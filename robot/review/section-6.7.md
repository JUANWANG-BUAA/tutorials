# §6.7 操作空间动力学模型 · 审读记录

## 第二轮叙述修订（2026-11-15）

范围：`src/ch06/sec6-7.md` 全文。上下文读了 §6.6 出口、§7.1 与 §7.4 入口、`homework06b.md`（7-10）、第 8 周转录 01:36:48–01:55:00 及 `git show 9b93dd0:robot/src/ch06/sec6-7.md`。

### 问题与改法

| 位置（改前） | 读者会卡在哪 | 改法 |
|:--|:--|:--|
| 节首与 §6.7.1 L3–10 | 开篇直接给关节方程和局部可逆条件，未把老师 01:44:28–01:47:29 讲的两点背景（末端任务关联度高、多关节不直观）说具体 | 先从打磨/装配直接规定末端轨迹与接触力、而七个关节角看不出哪一方向抵住工件切入，说明为何要把速度、加速度和广义力一起换算到任务坐标 $\boldsymbol x$；再在 §6.7.1 交代局部非冗余分支（$r=n$、$J_A$ 可逆）与冗余情况（6.7.5）的分工 |
| §6.7.2 L15–30 | “欧拉角的导数不是角速度”（01:50:30–01:50:45）被压没了；$\boldsymbol F_A=T_A^{\mathrm T}\boldsymbol F$ 与 $\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol F_A$ 只给结论未写功率恒等式 | 恢复老师提醒（$\dot{\boldsymbol\phi}$ 不是物理角速度 $\boldsymbol\omega$，差 $\boldsymbol\omega=T(\boldsymbol\phi)\dot{\boldsymbol\phi}$）；写出功率守恒 $\boldsymbol F_A^{\mathrm T}\dot{\boldsymbol x}=\boldsymbol F^{\mathrm T}\boldsymbol v=\boldsymbol F^{\mathrm T}T_A\dot{\boldsymbol x}\Rightarrow\boldsymbol F_A=T_A^{\mathrm T}\boldsymbol F$ 及 $\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol F_A$；对 $\dot{\boldsymbol x}=J_A\dot{\boldsymbol q}$ 求导写出 $\ddot{\boldsymbol x}=J_A\ddot{\boldsymbol q}+\dot J_A\dot{\boldsymbol q}$ |
| §6.7.3 L36–50 | 从关节方程直接跳到 $\ddot{\boldsymbol x}$ 的展开式，缺少中间解出的 $\ddot{\boldsymbol q}$ | 分三步写出：① 左乘 $B^{-1}$ 解出 $\ddot{\boldsymbol q}=-B^{-1}C\dot{\boldsymbol q}-B^{-1}\boldsymbol g+B^{-1}J_A^{\mathrm T}(\boldsymbol\gamma_A-\boldsymbol h_A)$；② 左乘 $J_A$ 加 $\dot J_A\dot{\boldsymbol q}$ 代入 $\ddot{\boldsymbol x}$；③ 从右到左解释 $J_AB^{-1}J_A^{\mathrm T}$ 三步物理作用 |
| §6.7.4 L54–86 | 左乘 $B_A$ 移项的过程省略；9b6c8f5 删去了关节空间与操作空间五项对照表；动能算例未算出误写 $J_ABJ_A^{\mathrm T}$ 时的错误数值 | 补清 $B\succ 0$ 且 $J_A$ 行满秩时 $J_A^{\mathrm T}\boldsymbol a\neq\boldsymbol 0\Rightarrow\boldsymbol a^{\mathrm T}(J_AB^{-1}J_A^{\mathrm T})\boldsymbol a>0$ 的正定与可逆性证明；写出左乘 $B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}$ 并移项的中间式；恢复五项对照表，链向作业六·补 7-10 的 $\dot B_A-2C_A$ 反对称性；动能算例补出误写 $J_ABJ_A^{\mathrm T}=\operatorname{diag}(16,1/4)$ 会算出 $32.03125\ \mathrm J\neq 2.5\ \mathrm J$；保留 01:52:43 奇点/退化说明 |
| §6.7.5 L90–105 | “不意味着……也不意味着……”两连防御否定句；力矩零空间算例未写矩阵相乘中间步 | 去掉防御性排比，正面写出操作空间正逆解及需要核查的测量与限位条件；冗余部分写出 $J_AB^{-1}\boldsymbol v_0=[1\ 1]\operatorname{diag}(1/4,1)[1,-1]^{\mathrm T}=1/4-1=-3/4\neq 0$ 与 $\boldsymbol\tau_0=(4,-1)^{\mathrm T}$ 使 $J_AB^{-1}\boldsymbol\tau_0=0$ 的完整计算，以及投影阵 $N_\tau=I-J_A^{\mathrm T}B_AJ_AB^{-1}$ 的左乘验证 |
| §6.7.6 L112–124 | 上一轮删去了常见错误清单与默写点；检查理解 3 个答案挤成一段 | 恢复常见错误清单 5 条与默写点 4 条；检查理解核对改为 1–3 分条对应 |

