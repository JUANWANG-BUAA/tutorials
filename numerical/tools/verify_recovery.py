#!/usr/bin/env python3
"""Check protected content, real homework tables and mathematical counterexamples.

Uses the same SymPy/mpmath dependencies as tools/check_math_examples.py.
The table checks read the current Markdown, rather than a copied output fixture.
"""

from __future__ import annotations

from decimal import Decimal, ROUND_HALF_UP, localcontext
import json
from pathlib import Path
import re

import mpmath as mp
import sympy as sp

import check_book

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
mp.mp.dps = 80
checked_values = 0


def read(rel: str) -> str:
    return (SRC / rel).read_text(encoding="utf-8")


def section(rel: str, start: str, end: str | None = None) -> str:
    text = read(rel)
    begin = text.index(start)
    return text[begin : text.index(end, begin) if end else len(text)]


def clean(cell: str) -> str:
    cell = cell.replace("$", "").replace("**", "")
    cell = re.sub(r"\\(?:mathbf|mathrm)\{([^{}]*)\}", r"\1", cell)
    cell = re.sub(r"\\times\s*10\^\{(-?\d+)\}", r"e\1", cell)
    return cell.strip()


def numeric_rows(text: str) -> list[list[str]]:
    rows = []
    for line in text.splitlines():
        if not line.startswith("|"):
            continue
        cells = [clean(cell) for cell in line.strip().strip("|").split("|")]
        if cells and cells[0].isdigit():
            rows.append(cells)
    return rows


def close_to_printed(actual: object, cell: str) -> None:
    """Allow half a unit in the last printed decimal, including scientific form."""
    global checked_values
    match = re.match(r"^([-+]?\d+(?:\.\d+)?)(?:e([-+]?\d+))?", clean(cell))
    if not match:
        raise AssertionError(f"Not a numeric display: {cell!r}")
    mantissa, exponent = match.group(1), int(match.group(2) or 0)
    decimals = len(mantissa.partition(".")[2])
    tolerance = mp.mpf("0.50001") * mp.power(10, exponent - decimals)
    expected = mp.mpf(match.group(0))
    error = abs(mp.mpf(str(actual)) - expected)
    assert error <= tolerance, (actual, cell, error, tolerance)
    checked_values += 1


def matrix_after(text: str, marker: str) -> sp.Matrix:
    tail = text[text.index(marker) :]
    match = re.search(r"\\begin\{pmatrix\}(.*?)\\end\{pmatrix\}", tail, re.S)
    assert match, marker
    rows = [
        [sp.Rational(cell.strip()) for cell in row.split("&")]
        for row in match.group(1).split(r"\\")
        if row.strip()
    ]
    return sp.Matrix(rows)


def check_content_inventory() -> None:
    contract = json.loads((ROOT / "tools/content_contract.json").read_text())
    mounted = {rel for _, rel in check_book.pages_from_summary()}
    missing = set(contract["required_pages"]) - mounted
    assert not missing, f"Recovered pages removed from SUMMARY: {sorted(missing)}"
    for rel, anchors in contract["required_anchors"].items():
        actual = check_book.page_id_set(rel, read(rel))
        assert set(anchors) <= actual, (rel, sorted(set(anchors) - actual))
    for rel, count in contract["homework_counts"].items():
        chapter = 1 if rel.startswith("ch01/") else int(rel.split("/")[1][-1])
        found = {
            int(number)
            for number in re.findall(rf"\{{#hw-{chapter}-(\d+)\}}", read(rel))
        }
        assert found == set(range(1, count + 1)), (rel, found)
    # These data identify the source questions that the faulty rewrite replaced.
    assert r"(A+6I)^{-1}" in read("course/ch03/exercises.md")
    assert matrix_after(read("course/ch03/exercises.md"), "{#hw-3-3}") == sp.Matrix(
        [[2, -1, 7, 11, -1], [3, 7, 3, 4, 1], [0, 0, 6, 8, 0],
         [0, 0, 0, 1, -4], [0, 0, 0, 2, 3]]
    )
    assert r"\varphi(x)=x+c(x^2-3)" in read("course/ch04/exercises.md")
    assert r"x=\tan x" in read("course/ch04/exercises.md")


def check_homework_recurrence() -> None:
    text = section("ch01/exercises.md", "{#sol-hw-1-4}")
    rows = numeric_rows(text[: text.index("**易错点")])
    with localcontext() as context:
        context.prec = 4
        context.rounding = ROUND_HALF_UP
        forward = [Decimal("0.6321")]
        for n in range(1, 21):
            forward.append(Decimal(1) - Decimal(n) * forward[-1])
        backward = [Decimal(0)] * 21
        for n in range(20, 0, -1):
            backward[n - 1] = (Decimal(1) - backward[n]) / Decimal(n)
    for row in rows:
        n = int(row[0])
        close_to_printed(forward[n], row[1])
        exact = mp.quad(lambda x: x**n * mp.exp(x - 1), [0, 1])
        close_to_printed(exact, row[2])
        close_to_printed(backward[n], row[3])
    assert len(rows) == 10, "The published recurrence experiment was removed"


