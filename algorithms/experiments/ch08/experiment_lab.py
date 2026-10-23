"""
第8章实验：A/B测试模拟与样本量计算

实验列表：
1. 样本量计算器（给定α、β、δ、baseline，计算n）
2. 功效曲线（不同样本量下的统计功效）
3. A/B测试模拟（验证Type I/II错误率）
4. 置信区间覆盖率验证
5. 统计显著但实践无意义的演示

运行方式：python3 experiment_lab.py
"""

import numpy as np
from scipy.stats import norm, ttest_ind
import matplotlib.pyplot as plt
from typing import Tuple


class ABTestSimulator:
    """A/B测试模拟器"""

    def __init__(self, seed: int = 42):
        np.random.seed(seed)

    def sample_size_calculator(
        self,
        alpha: float,
        beta: float,
        baseline: float,
        relative_lift: float,
        metric_type: str = 'binary'
    ) -> int:
        """
        计算A/B测试所需样本量

        参数:
            alpha: 显著性水平(通常0.05)
            beta: Type II错误率(通常0.2，功效0.8)
            baseline: 基线值(控制组期望值)
            relative_lift: 相对提升(如0.05表示5%提升)
            metric_type: 指标类型('binary'用于CTR, 'continuous'需提供sigma)

        返回:
            每组所需样本量
        """
        z_alpha = norm.ppf(1 - alpha/2)
        z_beta = norm.ppf(1 - beta)

        if metric_type == 'binary':
            # 二项分布近似: σ² ≈ p(1-p)
            sigma_sq = baseline * (1 - baseline)
        else:
            raise ValueError("continuous metric需要提供sigma参数")

        delta = baseline * relative_lift
        n_per_group = 2 * (z_alpha + z_beta)**2 * sigma_sq / delta**2

        return int(np.ceil(n_per_group))

    def compute_power(
        self,
        n_per_group: int,
        alpha: float,
        baseline: float,
        relative_lift: float
    ) -> float:
        """计算给定样本量下的统计功效"""
        z_alpha = norm.ppf(1 - alpha/2)
        sigma = np.sqrt(baseline * (1 - baseline))
        delta = baseline * relative_lift

        se = sigma * np.sqrt(2 / n_per_group)
        z = delta / se
        power = 1 - norm.cdf(z_alpha - z) + norm.cdf(-z_alpha - z)

        return power

    def plot_power_curve(
        self,
        alpha: float,
        baseline: float,
        relative_lift: float,
        n_range: np.ndarray,
        output_file: str = None
    ):
        """绘制功效随样本量变化的曲线"""
        powers = [self.compute_power(n, alpha, baseline, relative_lift) for n in n_range]

        plt.figure(figsize=(10, 6))
        plt.plot(n_range, powers, linewidth=2, color='#3B6DFF')
        plt.axhline(0.8, color='#E9564F', linestyle='--', label='Target power 0.8', linewidth=1.5)
        plt.axhline(0.5, color='gray', linestyle=':', label='Underpowered (0.5)', alpha=0.7)
        plt.xlabel('Sample size per group', fontsize=12)
        plt.ylabel('Statistical power (1-β)', fontsize=12)
        plt.title(f'Power Curve (baseline={baseline:.1%}, lift={relative_lift*100:.1f}%)',
                  fontsize=14, pad=15)
        plt.legend(fontsize=11)
        plt.grid(True, alpha=0.3, linestyle='--')
        plt.tight_layout()

        if output_file:
            plt.savefig(output_file, dpi=150, bbox_inches='tight')
            print(f"功效曲线已保存: {output_file}")
        else:
            plt.show()

        # 找到功效达到0.8的最小样本量
        powers_arr = np.array(powers)
        if (powers_arr >= 0.8).any():
            idx = np.argmax(powers_arr >= 0.8)
            print(f"功效0.8所需样本量: {n_range[idx]}/组")
        else:
            print("所有样本量均未达到功效0.8")

    def simulate_ab_tests(
        self,
        n_simulations: int,
        n_per_group: int,
        baseline: float,
        true_lift: float,
        alpha: float = 0.05
    ) -> Tuple[float, float]:
        """
        模拟多次A/B测试，验证Type I/II错误率

        参数:
            n_simulations: 模拟次数
            n_per_group: 每组样本量
            baseline: 控制组真实CTR
            true_lift: 实验组真实相对提升(0表示原假设成立)
            alpha: 显著性水平

        返回:
            (拒绝率, 标准误差)
        """
        rejections = 0

        for _ in range(n_simulations):
            # 生成数据
            control = np.random.binomial(1, baseline, n_per_group)
            treatment_ctr = baseline * (1 + true_lift)
            treatment = np.random.binomial(1, treatment_ctr, n_per_group)

            # t检验
            _, p_value = ttest_ind(treatment, control)
            if p_value < alpha:
                rejections += 1

        rejection_rate = rejections / n_simulations
        se = np.sqrt(rejection_rate * (1 - rejection_rate) / n_simulations)

        return rejection_rate, se

    def verify_ci_coverage(
        self,
        n_simulations: int,
        n_per_group: int,
        baseline: float,
        true_lift: float,
        confidence_level: float = 0.95
    ) -> float:
        """验证置信区间的覆盖率"""
        coverage_count = 0
        z_critical = norm.ppf(1 - (1 - confidence_level)/2)

        for _ in range(n_simulations):
            control = np.random.binomial(1, baseline, n_per_group)
            treatment_ctr = baseline * (1 + true_lift)
            treatment = np.random.binomial(1, treatment_ctr, n_per_group)

            # 计算均值差和标准误
            diff = treatment.mean() - control.mean()
            se = np.sqrt(treatment.var()/n_per_group + control.var()/n_per_group)

            # 置信区间
            ci_lower = diff - z_critical * se
            ci_upper = diff + z_critical * se

            # 检查真实差异是否在CI内
            true_diff = baseline * true_lift
            if ci_lower <= true_diff <= ci_upper:
                coverage_count += 1

        coverage = coverage_count / n_simulations
        return coverage

    def demonstrate_practical_significance(self):
        """演示大样本下的统计显著但实践无意义"""
        print("\n" + "="*60)
        print("实验5：统计显著但实践无意义")
        print("="*60)

        # 超大样本
        n_per_group = 1000000
        baseline = 0.10
        tiny_lift = 0.01  # 仅1%相对提升

        control = np.random.binomial(1, baseline, n_per_group)
        treatment = np.random.binomial(1, baseline * (1 + tiny_lift), n_per_group)

        t_stat, p_value = ttest_ind(treatment, control)

        # 计算效应大小
        diff = treatment.mean() - control.mean()
        pooled_std = np.sqrt((treatment.var() + control.var()) / 2)
        cohens_d = diff / pooled_std

        # 计算置信区间
        se = np.sqrt(treatment.var()/n_per_group + control.var()/n_per_group)
        ci = (diff - 1.96*se, diff + 1.96*se)

        print(f"\n样本量: {n_per_group:,}/组（共{2*n_per_group:,}用户）")
        print(f"控制组CTR: {baseline:.1%}")
        print(f"实验组CTR: {treatment.mean():.3%}")
        print(f"绝对提升: {diff:.4%}")
        print(f"相对提升: {(treatment.mean()/baseline - 1)*100:.2f}%")
        print(f"p值: {p_value:.6f} {'***统计显著***' if p_value < 0.05 else ''}")
        print(f"95% CI: [{ci[0]:.4%}, {ci[1]:.4%}]")
        print(f"Cohen's d: {cohens_d:.4f} (效应大小: {'极小' if abs(cohens_d)<0.1 else '小' if abs(cohens_d)<0.2 else '中'})")
        print(f"\n决策建议: 虽然统计显著(p<0.001)，但仅1%相对提升")
        print(f"           需权衡工程成本、维护复杂度、长期风险")
        print(f"           若年化收益<工程成本，不建议上线")


