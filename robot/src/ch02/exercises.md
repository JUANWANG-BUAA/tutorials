# 习题集

本页共 **20 题**：A 组 4 题辨认概念，B 组 6 题推导结论，C 组 6 题计算与运行程序，D 组 4 题比较解支、设计标定实验和串联任务。答案默认折叠，先独立写出结果与适用条件，再展开核对。

第一轮可先做 A1/A3/A4、B3/B4/B6、C2/C6，再处理数值实验与研讨题。每次记录“错在系别、乘序、分支、约束还是实现”，下一轮换输入重做。旧稿标注的“原书 2.x”供定位相关主题；本页含合并、改编和新增问题，不表示逐字原题或已核定的考试范围。

**程序准备**：C1/C5 只用 Python 标准库；C4 需 NumPy、Matplotlib；C6 的完整对照需 NumPy、SciPy；D2 需 NumPy。建议在独立环境安装这些包。C6/D2 均附可下载的完整脚本；本页展示同一份源文件，避免复制两份后失去同步。

::: method A / B 组的自评标准（C / D 组另给验收标准）

- **A 组（概念判断）**：达标要求是「**判对 + 说得出依据**」。例如 A1 不只说「三重身份」，而要指出每一问用到的**是**哪一重身份以及**为什么**。
- **B 组（分析证明）**：按「**思路 → 关键步 → 结论**」三步自评。本编 B 组多为证明题，判分点在三处：起点（用了哪条性质）、中间不等式的方向或符号、结论的适用条件（如「$s_\vartheta\neq0$ 时」）。
- **通用扣分点**：上下标读反；$R^{-1}=R^{\mathrm T}$ 用在齐次变换上；漏掉第二支解或符号分支；把 $\boldsymbol\phi$ 当向量相加。

:::

## A 组 · 概念判断

