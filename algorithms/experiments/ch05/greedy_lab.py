#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
第5章：贪心算法与反例构造 - 实验验证
=======================================

实验内容：
1. 贪心正确性验证（活动选择问题）
2. 反例构造（贪心失败案例）
3. 贪心 vs 动态规划对比
4. 性能对比分析

依赖：numpy, matplotlib
"""

import numpy as np
import matplotlib.pyplot as plt
from typing import List, Tuple
import time

# 固定随机种子
SEED = 42
np.random.seed(SEED)

# ============================================================================
# 第1部分：活动选择问题（贪心正确性验证）
# ============================================================================

def activity_selection_greedy(activities: List[Tuple[int, int]]) -> List[int]:
    """活动选择问题：贪心算法（按结束时间排序）"""
    sorted_activities = sorted(enumerate(activities), key=lambda x: x[1][1])
    selected = []
    last_end = -1
    
    for idx, (start, end) in sorted_activities:
        if start >= last_end:
            selected.append(idx)
            last_end = end
    
    return selected


def activity_selection_dp(activities: List[Tuple[int, int]]) -> List[int]:
    """活动选择问题：动态规划算法（用于验证贪心正确性）"""
    n = len(activities)
    sorted_activities = sorted(enumerate(activities), key=lambda x: x[1][1])
    
    dp = [0] * (n + 1)
    selected = [[] for _ in range(n + 1)]
    
    for i in range(1, n + 1):
        idx, (start, end) = sorted_activities[i - 1]
        dp[i] = dp[i - 1]
        selected[i] = selected[i - 1][:]
        
        j = i - 1
        while j > 0:
            if sorted_activities[j - 1][1][1] <= start:
                break
            j -= 1
        
        if 1 + dp[j] > dp[i]:
            dp[i] = 1 + dp[j]
            selected[i] = selected[j][:] + [idx]
    
    return selected[n]


def experiment_1_greedy_correctness():
    """实验1：贪心正确性验证"""
    print("=" * 80)
    print("实验1：贪心正确性验证（活动选择问题）")
    print("=" * 80)
    
    activities_1 = [(1, 4), (3, 5), (0, 6), (5, 7), (3, 9), (5, 9),
                    (6, 10), (8, 11), (8, 12), (2, 14), (12, 16)]
    
    greedy_result = activity_selection_greedy(activities_1)
    dp_result = activity_selection_dp(activities_1)
    
    print(f"\n测试用例1: {len(activities_1)}个活动")
    print(f"贪心算法选择: {len(greedy_result)}个活动, 索引: {greedy_result}")
    print(f"动态规划选择: {len(dp_result)}个活动, 索引: {sorted(dp_result)}")
    print(f"结果一致: {len(greedy_result) == len(dp_result)}")
    
    results = []
    sizes = [10, 20, 50, 100]
    
    for n in sizes:
        activities = []
        for _ in range(n):
            start = np.random.randint(0, 100)
            duration = np.random.randint(1, 20)
            activities.append((start, start + duration))
        
        greedy_sel = activity_selection_greedy(activities)
        dp_sel = activity_selection_dp(activities)
        
        match = len(greedy_sel) == len(dp_sel)
        results.append({
            'n': n,
            'greedy_count': len(greedy_sel),
            'dp_count': len(dp_sel),
            'match': match
        })
        
        print(f"\n规模 n={n}: 贪心={len(greedy_sel)}, DP={len(dp_sel)}, 匹配={match}")
    
    # 可视化
    fig, axes = plt.subplots(1, 2, figsize=(14, 5))
    
    ax = axes[0]
    activities = activities_1[:8]
    greedy_sel = activity_selection_greedy(activities)
    
    for i, (start, end) in enumerate(activities):
        color = 'green' if i in greedy_sel else 'lightgray'
        ax.barh(i, end - start, left=start, height=0.8,
                color=color, edgecolor='black', linewidth=1.5)
        ax.text(start + (end - start) / 2, i, f'{i}',
                ha='center', va='center', fontsize=10, fontweight='bold')
    
    ax.set_xlabel('时间', fontsize=12)
    ax.set_ylabel('活动编号', fontsize=12)
    ax.set_title('活动选择问题：贪心算法结果\n（绿色=选中，灰色=未选）', fontsize=13)
    ax.grid(axis='x', alpha=0.3)
    ax.set_yticks(range(len(activities)))
    
    ax = axes[1]
    ns = [r['n'] for r in results]
    greedy_counts = [r['greedy_count'] for r in results]
    dp_counts = [r['dp_count'] for r in results]
    
    x = np.arange(len(ns))
    width = 0.35
    
    ax.bar(x - width/2, greedy_counts, width, label='贪心算法', alpha=0.8)
    ax.bar(x + width/2, dp_counts, width, label='动态规划', alpha=0.8)
    
    ax.set_xlabel('问题规模', fontsize=12)
    ax.set_ylabel('选中活动数量', fontsize=12)
    ax.set_title('贪心算法正确性验证', fontsize=13)
    ax.set_xticks(x)
    ax.set_xticklabels([f'n={n}' for n in ns])
    ax.legend()
    ax.grid(axis='y', alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('exp1_greedy_correctness.png', dpi=150, bbox_inches='tight')
    print("\n图表已保存: exp1_greedy_correctness.png")
    plt.close()

