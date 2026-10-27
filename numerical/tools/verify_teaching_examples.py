#!/usr/bin/env python3
"""Standard-library recomputation of selected teaching examples.
Run: python3 numerical/tools/verify_teaching_examples.py
Scope: course/ch02/sec21 decimal elimination, sec22 pivoted LU,
course/ch05/sec51 Newton interpolation, sec52 least squares,
lectures/lec11 + course/ch05/sec54 best square approximation (exact Fractions),
lectures/lec08 fixed-point example x - ln x = 2 and Newton/multiple-root rates.
Decimal rounds after every elementary operation; Fraction checks identities.
"""
from decimal import Decimal, ROUND_HALF_UP, localcontext
from fractions import Fraction as F
from math import isclose, log


def mul(a, b):
    return [[sum(x*y for x, y in zip(row, col)) for col in zip(*b)] for row in a]


def trans(a):
    return list(map(list, zip(*a)))


def eliminate_decimal(epsilon, pivot):
    with localcontext() as context:
        context.prec = 3
        context.rounding = ROUND_HALF_UP
        a = [[Decimal(epsilon), Decimal(1)], [Decimal(1), Decimal(1)]]
        b = [Decimal(1), Decimal(2)]
        if pivot:
            a.reverse()
            b.reverse()
        m = a[1][0]/a[0][0]
        u22 = a[1][1]-m*a[0][1]
        b2 = b[1]-m*b[0]
        x2 = b2/u22
        x1 = (b[0]-a[0][1]*x2)/a[0][0]
        return m, u22, b2, x1, x2


def check_decimal_elimination():
    assert eliminate_decimal('0.00001', False) == (10**5, -10**5, -10**5, 0, 1)
    assert eliminate_decimal('0.00001', True)[-2:] == (1, 1)
    assert eliminate_decimal('0.001', False) == (1000, -999, -998, 1, Decimal('0.999'))
    for eps in (F(1, 100000), F(1, 1000)):
        exact = [[1/(1-eps)], [(1-2*eps)/(1-eps)]]
        assert mul([[eps, 1], [1, 1]], exact) == [[1], [2]]


def check_pivoted_lu():
    a = [[4, 1, 1], [2, 1, 0], [1, 3, 2]]
    q = [[1, 0, 0], [0, 0, 1], [0, 1, 0]]
    lower = [[1, 0, 0], [F(1, 4), 1, 0], [F(1, 2), F(2, 11), 1]]
    upper = [[4, 1, 1], [0, F(11, 4), F(7, 4)], [0, 0, F(-9, 11)]]
    assert mul(lower, upper) == mul(q, a)
    rhs, intermediate = [[6], [3], [6]], [[6], [F(9, 2)], [F(-9, 11)]]
    assert mul(lower, intermediate) == mul(q, rhs)
    assert mul(upper, [[1], [1], [1]]) == intermediate
    wrong = [[1, 0, 0], [F(1, 2), 1, 0], [F(1, 4), F(2, 11), 1]]
    assert mul(wrong, upper) != mul(q, a)


def differences(nodes, values):
    coefficients = list(map(F, values))
    for level in range(1, len(nodes)):
        for i in range(len(nodes)-1, level-1, -1):
            coefficients[i] = (coefficients[i]-coefficients[i-1])/(nodes[i]-nodes[i-level])
    return coefficients


def newton(nodes, coefficients, point):
    result = coefficients[-1]
    for i in range(len(coefficients)-2, -1, -1):
        result = coefficients[i]+(point-nodes[i])*result
    return result


def check_interpolation():
    nodes = list(map(F, [-1, 0, 1, 2]))
    values = [F(1, 2), F(1), F(2), F(4)]
    coefficients = differences(nodes, values)
    assert coefficients == [F(1, 2), F(1, 2), F(1, 4), F(1, 12)]
    for x, y in zip(nodes, values):
        assert newton(nodes, coefficients, x) == y
    assert newton(nodes, coefficients, F(3, 10)) == F('1.22475')
    values[-1] = F('4.1')
    perturbed = differences(nodes, values)
    assert perturbed[-1] == F(1, 10)
    assert newton(nodes, perturbed, F(3, 10)) == F('1.2202')
    error = abs(1.2475-2**0.3)
    bound = 2*log(2)**3/6*abs(1.3*0.3*(-0.7))
    assert 0.005 < error < bound < 0.05
    assert isclose(error, 0.0163555867, abs_tol=5e-11)
    for degree in range(4):
        coefficient = differences(nodes, [x**degree for x in nodes])[-1]
        assert coefficient == (1 if degree == 3 else 0)


def check_least_squares():
    a, y = [[1, 0], [1, 1], [1, 2]], [[1], [2], [2]]
    c = [[F(7, 6)], [F(1, 2)]]
    assert mul(trans(a), a) == [[3, 3], [3, 5]]
    assert mul(trans(a), y) == [[5], [6]]
    prediction = mul(a, c)
    residual = [[yi[0]-pi[0]] for yi, pi in zip(y, prediction)]
    assert residual == [[F(-1, 6)], [F(1, 3)], [F(-1, 6)]]
    assert mul(trans(a), residual) == [[0], [0]]
    assert sum(row[0]**2 for row in residual) == F(1, 6)
    for c in ([[2], [0]], [[0], [2]], [[F(1, 2)], [F(3, 2)]]):
        assert mul([[1, 1]]*3, c) == [[2], [2], [2]]
    assert sum((value-2)**2 for value in (1, 2, 3)) == 2


def solve2(g, b):
    det = g[0][0]*g[1][1]-g[0][1]*g[1][0]
    return ((b[0][0]*g[1][1]-g[0][1]*b[1][0])/det,
            (g[0][0]*b[1][0]-b[0][0]*g[1][0])/det)


