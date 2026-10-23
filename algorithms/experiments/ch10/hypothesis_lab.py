#!/usr/bin/env python3
"""
第 10 章实验：假设检验与多重比较
验证 t 检验、多重检验校正、统计功效的实际表现。

Requires: numpy, scipy
"""
import random
import numpy as np
from scipy import stats
from typing import Tuple, List
from collections import defaultdict

# 固定随机种子，保证可复现
random.seed(42)
np.random.seed(42)

# ========== 实验 1：t 检验与 I 类错误率 ==========

def simulate_type_i_error(
    n_samples: int = 30,
    n_experiments: int = 10000,
    alpha: float = 0.05,
    mu: float = 0.0,
    sigma: float = 1.0
) -> float:
    """
    模拟 I 类错误率：H0 为真时，检验拒绝的比例。

    Args:
        n_samples: 每次实验的样本量
        n_experiments: 重复实验次数
        alpha: 显著性水平
        mu, sigma: H0 下的真实分布参数

    Returns:
        实际 I 类错误率（应接近 alpha）
    """
    reject_count = 0

    for _ in range(n_experiments):
        # 从 H0 分布采样
        sample = np.random.normal(mu, sigma, n_samples)

        # 单样本 t 检验：H0: mu = 0
        t_stat, p_value = stats.ttest_1samp(sample, 0.0)

        if p_value < alpha:
            reject_count += 1

    return reject_count / n_experiments

def simulate_type_ii_error(
    n_samples: int = 30,
    n_experiments: int = 10000,
    alpha: float = 0.05,
    true_mu: float = 0.5,
    sigma: float = 1.0
) -> Tuple[float, float]:
    """
    模拟 II 类错误率（β）和统计功效（1 - β）：H1 为真时，检验未拒绝 H0 的比例。

    Args:
        true_mu: H1 下的真实均值（效应量）
        其他参数同上

    Returns:
        (beta, power): II 类错误率和统计功效
    """
    not_reject_count = 0

    for _ in range(n_experiments):
        # 从 H1 分布采样
        sample = np.random.normal(true_mu, sigma, n_samples)

        # 单样本 t 检验：H0: mu = 0
        t_stat, p_value = stats.ttest_1samp(sample, 0.0)

        if p_value >= alpha:
            not_reject_count += 1

    beta = not_reject_count / n_experiments
    power = 1 - beta
    return beta, power

# ========== 实验 2：双样本 t 检验 ==========

def two_sample_t_test_demo():
    """
    演示双样本 t 检验：比较两组算法的运行时间。
    """
    # 算法 A 的运行时间（毫秒）
    algo_a = np.array([12.3, 15.1, 13.8, 14.5, 16.2, 12.9, 14.1, 13.5, 15.7, 14.3])

    # 算法 B 的运行时间（毫秒）
    algo_b = np.array([18.5, 17.2, 19.1, 16.8, 18.9, 17.5, 19.3, 18.1, 17.9, 18.6])

    # 独立样本 t 检验
    t_stat, p_value = stats.ttest_ind(algo_a, algo_b)

    print("=== 双样本 t 检验 ===")
    print(f"算法 A 均值: {np.mean(algo_a):.2f} ms")
    print(f"算法 B 均值: {np.mean(algo_b):.2f} ms")
    print(f"t 统计量: {t_stat:.4f}")
    print(f"p 值: {p_value:.6f}")

    if p_value < 0.05:
        print("结论：拒绝 H0，两组运行时间有显著差异（α = 0.05）")
    else:
        print("结论：不拒绝 H0，无显著差异（α = 0.05）")

    # 计算 Cohen's d（效应量）
    pooled_std = np.sqrt(((len(algo_a) - 1) * np.var(algo_a, ddof=1) +
                          (len(algo_b) - 1) * np.var(algo_b, ddof=1)) /
                         (len(algo_a) + len(algo_b) - 2))
    cohens_d = (np.mean(algo_b) - np.mean(algo_a)) / pooled_std
    print(f"Cohen's d: {cohens_d:.4f}")
    print()

# ========== 实验 3：多重检验问题 ==========

