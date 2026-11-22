# 7.4 操作空间控制

课件 §8.6，**全部是课堂内容**（录播 01:58:34–02:10:12）。前三节都在**关节空间**里设计控制器：
先由逆运动学把任务翻译成 $\boldsymbol q_d$，再控制 $\boldsymbol q$ 跟踪它。这一节换一种做法：
**直接在末端位姿的控制空间里闭环**。任务误差直接进入反馈，不必先把整条位姿参考转换成关节位置参考；但仍需雅可比映射，而且由正运动学估计末端状态时，标定误差并不会自动消失。奇异位形与冗余自由度也仍须处理。

<a id="sec-7.4.1"></a>

## 7.4.1 为什么还要操作空间

关节空间方案有一个「先天间接」：任务要求的是末端位姿，控制器跟踪的却是关节角。两者之间隔着
逆运动学，逆解误差、奇异、多解都发生在这一层，而控制器**看不见**。

直接在操作空间闭环，逻辑变成（图 7.4-1）：

```text
x_d（任务） ──→ 操作空间控制器 ──→ F（末端等效力） ──J_A^T──→ τ ──→ 机械手
     ↑                                                              │
     └──────────────── x（由 q 正运动学算出） ←──────────────────────┘
```

**优点**：任务误差直接进入反馈。对于冗余机械手（$n>6$），还可以利用额外自由度实现避障或避开关节限位等子任务，但必须通过零空间投影，确保这些子任务不会干扰末端任务。

**代价**：至少需要雅可比及可靠的末端状态；是否需要完整动力学取决于控制律。末端状态若由关节位置经正运动学估计，模型与关节标定误差也会进入闭环。
<a id="sec-7.4.2"></a>

## 7.4.2 操作空间动力学模型

取末端位姿

$$\boldsymbol x=\begin{bmatrix}\boldsymbol p\\ \boldsymbol\phi\end{bmatrix}
\quad(\text{位置}+\text{欧拉角}),\qquad
\dot{\boldsymbol x}=J_A(\boldsymbol q)\dot{\boldsymbol q},\tag{7.4-1}$$

$J_A$ 是**分析雅可比**，不是第三章的几何雅可比 $J$：姿态部分 $\dot{\boldsymbol\phi}$ 是欧拉角
导数，不是角速度（[3.6 分析雅可比](../ch03/sec3-6.md)）。本节所有位置、姿态及其参考均在同一固定基坐标系和同一欧拉角约定下表示，位置单位为 $\mathrm m$、姿态单位为 $\mathrm{rad}$。欧拉角差只在同一无奇异、无跨周期跳变的局部坐标图内使用，不能将相差 $2\pi$ 的表示直接当作很大的实际姿态误差。因位置与姿态量纲不同，$K_P,K_D$ 的各分块必须按共轭力的单位设置。对式 (7.4-1) 求时间导数得：


$$\ddot{\boldsymbol x}=J_A\ddot{\boldsymbol q}+\dot J_A\dot{\boldsymbol q}.\tag{7.4-2}$$

把它与关节空间方程联立、消去 $\ddot{\boldsymbol q}$，得**操作空间动力学模型**（推导见
[6.7](../ch06/sec6-7.md)）：

$$\boxed{\ B_x(\boldsymbol q)\ddot{\boldsymbol x}
+C_x(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol x}
+\boldsymbol g_x(\boldsymbol q)=\boldsymbol\tau_x-\boldsymbol h_A\ }\tag{7.4-3}$$

$B_x,C_x,\boldsymbol g_x$ 由 $B,C,\boldsymbol g$ 与 $J_A$ 组合而成，$\boldsymbol\tau_x$ 是与位姿坐标速度 $\dot{\boldsymbol x}$ 共轭的广义力。若 $\boldsymbol h_e$ 是末端施加给环境的几何力/力矩，$J=T_AJ_A$，则与 $\dot{\boldsymbol x}$ 共轭的接触广义力是 $\boldsymbol h_A=T_A^{\mathrm T}\boldsymbol h_e$，不是未经变换的 $\boldsymbol h_e$。自由运动时两者均为零。

**三处要留意**：

