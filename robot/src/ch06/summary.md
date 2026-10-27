# 第六章总结 · 动力学

> 这一章只做了一件事：**把「要多大的力矩」写成关节变量的显式函数**。
> 从 $L=T-U$ 出发，经过动能/势能、拉格朗日方程、两条结构性质、两个算例，
> 最后落在 $B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}
> +\boldsymbol g(\boldsymbol q)=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e$ 这一行上。
> 下面把这一行拆成「记住什么、怎么用、容易错在哪」。

## 一页公式

### 拉格朗日

$$L=T-U,\qquad
\frac{\mathrm d}{\mathrm dt}\Bigl(\frac{\partial L}{\partial\dot q_i}\Bigr)-\frac{\partial L}{\partial q_i}=\xi_i.$$

### 动能

$$T=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q},$$

$$B=\sum_{i=1}^{n}\Bigl[m_iJ_P^{(i)\mathrm T}J_P^{(i)}
+J_O^{(i)\mathrm T}\boldsymbol R_i\boldsymbol I_i^i\boldsymbol R_i^{\mathrm T}J_O^{(i)}
+m_{m_i}J_P^{(m_i)\mathrm T}J_P^{(m_i)}
+J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}\Bigr].$$

$B$ 对称、正定、一般随位形变。

### 势能与重力矩

$$U=-\sum_{i=1}^{n}\bigl(m_i\boldsymbol g_0^{\mathrm T}\boldsymbol p_i
+m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i}\bigr),\qquad
\boldsymbol g(\boldsymbol q)=\frac{\partial U}{\partial\boldsymbol q}.$$

左端重力项与实际重力广义力的关系为

$$\boldsymbol\tau_{\mathrm{grav}}=\sum_i\bigl(m_iJ_P^{(i)\mathrm T}\boldsymbol g_0
+m_{m_i}J_P^{(m_i)\mathrm T}\boldsymbol g_0\bigr)=-\boldsymbol g(\boldsymbol q).$$

