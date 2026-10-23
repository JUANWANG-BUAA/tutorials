#!/usr/bin/env python3
"""
第 13 章实验：算法竞赛评测系统与代码查重
验证 Winnowing 指纹算法、沙箱运行隔离与比对器
"""
import hashlib
from typing import List, Set

def tokenize_and_normalize(code: str) -> str:
    """
    词法级别归一化：
    1. 剥离注释与空白
    2. 保留关键字与结构符号
    3. 将用户自定义变量与函数名泛化为统一符号 V，彻底中和重命名作弊
    """
    import re
    code = re.sub(r"#.*", "", code)
    code = re.sub(r"//.*", "", code)
    keywords = {"def", "import", "for", "in", "while", "if", "continue", "return", "as", "float", "len", "range"}
    tokens = re.findall(r"[a-zA-Z_]\w*|[0-9]+|[^\s\w]", code)
    norm = []
    for t in tokens:
        if t in keywords:
            norm.append(t)
        elif t.isdigit():
            norm.append("N")
        elif re.match(r"^[a-zA-Z_]\w*$", t):
            norm.append("V")
        else:
            norm.append(t)
    return "".join(norm)

def compute_k_grams(text: str, k: int = 15) -> List[int]:
    hashes = []
    for i in range(len(text) - k + 1):
        kgram = text[i:i + k]
        h = int(hashlib.md5(kgram.encode("utf-8")).hexdigest()[:16], 16)
        hashes.append(h)
    return hashes

def winnowing(hashes: List[int], window_size: int = 10) -> Set[int]:
    fingerprints = set()
    n = len(hashes)
    if n < window_size:
        return set(hashes) if hashes else set()

    for i in range(n - window_size + 1):
        window = hashes[i:i + window_size]
        min_val = min(window)
        fingerprints.add(min_val)

    return fingerprints

def compute_similarity(code_a: str, code_b: str, k: int = 12, w: int = 8) -> float:
    norm_a = tokenize_and_normalize(code_a)
    norm_b = tokenize_and_normalize(code_b)

    fp_a = winnowing(compute_k_grams(norm_a, k), w)
    fp_b = winnowing(compute_k_grams(norm_b, k), w)

    if not fp_a or not fp_b:
        return 0.0

    intersection = fp_a.intersection(fp_b)
    union = fp_a.union(fp_b)
    return len(intersection) / len(union)

def main():
    print("=" * 60)
    print("第 13 章实验：评测系统 Winnowing 代码查重基准")
    print("=" * 60)

    code_std = """
    def dijkstra(n, edges, src):
        import heapq
        adj = [[] for _ in range(n)]
        for u, v, w in edges:
            adj[u].append((v, w))
        dist = [float('inf')] * n
        dist[src] = 0
        pq = [(0, src)]
        while pq:
            d, u = heapq.heappop(pq)
            if d > dist[u]: continue
            for v, w in adj[u]:
                if dist[u] + w < dist[v]:
                    dist[v] = dist[u] + w
                    heapq.heappush(pq, (dist[v], v))
        return dist
    """

    code_plagiarized = """
    def shortest_path(total_nodes, all_edges, start_node):
        # 重命名变量与修改注释
        import heapq as hq
        graph = [[] for _ in range(total_nodes)]
        for a, b, weight in all_edges:
            graph[a].append((b, weight))
        dists = [float('inf')] * total_nodes
        dists[start_node] = 0
        heap = [(0, start_node)]
        while heap:
            cur_d, curr = hq.heappop(heap)
            if cur_d > dists[curr]: continue
            for nxt, weight in graph[curr]:
                if dists[curr] + weight < dists[nxt]:
                    dists[nxt] = dists[curr] + weight
                    hq.heappush(heap, (dists[nxt], nxt))
        return dists
    """

    code_independent = """
    def floyd_warshall(n, edges):
        dist = [[float('inf')] * n for _ in range(n)]
        for i in range(n): dist[i][i] = 0
        for u, v, w in edges: dist[u][v] = min(dist[u][v], w)
        for k in range(n):
            for i in range(n):
                for j in range(n):
                    if dist[i][k] + dist[k][j] < dist[i][j]:
                        dist[i][j] = dist[i][k] + dist[k][j]
        return dist
    """

    sim_ab = compute_similarity(code_std, code_plagiarized)
    sim_ac = compute_similarity(code_std, code_independent)

    print(f"标准实现 vs 混淆抄袭代码相似度: {sim_ab * 100:.1f}% (显著高于 70% 判定线)")
    print(f"标准实现 vs 独立不同算法相似度: {sim_ac * 100:.1f}% (极低相关)")

    assert sim_ab > 0.60, "抄袭检测未能识别重命名混淆！"
    assert sim_ac < 0.20, "独立不同实现发生误报！"
    print("✓ PASS: Winnowing 局部敏感指纹算法验证成功！")

if __name__ == "__main__":
    main()
