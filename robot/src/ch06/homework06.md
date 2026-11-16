# 作业六：教材习题 7-2 / 7-6 / 7-7（附详细解答与验算）

> 课堂板书在最后 1 分钟留的作业：**7-2、7-6、7-7**（对应原书第 7 章）。
>
> ![课堂幻灯片 · 137:41：作业 7-2、7-6、7-7](../assets/ch06/homework.jpg)
> 三题分别练三件事：**$C$ 的不同选法与反对称性的两种陈述**（7-2）、**换广义坐标后动力学方程怎么变**
> （7-6）、**末端力经雅可比转置折算成关节力矩**（7-7）。

::: note 提交与评分
- **来源**：教材 Problems 7.2 / 7.6 / 7.7；课堂布置于 2026-10-19 第 7 周星期一第 3–5 节末。
- **提交**：智学北航 → 我的课 → 机器人控制技术 → **课程作业**（以平台实际条目与截止时间为准）。
- **评分**：每题按「建模 40% + 推导 40% + 结论/验算 20%」给分；只写答案不写中间步骤，最多 60%。
:::

## 先看这三道题在考什么

| 题 | 给定量 | 要求的量 | 真正考的是一句话 |
|:--|:--|:--|:--|
| **7-2** | 两连杆臂的 $B$、标准 Christoffel 选法的 $C$ | 换一种 $C$，检验两条「反对称」陈述 | **$C\dot q$ 唯一，$C$ 不唯一；能量守恒是物理的，反对称是选法的** |
| **7-6** | 相对角模型 | 换成绝对角后的 $B_A,C_A,g_A$ | **换广义坐标 = 换能量函数的自变量；惯量与广义力都要跟着变** |
| **7-7** | 例 7.2 的数据与轨迹、末端力 $[500,500]^{\rm T}$ N | 各时刻两关节力矩 | **末端力经 $J^{\rm T}$ 折算，且 $J$ 随位形变** |

三题的共同前提是同一个对象：**两连杆平面臂**（[6.3.2](../ch06/sec6-3-2.md)）。所以下面先把这台机器的 $B,C,g$ 摆清楚，三题都从这里出发。

### 三个反复用到的中间量

记 $c_2=\cos\vartheta_2$、$s_2=\sin\vartheta_2$、$h=-m_2a_1\ell_2s_2$。

$$B=\begin{bmatrix}b_{11}&b_{12}\\ b_{12}&b_{22}\end{bmatrix},\qquad
\begin{aligned}
b_{11}&=I_1+m_1\ell_1^2+k_{r_1}^2I_{m_1}+I_2+m_2\left(a_1^2+\ell_2^2+2a_1\ell_2c_2\right)+I_{m_2}+m_{m_2}a_1^2,\\
b_{12}&=I_2+m_2\left(\ell_2^2+a_1\ell_2c_2\right)+k_{r_2}I_{m_2},\\
b_{22}&=I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}.
\end{aligned}$$

$$\frac{\partial b_{11}}{\partial\vartheta_2}=2h,\qquad
\frac{\partial b_{12}}{\partial\vartheta_2}=h,\qquad
\frac{\partial b_{22}}{\partial\vartheta_2}=0,\qquad
\frac{\partial b_{ij}}{\partial\vartheta_1}=0. \tag{7.1}$$

**最后一列为什么是零**：$b_{ij}$ 只通过 $c_2=\cos\vartheta_2$ 依赖位形，与 $\vartheta_1$ 无关（$\vartheta_1$ 是整体转动，不改变两连杆的相对姿态）。

$$g_1=\left(m_1\ell_1+m_{m_2}a_1+m_2a_1\right)gc_1+m_2\ell_2gc_{12},\qquad
g_2=m_2\ell_2gc_{12}. \tag{7.2}$$

（$y$ 轴竖直向上，$\boldsymbol g_0=[0,-g,0]^{\mathrm T}$。）

---

## 习题 7-2：换一种 $C$，看看两条结论谁还成立

::: ex 题目
对 §7.3.2 的两连杆平面臂，证明：**取另一种满足式 (7.43) 的 $C$ 时，式 (7.49)
（$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$）仍然成立，而式 (7.48)
（对任意 $\boldsymbol w$，$\boldsymbol w^{\mathrm T}N\boldsymbol w=0$）不成立**。
:::

### 第 0 步：先把两条「反对称」陈述分清楚

教材里有两个容易混淆的命题，先写清楚它们各自说什么：

$$N=\dot B-2C \text{ 反对称}\quad\Longleftrightarrow\quad
\boldsymbol w^{\mathrm T}N\boldsymbol w=0\ \ \forall\boldsymbol w\in\mathbb R^2 \tag{7.48}$$

$$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0\quad\text{（只对真实速度成立）} \tag{7.49}$$

**区别在量词的宽度**：(7.48) 要求对**任意**向量 $\boldsymbol w$ 都为零，这等价于「$N$ 的对称部分为零」，即 $N$ 反对称；(7.49) 只要求对**当前那个具体的 $\dot{\boldsymbol q}$** 为零。

**为什么 (7.49) 一定成立（与 $C$ 的选法无关）**：它是**能量守恒**的微分形式。动能 $T=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}$，其变化率

$$\frac{\mathrm dT}{\mathrm dt}=\dot{\boldsymbol q}^{\mathrm T}B\ddot{\boldsymbol q}+\frac12\dot{\boldsymbol q}^{\mathrm T}\dot B\dot{\boldsymbol q}.$$

而运动方程给出 $B\ddot{\boldsymbol q}=\boldsymbol\tau-\boldsymbol g-C\dot{\boldsymbol q}$，代回得

$$\frac{\mathrm dT}{\mathrm dt}=\dot{\boldsymbol q}^{\mathrm T}\left(\boldsymbol\tau-\boldsymbol g\right)
+\dot{\boldsymbol q}^{\mathrm T}\left(\frac12\dot B-C\right)\dot{\boldsymbol q}.$$

**无驱动、无重力时**（$\boldsymbol\tau=\boldsymbol g=0$）动能必须守恒，$\mathrm dT/\mathrm dt=0$，于是

$$\dot{\boldsymbol q}^{\mathrm T}\left(\frac12\dot B-C\right)\dot{\boldsymbol q}=0
\ \Longleftrightarrow\
\dot{\boldsymbol q}^{\mathrm T}\left(\dot B-2C\right)\dot{\boldsymbol q}=0.$$

**这就是 (7.49)。注意推导里只用到了「动能守恒」，完全没用到 $C$ 是怎么算出来的**——所以它对**任何**满足运动方程的 $C$ 都成立。

**为什么 (7.48) 只在特定选法下成立**：$\boldsymbol w^{\mathrm T}N\boldsymbol w=0$ 对任意 $\boldsymbol w$ 成立，等价于 $N=N^{\mathrm T}$ 的对称部分是零。这是比 (7.49) 强得多的条件，它要求 $\dot B-2C$ 的**每一个**元素都配对抵消，而不只是沿 $\dot{\boldsymbol q}$ 方向的那个二次型为零。

### 第 1 步：取「直接」的 $C$（不把偏导对称化）

教材式 (7.43) 定义一个 $C$ 的方式是

$$c_{ij}=\sum_{k=1}^{2}h_{ijk}\dot q_k,\qquad
h_{ijk}=\frac{\partial b_{ij}}{\partial q_k}-\frac12\frac{\partial b_{jk}}{\partial q_i}. \tag{7.43}$$

标准（Christoffel）选法要把 $h_{ijk}$ 对后两个指标对称化；**这里不合作，直接用上式**。

由 (7.1) 的非零偏导（$k=2$ 方向），逐项算：

