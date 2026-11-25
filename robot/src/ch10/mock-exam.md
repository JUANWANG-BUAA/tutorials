# 综合自测卷 · 第十章 移动机器人建模

> **时间 90 分钟 · 满分 100**。闭卷，允许携带一张手写公式纸。
> 分值分配：概念与坐标系 20 + 约束与可积性 20 + 独轮与差速建模 25 + 两轮车与秩检验 20 + 链式与动力学 15 = **100 分**。

## 一、概念与坐标系（20 分）

**1.（10 分）** 写出移动机器人定义的三个核心要素，并简述「感知–思考–行动」闭环中从传感到执行的各环节分别回答什么问题（重点说明为什么实际执行必须闭环）。

::: note 一、参考答案
**1.** 三要素：在环境中运行、自主改变自身位置/姿态（位姿）、包含完整的感知–规划–控制系统（3 分）。
闭环环节：传感 + 信息提取回答「我周围有什么」（2 分）；定位与建图回答「我在哪里、环境长什么样」（2 分）；决策与运动规划回答「我要去哪、怎么去」（1 分）；由于传感噪声、地面摩擦与执行器误差，开环无法精确跟踪，因此须由 PID/MPC 控制器根据实时反馈修正误差并驱动执行器（2 分）。
:::

**2.（10 分）** 说明平面移动底盘在载体坐标系 $B$ 下原点与坐标轴的常用约定，写出平面刚体位姿齐次矩阵 $T_B^W(q)$，并说明 GPS 输出的 LLA 坐标为何不宜直接用于局部运动学建模。

::: note 参考答案
**2.** 差速小车与汽车/两轮车模型常取后轴中点为原点 $O_B$，对称 AGV 取几何中心；按右手系取 $x_B$ 向前、$y_B$ 向左、$z_B$ 向上（3 分）。
$T_B^W(q)=\begin{bmatrix}\cos\theta&-\sin\theta&x\\\sin\theta&\cos\theta&y\\0&0&1\end{bmatrix}$（4 分）。
LLA 为地球椭球面上的经纬高坐标，不同纬度下米/度尺度不同且非平面直角系，须先投影转换为局部惯性系或 ENU 东北天坐标系再建立运动学方程（3 分）。
:::

## 二、约束与可积性（20 分）

**3.（10 分）** 从世界系与载体系速度转换出发，推导无侧滑轮式小车的 Pfaffian 约束 $\dot x\sin\theta-\dot y\cos\theta=0$，并说明「完整约束」与「非完整约束」的根本差异。

::: note 参考答案
**3.** 由 $\begin{bmatrix}\dot x\\\dot y\end{bmatrix}=R_B^W(\theta)\begin{bmatrix}v_x^B\\v_y^B\end{bmatrix}$ 求逆得 $\begin{bmatrix}v_x^B\\v_y^B\end{bmatrix}=\begin{bmatrix}\cos\theta&\sin\theta\\-\sin\theta&\cos\theta\end{bmatrix}\begin{bmatrix}\dot x\\\dot y\end{bmatrix}$（4 分）。令侧向速度 $v_y^B = 0$，即 $-\dot x\sin\theta+\dot y\cos\theta=0 \implies \dot x\sin\theta-\dot y\cos\theta=0$（2 分）。
差异：完整约束 $h(q)=0$ 直接限制位形位置并使位形空间从 $n$ 维降至 $n-k$ 维；非完整约束 $A^T(q)\dot q=0$ 仅限制切空间中的瞬时速度方向而不可积分为 $h(q)=0$，位姿仍可到达全状态空间（4 分）。
:::

**4.（10 分）** 已知平面滚动圆盘的 Pfaffian 约束为 $\dot x\sin\theta - \dot y\cos\theta = 0$（$q=(x,y,\theta)^{\mathrm T}$），试利用积分因子判据严格证明该约束是不可积的（非完整的）。

