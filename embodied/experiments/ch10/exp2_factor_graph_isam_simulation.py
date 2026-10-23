# -*- coding: utf-8 -*-
"""实验 10.2：因子图消元顺序与填入元（Fill-in）分析。

两个对照：
  A. 6 顶点环图（5 条里程计边 + 1 条回环边）——环图上任意顶点消元的填入元相同，
     自然顺序与逆序给出同一结果，用来说明"顺序总有用"是错的。
  B. 5×5 网格图——变量按行优先编号时，自然顺序与逆 Cuthill–McKee（RCM）
     重排序的填入元显著不同，用来说明顺序在二维拓扑上才真正重要。
"""

import numpy as np
from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import reverse_cuthill_mckee


def symbolic_fill_in(H: np.ndarray) -> int:
    """对对称稀疏结构做符号 Cholesky，统计结构外新增的非零元个数。

    只关心是否存在非零，不关心数值；对正定矩阵，符号消元与数值 Cholesky
    的填充位置完全一致。
    """
    n = H.shape[0]
    A = (np.abs(H) > 1e-12).astype(np.int8)
    A = np.tril(A, -1) + np.tril(A, -1).T          # 对称化，忽略对角
    L = A.copy()
    fill = 0
    for k in range(n):
        rows = np.flatnonzero(L[k + 1:, k]) + k + 1
        for ii, i in enumerate(rows):
            for j in rows[ii + 1:]:
                if L[i, j] == 0:
                    L[i, j] = L[j, i] = 1
                    fill += 1
    return fill


def ring_graph(n: int = 6) -> np.ndarray:
    """链式里程计边 + 一条 (0, n-1) 回环边。"""
    H = np.zeros((n, n))
    for i in range(n - 1):
        H[i, i] += 2.0
        H[i + 1, i + 1] += 2.0
        H[i, i + 1] -= 1.0
        H[i + 1, i] -= 1.0
    H[0, 0] += 2.0
    H[n - 1, n - 1] += 2.0
    H[0, n - 1] -= 1.0
    H[n - 1, 0] -= 1.0
    return H + np.eye(n)


def grid_graph(side: int = 5) -> np.ndarray:
    """side×side 关键帧网格：每个格子与右、下邻居各有一条里程计因子。"""
    n = side * side
    H = np.zeros((n, n))
    idx = lambda r, c: r * side + c
    for r in range(side):
        for c in range(side):
            for dr, dc in ((0, 1), (1, 0)):
                rr, cc = r + dr, c + dc
                if rr < side and cc < side:
                    i, j = idx(r, c), idx(rr, cc)
                    H[i, i] += 2.0
                    H[j, j] += 2.0
                    H[i, j] -= 1.0
                    H[j, i] -= 1.0
    return H + np.eye(n)


def report(name: str, H: np.ndarray, perm: np.ndarray) -> None:
    natural = symbolic_fill_in(H)
    reordered = symbolic_fill_in(H[np.ix_(perm, perm)])
    print(f"{name}: 变量 {H.shape[0]} 个，自然顺序填入元 {natural}，"
          f"重排序后填入元 {reordered}")
    if natural == reordered:
        print("  两种顺序相同：该拓扑下消元顺序不影响填充。")
    else:
        print(f"  重排序减少 {(natural - reordered) / natural:.1%} 的填入元。")


def main():
    print("=== 实验 10.2：因子图消元顺序与填入元分析 ===")
    np.random.seed(42)

    H_ring = ring_graph(6)
    print("环图 Hessian 的非零结构（* 为非零）：")
    for r in range(H_ring.shape[0]):
        print("[" + " ".join("*" if H_ring[r, c] else "." for c in range(H_ring.shape[0])) + "]")
    report("6 顶点环图 / 逆序排列", H_ring, np.arange(6)[::-1])

    H_grid = grid_graph(5)
    perm_rcm = reverse_cuthill_mckee(csr_matrix(np.abs(H_grid) > 1e-12), symmetric_mode=True)
    print("5×5 网格图 / 行优先编号 vs 逆 Cuthill–McKee 重排序")
    report("  网格图", H_grid, perm_rcm)

    print("\n结论：填入元由图的拓扑与消元顺序共同决定。环图上顺序无差别，")
    print("二维网格上 RCM 通过降低带宽减少填充；把'重排序一定更好'当定式是错的。")


if __name__ == "__main__":
    main()