def multiple_testing_problem(
    n_hypotheses: int = 20,
    n_experiments: int = 1000,
    alpha: float = 0.05
) -> Tuple[float, float]:
    """
    演示多重检验问题：测试 20 个 H0 为真的假设，看有多少被错误拒绝。

    Args:
        n_hypotheses: 假设数量
        n_experiments: 重复实验次数
        alpha: 单次检验显著性水平

    Returns:
        (fwer, avg_false_positives): 家族错误率和平均假阳性数
    """
    family_wise_errors = 0
    total_false_positives = 0

    for _ in range(n_experiments):
        false_positives = 0

        for _ in range(n_hypotheses):
            # 从 H0 分布采样
            sample = np.random.normal(0, 1, 30)
            _, p_value = stats.ttest_1samp(sample, 0.0)

            if p_value < alpha:
                false_positives += 1

        if false_positives > 0:
            family_wise_errors += 1

        total_false_positives += false_positives

    fwer = family_wise_errors / n_experiments
    avg_fps = total_false_positives / n_experiments

    return fwer, avg_fps

def bonferroni_correction(
    n_hypotheses: int = 20,
    n_experiments: int = 1000,
    alpha: float = 0.05
) -> Tuple[float, float]:
    """
    Bonferroni 校正：将每个检验的 α 调整为 α/m。

    Returns:
        (fwer, avg_false_positives): 校正后的家族错误率和假阳性数
    """
    adjusted_alpha = alpha / n_hypotheses
    family_wise_errors = 0
    total_false_positives = 0

    for _ in range(n_experiments):
        false_positives = 0

        for _ in range(n_hypotheses):
            sample = np.random.normal(0, 1, 30)
            _, p_value = stats.ttest_1samp(sample, 0.0)

            if p_value < adjusted_alpha:
                false_positives += 1

        if false_positives > 0:
            family_wise_errors += 1

        total_false_positives += false_positives

    fwer = family_wise_errors / n_experiments
    avg_fps = total_false_positives / n_experiments

    return fwer, avg_fps

def benjamini_hochberg_fdr(p_values: np.ndarray, alpha: float = 0.05) -> np.ndarray:
    """
    Benjamini-Hochberg 过程控制 FDR（False Discovery Rate）。

    Args:
        p_values: p 值数组
        alpha: 期望的 FDR 水平

    Returns:
        布尔数组，指示每个假设是否应拒绝
    """
    m = len(p_values)
    # 排序 p 值并记录原始索引
    sorted_indices = np.argsort(p_values)
    sorted_p = p_values[sorted_indices]

    # BH 临界值：p_(i) <= (i/m) * alpha
    critical_values = np.arange(1, m + 1) / m * alpha

    # 找到最大的 i 使得 p_(i) <= (i/m) * alpha
    reject = sorted_p <= critical_values
    if not reject.any():
        return np.zeros(m, dtype=bool)

    max_i = np.where(reject)[0][-1]

    # 拒绝前 max_i + 1 个假设
    result = np.zeros(m, dtype=bool)
    result[sorted_indices[:max_i + 1]] = True

    return result

def compare_corrections():
    """
    比较无校正、Bonferroni 和 BH 过程。
    """
    print("=== 多重检验校正比较 ===")

    # 生成 20 个 p 值：18 个来自 H0，2 个来自 H1
    np.random.seed(123)
    p_h0 = np.random.uniform(0, 1, 18)  # H0 为真，p 值均匀分布
    p_h1 = np.array([0.001, 0.003])    # H1 为真，p 值很小

    p_values = np.concatenate([p_h0, p_h1])
    true_nulls = np.array([True] * 18 + [False] * 2)

    alpha = 0.05

    # 无校正
    no_corr = p_values < alpha
    fp_no_corr = np.sum(no_corr & true_nulls)
    tp_no_corr = np.sum(no_corr & ~true_nulls)

    # Bonferroni
    bonf = p_values < (alpha / len(p_values))
    fp_bonf = np.sum(bonf & true_nulls)
    tp_bonf = np.sum(bonf & ~true_nulls)

    # BH
    bh = benjamini_hochberg_fdr(p_values, alpha)
    fp_bh = np.sum(bh & true_nulls)
    tp_bh = np.sum(bh & ~true_nulls)

    print(f"无校正：拒绝 {no_corr.sum()} 个，假阳性 {fp_no_corr}，真阳性 {tp_no_corr}")
    print(f"Bonferroni：拒绝 {bonf.sum()} 个，假阳性 {fp_bonf}，真阳性 {tp_bonf}")
    print(f"BH (FDR)：拒绝 {bh.sum()} 个，假阳性 {fp_bh}，真阳性 {tp_bh}")
    print()

