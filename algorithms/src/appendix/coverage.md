# 附录 A · 母本覆盖矩阵

本矩阵系统映射全书 14 章内容与各大权威母本经典教材之间的知识对应关系。

## A.1 母本教材清单

1. **[Roughgarden Vol 1]**：《算法详解 卷1：算法基础》（Tim Roughgarden）—— 渐进分析、Karatsuba 乘法、分治算法、主定理
2. **[Roughgarden Vol 2]**：《算法详解 卷2：图算法和数据结构》（Tim Roughgarden）—— BFS/DFS、拓扑排序、Kosaraju SCC、Dijkstra、堆、平衡树、散列表
3. **[Roughgarden Vol 3]**：《算法详解 卷3：贪心算法和动态规划》（Tim Roughgarden）—— 调度与交换论证、Huffman 编码、最小生成树、背包、LCS、Bellman-Ford
4. **[Roughgarden Vol 4]**：《算法详解 卷4：NP-Hard问题算法》（Tim Roughgarden）—— NP 完全性、规约链、顶点覆盖、度量 TSP、集合覆盖、近似算法
5. **[CLRS]**：《算法导论》（Introduction to Algorithms 4th ed., Cormen, Leiserson, Rivest, Stein）—— 算法全谱系理论奠基
6. **[李航]**：《统计学习方法（第2版）》（李航）—— 模型评估、泛化误差、交叉验证、正则化、特征选择
7. **[Kohavi]**：《Trustworthy Online Controlled Experiments》（Ron Kohavi, Diane Tang, Ya Xu）—— 工业级 A/B 测试金标准
8. **[Pearl]**：《Causality: Models, Reasoning, and Inference》（Judea Pearl）—— 因果图（DAG）、潜在结果、干预准则

---

## A.2 逐章母本映射表

| 章号 | 章节名称 | 核心知识主题 | 对应权威母本条目 | 覆盖深度 |
|:--|:--|:--|:--|:--|
| **第 1 章** | 渐进分析与实验验证 | 大 O/Ω/Θ 形式化定义、递归树展开、主定理、常数因子、缓存局部性与最坏输入 | [CLRS] Ch 3-4; [Roughgarden Vol 1] Ch 2 | 完整覆盖 |
| **第 2 章** | 分治算法与性能剖析 | Karatsuba 乘法、Strassen 矩阵乘法、小矩阵阈值调优、逆序对计数、QuickSelect、BFPRT | [Roughgarden Vol 1] Ch 1, 3; [CLRS] Ch 4, 9 | 完整覆盖 |
| **第 3 章** | 图算法与最坏情况构造 | CSR 紧凑存储、Kosaraju SCC 双遍 DFS、Dijkstra 堆优化、Bellman-Ford 负环检测、Floyd、Johnson 重赋权、网络流 | [Roughgarden Vol 2] Ch 1-3; [CLRS] Ch 22-26 | 完整覆盖 |
| **第 4 章** | 数据结构与平摊分析 | 动态数组加倍扩容、1/4 缩容杜绝抖动、平摊分析三法、全域散列抗碰撞、红黑树五大公理、并查集阿克曼反函数 | [CLRS] Ch 11, 13, 17, 21; [Roughgarden Vol 2] Ch 4-7 | 完整覆盖 |
| **第 5 章** | 贪心算法与反例构造 | 贪心选择性质、交换论证四步法、单机加权调度 Smith 规则、Huffman 最优前缀树、拟阵理论、加权区间反例 | [Roughgarden Vol 3] Ch 1-3; [CLRS] Ch 16 | 完整覆盖 |
| **第 6 章** | 动态规划与序列重建 | 0-1 背包空间一维倒序压缩、LCS 与编辑距离、决策路径反向重建、区间 DP 矩阵链乘法、最优 BST | [Roughgarden Vol 3] Ch 4-7; [CLRS] Ch 15 | 完整覆盖 |
| **第 7 章** | NP 难问题与近似算法 | P/NP/NPC 定义、多项式规约链、顶点覆盖 2-近似、度量 TSP 1.5-近似（Christofides）、集合覆盖调和级数对数界、LP 松弛 | [Roughgarden Vol 4] 全卷; [CLRS] Ch 34-35 | 完整覆盖 |
| **第 8 章** | 在线算法与竞争比 | 竞争比定义、敌手模型、滑雪租赁 2-竞争比证明、分页确定性 $k$ 下界、LRU/FIFO、随机化 Marking 算法、秘书问题 1/e | [Borodin & El-Yaniv] Ch 1, 3; [CLRS] Ch 5.4 | 完整覆盖 |
| **第 9 章** | 评估指标与度量 | 不平衡分类指标、ROC/AUC 面积、排序指标 NDCG/MAP、回归指标、微基准测试设计与噪声排除 | [李航] Ch 1; [Manning IR] Ch 8 | 完整覆盖 |
| **第 10 章** | 假设检验与多重比较 | 零假设与备择假设、t 检验、Mann-Whitney U、Bonferroni 族错误率校正、Benjamini-Hochberg FDR、效应量 Cohen's d、检验力 | [Casella & Berger] Ch 8; [Kohavi] Ch 20 | 完整覆盖 |
| **第 11 章** | 模型评估、正则化与选择 | 偏差-方差分解严格推导、k-fold 与分层 CV、快速 LOOCV 闭式解、L1 Lasso 稀疏性与 L2 Ridge 收缩、AIC/BIC、嵌套 CV | [李航] Ch 1; [Hastie ESL] Ch 7 | 完整覆盖 |
| **第 12 章** | 因果推断：准实验、效应估计与敏感性分析 | 潜在结果模型、工具变量与 2SLS、断点回归（RD）平滑性检验、双重差分（DID）动态事件研究、聚类 Bootstrap、Delta 方法、E-value | [Angrist & Pischke MHE] Ch 3-5; [Pearl] Ch 6 | 完整覆盖 |
| **第 13 章** | 项目一：算法竞赛评测系统 | Linux 评测沙箱、seccomp-bpf 系统调用过滤、cgroup v2 资源隔离、对拍测试框架、Winnowing 代码查重算法 | Codeforces Polygon 设计规范; [Schleimer et al. 2003] | 完整工程落地 |
| **第 14 章** | 项目二：A/B 测试分析流水线 | 样本量与功效规划器、SRM 卡方健康诊断、CUPED 方差缩减、mSPRT 序贯检验早停、多臂老虎机（UCB1/Thompson）、CATE 异质因果 | [Kohavi 2020]; [Deng et al. 2013]; [Johari et al. 2017] | 完整工程落地 |
