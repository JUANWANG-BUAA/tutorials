#!/usr/bin/env python3
"""
第 14 章实验：异质性与个性化因果
验证 CATE 估计、Uplift 建模与 Meta-learner 的实际表现。

Requires: numpy, scipy, matplotlib
"""
import numpy as np
import matplotlib.pyplot as plt
from typing import Tuple
from dataclasses import dataclass

np.random.seed(42)

@dataclass
class SimulationResult:
    """模拟结果容器"""
    X: np.ndarray
    T: np.ndarray
    Y: np.ndarray
    true_cate: np.ndarray

def generate_heterogeneous_data(n: int = 2000, p: int = 5, noise_std: float = 0.5) -> SimulationResult:
    """生成具有异质性因果效应的数据"""
    X = np.random.randn(n, p)
    propensity = 1 / (1 + np.exp(-X[:, 1]))
    T = (np.random.rand(n) < propensity).astype(int)

    true_cate = np.zeros(n)
    true_cate[X[:, 0] < -0.5] = -2.0
    true_cate[(X[:, 0] >= -0.5) & (X[:, 0] < 0.5)] = 0.0
    true_cate[X[:, 0] >= 0.5] = 3.0

    Y0 = 2 * X[:, 0] + X[:, 2] + noise_std * np.random.randn(n)
    Y = Y0 + T * true_cate

    return SimulationResult(X=X, T=T, Y=Y, true_cate=true_cate)

class SLearner:
    """S-learner: 单模型学习器"""
    def __init__(self):
        self.beta = None

    def fit(self, X: np.ndarray, T: np.ndarray, Y: np.ndarray) -> None:
        n, p = X.shape
        Z = np.column_stack([X, T])
        Z_with_intercept = np.column_stack([np.ones(n), Z])
        self.beta = np.linalg.lstsq(Z_with_intercept, Y, rcond=None)[0]

    def predict_cate(self, X: np.ndarray) -> np.ndarray:
        n = X.shape[0]
        Z1 = np.column_stack([np.ones(n), X, np.ones(n)])
        Y1_pred = Z1 @ self.beta
        Z0 = np.column_stack([np.ones(n), X, np.zeros(n)])
        Y0_pred = Z0 @ self.beta
        return Y1_pred - Y0_pred

class TLearner:
    """T-learner: 双模型学习器"""
    def __init__(self):
        self.beta0 = None
        self.beta1 = None

    def fit(self, X: np.ndarray, T: np.ndarray, Y: np.ndarray) -> None:
        n, p = X.shape
        X_with_intercept = np.column_stack([np.ones(n), X])
        mask0 = (T == 0)
        self.beta0 = np.linalg.lstsq(X_with_intercept[mask0], Y[mask0], rcond=None)[0]
        mask1 = (T == 1)
        self.beta1 = np.linalg.lstsq(X_with_intercept[mask1], Y[mask1], rcond=None)[0]

    def predict_cate(self, X: np.ndarray) -> np.ndarray:
        X_with_intercept = np.column_stack([np.ones(X.shape[0]), X])
        Y1_pred = X_with_intercept @ self.beta1
        Y0_pred = X_with_intercept @ self.beta0
        return Y1_pred - Y0_pred

def compute_uplift_curve(y_true: np.ndarray, t: np.ndarray, cate_pred: np.ndarray, n_bins: int = 10) -> Tuple[np.ndarray, np.ndarray]:
    """计算 Uplift 曲线"""
    order = np.argsort(-cate_pred)
    y_sorted = y_true[order]
    t_sorted = t[order]

    percentiles = np.linspace(0, 100, n_bins + 1)
    uplift = np.zeros(n_bins + 1)

    for i, pct in enumerate(percentiles):
        n_top = int(len(y_sorted) * pct / 100)
        if n_top == 0:
            uplift[i] = 0
            continue
        y_top = y_sorted[:n_top]
        t_top = t_sorted[:n_top]
        if t_top.sum() > 0 and (1 - t_top).sum() > 0:
            uplift[i] = y_top[t_top == 1].mean() - y_top[t_top == 0].mean()
        else:
            uplift[i] = 0

    return percentiles, uplift

def compute_qini_coefficient(y_true: np.ndarray, t: np.ndarray, cate_pred: np.ndarray) -> float:
    """计算 Qini 系数"""
    percentiles, uplift = compute_uplift_curve(y_true, t, cate_pred, n_bins=20)
    integrate_fn = getattr(np, 'trapezoid', getattr(np, 'trapz', None))
    return float(integrate_fn(uplift, percentiles / 100))