def check_decimal_homework() -> None:
    text = section("course/ch02/exercises.md", "{#hw-2-2}", "{#hw-2-3}")
    a = matrix_after(text, "在四位十进制")
    right = sp.Matrix([1, 2, 3])
    exact = a.inv() * right
    for value, expected in zip(exact, ["-0.43758793", "-0.08172027", "0.38795938"]):
        close_to_printed(value.evalf(85), expected)
    with localcontext() as context:
        context.prec = 4
        context.rounding = ROUND_HALF_UP
        for pivot, expected in (
            (False, [Decimal("0"), Decimal("-0.09980"), Decimal("0.4000")]),
            (True, [Decimal("-0.4370"), Decimal("-0.08186"), Decimal("0.3882")]),
        ):
            system = [
                [Decimal(str(a[i, j].evalf(20))) for j in range(3)] + [Decimal(i + 1)]
                for i in range(3)
            ]
            for k in range(2):
                if pivot:
                    chosen = max(range(k, 3), key=lambda i: abs(system[i][k]))
                    system[k], system[chosen] = system[chosen], system[k]
                for i in range(k + 1, 3):
                    multiplier = system[i][k] / system[k][k]
                    for j in range(k + 1, 4):
                        system[i][j] -= multiplier * system[k][j]
                    system[i][k] = Decimal(0)
            solution = [Decimal(0)] * 3
            for i in range(2, -1, -1):
                value = system[i][3]
                for j in range(i + 1, 3):
                    value -= system[i][j] * solution[j]
                solution[i] = value / system[i][i]
            assert solution == expected, (pivot, solution)
            # Tie each output to the current answer, not just the calculation.
            assert all(str(value) in text for value in expected if value != 0)


def check_original_eigen_homework() -> None:
    text = read("course/ch03/exercises.md")
    matrix = matrix_after(text, "{#hw-3-3}")
    x = sp.Symbol("lambda")
    assert sp.expand(matrix.charpoly(x).as_expr()) == sp.expand(
        (x**2 - 9*x + 17) * (x - 6) * (x**2 - 4*x + 11)
    )
    assert r"2\pm2.6458\mathrm i" in text
    close_to_printed(sp.sqrt(7).evalf(85), "2.6458")
    # Exact spectral deflation must work for nonorthogonal eigenvectors too.
    vectors = sp.Matrix([[1, 1, 0], [0, 1, 1], [0, 0, 1]])
    diagonal = sp.diag(-4, 1, 3)
    a = vectors * diagonal * vectors.inv()
    projection = vectors[:, 0] * vectors.inv()[0, :]
    assert projection**2 == projection and a*projection == -4*projection
    b = 5*sp.eye(3) - a
    assert set((b - 9*projection).eigenvals()) == {0, 4, 2}
    c = (a + 5*sp.eye(3)).inv()
    assert set((c - projection).eigenvals()) == {0, sp.Rational(1, 6), sp.Rational(1, 8)}
    assert r"\sigma+\frac1{\mu_k}" in text


def check_original_nonlinear_tables() -> None:
    text = section("course/ch04/exercises.md", "{#hw-4-2}", "{#hw-4-3}")
    rows = numeric_rows(text[: text.index("**对照表**")])
    # First table has 0..5 and 33..35 (nine rows); split by the second zero row.
    split = next(i for i, row in enumerate(rows[1:], 1) if row[0] == "0")
    rows_by_method = [rows[:split], rows[split:]]
    for table, coefficient in zip(rows_by_method, [-mp.mpf("0.5"), -1/(2*mp.sqrt(3))]):
        values = [mp.mpf("1.5")]
        for _ in range(40):
            values.append(values[-1] + coefficient * (values[-1]**2 - 3))
        for row in table:
            k = int(row[0])
            close_to_printed(values[k], row[1])
            if k:
                close_to_printed(abs(values[k] - values[k-1]), row[2])
    assert len(rows_by_method[0]) == 9 and len(rows_by_method[1]) == 5
    text = section("course/ch04/exercises.md", "{#hw-4-4}", "{#hw-4-cover}")
    rows = numeric_rows(text)
    values = [mp.mpf("4.5")]
    for _ in range(4):
        value = values[-1]
        values.append(value - (mp.tan(value) - value) / mp.tan(value)**2)
    for row in rows:
        k = int(row[0])
        close_to_printed(values[k], row[1])
        close_to_printed(mp.tan(values[k]), row[2])
        if k:
            close_to_printed(abs((values[k] - values[k-1]) / values[k]), row[3])
    assert len(rows) == 5


