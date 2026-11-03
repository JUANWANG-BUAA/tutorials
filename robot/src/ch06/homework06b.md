# 作业六·补（第 8 周）：教材习题 7-8 / 7-10（附详细解答与验算）

> 第 8 周（2026-10-26）课件末页布置的是**教材习题 7-8、7-10**，一周内提交（手写）。
> 这两题仍属原书第 7 章（本书第六章）动力学：7-8 练**递推牛顿–欧拉**，7-10 练**操作空间模型的
> 反对称性**。因此并入本章作业详解，编号「作业六·补」；[作业六](homework06.md)（第 7 周）已解
> 7-2 / 7-6 / 7-7，两套合起来覆盖原书第 7 章的全部考点。

::: note 提交与评分
- **来源**：教材 Problems 7.8 / 7.10；布置于 2026-10-26 第 8 周星期一第 3–5 节末（课件末页写「7-8、7-10」）。
- **提交**：智学北航 → 我的课 → 机器人控制技术 → 课程作业（以平台实际条目与截止时间为准）；本周要求**手写**。
- **评分**（与作业六同口径）：每题「建模 40% + 推导 40% + 结论/验算 20%」；
  **只写答案不写中间步骤，最多 60%**——所以下面每一步都写清楚「用哪条递推式、为什么这一步是这样」。
:::

## 先看这两道题在考什么

| 题 | 给定量 | 要求的量 | 真正考的是一句话 |
|:--|:--|:--|:--|
| **7-8** | 移动–转动平面臂（图 7.16，PR 臂）的几何与惯性参数 | 用**递推牛顿–欧拉**算法建立动力学模型 | 当前连杆坐标系下两遍递推：**移动副取 $\boldsymbol f$ 沿关节方向、转动副取 $\boldsymbol\mu$ 沿关节轴**，转子惯量以 $k_r^2I_m$ 折算 |
| **7-10** | 操作空间模型 (7.133) 与关节空间性质 (7.48) | 证明 $\dot B_A-2C_A$ 反对称 | $C_A$ 由 (7.131) 只定出**乘积**，必须取 (7.138) 的加权右伪逆；再用 $B_AJ_AB^{-1}=\bar J_A^{\mathrm T}$ 把关节空间性质「合同」过去 |

两题的共同背景是同一台机器：7-8 就是 7.5（拉格朗日版）的**第二解法**；7-10 则是
[6.7 操作空间动力学模型](sec6-7.md)的**性质组**，与 [6.2.1](sec6-2-1.md) 的 $\dot B-2C$ 反对称一一对应。

## 约定与符号（7-8）

<figure>
<svg class="figure-svg" viewBox="0 0 760 340" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-hw8-pr-title fig-hw8-pr-desc">
<title id="fig-hw8-pr-title">移动–转动平面臂（PR 臂）与连杆坐标系</title>
<desc id="fig-hw8-pr-desc">水平导轨上的小车构成移动副 d1，其上的转动副转角 ϑ2 自竖直向下量起；x0 竖直向上、z0 沿导轨、y0 垂直纸面向外，坐标系 1 原点在关节 2，坐标系 2 原点在连杆末端。</desc>
<defs>
<marker id="arr-hw8-a" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--accent)"/></marker>
<marker id="arr-hw8-s" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--sage)"/></marker>
<marker id="arr-hw8-m" markerWidth="9" markerHeight="9" refX="7" refY="3" orient="auto"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"/></marker>
</defs>
<!-- 导轨 -->
<path d="M40 210H690" stroke="var(--ink-2)" stroke-width="2.5" fill="none"/>
<path d="M46 210l-10 16M66 210l-10 16M86 210l-10 16M106 210l-10 16M126 210l-10 16M146 210l-10 16M166 210l-10 16M186 210l-10 16M206 210l-10 16M226 210l-10 16M246 210l-10 16M266 210l-10 16M286 210l-10 16" stroke="var(--ink-2)" stroke-width="1.6" fill="none"/>
<!-- 基座坐标系 -->
<path d="M85 210v-62" stroke="var(--accent)" stroke-width="2.5" fill="none" marker-end="url(#arr-hw8-a)"/>
<path d="M85 210h78" stroke="var(--accent)" stroke-width="2.5" fill="none" marker-end="url(#arr-hw8-a)"/>
<circle cx="85" cy="210" r="3" fill="var(--ink)"/>
<text class="diagram-mono" x="78" y="142">x₀</text>
<text class="diagram-mono" x="150" y="196">z₀</text>
<text class="diagram-note" x="103" y="190">⊙ y₀</text>
<!-- d1 -->
<path d="M85 258h275" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr-hw8-m)"/>
<path d="M360 210v48" stroke="var(--muted)" stroke-width="1" stroke-dasharray="4 4" fill="none"/>
<text class="diagram-mono" x="205" y="278">d₁</text>
<!-- 小车与关节 2 -->
<rect class="diagram-node" x="334" y="197" width="38" height="16" rx="3"/>
<circle class="diagram-node" cx="353" cy="210" r="10"/>
<circle cx="353" cy="210" r="2.5" fill="var(--ink)"/>
<!-- 坐标系 1 -->
<path d="M353 210v40" stroke="var(--sage)" stroke-width="2.2" fill="none" marker-end="url(#arr-hw8-s)"/>
<path d="M353 207h64" stroke="var(--sage)" stroke-width="2.2" fill="none" marker-end="url(#arr-hw8-s)"/>
<text class="diagram-mono" x="330" y="266">x₁</text>
<text class="diagram-mono" x="418" y="201">y₁</text>
<text class="diagram-note" x="305" y="240">⊙ z₁</text>
<!-- 连杆 2：方向 (0.906, -0.423) -->
<path d="M353 210L512 136" stroke="var(--ink-2)" stroke-width="3" fill="none"/>
<circle cx="512" cy="136" r="3.5" fill="var(--ink)"/>
<circle cx="468" cy="156" r="3.5" fill="var(--ink)"/>
<text class="diagram-note" x="420" y="146">m₂, ℓ₂</text>
<text class="diagram-mono" x="452" y="196">a₂</text>
<text class="diagram-note" x="546" y="176">末端</text>
<!-- 转角 ϑ2：竖直向下参考线与圆弧 -->
<path d="M353 210v90" stroke="var(--muted)" stroke-width="1.2" stroke-dasharray="5 5" fill="none"/>
<path d="M353 276A66 66 0 0 1 413 182" stroke="var(--muted)" stroke-width="1.5" fill="none" marker-end="url(#arr-hw8-m)"/>
<text class="diagram-mono" x="368" y="250">ϑ₂</text>
<!-- 坐标系 2（原点在末端） -->
<path d="M512 136l42 -19" stroke="var(--sage)" stroke-width="2.2" fill="none" marker-end="url(#arr-hw8-s)"/>
<path d="M512 136l-19 -42" stroke="var(--sage)" stroke-width="2.2" fill="none" marker-end="url(#arr-hw8-s)"/>
<text class="diagram-mono" x="556" y="114">x₂</text>
<text class="diagram-mono" x="482" y="88">y₂</text>
<text class="diagram-note" x="502" y="196">⊙ z₂</text>
<!-- 重力 -->
<path d="M62 120v50" stroke="var(--ink-2)" stroke-width="3" fill="none" marker-end="url(#arr-hw8-m)"/>
<text class="diagram-mono" x="44" y="190">g</text>
<!-- 连杆 1 标注 -->
<text class="diagram-note" x="168" y="246">连杆 1（滑杆，m₁）</text>
</svg>
<figcaption>移动–转动平面臂（PR 臂）与连杆坐标系（本教程绘）。$x_0$ 竖直向上、$z_0$ 沿导轨、$y_0$ 垂直纸面向外；
坐标系 1 的原点在关节 2；坐标系 2 的原点在沿连杆距离 $a_2$ 处（末端），$x_2$ 沿连杆；
$\vartheta_2$ 自竖直向下的参考线量起，$\vartheta_2=0$ 时连杆下垂。</figcaption>
</figure>