# ========== 实验 4：统计功效与样本量 ==========

def power_analysis_sample_size(
    effect_size: float = 0.5,
    alpha: float = 0.05,
    power: float = 0.8,
    sigma: float = 1.0
) -> int:
    """
    通过模拟估计达到目标功效所需的样本量。

    Args:
        effect_size: Cohen's d（标准化效应量）
        alpha: I 类错误率
        power: 目标统计功效
        sigma: 总体标准差

    Returns:
        所需样本量
    """
    # 真实均值差
    mu_diff = effect_size * sigma

    # 二分搜索样本量
    n_min, n_max = 5, 1000
    target_n = n_min

    while n_min <= n_max:
        n = (n_min + n_max) // 2

        # 模拟功效
        reject_count = 0
        n_sim = 10000

        for _ in range(n_sim):
            sample = np.random.normal(mu_diff, sigma, n)
            _, p_value = stats.ttest_1samp(sample, 0.0)

            if p_value < alpha:
                reject_count += 1

        estimated_power = reject_count / n_sim

        if estimated_power < power:
            n_min = n + 1
        else:
            target_n = n
            n_max = n - 1

    return target_n

def power_curve_demo():
    """
    绘制功效曲线：功效随样本量变化。
    """
    print("=== 统计功效与样本量 ===")

    effect_size = 0.5
    alpha = 0.05
    sample_sizes = [10, 20, 30, 50, 70, 100]

    print(f"效应量: {effect_size} (Cohen's d)")
    print(f"显著性水平: {alpha}")
    print()
    print("样本量\t功效")
    print("-" * 20)

    for n in sample_sizes:
        # 模拟功效
        reject_count = 0
        n_sim = 5000

        for _ in range(n_sim):
            sample = np.random.normal(effect_size, 1.0, n)
            _, p_value = stats.ttest_1samp(sample, 0.0)

            if p_value < alpha:
                reject_count += 1

        power = reject_count / n_sim
        print(f"{n}\t{power:.4f}")

    print()

# ========== 实验 5：p-hacking 演示 ==========

def p_hacking_demo(n_attempts: int = 20, alpha: float = 0.05) -> dict:
    """
    演示 p-hacking：反复尝试不同的数据切分/变换，直到找到 p < 0.05。

    Args:
        n_attempts: 尝试次数
        alpha: 显著性水平

    Returns:
        包含结果的字典
    """
    # 生成两组无差异的数据
    np.random.seed(456)
    group_a = np.random.normal(100, 15, 100)
    group_b = np.random.normal(100, 15, 100)

    results = {
        "attempts": [],
        "first_significant": None
    }

    for i in range(n_attempts):
        # 尝试不同的"分析"
        if i == 0:
            # 原始 t 检验
            _, p = stats.ttest_ind(group_a, group_b)
            method = "原始 t 检验"
        elif i == 1:
            # 移除"异常值"（> 2 std）
            a_clean = group_a[np.abs(group_a - np.mean(group_a)) < 2 * np.std(group_a)]
            b_clean = group_b[np.abs(group_b - np.mean(group_b)) < 2 * np.std(group_b)]
            _, p = stats.ttest_ind(a_clean, b_clean)
            method = "移除异常值后"
        elif i == 2:
            # 只看前 50 个样本
            _, p = stats.ttest_ind(group_a[:50], group_b[:50])
            method = "子集分析 (n=50)"
        elif i == 3:
            # 按中位数分组
            median_a = np.median(group_a)
            _, p = stats.ttest_ind(group_a[group_a > median_a],
                                    group_b[group_b > median_a])
            method = "高于中位数组"
        else:
            # 随机子集
            np.random.seed(i)
            idx_a = np.random.choice(100, 60, replace=False)
            idx_b = np.random.choice(100, 60, replace=False)
            _, p = stats.ttest_ind(group_a[idx_a], group_b[idx_b])
            method = f"随机子集 {i-3}"

        results["attempts"].append({
            "method": method,
            "p_value": p
        })

        if p < alpha and results["first_significant"] is None:
            results["first_significant"] = i + 1

    return results

