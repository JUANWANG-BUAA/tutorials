#!/usr/bin/env python3
"""Exact checks for selected teaching examples; standard library only.
Run: python3 matrix/tools/verify_teaching_examples.py
Scope: ch02/sec24 parameter eigenspaces, ch03/sec35 Schur basis,
ch03/sec36 Gram–Schmidt, ch03/sec37 orthogonal projection & least squares
(examples 3.7.E / 3.7.F, exercise C29), ch03/sec38 lambda-matrix inverses
and elementary-transformation chains (examples 3.8.A–3.8.C, exercises
C30/C31, polynomial coefficients as exact Fractions). This does not prove
the general spectral theorems.
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


if __name__ == '__main__':
    checks = (
        check_parameter_eigenspaces, check_schur_basis, check_orthogonalization,
        check_projection_37e, check_least_squares_37f, check_projection_least_squares_c29,
        check_lambda_inverses_38a_c30, check_lambda_elementary_chains_38c_c31,
        check_smith_38d_self_test, check_smith_38e_diagonal_not_smith,
        check_jordan_38f_rank_formula, check_jordan_3812_transition,
        check_jordan_38g_powers_exponential, check_frobenius_minpoly_3813,
        check_direct_sum_38f_lemma,
    )
    for check in checks:
        check()
        print('PASS', check.__name__)
    print(f'{len(checks)} exact example groups passed; no external dependencies.')

