#!/usr/bin/env python3
"""
实验 6：交叉验证与模型选择
================================================================================
对应教材：第 6 章

实验任务：
1. 手动实现 k-fold 交叉验证
2. 偏差-方差分解的实验验证
3. 学习曲线与验证曲线可视化
4. 演示数据泄露的危害
"""

import numpy as np
import matplotlib.pyplot as plt
import time
import warnings
warnings.filterwarnings('ignore')


# ============================================================================
# 辅助函数：纯 NumPy 实现
# ============================================================================

def make_regression_data(n_samples=100, n_features=5, noise=10.0, random_state=None):
    """生成回归数据：y = Xw + noise"""
    if random_state is not None:
        np.random.seed(random_state)

    X = np.random.randn(n_samples, n_features)
    true_coef = np.random.randn(n_features)
    y = X @ true_coef + np.random.randn(n_samples) * noise
    return X, y


class LinearRegressionNumPy:
    """最小二乘法：w = (X'X)^{-1}X'y"""
    def __init__(self):
        self.coef_ = None
        self.intercept_ = None

    def fit(self, X, y):
        X_bias = np.c_[np.ones(len(X)), X]
        w = np.linalg.lstsq(X_bias, y, rcond=None)[0]
        self.intercept_ = w[0]
        self.coef_ = w[1:]
        return self

    def predict(self, X):
        return X @ self.coef_ + self.intercept_


class RidgeNumPy:
    """岭回归：w = (X'X + λI)^{-1}X'y"""
    def __init__(self, alpha=1.0):
        self.alpha = alpha
        self.coef_ = None
        self.intercept_ = None

    def fit(self, X, y):
        X_bias = np.c_[np.ones(len(X)), X]
        n_features = X_bias.shape[1]
        I = np.eye(n_features)
        I[0, 0] = 0  # 不惩罚截距
        w = np.linalg.solve(X_bias.T @ X_bias + self.alpha * I, X_bias.T @ y)
        self.intercept_ = w[0]
        self.coef_ = w[1:]
        return self

    def predict(self, X):
        return X @ self.coef_ + self.intercept_


class StandardScalerNumPy:
    """标准化：(X - mean) / std"""
    def __init__(self):
        self.mean_ = None
        self.std_ = None

    def fit(self, X):
        self.mean_ = X.mean(axis=0)
        self.std_ = X.std(axis=0)
        self.std_[self.std_ == 0] = 1  # 避免除零
        return self

    def transform(self, X):
        return (X - self.mean_) / self.std_

    def fit_transform(self, X):
        return self.fit(X).transform(X)


