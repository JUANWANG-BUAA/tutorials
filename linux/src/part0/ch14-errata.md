# 0.14 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与性能观测陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换内核、换工具版本、换容器环境后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、procps-ng 4.0、sysstat 12.6、perf 6.8、bpftrace 0.20、cgroup v2。换环境时逐条复核。

## 1. 指标与资源

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | load average 是 CPU 使用率 | load 计 R+D（含 I/O 等待），不等于 CPU 忙 | `uptime`、`vmstat`、`ps -eo stat` |
| 2 | `%util` 100% 就是磁盘慢 | `%util` 是设备忙占比，不代表延迟；SSD/多队列更失真 | `iostat -x` 的 await/aqu-sz、`blktrace` |
| 3 | `free` 的 free 就是可用内存 | `available` 才是估计可用（含可回收 cache） | `free -h`、`/proc/meminfo` |
| 4 | RSS 相加就是进程总占用 | RSS 共享页重复计；PSS 按比例、USS 私有 | `smem`、`/proc/PID/smaps_rollup` |
| 5 | `await` 只是磁盘服务时间 | 含队列等待+服务；高 await 可能是排队 | `iostat -x`、`aqu-sz`、`blktrace` |
| 6 | PSI 的 `some` 与 `full` 一样 | `some` 至少一个任务停顿；`full` 所有任务停顿（CPU 无 full） | `cat /proc/pressure/*` |
| 7 | 容器 CPU 用不满是宿主没资源 | 可能 cgroup `cpu.max` 限流；看 `throttled` | `cpu.stat`、`cpu.pressure`、`docker stats` |

## 2. 追踪与工具

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 8 | `strace` 开销很小 | 每次 syscall 停/打印，可能几倍到几十倍 | 对比开关 strace 的延迟 |
| 9 | `perf record` 结果就是全部真相 | 采样有偏差/频率影响；短函数可能漏 | 调频率、`perf stat` 对照 |
| 10 | `bpftrace` 探针不影响性能 | 热路径探针开销明显；探针越多越慢 | 先小范围、对比基线 |
| 11 | 计数器可以直接相减 | 可能溢出/多 CPU 聚合/单位不同 | 看工具文档/`perf stat -I` |
| 12 | 容器里看到的数字等于宿主 | cgroup/namespace 限制视图；CPU/内存/IO 可能被限 | `cpu.stat`、`memory.current`、`/proc/pressure` |
| 13 | 第一次跑就是基线 | cache/冷启动/负载会变；要多次/对照 | 预热、重复、取分布 |
| 14 | 所有时间都是本地时区 | 日志/监控可能 UTC；跨时区对比会错 | `date -Is`、`timedatectl` |
| 15 | `lsof` 只列存在的文件 | deleted-but-open 仍占空间；`+L1` 找 | `lsof +L1`、`/proc/PID/fd` |
| 16 | `ulimit -n` 是全局 | 每进程/会话限制；hard/soft 不同 | `/proc/PID/limits` |

## 3. 观测与结论

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 17 | 工具版本不影响字段 | procps/sysstat/perf 字段/单位依版本 | `vmstat -V`、`iostat -V`、`perf --version` |
| 18 | 单次数字能下结论 | 负载/采样/缓存波动；要基线/分布/对照 | 多次采集、`hyperfine` |
| 19 | CPU 高就是应用问题 | 可能内核/驱动/中断/ steal（虚拟化） | `mpstat -P ALL`、`perf top` |
| 20 | 内存涨就是泄漏 | 可能 cache/arena/碎片；看 PSS/回收 | `smem`、`PSI`、`valgrind`/`heaptrack` |
| 21 | 磁盘慢就是盘坏 | 可能文件系统/队列/应用同步写 | `iostat`、`blktrace`、`strace -e fsync` |
| 22 | 网络慢就是带宽 | 可能 RTT/重传/队列/应用 | `ss -i`、`mtr`、`tcpdump` |
| 23 | 性能结论可以跨机器复用 | CPU/内核/负载/配置不同；要本机复测 | 记录环境/版本/参数 |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的内核/工具版本上使用前先验证：

- PSI 需要内核 `CONFIG_PSI`；cgroup v2 的控制器依内核启动参数/容器 runtime。
- `perf`/`bpftrace` 需要权限/内核符号；容器/受限环境可能不可用。
- `iostat` 的 `%util`/`await` 在 SSD/NVMe 多队列下语义有限；以 `blktrace`/应用延迟为准。
- `smem`/PSS 依内核 `CONFIG_PROC_PAGE_MONITOR`；容器里可能不可见。
- 不同发行版的 procps/sysstat 字段/单位可能不同；以本机 `--version`/man 为准。

## 5. 发现新问题怎么记

如果你在别的内核/工具版本上发现本章结论不成立，按「现象 → 命令/输出 → 版本/环境 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
