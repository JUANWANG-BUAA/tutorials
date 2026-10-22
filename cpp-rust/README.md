# 《Rust 底层性能工程》

本书沿用目录 slug `cpp-rust`。遵循最新方向，全书聚焦 **Rust 底层性能工程**（rustc/HIR/THIR/MIR/LLVM、对象布局与 niche、所有权借用与 unsafe 证明、原子与内存序、无锁数据结构与代际回收、Future 编译与 Tokio 多任务调度、进程隔离与管道背压、SIMD 向量化与零拷贝、系统性能采样 profiling 与 Cargo CI 门禁），附带两个可执行的工业级实战项目（有界 Agent 工具执行器 `agent-runtime` 与高性能跨语言组件 `ffi-bridge`）。C/C++ 仅用于提供必要的跨语言 FFI 契约与 CMake 静态链接构建支持。

全书 16 章正文均已全部完成，每章 1000–1500 行，包含完整的类型/布局表、代码生成/ABI 表、可编译运行的基准测试、微架构时钟与方差统计、对象/并发架构图、以及至少 12 条深度工程陷阱与出口检查。

## 全书架构与 16 章全景

### 第一篇：数据与编译器（第 1–4 章）
- **[第 1 章 测量：让编译器、时钟与回归预算说同一种话](src/part1/ch01.md)**：观测开销、死代码消除（DCE）防线、优化屏障 `black_box`、配对采样、时钟漂移、置信区间与性能门禁。
- **[第 2 章 对象：布局、热字段与可证明的存储复用](src/part1/ch02.md)**：结构体对齐、字段重排、空位枚举 niche 优化、缓存行利用、SoA/AoS 转换与定制 Arena 分配器。
- **[第 3 章 所有权：借用、初始化、销毁与unsafe证明边界](src/part1/ch03.md)**：借用的优化语义、未初始化内存防御、Drop flag 与析构展开、指针来源（Provenance）与内存安全证明清单。
- **[第 4 章 从所有权事实到机器码：rustc 的分层证据](src/part1/ch04.md)**：rustc 编译流水线全解（HIR、THIR、MIR、borrowck、Drop elaboration、代码生成单元 CGU 与查询驱动模型）。

### 第二篇：优化与并发（第 5–8 章）
- **[第 5 章 泛型、trait 对象与优化可见性](src/part2/ch05.md)**：单态化膨胀代价、虚表非稳定布局、去虚化触发条件、局部已知 dyn 分派粒度优化。
- **[第 6 章 LLVM、CTFE 与可验证的优化边界](src/part2/ch06.md)**：别名分析属性、循环向量化、编译期求值（CTFE）与 Miri 未定义行为检测、ThinLTO 与 PGO 调优。
- **[第 7 章 并发、原子与内存序：从同步证明到缓存行竞争](src/part2/ch07.md)**：双向 happens-before 证明、AArch64 `ldapr`/`casal` 汇编生成、单槽 SPSC 无锁通道与 128 字节缓存行伪共享消除。
- **[第 8 章 异步的编译器底座：Future、Pin、poll 与唤醒协议](src/part2/ch08.md)**：协程状态机实际 MIR 产物、跨 await 变量存活期、Pin 结构体内存自引用防御、唤醒丢失回归与零分配栈调度。

### 第三篇：高性能运行系统（第 9–12 章）
- **[第 9 章 多任务执行器、Tokio、背压与公平性](src/part3/ch09.md)**：Tokio 1.54.0 核心状态字机理、任务运行权与通知排队、工作窃取（Work-Stealing）微架构开销、阻塞 poll 延迟污染重现与许可生命周期。
- **[第 10 章 多进程、IPC、输出背压与异常回收](src/part3/ch10.md)**：24 字节显式二进制线协议、持久 worker 复用、双管道并发排空与有限日志保留、直接子进程超时 kill/wait 与写端继承隔离。
- **[第 11 章 无锁数据结构、ABA问题与内存回收机制](src/part3/ch11.md)**：非阻塞进度保证分级、线性化点判定、128 位标记指针与 ABA 根因、代际回收（EBR）三纪元数学证明与停顿参与者内存雪崩。
- **[第 12 章 向量化、零拷贝数据流与异步I/O边界](src/part3/ch12.md)**：ARM64 NEON 128 位向量车道与 LLVM 自动向量化 7.7x 吞吐实测、借用切片分帧零拷贝 3.6x 提升、Linux io_uring 共享内存环与完成型 Buffer 所有权契约。

