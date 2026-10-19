# 课程知识地图

这份教程的目标，是把「用计算机算数」讲成一个**闭环的工程问题**：误差从哪来、怎么度量、怎么控制（[第一章](ch01/overview.md)），以及控制误差所需的语言与工具箱——范数、内积、正交、投影、谱（[补充篇](ch02/overview.md)）。下文先给出概念主干图，箭头标出的正是「先学什么、后学什么」；随后的两张地图表把图上每个节点落回具体小节，方便随时定位。学习时不妨顺着箭头自检：前一环是否真的懂了。

## 第一章 + 补充篇主干

> 下图中的 2.1–2.6 是**补充篇内部编号**，不是课堂第 2 章的节号；课堂第 2 章是线性方程组，见[课堂主线](course/ch02/overview.md)。

<figure>
<svg height="420" viewBox="0 0 920 420" width="920" xmlns="http://www.w3.org/2000/svg">
<defs>
<marker id="arr2" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-size="13.5" text-anchor="middle">
<!-- 第一行：第一章 -->
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="196" x="10" y="16"></rect><text fill="var(--fig-blue)" x="108" y="42">翻译链条与四类误差（1.1）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="200" x="240" y="16"></rect><text fill="var(--fig-blue)" x="340" y="42">度量：ε / ε_r / 有效数字（1.2）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="196" x="474" y="16"></rect><text fill="var(--fig-blue)" x="572" y="42">传播与四原则 · 浮点公理（1.2）</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="196" x="700" y="16"></rect><text fill="var(--fig-blue)" x="798" y="42">向前 / 向后误差 · 条件数（1.2）</text>
<!-- 第二行：尺子 -->
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="300" x="130" y="106"></rect><text fill="var(--fig-purple)" x="280" y="132">范数：给「向量 / 矩阵多大」立公理（1.3）</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="360" x="470" y="106"></rect><text fill="var(--fig-purple)" x="650" y="132">等价定理 · 相容性 · ‖A‖&lt;1 与 Neumann 级数（1.3）</text>
<!-- 第三行：补充篇结构 -->
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="196" x="10" y="196"></rect><text fill="var(--fig-green)" x="108" y="222">内积与正交矩阵（2.1）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="220" x="240" y="196"></rect><text fill="var(--fig-green)" x="350" y="222">四个子空间与投影 · 最小二乘（2.2）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="230" x="494" y="196"></rect><text fill="var(--fig-green)" x="609" y="222">正交化与 QR 分解（2.3）</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="170" x="748" y="196"></rect><text fill="var(--fig-green)" x="833" y="222">条件数与扰动（2.4）</text>
<!-- 第四行：谱 -->
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="290" x="118" y="286"></rect><text fill="var(--fig-gold)" x="263" y="312">特征值 · 谱半径 · Gerschgorin（2.5）</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="290" x="444" y="286"></rect><text fill="var(--fig-gold)" x="589" y="312">对称谱：Rayleigh 商 · Courant–Fischer</text>
<rect fill="color-mix(in srgb, var(--fig-red) 14%, transparent)" height="42" rx="9" stroke="color-mix(in srgb, var(--fig-red) 45%, transparent)" width="230" x="342" y="362"></rect><text fill="var(--fig-red)" x="457" y="382">SVD · 低秩逼近 · 数值秩（2.6）</text>
</g>
<g fill="none" marker-end="url(#arr2)" stroke="var(--muted)" stroke-width="1.4">
<path d="M206,37 L240,37"></path><path d="M440,37 L474,37"></path><path d="M670,37 L700,37"></path>
<path d="M798,58 L798,82 L280,82 L280,106"></path>
<path d="M572,58 L572,90 L650,90 L650,106"></path>
<path d="M340,148 L340,172 L108,172 L108,196"></path>
<path d="M650,148 L650,176 L350,176 L350,196"></path>
<path d="M108,238 L108,262 L263,262 L263,286"></path>
<path d="M609,238 L609,262 L589,262 L589,286"></path>
<path d="M350,238 L350,340 L457,340 L457,362"></path>
<path d="M833,238 L833,258 L700,258 L700,196" stroke-dasharray="4 3"></path>
</g>
</svg>
<figcaption>图 0-1 · 第一章 + 补充篇概念主干：翻译产生误差 → 误差可度量、会传播 → 度量与控制的语言是范数 → 范数的几何实现是内积与正交 → 正交结构给出投影、QR 与 SVD → 谱刻画敏感性</figcaption>
</figure>

