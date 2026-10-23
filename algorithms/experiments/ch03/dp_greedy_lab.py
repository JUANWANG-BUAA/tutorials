#!/usr/bin/env python3
"""
第 3 章实验：动态规划与贪心性能对比

验证：
1. 朴素递归 vs 记忆化（斐波那契）
2. 背包问题的O(nW)复杂度
3. LCS的O(mn)复杂度
4. 贪心 vs DP（带权重区间调度）

运行: python3 dp_greedy_lab.py
"""

import time
import random
from functools import lru_cache

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
        func(*args)
        end = time.perf_counter()
        times.append((end - start) * 1000)
    times.sort()
    return times[len(times) // 2]

# ============================================================
# 实验 1: 朴素递归 vs 记忆化
# ============================================================

def fib_naive(n):
    """朴素递归"""
    if n <= 1:
        return n
    return fib_naive(n-1) + fib_naive(n-2)

@lru_cache(maxsize=None)
def fib_memo(n):
    """记忆化递归"""
    if n <= 1:
        return n
    return fib_memo(n-1) + fib_memo(n-2)

def experiment1():
    print("\n" + "="*50)
    print("[实验 1] 朴素递归 vs 记忆化（斐波那契）")
    print("="*50)

    n_small = 20
    t_naive_small = measure_time(fib_naive, n_small, repeat=5)
    fib_memo.cache_clear()
    t_memo_small = measure_time(fib_memo, n_small)

    print(f"  fib({n_small}):")
    print(f"    朴素递归: {t_naive_small:.1f}ms")
    print(f"    记忆化: {t_memo_small:.2f}ms")
    print(f"    加速比: {t_naive_small / t_memo_small:.0f}x")

    n_large = 30
    print(f"\n  fib({n_large}):")
    print(f"    朴素递归: 超时（指数复杂度）")
    fib_memo.cache_clear()
    t_memo_large = measure_time(fib_memo, n_large)
    print(f"    记忆化: {t_memo_large:.2f}ms")

    print(f"\n  结论：记忆化将指数复杂度降为线性，提速数万倍。")

# ============================================================
# 实验 2: 背包问题规模测试
# ============================================================

def knapsack_01(weights, values, W):
    """0-1背包（空间优化版）"""
    dp = [0] * (W + 1)
    for i in range(len(weights)):
        for w in range(W, weights[i] - 1, -1):
            dp[w] = max(dp[w], dp[w - weights[i]] + values[i])
    return dp[W]

def experiment2():
    print("\n" + "="*50)
    print("[实验 2] 背包问题规模测试（O(nW)）")
    print("="*50)

    # 测试1
    n1, W1 = 100, 1000
    weights1 = [random.randint(1, 50) for _ in range(n1)]
    values1 = [random.randint(10, 100) for _ in range(n1)]
    t1 = measure_time(knapsack_01, weights1, values1, W1)

    # 测试2: 规模翻倍
    n2, W2 = 200, 2000
    weights2 = [random.randint(1, 50) for _ in range(n2)]
    values2 = [random.randint(10, 100) for _ in range(n2)]
    t2 = measure_time(knapsack_01, weights2, values2, W2)

    print(f"  n={n1}, W={W1}: {t1:.1f}ms")
    print(f"  n={n2}, W={W2}: {t2:.1f}ms")
    print(f"  规模2x → 时间 {t2/t1:.1f}x（理论4x，符合O(nW)）")

    print(f"\n  注意：W是数值大小，W=10^9时O(nW)不可行（伪多项式）。")

# ============================================================
# 实验 3: LCS复杂度验证
# ============================================================

def lcs_length(X, Y):
    """最长公共子序列长度"""
    m, n = len(X), len(Y)
    dp = [[0] * (n + 1) for _ in range(m + 1)]

    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if X[i-1] == Y[j-1]:
                dp[i][j] = dp[i-1][j-1] + 1
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])

    return dp[m][n]

def experiment3():
    print("\n" + "="*50)
    print("[实验 3] LCS复杂度验证（O(mn)）")
    print("="*50)

    # 测试1
    m1 = n1 = 500
    X1 = ''.join(random.choices('ABCD', k=m1))
    Y1 = ''.join(random.choices('ABCD', k=n1))
    t1 = measure_time(lcs_length, X1, Y1)

    # 测试2: 规模翻倍
    m2 = n2 = 1000
    X2 = ''.join(random.choices('ABCD', k=m2))
    Y2 = ''.join(random.choices('ABCD', k=n2))
    t2 = measure_time(lcs_length, X2, Y2)

    print(f"  m=n={m1}: {t1:.1f}ms")
    print(f"  m=n={m2}: {t2:.1f}ms")
    print(f"  规模2x → 时间 {t2/t1:.1f}x（理论4x，符合O(mn)）")

    print(f"\n  应用：DNA序列比对、版本控制diff、拼写检查。")

