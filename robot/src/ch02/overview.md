# 第二章 · 运动学

本章建立刚体位姿描述与串联／闭链机械手运动学的完整数学框架，回答两个核心问题：**给定关节变量 $\boldsymbol q$，如何严格描述并计算末端执行器的三维位姿 $T_e^b(\boldsymbol q)$（正运动学）；给定目标位姿 $(\boldsymbol p_e, R_e)$，何时存在封闭解析解并如何系统求取全部分支（逆运动学）。**

全文以特殊正交群 $SO(3)$ 与特殊欧几里得群 $SE(3)$ 为几何底座，统一采用右手坐标系、列向量表达与**「右下在右上」**上下标读法，并在各节明确每条公式的适用前提、奇异边界与退化条件。

---

## 一、核心符号与术语对照表

| 符号 | 中文名称 | 物理与几何含义（含上下标读法） | 维度 / 单位 / 坐标系 |
|:--|:--|:--|:--|
| $\boldsymbol o',\ \boldsymbol p^i,\ \boldsymbol d^i$ | 位置向量、点坐标、自由方向 | 上标 $i$ 表示在系 $i$ 中表达；$\boldsymbol o'$ 为动系原点位置；齐次坐标点末位取 $1$、自由方向取 $0$ | $\mathbb R^3$；位置 $\mathrm m$，方向无量纲 |
| $R,\ R_j^i,\ SO(3)$ | 旋转矩阵、特殊正交群 | **读法「右下在右上」**：$R_j^i$ 的三列是系 $j$ 三轴在系 $i$ 中的方向余弦；$R^{\mathrm T}R=I_3,\ \det R=+1$ | $\mathbb R^{3\times 3}$；无量纲 |
| $\boldsymbol\phi=[\varphi,\vartheta,\psi]^{\mathrm T}$ | 欧拉角（ZYZ / RPY） | ZYZ 绕当前轴 $z\text{-}y'\text{-}z''$ 右乘；RPY 绕固定轴 $x\text{-}y\text{-}z$ 左乘（偏航 $\varphi$、俯仰 $\vartheta$、滚转 $\psi$） | $\mathbb R^3$；$\mathrm{rad}$ 或度 |
| $(\vartheta,\boldsymbol r)$ | 角和轴参数 | 绕单位轴 $\boldsymbol r$ 按右手定则转角 $\vartheta$；满足 $\|\boldsymbol r\|=1$ 与等价关系 $R(-\vartheta,-\boldsymbol r)=R(\vartheta,\boldsymbol r)$ | $\mathrm{rad}$ 与 $\mathbb R^3$（单位轴） |
| $S(\boldsymbol\omega),\ so(3)$ | 反对称矩阵与李代数 | $S(\boldsymbol\omega)\boldsymbol p=\boldsymbol\omega\times\boldsymbol p$，$S^{\mathrm T}=-S$；$so(3)$ 为 $SO(3)$ 在 $I_3$ 处的切空间 | $\mathbb R^{3\times 3}$；$\exp:so(3)\to SO(3)$ |
| $Q=\{\eta,\boldsymbol\epsilon\}$ | 单位四元数（欧拉参数） | $\eta=\cos(\vartheta/2)$，$\boldsymbol\epsilon=\sin(\vartheta/2)\boldsymbol r$；$\eta^2+\|\boldsymbol\epsilon\|^2=1$，$Q\sim -Q$ 双重覆盖 $SO(3)$ | $S^3\subset\mathbb R^4$；Hamilton 约定 |
| $A_j^i,\ T_j^i,\ SE(3)$ | 齐次变换矩阵与欧氏群 | $A_j^i=\begin{bmatrix}R_j^i&\boldsymbol o_j^i\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$ 表示系 $j$ 相对系 $i$ 的位姿；连乘时相邻上下标对消 | $\mathbb R^{4\times 4}$；底行 $[0,0,0,1]$ |
| $T_0^b,\ T_n^0,\ T_e^n,\ T_e^b$ | 基座 / DH 链 / 工具 / 总正解 | $T_0^b$（系 $0$ 在基座系 $b$ 中）、$T_n^0=A_1^0\cdots A_n^{n-1}$、$T_e^n$（工具在末杆中）、$T_e^b=T_0^b T_n^0 T_e^n$ | $\mathbb R^{4\times 4}$；由右向左 $e\to n\to 0\to b$ |
| $z_{i-1},\ o_i,\ o'_i,\ \{i'\}$ | 看守轴、原点、垂足与过渡系 | 系 $i-1$ 的 $z_{i-1}$ 沿**关节 $i$** 轴线；公垂线交 $z_{i-1}$ 于 $o'_i$、交 $z_i$ 于 $o_i$；$\{i'\}$ 为中间系 | 空间轴线与原点；$\{i\}$ 固连连杆 $i$ |
| $a_i,\ \alpha_i,\ d_i,\ \vartheta_i$ | 标准 DH 四参数 | $a_i\ge 0$ 沿 $x_i$、$\alpha_i$ 绕 $x_i$（恒常数）；$d_i$ 沿 $z_{i-1}$（P 变量）、$\vartheta_i$ 绕 $z_{i-1}$（R 变量），每行 3 常 1 变 | $\mathrm m,\ \mathrm{rad}$ |
| $c_i,s_i,c_{ij},s_{123}$ | 三角函数简写 | $c_i=\cos\vartheta_i,\ s_i=\sin\vartheta_i$；多下标表**角度相加**，如 $c_{23}=\cos(\vartheta_2+\vartheta_3),\ s_{123}=\sin(\vartheta_1+\vartheta_2+\vartheta_3)$ | 无量纲标量 |
| $\boldsymbol n_e,\boldsymbol s_e,\boldsymbol a_e,\boldsymbol p_e$ | 夹爪三轴与工具原点 | $T_e^b$ 前三列：接近轴 $\boldsymbol a_e$、滑移轴 $\boldsymbol s_e$、法向 $\boldsymbol n_e=\boldsymbol s_e\times\boldsymbol a_e$；第 4 列位置 $\boldsymbol p_e$ | 基座系 $b$ |
| $\boldsymbol x_e=k(\boldsymbol q),\ n,m,r$ | 操作空间与三类维数 | $n$ 关节数；$m$ 完整位姿独立维数；$r\le m$ 任务维数；$\mathcal W_D\subseteq\mathcal W_R\subset\mathbb R^3$ | $n,m,r\in\mathbb Z^+$ |
| $\boldsymbol\xi\in\mathbb R^p,\ \Phi_k^*$ | 标定参数与设计矩阵 | $p\le 4n$ 为可辨识子集维数；$\Phi_k^*\in\mathbb R^{tm\times p}$ 为 $t$ 组量测堆叠后的灵敏度矩阵 | 需 $tm\ge p$ 且 $\operatorname{rank}\Phi_k^*=p$ |
| $\boldsymbol p_w=\boldsymbol p_e-d_6\boldsymbol a_e$ | 球形腕腕心位置 | 三腕轴交点（腕心 $W$），沿接近轴回退外移长 $d_6$ 得到（仅对沿末轴偏置工具成立） | $\mathbb R^3$；$\mathrm m$；基座系 |

