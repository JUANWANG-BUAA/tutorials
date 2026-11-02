# 全书知识地图

这本书有一条主线，十六条章不是并列的专题，而是这条线上的十六个站。**测量方法**（第 1 章）先立起来，然后依次问：数据在内存里怎么摆（2）、谁拥有它（3）、编译器把这些事实降成了什么（4–6）、多个执行流怎样共享它们（7–12）、最后怎么把「感觉快了」变成能守住的证据（13–14），并在两个项目里走完一遍（15–16）。

读任何一章之前，先用这张图确认前一环有没有断。图上每个方框写着该章的枢纽概念；箭头指向的是「下一环默认你已经懂了什么」。

<figure>
<svg aria-labelledby="fig-bookmap-title fig-bookmap-desc" role="img" font-size="12.5" height="500" viewBox="0 0 920 500" width="920" xmlns="http://www.w3.org/2000/svg">
<title id="fig-bookmap-title">全书十六章正文的概念链条地图（第 17 章把这条链收进一个项目）</title>
<desc id="fig-bookmap-desc">四条泳道对应四篇：第一篇数据与编译器（1 测量方法、2 对象布局、3 所有权、4 编译器分层证据）；第二篇优化与并发（5 泛型与 dyn、6 LLVM 与 CTFE、7 原子与内存序、8 async 底座）；第三篇高性能运行系统（9 执行器与背压、10 进程与 IPC、11 无锁与回收、12 向量化与零拷贝）；第四篇证据与项目（13 profiling 归因、14 构建身份与门禁、15 项目一、16 项目二）。每条泳道内箭头从左到右，泳道之间用折线箭头连接；另有一条红色虚线沿左侧向下，表示第 1 章的测量方法贯穿后续各章，图中指向第 13 章。</desc>
<defs>
<marker id="bm-arr" markerHeight="9" markerWidth="9" orient="auto" refX="7" refY="3"><path d="M0,0 L7,3 L0,6 Z" fill="var(--muted)"></path></marker>
</defs>
<g font-weight="600" fill="var(--muted)">
<text x="10" y="46">第一</text>
<text x="10" y="62">篇</text>
<text x="10" y="166">第二</text>
<text x="10" y="182">篇</text>
<text x="10" y="286">第三</text>
<text x="10" y="302">篇</text>
<text x="10" y="396">第四</text>
<text x="10" y="412">篇</text>
</g>
<g text-anchor="middle">
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="188" x="42" y="28"></rect><text fill="var(--fig-blue)" x="136" y="47">1 测量方法</text><text fill="var(--fig-neutral)" x="136" y="64">可观察集合 · 批均值</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="188" x="250" y="28"></rect><text fill="var(--fig-blue)" x="344" y="47">2 对象</text><text fill="var(--fig-neutral)" x="344" y="64">布局 · 热字段 · niche</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="188" x="458" y="28"></rect><text fill="var(--fig-blue)" x="552" y="47">3 所有权</text><text fill="var(--fig-neutral)" x="552" y="64">借用 · Drop · unsafe 边界</text>
<rect fill="color-mix(in srgb, var(--fig-blue) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-blue) 45%, transparent)" width="188" x="666" y="28"></rect><text fill="var(--fig-blue)" x="760" y="47">4 rustc 分层证据</text><text fill="var(--fig-neutral)" x="760" y="64">MIR · THIR · IR · asm</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="188" x="42" y="148"></rect><text fill="var(--fig-green)" x="136" y="167">5 泛型与 dyn</text><text fill="var(--fig-neutral)" x="136" y="184">单态化 · 去虚化</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="188" x="250" y="148"></rect><text fill="var(--fig-green)" x="344" y="167">6 LLVM 与 CTFE</text><text fill="var(--fig-neutral)" x="344" y="184">优化可见边界</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="188" x="458" y="148"></rect><text fill="var(--fig-green)" x="552" y="167">7 原子与内存序</text><text fill="var(--fig-neutral)" x="552" y="184">Acquire · Release · Relaxed</text>
<rect fill="color-mix(in srgb, var(--fig-green) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-green) 45%, transparent)" width="188" x="666" y="148"></rect><text fill="var(--fig-green)" x="760" y="167">8 async 底座</text><text fill="var(--fig-neutral)" x="760" y="184">状态机 · 轮询 · 取消</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="188" x="42" y="268"></rect><text fill="var(--fig-gold)" x="136" y="287">9 执行器与背压</text><text fill="var(--fig-neutral)" x="136" y="304">Tokio · 公平性 · 有界</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="188" x="250" y="268"></rect><text fill="var(--fig-gold)" x="344" y="287">10 进程与 IPC</text><text fill="var(--fig-neutral)" x="344" y="304">管道 · 输出背压 · 回收</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="188" x="458" y="268"></rect><text fill="var(--fig-gold)" x="552" y="287">11 无锁与回收</text><text fill="var(--fig-neutral)" x="552" y="304">ABA · epoch · hazard</text>
<rect fill="color-mix(in srgb, var(--fig-gold) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-gold) 45%, transparent)" width="188" x="666" y="268"></rect><text fill="var(--fig-gold)" x="760" y="287">12 向量化与零拷贝</text><text fill="var(--fig-neutral)" x="760" y="304">SIMD · I/O 边界</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="188" x="42" y="388"></rect><text fill="var(--fig-purple)" x="136" y="407">13 profiling 归因</text><text fill="var(--fig-neutral)" x="136" y="424">热栈 · 可反驳的结论</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="188" x="250" y="388"></rect><text fill="var(--fig-purple)" x="344" y="407">14 构建身份与门禁</text><text fill="var(--fig-neutral)" x="344" y="424">Cargo · 三态发布</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="188" x="458" y="388"></rect><text fill="var(--fig-purple)" x="552" y="407">15 项目一</text><text fill="var(--fig-neutral)" x="552" y="424">agent runtime 协议</text>
<rect fill="color-mix(in srgb, var(--fig-purple) 14%, transparent)" height="44" rx="9" stroke="color-mix(in srgb, var(--fig-purple) 45%, transparent)" width="188" x="666" y="388"></rect><text fill="var(--fig-purple)" x="760" y="407">16 项目二</text><text fill="var(--fig-neutral)" x="760" y="424">组件与最小 C ABI</text>
</g>
<g fill="none" marker-end="url(#bm-arr)" stroke="var(--muted)" stroke-width="1.4">
<path d="M230,50 L250,50"></path>
<path d="M438,50 L458,50"></path>
<path d="M646,50 L666,50"></path>
<path d="M760,72 L760,110 L136,110 L136,148"></path>
<path d="M230,170 L250,170"></path>
<path d="M438,170 L458,170"></path>
<path d="M646,170 L666,170"></path>
<path d="M760,192 L760,230 L136,230 L136,268"></path>
<path d="M230,290 L250,290"></path>
<path d="M438,290 L458,290"></path>
<path d="M646,290 L666,290"></path>
<path d="M760,312 L760,350 L136,350 L136,388"></path>
<path d="M230,410 L250,410"></path>
<path d="M438,410 L458,410"></path>
<path d="M646,410 L666,410"></path>
</g>
<g fill="none" marker-end="url(#bm-arr)" stroke="var(--fig-red)" stroke-dasharray="5 4" stroke-width="1.4">
<path d="M136,72 L136,88 L32,88 L32,410 L42,410"></path>
</g>
<text fill="var(--fig-red)" font-size="11.5" x="150" y="84">虚线：第 1 章的测量方法贯穿后续各章（这里指向第 13 章）</text>
</svg>
<figcaption>图 0-1 · 十六章正文一条主线：先会测量，再看对象与所有权，再问编译器给了什么，然后处理并发与运行系统，最后回到证据与项目。第 17 章不在这条链上——它把这十六章收进同一个代码仓库。</figcaption>
</figure>