**看图先说清三件事**：

1. **运动平面是 $x_0$–$z_0$ 平面**。取 $x_0$ 竖直向上、$z_0$ 沿水平导轨、$y_0$ 垂直纸面向外，
   于是重力加速度向量 $\boldsymbol g^0=[-g,0,0]^{\mathrm T}$，初始条件为
   $\ddot{\boldsymbol p}^0_0-\boldsymbol g^0_0=[g,0,0]^{\mathrm T}$、$\boldsymbol\omega^0_0=\dot{\boldsymbol\omega}^0_0=\boldsymbol 0$。
   （这套「反常规」的取向不是随便定的：取教材官方解答图 S7.2 的取法，才能和教材、习题解答逐项比对。）
2. **关节 1 是移动副、关节 2 是转动副**：小车沿导轨平移 $d_1$，连杆 2 绕关节 2 转 $\vartheta_2$，
   $\vartheta_2$ 自**竖直向下**的参考线量起（$\vartheta_2=0$ 表示连杆下垂）。
3. **坐标系 2 的原点在连杆末端**（沿连杆走 $a_2$ 处），因此连杆 2 质心在坐标系 2 中的横坐标是
   $\ell_{C2}=\ell_2-a_2<0$。记 $\ell_2\equiv\ell_{C2}+a_2$ 为**关节 2 到质心的有向距离**，
   后面所有公式都用 $\ell_2$ 记账。

| 符号 | 含义 | 符号 | 含义 |
|:--|:--|:--|:--|
| $d_1$ | 关节 1 位移（沿 $z_0=y_1$，导轨方向） | $\vartheta_2$ | 关节 2 转角 |
| $m_1$ | 连杆 1 总质量（滑杆 + 安装其上的电机 2） | $m_2$ | 连杆 2 质量 |
| $\ell_2$ | 关节 2 $\to$ 连杆 2 质心的有向距离 | $a_2$ | 关节 2 $\to$ 末端距离 |
| $\bar I_{2zz}$ | 连杆 2 绕质心、垂直平面的惯量 | $k_{r_i},I_{m_i}$ | 减速比、转子惯量 |
| $g$ | 重力加速度（沿 $-x_0$） | | |

矢量与旋转矩阵（教材 (7.107)–(7.114) 的记号，均写在**当前连杆坐标系**中）：

$$\boldsymbol r^1_{0,1}=\begin{bmatrix}0\\ d_1\\ 0\end{bmatrix},\quad
\boldsymbol r^1_{1,C_1}=\begin{bmatrix}0\\ \ell_{C1}\\ 0\end{bmatrix},\quad
\boldsymbol r^2_{1,2}=\begin{bmatrix}a_2\\ 0\\ 0\end{bmatrix},\quad
\boldsymbol r^2_{2,C_2}=\begin{bmatrix}\ell_{C2}\\ 0\\ 0\end{bmatrix},$$

