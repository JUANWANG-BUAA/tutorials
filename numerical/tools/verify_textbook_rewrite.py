#!/usr/bin/env python3
"""Check the new reading order and independently recompute rewritten examples.

This covers selected chapter-one claims, not the literary quality of the book.
"""
from __future__ import annotations

from decimal import Decimal, localcontext
from pathlib import Path
import re

import mpmath as mp
import sympy as sp

import verify_recovery as recovery

SRC = Path(__file__).resolve().parents[1] / 'src'


def check_reading_order() -> None:
    text = recovery.read('SUMMARY.md')
    entries = re.findall(r'^( *)- \[([^]]+)\]\(([^)]+)\)', text, re.M)
    paths = [path for _, _, path in entries]
    assert len(paths) == len(set(paths))
    chapters = ['ch01'] + [f'course/ch{n:02}' for n in range(2, 8)]
    positions = [paths.index(ch + '/overview.md') for ch in chapters]
    assert positions == sorted(positions)
    source_start = paths.index('lectures/crosswalk.md')
    for indent, title, path in entries:
        if path in [ch + '/overview.md' for ch in chapters]:
            assert not indent, (title, indent)
        if path.startswith('lectures/'):
            assert paths.index(path) >= source_start
        if re.match(r'(?:ch01|course/ch0[2-7])/sec', path):
            assert len(indent) == 2 and paths.index(path) < source_start
    assert '教材 ·' not in text and '课堂主线' not in text


def check_water_and_six_expressions() -> None:
    text = recovery.read('ch01/sec11.md')
    depth, temperature = [], []
    for label, target in [('深度', depth), ('水温', temperature)]:
        line = next(line for line in text.splitlines() if line.startswith('| ' + label))
        target.extend(mp.mpf(c.strip()) for c in line.strip('|').split('|')[1:])
    target_depth = int(re.search(r'T\((\d+)\)\\approx', text)[1])
    actual = temperature[0] + (temperature[1]-temperature[0])*(target_depth-depth[0])/(depth[1]-depth[0])
    line = next(line for line in text.splitlines() if line.startswith('$$T('))
    shown = re.findall(r'\\approx(\d+\.\d+)', line)[-1]
    recovery.close_to_printed(actual, shown)
    s = sp.Symbol('s')
    formulas = [(s-1)**6, (3-2*s)**3, 99-70*s,
                1/(s+1)**6, 1/(3+2*s)**3, 1/(99+70*s)]
    true = (mp.sqrt(2)-1)**6
    rows = [line.strip('|').split('|') for line in text.splitlines()
            if line.startswith('| $')]
    assert len(rows) == len(formulas)
    for formula, row in zip(formulas, rows):
        assert sp.simplify(formula.subs(s, sp.sqrt(2))-(sp.sqrt(2)-1)**6) == 0
        value = mp.mpf(str(sp.N(formula.subs(s, sp.Rational(14,10)), 80)))
        recovery.close_to_printed(value, row[1])
        recovery.close_to_printed(abs(value-true), row[2])
    for rel, column in [('ch01/exercises.md', 4), ('appendix/derivations.md', 4)]:
        page = recovery.read(rel)
        section = page[page.index('六个公式' if rel.startswith('ch01') else '### A.1.1'):]
        rows = [line.strip('|').split('|') for line in section.splitlines()
                if line.startswith('| $')][:6]
        assert len(rows) == 6
        for formula, row in zip(formulas, rows):
            value = mp.mpf(str(sp.N(formula.subs(s, sp.Rational(14,10)), 80)))
            recovery.close_to_printed(abs(value-true), row[column])
    # Their equality uses s^2=2; it is not an identity for arbitrary inputs.
    assert sp.simplify(formulas[0]-formulas[2]) != 0


