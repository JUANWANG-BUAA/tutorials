# RUNTIME-DRAIN-INTERMITTENT修复证据

本目录只新增证据；`runtime-final`旧日志、原始样本和清单没有覆盖。
原清单13个条目的逐字节版本已保存到`../runtime-final/source-snapshot/<root-relative-path>`。

## 结论与边界

已确定性复现并修复macOS标准库非原子pipe/CLOEXEC窗口造成的意外描述符继承：
无关进程的两秒后代持有写端，直接child退出或被杀后读者没有EOF。
同一交错下旧版8例全失败、原子`pipe2(O_CLOEXEC)`新版8例全通过。
不扩大grace，不串行化测试，不删除断言。原单次失败日志没有描述符/reader状态，
不能唯一重建历史事故；finding状态仍由父级结合独立审计裁决。

## 文件导览

| 目录/文件 | 含义 |
|:--|:--|
| `baseline-debug/`, `baseline-release/` | 旧实现，flood/sleep × stdout/stderr；8个预期断言失败；gate flags=0；lsof额外PIPE |
| `fixed-debug/`, `fixed-release/` | 同样交错修复后8例通过；gate flags=1；后代没有额外PIPE |
| `final-validation/` | 最终源码，debug/release各10轮默认并行完整测试及各5轮八runtime压力；800条完整Report |
| `repeated-validation/` | 在仅改benchmark预热/内容校验前，另20轮完整测试及800条Report；进程实现与最终版相同 |
| `measurements-final/` | 最终源码4入口10case各21个观测，共210；环境、源码快照、MIR/LLVM IR/本机汇编、另行sample |
| `measurements/` | 修复初跑，同样210个观测；沿用旧短预热，后续已加强，不能代替final数据 |
| `before-source-snapshot/` | 第一次故障注入之前的额外源码快照，配before-diagnostic-source-hashes.json |
| `implementation-source-review.json` | 针对std/Tokio/SDK实际核读范围与本地副本哈希；不是整个crate审计 |
| `diagnostic-summary.json` | 源码快照验证、故障矩阵、stress计数、从原始样本重算的N-1 sd与nearest-rank分位数 |
| `diagnostic-verification.txt` | 本地机械复验结果，不是独立审计 |
| `race-before-2.txt`, `race-before-2-lsof.txt` | 首次成功复现；无关后代持有10/11号管道 |
| `race-after-1.txt` | 首次修复后回归，通过 |
| `race-before.txt` | 被保留的诊断原型失败：dlsym interpose递归导致栈溢出，不是被测runtime的新故障 |

每套suite都有源码指纹与快照，不把旧失败版、新增诊断版和最终测量版混成同一版本。
`final-validation/source-hashes.json`含全部诊断C/脚本；`measurements-final/source-hashes.json`
沿用既有benchmark脚本格式，并含`process_macos.rs`与Cargo.lock。

## 最终压力计数

最终800条Report包括600个flood、100个30ms deadline sleep和100个正常继承fd 1/2的inherit。
每轮80条为8个独立current-thread runtime并发，不是一个runtime串行跑80次。
所有flood两流各2097152字节、完整EOF、无reader_errors；所有timeout观察杀后wait与双EOF；
所有inherit仍明确报告两路非EOF/grace过期，保留直接child边界。
最终每轮6个单元测试+12个集成测试，共20轮360项执行全通过。
两套验证合计1600条Report、40轮720项测试执行，但最终套可单独复验。

## 性能证据如何使用

最终210个观测=168个批均值+42个单通知观察，不是210个生产逐请求尾样本。
所有过程顺序运行，使用共享目录锁；测量前未看到其他真实cargo/rustc构建进程。
桌面系统未锁核/锁频，不能宣称系统隔离。M5 Pro cacheline实查128。
scheduling至少预热500ms，其余3入口每配置至少500ms；保留所有21个原始值。
pipe-drain除精确字节总数、退出状态、EOF外，还检验保留字节全部为`x`。
process-rpc验证每条request id/value；scheduling保留原checksum及任务数检查。
统计重算在`diagnostic-summary.json`；不捏造p-value，不把新旧两次非配对运行解释成修复的净性能收益。
`measurements-final/scheduling-sample.txt`是另起进程的macOS sample，不混入正式计时，亦不是Linux perf。

复现脚本及版本限制见`../../runtime-lab/diagnostics/README.md`。
旧实测数值应继续指向旧快照，不能把旧`runtime-final`哈希改为当前源码。