| $i,j,k$ | $\partial b_{ij}/\partial q_k$ | $\frac12\partial b_{jk}/\partial q_i$ | $h_{ijk}$ |
|:--:|:--:|:--:|:--:|
| 1,1,2 | $2h$ | $\frac12\partial b_{12}/\partial q_1=0$ | $2h$ |
| 1,2,2 | $h$ | $\frac12\partial b_{22}/\partial q_1=0$ | $h$ |
| 2,1,1 | $0$ | $\frac12\partial b_{11}/\partial q_2=h$ | $-h$ |
| 2,1,2 | $h$ | $\frac12\partial b_{12}/\partial q_2=\frac h2$ | $\frac h2$ |
| 2,2,1 | $0$ | $\frac12\partial b_{21}/\partial q_2=\frac h2$ | $-\frac h2$ |
| 其余 | $0$ | $0$ | $0$ |

**逐格说明两格容易错的**：

- $(2,1,1)$：$i=2,j=1,k=1$。第一项 $\partial b_{21}/\partial q_1=0$（对 $\vartheta_1$ 无依赖）；第二项 $\frac12\partial b_{11}/\partial q_2=\frac12(2h)=h$。相减得 $-h$。
- $(2,1,2)$：$i=2,j=1,k=2$。第一项 $\partial b_{21}/\partial q_2=h$；第二项 $\frac12\partial b_{12}/\partial q_2=\frac h2$。相减得 $\frac h2$。

由 $c_{ij}=\sum_k h_{ijk}\dot q_k$：

$$c_{11}=h_{111}\dot q_1+h_{112}\dot q_2=2h\dot q_2,$$

$$c_{12}=h_{121}\dot q_1+h_{122}\dot q_2=h\dot q_2,$$

$$c_{21}=h_{211}\dot q_1+h_{212}\dot q_2=-h\dot q_1+\frac h2\dot q_2,$$

$$c_{22}=h_{221}\dot q_1+h_{222}\dot q_2=-\frac h2\dot q_1.$$

于是

$$C_{\text{alt}}=\begin{bmatrix}
2h\dot q_2 & h\dot q_2\\[1mm]
-h\dot q_1+\dfrac h2\dot q_2 & -\dfrac h2\dot q_1
\end{bmatrix}. \tag{7.3}$$

### 第 2 步：验证 $C_{\text{alt}}$ 满足 (7.43)（即它确实是合法的 $C$）

(7.43) 的本质要求是 $C\dot{\boldsymbol q}$ 与标准选法一致。算：

$$C_{\text{alt}}\dot{\boldsymbol q}
=\begin{bmatrix}
2h\dot q_2\cdot\dot q_1+h\dot q_2\cdot\dot q_2\\[1mm]
\left(-h\dot q_1+\dfrac h2\dot q_2\right)\dot q_1-\dfrac h2\dot q_1\dot q_2
\end{bmatrix}
=\begin{bmatrix}
h\left(2\dot q_1\dot q_2+\dot q_2^2\right)\\[1mm]
-h\dot q_1^2
\end{bmatrix}. \tag{7.4}$$

第二行里 $\frac h2\dot q_1\dot q_2$ 与 $-\frac h2\dot q_1\dot q_2$ **精确抵消**——这不是巧合，正是 $h_{ijk}$ 的定义保证的。

而标准选法（[6.3.2.4 Christoffel 符号与 $C$](../ch06/sec6-3-2.md)）给出

$$C_{\text{std}}\dot{\boldsymbol q}=\begin{bmatrix}h\left(2\dot q_1\dot q_2+\dot q_2^2\right)\\ -h\dot q_1^2\end{bmatrix}. \tag{7.5}$$

两者相同 ⇒ **$C_{\text{alt}}$ 与 $C_{\text{std}}$ 描述同一个动力学**。这就是「$C\dot q$ 唯一，$C$ 不唯一」。

**「$C$ 不唯一」到底有多少自由度？** 若 $C_1\dot q=C_2\dot q$，则 $(C_1-C_2)\dot q=0$。取 $D=C_1-C_2$，$D$ 只需满足「零空间包含 $\dot q$」——在二维情形下，$D$ 可以是任何形如 $\boldsymbol d\,\boldsymbol n^{\mathrm T}$ 的矩阵，其中 $\boldsymbol n\perp\dot{\boldsymbol q}$。**所以 $C$ 的不唯一性是一整族，不是只有两个选择**。

### 第 3 步：算 $N=\dot B-2C_{\text{alt}}$

先算 $\dot B$。由 (7.1)，只有 $b_{11},b_{12}$ 依赖 $\vartheta_2$：

$$\dot B=\begin{bmatrix}
\dfrac{\partial b_{11}}{\partial\vartheta_2}\dot q_2 & \dfrac{\partial b_{12}}{\partial\vartheta_2}\dot q_2\\[1mm]
\dfrac{\partial b_{12}}{\partial\vartheta_2}\dot q_2 & 0
\end{bmatrix}
=\begin{bmatrix}2h\dot q_2 & h\dot q_2\\ h\dot q_2 & 0\end{bmatrix}. \tag{7.6}$$

于是

$$N=\dot B-2C_{\text{alt}}
=\begin{bmatrix}
2h\dot q_2 & h\dot q_2\\
h\dot q_2 & 0
\end{bmatrix}
-\begin{bmatrix}
4h\dot q_2 & 2h\dot q_2\\
-2h\dot q_1+h\dot q_2 & -h\dot q_1
\end{bmatrix}$$

逐元素相减：

$$N_{11}=2h\dot q_2-4h\dot q_2=-2h\dot q_2,$$

$$N_{12}=h\dot q_2-2h\dot q_2=-h\dot q_2,$$

$$N_{21}=h\dot q_2-\left(-2h\dot q_1+h\dot q_2\right)=2h\dot q_1,$$

$$N_{22}=0-\left(-h\dot q_1\right)=h\dot q_1.$$

$$N=\begin{bmatrix}
-2h\dot q_2 & -h\dot q_2\\
2h\dot q_1 & h\dot q_1
\end{bmatrix}. \tag{7.7}$$

### 第 4 步：(7.48) 不成立——举一个具体的 $\boldsymbol w$

反对称要求 $N_{12}=-N_{21}$，即

$$-h\dot q_2\overset{?}{=}-2h\dot q_1
\quad\Longleftrightarrow\quad
\dot q_2=2\dot q_1.$$

**一般情况下不成立**（$h\neq0$ 时，只要 $\dot q_2\neq2\dot q_1$ 就破）。更直接的检验：$N_{11}$ 与 $N_{22}$ 必须为零才可能反对称，而 $N_{11}=-2h\dot q_2$。

取 $\boldsymbol w=[1,0]^{\mathrm T}$：

$$\boldsymbol w^{\mathrm T}N\boldsymbol w=N_{11}=-2h\dot q_2
=2m_2a_1\ell_2s_2\dot q_2. \tag{7.8}$$

只要 $s_2\neq0$ 且 $\dot q_2\neq0$，这个数就非零。**所以 (7.48) 不成立。**

**数值例**（取 $\vartheta_2=-0.7$、$\dot q_2=1.1$）：$h=-m_2a_1\ell_2\sin(-0.7)=+32.2$（以例 7.2 的 $m_2=50,a_1=1,\ell_2=0.5$ 计），$N_{11}=-2(32.2)(1.1)=-70.8\neq0$。

### 第 5 步：(7.49) 成立——直接展开

$$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}
=\begin{bmatrix}\dot q_1 & \dot q_2\end{bmatrix}
\begin{bmatrix}-2h\dot q_2 & -h\dot q_2\\ 2h\dot q_1 & h\dot q_1\end{bmatrix}
\begin{bmatrix}\dot q_1\\ \dot q_2\end{bmatrix}.$$

