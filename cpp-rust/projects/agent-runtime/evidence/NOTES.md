# 项目证据：原子捕获修复后的版本边界

## 当前正式证据

正文第15章只采用 `run-04/`：4case各21条，共84条正式原始观察。
Tokio=1.54.0，libc=0.2.191，Rust1.99.0，macOS27.0.1，Apple M5 Pro，cache line128。
源码/锁文件/测量与诊断脚本的19份SHA256、逐字节source-snapshot和最终验证相互一致。
六个原生产物为明确指定输出路径的agent_runtime与runtime_bench各MIR、LLVM IR和.s，
没有用target/deps通配符把旧版编译产物混在当前证据中。
macOS sample来自另一个profile进程，未混入正式原始样本。
测量由mkdir目录锁独占合作计时，trap释放；本次开始快照没有匹配到cargo/rustc构建进程。
这不是整台桌面被隔离的证明。lifecycle出现明显长批次，全部保留，不裁样本、不称SLA。

| case | mean | N-1 sd | 批p50 | 批p99 | 单位 |
|:--|--:|--:|--:|--:|:--|
| admission-full | 3.662 | 0.064 | 3.653 | 3.886 | ns/拒绝尝试 |
| C1/R0 | 2.871944 | 1.268896 | 2.535537 | 7.845750 | ms/工具批均值 |
| C1/R4096 | 3.505500 | 2.472717 | 2.285484 | 9.227984 | ms/工具批均值 |
| C4/R4096 | 1.046813 | 0.621628 | 0.811443 | 3.373109 | ms/工具批均值 |

每项至少500ms预热；lifecycle每批8工具，每工具双路各262144字节，完整FNV校验。
21批nearest-rank p99等于最大批均值，不是请求p99。跨旧新版不是配对净开销实验。

## 原归档保护与首轮修复归档

- `run-02/` 原84条、原source-sha256.txt及原生产物均未改写。修复前逐项核对12份源文件全匹配，
  新增 `source-snapshot/` 保存原文件逐字节版本及 `pre-capture-fix-preservation.json` 核对记录。
- `run-01/` 原63条、原指纹及产物未改写。11份中8份仍与修复前文件相同，已保存这些快照。
  scripts/summarize.py、src/bin/runtime-bench.rs、src/main.rs三个更早版本当时已演进，
  没有伪造恢复，核对记录明确标出缺失。旧原生文本不能当成完整源快照。
- `run-03/` 是修复实现第一次测量，另84条全部保留。其脚本通配符收集了target/deps的旧版本，
  所以不作为当前代码生成归档。之后只改进输出选择，再完整验证/测量，形成run-04。
- 旧run-01、run-02与首轮run-03均不是正文正式当前数值。四轮总计315条真实原始观察，
  本次新增168条。不要覆盖旧hash，把新版源文件伪装成旧测量版本。
- 原先关于“没有专门构造继承后代”的限制已经由本次新增正常继承及额外FD对抗验证补足；
  仍没有实现后代强制终止或进程组回收。

## 最终验证

`capture-fix-final-validation-02/` 与run-04全部被测源指纹一致：

- rustfmt、offline locked clippy全部target且-D warnings通过。
- debug/release各10轮默认并行cargo test；每轮2单元+14contracts+2regressions，共360项全通过。
- 原CLI回归每轮真实启动Success/NonZero/TimedOut/Cancelled/usage五类，原断言不删除。
- 各profile5轮八独立Runtime stress，共800条完整结果：640logs、80timeout、80cancel。
- 每条结果核验预期Outcome、reaped、两流EOF、无清理错误；logs另核总字节/前缀/FNV。
- 各profile4个dyld gate交错，共8例全部通过：logs/timeout × stdout/stderr。
- ready均为pipe2、双端flags=1；lsof按活后代精确PID采集，没有大于2号的额外PIPE。
- 有意标准流继承测试仍记录两路未EOF及原30ms测试grace错误；默认grace仍1秒。
- Command保持存活的双次复用均有EOF，连续两次spawn失败返回NotFound。
- 库调用例在debug/release都执行，正常shutdown观察清理完成。

`capture-fix-final-validation/` 另保留同进程实现的一套360项测试、800条结果、8例gate。
两套之间只改measure.sh的原生产物选择，不改变运行库、helper、契约或benchmark工作量。
最终续跑另执行 `capture-fix-resume-validation/`：同样360项测试、800条压力结果及8例gate全部通过，
19份源码指纹与run-04逐项相同；`verification.json`保留该套机械复验计数，未新增或混入正式计时样本。
`capture-fix-race-first/` 还有初次debug四交错；不拿这些重复次数代替确定性机制证据。

## 阅读与机械复验

`capture-source-review.json`记录实际核读的std管道/posix_spawn、Tokio接管与spawn包装、SDK可用版本，
以及项目新版MIR、IR、汇编和sample的具体阅读范围。不是整个依赖库审计。
先前S11物理PDF390–394的核读与映射由项目初稿保留；本次没有新母本页码或新在线抓取记录。

```bash
python3 evidence/verify_capture.py
python3 scripts/summarize.py evidence/run-04
```

`capture-verification.json`记录复验结果；`capture-chapter-check.json`记录第15章结构/唯一锚点。
它们只是实施者机械检查，不是独立审计。全局finding、台账和发布门禁由父级集成。

## 根因及剩余边界

本机std Rust1.99 macOS匿名管道仍是pipe后补FD_CLOEXEC，窗口内无关posix_spawn可以复制额外FD。
先前专门定位已确定性证明此机制；本项目原并发捕获路径确实同样暴露，因此修复而非归类为噪声。
初次preview事故没有PID/FD，无法声称唯一重建那一次历史原因。

修复仅保护项目自己创建的捕获管道，不修复其他调用者仍使用Stdio::piped的实现。
macOS平台模块含有限且有契约的unsafe；项目不再称全安全Rust。
没有pipe2的旧macOS显式Unsupported，无racy fallback；旧实机未运行。
非macOS路径未执行。没有Miri、Loom、TSan、Linux perf、io_uring或PMU数据。
直接Child之外的后代仍可能有意持有fd1/fd2；grace只限制等待，不替代进程树清理。
wait失败、外层runtime强毁、SIGKILL、内部panic不属于已证明的及时回收路径。
预算限制队列、工作集合与日志前缀长度，不限制调用者长期保存结果，不是精确RSS上界。