1. **形式对应有前提**：本节先讨论 $J_A$ 可逆的非冗余情况，以及精确模型和力矩执行。不能只因外形相似就忽略坐标、力的共轭关系与驱动限制。
2. **$B_x$ 的存在**：$B$ 正定且 $J_A$ 满行秩时，$B_x=(J_AB^{-1}J_A^{\mathrm T})^{-1}$ 存在。奇异时该逆不存在，接近奇异时可能病态。
3. **冗余时**，$J_A$ 不必是方阵；满行秩仍可定义上述 $B_x$，但末端坐标不足以确定全部关节状态，还须处理零空间动力学，见 [6.7](../ch06/sec6-7.md)。

在这些坐标和模型假设下，操作空间方程与关节空间方程形式对应，因此可以把 7.3 的设计思路迁移过来：把状态 $\boldsymbol q$ 换成 $\boldsymbol x$，动力学项换成 $B_x,C_x,\boldsymbol g_x$，再按所选坐标检查各项的定义与稳定性条件。下面分别用重力补偿 PD 与逆动力学说明这种迁移；“形式相同”不意味着可以忽略奇异和零空间。

<a id="sec-7.4.3"></a>

## 7.4.3 两种实现：逆雅可比与转置雅可比

课件 §8.6.1 把操作空间方案分成两条路，区别在**误差怎样变成关节力矩**。

### 7.4.3.1 逆雅可比方案：先翻译，再关节控制

逆雅可比方案先把末端误差转换成关节空间的修正量，再交给关节控制器。设 $J_A$ 为可逆方阵，$\tilde{\boldsymbol x}=\boldsymbol x_d-\boldsymbol x$，一个局部速度指令的例子是

$$\dot{\boldsymbol q}_{\rm cmd}=J_A^{-1}(\dot{\boldsymbol x}_d+K\tilde{\boldsymbol x}),\qquad K\succ0.\tag{7.4-4}$$

若关节速度能准确跟踪该指令，且运动学模型准确，则 $\dot{\tilde{\boldsymbol x}}=-K\tilde{\boldsymbol x}$。实际还需要关节伺服把速度指令转换为驱动力矩；不能把逆雅可比乘以末端误差直接写成关节力矩。奇异位形附近逆矩阵病态，冗余时还要规定如何分配关节速度。

### 7.4.3.2 转置雅可比方案：把误差变成「弹簧力」

不翻译，直接把操作空间误差乘增益，得到末端等效力，再用 $J_A^{\mathrm T}$ 折算成关节力矩
（图 7.4-2）：

$$\boxed{\ \boldsymbol F=K_P(\boldsymbol x_d-\boldsymbol x),\qquad
\boldsymbol\tau=J_A^{\mathrm T}(\boldsymbol q)\boldsymbol F\ }\tag{7.4-5}$$

**物理图像**：$K_P$ 等效为一个**广义虚拟弹簧**，把末端从当前位姿往期望位姿 $\boldsymbol x_d$ 拉；$J_A^{\mathrm T}$ 则实现了这一虚拟力向关节空间的分配（符合虚功原理：$\boldsymbol\tau = J_A^{\mathrm T}\boldsymbol F$）。**此方案不需要求 $J_A^{-1}$，因此在奇异位形附近数值上更为稳健**——这是其相对逆雅可比方案的核心优势。
这里的稳健只指无需数值求逆，不代表在奇异处仍能消除任意任务误差：某些方向的虚拟力可能落入 $J_A^{\mathrm T}$ 的零空间。式 (7.4-5) 还只是弹簧项，尚未补重力或加入阻尼，不能单凭它保证动态系统收敛；下一小节补齐这两部分。


**代价**：弹簧力只保证「往目标拉」，不保证「沿最短路径」；刚度矩阵 $K_P$ 的设计要考虑各向异性
（位置与姿态的量纲不同），否则会出现「位置到了、姿态还差很多」的耦合。

<a id="sec-7.4.4"></a>

## 7.4.4 操作空间重力补偿 PD

与关节空间的重力补偿 PD 完全平行。取末端期望位姿 $\boldsymbol x_d$ 为常数，误差
$\tilde{\boldsymbol x}=\boldsymbol x_d-\boldsymbol x$，构造

