# 延伸阅读

本页把第一章 + 补充篇内容向外延伸，给出**经典参考书**与**深入方向**。原则：只列真实存在、可查证的资料；每条都标注「读它的什么」与「何时读」。**不编造文献。**

::: note 关于引用
下列书目都是数值分析领域公认的经典；出版社与版次以实际出版物为准，本教程不逐一核对版次细节。**建议先读原书（颜庆津《数值分析》第 4 版）的对应章节，再按本页指引向外扩展。**
:::

## 一、本教程的直接对标与配套

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **颜庆津《数值分析》（第 4 版）**，北京航空航天大学出版社 | 第 1 章（本教程第一章的对标）、1.3 节（补充篇的出发点）、第 2 章 2.1–2.4（方程组与迭代法）、第 3 章（特征值与 QR 方法） | **全程**；尤其原书第三章 3.3 的 QR 方法，是本教程 [2.3](supplement/sec23.md) 的直接后续 |
| **李庆扬、王能超、易大义《数值分析》** | 误差分析、范数、条件数的中文标准表述 | 想换一本中文教材对照时 |
| **Burden & Faires, _Numerical Analysis_**（英文影印版） | 引例与习题（课堂精编[第 1 讲](lectures/lec01.md)的波纹瓦弧长例即出自该书）、算法表述与图示 | 跟课堂精编复习时对照阅读——庞刚老师在课上特别推荐（讲解详细、界面友好） |

::: note 跟课堂的同学
正在修读 2026 秋《数值分析 I》的同学，优先把[课堂精编](lectures/overview.md)八讲（第 1–7、9 讲）与正文对应小节交叉读；老师课上推荐的书目（Burden & Faires、王能超《数值分析简明教程》、Heath《科学计算导论》等）不用另作安排，读完对应正文小节后按需选读即可。
:::

