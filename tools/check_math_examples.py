"""Recompute published iteration tables; exact rationals first, then 60-digit rounding."""
from pathlib import Path
import re
import sympy as sp
import mpmath as mp

ROOT = Path(__file__).resolve().parents[1]
mp.mp.dps = 60
checked = 0


def rows_after(text: str, marker: str) -> list[list[str]]:
    section = text[text.index(marker):]
    start = section.index('| $k$')
    table = section[start:].split('\n\n', 1)[0]
    return [[cell.strip() for cell in line.split('|')[1:-1]]
            for line in table.splitlines() if re.match(r'\| \d+ \|', line)]


def verify(actual: object, published: str) -> None:
    global checked
    assert abs(mp.mpf(str(actual)) - mp.mpf(published)) <= mp.mpf('0.00000050001'), (actual, published)
    checked += 1


text = (ROOT / 'numerical/src/course/ch02/sec25.md').read_text()
A = sp.Matrix([[10, -2, -2], [-2, 10, -1], [-1, -2, 3]])
b = sp.Matrix([1, sp.Rational(1, 2), 1])
assert A * sp.Matrix([sp.Rational(55, 238), sp.Rational(5, 34), sp.Rational(121, 238)]) == b
D = sp.diag(*A.diagonal())
L = sp.Matrix(3, 3, lambda i, j: A[i, j] if i > j else 0)
for marker, N, stop in [('**例 6', D, 16), ('**例 9', D + L, 9)]:
    published = {int(row[0]): row[1:] for row in rows_after(text, marker)}
    x = sp.zeros(3, 1)
    first_stop = None
    for k in range(max(published) + 1):
        if k in published:
            for value, display in zip(x, published[k]):
                verify(str(value.evalf(65)), display)
        next_x = x + N.inv() * (b - A * x)
        if first_stop is None and max(abs(v) for v in next_x - x) <= sp.Rational(1, 100000):
            first_stop = k + 1
        x = next_x
    assert first_stop == stop, (marker, first_stop)
    print(f'{marker}: exact rational stopping step {stop}')

text = (ROOT / 'numerical/src/course/ch03/sec31.md').read_text()
A = mp.matrix([[6, -12, 6], [-21, -3, 24], [-12, -12, 51]])
assert sp.Matrix([[6, -12, 6], [-21, -3, 24], [-12, -12, 51]]).charpoly().as_expr().expand() == sp.Symbol('lambda')**3 - 54*sp.Symbol('lambda')**2 + 243*sp.Symbol('lambda') + 7290
for marker, operator, initial in [('**例 1', A, [1, 0, 0]), ('**例 2', A**-1, [1, 1, 1])]:
    published = {int(row[0]): row[1:] for row in rows_after(text, marker)}
    u = mp.matrix(initial)
    y = u / mp.norm(u)
    beta = None
    for k in range(max(published) + 1):
        if k in published:
            row = published[k]
            for vector, display in [(u, row[0]), (y, row[1])]:
                for value, cell in zip(vector, display.split(',')):
                    verify(value, cell.strip())
            if beta is not None:
                verify(beta, row[2])
        u = operator * y
        beta = (y.T * u)[0]
        y = u / mp.norm(u)
    print(f'{marker}: 60-digit power iteration table verified')
print(f'Mathematical examples passed: {checked} published values checked.')

# Nonlinear examples: residuals must match the unrounded iterates, not displayed decimals.
text = (ROOT / 'numerical/src/course/ch04/sec42.md').read_text()
f = lambda x: x**3 - x - 1
for marker, fixed in [('**例 4', False), ('**例 5', True)]:
    published = rows_after(text, marker)
    previous, x = mp.mpf(1), mp.mpf(2)
    for row in published:
        assert abs(x - mp.mpf(row[1])) <= mp.mpf('0.000000000050001'), (marker, row)
        checked += 1
        residual = mp.mpf(row[2].strip('$'))
        assert abs(abs(f(x)) - residual) <= abs(residual) * mp.mpf('0.00051'), (marker, row)
        checked += 1
        next_x = x - f(x) * (x - previous) / (f(x) - f(previous))
        if not fixed:
            previous = x
        x = next_x
print(f'Including nonlinear tables: {checked} published values checked.')

# Independent exact symbolic checks tie the counterexamples to their full maps.
x = sp.symbols('x', positive=True)
phi = x + x**2
phi_phi = phi + phi**2
steffensen = sp.cancel(x - (phi - x)**2 / (phi_phi - 2*phi + x))
assert sp.cancel(steffensen - x*(1+x)/(2+x)) == 0
assert sp.limit(steffensen/x, x, 0, dir='+') == sp.Rational(1, 2)
fourth = sp.cancel(x - (x+x**4)/(1+4*x**3))
assert sp.limit(fourth/x**4, x, 0, dir='+') == 3
assert sp.limit(fourth/x**3, x, 0, dir='+') == 0
chord = sp.cancel(x - (x**3-1)*x/x**3)
assert chord == x**-2
assert sp.diff(chord, x).subs(x, 1) == -2
Q = sp.diag(-1, 1)
for sign in [1, -1]:
    A = sp.Matrix([[-1, sign], [0, 2]])
    R = sp.Matrix([[1, -sign], [0, 2]])
    assert Q.T*Q == sp.eye(2) and Q*R == A
    assert R*Q == sp.Matrix([[-1, -sign], [0, 2]])
P = sp.Matrix([[1, 1], [0, 1]])
A = sp.Matrix([[1, 1], [0, 2]])
assert A*P == P*sp.diag(1, 2) and P.det() != 0
assert A.T*A != A*A.T
print('Exact symbolic counterexample maps and limiting factors passed.')
