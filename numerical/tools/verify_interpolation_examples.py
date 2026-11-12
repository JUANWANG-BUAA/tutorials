#!/usr/bin/env python3
"""Recompute current interpolation formulas, including both spline coordinates."""
import re

import sympy as sp
from sympy.parsing.sympy_parser import (
    implicit_multiplication_application, parse_expr, standard_transformations,
)

import verify_recovery as r
from verify_slide_examples import part

X = sp.Symbol('x')
TRANSFORMS = standard_transformations + (implicit_multiplication_application,)


def polynomial(latex):
    """Parse the small rational-polynomial formulas used by these examples."""
    latex = latex.replace(r'\dfrac', r'\frac')
    latex = re.sub(r'\\(?:dfrac|frac)(\d)(\d)', r'\\frac{\1}{\2}', latex)
    # Innermost fractions first, so numerators may themselves contain fractions.
    while r'\frac' in latex:
        converted = re.sub(r'\\frac\{([^{}]*)\}\{([^{}]*)\}',
                           lambda m: '(('+m[1]+')/('+m[2]+'))', latex)
        assert converted != latex, latex
        latex = converted
    latex = latex.replace(r'\cdot', '*').replace(r'\,', '')
    latex = latex.replace('^', '**').replace('{', '(').replace('}', ')')
    return parse_expr(latex, local_dict={'x': X}, transformations=TRANSFORMS)


def data_array(text):
    array = re.search(r'\\begin\{array\}.*?\n(.*?)\\end\{array\}', text, re.S)[1]
    lines = [line for line in array.splitlines() if '&' in line]
    return [[sp.Rational(v.strip().rstrip('\\').strip())
             for v in line.split('&')[1:]] for line in lines]


def displayed_tuple(text, marker):
    values = text.split(marker, 1)[1].split(')', 1)[0]
    return [sp.Rational(v.strip().replace('\\', '')) for v in values.split(',')]


def check_basis_and_differences():
    text = r.section('course/ch05/sec51.md', 'id="interpolation-basis-independence"',
                     '::: thm 定理 · 插值多项式')
    matrix = r.matrix_after(text, 'A=')
    assert matrix == sp.Matrix([[1, 1], [1, 1]]) and matrix.det() == 0
    assert sp.Matrix([[1, z**2] for z in [-1, 0]]).det() != 0
    # Polynomial bases are unisolvent for every distinct set of sufficient size.
    for nodes in [[-1, 0, 1], [sp.Rational(1, 5), 2, 4, 7]]:
        v = sp.Matrix([[z**k for k in range(len(nodes))] for z in nodes])
        assert v.det() == sp.prod(nodes[j]-nodes[i]
                                 for j in range(len(nodes)) for i in range(j))
    # The text's x^3 example has a constant third difference, zero fourth difference.
    nodes = list(range(5)); values = [sp.Integer(z)**3 for z in nodes]
    for order in range(1, 5):
        values = [(values[j+1]-values[j])/(nodes[j+order]-nodes[j])
                  for j in range(len(values)-1)]
        if order == 3:
            assert values == [1, 1]
        if order == 4:
            assert values == [0]
    # Identical finite data do not prove the underlying function is a polynomial.
    other = X**3 + sp.prod(X-z for z in nodes)
    assert all(other.subs(X, z) == z**3 for z in nodes)
    assert sp.degree(other, X) == 5
    text = r.read('course/ch05/sec51.md')
    assert '每个差商都是一个数' in text and r'f\in C^k' in text


