# 第七章总结 · 运动控制

> 这一章只做了一件事：**把「要让机械手按期望轨迹动」翻译成一串可以实时算出来的数**。主线是
> **两套空间方案 → 两大类架构 → 四档模型使用深度 → 九种方案比较**。最该记住的是三层递进：
> 分散控制把耦合当干扰（$d$），集中控制把耦合算出来抵消（$B,C,\boldsymbol g$），鲁棒/自适应在
> 模型不准时兜底。下面把这条线拆成「记住什么、怎么用、容易错在哪」。

::: note 本编的完成度
本章覆盖**课件 §8.1–§8.7 全部内容**：7.1 与 7.2.5 来自第 8 周录播（2026-10-26），
7.2.1–7.2.4、7.2.6–7.2.8、7.3、7.4、7.5 来自第 9 周录播（2026-11-02）。**不再有「教材补」的节**。
章末五件套（勘误/习题/自检表/回忆卡/自测卷）已齐；第 9 周作业详解见 [作业七](homework07.md)。
:::

## 一页公式

### 被控对象与分散化

$$B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
+F_{\mathrm v}\dot{\boldsymbol q}+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau \tag{7.1}$$

$$K_r^{-1}\bar B K_r^{-1}\ddot{\boldsymbol q}_m+F_m\dot{\boldsymbol q}_m+d=\boldsymbol\tau_m,
\qquad
d=K_r^{-1}\Delta B K_r^{-1}\ddot{\boldsymbol q}_m
+K_r^{-1}C K_r^{-1}\dot{\boldsymbol q}_m+K_r^{-1}\boldsymbol g \tag{7.2-3,7.2-4}$$

**一句话**：把 $B$ 拆成「标称对角阵 $\bar B$ + 位形依赖 $\Delta B$」，耦合、重力、库仑摩擦全塞进
$d$，剩下 $n$ 个线性定常单轴系统。

### 分散控制：三种控制器与根轨迹

$$C_p=K_P,\qquad C_v(s)=K_v\frac{1+sT_v}{s},\qquad C_A=1,
\qquad C(s)=K_c\frac{1+sT_c}{s}\ (\text{PI}) \tag{7.2-6}$$

$$L(s)=\frac{k_mK_Pk_{tp}(1+sT_p)}{s^2(1+sT_m)},\qquad
T_p<T_m\ \text{不稳定},\quad T_p>T_m\ \text{稳定},\quad T_p\gg T_m\ \text{更快} \tag{7.2-8}$$

$$X_R=K_Pk_{tp},\qquad T_R=\max\left\{T_p,\frac{1}{\zeta\omega_n}\right\} \tag{7.2-12,7.2-13}$$

### 驱动接口（第 8 周）

$$\boldsymbol q_m=K_r\boldsymbol q,\quad
\boldsymbol\tau_m=K_r^{-1}\boldsymbol\tau=K_t\boldsymbol i_a,\quad
\boldsymbol v_a=R_a\boldsymbol i_a+K_v\dot{\boldsymbol q}_m,\quad
\boldsymbol v_a=G_v\boldsymbol v_c \tag{7.2-14}$$

$$\boldsymbol\tau=K_rK_tR_a^{-1}(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q}) \tag{7.2-15}$$

$$\text{三条假设（}K_r\gg I,\ R_a\to0,\ \tau\ \text{小）}
\Longrightarrow G_v\boldsymbol v_c\approx K_vK_r\dot{\boldsymbol q} \tag{7.2-16}$$

$$\text{加电流环：}\ \boldsymbol\tau=K_rK_tG_i\boldsymbol v_c \tag{7.2-17}$$

**一句话**：$\tau$ 与 $v_c$ 之间隔着 $K_vK_r\dot{\boldsymbol q}$——有它就得整机一起算；
用电流环消掉它才是力矩源；用三条假设忽略它就掉进速度源。

### 前馈：计算转矩前馈

$$\boldsymbol v_{c,\rm ff}=R_aK_t^{-1}\Bigl[
K_r^{-1}\Delta B(\boldsymbol q_d)K_r^{-1}\ddot{\boldsymbol q}_{md}
+K_r^{-1}C(\boldsymbol q_d,\dot{\boldsymbol q}_d)K_r^{-1}\dot{\boldsymbol q}_{md}
+K_r^{-1}\boldsymbol g(\boldsymbol q_d)\Bigr] \tag{7.2-18}$$

### 集中控制 · 重力补偿 PD（点对点）

$$V=\frac12\dot{\boldsymbol q}^{\mathrm T}B\dot{\boldsymbol q}
+\frac12\tilde{\boldsymbol q}^{\mathrm T}K_P\tilde{\boldsymbol q},\qquad
\boldsymbol u=\boldsymbol g(\boldsymbol q)+K_P\tilde{\boldsymbol q}-K_D\dot{\boldsymbol q}
\ \Longrightarrow\
\dot V=-\dot{\boldsymbol q}^{\mathrm T}(F+K_D)\dot{\boldsymbol q}\le0 \tag{7.3-3,7.3-6,7.3-7}$$

