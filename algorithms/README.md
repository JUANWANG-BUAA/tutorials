# 算法、评估与因果 · 定制教程

**14 章 + 2 个项目**：从渐进分析、分治、图算法、动态规划，到基准测试、假设检验、因果推断与 A/B 测试。

**当前进度**：✅ 前3章完成（2568行正文 + 897行实验代码，13个子实验全部验证通过）

---

## 快速开始

```bash
# 1. 安装依赖
python3 -m pip install --user mdbook katex

# 2. 本地预览
cd algorithms
mdbook serve --open

# 3. 构建静态站点
mdbook build
```

产物在 `book/` 目录，用浏览器打开 `book/index.html`。

---

## 目录结构

```
algorithms/
├── book.toml            # mdBook 配置
├── src/
│   ├── SUMMARY.md       # 目录与导航
│   ├── preface.md       # 卷首：为什么写这本书
│   ├── scope.md         # 范围与边界
│   ├── part1/           # 第 1 篇：算法分析基础（1-4 章）
│   ├── part2/           # 第 2 篇：算法设计范式（5-8 章）
│   ├── part3/           # 第 3 篇：评估与统计推断（9-12 章）
│   ├── part4/           # 第 4 篇：两个项目（13-14 章）
│   └── appendix/        # 附录：覆盖矩阵、勘误、延伸阅读
├── experiments/         # 每章实验（ch01/...ch14/）
├── projects/
│   ├── planner/         # 项目一：算法竞赛评测系统
│   └── pipeline/        # 项目二：A/B 测试分析流水线
├── tools/               # 构建与质量门禁脚本
└── theme/               # 视觉层（符号链接到 ../shared/theme）
```

---

## 实验环境

### 最小依赖

- Python 3.11+
- mdBook 0.4.40+（`cargo install mdbook`）
- KaTeX CLI（`npm install -g katex`）

### 实验依赖

```bash
python3 -m pip install --user \
  numpy scipy statsmodels \
  hypothesis pytest \
  matplotlib plotly
```

### 性能测试工具（可选）

- **Linux**：`perf`（内核自带）
- **macOS**：`hyperfine`（`brew install hyperfine`）
- **通用**：`time` 命令

---

## 运行实验

### 单章实验

```bash
cd experiments/ch01
python3 asymptotic_lab.py
```

### 全部实验（14 章）

```bash
bash experiments/run_all.sh
```

输出示例：

```
[ch01] asymptotic_lab.py         PASS
[ch02] divide_conquer_lab.py     PASS
...
[ch14] ab_test_lab.py            PASS
===============================
experiments: PASS=14 FAIL=0 SKIP=0
```

---

## 项目验收

### 项目一：评测系统

```bash
cd projects/planner
bash run_tests.sh
```

验收标准：42 个测试用例全部通过（正确性 + 性能 + 沙箱）。

### 项目二：A/B 测试平台

```bash
cd projects/pipeline
bash run_tests.sh
```

验收标准：43 个测试全部通过（样本量计算 + 假设检验 + 因果效应）。

---

## 质量门禁

一键运行全部检查：

```bash
python3 tools/verify_all.py
```

覆盖项：

1. **结构检查**：行数、H2 结构、盒子闭合、锚点唯一性
2. **实验验证**：14 个章节实验全部通过
3. **项目验证**：2 个项目各自测试全部通过
4. **覆盖矩阵**：母本单元映射完整，缺口 = 0
5. **代码围栏**：语法检查通过
6. **构建测试**：`mdbook build` 零警告，内链有效

---

## 母本覆盖

| 母本 | 作者 | 覆盖范围 |
|:--|:--|:--|
| 算法详解 卷 1 | Tim Roughgarden | 渐进分析、分治、主方法、快排 |
| 算法详解 卷 2 | Tim Roughgarden | 图算法、数据结构、哈希 |
| 算法详解 卷 3 | Tim Roughgarden | 贪心、动态规划 |
| 算法详解 卷 4 | Tim Roughgarden | NP 难问题、近似算法 |
| 算法导论（CLRS 3ed） | Cormen 等 | 经典算法百科全书 |
| 统计学习方法（第 2 版） | 李航 | 监督学习、评估指标、统计学习理论 |

完整映射见 [附录 A](src/appendix/coverage.md)。

---

## 特色

### 与现有算法书的区别

| 维度 | 现有算法书 | 本书特色 |
|:--|:--|:--|
| 算法分析 | 理论复杂度 | **理论 + 实测对比**，常数、缓存、分支预测影响 |
| 正确性验证 | 伪代码 + 证明 | **可运行代码 + 对拍 + 反例构造** |
| 性能评估 | 跑一次计时 | **统计推断、置信区间、多重比较校正** |
| agent 陷阱 | 不涉及 | **每章一个真实 LLM 生成代码的失败案例** |
| 工程实践 | 理论为主 | **两个完整项目：评测系统 + A/B 测试平台** |

### 每章结构

- **chapter-index**：本章回答 / 读完你会
- **导语**：上一章留下什么、本章解决什么、一个具体反例
- **8 个内容节**：每节有问题、机制、边界、表/代码/图
- **ASCII 布局图**：算法流程、复杂度树、实验设计
- **可运行实验**：`experiments/chNN/` 真实输出可验证
- **agent 陷阱案例**：症状 → 根因 → 检测 → 修复
- **母本对应表**：4-7 行，标注覆盖程度
- **8-15 条陷阱**：常见错误与修复方法
- **出口检查表**：达标线 + method/sol 自测

---

## 已知限制

1. **性能测量环境依赖**：实验在 macOS 上验证，Linux 结果可能略有差异（已固定 seed）。
2. **项目二不是生产级平台**：专注评估逻辑演示，不含分布式调度、故障恢复。
3. **因果推断为入门级**：第 12 章只覆盖核心概念，完整因果推断需要专门教材。
4. **母本部分依赖论文**：第 8-12 章补充工程论文（SPEC、MLPerf）与开源项目文档。

---

## 贡献

发现笔误、实验问题或有改进建议？

- **提 Issue**：[github.com/JUANWANG-BUAA/tutorials/issues](https://github.com/JUANWANG-BUAA/tutorials/issues)
- **编辑此页**：右上角 GitHub 图标 → 直接改 Markdown → 提 Pull Request

---

## 许可

本教程内容采用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 许可。

代码示例（`experiments/`、`projects/`）采用 [MIT License](LICENSE-CODE)。
