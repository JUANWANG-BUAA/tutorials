# 延伸阅读

读到一个概念仍有疑问时，先沿本页“读什么”定位主题，再判断是否需要换一本书。本页以第一章与补充篇为重点，也保留七章主线的中文参考资料；它是选读索引，不要求先读完外部教材才能继续正文。

::: note 关于引用
外部教材的符号、归一化和章节安排可能不同；查读时同时核对主题名称与手头版次。颜庆津《数值分析》第 4 版用于对照课程内容与来源，但本教程正文应可独立阅读。下面已核对的章节入口给出目录链接，其余按主题查索引，不用未经确认的精确章节号导航。
:::

## 一、本教程的直接对标与配套

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **颜庆津《数值分析》（第 4 版）**，北京航空航天大学出版社 | 第 1 章（本教程第一章的对标）、1.3 节（补充篇的出发点）、第 2 章 2.1–2.4（方程组与迭代法）、第 3 章（特征值与 QR 方法） | **全程**；尤其原书第三章 3.3 的 QR 方法，是本教程 [2.3](supplement/sec23.md) 的直接后续 |
| **李庆扬、王能超、易大义《数值分析》** | 误差分析、范数、条件数的中文标准表述 | 想换一本中文教材对照时 |
| **Burden & Faires, _Numerical Analysis_**（英文影印版） | 引例与习题、算法表述与图示；既有[第 1 讲整理稿](lectures/lec01.md)将波纹瓦弧长例与该书联系起来，并记录了教师推荐，但原录音待核 | 希望对照另一套引例与算法讲解时；不要把整理稿中的推荐措辞当作逐字引语 |

::: note 跟课堂的同学
正在修读 2026 秋《数值分析 I》的同学，可把[课堂来源记录](lectures/overview.md)与对应正文交叉阅读；第 1–7、9 讲可作初步入口，不代表全课程范围。旧阅读清单还列有王能超《数值分析简明教程》、Heath《科学计算导论》，可按主题选读；现有本页未给出这两项“教师推荐”的可定位证据，因此不把书目来源改写为课堂发言。第 1–5、7 讲原录音待核，其余现有 ASR 未经连续听校，引用时应保留这一证据边界。
:::

