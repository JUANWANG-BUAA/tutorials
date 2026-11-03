# 1.9 勘误与版本注记

这一页收本章最容易「记成永久真理」的东西：48 位/四级页表是不是通用配置、页大小是不是 4096、`perf` 与 `/proc` 的字段在不同内核上给不给、以及 1.9.11/1.9.12 里那些输出到底属于谁。正文里的 `errata` 盒讲理解陷阱；这一页讲**换一台机器、换一个内核、换一种页大小之后要复核什么**。

**本章基线**：正文的页表数字按 x86-64、4 KiB 页、48 位虚拟地址、四级页表讲，是教学条件，不是任何一台机器的规格。本书在一台 Ubuntu 24.04.5 虚拟机（aarch64、4 vCPU、内核 7.0.0-38-generic、GCC 13.3.0、glibc 2.39、`sudo` 不可用）上复核过：`getconf PAGE_SIZE` 与 `getconf PAGESIZE` 都给 4096；THP 为 `always [madvise] never`；`perf_event_paranoid` 为 4，`perf stat` 直接拒绝；`/proc/self/smaps_rollup` 有 `Rss`/`Pss`/`AnonHugePages` 及 `Pss_Dirty`/`Pss_Anon`/`Pss_File`/`Pss_Shmem` 等字段。标注「VM 实测」的是这台机器；其余按文末「本章未实测项」当作待验证的方法或量级。

## 一、容易搬家的十四条

