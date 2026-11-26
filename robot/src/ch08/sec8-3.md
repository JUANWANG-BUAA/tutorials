# 8.3 阻抗与导纳：设计接触的过渡过程

上一节的柔顺控制只规定了最终停在哪里，没有约束靠近表面或遭遇冲击时的加减速响应与阻尼特性。为了在撞击瞬间吸收冲击、抑制弹跳，需要把静态的力–位移关系扩充为包含二阶惯性与一阶阻尼的动态方程——这正是**阻抗控制（Impedance Control）**与**导纳控制（Admittance Control）**的核心。

<a id="sec-8.3.1"></a>

## 8.3.1 从静态弹簧到二阶目标阻抗

设固定坐标下位置追踪误差为 $\tilde{\boldsymbol{x}} = \boldsymbol{x}_d - \boldsymbol{x}_e$（全文为清晰区分误差与自然指数，常用 $\tilde{\boldsymbol{x}}$ 或 $\boldsymbol{e}$ 记之）。阻抗控制希望在广义接触力 $\boldsymbol{h}_A$ 作用下，末端位姿误差呈现一个可由设计师人为指定的**质量–弹簧–阻尼**二阶系统响应：

$$M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A,$$

其中 $M_d, K_D, K_P \in \mathbb R^{6\times 6}$ 均为对称正定矩阵，依次称为**期望惯量矩阵**、**期望阻尼矩阵**（教材及文献亦常记为 $D_d$）与**期望刚度矩阵**。在单轴平动下，三者的量纲分别为 $\mathrm{kg}$、$\mathrm{N\cdot s/m}$ 与 $\mathrm{N/m}$。当系统静止时（$\ddot{\tilde{\boldsymbol{x}}} = \dot{\tilde{\boldsymbol{x}}} = \boldsymbol{0}$），上式立即退化为上一节的静态柔顺方程 $K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A$。注意，$M_d$ 是控制系统赋予末端的**虚拟惯量**，不必等于连杆真实的物理质量。

关于命名，必须预先交代清楚电路/机械类比中的**端口变量口径**：拉普拉斯域中，力与位置误差之比 $\boldsymbol{h}_A(s)/\tilde{\boldsymbol{x}}(s) = M_d s^2 + K_D s + K_P$ 严格来说是**动态刚度**；工程上经典的机械阻抗定义为力与速度之比 $\boldsymbol{h}_A(s)/\bigl(s\tilde{\boldsymbol{x}}(s)\bigr) = M_d s + K_D + K_P/s$，其倒数称为机械导纳。习惯上仍把以位移、速度误差映射到广义力的整套二阶模型统称为“目标阻抗方程”。

<a id="sec-8.3.2"></a>

## 8.3.2 为什么抵消原动力学还不够：惯量耦合与力测量解耦

把静态期望关系变成二阶系统，首先想到用第七章的逆动力学控制把非线性机器人线性化。但接触力 $-J^{\mathrm T}\boldsymbol{h}_e$ 挂在真实动力学右端，如果不加处理地沿用自由空间控制律，会发生什么？

::: thm 定理 8.3.1 · 逆动力学阻抗控制与接触力的完全解耦 {#thm-8.3.1}
设机械臂非奇异且任务维度与关节数匹配（$J_A(\boldsymbol{q})$ 可逆），记非线性合项 $\boldsymbol{n}(\boldsymbol{q},\dot{\boldsymbol{q}}) = C(\boldsymbol{q},\dot{\boldsymbol{q}})\dot{\boldsymbol{q}} + F\dot{\boldsymbol{q}} + \boldsymbol{g}(\boldsymbol{q})$，操作空间惯性矩阵 $B_A(\boldsymbol{q}) = J_A^{-\mathrm T}(\boldsymbol{q})B(\boldsymbol{q})J_A^{-1}(\boldsymbol{q})$。
1. **无接触力测量时**：取自由空间逆动力学控制律 $\boldsymbol{u} = B(\boldsymbol{q})\boldsymbol{y} + \boldsymbol{n}(\boldsymbol{q},\dot{\boldsymbol{q}})$ 与加速指令 $\boldsymbol{y} = J_A^{-1}\bigl[\ddot{\boldsymbol{x}}_d + M_d^{-1}(K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}}) - \dot J_A\dot{\boldsymbol{q}}\bigr]$，闭环仍残留构型相关的惯量耦合：
   $$M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = M_d B_A^{-1}(\boldsymbol{q})\boldsymbol{h}_A.$$
