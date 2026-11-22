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

**一句话**：把 $B$ 拆成标称对角阵 $\bar B$ 与偏差 $\Delta B$，再把惯量偏差、速度耦合和重力并入 $d$。上式保留折算黏性摩擦；若考虑库仑摩擦，还须将其计入扰动。

### 分散控制：三种控制器与根轨迹

$$C_p=K_P,\qquad C_v(s)=K_v\frac{1+sT_v}{s},\qquad C_A=1,
\qquad C(s)=K_c\frac{1+sT_c}{s}\ (\text{PI}) \tag{7.2-6}$$

$$L(s)=\frac{k_mK_Pk_{tp}(1+sT_p)}{s^2(1+sT_m)},\qquad
T_p<T_m\ \text{不稳定},\quad T_p>T_m\ \text{稳定}\quad(\text{正参数模型}). \tag{7.2-8}$$

$$X_R=K_Pk_{tp},\qquad T_R=\max\left\{T_p,\frac{1}{\zeta\omega_n}\right\} \tag{7.2-12,7.2-13}$$

### 驱动接口（第 8 周）

$$\boldsymbol q_m=K_r\boldsymbol q,\quad
\boldsymbol\tau_m=K_r^{-1}\boldsymbol\tau=K_t\boldsymbol i_a,\quad
\boldsymbol v_a=R_a\boldsymbol i_a+K_v\dot{\boldsymbol q}_m,\quad
\boldsymbol v_a=G_v\boldsymbol v_c \tag{7.2-14}$$

$$\boldsymbol\tau=K_rK_tR_a^{-1}(G_v\boldsymbol v_c-K_vK_r\dot{\boldsymbol q}) \tag{7.2-15}$$

$$|R_{a_i}i_{a_i}|\ll|k_{v_i}k_{r_i}\dot q_i|\quad\text{（每个需近似的关节）}
\quad\Longrightarrow\quad G_v\boldsymbol v_c\approx K_vK_r\dot{\boldsymbol q}. \tag{7.2-16}$$

$$\text{理想电流环：}\ \boldsymbol\tau=K_rK_tG_i\boldsymbol v_c.$$

电阻压降足够小时，电压近似决定速度；电流内环则可近似按指令控制电机力矩。整机动力学中的耦合是否需要补偿，仍取决于任务与实际参数。

### 前馈：计算转矩前馈