一句话主线：**科学计算的每一步翻译都产生误差（1.1）；误差用绝对 / 相对误差与有效数字来度量，并按四则运算的规则传播（1.2 前半）。要控制传播，先得弄清浮点数的表示与运算，再掌握算法设计原则（1.2 后半）；而「误差究竟有多大」这句话本身就需要一把尺子——范数（1.3）。第一章把这把尺子造好，却只回答「多大」；补充篇把尺子升级为几何——内积定义「正交」，正交给出「投影」，投影导出「最小二乘」与「QR」，而条件数（2.4）、谱半径（2.5）、奇异值（2.6）分别回答「多敏感」「多快收敛」「离奇异有多远」。**

## 第一章地图（误差与范数）

| 层 | 内容 | 位置 |
|:--|:--|:--|
| 问题层 | 科学计算链条、四类误差的落点、四个关键词 | [1.1](ch01/sec11.md) |
| 度量层 | $e,\varepsilon,\varepsilon_{\mathrm r}$、有效数字与相对误差的换算 | [1.2.2](ch01/sec12.md#sec-1.2.2) |
| 传播层 | 一元 / 多元 Taylor 误差估计、四则运算误差限 | [1.2.3](ch01/sec12.md#sec-1.2.3) |
| 算法层 | 复杂度 $O(\cdot)$、稳定性、四条设计原则、秦九韶 | [1.2.4](ch01/sec12.md#sec-1.2.4) |
| 机器层 | IEEE 754、机器精度 $u$、浮点算术公理 | [1.2.5](ch01/sec12.md#sec-1.2.5) |
| 判据层 | 向前 / 向后误差、conditioning ≠ stability | [1.2.6](ch01/sec12.md#sec-1.2.6) |
| 语言层 | 范数三公理与四公理、五个公式、等价与相容、定理 1.3.6 | [1.3](ch01/sec13.md) |

## 补充篇地图（几何与谱）

| 层 | 内容 | 位置 |
|:--|:--|:--|
| 几何基础 | 内积公理、加权内积、正交与标准正交基、正交矩阵十条件 | [2.1](ch02/sec21.md) |
| 结构层 | 四个基本子空间的正交补关系、正交分解、投影矩阵、最小二乘 | [2.2](ch02/sec22.md) |
| 算法层 | Gram–Schmidt、修正 Gram–Schmidt、Householder、Givens；QR 分解 | [2.3](ch02/sec23.md) |
| 敏感层 | $\mathrm{cond}(A)$、右端 / 系数扰动界、Hilbert 矩阵、残差 ≠ 误差 | [2.4](ch02/sec24.md) |
| 谱层 | 特征值、谱半径、$\rho\le\lVert\cdot\rVert$、Gerschgorin、Rayleigh 商、Courant–Fischer | [2.5](ch02/sec25.md) |
| 统一层 | SVD 两种几何读法、与四个基本子空间的关系、Eckart–Young、数值秩、伪逆、PCA | [2.6](ch02/sec26.md) |
| 实证层 | 四种 QR 方法的正交性退化实测、条件数与有效数字、低秩压缩 | [2.7](ch02/sec27.md) |

::: method 三件最有用的「随身行李」
1. **有效数字与相对误差的换算**：$\varepsilon_{\mathrm r}\le\tfrac{1}{2a_1}\times10^{1-n}$，反之 $\varepsilon_{\mathrm r}\le\tfrac{1}{2(a_1+1)}\times10^{1-n}\Rightarrow$ 至少 $n$ 位（[1.2.2](ch01/sec12.md#sec-1.2.2)）。
2. **算法设计四原则**：稳定性看方向、防吞噬、防相消、防小除数（[1.2.4](ch01/sec12.md#sec-1.2.4)）。
3. **两条判据两把尺**：$\lVert A\rVert\lt1\Rightarrow I\pm A$ 可逆且 Neumann 级数收敛（[1.3.5](ch01/sec13.md#sec-1.3.5)）；$\mathrm{cond}(A)=\sigma_1/\sigma_r$ 决定最多能保住几位有效数字（[2.4](ch02/sec24.md)）。
:::

## 课堂精编对照（2026 秋·庞刚《数值分析 I》）

下表给出课堂进度与正文的对应关系。第 1–3 讲覆盖第一章全部内容；从第 3 讲起进入**第 2 章 线性方程组的解法**（原书第 2 章，目前由讲座页承载）；第 6 讲末尾开启第 3 章特征值问题；第 7 讲给出幂法 / 反幂法与第 4 章非线性方程的引入。

| 讲次 | 主题 | 对应正文 | 老师补充（正文暂未展开） |
|:--|:--|:--|:--|
| [第 1 讲](lectures/lec01.md) | 引例、误差分类、误差限运算 | [1.1](ch01/sec11.md)、[1.2.1–1.2.3](ch01/sec12.md) | 三个板书例题：$\int_0^1 e^{-x^2}dx$ 的级数积分、$\int_5^\infty e^{-x^2}dx$ 的渐近展开、递推 $I_n$ 的稳定性 |
| [第 2 讲](lectures/lec02.md) | 有效数字、精度技巧、范数引入 | [1.2.2](ch01/sec12.md#sec-1.2.2)、[1.2.4](ch01/sec12.md#sec-1.2.4)、[1.3.1](ch01/sec13.md#sec-1.3.1)、[1.3.3](ch01/sec13.md#sec-1.3.3) | 从属范数的几何直观（球面 / 八面体 / 盒子）、相容关系的完整板书证明 |
| [第 3 讲](lectures/lec03.md) | 矩阵范数计算、可逆判据、高斯消去 | [1.3.4](ch01/sec13.md#sec-1.3.4)、[1.3.5](ch01/sec13.md#sec-1.3.5) + 课堂精编 | $\lVert A\rVert_1$ 最大列和公式的逐步推导、$[[0,1],[1,0]]$ 的反例、列主元消去 |
| [第 4 讲](lectures/lec04.md) | LU 分解、追赶法、迭代法引论 | [第 2 章导览](course/ch02/overview.md)（原书 2.2、2.4.1） | Doolittle 逐圈求解 + 完整例题、三对角 $O(n)$ 分解、$\|G\|<1$ 收敛定理 |
| [第 5 讲](lectures/lec05.md) | 收敛理论、误差估计、Jacobi / Gauss–Seidel | [第 2 章导览](course/ch02/overview.md)（原书 2.4.1–2.4.3） | $\rho(G)<1$ 充要条件的对角化解耦自证（原书证明从略）、先验 / 后验误差估计 |
| [第 6 讲](lectures/lec06.md) | SOR、收敛定理、特征值问题开篇 | [第 2 章导览](course/ch02/overview.md)（原书 2.4.4）+ [第 3 章导览](course/ch03/overview.md) | 必要条件 $\omega\in(0,2)$、「对角占优 ⟹ 可逆」引理、$0<\omega\le1$ 与对称正定 $0<\omega<2$ 两大收敛定理、薛定谔方程动机 |
| [第 7 讲](lectures/lec07.md) | 幂法、反幂法与位移、非线性方程开篇 | [第 3 章导览](course/ch03/overview.md)（原书第 3 章）+ [第 4 章导览](course/ch04/overview.md)（原书第 4 章引入）+ [补充篇 2.5](ch02/sec25.md)（Rayleigh 商） | $\lambda_1$ 必为实数的共轭反证、规范化幂法的回推推导、$y_k^{\mathrm T}Ay_k\to\lambda_1$ 的 2-范数条件、$Au_{k+1}=y_k$ 的实际写法、位移 $A-pI$、二分法与不动点存在性证明 |

::: note[skip] 直接法与迭代法的去向
第 3–7 讲的高斯消去、LU 分解、追赶法、迭代法与幂法属于**本书第 2、3 章**（与原书同号），目前由讲座页承载（详见[课堂精编导览](lectures/overview.md)）。第 6 讲末尾的特征值问题开篇（模最大特征值、幂法预告）指向原书第 3 章，第 7 讲已把幂法展开为完整算法；非线性方程（原书第 4 章）在第 7 讲只讲到不动点迭代与二分法，Newton 法等留待后续讲次展开。
:::
