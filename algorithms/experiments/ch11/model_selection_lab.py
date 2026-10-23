"""
experiments/ch11/model_selection_lab.py
第11章 模型评估与选择 — 实验验证

实验列表：
  Exp1: 多项式回归过拟合演示（学习曲线）
  Exp2: Ridge / Lasso 正则化路径
  Exp3: 前向特征选择 vs Lasso
  Exp4: Bootstrap 0.632+ 误差估计
  Exp5: AIC vs BIC 模型选择差异

依赖：纯 NumPy + Matplotlib
"""

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec

RNG = np.random.default_rng(42)

# ──────────────────────────────────────────────────────────────────────────────
# 通用工具
# ──────────────────────────────────────────────────────────────────────────────

def mse(y_true, y_pred):
    return np.mean((y_true - y_pred) ** 2)


def poly_features(x, degree):
    """将一维 x 扩展为 degree 阶多项式特征矩阵（含截距）。"""
    return np.column_stack([x ** d for d in range(degree + 1)])


def ridge_fit(X, y, lam):
    """Ridge 回归闭式解。"""
    d = X.shape[1]
    return np.linalg.solve(X.T @ X + lam * np.eye(d), X.T @ y)


def lasso_coordinate_descent(X, y, lam, max_iter=1000, tol=1e-6, theta_init=None):
    """Lasso 坐标下降求解器（热启动支持）。"""
    n, d = X.shape
    theta = np.zeros(d) if theta_init is None else theta_init.copy()
    residual = y - X @ theta
    for _ in range(max_iter):
        theta_old = theta.copy()
        for j in range(d):
            residual += X[:, j] * theta[j]          # 恢复第j项
            rho = X[:, j] @ residual / n
            z_j = np.sum(X[:, j] ** 2) / n
            # 软阈值
            if z_j == 0:
                theta[j] = 0.0
            else:
                theta[j] = np.sign(rho) * max(abs(rho) - lam / (2 * n), 0) / z_j
            residual -= X[:, j] * theta[j]          # 更新残差
        if np.max(np.abs(theta - theta_old)) < tol:
            break
    return theta


# ──────────────────────────────────────────────────────────────────────────────
# Exp1: 过拟合演示 — 多项式回归学习曲线
# ──────────────────────────────────────────────────────────────────────────────

