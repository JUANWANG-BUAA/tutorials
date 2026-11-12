#!/usr/bin/env python3
"""Check the current text's spectral, multiple-root and sampled-integral examples."""
import re

import mpmath as mp
import sympy as sp

import verify_recovery as r
from verify_slide_examples import part

mp.mp.dps = 70


def check_disks():
    text = part('course/ch03/sec31.md', 'ex-3.0.2')
    a = r.matrix_after(text, 'A=')
    d = sp.diag(1, 1, sp.Rational(10, 9))
    scaled = d.inv()*a*d
    assert scaled == sp.Matrix([[4, 1, 0], [1, 0, -sp.Rational(10, 9)],
                                [sp.Rational(9, 10), sp.Rational(9, 10), -4]])
    radii = [sum(abs(scaled[i, j]) for j in range(3) if i != j) for i in range(3)]
    assert radii == [1, sp.Rational(19, 9), sp.Rational(9, 5)]
    for i in range(3):
        for j in range(i):
            assert abs(scaled[i, i]-scaled[j, j]) > radii[i]+radii[j]
    shown = re.findall(r'-?\d\.\d{4}', text)
    eigenvalues = sorted(a.charpoly().nroots(n=60), key=lambda z: float(sp.re(z)), reverse=True)
    for value, printed in zip(eigenvalues, shown):
        assert abs(sp.im(value)) < sp.Rational(1, 10**50)
        r.close_to_printed(sp.re(value), printed)
    # Diagonal dominance does not imply a small absolute radius or a real spectrum.
    counterexample = sp.Matrix([[1000, -999], [999, 1000]])
    assert all(abs(counterexample[i, i]) > sum(abs(counterexample[i, j])
               for j in range(2) if i != j) for i in range(2))
    assert set(counterexample.eigenvals()) == {1000-999*sp.I, 1000+999*sp.I}
    assert '共轭根' in text and '按所在圆盘编号' in text


def check_power_variants():
    text = r.section('course/ch03/sec31.md', '{#power-infinity-normalization}',
                     '### 同一个主特征值')
    assert r'\operatorname{diag}(-2,1)' in text
    a = sp.diag(-2, 1)
    u = sp.ones(2, 1)
    for step in range(10):
        pivot = max(range(2), key=lambda i: abs(u[i]))
        y = u/u[pivot]
        u = a*y
        assert y[pivot] == 1 and u[pivot]/y[pivot] == -2
        if step == 1:
            assert y == sp.Matrix([1, -sp.Rational(1, 2)])
            assert u == sp.Matrix([-2, -sp.Rational(1, 2)])
    repeated = r.section('course/ch03/sec31.md', '{#power-repeated-dominant}',
                         '### 主特征值等模时')
    assert r'\operatorname{diag}(3,3,1)' in repeated
    v = sp.Matrix([1, 2, 0])
    assert sp.diag(3, 3, 1)*v == 3*v
    u = sp.Matrix([1, 2, 1])
    assert sp.diag(3, 3, 1)**10*u/3**10 == v+sp.Matrix([0, 0, sp.Rational(1, 3**10)])
    text = part('course/ch03/sec31.md', 'ex-power-conjugate-pair')
    a = r.matrix_after(text, 'A=')
    u0 = sp.Matrix([1, 0]); u1 = a*u0; u2 = a*u1
    assert u1 == sp.Matrix([1, 2]) and u2 == sp.Matrix([-3, 4])
    p, q = (sp.Matrix.hstack(u1, u0)).inv()*(-u2)
    assert (p, q) == (-2, 5)
    for lam in [1+2*sp.I, 1-2*sp.I]:
        z = u1-sp.conjugate(lam)*u0
        assert (a*z-lam*z).applyfunc(sp.simplify) == sp.zeros(2, 1)
    assert r'z_\lambda=u_{k+1}-\bar\lambda u_k' in text
    # The +/-r combinations select the correct, rather than swapped, directions.
    a = sp.diag(3, -3); u = sp.Matrix([1, 2]); w = a*u
    assert a*(w+3*u) == 3*(w+3*u)
    assert a*(w-3*u) == -3*(w-3*u)


def check_multiple_newton():
    text = part('course/ch04/sec41b.md', 'newton-multiple-comparison')
    table = r.numeric_rows(text)
    assert len(table) == 4
    e = sp.Symbol('e'); f = e**2*sp.exp(e+1)
    f1 = sp.diff(f, e); f2 = sp.diff(f1, e)
    maps = [sp.simplify(e-f/f1), sp.simplify(e-2*f/f1),
            sp.simplify(e-f*f1/(f1**2-f*f2))]
    expected = [e*(1+e)/(2+e), e**2/(2+e), -e**2/2]
    assert all(sp.simplify(a-b) == 0 for a, b in zip(maps, expected))
    funcs = [sp.lambdify(e, mapping, 'mpmath') for mapping in maps]
    values = [mp.mpf('.01')]*3
    for k, row in enumerate(table):
        assert int(row[0]) == k
        for j in range(3):
            r.close_to_printed(values[j], row[j+1])
            values[j] = funcs[j](values[j])
    counts = []
    for func in funcs:
        value = mp.mpf('.01'); k = 0
        while abs(value) > mp.mpf('1e-10'):
            value = func(value); k += 1
            assert k < 100
        counts.append(k)
    assert counts == [27, 3, 3]
    assert '27 次更新' in text and '只需 3 次' in text
    # Check error constants for a family of smooth, nonconstant g, not only m=2.
    for m in range(2, 6):
        g = 2+3*e+e**2; f = e**m*g; fp = sp.diff(f, e)
        known = e-m*f/fp
        unknown = e-f*fp/(fp**2-f*sp.diff(fp, e))
        assert sp.limit(known/e**2, e, 0) == sp.Rational(3, 2*m)
        assert sp.limit(unknown/e**2, e, 0) == -sp.Rational(3, 2*m)