$$\boldsymbol R^0_1=\begin{bmatrix}-1&0&0\\ 0&0&1\\ 0&1&0\end{bmatrix}=\big(\boldsymbol R^0_1\big)^{\mathrm T},\qquad
\boldsymbol R^1_2=\boldsymbol R_z(\vartheta_2),\qquad z^{i-1}_{m_i}=z_0=[0,0,1]^{\mathrm T}\ (i=1,2).$$

> **为什么 $\boldsymbol r^1_{0,1}$ 的位移写在 $y$ 分量上**：$\boldsymbol R^0_1$ 的三列就是坐标系 1 的三个轴在坐标系 0
> 中的方向，即 $x_1=-x_0$、$y_1=z_0$、$z_1=y_0$。导轨沿 $z_0$，故在小车自己的坐标系 1 里，平移方向是 $y_1$。

## 习题 7-8：两遍递推、四步到位

### 第 0 步：把「两遍递推」的框架摆出来

教材 (7.107)–(7.114) 分两遍：

- **前向**（$i=1,\dots,n$）：由初值算 $\boldsymbol\omega^i_i,\dot{\boldsymbol\omega}^i_i,\ddot{\boldsymbol p}^i_i,
  \ddot{\boldsymbol p}^i_{C_i}$（(7.107)–(7.110)）与转子的 $\dot{\boldsymbol\omega}^{i-1}_{m_i}$（(7.111)）；
- **后向**（$i=n,\dots,1$）：由末端力算 $\boldsymbol f^i_i,\boldsymbol\mu^i_i$（(7.112)(7.113)），
  再由 (7.114) 取关节广义力：**移动副取 $\boldsymbol f$ 沿关节轴的分量**，**转动副取 $\boldsymbol\mu$ 沿关节轴的分量**，
  两处再加转子项 $k_{r_i}I_{m_i}\dot{\boldsymbol\omega}^{\mathrm T}_{m_i}z_{m_i}$。

本题 $n=2$、末端无外力（$\boldsymbol f^3_3=\boldsymbol\mu^3_3=\boldsymbol 0$）、不计摩擦。

### 第 1 步：前向递推（速度与加速度）

**连杆 1（移动副，关节变量 $d_1$）**：移动副不转动，

$$\boldsymbol\omega^1_1=\boldsymbol 0,\qquad \dot{\boldsymbol\omega}^1_1=\boldsymbol 0,$$

$$\begin{aligned}
\ddot{\boldsymbol p}^1_1&=\boldsymbol R^{0\mathrm T}_1\big(\ddot{\boldsymbol p}^0_0+\ddot d_1z_0\big)
+2\dot d_1\,\boldsymbol\omega^1_1\times(\boldsymbol R^{0\mathrm T}_1z_0)\\
&\quad+\dot{\boldsymbol\omega}^1_1\times\boldsymbol r^1_{0,1}
+\boldsymbol\omega^1_1\times(\boldsymbol\omega^1_1\times\boldsymbol r^1_{0,1})
=\boldsymbol R^0_1\begin{bmatrix}g\\0\\ \ddot d_1\end{bmatrix}
=\begin{bmatrix}-g\\ \ddot d_1\\0\end{bmatrix},
\end{aligned}$$

$$\ddot{\boldsymbol p}^1_{C_1}=\ddot{\boldsymbol p}^1_1
+\dot{\boldsymbol\omega}^1_1\times\boldsymbol r^1_{1,C_1}
+\boldsymbol\omega^1_1\times(\boldsymbol\omega^1_1\times\boldsymbol r^1_{1,C_1})
=\begin{bmatrix}-g\\ \ddot d_1\\0\end{bmatrix},\qquad
\dot{\boldsymbol\omega}^0_{m_1}=k_{r1}\ddot d_1z_{m_1}=\begin{bmatrix}0\\0\\k_{r1}\ddot d_1\end{bmatrix}.$$

$\boldsymbol\omega_1=\boldsymbol 0$ 使科氏项 $2\dot d_1\boldsymbol\omega\times(\cdot)$ 与向心项全部为零——
这就是「移动副首关节」在递推里的最大简化。

**连杆 2（转动副，关节变量 $\vartheta_2$）**：

$$\boldsymbol\omega^2_2=\boldsymbol R^{1\mathrm T}_2\big(\boldsymbol\omega^1_1+\dot\vartheta_2z_0\big)
=\begin{bmatrix}0\\0\\\dot\vartheta_2\end{bmatrix},\qquad
\dot{\boldsymbol\omega}^2_2=\boldsymbol R^{1\mathrm T}_2\big(\dot{\boldsymbol\omega}^1_1+\ddot\vartheta_2z_0
+\dot\vartheta_2\,\boldsymbol\omega^1_1\times z_0\big)=\begin{bmatrix}0\\0\\\ddot\vartheta_2\end{bmatrix},$$

$$\ddot{\boldsymbol p}^2_2=\boldsymbol R^{1\mathrm T}_2\ddot{\boldsymbol p}^1_1
+\dot{\boldsymbol\omega}^2_2\times\boldsymbol r^2_{1,2}
+\boldsymbol\omega^2_2\times(\boldsymbol\omega^2_2\times\boldsymbol r^2_{1,2})
=\begin{bmatrix}s_2\ddot d_1-a_2\dot\vartheta_2^2-gc_2\\ c_2\ddot d_1+a_2\ddot\vartheta_2+gs_2\\0\end{bmatrix},$$

$$\ddot{\boldsymbol p}^2_{C_2}=\ddot{\boldsymbol p}^2_2
+\dot{\boldsymbol\omega}^2_2\times\boldsymbol r^2_{2,C_2}
+\boldsymbol\omega^2_2\times(\boldsymbol\omega^2_2\times\boldsymbol r^2_{2,C_2})
=\begin{bmatrix}s_2\ddot d_1-\ell_2\dot\vartheta_2^2-gc_2\\ c_2\ddot d_1+\ell_2\ddot\vartheta_2+gs_2\\0\end{bmatrix}.$$