## 逐环说明：每一章默认你已经懂了什么

| 章 | 依赖前一环的哪件具体东西 | 断了会在哪道题上卡住 |
|:--|:--|:--|
| [1](part1/ch01.md) | 无（起点） | — |
| [2](part1/ch02.md) | 批均值口径与实验契约（[定义 1.2.2](part1/ch01.md#def-1.2.2)、[定义 1.1.3](part1/ch01.md#def-1.1.3)） | 读不懂「热列扫描的实测边界」里为什么不能横向比 |
| [3](part1/ch03.md) | 布局与大小（第 2 章）、可观察集合（[定义 1.1.1](part1/ch01.md#def-1.1.1)） | 判断不了 move 与 clone 的成本差别是否真的发生 |
| [4](part1/ch04.md) | 所有权事实（第 3 章）、DCE（[定义 1.1.1](part1/ch01.md#def-1.1.1)） | MIR/IR 对照时不知道自己在看哪一层 |
| [5](part2/ch05.md) | 分层证据链（第 4 章） | 说不清单态化与去虚化各自改变了什么 |
| [6](part2/ch06.md) | 优化可见性（第 5 章）、屏障（[定义 1.3.1](part1/ch01.md#def-1.3.1)） | 把 `const fn` 的编译期结果当成运行期收益 |
| [7](part2/ch07.md) | 代码生成边界（第 4、6 章） | 内存序的选择变成背口诀 |
| [8](part2/ch08.md) | 借用与生命周期（第 3 章）、原子（第 7 章） | 读不懂状态机为什么需要自引用 |
| [9](part3/ch09.md) | async 底座（第 8 章）、配对实验（[定义 1.4.1](part1/ch01.md#def-1.4.1)） | 无法区分「调度不公平」与「真的慢」 |
| [10](part3/ch10.md) | 资源与取消（第 9 章） | 找不到管道背压的观测点 |
| [11](part3/ch11.md) | 内存序（第 7 章）、回收义务（第 3 章） | 比较无锁与锁时只看到吞吐看不到代价 |
| [12](part3/ch12.md) | 布局（第 2 章）、向量化证据（第 6 章） | 把零拷贝的宣传当成实际拷贝次数 |
| [13](part4/ch13.md) | 第 1 章全部 + 任一章的机制结论 | 从热栈直接跳到「就是这个函数慢」 |
| [14](part4/ch14.md) | 三态门禁（[定义 1.7.2](part1/ch01.md#def-1.7.2)）、构建配置（第 4 章） | 门禁只挡得住噪声，挡不住回归 |
| [15](part4/ch15.md) | 第 8–10 章 + 第 14 章 | 协议写不出取消与有界的验收条件 |
| [16](part4/ch16.md) | 第 2–4 章 + 第 14 章 | FFI 边界上的所有权与布局责任分不清 |
| [17](part4/ch17.md) | 全部十六章各出一块零件（布局 2、所有权 3、代码生成 4、分派 5、优化 6、原子 7、异步 8、调度 9、进程 10、回收 11、向量化 12、归因 13、门禁 14） | 六条不变量写不出测试，或基准的输入家族没定，结论无法落地 |

## 一条贯穿的因果句式

十七章反复练习的其实是同一句话的十七种填法：

> 在〔输入家族 + 环境 + 构建〕下，〔被测对象〕的〔指标〕是〔数值与不确定度〕，因为〔机制证据〕；本结论不覆盖〔限制〕。

前四章教你填前两格，中间八章教你填「机制证据」，最后五章（13–17）教你把整句话变成别人能复核、机器能守住的规则；第 17 章要求你亲手把这句话填完一次。填不出「机制证据」那一格，就是还在背结论。

## 断点自测

不确定自己从哪章开始，先花 15 分钟做[入学诊断自测](entry-test.md)。已经知道自己缺什么的，按下表直接去补：

| 你的症状 | 缺的是 | 先补 |
|:--|:--|:--|
| 看到 `0.000016 ns/元素` 不觉得奇怪 | 测量方法 | [1.1](part1/ch01.md#sec-cpp-rust.1.1.1)、[1.5](part1/ch01.md#sec-cpp-rust.1.1.5) |
| 说不清一个结构体在内存里怎么摆 | 布局 | [2.1](part1/ch02.md#sec-cpp-rust.1.2.1)、[2.2](part1/ch02.md#sec-cpp-rust.1.2.2) |
| 一到 `&str`、`Vec`、`Drop` 就靠试 | 所有权 | [3.1](part1/ch03.md#sec-cpp-rust.1.3.1)、[先修工具箱](prerequisite.md) |
| 看不懂 `cargo rustc -- --emit=mir` 的输出 | 编译器分层 | [4 章](part1/ch04.md) |
| 分不清 `SeqCst` 和 `Acquire` 何时该选 | 并发语义 | [7 章](part2/ch07.md) |
| async 任务不被调度只能加 `yield_now` | 执行器 | [8 章](part2/ch08.md)、[9 章](part3/ch09.md) |
| profiler 一堆栈不知道先改哪个 | 归因方法 | [13 章](part4/ch13.md) |
| 门禁要么全红要么全绿 | 判定设计 | [1.7](part1/ch01.md#sec-cpp-rust.1.1.7)、[14 章](part4/ch14.md) |
