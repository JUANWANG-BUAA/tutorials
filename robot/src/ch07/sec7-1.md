# 7.1 控制问题与控制体系

第六章已经建立机械臂的动力学模型，它回答的是“给定运动需要多大广义力”或“给定广义力如何演化”。控制工程面临的则是逆向决策：给定期望轨迹，如何依据存在偏差的有限传感器测量实时决定控制输入，在扰动和参数未知的情况下稳定地完成跟踪？本节梳理控制问题的严格提法、工程制约因素、两套空间反馈方案与两大动力学补偿架构。

<a id="sec-7.1.1"></a>

## 7.1.1 控制问题的数学提法与任务分类

将[第六章](../ch06/sec6-1.md#part-6.1.3)关节空间主方程（含粘性与滑动库仑摩擦）写作自由空间被控对象：

$$B(\boldsymbol q)\ddot{\boldsymbol q}+C(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}+F_{\mathrm v}\dot{\boldsymbol q}+F_{\mathrm s}\operatorname{sgn}(\dot{\boldsymbol q})+\boldsymbol g(\boldsymbol q)=\boldsymbol\tau.\tag{7.1}$$

**运动控制问题**定义为：给定期望关节轨迹 $\boldsymbol q_d(t)$（或操作空间期望轨迹 $\boldsymbol x_d(t)$），构造时间演化控制输入 $\boldsymbol\tau(t)$，使闭环系统的实际轨迹跟踪期望运动（或稳定至定点），并满足指定的瞬态响应指标（带宽、超调、调节时间）和稳态误差界。

控制与第六章动力学逆解存在三点本质差异：
1. **模型仅是近似**：连杆质量、关节摩擦与末端负载通常存在未知偏差，仅凭开环逆解无法保证跟踪精度，必须依靠闭环状态反馈修正误差；
2. **状态测量受限**：多数工业机械手仅安装关节位置/速度传感器，加速度与末端位姿往往无法直接无噪测量；
3. **闭环动态与鲁棒性要求**：设计不仅关心名义代数平衡，还要求闭环渐近稳定与扰动衰减能力。

按末端是否与外界发生力学接触，运动控制划分为两类问题：
- **自由空间运动控制（本章对象）**：末端在自由空间运动或对准，无环境接触力（$\boldsymbol h_e=\boldsymbol 0$，方程不含 $-J^{\mathrm T}\boldsymbol h_e$）；
- **环境交互控制（[第八章](../ch08/overview.md)对象）**：末端受物理约束与环境发生接触施力，须协同控制位置/速度与接触广义力。

<a id="sec-7.1.2"></a>

## 7.1.2 影响控制方案选型的四个因素

1. **任务方式**：点对点（PTP）重点要求终态静态精度与避障；连续路径跟踪还要求全程瞬态误差和速度匹配。
2. **机械本体构型**：正交笛卡儿臂惯量常对角解耦，而串联关节型机械臂具有强烈的位形依赖惯量与速度耦合。
3. **执行与传动结构**：高减速比将耦合按传动比幂次衰减到电机侧，但也伴随摩擦增大、齿隙与结构柔性。
4. **性能指标约束**：高速度、高加速度与微米级精度往往要求从单纯单轴反馈升级至前馈与整机非线性补偿。

<a id="sec-7.1.3"></a>
<a id="sec-7.1.4"></a>

## 7.1.3 两套控制空间方案：关节空间 vs 操作空间

机器人控制的固有结构错位在于：**作业任务通常定义在末端操作空间 $\boldsymbol x_d$，而物理执行器全部驱动在关节空间 $\boldsymbol\tau$。** 围绕误差比较点位置的不同，形成两套空间反馈方案：

<figure>
<svg class="figure-svg" viewBox="0 0 920 430" xmlns="http://www.w3.org/2000/svg" role="img" aria-labelledby="fig-71-loops-t fig-71-loops-d">
<title id="fig-71-loops-t">两套控制方案的框图：关节空间与操作空间</title>
<desc id="fig-71-loops-d">上面板：关节空间方案，期望位姿先经逆运动学变成关节期望，与反馈关节量比较后进控制器与执行器，机械手输出实际关节运动与末端位姿；反馈闭环在关节量上，末端段开环。下面板：操作空间方案，期望位姿直接与反馈末端位姿比较，控制器输出经雅可比转置折算成关节力矩；闭环在末端位姿上。</desc>
<defs><marker id="f71-m" markerWidth="8" markerHeight="8" refX="6" refY="3" orient="auto"><path d="M0,0 L6,3 L0,6 Z" fill="var(--muted)"/></marker></defs>
<text class="diagram-text" x="460" y="30" text-anchor="middle">同一套读法：前向通道从左到右，反馈从右回到比较点取负；闭环量用同色标出</text>
<g class="diagram-node">
<rect x="24" y="58" width="88" height="40" rx="8"/>
<rect x="140" y="58" width="96" height="40" rx="8"/>
<rect x="300" y="58" width="76" height="40" rx="8"/>
<rect x="430" y="58" width="76" height="40" rx="8"/>
<rect x="560" y="58" width="76" height="40" rx="8"/>
<rect x="690" y="58" width="90" height="40" rx="8"/>
<rect x="300" y="150" width="76" height="40" rx="8"/>
</g>
<g class="diagram-text" text-anchor="middle">
<text x="68" y="82">x<tspan class="sb">d</tspan></text><text x="188" y="82">逆运动学</text>
<text x="338" y="82">控制器</text><text x="468" y="82">执行器</text>
<text x="598" y="82">机械手</text><text x="735" y="82">x<tspan class="sb">e</tspan></text>
<text x="338" y="174">传感器</text>
</g>
<text class="diagram-text" fill="var(--accent-text)" x="240" y="82" text-anchor="middle">q<tspan class="sb">d</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="436" y="120" text-anchor="middle">τ</text>
<text class="diagram-text" fill="var(--accent-text)" x="672" y="120" text-anchor="middle">q（闭环量）</text>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f71-m)">
<path d="M112 78 H136"/><path d="M236 78 H296"/><path d="M376 78 H426"/><path d="M506 78 H556"/><path d="M636 78 H686"/>
<path d="M735 98 V174 H380"/><path d="M300 170 H236 V98"/>
</g>
<circle cx="258" cy="78" r="3" fill="var(--ink)"/>
<text class="diagram-note" x="460" y="212" text-anchor="middle">上：关节空间方案——闭环在 q，x_d→x_e 段除逆运动学外开环</text>
<g class="diagram-node">
<rect x="24" y="252" width="88" height="40" rx="8"/>
<rect x="260" y="252" width="76" height="40" rx="8"/>
<rect x="390" y="252" width="76" height="40" rx="8"/>
<rect x="520" y="252" width="76" height="40" rx="8"/>
<rect x="650" y="252" width="90" height="40" rx="8"/>
<rect x="390" y="344" width="76" height="40" rx="8"/>
</g>
<g class="diagram-text" text-anchor="middle">
<text x="68" y="276">x<tspan class="sb">d</tspan></text>
<text x="298" y="276">控制器</text><text x="428" y="276">J<tspan class="sp">T</tspan> 折算</text>
<text x="558" y="276">执行器</text><text x="695" y="276">机械手</text>
<text x="428" y="368">测量/估计</text>
</g>
<text class="diagram-text" fill="var(--accent-text)" x="222" y="276" text-anchor="middle">x̃ = x<tspan class="sb">d</tspan> − x<tspan class="sb">e</tspan></text>
<text class="diagram-text" fill="var(--accent-text)" x="486" y="240" text-anchor="middle">F（末端广义力）</text>
<text class="diagram-text" fill="var(--accent-text)" x="626" y="314" text-anchor="middle">x<tspan class="sb">e</tspan>（闭环量，常由 q 算出）</text>
<g fill="none" stroke="var(--line-strong)" stroke-width="1.6" marker-end="url(#f71-m)">
<path d="M112 272 H256"/><path d="M336 272 H386"/><path d="M466 272 H516"/><path d="M596 272 H646"/>
<path d="M695 292 V364 H470"/><path d="M390 364 H262 V292"/>
</g>
<text class="diagram-note" x="460" y="408" text-anchor="middle">下：操作空间方案——闭环在 x_e，无逆运动学环节；x_e 多数由 q 经正运动学间接得到（优点「只是潜在的」）</text>
</svg>
<figcaption>两套空间控制方案对比：关节空间方案将末端指令翻译到关节再闭环（对 $\boldsymbol x_e$ 开环）；操作空间方案在末端误差 $\tilde{\boldsymbol x}$ 上闭环再经雅可比转置折算（工程多仍由关节传感器经正运动学计算 $\boldsymbol x_e$）。</figcaption>
</figure>