### 清单核对

- 知识点：操作空间背景、几何雅可比 $J$ 与分析雅可比 $J_A$、$T_A$ 与功率对偶、分析加速度 $\ddot{\boldsymbol x}=J_A\ddot{\boldsymbol q}+\dot J_A\dot{\boldsymbol q}$、三步消元推导、$J_AB^{-1}J_A^{\mathrm T}$ 正定性证明、$B_A,C_A\dot{\boldsymbol x},\boldsymbol g_A$ 定义与对照表、动能不变性导出 $B_A=J_A^{-\mathrm T}BJ_A^{-1}$ 及二维算例（$2.5\ \mathrm J$）、奇点退化、操作空间正逆解、冗余机械手 $B_A(\boldsymbol q)$ 与动力学力矩零空间 $J_AB^{-1}\boldsymbol\tau_0=\boldsymbol 0$（含 $(-3/4)$ 反例与 $N_\tau$ 投影阵）。全部保留。
- 图：5 张纯课件图（`opspace-background.jpg`、`opspace-jacobians.jpg`、`opspace-BA.jpg`、`opspace-summary.jpg`、`opspace-redundant.jpg`）全部存在且保留（旧版不存在的 `opspace-board.jpg` 已移除）。
- 被引链接：`sec7-1.md`、`sec7-4.md`、`homework06b.md`、`summary.md`、`overview.md`、`preface-index.md`、`preface-notation.md` 均以 `sec6-7.md` 引用，小节结构 6.7.1–6.7.6 保持不变（`sec7-4.md:142` 引用“§6.7.5”）。
- 框与公式：`:::` 开 4 闭 4，`$$` 34 个，行内 `$` 212 个，全部配平；全文无 `——`、无防御套话。

### 复算（一次性 python）

- 动能算例：$B=\operatorname{diag}(4,1),J_A=\operatorname{diag}(2,1/2)\Rightarrow B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}=\operatorname{diag}(1,4)$；$\dot q=(1,1)^{\mathrm T},\dot x=(2,1/2)^{\mathrm T}\Rightarrow\frac12\dot q^{\mathrm T}B\dot q=\frac12\dot x^{\mathrm T}B_A\dot x=2.5\ \mathrm J$；误取 $J_ABJ_A^{\mathrm T}=\operatorname{diag}(16,1/4)$ 得 $\frac12(16\times 4+\frac14\times\frac14)=32.03125\ \mathrm J$。
- 力矩零空间：$B=\operatorname{diag}(4,1),J_A=[1,1]$，$B_A=(1/4+1)^{-1}=4/5$；$v_0=(1,-1)^{\mathrm T}$ 时 $J_AB^{-1}v_0=1/4-1=-3/4$；$\tau_0=(4,-1)^{\mathrm T}$ 时 $J_AB^{-1}\tau_0=1-1=0$；$N_\tau=I-J_A^{\mathrm T}B_AJ_AB^{-1}=\frac15[[4,-4],[-1,1]]$，验证 $J_AB^{-1}N_\tau=[0,0]$ 且 $N_\tau^2=N_\tau$。

### 需要同步的配套页（只列出，未改）

- `homework06b.md`（7-10）、`summary.md`、`ch07/sec7-4.md` 均与本节一致。
