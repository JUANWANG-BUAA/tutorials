# A 母本覆盖矩阵

## A.1 这张表怎么读

本表把本书用到的每一部母本、规范与论文的**每一个章节**映射到正文落点。它是「不遗漏、不越界」的验收依据，不是装饰：

- **完整**：该章的概念、关键接口/字段、边界与例子都在正文出现；
- **精选**：核心概念与常用接口在正文，冷门细节只给判断；
- **背景**：只保留理解主线所需的最小集；
- **交叉引用**：该书已覆盖，本书**不重写**，只在 agent 新增层需要时给出落点；
- **淘汰**：内容过时或超出范围，只在附录 B 保留说明。

《Linux 系统与内核》第 2/3/5 篇与《深度学习导论》是**前置知识**，本书用「交叉引用」明确边界：进程、信号、IPC、namespace、cgroup、TCP/IP、容器、神经网络、训练方法都不在这里重讲。若你发现某一节在本书找不到落点，按「母本」列回查；若发现本书重写了基础，那是缺陷，不是覆盖。

> 版本基线：MCP `2026-07-28`（对照 `2025-11-25`）、OCI Runtime Spec `v1.3.0`、OpenTelemetry Semantic Conventions `1.44.0`、Linux 6.8、bash 5.2。页码随版本漂移，故不列页码。

## L2 · 《Linux 系统与内核》第 2 篇 · Unix/Linux 系统编程

*本仓库 linux/，19 章。只交叉引用，不重写系统编程基础。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1 章 | 系统编程基础：系统调用、错误与可移植性 | 3.1 | 交叉引用 | 系统调用、errno、可移植性只作边界说明 |
| 第 2–4 章 | 文件 I/O … 缓冲与 stdio | 3.3 | 交叉引用 | 文件 I/O、原子性、mmap 用于沙箱文件策略 |
| 第 5–6 章 | 文件属性、扩展属性与 ACL … 目录、链接与文件事件 | 4.1 | 交叉引用 | 凭证、ACL 与权限模型 |
| 第 7–8 章 | 进程创建与终止 … 程序执行与子进程监控 | 3.2 | 交叉引用 | fork/exec/wait 与退出状态，见附录 B 的 0x2a00 |
| 第 9 章 | 进程凭证、用户、组与能力 | 4.2 | 交叉引用 | capability 五集合 |
| 第 10–11 章 | 信号 … 定时器与休眠 | 3.2 | 交叉引用 | 信号、定时器与超时 |
| 第 12–13 章 | 线程 … 线程同步与线程安全 | 8.4 | 背景 | 线程同步作为多 agent 冲突的类比 |
| 第 14–15 章 | 管道、FIFO 与消息队列 … 共享内存与信号量 | 8.3 | 背景 | 消息队列/信号量作为通信原语，含 variadic 原型勘误 |
| 第 16–18 章 | 套接字基础 … 备选 I/O：select/poll/epoll/io_uring | 3.4 | 交叉引用 | socket 与 epoll 用于网络边界 |
| 第 19 章 | 终端、pty、作业控制与守护进程 | 13.6 | 精选 | 作业控制用于沙箱进程组与会话 |

## L3 · 《Linux 系统与内核》第 3 篇 · Linux 内核

*本仓库 linux/，15 章。只取隔离与观测相关的机制落点。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1–2 章 | 内核架构、源码、构建与调试环境 … 启动与初始化 | 3.2 | 背景 | 内核架构与启动，只说明边界 |
| 第 3 章 | 中断、异常与系统调用 | 4.3 | 交叉引用 | 系统调用入口是 seccomp 的拦截点 |
| 第 4–5 章 | 进程管理与调度 … 线程与调度 | 3.2 | 背景 | 调度与进程组 |
| 第 6–7 章 | 内存管理 … 换入/换出 | 3.5 | 背景 | 内存与换页 |
| 第 8 章 | 设备驱动 | 3.3 | 背景 | 设备与文件 |
| 第 9–10 章 | 虚拟文件系统 … 文件系统 | 3.3 | 交叉引用 | VFS、挂载与 rootfs |
| 第 11 章 | 进程同步 | 8.4 | 背景 | 内核同步原语 |
| 第 12–13 章 | 内存管理进阶 … 文件系统进阶 | 3.5 | 背景 | 内存/文件系统进阶 |
| 第 14 章 | 设备驱动进阶 | 3.3 | 背景 | 设备驱动 |
| 第 15 章 | 内核调试与追踪 | 10.7 | 交叉引用 | ftrace/perf 用于回放与定位 |