def check_hermite_correction():
    text = part('course/ch05/sec52.md', 'ex-5.2.3')
    nodes, values = data_array(text)
    p = polynomial(re.search(r'p_3\(x\)=(.*?)\.\n\$\$', text, re.S)[1])
    assert sp.expand(p-sp.interpolate(list(zip(nodes, values)), X)) == 0
    # Read the final formula, not a copied coefficient fixture.
    final = re.findall(r'H_5\(x\)=p_3\(x\)\+(.*?)\.\n\$\$', text, re.S)[-1]
    h = sp.expand(p+polynomial(final))
    assert sp.degree(h, X) <= 5
    assert all(h.subs(X, z) == y for z, y in zip(nodes, values))
    derivatives = [(sp.Rational(z), sp.Rational(value)) for z, value in
                   re.findall(r"H_5'\((-?\d+)\)=(\d+(?:\.\d+)?)", text)[:2]]
    assert len(derivatives) == 2
    assert all(sp.diff(h, X).subs(X, z) == value for z, value in derivatives)
    # Squaring the full node product would freeze all first derivatives.
    w = sp.prod(X-z for z in nodes)
    frozen = p+(2*X+3)*w**2
    assert all(sp.diff(frozen-p, X).subs(X, z) == 0 for z in nodes)
    assert any(sp.diff(frozen, X).subs(X, z) != value for z, value in derivatives)
    method = r.section('course/ch05/sec52.md', '**方法三', '::: note 另一种构造')
    assert r'H_N(x)=p_n(x)+q(x)\omega_{n+1}(x)' in method
    assert r'\omega_{n+1}(x)=\prod_{i=0}^n(x-x_i)' in method


def check_clamped_bspline_basis():
    text = part('course/ch05/sec53.md', 'bspline-constant-coefficients')
    knots = [0]*4+[1]*4

    def basis(i, degree):
        if degree == 0:
            # This interval is the only nonempty elementary span, 0 < x < 1.
            return sp.Integer(knots[i] == 0 and knots[i+1] == 1)
        value = 0
        left = knots[i+degree]-knots[i]
        right = knots[i+degree+1]-knots[i+1]
        if left:
            value += (X-knots[i])/left*basis(i, degree-1)
        if right:
            value += (knots[i+degree+1]-X)/right*basis(i+1, degree-1)
        return sp.expand(value)

    expressions = re.findall(r'N_\{\d,3\}=(.*?)(?:,\\quad|\.\n|,\n)', text)
    assert len(expressions) == 4, expressions
    bases = [polynomial(expr) for expr in expressions]
    assert all(sp.expand(value-basis(i, 3)) == 0 for i, value in enumerate(bases))
    coefficients = displayed_tuple(text, '(c_0,c_1,c_2,c_3)=(')
    spline = sp.expand(sum(c*b for c, b in zip(coefficients, bases)))
    assert spline == 1 and sp.diff(spline, X) == 0
    assert sum(bases).expand() == 1


