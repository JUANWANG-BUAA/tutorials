#!/usr/bin/env python3
"""
第9章实验：评估指标计算与可视化

实验内容：
- 实验 A: 不平衡数据集的分类指标对比
- 实验 B: ROC 曲线与 AUC 绘制
- 实验 C: 排序指标（NDCG、MAP、MRR）对比

运行方式：python metrics_lab.py
"""

import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics import (
    accuracy_score, precision_score, recall_score, f1_score,
    confusion_matrix, classification_report,
    roc_curve, auc, roc_auc_score
)
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import make_classification

# 设置随机种子保证可复现
np.random.seed(42)

# 设置中文字体（macOS）
plt.rcParams['font.sans-serif'] = ['Arial Unicode MS']
plt.rcParams['axes.unicode_minus'] = False


# ============================================================================
# 实验 A: 不平衡数据集的分类指标对比
# ============================================================================

def experiment_a_imbalanced_metrics():
    """
    构造不平衡数据集（99% 正常，1% 欺诈），对比三个分类器：
    - Baseline: 全预测为正常
    - Poor: 召回率低
    - Good: 召回率高
    """
    print("=" * 70)
    print("实验 A: 不平衡数据集的分类指标对比")
    print("=" * 70)

    # 构造测试集：10000 个样本，9900 正常，100 欺诈
    n_samples = 10000
    n_fraud = 100
    n_normal = n_samples - n_fraud

    y_true = np.array([0] * n_normal + [1] * n_fraud)
    np.random.shuffle(y_true)

    print(f"\n数据集分布：正常 {n_normal} 笔, 欺诈 {n_fraud} 笔")
    print(f"欺诈占比：{n_fraud / n_samples * 100:.1f}%\n")

    # 三个分类器的预测结果
    classifiers = {
        "Baseline（全预测正常）": np.zeros(n_samples, dtype=int),
        "Poor（低召回率）": None,
        "Good（高召回率）": None,
    }

    # Poor 分类器：只找到 20% 的欺诈，且有少量误报
    y_pred_poor = y_true.copy()
    fraud_indices = np.where(y_true == 1)[0]
    # 将 80% 的欺诈错判为正常
    miss_fraud = np.random.choice(fraud_indices, size=int(0.8 * n_fraud), replace=False)
    y_pred_poor[miss_fraud] = 0
    # 添加 1% 的误报
    normal_indices = np.where(y_true == 0)[0]
    false_positives = np.random.choice(normal_indices, size=int(0.01 * n_normal), replace=False)
    y_pred_poor[false_positives] = 1
    classifiers["Poor（低召回率）"] = y_pred_poor

    # Good 分类器：找到 80% 的欺诈，误报率 2%
    y_pred_good = y_true.copy()
    miss_fraud_good = np.random.choice(fraud_indices, size=int(0.2 * n_fraud), replace=False)
    y_pred_good[miss_fraud_good] = 0
    false_positives_good = np.random.choice(normal_indices, size=int(0.02 * n_normal), replace=False)
    y_pred_good[false_positives_good] = 1
    classifiers["Good（高召回率）"] = y_pred_good

    # 计算并展示指标
    print(f"{'分类器':<20} {'准确率':<8} {'精确率':<8} {'召回率':<8} {'F1':<8}")
    print("-" * 70)

    for name, y_pred in classifiers.items():
        acc = accuracy_score(y_true, y_pred)

        # 处理全预测为 0 的情况（精确率/召回率可能未定义）
        if np.sum(y_pred) == 0:  # 全预测为负
            prec = 0.0  # 无正例预测，定义为 0
            rec = 0.0   # 未找到任何正例
            f1 = 0.0
        else:
            prec = precision_score(y_true, y_pred, zero_division=0)
            rec = recall_score(y_true, y_pred)
            f1 = f1_score(y_true, y_pred)

        print(f"{name:<20} {acc:<8.3f} {prec:<8.3f} {rec:<8.3f} {f1:<8.3f}")

    # 详细展示混淆矩阵（以 Good 分类器为例）
    print("\n" + "=" * 70)
    print("Good 分类器的混淆矩阵：")
    print("=" * 70)
    cm = confusion_matrix(y_true, classifiers["Good（高召回率）"])
    print(cm)
    print(f"\nTN={cm[0,0]}, FP={cm[0,1]}, FN={cm[1,0]}, TP={cm[1,1]}")

    # 可视化混淆矩阵
    fig, axes = plt.subplots(1, 3, figsize=(15, 4))

    for idx, (name, y_pred) in enumerate(classifiers.items()):
        cm = confusion_matrix(y_true, y_pred)
        ax = axes[idx]
        im = ax.imshow(cm, cmap='Blues', aspect='auto')
        ax.set_title(name)
        ax.set_xlabel('预测标签')
        ax.set_ylabel('真实标签')
        ax.set_xticks([0, 1])
        ax.set_yticks([0, 1])
        ax.set_xticklabels(['正常', '欺诈'])
        ax.set_yticklabels(['正常', '欺诈'])

        # 标注数值
        for i in range(2):
            for j in range(2):
                text = ax.text(j, i, cm[i, j], ha="center", va="center",
                             color="white" if cm[i, j] > cm.max()/2 else "black",
                             fontsize=14, weight='bold')

    plt.tight_layout()
    plt.savefig('/Users/juanwang/Desktop/tutorials/algorithms/experiments/ch09/confusion_matrices.png',
                dpi=150, bbox_inches='tight')
    print("\n混淆矩阵可视化已保存到 confusion_matrices.png")