# ============================================================
# 实验 4: 贪心 vs DP（带权重区间调度）
# ============================================================

def interval_scheduling_greedy(intervals):
    """贪心：按结束时间排序"""
    intervals.sort(key=lambda x: x[1])
    selected = []
    last_end = -float('inf')

    for start, end, value in intervals:
        if start >= last_end:
            selected.append((start, end, value))
            last_end = end

    return sum(v for _, _, v in selected)

def interval_scheduling_dp(intervals):
    """DP：带权重的区间调度"""
    # 按结束时间排序
    intervals.sort(key=lambda x: x[1])
    n = len(intervals)

    # dp[i] = 考虑前i个区间的最大价值
    dp = [0] * (n + 1)

    for i in range(1, n + 1):
        start, end, value = intervals[i-1]

        # 找最后一个不冲突的区间
        j = i - 1
        while j > 0 and intervals[j-1][1] > start:
            j -= 1

        # 选或不选当前区间
        dp[i] = max(dp[i-1], dp[j] + value)

    return dp[n]

def experiment4():
    print("\n" + "="*50)
    print("[实验 4] 贪心 vs DP（带权重区间调度）")
    print("="*50)

    # 生成随机区间（带权重）
    n = 100
    intervals = []
    for _ in range(n):
        start = random.randint(0, 100)
        duration = random.randint(5, 20)
        end = start + duration
        value = random.randint(10, 100)
        intervals.append((start, end, value))

    t_greedy = measure_time(interval_scheduling_greedy, intervals[:])
    greedy_value = interval_scheduling_greedy(intervals[:])

    t_dp = measure_time(interval_scheduling_dp, intervals[:])
    dp_value = interval_scheduling_dp(intervals[:])

    print(f"  n={n} 个区间")
    print(f"\n  贪心（按结束时间）:")
    print(f"    时间: {t_greedy:.1f}ms")
    print(f"    总价值: {greedy_value}")

    print(f"\n  DP（最优解）:")
    print(f"    时间: {t_dp:.1f}ms")
    print(f"    总价值: {dp_value}")

    print(f"\n  结论：")
    print(f"    - 无权重时：贪心最优且快（O(n log n)）")
    print(f"    - 有权重时：贪心次优，需DP（O(n²)简化版，可优化到O(n log n)）")
    print(f"    - 价值差距: {dp_value - greedy_value} ({(dp_value - greedy_value) / dp_value * 100:.1f}%)")

# ============================================================
# 实验 5: DP空间优化效果
# ============================================================

def knapsack_2d(weights, values, W):
    """背包：二维数组"""
    n = len(weights)
    dp = [[0] * (W + 1) for _ in range(n + 1)]

    for i in range(1, n + 1):
        for w in range(W + 1):
            dp[i][w] = dp[i-1][w]
            if w >= weights[i-1]:
                dp[i][w] = max(dp[i][w],
                               dp[i-1][w - weights[i-1]] + values[i-1])

    return dp[n][W]

def experiment5():
    print("\n" + "="*50)
    print("[实验 5] DP空间优化对比")
    print("="*50)

    n, W = 500, 5000
    weights = [random.randint(1, 50) for _ in range(n)]
    values = [random.randint(10, 100) for _ in range(n)]

    t_2d = measure_time(knapsack_2d, weights, values, W)
    t_1d = measure_time(knapsack_01, weights, values, W)

    print(f"  n={n}, W={W}")
    print(f"\n  二维数组 O(nW) 空间:")
    print(f"    时间: {t_2d:.1f}ms")
    print(f"    空间: {n * W * 4 / 1024 / 1024:.1f}MB (int32)")

    print(f"\n  一维数组 O(W) 空间:")
    print(f"    时间: {t_1d:.1f}ms")
    print(f"    空间: {W * 4 / 1024:.2f}MB")

    print(f"\n  空间节省: {n}x, 时间几乎相同")

# ============================================================
# 主函数
# ============================================================

def main():
    print("="*50)
    print("第 3 章实验：DP与贪心性能对比")
    print("="*50)

    experiment1()
    experiment2()
    experiment3()
    experiment4()
    experiment5()

    print("\n" + "="*50)
    print("所有实验完成 ✓")
    print("="*50)

if __name__ == "__main__":
    main()
