#!/usr/bin/env python3
"""Recompute examples corrected in the final prose and consistency review.

Inputs and displayed values are read from current Markdown. These checks cover
selected examples, not every theorem or every application claim in the book.
"""
from __future__ import annotations

import ast
import re

import mpmath as mp
import sympy as sp

import verify_recovery as recovery


def python_blocks(rel: str) -> list[str]:
    return re.findall(r'```python\n(.*?)\n```', recovery.read(rel), re.S)


def check_arcsin_coefficients() -> None:
    text = recovery.section('course/ch05/sec55.md', '{#ex-5.6.9}', '\n::: think')
    assert 'c_0=0' in text
    assert r'\arcsin x=\frac4\pi\sum_' in text
    theta = sp.Symbol('theta', real=True)
    for k in range(8):
        coefficient = sp.integrate(2/sp.pi*(sp.pi/2-theta)*sp.cos(k*theta), (theta, 0, sp.pi))
        expected = 4/(sp.pi*k*k) if k % 2 else 0
        assert sp.simplify(coefficient-expected) == 0
    x = sp.Symbol('x')
    polynomial = 4/sp.pi*(x+(4*x**3-3*x)/9+(16*x**5-20*x**3+5*x)/25
                         +(64*x**7-112*x**5+56*x**3-7*x)/49)
    assert sp.expand(polynomial-4/sp.pi*sum(sp.chebyshevt(k,x)/k**2 for k in [1,3,5,7])) == 0
    assert polynomial.subs(x,0) == 0


def check_gps_budget() -> None:
    text = recovery.read('ch01/application.md')
    tree = ast.parse(python_blocks('ch01/application.md')[0])
    cases = [ast.literal_eval(node.value.args[0]) for node in tree.body
             if isinstance(node, ast.Expr) and isinstance(node.value, ast.Call)
             and isinstance(node.value.func, ast.Name) and node.value.func.id == 'report']
    rows = [line for line in text.splitlines() if line.startswith(('| 好几何 |','| 差几何 |'))]
    assert len(cases) == len(rows) == 2
    for pairs, row in zip(cases, rows):
        directions = []
        for azimuth, elevation in pairs:
            a,e = mp.radians(azimuth), mp.radians(elevation)
            directions.append([-mp.cos(e)*mp.sin(a),-mp.cos(e)*mp.cos(a),-mp.sin(e),1])
        g = mp.matrix(directions)
        q = (g.T*g)**-1
        gdop = mp.sqrt(sum(q[i,i] for i in range(4)))
        pdop = mp.sqrt(sum(q[i,i] for i in range(3)))
        values = [pdop, gdop, 5*pdop, 5*gdop]
        cells = row.strip('|').split('|')[1:]
        for actual,cell in zip(values,cells):
            recovery.close_to_printed(actual, cell)
        singular_squared = mp.eigsy(g.T*g,eigvals_only=True)
        condition = mp.sqrt(max(singular_squared)/min(singular_squared))
        output = next(line for line in text.splitlines() if 'cond2(G)=' in line
                      and line.startswith('好几何:' if pairs == cases[0] else '差几何（聚顶）:'))
        displays = re.findall(r'=\s*(\d+\.\d+)', output)
        for actual,display in zip([condition,gdop,pdop],displays):
            recovery.close_to_printed(actual,display)
        assert abs(gdop**2-pdop**2-q[3,3]) < mp.mpf('1e-60')


def check_ode_error_models() -> None:
    text = recovery.read('course/ch07/sec74.md')
    assert r'\frac{C_Ru}{pC_T}' in text and r'1/(p+1)' in text
    assert r'y(t_{n+1})-y_{n+1,h/2}\approx' in text
    h,u,ct,cr = sp.symbols('h u ct cr', positive=True)
    for p in [1,4]:
        error = ct*h**p+cr*u/h
        optimum = (cr*u/(p*ct))**sp.Rational(1,p+1)
        assert sp.simplify(sp.diff(error,h).subs(h,optimum)) == 0
        assert sp.simplify(sp.diff(error,h,2).subs(h,optimum)).is_positive
        exact,c = sp.symbols('exact c')
        coarse = exact-c*h**p
        fine = exact-c*(h/2)**p
        assert sp.simplify((fine-coarse)/(2**p-1)-(exact-fine)) == 0