---

## 二、十二节架构与核心公式索引

| 节次与优先级 | 核心公式 / 结论 | 前提条件与边界要点 |
|:--|:--|:--|
| **[2.1 刚体的姿态](sec2-1.md)** · `了解·精简` | $9$ 个方向余弦受 $6$ 条正交归一约束剩 $3$ 自由度；右手性 $\boldsymbol x'\times\boldsymbol y'=\boldsymbol z'$ | 区分固定起点位置向量（带单位 $\mathrm m$）与自由方向（无量纲）；单轴不能确定完整姿态 |
| **[2.2 旋转矩阵](sec2-2.md)** · `核心必考` | $R^{\mathrm T}R=I_3,\ R^{-1}=R^{\mathrm T},\ \det R=+1$；$R_x,R_y,R_z$ 与 $R_k(-\vartheta)=R_k^{\mathrm T}(\vartheta)$ | 兼具姿态描述、被动换坐标（$\boldsymbol p^0=R_1^0\boldsymbol p^1$）与主动旋转算子三重身份；仅查模长无法分辨 $R$ 与 $R^{\mathrm T}$ |
| **[2.3 旋转矩阵的合成](sec2-3.md)** · `核心必考` | 当前轴右乘 $R_{\rm new}=RB$；固定轴左乘 $R_{\rm new}=SR$；$R_n^0=R_1^0 R_2^1\cdots R_n^{n-1}$ | 换系满足 $B=R^{\mathrm T}SR$；仅从 $I_3$ 出发固定轴与成对倒序当前轴等价；一般旋转不可交换 |
| **[2.4 欧拉角：ZYZ 与 RPY](sec2-4.md)** · `核心必考` | ZYZ：$R_z(\varphi)R_y(\vartheta)R_z(\psi)$；RPY：$R_z(\varphi)R_y(\vartheta)R_x(\psi)$；$\|\nabla\operatorname{Atan2}\|=1/\rho$ | ZYZ 于 $\vartheta=0,\pi$ 分定和/差；RPY 于 $\vartheta=\pm\pi/2$ 分定差/和；$\operatorname{Atan2}$ 保留象限但不消除表示奇点 |
| **[2.5 角和轴与 $so(3)$](sec2-5.md)** · `重点掌握` | Rodrigues 式 $R=c_\vartheta I+(1-c_\vartheta)\boldsymbol r\boldsymbol r^{\mathrm T}+s_\vartheta S(\boldsymbol r)$；$\exp(\vartheta S)=R$ | $\vartheta=0$ 主旋转向量为 $\boldsymbol 0$；半圈 $\vartheta=\pi$ 反对称部分零，改由 $(R+I)/2$ 最大主元与交叉项恢复相对符号 |
| **[2.6 单位四元数](sec2-6.md)** · `补充·精简` | $R=(2\eta^2-1)I+2\boldsymbol\epsilon\boldsymbol\epsilon^{\mathrm T}+2\eta S(\boldsymbol\epsilon)$；$Q^{-1}=\{\eta,-\boldsymbol\epsilon\}$；$H=4\boldsymbol q\boldsymbol q^{\mathrm T}$ | $Q\sim -Q$ 双重覆盖；原书反对称差在半圈失效（E2.7），须用 $H$ 最大主元提取；SLERP 前先对齐点积符号 |
| **[2.7 齐次变换](sec2-7.md)** · `核心必考` | $A_0^1=\begin{bmatrix}R^{\mathrm T}&-R^{\mathrm T}\boldsymbol o\\ \boldsymbol 0^{\mathrm T}&1\end{bmatrix}$；$A_2^0=A_1^0 A_2^1$；$\hat\xi_s=\dot A A^{-1}$ | 点取末分量 $1$，自由方向取 $0$；$A^{-1}=A^{\mathrm T}\iff\boldsymbol o=\boldsymbol 0$；空间线速度 $\boldsymbol v_s=\dot{\boldsymbol o}-\boldsymbol\omega_s\times\boldsymbol o\neq\dot{\boldsymbol o}$ |
| **[2.8 标准 DH 法](sec2-8.md)** · `核心必考` | $T_e^b=T_0^b A_1^0\cdots A_n^{n-1}T_e^n$；$A_i^{i-1}=\operatorname{Rot}_z(\vartheta_i)\operatorname{Trans}_z(d_i)\operatorname{Trans}_x(a_i)\operatorname{Rot}_x(\alpha_i)$ | 系 $i-1$ 的 $z_{i-1}$ 看守关节 $i$；每行 3 常 1 变；闭链虚拟切口 6 等式仅含 5 个独立约束 |
| **[2.9 典型机械手结构](sec2-9.md)** · `重点掌握` | 平面 3R / 平行四边形 / 球臂 / 拟人臂 / 球腕 / 斯坦福 / 带腕拟人 / DLR / 类人 | 本表球腕 $R_6^3=\text{ZYZ}$；斯坦福系 $3$ 接口对齐可直乘，带腕拟人臂接口冲突须整臂重建（$a_3\to d_4$） |
| **[2.10 两空间与工作空间](sec2-10.md)** · `了解·精简` | $\mathcal W_D\subseteq\mathcal W_R$；$\dim\mathcal N(J_{\rm task})=n-\operatorname{rank}J_{\rm task}$ | 工作空间轮廓须兼查域边界与内部临界点；区分定位精度（系统偏差）与重复精度（随机散布）；奇异瞬时核增大不保有限自运动 |
| **[2.11 运动学标定](sec2-11.md)** · `了解·精简` | 局部姿态残差 $(\operatorname{Log}(R_n^{\mathrm T}R_m))^{\vee}$；$\Delta\boldsymbol\xi=(\Phi_k^{*\mathrm T}W\Phi_k^*)^{-1}\Phi_k^{*\mathrm T}W\boldsymbol r^*$ | 实际待估参数 $p\le 4n$；$tm\ge p$ 仅为必要条件，须查 $\operatorname{rank}\Phi_k^*=p$、条件数及独立验证；回零非几何标定 |
| **[2.12 逆运动学](sec2-12.md)** · `核心必考` | Pieper 充分条件（三轴共点或平行）；解耦五步 $\boldsymbol p_w=\boldsymbol p_e-d_6\boldsymbol a_e$ | 平面臂 2 支、拟人臂 4 支、带球腕 8 支；球臂用 $\vartheta_1=\operatorname{Atan2}(p_{wy},p_{wx})-\operatorname{Atan2}(d_2,\pm\sqrt{\rho^2-d_2^2})$ 补全半角无穷根 |
| **[作业二详解](homework02.md)** · `重点掌握` | 教材习题 2-4 / 2-12 / 2-19 | Rodrigues 相似变换逐元证明、圆柱形臂（RPP）DH 建系与正逆运动学求解及 $d_3=0$ 边界 |

