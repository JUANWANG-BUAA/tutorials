# 0.14 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · USE 与资源优先

USE 是什么？CPU/内存/磁盘/网络各看哪三个量？为什么先问“哪个资源”？

::: sol 解答

USE：Utilization（利用率）、Saturation（饱和/排队）、Errors（错误）。CPU：使用率/runqueue/错误；内存：used/available/swap/PSI；磁盘：`%util`/`aqu-sz`/`await`/错误；网络：带宽/队列/重传/错误。先问资源才能选对工具；一上来 `top` 只看 CPU，容易漏 I/O/内存/网络。

:::
:::

::: ex A2 · CPU：load 与 vmstat

load average 计什么？`vmstat 1` 的 r/b/us/sy/id/wa 各是什么？load 高但 CPU 空闲怎么解释？

::: sol 解答

load 计 R（运行/可运行）+ D（不可中断睡眠，多等 I/O）。`vmstat`：r 可运行、b 不可中断、us 用户、sy 系统、id 空闲、wa 等 I/O。load 高 CPU 空闲，多半是 D 等 I/O/锁/NFS；看 `ps -eo stat` 与 `iostat`。

:::
:::

::: ex A3 · 内存：available 与 RSS/PSS/USS

`free` 的 `free`/`available` 差在哪？RSS/PSS/USS 各是什么？为什么 RSS 会高估进程占用？

::: sol 解答

`free` 是完全空闲；`available` 是估计可分配的内存（含可回收 cache）。RSS 是常驻集（共享页重复计），PSS 按共享比例分摊，USS 是私有页。多进程共享库会让 RSS 相加远大于实际；看 PSS/`smaps_rollup` 更准。

:::
:::

::: ex A4 · 磁盘：await、aqu-sz、%util

`iostat -x` 的 `await`/`aqu-sz`/`%util` 各是什么？为什么 `%util` 100% 不一定慢？

::: sol 解答

`await` 平均 I/O 等待（队列+服务，ms）；`aqu-sz` 平均队列深度；`%util` 设备忙占比。`%util` 100% 只说明设备一直在忙，可能每次很快；要看 `await`/`aqu-sz`/应用延迟。SSD/多队列下 `%util` 更不代表饱和。

:::
:::

::: ex A5 · 网络与调度延迟

网络延迟/重传看什么？调度延迟看什么？`ss -i` 的 rtt/retrans 是什么？

::: sol 解答

网络：`ss -i` 看 rtt/retrans/拥塞窗口，`mtr` 看路径，`tcpdump` 看包；调度：`perf sched latency`、`/proc/PID/schedstat`、`vmstat` 的 r。`ss -i` 的 rtt 是平滑 RTT，retrans 是重传计数；高重传/高 rtt 说明网络或拥塞问题。

:::
:::

::: ex A6 · 追踪工具

`strace`/`perf trace`/`bpftrace` 各适合什么？开销怎样？为什么先小范围？

::: sol 解答

`strace` 追系统调用（详细、开销大）；`perf trace` 更轻、适合全局；`bpftrace` 用 kprobe/tracepoint 看内核路径/延迟分布（灵活、开销依探针）。开销：strace 可能几倍到几十倍；bpftrace 探针过多也会拖慢。先小范围/短时间/过滤。

:::
:::

::: ex A7 · PSI 与 cgroup

PSI 的 `some/full` 是什么？cgroup v2 的 `cpu.stat`/`memory.current`/`memory.max` 各看什么？

::: sol 解答

PSI：`some` 表示至少一个任务因资源停顿的时间占比，`full` 表示所有任务都停顿（CPU 无 full）。cgroup v2：`cpu.stat` 看 usage/throttled/throttle_us，`cpu.max` 是配额/周期，`memory.current`/`memory.max` 看当前/上限，`memory.events` 看 OOM/高水位。容器被限流看 throttled。

:::
:::

::: ex A8 · 症状→工具→证据矩阵

任选三个症状，给出第一工具与证据。为什么要矩阵？

::: sol 解答