| # | 看起来像 | 实际是（怎么验证） |
|:--|:--|:--|
| A1 | 48 位虚拟地址、四级页表、9/9/9/9/12 是通用配置 | 这是 x86-64 的常用形态。ARM64 可用 4/16/64 KiB 基础页，页表级数随地址宽度与页粒度变（常见 3–4 级）；通用的是「索引 → 表项 → 下一级」的结构，不是位数。先 `getconf PAGE_SIZE`、`uname -m`，再决定用哪套拆分。 |
| A2 | `grep -m1 'address sizes' /proc/cpuinfo` 会打印「46 bits physical, 48 bits virtual」 | 这是 x86 的字段。VM 实测（aarch64、内核 7.0.0-38）：该 grep 无输出、退出码 1；拿它判断地址位宽会得到空结果。换架构先看 `/proc/cpuinfo` 的真实字段，不要照抄示例。 |
| A3 | `grep la57 /proc/cpuinfo` 能说明五级页表可用，57 位/128 PB 是通用上限 | `la57` 是 x86 的 CPU 标志；VM 实测同样无此字段。57 位、128 PB 是 x86 LA57 语境；ARM64 的虚拟地址宽度另算。1.9.1 的「用户空间 128 TiB → 64 PiB」与 1.9.8 的「整空间 256 TB → 128 PB」也不是同一口径，差在「用户半区」与「整空间」。 |
| A4 | PTE 的位序（bit 63 NX、bit 59–62 PK、PFN 12–51）跨架构一致 | 那是 x86-64 的描述符布局。ARM64 用另一套描述符位（如 AF、AP、UXN/PXN、Contiguous），不能把 x86 的位表套到 ARM64。读 PTE 位之前先确认架构与内核文档版本。 |
| K1 | `perf stat -e page-faults,minor-faults,major-faults` 随时能读 | VM 实测：内核 7.0.0-38、`perf_event_paranoid=4`，`perf stat` 直接打印权限说明并退出，连 `page-faults` 也拿不到。1.9.13 的那段计数是**形状示例**。替代：`/usr/bin/time -v` 的 minor/major faults、`/proc/$pid/stat` 的 `min_flt`/`maj_flt`。 |
| K2 | `/proc/self/smaps_rollup` 只有 `Rss`、`Pss`、`Shared_Clean`、`Private_Dirty`、`Swap` 五行 | VM 实测：除这些外还有 `Pss_Dirty`、`Pss_Anon`、`Pss_File`、`Pss_Shmem`、`SwapPss` 等；字段随内核版本增加。按 key 读（`grep -E -e Rss -e Pss`），不要按行号读，也不要把示例的五行当完整 schema。 |
| K3 | `/proc/self/pagemap` 能读到物理页框号 PFN | 内核 4.0 起，非特权进程读到的 PFN 恒为 0；要非零需要 `CAP_SYS_ADMIN`。本书 VM 上 `sudo` 不可用，所以「pagemap 查 PFN」这一项**本机未实测**。`present`/`swapped` 位仍可用于「页在不在」的判断（若文件可读）；替代是 `mincore` 与 `smaps` 的 `Rss`。 |
| K4 | 透明大页默认 `always`，`madvise` 返回 0 就生效 | VM 实测：`enabled` 是 `always [madvise] never`，即只有显式 `madvise(MADV_HUGEPAGE)` 的区间才可能合并；返回 0 只表示调用成功。要读 `smaps_rollup` 的 `AnonHugePages`（或对应 VMA 的 `smaps`）确认真的拿到 2 MiB 页，并检查映射是否 2 MiB 对齐、`defrag` 策略是否允许。 |
| K5 | `MAP_FIXED_NOREPLACE`、`MADV_FREE`、`MADV_COLLAPSE` 在任何 Linux 上都能用 | 它们是按内核版本引入的：`MAP_FIXED_NOREPLACE` 自 4.17，`MADV_FREE` 自 4.5，`MADV_COLLAPSE` 更晚。老内核上可能返回 `EINVAL`/`ENOSYS`。用 `uname -r` 与 man page 的「Linux x.y」节核对，不要假定「Linux 都支持」。 |
| P1 | 页大小总是 4096 | VM 实测 aarch64 上是 4096，但 Apple Silicon 是 16 KiB，ARM64 还可配置 4/16/64 KiB。页大小一变，9/9/9/9/12 里的 offset 位数、`SIGBUS` 的页边界、`mmap` 的 `offset` 对齐全都变。代码里一律用 `sysconf(_SC_PAGESIZE)`。 |
| P2 | 1.9.12 的 `SIGBUS` 总在 `p[4096]` | `p[body]` 的 `body = ceil(len/ps)*ps`，边界等于**系统页大小**，不是固定的 4096。VM 实测 4 KiB 页、`/etc/hostname` 21 字节时 `caught at p[4096]`；正文说 13 字节是另一台机器；Apple Silicon 16 KiB 页上同一份代码会打印 `p[16384]`。 |
| P3 | `mmap` 的 `offset` 按 4 KiB 对齐就够 | 必须是**系统页大小**的倍数。16 KiB 页的机器上传 `offset=4096` 会得到 `EINVAL`；4 KiB 页上则合法。写跨平台代码时用 `sysconf(_SC_PAGESIZE)` 算对齐，不要写常量 4096。 |
| P4 | 1.9.12 输出里的 `len=13`、`first=h`、`last=` 是程序行为 | 那是示例文件的长度与内容。VM 实测 `/etc/hostname` 是 21 字节，`first`/`last` 也随之不同；换文件更会变。程序的**形状**（`len`、`first`、`last`、`caught at p[body]`、`pages/resident`）稳定，具体字符与数字不稳定。 |
| P5 | 页大小只影响偏移，不影响分配器与 VMA | 页大小同时影响「最小映射粒度」「`brk` 的对齐」「`mmap` 的 `offset`」「`mincore` 的向量长度」「`SIGBUS` 的边界」。分配器内部的 16 B 对齐与页大小是两件事，别把 `malloc` 的 16 B 对齐当成页对齐；大块 `mmap` 的阈值（128 KiB）又按字节算，与页大小无关。 |

## 二、本章结构注记（不是版本差异，但会影响读法）

本章是一份合并稿，有三处主题重叠：**1.9.3 与 1.9.8** 都讲四级页表 walk（前者用 `0x00007f3c5d2e8a40`，后者用 `0x00007f8c12345678`），**1.9.5 与 1.9.9** 都讲 `mmap`（前者给组合与 `mmap_cat`，后者给参数表、errno 与信号），**1.9.6 与 1.9.10** 都讲分配器（前者给边界标记与 `alloc.c`，后者给 glibc bins 与 GC）。把它们当「速览 → 深挖」的配对读，不要当 16 个互不相干的新主题；两处的数字也不要混用：

