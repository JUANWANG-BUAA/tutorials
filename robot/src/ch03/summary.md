# 第三章总结 · 微分运动学和静力学

> 本章在正运动学基础上通过求导与虚功建立速度映射与静力对偶，解答速度合成、奇点降秩、冗余零空间分配、数值逆解及静力传力五类核心工程问题。

## 八节核心结论与易错点对照

| 节 | 关键结论 | 常见陷阱 |
|:--|:--|:--|
| [3.1 几何雅可比](sec3-1.md) | $\boldsymbol v_e=J(\boldsymbol q)\dot{\boldsymbol q}$（[@def-3.1.1]）；$\dot R=S(\boldsymbol\omega)R$ 与共轭律 $RS(\boldsymbol\omega)R^{\mathrm T}=S(R\boldsymbol\omega)$（[@thm-3.1.A]、[@thm-3.1.B]）；几何雅可比逐列构造公式（[@thm-3.1.C]） | 直接对 $\dot R$ 摘帽；预设关节轴 $\boldsymbol z_{i-1}=[0,0,1]^{\mathrm T}$；转动列叉乘矢径反序；漏掉固连工具偏置 |
| [3.2 典型结构](sec3-2.md) | 五步标准流程（[@method-3.2.A]）；3R 平面臂、拟人臂（$\det J_P$ 降阶含余弦组合）、斯坦福 $6\times 6$ 构造与数值中心差分校验 | 斯坦福移动关节第 3 列误套转动公式；误以为转轴固定处线速度列必非零 |
| [3.3 运动学奇点](sec3-3.md) | 降秩判据 $\operatorname{rank}J<r_{\max}$（方阵 $\det J=0$，[@def-3.3.1]）；速度椭球半轴 $Q\sigma_i$；六轴球腕解耦 $\det J=\det J_{11}\det J_{22}$（[@thm-3.3.A]）分判腕/肘/肩奇点 | 混淆“轴平行”与“列相关”；把腕心雅可比 $J_w$ 直接代用于工具点速度指令 |
| [3.4 冗余分析](sec3-4.md) | 任务相关冗余 $n>r$（[@def-3.4.1]）；秩-零度关系 $\dim\mathcal R(J)+\dim\mathcal N(J)=n$；正交投影 $P=B(B^{\mathrm T}B)^{-1}B^{\mathrm T}$（[@thm-3.4.B]）与有限更新 $O(h^2)$ 漂移 | 把求任务雅可比简化为选行；未归一化即写成 $BB^{\mathrm T}$；混同瞬时零速度与有限自运动 |
| [3.5 逆微分运动学](sec3-5.md) | 前向 Euler 数值积分；加权右伪逆 $J_W^\#$（[@def-3.5.1]）与零空间次目标梯度；阻尼广义逆 $J^*$（[@def-3.5.2]）限制增益峰值为 $1/(2k)$ | 行满秩闭式硬套奇异位形；混淆误差权 $K$ 与阻尼 $k$；以为阻尼能补回丢失速度方向 |
| [3.6 分析雅可比](sec3-6.md) | ZYZ 角速率与角速度关系 $\boldsymbol\omega_e=T\dot{\boldsymbol\varphi}_e$；光滑非奇异域内 $J=T_AJ_A$（[@thm-3.6.A]）保秩；角速度分量积分丢失顺序不可唯一恢复姿态 | 把 $T$ 非正交轴的合成系数误当逐轴点积；混淆姿态表示奇点与机构奇点 |
| [3.7 闭环逆运动学](sec3-7.md) | 一阶逆方案（前馈+反馈指数收敛 $\dot{\boldsymbol e}=-K\boldsymbol e$）、转置方案（负梯度下降但受制于位形与固定目标）及二阶加速度方案与姿态误差配套 | 欧拉角误差导数错配几何 $J$；二阶方案漏掉 $\dot J_A\dot{\boldsymbol q}$ |
| [3.8 静力学](sec3-8.md) | 虚功与功率守恒导出 $\boldsymbol\tau=J^{\mathrm T}(\boldsymbol q)\boldsymbol F_e$（[@def-3.8.1]）；同向换基与换参考点速度/力变换互为逆转置 $A_v, A_v^{-\mathrm T}$ | 误用 $J^{-1}$ 传力；$\boldsymbol F_e$（施于环境）与环境反力符号混用；传感器参考点力臂遗漏 |

## 全章三条核心骨架

1. **逐列构造统领几何雅可比**：锁死其余关节、单位速度单轴驱动即给出雅可比各列——转动列 $\begin{bmatrix}\boldsymbol z_{i-1}\times(\boldsymbol p_e-\boldsymbol p_{i-1})\\\boldsymbol z_{i-1}\end{bmatrix}$、移动列 $\begin{bmatrix}\boldsymbol z_{i-1}\\\boldsymbol 0\end{bmatrix}$，所有矢量直接由正运动学中间矩阵 $T_i^0$ 读出。
2. **先判定任务秩，再选用逆解算子**：满秩方阵用 $J^{-1}$；冗余行满秩用伪逆叠零空间投影；近奇异或降秩用阻尼最小二乘 $J^*$ 换取有界增益 $1/(2k)$；涉及姿态坐标参数须以光滑分支下的分析雅可比 $J_A$ 衔接。
3. **同一雅可比通过转置连接力传递**：$\boldsymbol\tau=J^{\mathrm T}\boldsymbol F_e$ 来自虚功为零与功率对偶，不依赖 $J$ 的方阵或满秩性，是后续动力学末端载荷项（$-J^{\mathrm T}\boldsymbol h_e$）和力控制的直接基石。

接下来[第四章 · 轨迹规划](../ch04/overview.md)将把瞬时几何与速度推进到带时间律、平滑加减速限制的整段轨迹构造。