::: note 参考答案
**4.** 设存在光滑非零积分因子 $\gamma(x,y,\theta)$ 使 $\gamma a = \nabla h$，这里 $a=(\sin\theta,-\cos\theta,0)^{\mathrm T}$（2 分）。由 $\frac{\partial(\gamma a_i)}{\partial q_j}=\frac{\partial(\gamma a_j)}{\partial q_i}$ 取 $(i,j)=(2,3)$ 与 $(1,3)$ 得：
$\cos\theta\frac{\partial\gamma}{\partial\theta}=\gamma\sin\theta$，且 $\sin\theta\frac{\partial\gamma}{\partial\theta}=-\gamma\cos\theta$（4 分）。
两式平方相加得 $(\partial\gamma/\partial\theta)^2=\gamma^2 \implies \partial\gamma/\partial\theta=\pm\gamma$（2 分）。代回原两式得 $\gamma\cos\theta=\pm\gamma\sin\theta$ 与 $\gamma\sin\theta=\mp\gamma\cos\theta$，消去三角函数推出唯一解 $\gamma\equiv 0$，与 $\gamma\neq 0$ 矛盾，故不可积（2 分）。
:::

## 三、独轮车与差速驱动建模（25 分）

**5.（15 分）** 写出独轮车模型 $\dot q = G(q)u$，完整手推一阶李括号 $g_3=[g_1,g_2]$，并据 Frobenius 定理与 Chow 定理得出该系统的完整性与可控性结论。

::: note 参考答案
**5.** $q=(x,y,\theta)^{\mathrm T},\ u=(v,\omega)^{\mathrm T}$，运动学方程为 $\dot q = \begin{bmatrix}\cos\theta&0\\\sin\theta&0\\0&1\end{bmatrix}\begin{bmatrix}v\\\omega\end{bmatrix}$（4 分）。
取 $g_1=[\cos\theta,\sin\theta,0]^{\mathrm T},\ g_2=[0,0,1]^{\mathrm T}$。因为 $g_2$ 为常向量，故 $\frac{\partial g_2}{\partial q}=\mathbf 0$（2 分）；又 $\frac{\partial g_1}{\partial q}=\begin{bmatrix}0&0&-\sin\theta\\0&0&\cos\theta\\0&0&0\end{bmatrix}$，故
$g_3=[g_1,g_2] = \mathbf 0 - \frac{\partial g_1}{\partial q}g_2 = [\sin\theta,\ -\cos\theta,\ 0]^{\mathrm T}$（5 分）。
$\det([g_1,g_2,g_3])=+1\neq 0$，即 $\dim\bar\Delta=\dim\Delta_2=3=n$。由 Frobenius 定理，分布不对合故系统非完整；由 Chow 定理，控制李代数处处满秩，系统为**完全非完整且全局可控**（4 分）。
:::

**6.（10 分）** 设差速驱动小车左右轮半径 $r=0.06\,\mathrm m$、轮距 $d=0.36\,\mathrm m$。写出 $(v,\omega)$ 与 $(\omega_R,\omega_L)$ 的正逆换算公式；若当前右轮角速度 $\omega_R=10\,\mathrm{rad/s}$、左轮 $\omega_L=4\,\mathrm{rad/s}$，求整车前向线速度 $v$ 与角速度 $\omega$，并说明差速小车等效独轮车的三个基本假设。

::: note 参考答案
**6.** 正换算：$v=\frac{r(\omega_R+\omega_L)}{2},\ \omega=\frac{r(\omega_R-\omega_L)}{d}$；逆换算：$\omega_R=\frac{v+(d/2)\omega}{r},\ \omega_L=\frac{v-(d/2)\omega}{r}$（4 分）。
代入数值：$v = 0.06\times(10+4)/2 = 0.42\,\mathrm{m/s}$，$\omega = 0.06\times(10-4)/0.36 = 1.0\,\mathrm{rad/s}$（3 分）。
三大假设：地面平坦、低速运行、轮地接触无侧滑（3 分）。
:::

## 四、两轮车模型与秩检验（20 分）