$$V=\frac12\dot{\boldsymbol q}^{\mathrm T}B(\boldsymbol q)\dot{\boldsymbol q}
+\frac12\tilde{\boldsymbol x}^{\mathrm T}K_P\tilde{\boldsymbol x},\tag{7.4-6}$$

控制律取

$$\boxed{\ \boldsymbol u=\boldsymbol g(\boldsymbol q)
+J_A^{\mathrm T}(\boldsymbol q)K_P\tilde{\boldsymbol x}
-J_A^{\mathrm T}(\boldsymbol q)K_DJ_A(\boldsymbol q)\dot{\boldsymbol q}\ }\tag{7.4-7}$$

这里 $K_P,K_D$ 取对称正定矩阵。目标静止时，$\dot{\tilde{\boldsymbol x}}=-J_A\dot{\boldsymbol q}$；把控制律代入动力学，再用 $\dot B-2C$ 的反对称性，得到

$$\dot V=-\dot{\boldsymbol q}^{\mathrm T}F\dot{\boldsymbol q}
-\dot{\boldsymbol q}^{\mathrm T}J_A^{\mathrm T}K_DJ_A\dot{\boldsymbol q}\le0.\tag{7.4-8}$$

负号表示阻尼：末端正在向某方向运动时，速度反馈要施加相反方向的力。若取正号，不能得到上面的耗散式。课件 125:40 的框图也在速度反馈处使用减号。

若闭环轨迹有界、模型满足拉萨尔原理的条件，且阻尼足以使最大不变集中的速度为零，则平衡点满足

$$J_A^{\mathrm T}(\boldsymbol q)K_P\tilde{\boldsymbol x}=0.\tag{7.4-9}$$

当 $J_A$ 满行秩时，$J_A^{\mathrm T}$ 列满秩，因此平衡点有 $\tilde{\boldsymbol x}=0$。冗余本身不破坏这一结论；但任务空间阻尼可能无法耗散零空间运动，需单独分析。奇异时 $J_A^{\mathrm T}$ 可能存在非零零空间，非零末端误差也可能满足平衡条件。

<a id="sec-7.4.5"></a>

## 7.4.5 操作空间逆动力学

跟踪操作空间轨迹时，把 7.3.4 的逆动力学「搬」到 $\boldsymbol x$ 空间。由 (7.4-2)，

$$\ddot{\boldsymbol q}=J_A^{-1}\bigl(\ddot{\boldsymbol x}-\dot J_A\dot{\boldsymbol q}\bigr).\tag{7.4-10}$$

取辅助控制

$$\boldsymbol y=J_A^{-1}(\boldsymbol q)\bigl(\ddot{\boldsymbol x}_d
+K_D\dot{\tilde{\boldsymbol x}}+K_P\tilde{\boldsymbol x}
-\dot J_A(\boldsymbol q,\dot{\boldsymbol q})\dot{\boldsymbol q}\bigr),\tag{7.4-11}$$

再令 $\boldsymbol u=B(\boldsymbol q)\boldsymbol y+\boldsymbol n(\boldsymbol q,\dot{\boldsymbol q})$，
代回关节空间方程得

$$\ddot{\tilde{\boldsymbol x}}+K_D\dot{\tilde{\boldsymbol x}}+K_P\tilde{\boldsymbol x}=0.\tag{7.4-12}$$
上式要求参考在所用局部坐标图内可达、轨迹保持非奇异，模型与状态准确、力矩不饱和，并采用理想连续时间更新；取正对角增益时各任务坐标误差指数衰减。采样、延迟、测量误差或限幅存在时须重新写误差方程。欧拉角坐标奇异和机械臂的运动学奇异是两种不同问题，都不能仅靠把 $J_A^{-1}$ 换成数值伪逆就保留同一证明。

**注意它与 7.4.4 的分工**：7.4.4 只补重力，适合点对点；7.4.5 对模型做更完整的补偿，适合轨迹跟踪。前者用 $J_A$ 做力的映射，后者还需 $\dot J_A$ 和逆雅可比。

**这个方案有三个硬约束**：

