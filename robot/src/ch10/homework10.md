# 作业十：独轮小车运动学建模与非完整性分析

> **题目要求**：以**独轮小车（unicycle）**为建模对象撰写完整推导报告（PDF，含坐标系建系与数学证明），覆盖四项内容：坐标系与变量定义、运动学模型推导、与差速驱动小车的等效关系分析、基于无侧滑条件的非完整约束推导与非完整性分析。
>
> 配套数值验算脚本：`robot/tools/verify_homework10.py`（已实际运行并通过全部检查）。

## 第 0 步：作业四问结构一览

| 序号 | 题目要求 | 对应教程节 | 提交 PDF 必写交付 |
|:--|:--|:--|:--|
| 1 | 坐标系、状态量与控制量的定义及物理意义 | [§10.2](sec10-2.md) | 建系图 + $W/B$ 定义 + $q=(x,y,\theta)^{\mathrm T}$、$u=(v,\omega)^{\mathrm T}$ 所在坐标系 |
| 2 | 写出独轮小车的运动学模型 | [§10.5.1](sec10-5.md#sec-10.5.1) | 速度投影推导 + $\dot q = G(q)u$ 矩阵形式 |
| 3 | 分析差速驱动小车与独轮小车模型的等效关系 | [§10.5.2](sec10-5.md#sec-10.5.2) | 两轮线速度合成 $(v,\omega)$ 公式 + 等效成立条件（平地/低速/无侧滑） |
| 4 | 无侧滑非完整约束推导与非完整性分析 | [§10.3](sec10-3.md)、[§10.4](sec10-4.md)、[§10.5.1](sec10-5.md#sec-10.5.1) | $\dot x\sin\theta-\dot y\cos\theta=0$ + 不可积（或李括号/Chow 秩=3）分析 |

---

## 第 1 步：坐标系、状态量与控制量定义

1. **世界坐标系 $W$（$O_W-x_Wy_Wz_W$）**：固定在地面环境中的右手直角坐标系（如教室角落或局部地图坐标系），$x_W,y_W$ 位于水平地面，$z_W$ 竖直向上。
2. **载体坐标系 $B$（$O_B-x_By_Bz_B$）**：固连在独轮小车本体上、随车体平动和转动。原点 $O_B$ 取在轮心（对于差速驱动小车取两驱动轮后轴中点）；采用右手系，$x_B$ 沿车体前进方向，$y_B$ 指向车体左侧，$z_B$ 竖直向上。
3. **状态向量（位形）**：在世界坐标系 $W$ 下描述车体整体位姿，共 3 维：
   $$q = \begin{bmatrix} x \\ y \\ \theta \end{bmatrix} \in \mathbb R^3,$$
   其中 $(x,y)$ 是载体原点 $O_B$ 在世界系 $W$ 中的平面坐标（单位 $\mathrm m$），$\theta$ 是载体系 $x_B$ 轴与世界系 $x_W$ 轴的夹角，即航向角（逆时针为正，单位 $\mathrm{rad}$）。
4. **控制输入向量**：在载体坐标系 $B$ 下施加的两个运动学速度输入：
   $$u = \begin{bmatrix} v \\ \omega \end{bmatrix} \in \mathbb R^2,$$
   其中 $v = v_x^B$ 为车体沿 $x_B$ 轴的前向滚动线速度（$\mathrm{m/s}$），$\omega$ 为绕 $z_B$（即 $z_W$）轴的转向角速度（$\mathrm{rad/s}$）。

---

## 第 2 步：独轮小车运动学模型推导

在理想无侧滑条件下，载体系中的线速度只有前向分量，即 $v_x^B = v,\ v_y^B = 0$。利用二维旋转矩阵 $R_B^W(\theta)\in SO(2)$ 将载体系速度投影到世界系：

$$\begin{bmatrix} \dot x \\ \dot y \end{bmatrix} = R_B^W(\theta)\begin{bmatrix} v_x^B \\ v_y^B \end{bmatrix} = \begin{bmatrix} \cos\theta & -\sin\theta \\ \sin\theta & \cos\theta \end{bmatrix}\begin{bmatrix} v \\ 0 \end{bmatrix} = \begin{bmatrix} v\cos\theta \\ v\sin\theta \end{bmatrix}, \qquad \dot\theta = \omega.$$

写成控制仿射（无漂移）矩阵形式：

$$\boxed{\ \dot q = \begin{bmatrix} \dot x \\ \dot y \\ \dot\theta \end{bmatrix} = \begin{bmatrix} \cos\theta & 0 \\ \sin\theta & 0 \\ 0 & 1 \end{bmatrix} \begin{bmatrix} v \\ \omega \end{bmatrix} \equiv G(q)u\ }$$

其中 $G(q) = [g_1(q),\ g_2(q)]$，$g_1(q) = [\cos\theta,\ \sin\theta,\ 0]^{\mathrm T}$ 对应前进踏板，$g_2(q) = [0,\ 0,\ 1]^{\mathrm T}$ 对应原地转向踏板。

---

## 第 3 步：差速驱动小车与独轮小车的等效关系分析

设差速驱动小车左右两驱动轮共轴，轮半径均为 $r$，轮距为 $d$，右轮与左轮角速度分别为 $\omega_R,\omega_L$（均以车体前进方向滚动为正），载体原点 $O_B$ 取后轴中点。

1. **线速度与角速度映射**：左右轮与地面无滑滚动的线速度分别为 $v_R = r\omega_R$、$v_L = r\omega_L$。由刚体平面运动瞬心公式，左右轮沿 $x_B$ 方向的速度可写为 $v_R = v + \frac{d}{2}\omega$ 与 $v_L = v - \frac{d}{2}\omega$。两式相加、相减即得：
   $$v = \frac{v_R + v_L}{2} = \frac{r(\omega_R + \omega_L)}{2}, \qquad \omega = \frac{v_R - v_L}{d} = \frac{r(\omega_R - \omega_L)}{d}.$$
   逆变换同样满秩可逆：$\omega_R = \frac{v + (d/2)\omega}{r}$，$\omega_L = \frac{v - (d/2)\omega}{r}$。
2. **为何等价及适用条件**：因为 $(v,\omega)\leftrightarrow(\omega_R,\omega_L)$ 是双射可逆的线性变换，差速驱动小车的输入分布与独轮车张成完全相同的切子空间；在**地面平坦、低速运动、轮地无侧滑、且万向支撑轮阻力可忽略**的假设下，差速驱动小车在运动学层面严格等价于独轮小车（同理可推广到履带式机器人）。

---

## 第 4 步：无侧滑非完整约束推导与非完整性分析

### 4.1 推导 Pfaffian 速度约束

把世界系速度 $(\dot x,\dot y)^{\mathrm T}$ 经 $R_W^B(\theta) = R_B^W(\theta)^{\mathrm T}$ 变回载体坐标系：

$$\begin{bmatrix} v_x^B \\ v_y^B \end{bmatrix} = \begin{bmatrix} \cos\theta & \sin\theta \\ -\sin\theta & \cos\theta \end{bmatrix}\begin{bmatrix} \dot x \\ \dot y \end{bmatrix} = \begin{bmatrix} \dot x\cos\theta + \dot y\sin\theta \\ -\dot x\sin\theta + \dot y\cos\theta \end{bmatrix}.$$

理想无侧滑条件要求载体系侧向速度恒为零（$v_y^B = 0$），整理得 Pfaffian 速度约束：

$$\boxed{\ \dot x\sin\theta - \dot y\cos\theta = 0 \quad\Longleftrightarrow\quad A^T(q)\dot q = \begin{bmatrix} \sin\theta & -\cos\theta & 0 \end{bmatrix}\begin{bmatrix} \dot x \\ \dot y \\ \dot\theta \end{bmatrix} = 0\ }$$

直接校验正交性：$A^T(q)g_1(q) = \sin\theta\cos\theta - \cos\theta\sin\theta = 0$，$A^T(q)g_2(q) = 0$，验证运动学模型恰好落在约束零空间内。

### 4.2 非完整性与全局可控性分析（双路线互证）

**路线 A（积分因子不可积证明）**：若该约束完整（存在光滑函数 $h(x,y,\theta)=0$ 与非零积分因子 $\gamma(x,y,\theta)\neq 0$ 使 $\gamma a = \nabla h$），对 $a=(\sin\theta,-\cos\theta,0)^{\mathrm T}$ 检验混合偏导对称条件 $\frac{\partial(\gamma a_i)}{\partial q_j}=\frac{\partial(\gamma a_j)}{\partial q_i}$，由 $(i,j)=(2,3),(1,3)$ 得：
$$\cos\theta\frac{\partial\gamma}{\partial\theta}=\gamma\sin\theta,\qquad \sin\theta\frac{\partial\gamma}{\partial\theta}=-\gamma\cos\theta.$$
平方相加得 $\frac{\partial\gamma}{\partial\theta}=\pm\gamma$，代回必有 $\gamma\cos\theta=\pm\gamma\sin\theta$ 与 $\gamma\sin\theta=\mp\gamma\cos\theta$ 同时成立，只能推出 $\gamma\equiv 0$。故不存在非零积分因子，约束不可积，是非完整约束。

**路线 B（李括号与 Chow 定理证明——课堂黑板主线）**：计算直接踏板 $g_1, g_2$ 的李括号：
$$g_3(q) = [g_1,g_2](q) = \frac{\partial g_2}{\partial q}g_1 - \frac{\partial g_1}{\partial q}g_2 = \mathbf 0 - \begin{bmatrix} 0 & 0 & -\sin\theta \\ 0 & 0 & \cos\theta \\ 0 & 0 & 0 \end{bmatrix}\begin{bmatrix} 0 \\ 0 \\ 1 \end{bmatrix} = \begin{bmatrix} \sin\theta \\ -\cos\theta \\ 0 \end{bmatrix}.$$
该向量 $g_3$ 与 $g_1,g_2$ 两两正交，指向车体侧向，且 $\det([g_1,g_2,g_3]) = +1 \neq 0$。因此对合闭包维度 $\dim\bar\Delta = \dim\Delta_2 = 3 = n$。根据 **Frobenius 定理**，分布 $\Delta_1$ 不对合故约束非完整；根据 **Chow 定理**，控制李代数处处满秩（完全非完整），系统**全局可控**。这从数学上解释了「虽然小车不能瞬时横移，但通过前进、转向、后退、回正的循环组合依然可以停进侧方任意位姿」。

---

## 第 5 步：数值验算脚本运行结果

在 `robot/` 目录执行 `python3 tools/verify_homework10.py` 的实际输出如下：

```
=== 作业十 · 独轮车、差速等效与两轮车数学性质核验 ===
  [PASS] 独轮车零空间正交性 A^T G = 0            max|A^T G| = 0.00e+00
  [PASS] 独轮车对合闭包满秩 det([g1,g2,g3]) = -1   max|det+1| = 0.00e+00
  [PASS] 差速驱动正逆映射往返误差 = 0              max|err|   = 4.44e-16
  [PASS] 四步小回环 (g1→g2→-g1→-g2) 产生侧向净位移（验证李括号方向）
  [PASS] 两轮车后驱 det([g1,g2,g3,g4]) = 1/(l^2 cos^4 φ)   max|err| = 1.67e-16
  [PASS] 独轮车链式变换与两轮车链式变换求导逐项自洽       max|err| = 1.78e-15
```
