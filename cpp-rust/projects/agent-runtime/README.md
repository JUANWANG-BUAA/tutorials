# agent-runtime：有界命名工具执行器

这是项目一的独立 Cargo 包，不依赖 `bench/runtime-lab`。
它使用 Tokio 1.54.0 的真实多线程运行时、进程和计时器 driver；不是把单 Future `block_on` 包装成 runtime。
业务调度层使用安全 Rust；macOS 捕获模块含逐处写明契约的有限 unsafe（dlsym、pipe2 与 OwnedFd 构造），不是“全安全 Rust”项目。
项目治理的资源是**直接子进程**，不是任意进程树。

## 可运行范围

- 不可变命名注册表：`Registry::helper` 暴露随项目构建的 helper；`Registry::fixed` 暴露管理员预先固定的命令和参数。
- helper 提供原样 echo、双路日志、有限 sleep、指定非零退出四种类型化操作。
- 请求不能指定可执行文件、cwd、环境变量或 shell 命令。管理员配置路径先 canonicalize；CLI 只使用同目录 `tool-helper`。
- 子进程环境清空，cwd 为 `/`，stdin 关闭，stdout/stderr 以字节读取，不假设 UTF-8。
- macOS 捕获用动态探测的 `pipe2(O_CLOEXEC)` 原子创建两对管道，OwnedFd 管理所有权；spawn 后立即替换 Command 双路显式写端，避免父进程自己阻止 EOF。
- 不存在 pipe2 的旧 macOS 明确 Unsupported（结果为 SpawnFailed + cleanup_error），不回退到已证实有竞争的 pipe/fcntl，不用全局 spawn 锁。非 macOS 仍用标准库/Tokio 路径，未执行验证。
- `try_submit` 同步拒绝满载，先取得总准入许可再构造排队消息；不会为等待入队创建任务。
- 队列最多 Q 项，JoinSet 最多 C 项，准入许可最多 Q+C 个；C 的许可由任务成员身份表达，包含退出后排空。
- 每路只保留 R 字节前缀，但持续排空并对全部已读字节做 FNV-1a 校验。
- timeout 从成功提交的时间点计算，包含排队；运行超时/取消后发送 kill 并观察 wait，再排空剩余管道。
- `Ticket::cancel()` 是请求；`Ticket::wait().await` 返回的 `reaped` 才是直接子进程回收观察。
- 正常退出必须 `Runtime::shutdown().await`：关闭接收端、处理已接受工作、join 全部工作任务。

## 构建与 CLI

在本目录执行：

```bash
cargo build --offline --locked --bins
./target/debug/agent-runtime echo 'literal ; $HOME | $(not-a-command)'
./target/debug/agent-runtime logs 65536
./target/debug/agent-runtime sleep 5000 100
./target/debug/agent-runtime cancel 5000 100
./target/debug/agent-runtime fail 17
```

后三条正常返回退出码 1，因为分别产生 TimedOut、Cancelled、NonZero；不是示例失败。
成功退出码为 0；参数/准入/运行时观察错误为 2。
日志行包括 total、retained、checksum、eof、error；前缀以转义 Debug 字符串显示，避免终端控制字节直接生效。
`logs 65536` 的输出较长，因为默认保留每路8192字节；库调用可设置更小 R。
只安装主二进制而漏装同目录 helper，会在注册阶段明确失败，不回退到 PATH。

## 库 API

完整可运行调用例在 `examples/library.rs`：

```bash
cargo run --offline --locked --example library -- "$PWD/target/debug/tool-helper"
```

基本流程是：构造 Registry → Runtime::start → client.try_submit → ticket.wait → runtime.shutdown。
`Client` 可以克隆并供多个生产者调用，关闭后克隆句柄也只能收到 Closed。
调用者应在上游限制请求体；本库接收 owned Input，不能追溯性限制调用者已经分配的 String。
`Full` 是即时过载拒绝，不承诺自动重试或公平排队；调用者重试也必须有限。
若任务仍占用总准入许可，`Full` 可能先于 UnknownTool/InvalidInput；不要用错误优先级做鉴权。
`Ticket::started` 是 watch 当前状态观察，可能合并中间状态，不是不可丢失的事件日志。

`Registry::fixed` 适用于管理员审过的固定命令，例如固定 lint 或只读检查程序。
请求必须使用 `Input::Fixed`，不能覆盖固定 argv；需要动态参数的新工具应新增类型化 validator/adapter，而不是拼 shell 字符串。
环境为空且 cwd 为 `/` 是接口的一部分：需要环境或项目目录的命令不能不经适配直接使用。
管理员不应注册 shell/interpreter 去执行不可信字符串；本项目没有阻止管理员自己配置危险工具的沙箱。

## 结果与取消

`ToolResult` 将业务结局、pid、exit_code、reaped、两路 Log、队列时间、工作时间和清理错误分开。
Success 不自动代表日志完整；必须同时检查 eof/error/reaped/cleanup_error。
Unix 信号退出时 exit_code 可以是 None，不能据此判断进程还活着。
取消与自然完成竞争，select 观察先后决定结局，不承诺全局时间戳线性化顺序。
丢弃 Ticket 会登记取消，但不 abort 工作任务；不需要响应的请求仍由 dispatcher 完成回收。
显式 cancel 后再 wait 能保留清理结果；丢弃 Ticket 则主动放弃它。