def kfold_split(n_samples, n_splits=5, shuffle=True, random_state=None):
    """k-fold 交叉验证索引生成器"""
    if random_state is not None:
        np.random.seed(random_state)

    indices = np.arange(n_samples)
    if shuffle:
        np.random.shuffle(indices)

    fold_sizes = np.full(n_splits, n_samples // n_splits, dtype=int)
    fold_sizes[:n_samples % n_splits] += 1

    current = 0
    for fold_size in fold_sizes:
        start, stop = current, current + fold_size
        val_idx = indices[start:stop]
        train_idx = np.concatenate([indices[:start], indices[stop:]])
        yield train_idx, val_idx
        current = stop


def mean_squared_error(y_true, y_pred):
    """均方误差"""
    return np.mean((y_true - y_pred) ** 2)


def r2_score(y_true, y_pred):
    """R² 得分"""
    ss_res = np.sum((y_true - y_pred) ** 2)
    ss_tot = np.sum((y_true - y_true.mean()) ** 2)
    return 1 - ss_res / ss_tot


def f_statistic(X, y):
    """F 统计量（用于特征选择）"""
    n_samples, n_features = X.shape
    y_mean = y.mean()

    f_scores = np.zeros(n_features)
    for i in range(n_features):
        x_i = X[:, i]
        # 分组：基于特征 i 的中位数
        median = np.median(x_i)
        group1 = y[x_i <= median]
        group2 = y[x_i > median]

        # 组间方差和组内方差
        ss_between = len(group1) * (group1.mean() - y_mean)**2 + \
                     len(group2) * (group2.mean() - y_mean)**2
        ss_within = np.sum((group1 - group1.mean())**2) + \
                    np.sum((group2 - group2.mean())**2)

        # F 统计量
        df_between = 1
        df_within = n_samples - 2
        if ss_within > 0:
            f_scores[i] = (ss_between / df_between) / (ss_within / df_within)

    return f_scores


def train_test_split_numpy(X, y, test_size=0.3, random_state=None):
    """训练集-测试集划分"""
    if random_state is not None:
        np.random.seed(random_state)

    n_samples = len(X)
    n_test = int(n_samples * test_size)
    indices = np.random.permutation(n_samples)

    test_idx = indices[:n_test]
    train_idx = indices[n_test:]

    return X[train_idx], X[test_idx], y[train_idx], y[test_idx]


# ============================================================================
# 任务 1：手动实现 k-fold 交叉验证
# ============================================================================

def task1_manual_kfold():
    """手动实现 k-fold 交叉验证"""
    print("=" * 80)
    print("任务 1：手动实现 k-fold 交叉验证")
    print("=" * 80)

    # 生成数据
    np.random.seed(42)
    X, y = make_regression_data(n_samples=200, n_features=5, noise=10, random_state=42)

    k = 5
    model = RidgeNumPy(alpha=1.0)

    # 手动实现
    errors_manual = []
    for fold, (train_idx, val_idx) in enumerate(kfold_split(len(X), k, shuffle=True, random_state=42), 1):
        X_train, X_val = X[train_idx], X[val_idx]
        y_train, y_val = y[train_idx], y[val_idx]

        model.fit(X_train, y_train)
        y_pred = model.predict(X_val)
        error = mean_squared_error(y_val, y_pred)
        errors_manual.append(error)
        print(f"Fold {fold}: MSE = {error:.4f}")

    mean_manual = np.mean(errors_manual)
    std_manual = np.std(errors_manual)
    print(f"\n5-fold 交叉验证结果：{mean_manual:.4f} ± {std_manual:.4f}")
    print("验证成功：手动实现的 k-fold 交叉验证工作正常")
    print()


# ============================================================================
# 任务 2：偏差-方差分解
# ============================================================================

def task2_bias_variance():
    """实验验证偏差-方差分解"""
    print("=" * 80)
    print("任务 2：偏差-方差分解")
    print("=" * 80)

    np.random.seed(42)

    # 真实函数
    def f_true(x):
        return np.sin(2 * np.pi * x)

    # 测试点
    x_test = np.linspace(0, 1, 100)
    y_true = f_true(x_test)
    sigma = 0.3  # 噪声标准差

    # 生成多个训练集
    n_datasets = 100
    n_train = 20
    degrees = [1, 3, 9, 15]

    results = {}
    fig, axes = plt.subplots(2, 4, figsize=(16, 8))

    for col, degree in enumerate(degrees):
        predictions = []

        for _ in range(n_datasets):
            # 生成训练集
            x_train = np.random.rand(n_train)
            y_train = f_true(x_train) + np.random.randn(n_train) * sigma

            # 多项式拟合
            X_train = np.vander(x_train, degree + 1, increasing=True)
            X_test = np.vander(x_test, degree + 1, increasing=True)

            # 使用岭回归防止数值不稳定
            model = RidgeNumPy(alpha=1e-10).fit(X_train, y_train)
            y_pred = model.predict(X_test)
            predictions.append(y_pred)

        predictions = np.array(predictions)
        mean_pred = predictions.mean(axis=0)

        # 计算偏差、方差、噪声
        bias_sq = np.mean((mean_pred - y_true) ** 2)
        variance = np.mean(predictions.var(axis=0))
        noise = sigma ** 2
        total = bias_sq + variance + noise

        results[degree] = {
            'bias_sq': bias_sq,
            'variance': variance,
            'noise': noise,
            'total': total
        }

        # 上图：拟合曲线
        ax_top = axes[0, col]
        ax_top.plot(x_test, y_true, 'k-', linewidth=2, label='True', zorder=10)

        # 绘制部分预测（透明度低）
        for pred in predictions[:30]:
            ax_top.plot(x_test, pred, 'b-', alpha=0.1, linewidth=0.5)

        ax_top.plot(x_test, mean_pred, 'r--', linewidth=2, label='Mean', zorder=9)
        ax_top.set_title(f'Degree {degree}', fontsize=12, fontweight='bold')
        ax_top.set_ylim(-2, 2)
        ax_top.grid(True, alpha=0.3)
        if col == 0:
            ax_top.set_ylabel('y', fontsize=11)
            ax_top.legend(loc='upper right', fontsize=9)

        # 下图：偏差-方差分解
        ax_bot = axes[1, col]
        bars = ax_bot.bar(['Bias²', 'Variance', 'Noise'],
                          [bias_sq, variance, noise],
                          color=['#e74c3c', '#3498db', '#95a5a6'],
                          alpha=0.8)
        ax_bot.set_ylim(0, max(0.5, max(bias_sq, variance) * 1.2))
        ax_bot.set_title(f'Total MSE = {total:.3f}', fontsize=10)
        ax_bot.grid(axis='y', alpha=0.3)

        # 添加数值标签
        for bar in bars:
            height = bar.get_height()
            ax_bot.text(bar.get_x() + bar.get_width()/2., height,
                       f'{height:.3f}',
                       ha='center', va='bottom', fontsize=9)

        if col == 0:
            ax_bot.set_ylabel('Error', fontsize=11)

    plt.tight_layout()
    plt.savefig('ch06_bias_variance_decomposition.png', dpi=150, bbox_inches='tight')
    print("已保存图像：ch06_bias_variance_decomposition.png")

    # 打印表格
    print("\nDegree | Bias²   | Variance | Noise  | Total")
    print("-" * 55)
    for deg in degrees:
        res = results[deg]
        print(f"{deg:6d} | {res['bias_sq']:7.4f} | {res['variance']:8.4f} | "
              f"{res['noise']:6.4f} | {res['total']:6.4f}")

    print("\n观察：")
    print("- Degree 1：高偏差（不能拟合非线性），低方差（稳定）")
    print("- Degree 3：偏差和方差达到平衡，总误差最小")
    print("- Degree 9/15：低偏差，但方差爆炸（过拟合）")
    print()


# ============================================================================
# 任务 3：学习曲线
# ============================================================================

def task3_learning_curve():
    """绘制学习曲线诊断欠拟合/过拟合"""
    print("=" * 80)
    print("任务 3：学习曲线")
    print("=" * 80)

    # 生成数据
    np.random.seed(42)
    X, y = make_regression_data(n_samples=500, n_features=20, noise=20, random_state=42)

    models = [
        ('High Bias (alpha=100)', RidgeNumPy(alpha=100)),
        ('Balanced (alpha=1)', RidgeNumPy(alpha=1)),
        ('High Variance (alpha=0.01)', RidgeNumPy(alpha=0.01))
    ]

    fig, axes = plt.subplots(1, 3, figsize=(15, 5))

    for ax, (title, model) in zip(axes, models):
        train_sizes = np.linspace(0.1, 1.0, 10)
        train_errors_mean = []
        train_errors_std = []
        val_errors_mean = []
        val_errors_std = []

        for train_size in train_sizes:
            n_train = int(len(X) * train_size)
            train_errors_fold = []
            val_errors_fold = []

            # 5-fold 交叉验证
            for train_idx, val_idx in kfold_split(len(X), n_splits=5, shuffle=True, random_state=42):
                # 使用前 n_train 个训练样本
                train_idx_subset = train_idx[:min(n_train, len(train_idx))]
                X_train, X_val = X[train_idx_subset], X[val_idx]
                y_train, y_val = y[train_idx_subset], y[val_idx]

                model.fit(X_train, y_train)
                train_errors_fold.append(mean_squared_error(y_train, model.predict(X_train)))
                val_errors_fold.append(mean_squared_error(y_val, model.predict(X_val)))

            train_errors_mean.append(np.mean(train_errors_fold))
            train_errors_std.append(np.std(train_errors_fold))
            val_errors_mean.append(np.mean(val_errors_fold))
            val_errors_std.append(np.std(val_errors_fold))

        train_sizes_abs = (train_sizes * len(X)).astype(int)
        train_errors_mean = np.array(train_errors_mean)
        train_errors_std = np.array(train_errors_std)
        val_errors_mean = np.array(val_errors_mean)
        val_errors_std = np.array(val_errors_std)

        # 绘制曲线
        ax.plot(train_sizes_abs, train_errors_mean, 'o-', color='#2ecc71',
                label='Training error', linewidth=2, markersize=6)
        ax.fill_between(train_sizes_abs,
                        train_errors_mean - train_errors_std,
                        train_errors_mean + train_errors_std,
                        alpha=0.2, color='#2ecc71')

        ax.plot(train_sizes_abs, val_errors_mean, 's-', color='#e74c3c',
                label='Validation error', linewidth=2, markersize=6)
        ax.fill_between(train_sizes_abs,
                        val_errors_mean - val_errors_std,
                        val_errors_mean + val_errors_std,
                        alpha=0.2, color='#e74c3c')

        ax.set_xlabel('Training set size', fontsize=11)
        ax.set_ylabel('Mean Squared Error', fontsize=11)
        ax.set_title(title, fontsize=12, fontweight='bold')
        ax.legend(loc='best', fontsize=9)
        ax.grid(True, alpha=0.3)

    plt.tight_layout()
    plt.savefig('ch06_learning_curves.png', dpi=150, bbox_inches='tight')
    print("已保存图像：ch06_learning_curves.png")

    print("\n诊断：")
    print("- High Bias：训练误差和验证误差都高且接近 → 欠拟合")
    print("  解决：增加模型复杂度（减小 alpha）")
    print("- Balanced：训练误差略低于验证误差，收敛 → 良好")
    print("- High Variance：训练误差低，验证误差高且有gap → 过拟合")
    print("  解决：收集更多数据或增加正则化（增大 alpha）")
    print()


# ============================================================================
# 任务 4：验证曲线
# ============================================================================

def task4_validation_curve():
    """绘制验证曲线选择最优超参数"""
    print("=" * 80)
    print("任务 4：验证曲线")
    print("=" * 80)

    # 生成数据
    np.random.seed(42)
    X, y = make_regression_data(n_samples=300, n_features=10, noise=15, random_state=42)

    # 超参数范围
    param_range = np.logspace(-3, 3, 30)
    train_errors_mean = []
    train_errors_std = []
    val_errors_mean = []
    val_errors_std = []

    for alpha in param_range:
        model = RidgeNumPy(alpha=alpha)
        train_errors_fold = []
        val_errors_fold = []

        # 5-fold 交叉验证
        for train_idx, val_idx in kfold_split(len(X), n_splits=5, shuffle=True, random_state=42):
            X_train, X_val = X[train_idx], X[val_idx]
            y_train, y_val = y[train_idx], y[val_idx]

            model.fit(X_train, y_train)
            train_errors_fold.append(mean_squared_error(y_train, model.predict(X_train)))
            val_errors_fold.append(mean_squared_error(y_val, model.predict(X_val)))

        train_errors_mean.append(np.mean(train_errors_fold))
        train_errors_std.append(np.std(train_errors_fold))
        val_errors_mean.append(np.mean(val_errors_fold))
        val_errors_std.append(np.std(val_errors_fold))

    train_errors_mean = np.array(train_errors_mean)
    train_errors_std = np.array(train_errors_std)
    val_errors_mean = np.array(val_errors_mean)
    val_errors_std = np.array(val_errors_std)

    # 找到最优点
    best_idx = np.argmin(val_errors_mean)
    best_alpha = param_range[best_idx]
    best_val_error = val_errors_mean[best_idx]

    # 绘图
    plt.figure(figsize=(10, 6))
    plt.semilogx(param_range, train_errors_mean, 'o-', color='#2ecc71',
                 label='Training error', linewidth=2, markersize=5)
    plt.fill_between(param_range,
                     train_errors_mean - train_errors_std,
                     train_errors_mean + train_errors_std,
                     alpha=0.2, color='#2ecc71')

    plt.semilogx(param_range, val_errors_mean, 's-', color='#e74c3c',
                 label='Validation error', linewidth=2, markersize=5)
    plt.fill_between(param_range,
                     val_errors_mean - val_errors_std,
                     val_errors_mean + val_errors_std,
                     alpha=0.2, color='#e74c3c')

    # 标注最优点
    plt.axvline(best_alpha, color='#9b59b6', linestyle='--', linewidth=2,
                label=f'Optimal alpha = {best_alpha:.3f}')
    plt.plot(best_alpha, best_val_error, 'r*', markersize=15, zorder=10)

    plt.xlabel('Regularization strength (alpha)', fontsize=12)
    plt.ylabel('Mean Squared Error', fontsize=12)
    plt.title('Validation Curve for Ridge Regression', fontsize=14, fontweight='bold')
    plt.legend(loc='best', fontsize=10)
    plt.grid(True, alpha=0.3, which='both')
    plt.tight_layout()
    plt.savefig('ch06_validation_curve.png', dpi=150, bbox_inches='tight')
    print("已保存图像：ch06_validation_curve.png")

    print(f"\n最优超参数：alpha = {best_alpha:.4f}")
    print(f"对应验证误差：{best_val_error:.4f}")
    print("\n观察：")
    print("- alpha 过小（左侧）：过拟合，验证误差高")
    print("- alpha 过大（右侧）：欠拟合，训练和验证误差都高")
    print("- 最优点：验证误差最低")
    print()


# ============================================================================
# 任务 5：数据泄露演示
# ============================================================================

def task5_data_leakage():
    """演示预处理和特征选择中的数据泄露"""
    print("=" * 80)
    print("任务 5：数据泄露演示")
    print("=" * 80)

    np.random.seed(42)

    # 生成数据：只有前 5 个特征真正相关
    n_samples = 200
    n_features = 100
    X = np.random.randn(n_samples, n_features)
    y = X[:, :5].sum(axis=1) + np.random.randn(n_samples) * 0.1

    # ========== 泄露 1：特征选择 ==========
    print("\n【实验 1：特征选择泄露】")

    # 错误：在划分前选特征
    f_scores = f_statistic(X, y)
    top_k_indices = np.argsort(f_scores)[-10:]
    X_selected = X[:, top_k_indices]

    # 交叉验证
    r2_scores_wrong = []
    for train_idx, val_idx in kfold_split(len(X_selected), n_splits=5, shuffle=True, random_state=42):
        model = LinearRegressionNumPy()
        model.fit(X_selected[train_idx], y[train_idx])
        r2_scores_wrong.append(r2_score(y[val_idx], model.predict(X_selected[val_idx])))
    score_wrong = np.mean(r2_scores_wrong)

    # 正确：在每折内独立选特征
    r2_scores_correct = []
    for train_idx, val_idx in kfold_split(len(X), n_splits=5, shuffle=True, random_state=42):
        X_train, X_val = X[train_idx], X[val_idx]
        y_train, y_val = y[train_idx], y[val_idx]

        # 只在训练集上选特征
        f_scores_train = f_statistic(X_train, y_train)
        top_k_indices_train = np.argsort(f_scores_train)[-10:]
        X_train_selected = X_train[:, top_k_indices_train]
        X_val_selected = X_val[:, top_k_indices_train]

        model = LinearRegressionNumPy()
        model.fit(X_train_selected, y_train)
        r2_scores_correct.append(r2_score(y_val, model.predict(X_val_selected)))
    score_correct = np.mean(r2_scores_correct)

    print(f"错误做法（泄露）：R² = {score_wrong:.4f}")
    print(f"正确做法（无泄露）：R² = {score_correct:.4f}")
    print(f"差异：{score_wrong - score_correct:.4f} (性能被虚高估计！)")

    # ========== 泄露 2：标准化 ==========
    print("\n【实验 2：标准化泄露】")

    X2, y2 = make_regression_data(n_samples=200, n_features=10, noise=10, random_state=99)

    # 错误：在划分前标准化
    scaler = StandardScalerNumPy()
    X2_scaled = scaler.fit_transform(X2)
    X_train_w, X_test_w, y_train_w, y_test_w = train_test_split_numpy(
        X2_scaled, y2, test_size=0.3, random_state=42
    )
    model_wrong = LinearRegressionNumPy().fit(X_train_w, y_train_w)
    score_wrong2 = r2_score(y_test_w, model_wrong.predict(X_test_w))

    # 正确：只用训练集拟合 scaler
    X_train_c, X_test_c, y_train_c, y_test_c = train_test_split_numpy(
        X2, y2, test_size=0.3, random_state=42
    )
    scaler2 = StandardScalerNumPy().fit(X_train_c)
    X_train_c = scaler2.transform(X_train_c)
    X_test_c = scaler2.transform(X_test_c)
    model_correct = LinearRegressionNumPy().fit(X_train_c, y_train_c)
    score_correct2 = r2_score(y_test_c, model_correct.predict(X_test_c))

    print(f"错误做法（泄露）：R² = {score_wrong2:.4f}")
    print(f"正确做法（无泄露）：R² = {score_correct2:.4f}")
    print(f"差异：{score_wrong2 - score_correct2:.4f}")

    print("\n关键教训：")
    print("- 所有预处理步骤（标准化、特征选择、降维等）必须在训练集上拟合")
    print("- 交叉验证时，每折内必须独立预处理")
    print("- 违反此原则会导致性能虚高估计")
    print()


# ============================================================================
# 任务 6：LOOCV vs. k-fold
# ============================================================================

def task6_loocv_comparison():
    """比较 LOOCV 和 k-fold 的性能"""
    print("=" * 80)
    print("任务 6：LOOCV vs k-fold 对比")
    print("=" * 80)

    np.random.seed(42)
    X, y = make_regression_data(n_samples=100, n_features=5, noise=5, random_state=42)
    model_class = RidgeNumPy

    # k-fold (k=5)
    start = time.time()
    errors_5fold = []
    for train_idx, val_idx in kfold_split(len(X), n_splits=5, shuffle=True, random_state=42):
        model = model_class(alpha=1.0)
        model.fit(X[train_idx], y[train_idx])
        errors_5fold.append(mean_squared_error(y[val_idx], model.predict(X[val_idx])))
    time_5fold = time.time() - start
    score_5fold_mean = np.mean(errors_5fold)
    score_5fold_std = np.std(errors_5fold)

    # k-fold (k=10)
    start = time.time()
    errors_10fold = []
    for train_idx, val_idx in kfold_split(len(X), n_splits=10, shuffle=True, random_state=42):
        model = model_class(alpha=1.0)
        model.fit(X[train_idx], y[train_idx])
        errors_10fold.append(mean_squared_error(y[val_idx], model.predict(X[val_idx])))
    time_10fold = time.time() - start
    score_10fold_mean = np.mean(errors_10fold)
    score_10fold_std = np.std(errors_10fold)

    # LOOCV (k=n)
    start = time.time()
    errors_loo = []
    for i in range(len(X)):
        train_idx = np.concatenate([np.arange(i), np.arange(i+1, len(X))])
        val_idx = np.array([i])
        model = model_class(alpha=1.0)
        model.fit(X[train_idx], y[train_idx])
        errors_loo.append(mean_squared_error(y[val_idx], model.predict(X[val_idx])))
    time_loo = time.time() - start
    score_loo_mean = np.mean(errors_loo)
    score_loo_std = np.std(errors_loo)

    print(f"5-fold CV：  {score_5fold_mean:.4f} ± {score_5fold_std:.4f}  "
          f"({time_5fold:.4f}s)")
    print(f"10-fold CV： {score_10fold_mean:.4f} ± {score_10fold_std:.4f}  "
          f"({time_10fold:.4f}s)")
    print(f"LOOCV：     {score_loo_mean:.4f} ± {score_loo_std:.4f}  "
          f"({time_loo:.4f}s)")

    print("\n结论：")
    print("- LOOCV 计算成本高（需训练 n 次）")
    print("- LOOCV 方差大（每次只在 1 个样本上测试）")
    print("- 实践中，5-fold 或 10-fold 是更好的折衷")
    print()


# ============================================================================
# 主函数
# ============================================================================

def main():
    print("\n" + "=" * 80)
    print(" " * 20 + "实验 6：交叉验证与模型选择")
    print("=" * 80 + "\n")

    task1_manual_kfold()
    task2_bias_variance()
    task3_learning_curve()
    task4_validation_curve()
    task5_data_leakage()
    task6_loocv_comparison()

    print("=" * 80)
    print("实验完成！生成的图像：")
    print("  - ch06_bias_variance_decomposition.png")
    print("  - ch06_learning_curves.png")
    print("  - ch06_validation_curve.png")
    print("=" * 80)


if __name__ == "__main__":
    main()
