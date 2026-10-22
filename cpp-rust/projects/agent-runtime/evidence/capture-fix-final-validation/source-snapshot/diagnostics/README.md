# macOS 捕获管道的确定性回归

本目录只用于正确性验证，不把 gate 停顿、lsof 或压力报告计入 benchmark。
项目不依赖 runtime-lab；`pipe_gate.c` 和 `src/process_macos.rs` 由已证明的修复适配而来。
前因证据在 `bench/results/runtime-fixed/`，原 Rust 1.99 macOS 实现有8旧失败/8新通过矩阵。
这不是“调度噪声”，而是 pipe 后补 CLOEXEC 可被无关并发 posix_spawn 复制的实际竞争。
不能从本次机制证明倒推缺失 PID/FD 的历史单次事故一定具有唯一相同根因。

## 实施边界

项目 macOS 捕获改用动态查找的 `pipe2(O_CLOEXEC)`，两端从创建时即标记。
无 pipe2 的旧 macOS 返回 `io::ErrorKind::Unsupported`，传播为 SpawnFailed 和 cleanup_error，
不做已知有竞争的 pipe/fcntl fallback，也没有串行化全部 spawn 的全局锁。
非 macOS 保留标准库/Tokio路径，未执行验证，不声称跨平台原子创建。

`OwnedFd` 唯一拥有成功系统调用得到的每个描述符；Tokio接管读端并注册非阻塞I/O。
两个写端移动到 Command；spawn 成功或失败后均显式替换为 null，防止父进程自己阻止EOF。
普通 fd 1/2 继承不受禁止；contracts 新测试故意让直接工具的后代持有标准写端，
仍应在原30ms测试grace后标记未EOF。生产默认grace仍1秒，不增加宽限期。
新增模块含有限 unsafe：dlsym、函数指针转换、pipe2调用、OwnedFd构造和测试fcntl；
各处写明初始化、函数签名、存活期和唯一所有权前提。不是全项目“全安全Rust”。

## 确定性对抗交错

1. 初始化当前线程runtime，arm gate；真正pipe/pipe2返回前暂停一次。
2. 另一条原生线程观察ready，在窗口内启动标准流全为null的无关helper。
3. helper启动两秒hold后代后退出；后代PID写到pid文件。
4. lsof按该精确PID记录活内核FD，然后release原管道创建线程。
5. logs必须完整排空每流2MiB；sleep必须超时并reap；两者必须两流EOF、无错误。
6. 额外检查ready是pipe2且两个flags=1，活后代没有fd大于2的PIPE。

因为无关进程标准流是null，额外PIPE不能解释为有意的stdout/stderr继承。
gate没有修改FD标志、模拟read、修改输出或改变grace；对stdout/stderr分别设置N=1/2。
诊断要求macOS27 SDK、clang和本地非系统程序可使用DYLD_INSERT_LIBRARIES。
生产库本身不需要interposer。gate等候有上界；失败归档也保留，不覆盖重跑。

## 复现

在项目目录执行，输出目录必须不存在：

```bash
bash diagnostics/reproduce_descriptor_race.sh evidence/my-race-debug debug
bash diagnostics/reproduce_descriptor_race.sh evidence/my-race-release release
bash diagnostics/validate_capture.sh evidence/my-validation
```

完整验证包括fmt、offline locked clippy全部target、debug/release各10轮默认并行cargo test，
各5轮八独立Runtime并发stress，以及两种profile各4个gate交错和库示例。
每次完整cargo test执行2单元+14契约+2回归（含真实CLI），每个stress输出80条完整结果。
stress包括64条logs、8条timeout、8条cancel，不以“非零也算通过”掩盖错误。
所有旧测试断言保持不变，未使用test-threads=1或全局spawn锁。

`validate_capture.sh`保留完整源码快照和SHA256；正式性能另用`scripts/measure.sh`取得共享目录锁。
只能将本目录结果称为实施者回归执行，不是独立审计或全交错形式证明。
工具后代只按夹具期限自行退出，不冒充运行库实现了进程组清理。