先算 $N\dot{\boldsymbol q}$：

$$N\dot{\boldsymbol q}=\begin{bmatrix}
-2h\dot q_2\dot q_1-h\dot q_2^2\\
2h\dot q_1^2+h\dot q_1\dot q_2
\end{bmatrix}.$$

再左乘 $\dot{\boldsymbol q}^{\mathrm T}$：

$$\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}
=\dot q_1\left(-2h\dot q_1\dot q_2-h\dot q_2^2\right)
+\dot q_2\left(2h\dot q_1^2+h\dot q_1\dot q_2\right)$$

展开四项：

$$=-2h\dot q_1^2\dot q_2-h\dot q_1\dot q_2^2+2h\dot q_1^2\dot q_2+h\dot q_1\dot q_2^2=0. \qquad\blacksquare$$

**四项两两抵消**，与 $\dot q_1,\dot q_2$ 的取值无关——这印证了第 0 步的一般论证：只要 $C$ 合法，(7.49) 自动成立。

### 第 6 步：结论表

| 陈述 | Christoffel 的 $C_{\rm std}$ | 另一种 $C_{\rm alt}$ | 原因 |
|:--|:--|:--|:--|
| $\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$（7.49） | ✅ | ✅ | 能量守恒，对任何合法 $C$ 都成立 |
| $\boldsymbol w^{\mathrm T}N\boldsymbol w=0$ 对任意 $\boldsymbol w$（7.48） | ✅ | ❌ | 只有 Christoffel 选法使 $N$ 真正反对称 |

**一句话**：**式 (7.49) 是物理的，式 (7.48) 是选法的**。

### 验算

`tools/verify_homework06.py` 的 `check_7_2`：取 $\boldsymbol q=(1.2,-0.7)$、$\dot{\boldsymbol q}=(0.8,-1.1)$，

- 断言 $C_{\rm std}\dot q$ 与 $C_{\rm alt}\dot q$ 全等；
- 断言 $\dot q^{\mathrm T}N\dot q=0$（容差 $10^{-9}$）；
- 断言 $N_{12}\neq-N_{21}$ 且 $\boldsymbol w^{\mathrm T}N\boldsymbol w\neq0$（$\boldsymbol w=[1,0]^{\mathrm T}$）；
- 断言标准选法下 $N=-N^{\mathrm T}$。

::: think 7-2 易错点 · 三条 {#hw6-72-pitfalls}

1. **把 (7.49) 当成 $N$ 反对称的证明**。(7.49) 只是一个二次型沿一条特殊方向为零；二次型为零**不推出**矩阵为零（除非对任意方向）。
2. **以为 $C$ 只有两种选法**。任何满足 $C\dot q$ 相同的矩阵都是合法选法，构成一整族。
3. **算 $\dot B$ 时把 $\vartheta_1$ 的偏导也算进去**。$b_{ij}$ 与 $\vartheta_1$ 无关，$\partial b_{ij}/\partial\vartheta_1\equiv0$。

:::

---

## 习题 7-6：换绝对角作广义坐标

::: ex 题目
对图 7.4 的两连杆平面臂，取**相对基座的绝对角** $x_1,x_2$ 为广义坐标，用拉格朗日法求动力学模型，
并与式 (7.82)（相对角 $\vartheta_1,\vartheta_2$ 的模型）比较。
:::

### 第 0 步：这道题在考什么

动力学方程 $B\ddot q+C\dot q+g=\tau$ 的**形式**对任何广义坐标都成立，但 $B,C,g$ 会变。换坐标有三件事必须一起处理：

1. **运动学**：$x$ 与 $\vartheta$ 的关系，以及速度、加速度的变换；
2. **动能**：$B_A=J_A^{-\mathrm T}BJ_A^{-1}$——惯量矩阵按**相似变换**变；
3. **广义力**：$\tau_x=J_A^{-\mathrm T}\tau_\vartheta$——**力矩也要变**（这一步最容易漏）。

漏掉第 3 步，方程左右两边就不是同一个坐标系里的量，物理上不成立。

### 第 1 步：坐标变换与雅可比

取绝对角：

$$x_1=\vartheta_1,\qquad x_2=\vartheta_1+\vartheta_2
\qquad\Longleftrightarrow\qquad
\vartheta_1=x_1,\quad \vartheta_2=x_2-x_1. \tag{7.9}$$

**几何意义**：$x_1$ 是连杆 1 相对基座的角，$x_2$ 是**连杆 2 相对基座**的角（不是相对连杆 1）。

求导：

$$\dot{\boldsymbol x}=\begin{bmatrix}\dot x_1\\ \dot x_2\end{bmatrix}
=\begin{bmatrix}\dot\vartheta_1\\ \dot\vartheta_1+\dot\vartheta_2\end{bmatrix}
=\begin{bmatrix}1&0\\1&1\end{bmatrix}\begin{bmatrix}\dot\vartheta_1\\ \dot\vartheta_2\end{bmatrix}
=J_A\dot{\boldsymbol q},\qquad J_A=\begin{bmatrix}1&0\\1&1\end{bmatrix}. \tag{7.10}$$

$$J_A^{-1}=\begin{bmatrix}1&0\\-1&1\end{bmatrix},\qquad
J_A^{-\mathrm T}=\begin{bmatrix}1&-1\\0&1\end{bmatrix}. \tag{7.11}$$

**验证 $J_A^{-1}$**：$\begin{bmatrix}1&0\\1&1\end{bmatrix}\begin{bmatrix}1&0\\-1&1\end{bmatrix}=\begin{bmatrix}1&0\\0&1\end{bmatrix}$ ✓。

**$\det J_A=1\neq0$**——这保证 $x$ 是一组合法的广义坐标（不会退化）。若某个变换在某些位形退化，那些位形就不能用作广义坐标（与欧拉角的奇点同源）。

### 第 2 步：动能与惯量矩阵的变换

动能是标量，与用什么坐标描述无关：

$$T=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}
=\frac12\left(J_A^{-1}\dot{\boldsymbol x}\right)^{\mathrm T}B\left(J_A^{-1}\dot{\boldsymbol x}\right)
=\frac12\dot{\boldsymbol x}^{\mathrm T}\underbrace{\left(J_A^{-\mathrm T}BJ_A^{-1}\right)}_{B_A}\dot{\boldsymbol x}. \tag{7.12}$$

（用了 $\dot{\boldsymbol q}=J_A^{-1}\dot{\boldsymbol x}$。）于是

$$\boxed{\;B_A=J_A^{-\mathrm T}\,B\,J_A^{-1}\;}\tag{7.13}$$

**为什么是「相似变换」而不是直接代换**：$B_A$ 必须满足 $T=\frac12\dot x^{\mathrm T}B_A\dot x$。任何不满足这一条的 $B_A$ 都会算出错误的动能。用 $J_A$ 夹在两边，正是为了保证这一点。

### 第 3 步：把 $B_A$ 乘出来（逐步）

先算 $BJ_A^{-1}$：

$$BJ_A^{-1}=\begin{bmatrix}b_{11}&b_{12}\\ b_{12}&b_{22}\end{bmatrix}
\begin{bmatrix}1&0\\-1&1\end{bmatrix}
=\begin{bmatrix}b_{11}-b_{12}&b_{12}\\ b_{12}-b_{22}&b_{22}\end{bmatrix}.$$

（第 1 列：$\text{col}_1-\text{col}_2$；第 2 列：原第 2 列。）

再左乘 $J_A^{-\mathrm T}$：

