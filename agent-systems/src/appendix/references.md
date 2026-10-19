# C 术语、工具与延伸阅读

## C.1 规范与版本

这本书的结论都挂在具体版本上。下面列出正文引用的规范入口；读原文时先看版本号与 changelog，不要拿博客二手总结替代。

| 规范 | 本书基线 | 入口 | 正文落点 |
|:--|:--|:--|:--|
| Model Context Protocol | 2026-07-28（对照 2025-11-25） | <https://modelcontextprotocol.io/specification/2026-07-28> | 2.1–2.9、10.3、11.5 |
| MCP 安全最佳实践 | 2026-07-28 | <https://modelcontextprotocol.io/docs/2026-07-28/tutorials/security/security_best_practices> | 2.8、11.5 |
| OpenAI function calling | Responses API + Chat Completions | <https://platform.openai.com/docs/guides/function-calling> | 2.3、2.7 |
| JSON Schema | 2020-12 | <https://json-schema.org/draft/2020-12> | 2.2、1.4 |
| OCI Runtime Spec | v1.3.0 | <https://specs.opencontainers.org/runtime-spec/> | 3.6、4.2–4.6 |
| OpenTelemetry GenAI | semconv 1.44.0 | <https://opentelemetry.io/docs/specs/semconv/gen-ai/> | 10.2–10.3 |
| W3C Trace Context | Recommendation | <https://www.w3.org/TR/trace-context/> | 10.2 |
| OAuth 2.1 | draft | <https://datatracker.ietf.org/doc/draft-ietf-oauth-v2-1/> | 2.8 |
| RFC 8707 Resource Indicators | RFC | <https://www.rfc-editor.org/rfc/rfc8707> | 2.8 |
| RFC 9728 Protected Resource Metadata | RFC | <https://www.rfc-editor.org/rfc/rfc9728> | 2.8 |
| NIST AI RMF 1.0 | 2023 | <https://www.nist.gov/itl/ai-risk-management-framework> | 12.6 |
| NIST GenAI Profile | 2024 | <https://www.nist.gov/publications/artificial-intelligence-risk-management-framework-generative-artificial-intelligence> | 12.6 |
| ISO/IEC 42001 | 2023 | <https://www.iso.org/standard/81230.html> | 12.6 |
| EU AI Act | Regulation (EU) 2024/1689 | <https://eur-lex.europa.eu/eli/reg/2024/1689/oj> | 12.6 |
| OWASP LLM Top 10 | 2025 | <https://genai.owasp.org/llm-top-10/> | 11.1–11.7 |

这张表说明什么：规范是**可检查的契约**，不是背景阅读。写 2.5 时如果只记得 `initialize`，就会漏掉 2026-07-28 的无状态迁移；写 4.4 时如果只记得「Landlock 支持网络」，就会把 ABI 4 的能力记成 ABI 6。

## C.2 论文与方法

论文只提供方法与证据，正文已把它们重写成工程判断。读原文时关注实验设置与适用边界，不要只记结论。

### C.2.1 循环、规划与反思

| 论文 | 一句话 | 正文 |
|:--|:--|:--|
| ReAct: Synergizing Reasoning and Acting in Language Models (Yao et al., 2022) | 推理与行动交错，用观察修正推理 | 7.2 |
| Reflexion: Language Agents with Verbal Reinforcement Learning (Shinn et al., 2023) | 把失败写成语言化反思，回写到下一轮 | 7.5 |
| Tree of Thoughts: Deliberate Problem Solving with Large Language Models (Yao et al., 2023) | 把候选思维组织成树，用搜索换质量 | 7.4 |
| Self-Refine: Iterative Refinement with Self-Feedback (Madaan et al., 2023) | 同一模型自我批评与修订 | 7.5 |
| Self-Consistency Improves Chain of Thought Reasoning (Wang et al., 2022) | 多次采样投票，降低单次方差 | 7.6 |
| Toolformer: Language Models Can Teach Themselves to Use Tools (Schick et al., 2023) | 自监督学习何时调用工具 | 2.3 |
| Gorilla: Large Language Model Connected with Massive APIs (Patil et al., 2023) | API 检索与调用 | 2.3 |
| ToolLLM: Facilitating Large Language Models to Master 16000+ Real-world APIs (Qin et al., 2023) | 大规模工具调用数据与评测 | 2.9 |

