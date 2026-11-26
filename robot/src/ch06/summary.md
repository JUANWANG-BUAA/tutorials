# 第六章总结 · 动力学

> 本章建立关节空间与操作空间的刚体动力学模型，回答两类工程问题：**已知运动求所需关节驱动力矩（逆动力学）** 与 **已知驱动力矩积分预测后续运动（正动力学）**。全章的主干结论集中在能量构造、一条主方程、两条代数结构性质、两个两连杆算例以及 $O(n)$ 递推引擎上。

## 一页核心公式

### 1. 拉格朗日能量构造与关节空间主方程（6.1）

$$\mathcal L = T - U,\qquad \frac{\mathrm d}{\mathrm dt}\!\left(\frac{\partial\mathcal L}{\partial\dot q_i}\right)-\frac{\partial\mathcal L}{\partial q_i}=\xi_i,\qquad T=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q},$$

$$B(\boldsymbol q) = \sum_{i=1}^{n}\Bigl(m_{\ell_i}J_P^{(\ell_i)\mathrm T}J_P^{(\ell_i)} + J_O^{(\ell_i)\mathrm T}\boldsymbol R_i\boldsymbol I_{\ell_i}^i\boldsymbol R_i^{\mathrm T}J_O^{(\ell_i)} + m_{m_i}J_P^{(m_i)\mathrm T}J_P^{(m_i)} + J_O^{(m_i)\mathrm T}\boldsymbol R_{m_i}\boldsymbol I_{m_i}^{m_i}\boldsymbol R_{m_i}^{\mathrm T}J_O^{(m_i)}\Bigr),$$