## L5 · 《Linux 系统与内核》第 5 篇 · 云原生

*本仓库 linux/，6 章。容器运行时只作为沙箱的实现参照。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1–2 章 | 容器基础与运行时 … namespace 与隔离 | 3.6 | 交叉引用 | OCI 运行时与 namespace |
| 第 3 章 | cgroup 与资源限制 | 3.5 | 交叉引用 | cgroup v2 |
| 第 4 章 | 容器网络 | 3.4 | 交叉引用 | 容器网络与 egress |
| 第 5 章 | 容器存储 | 3.3 | 交叉引用 | 容器存储与 overlay |
| 第 6 章 | Kubernetes 与编排 | 12.3 | 背景 | 编排层的最小权限 |

## DL · 《深度学习导论》

*本仓库 deeplearning/，9 讲。模型基础只引用，不重写。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1 章 | 深度学习导论 | 5.2 | 背景 | token 与注意力成本 |
| 第 2 章 | 序列建模与注意力 | 5.2 | 背景 | 上下文窗口与位置偏差 |
| 第 3–4 章 | 计算机视觉 … 生成建模 | 1.1 | 背景 | 模型能力边界，不重写网络结构 |
| 第 5 章 | 强化学习 | 7.4 | 背景 | MCTS 来自强化学习 |
| 第 6–7 章 | 新前沿 … AI 三法则 | 11.1 | 背景 | AI 风险框架 |
| 第 8 章 | AI for Science | 9.1 | 背景 | 领域评测 |
| 第 9 章 | 大规模并行训练 | 9.6 | 背景 | 训练/推理成本 |

## MCP · Model Context Protocol Specification

*2026-07-28（对照 2025-11-25）。协议章节逐节落点；旧版生命周期作为迁移对照。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1 章 | 架构：host、client、server 与 JSON-RPC 2.0 | 2.1 | 完整 | host/client/server 三角与 JSON-RPC 2.0 |
| 第 2 章 | 无状态协议与每请求 _meta | 2.5 | 完整 | 无状态协议、每请求 _meta |
| 第 3 章 | server/discover 与版本协商 | 2.5 | 完整 | server/discover 与版本协商 |
| 第 4 章 | Tools：tools/list 与 tools/call | 2.4 | 完整 | tools/list、tools/call、inputSchema |
| 第 5 章 | 工具结果：content、structuredContent、isError | 2.7 | 完整 | 结构化结果与 isError |
| 第 6 章 | Resources：list/read/templates 与订阅 | 2.4 | 完整 | resources 与订阅 |
| 第 7 章 | Prompts：list/get 与参数 | 2.4 | 完整 | prompts 与参数 |
| 第 8 章 | 多轮往返请求 MRTR | 2.5 | 完整 | MRTR 取代 server-initiated requests |
| 第 9 章 | 取消与进度通知 | 2.6 | 完整 | 取消与进度 |
| 第 10 章 | subscriptions/listen 长流 | 2.6 | 精选 | subscriptions/listen 长流 |
| 第 11 章 | stdio 传输 | 2.6 | 完整 | stdio 传输与 stderr 日志 |
| 第 12 章 | Streamable HTTP 传输 | 2.6 | 完整 | Streamable HTTP |
| 第 13 章 | HTTP 头、Origin 与请求关联 | 2.6 | 精选 | Mcp-Method/Mcp-Name 与 Origin |
| 第 14 章 | 授权：OAuth 2.1 与受保护资源元数据 | 2.8 | 完整 | OAuth 2.1 与 RFC 9728 |
| 第 15 章 | 授权服务器发现与 OIDC | 2.8 | 精选 | OIDC 发现 |
| 第 16 章 | 客户端注册：CIMD 与 DCR | 2.8 | 精选 | CIMD 与 DCR |
| 第 17 章 | token audience 与 RFC 8707 | 2.8 | 完整 | token audience 与 RFC 8707 |
| 第 18 章 | 安全：confused deputy 与 token passthrough | 11.5 | 完整 | confused deputy、token passthrough |
| 第 19 章 | 安全：状态句柄劫持与 SSRF | 11.5 | 完整 | 状态句柄劫持、SSRF |
| 第 20 章 | 安全：本地 server 失陷与 stdio 代理 | 11.5 | 精选 | 本地 server 失陷与 stdio 代理 |
| 第 21 章 | 缓存：ttlMs 与 cacheScope | 5.7 | 精选 | ttlMs/cacheScope 与上下文缓存 |
| 第 22 章 | 分页 | 2.6 | 背景 | 分页 |
| 第 23 章 | Tasks 扩展 | 2.5 | 精选 | Tasks 扩展 |
| 第 24 章 | 扩展机制与能力协商 | 2.9 | 完整 | 扩展与能力协商 |
| 第 25 章 | 弃用：Roots、Sampling、Logging | 2.9 | 完整 | Roots/Sampling/Logging 弃用 |
| 第 26 章 | Schema：JSON Schema 2020-12 | 2.2 | 完整 | JSON Schema 2020-12 默认方言 |
| 第 27 章 | 错误码与 JSON-RPC 映射 | 2.7 | 完整 | 错误码分区与 JSON-RPC 映射 |
| 第 28 章 | _meta 中的 OpenTelemetry 上下文 | 10.3 | 精选 | _meta 中的 traceparent |
| 第 29 章 | Registry 与供应链 | 11.4 | 精选 | Registry 与工具供应链 |
| 第 30 章 | 版本兼容策略 | 2.9 | 完整 | 版本兼容策略 |