$$B_A=J_A^{-\mathrm T}\left(BJ_A^{-1}\right)
=\begin{bmatrix}1&-1\\0&1\end{bmatrix}
\begin{bmatrix}b_{11}-b_{12}&b_{12}\\ b_{12}-b_{22}&b_{22}\end{bmatrix}.$$

第 1 行 = 第 1 行减第 2 行：

$$\left[(b_{11}-b_{12})-(b_{12}-b_{22}),\quad b_{12}-b_{22}\right]
=\left[b_{11}-2b_{12}+b_{22},\quad b_{12}-b_{22}\right].$$

第 2 行不变：$[b_{12}-b_{22},\ b_{22}]$。所以

$$B_A=\begin{bmatrix}
b_{11}-2b_{12}+b_{22} & b_{12}-b_{22}\\
b_{12}-b_{22} & b_{22}
\end{bmatrix}. \tag{7.14}$$

**这一步的三个元素都要记下来**，因为后面要用：

$$b_{A11}=b_{11}-2b_{12}+b_{22},\qquad
b_{A12}=b_{12}-b_{22},\qquad
b_{A22}=b_{22}. \tag{7.15}$$

### 第 4 步：代入 $B$ 的表达式，看哪些项抵消

**先算 $b_{A11}$**。把 $b_{11},b_{12},b_{22}$ 的定义抄进来：

$$b_{A11}=\bigl[I_1+m_1\ell_1^2+k_{r_1}^2I_{m_1}+I_2+m_2(a_1^2+\ell_2^2+2a_1\ell_2c_2)+I_{m_2}+m_{m_2}a_1^2\bigr]$$

$$-2\bigl[I_2+m_2(\ell_2^2+a_1\ell_2c_2)+k_{r_2}I_{m_2}\bigr]+\bigl[I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}\bigr].$$

**同类项逐个收**：

| 项 | 系数 |
|:--|:--|
| $I_2$ | $1-2+1=0$ ——**抵消** |
| $m_2\ell_2^2$ | $1-2+1=0$ ——**抵消** |
| $m_2a_1\ell_2c_2$ | $2-2=0$ ——**抵消**（这就是「对角元与位形无关」的来源） |
| $I_{m_2}$ | $1-2k_{r_2}+k_{r_2}^2=(1-k_{r_2})^2$ |
| 其余 | $I_1+m_1\ell_1^2+k_{r_1}^2I_{m_1}+m_2a_1^2+m_{m_2}a_1^2$ |

于是

$$b_{A11}=I_1+m_1\ell_1^2+k_{r_1}^2I_{m_1}+m_2a_1^2+(1-k_{r_2})^2I_{m_2}+m_{m_2}a_1^2. \tag{7.16}$$

**这是本题最重要的结论**：$b_{A11}$ 里**没有 $c_2$**——绝对角下，连杆 1 的等效惯量与连杆 2 的姿态无关。

**直观解释**：在相对角坐标里，$b_{11}$ 含 $m_2(a_1^2+\ell_2^2+2a_1\ell_2c_2)$，因为 $\dot\vartheta_1$ 让连杆 2 整体绕关节 1 转，而连杆 2 的质心到关节 1 的距离随 $\vartheta_2$ 变。在绝对角坐标里，$\dot x_1$ 只让**连杆 1** 转，连杆 2 的姿态由 $x_2$ 独立描述——所以连杆 2 的贡献被完整地移到了 $b_{A12}$ 与 $b_{A22}$。

**再算 $b_{A12}$**：

$$b_{A12}=b_{12}-b_{22}=\bigl[I_2+m_2(\ell_2^2+a_1\ell_2c_2)+k_{r_2}I_{m_2}\bigr]-\bigl[I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}\bigr].$$

$I_2$ 与 $m_2\ell_2^2$ 抵消：

$$b_{A12}=m_2a_1\ell_2c_2+\left(k_{r_2}-k_{r_2}^2\right)I_{m_2}
=m_2a_1\ell_2\cos(x_2-x_1)+k_{r_2}(1-k_{r_2})I_{m_2}. \tag{7.17}$$

（用了 $c_2=\cos\vartheta_2=\cos(x_2-x_1)$。）

$$b_{A22}=b_{22}=I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2}. \tag{7.18}$$

**$b_{A22}$ 本来就是常数**，换坐标后仍是常数——因为 $x_2$ 是连杆 2 的绝对角，它的惯量只由连杆 2 自己（与转子 2）决定。

**一个值得注意的细节**：$b_{A12}$ 里的转子项是 $k_{r_2}(1-k_{r_2})I_{m_2}$，而不是原来的 $k_{r_2}I_{m_2}$。若 $k_{r_2}=1$（直驱），这一项**为零**；但 $b_{A22}$ 仍含 $k_{r_2}^2I_{m_2}=I_{m_2}$，不会消失。这说明「换坐标会改变交叉项的构成」，但不会消灭转子惯量。

### 第 5 步：速度项——逐个数 Christoffel 符号

由 (7.14)，$B_A$ 只有 $b_{A12}=b_{A21}$ 依赖位形，且只通过 $u=x_2-x_1$。记

$$b=b_{A12}=m_2a_1\ell_2\cos u+\text{const},\qquad u=x_2-x_1. \tag{7.19}$$

**先算两个偏导**（链式法则，注意 $\partial u/\partial x_1=-1$、$\partial u/\partial x_2=+1$）：

$$\frac{\partial b}{\partial x_1}=\frac{\mathrm db}{\mathrm du}\cdot(-1)=-\left(-m_2a_1\ell_2\sin u\right)=m_2a_1\ell_2\sin u,$$

$$\frac{\partial b}{\partial x_2}=\frac{\mathrm db}{\mathrm du}\cdot(+1)=-m_2a_1\ell_2\sin u.$$

记 $h=-m_2a_1\ell_2\sin u$（与相对角模型的 $h$ 同形，只是 $s_2$ 换成 $\sin(x_2-x_1)$），则

$$\frac{\partial b}{\partial x_1}=-h,\qquad \frac{\partial b}{\partial x_2}=h. \tag{7.20}$$

**这里符号最容易错**：$\partial b/\partial x_1$ 是**负的** $h$，因为 $x_1$ 增大使 $u$ 减小。建议先用 $u$ 求导再乘链式因子，不要凭直觉。

Christoffel 符号的定义：

$$c_{ijk}=\frac12\left(\frac{\partial b_{ij}}{\partial x_k}+\frac{\partial b_{ik}}{\partial x_j}-\frac{\partial b_{jk}}{\partial x_i}\right). \tag{7.21}$$

$b_{A11},b_{A22}$ 是常数，只有涉及 $b$ 的项非零。逐个算（$i,j,k\in\{1,2\}$）：

**$c_{112}$**：$\frac12\left(\partial b_{11}/\partial x_2+\partial b_{12}/\partial x_1-\partial b_{12}/\partial x_1\right)=0$——后两项精确抵消。

**$c_{121}$**：$\frac12\left(\partial b_{12}/\partial x_1+\partial b_{11}/\partial x_2-\partial b_{21}/\partial x_1\right)=\frac12\left(-h+0-(-h)\right)=0$。

**$c_{122}$**：$\frac12\left(\partial b_{12}/\partial x_2+\partial b_{12}/\partial x_2-\partial b_{22}/\partial x_1\right)=\frac12\left(2h-0\right)=h$。

**$c_{211}$**：$\frac12\left(\partial b_{21}/\partial x_1+\partial b_{21}/\partial x_1-\partial b_{11}/\partial x_2\right)=\frac12\left(-2h-0\right)=-h$。

**$c_{212}$**：$\frac12\left(\partial b_{21}/\partial x_2+\partial b_{22}/\partial x_1-\partial b_{12}/\partial x_2\right)=\frac12\left(h+0-h\right)=0$。

