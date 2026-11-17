# 2.7 数值实验：亲手看见正交与谱

> **本节属“补充篇 · 数值线性代数工具箱”**：2.x 是补充篇内部编号，不是课堂第 2 章的节号。课堂第 2 章是[线性方程组的解法](../course/ch02/overview.md)。

本章的四个核心论断，在**教科书证明里**都是干净的定理，但在**浮点现实里**是否成立、以什么量级成立，必须亲手测一遍。本节的前三组实验分别对应：

- **实验一**（对应 [2.3.3](sec23.md#sup-2.3.3)）：三种正交化方法的正交性损失量级——$\mathrm{cond}^2u$ vs $\mathrm{cond}\,u$ vs $u$；
- **实验二**（对应 [2.4.1](sec24.md#sup-2.4.1)、[2.3.6](sec23.md#sup-2.3.6)）：条件数如何预测有效数字损失，以及正态方程 vs QR 的分水岭；
- **实验三**（对应 [2.6.5](sec26.md#sup-2.6.5)、[2.6.6](sec26.md#sup-2.6.6)）：Eckart–Young 最优性与低秩压缩 / PCA。

所有代码只依赖 `numpy`。下面的输出供比较；实验三的代码及输出已在 Python 3.13.13、NumPy 2.4.6 下运行，其余历史输出未附齐平台和库版本。不同环境的末位和接近零的结果可能不同；报告中的“实测”应来自自己的运行，并与精确恒等式、误差上界和渐近参考量级分别比较。

::: note 实验报告的统一要求
每题都给出「报告要求」；提交时请包含四部分：① 可复现的脚本（含随机种子）；② 实测输出（原样粘贴）；③ 与理论预测的**逐项对照表**（理论值 / 实测值 / 比值）；④ 对「为什么是这个量级」的一段解释。**只贴代码、不给对照表的报告不合格**——这些实验的目的始终是「用数据检验理论」，而不是「跑通代码」。
:::

**先认清测量对象。** 正交性损失 $\|Q^{\mathrm T}Q-I\|$ 与分解残差 $\|A-QR\|/\|A\|$ 是两个指标：重建准确不代表列正交。已知解误差是前向误差，尺度化残差是后向误差的线索，二者也不能互换。理论用 2-范数而脚本用 F-范数时，可用 $\|M\|_2\le\|M\|_F\le\sqrt{\operatorname{rank}M}\|M\|_2$ 比较量级，不能逐位比较常数。误差接近舍入水平后，比值会被噪声主导，不宜继续估计收敛阶。

<a id="sup-2.7.1"></a>

## 实验一 · 三种正交化方法的正交性退化

**目的：** 比较经典 Gram–Schmidt（CGS）、修正 Gram–Schmidt（MGS）与 Householder QR 的正交性损失。$\mathrm{cond}^2u$、$\mathrm{cond}\,u$ 和带维数因子的 $u$ 是有条件的参考量级，不是每个矩阵都必须达到的等值或固定失效阈值。

**做法：** 取节点均匀分布在 $[0.1,1]$ 的 Vandermonde 矩阵，改变维数 $n$，分别计算三种方法的 $\lVert Q^{\mathrm T}Q-I\rVert$。下面代码默认计算 Frobenius 范数；若要和 2-范数误差界逐项对照，需在 `np.linalg.norm` 中指定 `2`。

```python
import numpy as np
u = np.finfo(float).eps / 2          # 单位舍入误差，双精度 ≈1.11e-16

def cgs(A):
    """经典 Gram–Schmidt：r_ij 用【原始】列 a_j"""
    m, n = A.shape
    Q = A.astype(float).copy(); R = np.zeros((n, n))
    for j in range(n):
        for i in range(j):
            R[i, j] = Q[:, i] @ A[:, j]          # ← 原始列
            Q[:, j] -= R[i, j] * Q[:, i]
        R[j, j] = np.linalg.norm(Q[:, j])
        Q[:, j] /= R[j, j]
    return Q, R

def mgs(A):
    """修正 Gram–Schmidt：r_ij 用【当前】列（就地更新）"""
    m, n = A.shape
    Q = A.astype(float).copy(); R = np.zeros((n, n))
    for j in range(n):
        for i in range(j):
            R[i, j] = Q[:, i] @ Q[:, j]          # ← 当前列
            Q[:, j] -= R[i, j] * Q[:, i]
        R[j, j] = np.linalg.norm(Q[:, j])
        Q[:, j] /= R[j, j]
    return Q, R

def house(A):
    """Householder 反射（逐步消元），返回 Q, R"""
    m, n = A.shape
    R = A.astype(float).copy(); Q = np.eye(m)
    for k in range(min(m - 1, n)):
        x = R[k:, k]
        alpha = -(1 if x[0] >= 0 else -1) * np.linalg.norm(x)
        v = x - alpha * np.eye(1, len(x), 0).ravel()
        nv = np.linalg.norm(v)
        if nv < 1e-300: continue
        v = v / nv
        R[k:, :] -= 2 * np.outer(v, v @ R[k:, :])
        Q[:, k:] -= 2 * np.outer(Q[:, k:] @ v, v)
    return Q, np.triu(R[:n, :])

print(f"{'n':>3} {'cond(A)':>10} {'CGS':>11} {'MGS':>11} {'Householder':>12} "
      f"{'cond*u':>10} {'cond^2*u':>10}")
for n in [6, 8, 10, 12, 14, 16]:
    x = np.linspace(0.1, 1.0, n)
    A = np.vander(x, n, increasing=True)
    c = np.linalg.cond(A)
    f = lambda Q: np.linalg.norm(Q.T @ Q - np.eye(Q.shape[1]))
    print(f"{n:3d} {c:10.2e} {f(cgs(A)[0]):11.2e} {f(mgs(A)[0]):11.2e} "
          f"{f(house(A)[0]):12.2e} {c*u:10.2e} {c*c*u:10.2e}")
```

**实测输出（本教材运行结果）：**

```text
  n     cond(A)         CGS         MGS  Householder     cond*u   cond^2*u
  6   1.02e+04    8.78e-10    1.47e-13     1.22e-15    1.1e-12    1.2e-08
  8   7.40e+05    2.51e-05    2.28e-11     1.29e-15    8.2e-11    6.1e-05
 10   5.60e+07    1.19e+00    8.11e-10     2.45e-15    6.2e-09    3.5e-01
 12   4.35e+09    2.47e+00    1.24e-07     2.12e-15    4.8e-07    2.1e+03
 14   3.42e+11    4.48e+00    4.70e-06     2.18e-15    3.8e-05    1.3e+07
 16   2.73e+13    6.55e+00    4.70e-04     3.00e-15    3.0e-03    8.3e+10
```

**结论（逐条对照上面的实测输出表）：**

1. **本表中 Householder 的正交性损失接近舍入误差量级**：从 $n=6$ 到 $n=16$ 都约为 $10^{-15}$，没有随条件数明显增长。精确正交变换保持 2-范数，但浮点计算每一步仍引入舍入误差；其稳定性结论还需考虑维数和浮点计算条件，不能只靠正交性断言。
2. **比较 MGS 列与 $\mathrm{cond}\cdot u$**：表中 $n=14$ 行的参考量为 $3.8\times10^{-5}$、实测值为 $4.7\times10^{-6}$；$n=16$ 行分别为 $3.0\times10^{-3}$ 和 $4.7\times10^{-4}$。参考量说明趋势，不是每次运行的精确预测。
3. **CGS 列先随风险尺度增长，随后只剩粗糙的维数量级限制。** $n=10$ 时 $\mathrm{cond}^2u=0.35$，实测 F-范数损失为 $1.19$；$n=16$ 时参考量高达 $8.3\times10^{10}$，实测仅 $6.55$。若输出每列已单位化，$Q^{\mathrm T}Q$ 半正定且迹为 $n$，则 $\|Q^{\mathrm T}Q-I\|_F^2=\sum_i\lambda_i^2-n\le n^2-n$。这解释了实测量不会按参考式无限增大，却不表示正交性恢复。

**风险尺度：** $\mathrm{cond}^2u$ 接近 1 时，CGS 的常见误差界不再保证正交性；本表中 $n=10$ 已出现显著损失，但这不是所有输入共享的分界。

**报告要求：** ① 比较三种实测误差及参考量级，并注明范数与维数；② 换用几何分布节点观察变化；③ 加入再正交化并比较结果，不要求每个比值恒定。

<a id="sup-2.7.2"></a>

## 实验二 · 条件数预测有效数字，正态方程 vs QR

**目的：** 考察 $\log_{10}\mathrm{cond}(A)$ 的最坏情形位数估计，并比较相容最小二乘问题的法方程与 QR。条件数给出敏感性上界的尺度，不保证每次计算恰好损失这么多位。

**做法：** (a) 对 Hilbert 矩阵以 $\boldsymbol x=\boldsymbol1$ 构造右端，比较求解误差和 $\mathrm{cond}\,u$；(b) 对病态 Vandermonde 最小二乘问题比较法方程与 QR。记录浮点类型及平台，并解释不同扰动方向和算法的影响。

```python
import numpy as np
u = np.finfo(float).eps / 2          # ≈1.11e-16

print("== (a) Hilbert 矩阵：条件数 vs 实测误差 ==")
print(f"{'n':>3} {'cond2':>10} {'log10(cond)':>12} {'实测误差':>11} {'cond*u':>10}")
for n in [4, 6, 8, 10, 12]:
    H = np.array([[1/(i + j + 1.0) for j in range(n)] for i in range(n)])
    x = np.ones(n); b = H @ x
    xh = np.linalg.solve(H, b)                   # 双精度求解
    c = np.linalg.cond(H, 2)
    print(f"{n:3d} {c:10.2e} {np.log10(c):12.1f} "
          f"{np.max(np.abs(xh - x)):11.2e} {c*u:10.2e}")

print()
print("== (b) 最小二乘：正态方程 vs QR ==")
print(f"{'m':>3} {'n':>3} {'cond(A)':>10} {'正态方程误差':>13} {'QR 误差':>11}")
for m, n in [(12, 10), (20, 15)]:
    xd = np.linspace(0, 1, m)
    A = np.vander(xd, n, increasing=True)
    c0 = np.ones(n); b = A @ c0                  # 相容右端（真解 c0）
    # 正态方程
    c_ne = np.linalg.solve(A.T @ A, A.T @ b)
    # QR
    Q, R = np.linalg.qr(A)
    c_qr = np.linalg.solve(R, Q.T @ b)
    print(f"{m:3d} {n:3d} {np.linalg.cond(A):10.2e} "
          f"{np.max(np.abs(c_ne - c0)):13.2e} {np.max(np.abs(c_qr - c0)):11.2e}")
```

**实测输出（本教材运行结果）：**

```text
== (a) Hilbert 矩阵：条件数 vs 实测误差 ==
  n     cond2  log10(cond)      实测误差     cond*u
  4  1.55e+04          4.2    4.996e-14   1.72e-12
  6  1.50e+07          7.2    2.287e-10   1.66e-09
  8  1.53e+10         10.2    1.613e-07   1.69e-06
 10  1.60e+13         13.2    7.441e-04   1.78e-03
 12  1.72e+16         16.2    2.201e-01   1.91e+00

== (b) 最小二乘：正态方程 vs QR ==
  m   n     cond(A)      正态方程误差     QR 误差
 12  10   6.84e+06      1.31e-04    5.41e-11
 20  15   6.03e+10      2.81e+01    2.23e-06
```

**结论：**

1. (a) 中误差随条件数增大而显著增长，但误差与 $\mathrm{cond}\,u$ 并不必然同量级；例如 $n=4$ 时两者相差约 34 倍。该乘积是尺度估计，不能代替针对实际输入和算法的误差分析。
2. $n=12$ 时实测误差约为 $0.22$；$\mathrm{cond}\,u>1$ 表示常见最坏情形估计不能保证有效位数，并不表示每个右端都无法求解。
3. (b) 第二行法方程误差约 $28$，QR 误差约 $2.2\times10^{-6}$，反映这组数据中显式法方程引入了更大的误差；不应据此设定普适的失效分界。

**报告要求：** 画出误差与参考量级，说明比值及平台依赖；改变矩阵规模并比较 QR 与 `np.linalg.lstsq`，同时记录残差和已知解误差。

<a id="sup-2.7.3"></a>

## 实验三 · 低秩逼近、截断伪逆与 PCA

**目的：** 验证 Eckart–Young 定理（$\lVert A-A_k\rVert_2=\sigma_{k+1}$ 精确成立），实测低秩压缩的「存储–误差」曲线，并用 SVD 做一次 PCA，与协方差矩阵的特征值分解对照。**预期看到**：截断误差与 $\sigma_{k+1}$ 一致到机器精度；很小的存储占比就能复原图像的大部分能量；SVD 的奇异值与协方差特征值满足 $\sigma_i=\sqrt{(n-1)\lambda_i}$。

**压缩指标怎样读？** 对 $m\times n$ 图像，$\mathrm{RMSE}=\|A-A_k\|_F/\sqrt{mn}$。这里 PSNR（峰值信噪比）定义为 $20\log_{10}(R/\mathrm{RMSE})$，脚本固定取原图动态范围 $R=\max A-\min A$；不同的峰值约定不能直接比较。因子存储比按吸收奇异值后的 $k(m+n)/(mn)$ 计，不含量化、文件头和实际编码开销，因此不是压缩文件大小比。

**(d) 怎样比较截断前后的解？** 构造中 $A_3$ 的信号秩至多为 3，噪声为逐元素标准差 $\varepsilon_n$ 的矩阵 $E$。阈值 `eps_n * norm(A3, 2)` 是人为选择，并非 $\|E\|_2$ 的确定上界；合成实验知道干净矩阵，可以算出实际的 $\|A_{3n}-A_3\|_2$，真实数据则需要独立噪声模型。为了比较求解误差，脚本另取 $\boldsymbol x_{\rm true}=A_3^{\mathrm T}\boldsymbol z$，再用 $A_3\boldsymbol x_{\rm true}$ 加噪声构造右端 $\boldsymbol b$。这样 $\boldsymbol x_{\rm true}$ 属于 $A_3$ 的行空间，是无噪声方程的最小范数解；将它与默认阈值和人为阈值所得的解比较，同时报告各自的残差。

```python
import numpy as np
rng = np.random.default_rng(0)

# ---------- (a) Eckart–Young：误差 = 被砍掉的第一个奇异值 ----------
print("== (a) Eckart–Young 验证 ==")
m, n = 60, 40
U_, _, Vt_ = np.linalg.svd(rng.normal(size=(m, n)), full_matrices=False)
dec = np.exp(-np.arange(n) / 2.5)                 # 精确指定奇异值（指数衰减）
A = (U_ * dec) @ Vt_
U, S, Vt = np.linalg.svd(A)
for k in [1, 2, 3, 5, 8, 10]:
    Ak = (U[:, :k] * S[:k]) @ Vt[:k]
    e2 = np.linalg.norm(A - Ak, 2)
    eF = np.linalg.norm(A - Ak, 'fro')
    print(f"k={k:2d}  ||A-Ak||_2={e2:.6e} (σ{k+1}={S[k]:.6e})  "
          f"||A-Ak||_F={eF:.6e} (√Σσ²={np.sqrt((S[k:]**2).sum()):.6e})")

# ---------- (b) 合成图像的低秩压缩 ----------
print()
print("== (b) 图像低秩压缩 ==")
N = 120
xx, yy = np.meshgrid(np.linspace(0, 1, N), np.linspace(0, 1, N))
img = (np.sin(3*np.pi*xx)*np.cos(2*np.pi*yy) + 0.6*np.sin(7*np.pi*yy)
       + 0.4*np.cos(11*np.pi*xx*yy) + (np.abs(xx - 0.5) < 0.08)*1.2)
U, S, Vt = np.linalg.svd(img, full_matrices=False)
rngv = img.max() - img.min()
print("前 12 个奇异值：", np.round(S[:12], 3))
for k in [1, 2, 3, 5, 8, 12, 20]:
    Ak = (U[:, :k] * S[:k]) @ Vt[:k]
    rmse = np.sqrt(((img - Ak)**2).mean())
    print(f"k={k:2d}  存储 2k/N={2*k/N:5.1%}  "
          f"||E||F/||A||F={np.linalg.norm(img-Ak,'fro')/np.linalg.norm(img,'fro'):.5f}  "
          f"RMSE={rmse:.4f}  PSNR={20*np.log10(rngv/rmse):.2f} dB")

# ---------- (c) PCA：SVD 与协方差特征值分解对照 ----------
print()
print("== (c) PCA ==")
rng2 = np.random.default_rng(3)
L = np.linalg.cholesky(np.array([[3., 2.], [2., 2.]]))
X = rng2.normal(size=(400, 2)) @ L.T
Xc = X - X.mean(0)                                 # 必须中心化！
C = Xc.T @ Xc / (len(X) - 1)                       # 样本协方差
w, V = np.linalg.eigh(C)                           # 特征值分解
print("样本协方差 =", np.round(C, 4).tolist())
print("特征值 =", np.round(w, 4), " (真实协方差的理论值 4.5616 / 0.4384)")
print("主方向 =", np.round(V[:, 1], 4), " 方差解释比 =", np.round(w[::-1]/w.sum(), 4))
print("SVD 对照: σ =", np.round(np.linalg.svd(Xc, compute_uv=False), 4),
      " sqrt((n-1)λ) =", np.round(np.sqrt((len(X)-1)*w), 4))

# ---------- (d) 截断伪逆：截断点决定成败 ----------
print()
print("== (d) 截断伪逆 ==")
eps_n = 1e-9
A3 = rng.normal(size=(30, 3)) @ rng.normal(size=(3, 20))
A3n = A3 + eps_n * rng.normal(size=(30, 20))        # 加噪声
U3, s, Vt3 = np.linalg.svd(A3n, full_matrices=False)
thr = eps_n * np.linalg.norm(A3, 2)
print(f"噪声阈值 ≈ {thr:.3e}；σ3={s[2]:.3e}  σ4={s[3]:.3e}")
print(f"实际噪声谱范数 = {np.linalg.norm(A3n-A3, 2):.3e}")
keep = s > thr
print(f"默认阈值 rank = {np.linalg.matrix_rank(A3n)}  →  按噪声阈值截断 rank = "
      f"{keep.sum()}")
x_true = A3.T @ rng.normal(size=A3.shape[0])
b3 = A3 @ x_true + eps_n * rng.normal(size=A3.shape[0])
x_full = np.linalg.lstsq(A3n, b3, rcond=None)[0]
x_cut = Vt3[keep].T @ ((U3[:, keep].T @ b3) / s[keep])
for label, x in [('默认阈值', x_full), ('按噪声阈值截断', x_cut)]:
    print(f"{label}: ||x-x_true||_2={np.linalg.norm(x-x_true):.3e}, "
          f"||A3n x-b||_2={np.linalg.norm(A3n@x-b3):.3e}")
```

**一次运行的输出（Python 3.13.13，NumPy 2.4.6）：**

```text
== (a) Eckart–Young 验证 ==
k= 1  ||A-Ak||_2=6.703200e-01 (σ2=6.703200e-01)  ||A-Ak||_F=9.033085e-01 (√Σσ²=9.033085e-01)
k= 2  ||A-Ak||_2=4.493290e-01 (σ3=4.493290e-01)  ||A-Ak||_F=6.055058e-01 (√Σσ²=6.055058e-01)
k= 3  ||A-Ak||_2=3.011942e-01 (σ4=3.011942e-01)  ||A-Ak||_F=4.058827e-01 (√Σσ²=4.058827e-01)
k= 5  ||A-Ak||_2=1.353353e-01 (σ6=1.353353e-01)  ||A-Ak||_F=1.823748e-01 (√Σσ²=1.823748e-01)
k= 8  ||A-Ak||_2=4.076220e-02 (σ9=4.076220e-02)  ||A-Ak||_F=5.493025e-02 (√Σσ²=5.493025e-02)
k=10  ||A-Ak||_2=1.831564e-02 (σ11=1.831564e-02)  ||A-Ak||_F=2.468175e-02 (√Σσ²=2.468175e-02)

== (b) 图像低秩压缩 ==
前 12 个奇异值： [75.876 71.599 23.769 10.148 10.148 10.148 10.142  9.827  7.829  6.711  5.492  3.607]
k= 1  存储 2k/N= 1.7%  ||E||F/||A||F=0.72427  RMSE=0.6642  PSNR=17.27 dB
k= 2  存储 2k/N= 3.3%  ||E||F/||A||F=0.31815  RMSE=0.2917  PSNR=24.42 dB
k= 3  存储 2k/N= 5.0%  ||E||F/||A||F=0.23359  RMSE=0.2142  PSNR=27.10 dB
k= 5  存储 2k/N= 8.3%  ||E||F/||A||F=0.19379  RMSE=0.1777  PSNR=28.72 dB
k= 8  存储 2k/N=13.3%  ||E||F/||A||F=0.11216  RMSE=0.1029  PSNR=33.47 dB
k=12  存储 2k/N=20.0%  ||E||F/||A||F=0.01524  RMSE=0.0140  PSNR=50.81 dB
k=20  存储 2k/N=33.3%  ||E||F/||A||F=0.00000  RMSE=0.0000  PSNR=201.71 dB
== (c) PCA ==
样本协方差 = [[3.0504, 2.0862], [2.0862, 2.0822]]
特征值 = [0.4247 4.708 ]  (真实协方差的理论值 4.5616 / 0.4384)
主方向 = [-0.783  -0.6221]  方差解释比 = [0.9173 0.0827]
SVD 对照: σ = [43.3414 13.0172]  sqrt((n-1)λ) = [13.0172 43.3414]

== (d) 截断伪逆 ==
噪声阈值 ≈ 2.539e-08；σ3=1.238e+01  σ4=9.080e-09
实际噪声谱范数 = 9.742e-09
默认阈值 rank = 20  →  按噪声阈值截断 rank = 3
默认阈值: ||x-x_true||_2=3.730e+01, ||A3n x-b||_2=1.179e-07
按噪声阈值截断: ||x-x_true||_2=9.696e-09, ||A3n x-b||_2=2.096e-07
```

**结论：**

1. **(a) 部分的每一行都精确成立**：$\lVert A-A_k\rVert_2=\sigma_{k+1}$、$\lVert A-A_k\rVert_F=\sqrt{\sigma_{k+1}^2+\cdots}$，与输出中括号里的理论值逐位吻合到机器精度——这是 [@thm-sup-2.6.4] 的直接验证。**注意误差随 $k$ 下降极快**：$k=10$ 时为 $1.8\times10^{-2}$、$k=20$ 时 $3.4\times10^{-4}$、$k=30$ 时 $6.1\times10^{-6}$，$k=40$（满秩）时降到 $3\times10^{-15}$（机器精度）——因为构造时奇异值按指数衰减，前 $k$ 个就抓住了几乎全部能量（$k=12$ 已占 $99.993\%$）。
2. **(b) 的压缩效果由奇异值尾部决定。** 本次输出中 $k=3\to5$ 和 $k=8\to12$ 的 PSNR 增益不同，可用对应尾部平方和解释；不能把某个奇异值簇直接归因于亮带。亮带矩阵在本构造中各行相同，单独的秩至多为 1，而矩阵相加后的奇异值并不逐项相加。输出中 `0.00000` 或 `0.0000` 只表示显示精度下为零，不代表无损重建；接近机器精度的结果尤其依赖运行环境。
3. **(c) 中 SVD 与特征值分解给出同一答案**：$\sigma_i=\sqrt{(n-1)\lambda_i}$ 精确成立（$43.34$ 对 $\sqrt{399\times4.708}$ ✓）。**但两者的排列顺序相反**——`eigh` 输出升序、`svd` 输出降序。样本特征值 $4.708/0.425$ 与真实值 $4.5616/0.4384$ 有偏差，这是**采样波动**（$n=400$ 的有限样本）造成的，不是算法误差。
4. **(d) 中残差小不代表解准确。** 默认阈值保留 20 项，本次得到的残差比截断后的更小，但解误差约为 $37.3$；按给定阈值保留 3 项时，解误差约为 $9.7\times10^{-9}$。被保留的小奇异值会放大数据扰动，所以两项指标需要一起看。本例已知干净矩阵和最小范数解，才能直接计算这些误差；一般问题中这个阈值不保证恢复信号秩，也不保证得到最优解。

**报告要求：** ① 对 (a) 画两种误差与理论尾部公式，随机秩 $k$ 候选的误差只能提供实验比较，不能代替最优性证明；② 对 (b) 画存储比与 PSNR，并注明动态范围和因子计数；③ 对 (d) 扫描噪声水平与阈值，记录 $\sigma_3,\sigma_4$、实际噪声谱范数和保留项数。默认浮点阈值与数据噪声阈值回答不同问题；两者何时分离取决于维数、信号谱、噪声模型与所选阈值，不使用“噪声超过 $\sigma_4$”这种循环判据。

<a id="sup-2.7.4"></a>

## 实验四（选做）· 幂法、Gerschgorin 与特征值敏感性

**目的：** 验证 [2.5.3](sec25.md#sup-2.5.3) 的收敛速度 $\lvert\lambda_2/\lambda_1\rvert^2$、[@thm-sup-2.5.2] 的圆盘围栏，以及 [2.5.5](sec25.md#sup-2.5.5) 的「本例对称矩阵的 $O(\varepsilon^2)$ 移动与 Jordan 块的 $O(\sqrt\varepsilon)$ 移动」。**预期看到**：幂法相邻两次误差的比值稳定在 $(\lambda_2/\lambda_1)^2$；三个行圆盘罩住全部特征值；同一扰动量级下，非正规矩阵的特征值移动 $\sim\sqrt\varepsilon$，本例对称矩阵为 $\sim\varepsilon^2$（一般 Weyl 上界是 $O(\varepsilon)$）。

```python
import numpy as np
np.set_printoptions(precision=6, suppress=True)

# (a) 幂法 + Rayleigh 商：验证速度 (λ2/λ1)^2
A = np.array([[5., 2, 0], [2, 4, 1], [0, 1, 3]])
w = np.sort(np.abs(np.linalg.eigvals(A)))[::-1]
print("== (a) 幂法：|λ2/λ1| =", f"{w[1]/w[0]:.6f}", "  理论误差比 =",
      f"{(w[1]/w[0])**2:.6f}")
x = np.ones(3) / np.sqrt(3); prev = None
for k in range(1, 13):
    y = A @ x; x = y / np.linalg.norm(y); r = x @ A @ x
    ratio = "" if prev is None else f"  实测比值={abs(r-w[0])/prev:.4f}"
    prev = abs(r - w[0])
    print(f"  k={k:2d} Rayleigh={r:.10f} 误差={abs(r-w[0]):.3e}{ratio}")

# (b) Gerschgorin 圆盘
print()
print("== (b) Gerschgorin ==")
A = np.array([[10., -1, 2], [0, 4, 1], [-2, 1, 5]])
print("真实特征值 =", np.sort(np.linalg.eigvals(A)))
for i in range(3):
    r_i = np.abs(A[i]).sum() - abs(A[i, i])
    print(f"  行圆盘 {i+1}: 中心 {A[i,i]:5.1f}  半径 {r_i:4.1f}  "
          f"区间 [{A[i,i]-r_i:6.2f}, {A[i,i]+r_i:6.2f}]")

# (c) 特征值对扰动的敏感性
print()
print("== (c) 对称 vs Jordan ==")
J = np.array([[1., 1], [0, 1]]); S = np.array([[1., 0], [0, 2.]])
for t in [1e-2, 1e-4, 1e-8, 1e-12]:
    ej = np.linalg.eigvals(J + np.array([[0., 0], [t, 0]]))
    es = np.linalg.eigvalsh(S + np.array([[0., t], [t, 0]]))
    print(f"  t={t:.0e}  Jordan 移动={max(abs(ej-1)):.3e} (√t={np.sqrt(t):.1e})   "
          f"对称 移动={max(abs(es-np.array([1.,2.]))):.3e}")
```

**预期结果与报告要求：** (a) 输出中「实测比值」一列应稳定在 $0.27$ 附近（理论值 $0.2717$）；本例 $A$ 对称正定，单位向量下的 $\lVert A\boldsymbol{x}\rVert_2$ 估计同样具有关于方向误差的二阶性质，渐近误差比也为 $0.2717$；$0.5212$ 是特征向量方向误差的渐近比，不能把它当成这里的特征值估计误差比。(b) 三个行圆盘为 $D(10,3)$、$D(4,1)$、$D(5,3)$，实轴截面为 $[7,13]\cup[3,5]\cup[2,8]$，其中 $D(c,r)=\{z:|z-c|\le r\}$。它们相互连通，不能用孤立圆盘计数断言第一个只含一个特征值。直接计算本例特征值约为 $\{9.0687,6.2778,3.6535\}$；矩阵非对称，仅凭实轴截面本身不能证明特征值为实数。(c) Jordan 矩阵的特征值移动量精确为 $\sqrt t$，对称矩阵的特征值移动量约为 $t^2$——两者的移动量之比约为 $t^{-3/2}$，因而 $t=10^{-2}$ 时约为 $10^3$，$t=10^{-4}$ 时约为 $10^6$。报告要点：解释 (c) 中「为什么对称矩阵的移动量是 $t^2$ 而不是 $t$」（提示：本例扰动的一阶项 $\boldsymbol{u}_1^{\mathrm T}E\boldsymbol{u}_1$ 恰为零，主导的是二阶项，见 [2.5.4](sec25.md#sup-2.5.4) 的变分刻画）。