**转子的角加速度**（(7.111)，注意换系：转子 1 的量要先从坐标系 0 转到坐标系 1）：

$$\dot{\boldsymbol\omega}^1_{m_2}=\boldsymbol R^{1\mathrm T}_2\big(\boldsymbol R^0_1\dot{\boldsymbol\omega}^0_{m_1}\big)
+k_{r2}\ddot\vartheta_2z_{m_2}+k_{r2}\dot\vartheta_2\big(\boldsymbol\omega^1_{m_1}\times z_{m_2}\big)
=\begin{bmatrix}k_{r1}k_{r2}\dot d_1\dot\vartheta_2\\ k_{r1}\ddot d_1\\ k_{r2}\ddot\vartheta_2\end{bmatrix}.$$

只有第 3 分量进入 $\tau_2$（因为 (7.114) 右乘 $z_{m_2}$，另两个分量被点乘消掉）——**这也是
教材解答只写出 $[0,0,k_{r2}\ddot\vartheta_2]^{\mathrm T}$ 的原因**，照抄可以，但要能解释。

### 第 2 步：后向递推（力与力矩）

**连杆 2**：$\boldsymbol f^3_3=\boldsymbol\mu^3_3=\boldsymbol 0$，

$$\boldsymbol f^2_2=m_2\ddot{\boldsymbol p}^2_{C_2}
=m_2\begin{bmatrix}s_2\ddot d_1-\ell_2\dot\vartheta_2^2-gc_2\\ c_2\ddot d_1+\ell_2\ddot\vartheta_2+gs_2\\0\end{bmatrix},$$

$$\boldsymbol\mu^2_2=-\boldsymbol f^2_2\times\big(\boldsymbol r^2_{1,2}+\boldsymbol r^2_{2,C_2}\big)
+\bar{\boldsymbol I}^2_2\dot{\boldsymbol\omega}^2_2+\boldsymbol\omega^2_2\times(\bar{\boldsymbol I}^2_2\boldsymbol\omega^2_2).$$

$\boldsymbol\omega^2_2\parallel z_2$ 且 $\bar{\boldsymbol I}^2_2$ 在本坐标系为对角阵，故陀螺项
$\boldsymbol\omega\times(\bar{\boldsymbol I}\boldsymbol\omega)\equiv\boldsymbol 0$；又
$\boldsymbol r^2_{1,2}+\boldsymbol r^2_{2,C_2}=[\ell_2,0,0]^{\mathrm T}$，得

$$\mu^2_{2z}=m_2\ell_2c_2\ddot d_1+\big(\bar I_{2zz}+m_2\ell_2^2\big)\ddot\vartheta_2+m_2\ell_2gs_2
\quad\Longrightarrow\quad
\tau_2=\mu^2_{2z}+k_{r2}^2I_{m2}\ddot\vartheta_2 .$$

**连杆 1**：

$$\boldsymbol f^1_1=\boldsymbol R^1_2\boldsymbol f^2_2+m_1\ddot{\boldsymbol p}^1_{C_1}
=\begin{bmatrix}-m_2\ell_2s_2\ddot\vartheta_2-m_2\ell_2c_2\dot\vartheta_2^2-(m_1+m_2)g\\
(m_1+m_2)\ddot d_1+m_2\ell_2c_2\ddot\vartheta_2-m_2\ell_2s_2\dot\vartheta_2^2\\0\end{bmatrix},$$

$$\tau_1=f^1_{1y}+k_{r1}^2I_{m1}\ddot d_1
\qquad(\text{移动副：取 }\boldsymbol f\text{ 沿关节方向 }y_1\text{ 的分量}).$$

### 第 3 步：答案

::: ex 习题 7-8 结论
$$\tau_1=\big(m_1+m_2+k_{r1}^2I_{m1}\big)\ddot d_1+m_2\ell_2c_2\ddot\vartheta_2-m_2\ell_2s_2\dot\vartheta_2^2,$$

$$\tau_2=m_2\ell_2c_2\ddot d_1+\big(\bar I_{2zz}+m_2\ell_2^2+k_{r2}^2I_{m2}\big)\ddot\vartheta_2+m_2\ell_2gs_2 .$$

写成 $\boldsymbol B(\boldsymbol q)\ddot{\boldsymbol q}+\boldsymbol C\dot{\boldsymbol q}+\boldsymbol g=\boldsymbol\tau$：

$$\boldsymbol B=\begin{bmatrix}m_1+m_2+k_{r1}^2I_{m1}&m_2\ell_2c_2\\[2pt]
m_2\ell_2c_2&\bar I_{2zz}+m_2\ell_2^2+k_{r2}^2I_{m2}\end{bmatrix},\qquad
\boldsymbol C\dot{\boldsymbol q}=\begin{bmatrix}-m_2\ell_2s_2\dot\vartheta_2^2\\0\end{bmatrix},\qquad
\boldsymbol g=\begin{bmatrix}0\\ m_2\ell_2gs_2\end{bmatrix}.$$
:::

### 第 4 步：和拉格朗日结果对一遍（这一步是「送分」也是「保险」）

同一台机器的拉格朗日结果（教材解答 (S7.4)(S7.5)）为