def demonstrate_p_hacking():
    """
    演示 p-hacking 的危害。
    """
    print("=== p-hacking 演示 ===")
    print("两组数据从同一分布 N(100, 15) 采样，真实差异为 0。")
    print("通过反复尝试不同分析方法，寻找 p < 0.05...\n")

    results = p_hacking_demo(n_attempts=10)

    for i, attempt in enumerate(results["attempts"], 1):
        p = attempt["p_value"]
        method = attempt["method"]
        star = " *** 显著！" if p < 0.05 else ""
        print(f"{i}. {method:20s} p = {p:.4f}{star}")

    if results["first_significant"]:
        print(f"\n在第 {results['first_significant']} 次尝试找到'显著'结果！")
        print("这是典型的 I 类错误：H0 为真但被错误拒绝。")
    else:
        print("\n所有尝试均未找到显著结果。")

    print()

# ========== 实验 6：Mann-Whitney U 检验（非参数） ==========

def mann_whitney_demo():
    """
    演示 Mann-Whitney U 检验：不假设正态分布。
    """
    print("=== Mann-Whitney U 检验 ===")

    # 生成偏态数据（指数分布）
    np.random.seed(789)
    group_a = np.random.exponential(2.0, 30)
    group_b = np.random.exponential(2.5, 30)

    # t 检验（假设正态）
    t_stat, p_t = stats.ttest_ind(group_a, group_b)

    # Mann-Whitney U 检验（非参数）
    u_stat, p_u = stats.mannwhitneyu(group_a, group_b, alternative='two-sided')

    print(f"组 A 均值: {np.mean(group_a):.2f}, 中位数: {np.median(group_a):.2f}")
    print(f"组 B 均值: {np.mean(group_b):.2f}, 中位数: {np.median(group_b):.2f}")
    print()
    print(f"t 检验 p 值: {p_t:.4f}")
    print(f"Mann-Whitney U 检验 p 值: {p_u:.4f}")
    print()
    print("对于非正态数据，Mann-Whitney 更稳健。")
    print()

# ========== 主函数 ==========

def main():
    print("=" * 60)
    print("第 10 章实验：假设检验与多重比较")
    print("=" * 60)
    print()

    # 实验 1：I 类错误率
    print("实验 1：验证 I 类错误率")
    print("-" * 40)
    alpha = 0.05
    type_i_rate = simulate_type_i_error(n_samples=30, n_experiments=10000, alpha=alpha)
    print(f"理论 I 类错误率（α）: {alpha}")
    print(f"实测 I 类错误率: {type_i_rate:.4f}")
    print(f"差异: {abs(type_i_rate - alpha):.4f}")
    print()

    # 实验 2：II 类错误率与统计功效
    print("实验 2：II 类错误率与统计功效")
    print("-" * 40)
    true_mu = 0.5
    beta, power = simulate_type_ii_error(n_samples=30, true_mu=true_mu, alpha=alpha)
    print(f"真实效应: μ = {true_mu}")
    print(f"II 类错误率（β）: {beta:.4f}")
    print(f"统计功效（1 - β）: {power:.4f}")
    print()

    # 实验 3：双样本 t 检验
    two_sample_t_test_demo()

    # 实验 4：多重检验问题
    print("实验 4：多重检验问题")
    print("-" * 40)
    fwer_no_corr, fps_no_corr = multiple_testing_problem(n_hypotheses=20)
    print(f"测试 20 个 H0 为真的假设（α = 0.05）")
    print(f"家族错误率（至少一个假阳性）: {fwer_no_corr:.4f}")
    print(f"期望: 1 - (1 - 0.05)^20 = {1 - 0.95**20:.4f}")
    print(f"平均假阳性数: {fps_no_corr:.2f}")
    print(f"期望: 20 * 0.05 = {20 * 0.05:.2f}")
    print()

    # 实验 5：Bonferroni 校正
    print("实验 5：Bonferroni 校正")
    print("-" * 40)
    fwer_bonf, fps_bonf = bonferroni_correction(n_hypotheses=20, alpha=alpha)
    print(f"Bonferroni 校正后（α = {alpha / 20:.4f}）")
    print(f"家族错误率: {fwer_bonf:.4f} (目标: {alpha})")
    print(f"平均假阳性数: {fps_bonf:.2f}")
    print()

    # 实验 6：多重检验校正比较
    compare_corrections()

    # 实验 7：统计功效与样本量
    power_curve_demo()

    # 实验 8：p-hacking 演示
    demonstrate_p_hacking()

    # 实验 9：Mann-Whitney U 检验
    mann_whitney_demo()

    print("=" * 60)
    print("所有实验完成！")
    print("=" * 60)

if __name__ == "__main__":
    main()