def check_integral_error_bounds() -> None:
    text = recovery.read('ch01/sec12.md')
    assert r'0<I-\frac{26}{35}\le\frac1{216}' in text
    x = sp.Symbol('x')
    polynomial = 1-x*x+x**4/sp.factorial(2)-x**6/sp.factorial(3)
    partial = sp.integrate(polynomial, (x,0,1))
    assert partial == sp.Rational(26,35)
    bound = sp.integrate(x**8/sp.factorial(4), (x,0,1))
    assert bound == sp.Rational(1,216)
    integral = mp.quad(lambda z: mp.exp(-z*z), [0,1])
    assert 0 < integral-mp.mpf(26)/35 < mp.mpf(1)/216
    assert r'R(a)=\frac34\int_a^\infty\frac{e^{-x^2}}{x^4}' in text
    assert r'\frac{3e^{-a^2}}{8a^5}' in text
    a = sp.Symbol('a', positive=True)
    approx = sp.exp(-a*a)*(1/(2*a)-1/(4*a**3))
    # Differentiate the claimed finite integration-by-parts identity.
    assert sp.simplify(sp.diff(approx,a)-sp.Rational(3,4)*sp.exp(-a*a)/a**4+sp.exp(-a*a)) == 0
    for a in map(mp.mpf, ['0.1','1','5','10']):
        exact = mp.sqrt(mp.pi)*mp.erfc(a)/2
        two_terms = mp.exp(-a*a)*(1/(2*a)-1/(4*a**3))
        remainder = exact-two_terms
        assert 0 < remainder <= 3*mp.exp(-a*a)/(8*a**5)
        independent = mp.quad(lambda z: 3*mp.exp(-z*z)/(4*z**4), [a,mp.inf])
        assert mp.almosteq(remainder,independent)


def check_strict_arithmetic_bounds() -> None:
    text = recovery.read('ch01/sec12.md')
    assert r'|b|(|b|-\varepsilon_b)' in text
    assert r'\varepsilon_a\varepsilon_b' in text
    for a,b,ea,eb in [(3,2,sp.Rational(1,100),sp.Rational(1,10)),
                      (-3,-2,sp.Rational(1,100),sp.Rational(1,10)),
                      (0,1,sp.Rational(1,3),sp.Rational(99,100)),
                      (1,sp.Rational(1,10**20),sp.Rational(1,100),sp.Rational(1,10**22))]:
        a,b,ea,eb = map(sp.Rational, (a,b,ea,eb))
        product_bound = abs(b)*ea+abs(a)*eb+ea*eb
        quotient_bound = (abs(b)*ea+abs(a)*eb)/(abs(b)*(abs(b)-eb))
        for dx in [-ea,0,ea]:
            for dy in [-eb,0,eb]:
                assert abs((a+dx)*(b+dy)-a*b) <= product_bound
                assert abs((a+dx)/(b+dy)-a/b) <= quotient_bound


def check_rounding_and_norm_order() -> None:
    text = recovery.read('ch01/sec12.md')
    assert r'2^{k+1-t}' in text
    with localcontext() as ctx:
        ctx.prec = 10
        product = Decimal('1.000002')**2
        assert product-Decimal('1.000004') == 0
    with localcontext() as ctx:
        ctx.prec = 50
        assert Decimal('1.000002')**2-Decimal('1.000004') == Decimal('4e-12')
    exact = mp.sqrt(1+mp.mpf('1e-16'))-1
    direct = (1+1e-16)**0.5-1
    rationalized = 1e-16/((1+1e-16)**0.5+1)
    assert direct == 0
    assert abs(mp.mpf(rationalized)-exact)/exact < mp.mpf('1e-15')
    text = recovery.read('ch01/sec13.md')
    vectors = [re.search(r'\\boldsymbol '+name+r'=\(([^)]+)\)',text)[1]
               for name in ['u','v']]
    u,v = [[mp.mpf(n) for n in vector.split(',')] for vector in vectors]
    assert sum(map(abs,u)) < sum(map(abs,v))
    assert max(map(abs,u)) > max(map(abs,v))
    assert r'\lvert\boldsymbol{x}\rvert^{\mathrm T}\boldsymbol{y}' in text
    # A mixed-sign vector catches replacing sum(abs(x_i)) by abs(sum(x_i)).
    x = [3,-5,1]
    assert sum(map(abs,x)) != abs(sum(x))
    assert sum(map(abs,x)) <= mp.sqrt(sum(n*n for n in x))*mp.sqrt(len(x))