### 集中控制 · 逆动力学（轨迹跟踪）

$$\boldsymbol u=B(\boldsymbol q)\bigl(\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}
+K_P\tilde{\boldsymbol q}\bigr)+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q}),
\qquad
\boldsymbol n=C\dot{\boldsymbol q}+F\dot{\boldsymbol q}+\boldsymbol g \tag{7.3-9}$$

$$\Longrightarrow\quad
\ddot{\tilde{\boldsymbol q}}+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q}=0 \tag{7.3-10}$$

### 集中控制 · 鲁棒

$$\boldsymbol u=\hat B\boldsymbol y+\hat{\boldsymbol n}+\boldsymbol\omega,\qquad
\boldsymbol y=\ddot{\boldsymbol q}_d+K_D\dot{\tilde{\boldsymbol q}}+K_P\tilde{\boldsymbol q},
\qquad
\boldsymbol\omega=\frac{\rho}{\|\boldsymbol z\|}\boldsymbol z,\quad
\boldsymbol z=D^{\mathrm T}Q\boldsymbol\xi \tag{7.3-12,7.3-13}$$

$$\text{边界层：}\ \boldsymbol\omega=
\begin{cases}
\rho\boldsymbol z/\|\boldsymbol z\|, & \|\boldsymbol z\|\ge\varepsilon\\
(\rho/\varepsilon)\boldsymbol z, & \|\boldsymbol z\|<\varepsilon
\end{cases} \tag{7.3-14}$$

**一句话**：模型补偿 + 线性反馈 + 鲁棒项；滑动子空间 $z=0$，边界层把「抖振」换成「有界误差」。

### 集中控制 · 自适应

$$\dot{\boldsymbol q}_r=\dot{\boldsymbol q}_d+\Lambda\tilde{\boldsymbol q},\qquad
\boldsymbol\sigma=\dot{\boldsymbol q}_r-\dot{\boldsymbol q}
=\dot{\tilde{\boldsymbol q}}+\Lambda\tilde{\boldsymbol q} \tag{7.3-16}$$

$$\boldsymbol u=Y(\boldsymbol q,\dot{\boldsymbol q},\dot{\boldsymbol q}_r,\ddot{\boldsymbol q}_r)
\hat{\boldsymbol\pi}+K_D\boldsymbol\sigma,\qquad
\dot{\hat{\boldsymbol\pi}}
=K_\pi^{-1}Y^{\mathrm T}\boldsymbol\sigma \tag{7.3-17,7.3-18}$$

**一句话**：参数线性性 $\tau=Y\pi$ 是入口；$\hat\pi$ 在线更新，只保证跟踪收敛，不保证辨识真值。

### 操作空间

$$\boldsymbol x=\begin{bmatrix}\boldsymbol p\\\boldsymbol\phi\end{bmatrix},\quad
\dot{\boldsymbol x}=J_A\dot{\boldsymbol q},\quad
B_x\ddot{\boldsymbol x}+C_x\dot{\boldsymbol x}+\boldsymbol g_x
=\boldsymbol\tau_x-\boldsymbol h_e \tag{7.4-1,7.4-3}$$

$$\text{转置雅可比：}\ \boldsymbol F=K_P(\boldsymbol x_d-\boldsymbol x),\quad
\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol F \tag{7.4-5}$$

$$\text{重力补偿 PD：}\ \boldsymbol u=\boldsymbol g+J_A^{\mathrm T}K_P\tilde{\boldsymbol x}
+J_A^{\mathrm T}K_DJ_A\dot{\boldsymbol q} \tag{7.4-7}$$

$$\text{逆动力学：}\ \boldsymbol y=J_A^{-1}\bigl(\ddot{\boldsymbol x}_d+K_D\dot{\tilde{\boldsymbol x}}
+K_P\tilde{\boldsymbol x}-\dot J_A\dot{\boldsymbol q}\bigr),\quad
\boldsymbol u=B\boldsymbol y+\boldsymbol n \tag{7.4-11}$$

### 九种方案的误差量级（快轨迹）

| 方案 | 误差量级 | 方案 | 误差量级 |
|:--|:--|:--|:--|
| A 位置 + 速度（分散） | $\sim0.2$ rad | F 重力补偿 PD（集中） | 跟踪不如 C/D |
| C A + 分散前馈 | $<0.01$ rad | G 逆动力学 | $\sim10^{-4}$ rad |
| E C + 计算转矩前馈 | $\sim0.005$ rad | H 鲁棒 / I 自适应 | $10^{-3}$–$10^{-4}$ rad |

## 三句话总结

1. **分散 = 把耦合当干扰，集中 = 把耦合算出来抵消。** 分散的合法性来自驱动（大减速比 + 小电枢
   电阻 + 小转矩 ⇒ $\dot q\propto v_c$）；集中的合法性来自模型（$B,C,\boldsymbol g$ 可算）。
   选哪条先看驱动器是电压源还是电流源。
