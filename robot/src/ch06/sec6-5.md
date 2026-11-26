# 6.5 动力学正解与逆解

无论通过拉格朗日法得到矩阵形式，还是通过牛顿–欧拉法获得两遍递推过程，工程应用都归结为两个互逆的问题：仿真需要由力和力矩算出机械臂未来怎样运动，前馈控制与轨迹校验需要由给定运动算出电机需要提供多大载荷。本节严格界定这两个问题，并说明怎样用纯逆动力学递推高效求解正动力学所需的惯性矩阵 $B(\boldsymbol q)$。

## 6.5.1 两个问题的严格定义与本质差异

::: def 定义 6.5.1 · 动力学正解与逆解 {#def-6.5.1}
考虑机械臂动力学模型，忽略复杂未建模弹性并给定外部接触作用 $\boldsymbol h_e$：

1. **动力学逆解（Inverse Dynamics）**：给定关节位置 $\boldsymbol q(t)$、速度 $\dot{\boldsymbol q}(t)$、加速度 $\ddot{\boldsymbol q}(t)$ 及末端接触广义力 $\boldsymbol h_e(t)$，求所需各关节驱动广义力向量 $\boldsymbol\tau(t)$。
2. **动力学正解（Direct / Forward Dynamics）**：给定驱动广义力输入 $\boldsymbol\tau(t)$、接触力 $\boldsymbol h_e(t)$ 及初始状态 $\bigl(\boldsymbol q(t_0),\,\dot{\boldsymbol q}(t_0)\bigr)$，求后续时刻的关节加速度 $\ddot{\boldsymbol q}(t)$，并随时间积分得到运动轨迹 $\boldsymbol q(t),\dot{\boldsymbol q}(t)$。
:::

| 比较维度 | 逆动力学（Inverse Dynamics） | 正动力学（Direct Dynamics） |
|:--|:--|:--|
| 输入 | $\boldsymbol q,\ \dot{\boldsymbol q},\ \ddot{\boldsymbol q},\ \boldsymbol h_e$ | $\boldsymbol\tau,\ \boldsymbol h_e$ 及初态 $\boldsymbol q(t_0),\dot{\boldsymbol q}(t_0)$ |
| 输出 | 代数求得的 $\boldsymbol\tau$ | $\ddot{\boldsymbol q}$ 及微分方程数值积分轨迹 $(\boldsymbol q(t),\dot{\boldsymbol q}(t))$ |
| 数学本质 | **纯代数代入 / 递推**，瞬时决定，无历史路径依赖 | 求解二阶**耦合非线性常微分方程组**（一般无闭合解析解） |
| 工程用途 | 计算力矩前馈控制、电机选型、轨迹力矩可行性检验 | 物理仿真器引擎、自由落体或碰撞响应推演 |

## 6.5.2 正动力学的数值推进与 $B(\boldsymbol q)$ 列采样法

将关节空间主方程写成关于最高阶导数 $\ddot{\boldsymbol q}$ 的显式形式。把速度耦合、摩擦、重力及接触项合并记为当前状态载荷 $\boldsymbol\tau'(\boldsymbol q,\dot{\boldsymbol q},\boldsymbol h_e)$：

$$\boldsymbol\tau'(\boldsymbol q,\dot{\boldsymbol q},\boldsymbol h_e) = C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q} + F_{\mathrm v}\dot{\boldsymbol q} + F_{\ s}\operatorname{sgn}(\dot{\boldsymbol q}) + \boldsymbol g(\boldsymbol q) + J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e.$$

利用惯性矩阵 $B(\boldsymbol q)$ 对非退化机械臂恒对称正定（必可逆），解得任意时刻的瞬时加速度：

$$\boxed{\ \ddot{\boldsymbol q} = B^{-1}(\boldsymbol q)\bigl(\boldsymbol\tau - \boldsymbol\tau'(\boldsymbol q,\dot{\boldsymbol q},\boldsymbol h_e)\bigr)\ }$$

一旦算出瞬时 $\ddot{\boldsymbol q}$，连同状态 $(\boldsymbol q,\dot{\boldsymbol q})$ 构成了标准的一阶状态空间常微分方程，可通过欧拉法（教学演示）或四阶 Runge–Kutta（RK4，工程仿真常用）按步长 $\Delta t$ 向前推进：

$$\dot{\boldsymbol q}(t+\Delta t) \approx \dot{\boldsymbol q}(t) + \ddot{\boldsymbol q}(t)\Delta t,\qquad \boldsymbol q(t+\Delta t) \approx \boldsymbol q(t) + \dot{\boldsymbol q}(t)\Delta t + \frac12\ddot{\boldsymbol q}(t)\Delta t^2\quad\text{（或高阶 RK4）}.$$

### 只用 $O(n)$ 牛顿–欧拉逆解程序如何完成正解？

在实际仿真软件中，通常已编写好高效的牛顿–欧拉逆动力学函数 $\operatorname{RNE}(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q},\boldsymbol g_0,\boldsymbol h_e)$，而并不想再去手写一套冗长的拉格朗日解析矩阵 $B,C,\boldsymbol g$。利用叠加原理可以分两步直接借用 $\operatorname{RNE}$ 求正解：

1. **一次性算出总非惯性载荷 $\boldsymbol\tau'$**：令加速度输入为零（$\ddot{\boldsymbol q}=\boldsymbol 0$），调用一次递推函数：

$$\boldsymbol\tau' = \operatorname{RNE}(\boldsymbol q,\dot{\boldsymbol q},\boldsymbol 0,\boldsymbol g_0,\boldsymbol h_e)\ \bigl(+\ \text{已知摩擦项}\bigr).$$

2. **逐列采出惯性矩阵 $B(\boldsymbol q)$**：将速度、重力及接触外力全设为零（$\dot{\boldsymbol q}=\boldsymbol 0,\ \boldsymbol g_0=\boldsymbol 0,\ \boldsymbol h_e=\boldsymbol 0$，也不计摩擦），令加速度先后取标准基向量 $\boldsymbol e_j = [0,\dots,1,\dots,0]^{\mathrm T}$（$j=1,\dots,n$）。此时主方程只余下 $B(\boldsymbol q)\boldsymbol e_j$，正好返回 $B(\boldsymbol q)$ 的第 $j$ 列 $\boldsymbol b_j(\boldsymbol q)$：

$$\boldsymbol b_j(\boldsymbol q) = \operatorname{RNE}(\boldsymbol q,\boldsymbol 0,\boldsymbol e_j,\boldsymbol 0,\boldsymbol 0),\qquad j=1,\dots,n.$$

拼装成对称阵 $B(\boldsymbol q)=[\boldsymbol b_1,\dots,\boldsymbol b_n]$ 并解线性方程组 $B\ddot{\boldsymbol q}=\boldsymbol\tau-\boldsymbol\tau'$（采用 Cholesky 分解比直接矩阵求逆数值稳定性更好，尤其当末端接近工作边界或部分轴质量比极大、$B$ 条件数偏高时）。

## 6.5.3 计算复杂度口径说明

讨论正、逆动力学计算耗时应明确“给定什么形式”与“如何实现”，避免混淆不同来源中的阶数说法：

| 计算方法与场景 | 时间复杂度 | 说明 |
|:--|:--|:--|
| 递推牛顿–欧拉逆解 $\operatorname{RNE}$ | **$O(n)$** | 不显式组装 $B,C,\boldsymbol g$，每杆计算量固定，自由度高时最快 |
| 已有显式矩阵后的逆解代入 | $O(n^2)$ | 单次矩阵乘向量 $B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}$ 为 $O(n^2)$，不含求取矩阵本身的符号/展开开销 |
| 经由 $n$ 次 RNE 列采样组阵再分解求解的正解 | $O(n^3)$ | 列采样花费 $n\times O(n)=O(n^2)$，随后对 $n\times n$ 矩阵 $B$ 做 Cholesky 分解为 $O(n^3)$（实际对常用 6 轴臂 $n=6$ 仍极快；超大自由度另有 $O(n)$ 铰接体正动力学算法） |

## 本节小结

- **逆解只代入、正解要积分**：控制主要依赖逆动力学（快、解析稳定）；仿真需要正动力学求解 $\ddot{\boldsymbol q}=B^{-1}(\boldsymbol\tau-\boldsymbol\tau')$ 并随时间做 RK4 积分。
- **两套模型无缝对接**：只需将 $\operatorname{RNE}$ 分别置 $\ddot{\boldsymbol q}=\boldsymbol 0$ 和单位坐标加速度 $\boldsymbol e_j$，即可无痛算出 $\boldsymbol\tau'$ 与 $B(\boldsymbol q)$ 全部分量用于正动力学仿真。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 84:30 板书 | [dyn-board-compare.jpg](../assets/ch06/dyn-board-compare.jpg) | 正逆动力学对比说明 | 6.5.1 并入对比表与核心要点 |
| 84:43 | [dyn-def.jpg](../assets/ch06/dyn-def.jpg) | 正解与逆解定义 | 定义 6.5.1 严格界定 |
| 85:46 | [dyn-qddot.jpg](../assets/ch06/dyn-qddot.jpg) | $\ddot{\boldsymbol q}=B^{-1}(\boldsymbol\tau-\boldsymbol\tau')$ 式 | 6.5.2 导出并强调正定性与条件数 |
| 86:10 | [dyn-integration.jpg](../assets/ch06/dyn-integration.jpg) | 数值积分推进 | 6.5.2 给出推进流程及 RK4 说明 |
| 87:03 | [dyn-B-ne.jpg](../assets/ch06/dyn-B-ne.jpg) | 用逆动力学递推采样 $B(\boldsymbol q)$ 各列 | 6.5.2 完整给出叠加置零法四步骤 |
| 87:31 | [dyn-complexity.jpg](../assets/ch06/dyn-complexity.jpg) | 计算复杂度对比 | 6.5.3 分三种计算口径澄清 $O(n)/O(n^2)/O(n^3)$ |
:::