def check_spline_coordinates():
    text = part('course/ch05/sec53.md', 'ex-5.3.4')
    nodes, values = data_array(text)
    first, last = [sp.Rational(v.rstrip('.')) for v in re.findall(r"f'\(\d\)=(\d+(?:\.\d+)?)", text)]
    a = r.matrix_after(text, r'\begin{pmatrix}')
    matrices = re.findall(r'\\begin\{pmatrix\}(.*?)\\end\{pmatrix\}', text, re.S)
    right = sp.Matrix([sp.Rational(v) for v in matrices[2].split(r'\\')])
    assert right == sp.Matrix([6*(values[1]-values[0]-first),
                               6*(values[2]-2*values[1]+values[0]),
                               6*(last-values[2]+values[1])])
    moments = a.inv()*right
    shown_moments = displayed_tuple(text, '(M_0,M_1,M_2)=(')
    assert len(shown_moments) == 3
    for actual, shown in zip(moments, shown_moments):
        r.close_to_printed(sp.N(actual, 70), str(shown.evalf(8)))
    pieces = []
    for i in range(2):
        lo, hi = nodes[i:i+2]; step = hi-lo
        p = (moments[i]*(hi-X)**3+moments[i+1]*(X-lo)**3)/(6*step)
        p += (values[i]-moments[i]*step**2/6)*(hi-X)/step
        p += (values[i+1]-moments[i+1]*step**2/6)*(X-lo)/step
        pieces.append(sp.expand(p))
        assert p.subs(X, lo) == values[i] and p.subs(X, hi) == values[i+1]
    assert sp.diff(pieces[0], X).subs(X, nodes[0]) == first
    assert sp.diff(pieces[1], X).subs(X, nodes[2]) == last
    for order in range(3):
        assert sp.diff(pieces[0]-pieces[1], X, order).subs(X, nodes[1]) == 0
    for point, shown in re.findall(r'S\((\d+(?:\.\d+)?)\)\\approx(\d+(?:\.\d+)?)', text):
        p = pieces[0 if sp.Rational(point) < nodes[1] else 1]
        r.close_to_printed(sp.N(p.subs(X, sp.Rational(point)), 70), shown)

    comparison = part('course/ch05/sec53.md', 'spline-basis-comparison')
    b = r.matrix_after(comparison, r'\begin{pmatrix}')
    matrices = re.findall(r'\\begin\{pmatrix\}(.*?)\\end\{pmatrix\}', comparison, re.S)
    right = sp.Matrix([sp.Rational(v) for v in matrices[2].split(r'\\')])
    assert right == sp.Matrix([6*values[0]+2*first, 6*values[1],
                               6*values[2]-2*last])
    center = b.inv()*right
    assert list(center) == displayed_tuple(comparison, '(c_1,c_2,c_3)=(')
    coefficients = [center[1]-2*first, *center, center[1]+2*last]
    assert coefficients[0] == sp.Rational(re.search(r'c_0=(\d+(?:\.\d+)?)', comparison)[1])
    assert coefficients[4] == sp.Rational(re.search(r'c_4=(\d+(?:\.\d+)?)', comparison)[1])
    # Read both polynomial branches of the displayed centered B-spline kernel.
    kernel = comparison.split(r'\begin{cases}', 1)[1].split(r'\end{cases}', 1)[0]
    inner, outer = [line.split('&', 1)[0].strip().rstrip(',')
                    for line in kernel.splitlines() if '&' in line][:2]
    inner = polynomial(inner.replace('|t|', 'x').replace('t', 'x'))
    outer = polynomial(outer.replace('|t|', 'x').replace('t', 'x'))
    for i, lo in enumerate(nodes[:-1]):
        mid = lo+sp.Rational(1, 2); result = 0
        for j, c in enumerate(coefficients):
            distance = abs(mid-j)
            if distance < 2:
                argument = (X-j) if mid >= j else (j-X)
                result += c*(inner if distance < 1 else outer).subs(X, argument)
        assert sp.expand(result-pieces[i]) == 0
    # Also compare the slope method's polynomial, not only its midpoint values.
    slopes = part('course/ch05/sec53.md', 'ex-5.3.5')
    middle = sp.Rational(re.search(r'm_1=(\d+(?:\.\d+)?)', slopes)[1])
    assert middle == sp.diff(pieces[0], X).subs(X, nodes[1])
    assert middle == (18-first-last)/4
    for point, shown in re.findall(r'S\((\d+(?:\.\d+)?)\)=(\d+(?:\.\d+)?)', slopes):
        p = pieces[0 if sp.Rational(point) < nodes[1] else 1]
        r.close_to_printed(sp.N(p.subs(X, sp.Rational(point)), 70), shown)


def check_tensor_and_conditions():
    text = part('course/ch05/sec51.md', 'ex-5.1.2')
    p = polynomial(re.findall(r'p\(x,y\)=(.*?)\.\n', text)[-1].replace('y', 'z'))
    z = sp.Symbol('z')
    for x, y, value in [(0, 0, 1), (1, 0, 2), (0, 1, 3), (1, 1, 5)]:
        assert p.subs({X: x, z: y}) == value
    assert sp.degree(p, X) == sp.degree(p, z) == 1
    assert '计算量与一维同阶' not in r.read('course/ch05/sec51.md')
    theorem = part('course/ch05/sec53.md', 'thm-5.4')
    assert 'y_0=y_n' in theorem
    definition = part('course/ch05/sec53.md', 'def-5.3.1')
    assert '次数不超过 $m$' in definition and 'C^{m-1}' in definition


if __name__ == '__main__':
    for check in [check_basis_and_differences, check_hermite_correction,
                  check_clamped_bspline_basis, check_spline_coordinates,
                  check_tensor_and_conditions]:
        check()
        print('PASS:', check.__name__)
    print(f'PASS: interpolation examples; {r.checked_values} printed values recomputed')