> **贯穿与课程范围说明**：本章既覆盖课程主干内容（[2.2](sec2-2.md)–[2.5](sec2-5.md)、[2.7](sec2-7.md)–[2.10](sec2-10.md)、[2.12](sec2-12.md)），也收录原书中的四元数（[2.6](sec2-6.md)）、闭链处理与冗余类人构形、以及非线性运动学标定（[2.11](sec2-11.md)）。全章数值例题与代码可结合 [两连杆第一关](../training/two-link.md#mission-reach)、[20 项目标自检表](checklist.md)、[全章总结](summary.md) 及 [勘误与补注](errata.md) 进行闭环核验。

---

<a id="checkpoint-2"></a>

## 三、进入第三章前：三项核心计算核对

完成全章学习后，先独立推算以下三题，再展开核对；建系与逆解题目须同时检验几何与回代闭环。

::: think 检查 1 · 主动旋转算子与被动坐标变换 {#checkpoint-2.orientation}
令 $R=R_z(90^\circ)$，列向量 $\boldsymbol a=(1,0.5,0)^{\mathrm T}\,\mathrm m$。分别求：① 同一固定系内把该位置向量绕原点主动正转 $90^\circ$ 后的坐标；② 把点保持不动、将其在固定系下的坐标 $\boldsymbol p^0=\boldsymbol a$ 改写为姿态 $R$、共原点动系下的坐标 $\boldsymbol p^1$。说明为何仅检验模长不变不足以判断用对了 $R$ 还是 $R^{\mathrm T}$。

::: sol 检查 1 核对
① 主动旋转算子用 $R\boldsymbol a$，得 $(-0.5,1,0)^{\mathrm T}\,\mathrm m$；② 被动坐标变换用 $R^{\mathrm T}\boldsymbol a$，得 $(0.5,-1,0)^{\mathrm T}\,\mathrm m$。两者欧氏模长均为 $\sqrt{1.25}\,\mathrm m$，却对应相反旋转方向；还必须指明向量所在坐标系并检查非对称角度（如 $\pm 90^\circ$）下的像向量指向。参见 [§2.2 数值对照](sec2-2.md#ex-2.2.compare)。
:::
:::

::: think 检查 2 · 标准 DH 建表、正运动学连乘与工具外移 {#checkpoint-2.chain}
考虑两连杆平面 2R 臂（$a_1=a_2=1\,\mathrm m$），两转动关节轴均沿 $+z$ 轴，$x_i$ 沿连杆 $i$，零角时两杆沿 $+x_0$，物理基座与系 $0$ 重合。写出标准 DH 参数表，并在 $\boldsymbol q=(0,\pi/2)^{\mathrm T}\,\mathrm{rad}$ 时求系 $2$ 原点位姿；若夹爪工具原点沿系 $2$ 的 $+x_2$ 轴外移 $0.5\,\mathrm m$，求工具尖端在基座系下的位置 $\boldsymbol p_e^0$。

::: sol 检查 2 核对
两行标准 DH 参数均为 $(a_i,\alpha_i,d_i,\vartheta_i)=(1,0,0,q_i)$（单位 $\mathrm m,\mathrm{rad}$）。代入 $\boldsymbol q=(0,\pi/2)^{\mathrm T}$，得系 $2$ 原点位置 $(1,1,0)^{\mathrm T}\,\mathrm m$、姿态 $R_2^0=R_z(\pi/2)$。工具位置须先将局部偏移左乘 $R_2^0$ 换算至基系：
$$\boldsymbol p_e^0 = \boldsymbol p_2^0 + R_2^0(0.5,0,0)^{\mathrm T} = (1,1,0)^{\mathrm T}+(0,0.5,0)^{\mathrm T}=(1,1.5,0)^{\mathrm T}\,\mathrm m.$$
注意工具沿局部轴 $+x_2$ 延伸而非直接加在基系 $x$ 分量上。参见 [§2.8 混合链算例](sec2-8.md#practice-2.8.chain)。
:::
:::

::: think 检查 3 · 双支位置逆解、工作空间边界检查与正解回代 {#checkpoint-2.inverse}
沿用上题 $a_1=a_2=1\,\mathrm m$ 平面 2R 臂（不外移工具），求到达目标位置 $(1,1)\,\mathrm m$（不限定末端朝向，忽略限位）的全部位置逆解；若目标改为 $(3,0)\,\mathrm m$，判断解的存在性；若额外指定末端姿态角 $\phi$，原有两支位置解是否仍自动成立？

::: sol 检查 3 核对
两支逆解分别为 $\boldsymbol q=(0,\pi/2)^{\mathrm T}$ 与 $(\pi/2,-\pi/2)^{\mathrm T}$，回代正运动学均精确恢复 $(1,1)\,\mathrm m$，但末杆朝向角分别为 $\pi/2$ 与 $0$；因此给定任意朝向 $\phi$ 时必须单独验证姿态约束。对目标 $(3,0)\,\mathrm m$，余弦定理解得 $c_2=(3^2-1^2-1^2)/(2\cdot 1\cdot 1)=3.5>1$，目标超出可达工作空间外边界，应直接判定无解（严禁强行截断续算）。参见 [两连杆第一关](../training/two-link.md#mission-reach)。
:::
:::