$$\tau_1=(m_{\ell_1}+m_{m_2}+m_{\ell_2}+k_{r1}^2I_{m1})\ddot d_1
+m_{\ell_2}\ell_2c_2\ddot\vartheta_2-m_{\ell_2}\ell_2s_2\dot\vartheta_2^2,$$
$$\tau_2=m_{\ell_2}\ell_2c_2\ddot d_1+\big(I_{\ell_2}+m_{\ell_2}\ell_2^2+k_{r2}^2I_{m2}\big)\ddot\vartheta_2
+m_{\ell_2}\ell_2gs_2 .$$

在对应关系 $m_1=m_{\ell_1}+m_{m_2}$（连杆 1 质量 + 电机 2 质量）、$m_2=m_{\ell_2}$、
$\bar I_{2zz}=I_{\ell_2}$、$\ell_2=\ell_{C2}+a_2$ 下**逐项相同**。两种方法互相验证，说明递推没有算错。

**四条解读**（手写时点出其中两三条，比只写公式更容易拿满「结论」分）：

1. $b_{11}$ 与位形无关：两连杆质心沿导轨的速度分量都恰为 $\dot d_1$（连杆 2 质心的横向偏移只进入
   $b_{12}$ 与 $b_{22}$），故沿导轨的等效质量恒为 $m_1+m_2$（再加 $k_{r1}^2I_{m1}$）；
   Christoffel 系数 $c_{112}=c_{211}=0$，$\tau_1$ 中不出现 $\dot d_1\dot\vartheta_2$ 型科氏项。
2. $b_{12}=b_{21}=m_2\ell_2c_2$，随 $\vartheta_2$ 变化——这份「位形相关」正是 $\tau_1$ 中离心项
   $-m_2\ell_2s_2\dot\vartheta_2^2$ 的来源。
3. **重力只进 $\tau_2$**：导轨水平、重力沿 $-x_0$ 垂直于导轨，移动副不需要「克服重力」的广义力；
   $\tau_2$ 中 $m_2\ell_2gs_2$ 在连杆下垂（$\vartheta_2=0$）时为零、水平（$\vartheta_2=\pi/2$）时最大。
4. 转子惯量以 $k_r^2I_m$ 出现在对角元：关节侧写 $I+k_r^2I_m$，除以 $k_r^2$ 即得电机侧的
   $I/k_r^2+I_m$——正是第 5 章 [5.2.3](../ch05/sec5-2-3.md) 的等效惯量折算。

### 验算

`tools/verify_homework06b.py` 的 7-8 部分用**三条互不复用的路线**对比（教材递推的 NumPy 实现、
闭式两式、独立拉格朗日模型），参数取 $m_1=3.0$、$m_2=2.0$、$\ell_2=0.35$（$\ell_{C2}=-0.25$、$a_2=0.6$）、
$\bar I_{2zz}=0.02$、$k_{r1}^2I_{m1}=0.05$、$k_{r2}^2I_{m2}=0.025$、$g=9.81$：

```
[7-8] 样例状态 d1=0.30, t2=0.70, dd1=0.50, dt2=-1.20, ddd1=2.00, ddt2=-3.00
      闭式 tau = [7.844459978, 4.624621920] N·m
      (A) 递推     vs (B) 闭式：max|d tau| = 7.105e-15
      (C) 拉格朗日 vs (B) 闭式：max|d tau| = 0.000e+00
      PASS (A) 递推 与闭式一致（<1e-09）
      PASS (C) 拉格朗日 与闭式一致（<1e-09）
```

偏差在双精度舍入量级（20 组随机状态，$\vartheta_2$ 跨 $\pm2\pi$）。**顺带一个可写进作业的检验**：
$f^2_{2}$ 与 $\mu^2_{2z}$ 的表达式、$\boldsymbol B$ 的对称正定性、$\dot B-2C$ 的反对称性都能逐项对上，
说明「中间量 → 最终模型」这条链条没有断。

::: think 7-8 易错点 · 四条 {#hw8-78-pitfalls}

1. **把 $\boldsymbol r^1_{0,1}$ 写成 $[d_1,0,0]^{\mathrm T}$**。位移沿的是 $y_1$（导轨），不是 $x_1$；
   写错在数值上未必立刻暴露（关节 1 上 $\boldsymbol\omega_1=0$ 使含它的项恒零），但说明坐标系没吃透。
2. **漏掉 $\ddot{\boldsymbol p}^2_{C_2}$ 里的 $\ell_2\dot\vartheta_2^2$**（向心项），或把 $a_2$ 与 $\ell_2$ 混用：
   质心用 $\ell_2=\ell_{C2}+a_2$，末端才用 $a_2$；教材解答里 $\ell_{C2}<0$ 就是「坐标系 2 原点在末端」的产物，
   照抄时不要以为书上写错了。
3. **移动副误加力矩**：移动副只有 $\boldsymbol f$ 沿关节方向的分量，转动副才取 $\boldsymbol\mu$ 沿关节轴的分量；
   两处转子项形式都是 $k_{r_i}^2I_{m_i}\ddot q_i$，但来源分别是 (7.114) 的两支。
4. **忘记重力向量符号**：$x_0$ 向上 $\Rightarrow \boldsymbol g^0=[-g,0,0]^{\mathrm T}$，初始条件
   $\ddot{\boldsymbol p}^0_0-\boldsymbol g^0_0=[g,0,0]^{\mathrm T}$；递推里「重力已经并进加速度」，不必再单独加。

:::

## 习题 7-10：把关节空间的反对称性「搬」到操作空间

### 第 0 步：命题与要用的三条恒等式

要证的是操作空间的 (7.48) 类比：

$$\boldsymbol N_A\equiv\dot{\boldsymbol B}_A-2\boldsymbol C_A\ \text{反对称}
\quad\Longleftrightarrow\quad
\boldsymbol w^{\mathrm T}\big(\dot{\boldsymbol B}_A-2\boldsymbol C_A\big)\boldsymbol w=0
\quad(\forall\,\boldsymbol w\in\mathbb R^r),$$

其中（教材 (7.130)–(7.132)）

$$\boldsymbol B_A=\big(\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}\big)^{-1},\qquad
\boldsymbol C_A\dot{\boldsymbol x}_e=\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol C\dot{\boldsymbol q}
-\boldsymbol B_A\dot{\boldsymbol J}_A\dot{\boldsymbol q},\qquad
\boldsymbol g_A=\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol g .$$