def check_convergence_bounds() -> None:
    text = recovery.read('appendix/connections.md')
    line = next(line for line in text.splitlines() if '三个几何底数' in line)
    displays = re.findall(r'\$(0\.\d+)\$',line)
    kappa = mp.mpf(10000)
    for actual,display in zip([1-1/kappa,(kappa-1)/(kappa+1),
                              (mp.sqrt(kappa)-1)/(mp.sqrt(kappa)+1)],displays):
        recovery.close_to_printed(actual,display)
    assert len(displays) == 4  # includes squared steepest-descent factor
    recovery.close_to_printed(((kappa-1)/(kappa+1))**2,displays[3])
    # Zero is an allowed secondary PageRank eigenvalue.
    s = sp.ones(3)/3
    g = sp.Rational(85,100)*s+sp.Rational(15,100)*sp.ones(3)/3
    assert set(g.eigenvals()) == {0,1}
    y = sp.Matrix([1,-1,0])
    assert g*y == sp.zeros(3,1) and sum(y) == 0


def check_gershgorin_and_power() -> None:
    text = recovery.section('supplement/mock-exam.md','**14.** 对','**15.**')
    a = recovery.matrix_after(text,'$$A=')
    for matrix,expected in [(a,[(9,3),(4,1),(3,1)]),(a.T,[(9,1),(4,1),(3,3)])]:
        disks = [(matrix[i,i],sum(abs(matrix[i,j]) for j in range(3) if j != i)) for i in range(3)]
        assert disks == expected
        for c,r in disks:
            assert f'D({c},{r})' in text
    t = sp.Symbol('t')
    poly = a.charpoly(t).as_expr()
    assert poly == t**3-16*t**2+73*t-101
    for left,right in [(2,3),(3,4),(9,10)]:
        assert poly.subs(t,left)*poly.subs(t,right) < 0
    eigenvalues = sorted(mp.polyroots([int(v) for v in sp.Poly(poly,t).all_coeffs()],maxsteps=100))
    displays = re.search(r'特征值约为 \$(.*?)\$',text)[1].split(',')
    for actual,display in zip(eigenvalues,displays):
        recovery.close_to_printed(actual,display)
    block = python_blocks('supplement/sec27.md')[-1]
    tree = ast.parse(block)
    matrices = [ast.literal_eval(node.value.args[0]) for node in tree.body
                if isinstance(node,ast.Assign) and isinstance(node.value,ast.Call)
                and isinstance(node.value.func,ast.Attribute) and node.value.func.attr == 'array'
                and any(isinstance(target,ast.Name) and target.id == 'A' for target in node.targets)]
    symmetric,non_symmetric = map(mp.matrix,matrices)
    eig = sorted(mp.eigsy(symmetric,eigvals_only=True),reverse=True)
    recovery.close_to_printed((eig[1]/eig[0])**2,'0.2717')
    x = mp.matrix([1,1,1]); x /= mp.norm(x)
    errors = []
    for _ in range(30):
        y = symmetric*x; x=y/mp.norm(y)
        errors.append((abs((x.T*symmetric*x)[0]-eig[0]),abs(mp.norm(symmetric*x)-eig[0])))
    for j in [0,1]:
        assert abs(errors[-1][j]/errors[-2][j]-(eig[1]/eig[0])**2) < mp.mpf('1e-10')
    assert [sum(abs(non_symmetric[i,j]) for j in range(3) if j!=i) for i in range(3)] == [3,1,3]


def check_givens_work() -> None:
    # Six flops per updated column for each plane rotation, including pivot column.
    j,m,n = sp.symbols('j m n',integer=True,positive=True)
    work = sp.expand(sp.summation(6*(m-j)*(n-j+1),(j,1,n)))
    leading = 3*m*n**2-n**3
    assert sp.Poly(work-leading,m,n).total_degree() <= 2
    for rel in ['supplement/sec23.md','supplement/recall-cards.md','review/contrast-cards.md']:
        assert '3mn^2-n^3' in recovery.read(rel)


if __name__ == '__main__':
    checks = [check_arcsin_coefficients, check_gps_budget, check_ode_error_models,
              check_convergence_bounds, check_gershgorin_and_power, check_givens_work]
    for check in checks:
        check()
        print(f'PASS {check.__name__}')
    print(f'Editorial review checks passed: {len(checks)} groups, {recovery.checked_values} published values.')
