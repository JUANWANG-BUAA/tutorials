# CHAPTER09-DONE.md

## ⚠️ 章节位置说明

**原计划**：第9章为"多臂老虎机与在线实验"

**实际情况**：
- `src/part3/ch09.md` 已存在，内容为"评估指标与度量"（1289行，完整章节）
- 多臂老虎机内容需要放置到新位置

**建议方案**：

### 方案A：创建新章节文件
将多臂老虎机内容写入 `src/part3/ch10_bandit.md` 或 `src/part4/ch13_bandit.md`

### 方案B：重组现有结构
- 将现有part3/ch09.md重命名为ch10.md（评估指标）
- 新建part3/ch09.md写入多臂老虎机内容

### 方案C：合并到实验设计
将多臂老虎机作为part2/ch08.md的扩展节（在线实验vs离线实验）

---

## 📝 多臂老虎机章节草稿（未写入文件）

由于目标位置不明确，以下为准备好的章节大纲和核心内容框架：

### 计划内容覆盖

#### 4个内容节
1. § 9.1 探索-利用权衡（后悔、上界、次线性后悔）
2. § 9.2 ε-Greedy算法（简单但次优、后悔O(T^{2/3})）
3. § 9.3 UCB算法（乐观面对不确定性、对数后悔）
4. § 9.4 Thompson采样（贝叶斯视角、Beta-Bernoulli）
5. § 9.5 Contextual Bandit（LinUCB、上下文特征利用）
6. § 9.6 Agent陷阱：过早停止探索

#### 固定4节
7. § 9.7 实验（3算法对比、后悔曲线、上下文实验）
8. § 9.8 母本对应（Sutton《RL》第2章、Lattimore《Bandit Algorithms》）
9. § 9.9 本章陷阱（10条）
10. § 9.10 出口检查

### 核心算法实现（已准备）

**ε-Greedy**：
```python
class EpsilonGreedy:
    def __init__(self, k, epsilon):
        self.k = k
        self.epsilon = epsilon
        self.Q = np.zeros(k)
        self.N = np.zeros(k)
    
    def select_arm(self):
        if np.random.rand() < self.epsilon:
            return np.random.randint(self.k)
        return np.argmax(self.Q)
    
    def update(self, arm, reward):
        self.N[arm] += 1
        self.Q[arm] += (reward - self.Q[arm]) / self.N[arm]
```

**UCB1**：
```python
class UCB1:
    def __init__(self, k):
        self.k = k
        self.Q = np.zeros(k)
        self.N = np.zeros(k)
        self.t = 0
    
    def select_arm(self):
        self.t += 1
        if self.t <= self.k:
            return self.t - 1
        ucb_scores = self.Q + np.sqrt(2 * np.log(self.t) / (self.N + 1e-10))
        return np.argmax(ucb_scores)
```

**Thompson Sampling**：
```python
class ThompsonSampling:
    def __init__(self, k):
        self.k = k
        self.alpha = np.ones(k)
        self.beta = np.ones(k)
    
    def select_arm(self):
        theta = np.random.beta(self.alpha, self.beta)
        return np.argmax(theta)
    
    def update(self, arm, reward):
        if reward > 0.5:
            self.alpha[arm] += 1
        else:
            self.beta[arm] += 1
```

### 实验脚本大纲

**文件**：`experiments/ch09/bandit_lab.py`

**实验1**：3算法对比（ε-greedy vs UCB vs Thompson采样）
- 3臂老虎机，真实期望[0.5, 0.7, 0.6]
- 运行10,000轮，记录累积后悔
- 绘制后悔曲线

**实验2**：ε衰减策略对比
- εₜ = 1/t vs εₜ = 1/√t vs 固定ε=0.1
- 验证衰减策略的改进

**实验3**：UCB vs Thompson采样收敛速度
- 不同臂数（K=3, 5, 10）
- 绘制选择最优臂的概率随时间变化

**实验4**：Contextual Bandit（LinUCB）
- 模拟新闻推荐场景
- 5篇新闻，用户特征3维
- 对比context-free vs contextual策略

**实验5**：过早停止探索的代价
- ε-greedy在100轮后设ε=0
- 对比持续探索vs过早停止

### 理论要点

**关键定理**：
1. UCB1后悔上界：R(T) ≤ 8·Σᵢ(ln(T)/Δᵢ) + O(K)
2. 次线性后悔：R(T) = o(T)，即R(T)/T → 0
3. Thompson采样：R(T) = O(√(KT·log T))

**核心公式**：
1. UCB分数：UCBᵢ(t) = Q̂ᵢ(t) + √(2·ln(t) / Nᵢ(t))
2. 后悔：R(T) = T·μ* - E[Σᵗ₌₁ᵀ rₜ]
3. Beta后验更新：α ← α+成功次数，β ← β+失败次数

