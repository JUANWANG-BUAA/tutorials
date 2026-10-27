# 第七章总结 · 运动控制

> 这一章只做了一件事：**把「要让机械手按期望轨迹动」翻译成一串可以实时算出来的数**。从控制问题的
> 提法出发，经过「两套空间方案 → 两大类架构 → 广义力落地成电压」这条主线，最后落在两行式子上：
> 分散控制的 $\tau_i=K_Pe_i+K_D\dot e_i$（+ 补偿），与集中控制的
> $\boldsymbol\tau=B(\boldsymbol q)(\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}+K_P\boldsymbol e)
> +C\dot{\boldsymbol q}+\boldsymbol g$。下面把这两行拆成「记住什么、怎么用、容易错在哪」。

::: note 本编的完成度（哪部分是课堂上讲的）
本章覆盖**课件 §8.1–§8.2**（7.1 全部、7.2.5 的驱动接口），这部分是 2026-10-26 录播的原话与课件；
**§8.3–§8.7 的具体控制律**（7.2.1–7.2.4、7.2.6–7.2.7、7.3、7.4.3）按教材与课件目录预写，
第 9 周录播后校订。本文的「三句话」「知识地图」适用于全章，「常见错误」前五条是课堂内容。
:::

## 一页公式

### 被控对象

$$B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}
+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau \tag{7.1}$$

### 驱动接口（本讲正题）

$$\begin{aligned}
\boldsymbol q_m&=K_r\boldsymbol q, &\boldsymbol\tau_m&=K_r^{-1}\boldsymbol\tau=K_t\boldsymbol i_a,\\
\boldsymbol v_a&=R_a\boldsymbol i_a+K_v\dot{\boldsymbol q}_m, &\boldsymbol v_a&=G_v\boldsymbol v_c,
\end{aligned} \tag{7.9}$$

$$\boldsymbol\tau=K_rK_tR_a^{-1}\bigl(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q}\bigr) \tag{7.10}$$

$$\text{三条假设（}K_r\gg I,\ R_a\to0,\ \tau\ \text{小）}\ \Longrightarrow\
G_v\boldsymbol v_c\approx K_vK_r\dot{\boldsymbol q} \tag{7.11}$$

$$\text{加电流环：}\ \boldsymbol\tau=K_rK_tG_i\boldsymbol v_c \tag{7.12}$$

**一句话**：**$\tau$ 与 $v_c$ 之间隔着 $K_vK_r\dot{\boldsymbol q}$**——有它，就得整机一起算（集中）；
用电流环把它消掉，才是力矩源；用三条假设把它忽略，就掉进速度源（分散）。

### 分散（独立关节）控制

$$b_{ii}\ddot q_i+F_{{\rm v}_i}\dot q_i+g_i+d_i=\tau_i \tag{7.2}$$

$$\tau_i=K_{P_i}e_i+K_{D_i}\dot e_i\quad(\text{PD}),\qquad
\tau_i=K_{P_i}e_i+K_{I_i}\!\!\int\!\! e_i\,\mathrm dt+K_{D_i}\dot e_i\quad(\text{PID}) \tag{7.3,7.7}$$

$$J_i\ddot e_i+K_{D_i}\dot e_i+K_{P_i}e_i=d_i',\qquad
\omega_{n_i}=\sqrt{K_{P_i}/J_i},\ \ \zeta_i=\frac{K_{D_i}}{2\sqrt{K_{P_i}J_i}} \tag{7.4,7.5}$$

$$\text{PD 的稳态误差：}\ e_{i,\rm ss}=d_i'/K_{P_i}\neq0
\qquad\Longrightarrow\qquad \text{加积分，或把扰动补掉}$$

$$\boldsymbol\tau=\boldsymbol g(\boldsymbol q)+K_P\boldsymbol e+K_D\dot{\boldsymbol e}
\quad(\text{重力补偿 PD}) \tag{7.8}$$

$$\boldsymbol\tau=B(\boldsymbol q_d)\ddot{\boldsymbol q}_d
+C(\boldsymbol q_d,\dot{\boldsymbol q}_d)\dot{\boldsymbol q}_d+\boldsymbol g(\boldsymbol q_d)
+K_P\boldsymbol e+K_D\dot{\boldsymbol e}\quad(\text{计算力矩前馈}) \tag{7.13}$$