### C.2.2 记忆与检索

| 论文 | 一句话 | 正文 |
|:--|:--|:--|
| Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks (Lewis et al., 2020) | 检索增强生成的基础配方 | 6.3 |
| Lost in the Middle: How Language Models Use Long Contexts (Liu et al., 2023) | 长上下文中部信息利用率下降 | 5.2 |
| MemGPT: Towards LLMs as Operating Systems (Packer et al., 2023) | 分层记忆与换入换出 | 6.1 |
| CoALA: Cognitive Architectures for Language Agents (Sumers et al., 2023) | 把 agent 拆成记忆、行动空间与决策过程 | 1.3 |

### C.2.3 评测

| 论文/基准 | 一句话 | 正文 |
|:--|:--|:--|
| SWE-bench (Jimenez et al., 2023) | 真实仓库 issue 修复 | 9.2 |
| τ-bench (Yao et al., 2024) | 工具-用户交互与规则遵循 | 9.2 |
| AgentBench (Liu et al., 2023) | 多环境 agent 评测 | 9.2 |
| WebArena (Zhou et al., 2023) | 真实网页任务 | 9.2 |
| GAIA (Mialon et al., 2023) | 通用助手基准 | 9.2 |
| Judging LLM-as-a-Judge (Zheng et al., 2023) | 模型评审的偏差与一致性 | 9.7 |

### C.2.4 多智能体与安全

| 论文/系统 | 一句话 | 正文 |
|:--|:--|:--|
| AutoGen (Wu et al., 2023) | 多 agent 对话编排 | 8.2 |
| ChatDev (Qian et al., 2023) | 角色化软件开发 | 8.2 |
| CAMEL (Li et al., 2023) | 角色扮演协作 | 8.2 |
| CaMeL: Defeating Prompt Injections by Design (Debenedetti et al., 2025) | 用能力隔离与控制流完整性防注入 | 11.5 |
| AgentDojo (Debenedetti et al., 2024) | 注入攻击与防御的评测环境 | 11.7 |
| InjecAgent (Zhan et al., 2024) | 间接提示注入基准 | 11.7 |
| PromptInject (Perez & Ribeiro, 2022) | 提示注入的系统化描述 | 11.2 |

## C.3 工具

书里不绑定框架；下面这些工具只用于「验证某个机制」，不是推荐清单。

| 类别 | 工具 | 用途 | 章节 |
|:--|:--|:--|:--|
| 构建 | mdBook、mdbook-katex、markdown-it-py | 本书构建 | 环境 |
| 协议 | MCP Inspector | 手工发 `tools/list`、`tools/call`，看请求帧 | 2.4 |
| 沙箱 | bubblewrap、nsjail、firejail | 对照你自己的 runner；不要盲信默认配置 | 3.6 |
| 权限 | `capsh`、`setpriv`、`seccomp-tools` | 查看/调试 capability 与 seccomp | 4.2–4.3 |
| 观测 | OpenTelemetry Collector、Jaeger、Tempo | trace 收集与查询 | 10.2 |
| 策略 | Open Policy Agent、Cedar | 策略即代码 | 12.5 |
| 供应链 | Sigstore/cosign、SLSA、Syft | 签名、来源证明、SBOM | 11.4 |
| 统计 | Python `statistics`、`numpy`（可选） | 置信区间与重采样 | 9.4 |

使用工具的两条原则：

1. **先能解释它做了什么，再用。** 例如 `bwrap` 的一条命令可能包含 userns、bind mount、seccomp；说不清哪一层在挡什么，就无法排查「为什么这个写入成功了」。
2. **默认配置不是安全证明。** 容器、沙箱、框架的默认值会随版本变化；把它们当成起点，用第 3、4 章的检查表逐项验证。

## C.4 术语表

