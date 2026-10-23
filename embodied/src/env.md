# 实验环境与工具链

本书所有实验脚本与实战项目均基于 Python 3.10+ 与 NumPy/SciPy 构建，不依赖 ROS、Ceres、g2o 等重型框架；每个实验都能用一条 `python3` 命令复现。

---

## 1. 基础依赖

在仓库内直接执行以下命令安装依赖：

```bash
# 安装基础数学运算与测试依赖
pip install -r embodied/requirements.txt
```

`requirements.txt` 清单如下：
```text
numpy>=1.24.0
scipy>=1.10.0
matplotlib>=3.7.0
pytest>=7.3.0
```

---

## 2. 目录结构与项目测试

本书配套的全部实验脚本位于 `embodied/experiments/`，两大独立工程项目位于 `embodied/projects/`。

验证项目一（小车 SLAM 闭环系统）：
```bash
cd embodied/projects/car-slam
PYTHONPATH=. pytest tests/ -v
```

验证项目二（机械臂视觉伺服控制系统）：
```bash
cd embodied/projects/arm-servoing
PYTHONPATH=. pytest tests/ -v
```

运行各章核心算法实验（以第 3 章 EKF 跟踪与第 8 章点到面 ICP 为例）：
```bash
python3 embodied/experiments/ch03/exp1_linear_kf_vs_ekf_tracking.py
python3 embodied/experiments/ch08/exp1_point_to_plane_icp.py
```