由 (7.138) 定义 $\boldsymbol B$ 加权的右伪逆 $\bar{\boldsymbol J}_A=\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}\boldsymbol B_A$，
它给出三条恒等式（第 1–3 条是全部推导的骨架）：

| # | 恒等式 | 为什么成立 |
|:--|:--|:--|
| (I) | $\boldsymbol B_A^{\mathrm T}=\boldsymbol B_A$ | $\boldsymbol B$ 对称正定 $\Rightarrow$ $\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}$ 对称 $\Rightarrow$ 其逆对称 |
| (II) | $\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}=\bar{\boldsymbol J}_A^{\mathrm T}$ | 把 (7.138) 两边转置，再用 (I) 与 $\boldsymbol B^{-\mathrm T}=\boldsymbol B^{-1}$ |
| (III) | $\boldsymbol J_A\bar{\boldsymbol J}_A=\boldsymbol I_r$ | $\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}\boldsymbol B_A=\boldsymbol I_r$；当且仅当 $\boldsymbol J_A$ 行满秩 |

### 第 1 步：$\dot{\boldsymbol B}_A$ 的展开

记 $\boldsymbol M=\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}$，则 $\boldsymbol B_A=\boldsymbol M^{-1}$。
用矩阵逆的求导公式 $\dfrac{\mathrm d}{\mathrm dt}\boldsymbol M^{-1}=-\boldsymbol M^{-1}\dot{\boldsymbol M}\boldsymbol M^{-1}$，
并注意

$$\dot{\boldsymbol M}=\dot{\boldsymbol J}_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}
-\boldsymbol J_A\boldsymbol B^{-1}\dot{\boldsymbol B}\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}
+\boldsymbol J_A\boldsymbol B^{-1}\dot{\boldsymbol J}_A^{\mathrm T},$$

得

$$\begin{aligned}
\dot{\boldsymbol B}_A=-\boldsymbol B_A\big(&\dot{\boldsymbol J}_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}
-\boldsymbol J_A\boldsymbol B^{-1}\dot{\boldsymbol B}\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}\\
&+\boldsymbol J_A\boldsymbol B^{-1}\dot{\boldsymbol J}_A^{\mathrm T}\big)\boldsymbol B_A .
\end{aligned}$$

> **对照教材解答的小坑**：官方解答手册在这一式把第一项的求导位置印在第二个 $\boldsymbol J_A$ 上，与真值相差
> $\boldsymbol B_A(\boldsymbol Y-\boldsymbol Y^{\mathrm T})\boldsymbol B_A$（$\boldsymbol Y=\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}\dot{\boldsymbol J}_A^{\mathrm T}\boldsymbol B_A$）。
> 这一项**恰是反对称的**，所以手册的最终结论不受影响；但推导时应按上式写。

### 第 2 步：$\boldsymbol C_A$ 的构造（为什么必须取 (7.138)）

(7.131) 只给出**乘积** $\boldsymbol C_A\dot{\boldsymbol x}_e$。由 (3.62) 的 $\dot{\boldsymbol x}_e=\boldsymbol J_A\dot{\boldsymbol q}$，
把 (7.131) 两边用 $\dot{\boldsymbol q}$ 表示，可得矩阵恒等式

$$\boldsymbol C_A\boldsymbol J_A=\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol C
-\boldsymbol B_A\dot{\boldsymbol J}_A .$$

两边右乘 $\bar{\boldsymbol J}_A$，用 (III) 得一个满足 (7.131) 的 $\boldsymbol C_A$：

$$\boxed{\ \boldsymbol C_A=\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol C\bar{\boldsymbol J}_A
-\boldsymbol B_A\dot{\boldsymbol J}_A\bar{\boldsymbol J}_A\ }$$

**这是「一个」解，不是「唯一」解**：若 $\boldsymbol C_A$ 是解，则对任意满足 $\boldsymbol Z\boldsymbol J_A=\boldsymbol 0$ 的
$\boldsymbol Z$，$\boldsymbol C_A+\boldsymbol Z$ 仍是解（$\boldsymbol Z$ 的列张成 $\boldsymbol J_A$ 的左零空间，对应
「内部运动」方向）。下面的反对称结论对**取 (7.138) 的那个解**成立，这一点与
[作业六 7-2](homework06.md#hw6-72-pitfalls) 的教训完全平行：$\dot{\boldsymbol q}^{\mathrm T}\boldsymbol N\dot{\boldsymbol q}=0$
是物理的、对任何 $\boldsymbol C$ 都成立；$\boldsymbol w^{\mathrm T}\boldsymbol N\boldsymbol w=0$ 对任意 $\boldsymbol w$ 成立，
则是**选法**给的。

### 第 3 步：分解 $\dot{\boldsymbol B}_A-2\boldsymbol C_A$

把第 1 步的三个因子用 (II) 改写：

$$\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}\dot{\boldsymbol B}\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}\boldsymbol B_A
=\bar{\boldsymbol J}_A^{\mathrm T}\dot{\boldsymbol B}\bar{\boldsymbol J}_A,\qquad
\boldsymbol B_A\dot{\boldsymbol J}_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}\boldsymbol B_A
=\boldsymbol B_A\dot{\boldsymbol J}_A\bar{\boldsymbol J}_A,$$