**$c_{221}$**：$\frac12\left(\partial b_{22}/\partial x_1+\partial b_{21}/\partial x_2-\partial b_{21}/\partial x_2\right)=0$——后两项抵消。

**$c_{111}=c_{222}=0$**（全为常数的对角元）。

**结论：只有两个非零符号**

$$c_{122}=h,\qquad c_{211}=-h. \tag{7.22}$$

**与相对角模型对比**：那里有四个非零符号（$c_{112}=c_{121}=h$、$c_{122}=h$、$c_{211}=-h$），这里**只剩两个**——因为 $b_{A11}$ 不再依赖位形，凡是含 $\partial b_{11}/\partial x_2$ 的符号全部消失。**惯量矩阵越「平」，Christoffel 符号越少，速度项越简单。**

### 第 6 步：组装 $C_A$ 与 $C_A\dot{\boldsymbol x}$

$$(C_A)_{ij}=\sum_{k=1}^{2}c_{ijk}\dot x_k. \tag{7.23}$$

逐个：

$$c_{11}=c_{111}\dot x_1+c_{112}\dot x_2=0,$$

$$c_{12}=c_{121}\dot x_1+c_{122}\dot x_2=h\dot x_2,$$

$$c_{21}=c_{211}\dot x_1+c_{212}\dot x_2=-h\dot x_1,$$

$$c_{22}=c_{221}\dot x_1+c_{222}\dot x_2=0.$$

$$C_A=\begin{bmatrix}0&h\dot x_2\\ -h\dot x_1&0\end{bmatrix},\qquad
C_A\dot{\boldsymbol x}=\begin{bmatrix}h\dot x_2^2\\ -h\dot x_1^2\end{bmatrix}. \tag{7.24}$$

**关键观察：没有 $\dot x_1\dot x_2$ 的科氏项**。相对角模型里，关节 1 的速度项含 $2h\dot\vartheta_1\dot\vartheta_2$，是「科氏项」；绝对角模型里这一项**消失了**。

**为什么**：科氏项起源于「一个关节的运动改变了另一个关节的力臂」。在绝对角下，连杆 2 的转动是相对基座描述的，$\dot x_1$ 与 $\dot x_2$ 分别对应两个独立的绝对转动，只有「关节 2 轴随连杆 1 平移」这一条耦合路径（体现在 $b_{A12}$ 的 $\cos u$ 与 $h$ 里），所以交叉项自然只剩 $\dot x_2^2$ 与 $\dot x_1^2$ 两个离心项。

**验证反对称性**（顺便检查推导）：$\dot B_A=\begin{bmatrix}0&\dot b\\ \dot b&0\end{bmatrix}$，$\dot b=-h\dot x_1+h\dot x_2=h(\dot x_2-\dot x_1)$，

$$N_A=\dot B_A-2C_A=\begin{bmatrix}0&h(\dot x_2-\dot x_1)-2h\dot x_2\\ h(\dot x_2-\dot x_1)+2h\dot x_1&0\end{bmatrix}
=\begin{bmatrix}0&-h(\dot x_1+\dot x_2)\\ h(\dot x_1+\dot x_2)&0\end{bmatrix},$$

**反对称** ✓。这说明 $C_A$ 是按 Christoffel 规则算的（否则 $N_A$ 不会反对称，参照 7-2）。

### 第 7 步：重力项

势能只与高度有关。各质心高度：

$$y_{c1}=\ell_1\sin x_1,\qquad
y_{c2}=a_1\sin x_1+\ell_2\sin x_2,$$

（连杆 2 的质心高度用**绝对角** $x_2$ 写：$a_1\sin x_1+\ell_2\sin x_2$——因为 $x_2$ 就是连杆 2 与水平的夹角。）转子 2 在关节 2 处，高度 $a_1\sin x_1$；转子 1 在原点。

$$U=\left(m_1\ell_1+m_{m_2}a_1+m_2a_1\right)g\sin x_1+m_2\ell_2g\sin x_2. \tag{7.25}$$

$$g_{A1}=\frac{\partial U}{\partial x_1}=\left(m_1\ell_1+m_{m_2}a_1+m_2a_1\right)g\cos x_1, \tag{7.26}$$

$$g_{A2}=\frac{\partial U}{\partial x_2}=m_2\ell_2g\cos x_2. \tag{7.27}$$

**对比相对角**：$g_1$ 含 $c_1$ **与** $c_{12}$ 两项，$g_2$ 含 $c_{12}$。绝对角下每式**只有一项**，而且 $g_{A1}$ 只认 $x_1$、$g_{A2}$ 只认 $x_2$——**重力项解耦了**。

**为什么**：势能对绝对角求导时，$\sin x_1$ 只出现在连杆 1 与转子项里，$\sin x_2$ 只出现在连杆 2 的质心项里，两者不交叉。

### 第 8 步：广义力也要换——这一步最容易漏

方程左边已经全部换到 $x$ 坐标，右边必须也是。**关节力矩 $\tau_1,\tau_2$ 是相对角的广义力**（$\tau_1$ 作用于 $\vartheta_1$、$\tau_2$ 作用于 $\vartheta_2$），不能直接搬到 $x$ 坐标上。

用虚功（功率）不变求变换。力矩做的虚功：

$$\delta W=\tau_1\delta\vartheta_1+\tau_2\delta\vartheta_2
=\tau_1\delta x_1+\tau_2(\delta x_2-\delta x_1)
=(\tau_1-\tau_2)\delta x_1+\tau_2\delta x_2.$$

所以

$$\boxed{\;\boldsymbol\tau_x=\begin{bmatrix}\tau_1-\tau_2\\ \tau_2\end{bmatrix}=J_A^{-\mathrm T}\boldsymbol\tau\;}\tag{7.28}$$

**两项都要解释**：

- $x_1$ 的广义力是 $\tau_1-\tau_2$：转动连杆 1 时，关节 2 的电机也被带着动，它对 $\vartheta_1$ 做的功是 $-\tau_2\delta x_1$（因为 $\delta\vartheta_2=\delta x_2-\delta x_1$ 里含 $-\delta x_1$）；
- $x_2$ 的广义力只是 $\tau_2$：$x_2$ 是连杆 2 的绝对角，只有关节 2 的电机作用于它（关节 1 的电机作用在连杆 1 与基座之间，不进入 $x_2$）。

**一般规则**：换广义坐标时，广义力按 $\boldsymbol\tau_x=(J_A^{-1})^{\mathrm T}\boldsymbol\tau_q$ 变换——与速度变换是**转置对偶**关系（与第 3 章 $\tau=J^{\mathrm T}F$ 同一条对偶）。

### 第 9 步：完整方程与对比

$$\boxed{\;B_A\ddot{\boldsymbol x}+C_A\dot{\boldsymbol x}+\boldsymbol g_A=J_A^{-\mathrm T}\boldsymbol\tau\;}\tag{7.29}$$

展开：

$$\begin{bmatrix}
b_{A11}&b_{A12}\\ b_{A12}&b_{A22}
\end{bmatrix}
\begin{bmatrix}\ddot x_1\\ \ddot x_2\end{bmatrix}
+\begin{bmatrix}h\dot x_2^2\\ -h\dot x_1^2\end{bmatrix}
+\begin{bmatrix}(m_1\ell_1+m_{m_2}a_1+m_2a_1)gc_1\\ m_2\ell_2gc_2\end{bmatrix}
=\begin{bmatrix}\tau_1-\tau_2\\ \tau_2\end{bmatrix}.$$

其中

$$b_{A11}=I_1+m_1\ell_1^2+k_{r_1}^2I_{m_1}+m_2a_1^2+(1-k_{r_2})^2I_{m_2}+m_{m_2}a_1^2,$$