# ============================================================================
# 实验 B: ROC 曲线与 AUC 绘制
# ============================================================================

def experiment_b_roc_curve():
    """
    训练逻辑回归模型，绘制 ROC 曲线并计算 AUC
    """
    print("\n\n" + "=" * 70)
    print("实验 B: ROC 曲线与 AUC")
    print("=" * 70)

    # 生成不平衡数据集
    X, y = make_classification(
        n_samples=2000,
        n_features=20,
        n_informative=15,
        n_redundant=5,
        n_classes=2,
        weights=[0.9, 0.1],  # 90% 负类，10% 正类
        flip_y=0.01,
        random_state=42
    )

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.3, random_state=42, stratify=y
    )

    print(f"\n训练集：{len(y_train)} 样本, 正类比例：{np.mean(y_train):.1%}")
    print(f"测试集：{len(y_test)} 样本, 正类比例：{np.mean(y_test):.1%}")

    # 训练两个模型：一个处理不平衡，一个不处理
    models = {
        "未处理不平衡": LogisticRegression(random_state=42, max_iter=1000),
        "类别加权": LogisticRegression(class_weight='balanced', random_state=42, max_iter=1000),
    }

    plt.figure(figsize=(10, 7))

    for name, model in models.items():
        model.fit(X_train, y_train)
        y_proba = model.predict_proba(X_test)[:, 1]

        # 计算 ROC 曲线
        fpr, tpr, thresholds = roc_curve(y_test, y_proba)
        roc_auc = auc(fpr, tpr)

        # 绘制
        plt.plot(fpr, tpr, linewidth=2, label=f'{name} (AUC = {roc_auc:.3f})')

        print(f"\n{name}:")
        print(f"  AUC = {roc_auc:.3f}")

        # 找到默认阈值 0.5 的位置
        idx = np.argmin(np.abs(thresholds - 0.5))
        print(f"  阈值=0.5 时: FPR={fpr[idx]:.3f}, TPR={tpr[idx]:.3f}")

    # 添加随机猜测基准线
    plt.plot([0, 1], [0, 1], 'k--', linewidth=1, label='随机猜测 (AUC = 0.5)')

    plt.xlim([0.0, 1.0])
    plt.ylim([0.0, 1.05])
    plt.xlabel('假正率 (FPR)', fontsize=12)
    plt.ylabel('真正率 (TPR / 召回率)', fontsize=12)
    plt.title('ROC 曲线对比', fontsize=14, weight='bold')
    plt.legend(loc="lower right", fontsize=11)
    plt.grid(alpha=0.3, linestyle='--')
    plt.tight_layout()
    plt.savefig('/Users/juanwang/Desktop/tutorials/algorithms/experiments/ch09/roc_curve.png',
                dpi=150, bbox_inches='tight')
    print("\nROC 曲线已保存到 roc_curve.png")


# ============================================================================
# 实验 C: 排序指标对比
# ============================================================================

def dcg_at_k(relevances, k):
    """计算 DCG@k"""
    relevances = np.array(relevances)[:k]
    if relevances.size == 0:
        return 0.0
    # DCG = Σ (2^rel - 1) / log2(i+2)
    gains = 2**relevances - 1
    discounts = np.log2(np.arange(2, relevances.size + 2))
    return np.sum(gains / discounts)


def ndcg_at_k(relevances, k):
    """计算 NDCG@k"""
    dcg = dcg_at_k(relevances, k)
    ideal_relevances = sorted(relevances, reverse=True)
    idcg = dcg_at_k(ideal_relevances, k)
    return dcg / idcg if idcg > 0 else 0.0


def average_precision(relevances):
    """计算 AP（平均精确率，适用于二值相关性）"""
    relevances = np.array(relevances)
    if np.sum(relevances) == 0:
        return 0.0

    precisions = []
    num_relevant = 0
    for i, rel in enumerate(relevances):
        if rel > 0:  # 相关
            num_relevant += 1
            precision_at_i = num_relevant / (i + 1)
            precisions.append(precision_at_i)

    return np.mean(precisions) if precisions else 0.0


