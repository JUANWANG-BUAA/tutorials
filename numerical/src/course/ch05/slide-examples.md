# 5.6 逼近与拟合的完整算例

[上一节](sec55.md#sec-5.6)给出了投影条件。下面先计算函数逼近题，再对一组数据作曲线拟合。每题都先写清要最小化的误差，再列方程求系数。

首次学习按顺序做：第一题练法方程，第二题练积分和误差自检，第三题练换区间与正交基，最后把积分换成数据求和。复习时可直接按题型进入。

| 想复习什么 | 例题 | 应检查的结果 |
|:--|:--|:--|
| 幂基法方程与唯一性 | [正弦函数](#slide-sine) | Gram 矩阵正定，误差与 1、x 正交 |
| 根式积分与误差平方和 | [根式函数](#slide-root) | 最优平方误差等于 $(f,f)-\boldsymbol c^{\mathrm T}\boldsymbol d$ |
| 区间变换与正交投影 | [反正切函数](#slide-arctan) | 先在 $[-1,1]$ 算系数，再换回 x |
| 偶函数与正交投影 | [绝对值函数](#slide-absolute-value) | 系数由积分求出，误差与偶次基正交 |
| 非线性模型线性化 | [钢包数据](#slide-ladle) | 变换前后的残差单位与权重不同 |

## 一、正弦函数的一次最佳平方逼近 {#slide-sine}

lecture11 pp.8–10 要求在 $[0,\pi/2]$ 上选择 $p(x)=ax+b$，使

$$
J(a,b)=\int_0^{\pi/2}(\sin x-ax-b)^2\,dx
$$

最小。这里的“最佳”由这个积分定义，并不要求直线通过端点。

误差分别与 1、x 正交，得到

$$
\begin{pmatrix}
\pi/2&\pi^2/8\\
\pi^2/8&\pi^3/24
\end{pmatrix}
\begin{pmatrix}b\\a\end{pmatrix}
=\begin{pmatrix}1\\1\end{pmatrix}.
$$

右端来自 $\int_0^{\pi/2}\sin x\,dx=1$ 和分部积分 $\int_0^{\pi/2}x\sin x\,dx=1$。解得

$$
a=\frac{24(4-\pi)}{\pi^3}\approx0.6644388982,\qquad
b=\frac8\pi-\frac{24}{\pi^2}\approx0.1147706821.
$$

因此 $p(x)\approx0.6644388982x+0.1147706821$。Gram 矩阵的首个顺序主子式为 $\pi/2>0$，行列式为 $\pi^4/192>0$，故正定，法方程给出唯一极小值。若直接对 J 求二阶偏导，按参数 $(a,b)$ 排列的 Hessian 为

$$
\begin{pmatrix}\pi^3/12&\pi^2/4\\\pi^2/4&\pi\end{pmatrix}.
$$

混合偏导为 $\pi^2/4$。最优平方误差可由投影关系简算：

$$
J_{\min}=\int_0^{\pi/2}\sin^2x\,dx-(a+b)
=\frac\pi4-a-b\approx0.0061885832.
$$

这一题中基函数很简单，直接积分就能得到法方程。下一题沿用同一办法，但积分中出现根式，更需要保留精确表达式再取小数。

## 二、根式函数的一次逼近与误差核对 {#slide-root}

lecture11 pp.16–17 取 $f(x)=\sqrt{1+x^2}$、区间 $[0,1]$、权 1，仍在 $\operatorname{span}\{1,x\}$ 中求最佳逼近。令 $L=\log(1+\sqrt2)$，则

$$
I_0=\int_0^1\sqrt{1+x^2}\,dx=\frac{\sqrt2+L}{2},\qquad
I_1=\int_0^1x\sqrt{1+x^2}\,dx=\frac{2\sqrt2-1}{3}.
$$

第二个积分用 $u=1+x^2$ 即可。法方程为

$$
\begin{pmatrix}1&1/2\\1/2&1/3\end{pmatrix}
\begin{pmatrix}b\\a\end{pmatrix}
=\begin{pmatrix}I_0\\I_1\end{pmatrix},
$$

消元得 $a=12I_1-6I_0$、$b=4I_0-6I_1$，所以

$$
a=5\sqrt2-4-3L\approx0.4269470508,\qquad
b=2-2\sqrt2+2L\approx0.9343200493.
$$

再算 $(f,f)=\int_0^1(1+x^2)\,dx=4/3$，得

$$
J_{\min}=\frac43-bI_0-aI_1\approx0.0007129278698.
$$

代回两条法方程可以检查系数，再用投影恒等式核对平方误差。

## 三、反正切函数：先换区间，再换回变量 {#slide-arctan}

lecture11 pp.33–34 求 $\arctan x$ 在 $[0,1]$ 上的一次最佳平方逼近。这里换用 Legendre 基，看看正交性能省下哪一步。

令 $\xi=2x-1$，则 $x=(\xi+1)/2$，函数变为 $g(\xi)=\arctan((\xi+1)/2)$。在 $[-1,1]$ 上取 $P_0=1,P_1=\xi$，有

$$
g(\xi)\approx d_0+d_1\xi,\qquad
d_0=\tfrac12\int_{-1}^1g(\xi)\,d\xi,\quad
d_1=\tfrac32\int_{-1}^1\xi g(\xi)\,d\xi.
$$

原目标积分在换元后多出的常数 $1/2$ 不改变最优系数。换回 x 计算两个积分：

$$
A_0=\int_0^1\arctan x\,dx=\frac\pi4-\frac12\log2,\qquad
A_1=\int_0^1x\arctan x\,dx=\frac\pi4-\frac12.
$$

于是 $d_0=A_0$、$d_1=3(2A_1-A_0)$。正交基让系数分别求出，无须联立解方程。最后还要把 $\xi=2x-1$ 代回：

$$
p(x)=(d_0-d_1)+2d_1x
=\left(3-2\log2-\frac\pi2\right)
+\left(-6+3\log2+\frac{3\pi}2\right)x.
$$

即 $p(x)\approx0.0429093121+0.7918305221x$。若忘记最后的换元，会把 $d_1$ 误当作 x 的系数；此时可以代入 $x=0$、$x=1$ 检查变量是否还对应原区间。

## 四、钢包容积：线性化以后，最小化的是什么？ {#slide-ladle}

lecture12 pp.4–6 给出使用次数 k 与容积 V，模型为 $V=k/(ak+b)$。原数据如下：

| k | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
|:--|--:|--:|--:|--:|--:|--:|--:|--:|
| V | 6.42 | 5.20 | 9.58 | 9.50 | 9.70 | 10.00 | 9.93 | 9.99 |

| k | 9 | 10 | 11 | 12 | 13 | 14 | 15 |
|:--|--:|--:|--:|--:|--:|--:|--:|
| V | 10.49 | 10.59 | 10.60 | 10.80 | 10.60 | 10.90 | 10.76 |

取倒数后，$w=1/V=a+bz$，其中 $z=1/k$。对变换后的数据做一次线性拟合，法方程是

$$
\begin{pmatrix}15&\sum z_i\\\sum z_i&\sum z_i^2\end{pmatrix}
\begin{pmatrix}a\\b\end{pmatrix}
=\begin{pmatrix}\sum w_i\\\sum z_iw_i\end{pmatrix}.
$$

得到 $a\approx0.0880189491$、$b\approx0.0895179798$。以下代码只需 Python 标准库，可复现系数并换回原容积检查残差：

```python
volumes = [6.42, 5.20, 9.58, 9.50, 9.70, 10.00, 9.93, 9.99,
           10.49, 10.59, 10.60, 10.80, 10.60, 10.90, 10.76]
k = list(range(1, len(volumes) + 1))
z = [1 / t for t in k]
w = [1 / v for v in volumes]
n = len(k)
sz, sw = sum(z), sum(w)
szz = sum(t * t for t in z)
szw = sum(t * v for t, v in zip(z, w))
b = (n * szw - sz * sw) / (n * szz - sz * sz)
a = (sw - b * sz) / n
predicted = [t / (a * t + b) for t in k]
sse = sum((v - p) ** 2 for v, p in zip(volumes, predicted))
print(f"a={a:.10f}, b={b:.10f}, 原容积残差平方和={sse:.10f}")
```

输出为 `a=0.0880189491, b=0.0895179798, 原容积残差平方和=8.0238016807`。例如 k=2 时预测为 7.53137，与原值 5.20 相差较大。这个读数与相邻项不同，计算时先保留原值；是否为误录，需要原始实验记录才能判断。

线性化求的是 $\sum_i(1/V_i-a-b/k_i)^2$ 的最小值。若记模型预测为 $\widehat V_i=k_i/(ak_i+b)$，则

$$
\left(\frac1{V_i}-\frac1{\widehat V_i}\right)^2
=\frac{(V_i-\widehat V_i)^2}{V_i^2\widehat V_i^2}.
$$

这相当于给原容积残差加上与数据、参数都有关的权重，较小容积的影响更大。因此线性化的最优系数不必使原容积平方误差最小。直接在原量纲上迭代求解，可得到 $a\approx0.085354714$、$b\approx0.097296933$，原容积残差平方和约为 7.561404259；这是另一种拟合目标的数值结果。

## 做完以后，怎样检查？

前三题都可以把残差分别乘 1 和 x 再积分，检查是否为零；换了正交基，最后的最优直线应与幂基求解一致。数据拟合则先写清误差在哪个量纲上计算，再代回原模型检查预测值。回到[最佳平方逼近](sec55.md#sec-5.6)，这些计算用的仍是同一个投影条件。


## 五、绝对值函数：只用偶次多项式作逼近 {#slide-absolute-value}

求 $f(x)=|x|$ 在 $[-1,1]$ 上、权为 1、逼近空间为 $\operatorname{span}\{1,x^2,x^4\}$ 的最佳平方逼近。前三题使用一次多项式，这里则利用函数的偶对称性，改用偶次 Legendre 基 $P_0,P_2,P_4$。这三个基函数张成同一个逼近空间。

由 $\lVert P_j\rVert^2=2/(2j+1)$，投影系数为
$$c_j=\frac{2j+1}{2}\int_{-1}^1|x|P_j(x)\,dx
=(2j+1)\int_0^1xP_j(x)\,dx.$$

代入 $P_0=1$、$P_2=(3x^2-1)/2$、$P_4=(35x^4-30x^2+3)/8$，分别算得
$$c_0=\frac12,\qquad c_2=5\left(\frac38-\frac14\right)=\frac58,$$
$$c_4=\frac98\left(\frac{35}{6}-\frac{30}{4}+\frac32\right)=-\frac3{16}.$$

因此
$$p(x)=\frac12P_0(x)+\frac58P_2(x)-\frac3{16}P_4(x)
=\frac{15}{128}+\frac{105}{64}x^2-\frac{105}{128}x^4.$$

可以直接检查误差与 $1,x^2,x^4$ 的内积都为零。再用投影恒等式计算最优平方误差：
$$\int_{-1}^1(|x|-p(x))^2dx
=\frac23-\left[2\left(\frac12\right)^2+\frac25\left(\frac58\right)^2+\frac29\left(-\frac3{16}\right)^2\right]
=\frac1{384}.$$

来源为最佳平方逼近课件 lecture11 第 28 页。原页的 $c_2=1.25$、$c_4=0.1875$ 有算术错误，分别应为 $0.625$、$-0.1875$；本题按积分重新计算。逼近空间、区间和权保持与原题一致。