def exp1_overfitting_demo():
    """演示低阶（欠拟合）、适当阶、高阶（过拟合）多项式的学习曲线。"""
    print("=" * 60)
    print("Exp1: 过拟合演示 — 多项式回归学习曲线")
    print("=" * 60)

    # 真实函数：sin
    def true_f(x):
        return np.sin(2 * np.pi * x)

    n_total = 200
    x_all = RNG.uniform(0, 1, n_total)
    y_all = true_f(x_all) + RNG.normal(0, 0.3, n_total)

    n_test = 50
    x_test, y_test = x_all[:n_test], y_all[:n_test]
    x_train_pool, y_train_pool = x_all[n_test:], y_all[n_test:]

    train_sizes = np.arange(10, 141, 10)
    degrees = [1, 3, 9]
    colors = ['steelblue', 'darkorange', 'firebrick']
    labels = ['degree=1 (欠拟合)', 'degree=3 (适当)', 'degree=9 (过拟合)']

    fig, axes = plt.subplots(1, 2, figsize=(13, 5))

    # 左图：拟合示例（n=30）
    ax = axes[0]
    x_demo = x_train_pool[:30]
    y_demo = y_train_pool[:30]
    x_plot = np.linspace(0, 1, 300)
    ax.scatter(x_demo, y_demo, s=20, color='gray', alpha=0.7, label='训练点(n=30)')
    ax.plot(x_plot, true_f(x_plot), 'k--', lw=1.5, label='真实函数')
    for deg, col, lab in zip(degrees, colors, labels):
        Xd = poly_features(x_demo, deg)
        Xd_plot = poly_features(x_plot, deg)
        # 数值稳定：列归一化
        col_scale = np.maximum(np.max(np.abs(Xd), axis=0), 1e-8)
        th = ridge_fit(Xd / col_scale, y_demo, lam=1e-8)
        y_fit = (Xd_plot / col_scale) @ th
        ax.plot(x_plot, y_fit, color=col, lw=1.8, label=lab)
    ax.set_ylim(-2.5, 2.5)
    ax.set_title("拟合示例（n=30）")
    ax.legend(fontsize=8)
    ax.set_xlabel("x")
    ax.set_ylabel("y")

    # 右图：学习曲线
    ax = axes[1]
    for deg, col, lab in zip(degrees, colors, labels):
        tr_errs, te_errs = [], []
        X_test_d = poly_features(x_test, deg)
        col_scale_test = None
        for n_tr in train_sizes:
            Xd = poly_features(x_train_pool[:n_tr], deg)
            yd = y_train_pool[:n_tr]
            cs = np.maximum(np.max(np.abs(Xd), axis=0), 1e-8)
            th = ridge_fit(Xd / cs, yd, lam=1e-8)
            tr_errs.append(mse(yd, (Xd / cs) @ th))
            te_errs.append(mse(y_test, (X_test_d / cs) @ th))
        ax.plot(train_sizes, tr_errs, '--', color=col, lw=1.2, alpha=0.7)
        ax.plot(train_sizes, te_errs, '-', color=col, lw=1.8, label=lab)
    ax.set_ylim(0, 1.2)
    ax.set_xlabel("训练集大小")
    ax.set_ylabel("MSE")
    ax.set_title("学习曲线（实线=测试，虚线=训练）")
    ax.legend(fontsize=8)

    plt.suptitle("Exp1: 过拟合演示", fontsize=13)
    plt.tight_layout()
    plt.savefig('/tmp/exp1_overfitting.png', dpi=120)
    plt.close()

    print("  degree=1  测试MSE(n=140):", round(te_errs[0] if False else
          mse(y_test, (poly_features(x_test, 1) /
              np.maximum(np.max(np.abs(poly_features(x_train_pool[:140], 1)), axis=0), 1e-8)) @
              ridge_fit(poly_features(x_train_pool[:140], 1) /
              np.maximum(np.max(np.abs(poly_features(x_train_pool[:140], 1)), axis=0), 1e-8),
              y_train_pool[:140], 1e-8)), 4))
    print("  图表已保存至 /tmp/exp1_overfitting.png")


# ──────────────────────────────────────────────────────────────────────────────
# Exp2: Ridge / Lasso 正则化路径
# ──────────────────────────────────────────────────────────────────────────────

