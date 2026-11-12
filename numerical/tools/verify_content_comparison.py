#!/usr/bin/env python3
"""Recompute the exercises retained during the original-content comparison.

Read matrices and published table cells from current Markdown. Uses the book's
existing SymPy/mpmath dependency and display-tolerance helpers.
"""
from __future__ import annotations

import re

import mpmath as mp
import sympy as sp

import verify_recovery as recovery


def extract(rel: str, anchor: str) -> str:
    text = recovery.section(rel, '{#' + anchor + '}')
    return text.split('\n::: ex ', 1)[0]


def vector(cell: str) -> sp.Matrix:
    match = re.search(r'\(([^()]*)\)', cell)
    assert match, cell
    return sp.Matrix([sp.Rational(value) for value in match[1].split(',')])


def check_intro_source_data() -> None:
    text = extract('ch01/sec11.md', 'intro-three-problems')
    lecture = recovery.read('lectures/lec01.md')
    for label in ['深度', '水温']:
        def data(source: str) -> list[str]:
            line = next(line for line in source.splitlines() if line.startswith('| ' + label))
            return [cell.strip() for cell in line.strip('|').split('|')[1:]]
        assert data(text) == data(lecture), (label, data(text), data(lecture))
    assert r'x-\varepsilon\sin x-t=0' in text
    assert r'\sqrt{1+\frac{\cos^2x}{4}}' in text


def check_power_and_shifts() -> None:
    text = extract('course/ch03/mock-exam.md', 'extra-power-three-steps')
    a = recovery.matrix_after(text, '对 $A=')
    u = sp.ones(2, 1)
    rows = recovery.numeric_rows(text)
    assert len(rows) == 3
    for row in rows:
        y = u / max(abs(value) for value in u)
        u = a * y
        assert vector(row[1]) == y
        assert vector(row[2]) == u
        assert sp.Rational(row[3]) == max(abs(value) for value in u)
    lam = sp.Symbol('lambda')
    assert a.charpoly(lam).as_expr() == lam**2 - 7*lam + 11
    recovery.close_to_printed((7+mp.sqrt(5))/2, re.search(r'主特征值约 \$(.*?)\$', text)[1])
    recovery.close_to_printed(max(abs(value) for value in u), re.search(r'第三个尺度估计约 \$(.*?)\$', text)[1])
    text = extract('course/ch03/mock-exam.md', 'extra-singular-shift')
    a = recovery.matrix_after(text, '对 $A=')
    assert set(a.eigenvals()) == {1, 6}
    assert (a-sp.eye(2)).det() == 0
    assert (a-sp.Rational(9,10)*sp.eye(2)).det() == sp.Rational(51,100)
    assert r'\mu$，恢复 $\lambda=0.9+1/\mu' in text
    text = extract('course/ch03/mock-exam.md', 'extra-energy-order')
    h = recovery.matrix_after(text, '实对称矩阵 $H=')
    assert set(h.eigenvals()) == {2-sp.sqrt(2), 2, 2+sp.sqrt(2)}
    middle = sp.Matrix([1, 0, -1])
    assert h*middle == 2*middle and middle.dot(sp.ones(3,1)) == 0
    assert (h-2*sp.eye(3)).det() == 0
    assert (h-sp.Rational(21,10)*sp.eye(3)).det() != 0


def check_log_iteration() -> None:
    text = extract('course/ch04/mock-exam.md', 'extra-log-contraction')
    rows = recovery.numeric_rows(text)
    assert len(rows) == 3
    x = mp.mpf(3)
    previous = x
    for row in rows:
        previous, x = x, 2+mp.log(x)
        recovery.close_to_printed(x, row[1])
    bound = re.search(r'\|x_3-x_2\|\\approx([^$]+)', text)[1]
    recovery.close_to_printed(abs(x-previous), bound)


def check_sqrt_order() -> None:
    text = extract('course/ch04/mock-exam.md', 'extra-sqrt-five-order')
    rows = recovery.numeric_rows(text)
    assert len(rows) == 3
    x, s = mp.mpf(2), mp.sqrt(5)
    previous = x
    for row in rows:
        previous, x = x, (x+5/x)/2
        recovery.close_to_printed(x, row[1])
        recovery.close_to_printed(abs(x-s), row[2])
    measured = re.search(r'实测比值 \$\\approx([^$]+)', text)[1]
    theoretical = re.search(r'理论极限 .*?\\approx([^$]+)', text)[1]
    recovery.close_to_printed(abs(x-s)/abs(previous-s)**2, measured)
    recovery.close_to_printed(1/(2*s), theoretical)
    text = extract('course/ch04/mock-exam.md', 'extra-newton-interval')
    f = lambda y: y**3-3*y+1
    assert f(sp.Rational(9,10)) == sp.Rational(-971,1000)
    assert f(sp.Rational(1,5)) == sp.Rational(51,125)
    assert '0.408>0' in text and '根左侧' in text


