# 符号、代码与证据约定

为了保证全书数学符号的一致性，本书遵循机器人学与现代 SLAM 领域的国际通用学术规范。

---

## 1. 常用坐标系与几何符号

- $\mathcal{F}_W$：世界静止惯性参考坐标系（World Frame，通常对齐东北天 ENU 或启动原点）；
- $\mathcal{F}_B$：机器人本体底盘坐标系（Body/Base Frame）；
- $\mathcal{F}_C$：相机光学中心坐标系（Camera Frame，右-下-前 或 前-左-上）；
- $\mathcal{F}_L$：激光雷达传感器坐标系（LiDAR Frame）；
- $\mathcal{F}_I$：IMU 惯性测量单元坐标系（IMU Frame）；
- $T_{BA} \in \mathrm{SE}(3)$：表示将点从坐标系 $A$ 变换至坐标系 $B$ 的刚体位姿变换矩阵：$p^B = T_{BA} p^A = R_{BA} p^A + t_{BA}$；
- $\exp(\xi^\wedge)$ / $\log(T)^\vee$：特殊欧氏群 $\mathrm{SE}(3)$ 与其切空间李代数 $\mathfrak{se}(3)$ 之间的指数映射与对数映射。

---

## 2. 状态估计与概率符号

- $x_k \in \mathbb{R}^n$：第 $k$ 时刻系统的真实状态向量；
- $\hat{x}_k$：第 $k$ 时刻状态的后验估计均值；
- $u_k$：第 $k$ 时刻系统的控制输入（或里程计/IMU名义输入）；
- $z_k$：第 $k$ 时刻传感器的观测测量值；
- $P_k \in \mathbb{R}^{n \times n}$：状态估计误差的协方差矩阵；
- $Q_k$：系统过程噪声协方差矩阵；
- $R_k$：传感器观测噪声协方差矩阵；
- $\Omega = \Sigma^{-1}$：信息矩阵（协方差之逆）；
- $\mathrm{bel}(x_k) = p(x_k \mid z_{1:k}, u_{1:k})$：第 $k$ 步的置信状态（Belief State）。

---

## 3. 代码与证据约定

- 所有代码遵循 Python 3.10+ 标准，核心数值运算基于 NumPy / SciPy 实现，无隐藏调包；
- 所有工程实现均带有严格的输入输出形状校验与物理量纲注释；
- 代码与测试完全通过 `pytest` 自动化运行检验，可零配置在 macOS、Linux、Ubuntu 等环境中复现。