2. **引入精确力测量与双向配对后**：取带前馈力抵消的控制律并同步在加速度指令中引回目标响应力项：
   $$\boldsymbol{u} = B(\boldsymbol{q})\boldsymbol{y} + \boldsymbol{n}(\boldsymbol{q},\dot{\boldsymbol{q}}) + J^{\mathrm T}(\boldsymbol{q})\boldsymbol{h}_e, \qquad \boldsymbol{y} = J_A^{-1}\Bigl[\ddot{\boldsymbol{x}}_d + M_d^{-1}\bigl(K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} - \boldsymbol{h}_A\bigr) - \dot J_A\dot{\boldsymbol{q}}\Bigr],$$
   方可彻底消去真实惯性矩阵 $B_A(\boldsymbol{q})$，严格实现完全解耦的目标阻抗方程：
   $$M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A.$$
:::

**证明**：将 $\boldsymbol{u} = B\boldsymbol{y} + \boldsymbol{n}$ 代入[含接触动力学方程](sec8-1.md#def-8.1.1) $B\ddot{\boldsymbol{q}} + \boldsymbol{n} = \boldsymbol{u} - J^{\mathrm T}\boldsymbol{h}_e$，两边左乘 $B^{-1}$ 得 $\ddot{\boldsymbol{q}} = \boldsymbol{y} - B^{-1}J^{\mathrm T}\boldsymbol{h}_e$。再代入末端加速度运动学 $\ddot{\boldsymbol{x}}_e = J_A\ddot{\boldsymbol{q}} + \dot J_A\dot{\boldsymbol{q}}$ 与 $J = T_A J_A,\,\boldsymbol{h}_A = T_A^{\mathrm T}\boldsymbol{h}_e$：

$$\ddot{\boldsymbol{x}}_e = J_A\boldsymbol{y} + \dot J_A\dot{\boldsymbol{q}} - J_A B^{-1}J_A^{\mathrm T}\boldsymbol{h}_A.$$

注意到 $J_A B^{-1}J_A^{\mathrm T} = (J_A^{-\mathrm T} B J_A^{-1})^{-1} = B_A^{-1}(\boldsymbol{q})$。将情况 (1) 的 $\boldsymbol{y}$ 代入，整理 $\ddot{\tilde{\boldsymbol{x}}} = \ddot{\boldsymbol{x}}_d - \ddot{\boldsymbol{x}}_e$ 得 $\ddot{\tilde{\boldsymbol{x}}} = -M_d^{-1}(K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}}) + B_A^{-1}\boldsymbol{h}_A$，两边左乘 $M_d$ 即证 (1)。对于情况 (2)，外环增加 $+J^{\mathrm T}\boldsymbol{h}_e$ 先精确抵消了动力学方程中环境造成的真实扰动力，使 $\ddot{\boldsymbol{q}} = \boldsymbol{y}$ 还原为自由空间纯积分器；随后 $\boldsymbol{y}$ 内引入的 $-M_d^{-1}\boldsymbol{h}_A$ 再人为注入以**期望虚拟惯量 $M_d$**（而非真实惯量 $B_A$）响应接触力的柔性动态，于是 $\ddot{\tilde{\boldsymbol{x}}} = M_d^{-1}(\boldsymbol{h}_A - K_D\dot{\tilde{\boldsymbol{x}}} - K_P\tilde{\boldsymbol{x}})$，左乘 $M_d$ 即证 (2)。$\square$