示例：CPU 高→`pidstat`/`perf top`→热点进程/函数；内存涨→`free -h`/`smem`/PSI→available/PSS/pressure；磁盘慢→`iostat -x`→await/aqu-sz；网络慢→`ss -i`/`mtr`→rtt/retrans；fd 泄漏→`lsof`/`/proc/PID/fd`。矩阵把“猜”变成“先拿哪条证据”。

:::
:::

## B 组 · 诊断推理

::: ex B1 · load 高但 CPU 空闲

`uptime` 显示 load 20，`top` 的 CPU 95% idle。列出至少四种原因与验证。

::: sol B1 核对

① 大量 D 等 I/O：`ps -eo stat`、`vmstat`、`iostat -x`；② NFS/网络存储挂起；③ 内存压力/回收/swap：`free -h`、`vmstat`、PSI；④ cgroup CPU 限流：`cpu.stat` 的 throttled；⑤ 大量短命进程 fork/exit：`pidstat`。load 计 R+D，不等于 CPU 忙。

:::
:::

::: ex B2 · 磁盘慢但 %util 不高/很高

`iostat -x` 显示 `%util` 100% 但 `await` 很低，或 `%util` 不高但应用延迟高。各怎样解释？

::: sol B2 核对

`%util=100` 但 `await` 低：设备一直有小请求、每次很快，忙不等于慢。`%util` 低但延迟高：可能是队列/后端/文件系统/应用层，或 SSD 多队列 `%util` 失真；看 `await`/`aqu-sz`/`blktrace`/应用延迟。不要只看 `%util`。

:::
:::

::: ex B3 · 内存涨但 free 很低

`free -h` 显示 free 很少、buff/cache 很多，应用 OOM。是内存不够吗？怎样判断？

::: sol B3 核对

不一定；Linux 用空闲内存做 cache。看 `available`（可回收）、`/proc/meminfo` 的 `MemAvailable`、PSI `memory.pressure`、`memory.events` 的 OOM 计数、cgroup `memory.current/max`。若 available 足够、无 PSI/OOM，cache 多是正常；若 available 低/PSI 高/OOM，才是真压力。

:::
:::

::: ex B4 · 容器 CPU 被限

容器里应用 CPU 用不满，宿主 CPU 空闲。为什么？怎样确认？

::: sol B4 核对

cgroup CPU 配额/权重限制：看 `/sys/fs/cgroup/.../cpu.max`、`cpu.stat` 的 `throttled`/`throttle_us`、`cpu.pressure`；也可能 `cpuset` 限核、`cpu.weight` 竞争。`docker stats`/`systemd-cgtop` 辅助。被限流不是宿主没 CPU，而是配额用完。

:::
:::

::: ex B5 · fd 泄漏

服务运行久了报 `Too many open files`。怎样确认是 fd 泄漏？怎样找？

::: sol B5 核对

`ulimit -n`、`cat /proc/PID/limits` 看上限；`ls /proc/PID/fd | wc -l` 看数量增长；`lsof -p PID`/`/proc/PID/fd` 看类型/路径；`lsof +L1` 找 deleted-but-open；`strace -e openat,close` 看未关闭。常见：连接/文件未 close、缓存无上限。

:::
:::

::: ex B6 · 追踪工具把系统拖慢

开了 `strace -f`/`bpftrace` 后应用延迟翻倍。为什么？怎样降低开销？

::: sol B6 核对

strace 每次 syscall 都停/打印，开销大；bpftrace 探针在热路径上频繁触发。降低：缩小范围（PID/时间/过滤）、用 `perf trace`/`perf stat`、采样而非全量、短时间采集、先基线后开追踪。追踪本身会改变时序，结论要谨慎。

:::
:::

## C 组 · 动手实验

::: ex C1 · 一键取证与基线

写一个 `triage.sh`，采集时间/内核/load/vmstat/free/iostat/ss/ps top/PSI；在空闲与压力下各跑一次，对比。

::: sol C1 核对