### 集中控制 · 计算力矩

$$\boldsymbol\tau=B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d+K_D\dot{\boldsymbol e}
+K_P\boldsymbol e\bigr)+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+\boldsymbol g(\boldsymbol q) \tag{7.15}$$

$$\Longrightarrow\quad \ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e=\boldsymbol 0
\tag{7.16}$$

**模型不准时**（标称模型 $\hat B,\hat C,\hat{\boldsymbol g}$）：

$$\ddot{\boldsymbol e}+K_D\dot{\boldsymbol e}+K_P\boldsymbol e
=B^{-1}\bigl[\Delta B\boldsymbol u+\Delta C\dot{\boldsymbol q}+\Delta\boldsymbol g\bigr] \tag{7.17}$$

### 操作空间

$$\boldsymbol x=\begin{bmatrix}\boldsymbol p\\\boldsymbol\phi\end{bmatrix},\quad
\dot{\boldsymbol x}=J_A(\boldsymbol q)\dot{\boldsymbol q},\qquad
B_x\ddot{\boldsymbol x}+C_x\dot{\boldsymbol x}+\boldsymbol g_x
=\boldsymbol\tau_x-\boldsymbol h_e \tag{7.18,7.19}$$

$$\boldsymbol F=B_x\bigl(\ddot{\boldsymbol x}_d+K_D\dot{\boldsymbol e}_x
+K_P\boldsymbol e_x\bigr)+C_x\dot{\boldsymbol x}+\boldsymbol g_x
\quad\Longrightarrow\quad
\ddot{\boldsymbol e}_x+K_D\dot{\boldsymbol e}_x+K_P\boldsymbol e_x=\boldsymbol 0 \tag{7.21,7.22}$$

### 三套方案一表

| | 分散控制 | 集中 · 计算力矩 | 操作空间 |
|:--|:--|:--|:--|
| 反馈量 | $\boldsymbol q,\dot{\boldsymbol q}$ | $\boldsymbol q,\dot{\boldsymbol q}$ | $\boldsymbol x,\dot{\boldsymbol x}$（多为估计） |
| 驱动器 | **速度源**（电压控制） | **力矩源**（电流环） | **力矩源** |
| 误差方程 | 带扰动的单轴二阶 | 解耦二阶（模型精确时） | 同左，在 $x$ 空间 |
| 计算量 / 适用 | 最小 / 低速轻载点位 | 大 / 高速高精重载 | 最大 / 柔顺冗余 |

## 三句话总结

1. **控制 = 任务翻译 + 力决策**：任务提在操作空间、动作落在关节空间，两套方案就是「把任务翻译成
   关节角」（$x$ 开环）与「把控制器搬到 $x$ 空间」（$x$ 要测）；**闭环通道里有什么量、那个量的
   信息质量如何，才是方案优劣的真判据。**
2. **能不能分散控制，由驱动器决定**：大减速比 + 小电枢电阻 + 小转矩 ⇒ 电压与速度成正比 ⇒
   每轴一个速度环；反之要力矩源（电流环）与整机模型。这条接口上接第五章的驱动、下接
   §8.3/§8.5 的方法。
3. **用模型的方式决定误差方程的样子**：把耦合当扰动（分散）⇒ 误差方程带 $d_i'$，稳态误差
   $\propto1/K_P$；把耦合算出来抵消（计算力矩）⇒ 误差方程解耦成 $n$ 个二阶系统，代价是模型误差
   以 (7.17) 的形式漏进来。**所有高级方法（鲁棒/自适应）都在补这个漏。**

## 知识地图（本章在全书中的位置）

```text
第 2 章 运动学（逆解 q_d←x_d）──┐
第 3 章 微分运动学（J、J_A、奇点）─┤
第 4 章 轨迹规划（q_d, q̇_d, q̈_d）─┼──→ 第 7 章 运动控制（本章）
第 5 章 执行器与传感器（驱动、反馈）┤        │
第 6 章 动力学（B, C, g）──────────┘        │
                                            ├─ 7.1 体系：关节/操作空间 × 分散/集中
                                            ├─ 7.2 分散：单轴 PD/PID + 补偿 + 驱动接口
                                            ├─ 7.3 集中：计算力矩（反馈线性化）
                                            └─ 7.4 操作空间：x 空间的控制律
                                                  │
                                                  ↓
                                    第 8 章 力控制（h_e 不能丢）
                                    第 9 章 视觉伺服（x 从哪来）
```

