# 0.14 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先问资源

### D1 · USE 与资源优先

USE 是什么？CPU/内存/磁盘/网络各看哪三个量？为什么先问“哪个资源”？

::: sol D1 核对

USE：Utilization（利用率）、Saturation（饱和/排队）、Errors（错误）。CPU：使用率/runqueue/错误；内存：used/available/swap/PSI；磁盘：`%util`/`aqu-sz`/`await`/错误；网络：带宽/队列/重传/错误。先问资源，才能选对工具；一上来 `top` 只看 CPU，容易漏 I/O/内存/网络。
:::

### D2 · CPU：load 与 vmstat

load average 计什么？`vmstat 1` 的 r/b/us/sy/id/wa 各是什么？load 高但 CPU 空闲怎么解释？

::: sol D2 核对

load 计 R（运行/可运行）+ D（不可中断睡眠，多等 I/O）。`vmstat`：r 可运行、b 不可中断、us 用户、sy 系统、id 空闲、wa 等 I/O。load 高 CPU 空闲，多半是 D 等 I/O/锁/NFS；看 `ps -eo stat` 与 `iostat`。
:::

### D3 · 内存：available 与 RSS/PSS/USS

`free` 的 `free`/`available` 差在哪？RSS/PSS/USS 各是什么？为什么 RSS 会高估进程占用？

::: sol D3 核对

`free` 是完全空闲；`available` 是估计可分配给新应用的内存（含可回收 cache）。RSS 是常驻集（共享页重复计），PSS 按共享比例分摊，USS 是私有页。多进程共享库会让 RSS 相加远大于实际；看 PSS/`smaps_rollup` 更准。
:::

### D4 · 磁盘：await、aqu-sz、%util

`iostat -x` 的 `await`/`aqu-sz`/`%util` 各是什么？为什么 `%util` 100% 不一定慢？

::: sol D4 核对

`await` 平均 I/O 等待（队列+服务，ms）；`aqu-sz` 平均队列深度；`%util` 设备忙占比。`%util` 100% 只说明设备一直在忙，可能每次很快；要看 `await`/`aqu-sz`/应用延迟。SSD/多队列下 `%util` 更不代表饱和。
:::

### D5 · 网络与调度延迟

网络延迟/重传看什么？调度延迟看什么？`ss -i` 的 rtt/retrans 是什么？

::: sol D5 核对

网络：`ss -i` 看 rtt/retrans/拥塞窗口，`mtr` 看路径，`tcpdump` 看包；调度：`perf sched latency`、`/proc/PID/schedstat`、`vmstat` 的 r。`ss -i` 的 rtt 是平滑 RTT，retrans 是重传计数；高重传/高 rtt 说明网络或拥塞问题。
:::

## B. 第二遍：追踪与证据

### D6 · 追踪工具

`strace`/`perf trace`/`bpftrace` 各适合什么？开销怎样？为什么先小范围？

::: sol D6 核对

`strace` 追系统调用（详细、开销大）；`perf trace` 更轻、适合全局；`bpftrace` 用 kprobe/tracepoint 看内核路径/延迟分布（灵活、开销依探针）。开销：strace 可能几倍到几十倍；bpftrace 探针过多也会拖慢。先小范围/短时间/过滤，再放大。
:::

### D7 · 症状→工具→证据矩阵

任选三个症状，给出第一工具与证据。为什么要矩阵？

::: sol D7 核对

示例：CPU 高→`pidstat`/`perf top`→热点进程/函数；内存涨→`free -h`/`smem`/PSI→available/PSS/pressure；磁盘慢→`iostat -x`→await/aqu-sz；网络慢→`ss -i`/`mtr`→rtt/retrans；fd 泄漏→`lsof`/`/proc/PID/fd`。矩阵把“猜”变成“先拿哪条证据”，避免工具乱试。
:::

### D8 · `triage.sh` 与基线

一键取证脚本应采集什么？为什么先建基线？命令行工程化指什么？

::: sol D8 核对

采集：时间/内核/负载/`vmstat`/`free`/`iostat`/`ss`/`ps` top/PSI/cgroup/日志摘要；只读、带时间戳、可复现。先建基线才能对比“正常 vs 异常”；没有基线，单次数字无法判断。命令行工程化：固定环境/参数、`hyperfine`/`time`、格式化输出、dotfiles、shellcheck。
:::

### D9 · PSI 与 cgroup

PSI 的 `some/full` 是什么？cgroup v2 的 `cpu.stat`/`memory.current`/`memory.max` 各看什么？

::: sol D9 核对

PSI：`some` 表示至少一个任务因资源停顿的时间占比，`full` 表示所有任务都停顿（CPU 无 full）。cgroup v2：`cpu.stat` 看 usage/throttled/throttle_us，`cpu.max` 是配额/周期，`memory.current`/`memory.max` 看当前/上限，`memory.events` 看 OOM/高水位。容器被限流看 throttled。
:::

### D10 · 块层真实延迟

`%util` 与块层真实延迟差在哪？`blktrace`/`bpftrace` 能看什么？`aqu-sz` 高说明什么？

::: sol D10 核对

`%util` 是设备忙时间占比，不区分请求大小/并发；真实延迟看 `await`/应用延迟/块层 `blktrace` 的 Q→D→C 时间。`blktrace`/`bpftrace` 看请求排队/服务/完成；`aqu-sz` 高说明排队多，可能后端慢/队列深。SSD/NVMe 多队列下 `%util` 可能失真。
:::

### D11 · fd 取证

`lsof -p` 与 `/proc/PID/fd` 各看什么？deleted 文件怎样找？fd 泄漏的后果？

::: sol D11 核对

`lsof -p PID` 列进程打开的 fd/类型/大小/路径；`/proc/PID/fd` 是 fd 符号链接，能看到 `(deleted)`。deleted-but-open 用 `lsof +L1`/`lsof | grep deleted`。fd 泄漏会 `EMFILE`/`ENFILE`，新连接/文件打不开；看 `ulimit -n` 与 `ls /proc/PID/fd | wc -l`。
:::

### D12 · perf/bpftrace 开销与陷阱

`perf stat`/`perf record`/`bpftrace` 的开销来源？任选三个观测陷阱。

::: sol D12 核对

`perf stat` 用硬件计数器（开销低）；`perf record` 采样（频率越高开销越大）；`bpftrace` kprobe/tracepoint 在热路径上开销明显。陷阱：load≠CPU、`%util`≠延迟、free≠available、RSS 重复计、采样偏差、计数器溢出、追踪改变时序、容器限制看不到、时钟/时区、单次数字下结论。
:::
