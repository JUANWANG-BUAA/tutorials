# 附录 A · 补充推导

正文里标着「证明从略」「留作习题补充」「证明思路」的地方，完整推导全部收在本附录，按章组织。每条标题括注正文出处，正文对应位置也有反向链接；附录编号 A.1、A.2……自成一体，不与正文的节级编号混用。本附录只用到两个外部结果：**Birkhoff 定理**（A.2.3 给出证明）与**矩阵的 Jordan 标准形**（A.2.7 引用）。

<a id="app-a-1"></a>

## A.1 第一章

<a id="app-a-1-1"></a>

### A.1.1 六个等价公式的误差放大因子（[1.1.3](../ch01/sec11.md#sec-1.1.3) 的定量复现）

设 $t=\sqrt2$，$a=1.4$，则输入误差 $e=t-a=0.0142136$，相对误差 $\varepsilon=e/t\approx1.005\%$。六个公式在 $t=\sqrt2$ 处恒等，依据是三条代数事实（可用二项展开自证）：

$$(\sqrt2+1)(\sqrt2-1)=1,\qquad(\sqrt2-1)^2=3-2\sqrt2,\qquad(\sqrt2-1)^6=99-70\sqrt2 .$$

由 [1.2.3](../ch01/sec12.md#sec-1.2.3) 的传播公式：输出绝对误差 $\approx\lvert f'(t)\rvert e$，输出相对误差 $\approx\kappa\cdot\varepsilon$，其中相对条件数（[1.2.6](../ch01/sec12.md#sec-1.2.6)）

$$\kappa=\left\lvert\frac{t\,f'(t)}{f(t)}\right\rvert .$$

逐个公式算出 $f'(t)$ 与 $\kappa$（$f(t)=(\sqrt2-1)^6=0.0050506$）：

| 公式 | $\lvert f'(t)\rvert$ | $\kappa$ | 预测绝对误差 $\lvert f'\rvert e$ | 实测（[1.1.3](../ch01/sec11.md#sec-1.1.3) 表） | 预测相对误差 |
|:--|:--:|:--:|:--:|:--:|:--:|
| $(t-1)^6$ | $6(t-1)^5=0.07316$ | $\dfrac{6t}{t-1}\approx20.5$ | $1.04\times10^{-3}$ | $9.6\times10^{-4}$ | $20.6\%$ |
| $(3-2t)^3$ | $6(3-2t)^2=0.17662$ | $\dfrac{6t}{3-2t}\approx49.5$ | $2.51\times10^{-3}$ | $3.0\times10^{-3}$ | $49.7\%$ |
| $99-70t$ | $70$ | $\dfrac{70t}{99-70t}\approx1.96\times10^{4}$ | $9.95\times10^{-1}$ | $9.9\times10^{-1}$ | $197$ |
| $1/(t+1)^6$ | $\dfrac{6}{(t+1)^7}=0.012553$ | $\dfrac{6t}{t+1}\approx3.51$ | $1.78\times10^{-4}$ | $1.8\times10^{-4}$ | $3.53\%$ |
| $1/(3+2t)^3$ | $\dfrac{6}{(3+2t)^4}=0.0051993$ | $\dfrac{6t}{3+2t}\approx1.46$ | $7.39\times10^{-5}$ | $7.5\times10^{-5}$ | $1.46\%$ |
| $1/(99+70t)$ | $\dfrac{70}{(99+70t)^2}=0.0017856$ | $\dfrac{70t}{99+70t}\approx0.500$ | $2.54\times10^{-5}$ | $2.6\times10^{-5}$ | $0.50\%$ |

四条读法：

1. **$\kappa$ 从 $0.5$ 跨到 $1.96\times10^{4}$，近五个数量级**——与实测误差之比（$2.6\times10^{-5}$ 对 $9.9\times10^{-1}$）精确对应。一阶传播公式把整张表复现到两位有效数字。
2. **公式 3 的 $\kappa$ 大，是因为分母 $f(t)=99-70\sqrt2\approx5\times10^{-3}$ 极小**：$99$ 与 $70\sqrt2\approx98.995$ 是相近数，相减在**输入之前**就把信息压没了。相减这一步本身是精确的（Sterbenz 引理，见[附录 B.3](float.md#app-b-3)）——错的不是减法，是被送去相减的数只剩 4 位有效数字（[1.2.4](../ch01/sec12.md#sec-1.2.4) 原则 (3)）。
3. **公式 6 的 $\kappa=0.5\lt1$：误差被压缩**。取倒数把「小输出」换成「大输出」，条件反而变好。这与「用韦达定理保小根」（原则 (2)）是同一个思想：**换等价提法，让病态环节落进良态运算**。
4. 公式 2 的预测（$49.7\%$）与实测（$58.4\%$）差约五分之一，这是线性化误差：$\kappa$ 本身随 $t$ 在 $[a-e,\ a+e]$ 上变化，量级判断不受影响。

<a id="app-a-1-2"></a>

### A.1.2 有效数字与相对误差的换算界都不可再改进（[定理 1.2.1](../ch01/sec12.md#thm-1.2.1) 的补全）

**正向界 $\dfrac{1}{2a_1}\times10^{1-n}$ 取得等号。**取 $a=5.00$（规格化 $0.500\times10^1$，$a_1=5$，$m=1$，$k=3$），$x=5.005$。则 $\varepsilon(a)=0.005=\tfrac12\times10^{1-3}$（$a$ 恰有 3 位有效数字），而

$$\varepsilon_{\mathrm r}(a)=\frac{0.005}{5.00}=0.001=\frac{1}{2a_1}\times10^{1-3}=\frac{1}{10}\times10^{-2},$$

等号成立。故常数 $\dfrac{1}{2a_1}$ 不可放宽。

**逆向界 $\dfrac{1}{2(a_1+1)}\times10^{1-n}$ 也卡在临界上。**取 $a=9.9$（$0.99\times10^1$，$a_1=9$，$m=1$），$n=2$ 时界为 $\dfrac{1}{2\times10}\times10^{-1}=0.005$。取 $x=9.96$：

$$\varepsilon_{\mathrm r}(a)=\frac{0.06}{9.9}\approx0.00606\ \gt\ 0.005,\qquad\varepsilon(a)=0.06\ \gt\ \tfrac12\times10^{1-2}=0.05,$$

第 2 位有效数字已经失守。也就是说：相对误差限只要比逆向界**再大一点**，就可能不足 $n$ 位——常数 $a_1+1$ 不可再小。

**组合起来读：**最坏情形 $a_1=1$ 时，正向界 $\tfrac12\times10^{1-n}$ 与逆向界 $\tfrac1{40}\times10^{1-n}$ 相差 $20$ 倍。「由有效数字推相对误差」（正向）与「由相对误差倒推有效数字」（逆向）必须用各自的常数，不能共用。

<a id="app-a-1-3"></a>

### A.1.3 递推积分 $y_n$ 的完整分析：最坏误差界与交错级数（[1.2.4](../ch01/sec12.md#sec-1.2.4) 原则 (1) 的补全）

$$y_n=\int_0^1\frac{x^n}{x+5}\,dx,\qquad y_n=\frac1n-5y_{n-1}\ (n\ge1),\qquad y_0=\ln\frac65 .$$

**（一）正向递推的最坏误差界。**设第 $n$ 步的误差为 $\delta_n=y_n^{(计算)}-y_n^{(真)}$。每步执行 $y_n=\mathrm{fl}(1/n-5y_{n-1})$，除真实递推外多出两项误差：旧误差被乘 $-5$ 放大，加上本步新的舍入 $\rho_n$（$\lvert\rho_n\rvert\le\rho$，$\rho$ 为每步舍入的绝对值上界）：

$$\delta_n=-5\,\delta_{n-1}+\rho_n .$$

对 $n$ 展开此式（$\delta_n=-5\delta_{n-1}+\rho_n$ 逐层代入）：

$$\lvert\delta_n\rvert\ \le\ 5^n\lvert\delta_0\rvert+\rho\,(1+5+\cdots+5^{n-1})=5^n\lvert\delta_0\rVert+\rho\,\frac{5^n-1}{4}\ \approx\ 5^n\Bigl(\lvert\delta_0\rvert+\frac{\rho}{4}\Bigr).$$

取 $\lvert\delta_0\rvert=\lvert\ln(6/5)-0.1823\rvert=2.16\times10^{-5}$、$n=100$、$5^{100}\approx7.9\times10^{69}$：界约 $10^{65}$。反向递推的系数 $1/5$ 把同一公式变成**压缩**，起点误差 $1.6\times10^{-4}$ 传到 $y_0$ 只剩 $1.6\times10^{-4}/5^{100}$——机器精度之下。

**（二）$y_n$ 的交错级数（反向递推起点的精确化）。**在 $[0,1]$ 上 $\lvert x/5\rvert\le\tfrac15\lt1$，几何级数一致收敛，可逐项积分：

$$\frac{1}{x+5}=\frac15\cdot\frac{1}{1+x/5}=\sum_{j=0}^{\infty}\frac{(-1)^jx^j}{5^{j+1}}\qquad\Longrightarrow\qquad
y_n=\sum_{j=0}^{\infty}\frac{(-1)^j}{5^{j+1}(n+j+1)} .$$

级数各项单调递减趋于零，故**截断误差不超过首个舍去项**。两个检验：

- $n=0$：级数为 $\sum_j(-1)^j\frac{(1/5)^{j+1}}{j+1}$，正是 $\ln(1+z)$ 在 $z=1/5$ 处的 Taylor 级数，和为 $\ln(6/5)=0.182322$ ✓；
- $n=100$：逐项求和 $y_{100}=\frac{1}{505}-\frac{1}{2550}+\frac{1}{12875}-\frac{1}{65000}+\cdots\approx0.0016528$。

对照正文用的区间估计 $\frac{1}{6(n+1)}\lt y_n\lt\frac{1}{5(n+1)}$：$n=100$ 时区间为 $[0.0016502,\ 0.0019802]$，中点 $0.0018152$，真值 $0.0016528$ **紧贴区间左端**——中点估计的误差 $1.62\times10^{-4}$ 几乎用尽了「半宽度 $1.65\times10^{-4}$」的预算。这个粗糙的界已经做到了它能做到的极限；想要更准的起点，交错级数本身就可以：第 $j+1$ 项约为 $5^{-(j+1)}/(n+1)$，**想要起点误差多小就取多少项**——取 $7$ 项达绝对误差 $10^{-7}$，取 $12$ 项（手算量）达 $10^{-10}$，比「区间中点」细六个数量级。

**（三）渐近行为。**级数首项给出 $y_n\approx\dfrac{1}{5(n+1)}\sim\dfrac{1}{5n}$：被积函数在 $x\approx1$ 处最大、分母 $\approx6$ 而非 $5$，修正项 $-\dfrac{1}{25(n+2)}$ 正是它。

<a id="app-a-1-4"></a>

### A.1.4 范数等价常数的可达性，与无穷维的失效（[定理 1.3.3](../ch01/sec13.md#thm-1.3.3) 的补全）

**（一）显式不等式的每个常数都有向量取等：**

| 不等式 | 取等的向量 |
|:--|:--|
| $\lVert\boldsymbol{x}\rVert_\infty=\lVert\boldsymbol{x}\rVert_2$ | $\boldsymbol{x}$ 只有一个非零分量 |
| $\lVert\boldsymbol{x}\rVert_2=\sqrt n\,\lVert\boldsymbol{x}\rVert_\infty$ | $\lvert x_1\rvert=\cdots=\lvert x_n\rvert$（如 $\boldsymbol{1}$） |
| $\lVert\boldsymbol{x}\rVert_2=\lVert\boldsymbol{x}\rVert_1$ | 单个非零分量 |
| $\lVert\boldsymbol{x}\rVert_1=\sqrt n\,\lVert\boldsymbol{x}\rVert_2$ | $\lvert x_1\rvert=\cdots=\lvert x_n\rvert$ |

所以 $\sqrt n$、$n$ 这些因子不是估计的粗糙，而是**这组范数的真实距离**。

**（二）等价性是有限维的专利。**在无穷维序列空间取

$$\boldsymbol{x}=\Bigl(1,\ \tfrac12,\ \tfrac13,\ \cdots\Bigr):\qquad
\lVert\boldsymbol{x}\rVert_2^2=\sum_{k\ge1}\frac{1}{k^2}\lt\infty,\qquad
\lVert\boldsymbol{x}\rVert_1=\sum_{k\ge1}\frac1k=\infty .$$

同一个向量，一种范数有限、另一种无穷大——「换范数不改变收敛」在无穷维**失效**。数值 PDE 里对微分算子做有限元 / 差分离散，本质是「用 $n$ 维空间逼近无穷维」：维数 $n$ 增大时，等价常数（如 $\sqrt n$）随之恶化。「收敛结论与范数无关，但界的常数随 $n$ 增长」——这是离散化误差分析里天天打交道的事实，也是泛函分析选择在无穷维单独建立一套理论的原因。

<a id="app-a-2"></a>

## A.2 第二章

<a id="app-a-2-1"></a>

### A.2.1 Jordan–von Neumann 定理：平行四边形恒等式 ⟹ 内积（[定理 2.1.2](../ch02/sec21.md#thm-2.1.2) 逆方向的完整证明）

设 $\lVert\cdot\rVert$ 是 $\mathbb{R}^n$ 上的范数且满足平行四边形恒等式（2.2）。定义

$$\langle\boldsymbol{x},\boldsymbol{y}\rangle:=\frac14\Bigl(\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2-\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2\Bigr),$$

以下验证它满足内积三公理（对称、线性、正定），且诱导范数恰为 $\lVert\cdot\rVert$。

**第一步：符号与倍乘的基本事实。**

- $\langle\boldsymbol{x},\boldsymbol{x}\rangle=\frac14\lVert2\boldsymbol{x}\rVert^2=\lVert\boldsymbol{x}\rVert^2$（正定性与「诱导范数还原」一次到位：这里 $\lVert2\boldsymbol{x}\rVert^2=4\lVert\boldsymbol{x}\rVert^2$ 用了范数齐次性）；
- $\langle\boldsymbol{y},\boldsymbol{x}\rangle=\langle\boldsymbol{x},\boldsymbol{y}\rangle$（交换只对调两个平方项）；$\langle\boldsymbol{0},\boldsymbol{y}\rangle=0$；$\langle-\boldsymbol{x},\boldsymbol{y}\rangle=-\langle\boldsymbol{x},\boldsymbol{y}\rangle$。

**第二步（关键恒等式）：**对任意 $\boldsymbol{x},\boldsymbol{z},\boldsymbol{y}$，

$$\langle\boldsymbol{x}+\boldsymbol{z},\boldsymbol{y}\rangle+\langle\boldsymbol{x}-\boldsymbol{z},\boldsymbol{y}\rangle
=\frac14\Bigl[\lVert(\boldsymbol{x}+\boldsymbol{y})+\boldsymbol{z}\rVert^2+\lVert(\boldsymbol{x}+\boldsymbol{y})-\boldsymbol{z}\rVert^2-\lVert(\boldsymbol{x}-\boldsymbol{y})+\boldsymbol{z}\rVert^2-\lVert(\boldsymbol{x}-\boldsymbol{y})-\boldsymbol{z}\rVert^2\Bigr].$$

对前后两组分别用平行四边形恒等式（$\lVert\boldsymbol{a}+\boldsymbol{z}\rVert^2+\lVert\boldsymbol{a}-\boldsymbol{z}\rVert^2=2\lVert\boldsymbol{a}\rVert^2+2\lVert\boldsymbol{z}\rVert^2$），$\lVert\boldsymbol{z}\rVert$ 项相消：

$$=\frac14\Bigl[2\lVert\boldsymbol{x}+\boldsymbol{y}\rVert^2-2\lVert\boldsymbol{x}-\boldsymbol{y}\rVert^2\Bigr]=2\langle\boldsymbol{x},\boldsymbol{y}\rangle. \tag{$*$}$$

**第三步（倍 2）。**在 $(*)$ 中取 $\boldsymbol{z}=\boldsymbol{x}$：$\langle2\boldsymbol{x},\boldsymbol{y}\rangle+\langle\boldsymbol{0},\boldsymbol{y}\rangle=2\langle\boldsymbol{x},\boldsymbol{y}\rangle$，故 $\langle2\boldsymbol{x},\boldsymbol{y}\rangle=2\langle\boldsymbol{x},\boldsymbol{y}\rangle$。

**第四步（加法）。**任取 $\boldsymbol{u},\boldsymbol{v}$，令 $\boldsymbol{x}=\frac{\boldsymbol{u}+\boldsymbol{v}}2$、$\boldsymbol{z}=\frac{\boldsymbol{u}-\boldsymbol{v}}2$（于是 $\boldsymbol{x}+\boldsymbol{z}=\boldsymbol{u}$，$\boldsymbol{x}-\boldsymbol{z}=\boldsymbol{v}$）。由 $(*)$ 与第三步（把 $\frac{\boldsymbol{u}+\boldsymbol{v}}2$ 看成 $\frac12\cdot(\boldsymbol{u}+\boldsymbol{v})$，第三步反过来用）：

$$\langle\boldsymbol{u},\boldsymbol{y}\rangle+\langle\boldsymbol{v},\boldsymbol{y}\rangle=2\Bigl\langle\frac{\boldsymbol{u}+\boldsymbol{v}}2,\ \boldsymbol{y}\Bigr\rangle=\langle\boldsymbol{u}+\boldsymbol{v},\boldsymbol{y}\rangle .$$

**第五步（齐次性）。**加法已得，$\langle k\boldsymbol{x},\boldsymbol{y}\rangle=k\langle\boldsymbol{x},\boldsymbol{y}\rangle$ 对正整数 $k$ 归纳成立；负号由第一步；对有理数 $\frac pq$：$q\,\langle\frac pq\boldsymbol{x},\boldsymbol{y}\rangle=\langle p\boldsymbol{x},\boldsymbol{y}\rangle=p\langle\boldsymbol{x},\boldsymbol{y}\rangle$，两边除以 $q$。对实数 $t$：取有理数 $r_m\to t$，只需证 $\boldsymbol{w}\to\boldsymbol{0}$ 时 $\langle\boldsymbol{w},\boldsymbol{y}\rangle\to0$。由定义与三角不等式，

$$\lvert\langle\boldsymbol{w},\boldsymbol{y}\rangle\rvert\le\frac14\bigl(\lVert\boldsymbol{w}+\boldsymbol{y}\rVert+\lVert\boldsymbol{w}-\boldsymbol{y}\rVert\bigr)\cdot\bigl\lvert\lVert\boldsymbol{w}+\boldsymbol{y}\rVert-\lVert\boldsymbol{w}-\boldsymbol{y}\rVert\bigr\lvert\le\frac14\cdot2(\lVert\boldsymbol{w}\rVert+\lVert\boldsymbol{y}\rVert)\cdot2\lVert\boldsymbol{w}\rVert=\lVert\boldsymbol{y}\rVert\,\lVert\boldsymbol{w}\rVert(\lVert\boldsymbol{w}\rVert+\lVert\boldsymbol{y}\rVert)\to0 ,$$

而 $\lVert(t-r_m)\boldsymbol{x}\rVert=|t-r_m|\,\lVert\boldsymbol{x}\rVert\to0$。故 $\langle t\boldsymbol{x},\boldsymbol{y}\rangle=\lim_m r_m\langle\boldsymbol{x},\boldsymbol{y}\rangle=t\langle\boldsymbol{x},\boldsymbol{y}\rangle$。∎

**评注：**第二步的 $(*)$ 是全证明的心脏——平行四边形恒等式在这里恰好提供了「把 $\pm\boldsymbol{z}$ 的四个平方项两两配对」的结构；$1$-范数与 $\infty$-范数（[例 2.1.2](../ch02/sec21.md#ex-2.1.2)）正是在这一步失效。

<a id="app-a-2-2"></a>

### A.2.2 残差与误差的向下界（[定理 2.4.4](../ch02/sec24.md#thm-2.4.4) 的补充证明）

::: thm 命题 A.2 · 残差与误差的向下界
设 $A$ 非奇异，$\hat{\boldsymbol{x}}$ 为近似解，$\boldsymbol{r}=\boldsymbol{b}-A\hat{\boldsymbol{x}}$，$\boldsymbol{e}=\hat{\boldsymbol{x}}-\boldsymbol{x}$。若 $\lVert\boldsymbol{e}\rVert\lt\lVert\hat{\boldsymbol{x}}\rVert$，记 $\alpha=\lVert\boldsymbol{e}\rVert/\lVert\hat{\boldsymbol{x}}\rVert$，则

$$\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\ \le\ \mathrm{cond}(A)\cdot\frac{\alpha}{1-\alpha} .$$

::: proof 证明
由 $\boldsymbol{r}=-A\boldsymbol{e}$（两边取范数）得 $\lVert\boldsymbol{r}\rVert\le\lVert A\rVert\,\lVert\boldsymbol{e}\rVert$。另一方面，反三角不等式给出 $\lVert\boldsymbol{x}\rVert\ge\lVert\hat{\boldsymbol{x}}\rVert-\lVert\boldsymbol{e}\rVert=\lVert\hat{\boldsymbol{x}}\rVert(1-\alpha)$，而 $\boldsymbol{b}=A\boldsymbol{x}$ 给出下界（这是标准的「右端 = 解经 $A$ 的像」估计：$\lVert\boldsymbol{b}\rVert\ge\lVert\boldsymbol{x}\rVert/\lVert A^{-1}\rVert$，由 $\lVert\boldsymbol{x}\rVert=\lVert A^{-1}\boldsymbol{b}\rVert\le\lVert A^{-1}\rVert\lVert\boldsymbol{b}\rVert$ 移项即得）。两式相除：

$$\frac{\lVert\boldsymbol{r}\rVert}{\lVert\boldsymbol{b}\rVert}\le\frac{\lVert A\rVert\,\lVert\boldsymbol{e}\rVert}{\lVert\boldsymbol{x}\rVert/\lVert A^{-1}\rVert}\le\lVert A\rVert\lVert A^{-1}\rVert\cdot\frac{\alpha\lVert\hat{\boldsymbol{x}}\rVert}{(1-\alpha)\lVert\hat{\boldsymbol{x}}\rVert}=\mathrm{cond}(A)\cdot\frac{\alpha}{1-\alpha}.$$
:::
:::

**两个附注。**

1. **可计算性。**$\alpha$ 用的是 $\hat{\boldsymbol{x}}$（在手上）而非 $\boldsymbol{x}$（不可知）；充分条件 $\alpha\lt1$ 由 $\lVert\boldsymbol{e}\rVert\lt\lVert\boldsymbol{x}\rVert/2$ 保证（此时 $\lVert\hat{\boldsymbol{x}}\rVert\ge\lVert\boldsymbol{x}\rVert-\lVert\boldsymbol{e}\rVert\gt\lVert\boldsymbol{e}\rVert$）——这正是正文定理 2.4.4 括注的来历。
2. **与上界合起来读。**上界（2.23）说「残差被 $\mathrm{cond}$ 放大成误差」，本命题说「误差也顶多被 $\mathrm{cond}$ 压成残差」：二者互相控制在 $\mathrm{cond}$ 因子内。**残差小 + 条件数小 ⟺ 误差小**——两件事都不可省。

<a id="app-a-2-3"></a>

### A.2.3 工具箱：重排不等式、Birkhoff 定理与对称迹不等式

A.2.4 与 A.2.5 的两条主定理共用下面三件工具。本节把它们一次备齐。

::: lem 引理 A.3.1 · 标量重排不等式
设 $a_1\ge\cdots\ge a_n$，$b_1\ge\cdots\ge b_n$，$\pi$ 为任一置换，则 $\sum_i a_ib_{\pi(i)}\le\sum_i a_ib_i$。

::: proof 证明（对换法）
若 $\pi$ 不是恒等置换，存在 $i\lt j$ 使 $\pi(i)\gt\pi(j)$。交换 $\pi(i)$ 与 $\pi(j)$ 两项，和的改变量为

$$(a_ib_{\pi(j)}+a_jb_{\pi(i)})-(a_ib_{\pi(i)}+a_jb_{\pi(j)})=(a_i-a_j)\,\bigl(b_{\pi(j)}-b_{\pi(i)}\bigr)\ge0 ,$$

即「逆序对换成顺序，和不减」。逆序对个数有限，逐个消除后 $\pi$ 化为恒等置换，和单调不减到 $\sum a_ib_i$。
:::
:::

::: lem 引理 A.3.2 · Birkhoff 定理
$n\times n$ **双随机矩阵**（每行、每列元素之和都为 $1$ 的非负矩阵）都是置换矩阵的凸组合：$P=\sum_{\pi}w_\pi\Pi_\pi$，$w_\pi\ge0$，$\sum w_\pi=1$。

::: proof 证明（循环剥离归纳）
对非零元个数归纳。若
 的每行恰有一个非零元，则该元必为 $1$（行和为 $1$），各列同理， 
 已是置换矩阵。否则存在某行 $i_1$ 含至少两个正元；因行和为 $1$，其中每个正元 $p_{i_1j_1}\lt1$。列 $j_1$ 的和也为 $1$，而 $p_{i_1j_1}\lt1$，故列 $j_1$ 必含另一个正元 $p_{i_2j_1}$（$i_2\neq i_1$）。行 $i_2$ 若只有 $j_1$ 这一个正元，则 $p_{i_2j_1}=1$，列 $j_1$ 的和将超过 $1$——矛盾，故行 $i_2$ 含另一个正列 $j_2\neq j_1$。如此「行→列→行」交替行走，行只有有限多个，必有某行第二次被踏访，截出回路：得到互异的 $i_1,\dots,i_p$ 与互异的 $j_1,\dots,j_p$，使

$$p_{i_kj_k}\gt0\quad\text{且}\quad p_{i_{k+1}j_k}\gt0\qquad(k=1,\dots,p,\ i_{p+1}:=i_1).$$

令 $\theta=\min\{p_{i_{k+1}j_k}\}\in(0,1]$（若 $\theta=1$，环上这些位置全为 $1$， 
 在这些行列上已是置换块，剩余行列仍双随机，化为更小规模）。设 $\Pi$ 为环上「移位」置换：$\Pi_{i_{k+1}j_k}=1$。则

$$P=\theta\,\Pi+(1-\theta)\,Q,\qquad Q=\frac{P-\theta\Pi}{1-\theta}$$

- $Q\ge0$：$\Pi$ 的非零元全落在环上 $p_{i_{k+1}j_k}\ge\theta$ 的位置，减法不出现负元；
- $Q$ 双随机：环上的行（列）减掉 $\theta$ 后和为 $1-\theta$，除以 $1-\theta$ 恰为 $1$；环外的行（列）不动；
- 至少一个环上元素被减到零，故 $Q$ 的非零元严格减少。

归纳终止于置换矩阵，回代即得凸组合表示。
:::
:::

::: lem 引理 A.3.3 · 对称迹不等式
设 $S,T\in\mathbb{R}^{n\times n}$ 对称，特征值降序排列 $\lambda_1\ge\cdots\ge\lambda_n$、$\mu_1\ge\cdots\ge\mu_n$，则

$$\operatorname{tr}(ST)\ \le\ \sum_{i=1}^n\lambda_i\mu_i .$$

::: proof 证明
取标准正交特征基 $S=\sum_i\lambda_i\boldsymbol{u}_i\boldsymbol{u}_i^{\mathrm T}$、$T=\sum_j\mu_j\boldsymbol{v}_j\boldsymbol{v}_j^{\mathrm T}$，则

$$\operatorname{tr}(ST)=\sum_{i,j}\lambda_i\mu_j\,(\boldsymbol{u}_i^{\mathrm T}\boldsymbol{v}_j)^2 .$$

矩阵 $C=(c_{ij})$，$c_{ij}=(\boldsymbol{u}_i^{\mathrm T}\boldsymbol{v}_j)^2$，行和 $\sum_jc_{ij}=\lVert\boldsymbol{u}_i\rVert^2=1$（$\{\boldsymbol{v}_j\}$ 是标准正交基，Parseval 恒等式 [定理 2.1.4](../ch02/sec21.md#thm-2.1.4)），列和同理为 $1$——$C$ 双随机。由引理 A.3.2，$C=\sum_\pi w_\pi\Pi_\pi$，于是

$$\operatorname{tr}(ST)=\sum_\pi w_\pi\sum_i\lambda_i\mu_{\pi(i)}\ \overset{\text{A.3.1}}{\le}\ \sum_\pi w_\pi\sum_i\lambda_i\mu_i=\sum_i\lambda_i\mu_i. $$

（取等条件：$S,T$ 有共同特征基且降序对齐——正是「同向对角」的情形。）
:::
:::

::: cor 推论 A.3.4 · Hoffman–Wielandt 不等式（对称阵）
在引理 A.3.3 的记号下，

$$\lVert S-T\rVert_F^2\ \ge\ \min_{\pi}\ \sum_{i=1}^n\bigl(\lambda_i-\mu_{\pi(i)}\bigr)^2 ,$$

且右端最优配对就是「降序对降序」。

::: proof 证明
$\lVert S-T\rVert_F^2=\operatorname{tr}(S-T)^2=\sum_i\lambda_i^2+\sum_i\mu_i^2-2\operatorname{tr}(ST)$。用引理 A.3.3 压掉交叉项，再用引理 A.3.1（$\max_\pi\sum\lambda_i\mu_{\pi(i)}=\sum\lambda_i\mu_i$，即逆序使 $\sum\lambda_i\mu_{\pi(i)}$ 最大）：

$$\lVert S-T\rVert_F^2\ \ge\ \sum_i\lambda_i^2+\sum_i\mu_i^2-2\sum_i\lambda_i\mu_i=\sum_i(\lambda_i-\mu_i)^2,$$

而 $(\lambda_i-\mu_{\pi(i)})^2$ 展开后交叉项 $-2\lambda_i\mu_{\pi(i)}$ 由重排不等式知降序配对最小。
:::
:::

<a id="app-a-2-4"></a>

### A.2.4 von Neumann 迹不等式：完整证明（[例 2.6.4](../ch02/sec26.md#ex-2.6.4) 的补全）

::: thm 定理 A.4 · von Neumann 迹不等式
对任意 $A,B\in\mathbb{R}^{m\times n}$，$\lvert\operatorname{tr}(A^{\mathrm T}B)\rvert\le\sum_{i=1}^{\min(m,n)}\sigma_i(A)\sigma_i(B)$（奇异值均降序）。

::: proof 证明
一步「对称化膨胀」（symmetric dilation）把矩形问题化为 A.2.3 的对称情形。设 $m\ge n$（否则转置），令

$$S=\begin{pmatrix}O&A\\A^{\mathrm T}&O\end{pmatrix},\qquad T=\begin{pmatrix}O&B\\B^{\mathrm T}&O\end{pmatrix}\in\mathbb{R}^{(m+n)\times(m+n)} .$$

**（一）$S$ 对称，且特征值恰为 $\pm\sigma_i(A)$。**取 $A\boldsymbol{v}_i=\sigma_i\boldsymbol{u}_i$（SVD 的配对关系，[定理 2.6.1](../ch02/sec26.md#thm-2.6.1)），则

$$S\begin{pmatrix}\boldsymbol{v}_i\\ \boldsymbol{u}_i\end{pmatrix}=\begin{pmatrix}A\boldsymbol{u}_i\\ A^{\mathrm T}\boldsymbol{v}_i\end{pmatrix}=\sigma_i\begin{pmatrix}\boldsymbol{v}_i\\ \boldsymbol{u}_i\end{pmatrix},\qquad
S\begin{pmatrix}\boldsymbol{v}_i\\ -\boldsymbol{u}_i\end{pmatrix}=-\sigma_i\begin{pmatrix}\boldsymbol{v}_i\\ -\boldsymbol{u}_i\end{pmatrix}$$

（其中用到配对的第二式 $A^{\mathrm T}\boldsymbol{u}_i=\sigma_i\boldsymbol{v}_i$）。这 $2n$ 个向量标准正交，再补上零空间方向（特征值 $0$），共 $m+n$ 个——特征值恰为 $\sigma_1,\dots,\sigma_n,-\sigma_n,\dots,-\sigma_1$ 再补 $m-n$ 个 $0$，降序排列为 $\sigma_1\ge\cdots\ge\sigma_n\ge0\ge-\sigma_n\ge\cdots\ge-\sigma_1$（插入的 $0$ 与 $\sigma_n=0$ 或 $-\sigma_n=0$ 合并即可，不影响下文求和）。

**（二）套用对称迹不等式。**$\operatorname{tr}(ST)=2\operatorname{tr}(A^{\mathrm T}B)$（分块直接展开），$S,T$ 的特征值降序逐项相乘：

$$\operatorname{tr}(ST)\ \overset{\text{A.3.3}}{\le}\ \sum_{i\le n}\sigma_i(A)\sigma_i(B)+\sum_{i\le n}\bigl(-\sigma_{n-i+1}(A)\bigr)\bigl(-\sigma_{n-i+1}(B)\bigr)=2\sum_{i=1}^{n}\sigma_i(A)\sigma_i(B),$$

两边除以 $2$ 即得 $\operatorname{tr}(A^{\mathrm T}B)\le\sum\sigma_i(A)\sigma_i(B)$。对 $-B$ 再用一次得绝对值版本。
:::
:::

**取等条件**（正文实验的观察）：$A,B$ 的左右奇异子空间两两重合（$W=U_A^{\mathrm T}U_B$ 与 $Z=V_B^{\mathrm T}V_A$ 同时为恒等）。特例 $B=A^{\mathrm T}$：$\operatorname{tr}(A^{\mathrm T}A)=\lVert A\rVert_F^2=\sum\sigma_i^2$ 取等。

<a id="app-a-2-5"></a>

### A.2.5 Eckart–Young–Mirsky：Frobenius 情形完整证明（[定理 2.6.4](../ch02/sec26.md#thm-2.6.4) 的补全）

::: thm 定理 A.5 · Eckart–Young–Mirsky（Frobenius 情形）
$\min_{\operatorname{rank}B\le k}\lVert A-B\rVert_F=\sqrt{\sigma_{k+1}^2+\cdots+\sigma_r^2}$，由截断 SVD（2.33）取到。

::: proof 证明
上界方向（$B=A_k$ 达到）正文已算：$A-A_k$ 的奇异值恰为 $\sigma_{k+1},\dots,\sigma_r$，Frobenius 范数平方 $=\sum_{i\gt k}\sigma_i^2$。只证**下界**：任何 $\operatorname{rank}B\le k$ 都不更优。

取 A.2.4 的膨胀 $S,T$（$A\mapsto S$，$B\mapsto T$）。$T$ 的特征值：$\tau_1\ge\cdots\ge\tau_k\gt0=\tau_{k+1}=\cdots$（$B$ 至多 $k$ 个非零奇异值），降序排列为 $\tau_1,\dots,\tau_n$（$\tau_i=0,\ i\gt k$）接 $-\tau_n,\dots,-\tau_1$。由推论 A.3.4 与「降序配降序」：

$$2\lVert A-B\rVert_F^2=\lVert S-T\rVert_F^2\ \ge\ \min_{\pi}\sum_i\bigl(\lambda_i(S)-\lambda_{\pi(i)}(T)\bigr)^2=\sum_i\bigl(\lambda_i(S)-\lambda_i(T)\bigr)^2 .$$

（右端等号处用了与 A.3.4 相同的重排论证：$\sum(\lambda_i(S)-\mu_{\pi(i)}(T))^2$ 在同序配对时最小。）把两个降序谱逐项相减：

$$\sum_i\bigl(\lambda_i(S)-\lambda_i(T)\bigr)^2=\sum_{j\le n}\bigl(\sigma_j-\tau_j\bigr)^2+\sum_{j\le n}\bigl(\sigma_{n-j+1}-\tau_{n-j+1}\bigr)^2=2\sum_{j=1}^{n}\bigl(\sigma_j-\tau_j\bigr)^2\ \ge\ 2\sum_{j\gt k}\sigma_j^2,$$

最后一步因 $j\gt k$ 时 $\tau_j=0$，$(\sigma_j-\tau_j)^2=\sigma_j^2$。合并：

$$\lVert A-B\rVert_F^2\ \ge\ \sum_{j\gt k}\sigma_j^2 .$$
:::
:::

**评注。**同一套「Birkhoff + 重排 + 膨胀」顺带产出了 von Neumann 迹不等式（A.2.4）与 Hoffman–Wielandt（A.3.4）——三个「最优配对」型定理是一家人。2-范数情形（正文）用的是 Courant–Fischer 维数计数，走的是另一条路，但结论同样精确。

<a id="app-a-2-6"></a>

### A.2.6 Weyl 不等式的严格证明（[定理 2.5.6](../ch02/sec25.md#thm-2.5.6)（一）的补全）

::: thm 命题 A.6 · Weyl 扰动界
$A,E$ 对称，特征值升序 $\lambda_1\le\cdots\le\lambda_n$，$\mu_1\le\cdots\le\mu_n$（$\mu$ 为 $A+E$ 的），则 $\lvert\lambda_i-\mu_i\rvert\le\lVert E\rVert_2$。

::: proof 证明
只证 $\mu_i\le\lambda_i+\lVert E\rVert_2$（另一半对 $-E$ 同理）。由 Courant–Fischer（[定理 2.5.5](../ch02/sec25.md#thm-2.5.5) 的 max-min 形式，对升序特征值写开）：

$$\mu_i=\min_{\dim\mathcal{S}=n-i+1}\ \max_{\boldsymbol{0}\neq\boldsymbol{x}\in\mathcal{S}}\frac{\boldsymbol{x}^{\mathrm T}(A+E)\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}} .$$

**关键是把 $\min$ 换成取等子空间 $\mathcal{S}_0$ 的代入：**取 $\mathcal{S}_0=\operatorname{span}\{\boldsymbol{u}_i,\boldsymbol{u}_{i+1},\dots,\boldsymbol{u}_n\}$（$A$ 的第 $i$ 到第 $n$ 个特征向量，$\dim=n-i+1$），则

$$\mu_i\ \le\ \max_{\boldsymbol{x}\in\mathcal{S}_0}R_{A+E}(\boldsymbol{x})\ =\ \max_{\boldsymbol{x}\in\mathcal{S}_0}\Bigl(R_A(\boldsymbol{x})+\frac{\boldsymbol{x}^{\mathrm T}E\boldsymbol{x}}{\boldsymbol{x}^{\mathrm T}\boldsymbol{x}}\Bigr)\ \le\ \max_{\boldsymbol{x}\in\mathcal{S}_0}R_A(\boldsymbol{x})+\lVert E\rVert_2=\lambda_i+\lVert E\rVert_2 ,$$

最后一步：$\mathcal{S}_0$ 上 $R_A$ 的最大值是 $\lambda_i$（权只落在 $\lambda_i,\dots,\lambda_n$ 上，且 $\boldsymbol{x}=\boldsymbol{u}_i$ 达到）；扰动项的上界 $\sup_{\boldsymbol{x}\neq0}\lvert\boldsymbol{x}^{\mathrm T}E\boldsymbol{x}\rvert/\boldsymbol{x}^{\mathrm T}\boldsymbol{x}=\max(\lambda_{\max}(E),-\lambda_{\min}(E))\le\lVert E\rVert_2$。反向：$\lambda_i=\lambda_i((A+E)+(-E))\le\mu_i+\lVert E\rVert_2$。
:::
:::

**两个附注。**① 一般形式的 Weyl 不等式 $\lambda_{i+j-1}(A+B)\le\lambda_i(A)+\lambda_j(B)$（$i+j-1\le n$）用同一论证（$\mathcal{S}_0$ 取 $A$ 的前 $i-1$ 大与 $B$ 的前 $j-1$ 大的补空间交集，维数计数同 [定理 2.6.4](../ch02/sec26.md#thm-2.6.4) 的证明）。② 证明里「把 min 换成特定子空间」这一步在正文被一笔带过，正是它使放缩合法：$\min$ 的下标换成任何一个允许的 $\mathcal{S}$，都不改变「$\le$」方向。

<a id="app-a-2-7"></a>

### A.2.7 Gelfand 公式与瞬态增长（[例 2.5.6](../ch02/sec25.md#ex-2.5.6) 的定量补全）

::: thm 定理 A.7 · Gelfand 公式
对任意相容矩阵范数，$\displaystyle\lim_{k\to\infty}\lVert A^k\rVert^{1/k}=\rho(A)$。

::: proof 证明
「$\ge$」：$\rho(A)^k=\rho(A^k)\le\lVert A^k\rVert$（[2.5.1](../ch02/sec25.md#sec-2.5.1) 后的注），故 $\rho(A)\le\liminf_k\lVert A^k\rVert^{1/k}$。

「$\le$」：取 $A$ 的 Jordan 标准形 $A=PJP^{-1}$。任给 $s\gt\rho(A)$，取 $D=\operatorname{diag}(1,\ s^{-1},\ s^{-2},\dots,s^{-(n-1)})$，则 $J_s=D^{-1}JD$ 与 $J$ 相似，且**非对角元被压缩**：$(J_s)_{ij}=s^{\,i-j}J_{ij}$，约当块的每个上移位元乘上 $s^{-1}$。再取 $\tilde s$ 使 $\rho(A)\lt\tilde s\lt s$，估计 $J_s^k$ 的元素：二项展开 $(\Lambda+s^{-1}N)^k$ 的每一项是 $k$ 个因子的乘积，每个因子或为对角元 $\lambda_i$（模 $\le\rho(A)\le\tilde s$），或为上移位元 $s^{-1}$（与 $k$ 无关的常数）。非零乘积中移位因子至多 $n-1$ 个（$N$ 的幂零性），组合数 $\binom{k}{q}\le k^{\,n-1}$，移位因子与 $\tilde s^{-(n-1)}$ 一并并入与 $k$ 无关的常数 $C$，得

$$\lvert(J_s^k)_{ij}\rvert\ \le\ C\,k^{\,n-1}\,\tilde s^{\,k} .$$

故

$$\lVert A^k\rVert\le\lVert P D\rVert\,\lVert J_s^k\rVert\,\lVert D^{-1}P^{-1}\rVert\le C'\,k^{\,n-1}s^{\,k},\qquad
\lVert A^k\rVert^{1/k}\le C'^{1/k}\,k^{(n-1)/k}\,s\ \xrightarrow{k\to\infty}\ s .$$

令 $s\downarrow\rho(A)$ 即得。
:::
:::

**（二）对角化情形的瞬态增长界。**$B=V\Lambda V^{-1}$，则对一切 $k$：

$$\frac{\rho(B)^k}{\operatorname{cond}(V)}\ \le\ \lVert B^k\rVert\ \le\ \operatorname{cond}(V)\,\rho(B)^k$$

（右端：$\lVert V\Lambda^kV^{-1}\rVert\le\lVert V\rVert\lVert\Lambda^k\rVert\lVert V^{-1}\rVert$；左端：把 $\rho^k=\lVert\Lambda^k\rVert=\lVert V^{-1}B^kV\rVert$ 反向放缩）。**非正规性（$\operatorname{cond}(V)$ 大）正是瞬态增长的上限来源**。

**（三）$2\times2$ 的精确算例。**$B=\begin{pmatrix}\lambda&M\\0&\lambda\end{pmatrix}$（$\lvert\lambda\rvert\lt1$）：

$$B^k=\begin{pmatrix}\lambda^k&Mk\lambda^{k-1}\\0&\lambda^k\end{pmatrix},\qquad
\lVert B^k\rVert_2\ \ge\ Mk\lvert\lambda\rvert^{k-1},$$

右端在 $k^*\approx-1/\ln\lvert\lambda\rvert$ 处达峰，峰值 $\approx\dfrac{M}{e\,\lvert\ln\lvert\lambda\rvert\rvert}$——**随 $M$ 线性增长**。取 $\lambda=0.99$、$M=1000$：峰值 $\approx\dfrac{1000}{e\times0.0101}\approx3.7\times10^{4}$，出现在 $k^*\approx99$ 步——迭代先放大三万七千倍，再开始收敛。「$\rho\lt1$ ⟹ 收敛」没有说谎，但**前一百步的灾难它一个字都没提**；这就是 [例 2.5.6](../ch02/sec25.md#ex-2.5.6) 结论「实用判据取 $\lVert H\rVert\lt1$」的定量版。

<a id="app-a-2-8"></a>

### A.2.8 Kantorovich 不等式与最速下降的收敛率（[2.4](../ch02/sec24.md) 的延伸）

::: thm 定理 A.8 · Kantorovich 不等式
$A$ 对称正定，特征值 $0\lt m\le\cdots\le M$，则对任意 $\boldsymbol{x}\neq\boldsymbol{0}$：

$$\frac{(\boldsymbol{x}^{\mathrm T}A\boldsymbol{x})^2}{(\boldsymbol{x}^{\mathrm T}\boldsymbol{x})(\boldsymbol{x}^{\mathrm T}A^2\boldsymbol{x})}\ \ge\ \frac{4mM}{(m+M)^2} .$$

::: proof 证明
在特征基下对角化 $A=\operatorname{diag}(\lambda_i)$，写 $\boldsymbol{x}=\sum k_i\boldsymbol{u}_i$，取权 $w_i=k_i^2/\sum_jk_j^2$，则命题变为 $\dfrac{(\sum w_i\lambda_i)^2}{\sum w_i\lambda_i^2}\ge\dfrac{4mM}{(m+M)^2}$（两边同除 $(\sum k_j^2)^2$）。由 $m\le\lambda_i\le M$：$(\lambda_i-m)(\lambda_i-M)\le0$，即

$$\lambda_i^2\ \le\ (m+M)\lambda_i-mM .$$

乘以 $w_i$ 求和（记 $u=\sum w_i\lambda_i\in[m,M]$，$v=\sum w_i\lambda_i^2$）：$v\le(m+M)u-mM$。于是

$$\frac{u^2}{v}\ \ge\ \frac{u^2}{(m+M)u-mM}\ \ge\ \min_{u\in[m,M]}\frac{u^2}{(m+M)u-mM} .$$

对 $u$ 求导，极小点 $u^*=\dfrac{2mM}{m+M}\in[m,M]$，代入得 $\dfrac{u^{*2}}{2mM-mM}=\dfrac{4mM}{(m+M)^2}$。
:::
:::

**应用：最速下降解 $A\boldsymbol{x}=\boldsymbol{b}$ 的收敛率。**迭代 $\boldsymbol{x}_{k+1}=\boldsymbol{x}_k+\alpha_k\boldsymbol{r}_k$（$\boldsymbol{r}_k=\boldsymbol{b}-A\boldsymbol{x}_k=-A\boldsymbol{e}_k$），精确线搜索 $\alpha_k=\dfrac{\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k}{\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k}$。令 $\tilde{\boldsymbol{e}}=A^{1/2}\boldsymbol{e}_k$（$\lVert\boldsymbol{e}_k\rVert_A=\lVert\tilde{\boldsymbol{e}}_k\rVert_2$，$\boldsymbol{r}_k=A^{1/2}\tilde{\boldsymbol{e}}_k$），展开：

$$\lVert\boldsymbol{e}_{k+1}\rVert_A^2=\lVert\boldsymbol{e}_k\rVert_A^2-2\alpha_k\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k+\alpha_k^2\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k\ \Big|_{\alpha=\alpha_k}=\lVert\boldsymbol{e}_k\rVert_A^2-\frac{(\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k)^2}{\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k},$$

$$\frac{\lVert\boldsymbol{e}_{k+1}\rVert_A^2}{\lVert\boldsymbol{e}_k\rVert_A^2}=1-\frac{(\tilde{\boldsymbol{e}}_k^{\mathrm T}A\tilde{\boldsymbol{e}}_k)^2}{(\tilde{\boldsymbol{e}}_k^{\mathrm T}\tilde{\boldsymbol{e}}_k)(\tilde{\boldsymbol{e}}_k^{\mathrm T}A^2\tilde{\boldsymbol{e}}_k)}\ \overset{\text{A.8}}{\le}\ 1-\frac{4mM}{(m+M)^2}=\Bigl(\frac{M-m}{M+m}\Bigr)^2=\Bigl(\frac{\kappa-1}{\kappa+1}\Bigr)^2 .$$

（中间一步用了 $\boldsymbol{r}_k^{\mathrm T}\boldsymbol{r}_k=\tilde{\boldsymbol{e}}_k^{\mathrm T}A\tilde{\boldsymbol{e}}_k$、$\boldsymbol{r}_k^{\mathrm T}A\boldsymbol{r}_k=\tilde{\boldsymbol{e}}_k^{\mathrm T}A^2\tilde{\boldsymbol{e}}_k$、$\lVert\boldsymbol{e}_k\rVert_A^2=\tilde{\boldsymbol{e}}_k^{\mathrm T}\tilde{\boldsymbol{e}}_k$。）**每步误差压缩因子 $\le\bigl(\frac{\kappa-1}{\kappa+1}\bigr)^2$**：$\kappa=10$ 时 $\approx0.67$（尚可），$\kappa=10^4$ 时 $\approx0.9996$——三万步才压两个数量级。条件数不仅决定**结果准不准**（[2.4](../ch02/sec24.md)），也决定**迭代快不快**；降低 $\kappa$ 的手段（预条件、行均衡化 2.4.5）由此获得双重回报。与定步长梯度下降（[附录 C.2.1](connections.md#app-c-2-1)）及共轭梯度法（$\bigl(\frac{\sqrt\kappa-1}{\sqrt\kappa+1}\bigr)^k$，见[附录 C.6.1](connections.md#app-c-6-1)）的完整对照放在附录 C。

::: note 本附录引用的外部结果
除 Birkhoff 定理（A.2.3 自证）与 Jordan 标准形（A.2.7 引用，见任何高等代数教材）外，全部推导自含。进一步的系统展开见延伸阅读里的 Horn & Johnson《Matrix Analysis》（迹不等式与特征值扰动）、Higham《Accuracy and Stability of Numerical Algorithms》（Chapter 4：求和与浮点）与 Golub & Van Loan《Matrix Computations》（2.3–2.6 节：正交化与 SVD）。
:::