2. **模型用得越深，误差越小，代价越大。** 纯反馈 $\sim0.2$ rad → 加前馈 $\sim0.01$ →
   逆动力学 $10^{-4}$；但逆动力学要在线算整机模型、要准参数、要快采样，模型一不准就退回
   $10^{-3}$，于是需要鲁棒/自适应。
3. **稳定性证明只有一个套路**：构造 $V=\frac12\dot q^{\mathrm T}B\dot q+\frac12e^{\mathrm T}K_Pe$，
   求导，用 $\dot B-2C$ 反对称消交叉项；$\dot V\le0$ 后用拉萨尔原理补最后一步。

## 知识地图（本章在全书中的位置）

```text
第 2 章 运动学（逆解 q_d←x_d）──┐
第 3 章 微分运动学（J、J_A、奇点）─┤
第 4 章 轨迹规划（q_d, q̇_d, q̈_d）─┼──→ 第 7 章 运动控制（本章）
第 5 章 执行器与传感器（驱动、反馈）┤        │
第 6 章 动力学（B, C, g, Yπ）──────┘        │
                                            ├─ 7.1 体系：关节/操作空间 × 分散/集中
                                            ├─ 7.2 分散：单轴 PI/PID + 根轨迹 + 前馈 + 驱动接口
                                            ├─ 7.3 集中：重力补偿 PD → 逆动力学 → 鲁棒 → 自适应
                                            ├─ 7.4 操作空间：转置/逆雅可比 + PD/逆动力学
                                            └─ 7.5 九种方案比较与选型
                                                  │
                                                  ↓
                                    第 8 章 力控制（h_e 不能丢）
                                    第 9 章 视觉伺服（x 从哪来）
```

## 常见错误总表

| # | 错误 | 纠正 |
|:--|:--|:--|
| 1 | 把「关节空间控制」与「分散控制」当成同一件事 | 前者是**空间**分类，后者是**架构**分类；关节空间里也能用集中控制 |
| 2 | 把三种单轴控制器串起来 | 位置/速度/加速度三套 PI **选一套**，其余置 1 |
| 3 | 以为 $K_P$ 越大越好 | $K_P$ 压低干扰增益，但也压低阻尼比；超过电机时间常数允许范围就振荡 |
| 4 | 把 $T_p<T_m$ 当归一化问题 | 那是**结构不稳定**，调 $K_P$ 救不了 |
| 5 | 用期望值算反馈环里的重力 | 反馈用**实测** $\boldsymbol q$；只有前馈用 $\boldsymbol q_d$ |
| 6 | 重力补偿 PD 拿来做轨迹跟踪 | 它的证明用了 $\dot q_d=0$，只能点对点 |
| 7 | 逆动力学里把 $\boldsymbol q$ 写成 $\boldsymbol q_d$ | 一写就退回前馈，不再是反馈线性化 |
| 8 | 鲁棒项无限加大 $\rho$ | $\rho$ 超过实际不确定界只会加剧抖振 |
| 9 | 加边界层后还宣称渐近收敛 | 边界层只保证**有界误差**，不是零 |
| 10 | 以为自适应能辨识真参数 | 更新律只保证跟踪收敛，参数可能漂移 |
| 11 | 用几何雅可比写操作空间模型 | 姿态部分要分析雅可比 $J_A$（$\dot\phi\neq\omega$） |
| 12 | 冗余机械手硬求 $J_A^{-1}$ | $n>6$ 时非方阵，必须伪逆 + 零空间 |
| 13 | 选方案从「哪个先进」出发 | 先看驱动器（电压源/电流源）与误差预算 |

## 学完自检

::: think 十二问自检（能答十问即可进入第八章）
1. 控制问题与动力学正问题的区别是什么？
2. 分散控制把什么塞进 $d$？$d$ 里至少包含哪三项？
3. 位置环开环传递函数是什么？$T_p<T_m$ 为什么不稳定？
4. 干扰抑制因子与收敛时间怎么算？$K_P$ 的取舍是什么？
5. 驱动五式与三条假设推出什么？为什么它能证明「可以分散」？
6. 重力补偿 PD 的李雅普诺夫函数是什么？为什么它只能做点对点？
7. 逆动力学控制的误差方程是什么？它与计算转矩前馈的区别在哪？
8. 鲁棒控制的滑动子空间与边界层各起什么作用？为什么加边界层后误差不为零？
9. 自适应控制的 $\sigma$、控制律、更新律是什么？它保证什么、不保证什么？
10. 操作空间的转置雅可比方案与逆雅可比方案各有什么优缺点？
11. 九种方案的误差量级相对关系是什么？
12. 选型先看哪三件事？
:::

## 与前后章的接口

- **向前**（第 2–6 章）：逆运动学给 $\boldsymbol q_d$；$J,J_A$ 与奇点；轨迹给
  $\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d$；驱动器模型与两种发电机特性；
  $B,C,\boldsymbol g$ 与 $\boldsymbol\tau=Y\pi$。
- **向后**（第 8–9 章）：力控制把 $-\boldsymbol h_e$ 从「扔掉」变成「控制对象」；视觉伺服回答
  「$\boldsymbol x$ 怎么测」，补上 7.4 的短板。