| 术语 | 英文 | 本书定义 | 首次出现 |
|:--|:--|:--|:--|
| agent | agent | 带状态、工具、预算的闭环控制器 | 1.1 |
| 轨迹 | trajectory | 状态、动作、观察的序列 | 1.1 |
| 步 | step | 一次决策-执行-更新 | 1.2 |
| 回合 | turn | 用户一次输入到最终回复 | 1.2 |
| 工具契约 | tool contract | 名称、schema、前置条件、效果、幂等、成本、权限 | 1.4 |
| 预算向量 | budget vector | 步数、工具、墙钟、token、金额 | 1.5 |
| 进展度量 | progress measure | 用于判定「是否有推进」的良基函数 | 1.5 |
| 幂等键 | idempotency key | 让重试不产生重复副作用的标识 | 1.4 |
| 工具协议 | tool protocol | 模型、宿主、工具三方对调用与结果的契约 | 2.1 |
| MCP | Model Context Protocol | 连接 host/client/server 的 JSON-RPC 协议 | 2.4 |
| MRTR | Multi Round-Trip Requests | 服务端要求补充输入的多次往返模式 | 2.5 |
| 沙箱 | sandbox | 进程、文件、网络、资源四层边界的组合 | 3.1 |
| capability | capability | 绕过 UID 检查的细粒度特权 | 4.2 |
| seccomp | seccomp-bpf | 系统调用过滤 | 4.3 |
| Landlock | Landlock | 无特权、可堆叠的 LSM 访问控制 | 4.4 |
| user namespace | user namespace | UID/GID 映射与命名空间内 root | 4.5 |
| 上下文工程 | context engineering | 按预算选择、压缩、裁剪、缓存上下文 | 5.1 |
| prompt caching | prompt caching | 复用稳定前缀的 KV 缓存 | 5.7 |
| RAG | retrieval-augmented generation | 检索增强生成 | 6.3 |
| 重排 | rerank | 对召回候选做更贵的相关性排序 | 6.4 |
| 归因 | attribution | 把答案片段映射回证据 span | 6.5 |
| ReAct | ReAct | 推理与行动交错 | 7.2 |
| Plan-Execute | plan-and-execute | 先出计划再执行，可重规划 | 7.3 |
| 树搜索 | tree search | 展开候选并用价值函数回传 | 7.4 |
| 多智能体 | multi-agent | 多个角色/进程协作或对抗 | 8.1 |
| 评估集 | eval set | 版本化、分层、可复现的样本集合 | 9.2 |
| 置信区间 | confidence interval | 对指标不确定性的区间估计 | 9.4 |
| 配对检验 | paired test | 同一批样本上比较两个系统 | 9.4 |
| 门禁 | gate | 阻止回归进入生产的自动检查 | 9.5 |
| trace | trace | 一次运行的 span 树 | 10.2 |
| span | span | 一个有开始/结束/属性的操作 | 10.2 |
| 回放 | replay | 用记录重放一次运行 | 10.6 |
| prompt injection | prompt injection | 不可信数据被当成指令 | 11.2 |
| 数据外泄 | exfiltration | 把敏感数据送出边界 | 11.3 |
| 工具投毒 | tool poisoning | 通过工具描述/schema/供应链影响行为 | 11.4 |
| human-in-the-loop | HITL | 在关键动作前引入人工审批 | 12.4 |
| 策略即代码 | policy as code | 把授权规则写成可测试、可审计的代码 | 12.5 |
| JIT 权限 | just-in-time | 按需、短时授予权限 | 12.3 |

## C.5 延伸阅读顺序

如果你想深入某一层，建议按下面的顺序读，而不是直接跳到论文：

1. **协议层**：先读 MCP 2026-07-28 的 Architecture、Transports、Tools、Authorization 四页；再对照 2025-11-25 的 Lifecycle，理解迁移。
2. **沙箱层**：先读 `seccomp(2)`、`landlock(7)`、`user_namespaces(7)` 的 EXAMPLES；再读 OCI Runtime Spec 的 config-linux。不要先读内核源码。
3. **上下文层**：先读 Lost in the Middle 的实验设置，再读自己模型的上下文文档；不同模型的「中间」位置与衰减曲线不同。
4. **评估层**：先读 SWE-bench 与 τ-bench 的评测协议，再读统计教材的区间估计；不要只看排行榜分数。
5. **安全层**：先读 OWASP LLM Top 10 与 MCP Security Best Practices，再读 CaMeL 与 AgentDojo；前者给攻击面，后者给评测方法。
6. **治理层**：先读 NIST AI RMF 的 Govern/Map/Measure/Manage 四函数，再读 EU AI Act 的时间表；不要从条文开始背。

每读一篇，问三个问题：它的实验条件是什么？它的结论在什么条件下不成立？如果搬到我的系统，最小的验证实验是什么？答不出来，就还没读懂。