def check_newton_and_chebyshev() -> None:
    e, a, b, c = sp.symbols("e a b c", nonzero=True)
    f = a*e + b*e**2/2 + c*e**3/6
    fp, fpp = sp.diff(f, e), sp.diff(f, e, 2)
    chebyshev = e - f/fp - fpp*f**2/(2*fp**3)
    coefficient = sp.expand(sp.series(chebyshev, e, 0, 4).removeO()).coeff(e, 3)
    assert sp.simplify(coefficient - (b**2/(2*a**2) - c/(6*a))) == 0
    text = section("course/ch04/exercises.md", "{#sol-hw-4-3}", "{#hw-4-4}")
    assert r"\frac{b^2}{2a^2}-\frac{c}{6a}" in text and "Chebyshev" in text
    x = sp.Symbol("x")
    f = x + x**3
    assert sp.cancel(x - f/sp.diff(f, x)) == 2*x**3/(1 + 3*x**2)
    # Initial-value conditions in all four monotonicity/curvature combinations.
    for f, initial in [(x*x-2, 2), (sp.log(x), sp.Rational(1,2)),
                       (2-x*x, 2), (-sp.log(x), sp.Rational(1,2))]:
        assert f.subs(x, initial)*sp.diff(f, x, 2).subs(x, initial) > 0
    text = read("course/ch04/mock-exam.md")
    assert r"\varphi_2(x)=(x+2/x)/2" in text
    f = lambda x: x**3-x-1
    newton, previous, current = mp.mpf(1), mp.mpf(1), mp.mpf(2)
    rows = numeric_rows(text[text.index("**第 8 题。**"):text.index("**第 9 题。**")])
    assert len(rows) == 3
    for row in rows:
        newton -= f(newton)/(3*newton**2-1)
        updated = current - f(current)*(current-previous)/(f(current)-f(previous))
        previous, current = current, updated
        close_to_printed(newton, row[1])
        close_to_printed(current, row[2])


def check_norms_and_iteration_boundaries() -> None:
    text = read("course/ch02/exercises.md")
    a = matrix_after(text, "{#sol-hw-2-5}")
    assert a == sp.Matrix([[1, 2], [0, 1]])
    assert set(a.eigenvals()) == {1}
    assert max(abs(value) for value in (sp.eye(2)-a.T*a).eigenvals()) > 1
    assert r"\frac2{\|A\|_2^2}" in text
    # Missing right-eigenvector component despite nonzero Euclidean dot product.
    a, initial = sp.Matrix([[2, 1], [0, 1]]), sp.Matrix([1, -1])
    assert (sp.Matrix([1, 0]).T*initial)[0] != 0 and a*initial == initial
    assert "{#note-power-initial}" in read("course/ch03/sec31.md")
    # The weighted-norm example rejects an arbitrary-norm -> Frobenius bound.
    a, scale = sp.Matrix([[0, 50], [0, 0]]), sp.diag(1, 100)
    assert (scale*a*scale.inv()).norm(1) == sp.Rational(1, 2)
    assert (sp.eye(2)-a).inv().norm() > sp.sqrt(2)/(1-sp.Rational(1, 2))
    # Stable Muller denominator must choose correctly for both signs of b.
    text = read("course/ch04/sec41b.md")
    assert r"2c_k}{b_k+\operatorname{sgn}(b_k)\sqrt" in text
    for b in [-3, 3]:
        denominator = b + sp.sign(b)*sp.sqrt(b*b - 8)
        root = -4/denominator
        assert sp.simplify(root*root + b*root + 2) == 0 and abs(root) == 1
    z = sp.Symbol("z")
    one_correction = 1+z+z*z/2
    trapezoid = (1+z/2)/(1-z/2)
    assert one_correction.subs(z, -10) == 41
    assert trapezoid.subs(z, -10) == -sp.Rational(2, 3)
    gauss = (1+z/2+z*z/12)/(1-z/2+z*z/12)
    assert sp.series(gauss-sp.exp(z), z, 0, 5).removeO() == 0