def check_iteration_cost_table() -> None:
    text = extract('course/ch04/mock-exam.md', 'extra-root-cost')
    f = lambda x: mp.exp(x)-3*x*x
    derivative = lambda x: mp.exp(x)-6*x
    rows = recovery.numeric_rows(text)
    assert len(rows) == 5
    x, previous, current = mp.mpf(1), mp.mpf('.5'), mp.mpf(1)
    newton_stop = secant_stop = None
    newton_delta = secant_delta = mp.inf
    for k, row in enumerate(rows, 1):
        if k <= 4:
            next_x = x-f(x)/derivative(x)
            newton_delta = abs(next_x-x)
            x = next_x
            recovery.close_to_printed(x, row[1])
            if newton_delta < mp.mpf('1e-6') and newton_stop is None:
                newton_stop = k
        else:
            assert row[1] == '—'
        next_x = current-f(current)*(current-previous)/(f(current)-f(previous))
        secant_delta = abs(next_x-current)
        previous, current = current, next_x
        recovery.close_to_printed(current, row[2])
        if secant_delta < mp.mpf('1e-6') and secant_stop is None:
            secant_stop = k
    assert (newton_stop, secant_stop) == (4, 5)
    recovery.close_to_printed(newton_delta, re.search(r'最后步差约 \$(.*?)\$', text)[1])
    recovery.close_to_printed(secant_delta, re.search(r'割线用五次更新，最后步差约 \$(.*?)\$', text)[1])
    recovery.close_to_printed(mp.findroot(f, 1), re.search(r'根约为 ([0-9.]+)', text)[1].rstrip('.'))
    a, b = mp.mpf(0), mp.mpf(2)
    for expected in [1, mp.mpf('.5'), mp.mpf('.75'), mp.mpf('.875'), mp.mpf('.9375')]:
        c = (a+b)/2
        assert c == expected
        if f(a)*f(c) <= 0:
            b = c
        else:
            a = c
    assert (a,b) == (mp.mpf('.875'),mp.mpf('.9375'))
    assert '成本为 44' in text and '成本为 6' in text and '45 与 7' in text


def check_application_and_order_card() -> None:
    text = extract('training/exam-sprint.md', 'application-spd-iteration')
    a = recovery.matrix_after(text, '例如')
    assert set(a.eigenvals()) == {sp.Rational(5,2), sp.Rational(1,4)}
    jacobi = sp.eye(3)-a  # This source matrix has unit diagonal.
    assert max(abs(value) for value in jacobi.eigenvals()) == sp.Rational(3,2)
    text = extract('course/ch04/recall-cards.md', 'recall-secant-order')
    assert r"\psi'(s)=1-\frac{f'(s)(c-s)}{f(c)}" in text
    x,s,c = sp.symbols('x s c', real=True)
    f = sp.Function('f')
    psi = x-f(x)*(x-c)/(f(x)-f(c))
    slope = sp.Symbol('slope')
    at_root = sp.diff(psi,x).subs(x,s).subs(sp.diff(f(s),s),slope).subs(f(s),0)
    assert sp.simplify(at_root-(1-slope*(c-s)/f(c))) == 0



def check_foundation_exam() -> None:
    from collections import Counter
    text = recovery.read('training/exam-foundations.md')
    numbers = Counter(int(value) for value in re.findall(r'^\*\*(\d+)\.', text, re.M))
    assert numbers == Counter({k: 2 for k in range(1,14)}), numbers
    sums = [int(value) for value in re.findall(r'共\s*(\d+)\s*分', text)]
    assert sums == [20,20,36,24] and sum(sums) == 100
    g = recovery.matrix_after(text, '例如 $G=')
    d = sp.diag(1,8)
    assert max(abs(value) for value in g.eigenvals()) == sp.Rational(1,2)
    assert g.norm(1) == sp.Rational(5,2)
    assert (d*g*d.inv()).norm(sp.oo) == sp.Rational(3,4)
    question = text[text.index('**9.** 解线性方程组'):]
    equations = re.search(r'\\begin\{cases\}(.*?)\\end\{cases\}', question, re.S)[1].split(r'\\')
    matrix, right = [], []
    for equation in equations:
        left, rhs = equation.split('=')
        coefficients = {int(index): sp.Rational(coefficient if coefficient not in ['', '+', '-'] else coefficient+'1')
                        for coefficient,index in re.findall(r'([+-]?\d*)x_([123])', left)}
        matrix.append([coefficients.get(k,0) for k in [1,2,3]])
        right.append(sp.Rational(rhs.strip(' ,')))
    a,b = sp.Matrix(matrix),sp.Matrix(right)
    answer = text[text.index('**9.** **(a)**'):]
    l = recovery.matrix_after(answer, '**9.**')
    end_first = answer.index(r'\end{pmatrix}')+len(r'\end{pmatrix}')
    u = recovery.matrix_after(answer[end_first:], '')
    assert l*u == a
    assert a*sp.Matrix([1,2,3]) == b
    assert a.det() == 25 and '2.5\\times5=25' in answer
    # Effective-digit answer must use the error <= half-unit threshold.
    error = abs(mp.mpf('2.71828')-mp.e)
    assert error <= mp.mpf('0.5e-5') and error > mp.mpf('0.5e-6')
    assert r'1.83\times10^{-6}\le\tfrac12\times10^{1-n}' in text
    assert r'\|S_m-S_n\|' in text and '整个尾和' in text

def main() -> None:
    groups = [check_intro_source_data, check_power_and_shifts, check_log_iteration,
              check_sqrt_order, check_iteration_cost_table, check_application_and_order_card,
              check_foundation_exam]
    for group in groups:
        group()
        print('PASS', group.__name__)
    print(f'Content comparison checks passed: {len(groups)} groups, '
          f'{recovery.checked_values} published values.')


if __name__ == '__main__':
    main()