- 1.9.6 的例子按「头 16 B + 脚 8 B」算，100 B 请求得 128 B 块；1.9.11 的程序用 `WSIZE=8`，头脚各 8 B，24 B 请求得 48 B 块。`used=208` 属于后者的块布局，不能拿去核对前者的 128。
- 1.9.1 说用户态可用空间「128 TiB → 64 PiB」，1.9.8 说「256 TB → 128 PB」；前者是用户半区，后者是整空间，两者不矛盾，但引用时要带口径。
- [1.1.5](ch01.md#sec-1.1.5) 用「47 位用户地址」描述 x86-64 用户态，本章用「48 位 VA、bit 47 为符号位」；这是同一条规范地址规则的两种说法（48 位里最高位用于符号扩展，用户半区实际 47 位可寻址），不是两个不同的位数。

## 三、本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级或方法**，不要抄成事实：

- **1.9.13 的全部 `perf` 计数**。VM 的 `perf_event_paranoid=4`，连软件事件都拒绝；`1,234 page-faults`、`34 major-faults` 是形状示例。`dTLB-load-misses`、`cache-misses` 在本环境同样拿不到。
- **`/proc/self/pagemap` 的 PFN**。非特权读到 0，`CAP_SYS_ADMIN` 才有非零值；本书 VM 无 `sudo`，未实测「PFN 与物理页对应」这一步。
- **大页省下的时间**。VM 只验到「THP 策略是 `madvise`、`AnonHugePages` 可读」；`madvise(MADV_HUGEPAGE)` 后到底省了多少 TLB 未命中与时间，缺 `dTLB` 事件，未测。
- **五级页表（LA57）与 57 位地址**。VM 是 aarch64，没有 `la57` 字段；正文的 57 位、128 PB、多一级 walk 只按文档与 x86 资料写，未在硬件上验证。
- **`MAP_HUGETLB`、`MAP_SYNC`、DAX、`MAP_FIXED_NOREPLACE` 的具体内核行为**。正文只给语义与版本门槛；本书没有 hugetlbfs 配置，也没有 DAX 设备，全部未实测。
- **KSM / `MADV_MERGEABLE` 的去重收益与侧信道风险**。正文按机制描述，未在 VM 上开启或计量。
- **1.9.11 的分配器输出**（`a=0x1006d8028 ... used=208`、`d=... reused=1`）。地址形态属于示例机器，`used=208/160` 取决于该程序的 8 B 头脚布局；本书未在 VM 上重跑这份代码，不能把地址当 Linux 输出。
- **1.9.12 的 `len=13 first=h last=`**。VM 实测 `/etc/hostname` 是 21 字节，`first`/`last` 不同；正文的 13 字节属于另一台机器，输出里的换行符也不可见。
- **1.9.12 在 Apple Silicon 上的 `p[16384]`**。正文按 16 KiB 页推断，本书没有 Apple 机器实测；可移植的结论只有「边界 = `sysconf(_SC_PAGESIZE)`」。
- **glibc `malloc` 阈值的动态调整、fastbin 的确切上限、arena 数量**。正文给的是常见默认值（128 KiB、≤128 B、每线程 arena）；具体值随 glibc 版本、`MALLOC_MMAP_THRESHOLD_`、`MALLOC_ARENA_MAX` 与分配历史变，本书只验到「64 MiB 走 `mmap`、100 KiB 走 `brk`」这一条（VM 实测）。
- **TLB shootdown 的实际延迟与 IPI 成本**。正文只给机制；VM 是 4 vCPU 虚拟环境，测不了真实跨核同步开销。
- **CSAPP 第 9 章的页码与逐小节页码**。正文末的页码表照录，本书没有逐页复核扫描版；只按 9.1–9.12 的结构核对覆盖范围。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/内核/编译器/工具版本 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在页大小、内核版本与权限上，所以请一并附上这几行：`uname -a`；`uname -m`；`getconf PAGE_SIZE`；`getconf PAGESIZE`；`ldd --version`；`cat /sys/kernel/mm/transparent_hugepage/enabled`；`cat /proc/sys/kernel/perf_event_paranoid`；`perf --version`；`gcc --version`；以及涉及的完整命令（`strace` 的过滤条件、`mmap` 的 `offset`、`malloc` 的大小）。涉及数字时写明**口径**：那是 4 KiB/48 位下的纸面计算、某台机器的墙钟、还是 `perf` 的真机计数。本章的多数分歧都出在把前一种数当后一种用。这张表按同一格式继续增补。