1. **$J_A$ 必须可逆**：所选任务维数与关节数相同且非奇异；冗余时需要另行选择伪逆与零空间运动。
2. **要算 $\dot J_A\dot{\boldsymbol q}$**：这是对速度映射求导产生的运动学加速度项，不是关节动力学中的 $C\dot q$，不能把两者混作同一个科氏项。
3. **$B_x$ 不一定显式算**：可以像 (7.4-11) 这样先算 $\boldsymbol y$ 再乘 $B$，避免构造 $B_x$；
   但 $J_A^{-1}$ 的数值条件仍然决定成败。

<a id="sec-7.4.6"></a>

## 7.4.6 奇异、冗余与代价

课件 127:50 专门用一页列了操作空间控制的「麻烦」：

| # | 问题 | 后果 | 对策 |
|:--|:--|:--|:--|
| 1 | $\boldsymbol x$ 测量或估计有误差 | 正运动学估计受关节和标定误差影响 | 改进标定或使用视觉、激光跟踪 |
| 2 | $J_A$ 奇异 | $J_A^{-1}$ 不存在，$B_x$ 病态，力矩爆 | 阻尼最小二乘、奇异回避（第三章） |
| 3 | 冗余（$n>6$） | $J_A$ 非方阵，逆不唯一 | 伪逆 + 零空间投影 |
| 4 | 计算量随方案而变 | 转置方案需计算 $J_A$；逆雅可比方案还需解速度映射，逆动力学方案还需动力学模型与 $\dot J_A\dot q$ | 按所选控制律评估计算周期；可用递推算法，不必对所有方案都显式构造 $B_x,C_x,\boldsymbol g_x$ |
| 5 | 姿态误差定义敏感 | 欧拉角万向锁、大角度误差不「小」 | 四元数/旋转矩阵误差 |

选择方案时要区分两类误差：关节反馈无法直接纠正运动学模型造成的末端偏差；操作空间反馈若依靠正运动学估计末端，同样会受到该模型误差影响。外部测量可以补充信息，但它也有标定、延迟与噪声，须结合任务精度和测量条件比较。

::: note 操作空间不是「更高级」
课件原话（127:50）：「操作空间控制器设计总是要求计算机械手雅可比矩阵，导致机械手的操作空间控制
通常比关节空间控制更复杂。实际上，奇异或冗余的存在都会影响到雅可比矩阵，操作空间控制器很难
处理这些影响因素。」——**它是另一套取舍，不是升级版**。
:::

<a id="sec-7.4.7"></a>

## 7.4.7 小结与常见错误

- **一句话**：操作空间控制把 7.3 的整套方法「搬」到 $\boldsymbol x$ 空间——用 (7.4-3) 的模型替换
  关节空间模型，用 (7.4-7)/(7.4-11) 替换 (7.3-6)/(7.3-9)，误差方程形式不变；代价是 $\boldsymbol x$
  难测、计算量大、奇异与冗余要多处理。
- **两条实现路线**：逆雅可比（先翻译，再关节控制）与转置雅可比（误差 → 弹簧力 → $J_A^{\mathrm T}$）；
  前者要 $J_A^{-1}$，后者不要，但后者不保证最短路径。
- **一个判据**：$\boldsymbol x$ 的信息质量决定这套方案的实际上限。
- **下一节**：[7.5 九种方案的仿真比较与选型](sec7-5.md) 把本章所有控制律放到同一台两连杆臂上量出差距。

核心公式速查：