<a id="sec-7.1.4.1"></a>
<a id="sec-7.1.4.2"></a>
<a id="sec-7.1.4.3"></a>

| 比较维度 | 关节空间方案（7.1.3a） | 操作空间方案（7.1.3b） |
|:--|:--|:--|
| 反馈闭环量 | 关节坐标 $\boldsymbol q$（由编码器直接测量） | 末端位姿 $\boldsymbol x_e$（多数经正运动学从 $\boldsymbol q$ 间接估算） |
| 逆运动学环节 | 控制器前必须经过前置逆解 $\boldsymbol x_d\to\boldsymbol q_d$ | 取消前置位置逆解，通过 $J_A^{\mathrm T}$ 或操作空间逆动力驱动 |
| 末端误差机制 | 从 $\boldsymbol x_d$ 到 $\boldsymbol x_e$ **开环**：标定误差、逆解分支切换误差不自消 | 闭环直对 $\tilde{\boldsymbol x}$，但若经正运动学推算 $\boldsymbol x_e$，连杆误差仍遗留（直接优势**仅是潜在的**，除非配备视觉/激光等直接测量） |
| 易出错环节 | 逆运动学多解分支跳变、奇异邻域高速关节参考 | 雅可比奇异与欧拉角表示奇异、计算量与冗余零空间自运动 |