def check_complete_linear_exercises() -> None:
    text = recovery.read('course/ch02/sec22.md')
    a = recovery.matrix_after(text, '{#exercise-2.5}')
    assert a*sp.ones(3,1) == sp.Matrix([6,9,9])
    lower = sp.Matrix([[1,0,0],[2,1,0],[3,-5,1]])
    upper = sp.Matrix([[1,2,3],[0,1,-4],[0,0,-24]])
    assert lower*upper == a
    assert lower*sp.Matrix([6,-3,-24]) == a*sp.ones(3,1)
    a = recovery.matrix_after(text, '{#exercise-2.6}')
    q = sp.Matrix([[0,1],[1,0]])
    assert q*a == sp.Matrix([[2,3],[0,1]])
    assert a*sp.ones(2,1) == sp.Matrix([1,5])
    a = recovery.matrix_after(text, '{#exercise-2.8}')
    x = sp.Matrix([sp.Rational(v) for v in ['.21','-.52','1.20','.82','-.64']])
    right = sp.Matrix([sp.Rational(v) for v in ['1.36','-3.49','4.50','2.72','-3.38']])
    assert a*x == right
    _,u,_ = a.LUdecomposition()
    assert list(u.diagonal()) == [4,sp.Rational(15,4),sp.Rational(56,15),
                                  sp.Rational(209,56),sp.Rational(780,209)]
    text = recovery.read('course/ch02/sec23.md')
    a = recovery.matrix_after(text, '{#exercise-2.9}')
    right = sp.Matrix([2,sp.Rational('2.0001')])
    assert a.inv().norm(sp.oo)*a.norm(sp.oo) == sp.Rational('40004.0001')
    assert a*sp.ones(2,1) == right
    assert a*sp.Matrix([0,2])-right == sp.Matrix([0,sp.Rational('0.0001')])
    exact = sp.ones(2,1)
    good = sp.Matrix([sp.Rational('1.0001'),1])
    bad = sp.Matrix([0,2])
    assert (a*good-right).norm(sp.oo) == (a*bad-right).norm(sp.oo)
    assert (good-exact).norm(sp.oo) < (bad-exact).norm(sp.oo)
    text = recovery.read('course/ch02/sec24.md')
    g = recovery.matrix_after(text,'{#exercise-2.14}')
    assert g.norm(sp.oo) == sp.Rational('1.4')
    assert all(abs(v.evalf()) < 1 for v in g.eigenvals())
    assert (sp.eye(2)-g).inv()*sp.Matrix([1,0]) == sp.Matrix([sp.Rational(20,13),sp.Rational(5,26)])


def check_cyclic_tridiagonal_reduction() -> None:
    text = recovery.read('course/ch02/sec22.md')
    assert r'T=A-\boldsymbol u\boldsymbol v^{\mathrm T}' in text
    # Non-symmetric corner entries catch swapping d_1 and e_1.
    a = sp.Matrix([[4,1,0,2],[-1,5,2,0],[0,-2,6,1],[3,0,-1,7]])
    gamma = -4
    u,v = sp.Matrix([gamma,0,0,3]),sp.Matrix([1,0,0,sp.Rational(2,gamma)])
    t = a-u*v.T
    assert all(t[i,j] == 0 for i in range(4) for j in range(4) if abs(i-j)>1)
    right = sp.Matrix([1,2,3,4])
    y,z = t.inv()*right,t.inv()*u
    x = y-z*((v.T*y)[0]/(1+(v.T*z)[0]))
    assert a*x == right


