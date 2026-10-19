<section class="chapter-cover">
<div class="kicker">Agent 系统工程 · 定制教程</div>
<h1>Agent 系统工程</h1>
<div class="subtitle">把 agent 当成一个有状态、有工具、有预算、可审计的系统来造：从循环与协议，到沙箱、上下文、评估、安全与治理，最后用两个可运行项目压成工程能力。</div>
<div class="cover-chips">
<span>4 篇 · 14 章</span>
<span>2 个可运行项目</span>
<span>163 个母本单元逐节覆盖</span>
<span>机制图 / trace / 实验 / 红队</span>
</div>
<details class="cover-details">
<summary>查看依据、边界与前置</summary>
<div class="meta">
依据 <b>Model Context Protocol 2026-07-28</b>（对照 2025-11-25）、<b>OpenAI function calling</b>、
<b>OCI Runtime Spec 1.3.0</b>、<b>OpenTelemetry GenAI/MCP semantic conventions</b>，以及 ReAct、Reflexion、
Tree of Thoughts、RAG、Lost in the Middle、MemGPT、τ-bench、SWE-bench、CaMeL、AgentDojo 等公开论文与规范整理。
全部正文为重新组织的讲解与示例，不是原文摘录。
<b>前置</b>：操作系统与系统编程读《Linux 系统与内核》第 2/3/5 篇；模型基础读《深度学习导论》。
本书只写 agent 新增层，不重写进程、TCP/IP、容器与神经网络。
</div>
</details>

<div class="cover-object" aria-hidden="true">
  <div class="book-3d"><div class="book"><div class="face face-front">{{#include assets/covers/agent-systems.svg}}</div></div></div>
</div>
</section>

<section class="book-contents" aria-label="目录">
<div class="bc-head"><span class="bc-kicker">CONTENTS / 目录</span><span class="bc-meta">4 篇 · 14 章 · 2 项目</span></div>
<div class="bc-list">
<a class="bc-row" href="part1/ch01.md"><span class="bc-no">01</span><span class="bc-title">机制与边界：循环、协议、沙箱、权限</span><span class="bc-count">4 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="part2/ch05.md"><span class="bc-no">02</span><span class="bc-title">上下文与决策：预算、记忆、规划、多智能体</span><span class="bc-count">4 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="part3/ch09.md"><span class="bc-no">03</span><span class="bc-title">评估、观测与治理</span><span class="bc-count">4 章</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
<a class="bc-row" href="projects/overview.md"><span class="bc-no">04</span><span class="bc-title">两个项目：代码 agent 与评估平台</span><span class="bc-count">2 项目</span><span class="bc-arrow" aria-hidden="true">↗</span></a>
</div>
<p class="bc-note">左侧目录是完整导航；页首搜索支持全文检索。第一次来，先读 <a href="roadmap.md">学习路线</a>，再从 <a href="part1/ch01.md">第 1 章</a> 开始。</p>
</section>

<section class="study-paths" aria-label="学习路线">
<div class="study-path">
<span class="path-kicker">ROUTE 01</span>
<strong>平台工程路线</strong>
<p>先读 1–4 章建立执行与边界，再读 9–12 章建立评估与治理，最后做项目二。</p>
<a href="roadmap.md">展开路线 →</a>
</div>
<div class="study-path">
<span class="path-kicker">ROUTE 02</span>
<strong>应用开发路线</strong>
<p>从 1、2、5、6、7 章入手，先做出可控的 agent，再补沙箱与评估。</p>
<a href="roadmap.md">展开路线 →</a>
</div>
<div class="study-path">
<span class="path-kicker">ROUTE 03</span>
<strong>安全与合规路线</strong>
<p>1、2、3、4、11、12 章连读，项目一做红队，项目二做回归门禁。</p>
<a href="roadmap.md">展开路线 →</a>
</div>
</section>

## 这本书解决什么问题

一个 agent 出事故，通常不是因为模型「不会」，而是因为系统缺了一层：

- 循环没有预算，跑到天亮；
- 工具没有契约，模型把「读取」当成「修改」；
- 沙箱只做了文件只读，网络却全开；
- 上下文把约束摘要掉了，模型「合理地」违反要求；
- 评估只看最终答案，看不到工具调用错误；
- trace 只有日志，没有 span，出事无法回放；
- 安全靠提示词，治理靠文档。

本书按「机制 → 上下文 → 评估 → 治理」的顺序，把这些层逐一补上。每一章都给出可运行的实验、失败复盘与观测命令；两个项目把所有层拼成一个能跑、能测、能审计的系统。

## 怎么读

| 你的背景 | 建议路线 | 可以跳过 |
|:--|:--|:--|
| 写过 LLM 应用，没做过平台 | 1–2 → 5–7 → 9–10 → 项目二 → 3–4 → 11–12 | 7.4 的搜索证明细节 |
| 系统/后端工程师 | 1 → 3–4 → 2 → 9–12 → 项目一 | 5.2 的位置偏差实验 |
| 安全/合规工程师 | 1–4 → 11–12 → 项目一 → 9–10 | 6.4 的重排实现 |
| 学生/研究者 | 按章顺序；每章先读定义与失败案例 | 项目二的部署细节 |

三条路线的共同点是：**先建立边界，再谈能力**。没有边界的 agent，能力越强，事故越大。

## 两个项目

| 项目 | 你会造什么 | 验收 |
|:--|:--|:--|
| [项目一 · 可沙箱执行的代码 agent](part4/ch13.md) | 一个能读文件、改文件、跑测试、受限执行的 agent；带进程组收尸、文件根、egress 拒绝、trace 与红队用例 | 超时能杀干净；越界写入被拒；红队用例全过；trace 可回放 |
| [项目二 · 带评估集的工具调用平台](part4/ch14.md) | 工具注册表、执行器、版本化评估集、多次采样、置信区间、回归门禁与成本/延迟仪表 | 同一评估集可复现；门禁能拦截回归；报告含 CI 与成本 |

两个项目共享同一套 trace 字段与工具契约；项目二可以直接评估项目一的 agent。先做哪个都行，但建议至少把项目一的沙箱 runner 跑通，再做项目二的评估。

## 与另外两本书的边界

| 主题 | 去哪读 | 本书只做什么 |
|:--|:--|:--|
| 进程、信号、IPC、socket、epoll | 《Linux 系统与内核》第 2 篇 | 在沙箱边界引用；写清 wait status、进程组、超时 |
| namespace、cgroup、seccomp、容器 | 同书第 3/5 篇 | 组合成 agent 沙箱；补 capability/landlock 的次序 |
| TCP/IP、DNS、HTTP | 同书第 4 篇 | 只写 egress 策略、DNS 重绑定、代理边界 |
| 神经网络、注意力、训练 | 《深度学习导论》 | 只引用 token、上下文、成本等工程含义 |

如果你在这本书里看到大段 fork/信号/反向传播的教科书讲解，那是缺陷，不是覆盖。请按 [附录 A 覆盖矩阵](appendix/coverage.md) 回查落点。