::: intuition 动手实验 · 同一条笛卡尔直线下的两种参考路径（3D）
给定空间起终点之间的期望直线（虚线）：只算首末两点逆解再在关节角中线性插值，末端会偏离直线走出弧线；沿直线离散逐点求逆运动学再送入关节伺服，则可在关节空间跟踪直线轨迹。拖动进度条比较两种轨迹差异。

<div class="lab" data-lab="ctrl3d"></div>
:::

<a id="sec-7.1.5"></a>

## 7.1.4 控制架构划分：分散控制 vs 集中控制

与反馈空间维度**相互正交**的另一重划分，是控制器是否显式利用整机多关节耦合动力学矩阵 $B,C,\boldsymbol g$（关节空间既可做分散控制也可做集中控制；是否配备电流环也非本质判别线）：

| 对比项 | 分散控制（Decentralized，7.2 节） | 集中控制（Centralized，7.3 节） |
|:--|:--|:--|
| 控制器拓扑 | 各关节各自独立设计单输入单输出（SISO）单轴回路 | 将整个多自由度机械手视作统一多输入多输出（MIMO）对象 |
| 模型利用 | 仅需本轴常数标称惯量与局部阻尼；略去跨轴模型 | 显式在线计算或估测整机耦合惯量、科氏与重力矩 |
| 耦合项处理 | 将惯性耦合、离心科氏与重力视作外加扰动 $d_i$ 予以抑制 | 主动在控制律中反相抵消，或依物理结构与上界补偿 |
| 成立前提 | 须校核减速比对耦合的衰减与闭环干扰抑制裕度 | 须满足全机械臂状态实时感知及在线算力与限幅约束 |

<a id="sec-7.1.6"></a>

## 7.1.5 控制器出口：广义力 $\boldsymbol\tau$ 与电机指令转换

控制算法求出的广义力 $\boldsymbol\tau$ 还必须下发到真实执行器硬件接口——功率放大器控制电压 $\boldsymbol v_c$（或电流环指令）。下一节 [7.2.5](sec7-2.md#sec-7.2.5) 将严格推导驱动五式，明确何时电机接近“速度源”、何时提供“力矩接口”。

<a id="sec-7.1.7"></a>

## 本节小结

- **两套分类坐标相互独立**：（关节空间 / 操作空间）确定**反馈比较谁**；（分散 / 集中）确定**控制律用多少整机动力学**。
- **工程要点速查**：

| 要点 | 核心表述 | 注意事项 |
|:--|:--|:--|
| 控制问题定位 | 设计 $\boldsymbol\tau(t)$ 满足动静态跟踪指标 | 不等同于第 6 章开环动力学逆解 |
| 两套空间对照 | 关节空间闭 $\boldsymbol q$（末端开环） vs 操作空间闭 $\boldsymbol x_e$ | 若 $\boldsymbol x_e$ 靠编码器正运动学估算，连杆标定误差无法自消 |
| 两套架构对照 | 单轴 SISO（耦合进扰动 $d$） vs 整机 MIMO（显式补偿） | 减速比决定耦合折算缩放尺度，需验算工况后确定架构 |

**下一节**：[7.2 分散（独立关节）控制](sec7-2.md)分析高减速比何以支撑单轴近似，并导出三种单轴控制器、根轨迹稳定性与驱动接口公式。

::: think 本节的课堂幻灯片（源料对照）

| 时间点 | 幻灯片 | 提供了什么 | 本教程如何处理 |
|:--|:--|:--|:--|
| 01:56:43 | [overview-tasks.jpg](../assets/ch07/overview-tasks.jpg) | 自由空间 vs 环境交互与解耦分类 | 7.1.1、7.1.4 分离自由/交互与架构概念 |
| 02:02:35 | [control-factors.jpg](../assets/ch07/control-factors.jpg) | 影响控制的工程因素框图 | 7.1.2 整理为四条设计制约因素 |
| 02:02:39 | [twospaces.jpg](../assets/ch07/twospaces.jpg) | 任务与动作所在空间错位 | 7.1.3 开篇明确结构根源 |
| 02:05:04 | [joint-space-loop.jpg](../assets/ch07/joint-space-loop.jpg) | 关节空间控制框图 | 整合入双面板自绘 SVG 上图 |
| 02:06:32 | [op-space-loop.jpg](../assets/ch07/op-space-loop.jpg) | 操作空间控制框图 | 整合入双面板自绘 SVG 下图 |
:::