def check_best_square_approx():
    # 第 11 讲例题 / 教材例 8: f=sqrt(x), (f,g)=∫₀¹ fg dx, span{1,x}
    gram = [[F(1), F(1, 2)], [F(1, 2), F(1, 3)]]
    assert gram[0][0]*gram[1][1]-gram[0][1]*gram[1][0] == F(1, 12)
    a, b = solve2(gram, [[F(2, 3)], [F(2, 5)]])
    assert (a, b) == (F(4, 15), F(4, 5))
    # 投影条件 (f-p,1)=(f-p,x)=0
    assert F(2, 3)-(a+b*F(1, 2)) == 0
    assert F(2, 5)-(a*F(1, 2)+b*F(1, 3)) == 0
    # ‖f-p‖²=(f,f)-2(f,p)+(p,p)=1/450
    ff, fp = F(1, 2), a*F(2, 3)+b*F(2, 5)
    pp = a*a+2*a*b*F(1, 2)+b*b*F(1, 3)
    assert (fp, pp) == (F(112, 225), F(112, 225))
    assert ff-2*fp+pp == F(1, 450)
    # 正交基 {1, x-1/2} 再算: 系数解耦, 结果同多项式
    c0, c1 = F(2, 3), F(1, 15)/F(1, 12)
    assert c1 == b and c0-c1*F(1, 2) == a
    # 延伸 B1: f=x² 于 [0,1]
    a2, b2 = solve2(gram, [[F(1, 3)], [F(1, 4)]])
    assert (a2, b2) == (F(-1, 6), F(1))
    fp2, pp2 = a2*F(1, 3)+b2*F(1, 4), a2*a2+2*a2*b2*F(1, 2)+b2*b2*F(1, 3)
    assert (fp2, pp2) == (F(7, 36), F(7, 36))
    assert F(1, 5)-2*fp2+pp2 == F(1, 180)
    # 延伸 B2: f=x² 于 [-1,1], Legendre 基 L0=1, L1=x
    assert F(2, 3)/F(2) == F(1, 3) and F(0)/F(3, 2) == 0


def check_fixed_point_log_example():
    # 第 8 讲例题: x - ln x = 2 于 [2,4], φ(x)=2+ln x, s≈3.146193 (板书四步验证, 表为编者补算)
    def phi(x):
        return 2 + log(x)

    s = 3.1461932206205825
    assert isclose(s, 2 + log(s), rel_tol=0, abs_tol=5e-16)
    # 定理一/二的条件: 自映射与压缩 (|φ'|=1/x ≤ 1/2 于 [2,4])
    assert 2 < phi(2) < 4 and 2 < phi(4) < 4
    assert all(1/4 <= 1/x <= 1/2 for x in (2, 3, 4))
    # 迭代表 (x0=3, 页面给 6 位小数)
    x, table = 3.0, []
    for _ in range(8):
        table.append(x)
        x = phi(x)
    published = ['3.000000', '3.098612', '3.130954', '3.141338',
                 '3.144649', '3.145702', '3.146037', '3.146144']
    for value, shown in zip(table, published):
        assert f'{value:.6f}' == shown, (value, shown)
    # 后验界 (L=1/2 ⇒ 因子 1): |x_k-s| ≤ |x_k-x_{k-1}|; 先验界对每个 k 成立
    errors = [abs(value - s) for value in table]
    steps = [abs(b - a) for a, b in zip(table[1:], table)]
    assert all(e <= st + 1e-15 for e, st in zip(errors[1:], steps))
    assert all(errors[k] <= 2 * 0.5**k * abs(table[1] - table[0]) for k in range(8))
    assert 2 * 0.5**10 * abs(table[1] - table[0]) > 1e-4 >= 2 * 0.5**11 * abs(table[1] - table[0])
    # 线性收敛的渐近速率 C=|φ'(s)|=1/s (定理 4.3); 全局常数 L=1/2 保守
    ratios = [b/a for a, b in zip(errors[3:], errors[4:])]
    assert all(isclose(r, 1/s, rel_tol=0.02) for r in ratios)
    # Newton 单根二阶: φ''(s)=f''(s)/f'(s), f=x-ln x-2
    f1, f2 = 1 - 1/s, 1/s**2
    assert isclose(f2/f1, 0.1480968394856202, rel_tol=1e-12)
    # 重根掉阶: φ'(s)=1-1/m (m=2: 1/2, m=3: 2/3), 数值取极限
    for m, expected in ((2, 0.5), (3, 2/3)):
        rate = newton_multiple_root_rate(m)
        assert isclose(rate, expected, rel_tol=0.01), (m, rate, expected)


def newton_multiple_root_rate(m):
    """Empirical asymptotic error ratio of plain Newton on f=(x-1)^m e^x at s=1."""
    x, previous_error = 1.3, None
    for _ in range(60):
        value = (x-1)**m * pow(2.718281828459045, x)
        derivative = m * (x-1)**(m-1) * pow(2.718281828459045, x) + value
        error = abs(x - 1)
        if previous_error is not None and error < 1e-12:
            break
        if derivative == 0:
            break
        x -= value/derivative
        previous_error = error
    return abs(x - 1)/previous_error if previous_error else float('nan')


if __name__ == '__main__':
    checks = (check_decimal_elimination, check_pivoted_lu, check_interpolation,
              check_least_squares, check_best_square_approx,
              check_fixed_point_log_example)
    for check in checks:
        check()
        print('PASS', check.__name__)
    print('6 example groups passed; no external dependencies.')