```bash
#!/usr/bin/env bash
set -euo pipefail
out=${1:-./triage-$(date +%s).txt}
{
    echo "== date"; date -Is
    echo "== uname"; uname -a
    echo "== load"; uptime
    echo "== vmstat"; vmstat 1 3
    echo "== free"; free -h
    echo "== iostat"; iostat -x 1 3 2>/dev/null || true
    echo "== ss"; ss -s
    echo "== ps"; ps -eo pid,stat,pcpu,pmem,cmd --sort=-pcpu | head -15
    echo "== psi"; cat /proc/pressure/{cpu,memory,io} 2>/dev/null || true
} > "$out"
echo "wrote $out"
```

空闲/压力各跑一次，对比 load/PSI/await；只读、带时间戳、可复现。先基线再下结论。

:::
:::

::: ex C2 · CPU 节流实验

用 cgroup v2 的 `cpu.max` 把一组进程限制到 20% CPU，跑 CPU 密集任务，观察 `cpu.stat` 的 throttled 与延迟。

::: sol C2 核对

```bash
sudo mkdir -p /sys/fs/cgroup/demo
echo '20000 100000' | sudo tee /sys/fs/cgroup/demo/cpu.max
sudo sh -c 'echo $$ > /sys/fs/cgroup/demo/cgroup.procs; while :; do :; done' &
cat /sys/fs/cgroup/demo/cpu.stat
```

`cpu.stat` 的 `throttled`/`throttle_us` 增长说明被限；`cpu.pressure` 看压力。实验后清理 cgroup；不要在宿主关键 cgroup 上做。

:::
:::

::: ex C3 · I/O 延迟实验

用 `fio`/`dd`/`stress-ng` 制造随机/顺序 I/O，观察 `iostat -x` 的 await/aqu-sz/%util 与应用延迟。

::: sol C3 核对

```bash
sudo fio --name=rand --filename=/tmp/fio.dat --size=1G --rw=randread --bs=4k --iodepth=16 --runtime=30 --time_based
iostat -x 1 5
```

对比顺序/随机、iodepth 1/16 的 await/aqu-sz/IOPS；`%util` 可能先满。应用延迟用 `fio` 的 lat 或 `perf`；实验后删文件。

:::
:::

::: ex C4 · fd 泄漏/删除文件取证

用一个打开文件不关的小脚本，观察 `/proc/PID/fd` 增长；删除文件后看 `(deleted)` 与 `lsof +L1`。

::: sol C4 核对

```bash
bash -c 'while :; do exec 3</etc/hosts; sleep 0.01; done' &
pid=$!
ls /proc/$pid/fd | wc -l
lsof -p "$pid" | head
# 删除一个仍打开的文件
f=$(mktemp); exec 9<"$f"; rm "$f"; ls -l /proc/$$/fd/9; lsof +L1 | grep "$f" || true
kill "$pid"
```

fd 数量增长说明泄漏；`(deleted)` 说明文件已删但仍占空间；`lsof +L1` 找 deleted-but-open。实验只动临时文件。

:::
:::

::: ex C5 · USE 取数表与第 0 篇自检

为 CPU/内存/磁盘/网络各填一行 USE（利用率/饱和/错误）与命令；再做第 0 篇能力自检：能否独立完成文件/文本/权限/进程/服务/网络/性能任务？

::: sol C5 核对

示例表：

| 资源 | 利用率 | 饱和 | 错误 |
|:--|:--|:--|:--|
| CPU | `vmstat` us/sy | `vmstat` r、PSI cpu | `dmesg` MCE |
| 内存 | `free` available | PSI memory、swap | OOM/`memory.events` |
| 磁盘 | `iostat` %util | `aqu-sz`/`await` | `dmesg`/SMART |
| 网络 | `ss -i` 带宽 | 重传/队列 | `ip -s link` errors |

第 0 篇自检：能否写带 `set -euo pipefail` 的脚本、用 `strace`/`ss`/`journalctl` 定位、解释命令四层路径；不能就回对应章。

:::
:::