def experiment_1_s_vs_t_learner():
    """实验 1：S-learner vs T-learner 对比"""
    print("\n[实验 1] S-learner vs T-learner 性能对比")
    print("-" * 60)

    data = generate_heterogeneous_data(n=2000, p=5)
    n_train = 1500
    X_train, X_test = data.X[:n_train], data.X[n_train:]
    T_train, T_test = data.T[:n_train], data.T[n_train:]
    Y_train, Y_test = data.Y[:n_train], data.Y[n_train:]
    true_cate_test = data.true_cate[n_train:]

    s_learner = SLearner()
    s_learner.fit(X_train, T_train, Y_train)
    cate_s = s_learner.predict_cate(X_test)

    t_learner = TLearner()
    t_learner.fit(X_train, T_train, Y_train)
    cate_t = t_learner.predict_cate(X_test)

    rmse_s = np.sqrt(np.mean((cate_s - true_cate_test) ** 2))
    rmse_t = np.sqrt(np.mean((cate_t - true_cate_test) ** 2))

    print(f"S-learner RMSE: {rmse_s:.3f}")
    print(f"T-learner RMSE: {rmse_t:.3f}")
    print(f"T-learner 相对改进: {(rmse_s - rmse_t) / rmse_s * 100:.1f}%")

    groups = [
        (true_cate_test == -2.0, "负效应组 (τ=-2)"),
        (true_cate_test == 0.0, "零效应组 (τ=0)"),
        (true_cate_test == 3.0, "正效应组 (τ=3)")
    ]

    print("\n按真实效应分组的预测均值：")
    print(f"{'组别':<20} {'真实CATE':<12} {'S预测':<12} {'T预测':<12}")
    print("-" * 60)
    for mask, name in groups:
        if mask.sum() > 0:
            true_mean = true_cate_test[mask].mean()
            s_mean = cate_s[mask].mean()
            t_mean = cate_t[mask].mean()
            print(f"{name:<20} {true_mean:>10.2f}  {s_mean:>10.2f}  {t_mean:>10.2f}")

def experiment_2_uplift_curve():
    """实验 2：Uplift 曲线可视化"""
    print("\n[实验 2] Uplift 曲线分析")
    print("-" * 60)

    data = generate_heterogeneous_data(n=2000, p=5)
    n_train = 1500
    X_train, X_test = data.X[:n_train], data.X[n_train:]
    T_train, T_test = data.T[:n_train], data.T[n_train:]
    Y_train, Y_test = data.Y[:n_train], data.Y[n_train:]

    t_learner = TLearner()
    t_learner.fit(X_train, T_train, Y_train)
    cate_pred = t_learner.predict_cate(X_test)

    percentiles, uplift = compute_uplift_curve(Y_test, T_test, cate_pred, n_bins=10)
    qini = compute_qini_coefficient(Y_test, T_test, cate_pred)

    print(f"Qini 系数: {qini:.3f}")
    print("\nUplift 曲线数据点：")
    print(f"{'Top %':<10} {'累积Uplift':<15}")
    print("-" * 30)
    for pct, upl in zip(percentiles, uplift):
        print(f"{pct:>6.0f}%   {upl:>12.3f}")

    try:
        plt.figure(figsize=(8, 6))
        plt.plot(percentiles, uplift, 'b-', linewidth=2, label='T-learner')
        plt.axhline(y=0, color='gray', linestyle='--', alpha=0.5)
        plt.xlabel('Top % of Predicted CATE', fontsize=12)
        plt.ylabel('Cumulative Uplift', fontsize=12)
        plt.title('Uplift Curve', fontsize=14)
        plt.legend()
        plt.grid(True, alpha=0.3)
        plt.tight_layout()
        plt.savefig('/tmp/ch14_uplift_curve.png', dpi=150)
        print("\n图表已保存至 /tmp/ch14_uplift_curve.png")
    except Exception as e:
        print(f"\n无法生成图表: {e}")

def experiment_3_cate_distribution():
    """实验 3：CATE 估计分布"""
    print("\n[实验 3] CATE 估计分布分析")
    print("-" * 60)

    data = generate_heterogeneous_data(n=2000, p=5)
    n_train = 1500
    X_train, X_test = data.X[:n_train], data.X[n_train:]
    T_train, T_test = data.T[:n_train], data.T[n_train:]
    Y_train, Y_test = data.Y[:n_train], data.Y[n_train:]
    true_cate_test = data.true_cate[n_train:]

    s_learner = SLearner()
    s_learner.fit(X_train, T_train, Y_train)
    cate_s = s_learner.predict_cate(X_test)

    t_learner = TLearner()
    t_learner.fit(X_train, T_train, Y_train)
    cate_t = t_learner.predict_cate(X_test)

    print("CATE 估计的分布统计：")
    print(f"{'方法':<15} {'均值':<12} {'标准差':<12} {'最小值':<12} {'最大值':<12}")
    print("-" * 60)

    for name, cate in [("真实CATE", true_cate_test), ("S-learner", cate_s), ("T-learner", cate_t)]:
        print(f"{name:<15} {cate.mean():>10.3f}  {cate.std():>10.3f}  {cate.min():>10.3f}  {cate.max():>10.3f}")

    corr_s = np.corrcoef(true_cate_test, cate_s)[0, 1]
    corr_t = np.corrcoef(true_cate_test, cate_t)[0, 1]

    print(f"\n与真实CATE的相关系数：")
    print(f"S-learner: {corr_s:.3f}")
    print(f"T-learner: {corr_t:.3f}")

if __name__ == "__main__":
    print("=" * 60)
    print("第 14 章实验：异质性与个性化因果")
    print("=" * 60)

    experiment_1_s_vs_t_learner()
    experiment_2_uplift_curve()
    experiment_3_cate_distribution()

    print("\n" + "=" * 60)
    print("所有实验完成")
    print("=" * 60)
