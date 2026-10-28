# 学习目标

本清单把全书八个单元（第一章、课堂主线第 2–7 章、补充篇）的要求逐条写成可检验的「能……」目标：每条目标后括注认知层级（Bloom 分类），并在各单元末的自检表中对应到正文小节与习题。先修关系上，**K 组目标互不依赖，S 组依赖对应的 K 组，A 组依赖对应的 K、S 组**。

> **编号约定**：目标编号与单元一一对应——K1/S1/A1 为第一章；K2–K7 / S2–S7 / A2–A7 为课堂主线第 2–7 章（编号与该章章号一致）；K8/S8/A8 为补充篇（数值线性代数工具箱，本书第 8 个单元）。本页完整展开第一章与补充篇的逐条目标；第 2–7 章的逐条目标写在各章末的自检表里，编号区间如下：
>
> | 单元 | K · 知识 | S · 技能 | A · 素养 | 逐条自检表 |
> |:--|:--|:--|:--|:--|
> | 第 1 章 · 绪论 | K1.1–K1.7 | S1.1–S1.6 | A1.1–A1.4 | [第一章自检表](ch01/checklist.md)（完整表述见本页上文） |
> | 第 2 章 · 线性方程组的解法 | K2.1–K2.8 | S2.1–S2.5 | A2.1–A2.3 | [第 2 章自检表](course/ch02/checklist.md) |
> | 第 3 章 · 矩阵特征值与特征向量的计算 | K3.1–K3.7 | S3.1–S3.6 | A3.1–A3.3 | [第 3 章自检表](course/ch03/checklist.md) |
> | 第 4 章 · 非线性方程与非线性方程组的迭代解法 | K4.1–K4.7 | S4.1–S4.6 | A4.1–A4.3 | [第 4 章自检表](course/ch04/checklist.md) |
> | 第 5 章 · 插值与逼近 | K5.1–K5.12 | S5.1–S5.6 | A5.1–A5.4 | [第 5 章自检表](course/ch05/checklist.md) |
> | 第 6 章 · 数值积分 | K6.1–K6.10 | S6.1–S6.5 | A6.1–A6.3 | [第 6 章自检表](course/ch06/checklist.md) |
> | 第 7 章 · 常微分方程初值问题的数值解法 | K7.1–K7.8 | S7.1–S7.5 | A7.1–A7.3 | [第 7 章自检表](course/ch07/checklist.md) |
> | 补充篇 · 数值线性代数工具箱 | K8.1–K8.6 | S8.1–S8.6 | A8.1–A8.3 | [补充篇自检表](supplement/checklist.md)（完整表述见本页下文） |
>
> 各章导览的「本章学习目标」与各讲页首的「对应学习目标」均按这套编号引用；讲次只覆盖部分章节时，页首注明「属第 N 章目标」。

## 第一章 · 绪论

### K · 知识目标（概念与理论）

<ul class="objlist">
<li><span class="obj-id">K1.1</span>能按来源区分模型误差、观测误差、截断误差、舍入误差，对给定计算情境指出主导误差类型并说明理由。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.2</span>能写出绝对误差 $e$、误差限 $\varepsilon$、相对误差 $e_{\mathrm r}$ 的定义及关系式 $x=a\pm\varepsilon$，并解释「相对误差才能刻画精确程度」的原因。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.3</span>能陈述有效数字的定义（规格化形式 $\pm 0.a_1a_2\cdots\times10^m$ 与 $\varepsilon(a)=\tfrac12\times10^{m-n}$），说明「四舍五入近似值的误差限是末位半个单位」的依据，并解释 $2.14$ 与 $2.1400$ 的区别。<span class="obj-lv">理解</span></li>
<li><span class="obj-id">K1.4</span>能推导（而不只是写出）一元、高阶与多元的函数求值误差估计式，以及四则运算的 $\varepsilon$ 与 $\varepsilon_{\mathrm r}$ 公式，并指出每步推导用了什么近似。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K1.5</span>能陈述数值稳定性的含义（控制舍入误差的传播），并区分「问题病态」与「算法不稳定」这两个概念。<span class="obj-lv">理解</span></li>
<li><span class="obj-id">K1.6</span>能陈述向量范数的三条公理、矩阵范数的四条公理，以及从属（算子）范数的定义与相容性，并写出 $\lVert\boldsymbol{x}\rVert_p$ 与 $\lVert A\rVert_{1,2,\infty,F}$ 的计算公式。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K1.7</span>能陈述范数等价定理与定理 1.3.6（$\lVert A\rVert\lt1\Rightarrow I\pm A$ 非奇异及其逆的界），并说明这两条定理在算法判据中的用途。<span class="obj-lv">理解</span></li>
</ul>