$$\boldsymbol v_{c,\rm ff}=G_v^{-1}R_aK_t^{-1}\Bigl[
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
\boldsymbol z=\hat B^{-\mathrm T}D^{\mathrm T}Q\boldsymbol\xi,\quad D=[0;I] \tag{7.3-12,7.3-13}$$

$$\text{边界层：}\ \boldsymbol\omega=
\begin{cases}
\rho\boldsymbol z/\|\boldsymbol z\|, & \|\boldsymbol z\|\ge\varepsilon\\
(\rho/\varepsilon)\boldsymbol z, & \|\boldsymbol z\|<\varepsilon
\end{cases} \tag{7.3-14}$$

**一句话**：模型补偿 + 线性反馈 + 力矩型鲁棒项。$Q$ 解 $A^{\mathrm T}Q+QA=-P$；$\rho$ 须覆盖力矩不确定界。本文 $z=0$ 与课件 $D^{\mathrm T}Q\xi=0$ 是相同零集合，但补偿方向的惯量因子不可省。边界层一般只给最终有界保证，不保证误差必定非零；完整推导见 [7.3.5](sec7-3.md#sec-7.3.5)。

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
=\boldsymbol\tau_x-\boldsymbol h_A,\quad \boldsymbol h_A=T_A^{\mathrm T}\boldsymbol h_e,\ J=T_AJ_A \tag{7.4-1,7.4-3}$$

$$\text{转置雅可比：}\ \boldsymbol F=K_P(\boldsymbol x_d-\boldsymbol x),\quad
\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol F \tag{7.4-5}$$

$$\text{重力补偿 PD：}\ \boldsymbol u=\boldsymbol g+J_A^{\mathrm T}K_P\tilde{\boldsymbol x}
-J_A^{\mathrm T}K_DJ_A\dot{\boldsymbol q}. \tag{7.4-7}$$

$$\text{逆动力学：}\ \boldsymbol y=J_A^{-1}\bigl(\ddot{\boldsymbol x}_d+K_D\dot{\tilde{\boldsymbol x}}
+K_P\tilde{\boldsymbol x}-\dot J_A\dot{\boldsymbol q}\bigr),\quad
\boldsymbol u=B\boldsymbol y+\boldsymbol n \tag{7.4-11}$$

### 课堂仿真的末端位置误差量级（快轨迹）

| 方案 | 误差量级 | 方案 | 误差量级 |
|:--|:--|:--|:--|
| A 位置 + 速度（分散） | 约 $0.2\,\mathrm m$ | F 重力补偿 PD + 速度前馈（集中） | 本例跟踪不如 C/D |
| C A + 分散前馈 | $10^{-2}\,\mathrm m$ | G 逆动力学 | 精确模型下 $10^{-4}\,\mathrm m$ |
| E 计算转矩前馈 | 约 $0.005\,\mathrm m$ | H 鲁棒 / J 自适应 | $10^{-3}$–$10^{-4}\,\mathrm m$ |

原图纵轴为末端 $\tilde x,\tilde y$，不是关节角误差；原方案标签从 H 跳至 J，自适应不能改标为 I。这些量级只属于课堂所示工况，不能作为其他机器人的选型阈值；比较条件见 [7.5](sec7-5.md)。

## 三句话总结

1. **分散与集中**：分散控制将剩余耦合视作扰动，集中控制利用多关节模型或状态设计控制律。能否达到精度和稳定性要求，要结合驱动与负载检查。
2. **反馈与前馈**：前馈用模型预估力矩，反馈依据实测误差修正。模型、轨迹和执行器条件改变时，不能直接套用某次仿真的误差排序。
3. **稳定性证明**：重力补偿 PD 可用动能加位置误差二次型构造 $V$，并利用 $\dot B-2C$ 消去交叉项。$\dot V\le0$ 后还须检查不变集及有界性，见 [7.3](sec7-3.md)。

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
                                    原书第 9 章 力控制（h_e 不能丢）
                                    原书第 10 章 视觉伺服（x 从哪来）
```

## 常见错误总表

| # | 错误 | 纠正 |
|:--|:--|:--|
| 1 | 把「关节空间控制」与「分散控制」当成同一件事 | 前者是**空间**分类，后者是**架构**分类；关节空间里也能用集中控制 |
| 2 | 把位置、速度、加速度各设计成独立 PID 并直接叠加 | 先确定控制结构，按所选环节设计和整定；多环伺服也可以分层设计 |
| 3 | 以为 $K_P$ 越大越好 | 必须检查完整频率响应、采样、噪声和饱和；不能由干扰抑制因子单独判断稳定性 |
| 4 | 把 $T_p<T_m$ 当归一化问题 | 那是**结构不稳定**，调 $K_P$ 救不了 |
| 5 | 用期望值算反馈环里的重力 | 反馈用**实测** $\boldsymbol q$；只有前馈用 $\boldsymbol q_d$ |
| 6 | 将重力补偿 PD 的点对点证明直接用于任意轨迹 | 该证明用了 $\dot q_d=0$；轨迹跟踪须另行分析误差 |
| 7 | 逆动力学里把 $\boldsymbol q$ 写成 $\boldsymbol q_d$ | 一写就退回前馈，不再是反馈线性化 |
| 8 | 鲁棒项无限加大 $\rho$ | $\rho$ 超过实际不确定界只会加剧抖振 |
| 9 | 加边界层后无条件宣称渐近收敛 | 一般只保证最终有界，但并不表示最终误差必定非零 |
| 10 | 以为自适应一定辨识真参数 | 理想固定参数模型下估计有界；真值收敛另需可辨识性与持续激励 |
| 11 | 混用两种雅可比及其共轭力 | 分析坐标速度配 $J_A$ 与 $h_A$；几何速度配 $J$ 与几何力/力矩 |
| 12 | 冗余机械手硬求 $J_A^{-1}$ | $n>6$ 时非方阵，必须伪逆 + 零空间 |
| 13 | 选方案从「哪个先进」出发 | 先看驱动器（电压源/电流源）与误差预算 |

## 学完自检

::: think 十二问自检（答完后核对条件，再进入原书后续主题）
1. 控制问题与动力学正问题的区别是什么？
2. 分散控制把什么塞进 $d$？$d$ 里至少包含哪三项？
3. 位置环开环传递函数是什么？$T_p<T_m$ 为什么不稳定？
4. 干扰抑制因子与收敛时间怎么算？$K_P$ 的取舍是什么？
5. 驱动五式在什么逐轴条件下给出电压—速度近似？它为什么不单独证明整机闭环稳定？
6. 重力补偿 PD 的李雅普诺夫函数是什么？本节的固定目标证明为什么不能直接用于轨迹跟踪？
7. 逆动力学控制的误差方程是什么？它与计算转矩前馈的区别在哪？
8. 鲁棒控制的滑动子空间与边界层各起什么作用？为什么加边界层后一般只能保证误差有界？
9. 自适应控制的 $\sigma$、控制律、更新律是什么？它保证什么、不保证什么？
10. 操作空间的转置雅可比方案与逆雅可比方案各有什么优缺点？
11. 九种方案的误差量级相对关系是什么？
12. 选型先看哪三件事？
:::

## 与前后章的接口

- **向前**（第 2–6 章）：逆运动学给 $\boldsymbol q_d$；$J,J_A$ 与奇点；轨迹给
  $\boldsymbol q_d,\dot{\boldsymbol q}_d,\ddot{\boldsymbol q}_d$；驱动器模型与两种发电机特性；
  $B,C,\boldsymbol g$ 与 $\boldsymbol\tau=Y\pi$。
- **向后**（原书第 9–10 章）：力控制将末端交互力 $\boldsymbol h_e$ 纳入控制目标；视觉伺服回答
  「$\boldsymbol x$ 怎么测」，补上 7.4 的测量问题。本教程目前止于第七章，这里指向原书后续主题。

回到卷首的任务：自由空间中的取放和对准，可以用本教程的位姿、速度、规划、驱动、动力学与反馈逐项分析；螺丝刀接触螺栓后，怎样限制接触力、怎样判断拧紧完成？这是原书力控制需要继续回答的问题，不能靠减小位置误差代替。先做[跨章回访](../training/two-link.md#mission-revisit)，检查自己能否分清位置教学模型、完整工具姿态与接触任务的边界。
