# 第 6 章实验：交叉验证与模型选择

## 运行前准备

安装依赖：
```bash
pip install -r requirements.txt
```

或单独安装：
```bash
pip install numpy matplotlib scikit-learn
```

## 运行实验

```bash
python3 cv_lab.py
```

## 实验内容

1. **任务 1**：手动实现 k-fold 交叉验证，与 sklearn 对比
2. **任务 2**：偏差-方差分解实验（不同多项式阶数）
3. **任务 3**：学习曲线（诊断欠拟合/过拟合）
4. **任务 4**：验证曲线（选择最优超参数）
5. **任务 5**：数据泄露演示（特征选择和标准化）
6. **任务 6**：LOOCV vs. k-fold 性能对比

## 输出

生成三张图像：
- `ch06_bias_variance_decomposition.png` - 偏差-方差分解
- `ch06_learning_curves.png` - 学习曲线
- `ch06_validation_curve.png` - 验证曲线

## 理论对应

对应教材第 6 章各节：
- §6.2：k-fold 实现
- §6.5：偏差-方差分解推导
- §6.6：学习曲线和验证曲线
- §6.7：数据泄露陷阱