def exp2_regularization_paths():
    """绘制 Ridge 和 Lasso 的正则化路径。"""
    print("\n" + "=" * 60)
    print("Exp2: Ridge / Lasso 正则化路径")
    print("=" * 60)

    # 生成数据：5个真实特征 + 5个噪声特征
    n, d = 100, 10
    true_coef = np.array([2.0, -1.5, 1.0, -0.5, 0.8] + [0.0] * 5)
    X = RNG.normal(0, 1, (n, d))
    y = X @ true_coef + RNG.normal(0, 0.5, n)

    # 列归一化
    X_std = X / (np.std(X, axis=0) + 1e-8)

    lambdas = np.logspace(2, -2, 80)

    # Ridge 路径（闭式）
    ridge_paths = []
    for lam in lambdas:
        th = ridge_fit(X_std, y, lam)
        ridge_paths.append(th)
    ridge_paths = np.array(ridge_paths)   # (80, d)

    # Lasso 路径（坐标下降 + 热启动）
    lasso_paths = []
    th = np.zeros(d)
    for lam in lambdas:
        th = lasso_coordinate_descent(X_std, y, lam, theta_init=th)
        lasso_paths.append(th.copy())
    lasso_paths = np.array(lasso_paths)

    # L1 norm 作为 x 轴（经典展示方式）
    ridge_l1 = np.sum(np.abs(ridge_paths), axis=1)
    lasso_l1 = np.sum(np.abs(lasso_paths), axis=1)

    fig, axes = plt.subplots(1, 2, figsize=(13, 5))
    cmap = plt.cm.tab10

    for j in range(d):
        col = cmap(j % 10)
        ls = '-' if true_coef[j] != 0 else '--'
        lw = 2.0 if true_coef[j] != 0 else 0.8
        lab_r = f"x{j+1}" if j < 5 else None
        axes[0].plot(ridge_l1, ridge_paths[:, j], color=col, ls=ls, lw=lw, label=lab_r)
        axes[1].plot(lasso_l1, lasso_paths[:, j], color=col, ls=ls, lw=lw, label=lab_r)

    for ax, title in zip(axes, ["Ridge 路径（L2 正则化）", "Lasso 路径（L1 正则化）"]):
        ax.axhline(0, color='k', lw=0.5, ls=':')
        ax.set_xlabel("||θ||₁")
        ax.set_ylabel("系数值")
        ax.set_title(title)
        ax.legend(fontsize=7, loc='upper left')

    plt.suptitle("Exp2: Ridge vs Lasso 正则化路径\n（实线=真实特征，虚线=噪声特征）", fontsize=12)
    plt.tight_layout()
    plt.savefig('/tmp/exp2_reg_paths.png', dpi=120)
    plt.close()

    # 报告稀疏性
    lasso_final = lasso_paths[-1]
    lasso_coarse = lasso_paths[40]
    n_zero_lasso = np.sum(np.abs(lasso_coarse) < 1e-6)
    print(f"  λ=中等时 Lasso 零系数数量: {n_zero_lasso}/{d}")
    print(f"  真实特征系数（λ中等）: {lasso_coarse[:5].round(3)}")
    print(f"  噪声特征系数（λ中等）: {lasso_coarse[5:].round(3)}")
    print("  图表已保存至 /tmp/exp2_reg_paths.png")


# ──────────────────────────────────────────────────────────────────────────────
# Exp3: 前向特征选择 vs Lasso
# ──────────────────────────────────────────────────────────────────────────────

