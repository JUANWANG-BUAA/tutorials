# 0.14 章末总结

## 四单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、先问资源**（0.14.1–0.14.5） | 哪个资源慢？ | 先分 CPU/内存/磁盘/网络/调度；CPU 看 load/`vmstat`/`perf`，内存看 `available`/PSI，磁盘看 `await`/`aqu-sz`，网络看 `ss -i`/`mtr`。 | 把 load 当 CPU；把 `free` 当可用内存；把 `%util` 当延迟。 |
| **二、追踪与矩阵**（0.14.6–0.14.9） | 用什么追踪？怎样固化？ | `strace` 系统调用、`perf trace` 轻量、`bpftrace` 内核路径；建「症状→工具→证据」矩阵；`triage.sh` 一键采集。 | 追踪开销不看；采样偏差；脚本不可复现。 |
| **三、深水区**（0.14.10–0.14.14） | PSI/cgroup、RSS/PSS/USS、块层、fd、perf/bpftrace？ | PSI `some/full` 把压力变数字；RSS 共享、PSS 按比例、USS 私有；块层 `await` 含队列；`lsof`/fd 找泄漏；perf/bpftrace 有开销。 | 只看 RSS；`%util` 满但延迟不高；bpftrace 探针过多。 |
| **四、压成能力**（0.14.15–0.14.22） | 怎样取证/收口？ | 三条脚本、CPU 节流/IO 延迟/CPU 饱和/IO 队列实验、USE 取数表、`triage.sh`、23 陷阱、第 0 篇能力自检。 | 不建基线；不做对照；只看单次数字。 |

## 一条主线

这一章先教你**先问“哪个资源”**，再选工具：CPU、内存、磁盘、网络、调度各有第一指标；然后**用追踪工具与症状矩阵**把“猜”变成“证据”，把采集固化成 `triage.sh`。第二遍看 PSI/cgroup、RSS/PSS/USS、块层真实延迟、`lsof`/fd、`perf`/`bpftrace` 开销。最后用三条脚本、四组实验、USE 表、`triage.sh` 与 23 个陷阱收口，并做第 0 篇能力自检。

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| CPU 高 | `pidstat 1`、`perf top`、`vmstat 1` | 分用户/系统/等待；找热点进程/函数。 |
| load 高但 CPU 空闲 | `ps -eo stat` 看 D、`vmstat`/`iostat` | load 含 D（I/O），不一定是 CPU。 |
| 内存涨 | `free -h` 看 `available`、`smem`、PSI | `free` 的 free 不是可用；RSS 共享。 |
| 磁盘慢 | `iostat -x 1` 看 await/aqu-sz、`iotop` | `%util` 只表示忙，不等于延迟。 |
| 网络延迟/重传 | `ss -i`、`mtr`、`tcpdump` | 看 RTT/重传/路径。 |
| 调度延迟 | `perf sched latency`、`/proc/PID/schedstat` | 看等 CPU/被抢占。 |
| 系统调用慢 | `strace -c`/`perf trace` | 看哪个 syscall/次数/耗时。 |
| 内核路径 | `bpftrace` kprobe/tracepoint | 看函数/延迟分布；注意开销。 |
| fd 泄漏 | `lsof -p`、`/proc/PID/fd` | 找未关闭/删除文件。 |
| 容器 CPU 被限 | `cat /sys/fs/cgroup/.../cpu.stat`、`cpu.max` | 看 throttled/throttle_us。 |

## 能否讲出这八句话

1. 先问“哪个资源”，再选工具；USE：每个资源看利用率/饱和/错误。
2. load average 计 R+D，不等于 CPU 使用率；`vmstat` 看 r/b/us/sy/id/wa。
3. `free` 的 `available` 才是可用内存；RSS 共享、PSS 按比例、USS 私有。
4. `iostat -x` 的 `await` 含队列+服务，`aqu-sz` 是队列深度；`%util` 不等于延迟。
5. 网络看 `ss -i` 的 RTT/重传、`mtr` 的路径；调度看 `perf sched`。
6. `strace` 看 syscall，`perf trace` 更轻，`bpftrace` 看内核路径；都有开销，先小范围。
7. PSI 的 `some/full` 把 CPU/内存/IO 压力变数字；cgroup v2 的 `cpu.stat`/`memory.current` 看容器。
8. `triage.sh` 一键采集、先建基线、再做对照；不要用单次数字下结论。

## 学完之后

1. **[闭卷回忆卡](ch14-recall.md)**：先合上正文，把资源优先、load/free/iostat、追踪工具、PSI/cgroup、USE 五组结论从空白纸上叫出来。
2. **[习题集](ch14-exercises.md)**：A 组检查概念，B 组诊断“为什么 load 高 CPU 空闲/为什么磁盘慢/为什么容器被限”，C 组做 CPU 节流、IO 延迟、`triage.sh` 实验。
3. **[学习目标自检表](ch14-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch14-errata.md)**：把 procps/sysstat/perf/bpftrace/PSI 的版本差异过一遍。
5. **下一站**：[第 0 篇收束](ch14.md#sec-0.14.22) 做命令行能力自检；之后进入第 1 篇计算机系统。
