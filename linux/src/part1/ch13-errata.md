# 1.13 勘误与版本注记

这一页收本章最容易「换一台机器、换一个内核就不成立」的东西：OSTEP 的模型与 Linux 实现的差距、调度器的版本更替、文件系统语义的边界，以及 cgroup v1 与 v2 的接口差异。正文的 `errata` 盒讲理解陷阱；这一页讲**换一个内核、换一个架构、换一套挂载选项之后要复核什么**。

**本章基线**：正文标「VM 实测」的读数来自本书 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、4 vCPU、约 12 GiB 内存、`/` 为 `/dev/sda2` 上的 ext4、`vm.swappiness=60`，`sudo` 不可用）。`vmstat`、`iostat`、`strace`、`filefrag`、`findmnt`、`taskset` 可用；`stress-ng` 与 `fio` 未安装；`perf sched` 报 `can't access trace events`；`sudo dumpe2fs`/`debugfs` 不可用。凡标「未实测」的，请看末节。

## 1. 模型、调度器、文件系统与 cgroup：十五个容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「RR 的片长就是 Linux 的时间片」 | 普通调度类没有固定时间片：CFS 用 `sched_latency` 按任务数动态分片，EEVDF 用 `se.slice` 给每个实体一个调度片；`SCHED_RR` 是**实时类**的策略，与本章的 RR 不同名同义 | `chrt -p $$` 看自己的策略；`grep se.slice /proc/<pid>/sched` 与 `grep se.vruntime /proc/<pid>/sched` 各看一次；`chrt -r 10 sleep 1` 再对照 |
| 「nice 决定绝对优先级」 | nice 是相对权重：nice 每差 1 权重约乘 1.25，nice −20/0/19 对应 88761/1024/15。同一核上才会体现比例 | 绑核跑 `nice -n 0` 与 `nice -n 10`：VM 实测 90.1% 对 9.7%，`se.sum_exec_runtime` 9034.216380 ms 对 974.130957 ms；0 对 19 是 98.3% 对 1.3%、7893.609598 ms 对 118.216624 ms（约 66.8 倍，正文写 68:1 是取理论值） |
| 「Linux 的默认调度器是 CFS」 | 2.6.23–6.5 是 CFS，6.6 起默认 EEVDF。字段也随之变：本机 7.0.0-38 的 `/proc/<pid>/sched` 有 `se.slice`（2100000）、`se.load.weight`（1048576，即 1024 << 10 的定点数）、`se.avg.*`，但**看不到**正文提到的 `se.deadline` | `uname -r` 记版本；`grep -E 'se\.' /proc/<pid>/sched` 全量打印一次再引用；不要照抄别处的字段名 |
| 「MLFQ 五条规则描述的就是 Linux」 | Linux 没有 MLFQ。历史上的 O(1) 调度器有交互式优先级补偿，但不是多级反馈队列；普通类是 CFS/EEVDF，实时类是 FIFO/RR/DEADLINE，`SCHED_BATCH`/`SCHED_IDLE` 是另两档 | `chrt -m` 列出支持的策略；`ps -eo pid,cls,rtprio,ni,comm` 看每个进程的调度类 |
| 「PTE 的低 12 位就是那十个标志」 | 那张位号表是 **x86-64** 的。aarch64 用 `AF`（access flag）表示已访问、用 `AP[2:1]` 表示权限，脏位要靠 DBM 或软件写保护；`task_struct->thread` 在 arm64 上也没有 `fsbase` 字段（TLS 走 `TPIDR_EL0`，对应 `tp_value`） | `uname -m` 先看架构；读 `arch/arm64/include/asm/pgtable-hwdef.h` 的 `PTE_AF`/`PTE_DBM`；x86 的结论只在 x86 上复核 |
| 「Clock 的基础是 `PG_lru`」 | `PG_lru` 是「页在 LRU 链表上」的标志，不是时钟算法的访问位；近似 LRU 靠 PTE 的 `A` 位（由 CPU 置位、内核清除）+ active/inactive 双链表 | 读 `/proc/kpageflags`（需 root，本机不可用）；退一步看 `Documentation/admin-guide/mm/` 的 LRU 描述；不要用 `PG_lru` 解释二次机会 |
| 「`rename` 是原子替换，任何情况都成立」 | 只在**同一个文件系统内**原子；跨挂载点返回 `EXDEV`。另外 glibc 在 aarch64 上把 `rename()` 编成 `renameat`，`strace -e trace=rename` 看不到 | `strace -f -e trace=%file ./aw ...`：VM 实测出现 `renameat(AT_FDCWD, "data.bin.tmp.<pid>", AT_FDCWD, "data.bin") = 0`；跨 FS 用 `df -T` 先确认 |
| 「`fsync` 之后数据一定在盘上」 | `fsync` 保证到设备缓存为止；设备带易失写缓存时还要 flush/FUA（见 3.13.5）。它只作用于一个对象：文件要 `fsync`，目录项要 `fsync` 目录 | `strace -e trace=%file` 数 `fsync` 的对象：VM 实测两次（文件 fd 3、目录 fd 3）；本机 `/proc/fs/ext4/sda2/options` 只显示 `rw`、`bsddf`、`nogrpid`，看不到 `data=ordered`（默认项不打印） |
| 「日志的 inode 号就是 8」 | 内部日志是 `mke2fs` 的约定（inode 8）；外部日志（`-J device=`）没有 inode 8，`has_journal` 也照样为真 | `sudo dumpe2fs -h`/`debugfs` 本机不可用；只能 `findmnt -no FSTYPE` 与 `filefrag` 推断，涉及日志号时写「未实测」 |
| 「`stat -f` 能看出 ext4」 | `stat -fc %T /` 返回 `ext2/ext3`——ext2/3/4 共用同一个魔数 `ef53`，stat 分不出来 | 用 `findmnt -no FSTYPE /`（本机 `ext4`）或 `df -T`；要特性列表只能 `tune2fs -l`（需 root） |
| 「容器限额就在 `/sys/fs/cgroup/cpu.max`」 | 根 cgroup 没有 `cpu.max`/`pids.max`/`memory.max`（root 不受限），必须读 `/proc/self/cgroup` 拼出自己的路径再读 | VM 实测：`/proc/self/cgroup` 是 `0::/user.slice/user-1000.slice/session-*.scope`，拼上 `/sys/fs/cgroup` 后 `cpu.max` 为 `max 100000`、`pids.max` 为 `max`、`cpu.weight` 为 `100`、`pids.current` 为 4 |
| 「cgroup v1 与 v2 只是路径不同」 | 接口名与语义都变了：v1 是 `cpu.cfs_quota_us`/`cpu.cfs_period_us` + `cpu.shares`（默认 1024，范围 2–262144）；v2 是 `cpu.max`（`quota period` 一行）+ `cpu.weight`（默认 100，范围 1–10000）；v1 `memory.limit_in_bytes` → v2 `memory.max`；v1 `pids/pids.max` → v2 `pids.max`。v1 按控制器分挂载点，v2 是统一层级 | `cat /proc/self/cgroup` 看是 `0::` 还是多行 `N:controller:`；`cat /sys/fs/cgroup/cgroup.controllers` 有内容说明是 v2 统一层级；换算 `weight = 1 + (shares−2)×9999/262142` |
| 「`vmstat` 的 `si/so` 是累计量」 | `si/so` 是**每秒**换入/换出的 KiB；累计页数在 `/proc/vmstat` 的 `pswpin`/`pswpout` | `vmstat 1` 看瞬时；`grep pswp /proc/vmstat` 看累计。VM 实测本机没有 swap 压力：`swpd`、`si`、`so` 全为 0，`pswpin`/`pswpout` 都是 0 |
| 「1.13.14 的三个实验都能照抄」 | 实验三用 `sudo dumpe2fs`/`debugfs`，本机没有 sudo；实验一的 `perf sched latency` 要 tracefs 读权限，本机报 `can't access trace events` | 替代链：`findmnt -no SOURCE,FSTYPE,OPTIONS /` + `filefrag -v` + `strace -e trace=%file`；调度看 `/proc/<pid>/sched` 与 `/proc/pressure/cpu` |
| 「swap 区就是一组连续槽」 | 对 swap 分区大致成立；swap **文件**要求预先分配、不能有空洞（`fallocate`），但底层块仍可能不连续；现代内核还支持多 swap 设备优先级、zswap/zram | `swapon --show` 看类型与优先级；`/proc/swaps` 的 `Type` 列区分 `partition` 与 `file` |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级、形状或方法**，不要抄成事实：