### S · 技能目标（判定、计算与实验）

<ul class="objlist">
<li><span class="obj-id">S1.1</span>能在两分钟内判定给定近似值的有效数字位数，包括 $\varepsilon$ 与末位不匹配（如 $0.86\times10^5$、$\varepsilon=0.005$）从而「没有有效数字」的情形。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S1.2</span>能对给定算式计算 $\varepsilon(u)$、$\varepsilon_{\mathrm r}(u)$ 并确定结果可靠的有效数字位数（如原书例 4、例 5 型题）。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S1.3</span>能把相近数相减、小除数、大数吃小数型的算式改写为等价的稳定形式：有理化、因式分解、韦达公式、先小后大求和。<span class="obj-lv">应用 / 创造</span></li>
<li><span class="obj-id">S1.4</span>能数出两种多项式求值算法的乘法次数并用 $O$ 记号表示；能对线性递推算出舍入误差的逐步放大（或缩小）因子。<span class="obj-lv">分析</span></li>
<li><span class="obj-id">S1.5</span>能用 Python 复现灾难性抵消、递推不稳定、求和次序三组实验，报告实测误差（含增长因子），并用本章概念解释。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S1.6</span>能计算 $\lVert\boldsymbol{x}\rVert_{1,2,\infty}$ 与 $\lVert A\rVert_{1,2,\infty,F}$（含 $\lVert A\rVert_2$ 经 $A^{\mathrm T}A$ 特征值的完整流程），并用数值验证相容性与等价不等式。<span class="obj-lv">应用</span></li>
</ul>

### A · 素养目标（诊断、批判与迁移）

<ul class="objlist">
<li><span class="obj-id">A1.1</span>能诊断给定数值代码中的隐患（相近数相减、小除数、求和次序、精度选型），量化每处隐患的后果，并给出改写方案。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A1.2</span>能批判性地解读计算结果：说明为什么「打印出的每一位数字并非都可靠」，并用有效数字与相对误差的语言论证可靠位数。<span class="obj-lv">评价</span></li>
<li><span class="obj-id">A1.3</span>能选择恰当的范数与判据解决一个具体问题（停机准则、误差报告、稳定性判断），并说明换一种范数后结论是否改变。<span class="obj-lv">评价 / 创造</span></li>
<li><span class="obj-id">A1.4</span>能把四类误差、误差传播规律与条件数组织成真实系统的完整误差预算（如 GPS 定位的逐环节误差分解），并指出其中哪一环是主要矛盾。<span class="obj-lv">分析 / 评价</span></li>
</ul>

## 补充篇 · 数值线性代数工具箱

先修链条：K8.x 依赖第一章的 K1.6、K1.7（范数与条件数）；S8.x 依赖对应的 K8.x；A8.x 依赖对应的 K8、S8 组。

### K · 知识目标（概念与理论）

<ul class="objlist">
<li><span class="obj-id">K8.1</span>能陈述内积的四条公理与由内积诱导的范数，区分一般内积与 Euclid 内积（举一个加权内积的例子），并陈述正交、标准正交基、正交矩阵的定义，以及正交矩阵的等价刻画（至少六条）。<span class="obj-lv">记忆 / 理解</span></li>
<li><span class="obj-id">K8.2</span>能陈述四个基本子空间（列空间、零空间、行空间、左零空间）的定义与两对正交补关系（$N(A)\perp C(A^{\mathrm T})$、$N(A^{\mathrm T})\perp C(A)$），说明秩定理 $\operatorname{rank}A+\dim N(A)=n$，并写出正交投影矩阵 $P=A(A^{\mathrm T}A)^{-1}A^{\mathrm T}$ 的三条性质（对称、幂等、$\lVert P\rVert_2=1$）。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K8.3</span>能陈述 Gram–Schmidt 正交化与 Householder 反射的构造原理，说明 QR 分解 $A=QR$ 的存在唯一性条件，并比较经典 Gram–Schmidt、修正 Gram–Schmidt、Householder、Givens 四种方法在浮点下的正交性损失量级（$O(\mathrm{cond}^2u)$ 与 $O(\mathrm{cond}\,u)$）。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K8.4</span>能陈述条件数 $\mathrm{cond}(A)=\lVert A\rVert\lVert A^{-1}\rVert$ 的定义，推导右端扰动界与系数扰动界，并解释「残差小 ≠ 误差小」与「系数的微小扰动可被放大 cond 倍」。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K8.5</span>能陈述特征值、谱半径、Gerschgorin 圆盘定理、Rayleigh 商与 Courant–Fischer 极小极大原理，说明「谱半径 ≤ 任一相容范数」以及「非正规矩阵的特征值对扰动可以开方敏感」的原因。<span class="obj-lv">理解 / 分析</span></li>
<li><span class="obj-id">K8.6</span>能陈述 SVD $A=U\Sigma V^{\mathrm T}$ 的两种几何读法（旋转–拉伸–旋转、两组正交基的配对），说明 $\lVert A\rVert_2=\sigma_1$、$\mathrm{cond}_2(A)=\sigma_1/\sigma_r$、Eckart–Young 定理与数值秩的定义。<span class="obj-lv">理解 / 评价</span></li>
</ul>

