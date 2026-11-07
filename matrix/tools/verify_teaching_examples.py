#!/usr/bin/env python3
"""Exact algebra and numerical checks for selected teaching examples.
Run: python3 matrix/tools/verify_teaching_examples.py
Scope: ch02/sec24 parameter eigenspaces, ch03/sec35 Schur basis,
ch03/sec36 Gram–Schmidt, ch03/sec37 orthogonal projection & least squares
(examples 3.7.E / 3.7.F, exercise C29), ch03/sec38 lambda-matrix inverses
and elementary-transformation chains (examples 3.8.A–3.8.C, exercises
C30/C31, polynomial coefficients as exact Fractions), ch04 norm/spectrum
examples (4.5.3–4.5.9 Gershgorin disks, 4.6.4/4.6.7 series, 4.6.9 Neumann
truncation; eigenvalues via Durand–Kerner polynomial root iteration). This does
not prove the general spectral theorems.
"""
from fractions import Fraction as F


def mul(a, b):
    return [[sum(x*y for x, y in zip(row, col)) for col in zip(*b)] for row in a]


def trans(a):
    return list(map(list, zip(*a)))


def sub(a, b):
    return [[x-y for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def rank(a):
    a = [[F(x) for x in row] for row in a]
    pivot = 0
    for col in range(len(a[0])):
        candidate = next((i for i in range(pivot, len(a)) if a[i][col]), None)
        if candidate is None:
            continue
        a[pivot], a[candidate] = a[candidate], a[pivot]
        scale = a[pivot][col]
        a[pivot] = [x/scale for x in a[pivot]]
        for i in range(len(a)):
            if i != pivot:
                scale = a[i][col]
                a[i] = [x-scale*y for x, y in zip(a[i], a[pivot])]
        pivot += 1
        if pivot == len(a):
            break
    return pivot


def check_parameter_eigenspaces():
    identity = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    for t in (0, 2, F(1, 1000)):
        a = [[1, t, 0], [0, 1, 0], [0, 0, 2]]
        assert 3-rank(sub(a, identity)) == (2 if t == 0 else 1)
        twice = [[2*x for x in row] for row in identity]
        assert 3-rank(sub(a, twice)) == 1
        assert mul(a, [[1], [0], [1]]) == [[1], [0], [2]]


def check_schur_basis():
    a = [[1, 2], [0, 3]]
    # Q=S/sqrt(2): evaluate Q^T A Q exactly without irrational arithmetic.
    s = [[1, -1], [1, 1]]
    assert mul(trans(s), s) == [[2, 0], [0, 2]]
    schur = [[x/F(2) for x in row] for row in mul(mul(trans(s), a), s)]
    assert schur == [[3, 2], [0, 1]]
    p = [[1, 1], [0, 1]]
    assert mul(a, p) == mul(p, [[1, 0], [0, 3]])
    assert mul(trans(a), a) != mul(a, trans(a))


def check_orthogonalization():
    a = [[1, 1], [0, 2]]
    u, v = [[1], [0]], [[1], [1]]
    w = sub(v, u)
    assert mul(a, u) == u
    assert mul(a, v) == [[2], [2]]
    assert mul(a, w) == [[1], [2]]  # Not parallel to w.
    b = [[2, 0, 0], [0, 2, 0], [0, 0, 3]]
    w = [[F(1, 2)], [F(-1, 2)], [0]]
    assert mul(b, w) == [[1], [-1], [0]]


# --------------------------------------------------------------------- #
# 多项式（系数列表，Fractions，低位在前；[] 表示零多项式）
# --------------------------------------------------------------------- #

def trim(p):
    while p and p[-1] == 0:
        p = p[:-1]
    return p


def padd(p, q):
    n = max(len(p), len(q))
    out = []
    for i in range(n):
        x = p[i] if i < len(p) else 0
        y = q[i] if i < len(q) else 0
        out.append(x+y)
    return trim(out)


def pneg(p):
    return [-x for x in p]


def pmul(p, q):
    if not p or not q:
        return []
    out = [0]*(len(p)+len(q)-1)
    for i, a in enumerate(p):
        for j, b in enumerate(q):
            out[i+j] += a*b
    return trim(out)


def peq(p, q):
    return trim(list(p)) == trim(list(q))


def pmul_mat(a, b):
    out = []
    for row in a:
        new = []
        for col in zip(*b):
            acc = []
            for x, y in zip(row, col):
                acc = padd(acc, pmul(x, y))
            new.append(acc)
        out.append(new)
    return out


def padd_mat(a, b):
    return [[padd(x, y) for x, y in zip(ar, br)] for ar, br in zip(a, b)]


def trace_of(a):
    out = []
    for i, row in enumerate(a):
        out = padd(out, row[i])
    return out


def check_projection_37e():
    a = [[1, 0], [1, 1], [0, 1]]           # columns (1,1,0) and (0,1,1)
    ata = mul(trans(a), a)
    assert ata == [[2, 1], [1, 2]]
    e = [[F(x, 3) for x in row] for row in [[2, 1, -1], [1, 2, 1], [-1, 1, 2]]]
    assert e == mul(mul(a, [[F(1, 3)*x for x in row] for row in [[2, -1], [-1, 2]]]), trans(a))
    assert e == trans(e)                    # Hermite
    assert mul(e, e) == e                   # idempotent
    assert mul(e, [[1], [1], [0]]) == [[1], [1], [0]]
    assert mul(e, [[0], [1], [1]]) == [[0], [1], [1]]
    b = [[1], [2], [3]]
    eb = mul(e, b)
    assert eb == [[F(1, 3)], [F(8, 3)], [F(7, 3)]]
    r = sub(b, eb)
    assert mul(trans(a), r) == [[0], [0]]   # residual orthogonal to columns


def check_least_squares_37f():
    a = [[1, 0], [1, 1], [0, 1]]
    b = [[1], [2], [3]]
    atb = mul(trans(a), b)
    assert atb == [[3], [5]]
    x = [[F(1, 3)], [F(7, 3)]]
    assert x == mul([[F(y, 3) for y in row] for row in [[2, -1], [-1, 2]]], atb)
    ax = mul(a, x)
    e = [[F(v, 3) for v in row] for row in [[2, 1, -1], [1, 2, 1], [-1, 1, 2]]]
    assert ax == mul(e, b)                  # fitted value equals the projection
    r = sub(b, ax)
    assert r == [[F(2, 3)], [F(-2, 3)], [F(2, 3)]]
    assert sum(v*v for row in r for v in row) == F(4, 3)   # ||r||^2 = 4/3


def check_projection_least_squares_c29():
    a = [[1, 0], [0, 1], [1, 1]]
    b = [[1], [1], [1]]
    e = [[F(x, 3) for x in row] for row in [[2, -1, 1], [-1, 2, 1], [1, 1, 2]]]
    assert e == mul(mul(a, [[F(x, 3) for x in row] for row in [[2, -1], [-1, 2]]]), trans(a))
    assert e == trans(e) and mul(e, e) == e
    assert sum(row[i] for i, row in enumerate(e)) == 2      # rank = trace = 2
    eb = mul(e, b)
    assert eb == [[F(2, 3)], [F(2, 3)], [F(4, 3)]]
    x = [[F(2, 3)], [F(2, 3)]]
    assert x == mul([[F(y, 3) for y in row] for row in [[2, -1], [-1, 2]]], mul(trans(a), b))
    assert mul(a, x) == eb
    r = sub(b, eb)
    assert mul(trans(a), r) == [[0], [0]]
    assert sum(v*v for row in r for v in row) == F(1, 3)   # ||r||^2 = 1/3


def check_lambda_inverses_38a_c30():
    lam = [0, 1]                            # the polynomial λ
    one = [1]
    zero = []
    # A(λ) = [[λ,1],[1,0]], det = -1 (nonzero constant) → invertible.
    a = [[lam, one], [one, zero]]
    inv = [[zero, one], [one, pneg(lam)]]
    ident = [[one, zero], [zero, one]]
    assert pmul_mat(a, inv) == ident and pmul_mat(inv, a) == ident
    # B(λ) = [[λ,1],[0,λ+1]], det = λ(λ+1) → not a constant, full rank only.
    d = [[lam, zero], [zero, padd(lam, one)]]
    det_d = pmul(lam, padd(lam, one))
    assert det_d == [0, 1, 1]               # λ²+λ, degree 2 → not invertible
    assert len(det_d) > 1                   # the “full rank ≠ invertible” gap
    # C(λ) = [[2,λ],[0,1]], det = 2 → invertible.
    c = [[[2], lam], [zero, one]]
    inv_c = [[[F(1, 2)], pmul([F(-1, 2)], lam)], [zero, one]]
    assert pmul_mat(c, inv_c) == ident and pmul_mat(inv_c, c) == ident
    # C30(b): B(λ) = [[1,λ,0],[0,2,1],[0,0,1]], det = 2.
    b3 = [[one, lam, zero], [zero, [2], one], [zero, zero, one]]
    inv_b3 = [[one, pmul([F(-1, 2)], lam), pmul([F(1, 2)], lam)],
              [zero, [F(1, 2)], [F(-1, 2)]],
              [zero, zero, one]]
    ident3 = [[one, zero, zero], [zero, one, zero], [zero, zero, one]]
    assert pmul_mat(b3, inv_b3) == ident3 and pmul_mat(inv_b3, b3) == ident3
    # C30(a): det [[λ,1,0],[0,λ,1],[1,0,λ]] = λ³+1.
    m = [[lam, one, zero], [zero, lam, one], [one, zero, lam]]
    det_m = padd(pmul(lam, pmul(lam, lam)), one)   # λ·λ·λ + 1·1·1 (cofactor signs +)
    assert det_m == [1, 0, 0, 1]


def check_lambda_elementary_chains_38c_c31():
    lam = [0, 1]
    one = [1]
    zero = []

    def row_add(m, i, j, f):
        m[i] = [padd(x, pmul(f, y)) for x, y in zip(m[i], m[j])]

    def col_add(m, i, j, f):
        for row in m:
            row[i] = padd(row[i], pmul(f, row[j]))

    m = [[lam, zero], [zero, padd(lam, one)]]
    row_add(m, 1, 0, one)                    # R2 += R1
    col_add(m, 0, 1, [-1])                   # C1 -= C2
    m[0], m[1] = m[1], m[0]                  # swap rows
    m[0] = [pneg(x) for x in m[0]]           # R1 *= -1
    col_add(m, 1, 0, padd(lam, one))         # C2 += (λ+1)·C1
    row_add(m, 1, 0, pneg(lam))              # R2 -= λ·R1
    assert m == [[one, zero], [zero, [0, 1, 1]]]   # diag(1, λ²+λ)

    m = [[lam, one], [one, lam]]
    m[0], m[1] = m[1], m[0]
    row_add(m, 1, 0, pneg(lam))
    col_add(m, 1, 0, pneg(lam))
    m[1] = [pneg(x) for x in m[1]]
    assert m == [[one, zero], [zero, [-1, 0, 1]]]  # diag(1, λ²-1)


def det_num(a):
    """Numeric determinant by Gaussian elimination over Fractions."""
    a = [[F(x) for x in row] for row in a]
    n = len(a)
    d = F(1)
    for col in range(n):
        pivot = next((i for i in range(col, n) if a[i][col]), None)
        if pivot is None:
            return F(0)
        if pivot != col:
            a[col], a[pivot] = a[pivot], a[col]
            d = -d
        d *= a[col][col]
        for i in range(col + 1, n):
            factor = a[i][col] / a[col][col]
            a[i] = [x - factor * y for x, y in zip(a[i], a[col])]
    return d


def pdivmod(a, b):
    """Exact division of univariate polynomials with Fractions; returns (q, r)."""
    a, b = trim(list(a)), trim(list(b))
    assert b, 'division by the zero polynomial'
    q = [F(0)] * max(1, len(a) - len(b) + 1)
    r = a[:]
    while trim(r) and len(r) >= len(b):
        c = r[-1] / b[-1]
        d = len(r) - len(b)
        q[d] = c
        for i, bi in enumerate(b):
            r[d + i] -= c * bi
        r = trim(r)
    return trim(q), r


def pmonic(p):
    p = trim(list(p))
    assert p, 'monic of the zero polynomial'
    return [x / p[-1] for x in p]


def pgcd(a, b):
    a, b = trim(list(a)), trim(list(b))
    if not b:
        return pmonic(a) if a else []
    while b:
        _, r = pdivmod(a, b)
        a, b = b, r
    return pmonic(a)


def det_poly(m):
    """Determinant of a polynomial matrix by cofactor expansion (small sizes only)."""
    n = len(m)
    if n == 1:
        return trim(list(m[0][0]))
    total = []
    for j in range(n):
        if not trim(m[0][j]):
            continue
        minor = [[m[i][k] for k in range(n) if k != j] for i in range(1, n)]
        term = pmul(m[0][j], det_poly(minor))
        total = padd(total, term if j % 2 == 0 else pneg(term))
    return trim(total)


def determinant_divisor(m, k):
    """k-th determinant divisor: monic gcd of all k-by-k minors."""
    from itertools import combinations
    n = len(m)
    g = None
    for rows in combinations(range(n), k):
        for cols in combinations(range(n), k):
            d = det_poly([[m[i][j] for j in cols] for i in rows])
            if trim(d):
                g = d if g is None else pgcd(g, d)
    assert g is not None, f'no nonzero {k}-minor'
    return pmonic(g)


def invariant_factors(m):
    """d_1 | ... | d_r from the determinant divisors D_k."""
    n = len(m)
    ds, prev = [], [1]
    for k in range(1, n + 1):
        D = determinant_divisor(m, k)
        q, r = pdivmod(D, prev)
        assert not r, f'D_{k-1} does not divide D_{k}'
        ds.append(pmonic(q))
        prev = D
    return ds


def char_matrix(a):
    """λI - A for a list-of-lists numeric matrix (coefficients low degree first)."""
    n = len(a)
    out = []
    for i in range(n):
        row = []
        for j in range(n):
            entry = [-F(a[i][j])] + ([F(1)] if i == j else [])
            row.append(trim(entry))
        out.append(row)
    return out


def check_smith_38d_self_test():
    """Example 3.8.D (λ,1,1)/(1,λ,1)/(1,1,λ) and the two self-test items."""
    lam, one, zero = [0, 1], [1], []
    m = [[lam, one, one], [one, lam, one], [one, one, lam]]
    assert peq(determinant_divisor(m, 1), [1])
    assert peq(determinant_divisor(m, 2), [-1, 1])            # λ-1
    assert peq(determinant_divisor(m, 3), [2, -3, 0, 1])      # λ³-3λ+2
    ds = invariant_factors(m)
    assert peq(ds[0], [1])
    assert peq(ds[1], [-1, 1])
    assert peq(ds[2], [-2, 1, 1])                             # (λ-1)(λ+2) = λ²+λ-2
    assert peq(pmul(pmul(ds[0], ds[1]), ds[2]), determinant_divisor(m, 3))
    # Char poly of the underlying A₀ = [[0,-1,-1],[-1,0,-1],[-1,-1,0]].
    a0 = [[0, -1, -1], [-1, 0, -1], [-1, -1, 0]]
    assert peq(det_poly(char_matrix(a0)), [2, -3, 0, 1])

    # Self-test 2: diag(λ², λ(λ+1), (λ+1)²) is NOT in Smith form.
    p = padd(lam, one)
    m2 = [[pmul(lam, lam), zero, zero],
          [zero, pmul(lam, p), zero],
          [zero, zero, pmul(p, p)]]
    assert peq(determinant_divisor(m2, 1), [1])
    assert peq(determinant_divisor(m2, 2), [0, 1, 1])          # λ²+λ
    ds2 = invariant_factors(m2)
    assert peq(ds2[0], [1])
    assert peq(ds2[1], [0, 1, 1])
    assert peq(ds2[2], [0, 0, 1, 2, 1])                        # λ²(λ+1)²

    # Self-test 3: diag(1,1,λ-2,(λ-2)²(λ+3)) already satisfies the divisibility chain.
    q = padd(lam, [3])
    m3 = [[one, zero, zero, zero],
          [zero, one, zero, zero],
          [zero, zero, [-2, 1], zero],
          [zero, zero, zero, pmul(pmul([-2, 1], [-2, 1]), q)]]
    ds3 = invariant_factors(m3)
    assert peq(ds3[0], [1]) and peq(ds3[1], [1])
    assert peq(ds3[2], [-2, 1])
    assert peq(ds3[3], pmul(pmul([-2, 1], [-2, 1]), q))
    # ∏d_i must reproduce the determinant D₄ = (λ-2)³(λ+3).
    assert peq(pmul(pmul(pmul(ds3[0], ds3[1]), ds3[2]), ds3[3]),
               determinant_divisor(m3, 4))


def check_smith_38e_diagonal_not_smith():
    """Example 3.8.E: diag(λ-1, (λ-1)(λ-2), (λ-2)²) is diagonal but not Smith."""
    lam, one, zero = [0, 1], [1], []
    a, b = [-1, 1], [-2, 1]                                  # λ-1, λ-2
    m = [[a, zero, zero],
         [zero, pmul(a, b), zero],
         [zero, zero, pmul(b, b)]]
    assert peq(determinant_divisor(m, 1), [1])
    assert peq(determinant_divisor(m, 2), pmul(a, b))
    ds = invariant_factors(m)
    assert peq(ds[0], [1])
    assert peq(ds[1], pmul(a, b))
    assert peq(ds[2], pmul(a, pmul(b, b)))                    # (λ-1)(λ-2)²
    assert peq(pmul(pmul(ds[1], ds[2]), ds[0]), determinant_divisor(m, 3))


def check_jordan_38f_rank_formula():
    """Example 3.8.F: A = [[2,1,1,0],[0,2,0,1],[0,0,2,1],[0,0,0,2]]."""
    a = [[2, 1, 1, 0], [0, 2, 0, 1], [0, 0, 2, 1], [0, 0, 0, 2]]
    n = 4
    mm = char_matrix(a)
    ds = invariant_factors(mm)
    assert peq(ds[0], [1]) and peq(ds[1], [1])
    assert peq(ds[2], [-2, 1])                                # λ-2
    assert peq(ds[3], [-8, 12, -6, 1])                        # (λ-2)³
    # Rank formula: n_k = dim N((A-2I)^k).
    n_mat = [[a[i][j] - (2 if i == j else 0) for j in range(n)] for i in range(n)]
    ranks = []
    power = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
    for _ in range(3):
        power = mul(power, n_mat)
        ranks.append(rank(power))
    assert ranks == [2, 1, 0], ranks
    nk = [n - r for r in ranks]
    assert nk == [2, 3, 4]
    blocks = [nk[0], nk[1] - nk[0], nk[2] - nk[1]]
    assert blocks == [2, 1, 1]                                # #blocks, #≥2, #≥3
    # Transition matrix from the docstring.
    p = [[1, 0, 0, 0],
         [0, F(1, 2), F(-1, 2), 1],
         [0, F(1, 2), F(1, 2), -1],
         [0, 0, F(1, 2), 0]]
    j = [[2, 1, 0, 0], [0, 2, 1, 0], [0, 0, 2, 0], [0, 0, 0, 2]]
    assert mul(a, p) == mul(p, j)
    assert det_num(p) == F(1, 2)


def check_jordan_3812_transition():
    """Example 3.8.12: A ~ J with the printed P, and the chain condition."""
    a = [[-1, -2, 6], [-1, 0, 3], [-1, -1, 4]]
    p = [[3, 2, -1], [0, 1, 0], [1, 1, 0]]
    j = [[1, 0, 0], [0, 1, 1], [0, 0, 1]]
    assert mul(a, p) == mul(p, j)
    assert det_num(p) == 1
    # p2 must lie in R(A-I) ∩ N(A-I); the first guess [0,3,1] does not.
    a_minus_i = [[a[i][j] - (1 if i == j else 0) for j in range(3)] for i in range(3)]
    assert rank(a_minus_i) == 1
    assert mul(a_minus_i, [[2], [1], [1]]) == [[0], [0], [0]]   # in the kernel
    assert mul(a_minus_i, [[0], [3], [1]]) == [[0], [0], [0]]   # also in the kernel
    # [0,3,1] is NOT in the column space: the system (A-I)x = [0,3,1] is inconsistent.
    aug = [row[:] + [rhs] for row, rhs in zip(a_minus_i, [0, 3, 1])]
    assert rank(a_minus_i) < rank(aug)
    # [2,1,1] IS in the column space (it is the generator of R(A-I)).
    aug2 = [row[:] + [rhs] for row, rhs in zip(a_minus_i, [2, 1, 1])]
    assert rank(a_minus_i) == rank(aug2)


def check_jordan_38g_powers_exponential():
    """Example 3.8.G: A = J₃(2); closed forms for A^m and exp(At)."""
    a = [[2, 1, 0], [0, 2, 1], [0, 0, 2]]
    n_mat = [[0, 1, 0], [0, 0, 1], [0, 0, 0]]
    assert mul(n_mat, n_mat) == [[0, 0, 1], [0, 0, 0], [0, 0, 0]]
    assert mul(mul(n_mat, n_mat), n_mat) == [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
    # Iterate A^m and compare with 2^m, m·2^(m-1), C(m,2)·2^(m-2).
    power = [[1 if i == j else 0 for j in range(3)] for i in range(3)]
    for m in range(1, 8):
        power = mul(power, a)
        second = F(m) * F(2) ** (m - 1)
        third = F(m * (m - 1), 2) * F(2) ** (m - 2) if m >= 2 else F(0)
        expected = [[F(2) ** m, second, third],
                    [F(0), F(2) ** m, second],
                    [F(0), F(0), F(2) ** m]]
        assert power == expected, (m, power, expected)


def check_frobenius_minpoly_3813():
    """Example 3.8.13: two Jordan blocks give m_A = (λ-3)³, not (λ-3)⁴."""
    a = [[3, 0, 0, 0],
         [0, 3, 1, 0],
         [0, 0, 3, 1],
         [0, 0, 0, 3]]
    ds = invariant_factors(char_matrix(a))
    assert peq(ds[0], [1]) and peq(ds[1], [1])
    assert peq(ds[2], [-3, 1])
    assert peq(ds[3], [-27, 27, -9, 1])                       # (λ-3)³
    # (A-3I)³ = O but (A-3I)² ≠ O.
    n_mat = [[a[i][j] - (3 if i == j else 0) for j in range(4)] for i in range(4)]
    sq = mul(n_mat, n_mat)
    assert sq != [[0] * 4 for _ in range(4)]
    assert mul(sq, n_mat) == [[0] * 4 for _ in range(4)]


def check_direct_sum_38f_lemma():
    """Block-diagonal lemma used in the Jordan existence proof.

    (a) The cross terms in D_k(diag(B1,B2)) = gcd_{i+j=k}(D_i D_j) cannot be
        dropped: diag(1,λ,λ,1) has D_2 = 1, while both blocks have D_2 = λ.
    (b) Elementary divisors of a direct sum are the multiset union: the
        invariant-factor exponents are the ascending merge of the two lists.
    """
    lam, one, zero = [0, 1], [1], []

    # (a) counterexample to the "gcd(D_k, D_k) is enough" shortcut
    mixed = [[one, zero, zero, zero],
             [zero, lam, zero, zero],
             [zero, zero, lam, zero],
             [zero, zero, zero, one]]
    assert peq(determinant_divisor(mixed, 2), [1])
    ds = invariant_factors(mixed)
    assert [peq(d, x) for d, x in zip(ds, [one, one, lam, lam])] == [True] * 4

    # (b) diag(λ, λ³) ⊕ [λ²]  →  invariants 1, λ, λ², λ³
    p2 = pmul(lam, lam)
    p3 = pmul(p2, lam)
    b1 = [[lam, zero, zero], [zero, p3, zero], [zero, zero, one]]
    direct = [row + [zero] for row in b1] + [[zero, zero, zero, p2]]
    got = invariant_factors(direct)
    want = [one, lam, p2, p3]
    assert all(peq(g, w) for g, w in zip(got, want))
    # D_k exponents are the running sums 0, 1, 3, 6 of the ascending merge;
    # the determinant is λ·λ³·1·λ² = λ⁶.
    Ds = [determinant_divisor(direct, k) for k in range(1, 5)]
    assert peq(Ds[0], one)
    assert peq(Ds[1], lam)
    assert peq(Ds[2], p3)
    assert peq(Ds[3], pmul(pmul(lam, p3), p2))



def check_ch04_norms():
    """第四章 4.1–4.3 的数值与结构核对（精确有理数算术）。"""
    # 例 4.3.2：列和、行和、Frobenius 与 A^HA 的特征值 5, 3, 15
    a = [[2, -1, 0], [0, 2, 3], [1, 2, 0]]
    assert [sum(abs(a[i][j]) for i in range(3)) for j in range(3)] == [3, 5, 3]
    assert [sum(abs(x) for x in row) for row in a] == [3, 5, 3]
    assert sum(x * x for row in a for x in row) == 23
    ata = mul(trans(a), a)
    assert ata == [[5, 0, 0], [0, 9, 6], [0, 6, 9]]
    assert 5 + 3 + 15 == sum(ata[i][i] for i in range(3))          # tr = 23
    assert 5 * 3 + 5 * 15 + 3 * 15 == 135                          # 二阶主子式和
    assert 5 * 3 * 15 == 5 * (9 * 9 - 6 * 6)                       # det = 225

    # 例 4.3.A：A = [[1,1],[0,1]]，A^TA 的特征值 (3 ± √5)/2，F 范数 √3
    b = [[1, 1], [0, 1]]
    assert mul(trans(b), b) == [[1, 1], [1, 2]]
    assert sum(x * x for row in b for x in row) == 3
    # λ = (3+√5)/2 满足 λ² − 3λ + 1 = 0；σ_max² = (3+√5)/2 > 0
    assert 3 * 3 - 4 * 1 == 5

    # 例 4.2.C：P^{-1}AP = [[1,1],[0,1]]（P = diag(10,1)）
    p = [[10, 0], [0, 1]]
    pinv = [[F(1, 10), 0], [0, 1]]
    c = [[1, 10], [0, 1]]
    assert mul(mul(pinv, c), p) == [[1, 1], [0, 1]]

    # 例 4.3.C：A+E 的迹 4、行列式 11/4，特征值 (4 ± √5)/2
    a2 = [[3, 0], [0, 1]]
    e = [[0, F(1, 2)], [F(1, 2), 0]]
    a4 = [[a2[i][j] + e[i][j] for j in range(2)] for i in range(2)]
    assert a4 == [[3, F(1, 2)], [F(1, 2), 1]]
    assert sum(a4[i][i] for i in range(2)) == 4
    assert a4[0][0] * a4[1][1] - a4[0][1] * a4[1][0] == F(11, 4)

    # 例 4.3.B / 习题 C9：Rayleigh 商在三个点上的读数
    for mat, want in (
        ([[2, 1], [1, 2]], [F(2), F(3), F(1)]),
        ([[4, 1], [1, 4]], [F(4), F(5), F(3)]),
    ):
        pts = ([1, 0], [1, 1], [1, -1])
        for x, w in zip(pts, want):
            num = sum(x[i] * mat[i][j] * x[j] for i in range(2) for j in range(2))
            den = sum(v * v for v in x)
            assert F(num, den) == w

    # 习题 C8：A = [[0,1/4],[1/4,0]] 的 (I−A)^{-1} 与行和 4/3
    inv = [[F(16, 15), F(4, 15)], [F(4, 15), F(16, 15)]]
    ima = [[F(1), F(-1, 4)], [F(-1, 4), F(1)]]
    assert mul(ima, inv) == [[1, 0], [0, 1]]
    assert sum(inv[0]) == F(4, 3)

    # 习题 A9：全 1 矩阵的两个反例
    a23 = [[1, 1, 1], [1, 1, 1]]
    # 2×3 全 1：A^TA = 2J_3（每列 2 个 1），λmax = 6，‖A‖₂ = √6 > ‖A‖₁ = 2
    assert mul(trans(a23), a23) == [[2, 2, 2], [2, 2, 2], [2, 2, 2]]
    assert 2 * 3 == 6
    a32 = [[1, 1], [1, 1], [1, 1]]
    assert mul(trans(a32), a32) == [[3, 3], [3, 3]]
    assert 3 * 2 == 6

    # 习题 C6：A = [[1,2],[3,4]]，A^TA = [[10,14],[14,20]]，特征值 15 ± √221
    c6 = [[1, 2], [3, 4]]
    assert mul(trans(c6), c6) == [[10, 14], [14, 20]]
    assert 10 + 20 == 30 and 10 * 20 - 14 * 14 == 4


# ---------------------------------------------------------------- 第四章 4.5–4.6

def _mat_vec(a, x):
    return [sum(ai * xi for ai, xi in zip(row, x)) for row in a]


def _char_poly(a):
    """Faddeev–LeVerrier：返回 [1, c_1, ..., c_n]（Fraction），即 λⁿ + c_1λⁿ⁻¹ + … + c_n。

    M_1 = I,  c_1 = -tr(A);
    M_k = A·M_{k-1} + c_{k-1}·I,  c_k = -(1/k)·tr(A·M_k).
    """
    n = len(a)
    c = -sum(a[i][i] for i in range(n))
    coef = [F(1), c]
    m = [[F(1) if i == j else F(0) for j in range(n)] for i in range(n)]   # M_1
    for k in range(2, n + 1):
        am = mul(a, m)
        m = [[am[i][j] + (c if i == j else 0) for j in range(n)] for i in range(n)]   # M_k
        am = mul(a, m)
        c = -sum(am[i][i] for i in range(n)) / k
        coef.append(c)
    return coef


def _poly_eval(coef, z):
    """Horner，z 允许复数。"""
    out = 0j
    for c in coef:
        out = out * z + complex(c)
    return out


def _roots(coef, iters=400):
    """Durand–Kerner 迭代求全部复根（独立于 matplotlib/numpy）。"""
    n = len(coef) - 1
    lead = complex(coef[0])
    roots = [complex(0.4, 0.9) ** k for k in range(n)]
    for _ in range(iters):
        new = []
        for i in range(n):
            num = _poly_eval(coef, roots[i]) / lead
            den = 1 + 0j
            for j in range(n):
                if i != j:
                    den *= (roots[i] - roots[j])
            if abs(den) < 1e-14:
                den = 1e-14 + 0j
            new.append(roots[i] - num / den)
        roots = new
    return roots


def _eigvals(a):
    return _roots(_char_poly(a))


def _gershgorin(a):
    """返回 [(圆心, 半径)]（按行）。"""
    n = len(a)
    out = []
    for i in range(n):
        rad = sum(abs(a[i][j]) for j in range(n) if j != i)
        out.append((complex(a[i][i]), rad))
    return out


def check_ch04_spectral_radius_and_disks():
    # 例 4.5.2：谱半径与四个范数
    a2 = [[F(1), F(2)], [F(2), F(2)]]
    coef2 = _char_poly(a2)
    assert coef2 == [F(1), F(-3), F(-2)], coef2   # λ² − 3λ − 2
    ev2 = _eigvals(a2)
    rho2 = max(abs(z) for z in ev2)
    # (3 + √17)/2 ≈ 3.5616
    assert abs(rho2 - (3 + 17 ** 0.5) / 2) < 1e-9

    # 例 4.5.3：三个圆盘两两不相交，每个特征值各在一个盘内
    a3 = [[1, 0.02, 0.11], [0.01, 1j, 0.14], [0.02, 0.01, 0.5]]
    disks3 = _gershgorin(a3)
    assert [round(r, 10) for _, r in disks3] == [0.13, 0.15, 0.03]
    # 圆盘两两分离
    for i in range(3):
        for j in range(i + 1, 3):
            ci, ri = disks3[i]
            cj, rj = disks3[j]
            assert abs(ci - cj) > ri + rj - 1e-12, (i, j)

    # 例 4.5.5：一个圆盘空着、一个装两个（ρ = 0.6，特征值 0.5 ± 0.3317i）
    a5 = [[F(0), F(-4, 10)], [F(9, 10), F(1)]]
    coef5 = _char_poly(a5)
    assert coef5 == [F(1), F(-1), F(36, 100)], coef5   # λ² − λ + 0.36
    ev5 = _eigvals(a5)
    for z in ev5:
        assert abs(abs(z) - 0.6) < 1e-9, z
        assert abs(z) > F(4, 10)          # 不在 G₁
        assert abs(z - 1) <= F(9, 10)     # 在 G₂

    # 例 4.5.7：G₄ = [0,2] 孤立；实系数 ⇒ 实根成对，故至少 2 个实特征值
    a7 = [[9, 1, -2, 1], [0, 8, 1, 1], [-1, 0, 4, 0], [1, 0, 0, 1]]
    disks7 = _gershgorin(a7)
    assert [r for _, r in disks7] == [4, 2, 1, 1]
    ev7 = _eigvals(a7)
    assert all(abs(z.imag) < 1e-8 for z in ev7), ev7     # 四个全实
    assert sum(1 for z in ev7 if abs(z - 1) <= 1) == 1    # G₄ 里恰一个

    # 例 4.5.6：n 阶矩阵的圆盘两两不相交（取 n = 5 验证）
    n = 5
    a6 = [[F(2 * (i + 1)) if i == j else F(1, n) for j in range(n)] for i in range(n)]
    disks6 = _gershgorin(a6)
    for i in range(n):
        for j in range(i + 1, n):
            assert abs(disks6[i][0] - disks6[j][0]) > disks6[i][1] + disks6[j][1]

    # 例 4.5.8：D = diag(2,1,1) 把三个圆盘分开
    a8 = [[9, 1, 1], [1, 1j, 1], [1, 1, 3]]
    d8 = [2, 1, 1]
    b8 = [[a8[i][j] * F(d8[i], d8[j]) for j in range(3)] for i in range(3)]
    disks8 = _gershgorin(b8)
    assert [r for _, r in disks8] == [4, F(3, 2), F(3, 2)]
    for i in range(3):
        for j in range(i + 1, 3):
            assert abs(disks8[i][0] - disks8[j][0]) > disks8[i][1] + disks8[j][1] - 1e-12

    # 例 4.5.A：ρ = 0.1 而 ‖A‖₁ = ‖A‖∞ = 1.1；定理 4.5.2 的构造给出 0.11
    fa = [[F(1, 10), F(1)], [F(0), F(1, 10)]]      # 超对角 1 的 2 阶 Jordan 块
    assert _char_poly(fa) == [F(1), F(-1, 5), F(1, 100)]
    shifted = sub(fa, [[F(1, 10), F(0)], [F(0), F(1, 10)]])
    assert shifted != [[0, 0], [0, 0]]
    assert mul(shifted, shifted) == [[0, 0], [0, 0]]
    assert max(sum(abs(v) for v in row) for row in fa) == F(11, 10)          # ‖·‖∞
    assert max(sum(abs(fa[i][j]) for i in range(2)) for j in range(2)) == F(11, 10)   # ‖·‖₁
    # Q = diag(1, 1/ε) → 超对角元乘 ε
    q = [[F(1), F(0)], [F(0), F(1, 100)]]
    qinv = [[F(1), F(0)], [F(0), F(100)]]
    sas = mul(mul(qinv, fa), q)
    assert sas == [[F(1, 10), F(1, 100)], [F(0), F(1, 10)]], sas
    assert max(sum(abs(sas[i][j]) for i in range(2)) for j in range(2)) == F(11, 100)
    # A^k 的 (1,2) 元 = k·0.1^(k-1) > 0.1^k，故下确界取不到
    for k in (1, 5, 10):
        assert k * F(1, 10) ** (k - 1) > F(1, 10) ** k



def check_ch04_series():
    """4.6 的级数算例：部分和、Neumann 截断、边界发散。"""

    def mat_pow(a, k):
        n = len(a)
        out = [[F(1) if i == j else F(0) for j in range(n)] for i in range(n)]
        for _ in range(k):
            out = mul(out, a)
        return out

    # 例 4.6.4：对角元 1/(k(k+1)) 与 2k/3^k，和分别为 1 与 3/2
    s1 = sum(F(1, k * (k + 1)) for k in range(1, 4000))
    assert abs(float(s1) - 1) < 2e-3, s1
    s2 = sum(F(2 * k, 3 ** k) for k in range(1, 60))
    assert abs(float(s2) - F(3, 2)) < 1e-12, float(s2)

    # 例 4.6.7：A = [[-1,1],[0,-1]]，Σ A^k/k 的 (1,2) 元通项是 (-1)^(k-1)，不趋于零
    for k in (1, 2, 3, 4, 11, 12):
        assert abs((-1) ** (k - 1)) == 1      # 通项不趋于零 ⇒ 级数发散

    # 例 4.6.9：3×3 矩阵 ρ ≈ 0.8390 < 1，Neumann 级数收敛
    b = [[F(2, 10), F(5, 10), F(2, 10)],
         [F(1, 10), F(5, 10), F(3, 10)],
         [F(1, 10), F(4, 10), F(2, 10)]]
    coef = _char_poly(b)
    assert coef == [F(1), F(-9, 10), F(5, 100), F(1, 1000)], coef   # λ³ − 0.9λ² + 0.05λ + 0.001
    ev = _eigvals(b)
    rho = max(abs(z) for z in ev)
    assert abs(rho - 0.83898339) < 1e-6, rho
    # 行和都 < 1 ⇒ ‖B‖∞ = 0.9
    assert max(sum(row) for row in b) == F(9, 10)

    # 习题 C12：A 的 ρ = 0.5，谱半径决定衰减率
    c = [[F(2, 10), F(3, 10)], [F(1, 10), F(4, 10)]]
    assert _char_poly(c) == [F(1), F(-6, 10), F(5, 100)]            # λ² − 0.6λ + 0.05
    ev_c = sorted(abs(z) for z in _eigvals(c))
    assert abs(ev_c[0] - 0.1) < 1e-9 and abs(ev_c[1] - 0.5) < 1e-9, ev_c

    # 习题 C11(a)：Σ A^m/2^m 的和 = [[2,4],[0,2]]，直接由 Neumann 级数算
    a11 = [[F(1), F(2)], [F(0), F(1)]]
    half = [[x / 2 for x in row] for row in a11]
    # (I − A/2)^-1
    i_minus = [[F(1) - half[0][0], -half[0][1]], [-half[1][0], F(1) - half[1][1]]]
    det = i_minus[0][0] * i_minus[1][1] - i_minus[0][1] * i_minus[1][0]
    assert det == F(1, 4), det
    inv = [[i_minus[1][1] / det, -i_minus[0][1] / det],
           [-i_minus[1][0] / det, i_minus[0][0] / det]]
    assert inv == [[F(2), F(4)], [F(0), F(2)]], inv

    # 习题 C8/C12 型：‖A‖∞ = 0.5 时截断误差界取等
    a = [[F(0), F(1, 2)], [F(1, 2), F(0)]]
    s3 = [[F(0)] * 2 for _ in range(2)]
    for m in range(4):
        pm = mat_pow(a, m)
        s3 = [[s3[i][j] + pm[i][j] for j in range(2)] for i in range(2)]
    assert s3 == [[F(5, 4), F(5, 8)], [F(5, 8), F(5, 4)]], s3
    inv_a = [[F(4, 3), F(2, 3)], [F(2, 3), F(4, 3)]]
    err = [[inv_a[i][j] - s3[i][j] for j in range(2)] for i in range(2)]
    assert err == [[F(1, 12), F(1, 24)], [F(1, 24), F(1, 12)]], err
    assert max(sum(abs(v) for v in row) for row in err) == F(1, 8)     # 界 0.5^4/0.5 = 1/8


def check_ch04_review_2026_11_03():
    """复核记录 R1–R4：把曾写错的数值钉成断言，防止回退。"""
    # R1：例 4.5.5 的 ∞-范数与 1-范数
    a = [[F(0), F(-2, 5)], [F(9, 10), F(1)]]
    rows = [abs(a[i][0]) + abs(a[i][1]) for i in range(2)]
    cols = [abs(a[0][j]) + abs(a[1][j]) for j in range(2)]
    assert rows == [F(2, 5), F(19, 10)], rows          # 0.4 与 1.9
    assert max(rows) == F(19, 10)                      # ‖A‖∞ = 1.9（不是 2.3）
    assert cols == [F(9, 10), F(7, 5)], cols           # 0.9 与 1.4
    assert max(cols) == F(7, 5)                        # ‖A‖₁ = 1.4

    # R2：习题 C10 的特征值（曾误写为 5.372/4.372/−4.745）
    c10 = [[4, 1, 1], [1, 4, 1], [1, 1, -3]]
    ev = sorted(z.real for z in _eigvals(c10))
    assert abs(ev[0] - (-3.24264)) < 1e-4, ev
    assert abs(ev[1] - 3.0) < 1e-6, ev
    assert abs(ev[2] - 5.24264) < 1e-4, ev
    # 谱半径与范数界：6 偏松约 14%
    assert abs((6 - ev[2]) / ev[2] - 0.14446) < 1e-3

    # R3：习题 C12 的误差矩阵：1-范数是列和最大 ≈ 0.0937，∞-范数恰为 1/16
    a12 = [[F(1, 5), F(3, 10)], [F(1, 10), F(2, 5)]]
    s4 = [[F(0), F(0)], [F(0), F(0)]]
    pw = [[F(1), F(0)], [F(0), F(1)]]
    for _ in range(5):
        s4 = [[s4[i][j] + pw[i][j] for j in range(2)] for i in range(2)]
        pw = mul(pw, a12)
    assert s4[1][1] == F(17309, 10000), s4      # 1.7309（不是 1.7369）
    inv = [[F(4, 3), F(2, 3)], [F(2, 9), F(16, 9)]]
    err = [[inv[i][j] - s4[i][j] for j in range(2)] for i in range(2)]
    inf_n = max(sum(abs(v) for v in row) for row in err)
    one_n = max(sum(abs(err[i][j]) for i in range(2)) for j in range(2))
    assert inf_n == F(1, 16), inf_n              # 0.0625 恰好取等
    assert abs(float(one_n) - 0.093744) < 1e-5, float(one_n)

    # R4：自测卷二第 11 题的 S3 的 (2,2) 元
    a11m = [[F(3, 10), F(4, 10)], [F(2, 10), F(1, 10)]]
    s3 = [[F(0), F(0)], [F(0), F(0)]]
    pw = [[F(1), F(0)], [F(0), F(1)]]
    for _ in range(4):
        s3 = [[s3[i][j] + pw[i][j] for j in range(2)] for i in range(2)]
        pw = mul(pw, a11m)
    assert s3[1][1] == F(1231, 1000), s3          # 1.231（不是 1.241）

def check_proof_basis_and_projectors():
    identity = [[1, 0], [0, 1]]
    zero = [[0, 0], [0, 0]]
    matrix = [[2, 1], [0, 3]]
    projectors = [
        sub([[3, 0], [0, 3]], matrix),
        sub(matrix, [[2, 0], [0, 2]]),
    ]
    assert sub(identity, projectors[0]) == projectors[1]
    assert mul(projectors[0], projectors[1]) == zero
    assert mul(projectors[1], projectors[0]) == zero
    for eigenvalue, projector in zip((2, 3), projectors):
        assert mul(projector, projector) == projector
        assert mul(matrix, projector) == [
            [eigenvalue * entry for entry in row] for row in projector
        ]
    transform = [[1, 1, 0], [0, 0, 1]]
    adapted_basis = [[1, 0, 0], [-1, 1, 0], [0, 0, 1]]
    images = mul(transform, adapted_basis)
    assert rank(adapted_basis) == 3
    assert images == [[0, 1, 0], [0, 0, 1]]
    assert rank([row[1:] for row in images]) == 2
    assert 3 - rank(transform) == 1


def check_smith_descent_proof():
    polynomial = [F(0), F(1)]
    next_polynomial = [F(1), F(1)]
    quotient, remainder = pdivmod(next_polynomial, polynomial)
    assert quotient == [1] and remainder == [1]
    assert len(remainder) < len(polynomial)
    diagonal = [[polynomial, []], [[], next_polynomial]]
    row_added = [[polynomial, next_polynomial], [[], next_polynomial]]
    column_reduced = [[polynomial, remainder], [[], next_polynomial]]
    column_swapped = [[remainder, polynomial], [next_polynomial, []]]
    row_cleared = [
        [remainder, polynomial],
        [[], pneg(pmul(next_polynomial, polynomial))],
    ]
    for stage in (diagonal, row_added, column_reduced, column_swapped, row_cleared):
        factors = invariant_factors(stage)
        assert peq(factors[0], [1])
        assert peq(factors[1], [0, 1, 1])


def check_neumann_proof_boundaries():
    identity = [[F(1), F(0)], [F(0), F(1)]]
    zero = [[F(0), F(0)], [F(0), F(0)]]
    matrix = [[F(1, 10), F(0)], [F(1), F(1, 10)]]
    norms = []
    for exponent in range(1, 11):
        power = identity
        for _ in range(exponent):
            power = mul(power, matrix)
        expected = F(1, 10) ** exponent + exponent * F(1, 10) ** (exponent - 1)
        assert max(sum(abs(entry) for entry in row) for row in power) == expected
        norms.append(expected)
    assert norms[:3] == [F(11, 10), F(21, 100), F(31, 1000)]
    assert all(after < before for before, after in zip(norms, norms[1:]))
    for matrix in (
        [[F(0), F(1)], [F(0), F(0)]],
        [[F(1, 2), F(1)], [F(0), F(1, 2)]],
        identity,
        [[F(2), F(0)], [F(0), F(2)]],
    ):
        partial_sum = zero
        power = identity
        for _ in range(8):
            partial_sum = [
                [left + right for left, right in zip(sum_row, power_row)]
                for sum_row, power_row in zip(partial_sum, power)
            ]
            power = mul(power, matrix)
            assert mul(sub(identity, matrix), partial_sum) == sub(identity, power)
            assert mul(partial_sum, sub(identity, matrix)) == sub(identity, power)
    nilpotent = [[0, 1], [0, 0]]
    assert mul(nilpotent, nilpotent) == zero
    assert sub(identity, [[2, 0], [0, 2]]) == [[-1, 0], [0, -1]]


if __name__ == '__main__':
    checks = (
        check_parameter_eigenspaces, check_schur_basis, check_orthogonalization,
        check_projection_37e, check_least_squares_37f, check_projection_least_squares_c29,
        check_lambda_inverses_38a_c30, check_lambda_elementary_chains_38c_c31,
        check_smith_38d_self_test, check_smith_38e_diagonal_not_smith,
        check_jordan_38f_rank_formula, check_jordan_3812_transition,
        check_jordan_38g_powers_exponential, check_frobenius_minpoly_3813,
        check_direct_sum_38f_lemma, check_ch04_norms,
        check_ch04_spectral_radius_and_disks, check_ch04_series,
        check_ch04_review_2026_11_03,
        check_proof_basis_and_projectors, check_smith_descent_proof,
        check_neumann_proof_boundaries,
    )
    for check in checks:
        check()
        print('PASS', check.__name__)
    print(f'{len(checks)} example groups passed (exact algebra and numerical checks); no external dependencies.')