## OAI · OpenAI Function Calling / Tools 文档

*Responses API 与 Chat Completions 对照。厂商协议作为 MCP 的对照面。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1 章 | Responses API 与 Chat Completions 的工具形态差异 | 2.3 | 完整 | 两种 API 的工具形态差异 |
| 第 2 章 | 函数定义：name、description、parameters | 2.2 | 完整 | 函数 schema 的三段 |
| 第 3 章 | strict 模式的约束与代价 | 2.2 | 完整 | strict 的约束与代价 |
| 第 4 章 | tool_choice：none/auto/required/named | 2.3 | 完整 | tool_choice 四态 |
| 第 5 章 | parallel_tool_calls 与并发结果 | 2.3 | 完整 | parallel_tool_calls |
| 第 6 章 | 流式 tool_call 增量与 index | 2.3 | 完整 | 流式增量与 index |
| 第 7 章 | 工具结果消息与 tool_call_id | 2.3 | 完整 | tool_call_id 与结果回传 |
| 第 8 章 | finish_reason 与截断 | 2.7 | 完整 | finish_reason 与截断 |
| 第 9 章 | 结构化输出 json_schema | 2.2 | 完整 | json_schema 结构化输出 |
| 第 10 章 | 参数校验失败与重试 | 2.7 | 完整 | 校验失败与重试 |
| 第 11 章 | token 计量与工具描述成本 | 9.6 | 精选 | 工具描述本身占 token |

## OCI · Open Container Initiative Runtime Spec

*v1.3.0（2025-11）。作为沙箱配置的工业级参照。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1 章 | bundle 布局 | 3.6 | 完整 | bundle 布局 |
| 第 2 章 | config.json 顶层字段 | 3.6 | 完整 | config.json 顶层 |
| 第 3 章 | process：args、env、cwd | 3.2 | 完整 | process 与 argv |
| 第 4 章 | user 与 uid/gid 映射 | 4.5 | 完整 | uid/gid 映射 |
| 第 5 章 | capabilities 五集合 | 4.2 | 完整 | capabilities 五集合 |
| 第 6 章 | rlimits | 3.5 | 完整 | rlimits |
| 第 7 章 | noNewPrivileges | 4.6 | 完整 | noNewPrivileges |
| 第 8 章 | seccomp | 4.3 | 完整 | seccomp |
| 第 9 章 | mounts 与 rootfs | 3.3 | 完整 | mounts 与 rootfs |
| 第 10 章 | namespaces | 4.5 | 完整 | namespaces |
| 第 11 章 | hooks | 12.4 | 精选 | hooks 与审批点 |
| 第 12 章 | 生命周期：create/start/kill/delete | 3.6 | 完整 | 生命周期 |
| 第 13 章 | annotations | 12.2 | 精选 | annotations 与审计 |
| 第 14 章 | cgroup 资源 | 3.5 | 完整 | cgroup 资源 |
| 第 15 章 | AppArmor/SELinux | 4.6 | 精选 | AppArmor/SELinux 与 LSM 次序 |

## PAPER · Agent / RAG / 评测 / 安全 的关键论文

