# 第9–10章正式运行

执行`bash tools/run_runtime_benchmarks.sh bench/results/runtime-final`生成正式数据。
另行附着macOS sample得到`process-rpc-sample.txt`，不参加计时统计。

- scheduling：4case×21个批均值=84。
- blocking-poll：2case×21个单次通知观察=42。
- process-rpc：2case×21个批均值=42。
- pipe-drain：2case×21个批均值=42。
- 本目录合计210条正式记录，其中168个批均值、42个通知观察。

统计为N-1标准差与nearest-rank分位数，无手写p值。
分位数是该小样本集合的描述，不作生产SLA推断。

帧尺寸探针、LLVM IR、本机汇编、14项测试日志和测量源码指纹一同保留。
Tokio精确版本与完整依赖解析在`bench/runtime-lab/Cargo.lock`。
核读的第三方实现文件另记在`sources/runtime-code.json`，应用源码指纹不代替依赖溯源。

`runtime-local/`保存前期试跑与独立调度采样，不纳入本目录正式统计。
调度源码在两次测量之间未改变；之后只追加了协议/进程回归测试和类型尺寸示例。

环境：本机Apple M5 Pro，aarch64-apple-darwin，Rust1.99.0，LLVM23.1.1。
没有亲和性、频率/温度隔离、PMU、Miri、TSan或Loom。

父进程sample中read、posix_spawn、wait4等栈可核对生命周期阶段。
采到等待栈不代表该等待持续消耗CPU；报告也没有覆盖所有helper进程。
没有计算稳定态CPU占比或具体系统调用纳秒成本。

后续完整预览曾发生一次并行排空断言失败，原日志保存在`preview-failed-parallel-drain.txt`。
三次契约复跑及80个直接child诊断中的70个flood未复现，随后预览也通过；根因未确定，P1保持开放。
`process-stress.txt`与独立diagnostic-source-hashes.json记录追加诊断，不计入210条正式观察。
没有删除失败记录、移除断言或放宽测试期限。

归档不应覆盖。重跑请选择新目录：

```bash
bash tools/run_runtime_benchmarks.sh bench/results/runtime-reproduction
```
