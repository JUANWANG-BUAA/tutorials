# Tokio调度与进程实验

这是本书第9–10章的可执行实验包，不是完整agent runtime或工具沙箱。
Tokio精确固定为1.54.0，锁文件纳入记录。使用Rust2021，release启用opt-level=3、debug=1、codegen-units=1、lto=false。

## 构建

```bash
cargo test --offline --locked --manifest-path bench/runtime-lab/Cargo.toml
cargo clippy --offline --locked --manifest-path bench/runtime-lab/Cargo.toml --all-targets -- -D warnings
cargo build --offline --locked --release --manifest-path bench/runtime-lab/Cargo.toml
```

命令从`cpp-rust/`运行。首次获取依赖需要可信联网环境；本机依赖已缓存，所以使用offline。
依赖feature包含rt、rt-multi-thread、sync、time、process、io-util、macros；`join!`也依赖macros feature。

## 四个benchmark

| 入口 | 实际工作 | 样本单位 |
|:--|:--|:--|
| scheduling | 128任务，每任务8192步；current/multi4，16/1024步后yield | 每批聚合ns/step |
| blocking-poll | current-thread中20ms睡眠放在poll或阻塞闭包 | 单次通知可用到恢复的ns |
| process-rpc | 每请求spawn或复用ready worker；每批16请求 | 每批ns/request |
| pipe-drain | 每流2MiB，两流并发排空；每流保存128字节或全部2MiB | 每批ns/输出字节 |

每case正式21次；后三种按交替顺序，scheduling按轮转顺序运行。
scheduling预热至少500ms；其余三个入口现在对每种配置各预热至少500ms。
pipe-drain还核验全部保留字节均为`x`，校验在Report计时边界之后。
所有benchmark进程顺序执行，不并行压测。
统计复用`performance-lab`的N-1标准差与nearest-rank分位数。

`blocking-poll`中的42个原始值是单次通知观察，其他168个是批均值。
小样本p99不能作为生产尾延迟承诺。

## helper与协议

`lab-worker`与process-rpc、pipe-drain必须放在同一可执行文件目录。
helper的rpc模式先发送8字节握手，再接受显式little-endian的24字节帧。
帧包含版本、标志、长度、request id和value，不使用结构体内存转储。

helper的flood/sleep/fail/inherit模式仅为受信任回归夹具。
inherit模式故意让一个短寿命后代继承写端，以证明直接child退出不等于输出EOF。
它不实现进程树清理。测试留出收尾窗口，但不把固定等待当成已观察后代退出。

## 直接子进程组件

`src/process.rs::run_child`提供：

- 空stdin，两个piped输出，并发排空。
- 每流固定前缀、已排空总字节计数和EOF状态。
- PID、reap与读者启动/进展/EOF/Drop时间、poll/Pending/read次数及原始I/O错误诊断。
- macOS使用`pipe2(O_CLOEXEC)`避免并行spawn意外继承写端；需要macOS 27+，不支持时明确报错。
- wait阶段期限；到期start_kill再wait。
- 独立输出grace；到期abort并观察reader取消。
- reader包装器Drop请求abort，避免外层取消后默认detach。

成功返回Report时直接子进程已wait；业务可以非零退出。
外层Future被取消时只剩Drop路径，不承诺相同的及时reap保证。
kill_on_drop是后备策略，不替代正常路径的显式wait。
期限不是硬实时总时长；spawn、kill后等待和排空还需要收尾预算。

没有：stdin流式输入、任意工具执行安全策略、进程树终止、CPU/内存配额、多worker进程池、共享内存实现。
固定cap控制保留内容长度，不是整个进程RSS上限，也不会达到cap就终止工具。

## 测试

3项线协议测试、3项管道标志/取消所有权单元测试（macOS），以及12项集成测试：
有界通道、取消析构、阻塞许可寿命、panic观察、双流排空、直接child超时、非零退出、
spawn失败、先wait停滞、参数拒绝、继承写端grace、复用Command后父写端释放。

完整预览曾有一次并行排空/EOF断言失败，旧日志与旧源码指纹保留不动。
现在通过受控交错证实：std的macOS pipe/fcntl窗口允许无关并发spawn继承写端，
其两秒后代会阻止EOF。原子pipe2路径通过同一交错回归，原断言与grace未放宽。
双profile、双流、flood/timeout的旧版失败及修复证据在`bench/results/runtime-fixed/`。
原失败日志无描述符证据，因此不能反推那一次事故的唯一原因；父级仍负责finding裁决。
复现方法、版本限制及诊断解释见[diagnostics/README.md](diagnostics/README.md)。
`process_stress`现每轮记录80条完整Report：60个flood、10个timeout、10个预期继承写端。
测试通过不是全交错证明。未运行Miri、TSan或Loom。

## 证据复验

```bash
bash tools/run_runtime_benchmarks.sh bench/results/new-runtime-run
python3 tools/verify_evidence.py
```

第一条命令生成新的环境、原始数据、测试、源码指纹、IR与汇编，不覆盖归档。
第二条核验书中正式归档`runtime-final`及前章`local`，并非自动把任意新运行认定为书中基线。
本机Apple M5 Pro / aarch64-apple-darwin / Rust1.99.0，未锁核、锁频或隔离热状态。

`runtime-local`是早期试跑；原正式统计使用`runtime-final`，该目录的`source-snapshot`保留实测旧源码。
`runtime-fixed`保存修复后的正确性证据；不能把旧版数值冒称为修复后源码实测。
调度器与父进程sample分别另行采集，不混入正式计时。
macOS采样不是Linux perf，也不是系统所有子进程的聚合CPU追踪。
