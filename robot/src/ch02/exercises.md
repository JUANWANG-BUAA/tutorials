# 习题集

原书第 2 章共 **20** 道习题（p.74–76，2.1–2.20）。本编以 10 框收录其中 **14 个题号**——B3 的解答兼给对偶的原书 2.3 的答案；B5 = 原书 2.15+2.16、C2 = 原书 2.12+2.19 各并两题；D4 第 (4) 步即原书 2.20（SCARA 逆解）的求解结构。四元数 2.6–2.9 与闭链 2.11 超出课程范围未选；类人机械手 2.14 存目（其正运动学即 [2.9.9](sec2-9.md#sec-2.9.9)）。另自编 10 题，共 20 框，按 A（概念判断 4）、B（分析证明 6）、C（计算编程 6）、D（开放研讨 4）分层，**全部附解答**（默认折叠）。标「原书 2.x」者与原书逐条对照；代码题给验收标准。

::: method A / B 组的自评标准（C / D 组另给验收标准）

- **A 组（概念判断）**：达标要求是「**判对 + 说得出依据**」。例如 A1 不只说「三重身份」，而要指出每一问用到的**是**哪一重身份以及**为什么**。
- **B 组（分析证明）**：按「**思路 → 关键步 → 结论**」三步自评。本编 B 组多为证明题，判分点在三处：起点（用了哪条性质）、中间不等式的方向或符号、结论的适用条件（如「$s_\vartheta\neq0$ 时」）。
- **通用扣分点**：上下标读反；$R^{-1}=R^{\mathrm T}$ 用在齐次变换上；漏掉第二支解或符号分支；把 $\boldsymbol\phi$ 当向量相加。

:::

## A 组 · 概念判断

::: ex A1 · 三重身份对号

（对应 [@thm-2.2.B]。）下列计算分别用到旋转矩阵的哪重身份？(a) 把相机系下测到的点坐标换算到机器人基座系；(b) 描述工具相对法兰的姿态；(c) 把刀尖向量绕刀轴转 $30°$ 做倒角。

::: sol 解答

(a) 坐标变换（原点重合 / 配合齐次变换处理平移）；(b) 姿态描述（列 = 工具系轴在法兰系中的方向余弦）；(c) 旋转算子（同系内旋转向量、模长不变）。三重身份同一矩阵、三种读法——选哪种只取决于你在「说」什么。

:::

:::

::: ex A2 · 可行的欧拉角序列

(a) 三个基本旋转共 27 种组合，为什么只有 12 种可行？(b) 判断下列序列是否可行，并说明它属于「绕当前轴」还是「绕固定轴」家族的哪个成员：$ZYZ$、$ZYX$、$XXZ$、$XZX$。

::: sol 解答

(a) 相邻两次绕平行轴的旋转可合并为一次，三个角实际只剩两个自由方向，无法覆盖 $SO(3)$；「相邻不同轴」的组合 $3\times2\times2=12$ 种才可行（录播 0:07:57–0:08:28）。(b) $XXZ$ 不可行（前两轴平行）；$ZYZ$、$XZX$、$ZYX$ 可行——其中 $ZYZ$ 是机器人学惯用的绕当前轴右乘族（[2.4.2](sec2-4.md#sec-2.4.2)）；$ZYX$ 是 RPY，按固定轴左乘定义（[2.4.5](sec2-4.md#sec-2.4.5)）；$XZX$ 可行但工程少用（原书习题 2.1 以它为练习）。

:::

:::

::: ex A3 · 右乘还是左乘？

写出下列旋转序列的乘积顺序并说明依据：(a) ZYZ 欧拉角；(b) RPY 角；(c) [2.5](sec2-5.md) 节把任意轴 $\boldsymbol r$ 转到 $z$ 轴的三步操作；(d) 机械手关节链 $0\to1\to2\to3$ 的姿态合成。

::: sol 解答

(a) 右乘 $R_z(\varphi)R_{y'}(\vartheta)R_{z''}(\psi)$——每次绕**当前**轴（[@thm-2.3.A]）；(b) 左乘 $R_z(\varphi)R_y(\vartheta)R_x(\psi)$——每次绕**固定**轴（[@thm-2.3.B]）；(c) 左乘 $R_z(\alpha)R_y(\beta)R_z(\vartheta)R_y(-\beta)R_z(-\alpha)$——全程绕固定系（录播 0:25:40）；(d) 右乘 $R_3^0=R_1^0R_2^1R_3^2$——关节依次绕新系轴（录播 0:30:26）。

:::

:::

::: ex A4 · DH 参数账本

(a) $n$ 关节开链共多少个 DH 参数？其中常数、变量各多少？(b) 对 SCARA（R–R–P–R，四轴竖直平行）逐行判断哪个参数是变量。(c) 转动关节的 $d_i$、移动关节的 $\vartheta_i$ 是什么？

::: sol 解答

(a) $4n$ 个；每行「3 常 1 变」，全表常数 $3n$、变量 $n$（[@def-2.8.3]）。(b) 四行变量都在 $\vartheta$ 列（$\vartheta_1,\vartheta_2,\vartheta_4$）与 $d$ 列（第 3 行 $d_3$），且四轴平行 ⇒ 全表 $\alpha_i=0$。(c) 都是**常数**——「杆件长度和扭角是不动的，距离这两个或转角，根据关节类型二选一当变量」（录播 1:03:57–1:04:31）。

:::

:::

## B 组 · 分析证明

::: ex B1 · ZXZ 欧拉角（原书 2.1）

推导 ZXZ 欧拉角（绕当前轴：先 $z$ 转 $\varphi$、再新 $x'$ 转 $\vartheta$、再新 $z''$ 转 $\psi$）的合成矩阵，并给出由 $R=[r_{ij}]$ 反解三角的公式。

::: sol 解答

$$R=R_z(\varphi)R_{x'}(\vartheta)R_{z''}(\psi)=\begin{bmatrix}
c_\varphi c_\psi-s_\varphi c_\vartheta s_\psi & -c_\varphi s_\psi-s_\varphi c_\vartheta c_\psi & s_\varphi s_\vartheta\\
s_\varphi c_\psi+c_\varphi c_\vartheta s_\psi & -s_\varphi s_\psi+c_\varphi c_\vartheta c_\psi & c_\varphi s_\vartheta\\
s_\vartheta s_\psi & s_\vartheta c_\psi & c_\vartheta
\end{bmatrix}.$$

对比第三列与第三行（设 $s_\vartheta>0$）：$\varphi=\operatorname{Atan2}(r_{13},r_{23})$，$\vartheta=\operatorname{Atan2}\big(\sqrt{r_{13}^2+r_{23}^2},r_{33}\big)$，$\psi=\operatorname{Atan2}(r_{31},r_{32})$；$s_\vartheta<0$ 时各宗量整体变号（对照 [2.4.4](sec2-4.md#sec-2.4.4) 两支解结构——任何「相邻不同轴」序列的逆解都长这样）。

:::

:::

::: ex B2 · 旋转矩阵的等距性（自编）

证明：(a) $\|R\boldsymbol p\|=\|\boldsymbol p\|$ 且 $(R\boldsymbol p)^T(R\boldsymbol q)=\boldsymbol p^T\boldsymbol q$；(b) $R^T$ 也是旋转矩阵（从而逆变换不改变长度与夹角）。（原书 2.7 问的是四元数版的同类不变性，属超范围内容，见 D3 自学路线。）

::: sol 解答

(a) $(R\boldsymbol p)^T(R\boldsymbol q)=\boldsymbol p^TR^TR\,\boldsymbol q=\boldsymbol p^T\boldsymbol q$（$R^TR=I$），取 $\boldsymbol q=\boldsymbol p$ 得模长不变。(b) $(R^T)^TR^T=(RR^T)^T=I$；$\det(R^T)=\det(R)=1$。故 $R^T\in SO(3)$——这正是「行的方向余弦」解释（[2.3.1](sec2-3.md#sec-2.3.1) 末）成立的原因。

:::

:::

::: ex B3 · ZYZ 的退化支（原书 2.2，兼答 2.3）

讨论 $s_\vartheta=0$（$\vartheta=0$ 与 $\vartheta=\pi$）时 ZYZ 逆解的行为；并给出 RPY 在 $c_\vartheta=0$ 时的对偶结论（原书 2.3）。

::: sol 解答

$\vartheta=0$：$R=R_z(\varphi)R_z(\psi)=R_z(\varphi+\psi)$——矩阵只含**和** $\varphi+\psi$，任何满足同一和的 $(\varphi,\psi)$ 都给出同一 $R$（无穷多组角，同一姿态）。$\vartheta=\pi$：利用 $R_y(\pi)R_z(\psi)=R_z(-\psi)R_y(\pi)$（共轭反转轴的转向），$R=R_z(\varphi-\psi)R_y(\pi)$——只含**差** $\varphi-\psi$。结论：退化时只能确定和 / 差，另一独立组合丢失，即 [@thm-2.4.B] 的奇点；工程表现是逆解出的 $\varphi,\psi$ 随微小扰动剧烈跳动。

RPY 对偶（原书 2.3）：$R=R_z(\varphi)R_y(\vartheta)R_x(\psi)$，$\vartheta=\pi/2$ 时数值验证只剩**和** $\varphi+\psi$、$\vartheta=-\pi/2$ 时只剩**差** $\varphi-\psi$（把上面 ZYZ 的 $R_y(\pi)$ 换成 $R_y(\pm\pi/2)$ 同法可证）——与 [2.4.5](sec2-4.md#sec-2.4.5) 末「只能确定 $\varphi$ 与 $\psi$ 的和或差」互为印证。

:::

:::

::: ex B4 · 角和轴在 $\sin\vartheta=0$ 的逆解（原书 2.5）

给出 $\vartheta=0$ 与 $\vartheta=\pi$ 时由 $R$ 求 $(\vartheta,\boldsymbol r)$ 的公式。

::: sol 解答

$\vartheta=0$：$R=I_3$，任何单位向量可作 $\boldsymbol r$（表示奇异，轴完全任意）。$\vartheta=\pi$：由 [@thm-2.5.A] 不妨取正支，$R(\pi,\boldsymbol r)=2\boldsymbol r\boldsymbol r^T-I_3$（式 2.25 中 $c_\vartheta=-1,s_\vartheta=0$），故 $\boldsymbol r\boldsymbol r^T=(R+I)/2$。于是

$$r_i^2=\tfrac12(r_{ii}+1),\qquad r_ir_j=\tfrac12 r_{ij}\ (i\neq j).$$

算法：选对角元最大的那一轴定该分量符号（设 $r_{11}$ 最大：$r_x=\sqrt{(r_{11}+1)/2}$），其余分量由交叉项恢复：$r_y=r_{12}/(2r_x)$、$r_z=r_{13}/(2r_x)$；$(\boldsymbol r)$ 与 $(-\boldsymbol r)$ 等价（[@thm-2.5.A]）。最大对角元准则保证分母不接近零（数值稳定性——与 [@thm-2.4.A] 同一思想）。

:::

:::

::: ex B5 · 旋转的「加法」可交换吗（原书 2.15 + 2.16）

(a) 在最简表示集合上定义 $\boldsymbol\phi_1\oplus\boldsymbol\phi_2:=\mathrm{rep}\big(R(\boldsymbol\phi_1)R(\boldsymbol\phi_2)\big)$。举例说明 $\oplus$ 不满足交换律。(b) 对微小旋转证明：$R_x(d\varphi_x)R_y(d\varphi_y)R_z(d\varphi_z)\,R_x(d\varphi'_x)R_y(d\varphi'_y)R_z(d\varphi'_z)=R_x(d\varphi_x+d\varphi'_x)R_y(d\varphi_y+d\varphi'_y)R_z(d\varphi_z+d\varphi'_z)$（一阶近似）。

::: sol 解答

(a) 取 $\boldsymbol\phi_1$ = 绕 $z$ 转 $90°$、$\boldsymbol\phi_2$ = 绕 $y$ 转 $90°$（同为 ZYZ / RPY 任一具体化均可）：$R_z(90°)R_y(90°)$ 第一列为 $[0,0,-1]^T$，而 $R_y(90°)R_z(90°)$ 第一列为 $[0,1,0]^T$，两乘积不同——「先转这个再转那个，反过来结果不一样」（录播 0:07:01）。$\oplus$ 继承了矩阵乘法的不可交换性。(b) 对微小角 $\cos(d\varphi)\approx1,\ \sin(d\varphi)\approx d\varphi$，基本旋转 $R_k(d\varphi)=I+S_k(d\varphi)+O(d\varphi^2)$，$S_k$ 为反对称阵。多因子乘积保留一阶项：

$$(I+S_1)(I+S_1')=I+S_1+S_1'+O(d\varphi^2),$$

反对称阵相加可交换，合并二阶以上项后即得恒等式。几何意义：**微小旋转在忽略二阶效应时像向量一样可加**——角速度 / 微分运动学（第 3 章）成立的代数根源。

:::

:::

::: ex B6 · 齐次变换的逆（原书 2.10）

用分块矩阵求逆法则证明式 2.45：$A_1^0=\begin{bmatrix}R&\boldsymbol o\\\boldsymbol 0^T&1\end{bmatrix}\Rightarrow(A_1^0)^{-1}=\begin{bmatrix}R^T&-R^T\boldsymbol o\\\boldsymbol 0^T&1\end{bmatrix}$。

::: sol 解答

设 $(A_1^0)^{-1}=\begin{bmatrix}X&\boldsymbol y\\\boldsymbol w^T&z\end{bmatrix}$。要求 $A_1^0(A_1^0)^{-1}=I_4$：

底部行：$\boldsymbol w^T=\boldsymbol 0^T$、$z=1$。顶部块：$RX+\boldsymbol o\boldsymbol w^T=RX=I_3\Rightarrow X=R^{-1}=R^T$（$R\in SO(3)$）；$R\boldsymbol y+\boldsymbol o=\boldsymbol 0\Rightarrow\boldsymbol y=-R^{-1}\boldsymbol o=-R^T\boldsymbol o$。右乘验证 $A^{-1}A=I_4$ 同理。□

注意逆的旋转块是 $R^T$ 但平移块要**先转置再反向**，「整体转置」不成立（$A^{-1}\neq A^T$，原书式 2.46）。

:::

:::

## C 组 · 计算与编程

::: ex C1 · Rodrigues 公式的数值验证（原书 2.4）

编程验证式 2.25：随机生成 1000 组 $(\vartheta,\boldsymbol r)$（$\boldsymbol r$ 归一化），比较 $R(\vartheta,\boldsymbol r)$ 与「五步合成」$R_z(\alpha)R_y(\beta)R_z(\vartheta)R_y(-\beta)R_z(-\alpha)$，报告最大元素偏差。

::: sol 解答

参考实现（Python / NumPy）：

```python
import numpy as np
rng = np.random.default_rng(42)
def Rz(t): c,s=np.cos(t),np.sin(t); return np.array([[c,-s,0],[s,c,0],[0,0,1.]])
def Ry(t): c,s=np.cos(t),np.sin(t); return np.array([[c,0,s],[0,1.,0],[-s,0,c]])
def rodrigues(th, r):
    r = r/np.linalg.norm(r); K = np.array([[0,-r[2],r[1]],[r[2],0,-r[0]],[-r[1],r[0],0]])
    return (1-np.cos(th))*np.outer(r,r) + np.cos(th)*np.eye(3) + np.sin(th)*K
err = 0.0
for _ in range(1000):
    r = rng.normal(size=3); th = rng.uniform(-np.pi, np.pi)
    a = np.arctan2(r[1], r[0]); b = np.arctan2(np.hypot(r[0],r[1]), r[2])
    R5 = Rz(a)@Ry(b)@Rz(th)@Ry(-b)@Rz(-a)
    err = max(err, np.abs(R5 - rodrigues(th, r)).max())
print(err)   # 典型输出量级 1e-15
```

验收：最大偏差 $<10^{-12}$；同时校验 $R^TR=I$、$\det R=1$。若把五步序列误写成右乘顺序，偏差将是 $O(1)$——这个「错误实验」值得顺手做一遍以体会 [@thm-2.3.B]。

:::

:::

::: ex C2 · 圆柱形臂的正逆运动学（原书 2.12 + 2.19）

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

解唯一（$d_3>0$ 约定下）；$\boldsymbol p$ 在轴线上（$d_3=0$）时 $\vartheta_1$ 任意——又一个「轴上奇异」实例，与 [@thm-2.12.C] 后的肩奇异同型。

:::

:::

::: ex C3 · SCARA 的正运动学（原书 2.13）

对 SCARA 机械手（R–R–P–R，四轴全部竖直平行，杆长 $a_1,a_2$，升降 $d_3$，腕转 $\vartheta_4$；另计自加的工具偏置 $d_4$——原书 2.13 官方参数表无此行，加上它只是把腕旋转中心沿 $z$ 平移一个常值）建立 DH 表并求 $T_4^0$。

::: sol 解答

| 连杆 | $a_i$ | $\alpha_i$ | $d_i$ | $\vartheta_i$ |
|:--|:--:|:--:|:--:|:--:|
| 1 | $a_1$ | 0 | 0 | $\vartheta_1$ |
| 2 | $a_2$ | 0 | 0 | $\vartheta_2$ |
| 3 | 0 | 0 | $d_3$ | 0 |
| 4 | 0 | 0 | $d_4$ | $\vartheta_4$ |

（全表 $\alpha_i=0$：四轴平行 + 原点全在公垂线上，[@method-2.8.zero] 的极致。）

$$T_4^0=\begin{bmatrix}
c_{124} & -s_{124} & 0 & a_1c_1+a_2c_{12}\\
s_{124} & c_{124} & 0 & a_1s_1+a_2s_{12}\\
0&0&1&-(d_3+d_4)\\
0&0&0&1
\end{bmatrix}$$

（$z$ 轴向上、$d_3$ 向下伸缩的约定下末端高度为 $-(d_3+d_4)$；若定义 $d_3$ 向上为正则去掉负号——**符号随建系约定，结构不变**。）结构观察：$d_3,\vartheta_4$ 不影响 $(x,y)$、$\vartheta_1,\vartheta_2$ 不影响 $z$——定位（臂）与装配（轴 + 腕）天然解耦，正是 [1.2.2](../ch01/sec1-2.md#sec-1.2.2) SCARA「竖直刚性 + 水平柔性」的运动学注脚。

:::

:::

::: ex C4 · 三连杆平面臂的工作空间作图（原书 2.17）

取 $a_1=0.5,\ a_2=0.3,\ a_3=0.2$（m），限位 $-\pi/3\le\vartheta_1\le\pi/3$、$-2\pi/3\le\vartheta_2\le2\pi/3$、$-\pi/2\le\vartheta_3\le\pi/2$。编程画出末端原点的工作空间并描述其边界。

::: sol 解答

```python
import numpy as np, matplotlib.pyplot as plt
rng = np.random.default_rng(42)
N = 200_000
a1, a2, a3 = 0.5, 0.3, 0.2
t1 = rng.uniform(-np.pi/3, np.pi/3, N)
t2 = rng.uniform(-2*np.pi/3, 2*np.pi/3, N)
t3 = rng.uniform(-np.pi/2, np.pi/2, N)
x = a1*np.cos(t1) + a2*np.cos(t1+t2) + a3*np.cos(t1+t2+t3)
y = a1*np.sin(t1) + a2*np.sin(t1+t2) + a3*np.sin(t1+t2+t3)
r, phi = np.hypot(x, y), np.arctan2(y, x)   # 半径、方位角必须由末端坐标计算
plt.scatter(x, y, s=0.05); plt.axis('equal'); plt.show()
print(r.min(), r.max(), np.degrees(phi.min()), np.degrees(phi.max()))
# 典型输出：r∈[0.2383, 1.0000]，φ∈[−123.9°, +123.9°]
```

两个易错点：**半径**用 $\sqrt{x^2+y^2}$（不是 $x$ 分量）；**方位角**用 $\operatorname{Atan2}(y,x)$（不是 $\vartheta_1+\vartheta_2+\vartheta_3$——末端姿态角与位置方位角一般不相等）。初版本解两处皆误，「画」出了与错误结论吻合的整环，是「代码与结论互相印证着错」的典型。

解析刻画（对照官方解 Fig. S2.4）：工作空间**不是整圆环**，而是一块**环形扇域**——

- **径向全域** $r\in[0.238,\,1.0]$：外径 $=a_1+a_2+a_3=1$（$\vartheta_2=\vartheta_3=0$ 臂全伸直）；内径 $0.238$ 由 $\vartheta_2=\pm\frac{2\pi}{3}$ **且 $\vartheta_3$ 取同号** $\pm\frac{\pi}{2}$ 生成（前臂回折贴向基座；若 $\vartheta_3$ 反号得 $r=0.635$，是内部结构而非内边界）；
- **方位角全域** $\varphi\in[-123.9°,\,+123.9°]$，不足整圆也随 $r$ 变化：$r=1$ 处仅 $\pm60°$（肩限位 $\vartheta_1=\pm\pi/3$），$r=0.5$ 处张到 $\pm120°$，最宽 $\pm123.9°$ 在 $r\approx0.39$ 的侧弧上；
- **边界全由圆弧拼成**（官方解法）：列出所有「丧失机动性」的临界位形——8 个关节限位角点、$\vartheta_2=0$ 的 4 个、$\vartheta_3=0$ 的 4 个、双零的 2 个——在笛卡儿空间把**只差一个分量**的两点用弧相连，外轮廓 **AMQRPHEDA**（官方解记号）围出可达工作空间：$QR$ 是 $r=1$ 的外弧，$HE$ 与 $DA$ 两段拼出 $r=0.238$ 的内弧（圆心角合计约 $204°$）。

验收：散点图的 $r_{\min},r_{\max}$ 与 $\varphi$ 极值同上列数值吻合（容差 = 网格步长）；把三个限位放宽到 $[-\pi,\pi]$ 应退化为整环 $0\le r\le1$——两个极端都对了，中间形态才可信。

:::

:::

::: ex C5 · ZYZ / RPY 正逆解闭环（自编）

实现式 2.18–2.23 的正逆解，做双向闭环测试；再专门测试 $\vartheta\approx0$（ZYZ）与 $\vartheta\approx\pm\pi/2$（RPY）附近的逆解行为。

::: sol 解答

要点与预期结果：

```python
def zyz_fwd(p, t, ps): ...          # 式 2.18
def zyz_inv(R):
    t = np.arctan2(np.hypot(R[0,2],R[1,2]), R[2,2])          # 支 I: ϑ∈(0,π)
    if abs(np.sin(t)) < 1e-12: ...                            # 奇点: 只能定 φ±ψ
    p = np.arctan2(R[1,2],R[0,2]); ps = np.arctan2(R[2,1],-R[2,0])
    return p, t, ps
```

(a) 随机 1000 组角，`inv(fwd(angles))` 与原角或「支 II 对应角」（式 2.20）逐组比对，全部应等价（同姿态）。(b) 在 $\vartheta=10^{-6}$ rad 附近：$R$ 对 $\varphi,\psi$ 各自的变化**不敏感**（只感知其和），逆解出的 $\varphi,\psi$ 对浮点噪声放大 $10^6$ 倍量级——[@thm-2.4.A] 的活教材：不是公式错，是表示在该处退化。验收：正常区误差 $<10^{-12}$；奇异区能复现「跳变」并解释。

:::

:::

::: ex C6 · 通用 DH 正运动学函数与逆解数值验证（自编）

写一个 `fk(dh, q) -> T`（输入 4n 参数表 + 关节变量），用它重现 [@method-2.8.A] 的三连杆平面臂与 [2.9.4](sec2-9.md#sec-2.9.4) 拟人臂结果；再对平面臂实现 [2.12.2](sec2-12.md#sec-2.12.2) 解析逆解，与 `scipy.optimize` 的数值解对照（含肘上 / 肘下两支）。验收还需覆盖 [例 2.12.D](sec2-12.md#ex-2.12.D) 的两支回代、零腕心的一族解，以及不等杆长零腕心的无解分支，避免分母为零时盲目调用 Atan2。

::: sol 解答

```python
def fk(dh, q):
    T = np.eye(4)
    for (a, al, d, th), qi in zip(dh, q):
        t = qi if th is None else th       # 变量列: None 标记
        d = qi if d  is None else d
        ct, st, ca, sa = np.cos(t), np.sin(t), np.cos(al), np.sin(al)
        A = np.array([[ct,-st*ca, st*sa, a*ct],
                      [st, ct*ca,-ct*sa, a*st],
                      [ 0,    sa,    ca,    d],
                      [ 0,     0,     0,    1]])
        T = T @ A
    return T
```

验收标准：(a) 平面臂 `fk` 输出与式 2.63 逐元素一致；(b) 拟人臂输出与式 2.66 一致（代 $\vartheta=0$ 抽查 $\boldsymbol p=[a_2+a_3,0,0]^T$ 型特例）；(c) 随机 100 组 $(p_x,p_y,\phi)$：解析解（两支）回代 `fk` 的误差 $<10^{-12}$，且每组的解数与 $c_2$ 容许性判据一致；工作空间外的测试点应被 $|c_2|>1$ 正确拒绝而非输出 NaN。**解析解是「快 + 全」、数值解是「通用 + 单支」**——两者的互补关系在第 3 章还会升级。

:::

:::

## D 组 · 开放研讨

::: ex D1 · 拟人臂肩奇异解的数目（原书 2.18）

讨论 [@thm-2.12.C] 的拟人臂在 $s_3=0$ 时解的数目，特别是 $s_3=0$ **且** $p_{wx}=p_{wy}=0$ 的边界情形：多少组？几何解释是什么？

::: sol 解答

$s_3=0$ 分两支：$c_3=1$（臂伸直，$\vartheta_3=0$）与 $c_3=-1$（臂全折，$\vartheta_3=\pi$）。

**通例（$p_{wx}^2+p_{wy}^2>0$）**：两支各给出两个不同的 $\vartheta_2$（伸直支 $\vartheta_2=\operatorname{Atan2}\big(p_{wz},\ \pm\sqrt{p_{wx}^2+p_{wy}^2}\big)$；全折支同形，把 $a_2+a_3$ 换成 $|a_2-a_3|$，须 $a_2\ne a_3$），每个 $\vartheta_2$ 对应由式 2.109/2.110 定出的 $\vartheta_1$——共 **4 组解**（肩前 / 后 × 伸直 / 全折），退化只表现为「肘上 / 肘下两支在 $s_3=0$ 处合并」，解数不增。

**边界（$p_{wx}=p_{wy}=0$，腕心落在 $z_0$ 轴上）**：旋转 $\vartheta_1$ 不移动腕心，故 $\vartheta_1$ **任意**（无穷多）。可解性要求腕心恰在极值点：伸直支 $p_{wz}=\pm(a_2+a_3)$、全折支 $p_{wz}=\pm|a_2-a_3|$，此时 $\vartheta_2=\pm\pi/2$。**结论：$\vartheta_1$ 连续无穷多 × 每支有限的 $(\vartheta_2,\vartheta_3)$**，几何图像是「臂绕竖直轴自转也够得着轴上的腕心」——肩奇异（对照球形臂 $d_3=0$、圆柱臂 $d_3=0$ 的同类现象，原书图 2.33 的第 3 章后续）。

**特例（$a_2=a_3$，全折支）**：全折时腕心与肩重合（$p_{wx}=p_{wy}=p_{wz}=0$ 是唯一可解点），此时 $\vartheta_2$ 与 $\vartheta_1$ **同时不定**——二维连续解族（两个参数族），是最深的退化层级。

:::

:::

::: ex D2 · 标定算法的仿真实验设计（自编）

设计一个数值实验验证 [@method-2.11.steps]：给「真值」DH 参数，仿真量测，检验最小二乘迭代能否恢复真值。给出实验要素与验收标准。

::: sol 解答

要素：(1) 真值 $\boldsymbol\xi^\star$：如拟人臂 12 个参数，对每个常数参数加 $[-1,1]$ mm / mrad 级「制造偏差」；(2) 量测：$t=60$ 个随机关节位形（$tm=180\gg4n=12$），位姿**铺满工作空间**（对照 [2.11](sec2-11.md) 常见错误 2）；(3) 噪声：位置加 $\sigma=0.05$ mm 高斯噪声（姿态可不加或加 mrad 级）；(4) 迭代初值为标称（无偏差）参数。验收：迭代收敛（$\|\Delta\boldsymbol\xi\|$ 单调下降至平台）；恢复误差与 Cramér–Rao 量级一致（参数误差 ≈ 噪声 / $\sqrt{t}$ 级）；把 $t$ 降到 3（$tm=9<12$）应看到欠定失败；把量测集中到工作空间一角应看到 $\Phi^T\Phi$ 病态、误差放大——三个「反例开关」都能按预期失效，实验才算完整。

:::

:::

::: ex D3 · 从角和轴到四元数的自学路线（自编）

课程以「卫星姿态用四元数」点题（录播 0:21:26）但未展开。以 [@def-2.5.1] 与 [2.4.5](sec2-4.md#sec-2.4.5) 预告框为起点，设计一条不超原书 §2.6 的自学路线，并说明四元数分别「修掉」了角和轴的哪些毛病。

::: sol 解答

路线：(1) 读原书式 2.30–2.32，验证单位约束 $\eta^2+\|\boldsymbol\epsilon\|^2=1$（与 $\boldsymbol r$ 单位模同型）；(2) 用式 2.33 数值验证 $R(\eta,\boldsymbol\epsilon)$ 与 $R(\vartheta,\boldsymbol r)$ 在 $\eta=\cos\frac{\vartheta}{2},\boldsymbol\epsilon=\sin\frac{\vartheta}{2}\boldsymbol r$ 时一致（复用 C1 代码）；(3) 用式 2.34–2.35 实现由 $R$ 提取四元数，重点测试 $\vartheta=\pi$——四元数**无奇点**（对照 [@thm-2.5.B] 的失效点）；(4) 用式 2.36 验证 $Q^{-1}=\{\eta,-\boldsymbol\epsilon\}$，并解释为何 $(\vartheta,\boldsymbol r)\equiv(-\vartheta,-\boldsymbol r)$ 的不唯一（[@thm-2.5.A]）在四元数中消失（半角把「轴 + 角」打包后，$(\pi-\cdot)$ 支对应 $\eta\to-\eta$，是**可区分**的两个四元数，对应同一旋转但明确分层）。修掉的毛病：无逆解奇点、无不唯一；代价：4 参数非最简 + 乘法不再是直观的「转轴 + 角」。这条路线也解释了卫星 / 姿态控制行业的选型逻辑。

:::

:::

::: ex D4 · SCARA 全流程贯通（自编）

把 [1.2.2](../ch01/sec1-2.md#sec-1.2.2) 的 SCARA 构形知识与本编串成一条链：构形判断 → DH 表（C3）→ 正运动学特征 → 逆解结构 → 选型复核。每步一句话给出「上一编 / 本编的哪条结论在起作用」。

::: sol 解答

链条：(1) **构形**：三轴平行 + 竖直柔性 → SCARA（[@ex-1.2.B] 口诀）；(2) **DH**：四轴平行 ⇒ 全表 $\alpha_i=0$、平面臂型 $A_i$（[@method-2.8.zero]）；(3) **正运动学**：$x,y$ 只依赖 $\vartheta_1,\vartheta_2$、$z$ 只依赖 $d_3$（C3）——定位与下压解耦；(4) **逆解**（此步即原书 2.20 的求解结构）：平面二连杆逆解（[2.12.2](sec2-12.md#sec-2.12.2) 的 $a_3=0$ 特例）+ $z,d_3$ 直读，$\vartheta_4$ 由 $\phi$ 回代——存在「左撇 / 右撇」两支（对应例 2.6 的肘上 / 肘下）；(5) **选型复核**：竖直装配任务 $r=4$ 恰好用满 $n=4$、无冗余（[@def-2.10.3]），装配柔性与原书第 9 章力控制衔接。一句话总结：**构形决定参数表的形状，参数表决定解耦结构，解耦结构决定逆解与控制的难度**——这正是全编「一条主线」在具体机型上的落地。

:::

:::

依据 Siciliano 等《机器人学：建模、规划与控制》第 2 章习题（p.74–76）整理扩充 · 全部附解 · 整理日期 2026-09-15