$$\boldsymbol B_A\boldsymbol J_A\boldsymbol B^{-1}\dot{\boldsymbol J}_A^{\mathrm T}\boldsymbol B_A
=\bar{\boldsymbol J}_A^{\mathrm T}\dot{\boldsymbol J}_A^{\mathrm T}\boldsymbol B_A .$$

于是

$$\dot{\boldsymbol B}_A=-\boldsymbol B_A\dot{\boldsymbol J}_A\bar{\boldsymbol J}_A
+\bar{\boldsymbol J}_A^{\mathrm T}\dot{\boldsymbol B}\bar{\boldsymbol J}_A
-\bar{\boldsymbol J}_A^{\mathrm T}\dot{\boldsymbol J}_A^{\mathrm T}\boldsymbol B_A,$$

而 $2\boldsymbol C_A=2\bar{\boldsymbol J}_A^{\mathrm T}\boldsymbol C\bar{\boldsymbol J}_A-2\boldsymbol B_A\dot{\boldsymbol J}_A\bar{\boldsymbol J}_A$。
两式相减、合并中间项：

$$\boxed{\ \dot{\boldsymbol B}_A-2\boldsymbol C_A
=\bar{\boldsymbol J}_A^{\mathrm T}\big(\dot{\boldsymbol B}-2\boldsymbol C\big)\bar{\boldsymbol J}_A
+\boldsymbol B_A\dot{\boldsymbol J}_A\bar{\boldsymbol J}_A
-\bar{\boldsymbol J}_A^{\mathrm T}\dot{\boldsymbol J}_A^{\mathrm T}\boldsymbol B_A\ }$$

### 第 4 步：逐项论证反对称

1. **第一项** $\bar{\boldsymbol J}_A^{\mathrm T}\boldsymbol N\bar{\boldsymbol J}_A$（$\boldsymbol N=\dot{\boldsymbol B}-2\boldsymbol C$）：
   由 (7.48) $\boldsymbol N$ 反对称，故
   $\big(\bar{\boldsymbol J}_A^{\mathrm T}\boldsymbol N\bar{\boldsymbol J}_A\big)^{\mathrm T}
   =\bar{\boldsymbol J}_A^{\mathrm T}\boldsymbol N^{\mathrm T}\bar{\boldsymbol J}_A
   =-\bar{\boldsymbol J}_A^{\mathrm T}\boldsymbol N\bar{\boldsymbol J}_A$，即反对称。
   $\bar{\boldsymbol J}_A$ 是 $n\times r$、不必是方阵，但乘出来是 $r\times r$ 方阵，转置论证照旧成立。
2. **后两项互为负转置**：记 $\boldsymbol X=\boldsymbol B_A\dot{\boldsymbol J}_A\bar{\boldsymbol J}_A$，由 (I) 得
   $\boldsymbol X^{\mathrm T}=\bar{\boldsymbol J}_A^{\mathrm T}\dot{\boldsymbol J}_A^{\mathrm T}\boldsymbol B_A^{\mathrm T}
   =\bar{\boldsymbol J}_A^{\mathrm T}\dot{\boldsymbol J}_A^{\mathrm T}\boldsymbol B_A$，所以后两项之差
   $\boldsymbol X-\boldsymbol X^{\mathrm T}=2\operatorname{skew}(\boldsymbol X)$ 反对称。
3. 反对称矩阵之和仍反对称，故 $\dot{\boldsymbol B}_A-2\boldsymbol C_A$ 反对称，
   即 $\boldsymbol w^{\mathrm T}(\dot{\boldsymbol B}_A-2\boldsymbol C_A)\boldsymbol w=0$ 对任意 $\boldsymbol w$ 成立。$\square$

### 第 5 步：三点说明（手写时留两行给它们）

- **非冗余退化**：$r=n$ 时 $\bar{\boldsymbol J}_A=\boldsymbol J_A^{-1}$，于是
  $\boldsymbol B_A=\boldsymbol J_A^{-\mathrm T}\boldsymbol B\boldsymbol J_A^{-1}$、
  $\boldsymbol C_A\dot{\boldsymbol x}_e=\boldsymbol J_A^{-\mathrm T}\boldsymbol C\dot{\boldsymbol q}
  -\boldsymbol B_A\dot{\boldsymbol J}_A\dot{\boldsymbol q}$（(7.134)(7.135)），反对称性由同一论证给出。
- **与 (7.48) 的对应**：关节空间 $\dot{\boldsymbol B}-2\boldsymbol C$ 反对称 $\leftrightarrow$ 操作空间
  $\dot{\boldsymbol B}_A-2\boldsymbol C_A$ 反对称；两者都是「能量守恒的代数表达」，前者对应
  $\tfrac12\dot{\boldsymbol q}^{\mathrm T}\boldsymbol B\dot{\boldsymbol q}$，后者对应伪动能
  $\tfrac12\dot{\boldsymbol x}_e^{\mathrm T}\boldsymbol B_A\dot{\boldsymbol x}_e$。正因为形式同构，
  [7.3](../ch07/sec7-3.md) 的计算力矩律才能整套搬到操作空间（[6.7](sec6-7.md) 的结论在此收口）。
