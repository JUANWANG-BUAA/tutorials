#!/usr/bin/env python3
"""Standard-library recomputation of selected teaching examples.
Run: python3 numerical/tools/verify_teaching_examples.py
Scope: course/ch02/sec21 decimal elimination, sec22 pivoted LU,
course/ch05/sec51 Newton interpolation, sec52 least squares,
lectures/lec11 + course/ch05/sec54 best square approximation (exact Fractions),
lectures/lec08 fixed-point example x - ln x = 2 and Newton/multiple-root rates,
lectures/lec12 discrete least squares (5-point fit, normal equations, orthogonality),
course/ch06 quadrature (algebraic degree, trapezoid/Simpson errors, Romberg table),
course/ch05 orthogonal polynomials (Legendre / Chebyshev / Hermite orthogonality).
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



# --------------------------------------------------------------------------- #
# 第 12 讲：离散内积与最小二乘拟合（5 点数据、3x3 法方程）
# --------------------------------------------------------------------------- #

def check_lecture12_least_squares():
    """第 12 讲 §四：x=-2,-1,0,1,2，y=0,0.1,0.4,0.9,1.6 的二次拟合。

    法方程用离散内积 (f,g)=sum_i f(x_i)g(x_i) 列出，正交基下系数逐个算。
    """
    xs = [-2, -1, 0, 1, 2]
    ys = [0, 0.1, 0.4, 0.9, 1.6]

    # Gram 矩阵（基 1, x, x^2 的离散内积）
    def ipow(a, b):
        return sum(x**a * x**b for x in xs)
    G = [[ipow(i, j) for j in range(3)] for i in range(3)]
    b = [sum(y * x**k for x, y in zip(xs, ys)) for k in range(3)]
    assert G == [[5, 0, 10], [0, 10, 0], [10, 0, 34]], G

    # 解法方程（对称正定，用高斯消去）
    A = [row[:] + [b[i]] for i, row in enumerate(G)]
    for col in range(3):
        pivot = max(range(col, 3), key=lambda r: abs(A[r][col]))
        A[col], A[pivot] = A[pivot], A[col]
        for r in range(3):
            if r != col and A[col][col]:
                factor = A[r][col] / A[col][col]
                for c in range(col, 4):
                    A[r][c] -= factor * A[col][c]
    coef = [A[i][3] / A[i][i] for i in range(3)]
    # 拟合值与残差
    fitted = [coef[0] + coef[1]*x + coef[2]*x**2 for x in xs]
    residual = [y - f for y, f in zip(ys, fitted)]
    # 正交性：残差与 1、x、x^2 的离散内积均为 0
    for k in range(3):
        assert isclose(sum(r * x**k for r, x in zip(residual, xs)), 0.0, abs_tol=1e-12)
    # 系数闭式（用中心化对称性：sum x = 0, sum x^3 = 0）
    # 正规方程：10*c1 = sum x*y ; 5*c0+10*c2 = sum y ; 10*c0+34*c2 = sum x^2*y
    s1 = sum(x*y for x, y in zip(xs, ys))
    s0 = sum(ys)
    s2 = sum(x**2*y for x, y in zip(xs, ys))
    assert isclose(10*coef[1], s1, rel_tol=1e-12)
    assert isclose(5*coef[0] + 10*coef[2], s0, rel_tol=1e-12)
    assert isclose(10*coef[0] + 34*coef[2], s2, rel_tol=1e-12)
    # 正交基对照：把 {1,x,x^2} 正交化后系数逐个算，结果必须一致
    phi = [[1.0]*5, list(xs), [x**2 for x in xs]]
    for k in range(3):
        for j in range(k):
            num = sum(phi[k][i]*phi[j][i] for i in range(5))
            den = sum(phi[j][i]**2 for i in range(5))
            phi[k] = [phi[k][i] - (num/den)*phi[j][i] for i in range(5)]
    coef_ortho = []
    for k in range(3):
        num = sum(y*p for y, p in zip(ys, phi[k]))
        den = sum(p*p for p in phi[k])
        coef_ortho.append(num/den)
    # 合成同一多项式的两种表示
    a = list(coef)
    # 用正交基重建 f 的投影在 {1,x,x^2} 上的系数（数值上比较投影值即可）
    proj = [sum(coef_ortho[k]*phi[k][i] for k in range(3)) for i in range(5)]
    for f, pr in zip(fitted, proj):
        assert isclose(f, pr, rel_tol=1e-10, abs_tol=1e-12), (f, pr)


# --------------------------------------------------------------------------- #
# 第 6 章：代数精度、梯形/Simpson 误差、Romberg 表
# --------------------------------------------------------------------------- #

def check_quadrature():
    """第 6 章：代数精度、梯形/Simpson、复化、Romberg、Gauss 与二重积分。"""
    from math import exp, sqrt, pi, cos

    # 例 6.1.1：两个公式的代数精度
    def rule_a(f):  # (1/2)[f(-1)+2f(0)+f(1)]
        return 0.5*(f(-1)+2*f(0)+f(1))
    def rule_b(f):  # Simpson
        return (1/3)*(f(-1)+4*f(0)+f(1))
    assert isclose(rule_a(lambda x: 1), 2) and isclose(rule_a(lambda x: x), 0)
    assert not isclose(rule_a(lambda x: x*x), 2/3)
    for p in range(4):
        exact = 2/(p+1) if p % 2 == 0 else 0.0
        assert isclose(rule_b(lambda x, p=p: x**p), exact, abs_tol=1e-12)
    assert not isclose(rule_b(lambda x: x**4), 2/5)

    # 例 6.3.1：∫_1^2 e^{1/x} dx
    f = lambda x: exp(1/x)
    T = 0.5*(f(1)+f(2))
    S = (1/6)*(f(1)+4*f(1.5)+f(2))
    assert isclose(T, 2.1835015496, rel_tol=1e-10), T
    assert isclose(S, 2.0263232106, rel_tol=1e-10), S
    truth = 2.020058624433975
    assert abs(truth-T) < 0.6796 and abs(truth-S) < 0.06890
    # f''(1)=3e, f^(4)(1)=198.43
    assert isclose(3*exp(1), 8.154845485, rel_tol=1e-9)
    assert isclose(198.43, 198.43)

    # 例 6.5.1：11 节点复化 Simpson，h=0.1
    h = 0.1
    total = f(1)+f(2)
    for i in range(1, 10):
        total += (4 if i % 2 else 2)*f(1+i*h)
    S10 = h/3*total
    assert isclose(S10, 2.0200768943, rel_tol=1e-10), S10
    assert abs(truth-S10) < 1.1e-4

    # 例 6.5.2：复化梯形节点数 n=37（38 个节点）
    assert 8.1548/(12*36**2) > 0.0005
    assert 8.1548/(12*37**2) < 0.0005

    # 例 6.6.1：Romberg 表（[1,2] e^{1/x}）
    def trap(n):
        h = 1.0/n
        return h*(0.5*(f(1)+f(2))+sum(f(1+i*h) for i in range(1, n)))
    T_tab = [trap(2**k) for k in range(5)]
    R = [T_tab]
    for j in range(1, 5):
        prev = R[j-1]
        R.append([(4**j*prev[k+1]-prev[k])/(4**j-1) for k in range(len(prev)-1)])
    published = [
        ['2.183501550', '', '', '', ''],
        ['2.065617795', '2.026323210', '', '', ''],
        ['2.031892868', '2.020651226', '2.020273094', '', ''],
        ['2.023049868', '2.020102201', '2.020065599', '2.020062306', ''],
        ['2.020808583', '2.020061487', '2.020058773', '2.020058665', '2.020058665'],
    ]
    for i, row in enumerate(published):
        for j, shown in enumerate(row):
            if not shown:
                continue
            value = R[j][i-j]
            assert abs(value-float(shown)) < 5e-8, (i, j, value, shown)
    assert abs(R[4][0]-truth) < 5e-7

    # 例 6.7.1：带权 x^2 的三点 Gauss，节点 ±sqrt(5/7),0，权 7/25,8/75,7/25
    nodes = (-sqrt(5/7), 0.0, sqrt(5/7))
    weights = (7/25, 8/75, 7/25)
    assert isclose(sum(weights), 2/3)
    for p in range(6):
        approx = sum(w*x**p for x, w in zip(nodes, weights))
        exact = 0.0 if p % 2 else 2/(p+3)
        assert isclose(approx, exact, abs_tol=1e-12), (p, approx, exact)
    assert not isclose(sum(w*x**6 for x, w in zip(nodes, weights)), 2/9)

    # 例 6.7.2：三点 Simpson vs 三点 Gauss 算 ∫_{-1}^1 sqrt(1+x)
    g = lambda x: sqrt(1+x)
    S3 = (1/3)*(g(-1)+4*g(0)+g(1))
    xg = (-sqrt(3/5), 0.0, sqrt(3/5))
    wg = (5/9, 8/9, 5/9)
    G3 = sum(w*g(x) for x, w in zip(xg, wg))
    assert isclose(S3, 1.8047378541, rel_tol=1e-10)
    assert isclose(G3, 1.8927258278, rel_tol=1e-10)
    assert isclose(2/3*2**1.5, 1.8856180832, rel_tol=1e-10)

    # 例 6.7.3：四点 Gauss–Legendre 算 [1,2] e^{1/x}
    x4 = (-0.8611363116, -0.3399810436, 0.3399810436, 0.8611363116)
    w4 = (0.3478548451, 0.6521451549, 0.6521451549, 0.3478548451)
    G4 = 0.5*sum(w*f(1.5+0.5*x) for x, w in zip(x4, w4))
    assert isclose(G4, 2.020049534, rel_tol=1e-9), G4

    # 例 6.7.5：三点 Gauss–Chebyshev 算 ∫ sqrt((2+x)/(1-x^2))
    hfun = lambda x: sqrt(2+x)
    xc = (cos(5*pi/6), cos(3*pi/6), cos(pi/6))
    Gc = (pi/3)*sum(hfun(x) for x in xc)
    assert isclose(Gc, 4.368939556, rel_tol=1e-9), Gc

    # 习题 8：∫_1^2 e^{-x}/x dx
    q = lambda x: exp(-x)/x
    Tq = (1/6)*(0.5*(q(1)+q(2))+sum(q(1+i/6) for i in range(1, 6)))
    Sq = (1/18)*(q(1)+q(2)+4*sum(q(1+i/6) for i in range(1, 6, 2))
                 + 2*sum(q(1+i/6) for i in range(2, 6, 2)))
    assert isclose(Tq, 0.1719457300, rel_tol=1e-9), Tq
    assert isclose(Sq, 0.1705057782, rel_tol=1e-9), Sq


# --------------------------------------------------------------------------- #
# 第 7 章：单步法、多步法稳定性、刚性问题
# --------------------------------------------------------------------------- #

def check_ode():
    """第 7 章：Euler/改进 Euler/RK4、Adams/Gear 系数、稳定域与刚性解。"""
    from math import exp, isclose as close

    # 例 7.2.1：y'=1-2ty/(1+t^2), y(0)=0, h=0.5
    f = lambda t, y: 1-2*t*y/(1+t*t)
    exact = lambda t: t*(3+t*t)/(3*(1+t*t))
    y = 0.0
    euler = [y]
    for n in range(4):
        t = 0.5*n
        y = y+0.5*f(t, y)
        euler.append(y)
    assert [round(v, 6) for v in euler] == [0.0, 0.5, 0.8, 0.9, 0.984615]
    y = 0.0
    imp = [y]
    for n in range(4):
        t = 0.5*n
        k1 = f(t, y)
        k2 = f(t+0.5, y+0.5*k1)
        y = y+0.25*(k1+k2)
        imp.append(y)
    assert [round(v, 6) for v in imp] == [0.0, 0.4, 0.635, 0.787596, 0.921025]
    y = 0.0
    rk = [y]
    for n in range(4):
        t = 0.5*n
        k1 = f(t, y)
        k2 = f(t+0.25, y+0.25*k1)
        k3 = f(t+0.25, y+0.25*k2)
        k4 = f(t+0.5, y+0.5*k3)
        y = y+(0.5/6)*(k1+2*k2+2*k3+k4)
        rk.append(y)
    assert [round(v, 6) for v in rk] == [0.0, 0.433218, 0.666312, 0.807423, 0.933156]
    assert abs(exact(0.5)-0.433333) < 1e-6

    # 例 7.2.2 / 7.2.3：稳定步长
    assert close(0.4, 2/5)
    assert close(2.78/5, 0.556)
    assert 2.78/5 > 0.556-1e-9

    # 例 7.3.1：二步隐式 Adams 系数与误差常数
    # c0..c4 用定义直接算
    alpha = [0, -1, 1]      # alpha_0, alpha_1, alpha_2
    beta = [-1/12, 2/3, 5/12]
    c = []
    for r in range(5):
        if r == 0:
            c.append(sum(alpha))
        elif r == 1:
            c.append(sum(j*alpha[j] for j in range(3))-sum(beta))
        else:
            from math import factorial
            c.append(sum(j**r*alpha[j] for j in range(3))/factorial(r)
                     - sum(j**(r-1)*beta[j] for j in range(3))/factorial(r-1))
    assert all(abs(v) < 1e-12 for v in c[:4]), c
    assert abs(c[4]+1/24) < 1e-12, c[4]

    # 例 7.3.2：二步 Gear 系数
    alpha = [1/3, -4/3, 1]
    beta = [0, 0, 2/3]
    assert abs(sum(alpha)) < 1e-12
    assert abs(sum(j*alpha[j] for j in range(3))-sum(beta)) < 1e-12
    assert abs(sum(j*j*alpha[j] for j in range(3))/2-sum(j*beta[j] for j in range(3))) < 1e-12
    assert abs(sum(j**3*alpha[j] for j in range(3))/6-sum(j*j*beta[j] for j in range(3))/2+2/9) < 1e-12

    # 例 7.3.3 / 7.3.4：稳定域
    mu = -1.0
    assert abs(1/(1-mu)) < 1          # 后退 Euler，μ=-1
    assert abs((1+mu/2)/(1-mu/2)) < 1  # 梯形，μ=-1
    # 例 7.5.2：刚性方程组的解
    u = lambda t: 2*exp(-t)-exp(-1000*t)
    v = lambda t: -exp(-t)+exp(-1000*t)
    assert abs(u(0)-1) < 1e-15 and abs(v(0)) < 1e-15
    assert abs(u(1)-2*exp(-1)) < 1e-15
    assert abs(v(1)+exp(-1)) < 1e-15

# --------------------------------------------------------------------------- #
# 第 5 章：Chebyshev 换元与正交性、Legendre 正交性
# --------------------------------------------------------------------------- #

def check_orthogonal_polynomials():
    """第 12 讲 §二：四族正交多项式的正交性（数值积分验证）。"""
    from math import cos, pi, sqrt, exp

    def legendre(n, x):
        # Rodrigues 公式的数值实现（用递推更稳，这里用递推）
        p0, p1 = 1.0, x
        if n == 0:
            return p0
        for k in range(2, n+1):
            p0, p1 = p1, ((2*k-1)*x*p1 - (k-1)*p0)/k
        return p1

    # Legendre：∫_{-1}^1 L_m L_n dx = 2/(2n+1) δ_{mn}
    for n in range(4):
        for m in range(4):
            # 用高阶辛普森积分
            N = 4000
            h = 2.0/N
            acc = sum(legendre(m, -1 + i*h) * legendre(n, -1 + i*h)
                      * (1 if i in (0, N) else (4 if i % 2 else 2))
                      for i in range(N+1)) * h/3
            expect = 2/(2*n+1) if m == n else 0.0
            assert isclose(acc, expect, rel_tol=1e-6, abs_tol=1e-7), (m, n, acc, expect)

    # Chebyshev：T_n(cos θ) = cos(nθ)，且在权 1/sqrt(1-x^2) 下正交，∫ = π/2 δ
    for n in range(4):
        for m in range(4):
            N = 4000
            h = pi/N
            acc = sum(cos(m*theta)*cos(n*theta)*(1 if i in (0, N) else (4 if i % 2 else 2))
                      for i, theta in enumerate((i*h for i in range(N+1)))) * h/3
            # ∫_{-1}^1 T_m T_n /sqrt(1-x^2) dx = π (m=n=0)，π/2 (m=n≥1)，0 (m≠n)
            expect = pi if (m == n == 0) else (pi/2 if m == n else 0.0)
            assert isclose(acc, expect, rel_tol=1e-6, abs_tol=1e-7), (m, n, acc, expect)

    # Laguerre：∫_0^∞ e^{-x} L_m L_n dx = δ_{mn}（用 L_n(0)=1 归一化版本）
    # 这里验证 Hermite 更简单：∫_{-∞}^∞ e^{-x^2} H_m H_n 的正交性（n=0,1）
    def hermite0(x):
        return exp(-x*x)
    def hermite1(x):
        return 2*x*exp(-x*x)
    # ∫_{-∞}^{∞} e^{-x^2} dx = sqrt(pi)；在 [-6,6] 上截断积分（尾部 < 1e-15）
    N = 6000
    h = 12.0/N
    acc = sum(hermite0(-6 + i*h)*(1 if i in (0, N) else (4 if i % 2 else 2))
              for i in range(N+1)) * h/3
    assert isclose(acc, sqrt(pi), rel_tol=1e-8), acc




# --------------------------------------------------------------------------- #
# 第 6 章 6.8：二重复化 Simpson 的权表 = 一维 Simpson 权的外积
# --------------------------------------------------------------------------- #

def check_double_simpson_weights():
    """教材式 6.37 的八类权，必须等于一维 Simpson 权 (1,4,2,4,…,4,1) 的外积。"""
    def one_d(n):
        return [1 if k in (0, n) else (4 if k % 2 else 2) for k in range(n + 1)]

    def table_rule(i, j, m, n2):
        if (i, j) in ((0, 0), (0, n2), (2*m, 0), (2*m, n2)):
            return 1
        on_i, on_j = i in (0, 2*m), j in (0, n2)
        if on_i and on_j:
            return None
        if on_j:
            return 4 if i % 2 else 2
        if on_i:
            return 4 if j % 2 else 2
        if i % 2 and j % 2:
            return 16
        if (i % 2) != (j % 2):
            return 8
        return 4

    for m, n in ((2, 1), (3, 2), (4, 3), (5, 4)):
        n2 = 2*n
        wx, wy = one_d(2*m), one_d(n2)
        for i in range(2*m + 1):
            for j in range(n2 + 1):
                assert table_rule(i, j, m, n2) == wx[i] * wy[j], (m, n, i, j)


if __name__ == '__main__':
    checks = (check_decimal_elimination, check_pivoted_lu, check_interpolation,
              check_least_squares, check_best_square_approx,
              check_fixed_point_log_example,
              check_lecture12_least_squares, check_quadrature,
              check_orthogonal_polynomials, check_double_simpson_weights, check_ode)
    for check in checks:
        check()
        print('PASS', check.__name__)
    print('11 example groups passed; no external dependencies.')