| 公式 | 条件与假设 | 单位/量纲 | 易错点 |
|:--|:--|:--|:--|
| 模型 (7.4-3)：$B_x\ddot{\boldsymbol x}+C_x\dot{\boldsymbol x}+\boldsymbol g_x=\boldsymbol\tau_x-\boldsymbol h_A$ | $B$ 正定、$J_A$ 满行秩；$B_x=(J_AB^{-1}J_A^{\mathrm T})^{-1}$ | 混合（m/rad 分块） | 接触力须共轭变换 $\boldsymbol h_A=T_A^{\mathrm T}\boldsymbol h_e$；冗余时末端坐标不能闭合模型 |
| 转置方案 (7.4-5)：$\boldsymbol F=K_P\tilde{\boldsymbol x}$，$\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol F$ | 弹簧项；奇异附近数值稳健 | N、N·m | 无求逆 ≠ 能消任意误差；$J_A^{\mathrm T}$ 零空间方向的误差拉不动 |
| 操作空间重力补偿 PD (7.4-7)：$\boldsymbol u=\boldsymbol g+J_A^{\mathrm T}K_P\tilde{\boldsymbol x}-J_A^{\mathrm T}K_DJ_A\dot{\boldsymbol q}$ | 固定目标、拉萨尔条件 | N·m | 平衡点由 $J_A^{\mathrm T}K_P\tilde x=0$ 定；奇异时非零误差也可满足 |
| 操作空间逆动力学 (7.4-11)：$\boldsymbol y=J_A^{-1}(\ddot{\boldsymbol x}_d+K_D\dot{\tilde{\boldsymbol x}}+K_P\tilde{\boldsymbol x}-\dot J_A\dot{\boldsymbol q})$ | $J_A$ 可逆、模型精确 | rad/s² | $\dot J_A\dot q$ 是运动学加速度，不是 $C\dot q$；欧拉角奇异与机构奇异分开判 |

::: think 常见错误清单
1. **混用两种雅可比和力的定义**：姿态坐标导数 $\dot{\boldsymbol\phi}$ 一般不等于角速度 $\boldsymbol\omega$。使用 $\dot{\boldsymbol x}=[\dot{\boldsymbol p};\dot{\boldsymbol\phi}]$ 时要用分析雅可比及其共轭广义力；也可以用几何雅可比，但须相应改用线速度、角速度和几何力/力矩。
2. **把 $B_x$ 当常数**：它随 $J_A$ 与 $\boldsymbol q$ 变，奇异处病态。
3. **以为操作空间一定更准**：若 $\boldsymbol x$ 由 $\boldsymbol q$ 算出，误差照样被带进来，
   并且会被 $J$ 放大。
4. **忽略 $\dot J_A\dot{\boldsymbol q}$ 项**：它来自时变雅可比的求导，不是 $C\dot q$ 的替代项；省略后任务加速度对消不再精确。
5. **冗余时硬求逆**：$n>6$ 时 $J_A$ 非方阵，必须伪逆 + 零空间。
6. **把 $\boldsymbol\tau=J_A^{\mathrm T}\boldsymbol F$ 写成 $J_A\boldsymbol F$**：转置方向由虚功原理
   决定，写反了力矩方向就错。
:::

::: think 默写点 · 合上书再写
1. 写出操作空间模型 (7.4-3)，说明它与关节空间模型的形式对应。
2. 分别说明何时使用分析雅可比与几何雅可比，以及与它们对应的速度、广义力如何配套。
3. 写出转置雅可比方案与逆雅可比方案，各说明一个优缺点。
4. 写出操作空间重力补偿 PD 的 $V$ 与 $\dot V$，说明平衡点为什么由 $J_A^{\mathrm T}K_P\tilde x=0$ 确定。
5. 写出操作空间逆动力学，指出它与 7.4.4 的分工。
6. 列出操作空间控制的五条代价与各自的对策。
:::

::: think 本节的课堂幻灯片（源料对照）

本节正文已给出全部推导与对照表；下列课件页保留以备核对，**不构成正文的替代**（对应录播 01:58:34–02:10:12）。

| 时间点 | 幻灯片 | 提供了什么 | 本书如何处理 |
|:--|:--|:--|:--|
| 122:30 | [op-transpose.jpg](../assets/ch07/op-transpose.jpg) | 转置雅可比方案结构 | 式 (7.4-5) + 弹簧物理图像 + 零空间边界替代 |
| 125:40 | [op-gravity-pd.jpg](../assets/ch07/op-gravity-pd.jpg) | 操作空间重力补偿 PD | (7.4-6)–(7.4-9) 完整推导 + 平衡点条件替代 |
| 126:50 | [op-inverse-dynamics.jpg](../assets/ch07/op-inverse-dynamics.jpg) | 操作空间逆动力学 | (7.4-10)–(7.4-12) + 三个硬约束替代 |
:::