### S · 技能目标（判定、计算与实验）

<ul class="objlist">
<li><span class="obj-id">S8.1</span>能对给定向量组手工执行 Gram–Schmidt 正交化（含三向量情形），求出对应的 $Q$ 与 $R$，并判断何时出现零列（秩亏）、该如何截断。<span class="obj-lv">应用</span></li>
<li><span class="obj-id">S8.2</span>能对一个 $3\times3$ 或 $4\times3$ 矩阵手算一个 Householder 反射（写出 $\boldsymbol v$、$H=I-2\boldsymbol v\boldsymbol v^{\mathrm T}/\boldsymbol v^{\mathrm T}\boldsymbol v$ 与 $HA$），并说明它把哪一列化成了 $\pm\lVert\cdot\rVert_2\boldsymbol e_1$。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S8.3</span>能用 QR 分解求最小二乘解（含 $A$ 列满秩与秩亏两种情形），比较正态方程与 QR 的误差量级，并给出选型理由。<span class="obj-lv">应用 / 评价</span></li>
<li><span class="obj-id">S8.4</span>能对给定矩阵估算 $\mathrm{cond}_2$ 或 $\mathrm{cond}_\infty$，据此预测求解线性方程组时有效数字的损失位数 $k\approx\log_{10}\mathrm{cond}$，并用 Hilbert 矩阵的数值实验验证预测。<span class="obj-lv">应用 / 评价</span></li>
<li><span class="obj-id">S8.5</span>能用 Gerschgorin 圆盘给出特征值的包含区间，用幂法与 Rayleigh 商估算主特征值并报告实测收敛比，解释幂法为何以 $\lvert\lambda_2/\lambda_1\rvert$ 的速度收敛。<span class="obj-lv">应用 / 分析</span></li>
<li><span class="obj-id">S8.6</span>能用 SVD 计算数值秩、条件数与伪逆，做秩 $k$ 截断并与理论下界 $\lVert A-A_k\rVert_2=\sigma_{k+1}$ 对照，用真实矩阵完成一次低秩压缩（报告压缩比与 $\lVert E\rVert_F/\lVert A\rVert_F$）。<span class="obj-lv">应用 / 创造</span></li>
</ul>

### A · 素养目标（诊断、批判与迁移）

<ul class="objlist">
<li><span class="obj-id">A8.1</span>能诊断一个线性方程组问题的病态来源（矩阵结构、尺度差异、条件数），区分「问题病态」与「算法不稳定」，并给出至少两种改进策略（重述问题 / 正则化 / 提高精度 / 选稳定算法）。<span class="obj-lv">分析 / 评价</span></li>
<li><span class="obj-id">A8.2</span>能批判性地评估数值线性代数库的返回值：判断残差范数能否作为误差的可靠指标，识别「数值秩」判定对阈值的依赖，说明伪逆截断参数的选择依据。<span class="obj-lv">评价</span></li>
<li><span class="obj-id">A8.3</span>能针对一个真实数据任务（低秩压缩 / 主成分 / 病态拟合）选择合适的方法（QR / SVD / 正则化）并说明理由，量化方法与数据的匹配程度及其失效边界。<span class="obj-lv">评价 / 创造</span></li>
</ul>

::: note 与考核的对应

K 组目标对应各章习题中 A 组与 B 组的概念题、证明题；S 组目标对应 B、C 组的计算与编程题；A 组目标对应 D 组的开放建模题与期末综合题中的分析小题。补充篇的 S8.4–S8.6 与 A8.1–A8.3 则直接对应 [2.7 数值实验](supplement/sec27.md) 的三组实验报告。

:::