def check_source_corrections() -> None:
    x = sp.Symbol("x", real=True)
    text = section("ch01/exercises.md", "{#hw-1-2}", "{#hw-1-3}")
    assert r"\dfrac{1-\cos x}{x}" in text
    assert r"\frac{x}{2}\left(\frac{\sin(x/2)}{x/2}\right)^2" in text
    assert sp.simplify(2*sp.sin(x/2)**2 - (1-sp.cos(x))) == 0
    assert sp.limit((1-sp.cos(x))/x, x, 0) == 0
    a, b, lam = sp.symbols("a b lambda")
    matrix = sp.Matrix([[10,a,0],[b,10,b],[0,a,5]])
    diagonal = sp.diag(10,10,5)
    lower = sp.Matrix([[0,0,0],[b,0,0],[0,a,0]])
    upper = matrix-diagonal-lower
    jacobi = -diagonal.inv()*(lower+upper)
    gs = -(diagonal+lower).inv()*upper
    assert sp.expand(jacobi.charpoly(lam).as_expr()) == lam**3-3*a*b*lam/100
    assert sp.expand(gs.charpoly(lam).as_expr()) == lam**3-3*a*b*lam**2/100
    text = read("course/ch02/exercises.md")
    assert r"\frac{\sqrt{3\lvert ab\rvert}}{10}" in text
    assert r"\frac{3\lvert ab\rvert}{100}" in text
    # Exact residual sign and two-sided error estimates in a fixed example.
    matrix = sp.diag(1, sp.Rational(1, 100))
    exact, approximate = sp.Matrix([1,1]), sp.Matrix([1,2])
    right, error = matrix*exact, approximate-exact
    residual = right-matrix*approximate
    assert error == -matrix.inv()*residual
    condition = matrix.norm(2)*matrix.inv().norm(2)
    relative_error = error.norm()/exact.norm()
    relative_residual = residual.norm()/right.norm()
    assert relative_residual/condition <= relative_error <= condition*relative_residual
    text = read("supplement/sec24.md")
    assert r"\boldsymbol{e}=-A^{-1}\boldsymbol{r}" in text
    assert r"\alpha<1" in text and "不能直接作为可计算的停机量" in text
    # A diagonal scaling disproves the old n-times Skeel upper bound.
    matrix = sp.diag(1,100)
    skeel = (abs(matrix.inv())*abs(matrix)).norm(sp.oo)
    assert skeel == 1 and matrix.norm(sp.oo)*matrix.inv().norm(sp.oo) > 2*skeel
    assert "反向的 $n$ 倍上界一般不成立" in text


def check_retained_editor_exercises() -> None:
    text = section("course/ch03/exercises.md", "{#editor-eigen-shift}")
    matrix = matrix_after(read("course/ch03/exercises.md"), "{#editor-eigen-shift}")
    maximum = sp.Matrix([sp.Rational(1,2), -sp.sqrt(2)/2, sp.Rational(1,2)])
    minimum = sp.Matrix([sp.Rational(1,2), sp.sqrt(2)/2, sp.Rational(1,2)])
    middle = sp.Matrix([1,0,-1])/sp.sqrt(2)
    assert (matrix*maximum-(2+sp.sqrt(2))*maximum).applyfunc(sp.simplify) == sp.zeros(3,1)
    assert (matrix*minimum-(2-sp.sqrt(2))*minimum).applyfunc(sp.simplify) == sp.zeros(3,1)
    assert maximum.norm() == minimum.norm() == middle.norm() == 1
    assert (matrix-2*sp.eye(3)).det() == 0
    assert (matrix-sp.Rational(21,10)*sp.eye(3)).det() != 0
    assert middle.dot(sp.ones(3,1)) == 0 and middle.dot(sp.Matrix([1,0,0])) != 0
    assert r"(1/2,-\sqrt2/2,1/2)" in text
    x = sp.Symbol("x", positive=True)
    text = section("course/ch04/exercises.md", "{#editor-fixed-point-equivalence}", "## 作业组")
    assert r"\varphi_3'(x)=-(x+2)/x^3" in text
    assert sp.simplify(sp.diff((x+1)/x**2,x)+(x+2)/x**3) == 0
    golden = (1+sp.sqrt(5))/2
    assert sp.simplify(1+1/golden-golden) == 0
    assert sp.simplify(golden**3-golden-1) != 0
    assert "交替并不等于发散" in text
    # Read every published bisection midpoint and residual in the original HW.
    text = section("course/ch04/exercises.md", "{#sol-hw-4-1}", "{#hw-4-2}")
    left,right = mp.mpf(1),mp.mpf(2)
    rows = numeric_rows(text)
    for row in rows:
        midpoint = (left+right)/2
        residual = midpoint**2-midpoint-1
        close_to_printed(midpoint,row[1])
        close_to_printed(residual,row[2])
        if residual > 0:
            right=midpoint
        else:
            left=midpoint
    assert len(rows)==5


def main() -> None:
    groups = (
        check_content_inventory, check_homework_recurrence, check_decimal_homework,
        check_original_eigen_homework, check_original_nonlinear_tables,
        check_newton_and_chebyshev, check_norms_and_iteration_boundaries,
        check_source_corrections, check_retained_editor_exercises,
    )
    for group in groups:
        group()
        print(f"PASS {group.__name__}")
    print(f"Recovery checks passed: {len(groups)} groups, {checked_values} published values.")


if __name__ == "__main__":
    main()