def check_secant_identity():
    text = r.section('course/ch04/sec41b.md', '{#thm-4.8}',
                     '::: intuition 为什么割线法')
    assert r'\bigl(C+o(1)\bigr)e_ke_{k-1}' in text
    assert r'f[x_{k-1},x_k,s]' in text
    x, y, s, t = sp.symbols('x y s t')
    # The identity is exact for distinct points; only its asymptotic reduction uses C^2.
    for f in [(t-s)*(t**2+2), t**4-s**4]:
        fx, fy, fs = [f.subs(t, z) for z in [x, y, s]]
        first = (fx-fy)/(x-y)
        second = ((fs-fx)/(s-x)-first)/(s-y)
        next_error = x-fx/first-s
        assert sp.cancel(next_error-second/first*(x-s)*(y-s)) == 0
    # f=x^2-2 has C=1/(2 sqrt(2)); verify both order and constant numerically.
    root = mp.sqrt(2); c = 1/(2*root)
    # Stable error recurrence avoids subtracting nearly identical approximations.
    previous = mp.mpf('.01'); current = mp.mpf('.005')
    phi = (1+mp.sqrt(5))/2
    ratios = []
    for _ in range(16):
        following = current*previous/(2*root+current+previous)
        ratios.append(following/current**phi)
        previous, current = current, following
    assert abs(ratios[-1]-c**(1/phi)) < mp.mpf('.001')


def check_sampled_integral():
    text = part('course/ch06/sec61.md', 'slide-tabulated-quadrature')
    table = [line for line in text.splitlines() if line.startswith('|')]
    nodes = [sp.Rational(v.strip()) for v in table[0].strip('|').split('|')[1:]]
    values = [sp.Rational(v.strip()) for v in table[2].strip('|').split('|')[1:]]
    assert nodes == list(range(1, 6))
    assert values == list(map(sp.Rational, ['4', '4.5', '6', '8', '8.5']))
    t = sp.Symbol('t')
    polynomial = sp.interpolate(list(zip(nodes, values)), t)
    integral = sp.integrate(polynomial, (t, 1, 5))
    cotes = 2*sum(w*v for w, v in zip([7, 32, 12, 32, 7], values))/45
    trap = sum(w*v for w, v in zip([1, 2, 2, 2, 1], values))/2
    simpson = sum(w*v for w, v in zip([1, 4, 2, 4, 1], values))/3
    assert integral == cotes == sp.Rational(373, 15)
    assert trap == sp.Rational('24.75') and simpson == sp.Rational(149, 6)
    for value, shown in zip([cotes, simpson], re.findall(r'\\approx([\d.]+)', text)):
        r.close_to_printed(value, shown)
    # Same samples can correspond to arbitrarily different integrals.
    kernel = sp.prod(t-x for x in nodes)**2
    assert all(kernel.subs(t, x) == 0 for x in nodes)
    assert sp.integrate(kernel, (t, 1, 5)) > 0
    all_text = r.read('course/ch06/sec61.md')
    coefficients = re.search(r'\| 8 \|.*?\\left\((.*?)\\right\)', all_text)[1]
    numerators = [sp.Integer(v.strip().replace('\\ ', '')) for v in coefficients.split(',')]
    assert len([v for v in numerators if v < 0]) == 3
    assert sum(numerators) == 28350 and sum(abs(v) for v in numerators) > 28350
    assert '三个负系数' in all_text


def check_closed_quadrature_formulas():
    from sympy.parsing.sympy_parser import (parse_expr, standard_transformations,
                                           implicit_multiplication_application)

    a, b, x = sp.symbols('a b x', real=True)
    f = sp.Function('f')
    transforms = standard_transformations+(implicit_multiplication_application,)
    for start, end, degree, denominator in [
        ('<a id="sec-6.3.3">', '<a id="sec-6.3.4">', 3, 6480),
        ('<a id="sec-6.3.4">', '::: ex 例 6.3.1', 5, 1935360),
    ]:
        text = r.section('course/ch06/sec61.md', start, end)
        formula = text.split('$$', 2)[1].split(r'\approx', 1)[1].strip().rstrip('.')
        formula = re.sub(r'\\frac\{([^{}]+)\}\{([^{}]+)\}',
                         lambda m: '(('+m[1]+')/('+m[2]+'))', formula)
        formula = formula.replace(r'\left', '').replace(r'\right', '')
        formula = formula.replace('[', '(').replace(']', ')')
        expression = parse_expr(formula, local_dict={'a': a, 'b': b, 'f': f},
                                transformations=transforms)
        nodes = [term.args[0] for term in expression.atoms(sp.Function)]
        expected = [a+(b-a)*sp.Rational(i, degree if degree == 3 else 4)
                    for i in range(4 if degree == 3 else 5)]
        assert {sp.expand(z) for z in nodes} == {sp.expand(z) for z in expected}
        for k in range(degree+2):
            estimate = expression.replace(lambda z: z.func == f, lambda z: z.args[0]**k)
            error = sp.factor(sp.integrate(x**k, (x, a, b))-estimate)
            if k <= degree:
                assert error == 0, (start, k, error)
            else:
                expected_error = -(b-a)**(k+1)*sp.factorial(k)/denominator
                assert sp.simplify(error-expected_error) == 0, (start, error)
        assert f'{{{denominator}}}' in text


if __name__ == '__main__':
    for check in [check_disks, check_power_variants, check_multiple_newton,
                  check_secant_identity, check_sampled_integral, check_closed_quadrature_formulas]:
        check()
        print('PASS:', check.__name__)
    print(f'PASS: spectral/root/source examples; {r.checked_values} printed values recomputed')
