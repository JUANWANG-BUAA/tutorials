# 并行管道EOF缺失的对抗回归

本目录是正确性诊断，不是benchmark，不输出延迟SLA。

## 已定位的机制

本机为macOS 27.0.1、Rust 1.99.0。当前标准库macOS的匿名管道实现仍先
`pipe()`，再分别对读、写端设置`FD_CLOEXEC`。并发的另一条spawn可以在该窗口
复制尚未标记的描述符；事后对父进程原描述符补标记，无法改变已复制到子进程的标志。
若这个无关子进程再启动两秒`sleep`后代，原flood或被杀的sleep退出后，后代仍持有写端，
读者因此读不到EOF。它可以发生在安全Rust中，不要求Tokio丢唤醒。

`pipe_gate.c`只暂停真实pipe/pipe2调用返回，不改数据和标志。
`descriptor_race`例程先初始化runtime，再arm。原生线程等到管道创建完成后，启动使用
null标准流的无关`inherit` helper；helper退出但其sleep后代继续存活。
`lsof`记录实际后代描述符，然后释放创建线程。分别选择stdout/stderr管道，运行flood和
30ms deadline的sleep。继承者使用null标准流，故观察到的额外PIPE不是正常的标准流继承。

macOS修复路径在`src/process_macos.rs`：动态查找系统`pipe2`并以`O_CLOEXEC`原子创建
两个管道，再把写端显式交给Command。`Command::spawn()`后必须立刻把Command持有的
写端替换为null，成功与失败均如此；否则父进程自己就会阻止EOF。Tokio持有、排空读端。
没有全局spawn锁，且未改变原deadline/grace。

macOS 27之前没有本路径要求的pipe2时返回`Unsupported`，不偷偷退回已知有竞争的方案。
本例程不是跨版本通用进程库；其他平台仍使用已有Tokio路径，未在本机执行验证。
直接使用`Command::spawn`的其他调用点仍受其平台实现约束；此修复仅承诺`run_child`的
捕获管道不会泄漏给无关并发spawn。正常通过fd 1/2继承到工具后代的写端仍然存在：
`inherited_writer_does_not_hang_drainers_forever`必须继续报告grace过期，不伪装EOF。

## 复现

从`cpp-rust/`执行，输出目录必须不存在：

```bash
bash bench/runtime-lab/diagnostics/reproduce_descriptor_race.sh bench/results/my-race-debug debug
bash bench/runtime-lab/diagnostics/reproduce_descriptor_race.sh bench/results/my-race-release release
bash bench/runtime-lab/diagnostics/validate_drain.sh bench/results/my-drain-validation
```

对抗脚本需要macOS 27 SDK、clang、允许对本地非系统可执行文件设置
`DYLD_INSERT_LIBRARIES`。这不是生产运行要求。每套四个交错都保留gate信息、lsof、
完整Report、退出码以及源码快照/指纹。`DRAIN_MANIFEST`可指定单独复制出的旧版本包，
不应修改已归档源码来做对照。旧实现四例预期都以原EOF断言失败；修复后应全部通过。

验证脚本保留debug/release各10轮默认并行完整测试、各5轮八runtime并发stress。
每轮stress明确核验60个flood（每路2097152字节）、10个timeout、10个预期非EOF的inherit。
共800条Report均带PID、reap/启动/进展/EOF/Drop时间、实际poll/Pending/read次数和I/O错误。
这些是调试观察，不能拿进性能统计。helper固定两秒退出，未实现后代进程组回收。

## 原事故的证据边界

原`runtime-final/preview-failed-parallel-drain.txt`只记录断言，没有PID、描述符或读任务
状态，因此不能事后唯一证明那一次失败就是本交错。现在已证实一个与原症状及并行
`inherit`测试完全相容的实际缺陷，并以双profile、双流、双退出方式确定性复现和消除。
不能把多轮通过写成穷尽所有内核/driver交错的证明。未来若仍失败，应先检查Report里的
读者开始/进展/EOF/Drop以及外部描述符证据，而不是加大grace。
