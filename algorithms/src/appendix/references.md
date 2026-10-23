# 附录 C · 术语、工具与延伸阅读

<div class="chapter-index">
<div><span class="ci-label">本章回答</span><p>全书涉及的核心算法术语全景是什么？有哪些经过生产检验的开源工具库可直接复用？如何按研究方向继续进阶阅读？</p></div>
<div><span class="ci-label">读完你会</span><p>掌握一套标准无歧义的算法与因果推断中英文双解词汇表；熟悉 Python 与 C++ 领域的工业级计算与验证工具栈；获取经过筛选的高价值经典学术论文与著作清单。</p></div>
</div>

## C.1 核心术语中英文对照表

| 中文术语 | 英文术语 | 形式化一句话定义 |
|:--|:--|:--|
| **渐进紧确界** | Asymptotically Tight Bound ($\Theta$) | 既是渐进上界又是渐进下界的紧确复杂度描述 |
| **平摊分析** | Amortized Analysis | 在最坏输入序列下对连续操作求平均，给出单步的确定性性能保证 |
| **势能函数** | Potential Function ($\Phi$) | 将数据结构状态映射为非负实数的数学对象，用以补偿偶发高昂操作 |
| **交换论证** | Exchange Argument | 将任意最优解逐步替换调整为贪心解且目标值不恶化的贪心证明法 |
| **拟阵** | Matroid | 满足非空性、遗传性与增广公理的独立子集系统代数结构 |
| **最长公共子序列** | Longest Common Subsequence (LCS) | 两个序列中按原有相对次序出现且长度最长的子序列（不要求连续） |
| **NP 完全性** | NP-Completeness (NPC) | 属于 NP 且所有 NP 问题均可在多项式时间内归约至该问题的最难问题类 |
| **近似比** | Approximation Ratio ($\alpha$) | 近似算法输出解与该实例全局理论最优解的最坏情况比值上限 |
| **竞争比** | Competitive Ratio ($c$) | 在线算法未知未来的最坏表现与拥有全知后见之明的离线最优解的比值 |
| **最小可检测效应** | Minimum Detectable Effect (MDE) | 在预设显著性水平与功效下，实验能够可靠检测到的最小真实指标变化 |
| **方差缩减** | CUPED | 利用实验前协变量对实验期指标去偏，消除背景方差的因果降噪技术 |
| **样本比率不匹配** | Sample Ratio Mismatch (SRM) | A/B 测试中实际分流样本量与预设分配比例发生严重偏航的系统故障 |
| **双单侧等价性检验** | Two One-Sided Tests (TOST) | 严格证明两组均值差异完全落在不可容忍边界以内的统计检验方法 |
| **两阶段最小二乘** | Two-Stage Least Squares (2SLS) | 工具变量法中通过第一阶段外生投影解决第二阶段内生性的标准回归估计器 |
| **断点回归设计** | Regression Discontinuity (RD) | 利用规则阈值两侧个体分配近似随机的准实验因果推断方法 |
| **双重差分** | Difference-in-Differences (DID) | 基于平行趋势假设，通过比较处理组与对照组在政策前后的变化差值估计因果效应 |
| **局部敏感指纹** | Winnowing Algorithm | 通过滑动窗口选取局部极值哈希，保证公共子串匹配下界的代码查重算法 |

---

## C.2 核心工业工具与计算库推荐

### 1. 算法与优化求解器
- **SciPy (`scipy.optimize.milp`)**：基于 HiGHS 高性能求解器的混合整数线性规划（MILP）库，适用于第 7 章的精确基准求解。
- **NetworkX**：图论分析与复杂网络算法库，适用于快速验证图拓扑性质与连通分量。
- **PuLP / Pyomo**：Python 线性与整数规划建模工具，支持无缝对接 Gurobi、CPLEX、SCIP 与 GLPK。

### 2. 统计推断与 A/B 测试平台
- **Statsmodels (`statsmodels.api`)**：提供完整的 OLS、WLS、广义线性模型（GLM）与 2SLS 工具变量回归接口。
- **DoWhy / EconML**：微软研究院出品的因果推断与异质处理效应（CATE / Uplift）建模工具库。
- **CausalImpact**：基于结构时间序列的贝叶斯因果效应评估包。

### 3. 系统级沙箱与评测基础设施
- **libseccomp**：Linux 内核系统调用过滤官方 C 库（提供 Python 绑定 `pyseccomp`）。
- **cgroup v2 (`/sys/fs/cgroup`)**：现代 Linux 统一资源层级文件系统，精确限制 CPU 配额、物理内存与最大 PID 数量。

---

## C.3 延伸阅读经典书单

1. **[算法理论圣经]**：
   - Thomas H. Cormen, Charles E. Leiserson, Ronald L. Rivest, Clifford Stein, *Introduction to Algorithms* (CLRS), 4th Edition, MIT Press, 2022.
   - Tim Roughgarden, *Algorithms Illuminated* (Part 1-4), Soundlikefun Publishing, 2017–2020.
2. **[近似算法与在线计算]**：
   - Vijay V. Vazirani, *Approximation Algorithms*, Springer, 2001.
   - Allan Borodin, Ran El-Yaniv, *Online Computation and Competitive Analysis*, Cambridge University Press, 1998.
3. **[统计学习与模型选择]**：
   - 李航, 《统计学习方法（第 2 版）》, 清华大学出版社, 2019.
   - Trevor Hastie, Robert Tibshirani, Jerome Friedman, *The Elements of Statistical Learning* (ESL), 2nd Edition, Springer, 2009.
4. **[在线实验与因果推断]**：
   - Ron Kohavi, Diane Tang, Ya Xu, *Trustworthy Online Controlled Experiments: A Practical Guide to A/B Testing*, Cambridge University Press, 2020.
   - Joshua D. Angrist, Jörn-Steffen Pischke, *Mostly Harmless Econometrics: An Empiricist's Companion*, Princeton University Press, 2009.
   - Judea Pearl, *Causality: Models, Reasoning, and Inference*, 2nd Edition, Cambridge University Press, 2009.