静止、无摩擦及其他外力时，保持输入为 $\boldsymbol\tau=\boldsymbol g$。
若两种力矩的符号仍混淆，先做 [单摆双路径例题](sec6-1-2.md#ex-6.1.2.A)，
再比较 [同一位形下保持、释放与加速](sec6-1-3.md#ex-6.1.3.A) 的三种输入。

### 运动方程

$$B\ddot{\boldsymbol q}+C\dot{\boldsymbol q}+F_{\mathrm v}\dot{\boldsymbol q}
+F_{\mathrm s}\operatorname{sgn}\dot{\boldsymbol q}+\boldsymbol g
=\boldsymbol\tau-J^{\mathrm T}\boldsymbol h_e,$$

$$h_{ijk}=\frac{\partial b_{ij}}{\partial q_k}-\frac12\frac{\partial b_{jk}}{\partial q_i},\qquad
\sum_jc_{ij}\dot q_j=\sum_{j,k}h_{ijk}\dot q_k\dot q_j.$$

### 两条结构性质

$$\text{Christoffel 选法：}\ N=\dot B-2C\ \text{反对称}
\ \Longleftrightarrow\ \forall\boldsymbol w,\ \boldsymbol w^{\mathrm T}N\boldsymbol w=0;$$

$$\text{任意选法：}\ \dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0\ \text{（能量守恒）}.$$

$$\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\,\boldsymbol\pi,
\qquad \boldsymbol\pi\ \text{每连杆 11 个参数（含摩擦 13 个）}.$$

### 两个算例

| | 笛卡儿臂 | 平面臂 |
|:--|:--|:--|
| $B$ | 常数对角 | $B(\vartheta_2)$，非对角 |
| $C$ | $O$ | $h=-m_2a_1\ell_2s_2$ 生成 |
| $g$ | $g_1=(m_1+m_{m_2}+m_2)g,\ g_2=0$ | 两项，含 $c_1,c_{12}$ |
| 耦合 | 无 | 有（$b_{12},C$） |

## 6.4–6.7 速览（第 8 周补入）

| 节 | 一句话 | 必记 |
|:--|:--|:--|
| [6.4 牛顿–欧拉递推](sec6-4.md) | 逐杆列方程，向外递推运动量、向内递推力/力矩 | 六类递推式（$\omega,\dot\omega,\dot p,\ddot p,\ddot p_C,\dot\omega_m$）、$\tau_i$ 投影、$O(n)$ |
| [6.5 正解与逆解](sec6-5.md) | 正解解 $B\ddot q=\tau-\tau'$（要数值积分），逆解只代入 | 正解用于仿真、逆解用于控制与轨迹校验 |
| [6.6 轨迹的动态标度](sec6-6.md) | 力矩超限时拉长时间，轨迹形状不变 | $q=\bar q(r(t))$、$\tau_s=c^2\bar\tau_s$ |
| [6.7 操作空间动力学](sec6-7.md) | 把关节空间模型搬到末端位姿 | $\ddot x_e=J_A\ddot q+\dot J_A\dot q$、$B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}$、$\tau=J_A^{\mathrm T}\tau_x$ |

**与两条路线的接口**：6.4 用递推重算同一组 $B,C,g$；6.5 把「给定运动求力」与「给定力求运动」分开；
6.6 用逆解检查规划可行性；6.7 把模型交给第七章的操作空间控制。四节合起来回答一个问题：
**本章的模型怎样用于仿真、规划与控制。**

## 三句话总结

1. **动力学 = 能量 + 拉格朗日方程**：写出 $T=\frac12\dot q^{\mathrm T}B\dot q$ 与 $U(q)$，
   代公式就得到关于 $q$ 的二阶微分方程；约束力自动消失，非保守力补右端。
2. **两条结构性质比公式本身更重要**：$\dot B-2C$ 反对称（能量/无源性），$\tau=Y\pi$ 线性
   （参数辨识/自适应）；前者管稳定性，后者管「模型从哪来」。
3. **算例是检验理解的唯一标准**：笛卡儿臂的「解耦」与平面臂的「耦合」是同一套公式的两个极端；
   能手算平面臂的 $B,C,g$，这一章才算真正会了。

## 知识地图（本章在全书中的位置）

```text
第 2 章 运动学 ──→ 第 3 章 微分运动学/静力学 ──→ 第 5 章 执行器与传感器
        │                    │                          │
        └────────────┬───────┴──────────────┬───────────┘
                     ↓                      ↓
              第 6 章 动力学（本章）   第 4 章 轨迹规划（参考输入）
                     │
                     ├─ 前馈：τ_ff = B q̈_d + C q̇_d + g（计算力矩）
                     ├─ 参数辨识：τ = Yπ → 最小二乘
                     └─ 第七编 运动控制（原书第 8 章）：反馈 + 前馈补偿
```

**下一编[第七章 · 运动控制](../ch07/overview.md)（原书第 8 章）会反复用到本章的三样东西**：$B$ 的正定性（控制器增益设计）、
$\dot B-2C$ 的反对称性（Lyapunov 稳定性）、$\boldsymbol g$ 的显式表达（重力补偿）。
如果这一章只记了公式而没理解这三条，第七编会变成「背控制律」。

## 常见错误总表

| # | 错误 | 纠正 |
|:--|:--|:--|
| 1 | 漏掉转子动能 $k_r^2I_m$ | 转子角速度是 $k_r\dot q$，平方后进动能 |
| 2 | 势能写成 $\dot q$ 的函数 | $U=U(q)$，与速度无关 |
| 3 | 把 $b_{ii}$ 当成连杆 $i$ 自己的惯量 | 是「锁住其他关节时关节 $i$ 看到的惯量」，含后面所有连杆 |
| 4 | $C$ 当成唯一 | 只有 $C\dot q$ 唯一；Christoffel 选法只是其中一种 |
| 5 | 把 $\dot q^{\mathrm T}N\dot q=0$ 当成 $N$ 反对称 | 前者对任意 $C$ 成立，后者只对 Christoffel 选法 |
| 6 | 11 / 13 / 最小参数集混用 | 11 刚体参数；13 含摩擦；最小集更小 |
| 7 | 平面臂 $b_{12}$ 漏 $k_{r_2}I_{m_2}$ | 转子 2 的总角速度含 $\dot\vartheta_1$ |
| 8 | 末端力符号搞反 | $\boldsymbol h_e$ 是末端对环境；执行器需额外 $+J^{\mathrm T}\boldsymbol h_e$ |
| 9 | 笛卡儿臂也套 Christoffel | $B$ 常数 ⇒ $C=0$，不必算 |
| 10 | 忘记 $Y$ 依赖 $\ddot q$ | 回归矩阵的自变量是 $q,\dot q,\ddot q$ |

## 学完自检

::: think 十问自检（能答八问即可进入原书第 8 章）
1. 拉格朗日方程为什么不需要画受力图？约束力去哪了？
2. 写出 $T_i$ 的三块分解，并说明交叉项为什么为零。
3. 惯性张量在基座系与连杆系中有什么区别？平行轴定理怎么写？
4. $B$ 的三条性质是什么？各自由什么保证？
5. 写出 $h_{ijk}$ 与 $C$ 的关系；$C$ 为什么不唯一？
6. 证明 $\dot B-2C$ 反对称；说明 $\dot q^{\mathrm T}N\dot q=0$ 为什么对任意 $C$ 成立。
7. 「11 个参数」与「13 个参数」各包含什么？
8. 笛卡儿臂为什么解耦？平面臂为什么不解耦？
9. 写出平面臂的 $B(q)$、$C$、$g$，并解释 $b_{22}$ 为什么是常数。
10. 末端力如何进方程？$J^{\mathrm T}$ 的物理意义是什么？
:::

## 与前后章的接口

- **向前**（第 3、4、5 章）：雅可比 $J_P,J_O$ 来自第 3 章；轨迹规划的 $q_d,\dot q_d,\ddot q_d$
  是动力学的输入（第 4 章）；执行器的力矩/摩擦模型来自第 5 章。
- **向后**（原书第 8 章及以后）：运动控制的「计算力矩法」直接用本章的 $B,C,g$；
  力控制用 $J^{\mathrm T}$ 把末端力折回关节；自适应控制用 $\tau=Y\pi$ 的线性性。
- **实验**：`tools/verify_homework06.py` 复算了作业 7-2 / 7-6 / 7-7 的关键数值，
  可作为修改公式后的回归测试。