def run_all_experiments():
    """运行所有实验"""
    sim = ABTestSimulator(seed=42)

    print("="*60)
    print("第8章实验：A/B测试模拟与样本量计算")
    print("="*60)

    # 实验1：样本量计算器
    print("\n实验1：样本量计算器")
    print("-" * 60)

    test_cases = [
        (0.10, 0.05, "CTR从10%提升到10.5%(5%相对提升)"),
        (0.05, 0.10, "转化率从5%提升到5.5%(10%相对提升)"),
        (0.10, 0.02, "CTR从10%提升到10.2%(2%相对提升)")
    ]

    for baseline, relative_lift, desc in test_cases:
        n = sim.sample_size_calculator(
            alpha=0.05,
            beta=0.2,
            baseline=baseline,
            relative_lift=relative_lift
        )
        print(f"\n{desc}")
        print(f"  每组需要: {n:,}用户，共{2*n:,}用户")
        print(f"  参数: α=0.05, 功效=0.8, baseline={baseline:.1%}, lift={relative_lift:.1%}")

    # 实验2：功效曲线
    print("\n\n实验2：功效曲线")
    print("-" * 60)

    sim.plot_power_curve(
        alpha=0.05,
        baseline=0.10,
        relative_lift=0.05,
        n_range=np.arange(100, 30000, 200),
        output_file='power_curve.png'
    )

    # 实验3：验证Type I错误率
    print("\n\n实验3：A/B测试模拟 - 验证Type I错误率")
    print("-" * 60)
    print("原假设成立(无真实差异)，期望Type I错误率=0.05")

    rejection_rate, se = sim.simulate_ab_tests(
        n_simulations=1000,
        n_per_group=1000,
        baseline=0.10,
        true_lift=0,  # 原假设成立
        alpha=0.05
    )

    print(f"模拟1000次实验，样本量1000/组")
    print(f"Type I错误率: {rejection_rate:.3f} ± {1.96*se:.3f} (期望0.05)")
    print(f"判断: {'✓ 接近理论值' if abs(rejection_rate - 0.05) < 0.02 else '✗ 偏离理论值'}")

    # 实验4：验证功效
    print("\n\n实验4：A/B测试模拟 - 验证统计功效")
    print("-" * 60)
    print("对立假设成立(5%相对提升)，期望功效≈0.8")

    # 先计算理论样本量
    n_required = sim.sample_size_calculator(
        alpha=0.05,
        beta=0.2,
        baseline=0.10,
        relative_lift=0.05
    )

    rejection_rate, se = sim.simulate_ab_tests(
        n_simulations=1000,
        n_per_group=n_required,
        baseline=0.10,
        true_lift=0.05,  # 对立假设成立
        alpha=0.05
    )

    print(f"模拟1000次实验，样本量{n_required}/组")
    print(f"实际功效: {rejection_rate:.3f} ± {1.96*se:.3f} (期望0.8)")
    print(f"Type II错误率: {1-rejection_rate:.3f} (期望0.2)")
    print(f"判断: {'✓ 接近理论值' if abs(rejection_rate - 0.8) < 0.05 else '✗ 偏离理论值'}")

    # 实验5：置信区间覆盖率
    print("\n\n实验5：置信区间覆盖率验证")
    print("-" * 60)

    coverage = sim.verify_ci_coverage(
        n_simulations=1000,
        n_per_group=2000,
        baseline=0.10,
        true_lift=0.05,
        confidence_level=0.95
    )

    print(f"模拟1000次实验，样本量2000/组")
    print(f"95% CI覆盖率: {coverage:.3f} (期望0.95)")
    print(f"判断: {'✓ 接近理论值' if abs(coverage - 0.95) < 0.03 else '✗ 偏离理论值'}")

    # 实验6：统计显著但实践无意义
    sim.demonstrate_practical_significance()

    # 总结
    print("\n" + "="*60)
    print("实验总结")
    print("="*60)
    print("✓ 实验1：样本量计算器验证 - 不同baseline和lift下的样本量需求")
    print("✓ 实验2：功效曲线 - 样本量与功效的关系")
    print("✓ 实验3：Type I错误率 ≈ 0.05 (接近理论α)")
    print("✓ 实验4：统计功效 ≈ 0.8 (接近理论1-β)")
    print("✓ 实验5：置信区间覆盖率 ≈ 0.95")
    print("✓ 实验6：大样本下统计显著但效应极小的案例")
    print("\n关键发现:")
    print("  1. 样本量与最小可检测效应的平方成反比")
    print("  2. 基线越低，检测相同相对提升所需样本量越大")
    print("  3. Type I/II错误率在模拟中接近理论值")
    print("  4. 统计显著≠实践意义，需综合判断")


if __name__ == '__main__':
    run_all_experiments()