::: ex A1 · 三重身份对号 {#exercise-2.A1}

（对应 [@thm-2.2.B]。）下列计算分别用到旋转矩阵的哪重身份？(a) 把相机系下测到的点坐标换算到机器人基座系；(b) 描述工具相对法兰的姿态；(c) 在固定参考系中，把一个方向向量绕过原点的 $z$ 轴正转 $30^\circ$。再说明 (a) 的两系原点不重合时，单独乘 $R$ 是否足够。

::: sol 解答

(a) 坐标变换；若 $R$ 的列为相机轴在基座系中的方向，原点重合时 $\boldsymbol p^{\rm base}=R\boldsymbol p^{\rm camera}$。不重合时还须加相机原点在基座系中的位置；反向求相机坐标须先减该位置再乘 $R^{\mathrm T}$。(b) 姿态描述，列为工具系三轴在法兰系中的坐标。(c) 旋转算子，输入与输出都在同一固定系中表达，$\boldsymbol v_{\rm after}=R_z(30^\circ)\boldsymbol v_{\rm before}$。可用 [§2.2 数值对照](sec2-2.md#ex-2.2.compare) 检查是否把旋转与换坐标混用。

:::

:::

::: ex A2 · 可行的欧拉角序列

(a) 三个基本旋转共 27 种组合，为什么只有 12 种可行？(b) 判断 $ZYZ$、$ZYX$、$XXZ$、$XZX$ 是否可覆盖任意姿态；只给这些序列名，能否判断固定轴还是当前轴？

::: sol 解答

(a) 相邻同轴旋转可合并，至多剩两转；$XXX$ 只剩一个有效角。相邻不同轴的序列共 $3\times2\times2=12$ 种，均可覆盖姿态但有表示奇点。(b) $XXZ$ 不可行，其余三种可行；序列名不能单独决定轴约定。本书 ZYZ 指当前轴 $z(\varphi)\to y(\vartheta)\to z(\psi)$；RPY 指固定轴 $x(\psi)\to y(\vartheta)\to z(\varphi)$，等价于从 $I$ 出发的当前轴 ZYX 时序。

:::

:::

::: ex A3 · 右乘还是左乘？ {#exercise-2.A3}

写出下列旋转序列的乘积并说明依据：(a) 从 $I$ 出发，绕当前 $z$ 转 $\varphi$、新的 $y$ 转 $\vartheta$、新的 $z$ 转 $\psi$（ZYZ）；(b) 从 $I$ 出发，绕固定 $x$ 转 $\psi$、固定 $y$ 转 $\vartheta$、固定 $z$ 转 $\varphi$（本书 RPY）；(c) 从一般 $R_0$ 出发，分别绕固定轴、当前轴先 $y(\alpha)$ 后 $z(\beta)$；(d) 已知相邻系姿态 $R_1^0,R_2^1,R_3^2$，求 $R_3^0$。

::: sol 解答

(a) 当前轴逐次右乘：$R_z(\varphi)R_y(\vartheta)R_z(\psi)$（[@thm-2.3.A]）。

(b) 固定轴逐次左乘：$R_z(\varphi)R_y(\vartheta)R_x(\psi)$（[@thm-2.3.B]）；最右因子对应本题最先发生的固定轴转动。

(c) 固定轴：$R_z(\beta)R_y(\alpha)R_0$；当前轴：$R_0R_y(\alpha)R_z(\beta)$。从 $I$ 出发时，将其中一个序列的轴角成对倒序可得到另一序列的终态；一般 $R_0$ 不保证这一点。

(d) $R_3^0=R_1^0R_2^1R_3^2$，由坐标换算链 $\boldsymbol p^0=R_1^0R_2^1R_3^2\boldsymbol p^3$ 得到。这里无需假设关节旋转发生的时间顺序。

:::

:::

::: ex A4 · DH 参数账本 {#exercise-2.A4}

(a) 对固定几何、无耦合的单自由度 R/P 开链，$n$ 行 DH 表有多少条目、多少活动变量？(b) 对 R–R–P–R 的 SCARA 标出每行变量；轴线平行是否保证扭角全为 0？(c) 转动关节的 $d$、移动关节的角度是什么？用[§2.8 练习 1](sec2-8.md#practice-2.8.chain)说明非零常数为何不能丢。

::: sol 解答

(a) $4n$ 个表项，$3n$ 个固定项、$n$ 个活动变量；固定项未必都是可独立标定的物理参数。(b) 第 1、2、4 行的变量为角度，第 3 行为 $d$；只有相邻 $z$ 轴同向平行时扭角为 0，反向可取 $\pi$。(c) 转动关节的 $d$、移动关节的角度是常数；编码器零位可能含固定偏置。练习 1 第二行的 $-\pi/2$ 决定姿态，第一行的 0.2 m 决定高度，均不能省。

:::

:::

## B 组 · 分析证明

::: ex B1 · ZXZ 欧拉角（原书 2.1）

推导 ZXZ 欧拉角（绕当前轴：先 $z$ 转 $\varphi$、再新 $x'$ 转 $\vartheta$、再新 $z''$ 转 $\psi$）的合成矩阵，并给出由 $R=[r_{ij}]$ 反求三个角的公式；单独处理零角与半圈。

::: sol 解答

$$R=R_z(\varphi)R_{x'}(\vartheta)R_{z''}(\psi)=\begin{bmatrix}
c_\varphi c_\psi-s_\varphi c_\vartheta s_\psi & -c_\varphi s_\psi-s_\varphi c_\vartheta c_\psi & s_\varphi s_\vartheta\\
s_\varphi c_\psi+c_\varphi c_\vartheta s_\psi & -s_\varphi s_\psi+c_\varphi c_\vartheta c_\psi & -c_\varphi s_\vartheta\\
s_\vartheta s_\psi & s_\vartheta c_\psi & c_\vartheta
\end{bmatrix}.$$

对比第三列与第三行，设 $s_\vartheta>0$，可得

$$\begin{aligned}
\varphi&=\operatorname{Atan2}(r_{13},-r_{23}),\\
\vartheta&=\operatorname{Atan2}\big(\sqrt{r_{13}^2+r_{23}^2},r_{33}\big),\\
\psi&=\operatorname{Atan2}(r_{31},r_{32}).
\end{aligned}$$

另一支可取 $(\varphi+\pi,-\vartheta,\psi+\pi)$，首末角按周期规范；$\vartheta$ 式的 $r_{33}$ 不变号。用 $(0°,90°,0°)$ 检查应得 $R_x(90°)$，其 $(2,3)$ 元必须是 $-1$。

当 $\vartheta=0$ 时，$R=R_z(\varphi+\psi)$，只能确定和；当 $\vartheta=\pi$ 时，$R=R_z(\varphi-\psi)R_x(\pi)$，只能确定差。两种情况下都可取 $\psi=0$、$\varphi=\operatorname{Atan2}(r_{21},r_{11})$，再分别取 $\vartheta=0,\pi$ 得到一个代表；所有满足同一和/差的角组成连续解族。

端点时，通用反解式会遇到 $\operatorname{Atan2}(0,0)$，应先采用上述端点分支。将代表角代回矩阵，再说明角参数的自由度如何对应同一个物理姿态。

:::

:::

::: ex B2 · 旋转矩阵的等距性（自编） {#exercise-2.B2}

证明：(a) $\|R\boldsymbol p\|=\|\boldsymbol p\|$ 且 $(R\boldsymbol p)^T(R\boldsymbol q)=\boldsymbol p^T\boldsymbol q$；(b) $R^T$ 也是旋转矩阵（从而逆变换不改变长度与夹角）。想比较四元数的同类性质，可继续做 D3；这不改变本题对 $R\in SO(3)$ 的假设。

::: sol 解答

(a) $(R\boldsymbol p)^T(R\boldsymbol q)=\boldsymbol p^TR^TR\,\boldsymbol q=\boldsymbol p^T\boldsymbol q$（$R^TR=I$），取 $\boldsymbol q=\boldsymbol p$ 得模长不变。(b) $(R^T)^TR^T=(RR^T)^T=I$；$\det(R^T)=\det(R)=1$。故 $R^T\in SO(3)$——这正是「行的方向余弦」解释（[2.3.1](sec2-3.md#sec-2.3.1) 末）成立的原因。

:::

:::

::: ex B3 · ZYZ 的退化支（原书 2.2，兼答 2.3） {#exercise-2.B3}

讨论 $s_\vartheta=0$（$\vartheta=0$ 与 $\vartheta=\pi$）时 ZYZ 逆解的行为；再比较 RPY 在 $c_\vartheta=0$ 时能确定哪些角的组合（原书 2.3 相关）。

::: sol 解答

$\vartheta=0$：$R=R_z(\varphi)R_z(\psi)=R_z(\varphi+\psi)$——矩阵只含**和** $\varphi+\psi$，任何满足同一和的 $(\varphi,\psi)$ 都给出同一 $R$（无穷多组角，同一姿态）。$\vartheta=\pi$：利用 $R_y(\pi)R_z(\psi)=R_z(-\psi)R_y(\pi)$（共轭反转轴的转向），$R=R_z(\varphi-\psi)R_y(\pi)$——只含**差** $\varphi-\psi$。结论：退化时只能确定和 / 差，另一独立组合丢失，即 [@thm-2.4.B] 的奇点；工程表现是逆解出的 $\varphi,\psi$ 随微小扰动剧烈跳动。

RPY（原书 2.3）：$\vartheta=+\pi/2$ 时 $R=R_z(\varphi-\psi)R_y(\pi/2)$，只剩**差**；$\vartheta=-\pi/2$ 时 $R=R_z(\varphi+\psi)R_y(-\pi/2)$，只剩**和**。可分别用 $(90°,90°,0°)\sim(120°,90°,30°)$、$(90°,-90°,0°)\sim(60°,-90°,30°)$ 代回验证，不能把两端混写。

:::

:::

::: ex B4 · 角和轴在 $\sin\vartheta=0$ 的逆解（原书 2.5） {#exercise-2.B4}

给出 $\vartheta=0$ 与 $\vartheta=\pi$ 时由 $R$ 求 $(\vartheta,\boldsymbol r)$ 的公式。

::: sol 解答

$\vartheta=0$：$R=I_3$，任何单位向量可作 $\boldsymbol r$（表示奇异，轴完全任意）。$\vartheta=\pi$：由 [@thm-2.5.A] 不妨取正支，$R(\pi,\boldsymbol r)=2\boldsymbol r\boldsymbol r^T-I_3$（式 2.25 中 $c_\vartheta=-1,s_\vartheta=0$），故 $\boldsymbol r\boldsymbol r^T=(R+I)/2$。于是

$$r_i^2=\tfrac12(r_{ii}+1),\qquad r_ir_j=\tfrac12 r_{ij}\ (i\neq j).$$

算法：选对角元最大的那一轴定该分量符号（设 $r_{11}$ 最大：$r_x=\sqrt{(r_{11}+1)/2}$），其余分量由交叉项恢复：$r_y=r_{12}/(2r_x)$、$r_z=r_{13}/(2r_x)$；$\boldsymbol r$ 与 $-\boldsymbol r$ 等价（[@thm-2.5.A]）。最大分量至少 $1/\sqrt3$，避免小分母。对角线只能恢复绝对值，不能省去交叉项。

例如 $R=\begin{bmatrix}0&-1&0\\-1&0&0\\0&0&-1\end{bmatrix}$ 必须得到 $\pm(1,-1,0)/\sqrt2$；全部取正会错把 $R_{12}$ 重建成 $+1$。零角时主旋转向量 $\phi=0$，不能把“轴任意”说成“零向量不唯一”。

:::

:::

::: ex B5 · 旋转的「加法」可交换吗（原书 2.15 + 2.16）

(a) 在最简表示集合上定义 $\boldsymbol\phi_1\oplus\boldsymbol\phi_2:=\mathrm{rep}\big(R(\boldsymbol\phi_1)R(\boldsymbol\phi_2)\big)$。举例说明 $\oplus$ 不满足交换律。(b) 对微小旋转证明：$R_x(d\varphi_x)R_y(d\varphi_y)R_z(d\varphi_z)\,R_x(d\varphi'_x)R_y(d\varphi'_y)R_z(d\varphi'_z)=R_x(d\varphi_x+d\varphi'_x)R_y(d\varphi_y+d\varphi'_y)R_z(d\varphi_z+d\varphi'_z)$（一阶近似）。

::: sol 解答

(a) 取 $\boldsymbol\phi_1$ 表示绕 $z$ 转 $90°$，$\boldsymbol\phi_2$ 表示绕 $y$ 转 $90°$。$R_z(90°)R_y(90°)$ 第一列为 $[0,0,-1]^T$，而 $R_y(90°)R_z(90°)$ 第一列为 $[0,1,0]^T$。两乘积不同，因此 $\oplus$ 不满足交换律。

(b) 令六个角增量的最大绝对值为 $\varepsilon$，令它们按固定比例共同趋于零。基本旋转展开为 $R_k(d\varphi)=I+S_k(d\varphi)+O(\varepsilon^2)$，其中 $S_k(d\varphi)$ 是向量 $d\varphi\,e_k$ 的叉乘矩阵。把两组三转动各自的一阶项记为

$$S=\sum_{k=x,y,z}S_k(d\varphi_k),\qquad S'=\sum_{k=x,y,z}S_k(d\varphi'_k).$$

六因子乘积为 $I+S+S'+O(\varepsilon^2)$。由于 $S_k$ 对角增量线性，右侧三因子乘积也有相同的一阶展开，故两边的差为 $O(\varepsilon^2)$。可取两组三维增量方向 $(1,2,-1)$、$(-2,1,3)$，分别乘步长 $h$ 和 $h/2$ 后比较两边矩阵；足够小时，最大元素误差应约缩为原来的四分之一。可交换的特殊输入可能出现更小误差，按具体输入核对即可。

:::

:::

::: ex B6 · 齐次变换的逆（原书 2.10） {#exercise-2.B6}

用分块矩阵求逆法则证明式 2.45：$A_1^0=\begin{bmatrix}R&\boldsymbol o\\\boldsymbol 0^T&1\end{bmatrix}\Rightarrow(A_1^0)^{-1}=\begin{bmatrix}R^T&-R^T\boldsymbol o\\\boldsymbol 0^T&1\end{bmatrix}$。

::: sol 解答

设 $(A_1^0)^{-1}=\begin{bmatrix}X&\boldsymbol y\\\boldsymbol w^T&z\end{bmatrix}$。要求 $A_1^0(A_1^0)^{-1}=I_4$：

底部行：$\boldsymbol w^T=\boldsymbol 0^T$、$z=1$。顶部块：$RX+\boldsymbol o\boldsymbol w^T=RX=I_3\Rightarrow X=R^{-1}=R^T$（$R\in SO(3)$）；$R\boldsymbol y+\boldsymbol o=\boldsymbol 0\Rightarrow\boldsymbol y=-R^{-1}\boldsymbol o=-R^T\boldsymbol o$。右乘验证 $A^{-1}A=I_4$ 同理。□

逆的旋转块是 $R^{\mathrm T}$，平移块是 $-R^{\mathrm T}o$；非零平移时整体转置不能当逆，平移为 0 时则可以。代入 [例 2.7.B](sec2-7.md#ex-2.7.B) 检查逆平移为 $(-1,2,0)$，并验证点与自由方向往返、末分量各自保持 1 与 0。

:::

:::

## C 组 · 计算与编程

::: ex C1 · Rodrigues 公式的数值验证（原书 2.4） {#exercise-2.C1}

比较角轴正解与五步合成，并验证旋转矩阵的正交性、行列式和不变轴。除固定种子的 1000 个一般输入外，还须测轴 ±z、混合符号轴、零角、半圈与负角；零向量必须报错。

::: sol 解答

以下代码仅用 Python 标准库，可整段运行。函数与矩阵公式都用弧度；方向输入先归一化，五步始终按固定轴合成。

~~~python
import math
import random


def multiply(first, second):
    return [[sum(first[row][inner] * second[inner][column] for inner in range(3))
             for column in range(3)] for row in range(3)]


def matrix_error(first, second):
    return max(abs(first[row][column] - second[row][column])
               for row in range(3) for column in range(3))


def determinant(matrix):
    return sum(matrix[0][column] * (matrix[1][(column + 1) % 3] * matrix[2][(column + 2) % 3]
               - matrix[1][(column + 2) % 3] * matrix[2][(column + 1) % 3]) for column in range(3))


def axis_matrix(direction, angle):
    length = math.hypot(*direction)
    if len(direction) != 3 or not all(math.isfinite(value) for value in direction) or not 0 < length < math.inf:
        raise ValueError("轴必须是非零的有限三维向量")
    if not math.isfinite(angle):
        raise ValueError("角度必须有限")
    axis = [value / length for value in direction]
    skew = [[0, -axis[2], axis[1]], [axis[2], 0, -axis[0]], [-axis[1], axis[0], 0]]
    cosine, sine = math.cos(angle), math.sin(angle)
    return [[cosine * (row == column) + (1 - cosine) * axis[row] * axis[column]
             + sine * skew[row][column] for column in range(3)] for row in range(3)]


def elementary(name, angle):
    cosine, sine = math.cos(angle), math.sin(angle)
    if name == "z":
        return [[cosine, -sine, 0], [sine, cosine, 0], [0, 0, 1]]
    return [[cosine, 0, sine], [0, 1, 0], [-sine, 0, cosine]]


def five_steps(direction, angle):
    if len(direction) != 3 or not all(math.isfinite(value) for value in direction) or math.hypot(*direction) == 0:
        raise ValueError("轴必须是非零的有限三维向量")
    if not math.isfinite(angle):
        raise ValueError("角度必须有限")
    horizontal, vertical, depth = direction
    radius = math.hypot(horizontal, vertical)
    alpha = math.atan2(vertical, horizontal) if radius else 0
    beta = math.atan2(radius, depth)
    result = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    for name, turn in (("z", -alpha), ("y", -beta), ("z", angle), ("y", beta), ("z", alpha)):
        result = multiply(elementary(name, turn), result)
    return result


generator = random.Random(42)
cases = [([generator.uniform(-1, 1) for unused in range(3)], generator.uniform(-math.pi, math.pi))
         for unused in range(1000)]
cases += [(axis, angle) for axis in ([0, 0, 1], [0, 0, -1], [1, -1, 0])
          for angle in (0, math.pi, -math.pi, 1e-8, math.pi - 1e-8)]
identity = [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
maximum = {"five_steps": 0.0, "orthogonal": 0.0, "determinant": 0.0, "axis": 0.0}
for direction, angle in cases:
    rotation = axis_matrix(direction, angle)
    transpose = [list(column) for column in zip(*rotation)]
    axis = [value / math.hypot(*direction) for value in direction]
    maximum["five_steps"] = max(maximum["five_steps"], matrix_error(rotation, five_steps(direction, angle)))
    maximum["orthogonal"] = max(maximum["orthogonal"], matrix_error(multiply(transpose, rotation), identity))
    maximum["determinant"] = max(maximum["determinant"], abs(determinant(rotation) - 1))
    maximum["axis"] = max(maximum["axis"], max(abs(sum(value * component for value, component in zip(row, axis)) - axis[index])
                                             for index, row in enumerate(rotation)))
assert all(value < 1e-12 for value in maximum.values()), maximum
try:
    axis_matrix([0, 0, 0], 0)
except ValueError:
    pass
else:
    raise AssertionError("零向量未报错")
print(len(cases), maximum)
~~~

验收为 1015 个输入的四项误差都小于 $10^{-12}$。再故意把时间顺序当成书写顺序，选一般轴与一般非零角核对差异；特殊可交换情形可能碰巧相同，不能要求每个错误序列都出现 $O(1)$ 差异。逆解的零角/半圈与混合符号任务见 B4 和 [§2.5 练习 1](sec2-5.md#lab-2.5)。

:::

:::
::: ex C2 · 圆柱形臂的正逆运动学（原书 2.12 + 2.19） {#exercise-2.C2}

图 2.35 的圆柱形臂：转动关节（竖直腰）+ 竖直升降移动关节（$d_2$）+ 水平伸缩移动关节（$d_3$）。建 DH 系、列参数表、求正运动学；再由末端位置 $\boldsymbol p$ 反解三个关节变量（逆解结论见 [@thm-2.19]）。

::: sol 解答

建系：$z_0$ 竖直（关节 1 轴）；$z_1$ 竖直（关节 2 轴，$d_2$ 沿它升降）；关节 3 轴水平径向 ⇒ $z_2$ 取水平径向（$\alpha_2=-\pi/2$）；$d_3$ 沿 $z_2$。

| 连杆 | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--|:--:|:--:|:--:|:--:|
| 1 | 0 | 0 | 0 | $\vartheta_1$ |
| 2 | 0 | $-\pi/2$ | $d_2$ | 0 |
| 3 | 0 | 0 | $d_3$ | 0 |

正运动学（本约定下零位径向沿 $y_0$；若你的建系取零位沿 $x_0$，仅 $\vartheta_1$ 多一个常值偏移，方法全同）：

$$T_3^0=\begin{bmatrix}c_1&0&-s_1&-s_1d_3\\ s_1&0&c_1&c_1d_3\\ 0&-1&0&d_2\\ 0&0&0&1\end{bmatrix}.$$

逆解：由 $p_x=-s_1d_3,\ p_y=c_1d_3,\ p_z=d_2$，且伸缩 $d_3>0$：

$$d_2=p_z,\qquad d_3=\sqrt{p_x^2+p_y^2},\qquad \vartheta_1=\operatorname{Atan2}(-p_x,\,p_y).$$

在 $d_3>0$、角度按模 $2\pi$ 理解时，给定可达位置对应一支关节解；实际升降/伸缩行程和转角限位还须筛选。若机构允许 $d_3=0$，轴上目标的 $\vartheta_1$ 任意；若行程严格排除 0，则轴上目标不可达，不能同时声称它有任意腰角解。这类退化可与 §2.12 的肩轴位置任务对照。

:::

:::

::: ex C3 · SCARA 的正运动学（原书 2.13）

本题采用自定的 SCARA 简化模型：R–R–P–R，所有 z 轴竖直同向朝上，杆长 $a_1,a_2$，升降 $d_3$，腕转 $\vartheta_4$；$d_4$ 是第四行的固定工具偏置。建立标准 DH 表并求 $T_4^0$。本题约定不直接替代 [§2.9.3](sec2-9.md#sec-2.9.3) 的原书选系。

::: sol 解答

| 连杆 | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--|:--:|:--:|:--:|:--:|
| 1 | $a_1$ | 0 | 0 | $\vartheta_1$ |
| 2 | $a_2$ | 0 | 0 | $\vartheta_2$ |
| 3 | 0 | 0 | $d_3$ | 0 |
| 4 | 0 | 0 | $d_4$ | $\vartheta_4$ |

所有 z 轴同向，所以全表 $\alpha_i=0$；$d_3$ 是沿 $+z_2$ 的有向距离。不能在保留该表时，又把 $d_3$ 当作向下为正的行程。

$$T_4^0=\begin{bmatrix}
c_{124} & -s_{124} & 0 & a_1c_1+a_2c_{12}\\
s_{124} & c_{124} & 0 & a_1s_1+a_2s_{12}\\
0&0&1&d_3+d_4\\
0&0&0&1
\end{bmatrix}$$

若编码器读数 $q_3$ 向下为正，应先换算 $d_3=d_{30}-q_3$，固定工具偏置也按所选正轴带符号填写。取 $a_1=a_2=1$ m、$\vartheta_1=0$、$\vartheta_2=\pi/2$、$d_3=-0.3$ m、$d_4=-0.1$ m，末端位置应为 $(1,1,-0.4)$ m。结构观察：$d_3,\vartheta_4$ 不影响 $(x,y)$，$\vartheta_1,\vartheta_2$ 不影响 z；这种运动学分解本身不证明刚性或柔性，后者还取决于结构与控制。

:::

:::

::: ex C4 · 三连杆平面臂的工作空间采样（原书 2.17） {#exercise-2.C4}

取 $a_1=0.5,\ a_2=0.3,\ a_3=0.2$（m），限位 $-\pi/3\le\vartheta_1\le\pi/3$、$-2\pi/3\le\vartheta_2\le2\pi/3$、$-\pi/2\le\vartheta_3\le\pi/2$。画出末端原点的位置像，并说明采样能支持什么、不能证明什么。

::: sol 解答

先运行 [§2.10 的两杆演示](sec2-10.md#lab-2.10.workspace)，区分整个关节域、域边界与内部临界集合，再扩展到三杆。下面的随机采样只给近似覆盖；需要 NumPy 与 Matplotlib。

```python
import numpy as np
import matplotlib.pyplot as plt

rng = np.random.default_rng(42)
sample_count = 200_000
first = rng.uniform(-np.pi / 3, np.pi / 3, sample_count)
second = rng.uniform(-2 * np.pi / 3, 2 * np.pi / 3, sample_count)
third = rng.uniform(-np.pi / 2, np.pi / 2, sample_count)
horizontal = .5 * np.cos(first) + .3 * np.cos(first + second) + .2 * np.cos(first + second + third)
vertical = .5 * np.sin(first) + .3 * np.sin(first + second) + .2 * np.sin(first + second + third)
radius = np.hypot(horizontal, vertical)
azimuth = np.arctan2(vertical, horizontal)
plt.scatter(horizontal, vertical, s=.05)
plt.axis("equal")
plt.xlabel("x (m)")
plt.ylabel("y (m)")
plt.show()
print("采样半径范围 (m):", radius.min(), radius.max())
print("采样方位范围 (deg):", np.degrees(azimuth.min()), np.degrees(azimuth.max()))
```

独立核对三个确定事实，不能把随机样本的最值直接当解析边界：

1. 三角不等式给出 $\rho\le0.5+0.3+0.2=1$ m；当后两关节均为 0 时达到 1 m。这些外圆点的方位仅覆盖肩限位 $[-60°,60°]$，因此位置像不是整圆环。
2. 取 $(\vartheta_1,\vartheta_2,\vartheta_3)=(0°,120°,90°)$，直接回代得 $\boldsymbol p=(0.35-0.1\sqrt3,\ 0.15\sqrt3-0.1)$ m，半径约 0.2383 m。这是一个确实可达的检查点；单靠它和散点图，不能证明全域最小半径。
3. 若三关节都放宽到全转且无障碍，最长杆不超过其余两杆之和，三杆能闭合到原点；可达集为半径 1 m 的圆盘。与受限情况比较时，要看整幅覆盖和已知位形，不能只检查两个随机极值。

半径须由 $\operatorname{hypot}(x,y)$ 计算；位置方位为 $\operatorname{Atan2}(y,x)$，与工具朝向 $\vartheta_1+\vartheta_2+\vartheta_3$ 不同。增加样本或换随机种子可观察覆盖是否稳定，仍不构成严格边界证明。若要继续求解析轮廓，须检查关节域各边界面的像和内部临界集合，并筛掉位置像内部的候选弧；不能把关节角点随意连弧当成完整证明。

:::

:::

::: ex C5 · ZYZ / RPY 正逆解闭环（自编） {#exercise-2.C5}

实现式 2.18–2.23；检查两支、四个精确奇点和近奇点。先比较重建矩阵，再判断角是否落在同一分支；不同分支的三个数不必直接相等。

::: sol 解答

下面仅用 Python 标准库，角度单位为弧度。逆解返回主支或奇点代表、输入半径及非奇点标志。

```python
import math

def multiply(first, second):
    return [[sum(first[row][inner] * second[inner][column]
                 for inner in range(3))
             for column in range(3)] for row in range(3)]

def rotation(axis, angle):
    cosine, sine = math.cos(angle), math.sin(angle)
    return {
        "x": [[1, 0, 0], [0, cosine, -sine], [0, sine, cosine]],
        "y": [[cosine, 0, sine], [0, 1, 0], [-sine, 0, cosine]],
        "z": [[cosine, -sine, 0], [sine, cosine, 0], [0, 0, 1]],
    }[axis]

def euler_forward(mode, phi, theta, psi):
    return multiply(multiply(rotation("z", phi), rotation("y", theta)),
                    rotation("z" if mode == "zyz" else "x", psi))

def euler_inverse(mode, matrix):
    if mode == "zyz":
        radius = math.hypot(matrix[0][2], matrix[1][2])
        if radius < 1e-12:
            parallel = matrix[2][2] > 0
            sign = 1 if parallel else -1
            phi = math.atan2(sign * matrix[1][0], sign * matrix[0][0])
            return (phi, 0 if parallel else math.pi, 0), radius, False
        angles = (math.atan2(matrix[1][2], matrix[0][2]),
                  math.atan2(radius, matrix[2][2]),
                  math.atan2(matrix[2][1], -matrix[2][0]))
    else:
        radius = math.hypot(matrix[0][0], matrix[1][0])
        if radius < 1e-12:
            theta = math.pi / 2 if matrix[2][0] < 0 else -math.pi / 2
            phi = math.atan2(-matrix[0][1], matrix[1][1])
            return (phi, theta, 0), radius, False
        angles = (math.atan2(matrix[1][0], matrix[0][0]),
                  math.atan2(-matrix[2][0], radius),
                  math.atan2(matrix[2][1], matrix[2][2]))
    return angles, radius, True

def matrix_error(first, second):
    return max(abs(first[row][column] - second[row][column])
               for row in range(3) for column in range(3))

for mode, middle_angles in [
    ("zyz", [0, 1e-6, 0.7, -0.7, math.pi]),
    ("rpy", [-math.pi / 2, -math.pi / 2 + 1e-6,
             0.7, math.pi / 2 - 1e-6, math.pi / 2]),
]:
    for theta in middle_angles:
        original = euler_forward(mode, 0.4, theta, -0.2)
        angles, radius, regular = euler_inverse(mode, original)
        error = matrix_error(original, euler_forward(mode, *angles))
        assert error < 1e-12, (mode, theta, error)
        print(mode, theta, regular, radius, error)
```

以上十个确定输入覆盖四个端点与近奇点。下面这段接在同一程序后，补上每种表示 1000 个随机输入和第二支的实际验收循环：

```python
import random

generator = random.Random(24)
for mode in ("zyz", "rpy"):
    for _ in range(1000):
        original = euler_forward(mode, *(generator.uniform(-math.pi, math.pi) for _ in range(3)))
        angles, radius, regular = euler_inverse(mode, original)
        assert matrix_error(original, euler_forward(mode, *angles)) < 1e-12
        if regular:
            phi, theta, psi = angles
            other = (phi + math.pi, -theta if mode == "zyz" else math.pi - theta, psi + math.pi)
            assert matrix_error(original, euler_forward(mode, *other)) < 1e-12
print("两种表示各 1000 个随机输入与正常区第二支通过")
```

精确奇点应报告不唯一并能用代表角重建；距奇点 $10^{-6}$ rad 的上述输入仍应能分离。阈值 $10^{-12}$ 是本程序的浮点分支策略，落入该阈值附近的非零输入会按奇点代表近似处理，不是数学上已经严格退化。

近 ZYZ 的 $\vartheta=0$ 时，保持 $\varphi+\psi$ 不变、反向改变两角的变化方向，对矩阵的影响变小；不是说单独改变任一角都没有影响。首末角反解的局部最坏敏感度约为 $1/|\sin\vartheta|$。可沿第三列横向向量的切向加入已知小扰动测方向误差；若直接扰动整个矩阵，要说明它可能已不属于 $SO(3)$，不能无条件套旋转矩阵恒等式。

:::

:::

::: ex C6 · 通用 DH 正运动学函数与逆解数值验证（自编） {#exercise-2.C6}

写一个 `fk(dh, q) -> T`，用它重现三连杆平面臂与拟人臂的正运动学；再实现平面 3R 臂的位姿逆解，与局部数值求解比较。任务沿用 [例 2.12.D](sec2-12.md#ex-2.12.D)：给定 $(p_x,p_y,\phi)$，长度用 m，角度用 rad，暂不设关节限位。必须分开返回有限解、连续族与无解，不能用一个特殊代表冒充整个连续族。

::: sol 解答

先从工具方向回退第三杆，得腕心 $w=(p_x-a_3\cos\phi,p_y-a_3\sin\phi)$。检查容许条件后取两种 $s_2$，并用

$$\vartheta_1=\operatorname{Atan2}(w_y,w_x)-\operatorname{Atan2}(a_2s_2,a_1+a_2c_2),\qquad
\vartheta_3=\phi-\vartheta_1-\vartheta_2.$$

这避免了用 $\|w\|^2$ 直接作分母，但**仍须先处理零腕心**：等杆长时用 $(\gamma,\pi,\phi-\gamma-\pi)$ 表示一族；不等杆长时无解。共线边界两支合并，角度按模 $2\pi$ 去重。下面的余弦截断只容忍机器舍入，明显越界必须返回无解。

完整脚本可[下载后直接运行](../assets/code/ch02-planar-ik.py)：`python3 ch02-planar-ik.py`。其中 R 行 `theta=None`、P 行 `d=None`，每行排列为 $(a,\alpha,d,\vartheta)$；本接口不自动叠加编码器零偏，需先换算变量。基座/工具在函数外按 $T_0^bT_n^0T_e^n$ 串接。

核对输出和模型边界：

| 输入/任务 | 应得到什么 |
|---|---|
| 两前杆各 1 m、末杆 0.5 m，目标 $(1.5,1,0)$ | 两支 $(0,\pi/2,-\pi/2)$、$(\pi/2,-\pi/2,0)$，位置与指向都回代正确 |
| 同杆长，目标 $(0.5,0,0)$ | `family`，由 `folded_family(gamma, 0)` 生成连续族 |
| 前两杆改成 1 m / 0.8 m，仍为零腕心 | `none`，不能消掉长度差 |
| 同杆长，目标 $(3.5,0,0)$ | `none`，不输出 NaN，也不强制投影到可达边界 |
| 固定种子生成 100 组关节角，先正解得到目标 | 对每个目标返回的所有有限支逐个回代，位置与角度误差均小于 $10^{-12}$ |

此外，复算 [§2.8 混合链练习](sec2-8.md#practice-2.8.chain)，再取拟人臂 $q=0$，检查 $p=(a_2+a_3,0,0)$。这些检查各针对不同接口，不能只用平面臂给通用 FK 函数背书。

数值对照使用两个明确初值，对同一例题得到两支；先检查求解状态和残差，再按角度周期去重。位置残差除以 1 m、角残差除以 1 rad 是本例的尺度约定，真实任务须按精度要求选择。`least_squares` 寻找局部极小值，多初值可以找到多支，但不保证收敛或枚举全部解；详见 [SciPy 接口说明](https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.least_squares.html)。本题结构的解析枚举在列全分支、单独处理退化并筛选约束后才能谈“完整”。

先写下预期状态，再运行以下完整程序，逐项对照上表。`pose_error` 将角度差按周期处理；不能把 $\pi$ 与 $-\pi$ 直接相减后当作姿态误差。

~~~python
{{#include ../assets/code/ch02-planar-ik.py}}
~~~

:::

:::

## D 组 · 开放研讨

::: ex D1 · 拟人臂：同一目标的解支如何计数（原书 2.18 相关） {#exercise-2.D1}

沿用 §2.12 的拟人臂位置映射，$a_2,a_3>0$，忽略限位、角度按模 $2\pi$ 理解。对**固定的同一个腕心目标**，讨论 $s_3=0$ 的解数：① 离开肩轴；② 在肩轴上；③ 等杆长全折回原点。再以 $a_2=0.5,a_3=0.3$ m 比较目标 $(0.8,0,0)$、$(0.2,0,0)$ 和 $(0.5,0,0.3)$ m。

::: sol 解答

先用目标半径 $r=\|p_w\|$ 决定 $c_3=(r^2-a_2^2-a_3^2)/(2a_2a_3)$。$s_3=0$ 对应外边界 $r=a_2+a_3$（伸直）或内边界 $r=|a_2-a_3|$（折回）。两种半径不同，**不能把两个不同目标的解相加成同一目标的四支**。

**离轴，$\rho=\sqrt{p_{wx}^2+p_{wy}^2}>0$。** 令 $\alpha=\operatorname{Atan2}(p_{wy},p_{wx})$，$\sigma=\pm1$ 表示径向分量的两种符号。固定目标已经决定 $\vartheta_3=0$ 或 $\pi$；记有向有效杆长 $A=a_2+a_3c_3$，则

$$\vartheta_1=\begin{cases}\alpha,&\sigma=+1,\\\alpha+\pi,&\sigma=-1,\end{cases}\qquad
\vartheta_2=\operatorname{Atan2}\!\left(\frac{p_{wz}}{A},\frac{\sigma\rho}{A}\right).$$

此处 $A\ne0$，共 **2 支**，是肘的两支合并后剩下的两种肩姿。折回且 $a_2<a_3$ 时 $A<0$，上式仍成立；若未经补角就把 A 换成绝对值，会漏掉 $\pi$ 的方向变化。

**肩轴上，$\rho=0$、目标非零。** 在上述内/外边界，$p_{wz}=\pm|A|$，$\vartheta_2=\operatorname{Atan2}(p_{wz}/A,0)$，而 $\vartheta_1$ 任意，得到一参数连续族。若是等杆长、$\vartheta_3=\pi$ 且目标为原点，则 A=0：前两段位置贡献恒相消，$\vartheta_1,\vartheta_2$ 都可任意，是二维连续族，不能套前式除以 A。

带数核对：外边界目标 $(0.8,0,0)$ 得 $(0,0,0)$、$(\pi,\pi,0)$；内边界目标 $(0.2,0,0)$ 得 $(0,0,\pi)$、$(\pi,\pi,\pi)$。普通目标 $(0.5,0,0.3)$ 的 $c_3=0$，肘和肩各有两选，才是通常的四支。每一支都要代回三个位置分量；这里计算的是腕心**位置任务**，还没有限制整臂末端姿态。

下面的函数只分类**内外边界目标**，不替代一般逆解器；`None` 表示可自由选取的关节角。边界比较用 $10^{-12}$ m 的数值容差。

```python
import math

def boundary_positions(a2, a3, target):
    if a2 <= 0 or a3 <= 0 or not all(math.isfinite(value) for value in (a2, a3, *target)):
        raise ValueError("正杆长与目标必须有限")
    x, y, z = target
    radius, rho = math.hypot(x, y, z), math.hypot(x, y)
    if math.isclose(radius, a2 + a3, rel_tol=0, abs_tol=1e-12):
        third, effective = 0.0, a2 + a3
    elif math.isclose(radius, abs(a2 - a3), rel_tol=0, abs_tol=1e-12):
        third, effective = math.pi, a2 - a3
    else:
        return "not_boundary", []
    if effective == 0:
        return ("two_parameters", [(None, None, third)]) if radius == 0 else ("not_boundary", [])
    if rho == 0:
        return "one_parameter", [(None, math.atan2(z / effective, 0), third)]
    alpha = math.atan2(y, x)
    angles = [(alpha + (0 if sign == 1 else math.pi),
               math.atan2(z / effective, sign * rho / effective), third)
              for sign in (1, -1)]
    return "finite", angles

for point in ((0.8, 0, 0), (0.2, 0, 0), (0, 0, 0.8), (0.5, 0, 0.3)):
    print(point, boundary_positions(0.5, 0.3, point))
```

:::

:::

::: ex D2 · 标定实验：先辨识，再谈误差（自编） {#exercise-2.D2}

设计并运行非线性标定实验：固定基座、工具和关节 2 零位，只估计平面 2R 臂的两杆长 $a_1,a_2$ 与关节 1 零偏 $\beta$。比较无噪声/有噪声结果，检查量测不足、不可辨识和近相关三种情况，并用独立位形判断预测是否准确。先操作 [§2.11 标定演示](sec2-11.md#lab-2.11.calibration)，再解释本题为什么比“两长度线性估计”多了一层迭代。

::: sol 解答

选 $\xi=(a_1,a_2,\beta)$，模型为

$$p_x=a_1\cos(q_1+\beta)+a_2\cos(q_1+\beta+q_2),\qquad
p_y=a_1\sin(q_1+\beta)+a_2\sin(q_1+\beta+q_2).$$

真值为 $(1.004\ \mathrm m,0.797\ \mathrm m,0.006\ \mathrm{rad})$，初值为 $(1\ \mathrm m,0.8\ \mathrm m,0)$。每个位形测 $(p_x,p_y)$，60 组共 120 个方程，但这不自动保证三个参数都可辨识。用解析灵敏度对当前参数线性化、堆叠残差，再用 `lstsq` 求更新量；每轮重新计算模型和矩阵。长度按 1 cm、零偏按 10 mrad 缩放后再比较条件数。程序通过回溯选择能降低残差的更新，不要求每次更新量的模单调下降。

完整程序可[下载运行](../assets/code/ch02-calibration.py)：`python3 ch02-calibration.py`。

逐项读输出，不能只看“拟合成功”：

| 对照 | 应检查的证据 |
|---|---|
| 无噪声、分散的 60 组位形 | 列秩为 3，迭代更新后三参数误差小于 $10^{-10}$；独立位形的预测也准确 |
| 位置噪声各分量独立，$\sigma=0.05$ mm | 同时记录参数误差、残差和 80 组未参与拟合的位形上的预测误差；单次估计不必恰好等于真值 |
| 只有 1 个位形 | 2 个方程少于 3 个参数，拒绝宣称唯一恢复 |
| 60 个位形都令 $q_2=0$ | 两长度的灵敏度列完全相同；改变 $q_1$ 或重复量测不能分开 $a_1,a_2$ |
| $q_2$ 仅从 0.7 变化到 0.701 rad | 可满秩但条件数显著增大；记录缩放和分布后，才能比较“病态”程度 |

在独立同方差小噪声、模型正确且列满秩的局部近似下，参数协方差约为 $\sigma^2(\Phi^{\mathrm T}\Phi)^{-1}$；实现通过缩放后的 SVD 计算，不显式求正规方程的逆。它的各对角元分别有 m²、m²、rad² 单位，不可把所有参数误差都直接写成“噪声/√样本数”。程序固定量测设计，重复 200 组独立噪声，将经验标准差与局部预测比较；这只检验该模型与设计的小噪声近似，不证明任意单次估计必达某个理论下界。

线性更新的返回秩和奇异值含义见 [NumPy `lstsq` 文档](https://numpy.org/doc/stable/reference/generated/numpy.linalg.lstsq.html)。若要扩展为更多 DH、基座或工具参数，必须重新检查参数规范与可辨识方向，不能按表项数直接要求全部恢复。

下面程序依次生成量测、检查无噪声更新、加入噪声、保留独立验证集，再运行两种秩不足对照和 200 组噪声重复实验。先读上表理解每项输出，再逐函数核对计算过程。

~~~python
{{#include ../assets/code/ch02-calibration.py}}
~~~

:::

:::

::: ex D3 · 从角和轴到四元数的自学路线（自编）

以 [@def-2.5.1] 与 [2.4.5](sec2-4.md#sec-2.4.5) 预告框为起点，以原书 §2.6 为主并结合本编提取勘误，设计自学路线：检查半角打包保留的重复表示，用精确半圈检验提取公式，再用两个固定轴旋转核对乘法顺序。

::: sol 解答

路线：(1) 检查半角打包满足单位约束；(2) 代入正解，与 C1 的角轴矩阵比较；(3) 代入同步反号参数与转角加整圈参数，分别得到 Q 与 −Q；(4) 在 [§2.6 演示](sec2-6.md#lab-2.6) 载入精确混合符号半圈，记录原书符号法重建差 2、最大分量法重建差约 0，并解释为何反对称差全零不能定相对符号；(5) 按 [例 2.6.C](sec2-6.md#ex-2.6.C) 复算先 z 后 x 的乘积。原书式 2.34–2.35 的边界问题见 [E2.7](errata.md#errata-2.7)。双重覆盖仍保留；选代表也不保证跨半圈连续。

:::

:::

::: ex D4 · SCARA 全流程贯通（自编）

把 [1.2.2](../ch01/sec1-2.md#sec-1.2.2) 的 SCARA 构形知识与本章串成一条链：构形判断 → DH 表（C3）→ 正运动学特征 → 逆解 → 选型复核。写出 C3 模型对 $(x,y,z,\phi)$ 的逆式；每步说明所用依据及条件，区分运动学结论与刚度、控制性能要求。

::: sol 解答

先确定本题采用 C3 的同向轴模型：两次平面回转、一次竖直移动、一次工具回转。SCARA 常见设计追求水平面顺从、竖直方向较刚，不能写成“竖直柔性”；具体刚度仍须查结构与控制数据，不能从 DH 表直接推出。

同向相邻轴才令本表 $\alpha_i=0$；仅知轴线平行，还可能采用反向正轴。给定任务 $(x,y,z,\phi)$，由 C3 的正解反求：

$$\begin{aligned}
c_2&=\frac{x^2+y^2-a_1^2-a_2^2}{2a_1a_2},\\
\vartheta_2&=\operatorname{Atan2}(\pm\sqrt{1-c_2^2},c_2),\\
\vartheta_1&=\operatorname{Atan2}(y,x)-\operatorname{Atan2}(a_2s_2,a_1+a_2c_2).
\end{aligned}$$
$$d_3=z-d_4,\qquad \vartheta_4=\phi-\vartheta_1-\vartheta_2.$$

先查 $|c_2|\le1$，零半径和共线情形沿用平面臂的单独处理；再按各关节行程与角限位筛选。一般非退化时两支，共线时合并，等长折回零半径时可有连续族；不应把“两支”写成对所有目标都成立。四关节与 $(x,y,z,\phi)$ 四个任务量在正常点可对应，但还须满任务秩；不能实现任意六维位姿。最后按插装方向、工作范围、负载与刚度数据复核选型，回到 [§1.2 的任务条件](../ch01/sec1-2.md#sec-1.2.2)。

:::

:::

依据 Siciliano 等《机器人学：建模、规划与控制》第二章相关主题整理扩充；本页修订与验证范围见逐页审读记录。