- **奇异位形**：$\boldsymbol J_A$ 降秩时 $\boldsymbol J_A\boldsymbol B^{-1}\boldsymbol J_A^{\mathrm T}$ 奇异、
  $\boldsymbol B_A$ 无定义，结论只在**全秩位形**上成立。

### 验算

`tools/verify_homework06b.py` 的 7-10 部分取两例：2R 平面臂（$n=r=2$，非冗余）与 3R 平面臂
（$n=3$、末端位置 $r=2$，冗余）。$\boldsymbol B,\partial\boldsymbol B/\partial q,\boldsymbol J,
\partial\boldsymbol J/\partial q$ 全部**解析**给出，由 (7.130)–(7.132)、(7.138) 构造
$\boldsymbol B_A,\boldsymbol C_A,\dot{\boldsymbol B}_A$，再对 20 组随机 $(\boldsymbol q,\dot{\boldsymbol q},\boldsymbol w)$ 检验：

```
[7-10] 2R（n=r=2，非冗余）：max|w^T(BdA-2CA)w| = 3.375e-14（关节空间基线 2.220e-16）  PASS
[7-10] 3R（n=3,r=2，冗余）：max|w^T(BdA-2CA)w| = 8.162e-13（关节空间基线 3.331e-16）  PASS
```

残差在双精度舍入量级，且与关节空间基线同量级——说明 $\dot{\boldsymbol B}_A-2\boldsymbol C_A$ 确实反对称，
不是「数值上碰巧很小」。冗余一例里 $\bar{\boldsymbol J}_A$ 是 $3\times2$，说明结论不依赖 $r=n$。

::: think 7-10 易错点 · 四条 {#hw8-710-pitfalls}

1. **用几何雅可比写操作空间模型**：位置部分一样、姿态部分不一样（$\dot{\boldsymbol\phi}\neq\boldsymbol\omega$），
   必须用分析雅可比 $\boldsymbol J_A$；本题虽只考反对称性，但记号要写对。
2. **随手取一个右伪逆**：$\boldsymbol C_A$ 的不唯一性决定了「反对称」不是自动成立的，必须取 (7.138) 的
   $\boldsymbol B$ 加权右伪逆，才有 (II) 这个恒等式可用。
3. **把 $\bar{\boldsymbol J}_A$ 当成方阵**：冗余时 $n>r$，(III) 是 $\boldsymbol J_A\bar{\boldsymbol J}_A=\boldsymbol I_r$
   （右逆），不是 $\bar{\boldsymbol J}_A\boldsymbol J_A=\boldsymbol I_n$；写反了 (II) 就推不出来。
4. **漏掉 $\dot{\boldsymbol J}_A$ 项**：$\boldsymbol C_A$ 的第二项 $-\boldsymbol B_A\dot{\boldsymbol J}_A\bar{\boldsymbol J}_A$
   正是操作空间特有的「离心/科氏型」速度耦合，丢掉了分解式就不成立。

:::

## 两题对照

| | 7-8（递推牛顿–欧拉） | 7-10（操作空间反对称性） |
|:--|:--|:--|
| 考的路线 | 前向算速度/加速度、后向算力/力矩 | 矩阵求导 + 恒等式变形 |
| 关键公式 | (7.107)–(7.114)；(7.114) 的两支（移动/转动） | (7.130)–(7.132)、(7.138)；分解式 (33) |
| 最容易错 | 移动副与转动副取错分量；$a_2$ 与 $\ell_2$ 混用 | 忘取加权伪逆；把右逆当方阵逆 |
| 不变量检验 | 与拉格朗日结果逐项相同；$\boldsymbol B$ 对称正定 | $\boldsymbol w^{\mathrm T}\boldsymbol N_A\boldsymbol w=0$；$\dot{\boldsymbol B}-2\boldsymbol C$ 基线 |

两题都在练同一件事：**同一个物理结论换一套坐标/换一种描述之后，公式里哪些量要跟着变、哪些不变**。
7-8 换的是「建模方法」（能量法 → 递推法），$\boldsymbol B,\boldsymbol C,\boldsymbol g$ 不变；
7-10 换的是「状态空间」（$\boldsymbol q$ → $\boldsymbol x_e$），惯性阵与速度项都要跟着换，
但「反对称」这条结构性结论保持不变。

::: think 交卷前自查 {#hw8-final-check}

1. 7-8 是否写清了**初始条件**（含 $g^0$ 的符号与 $x_0$ 朝上）和**两遍递推各自的公式编号**？
2. 7-8 是否写出了 $\boldsymbol f^2_2$、$\mu^2_{2z}$、$\boldsymbol f^1_1$ 三个中间量，并说明移动副取 $f_{1y}$、
   转动副取 $\mu_{2z}$？
3. 7-8 的最终两式是否与拉格朗日结果在对应关系下逐项一致（是否交代了 $m_1$ 与 $m_{\ell_1}+m_{m_2}$、
   $\ell_2$ 与 $\ell_{C2}+a_2$ 的对应）？
4. 7-10 是否写出了三条恒等式 (I)–(III)，并指出**哪一步**用到「必须取 (7.138)」？
5. 7-10 的结论是否明确为「$\dot{\boldsymbol B}_A-2\boldsymbol C_A$ 反对称，即
   $\boldsymbol w^{\mathrm T}(\dot{\boldsymbol B}_A-2\boldsymbol C_A)\boldsymbol w=0$ 对任意 $\boldsymbol w$」，
   而不是只写「两者形式相同」？

:::