def exp3_feature_selection():
    """比较前向选择和 Lasso 在稀疏数据上的特征选择能力。"""
    print("\n" + "=" * 60)
    print("Exp3: 前向特征选择 vs Lasso")
    print("=" * 60)

    n_train, n_test, d = 80, 100, 15
    true_coef = np.zeros(d)
    true_coef[[0, 2, 5, 8, 11]] = [3.0, -2.0, 1.5, -1.0, 2.5]   # 5 个真实特征

    X_tr = RNG.normal(0, 1, (n_train, d))
    X_te = RNG.normal(0, 1, (n_test, d))
    y_tr = X_tr @ true_coef + RNG.normal(0, 0.5, n_train)
    y_te = X_te @ true_coef + RNG.normal(0, 0.5, n_test)

    # 前向选择（5折CV）
    def cv_mse_subset(X, y, subset, k=5):
        n = len(y)
        fold = n // k
        errs = []
        for f in range(k):
            te_idx = np.arange(f * fold, (f + 1) * fold)
            tr_idx = np.concatenate([np.arange(0, f * fold), np.arange((f + 1) * fold, n)])
            Xtr_, ytr_ = X[tr_idx][:, subset], y[tr_idx]
            Xte_, yte_ = X[te_idx][:, subset], y[te_idx]
            th = ridge_fit(Xtr_, ytr_, lam=1e-6)
            errs.append(mse(yte_, Xte_ @ th))
        return np.mean(errs)

    selected = []
    remaining = list(range(d))
    forward_scores = []
    for step in range(min(8, d)):
        best_score = float('inf')
        best_feat = None
        for feat in remaining:
            cand = selected + [feat]
            score = cv_mse_subset(X_tr, y_tr, cand)
            if score < best_score:
                best_score = score
                best_feat = feat
        if best_feat is None:
            break
        selected.append(best_feat)
        remaining.remove(best_feat)
        forward_scores.append(best_score)

    true_features = set(np.where(true_coef != 0)[0])
    forward_recall = len(set(selected) & true_features) / len(true_features)
    forward_precision = len(set(selected) & true_features) / len(selected) if selected else 0

    # Lasso 选择（扫描 λ，选验证集最优）
    lambdas_lasso = np.logspace(1, -3, 60)
    best_lasso_score = float('inf')
    best_lasso_feat = None
    th = np.zeros(d)
    X_std_tr = X_tr / (np.std(X_tr, axis=0) + 1e-8)
    X_std_te = X_te / (np.std(X_tr, axis=0) + 1e-8)
    for lam in lambdas_lasso:
        th = lasso_coordinate_descent(X_std_tr, y_tr, lam, theta_init=th)
        nonzero = np.where(np.abs(th) > 1e-4)[0]
        if len(nonzero) == 0:
            continue
        val_s = mse(y_te, X_std_te[:, nonzero] @ th[nonzero])
        if val_s < best_lasso_score:
            best_lasso_score = val_s
            best_lasso_feat = list(nonzero)

    if best_lasso_feat is None:
        best_lasso_feat = []
    lasso_recall = len(set(best_lasso_feat) & true_features) / len(true_features)
    lasso_precision = (len(set(best_lasso_feat) & true_features) / len(best_lasso_feat)
                       if best_lasso_feat else 0)

    print(f"  真实特征索引: {sorted(true_features)}")
    print(f"  前向选择结果: {sorted(selected)}")
    print(f"    Precision={forward_precision:.2f}  Recall={forward_recall:.2f}")
    print(f"  Lasso 选择结果: {sorted(best_lasso_feat)}")
    print(f"    Precision={lasso_precision:.2f}  Recall={lasso_recall:.2f}")

    # 可视化
    fig, axes = plt.subplots(1, 2, figsize=(12, 4))

    # 左：前向选择CV曲线
    axes[0].plot(range(1, len(forward_scores) + 1), forward_scores, 'o-', color='steelblue')
    axes[0].axvline(5, color='gray', ls='--', alpha=0.6, label='真实特征数=5')
    axes[0].set_xlabel("选择的特征数")
    axes[0].set_ylabel("5折CV MSE")
    axes[0].set_title("前向选择：CV误差")
    axes[0].legend()

    # 右：真实 vs 恢复系数
    bar_x = np.arange(d)
    axes[1].bar(bar_x - 0.2, true_coef, 0.35, label='真实系数', color='steelblue', alpha=0.8)
    th_full = ridge_fit(X_std_tr, y_tr, lam=1e-6)
    axes[1].bar(bar_x + 0.2, th_full, 0.35, label='OLS（全特征）', color='gray', alpha=0.5)
    if best_lasso_feat:
        th_lasso_show = np.zeros(d)
        th_opt = lasso_coordinate_descent(X_std_tr, y_tr, lambdas_lasso[30])
        th_lasso_show = th_opt
        axes[1].bar(bar_x + 0.2, th_lasso_show, 0.35, label='Lasso', color='darkorange', alpha=0.7)
    axes[1].axhline(0, color='k', lw=0.5)
    axes[1].set_xlabel("特征索引")
    axes[1].set_ylabel("系数值")
    axes[1].set_title("系数恢复对比")
    axes[1].legend(fontsize=8)

    plt.suptitle("Exp3: 前向特征选择 vs Lasso", fontsize=13)
    plt.tight_layout()
    plt.savefig('/tmp/exp3_feature_selection.png', dpi=120)
    plt.close()
    print("  图表已保存至 /tmp/exp3_feature_selection.png")


# ──────────────────────────────────────────────────────────────────────────────
# Exp4: Bootstrap 0.632+ 误差估计
# ──────────────────────────────────────────────────────────────────────────────

