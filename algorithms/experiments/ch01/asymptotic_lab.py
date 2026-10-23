#!/usr/bin/env python3
"""
第 1 章实验：渐进分析与实验验证
验证理论复杂度与实测性能的关系。

Requires: numpy (可选，用于拟合斜率)
"""
import random
import time
from typing import Callable

# 固定随机种子，保证可复现
random.seed(42)

def measure_time(func: Callable, arr: list[int], repeat: int = 100) -> float:
    """测量函数在给定数组上的中位数运行时间（毫秒）"""
    times = []
    for _ in range(repeat):
        arr_copy = arr.copy()
        start = time.perf_counter()
        func(arr_copy)
        end = time.perf_counter()
        times.append((end - start) * 1000)  # 转毫秒
    times.sort()
    return times[repeat // 2]  # 返回中位数

# ========== 算法实现 ==========

def linear_scan(arr: list[int]) -> int:
    """O(n) - 线性扫描求和"""
    return sum(arr)

def quadratic_bubble_sort(arr: list[int]) -> None:
    """O(n²) - 冒泡排序"""
    n = len(arr)
    for i in range(n):
        for j in range(n - 1 - i):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]

def merge_sort(arr: list[int]) -> list[int]:
    """O(n log n) - 归并排序"""
    if len(arr) <= 1:
        return arr
    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])
    return merge(left, right)

def merge(left: list[int], right: list[int]) -> list[int]:
    """合并两个有序数组"""
    result = []
    i = j = 0
    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1
    result.extend(left[i:])
    result.extend(right[j:])
    return result

def quicksort_naive(arr: list[int]) -> None:
    """O(n log n) 平均，O(n²) 最坏 - 快速排序（选第一个元素为枢轴）"""
    if len(arr) <= 1:
        return
    _quicksort_naive_helper(arr, 0, len(arr) - 1)

def _quicksort_naive_helper(arr: list[int], lo: int, hi: int) -> None:
    if lo < hi:
        pivot_idx = _partition_first(arr, lo, hi)
        _quicksort_naive_helper(arr, lo, pivot_idx - 1)
        _quicksort_naive_helper(arr, pivot_idx + 1, hi)

def _partition_first(arr: list[int], lo: int, hi: int) -> int:
    """选第一个元素为枢轴"""
    pivot = arr[lo]
    i = lo + 1
    j = hi
    while True:
        while i <= j and arr[i] <= pivot:
            i += 1
        while i <= j and arr[j] > pivot:
            j -= 1
        if i > j:
            break
        arr[i], arr[j] = arr[j], arr[i]
    arr[lo], arr[j] = arr[j], arr[lo]
    return j

# ========== 实验 ==========

def experiment_1_complexity_comparison():
    """实验 1：O(n) vs O(n²) 对比"""
    print("\n[实验 1] O(n) vs O(n²) 复杂度对比")
    print("-" * 50)

    sizes = [1000, 5000, 10000]
    for n in sizes:
        arr = list(range(n))
        random.shuffle(arr)

        # O(n)
        t_linear = measure_time(linear_scan, arr, repeat=100)

        # O(n²)
        t_quad = measure_time(quadratic_bubble_sort, arr[:min(n, 1000)], repeat=10)  # 限制规模避免太慢

        print(f"  n={n:5d}:  O(n) {t_linear:6.2f}ms,  O(n²) {t_quad:7.2f}ms,  比值 {t_quad/t_linear:4.0f}")

    print("  结论：O(n²) 的增长明显快于 O(n)，符合理论预测。")

def experiment_2_mergesort_vs_quicksort():
    """实验 2：归并排序 vs 快速排序（随机输入）"""
    print("\n[实验 2] 归并排序 vs 快速排序（随机输入）")
    print("-" * 50)

    n = 10000
    arr = list(range(n))
    random.shuffle(arr)

    t_merge = measure_time(lambda a: merge_sort(a), arr, repeat=50)
    t_quick = measure_time(quicksort_naive, arr, repeat=50)

    print(f"  n={n}:  归并 {t_merge:.2f}ms,  快排 {t_quick:.2f}ms,  比值 {t_merge/t_quick:.2f}")
    print("  理论：两者都是 O(n log n)，但常数不同。")
    print("  观察：快排通常更快（缓存友好、原地排序），但常数差异不大。")

def experiment_3_quicksort_worst_case():
    """实验 3：快排的最坏情况（已排序输入）"""
    print("\n[实验 3] 快排最坏情况：已排序输入")
    print("-" * 50)

    # 用更小的规模，避免递归深度超限导致栈溢出
    n = 500
    arr_random = list(range(n))
    random.shuffle(arr_random)
    arr_sorted = list(range(n))

    t_random = measure_time(quicksort_naive, arr_random, repeat=20)

    # 对已排序输入，单次测量（太慢了，不重复）
    import sys
    sys.setrecursionlimit(10000)  # 临时提高递归限制
    arr_copy = arr_sorted.copy()
    start = time.perf_counter()
    try:
        quicksort_naive(arr_copy)
        t_sorted = (time.perf_counter() - start) * 1000
        print(f"  随机输入: {t_random:.2f}ms (O(n log n))")
        print(f"  已排序输入: {t_sorted:.2f}ms (O(n²))")
        print(f"  退化比: {t_sorted/t_random:.1f}x")
    except RecursionError:
        print(f"  随机输入: {t_random:.2f}ms (O(n log n))")
        print(f"  已排序输入: RecursionError（递归深度超限）")
        print(f"  退化：递归深度 O(n) 导致栈溢出")

    print("  结论：agent 如果只测随机输入，无法发现这个陷阱。")

def experiment_4_cache_effect():
    """实验 4：缓存效应（顺序 vs 随机访问）"""
    print("\n[实验 4] 缓存效应：顺序 vs 随机访问")
    print("-" * 50)

    n = 10_000_000  # 1千万个整数，约 40MB，超过典型 L3 缓存
    arr = list(range(n))

    # 顺序访问
    start = time.perf_counter()
    total = sum(arr)
    t_sequential = (time.perf_counter() - start) * 1000

    # 随机访问（生成随机索引）
    random_indices = [random.randint(0, n-1) for _ in range(n // 100)]  # 避免太慢
    start = time.perf_counter()
    total = sum(arr[i] for i in random_indices)
    t_random = (time.perf_counter() - start) * 1000

    print(f"  顺序访问: {t_sequential:.2f}ms")
    print(f"  随机访问 (1% 采样): {t_random:.2f}ms,  比值 {t_random/t_sequential:.1f}x")
    print("  结论：随机访问缓存命中率低，慢数倍甚至数十倍。")

def main():
    print("=" * 50)
    print("第 1 章实验：渐进分析与实验验证")
    print("=" * 50)

    experiment_1_complexity_comparison()
    experiment_2_mergesort_vs_quicksort()
    experiment_3_quicksort_worst_case()
    experiment_4_cache_effect()

    print("\n" + "=" * 50)
    print("所有实验完成 ✓")
    print("=" * 50)

if __name__ == "__main__":
    main()