*按主题选读，不逐篇复述。论文只提供方法与证据，正文重写为工程判断。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1 章 | ReAct：推理与行动交错 | 7.2 | 完整 | ReAct |
| 第 2 章 | Reflexion：语言化反思 | 7.5 | 完整 | Reflexion |
| 第 3 章 | Tree of Thoughts：思维树搜索 | 7.4 | 完整 | Tree of Thoughts |
| 第 4 章 | Toolformer：自监督工具学习 | 2.3 | 背景 | Toolformer |
| 第 5 章 | RAG：检索增强生成 | 6.3 | 完整 | RAG |
| 第 6 章 | Lost in the Middle：长上下文位置偏差 | 5.2 | 完整 | Lost in the Middle |
| 第 7 章 | MemGPT：分层记忆管理 | 6.1 | 完整 | MemGPT |
| 第 8 章 | Self-Refine：迭代自我改进 | 7.5 | 精选 | Self-Refine |
| 第 9 章 | CoALA：认知架构式 agent | 1.3 | 背景 | CoALA |
| 第 10 章 | ToolLLM：大规模工具调用 | 2.9 | 背景 | ToolLLM |
| 第 11 章 | Gorilla：API 调用与检索 | 2.3 | 背景 | Gorilla |
| 第 12 章 | τ-bench：工具-用户交互评测 | 9.2 | 完整 | τ-bench |
| 第 13 章 | SWE-bench：真实仓库修复 | 9.2 | 完整 | SWE-bench |
| 第 14 章 | AgentBench：多环境 agent 评测 | 9.2 | 完整 | AgentBench |
| 第 15 章 | WebArena：网页任务评测 | 9.2 | 精选 | WebArena |
| 第 16 章 | GAIA：通用助手基准 | 9.2 | 精选 | GAIA |
| 第 17 章 | Voyager：开放世界技能积累 | 6.7 | 背景 | Voyager 的技能积累 |
| 第 18 章 | AutoGen：多 agent 对话框架 | 8.2 | 完整 | AutoGen |
| 第 19 章 | ChatDev：角色化软件开发 | 8.2 | 精选 | ChatDev |
| 第 20 章 | CAMEL：角色扮演协作 | 8.2 | 精选 | CAMEL |
| 第 21 章 | LLM-as-a-judge：模型评审 | 9.7 | 完整 | LLM-as-a-judge |
| 第 22 章 | Self-consistency：自洽投票 | 7.6 | 完整 | Self-consistency |
| 第 23 章 | CaMeL：能力隔离防注入 | 11.5 | 完整 | CaMeL |
| 第 24 章 | AgentDojo：注入攻击评测 | 11.7 | 完整 | AgentDojo |
| 第 25 章 | InjecAgent：间接注入基准 | 11.7 | 完整 | InjecAgent |
| 第 26 章 | PromptInject：提示注入系统化 | 11.2 | 完整 | PromptInject |

## STD · 标准、规范与治理框架

*版本随正文标注。合规映射只写可执行条款，不抄条文。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1 章 | OpenTelemetry GenAI spans | 10.3 | 完整 | OTel GenAI spans |
| 第 2 章 | OpenTelemetry MCP attributes | 10.3 | 完整 | OTel MCP attributes |
| 第 3 章 | W3C Trace Context | 10.2 | 完整 | W3C Trace Context |
| 第 4 章 | NIST AI RMF 1.0 | 12.6 | 完整 | NIST AI RMF |
| 第 5 章 | NIST 生成式 AI Profile | 12.6 | 完整 | NIST GenAI Profile |
| 第 6 章 | ISO/IEC 42001 | 12.6 | 精选 | ISO/IEC 42001 |
| 第 7 章 | EU AI Act | 12.6 | 精选 | EU AI Act 时间表 |
| 第 8 章 | OWASP LLM Top 10 | 11.1 | 完整 | OWASP LLM Top 10 |
| 第 9 章 | SLSA | 11.4 | 精选 | SLSA |
| 第 10 章 | Sigstore | 11.4 | 精选 | Sigstore |
| 第 11 章 | SPDX 与 CycloneDX | 11.4 | 精选 | SPDX/CycloneDX |
| 第 12 章 | OAuth 2.1 | 2.8 | 完整 | OAuth 2.1 |
| 第 13 章 | RFC 8707 Resource Indicators | 2.8 | 完整 | RFC 8707 |
| 第 14 章 | RFC 9728 Protected Resource Metadata | 2.8 | 完整 | RFC 9728 |
| 第 15 章 | JSON Schema 2020-12 | 2.2 | 完整 | JSON Schema 2020-12 |
| 第 16 章 | MCP Security Best Practices | 11.5 | 完整 | MCP Security Best Practices |

## MAN · Linux man-pages 与 Bash 手册（回归清单）

*Linux 6.8 / bash 5.2 / groff man-pages。只写 agent 沙箱与观测会用到的边界；五条历史错误必须在正文或附录 B 纠正。*