def exp4_bootstrap632plus():
    """比较训练误差、留一CV、Bootstrap 0.632、Bootstrap 0.632+ 的估计。"""
    print("\n" + "=" * 60)
    print("Exp4: Bootstrap 0.632+ 误差估计")
    print("=" * 60)

    n, d_true = 50, 3
    true_coef = np.array([2.0, -1.5, 1.0])
    sigma = 0.5

    X = RNG.normal(0, 1, (n, d_true))
    y = X @ true_coef + RNG.normal(0, sigma, n)

    # 真实误差（大测试集近似）
    X_big = RNG.normal(0, 1, (5000, d_true))
    y_big = X_big @ true_coef + RNG.normal(0, sigma, 5000)
    th_full = ridge_fit(X, y, lam=1e-6)
    true_err = mse(y_big, X_big @ th_full)

    # 训练误差
    train_err = mse(y, X @ th_full)

    # LOOCV
    loocv_errs = []
    for i in range(n):
        idx = np.concatenate([np.arange(0, i), np.arange(i + 1, n)])
        th_i = ridge_fit(X[idx], y[idx], lam=1e-6)
        loocv_errs.append((y[i] - X[i] @ th_i) ** 2)
    loocv_err = np.mean(loocv_errs)

    # Bootstrap
    B = 200
    boot_err_oob_all = []     # 袋外误差（每个样本的平均）
    boot_train_errs = []

    oob_sum = np.zeros(n)
    oob_count = np.zeros(n)

    for _ in range(B):
        idx_boot = RNG.integers(0, n, n)
        oob_mask = np.ones(n, dtype=bool)
        oob_mask[idx_boot] = False
        oob_idx = np.where(oob_mask)[0]
        if len(oob_idx) == 0:
            continue
        th_b = ridge_fit(X[idx_boot], y[idx_boot], lam=1e-6)
        boot_train_errs.append(mse(y[idx_boot], X[idx_boot] @ th_b))
        oob_errs_b = (y[oob_idx] - X[oob_idx] @ th_b) ** 2
        oob_sum[oob_idx] += oob_errs_b
        oob_count[oob_idx] += 1

    valid = oob_count > 0
    oob_per_sample = np.where(valid, oob_sum / np.maximum(oob_count, 1), np.nan)
    err_oob = np.nanmean(oob_per_sample)
    err_train_boot = np.mean(boot_train_errs)

    err_632 = 0.368 * err_train_boot + 0.632 * err_oob

    # 0.632+
    gamma = np.mean(y.std() ** 2)    # 无信息误差率（近似：用 y 方差）
    denom = gamma - err_train_boot
    if abs(denom) < 1e-10:
        err_632plus = err_632
    else:
        R = (err_oob - err_train_boot) / denom
        R = np.clip(R, 0, 1)
        w = 0.632 / (1 - 0.368 * R)
        w = np.clip(w, 0.632, 1.0)
        err_632plus = (1 - w) * err_train_boot + w * err_oob

    estimates = {
        '训练误差': train_err,
        'LOOCV': loocv_err,
        'Bootstrap-OOB': err_oob,
        'Bootstrap-0.632': err_632,
        'Bootstrap-0.632+': err_632plus,
        '真实误差（参考）': true_err,
    }

    print(f"  {'方法':<20} {'估计值':>10}")
    print("  " + "-" * 32)
    for k, v in estimates.items():
        marker = " <--" if k == '真实误差（参考）' else ""
        print(f"  {k:<20} {v:>10.4f}{marker}")

    # 可视化
    fig, ax = plt.subplots(figsize=(8, 4))
    names = list(estimates.keys())
    vals = list(estimates.values())
    bar_colors = ['#e74c3c', '#3498db', '#95a5a6', '#f39c12', '#27ae60', '#2c3e50']
    bars = ax.barh(names, vals, color=bar_colors, alpha=0.85, edgecolor='white')
    ax.axvline(true_err, color='#2c3e50', ls='--', lw=1.5, label='真实误差')
    for bar, val in zip(bars, vals):
        ax.text(val + 0.002, bar.get_y() + bar.get_height() / 2,
                f'{val:.4f}', va='center', ha='left', fontsize=9)
    ax.set_xlabel("MSE 估计值")
    ax.set_title(f"Exp4: Bootstrap 误差估计比较（n={n}，d={d_true}）")
    ax.legend(fontsize=9)
    plt.tight_layout()
    plt.savefig('/tmp/exp4_bootstrap.png', dpi=120)
    plt.close()
    print("  图表已保存至 /tmp/exp4_bootstrap.png")