def check_new_nonlinear_tables() -> None:
    text = recovery.read('course/ch04/sec42.md')
    fixed = text[text.index('{#ex-4.2.1}'):text.index('## 4.2.3')]
    newton = text[text.index('{#ex-4.2.2}'):text.index('## 4.2.4')]
    x=y=mp.mpf(0)
    for line in fixed.splitlines():
        if not re.match(r'\| \d+ \|',line): continue
        cells=line.strip('|').split('|')
        recovery.close_to_printed(x,cells[1])
        recovery.close_to_printed(y,cells[2])
        x,y=mp.cos(y)/2,mp.sin(x)/2
    x=y=mp.mpf(0)
    for line in newton.splitlines():
        if not re.match(r'\| \d+ \|',line): continue
        cells=line.strip('|').split('|')
        recovery.close_to_printed(x,cells[1])
        recovery.close_to_printed(y,cells[2])
        residual=mp.matrix([x-mp.cos(y)/2,y-mp.sin(x)/2])
        if r'\lt' in cells[3]:
            assert mp.norm(residual,mp.inf) < mp.mpf('1e-14')
        else:
            recovery.close_to_printed(mp.norm(residual,mp.inf),cells[3])
        jacobian=mp.matrix([[1,mp.sin(y)/2],[-mp.cos(x)/2,1]])
        correction=mp.lu_solve(jacobian,-residual)
        x,y=x+correction[0],y+correction[1]
    x=y=mp.mpf(0)
    for count in range(1,100):
        new_x,new_y=mp.cos(y)/2,mp.sin(x)/2
        difference=max(abs(new_x-x),abs(new_y-y))
        x,y=new_x,new_y
        if difference <= mp.mpf('1e-6'): break
    assert count == 10 and '更新 10 次' in text
    exact=mp.findroot(lambda x,y:(x-mp.cos(y)/2,y-mp.sin(x)/2),(.49,.23))
    printed=re.search(r'解约为\s*\$\(([^,]+),([^\)]+)\)',fixed)
    assert printed
    for value,shown in zip(exact,printed.groups()):recovery.close_to_printed(value,shown)


def check_new_approximation_and_ode_exercises() -> None:
    x,h=sp.symbols('x h',real=True)
    text=recovery.read('course/ch05/exercises.md')
    assert r'H(x)=3x^2-2x^3' in text
    p=3*x*x-2*x**3
    assert [p.subs(x,0),sp.diff(p,x).subs(x,0),p.subs(x,1),sp.diff(p,x).subs(x,1)] == [0,0,1,0]
    assert sp.integrate((x*x-sp.Rational(1,3))**2,(x,-1,1)) == sp.Rational(8,45)
    a=sp.Matrix([[1,0],[1,1],[1,2]])
    c=(a.T*a).inv()*a.T*sp.Matrix([1,2,2])
    r=sp.Matrix([1,2,2])-a*c
    assert c == sp.Matrix([sp.Rational(7,6),sp.Rational(1,2)])
    assert a.T*r == sp.zeros(2,1) and (r.T*r)[0] == sp.Rational(1,6)
    assert r'\frac8{45}' in text
    text=recovery.read('course/ch06/exercises.md')
    assert 'm=41' in text
    assert sp.Rational(1,6*41**2) <= sp.Rational(1,10000) < sp.Rational(1,6*40**2)
    assert sp.integrate(x**4,(x,-1,1)) != 2*(1/sp.sqrt(3))**4
    text=recovery.read('course/ch07/exercises.md')
    formula=1-h+h*h/2-h**3/6+h**4/24
    assert formula.subs(h,sp.Rational(1,10)) == sp.Rational('0.9048375')
    assert sp.series(sp.log(1-h)/h,h,0,3) == -1-h/2-h*h/3+sp.Order(h**3)
    rho,sigma=(x-1)**2,x-1
    assert rho.subs(x,1) == 0 and sp.diff(rho,x).subs(x,1) == sigma.subs(x,1)
    assert sp.diff(rho,x).subs(x,1) == 0  # Repeated unit root violates zero stability.