$$U(\boldsymbol q) = -\sum_{i=1}^{n}\bigl(m_{\ell_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{\ell_i}+m_{m_i}\boldsymbol g_0^{\mathrm T}\boldsymbol p_{m_i}\bigr),\qquad \boldsymbol g(\boldsymbol q)=\left(\frac{\partial U}{\partial\boldsymbol q}\right)^{\mathrm T} = -\boldsymbol\tau_{\mathrm{grav}}.$$

代入并移项整理得到完整封闭运动方程：

$$\boxed{\ B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau-J^{\mathrm T}(\boldsymbol q)\boldsymbol h_e\ }$$

- **符号约定核对**：$\boldsymbol h_e$ 为末端施于环境的广义力；$\boldsymbol g(\boldsymbol q)$ 放在左端代表静平衡所需补偿输入（静止无外力时输入 $\boldsymbol\tau=\boldsymbol g$），参见[单摆双路径例题](sec6-1.md#ex-6.1.2.A)与[三工况力矩对比](sec6-1.md#ex-6.1.3.A)。

### 2. 两条控制与辨识关键结构性质（6.2）

- **第一类 Christoffel 符号与反对称性**：

$$c_{ijk}(\boldsymbol q)=\frac12\!\left(\frac{\partial b_{ij}}{\partial q_k}+\frac{\partial b_{ik}}{\partial q_j}-\frac{\partial b_{jk}}{\partial q_i}\right),\qquad c_{ij}=\sum_{k=1}^n c_{ijk}\dot q_k.$$

  Christoffel 选法保证 $N=\dot B-2C$ 对一切 $\boldsymbol w$ 严格反对称（$\boldsymbol w^{\mathrm T}N\boldsymbol w=0$）；任意满足相同 $C\dot{\boldsymbol q}$ 乘积的合法矩阵仅保证沿运动方向 $\dot{\boldsymbol q}^{\mathrm T}N\dot{\boldsymbol q}=0$（能量守恒），不能反推反对称。

- **惯性参数线性化**：借扩展连杆相对关节原点的锁转惯量、一阶矩与转子自转惯量构建每组 11 维（加两项摩擦共 13 维）参数 $\boldsymbol\pi$，无接触时形成块上三角线性回归方程 $\boldsymbol\tau=Y(\boldsymbol q,\dot{\boldsymbol q},\ddot{\boldsymbol q})\boldsymbol\pi$，可用线性最小二乘与奇异值分析求最小可辨识参数集。

### 3. 两个两连杆对照算例（6.3）

| 对照指标 | 正交笛卡儿臂（PR/PP） | 平面 2R 转动臂 |
|:--|:--|:--|
| 惯性矩阵 $B$ | 常数对角阵 | $B(\vartheta_2)$ 非对角且随构型变；$b_{22}$ 常值；$b_{12}$ 含 $k_{r_2}I_{m_2}$ |
| 速度耦合 $C$ | $O$（无离心/科氏项） | 由 $h=-m_2a_1\ell_2s_2$ 生成完整离心与科氏耦合 |
| 解耦与线性化 | 完全解耦（平动 + 轴正交缺一不可） | 强耦合；22 个名义惯性参数可缩为 8 参数（最小独立 5 组合） |

### 4. 牛顿–欧拉递推及工程衍生专题（6.4–6.7）

- **牛顿–欧拉 $O(n)$ 两遍递推（6.4）**：先取虚拟基座线加速度 $\ddot{\boldsymbol p}_0=-\boldsymbol g_0$（不重复显式加重力）从 $i=1\to n$ 向外递推连杆与转子运动量，再自 $i=n\to 1$ 由牛顿/欧拉平衡与轴投影式算出 $\boldsymbol f_i,\boldsymbol\mu_i,\tau_i$（$\boldsymbol\mu_i$ 对 $O_{i-1}$ 而 $\boldsymbol\mu_{i+1}$ 对 $O_i$）。
- **正解与逆解（6.5）**：逆解直接代数或递推求力矩；正解求解 $\ddot{\boldsymbol q}=B^{-1}(\boldsymbol\tau-\boldsymbol\tau')$ 并数值积分，可利用 $\operatorname{RNE}$ 分别置 $\ddot{\boldsymbol q}=\boldsymbol 0$ 与 $\boldsymbol e_j$ 采样组阵 $B$。
- **动态标度（6.6 选学）**：沿原轨迹做时间映射 $\boldsymbol q=\bar{\boldsymbol q}(r(t))$，拉长总时长 $T$ 倍时（$r=t/T$）动态分量缩放 $1/T^2$，重力项不变。
- **操作空间模型（6.7 选学）**：$J_A$ 满行秩下 $B_A=(J_AB^{-1}J_A^{\mathrm T})^{-1}$，满足 $\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol\gamma_A$；冗余自由度存在零空间内部动能（任务空间二次型为伪动能）且 $B_A$ 仍可能依赖内部构型。

## 知识衔接与自检要点

```text
第 2–3 章（几何运动学与雅可比） + 第 5 章（执行器折算与摩擦）
                   │
                   ▼
          第 6 章 动力学模型（B, C, g；O(n) RNE；τ = Yπ）
                   │
      ┌────────────┼────────────┐
      ▼            ▼            ▼
  前馈/计算力矩  Lyapunov 稳定   自适应参数辨识
  （7.3–7.4 节） （Ḃ-2C 反对称）  （最小二乘与自适应律）
```

在进入[第七章 · 运动控制](../ch07/overview.md)前确认三点物理直觉：当机械臂末端换持未知载荷时，由于质量矩与惯量同时改变，$B,C,\boldsymbol g$ 全数失准，下一章将利用第 5 章位置/速度测量设计关节空间反馈与[自适应控制](../ch07/sec7-4.md)，并结合本章的 $\dot B-2C$ 反对称性证明跟踪误差收敛。

## 全章常见错误排查表

| # | 高频误区 | 正确基准 |
|:--|:--|:--|
| 1 | 漏算电机转子 $k_r^2I_m$（尤其平面臂 $b_{12}$ 中的 $k_{r_2}I_{m_2}$） | 转子角速度含连杆牵连转速 $\boldsymbol\omega_{i-1}$ 叠加自转 $k_{r_i}\dot q_i\boldsymbol z_{m_i}$ |
| 2 | 混淆重力补偿项 $\boldsymbol g$ 与实际重力 $\boldsymbol\tau_{\mathrm{grav}}$ | 左端重力项 $\boldsymbol g=\partial U/\partial\boldsymbol q$；静止悬停输入 $\boldsymbol\tau=\boldsymbol g=-\boldsymbol\tau_{\mathrm{grav}}$ |
| 3 | 以为 $\dot{\boldsymbol q}^{\mathrm T}(\dot B-2C)\dot{\boldsymbol q}=0$ 等价于 $\dot B-2C$ 反对称 | 前者恒成立仅反映能量守恒，后者仅对 Christoffel 等特定选法对任意 $\boldsymbol w$ 成立 |
| 4 | 把 $b_{ii}$ 误解为仅连杆 $i$ 自身转动惯量 | $b_{ii}$ 是锁死其余关节后驱动轴 $i$ 看到的下游全质量等效惯量 |
| 5 | 牛顿–欧拉里参考点混用或重力加两遍 | $\boldsymbol\mu_i$ 对 $O_{i-1}$、$\boldsymbol\mu_{i+1}$ 对 $O_i$ 需补力臂；设 $\ddot{\boldsymbol p}_0=-\boldsymbol g_0$ 即已含重力 |
| 6 | 混淆 11 / 13 / 最小参数集口径 | 每组名义 11 惯性参数，含摩擦 13 参数；平面臂 8 参数仍可归并为 5 独立组合 |
| 7 | 认为“放慢动作总能降低总力矩需求” | 动态分量按 $1/T^2$ 降低，但重力不变；若动态项原与重力相抵，放慢反而增大净力矩 |

- **配套数值核验脚本**：`tools/verify_homework06.py` 覆盖作业 7-2、7-6、7-7；`tools/verify_homework06b.py` 覆盖作业 7-8 三路线互校与 7-10 操作空间反对称性。