## 二、数值线性代数（补充篇的主要延伸方向）

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **Golub & Van Loan, _Matrix Computations_**（第 4 版，Johns Hopkins） | 第 2 章（浮点误差）、第 3 章（QR 分解、最小二乘）、第 5 章（对称特征值）、第 8 章（对称特征值问题的算法）、第 2.4 节（SVD） | 想系统深入 QR / SVD / 特征值算法时，它是**标准参考**——**本教程 [2.3](supplement/sec23.md)、[2.5](supplement/sec25.md)、[2.6](supplement/sec26.md) 的每一节都能在这里找到更充分的展开** |
| **Trefethen & Bau, _Numerical Linear Algebra_**（SIAM） | 第 1–5 讲（SVD 与正交性）、第 11–12 讲（最小二乘与 QR）、第 15–16 讲（条件数）、第 24–25 讲（特征值）、第 26–27 讲（QR 算法） | **最适合作为本教程补充篇的「第二本书」**：写作风格与本教程一致——几何直觉 + 矩阵图，篇幅短、讲得透。**强烈推荐** |
| **Higham, _Accuracy and Stability of Numerical Algorithms_**（第 2 版，SIAM） | 第 2 章（浮点算术）、第 7 章（范数）、第 19 章（Gram–Schmidt）、第 20 章（最小二乘）、第 21 章（欠定系统） | 想知道**误差分析的量级结论是怎么来的**（本教程 [2.3.3](supplement/sec23.md#sup-2.3.3) 的 $\mathrm{cond}^2u$ / $\mathrm{cond}\,u$ 结论就出自该书第 19 章） |
| **Stewart, _Matrix Algorithms, Vol. I: Basic Decompositions_**（SIAM） | 第 1–2 章（矩阵分解的框架与扰动理论）、第 3 章（SVD） | 想从「扰动理论」这一更抽象的层面上理解矩阵分解 |
| **Horn & Johnson, _Matrix Analysis_** / **_Topics in Matrix Analysis_**（Cambridge） | 谱定理、奇异值、von Neumann 迹不等式、扰动理论 | 想补**纯数学**侧的严谨证明（本教程 [@ex-sup-2.6.4] 的迹不等式，完整证明在 _Topics_ §3.3） |

## 三、应用与数据科学（补充篇 [2.6](supplement/sec26.md) 的延伸）

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **Strang, _Linear Algebra and Its Applications_** | 四个基本子空间、投影、最小二乘 | 想补「线性代数基础」的几何直观（Strang 的四个子空间图是本教程 [2.2](supplement/sec22.md) 的图像来源） |
| **Hastie, Tibshirani & Friedman, _The Elements of Statistical Learning_**（Springer） | 第 3.4 节（主成分回归）、第 14 章（无监督学习：PCA 与聚类） | 想从统计角度看 SVD 与 PCA（见本教程 [2.6.6](supplement/sec26.md#sup-2.6.6)） |
| **Eckart & Young (1936), "The approximation of one matrix by another of lower rank"**, _Psychometrika_ | Eckart–Young 定理原文 | 想追溯 [@thm-sup-2.6.4] 的历史出处 |
| **Trefethen & Embree, _Spectra and Pseudospectra_**（Princeton） | 第 1、2、4 章 | 想深入理解**非正规矩阵**与「瞬态增长」（本教程 [@ex-sup-2.5.6] 提到的伪谱） |
| **Kalman (1996), "When is a linear system stable?"** 或同类文献 | 非正规性对稳定性判断的影响 | 想知道 [例 2.5.6](supplement/sec25.md#sup-2.5.6) 的现象在控制理论中会带来什么后果 |

## 四、工程实现（想动手写库 / 读懂 LAPACK）

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **LAPACK Users' Guide** 与 **BLAS 技术报告** | `geqrf`（Householder QR）、`geqp3`（列主元 QR）、`gesdd`/`gesvd`（SVD）、`gecon`（条件数估计）的接口与算法 | 想理解 `np.linalg.qr` / `np.linalg.svd` / `np.linalg.cond` **背后的实现**（本教程 [2.3.5](supplement/sec23.md#sup-2.3.5)、[2.4.5](supplement/sec24.md#sup-2.4.5) 提到过这些 LAPACK 例程的名字） |
| **Muller 等, _Handbook of Floating-Point Arithmetic_**（Birkhäuser） | 第 4 章（Sterbenz 引理、舍入误差） | 想读第一章 [@lem-1.2.1]（Sterbenz 引理）的完整证明 |
| **IEEE 754-2019 标准文本** | 浮点格式、舍入模式、异常 | 想核实第一章 [1.2.5](ch01/sec12.md#sec-1.2.5) 的细节 |
| **NumPy / SciPy 官方文档**（`numpy.linalg`、`scipy.linalg`） | 函数签名、`rcond` 参数、`assume_a` 参数 | **动手做实验时必查**——本教程 [2.7](supplement/sec27.md) 的全部代码只用 `numpy` |

## 五、想验证本教程的每个结论

本教程的**全部数值结论都可以自己复现**。推荐的复现路径如下：

1. **第一章 + 补充篇中每一处「实测输出」的代码都在正文里**（含随机种子），逐段复制即可；
2. **对每组实验，先写理论预期（用公式算），再跑代码对照**——这正是 [2.7](supplement/sec27.md) 的「报告要求」；
3. **把 [2.8.2](supplement/sec28.md#sup-2.8.2) 的八个陷阱逐个亲手踩一遍**：每个都给了反例代码与实测数字，亲自重现比读十遍更有用；
4. **想更系统地训练**：[习题集](supplement/exercises.md) 的 C 组编程题（每题带验收标准）与 D 组开放建模题（选一个真实数据集做完整流程）。

::: method 一份推荐的最小阅读清单（按时间排序）

**如果只有两周，按这个顺序读：**

1. **Trefethen & Bau 第 1–5 讲**（SVD 与正交性）——建立补充篇的几何直觉，约 2 小时；
2. **本教程 [2.1](supplement/sec21.md)–[2.3](supplement/sec23.md)**——把直觉落到公式与算法，配合复现实验一；
3. **Trefethen & Bau 第 11–16 讲**（最小二乘、QR、条件数）——与你亲手实现的 QR 相互印证，约 2 小时；
4. **本教程 [2.4](supplement/sec24.md)** + 复现实验二——把「能信几位」这件事彻底搞清楚；
5. **本教程 [2.5](supplement/sec25.md)–[2.6](supplement/sec26.md)** + 复现实验三——进入谱与 SVD；
6. **Golub & Van Loan 第 3、5、2.4 节**——想读算法细节时回查。

**读完后应该能做到：** 给定一个矩阵，说出它的 SVD 大概长什么样、条件数在哪个量级、哪些算法能用、哪些不能用——**这就是补充篇的「最低通关标准」。**
:::

::: note[skip] 关于「伪谱」与「非正规矩阵」的入门读物
想弄懂 [例 2.5.6](supplement/sec25.md#sup-2.5.6) 里的「瞬态增长」，**Trefethen & Embree 的 _Spectra and Pseudospectra_ 第 1 章是极好的入门**——前 20 页就能讲清为什么「特征值全在左半平面」还不足以判断稳定性。这是数值线性代数与动力系统、流体力学之间的一个重要交叉方向，也是理解「为什么 $\lVert A\rVert$ 比 $\rho(A)$ 更可靠」的深层原因。
:::
