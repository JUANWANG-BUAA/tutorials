#!/usr/bin/env python3
"""
第 4 章实验：搜索与启发式性能对比

验证：
1. BFS vs DFS 在迷宫中的性能和路径长度
2. A* 启发式函数对比（曼哈顿 vs 欧氏 vs 零启发式）
3. N皇后回溯剪枝效果
4. Alpha-Beta 剪枝节省的节点数
5. visited 集合的重要性

运行: python3 search_lab.py
"""

import time
import random
import heapq
from collections import deque

SEED = 42
REPEAT = 20

random.seed(SEED)

# ============================================================
# 工具函数
# ============================================================

def measure_time(func, *args, repeat=REPEAT):
    """测量函数运行时间中位数（毫秒）"""
    times = []
    for _ in range(repeat):
        start = time.perf_counter()
        result = func(*args)
        end = time.perf_counter()
        times.append((end - start) * 1000)
    times.sort()
    return times[len(times) // 2], result

# ============================================================
# 实验 1: BFS vs DFS 在迷宫中的性能
# ============================================================

def generate_maze(size, wall_prob=0.3):
    """生成随机迷宫，0是通路，1是墙"""
    maze = [[0 if random.random() > wall_prob else 1
             for _ in range(size)] for _ in range(size)]
    # 确保起点和终点是通路
    maze[0][0] = 0
    maze[size-1][size-1] = 0
    return maze

def bfs_maze(maze, start=(0,0)):
    """BFS求解迷宫，返回到所有可达点的距离"""
    n = len(maze)
    visited = {start}
    queue = deque([start])
    dist = {start: 0}

    while queue:
        x, y = queue.popleft()

        for dx, dy in [(0,1), (1,0), (0,-1), (-1,0)]:
            nx, ny = x + dx, y + dy

            if (0 <= nx < n and 0 <= ny < n and
                maze[nx][ny] == 0 and (nx, ny) not in visited):
                visited.add((nx, ny))
                dist[(nx, ny)] = dist[(x, y)] + 1
                queue.append((nx, ny))

    return dist

def dfs_maze(maze, start=(0,0)):
    """DFS求解迷宫（迭代版本），返回访问顺序和到终点的路径"""
    n = len(maze)
    visited = {start}
    stack = [(start, [start])]
    end = (n-1, n-1)

    while stack:
        (x, y), path = stack.pop()

        if (x, y) == end:
            return path

        for dx, dy in [(0,1), (1,0), (0,-1), (-1,0)]:
            nx, ny = x + dx, y + dy

            if (0 <= nx < n and 0 <= ny < n and
                maze[nx][ny] == 0 and (nx, ny) not in visited):
                visited.add((nx, ny))
                stack.append(((nx, ny), path + [(nx, ny)]))

    return []  # 无解

def experiment1():
    print("\n" + "="*60)
    print("[实验 1] BFS vs DFS 在迷宫中的性能")
    print("="*60)

    for size in [20, 50]:
        maze = generate_maze(size, wall_prob=0.3)

        # BFS
        t_bfs, dist_bfs = measure_time(bfs_maze, maze, (0,0))
        end = (size-1, size-1)
        path_len_bfs = dist_bfs.get(end, -1)

        # DFS
        t_dfs, path_dfs = measure_time(dfs_maze, maze, (0,0))
        path_len_dfs = len(path_dfs) if path_dfs else -1

        print(f"\n  迷宫{size}x{size}:")
        print(f"    BFS: {t_bfs:.1f}ms, 路径长度: {path_len_bfs}")
        print(f"    DFS: {t_dfs:.1f}ms, 路径长度: {path_len_dfs}")

        if path_len_bfs > 0 and path_len_dfs > 0:
            ratio = path_len_bfs / path_len_dfs * 100
            print(f"    BFS路径是DFS的{ratio:.0f}%")

    print(f"\n  结论：DFS更快（栈操作简单），BFS路径更短（最短路保证）")

# ============================================================
# 实验 2: A* 启发式函数对比
# ============================================================

def manhattan_distance(pos, goal):
    """曼哈顿距离"""
    return abs(pos[0] - goal[0]) + abs(pos[1] - goal[1])

def euclidean_distance(pos, goal):
    """欧氏距离"""
    return ((pos[0] - goal[0])**2 + (pos[1] - goal[1])**2) ** 0.5

def a_star(grid, start, goal, heuristic):
    """A*搜索，返回路径长度和展开节点数"""
    n = len(grid)
    open_set = []
    heapq.heappush(open_set, (heuristic(start, goal), start))

    g_score = {start: 0}
    came_from = {}
    expanded = 0

    while open_set:
        _, current = heapq.heappop(open_set)
        expanded += 1

        if current == goal:
            # 重建路径长度
            length = 0
            while current in came_from:
                length += 1
                current = came_from[current]
            return length, expanded

        x, y = current
        for dx, dy in [(0,1), (1,0), (0,-1), (-1,0)]:
            nx, ny = x + dx, y + dy

            if 0 <= nx < n and 0 <= ny < n and grid[nx][ny] == 0:
                neighbor = (nx, ny)
                tentative_g = g_score[current] + 1

                if neighbor not in g_score or tentative_g < g_score[neighbor]:
                    came_from[neighbor] = current
                    g_score[neighbor] = tentative_g
                    f_score = tentative_g + heuristic(neighbor, goal)
                    heapq.heappush(open_set, (f_score, neighbor))

    return -1, expanded  # 无解

def experiment2():
    print("\n" + "="*60)
    print("[实验 2] A* 启发式函数对比")
    print("="*60)

    size = 30
    grid = [[0 for _ in range(size)] for _ in range(size)]
    start = (0, 0)
    goal = (size-1, size-1)

    # 三种启发式
    heuristics = [
        ("h=0（Dijkstra）", lambda pos, g: 0),
        ("h=曼哈顿", manhattan_distance),
        ("h=欧氏", euclidean_distance)
    ]

    results = []
    for name, h in heuristics:
        path_len, expanded = a_star(grid, start, goal, h)
        results.append((name, path_len, expanded))

    print(f"\n  A*启发式对比（{size}x{size}网格）:")
    for name, path_len, expanded in results:
        print(f"    {name}: 展开{expanded}个节点, 路径长度{path_len}")

    print(f"\n  结论：曼哈顿距离展开节点最少，欧氏稍差，零启发式退化为Dijkstra")

# ============================================================
# 实验 3: N皇后回溯剪枝效果
# ============================================================

call_count = 0

def n_queens_with_pruning(n):
    """N皇后回溯解法（带剪枝），统计调用次数"""
    global call_count
    call_count = 0

    def is_valid(queens, row, col):
        for i in range(row):
            if queens[i] == col or abs(i - row) == abs(queens[i] - col):
                return False
        return True

    def backtrack(row, queens):
        global call_count
        call_count += 1

        if row == n:
            solutions.append(queens[:])
            return

        for col in range(n):
            if is_valid(queens, row, col):
                queens[row] = col
                backtrack(row + 1, queens)
                queens[row] = -1

    solutions = []
    backtrack(0, [-1] * n)
    return solutions, call_count

def experiment3():
    print("\n" + "="*60)
    print("[实验 3] N皇后回溯剪枝效果")
    print("="*60)

    n = 8
    t, (solutions, calls) = measure_time(n_queens_with_pruning, n, repeat=5)

    print(f"\n  {n}皇后回溯（求所有解）:")
    print(f"    调用次数: {calls}次")
    print(f"    运行时间: {t:.1f}ms")
    print(f"    找到解数: {len(solutions)}个")
    print(f"    无剪枝理论: {n}! = {1}")
    for i in range(1, n+1):
        print(f"{' '*4*2}{n}! = ", end="")
        result = 1
        for j in range(1, n+1):
            result *= j
        print(f"{result}次")
        break
    print(f"    剪枝效果: 减少{(1 - calls/40320)*100:.0f}%调用")

    print(f"\n  结论：约束检查将{n}!次调用减少到{calls}次")

# ============================================================
# 实验 4: Alpha-Beta 剪枝效果
# ============================================================

nodes_expanded = 0

def minimax(node, depth, is_maximizing):
    """Minimax算法（无剪枝）"""
    global nodes_expanded
    nodes_expanded += 1

    if depth == 0 or 'value' in node:
        return node.get('value', 0)

    if is_maximizing:
        max_eval = -float('inf')
        for child in node.get('children', []):
            eval = minimax(child, depth - 1, False)
            max_eval = max(max_eval, eval)
        return max_eval
    else:
        min_eval = float('inf')
        for child in node.get('children', []):
            eval = minimax(child, depth - 1, True)
            min_eval = min(min_eval, eval)
        return min_eval

def alpha_beta(node, depth, alpha, beta, is_maximizing):
    """Alpha-Beta剪枝"""
    global nodes_expanded
    nodes_expanded += 1

    if depth == 0 or 'value' in node:
        return node.get('value', 0)

    if is_maximizing:
        max_eval = -float('inf')
        for child in node.get('children', []):
            eval = alpha_beta(child, depth - 1, alpha, beta, False)
            max_eval = max(max_eval, eval)
            alpha = max(alpha, eval)
            if beta <= alpha:
                break  # β剪枝
        return max_eval
    else:
        min_eval = float('inf')
        for child in node.get('children', []):
            eval = alpha_beta(child, depth - 1, alpha, beta, True)
            min_eval = min(min_eval, eval)
            beta = min(beta, eval)
            if beta <= alpha:
                break  # α剪枝
        return min_eval

def build_game_tree(depth, branching):
    """构造完全博弈树"""
    if depth == 0:
        return {'value': random.randint(-10, 10)}

    return {
        'children': [build_game_tree(depth - 1, branching)
                     for _ in range(branching)]
    }

def experiment4():
    print("\n" + "="*60)
    print("[实验 4] Alpha-Beta 剪枝效果")
    print("="*60)

    depth = 5
    branching = 3
    tree = build_game_tree(depth, branching)

    # Minimax
    global nodes_expanded
    nodes_expanded = 0
    start = time.perf_counter()
    value_mm = minimax(tree, depth, True)
    t_mm = (time.perf_counter() - start) * 1000
    nodes_mm = nodes_expanded

    # Alpha-Beta
    nodes_expanded = 0
    start = time.perf_counter()
    value_ab = alpha_beta(tree, depth, -float('inf'), float('inf'), True)
    t_ab = (time.perf_counter() - start) * 1000
    nodes_ab = nodes_expanded

    print(f"\n  Minimax vs Alpha-Beta（深度{depth}，分支{branching}）:")
    print(f"    Minimax: 展开{nodes_mm}个节点, {t_mm:.1f}ms, 值={value_mm}")
    print(f"    Alpha-Beta: 展开{nodes_ab}个节点, {t_ab:.1f}ms, 值={value_ab}")
    print(f"    剪枝效果: 减少{(1 - nodes_ab/nodes_mm)*100:.0f}%节点")

    print(f"\n  结论：Alpha-Beta剪枝大幅减少展开节点数")

# ============================================================
# 实验 5: visited 集合的重要性
# ============================================================

def bfs_no_visited(grid, start, goal, max_visits=10000):
    """BFS无visited集合（有上限防止死循环）"""
    n = len(grid)
    queue = deque([(start, 0)])
    visits = 0

    while queue and visits < max_visits:
        (x, y), dist = queue.popleft()
        visits += 1

        if (x, y) == goal:
            return dist, visits

        for dx, dy in [(0,1), (1,0), (0,-1), (-1,0)]:
            nx, ny = x + dx, y + dy

            if 0 <= nx < n and 0 <= ny < n and grid[nx][ny] == 0:
                queue.append(((nx, ny), dist + 1))

    return -1, visits  # 超时或无解

def bfs_with_visited(grid, start, goal):
    """BFS有visited集合"""
    n = len(grid)
    visited = {start}
    queue = deque([(start, 0)])
    visits = 0

    while queue:
        (x, y), dist = queue.popleft()
        visits += 1

        if (x, y) == goal:
            return dist, visits

        for dx, dy in [(0,1), (1,0), (0,-1), (-1,0)]:
            nx, ny = x + dx, y + dy

            if (0 <= nx < n and 0 <= ny < n and
                grid[nx][ny] == 0 and (nx, ny) not in visited):
                visited.add((nx, ny))
                queue.append(((nx, ny), dist + 1))

    return -1, visits

def experiment5():
    print("\n" + "="*60)
    print("[实验 5] visited 集合的重要性")
    print("="*60)

    size = 10
    grid = [[0 for _ in range(size)] for _ in range(size)]
    start = (0, 0)
    goal = (size-1, size-1)

    # 有visited
    start_time = time.perf_counter()
    dist_v, visits_v = bfs_with_visited(grid, start, goal)
    t_v = (time.perf_counter() - start_time) * 1000

    # 无visited
    start_time = time.perf_counter()
    dist_nv, visits_nv = bfs_no_visited(grid, start, goal, max_visits=10000)
    t_nv = (time.perf_counter() - start_time) * 1000

    print(f"\n  BFS visited集合的影响（{size}x{size}网格）:")
    print(f"    有visited: 访问{visits_v}个节点, {t_v:.2f}ms, 距离={dist_v}")
    print(f"    无visited: 访问{visits_nv}个节点（上限10000）, {t_nv:.1f}ms, 距离={dist_nv}")

    if visits_nv >= 10000:
        print(f"    性能差异: >100x（无visited超时）")
    else:
        print(f"    性能差异: {visits_nv/visits_v:.0f}x")

    print(f"\n  结论：visited集合不是优化，是必需（防止指数级重复访问）")

# ============================================================
# 主函数
# ============================================================

def main():
    print("="*60)
    print("第 4 章实验：搜索与启发式性能对比")
    print("="*60)
    print(f"随机种子: {SEED}")
    print(f"重复次数: {REPEAT}")

    experiment1()  # BFS vs DFS
    experiment2()  # A*启发式对比
    experiment3()  # N皇后剪枝
    experiment4()  # Alpha-Beta剪枝
    experiment5()  # visited集合

    print("\n" + "="*60)
    print("所有实验完成！")
    print("="*60)

if __name__ == "__main__":
    main()
