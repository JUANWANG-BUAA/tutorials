# 附录 C · 术语表、开源工具与经典文献

---

## 1. 核心术语中英文对照表

| 中文术语 | 英文术语 | 常用缩写 / 符号 | 核心定义与工程内涵 |
|:--|:--|:--|:--|
| **特殊欧氏群** | Special Euclidean Group | $\mathrm{SE}(3)$ | 描述三维空间刚体旋转与平移的流形群 |
| **李代数** | Lie Algebra | $\mathfrak{se}(3)$ | 李群在单位元处的切空间，局部向量空间表示 |
| **视觉里程计** | Visual Odometry | VO | 仅依赖相机图像序列估计本体相对位姿变换 |
| **视觉惯性里程计** | Visual-Inertial Odometry | VIO | 融合相机与 IMU 高频加速度/角速度的里程计 |
| **激光惯导里程计** | LiDAR-Inertial Odometry | LIO | 融合激光雷达点云与 IMU 的高动态里程计 |
| **光束法平差** | Bundle Adjustment | BA | 联合优化相机位姿与三维路标点的非线性最小二乘 |
| **舒尔补消元** | Schur Complement | — | 利用稀疏块对角结构消去路标点、先求解相机位姿的高效算法 |
| **误差状态卡尔曼滤波** | Error-State Kalman Filter | ESKF | 在切空间误差向量上递推协方差、在流形上更新名义状态的滤波器 |
| **无迹变换** | Unscented Transform | UT | 利用确定性 Sigma 点精确传递非线性高斯均值与协方差的数值方法 |
| **蒙特卡洛定位** | Monte Carlo Localization | MCL | 基于粒子滤波与占据栅格地图的机器人全局定位方法 |
| **正态分布变换** | Normal Distributions Transform | NDT | 将离散点云体素化为局部高斯概率密度函数进行配准的方法 |
| **截断符号距离函数** | Truncated Signed Distance Function | TSDF | 隐式三维表面体素表征，记录体素到最近表面的截断有符号距离 |
| **图像相互作用矩阵** | Interaction Matrix | $L_s$ (Image Jacobian) | 关联相机空间运动旋量与图像特征变化率的雅可比矩阵 |

---

## 2. 经典学术文献与工程专著

1. **Gao, X., et al.** 《视觉SLAM十四讲：从理论到实践》（第2版），电子工业出版社，2019.
2. **高翔.** 《自动驾驶与机器人中的SLAM技术：从理论到实践》，电子工业出版社，2023.
3. **Craig, J. J.** *Introduction to Robotics: Mechanics and Control* (4th Edition), Pearson, 2018.
4. **Siciliano, B., Sciavicco, L., Villani, L., & Oriolo, G.** *Robotics: Modelling, Planning and Control*, Springer, 2009.
5. **Thrun, S., Burgard, W., & Fox, D.** *Probabilistic Robotics*, MIT Press, 2005.
6. **Barfoot, T. D.** *State Estimation for Robotics*, Cambridge University Press, 2017.
7. **Chaumette, F., & Hutchinson, S.** "Visual servo control. Part I: Basic approaches," *IEEE Robotics & Automation Magazine*, 2006.
8. **Qin, T., Li, P., & Shen, S.** "VINS-Mono: A robust and versatile monocular visual-inertial state estimator," *IEEE Transactions on Robotics*, 2018.
9. **Zhang, J., & Singh, S.** "LOAM: Lidar Odometry and Mapping in Real-time," *Robotics: Science and Systems (RSS)*, 2014.
10. **Xu, W., & Zhang, F.** "Fast-LIO2: Fast direct LiDAR-inertial odometry," *IEEE Transactions on Robotics*, 2022.