这个推导带来一个极关键的工程警示：**如果只在外层加了 $+J^{\mathrm T}\boldsymbol{h}_e$ 来补偿接触反力，却忘记在内层 $\boldsymbol{y}$ 里引回 $-\boldsymbol{h}_A$**，接触力就会被当成外部扰动完全抵消，机器臂会显得“无限硬”而不是呈现柔顺。相反，若没有力传感器，尽管我们把 $M_d, K_D, K_P$ 都设成对角阵，闭环方程右端依然挂着非对角且随位形变化的矩阵 $M_d B_A^{-1}(\boldsymbol{q})$——此时各轴碰撞依然相互耦合，不过在已知构型附近仍可用 $M_d$ 的标称缩放来折衷。对于完整六维含大姿态任务，还须将位置误差替换成 [8.2.3 节](sec8-2.md#sec-8.2.3) 的相对位姿误差 $\boldsymbol{e}_d$ 与相对雅可比 $J_{Ad}$。

<a id="sec-8.3.example"></a>
<a id="sec-8.3.3"></a>

## 8.3.3 同一套阻抗参数碰到更硬的环境会发生什么

当完成力测量解耦后，单轴接触任务满足 $m_d(\ddot x_d - \ddot x_e) + d_d(\dot x_d - \dot x_e) + k_P(x_d - x_e) = f_e$。令目标参考点 $x_d$ 固定不动（$\ddot x_d = \dot x_d = 0$），并代入单边弹性接触分支 $f_e = k_e(x_e - x_r)$，移项整理后便看出环境刚度是如何改变闭环动态的：

$$m_d\ddot x_e + d_d\dot x_e + (k_P + k_e)x_e = k_P x_d + k_e x_r.$$

这是一阶跃响应完全可手算的标准二阶线性系统，接触方向上的无阻尼自然频率与阻尼比分别为：

$$\omega_n = \sqrt{\frac{k_P + k_e}{m_d}}, \qquad \zeta = \frac{d_d}{2\sqrt{m_d(k_P + k_e)}}.$$

::: ex 例 8.3.2 · 同一组阻抗参数接触两种刚度环境 {#ex-8.3.2}
沿用 [8.2.4 节](sec8-2.md#sec-8.2.4) 的环境与刚度设置：$x_r = 1.0\,\mathrm m$，$x_d = 1.1\,\mathrm m$，$k_P = 2500\,\mathrm{N/m}$，并取期望质量与阻尼 $m_d = 100\,\mathrm{kg}$、$d_d = 500\,\mathrm{N\cdot s/m}$。分别考察自由空间与两类弹性表面，计算接触方向的固有频率 $\omega_n$、阻尼比 $\zeta$ 与平衡接触力：

| 工况 / 环境刚度 $k_e$ | 总刚度 $k_P + k_e$ | 自然频率 $\omega_n$（$\mathrm{rad/s}$） | 阻尼比 $\zeta$ | 平衡接触力 $f_e$ |
|:--|:--|:--|:--|:--|
| 自由空间（$k_e = 0$） | $2500\,\mathrm{N/m}$ | $5.000$ | $0.500$ | $0\,\mathrm N$ |
| 较软表面（$k_e = 1000\,\mathrm{N/m}$） | $3500\,\mathrm{N/m}$ | $5.916$ | $0.423$ | $71.43\,\mathrm N$ |
| 较硬表面（$k_e = 10000\,\mathrm{N/m}$） | $12500\,\mathrm{N/m}$ | $11.180$ | $0.224$ | $200.00\,\mathrm N$ |

当环境刚度提高 10 倍，闭环自然频率超过翻倍（$5.92 \to 11.18\,\mathrm{rad/s}$），但阻尼参数 $d_d$ 不变导致阻尼比几乎砍半（$0.423 \to 0.224$），过渡曲线出现明显欠阻尼振荡。若希望在已知刚度 $k_e$ 下精确获得目标阻尼比 $\zeta_\star$，必须按该工况单独调整阻尼参数：

$$d_d = 2\zeta_\star\sqrt{m_d(k_P + k_e)}.$$
:::

由此可见，同一组常值阻抗参数通常不可能面对截然不同的工件表面都保持同样的稳健阻尼比。面对未知或过硬工件时，要么事先留足更大的 $d_d$ 裕度，要么结合在线环境刚度估计自适应整定阻尼，并且不能忽略底层执行器采样周期与力信号滤波带来的相位滞后。

<a id="sec-8.3.4"></a>

## 8.3.4 导纳控制：从工业位置内环绕行

前面的逆动力学阻抗控制需要精确动力学模型与力矩级控制接口，工程上许多工业机器人只开放**位置或速度指令接口**（内部已封闭高刚度位置环以抵抗关节摩擦与模型误差）。此时若希望强行让手腕在碰撞时退让，反而应反过来做：利用测力去**修改内层运动参考**——这就是**导纳控制（Admittance Control）**。

设原始名义目标为 $\boldsymbol{x}_d$，外层导纳环读取实测广义接触力 $\boldsymbol{h}_e$，对虚拟退让偏移量 $\boldsymbol{z} = \boldsymbol{x}_d - \boldsymbol{x}_t$ 实时积分求解外层虚拟二阶模型（一般直接写为固定基座/工具系）：

$$M_t\ddot{\boldsymbol{z}} + D_t\dot{\boldsymbol{z}} + K_t\boldsymbol{z} = \boldsymbol{h}_e, \qquad \boldsymbol{x}_t = \boldsymbol{x}_d - \boldsymbol{z}.$$

随后将退让后的兼容参考位置 $\boldsymbol{x}_t$ 及其速度 $\dot{\boldsymbol{x}}_t$、加速度 $\ddot{\boldsymbol{x}}_t$ 喂给高带宽的内层位置/运动控制器跟踪。遇到阻力 $\boldsymbol{h}_e$ 增大时，虚拟偏移量 $\boldsymbol{z}$ 增大，送给机器臂的位置指令 $\boldsymbol{x}_t$ 顺势往后退，使真实末端展现柔顺行为。

| 比较维度 | 阻抗控制（Impedance） | 导纳控制（Admittance） |
|:--|:--|:--|
| **信号因果方向** | 运动/偏差输入 $\longrightarrow$ 计算驱动力矩输出 | 实测力输入 $\longrightarrow$ 生成退让位置/速度参考输出 |
| **依赖的底层接口** | 关节力矩（电流）控制 + 逆动力学前馈 | 高增益位置/速度内环 + 外环积分器 |
| **外环/内环条件** | 内层带宽由力矩伺服决定，需力传感器消除 $B_A$ 耦合 | 必须满足“**内快外慢**”与内环无静差跟踪，才能使真实末端逼近虚拟模型 |
| **适用环境倾向** | 适合**刚硬环境**（力反馈无需经过高刚度位置内环积分） | 适合有摩擦与未建模误差的自重臂在**较软环境**中实现精确柔顺运动；硬表面容易因离散延迟发散 |

需留意：虽然内快外慢是导纳逼近理想模型的常规工程准则，但面对极硬表面时，外环有限采样与滤波延迟加上刚度增益，仍可能引发高频振荡甚至失稳，不能把稳态条件当成无条件稳定性保证。

<details>
<summary>检查理解：系统已经装了力传感器，还有外层二阶动力学方程，为什么仍不属于直接力控制？</summary>

判断归属看**控制目标**而非传感器配置。导纳控制的输入固然是实测接触力，但其算法把力换算成一条“愿意退让的位置轨迹 $\boldsymbol{x}_t$”，系统并没有独立的期望力设定值 $\boldsymbol{h}_d$，也没有调节 $\boldsymbol{h}_d - \boldsymbol{h}_e \to \boldsymbol{0}$ 的反馈闭环；真正控制的仍是力与偏移量之间的刚度-阻尼-惯量比值关系。

</details>

单轴接触模型以及下文直接力控的数值验证可参考[配套脚本](../assets/code/ch08-contact.py)（使用与扩展说明见[章末习题](exercises.md)）。

## 8.3 小结与常见错误

- **一条主线**：阻抗把静态柔顺扩充为二阶模型 $M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A$；不测力直接用自由空间逆动力学补偿会遗留 $M_d B_A^{-1}\boldsymbol{h}_A$ 惯量耦合，必须在关节外环加 $+J^{\mathrm T}\boldsymbol{h}_e$ 同时在加速度指令里引回 $-\boldsymbol{h}_A$ 才能干净解耦。
- **核心反直觉**：同一阻尼参数碰到更硬表面时，总刚度升 $\implies$ 固有频率 $\omega_n$ 上升而阻尼比 $\zeta$ 下降，碰撞更容易振。
- **因果对偶**：阻抗是“位置进、力出”（直接输出力矩），导纳是“力进、位置出”（喂给封闭位置内环），两者的强弱环境互补。
- **下一节**：[8.4 直接力控制](sec8-4.md) 不满足于规定力–位移关系，正式建立以给定力 $\boldsymbol{h}_d$ 为基准的力误差闭环。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| 阻抗关系：$M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = \boldsymbol{h}_A$ | 非奇异、功率配对广义力 | $\mathrm N,\mathrm{N\cdot m}$ | 区分动态刚度（对位移）与机械阻抗（对速度）的命名口径 |
| 无测力耦合：$M_d\ddot{\tilde{\boldsymbol{x}}} + K_D\dot{\tilde{\boldsymbol{x}}} + K_P\tilde{\boldsymbol{x}} = M_d B_A^{-1}\boldsymbol{h}_A$ | $u = B\boldsymbol{y} + \boldsymbol{n}$、未补偿接触力 | — | 加 $+J^{\mathrm T}\boldsymbol{h}_e$ 补偿却漏掉内层 $-\boldsymbol{h}_A$ 会变成绝对抗扰而不是柔顺 |
| 频率与阻尼比：$\omega_n = \sqrt{\dfrac{k_P + k_e}{m_d}}$，$\zeta = \dfrac{d_d}{2\sqrt{m_d(k_P + k_e)}}$ | 单轴接触、固定 $x_d$ | $\mathrm{rad/s}$、无量纲 | $d_d$ 不随环境自适应时，高刚度接触表面 $\zeta$ 显著偏低 |
| 导纳模型：$M_t\ddot{\boldsymbol{z}} + D_t\dot{\boldsymbol{z}} + K_t\boldsymbol{z} = \boldsymbol{h}_e$，$\boldsymbol{x}_t = \boldsymbol{x}_d - \boldsymbol{z}$ | 内层运动环带宽远大于外环 | $\mathrm m$ | 内快外慢只是渐近理想，硬接触下延迟易引发振荡 |

::: think 常见错误清单 · 自查三条
1. 只给关节力矩加 $+J^{\mathrm T}\boldsymbol{h}_e$ 抵消外力，忘了把 $-\boldsymbol{h}_A$ 放进 $\boldsymbol{y}$：接触力全被硬扛掉，末端丧失期望柔顺度。
2. 拿同一套 $m_d, d_d, k_P$ 当成对所有未知工件都能取得相同阻尼比：$\zeta$ 与 $\sqrt{k_P + k_e}$ 成反比。
3. 硬把导纳控制当成直接力控：只要控制环的目标是给定力与偏移之间的比例/动态关系，而不是直接消除 $f_d - f_e$，就是间接力控制。
:::
