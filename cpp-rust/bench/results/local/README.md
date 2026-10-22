# 保存结果的解释

这是一组本机实测记录，不是跨硬件通用基线。

- `atomic-1.txt`、`atomic-4.txt`：各5模式×21批。
- `handoff.txt`：2模式×21批。
- `async-poll.txt`：3模式×21批。
- `future-allocation.txt`：最终500ms预热版本，2模式×21批。
- 正式批次合计357；统计采用N-1标准差与nearest-rank分位数。
- `future-allocation-drift.txt`：早期只预热一批的试跑，不在357批中；保留以说明为何修改预热方法。此文件不对应当前最终版本夹具。

前四组在同一次顺序测量中执行；分配基准是追加实现、发现漂移并修正预热后另行执行的记录。
不要把environment.txt的开始时刻理解成所有文件同时完成的时间。
profile目录的两次采样也是另外运行的进程，不用于正式墙钟表。

`source-hashes.json`登记最终源码快照；前三个benchmark在扩充分配实验时没有改动计算逻辑。
统计脚本复核样本与均值，不会伪造p值、置信度或硬件事件。

本机target的atomics.s/.ll由rustc直接生成；x86-64 Linux与AArch64 Android产物仅交叉生成，没有目标平台计时。
Future布局来自稳定MIR导出与示例执行，不保证布局跨版本稳定。

默认release配置：opt-level=3、debug=1、codegen-units=1、lto=false，未设置RUSTFLAGS。
桌面环境未锁核、未锁频、未控温；不得拿这些结果作为生产SLA或CPU微架构的绝对周期表。

重跑请执行：

```bash
bash tools/run_benchmarks.sh bench/results/reproduction
```

不要覆盖这里的已归档记录。