## 二、数值线性代数（补充篇的主要延伸方向）

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **Golub & Van Loan, _Matrix Computations_**（第 4 版，Johns Hopkins） | 第 2 章矩阵分析与 SVD 基础、第 5 章正交化与最小二乘、第 8 章对称特征值；浮点分析及一般线性方程可再查第 2、3 章相关小节。以[出版社目录](https://www.press.jhu.edu/books/title/10678/matrix-computations)为入口 | 深入本教程 [2.3](supplement/sec23.md)、[2.5](supplement/sec25.md)、[2.6](supplement/sec26.md)，需要算法细节时按主题回查 |
| **Trefethen & Bau, _Numerical Linear Algebra_**（SIAM） | 第 1–5 讲建立矩阵与 SVD 几何直觉；第 6–11 讲投影、QR 与最小二乘；第 12–19 讲条件数、浮点与稳定性；特征值与 QR 迭代按[出版社目录](https://epubs.siam.org/doi/pdf/10.1137/1.9780898719574.fm)查读 | 作为补充篇的第二本书：先读几何部分，写过一次 QR 后再读稳定性分析 |
| **Higham, _Accuracy and Stability of Numerical Algorithms_**（第 2 版，SIAM） | 按目录查浮点算术、范数、线性系统扰动、QR 与 Gram–Schmidt、最小二乘及欠定系统；QR / Gram–Schmidt 重点查第 19 章 | 已会实现算法，想进一步理解本教程 [2.3.3](supplement/sec23.md#sup-2.3.3) 中 $\mathrm{cond}^2u$ / $\mathrm{cond}\,u$ 的假设与量级时 |
| **Stewart, _Matrix Algorithms, Vol. I: Basic Decompositions_**（SIAM） | 按主题索引查矩阵分解、扰动理论及 SVD，并核对所用卷册的目录 | 已熟悉 QR / SVD，想从分解框架与扰动分析重新整理知识时 |
| **Horn & Johnson, _Matrix Analysis_** / **_Topics in Matrix Analysis_**（Cambridge） | 谱定理、奇异值、von Neumann 迹不等式、扰动理论 | 想补**纯数学**侧的严谨证明（本教程 [@ex-sup-2.6.4] 的迹不等式，完整证明在 _Topics_ §3.3） |

## 三、应用与数据科学（补充篇 [2.6](supplement/sec26.md) 的延伸）

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **Strang, _Linear Algebra and Its Applications_** | 四个基本子空间、投影、最小二乘 | 想补「线性代数基础」的几何直观（Strang 的四个子空间图是本教程 [2.2](supplement/sec22.md) 的图像来源） |
| **Hastie, Tibshirani & Friedman, _The Elements of Statistical Learning_**（Springer） | 第 3.4 节（主成分回归）、第 14 章（无监督学习：PCA 与聚类） | 想从统计角度看 SVD 与 PCA（见本教程 [2.6.6](supplement/sec26.md#sup-2.6.6)） |
| **Eckart & Young (1936), "The approximation of one matrix by another of lower rank"**, _Psychometrika_ | Eckart–Young 定理原文 | 想追溯 [@thm-sup-2.6.4] 的历史出处 |
| **Trefethen & Embree, _Spectra and Pseudospectra_**（Princeton） | 第 1、2、4 章 | 想深入理解**非正规矩阵**与「瞬态增长」（本教程 [@ex-sup-2.5.6] 提到的伪谱） |
| **控制理论中的非正规性与瞬态增长资料** | 沿上一行 Trefethen & Embree 的相关主题继续查读；旧书目线索“Kalman (1996), _When is a linear system stable?_”未检索到可确认的出版记录，不作为可引用文献，也不应与 Kalman 的 [_When Is a Linear Control System Optimal?_（1964）](https://ndlsearch.ndl.go.jp/books/R100000136-I1572824499309216512)混同 | 想将 [例 2.5.6](supplement/sec25.md#sup-2.5.6) 的现象接到控制问题时，先分清渐近稳定、有界响应与短时放大 |

## 四、工程实现（想动手写库 / 读懂 LAPACK）

| 资料 | 读什么 | 何时读 |
|:--|:--|:--|
| **LAPACK Users' Guide** 与 **BLAS 技术报告** | `geqrf`（Householder QR）、`geqp3`（列主元 QR）、`gesdd`/`gesvd`（SVD）、`gecon`（条件数估计）的接口与算法 | 想理解 `np.linalg.qr` / `np.linalg.svd` / `np.linalg.cond` **背后的实现**（本教程 [2.3.5](supplement/sec23.md#sup-2.3.5)、[2.4.5](supplement/sec24.md#sup-2.4.5) 提到过这些 LAPACK 例程的名字） |
| **Muller 等, _Handbook of Floating-Point Arithmetic_**（Birkhäuser） | 按所用版次的索引查 Sterbenz 引理、正确舍入与误差模型 | 想读第一章 [@lem-1.2.1] 的完整证明，并核对下溢与格式假设时 |
| **IEEE 754-2019 标准文本** | 浮点格式、舍入模式、异常 | 想核实第一章 [1.2.5](ch01/sec12.md#sec-1.2.5) 的细节 |
| **NumPy / SciPy 官方文档**（`numpy.linalg`、`scipy.linalg`） | 函数签名、`rcond` 参数、`assume_a` 参数 | **动手做实验时必查**——本教程 [2.7](supplement/sec27.md) 的全部代码只用 `numpy` |

## 五、想验证本教程的每个结论

复现实验时要检验数学预期，而不是要求每个浮点末位都与书中相同。推荐路径如下：

1. 从第一章与补充篇正文的实测代码入手，记录数据生成方式、随机种子、精度、库版本与后端；若结果不同，先核对这些条件；
2. **对每组实验，先写理论预期（用公式算），再跑代码对照**——这正是 [2.7](supplement/sec27.md) 的「报告要求」；
3. **把 [2.8.2](supplement/sec28.md#sup-2.8.2) 的八个陷阱逐个亲手踩一遍**：每个都给了反例代码与实测数字，亲自重现比读十遍更有用；
4. **想更系统地训练**：[习题集](supplement/exercises.md) 的 C 组编程题（每题带验收标准）与 D 组开放建模题（选一个真实数据集做完整流程）。

::: method 一份推荐的最小阅读清单（按时间排序）

**如果只有两周，按这个顺序读：**

1. **Trefethen & Bau 第 1–5 讲**（矩阵与 SVD）——建立补充篇的几何直觉，不要求记住尚未学到的全部证明；
2. **本教程 [2.1](supplement/sec21.md)–[2.3](supplement/sec23.md)**——把直觉落到公式与算法，配合复现实验一；
3. **Trefethen & Bau 第 6–11 讲及第 12–19 讲中对应主题**——用投影、QR、条件数与稳定性分析检查自己的实现；
4. **本教程 [2.4](supplement/sec24.md)** + 复现实验二——把「能信几位」这件事彻底搞清楚；
5. **本教程 [2.5](supplement/sec25.md)–[2.6](supplement/sec26.md)** + 复现实验三——进入谱与 SVD；
6. **Golub & Van Loan 第 2、5、8 章中的对应主题**——从 SVD 基础、QR / 最小二乘与对称特征值算法中按需回查，不要求整章连读。

**读完后应该能做到：** 给定一个矩阵，说出它的 SVD 大概长什么样、条件数在哪个量级、哪些算法能用、哪些不能用——**这就是补充篇的「最低通关标准」。**
:::

::: note[skip] 关于「伪谱」与「非正规矩阵」的入门读物
想弄懂 [例 2.5.6](supplement/sec25.md#sup-2.5.6) 的瞬态增长，可先读 Trefethen & Embree 的 _Spectra and Pseudospectra_ 第 1 章。对连续系统 $y'=Ay$，特征值全在左半平面保证有限维系统的渐近衰减，但非正规矩阵仍可能在短时放大扰动；对离散迭代则看谱半径是否小于 1。范数给出特定度量下的逐步界，谱刻画渐近行为，两者回答不同问题，不能笼统说哪一个“更可靠”。
:::