# ──────────────────────────────────────────────────────────────────────────────
# Exp5: AIC vs BIC 模型选择差异
# ──────────────────────────────────────────────────────────────────────────────

def exp5_aic_bic():
    """演示 AIC 和 BIC 在不同样本量下选择模型阶数的差异。"""
    print("\n" + "=" * 60)
    print("Exp5: AIC vs BIC 模型选择差异")
    print("=" * 60)

    def compute_aic_bic(X, y, lam=1e-8):
        n, k = X.shape
        th = ridge_fit(X, y, lam)
        y_hat = X @ th
        sigma2 = np.mean((y - y_hat) ** 2)
        if sigma2 <= 0:
            sigma2 = 1e-10
        log_lik = -n / 2 * np.log(2 * np.pi * sigma2) - n / 2
        aic = -2 * log_lik + 2 * k
        bic = -2 * log_lik + k * np.log(n)
        return aic, bic

    def true_f(x):
        return 1.5 * x + 0.5 * x ** 2    # 真实模型是2阶

    sample_sizes = [30, 100, 500]
    max_degree = 8

    fig, axes = plt.subplots(1, 3, figsize=(14, 4))

    for ax, n in zip(axes, sample_sizes):
        x = RNG.uniform(-1, 1, n)
        y = true_f(x) + RNG.normal(0, 0.3, n)

        aics, bics = [], []
        for deg in range(1, max_degree + 1):
            Xd = poly_features(x, deg)
            cs = np.maximum(np.max(np.abs(Xd), axis=0), 1e-8)
            aic, bic = compute_aic_bic(Xd / cs, y)
            aics.append(aic)
            bics.append(bic)

        degs = np.arange(1, max_degree + 1)
        aics_norm = np.array(aics) - min(aics)
        bics_norm = np.array(bics) - min(bics)

        ax.plot(degs, aics_norm, 'o-', color='steelblue', lw=1.8, label='ΔAIC')
        ax.plot(degs, bics_norm, 's-', color='firebrick', lw=1.8, label='ΔBIC')
        ax.axvline(2, color='k', ls='--', lw=1, alpha=0.5, label='真实阶数=2')
        ax.axvline(np.argmin(aics) + 1, color='steelblue', ls=':', lw=1.5,
                   label=f'AIC选择={np.argmin(aics)+1}')
        ax.axvline(np.argmin(bics) + 1, color='firebrick', ls=':', lw=1.5,
                   label=f'BIC选择={np.argmin(bics)+1}')
        ax.set_xlabel("多项式阶数")
        ax.set_ylabel("ΔIC（相对最小值）")
        ax.set_title(f"n={n}")
        ax.legend(fontsize=7)
        ax.set_xticks(degs)

        print(f"  n={n:>4}:  AIC选择阶数={np.argmin(aics)+1}，"
              f"BIC选择阶数={np.argmin(bics)+1}（真实=2）")

    plt.suptitle("Exp5: AIC vs BIC 在不同样本量下的模型选择\n（真实模型为2阶多项式）",
                 fontsize=12)
    plt.tight_layout()
    plt.savefig('/tmp/exp5_aic_bic.png', dpi=120)
    plt.close()
    print("  图表已保存至 /tmp/exp5_aic_bic.png")
    print()
    print("  观察：小样本时两者可能选过低阶；大样本时 BIC 更保守，")
    print("  AIC 可能选更高阶。AIC 倾向预测最优，BIC 倾向选中真实模型。")


# ──────────────────────────────────────────────────────────────────────────────
# 主程序
# ──────────────────────────────────────────────────────────────────────────────

if __name__ == "__main__":
    print("第11章 模型评估与选择 — 实验验证")
    print("使用随机种子 42，结果可复现\n")

    exp1_overfitting_demo()
    exp2_regularization_paths()
    exp3_feature_selection()
    exp4_bootstrap632plus()
    exp5_aic_bic()

    print("\n所有实验完成！图表输出到 /tmp/exp[1-5]_*.png")