- **`fio` 的随机/顺序对照**（1.13.5）：`fio` 未安装，正文的 `--iodepth`/`--ioengine=libaio` 命令没有在本机跑过；磁盘 12 ms 与 83 IOPS 是模型算式，不是本机读数。
- **`stress-ng` 制造 swap 压力**（1.13.14）：未安装，也没有权限调 `vm.swappiness`；`pswpin`/`pswpout` 只验证了「0」这一侧。
- **`perf sched` 的等待延迟**（1.13.14）：`perf sched record` 报 `can't access trace events`，没有拿到 `wait-time`/`sched-delay` 的真实数字。
- **`sudo dumpe2fs`/`debugfs` 的 inode 与日志信息**（1.13.14 实验三）：无 sudo，日志 inode 号、`Journal size`、块组布局都未核对；只用 `filefrag` 看到了 extent。
- **断电注入验证 `fsync`**：只验证到「两次 `fsync` + 一个 `renameat` 且返回 0」，没有真的掉电或 `echo 1 > /proc/sys/kernel/sysrq` 这类注入，所以「崩溃后一定还在」仍是机制推论。
- **RAID 各级别的实测**：没有块设备可做，容量与容错按公式；重建时长、write hole 的表现未测。
- **xv6 与 rCore 的行数、文件清单**：按公开仓库的结构描述，没有在本机 clone 与统计。
- **OSTEP 的页码与小节边界**（1.13.12）：按正文的落点表核对结构，没有重读原书。
- **x86-64 侧的 PTE 位号与代码生成**：本书只有 aarch64 机器，位号表按架构文档描述；`thread_struct` 的字段差异只在 arm64 侧观察。
- **容器内 `cpu.max`/`pids.max` 的限额效果**：没有写权限，未制造 throttle 或 `EAGAIN`；只验证了宿主会话 scope 的「不限额」形状。
- **十万级进程/线程的调度压测**：没有做；本章的份额结论来自 2 个和 3 个忙循环。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/内核/文件系统/架构 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在环境上，所以请一并附上：`uname -a`；`gcc --version`；`findmnt -no SOURCE,FSTYPE,OPTIONS /`；`cat /proc/self/cgroup` 与对应的 `cpu.max`/`cpu.weight`；`grep -E 'se\.' /proc/<pid>/sched` 的原始输出；`vmstat 1 3` 与 `iostat -x 1 3` 各一段；以及是否绑核（`taskset -pc $$`）。涉及数字时写明口径：是模拟器的缺页数、`se.sum_exec_runtime` 的毫秒值、`minflt` 的增量、`strace` 的调用次数，还是 `dd`/`iostat` 的吞吐。本章多数分歧都出在把后一种数当前一种用。
