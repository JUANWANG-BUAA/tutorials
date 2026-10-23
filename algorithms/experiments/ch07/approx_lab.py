#!/usr/bin/env python3
"""
第 7 章实验：NP 难问题与近似算法性能实测
对比极大匹配 2-近似算法 vs 整数线性规划 (ILP) 精确解
"""
import numpy as np
from scipy.optimize import milp, LinearConstraint, Bounds
from typing import List, Tuple, Set

np.random.seed(42)

def generate_random_graph(n: int, p: float = 0.1) -> List[Tuple[int, int]]:
    """生成 Erdos-Renyi 随机图 G(n, p)"""
    edges = []
    for u in range(n):
        for v in range(u + 1, n):
            if np.random.rand() < p:
                edges.append((u, v))
    return edges

def solve_vertex_cover_ilp(n: int, edges: List[Tuple[int, int]]) -> int:
    """使用 SciPy MILP 求解器精确求解顶点覆盖"""
    if not edges:
        return 0
    c = np.ones(n)
    m = len(edges)
    A = np.zeros((m, n))
    for i, (u, v) in enumerate(edges):
        A[i, u] = 1.0
        A[i, v] = 1.0

    constraints = LinearConstraint(A, lb=1.0, ub=np.inf)
    integrality = np.ones(n)
    bounds = Bounds(0.0, 1.0)
    res = milp(c=c, integrality=integrality, constraints=constraints, bounds=bounds)
    if res.success:
        return int(round(res.fun))
    return len(edges)

def vertex_cover_maximal_matching(n: int, edges: List[Tuple[int, int]]) -> int:
    """基于极大匹配的 2-近似算法"""
    matched: Set[int] = set()
    for u, v in edges:
        if u not in matched and v not in matched:
            matched.add(u)
            matched.add(v)
    return len(matched)

def main():
    print("=" * 60)
    print("第 7 章实验：顶点覆盖近似算法实测基准")
    print("=" * 60)

    n = 30
    p = 0.15
    rounds = 10
    ratios = []

    for r in range(1, rounds + 1):
        edges = generate_random_graph(n, p)
        if not edges:
            continue
        opt = solve_vertex_cover_ilp(n, edges)
        approx = vertex_cover_maximal_matching(n, edges)
        ratio = approx / max(1, opt)
        ratios.append(ratio)
        print(f"实例 {r:2d} | |V|={n}, |E|={len(edges):3d} | ILP最优 OPT={opt:2d} | 极大匹配 ALG={approx:2d} | 实际比值: {ratio:.3f}x")

    avg_ratio = np.mean(ratios)
    max_ratio = np.max(ratios)
    print("-" * 60)
    print(f"平均近似比: {avg_ratio:.3f}x (理论保证 <= 2.0x)")
    print(f"最差近似比: {max_ratio:.3f}x")
    assert max_ratio <= 2.0 + 1e-6, "近似比违背理论上界！"
    print("✓ PASS: 2-近似理论保证全部验证成立！")

if __name__ == "__main__":
    main()