def reciprocal_rank(relevances):
    """计算 RR（倒数排名）"""
    for i, rel in enumerate(relevances):
        if rel > 0:
            return 1.0 / (i + 1)
    return 0.0


def experiment_c_ranking_metrics():
    """
    模拟搜索引擎返回结果，计算 NDCG、MAP、MRR
    """
    print("\n\n" + "=" * 70)
    print("实验 C: 排序指标对比")
    print("=" * 70)

    # 定义三种排序质量的查询结果
    # 相关性分数：0=不相关, 1=稍微相关, 2=相关, 3=非常相关
    queries = {
        "完美排序": [3, 2, 2, 1, 1, 0, 0, 0, 0, 0],
        "中等排序": [2, 0, 3, 1, 0, 2, 0, 1, 0, 0],
        "糟糕排序": [0, 0, 1, 0, 2, 0, 0, 3, 1, 0],
    }

    print("\n查询结果相关性（0-3 分级）：")
    for name, rels in queries.items():
        print(f"  {name}: {rels}")

    print(f"\n{'查询':<15} {'NDCG@5':<10} {'NDCG@10':<10} {'MAP':<10} {'MRR':<10}")
    print("-" * 60)

    results = []
    for name, rels in queries.items():
        # MAP 需要二值相关性
        binary_rels = [1 if r > 0 else 0 for r in rels]

        ndcg5 = ndcg_at_k(rels, 5)
        ndcg10 = ndcg_at_k(rels, 10)
        map_score = average_precision(binary_rels)
        mrr_score = reciprocal_rank(rels)

        print(f"{name:<15} {ndcg5:<10.3f} {ndcg10:<10.3f} {map_score:<10.3f} {mrr_score:<10.3f}")
        results.append((name, ndcg5, ndcg10, map_score, mrr_score))

    # 可视化对比
    fig, axes = plt.subplots(1, 4, figsize=(16, 4))
    metric_names = ['NDCG@5', 'NDCG@10', 'MAP', 'MRR']

    for idx, metric_name in enumerate(metric_names):
        ax = axes[idx]
        names = [r[0] for r in results]
        values = [r[idx+1] for r in results]

        colors = ['#2ecc71', '#f39c12', '#e74c3c']
        bars = ax.bar(range(len(names)), values, color=colors, alpha=0.8, edgecolor='black')
        ax.set_ylim([0, 1.1])
        ax.set_xticks(range(len(names)))
        ax.set_xticklabels(names, rotation=15, ha='right')
        ax.set_title(metric_name, fontsize=12, weight='bold')
        ax.set_ylabel('分数', fontsize=10)
        ax.grid(axis='y', alpha=0.3, linestyle='--')

        # 标注数值
        for bar, value in zip(bars, values):
            height = bar.get_height()
            ax.text(bar.get_x() + bar.get_width()/2., height + 0.02,
                   f'{value:.3f}', ha='center', va='bottom', fontsize=9, weight='bold')

    plt.tight_layout()
    plt.savefig('/Users/juanwang/Desktop/tutorials/algorithms/experiments/ch09/ranking_metrics.png',
                dpi=150, bbox_inches='tight')
    print("\n排序指标对比图已保存到 ranking_metrics.png")

    # 详细解读
    print("\n" + "=" * 70)
    print("解读：")
    print("=" * 70)
    print("- 完美排序：所有指标都是 1.0（或接近 1.0）")
    print("- 中等排序：MRR 仍然高（第一个结果相关），但 MAP/NDCG 下降（后续排序不佳）")
    print("- 糟糕排序：所有指标都低，第一个相关结果在位置 3（MRR=0.333）")


# ============================================================================
# 主函数
# ============================================================================

def main():
    """运行所有实验"""
    print("\n" + "=" * 70)
    print("第 9 章实验：评估指标计算与可视化")
    print("=" * 70)
    print("\n本实验包含三部分：")
    print("  A. 不平衡数据集的分类指标对比")
    print("  B. ROC 曲线与 AUC")
    print("  C. 排序指标（NDCG、MAP、MRR）")
    print("\n" + "=" * 70 + "\n")

    experiment_a_imbalanced_metrics()
    experiment_b_roc_curve()
    experiment_c_ranking_metrics()

    print("\n\n" + "=" * 70)
    print("所有实验完成！")
    print("=" * 70)
    print("生成的文件：")
    print("  - confusion_matrices.png: 混淆矩阵对比")
    print("  - roc_curve.png: ROC 曲线")
    print("  - ranking_metrics.png: 排序指标对比")
    print("\n请查看图片并结合教材理解指标的含义。")


if __name__ == "__main__":
    main()