def check_spline_boundary_conditions() -> None:
    text = recovery.read('course/ch05/sec53.md')
    assert "S'(a)=f'(a)" in text and 'f\in C^4[a,b]' in text
    assert 'f\'\'(a)=f\'\'(b)=0' in text and '分划比有界' in text

    def first_midpoint(n: int, clamped: bool) -> mp.mpf:
        step = mp.mpf(1)/n
        a, right = mp.matrix(n+1), mp.matrix(n+1,1)
        for i in range(1,n):
            a[i,i-1],a[i,i],a[i,i+1] = 1,4,1
            right[i] = 12  # f(x)=x^2 has exact second derivative 2.
        if clamped:
            a[0,0],a[0,1],right[0] = 2,1,6
            a[n,n-1],a[n,n],right[n] = 1,2,6
        else:
            a[0,0],a[n,n] = 1,1
        second = mp.lu_solve(a,right)
        value = ((second[0]+second[1])*step**2/48
                 +(0-second[0]*step**2/6)/2
                 +(step**2-second[1]*step**2/6)/2)
        return value-(step/2)**2

    for n in (4,8,16):
        assert abs(first_midpoint(n,True)) < mp.mpf('1e-70')
    errors = [abs(first_midpoint(n,False)) for n in (8,16)]
    # Natural end conditions incompatible with f''=2 give O(h^2), not O(h^4),
    # at a point approaching the endpoint.
    assert mp.mpf('3.99') < errors[0]/errors[1] < mp.mpf('4.01')


def check_source_quadrature_corrections() -> None:
    text = recovery.read('course/ch06/source-exercises.md')
    row14 = next(line for line in text.splitlines() if line.startswith('| 14 |'))
    assert '**(2)、(3)**' in row14
    row16 = next(line for line in text.splitlines() if line.startswith('| 16 |'))
    nodes,weights = mp.gauss_quadrature(4,'laguerre')
    value = sum(weights[i]*mp.exp(nodes[i])/(1+nodes[i]**2) for i in range(4))
    shown = re.search(r'四点近似为 \$([0-9.]+)\$', row16)
    assert shown
    recovery.close_to_printed(value,shown.group(1))
    row18 = next(line for line in text.splitlines() if line.startswith('| 18 |'))
    nodes = [mp.cos((2*k-1)*mp.pi/8) for k in range(1,5)]
    value = mp.pi/4*sum(abs(t) for t in nodes)
    shown = re.search(r'approx([0-9.]+)',row18)
    assert shown
    recovery.close_to_printed(value,shown.group(1))
    coefficients = re.search(r'a_0=([0-9.]+),.*a_1=([0-9.]+),.*a_2=([0-9.]+)',row18)
    assert coefficients
    for j,shown in enumerate(coefficients.groups()):
        value = mp.pi/4*sum(mp.exp(t)*mp.chebyt(j,t) for t in nodes)
        recovery.close_to_printed(value,shown)


if __name__ == '__main__':
    mp.mp.dps = 80
    checks = [check_reading_order, check_water_and_six_expressions,
              check_integral_error_bounds, check_strict_arithmetic_bounds,
              check_rounding_and_norm_order, check_complete_linear_exercises,
              check_cyclic_tridiagonal_reduction, check_new_nonlinear_tables,
              check_new_approximation_and_ode_exercises, check_spline_boundary_conditions,
              check_source_quadrature_corrections]
    for check in checks:
        check()
        print('PASS',check.__name__)
    print(f'Textbook rewrite checks passed: {len(checks)} groups, {recovery.checked_values} published values.')