排队取消/过期在 dispatcher 取得执行槽时检查，不创建每项排队计时任务。
因此排队请求可能超过自己的 deadline 才被观察为 TimedOut，但不会因此启动过期子进程。
运行超时不等于硬响应期限：kill/wait 仍依赖操作系统，不能安全地在 wait 未完成时假装回收成功。
如果内核 wait 失败，结果为 WaitFailed、reaped=false，并保留错误；kill_on_drop 只是兜底，不是观察证明。

## 明确不保证

- 不创建进程组、不杀后代、不治理 daemon、没有网络/文件系统/权限隔离。
- 后代可能继承管道写端；直接子进程回收后，drain_grace 限制 EOF 等待，超时保留前缀并记录 error，不声称后代已清理。
- 当前 macOS 27.0.1 ARM64 实测；旧 macOS Unsupported 分支未在旧实机运行。未运行 Windows/Linux、Miri、Loom、TSan、perf 或 io_uring。
- 外部 runtime 被强行销毁、进程被 SIGKILL、内存耗尽、内部任务 panic 不属于已证明的正常清理路径。
- Runtime::Drop 只发出停止接收请求，不会同步 join；必须在外层 Tokio runtime 仍活着时 await shutdown。
- 队列与运行中资源有界，不限制用户长期保存的已完成 Ticket/ToolResult，也不限制 Client 克隆数。
- 日志总字节不限，CPU/I/O 总消耗依赖 deadline；FNV-1a 是实验完整性校验，不是密码学认证。

## 测试

```bash
cargo fmt --check
cargo clippy --offline --locked --all-targets -- -D warnings
cargo test --offline --locked
```

macOS 有2项单元测试：pipe2两端原子CLOEXEC标志、保持Command存活的两次捕获复用及两次spawn失败。
`tests/contracts.rs` 有14项测试，覆盖双路大输出、原样参数、满载、排队取消、超时回收、排队期限、非零退出、正常 shutdown、丢弃 ticket、运行槽生命周期、注册拒绝、输入预算、spawn 失败、固定命令与有意标准流继承。
`tests/regressions.rs` 保留原2项：安全复现串行排空死锁趋势后 kill+wait 恢复，以及真实 CLI 四种结局/退出码和usage。
负对照不执行 UB，不留下阻塞读任务，也不留下未 wait 的直接子进程。
删除后再 spawn 的失败测试使用临时可执行文件；未宣称覆盖可执行文件替换攻击。

完整默认并行重复验证与确定性交错：

```bash
bash diagnostics/validate_capture.sh evidence/my-new-validation
```

最终记录是 `evidence/capture-fix-final-validation-02/`：debug/release各10轮cargo test，每轮18项，合计360项通过；各5轮八独立Runtime并发stress，每轮80条，合计800条结果（640 logs、80 timeout、80 cancel），全部检查reaped/EOF及预期Outcome。
两profile另各4个dyld gate交错，分别暂停stdout/stderr的真实pipe2返回，窗口内启动无关null标准流helper及后代；精确PID的lsof证明无额外PIPE，gate双端flags=1。
这是已证明std macOS pipe/fcntl竞争的项目级回归，不是靠更多worker或更长grace掩盖。
有意fd1/fd2继承仍触发原30ms测试grace；默认生产grace仍1秒。
诊断细节、unsafe边界、复现命令见 `diagnostics/README.md`。

## 两项 benchmark 与归档

```bash
mkdir -p evidence
bash scripts/measure.sh evidence/my-new-run
```

必须使用不存在的输出目录；脚本拒绝覆盖归档。脚本在正式计时前构建、测试和导出 MIR/LLVM IR/原生 .s。
正式测量使用共享目录锁 `.work/cpp-rust-agents/measure.lock`；脚本退出时用 trap 释放。
不能并行执行计时进程；profiler 在另一个进程中单独采集，不混入原始样本。
每个 case 至少500ms预热，21个批次；`scripts/summarize.py` 独立校验样本索引、操作数、checksum，输出 N-1 标准差与 nearest-rank p50/p99。

1. `runtime-bench admission`：C=1、Q=1 的真实睡眠子进程和队列项占满预算；每批100000次拒绝尝试。结果为 ns/rejected-attempt，不是成功准入成本。
2. `runtime-bench lifecycle`：每批8个真实 helper，每个 stdout/stderr 各262144字节；比较 C1/R0、C1/R4096、C4/R4096。结果为 ns/tool 的批均值，不是逐请求延迟。

`evidence/run-04/` 是正文当前采用的原子捕获版归档：4case各21条，共84条；包含完整源快照/指纹、测试、布局、明确命名的六份MIR/LLVM IR/.s及另进程sample。
run-04开始快照没有观察到其他cargo/rustc构建进程，但桌面未隔离，lifecycle出现明显长批次，不承诺SLA。
旧 `run-01/` 的63条、`run-02/` 的84条及修复首轮 `run-03/` 的84条全部保留，不是当前正式数值。
修复前run-02全部12份源文件核对后已逐字节快照；run-01仍可取得的8/11份也保存，另3个已演进历史文件不伪造恢复。
run-03旧产物收集通配符混入target/deps旧版本，故最终脚本改为指定rustc输出路径，并完整重跑为run-04；run-03原始数据不删除。
两轮修复测量不构成配对净性能收益证明。章节第15章给出实际统计、强噪声和源版本边界。
这里只有实施者契约阅读、测试和机械复验，没有独立技术审计签核。
