# 1.6 勘误与版本注记

这一页收本章最容易「记成永久真理」的东西：缓存层级参数在机型与虚拟化下的可得性、`perf` 与 `cachegrind` 的事件与几何可用性、AoS/SoA 与分块结论的可移植性、x86-64 与 aarch64 的差别。正文里的 `errata` 盒讲理解陷阱；这一页讲**换一台机器、换一个内核、换一个工具之后要复核什么**。

**本章基线**：正文的层级与延迟两张表（1.6.1、1.6.9）是 x86-64 服务器/桌面的典型量级，不是任何一台机器的规格；[1.6.13](ch06.md#sec-1.6.13) 的 1.69 倍与 [1.6.14](ch06.md#sec-1.6.14) 的 sysfs 四行、那组 GB/s 属于正文标注的 Apple M1；[1.6.12](ch06.md#sec-1.6.12) 的 miss 率是模拟器算出来的确定值。本书另外在一台 Ubuntu 24.04.5 虚拟机（aarch64、4 vCPU、约 12 GiB、内核 7.0.0-38-generic、GCC 13.3.0、`perf version 7.0.14`、Valgrind 3.22.0，`sudo` 不可用）上复跑过：模拟器的输出逐行与正文一致，`soa.c` 能编译运行但倍数不稳，`perf` 的硬件事件拿不到。凡标注「VM 实测」的是这台机器的读数，其余按第 5 节当作未实测。

## 1. 缓存层级参数依机型与虚拟化而定

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | 正文层级表里的容量与延迟是你机器的规格 | 那是典型量级：L1 32–48 KiB、L2 512 KiB–2 MB、L3 8–32 MiB、行 64 B、DRAM 60–100 ns；同代不同型号能差数倍 | 先读 sysfs、`getconf`、`lscpu` 三路（[例 1.6-C1](ch06-exercises.md#ex-1.6-C1)），拿不到就写「本机未知」 |
| 2 | `/sys/devices/system/cpu/cpu0/cache/index*` 在任何 Linux 上都给得出容量与相联度 | VM 实测：`index0`（L1 Data）、`index1`（L1 Instruction）、`index2`（L2 Unified）存在且 `level`、`type` 可读，但 `size`、`ways_of_associativity`、`coherency_line_size`、`number_of_sets` 这几个文件**不存在**；正文 1.6.14 那四行完整输出是 Apple M1 的形态 | 用 `[ -f 文件 ]` 判存在再读；把缺字段这件事本身当成结论的一部分 |
| 3 | `getconf LEVEL1_DCACHE_SIZE` 有值，0 表示容量是 0 | VM 实测：`LEVEL1_DCACHE_SIZE`、`LEVEL1_DCACHE_ASSOC`、`LEVEL2_CACHE_SIZE`、`LEVEL3_CACHE_SIZE` 全返回 0，只有 `LEVEL1_DCACHE_LINESIZE` 给 64——0 是「未提供」 | `getconf -a` 之后只看 cache 那几行；给 0 时不要用容量估块大小 |
| 4 | `lscpu` 一定打印 L1d/L2/L3 行 | VM 实测：这台 aarch64 上 `lscpu` 不给任何 cache 行，`Model name` 也是空，只有 `Architecture: aarch64`、`NUMA node(s): 1`、`NUMA node0 CPU(s): 0-3` | 别按示例的字段名去解析输出；换机器先看真实文本 |
| 5 | LLC 一定是所有核共享、越大越好 | 共享方式（每核切片、cluster 内共享）与容量随型号变；正文那台机器报的是 `index3` 12M、16 路，而 1.6.11 的误解盒已提醒「跨核访问 L3 仍有代价」 | 只在同一台机器上比较两个版本的缺失；跨机器比容量没有意义 |
| 6 | 「NUMA 远程访问慢 1.5–2 倍」是可复现结论 | VM 实测：`numactl --hardware` 报 `available: 1 nodes (0)`，单节点没有本地与远程之分，这条只能在真多节点机器上证 | 没有多节点就把 1.6.7 那句按量级引用，并写「本机未实测」 |
| 7 | 把延迟乘以主频换算成周期数就能替所有人算 | 正文的 4–5、12–20、40–70、200–300 周期都是量级；虚拟机里的实际频率与宿主调度不受你控制 | 有 PMU 时用 `perf stat` 的 `cycles` 与耗时推频率；本环境推不了就承认推不了 |
| 8 | 客户机里 `/sys/block/*/queue/rotational` 能证明后面是 SSD | VM 实测：`rotational=0`、`logical_block_size=512`、`physical_block_size=4096`，说明的是虚拟块设备暴露给客户的对齐参数，不代表后端介质；1.6.9 的 NAND 页/块与写放大不能靠它验 | 要证介质与队列深度需真机或厂商资料；本书未做 |

## 2. `perf` 与 `cachegrind` 的事件与几何可用性

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 9 | `perf` 装了就能读缓存事件 | VM 实测：`/usr/bin/perf` 存在（`perf version 7.0.14`），但 `perf stat` 的 `cpu-cycles` 显示 not supported；指定 `cache-misses`、`L1-dcache-load-misses`、`LLC-load-misses`、`dTLB-load-misses` 时直接报 `No supported events found`，并在报错里写明 `perf_event_paranoid setting is 4`、需要 `CAP_PERFMON`/`CAP_SYS_PTRACE`/`CAP_SYS_ADMIN` | `cat /proc/sys/kernel/perf_event_paranoid`；再 `perf list` 与一条最小 `perf stat` |
| 10 | 「把 `perf_event_paranoid` 调低就好」是常规步骤 | 那一步需要 root。本书 VM 上 `sudo` 需要密码、不可用，所以没有特权时这句不成立，应写成「需特权，本机未实测」 | 先确认自己有没有 `CAP_PERFMON`；没有就走 `cachegrind` 与墙钟 |
| 11 | `perf c2c` 随时能定位伪共享 | VM 实测：`perf c2c record` 报 `failed: no PMU supports the memory events`；正文 1.6.4 把它列为首选工具时，前提是有支持内存事件的 PMU | 先跑 `perf c2c record true` 看能不能启动；不能就用布局 A/B（[例 1.6-B5](ch06-exercises.md#ex-1.6-B5)） |
| 12 | `L1-dcache-load-misses`、`LLC-load-misses` 是通用事件名 | 这是 Intel/AMD 系列的叫法，ARM64 平台的事件名与是否存在都不同；同一个命令在两个架构上给出不一样的一组字段 | `perf list` 里搜 cache 与 tlb，再决定读什么 |
| 13 | 正文 1.6.8 与 1.6.14 里那两段 `perf` 输出可以在你机器上复现 | 那是示例形态（字段名与百分比排版），用来说明怎么读；本书环境从未取得过这些计数 | 只当读法示范；自己跑出来的才是你的数 |
| 14 | cachegrind 固定模拟 32 KiB L1、64 B 行 | 正文 1.6.14 那句「默认 32 KB L1」在这台 VM 上不成立：它打印 `Cannot auto-detect cache config, using defaults`，`cg_annotate` 元数据显示实际用的是 D1 16384 B/64 B/4 路、LL 262144 B/64 B/8 路 | 每次先看 `cg_annotate` 的 Metadata 段，或显式传 `--I1`、`--D1`、`--LL` 再解释计数 |
| 15 | `cg_annotate` 可以直接吃 `cachegrind.out.*` | VM 实测：把两次运行的多个文件一起喂会报 `events in data files don't match`；而且不加 `-g` 编译时逐行注释是空的，只有函数级 | 用 `ls -t` 取最新一个文件；编译带 `-g`（[例 1.6-C3](ch06-exercises.md#ex-1.6-C3)） |
| 16 | cachegrind 的运行时间也能看 | VM 实测：同一份 `soa` 在模拟下给出 AoS 47.990 ms、SoA 13.291 ms、比值 3.61 倍，与原生运行的 1.21–1.89 倍完全不是一回事；它慢 20–50 倍 | 只用它的计数做 A/B；先把 $N$ 调小确认流程 |

## 3. AoS/SoA 与分块结论的可移植性

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 17 | 「AoS 换 SoA 就快 4 倍」 | 字节数差 4 倍，正文实测时间只差 1.69 倍（Apple M1）。原因写在 1.6.13：预取与向量化吸收了部分多读、SoA 循环受加法吞吐限制、两个 `effective GB/s` 的口径不同 | 改之前先测缺失（`LLC-load-misses` 或 `cachegrind` 的 `D1mr`），改之后只比自己与自己 |
| 18 | 那个 1.69 倍可以当结论引用 | 它属于单台机器、单次读数：没记绑核、重复次数与频率。VM 上同一份源码相邻两次跑出 1.89 与 1.21，且 AoS 的时间从 2.800 ms 跳到 12.557 ms——虚拟机的方差能盖过效应本身 | 至少 5 次取最小值、`taskset` 绑核；报倍数必须报机器与重复次数 |
| 19 | 校验值一致就说明计时可信 | `sink=2132783616.000000` 在两台机器、三种运行方式下都相同，它只证明**语义没改**；时间仍可能被调度、页缓存、频率左右 | 用校验值排除改错，用重复次数排除噪声，两步不能合并 |
| 20 | 分块一定比循环交换更值钱 | 正文在 L2 很大（标注 12 MiB）的那台机器上 `block64` 没赢过 `ikj`；分块治的是容量性缺失与别名，循环交换已经把行用满时它就没有可省的字节 | 先算 $3b^2\times 8$ 与目标层容量，取两档实测；见 [例 1.6-C7](ch06-exercises.md#ex-1.6-C7) |
| 21 | 「M1 的 L2 有 12 MiB」是可靠口径 | 正文用它解释分块没赢；容量数字与共享方式（每核还是 cluster 共享）本书未复核，而 sysfs 的 `index2`/`index3` 在不同机器上的含义并不总是一致 | 读自己机器的层级；读不到就把结论写成条件式 |
| 22 | 68 GB、410 MB、1/166 是测出来的 | 是纸面模型：68 GB 是「每次访问都缺」的上界，410 MB 假设块内三个子矩阵完全驻留；实际有 L2/L3 吸收，也有计算成为新瓶颈 | 用它定方向（搬得少才是主因），不要拿它对读数 |
| 23 | 1.6.12 的 miss 率是硬件测量 | 那是你写的模拟器的确定计算：$1/(\text{block}/\text{stride})$，所以 macOS 与 VM 逐行一致；它不建预取、乱序、多级共享 | 用它讲「步长与映射」的关系；讲真机缺失要用 `perf` 或 cachegrind |

## 4. x86-64 与 aarch64 的差别

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 24 | `movnt`/`stnp` 一类非临时存储到处可用 | 属 x86 的 intrinsic；ARM64 上的等价写法本书未实测，正文也只在 x86 语境提「绕过缓存」。VM 是 aarch64，所以那条陷阱 4 的修法在这里不适用 | 查目标编译器的内建与文档；否则退回布局与分块这两个可移植手段 |
| 25 | 缓存行都是 64 B，所以 `alignas(64)` 永远够 | 64 B 是 x86-64 与 ARM64 的常见值（VM 上 `getconf LEVEL1_DCACHE_LINESIZE` 也给 64），但各层的共享方式与预取窗口不同，行大小本身不是保证 | 先读 linesize 再定对齐常量，并在代码注释里写清假设 |
| 26 | MESI 就是所有平台的一致性协议 | 正文讲的是教学模型；真实实现多为变体（如 MESIF、MOESI），本书未展开也未验证。可移植的结论只有「写之前要拿到独占权，同行写会互相失效」 | 需要细节时查目标型号手册；伪共享在两种架构上都能用 A/B 证 |
| 27 | 48 位虚拟地址、四级页表是通用配置 | 那是 x86-64 常用形态，1.6.7 的页表遍历图按它画；ARM64 的级数与块大小随地址宽度、页粒度（可为 16 KiB）不同 | 机制在 [1.9.3](ch09.md#sec-1.9.3)，三架构并排看 [1.14.10](ch14.md#sec-1.14.10) |
| 28 | 大页就是 2 MiB 与 1 GiB | x86-64 的常用粒度；ARM64 依赖块大小与内核配置。两边都一样的是：THP 的开关值与是否真的用上要自己读 | 读 `/sys/kernel/mm/transparent_hugepage/enabled`，再看 `/proc/self/smaps_rollup` 的 `AnonHugePages`（[例 1.6-C5](ch06-exercises.md#ex-1.6-C5)） |
| 29 | 硬件预取器对固定步长的识别能力两边相同 | 正文「部分 CPU 能预取 4–16 个步长」是量级说法，本书未在任何机器上验证；这一条直接影响列优先与大步长实验的差距有多大 | 用你自己机器的步长曲线判断（[例 1.6-C6](ch06-exercises.md#ex-1.6-C6)）；别引用别人的差值 |
| 30 | 正文的位数算式在 48 位以下也一律成立 | 拆位只依赖 $S$ 与 $B$，但 `tag` 长度依赖地址位宽：1.6.3 按 32 位算得 20 位，1.6.10 按 48 位算得 36 位，两处不是同一题 | 算之前先写清用虚拟还是物理地址、多少位；见 [例 1.6-A3](ch06-exercises.md#ex-1.6-A3) 的相联度变位 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级或方法**，不要抄成事实：

- **所有 `perf` 读数**。本书的 Linux 虚拟机虽然装了 `perf`，但 `perf_event_paranoid` 为 4 且没有特权，缓存、TLB、周期、指令计数都取不到；`perf c2c` 明确报不支持内存事件。正文 1.6.8 与 1.6.14 里的 `perf stat` 输出是示例形态。`stalled-cycles-*`、`-e L1-dcache-load-misses` 在不同内核与 CPU 上的支持情况也未验证。
- **TLB 与大页省下的时间**。正文「4 KiB 页随机访问 1 GB 工作集时 `dTLB-load-misses` 可能上百万、改 2 MiB 后降一到两个数量级」是量级说法，未实测；本书只验到「大页确实能用上」这一步——VM 实测 `madvise(MADV_HUGEPAGE)` 后 `AnonHugePages` 为 65536 kB、`Rss` 为 66940 kB，而省了多少时间没测（缺 dTLB 事件）。
- **NUMA 远程访问的 1.5–2 倍与绑定收益**。本书虚拟机只有 1 个节点，`numactl --cpunodebind` 与 `--membind` 的对照实验做不了；1.6.7 与 1.6.15 第 11 条按文献量级引用。
- **内存山那组 GB/s**（32 KiB 约 26、64 MiB 约 37、stride 64 约 9.7、stride 512 约 1.1）：正文自己标注来自 Apple M1、未在 x86-64 复测；本书的虚拟机上未重跑，小工作集被加法依赖链封顶这一点也未单独验证。
- **1.6.13 的 3.914 ms、2.319 ms 与 1.69 倍**：属于正文标注的那台 M1。VM 复跑给出 1.89 与 1.21 两次倍数、以及相邻两次 AoS 相差约 4.5 倍的时间，说明这台机器上「倍数」不可引用，只有「SoA 不慢于 AoS」这个方向稳定。
- **列优先与行优先的 8:1**：1.6.2 的缺失比是按缓存行与步长推出来的，正文那段行/列求和程序的时间比在本书环境未复测；「预取器能识别 4–16 个步长」同样未测。
- **1.6.1 与 1.6.9 两张表的全部数值**：L1 到 HDD 的容量、延迟、带宽，NVMe 与 SATA 的 4K 随机 IOPS，写放大 3–10 倍，TRIM 与垃圾回收的效果，DRAM 行缓冲命中带来的加速——都是文献与厂商量级，本书未在任何机器上核实。
- **真实处理器的层级几何**：LLC 是否共享、每核切片大小、L1 相联度、`index2`/`index3` 在 ARM 大小核上的对应关系；本 VM 的相关 sysfs 字段不存在，正文 M1 那组数也未复核。
- **需要特权的条目**：`fstrim.timer`、挂载选项 `discard`、`losetup`/`mount` 类的 I/O 路径实验、把 `perf_event_paranoid` 调低——需 root，本机未实测。
- **与 CSAPP 的核对方式**：中文第 3 版在本机是纯扫描版、没有文本层，`tesseract` 缺 `chi_sim`，中文 OCR 不可用。本章只按 6.1–6.7 的章节结构核对覆盖范围（p435–p486，逐小节状态见正文末「母本对应」），没有引用书里的句子和页内数字；书中有而本章未展开的（如具体的映射函数变体、虚拟地址到物理地址的完整翻译细节）留给 [1.9](ch09.md) 与习题。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/内核/编译器/工具版本 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在环境与权限上，所以请一并附上这几行：`uname -a`；`lscpu` 的 `Architecture` 与 `Model name` 行（拿不到就写空）；`getconf -a` 里 cache 相关行；`/sys/devices/system/cpu/cpu0/cache/` 的目录清单与各 `index*` 下实际存在的文件；`cat /proc/sys/kernel/perf_event_paranoid`；`perf --version` 与 `valgrind --version`；完整的编译命令（有没有 `-g`、`-O2`）；有没有 `taskset` 绑核、跑了几次取什么统计量。

涉及数字时请写明**口径**：那个 miss 率来自 1.6.12 的模拟器、`cachegrind` 的模拟几何，还是真机 PMU；那个倍数是墙钟、CPE 还是 `effective GB/s`。本章的多数分歧都出在把前一种数当后一种用。这张表按同一格式继续增补。
