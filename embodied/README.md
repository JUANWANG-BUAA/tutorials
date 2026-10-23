# 具身感知：SLAM、状态估计与传感器融合

**4 篇 · 14 章 · 28 个可运行实验 · 2 个工程实战项目**。

从贝叶斯滤波与 SE(3) 李代数出发，经过 IMU/轮速/GNSS 组合导航、相机与激光里程计、回环检测与位姿图、Bundle Adjustment 与因子图、栅格/TSDF/语义建图，最终落到小车 2D SLAM 与机械臂视觉伺服两个可运行项目。

---

## 快速开始

```bash
# 1. Python 依赖（numpy / scipy / matplotlib / pytest）
python3 -m pip install -r requirements.txt

# 2. 本地预览（需要 mdbook 0.5.x）
cd embodied
mdbook serve --open

# 3. 构建静态站点
mdbook build
```

产物在 `embodied/book/`。站点的搜索索引与术语数据是**构建后产物**，由仓库根目录的 `build.sh` 统一生成；只跑 `mdbook build` 会得到没有索引的页面。

---

## 目录结构

```
embodied/
├── book.toml            # mdBook 配置与预处理器
├── src/
│   ├── SUMMARY.md       # 目录与导航
│   ├── preface.md       # 卷首：为什么写这本书
│   ├── scope.md         # 范围与边界
│   ├── part1/           # 第 1 篇：状态估计与贝叶斯滤波（1–4 章）
│   ├── part2/           # 第 2 篇：传感器建模与里程计（5–8 章）
│   ├── part3/           # 第 3 篇：后端优化、建图与鲁棒工程（9–12 章）
│   ├── part4/           # 第 4 篇：项目实战（13–14 章）
│   └── appendix/        # 覆盖矩阵、勘误、延伸阅读
├── experiments/         # 每章两个实验（ch01/ … ch14/）
├── projects/
│   ├── car-slam/        # 项目一：小车 2D SLAM 闭环系统
│   └── arm-servoing/    # 项目二：机械臂视觉伺服
├── tools/               # check_book.py / build_coverage.py / mathbook.py
└── theme/               # 视觉层
```

---

## 实验

每个实验都是独立脚本，固定随机种子，可直接运行并复现正文引用的数字：

```bash
python3 experiments/ch09/exp1_dbow_loop_closure.py
python3 experiments/ch09/exp2_pose_graph_se2_optimization.py
python3 experiments/ch13/exp1_car_slam_sim_trajectory.py
```

实验的定位是**验证公式与计数**，不是系统性能基准。正文在每一章末尾明确写出"能证明"与"不能证明"的边界；仿真中的阈值不能直接搬到实车。

## 项目

两个项目都是可安装、可测试的 Python 包：

```bash
PYTHONPATH=projects/car-slam python3 -m pytest -q projects/car-slam/tests      # 9 passed
PYTHONPATH=projects/arm-servoing python3 -m pytest -q projects/arm-servoing/tests  # 10 passed
```

`car-slam` 覆盖 SE(2) 流形、扫描匹配、关键帧与子图、回环、位姿图与占据栅格；`arm-servoing` 覆盖针孔模型、交互矩阵、IBVS/PBVS、阻尼最小二乘与眼在手映射。

## 质量门禁

```bash
python3 tools/check_book.py          # 结构、锚点、盒子、公式定界符、断链
python3 tools/check_book.py --verbose
```

门禁检查：每章 1000–1500 行、8–12 个带锚点的二级节、语义盒配平、机制图与观测命令、实验入口、母本对应、≥10 条陷阱、出口检查与下一站。它检查的是**契约**，不是内容正确性；内容仍需逐章复核。