**下一章（原书第 9 章 力控制）会反复用到本章的三样东西**：操作空间模型 (7.19)（力控方程就写在它
上面）、$J^{\mathrm T}$ 的折算关系（末端力 ↔ 关节力矩）、以及「$x$ 的测量质量决定闭环上限」这个
判断（力/位混合控制同样受它限制）。

## 常见错误总表

| # | 错误 | 纠正 |
|:--|:--|:--|
| 1 | 把「关节空间控制」与「分散控制」当成同一件事 | 前者是**空间**分类，后者是**架构**分类；关节空间里也能用集中控制 |
| 2 | 以为操作空间方案一定更好 | $x$ 若由 $\boldsymbol q$ 算出，信息上仍是间接的（课件：「优点只是潜在的」） |
| 3 | 只看到 $\tau\leftrightarrow v_c$ 的比例，忘了反电动势 | 「比例」只在 $K_r\gg I$、$R_a$ 小、$\tau$ 小三条假设下成立 |
| 4 | 用期望值算重力补偿 | (7.8) 必须用实测 $\boldsymbol q$ |
| 5 | 以为 PD 加了大 $K_P$ 就没有稳态误差 | $e_{\rm ss}=d/K_P\neq0$；零误差要积分或补偿 |
| 6 | 计算力矩里把 $\boldsymbol q$ 写成 $\boldsymbol q_d$ | 一写就退回前馈 (7.13)，不再是反馈线性化 |
| 7 | 以为误差方程 (7.16) 与参数无关 | 前提是模型精确且未限幅；破一个，(7.17) 就回来 |
| 8 | 用几何雅可比写操作空间模型 | 姿态部分要分析雅可比 $J_A$（$\dot{\boldsymbol\phi}\neq\boldsymbol\omega$） |
| 9 | 冗余机械手硬求 $J^{-1}$ | $n>6$ 时非方阵，必须伪逆 + 零空间 |
| 10 | 选方案从「哪个先进」出发 | 先看驱动器类型（速度源/力矩源）与任务精度要求 |

## 学完自检

::: think 十问自检（能答八问即可进入第九章）
1. 控制问题与动力学正问题的区别是什么？控制问题的输入、输出、指标各是什么？
2. 任务分哪两大类？本章的控制律为什么可以忽略末端反力？
3. 画出关节空间控制框图，指出闭环量与开环段，说出至少两个误差来源。
4. 画出操作空间控制框图，解释「这种优点只是潜在的」。
5. 分散控制与集中控制的四条对照是什么？它们的判别依据（工况）是什么？
6. 默写驱动系统五式（四组关系），推出 (7.10)，并说明三条假设各自消掉了什么。
7. 由 (7.10) 解释「为什么精确算 $\tau_i$ 需要知道所有关节的运动」，电流环如何绕开它？
8. 写出 PD 的稳态误差与 $\omega_n,\zeta$ 表达式；说明积分为什么必要。
9. 写出计算力矩律并推出误差方程；说明模型不准时会发生什么。
10. 写出操作空间模型与它的计算力矩律；说出三套方案在驱动器要求上的差别。
:::

## 与前后章的接口

- **向前**（第 2–6 章）：逆运动学给 $\boldsymbol q_d$（第 2 章）；$J,J_A$ 与奇点（第 3 章）；
  轨迹给 $\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d$（第 4 章）；驱动器模型与
  两种发电机特性（第 5 章）；$B,C,\boldsymbol g$ 与两条结构性质（第 6 章）。
- **向后**（第 9–10 章）：力控制把 $-\boldsymbol h_e$ 从「扔掉」变成「控制对象」；视觉伺服回答
  「$\boldsymbol x$ 怎么测」，补上 7.4 的短板。
- **本讲的另一条尾巴**：前半段（01:30–01:38）的**轨迹动态标度**（$\tau=c^2\tau'$，只需调一个
  参数 $c$）属动力学章（课件 §7.7），它解决的正是「规划出来的轨迹电机执行不了」——控制之前，
  先把可行性调好。
