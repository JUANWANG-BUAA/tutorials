# 7.4–7.5 步长的选择、常微分方程组与刚性问题

> 对应教材 7.4–7.5（7.4 步长的选择；7.5 常微分方程组与刚性问题，含 7.5.1 常微分方程组初值问题的数值解法、7.5.2 刚性问题）、例 11。第 15 讲已开讲本章；本页主题尚未在已收录课堂中覆盖，按教材拓展。
> 主线：步长怎么定 → 方程组怎么化 → 刚性为什么逼你换方法。

<a id="sec-7.4"></a>
## 7.4 步长的选择

::: intuition 直觉 · 精度、舍入误差与稳定性
选步长时要同时检查精度、舍入误差和稳定性。在相应光滑性条件下，$p$ 阶方法的全局截断误差为 $O(h^p)$。步长变小也会增加步数，但舍入误差怎样累积，还取决于误差传播、求和方式与各步误差的方向。

对刚性衰减问题，显式法常受更严格的稳定性限制：即使精度容许较大步长，$h\lambda$ 仍须落在方法的绝对稳定域内。下面先分清两种容易混淆的步长估计。
:::

**按容差选步长。** 若已有全局误差估计 $C_T h^p$，为满足容差 $\mathrm{tol}$，可先取 $h\lesssim(\mathrm{tol}/C_T)^{1/p}$，再检查稳定性。这里的容差是用户要求的误差上限。

**平衡截断与舍入误差。** 若另采用总误差模型
$$E(h)\approx C_T h^p+C_R\frac{u}{h},\qquad C_T,C_R>0,$$
其中 $u$ 是机器舍入单位，求导得
$$h_{\mathrm{bal}}=\left(\frac{C_Ru}{pC_T}\right)^{1/(p+1)}.$$
在这个特定模型下，Euler 对应 $O(u^{1/2})$，RK4 对应 $O(u^{1/5})$。它们与容差估计中的 $1/p$ 来自不同问题。若舍入误差并非按 $u/h$ 累积，就要改用相应模型，不能沿用这条平衡公式。

**显式方法的硬约束**：稳定域有界。若方法的绝对稳定域沿负实轴延伸到 $-z_{\max}$，则显式方法必须取

$$
h\lesssim \frac{z_{\max}}{|\lambda_{\max}|},
$$

这里假定相关测试特征值为负实数；复特征值须逐个检查 $h\lambda_i$ 所在位置。越过稳定边界时，离散解可能增长；对刚性问题，这个步长上限常比精度要求更严格。