| 原书章节 | 标题 | 本书落点 | 程度 | 备注 |
|:--|:--|:--|:--|:--|
| 第 1–2 章 | wait(2) 与 waitpid(2) … WIFEXITED 与 WEXITSTATUS | 3.2 | 完整 | wait status 与 WEXITSTATUS，示例 0x2a00 |
| 第 3 章 | clone(2) 的可变参数顺序 | 4.6 | 完整 | clone 可变参数 parent_tid→tls→child_tid |
| 第 4 章 | mq_open(3) 的可变参数原型 | 8.3 | 完整 | mq_open variadic 原型 |
| 第 5 章 | sem_open(3) 的可变参数原型 | 8.5 | 完整 | sem_open variadic 原型 |
| 第 6 章 | tzset(3) 与 TZ 空值 | 10.7 | 完整 | TZ 空值/无法解释/tzdata 缺失均为 UTC |
| 第 7 章 | bash pipefail 与 PIPESTATUS | 3.2 | 完整 | pipefail 与 PIPESTATUS |
| 第 8 章 | ulimit 软限制与硬限制 | 3.5 | 完整 | ulimit 软/硬限制 |
| 第 9 章 | jobs 作业表与作业控制 | 13.6 | 完整 | jobs 作业表 |
| 第 10 章 | seccomp(2) | 4.3 | 完整 | seccomp(2) |
| 第 11 章 | landlock(7) | 4.4 | 完整 | landlock(7) |
| 第 12 章 | user_namespaces(7) | 4.5 | 完整 | user_namespaces(7) |
| 第 13 章 | openat2(2) | 3.3 | 完整 | openat2(2) |
| 第 14 章 | cgroup v2 | 3.5 | 完整 | cgroup v2 |
| 第 15 章 | capabilities(7) | 4.2 | 完整 | capabilities(7) |
| 第 16 章 | pidfd_open(2) | 3.2 | 完整 | pidfd_open(2) |

## A.2 覆盖统计

| 母本 | 单元数 | 完整 | 精选 | 背景 | 交叉引用 | 淘汰 | 缺口 |
|:--|--:|--:|--:|--:|--:|--:|--:|
| L2 | 19 | 0 | 1 | 4 | 14 | 0 | 0 |
| L3 | 15 | 0 | 0 | 11 | 4 | 0 | 0 |
| L5 | 6 | 0 | 0 | 1 | 5 | 0 | 0 |
| DL | 9 | 0 | 0 | 9 | 0 | 0 | 0 |
| MCP | 30 | 20 | 9 | 1 | 0 | 0 | 0 |
| OAI | 11 | 10 | 1 | 0 | 0 | 0 | 0 |
| OCI | 15 | 12 | 3 | 0 | 0 | 0 | 0 |
| PAPER | 26 | 16 | 5 | 5 | 0 | 0 | 0 |
| STD | 16 | 11 | 5 | 0 | 0 | 0 | 0 |
| MAN | 16 | 16 | 0 | 0 | 0 | 0 | 0 |
| **合计** | **163** | **85** | **24** | **31** | **23** | **0** | **0** |

逐单元统计：完整 85、精选 24、背景 31、交叉引用 23、淘汰 0、缺口 0。

## A.3 不重写声明

| 主题 | 已由谁覆盖 | 本书只做什么 |
|:--|:--|:--|
| 进程、信号、IPC、socket、epoll | Linux 卷第 2 篇 | 在沙箱边界处引用；写清 wait status、进程组、超时与退出码 |
| namespace、cgroup、seccomp、容器 | Linux 卷第 3/5 篇 | 组合成 code agent 的沙箱；补 capability/landlock 的次序与陷阱 |
| TCP/IP、DNS、HTTP | Linux 卷第 4 篇 | 只写 egress 策略、代理与 DNS 重绑定风险 |
| 神经网络、注意力、训练 | 《深度学习导论》 | 只引用 token/上下文/成本等工程含义 |
| 云原生编排 | Linux 卷第 5 篇 | 只写 agent 平台的最小权限与审计落点 |

## A.4 缺口补记

本版从映射表生成时即要求「缺口 0」，没有事后补记。若后续规范改版（例如 MCP 再发新版），先改 `写作规范/source-toc/` 与 `tools/build_coverage.py` 的 `SOURCES`，再重跑本脚本；缺口非零时脚本会拒绝写出页面。

> 复核命令：`python3 tools/build_coverage.py && python3 tools/check_book.py`。