$$b_{A12}=m_2a_1\ell_2\cos(x_2-x_1)+k_{r_2}(1-k_{r_2})I_{m_2},\qquad
b_{A22}=I_2+m_2\ell_2^2+k_{r_2}^2I_{m_2},$$

$$h=-m_2a_1\ell_2\sin(x_2-x_1).$$

### 第 10 步：逐项对比与物理解释

| 项 | 相对角 $\vartheta$ | 绝对角 $x$ |
|:--|:--|:--|
| $B$ 的对角元 | $b_{11}$ 依赖 $\vartheta_2$，$b_{22}$ 常数 | $b_{A11},b_{A22}$ **都与位形无关** |
| $B$ 的非对角元 | $m_2a_1\ell_2c_2+k_{r_2}I_{m_2}$ | $m_2a_1\ell_2\cos(x_2-x_1)+k_{r_2}(1-k_{r_2})I_{m_2}$ |
| 速度项 | 含 $\dot\vartheta_1\dot\vartheta_2$（科氏）+ $\dot\vartheta_2^2$、$\dot\vartheta_1^2$ | 只有 $\dot x_2^2$、$\dot x_1^2$，**无科氏交叉项** |
| 重力项 | $g_1$ 含 $c_1,c_{12}$；$g_2$ 含 $c_{12}$ | $g_{A1}$ 只含 $c_1$；$g_{A2}$ 只含 $c_2$ |
| 广义力 | $\tau_1,\tau_2$ | $\tau_1-\tau_2,\ \tau_2$ |

**物理解释与工程含义**：

1. **对角元常数 ⇒ 惯量估计简单**。控制器里若要用 $B$，常数的对角元意味着「同一组增益可以在全工作空间用」，不必频繁重算。
2. **无科氏交叉项 ⇒ 速度补偿简单**。相对角模型里要补 $2h\dot\vartheta_1\dot\vartheta_2$，绝对角模型里只剩两个离心项。
3. **重力项解耦 ⇒ 前馈简单**。每个绝对角只受自己的重力项影响。
4. **代价**：广义力变成 $\tau_1-\tau_2$ 与 $\tau_2$ 的混合，输出侧要多做一次线性组合；而且绝对角坐标下的「关节力矩」不再直接是电机力矩（若用绝对角做控制，还要把算出的 $\tau_x$ 反变换回 $\tau$）。

**一句话**：**换坐标不能消灭耦合，只能把耦合从「惯量与速度项」搬到「广义力」那里**。这也是所有「选择更好的广义坐标」问题的共同结构。

### 验算

`tools/verify_homework06.py` 的 `check_7_6`：取 $\vartheta_1=0.4$、$\vartheta_2\in\{-1.2,0,0.9\}$ 三组，断言

$$B_A=J_A^{-\mathrm T}BJ_A^{-1},\qquad
(1,1)=b_{11}+b_{22}-2b_{12},\qquad
(1,2)=b_{12}-b_{22},\qquad
(2,2)=b_{22}.$$

并对 (7.16)(7.17)(7.18) 的闭式与数值 $B_A$ 逐元素比对（容差 $10^{-9}$）。