::: method[core] 定步长的实用流程 {#method-7.4-step}
1. 用误差常数与容差估一个先验步长 $h_0$，即 $C_T h_0^p\lesssim\mathrm{tol}$；
2. 用稳定域反解给出上限 $h_{\max}$，取 $h=\min(h_0,h_{\max})$；
3. 逐步加密做**步长减半实验**，观察误差是否按理论阶下降；
4. 若加密后不再改善，检查是否有舍入误差、非光滑性或实现问题；若稳定性迫使步长过小，再考虑适合该问题的隐式方法。
:::

::: method[core] 事后误差估计与自动步长 {#method-7.4-adaptive}
设方法为 $p$ 阶。从 $t_n$ 出发，分别用步长 $h$ 和 $h/2$ 算到 $t_{n+1}$，得 $y_{n+1,h}$ 与 $y_{n+1,h/2}$。由 Richardson 外推，

$$
y(t_{n+1})-y_{n+1,h/2}\approx\frac{y_{n+1,h/2}-y_{n+1,h}}{2^p-1}.
$$

这里右端估计的是两次半步所得细解的局部误差；粗解的相应估计还要乘 $2^p$。在误差渐近展开成立时，可据此接受细解，或缩短步长重算，再用安全因子调整下一步。该估计不要求显式给出高阶导数的上界，但局部容差仍不等于全程全局误差保证。
:::

### 让步长自己调整：先试算，再决定是否前进 {#adaptive-rk4-loop}

固定步长在解变化平缓处可能多算，在变化剧烈处又可能不够细。步长加倍法利用两种计算结果的差来估计一步误差。对 RK4，若粗步的局部误差为 $Ch^5+O(h^6)$，从同一起点走两次半步的局部误差为

$$
2C(h/2)^5+O(h^6)=\frac{Ch^5}{16}+O(h^6).
$$

因此细解误差估计是 $(y_{\mathrm{fine}}-y_{\mathrm{coarse}})/15$。两次半步虽然多算了一步，领先误差仍缩小到原来的 $1/16$。

把这个估计变成程序，要先约定什么叫“够准”。对标量问题，令

$$
s=\mathrm{atol}+\mathrm{rtol}\max(|y_n|,|y_{\mathrm{fine}}|),\qquad
E=\frac{|y_{\mathrm{fine}}-y_{\mathrm{coarse}}|}{15s}.
$$

$\mathrm{atol}$ 是绝对容差，给接近零的解提供误差尺度；$\mathrm{rtol}$ 是相对容差，使大数值分量允许相应的绝对误差。$E\le1$ 就接受细解，更新时刻；否则原地缩短步长重算。拒步时，时间和已接受的解都不改变。

由于估计对应 $h^5$，可取下一步为

$$
h_{\mathrm{new}}=h\cdot\operatorname{clip}(0.9E^{-1/5},0.2,5),
$$

其中 clip 将倍率限制在 $[0.2,5]$；0.9 是给误差估计留余量的安全系数。误差为零时取倍率 5。临近终点时先令 $h=\min(h,T-t_n)$，确保最后一步恰好到达终点。

下面是可直接运行的标量示例。它接受两半步的细解，不额外作 Richardson 外推；每次试步都记录是否接受，便于看清循环。

```python
import math


def rk4_step(f, t, y, h):
    k1 = f(t, y)
    k2 = f(t + h / 2, y + h * k1 / 2)
    k3 = f(t + h / 2, y + h * k2 / 2)
    k4 = f(t + h, y + h * k3)
    return y + h * (k1 + 2 * k2 + 2 * k3 + k4) / 6


def adaptive_rk4(f, t0, y0, end, h0, atol=1e-6, rtol=1e-6):
    # 标量、向前积分；返回已接受节点和全部试步记录。
    if end < t0 or h0 <= 0 or atol <= 0 or rtol < 0:
        raise ValueError("要求 end >= t0、h0 > 0、atol > 0、rtol >= 0")
    t, y, h = t0, y0, h0
    nodes, trials = [(t, y)], []
    for _ in range(10000):
        if t >= end:
            return nodes, trials
        h = min(h, end - t)
        if t + h == t:
            raise ArithmeticError("步长小于当前浮点时间分辨率")
        coarse = rk4_step(f, t, y, h)
        half = rk4_step(f, t, y, h / 2)
        fine = rk4_step(f, t + h / 2, half, h / 2)
        estimate = (fine - coarse) / 15
        scale = atol + rtol * max(abs(y), abs(fine))
        error = abs(estimate) / scale
        if not math.isfinite(error):
            raise ArithmeticError("试步结果不是有限数")
        accepted = error <= 1
        trials.append((t, h, error, accepted))
        if accepted:
            t = end if h == end - t else t + h
            y = fine
            nodes.append((t, y))
        factor = 5.0 if error == 0 else 0.9 * error ** (-1 / 5)
        factor = min(5.0, max(0.2, factor))
        h *= factor if accepted else min(1.0, factor)
    raise RuntimeError("试步次数超过本教学示例的上限")


nodes, trials = adaptive_rk4(lambda t, y: y, 0.0, 1.0, 1.0, 1.0,
                             atol=1e-6, rtol=0.0)
for t, h, error, accepted in trials:
    print(f"{t:.6f} {h:.6f} {error:.6f} {accepted}")
print(f"终点：{nodes[-1][0]:.6f}，数值解：{nodes[-1][1]:.9f}")
```

本例的试步过程如下。先看前两行：第一次被拒绝后，第二次仍从 $t=0$ 出发。

| 起点 $t$ | 试步 $h$ | 缩放误差 $E$ | 接受？ |
|--:|--:|--:|:--:|
| 0.000000 | 1.000000 | 600.857205 | 否 |
| 0.000000 | 0.250316 | 0.530094 | 是 |
| 0.250316 | 0.255776 | 0.759027 | 是 |
| 0.506092 | 0.243249 | 0.761250 | 是 |
| 0.749341 | 0.231200 | 0.751825 | 是 |
| 0.980541 | 0.019459 | 0.000004 | 是 |

最终 $y(1)\approx2.718277242$，与 $e$ 的差约为 $4.59\times10^{-6}$。这里的 $10^{-6}$ 控制每次试步的局部估计，整体误差还包含前面各步的累积。

对方程组，给每个分量设自己的 $s_i=\mathrm{atol}_i+\mathrm{rtol}_i\max(|Y_{n,i}|,|Y_{\mathrm{fine},i}|)$，用 $E=\max_i|e_i|/s_i$ 统一决定整步是否接受。后面把高阶方程改写成系统时，可以继续使用这个判断。

::: note 变步长与多步法的冲突
固定步长多步法的系数依赖等距历史节点，变步长时不能原封不动复用这些系数。可按实际时间节点重新插值求系数，或用 Nordsieck 表示更新历史；必要时也可用单步法重启。自适应既可用于 RK，也可用于变步长 Adams/BDF，只是历史与步长比的管理更复杂。
:::

<a id="sec-7.5"></a>
## 7.5 常微分方程组与刚性问题

<a id="sec-7.5.1"></a>
### 7.5.1 常微分方程组初值问题的数值解法

::: def 定义 7.5.1（教材 7.5.1） · 一阶方程组与高阶方程化一阶 {#def-7.5.1}
一阶方程组

$$
y_i'=f_i(t,y_1,\dots,y_s),\qquad y_i(t_0)=y_{i0}\quad(i=1,\dots,s)
$$

写成向量形式

$$
Y'=F(t,Y),\qquad Y(t_0)=Y_0 .
$$

高阶方程 $y^{(m)}=f(t,y,y',\dots,y^{(m-1)})$ 可令

$$
Y=(y,y',\dots,y^{(m-1)})^{\mathrm T},
$$

化成一阶系统 $Y'=F(t,Y)$。所有单步法 / RK 方法都可**逐分量**使用：把标量 $y$ 换成向量 $Y$，$f$ 换成 $F$。
:::

::: note 化高阶方程的标准三步
以 $y''=f(t,y,y')$ 为例：

1. 令 $z=y'$；
2. 则 $y'=z,\ z'=f(t,y,z)$；
3. 初值变为 $y(t_0)=y_0,\ z(t_0)=y_0'$。

$m$ 阶方程就引入 $m-1$ 个新变量，写成一阶系统。**不要漏掉初值的转换**：$y'(t_0)$ 要变成 $z(t_0)$。
:::

**方程组情形的三条额外注意**：

1. **线性方程组可用矩阵形式**：$Y'=AY+b$ 时，RK4 一步是 $Y_{n+1}=(I+hA+\frac{h^2A^2}{2}+\frac{h^3A^3}{6}+\frac{h^4A^4}{24})Y_n+\cdots$，矩阵幂可用特征分解或函数求值法算，避免反复矩阵乘法。
2. **每步代价上升**：$m$ 维系统的每步函数求值是 $m$ 次标量求值；RK4 一共 $4m$ 次。
3. **误差范数要用分量无关的度量**：用最大分量误差或 2-范数，而不是逐分量相对误差。

::: ex 例 7.5.1（教材例 11） · 中点公式解三阶方程 {#ex-7.5.1}
写出用中点公式求解

$$
y'''=ty+y'y'',\qquad 0\le t\le20,\qquad y(0)=1,\ y'(0)=0,\ y''(0)=-2
$$

的计算公式。

**解** 令 $z=y',\ w=y''$，则

$$
y'=z,\qquad z'=w,\qquad w'=ty+zw .
$$

记 $Y=(y,z,w)^{\mathrm T}$，$Y_0=(1,0,-2)^{\mathrm T}$，

$$
F(t,Y)=\begin{pmatrix}z\\ w\\ ty+zw\end{pmatrix}.
$$

中点公式（RK2）为

$$
K_1=F(t_n,Y_n),\qquad
K_2=F\left(t_n+\frac h2,\ Y_n+\frac h2K_1\right),\qquad
Y_{n+1}=Y_n+hK_2 .
$$

写成分量就是

$$
\begin{aligned}
k_{11}&=z_n, & k_{21}&=w_n, & k_{31}&=t_ny_n+z_nw_n,\\
k_{12}&=z_n+\frac h2k_{21}, & k_{22}&=w_n+\frac h2k_{31}, &
k_{32}=\left(t_n+\frac h2\right)\left(y_n+\frac h2k_{11}\right)+\left(z_n+\frac h2k_{21}\right)\left(w_n+\frac h2k_{31}\right),\\
y_{n+1}&=y_n+hk_{12}, & z_{n+1}&=z_n+hk_{22}, & w_{n+1}&=w_n+hk_{32}.
\end{aligned}
$$

其中 $K_1=(k_{11},k_{21},k_{31})^{\mathrm T}$，$K_2=(k_{12},k_{22},k_{32})^{\mathrm T}$。
:::

<a id="sec-7.5.2"></a>
### 7.5.2 刚性问题

::: def 定义 7.5.2（教材 7.5.2） · 刚性方程组与刚性比 {#def-7.5.2}
$s$ 维常系数线性方程组

$$
Y'=AY+\varphi(t)
$$

称为**刚性方程组**，若 $A$ 的特征值 $\lambda_i$ 满足：

1. $\operatorname{Re}\lambda_i<0$（$i=1,\dots,s$）；
2. $\max_i|\operatorname{Re}\lambda_i|\gg\min_i|\operatorname{Re}\lambda_i|$。

称

$$
r=\frac{\max_i|\operatorname{Re}\lambda_i|}{\min_i|\operatorname{Re}\lambda_i|}
$$

为**刚性比**。对一般非线性方程组，若 Jacobi 矩阵 $\partial F/\partial Y$ 的特征值在整个区间上满足上述条件，也称为刚性方程组。
:::

::: ex 例 7.5.2（教材 7.5.2） · 一个刚性方程组的步长困境 {#ex-7.5.2}
设

$$
u'=998u+1998v,\qquad v'=-999u-1999v,\qquad u(0)=1,\ v(0)=0,\quad 0\le t\le T.
$$

矩阵

$$
A=\begin{pmatrix}998&1998\\-999&-1999\end{pmatrix}
$$

的特征值为 $\lambda_1=-1,\ \lambda_2=-1000$，刚性比 $r=1000$。解为

$$
\begin{pmatrix}u\\v\end{pmatrix}
=\begin{pmatrix}2e^{-t}\\-e^{-t}\end{pmatrix}
+\begin{pmatrix}-e^{-1000t}\\e^{-1000t}\end{pmatrix}.
$$

**慢变部分** $(2e^{-t},-e^{-t})^{\mathrm T}$ 决定长期行为，**快变部分** $(-e^{-1000t},e^{-1000t})^{\mathrm T}$ 在 $t\sim10^{-3}$ 内衰减完。

若用 Euler 法，稳定性要求

$$
|1-1000h|<1\iff 0<h<0.002 .
$$

但慢变部分要算到 $t\sim O(1)$，步数约 $1/0.002=500$ 步；若慢尺度仍为 1、最快衰减率增至 $10^6$，同一终点所需步数超过 $5\times10^5$。刚性比本身不确定绝对步数，还要给出终点与时间尺度。**步长被最快的快变分量卡死，而精度只需要慢变分量**——这就是刚性问题的核心困难。
:::

**对策**：用**隐式方法**（后退 Euler、梯形、隐式 RK、Gear）。它们的稳定域向左延伸得远得多，同样的刚性方程可以用大得多的步长求解。

::: def 定义 7.5.3（教材 7.5.2） · A-稳定与 $A(\alpha)$-稳定 {#def-7.5.3}
若方法的绝对稳定区域包含整个左半平面，称为 **A-稳定**。若包含无限楔形区域

$$
W_\alpha=\{\mu\mid -\alpha<\pi-\arg\mu<\alpha\},\qquad 0<\alpha\le\frac\pi2,
$$

则称为 **$A(\alpha)$-稳定**。A-稳定即 $A(\pi/2)$-稳定。
:::

**A-稳定**：后退 Euler 与梯形法是 A-稳定的；显式 Euler 与 RK4 不是。这条性质是刚性问题的「入场券」——A-稳定保证对标量线性测试方程 $y'=\lambda y$、$\operatorname{Re}\lambda<0$ 的任意正步长稳定；它不是任意非线性或非正规系统的大步长保证。实际还要检查隐式方程求解、瞬态增长、所需精度与快模态阻尼。梯形法虽 A-稳定，却不具后退 Euler 的 L-稳定衰减。

::: method[core] 隐式 Runge–Kutta 的常用公式 {#method-7.5-implicit-rk}
$N$ 级隐式 R-K 的一般形式：

$$
y_{n+1}=y_n+h\sum_{i=1}^Nc_ik_i,\qquad
k_i=f\left(t_n+a_ih,\ y_n+h\sum_{j=1}^Nb_{ij}k_j\right)\quad(i=1,\dots,N).
$$

**一级二阶**：

$$
y_{n+1}=y_n+hk_1,\qquad k_1=f\left(t_n+\frac h2,\ y_n+\frac h2k_1\right).
$$

**二级二阶**：

$$
y_{n+1}=y_n+\frac h2(k_1+k_2),\quad
k_1=f(t_n,y_n),\quad
k_2=f\left(t_n+h,\ y_n+\frac h2(k_1+k_2)\right).
$$

**二级四阶**：

$$
y_{n+1}=y_n+\frac h2(k_1+k_2),
$$

$$
k_1=f\left(t_n+\left(\frac12-\frac{\sqrt3}6\right)h,\ y_n+\frac h4k_1+\left(\frac14-\frac{\sqrt3}6\right)hk_2\right),
$$

$$
k_2=f\left(t_n+\left(\frac12+\frac{\sqrt3}6\right)h,\ y_n+\left(\frac14+\frac{\sqrt3}6\right)hk_1+\frac h4k_2\right).
$$

隐式 R-K 是 A-稳定的，且可构造 $N$ 级 $2N$ 阶公式；代价是每步要求解含 $sN$ 个未知量的非线性方程组，高阶级数在实际计算中不常用。
:::

::: note 隐式 R-K 与 Gear
- **隐式 R-K** 是 A-稳定的，可以构造 $N$ 级 $2N$ 阶公式；但每步要解一个含 $sN$ 个未知量的非线性方程组，高阶级数在实际计算中不常用。
- **Gear（BDF）** $k=1,\dots,6$ 是 $A(\alpha)$-稳定的，$\alpha$ 随 $k$ 增大而减小；$k=1,2$ 为 $90^\circ$（A-稳定），$k=6$ 只剩 $18^\circ47'$。**阶越高，楔形越窄**，这是高阶 BDF 的稳定性代价。
- **显式线性多步法不可能是 A-稳定的；A-稳定的线性多步法阶不超过 2。** 所以高精度 + A-稳定不能兼得，实际求解器在「阶」与「稳定域」之间折中。
:::

::: method[core] 刚性问题的选型流程 {#method-7.5-stiff}
1. **估特征值量级**：算 Jacobi 矩阵的谱半径或行范数，得到 $|\lambda_{\max}|$；
2. **算刚性比** $r=|\lambda_{\max}|/|\lambda_{\min}|$；$r\gg1$ 就是刚性；
3. **非刚性**：显式高阶 RK（RK4/RK45），步长由精度定；
4. **刚性**：隐式方法（后退 Euler、梯形、Gear/BDF、隐式 RK），步长由精度定，不受稳定性卡死；
5. **验证**：用两种步长算，比较结果是否按阶收敛；若步长减半结果不变，可能已进入舍入误差区。
:::

::: note 编者补充 · 边值问题（教材第 7 章未收）
二阶边值问题

$$
y''=f(t,y,y'),\qquad y(a)=\alpha,\ y(b)=\beta
$$

的两种数值解法：

- **打靶法**：猜初始斜率 $s$，解初值问题 $y''=f(t,y,y'),\ y(a)=\alpha,\ y'(a)=s$ 得到 $y(b;s)$；再解方程 $y(b;s)=\beta$（二分 / Newton）得 $s$。每算一次 $y(b;s)$ 要解一次初值问题，因此**外层求根与内层初值求解嵌套**，内层的小误差会被外层放大。
- **有限差分法**：把 $[a,b]$ 分成网格，令 $y_i\approx y(t_i)$，用中心差分

$$
\frac{y_{i+1}-2y_i+y_{i-1}}{h^2}=f\left(t_i,y_i,\frac{y_{i+1}-y_{i-1}}{2h}\right),
$$

加上边界 $y_0=\alpha,y_n=\beta$，得到非线性 / 线性方程组；线性问题用追赶法 $O(n)$ 求解。
:::

::: think[core] 本节常见错误
1. **步长只按精度定。** 显式方法必须先满足稳定域；$h|\lambda_{\max}|$ 越界时，精度公式再漂亮也没用。
2. **把「稳定」当「精确」。** 绝对稳定性约束测试方程中数值解的增长；实际全局误差仍受截断误差、误差传播和非正规瞬态增长等影响。
3. **高阶方程化一阶时漏初值。** $y''$ 要引入 $z=y'$，初值 $y'(t_0)$ 必须转成 $z(t_0)$；漏掉会让整个解错位。
4. **方程组逐分量用标量公式时忘了同步。** RK 的 $k_i$ 是向量，必须用同一层的 $Y$ 同时算所有分量；不能用更新后的分量去算另一个分量。
5. **把刚性比算成 $\max|\lambda|/\min|\lambda|$ 的复数模。** 定义用的是**实部**的绝对值；对复特征值，实部才决定衰减率。
6. **以为隐式方法一定 A-稳定。** 只有部分隐式方法（后退 Euler、梯形、二阶 Gear）是 A-稳定；高阶 Adams 不是。
7. **自适应步长用于多步法不重启。** 步长一变，不能照搬等距节点的固定系数；应使用变步长系数或更新历史表示，必要时用单步法重启。
8. **忽略刚性问题的「慢变精度」。** 大步长隐式方法稳定，但若步长大于慢变时间尺度，精度仍不够；稳定与精度要分别检查。
:::

::: method[core] 本节公式速查
| 概念 | 公式 / 判据 |
|:--|:--|
| 一阶系统 | $Y'=F(t,Y)$，$Y=(y,y',\dots,y^{(m-1)})^{\mathrm T}$ |
| 细解的事后误差估计 | $e_{h/2}\approx\frac{y_{h/2}-y_h}{2^p-1}$ |
| 刚性比 | $r=\max\lvert\operatorname{Re}\lambda_i\rvert/\min\lvert\operatorname{Re}\lambda_i\rvert$ |
| Euler 稳定上限（负实特征值） | $h<2/\lvert\lambda_{\max}\rvert$ |
| A-稳定 | 稳定域包含整个左半平面 |
| A-稳定方法 | 后退 Euler、梯形、二阶 Gear |
| 高阶 BDF | $A(\alpha)$-稳定，$\alpha$ 随阶数减小 |
:::

::: note 覆盖核对
本节覆盖教材 7.4–7.5、例 11；边值问题为编者补充。下一节：[第 7 章习题](exercises.md)。
:::