### 第四篇：证据与项目（第 13–16 章）
- **[第 13 章 Profiling：从热栈到可以反驳的归因](src/part4/ch13.md)**：CPU On/Off 采样分母核算、内核栈与用户栈、火焰图失真分析、插桩微架构扰动与 macOS sample/Linux perf 边界。
- **[第 14 章 Cargo、构建身份与性能发布门禁](src/part4/ch14.md)**：Cargo 特性图解析、可复现构建位级确定性、CGU 与 ThinLTO 权衡、自动化性能回归与 CI 阻断门禁。
- **[第 15 章 项目一：有界agent工具runtime的资源与取消协议](src/part4/ch15.md)**：工业级多任务 Agent 工具执行系统实战，包含不可变工具注册、Q/C/Q+C 有界准入、原子 CLOEXEC 管道捕获、确定性超时与直接进程回收。
- **[第 16 章 项目二：Rust 高性能组件与最小 C ABI](src/part4/ch16.md)**：无裸指针外泄的代际句柄注册表、Rust 与 C11 原生程序双向测试、C11 CMake/CTest 自动化测试套件与批量 FFI 吞吐基准。

### 附录
- **[母本逐节台账与全书覆盖](src/appendix/coverage.md)**：16 份母本（7 本 C++、7 本 Rust、1 本 C 现代方法、1 本 CMake）全部 2,827 个原生与人工目录项逐节裁决，550 条已核读映射记录。

---

## 两个可执行实战项目

### 项目一：`projects/agent-runtime`
基于真实 Tokio 多线程运行时与进程驱动的高性能安全 Agent 工具执行引擎。
- 杜绝任意 shell 字符注入，仅支持预先 canonicalize 的安全命令或类型化 helper；
- 建立 $Q$ 队列、$C$ 并发与 $Q+C$ 强背压许可模型，在任务构造前同步拒绝过载；
- 独创针对 macOS std 管道竞争的原子 `pipe2(O_CLOEXEC)` 捕获机制（`src/process_macos.rs`），杜绝并发创建进程时的输出端点死锁；
- 18 项集成与回归测试全部通过，包含 800 条高并发压力测试与 8 组对抗性描述符注入校验。

### 项目二：`projects/ffi-bridge`
Rust 核心算法与 C11 客户端的高性能桥接体系。
- 核心算法、数据分配与代际注册表完全置于安全 Rust 之内，对外仅暴露标量或受控的 64 位代际句柄（`handle: u64`），严禁裸数据指针外泄；
- 包含代际回绕防范（`u32::MAX` 退休不回绕）、并发释放线性化原子操作、与 `catch_unwind` 异常防御边界；
- 配套包含完整的 C11 测试套件、跨边界 benchmark 驱动与 CMakeLists.txt，CTest 4/4 项全部自动化通过。

---

## 独立实验基准套件（`bench/`）

本书的所有性能数据均建立在真实编写、编译并实际执行的独立 Rust 实验套件之上：
- `bench/`：无第三方依赖的原生原子与 Future 基准；
- `bench/runtime-lab/`：基于 Tokio 1.54.0 的调度粒度、阻塞 poll 污染、IPC 往返与管道排空评测；
- `bench/foundations-lab/`：死代码消除防线、借用工作量、未初始化区域分配评测；
- `bench/compiler-lab/`：移动成本、Drop 分支、分派粒度、向量化与编译期计算（CTFE）查表评测；
- `bench/systems-lab/`：无锁队列与互斥锁队列 4 线程 MPMC 对决、EBR 停顿参与者内存积压评测、ARM NEON 向量化评测、零拷贝分帧解析评测；
- `bench/evidence-lab/`：真实 CPU 与 Waiting 栈采样对比、逐项插桩观测扰动评测、CGU 与 ThinLTO 构建耗时评测。

所有基准测试均遵循科学评测范式：至少 500ms 交替预热、每配置正式采集 21 个独立批次、交替轮换测试顺序、计算 $N-1$ 样本标准差与 nearest-rank 离散分位数。

---

## 自动化质量保障与严格发布门禁

本书建立了端到端的全自动化质检与不可变审计闭环体系：

```bash
# 进入 cpp-rust 目录
cd cpp-rust

# 1. 章节结构契约检查 (验证行数、H1/H2 结构、锚点唯一性、图表与陷阱)
python3 tools/check_book.py

# 2. 统计报告 (输出 16 章的行数、标题、代码块与陷阱明细)
python3 tools/audit_stats.py

# 3. 原始实验数据与源码快照比对
python3 tools/verify_evidence.py

# 4. 描述符继承竞争与修复验证
python3 tools/verify_drain_fix.py

# 5. 连续两轮独立全章节审计验证
python3 tools/verify_audits.py

# 6. 全书发布级严格门禁检查 (编译所有包、跑完所有测试、构建全书 HTML)
python3 tools/verify_all.py --release
```

执行 `python3 tools/verify_all.py --release` 即可验证全书达到正式发布标准：
`RELEASE GATES PASSED: All 16 chapters, 2 executable projects, 550 source ledger records, and 2 independent audit rounds verified.`