::: think 7-6 自检 · 四个问题 {#hw6-76-selfcheck}

1. 为什么 $B_A=J_A^{-\mathrm T}BJ_A^{-1}$，而不是 $J_A^{-1}B$ 或 $B J_A^{-1}$？
2. $b_{A11}$ 里的 $c_2$ 为什么能消掉？是哪三项在抵消？
3. 为什么绝对角下没有科氏项？用「力臂」的物理图像解释。
4. 为什么右边的力矩是 $[\tau_1-\tau_2,\tau_2]^{\mathrm T}$，而不是 $[\tau_1,\tau_2]^{\mathrm T}$？

::: sol 核对

1. 因为 $T=\frac12\dot q^{\mathrm T}B\dot q$ 是标量，要写成 $\frac12\dot x^{\mathrm T}B_A\dot x$ 就必须把 $J_A^{-1}$（一个放左边、一个放右边）夹在 $B$ 两侧。只乘一边不构成二次型。
2. 因为 $b_{A11}=b_{11}-2b_{12}+b_{22}$，而 $b_{11}$ 含 $+2m_2a_1\ell_2c_2$、$b_{12}$ 含 $+m_2a_1\ell_2c_2$、$b_{22}$ 不含——$+2-2\times1+0=0$。
3. 科氏项来自「一个关节的运动改变另一个关节的力臂」。绝对角下连杆 2 的姿态由 $x_2$ 独立描述，$\dot x_1$ 只转连杆 1，不改变连杆 2 的姿态，所以没有 $\dot x_1\dot x_2$ 项。
4. 因为 $\delta\vartheta_2=\delta x_2-\delta x_1$，$\tau_2$ 对 $\delta x_1$ 贡献 $-\tau_2$、对 $\delta x_2$ 贡献 $+\tau_2$；而 $\tau_1$ 只对 $\delta x_1$ 贡献。虚功不变给出 $[\tau_1-\tau_2,\tau_2]$。

:::

:::

::: think 7-6 易错点 · 四条 {#hw6-76-pitfalls}

1. **把 $J_A$ 与 $J_A^{-1}$ 乘反**。检查办法：$B_A$ 必须对称，且 $\det B_A=\det B$（相似变换保行列式）。
2. **漏掉广义力变换**。右边仍写 $[\tau_1,\tau_2]$，方程两边就不在同一坐标系里。
3. **$b_{A12}$ 的转子项写成 $k_{r_2}I_{m_2}$**。正确是 $k_{r_2}(1-k_{r_2})I_{m_2}$——差一个 $k_{r_2}^2I_{m_2}$，来源是 $b_{22}$ 里那一项被减掉了。
4. **$\partial b/\partial x_1$ 的符号**。$x_1$ 增大使 $x_2-x_1$ 减小，所以 $\partial b/\partial x_1=-h$，不是 $+h$。

:::

---

## 习题 7-7：末端力折成关节力矩

::: ex 题目
对图 7.4 的两连杆平面臂，用例 7.2 的数据与轨迹，求末端施加 $\boldsymbol f=[500,500]^{\mathrm T}\ \mathrm N$
时两关节所需的力矩。
:::

### 第 1 步：为什么末端力是 $J^{\mathrm T}\boldsymbol f$——从虚功推

**不背结论，推一遍**。设末端产生虚位移 $\delta\boldsymbol p_e$，关节产生虚位移 $\delta\boldsymbol q$，两者由雅可比联系：

$$\delta\boldsymbol p_e=J(\boldsymbol q)\,\delta\boldsymbol q. \tag{7.30}$$

末端对外施加力 $\boldsymbol f$，它做的虚功是 $\boldsymbol f^{\mathrm T}\delta\boldsymbol p_e$。这份功必须由关节力矩提供，即 $\boldsymbol\tau_f^{\mathrm T}\delta\boldsymbol q$。**虚功相等**：

$$\boldsymbol\tau_f^{\mathrm T}\delta\boldsymbol q=\boldsymbol f^{\mathrm T}J\delta\boldsymbol q
=\left(J^{\mathrm T}\boldsymbol f\right)^{\mathrm T}\delta\boldsymbol q.$$

对任意 $\delta\boldsymbol q$ 成立，于是

$$\boxed{\;\boldsymbol\tau_f=J^{\mathrm T}\boldsymbol f\;}\tag{7.31}$$

**三条必须说明的**：

1. **为什么是转置而不是逆**：力变换是速度变换的对偶（功率不变），对偶就是转置。$J$ 是长方阵时 $J^{\mathrm T}$ 照样存在，无需方阵、无需满秩——这是它比 $J^{-1}$ 优越之处。
2. **符号约定**：$\boldsymbol\tau_f$ 是「机器人**对外**施加 $\boldsymbol f$ 时，执行器**额外**需要提供的力矩」。若 $\boldsymbol f$ 是环境**作用在**机器人上的力，符号相反。
3. **坐标系**：$J$ 与 $\boldsymbol f$ 必须在**同一个坐标系**里（本题都在基系）。若力传感器读数在传感器系，要先用第 5 章的 (5.32) 变换过去。

### 第 2 步：写动力学方程，说明 $\boldsymbol\tau_f$ 加在哪一边

完整方程（教材式 7.42）：

$$B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e, \tag{7.32}$$

其中 $\boldsymbol h_e$ 是**末端作用在环境上的力**。移项：

$$\boldsymbol\tau=B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g+J^{\mathrm T}\boldsymbol h_e. \tag{7.33}$$

本题 $\boldsymbol h_e=\boldsymbol f=[500,500]^{\mathrm T}$ N，所以

$$\boldsymbol\tau=\underbrace{B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+\boldsymbol g}_{\text{不施力时所需的力矩 }\boldsymbol\tau_0}+J^{\mathrm T}\boldsymbol f. \tag{7.34}$$

**这个分解就是表格里 $\tau$ 与 $\tau_f$ 两列的关系**：$\tau_f=\tau+J^{\mathrm T}f$。

### 第 3 步：写出 $J$ 与 $J^{\mathrm T}\boldsymbol f$ 的解析式

平面臂的平动雅可比（只取位置，$2\times2$）：

$$J=\begin{bmatrix}
-a_1s_1-a_2s_{12} & -a_2s_{12}\\
a_1c_1+a_2c_{12} & a_2c_{12}
\end{bmatrix}. \tag{7.35}$$

转置并右乘 $\boldsymbol f$：

$$J^{\mathrm T}\boldsymbol f
=\begin{bmatrix}
-a_1s_1-a_2s_{12} & a_1c_1+a_2c_{12}\\
-a_2s_{12} & a_2c_{12}
\end{bmatrix}
\begin{bmatrix}500\\500\end{bmatrix}
=500\begin{bmatrix}
-(a_1s_1+a_2s_{12})+(a_1c_1+a_2c_{12})\\
a_2(c_{12}-s_{12})
\end{bmatrix}. \tag{7.36}$$

**逐项读这个式子**：

- 第一分量 $=500\left[J_{11}+J_{21}\right]$——它是「两列位置雅可比在 $f$ 方向上的投影」。因为 $f_x=f_y=500$ 相等，两个投影相加。
- 第二分量 $=500\cdot a_2(c_{12}-s_{12})$——只与关节 2 的力臂 $a_2$ 和连杆 2 的绝对姿态角有关。

### 第 4 步：$t=0$ 处手算（这道题最该会的一步）

$t=0$ 时 $\dot q=0$，所以 $C\dot q=0$——**速度项自动消失**，只剩惯性项与重力项，可以完整手算。

**位形**：由例 7.2，末端在 $(0.2,0)$、肘下垂，解得

$$q_1=1.4706\ \mathrm{rad},\qquad q_2=-2.9413\ \mathrm{rad}.$$

于是 $q_1+q_2=-1.4707$，三角函数值：

$$s_1=0.9950,\quad c_1=0.1000,\qquad s_{12}=-0.9950,\quad c_{12}=0.1000.$$

（注意 $q_1+q_2\approx-q_1$，所以 $s_{12}\approx-s_1$、$c_{12}\approx c_1$。）

**先算 $J^{\mathrm T}f$**。取 $a_1=a_2=1$：

第一分量：$500\left[-(0.9950-0.9950)+(0.1000+0.1000)\right]=500(0+0.2)=100.0$ N·m。

第二分量：$500\left[1\times(0.1000+0.9950)\right]=500(1.0950)=547.5$ N·m。

$$\boxed{\;J^{\mathrm T}\boldsymbol f\big|_{t=0}\approx\begin{bmatrix}100\\ 547.5\end{bmatrix}\ \mathrm{N\cdot m}\;}$$

**这个结果可以直接心算核对**：$J_{11}=-s_1-s_{12}\approx0$（两连杆一正一负抵消），$J_{21}=c_1+c_{12}\approx0.2$，所以第一分量只由 $J_{21}f_y$ 贡献 $=0.2\times500=100$。

**再算 $\tau_0$**。$t=0$ 时三角形速度曲线处于加速段，$\ddot q_1=\ddot q_2=4\Delta q/T^2=4(\pi/2)/0.25=25.13$ rad/s²。

先算 $B$：$c_2=\cos(-2.9413)=-0.9803$。

$$b_{11}=10+50(0.25)+100^2(0.01)+10+50\left(1+0.25+2\cdot1\cdot0.5\cdot(-0.9803)\right)+0.01+5(1).$$

逐项：$10+12.5+100+10+50(0.2697)+0.01+5=132.5+13.49+5.01=151.0$。

$$b_{12}=10+50\left(0.25+1\cdot0.5\cdot(-0.9803)\right)+100(0.01)=10+50(-0.2402)+1=-1.01.$$

$$b_{22}=10+50(0.25)+100^2(0.01)=122.5.$$

于是 $B\ddot q$：

$$\begin{bmatrix}151.0&-1.01\\-1.01&122.5\end{bmatrix}\begin{bmatrix}25.13\\25.13\end{bmatrix}
=25.13\begin{bmatrix}151.0-1.01\\-1.01+122.5\end{bmatrix}
=25.13\begin{bmatrix}150.0\\121.5\end{bmatrix}
=\begin{bmatrix}3769.9\\3053.4\end{bmatrix}.$$

再算重力项（$c_1=c_{12}=0.1000$）：

$$g_1=(50\cdot0.5+5\cdot1+50\cdot1)(9.81)(0.1000)+50\cdot0.5\cdot9.81\cdot0.1000
=80(9.81)(0.1)+245.25(0.1)$$

$$=78.48+24.53=103.01,$$

$$g_2=245.25\times0.1=24.53.$$

于是

$$\tau_0=\begin{bmatrix}3769.9\\3053.4\end{bmatrix}+\begin{bmatrix}103.0\\24.5\end{bmatrix}
=\begin{bmatrix}3872.9\\3077.9\end{bmatrix}\ \mathrm{N\cdot m},$$

$$\tau_f=\tau_0+J^{\mathrm T}f=\begin{bmatrix}3872.9\\3077.9\end{bmatrix}+\begin{bmatrix}100.0\\547.5\end{bmatrix}
=\begin{bmatrix}3972.9\\3625.4\end{bmatrix}\ \mathrm{N\cdot m}.$$

与表格第一行（$3873.2$、$3078.2$、$3973.2$、$3625.7$）在四舍五入范围内一致。

### 第 5 步：全轨迹的结果表

用上面的 $B,C,g$ 与 $J^{\mathrm T}f$ 逐点计算（$\tau_0$ 为不施力，$\tau_f$ 为施力）：

| $t$ / s | $q_1$ / rad | $q_2$ / rad | $\tau_{0,1}$ | $\tau_{0,2}$ | $\tau_{f,1}$ | $\tau_{f,2}$ |
|--:|--:|--:|--:|--:|--:|--:|
| 0.000 | 1.4706 | −2.9413 | 3873.2 | 3078.2 | 3973.2 | 3625.7 |
| 0.125 | 1.6670 | −2.7449 | 4205.5 | 3110.6 | 4336.9 | 3787.6 |
| 0.250 | 2.2560 | −2.1559 | −2360.7 | −3901.2 | −2616.7 | −3453.7 |
| 0.375 | 2.8451 | −1.5668 | −5564.5 | −3847.9 | −6523.4 | −4182.5 |
| 0.500 | 3.0414 | −1.3705 | −6797.9 | −3818.9 | −7892.9 | −4366.4 |

（单位均为 N·m；$g=9.81$，重力沿 $-y$。）

**两列之差就是 $J^{\mathrm T}f$**：

| $t$ | $J^{\mathrm T}f$ 第一分量 | 第二分量 |
|--:|--:|--:|
| 0.000 | 100.0 | 547.5 |
| 0.125 | 131.4 | 677.1 |
| 0.250 | −256.1 | 447.5 |
| 0.375 | −958.8 | −334.6 |
| 0.500 | −1095.0 | −547.5 |

### 第 6 步：从表里读出的三件事

**（一）同一方向的末端力，折算成的关节力矩会随位形大幅变化、甚至反号。**

$t=0$ 时 $J^{\mathrm T}f\approx[100,548]^{\mathrm T}$，$t=0.5$ 时约 $[-1095,-548]^{\mathrm T}$——第一分量从 $+100$ 变成 $-1095$。原因是 $J$ 依赖位形：两端时刻的臂形完全不同，同一个末端力的力臂方向也就不同。

**结论：不能把末端力当成一个常数偏置加到关节力矩上**，必须每步用当前 $\boldsymbol q$ 重算 $J^{\mathrm T}$。

**（二）$t=0.25$ s 处力矩跳变，是三角形速度曲线的固有特性。**

三角形速度曲线在 $t=T/2$ 处加速度从 $+4\Delta q/T^2$ 跳到 $-4\Delta q/T^2$。由 $\tau_0=B\ddot q+\dots$，$\ddot q$ 反号 ⇒ 惯性力矩整体反号 ⇒ 力矩出现约 $2\times$ 量级的跳变（从 $+4205$ 到 $-2361$）。

**这不是算错**。若实际系统受不了这个跳变，就应改用五次多项式或梯形曲线（本书第 4 章）——**这是「轨迹规划影响力矩需求」的直接证据**。

**（三）重力项的量级远小于惯性项。**

$t=0$ 时 $g=[103,25]^{\mathrm T}$，而 $B\ddot q=[3770,3053]^{\mathrm T}$——差一个量级以上。原因：加速度 $25$ rad/s² 很大（0.5 s 内转 90°），惯性力矩占主导。

**工程含义**：高速轨迹的力矩需求主要由**加速度**决定，减速器与电机的选型要按 $\ddot q_{\max}$ 而不是按重力负载算。

### 验算

`tools/verify_homework06.py` 的 7-7 部分：按 (7.34) 逐时刻计算 $\tau_0$ 与 $\tau_0+J^{\mathrm T}f$，与上表五个时刻逐项比对（容差 $10^{-6}$），全部通过：

```
0.000  +2.2560  -2.1559 ... 7-7 OK：5 个时刻的 τ 与 τ+Jᵀf 全部对上
```

::: think 7-7 自检 · 四个问题 {#hw6-77-selfcheck}

1. 用虚功推出 $\tau_f=J^{\mathrm T}f$，哪一步用到「对任意 $\delta q$ 成立」？
2. $J$ 是 $2\times2$ 时，为什么仍要说「$J^{\mathrm T}$ 比 $J^{-1}$ 普适」？
3. $t=0$ 时 $J_{11}\approx0$ 的几何原因是什么？
4. $t=0.25$ s 的力矩跳变，是数值问题还是物理现象？

::: sol 核对

1. 由 $\left(\tau_f^{\mathrm T}-f^{\mathrm T}J\right)\delta q=0$ 对**任意** $\delta q$ 成立，才能断言括号内为零（否则只能得到「在某个方向上为零」）。
2. 因为平面臂的 $J$ 恰好方阵，但三维机械手的 $J$ 是 $6\times n$（$n\neq6$ 时非方阵），此时 $J^{-1}$ 不存在而 $J^{\mathrm T}$ 仍存在；力变换的正确形式始终是 $J^{\mathrm T}$。
3. $q_1+q_2\approx-q_1$ 使 $s_{12}\approx-s_1$，于是 $J_{11}=-(a_1s_1+a_2s_{12})\approx0$——此时末端只能沿 $x$ 方向由关节 2 驱动。
4. 物理现象。三角形速度曲线在 $t=T/2$ 处加速度反号，惯性力矩随之反号；力矩跳变是轨迹的 $C^1$（加速度不连续）性质导致的。

:::

:::

::: think 7-7 易错点 · 四条 {#hw6-77-pitfalls}

1. **符号搞反**。$J^{\mathrm T}h_e$ 里 $h_e$ 是「末端对环境」的力；若题目说「环境对末端施力」，符号相反。写作业时先把约定写在第一行。
2. **把 $J^{\mathrm T}f$ 当常数**。它随位形变，必须逐时刻重算。
3. **漏掉 $C\dot q$**。$t=0$ 与 $t=0.5$ 时速度为零（三角形曲线的端点速度为零），但中间时刻不为零——只在端点可以省。
4. **忘记 $\tau$ 与 $\tau_f$ 的区别**。表格里两列不是重复，差的就是 $J^{\mathrm T}f$；写作业时要把这个分解写明。

:::

---

## 三题对照

| 题 | 考什么 | 关键公式 | 最容易错的地方 |
|:--|:--|:--|:--|
| 7-2 | $C$ 不唯一；两条反对称陈述的区别 | $C\dot q$ 唯一；(7.49) 恒成立、(7.48) 只对 Christoffel 成立 | 把 $\dot q^{\mathrm T}N\dot q=0$ 当成 $N$ 反对称 |
| 7-6 | 换广义坐标 | $B_A=J_A^{-\mathrm T}BJ_A^{-1}$、$\tau_x=J_A^{-\mathrm T}\tau$ | 把 $J_A$ 与 $J_A^{-1}$ 乘反；漏掉广义力变换 |
| 7-7 | 末端力经 $J^{\mathrm T}$ 折算 | $\tau=\tau_0+J^{\mathrm T}f$ | 符号；忘记 $J$ 随位形变 |

**三题的共同结构**：都在处理「同一个物理量换一种描述」——

- 7-2 换的是**速度项的分解方式**（$C$ 的选法），物理（能量）不变；
- 7-6 换的是**广义坐标**（$\vartheta\to x$），动能与广义力都要跟着变；
- 7-7 换的是**力的参考空间**（末端力 → 关节力矩），靠转置对偶。

**一条共同的检查方法**：算完之后验一个**不变量**。7-2 验 $\dot q^{\mathrm T}N\dot q=0$；7-6 验 $\det B_A=\det B$ 与 $N_A$ 反对称；7-7 验功率 $\dot q^{\mathrm T}\tau_f=\dot p_e^{\mathrm T}f$。不变量对上了，说明变换没写错。

::: think 交卷前自查 {#hw6-final-check}

1. 7-2 是否**同时**给出了「式 (7.49) 成立」与「式 (7.48) 不成立」两个结论，并各给了理由（前者用能量守恒、后者举出具体的 $\boldsymbol w$）？
2. 7-6 是否把 $B_A$ 的三个元素都推导出来（含抵消过程），并指出「无科氏项」与「广义力变换」？
3. 7-7 是否写清了 $\boldsymbol f$ 的方向约定、给出了 $t=0$ 的手算过程，并解释符号变化与力矩跳变？
4. 三题的公式是否与 [6.2.1](../ch06/sec6-2-1.md)、[6.3.2](../ch06/sec6-3-2.md) 的记号一致？

:::