**7.（20 分）** 已知轴距为 $l$ 的两轮车模型，取后轴中点为原点、状态 $q=(x,y,\theta,\phi)^{\mathrm T}$、输入 $u=(v,\dot\phi)^{\mathrm T}$。
(1) 写出**后轮驱动**与**前轮驱动**两轮车各自的运动学方程，并解释前驱方程中出现 $\cos\phi$ 的几何原因；
(2) 对后轮驱动模型计算 $g_3=[g_1,g_2]$ 与 $g_4=[g_1,g_3]$，并说明应如何检验 $\{g_1,g_2,g_3,g_4\}$ 张满 4 维空间。

::: note 参考答案
**7.** (1) 后轮驱动：$\dot x=v\cos\theta,\ \dot y=v\sin\theta,\ \dot\theta=\frac{v}{l}\tan\phi,\ \dot\phi=\dot\phi$（3 分）；前轮驱动：$\dot x=v\cos\phi\cos\theta,\ \dot y=v\cos\phi\sin\theta,\ \dot\theta=\frac{v}{l}\sin\phi,\ \dot\phi=\dot\phi$（3 分）。几何原因：位形原点仍在后轴中点，前轮速度 $v$ 沿车身前后方向（$x_B$）投影后，后轴中点实际前向速度大小为 $v\cos\phi$（2 分）。
(2) 由 $g_1=[\cos\theta,\sin\theta,\frac{1}{l}\tan\phi,0]^{\mathrm T},\ g_2=[0,0,0,1]^{\mathrm T}$ 得：
$g_3=[g_1,g_2]=-\frac{\partial g_1}{\partial\phi}=\begin{bmatrix}0\\0\\-\frac{1}{l\cos^2\phi}\\0\end{bmatrix}$（4 分）；
$g_4=[g_1,g_3]=-\frac{\partial g_1}{\partial\theta}\left(-\frac{1}{l\cos^2\phi}\right)=\begin{bmatrix}-\frac{\sin\theta}{l\cos^2\phi}\\\frac{\cos\theta}{l\cos^2\phi}\\0\\0\end{bmatrix}$（4 分）。
因为 $g_1$ 与 $g_3$ 并不正交，不能用内积判零检验；应把四列拼成 $4\times 4$ 矩阵计算行列式 $\det([g_1,g_2,g_3,g_4])=\frac{1}{l^2\cos^4\phi}\neq 0$，证明线性无关且满秩 4（4 分）。
:::

## 五、链式系统与动力学扩展（15 分）

**8.（15 分）**
(1) 对独轮车 $(2,3)$-链式模型 $z_1=\theta,\ z_2=x\cos\theta+y\sin\theta,\ z_3=x\sin\theta-y\cos\theta$，及 $\omega=v_1,\ v=v_2+z_3 v_1$，验证 $\dot z_1,\dot z_2,\dot z_3$ 满足链式标准形式，并简述如何控制基变量与纤维变量；
(2) 写出含理想无侧滑约束 $A(q)\dot q=0\ (A\in\mathbb R^{k\times n})$ 的移动机器人完整 Euler-Lagrange 动力学方程。

::: note 参考答案
**8.** (1) $\dot z_1 = \dot\theta = \omega = v_1$（1 分）；
$\dot z_2 = (\dot x\cos\theta+\dot y\sin\theta)+(-x\sin\theta+y\cos\theta)\dot\theta = v - z_3 v_1 = v_2$（3 分）；
$\dot z_3 = (\dot x\sin\theta-\dot y\cos\theta)+(x\cos\theta+y\sin\theta)\dot\theta = 0 + z_2 v_1 = z_2 v_1$（3 分）。
控制策略：先用 $v_1,v_2$ 把基变量 $(z_1,z_2)$ 调到目标值；再用周期 $T$ 的振荡输入使纤维变量 $z_3$ 产生期望净增量且 $(z_1,z_2)$ 周期净变化为零（3 分）。
(2) $M(q)\ddot q+C(q,\dot q)\dot q+g(q)=A^T(q)\lambda+B(q)\tau,\quad A(q)\dot q=0$，其中 $\lambda\in\mathbb R^k$ 为约束反力拉格朗日乘子（5 分）。
:::
