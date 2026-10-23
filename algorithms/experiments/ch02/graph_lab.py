#!/usr/bin/env python3
"""
第 2 章实验：图算法性能分析

验证：
1. Dijkstra vs Bellman-Ford 速度差异（非负权图）
2. Kruskal vs Prim 在稀疏/稠密图上的表现
3. Ford-Fulkerson 增广路数量
4. 真实图结构的影响

运行: python3 graph_lab.py
"""

import heapq
import random
import time
from collections import deque, defaultdict

SEED = 42
REPEAT = 50

random.seed(SEED)

# ============================================================
# 工具函数
# ============================================================

def measure_time(func, *args, repeat=REPEAT):
    """测量函数运行时间中位数（毫秒）"""
    times = []
    for _ in range(repeat):
        start = time.perf_counter()
        func(*args)
        end = time.perf_counter()
        times.append((end - start) * 1000)
    times.sort()
    return times[len(times) // 2]

def generate_graph(n, m, weighted=True, negative=False):
    """生成随机图（邻接表）"""
    graph = defaultdict(list)
    edges = set()

    while len(edges) < m:
        u, v = random.randint(0, n-1), random.randint(0, n-1)
        if u != v and (u, v) not in edges:
            edges.add((u, v))
            if weighted:
                w = random.randint(-5, 10) if negative else random.randint(1, 10)
            else:
                w = 1
            graph[u].append((v, w))

    return graph, list(edges)

# ============================================================
# Dijkstra 实现
# ============================================================

def dijkstra(graph, start, n):
    dist = {start: 0}
    pq = [(0, start)]
    visited = set()

    while pq:
        d, u = heapq.heappop(pq)
        if u in visited:
            continue
        visited.add(u)

        for v, w in graph.get(u, []):
            new_dist = d + w
            if v not in dist or new_dist < dist[v]:
                dist[v] = new_dist
                heapq.heappush(pq, (new_dist, v))

    return dist

# ============================================================
# Bellman-Ford 实现
# ============================================================

def bellman_ford(edges, n, start):
    dist = [float('inf')] * n
    dist[start] = 0

    for _ in range(n - 1):
        for u, v, w in edges:
            if dist[u] + w < dist[v]:
                dist[v] = dist[u] + w

    # 检测负权环
    for u, v, w in edges:
        if dist[u] + w < dist[v]:
            return None  # 负权环

    return {i: dist[i] for i in range(n)}

# ============================================================
# 并查集
# ============================================================

class UnionFind:
    def __init__(self, n):
        self.parent = list(range(n))
        self.rank = [0] * n

    def find(self, x):
        if self.parent[x] != x:
            self.parent[x] = self.find(self.parent[x])
        return self.parent[x]

    def union(self, x, y):
        px, py = self.find(x), self.find(y)
        if px == py:
            return False
        if self.rank[px] < self.rank[py]:
            px, py = py, px
        self.parent[py] = px
        if self.rank[px] == self.rank[py]:
            self.rank[px] += 1
        return True

# ============================================================
# Kruskal 实现
# ============================================================

def kruskal(edges, n):
    edges_weighted = [(u, v, w) for (u, v), w in edges]
    edges_weighted.sort(key=lambda e: e[2])

    uf = UnionFind(n)
    mst = []
    total_weight = 0

    for u, v, w in edges_weighted:
        if uf.union(u, v):
            mst.append((u, v, w))
            total_weight += w
            if len(mst) == n - 1:
                break

    return mst, total_weight

# ============================================================
# Prim 实现
# ============================================================

def prim(graph, n):
    visited = set()
    mst = []
    total_weight = 0
    pq = [(0, 0, -1)]  # (权重, 顶点, 来源)

    while pq and len(visited) < n:
        w, u, parent = heapq.heappop(pq)
        if u in visited:
            continue
        visited.add(u)

        if parent != -1:
            mst.append((parent, u, w))
            total_weight += w

        for v, edge_w in graph.get(u, []):
            if v not in visited:
                heapq.heappush(pq, (edge_w, v, u))

    return mst, total_weight

# ============================================================
# Ford-Fulkerson 实现
# ============================================================

def bfs_find_path(capacity, flow, s, t, n):
    visited = [False] * n
    parent = [-1] * n
    visited[s] = True
    queue = deque([s])

    while queue:
        u = queue.popleft()
        for v in range(n):
            if not visited[v] and capacity[u][v] > flow[u][v]:
                visited[v] = True
                parent[v] = u
                queue.append(v)
                if v == t:
                    return parent
    return None

def ford_fulkerson(capacity, s, t, n):
    flow = [[0] * n for _ in range(n)]
    max_flow = 0
    iterations = 0

    while True:
        parent = bfs_find_path(capacity, flow, s, t, n)
        if parent is None:
            break

        iterations += 1
        path_flow = float('inf')
        v = t
        while v != s:
            u = parent[v]
            path_flow = min(path_flow, capacity[u][v] - flow[u][v])
            v = u

        v = t
        while v != s:
            u = parent[v]
            flow[u][v] += path_flow
            flow[v][u] -= path_flow
            v = u

        max_flow += path_flow

    return max_flow, iterations

# ============================================================
# 实验 1: Dijkstra vs Bellman-Ford
# ============================================================

def experiment1():
    print("\n" + "="*50)
    print("[实验 1] Dijkstra vs Bellman-Ford (非负权图)")
    print("="*50)

    n, m = 1000, 5000
    graph, edge_list = generate_graph(n, m, weighted=True, negative=False)
    edges_bellman = [(u, v, w) for u, neighbors in graph.items()
                     for v, w in neighbors]

    t_dijkstra = measure_time(dijkstra, graph, 0, n)
    t_bellman = measure_time(bellman_ford, edges_bellman, n, 0)

    print(f"  n={n}, m={m}")
    print(f"  Dijkstra: {t_dijkstra:.1f}ms")
    print(f"  Bellman-Ford: {t_bellman:.1f}ms")
    print(f"  Bellman-Ford 慢 {t_bellman / t_dijkstra:.1f}x")
    print(f"  结论：非负权图用 Dijkstra 快一个数量级。")

# ============================================================
# 实验 2: Kruskal vs Prim (稀疏 vs 稠密)
# ============================================================

def experiment2():
    print("\n" + "="*50)
    print("[实验 2] Kruskal vs Prim：稀疏图 vs 稠密图")
    print("="*50)

    # 稀疏图
    n_sparse = 500
    m_sparse = n_sparse  # m = n
    graph_sparse, edges_sparse = generate_graph(n_sparse, m_sparse)
    edges_for_kruskal_sparse = [((u, v), w) for u, v, w in
                                 [(u, v, w) for u, neighbors in graph_sparse.items()
                                  for v, w in neighbors]]

    t_kruskal_sparse = measure_time(kruskal, edges_for_kruskal_sparse, n_sparse)
    t_prim_sparse = measure_time(prim, graph_sparse, n_sparse)

    print(f"  稀疏图 (n={n_sparse}, m={m_sparse}):")
    print(f"    Kruskal: {t_kruskal_sparse:.1f}ms")
    print(f"    Prim: {t_prim_sparse:.1f}ms")
    if t_kruskal_sparse < t_prim_sparse:
        print(f"    Kruskal 快 {t_prim_sparse / t_kruskal_sparse:.1f}x")
    else:
        print(f"    Prim 快 {t_kruskal_sparse / t_prim_sparse:.1f}x")

    # 稠密图
    n_dense = 200
    m_dense = n_dense * (n_dense - 1) // 4  # m ≈ n²/4
    graph_dense, edges_dense = generate_graph(n_dense, m_dense)
    edges_for_kruskal_dense = [((u, v), w) for u, v, w in
                                [(u, v, w) for u, neighbors in graph_dense.items()
                                 for v, w in neighbors]]

    t_kruskal_dense = measure_time(kruskal, edges_for_kruskal_dense, n_dense)
    t_prim_dense = measure_time(prim, graph_dense, n_dense)

    print(f"\n  稠密图 (n={n_dense}, m={m_dense}):")
    print(f"    Kruskal: {t_kruskal_dense:.1f}ms")
    print(f"    Prim: {t_prim_dense:.1f}ms")
    if t_kruskal_dense < t_prim_dense:
        print(f"    Kruskal 快 {t_prim_dense / t_kruskal_dense:.1f}x")
    else:
        print(f"    Prim 快 {t_kruskal_dense / t_prim_dense:.1f}x")

    print(f"  结论：稀疏图倾向 Kruskal，稠密图两者相当或 Prim 略优。")

# ============================================================
# 实验 3: Ford-Fulkerson 增广路数量
# ============================================================

def experiment3():
    print("\n" + "="*50)
    print("[实验 3] Ford-Fulkerson 增广路数量")
    print("="*50)

    n = 100
    s, t = 0, n - 1

    # 生成容量矩阵
    capacity = [[0] * n for _ in range(n)]
    num_edges = n * 3  # 稀疏网络

    for _ in range(num_edges):
        u, v = random.randint(0, n-2), random.randint(1, n-1)
        if u < v:
            capacity[u][v] = random.randint(1, 10)

    max_flow, iterations = ford_fulkerson(capacity, s, t, n)

    print(f"  n={n}, 源={s}, 汇={t}")
    print(f"  最大流: {max_flow}")
    print(f"  增广路数量: {iterations}")
    print(f"  理论上界: O(VE) = {n * num_edges}")
    print(f"  结论：实际增广路数远小于理论上界（紧图除外）。")

# ============================================================
# 实验 4: 真实图结构模拟
# ============================================================

def experiment4():
    print("\n" + "="*50)
    print("[实验 4] 真实图结构：路网 vs 社交网络")
    print("="*50)

    n = 1000

    # 路网模拟：稀疏，平均度 ~2-3
    m_road = n * 2
    graph_road, _ = generate_graph(n, m_road, weighted=True, negative=False)
    avg_degree_road = sum(len(neighbors) for neighbors in graph_road.values()) / n
    t_road = measure_time(dijkstra, graph_road, 0, n)

    # 社交网络模拟：相对稠密，平均度 ~50
    m_social = n * 25
    graph_social, _ = generate_graph(n, m_social, weighted=True, negative=False)
    avg_degree_social = sum(len(neighbors) for neighbors in graph_social.values()) / n
    t_social = measure_time(dijkstra, graph_social, 0, n)

    print(f"  路网 (n={n}, m={m_road}):")
    print(f"    平均度: {avg_degree_road:.1f}")
    print(f"    Dijkstra: {t_road:.1f}ms")

    print(f"\n  社交网络 (n={n}, m={m_social}):")
    print(f"    平均度: {avg_degree_social:.1f}")
    print(f"    Dijkstra: {t_social:.1f}ms")

    print(f"\n  社交网络慢 {t_social / t_road:.1f}x（度数高 → 更多邻居要松弛）")

# ============================================================
# 主函数
# ============================================================

def main():
    print("="*50)
    print("第 2 章实验：图算法性能分析")
    print("="*50)

    experiment1()
    experiment2()
    experiment3()
    experiment4()

    print("\n" + "="*50)
    print("所有实验完成 ✓")
    print("="*50)

if __name__ == "__main__":
    main()