### 母本映射

| 主题 | 母本 | 章节 |
|:--|:--|:--|
| 探索-利用困境 | Sutton《Reinforcement Learning》| Ch 2.1-2.7 |
| ε-greedy | Sutton, Ch 2.2 | 完整覆盖 |
| UCB | Auer et al. (2002) | 理论基础 |
| Thompson采样 | Russo et al. (2018) | 现代综述 |
| Contextual Bandit | Li et al. (2010) LinUCB | 原始论文 |
| 后悔上界 | Lattimore《Bandit Algorithms》| Ch 6-8 |

### 10条陷阱

1. **过早停止探索**：前100轮后设ε=0，错失更优臂
2. **忽略方差**：只看均值，不考虑不确定性
3. **冷启动问题**：新臂无历史，UCB无限大
4. **非平稳环境**：臂的期望随时间变化，需滑动窗口
5. **延迟反馈**：奖励延迟到达，需调整算法
6. **批量更新**：每100轮才更新一次，探索不及时
7. **线性假设错误**：LinUCB假设线性模型，非线性场景失效
8. **多重目标**：同时优化CTR和停留时长，需多目标bandit
9. **约束违反**：忽略预算约束、公平性约束
10. **测试泄露**：A/B测试中用bandit，但没告知用户实验性质

### 预期行数

- 正文：600-800行
- 实验脚本：400-500行
- 总计：1000-1300行

### 待决定事项

**需要用户确认**：
1. 多臂老虎机章节应放在哪个文件？
   - part3/ch10.md（新建）
   - part3/ch09.md（覆盖现有评估指标内容）—— ⚠️ 不推荐
   - part4/ch13.md（作为项目准备）
   
2. 现有part3/ch09.md（评估指标）是否保留？
   - 该章节完整（1289行），包含分类、ROC、NDCG等核心内容
   - 建议保留，将多臂老虎机放到新位置

3. 是否需要调整SUMMARY.md？
   - 当前结构：Ch9是评估指标，Ch10是假设检验
   - 插入多臂老虎机需要重新编号

---

## 🎯 下一步操作

### 选项A：创建新章节
```bash
# 1. 创建新文件
vim src/part3/ch10_bandit.md

# 2. 写入多臂老虎机内容

# 3. 更新SUMMARY.md
# 在part3下添加：
# - [10 多臂老虎机与在线学习](part3/ch10_bandit.md)
```

### 选项B：重组现有结构
```bash
# 1. 重命名现有文件
mv src/part3/ch09.md src/part3/ch10_metrics.md

# 2. 创建新的ch09.md写入多臂老虎机

# 3. 更新SUMMARY.md全部引用
```

### 选项C：合并到实验设计
```bash
# 1. 将多臂老虎机作为§ 8.6-8.10补充到part2/ch08.md

# 2. 重命名章节标题为：
#    "实验设计基础：A/B测试与多臂老虎机"
```

---

## 📊 当前状态

| 项目 | 状态 | 说明 |
|:--|:--|:--|
| 第8章正文 | ⚠️ 498行 | 目标700-900行，待补充 |
| 第8章实验 | ✓ 391行 | 完整可运行 |
| 第9章（评估指标）| ✓ 1289行 | 已存在，内容完整 |
| 第9章（多臂老虎机）| ❌ 未写入 | 内容已准备，等待位置确认 |
| 多臂老虎机实验 | ⏳ 草稿 | 需写入bandit_lab.py |

---

## 📝 建议方案（推荐）

### 最佳方案：创建独立章节

1. **保留**现有`part3/ch09.md`（评估指标，完整且重要）
2. **新建**`part3/ch10_bandit.md`（多臂老虎机）
3. **更新**SUMMARY.md：
   ```markdown
   # 第 3 篇 · 评估与统计推断
   
   - [9 评估指标与度量](part3/ch09.md)
   - [10 多臂老虎机与在线学习](part3/ch10_bandit.md)
   - [11 假设检验与多重比较](part3/ch11.md)  ← 原ch10
   - [12 因果推断入门](part3/ch12.md)  ← 原ch11
   ```

4. **补充**第8章到700+行（增加案例、图表、CUPED等）

5. **完成**多臂老虎机实验脚本`experiments/ch09/bandit_lab.py`

### 理由

- 评估指标是独立主题，与多臂老虎机无直接依赖
- 多臂老虎机是在线学习的核心，值得独立成章
- part3主题是"评估与统计推断"，两者都契合
- 避免覆盖已有1289行的完整章节

---

生成时间：2026-10-22  
状态：**待用户确认章节位置后继续**

**待办**：
1. 确认多臂老虎机章节文件名和位置
2. 写入多臂老虎机正文（600-800行）
3. 完成bandit_lab.py实验脚本（400-500行）
4. 补充第8章到700+行
5. 更新SUMMARY.md
