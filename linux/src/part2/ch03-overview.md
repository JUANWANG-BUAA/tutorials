# 2.3 高级文件 I/O：原子性、fcntl、mmap 与文件锁 · 本章导航

::: preview 这一章在讲什么
[2.2](ch02.md) 给你五个函数和三条纪律：短读要循环、短写要循环、`EINTR` 要重试。那是最小可用。真实程序很快撞上它管不着的三件事：两个线程共用一个 fd、偏移互相踩；想给日志加锁却分不清 `flock` 和 `fcntl` 哪个对；配置写到一半断电，重启读到半个 JSON。这一章补三块能力——**不共享偏移的读写**、**把文件映射进内存**、**多进程安全地共享文件**，它们围绕同一个主题：**多条系统调用之间没有原子性，必须用内核原语把「检查 + 修改」压成一步**。`fcntl` 是门把手：它既改 fd 标志，也是记录锁与 memfd seals 的入口。
:::

## 本章回答什么

- **`fcntl` 能改什么、不能改什么**：五类操作（读写状态 flags、读写 fd flags、复制 fd、记录锁、`F_OFD_*`）与第三参数随 `cmd` 变的契约；访问模式在 `open` 时定死，`F_SETFL` 静默忽略它（2.3.1）。
- **`dup` 家族复制的是哪一层**：复制 fd 表项而不是 `struct file`，所以偏移、状态 flags、`flock` 锁全共享；`dup2` 的价值是「原子关闭 + 复制」，`dup3` 只认 `O_CLOEXEC` 且 `oldfd == newfd` 报 `EINVAL`（2.3.2）。
- **怎么彻底躲开共享偏移**：`pread`/`pwrite` 把偏移当参数、不碰 `f_pos`；`readv`/`writev` 一次搬多段，短写后必须推进 `iovec` 而不是重试整个数组（2.3.3）。
- **`mmap` 到底是什么**：建一个 VMA（虚拟内存区域，内核里描述一段地址范围的表项），访问映射区就是访问 page cache；既不「把文件读进内存」也不绕过内核。`MAP_FAILED` 不是 NULL，`offset` 必须页对齐（2.3.4、2.3.9）。
- **什么时候 `SIGBUS`、什么时候 `SIGSEGV`**：地址不在任何 VMA 里是 `SIGSEGV`；在映射长度内但落在文件 EOF 之后的整页是 `SIGBUS`；同一页里超出 EOF 的尾部读为 0（2.3.4、2.3.10）。
- **映射建完之后还能做什么**：`msync` 只对共享映射有意义、`madvise(MADV_DONTNEED)` 在私有匿名映射上是破坏性的、`mlock` 受 `RLIMIT_MEMLOCK`、`mincore` 只是快照、`mremap` 可能搬家（2.3.11、2.3.4）。
- **不落盘的共享内存对象**：`memfd_create` + `F_ADD_SEALS` 把「内容不可变」变成内核强制，封印不可撤销（2.3.12）。
- **两套锁为什么互不认对方**：`flock` 归打开文件描述、`fcntl`/POSIX 记录锁归进程、OFD 锁归打开文件描述；POSIX 锁关闭该文件**任意** fd 就释放全部，`flock` 与记录锁混用不互斥（2.3.6、2.3.15）。
- **怎样让一次发布崩溃后要么是旧版要么是新版**：同目录临时文件 → `fsync(fd)` → `close` → `rename` → **父目录 `fsync`**；`O_TMPFILE` 连临时名字都省掉（2.3.7）。
- **空间与搬运**：`fallocate` 真分配磁盘块、`ftruncate` 只改逻辑大小；`O_DIRECT` 三项对齐；`sendfile`/`splice`/`tee`/`copy_file_range` 各有什么 fd 类型限制、失败怎么降级（2.3.5、2.3.8、2.3.13、2.3.14）。
- **内核侧与读数**：`mmap` 只登记 VMA、缺页才读盘；`strace` 看调用、`/proc/PID/smaps` 看驻留（2.3.16、2.3.17）。
- **哪些结论会搬家**：本章三组陷阱清单与出口检查（2.3.18、2.3.19），以及换架构、换内核、换文件系统之后要复核什么（[勘误页](ch03-errata.md)）。

## 读完你会

- 说出 `F_SETFL` 与 `F_GETFL` 为什么必须成对使用、`fcntl(fd, F_SETFL, O_NONBLOCK)` 错在哪、为什么「读-改-写」本身不是原子的。
- 用 `F_DUPFD_CLOEXEC`/`dup2`/`dup3` 三种写法各设一次 `FD_CLOEXEC`，并说出「事后补有竞态窗口」具体指什么。
- 把多线程共用 fd 的代码改成 `pread`/`pwrite`，并解释为什么 `lseek` + `read` 天然有竞态。
- 写出正确的 `writev` 短写循环：按已写字节数推进或切短当前 `iovec`，不重试整个数组。
- 用 `mmap` 原地改写文件并读回验证；解释 `SIGBUS` 的触发条件，并给出「访问前 `fstat` 比对 `st_size`」或加锁两种防御。
- 判断一次 `MAP_PRIVATE` 的修改会不会落盘、一次 `MAP_SHARED` 的修改什么时候对其他进程可见、什么时候才真正到磁盘。
- 用记录锁实现单实例程序，第二个实例退出码 2；用 `/proc/locks` 与 `lslocks` 看锁；解释 `fork` 后子进程为什么不继承记录锁却共享 `flock`。
- 用 OFD 锁（`F_OFD_SETLK`）避开「关任意 fd 释放全部锁」这个历史缺陷，并说明它和 `flock` 仍不互通。
- 写出「临时文件 + `O_CREAT|O_EXCL` → 写完 → `fsync` → `close` → `rename` → 目录 `fsync`」的原子发布，并说清每步防的是哪种崩溃。
- 用 `fallocate(KEEP_SIZE)` 预分配、`PUNCH_HOLE` 打洞，并用 `st_blocks` 与 `SEEK_DATA`/`SEEK_HOLE` 验证；区分「`st_size` 变了」与「块数变了」。
- 用 `splice` 把文件搬过管道、用 `copy_file_range` 同机复制，并在 `EXDEV`/`EOPNOTSUPP` 时回退到 `read`/`write` 循环。
- 遇到「锁加了但挡不住别人」「`mmap` 后数据看不见」「发布后读到半个文件」，按「现象 → 机制 → 证据 → 修法」四段给出可复核的答案。

## 先修与预计学时

- 三层对象（fd 表 / 打开文件描述 / inode）与返回值契约：[2.2 文件 I/O](ch02.md)，尤其 `O_APPEND`、`pread`、`fsync`、`O_TMPFILE` 四节。
- 错误处理纪律：[2.1.3 `errno` 的七条规则](ch01.md#sec-2.1.3)、[2.1.4 三层错误处理](ch01.md#sec-2.1.4)。
- 缓冲与 `fflush`：[2.4 缓冲与 stdio](ch04.md)（本章 2.3.2 与 2.3.6 都留了「先刷缓冲再换 fd / 再解锁」的尾巴）。
- 进程与 `fork`：[2.7 进程创建与终止](ch07.md)（2.3.15 的锁继承、2.3.10 的子进程 `SIGBUS` 都要用）；「进程=地址空间 + fd 表」这层模型在 [1.13 操作系统导论](../part1/ch13.md)。
- 阅读：约 150 分钟（19 节 + 1 个子节，正文有 10 个可编译程序）。C 组六个实验：约 80 分钟。章末习题：约 80 分钟。

## 这条主线怎么走

**第一段，骨架：八个能力点（2.3.1–2.3.8）。** 先把工具箱摊开。`fcntl` 是万能把手，但它只能改行为位，改不了访问模式，「读-改-写」两步之间还会丢更新。`dup` 家族复制的是表项不是对象，所以两个 fd 共享偏移和 `flock` 锁——这既是重定向 stdout 的基础，也是竞态的来源。`pread`/`pwrite` 把偏移变成参数，一次消掉共享偏移这一整类 bug；`readv`/`writev` 把多段拼成一次 I/O，短写后要推进数组。`mmap` 的基本模型只有一句：建 VMA、访问即访问 page cache、缺页才读盘；代价是 `SIGBUS`、页对齐和「文件会被别人截断」。零拷贝三接口先认形状，两套锁先认归属，原子发布先记住四步，`O_DIRECT`/`fallocate`/`ftruncate` 先记住「对齐」与「块 vs 大小」。

**第二段，映射的全表与缺页（2.3.9–2.3.12）。** 骨架之后逐个做全表。`MAP_*` 分「必须二选一」与「可叠加」两类；四种映射类型（私有/共享 × 文件/匿名）决定 `fork` 后谁看得见谁。`prot` 与 fd 打开模式的规则比「不能超过」更精确：`O_WRONLY` 映射不了，`O_RDONLY` 只能共享只读，因为很多架构没有「只写页」。缺页路径解释 `SIGSEGV` 与 `SIGBUS` 的分界：一个是「这地址不属于你」，一个是「地址属于你，背后的对象不在了」。`msync`/`madvise`/`mlock`/`mincore`/`mremap` 是映射之后的五个旋钮，其中只有 `msync(MS_SYNC)` 与 `mlock` 有强制语义，其余是提示或快照。`memfd_create` + seals 把匿名共享内存变成「有 fd、可传、可封印」的对象。

**第三段，空间与搬运（2.3.13–2.3.14）。** `fallocate` 的七种 mode 各自改动的是块还是大小，`posix_fallocate` 与它的差别在返回值与降级路径。零拷贝省的是「内核 ↔ 用户态」那两次拷贝，DMA 与 page cache 一步不少；`sendfile` 要可 `mmap` 的输入、`splice` 至少一端是管道、`tee` 只复制管道、`vmsplice` 借用户页、`copy_file_range` 可能 `EXDEV`——每一个都要写降级路径。

**第四段，锁的完整语义（2.3.15）。** 三种锁的归属不同，导致三组可见差异：`fork` 后谁继承、关闭哪个 fd 会释放、`/proc/locks` 里 PID 为什么是 -1。POSIX 记录锁「关闭该文件任意 fd 就释放全部」是历史缺陷，OFD 锁补上了它，但 OFD 与 `flock` 仍然互不认对方。强制锁在 Linux 5.15 已移除，别按它设计。

**第五段，内核、取证与收口（2.3.16–2.3.19）。** 建映射的七层路径解释「`mmap` 为什么快、第一次访问为什么慢」；缺页路径给出 `filemap_fault`/`do_wp_page`/`do_shared_fault` 三个岔口。取证两件工具：`strace` 看调用与 flags，`/proc/PID/smaps` 看 `Rss`/`Pss`/`Private_Dirty`。2.3.18 把三组陷阱按「现象 → 原因 → 修复」列成清单，2.3.19 是九行出口检查，逐条打勾在[自检表](ch03-checklist.md)。

一句话主线：**凡「两步合成一件事」先问内核有没有一步原语（`F_SETFL` 的读-改-写、`lseek`+`write`、检查+创建、加锁+写+解锁、写+改名）；凡结论依赖某个数值或行为，先在本机跑一遍再说——`flock` 与记录锁互不认、`MAP_PRIVATE` 的修改不落盘、目录不 `fsync` 目录项就不在，这三件事都能用一条命令证明。**

## 本章路线：五段，一条主线

| 分段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、骨架：八个能力点** | [2.3.1](ch03.md#sec-2.3.1)–[2.3.8](ch03.md#sec-2.3.8)（含 [2.3.6.1](ch03.md#sec-2.3.6.1)） | `fcntl` 能改哪三位？`dup` 复制的是哪一层？`pread` 怎么消竞态、`writev` 短写怎么推进？`mmap` 的模型与 `SIGBUS`？两套锁先认归属；原子发布四步；`O_DIRECT`/`fallocate`/`ftruncate` 各管什么？ |
| **二、映射全表与缺页** | [2.3.9](ch03.md#sec-2.3.9)–[2.3.12](ch03.md#sec-2.3.12) | `MAP_*` 每个标志改什么？四种映射类型在 `fork` 后各怎么表现？`SIGSEGV` 与 `SIGBUS` 的分界？`msync`/`madvise`/`mlock`/`mincore`/`mremap` 哪些是强制哪些是提示？memfd 的 seal 能防住谁？ |
| **三、空间与搬运** | [2.3.13](ch03.md#sec-2.3.13)、[2.3.14](ch03.md#sec-2.3.14) | `fallocate` 七种 mode 各自动块还是动大小？打洞为什么必须配 `KEEP_SIZE`？零拷贝到底省哪两次拷贝、每种接口的 fd 类型限制与降级路径是什么？ |
| **四、锁的完整语义** | [2.3.15](ch03.md#sec-2.3.15) | 三种锁的归属、释放时机、冲突范围差在哪？OFD 锁补的是哪个缺陷？`/proc/locks` 每列读什么？ |
| **五、内核、取证与收口** | [2.3.16](ch03.md#sec-2.3.16)–[2.3.19](ch03.md#sec-2.3.19) | `mmap` 在内核里经过哪些函数、缺页走哪三个岔口？怎么用 `strace` 与 `smaps` 拿读数？三组陷阱清单、九行出口检查。 |

## 怎么读

- **第一次读**：2.3.1–2.3.8 一口气读完（这八节是全章骨架），边读边在纸上画两样东西：「fd 表 → `struct file` → inode → page cache → 磁盘」五层图，以及「加锁 → 写 → `fflush` → 解锁」四步；然后跑 2.3.4 的 `mmap_scan` 与 2.3.6 的 `lockfile`，亲眼看一次 `exit=2`。
- **只想解决一个具体问题**：日志交错看 [2.3.3](ch03.md#sec-2.3.3) 与 [B1](ch03-exercises.md#ex-2.3-B1)；`mmap` 后进程被杀看 [2.3.10](ch03.md#sec-2.3.10) 与 [B3](ch03-exercises.md#ex-2.3-B3)；「我加了锁却挡不住别人」看 [2.3.15](ch03.md#sec-2.3.15) 与 [B2](ch03-exercises.md#ex-2.3-B2)；配置读到半个文件看 [2.3.7](ch03.md#sec-2.3.7) 与 [B4](ch03-exercises.md#ex-2.3-B4)；`mmap` 报 `EINVAL` 看 [2.3.4](ch03.md#sec-2.3.4) 与 [C2](ch03-exercises.md#ex-2.3-C2)。
- **准备面试或课程考试**：五处必答——`fcntl` 能改与不能改（2.3.1）、`pread` 为什么不踩共享偏移（2.3.3）、`MAP_SHARED` 与 `MAP_PRIVATE` 的写语义（2.3.9）、`SIGBUS` 与 `SIGSEGV` 的分界（2.3.10）、原子发布四步含目录 `fsync`（2.3.7）；先做[习题集](ch03-exercises.md) A 组。
- **怕数字搬家**：本章的正文示例里有三处是别的机器的形状（`/proc/locks` 的 `08:01` 设备号与 PID、`strace` 里 `0x7f...` 的地址形态、`fallocate_demo` 的 `blocks` 数），而本书测试机是 aarch64；`mremap` 那一步在本机直接失败。逐条列在[勘误与版本注记](ch03-errata.md)，出题与复跑前先读那一页。

## 环境口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096。可用：`cc`/`gcc`、`make`、`strace` 6.8、`getconf`、`stat`、`du`、`truncate`、`lslocks`、`flock`（命令）、`grep`/`awk`、`/proc`、`/sys`、bash 的 `exec 3<file`；`docker` 免 `sudo` 可用（本机 `docker info` 报 29.1.3），只在需要干净 rootfs 时用。
- **不可用**：`sudo`（`sudo -n true` 报「需要密码」）与 `perf` 的计数器——`/usr/bin/perf` 这个文件在，但 `perf_event_paranoid`=4，`perf stat true` 直接 `No supported events found`。所以 [2.3.16](ch03.md#sec-2.3.16) 的 `perf stat -e page-faults` 一律按「未实测」读，替代是 `getrusage` 的 `ru_minflt`/`ru_majflt`（见 [C6](ch03-exercises.md#ex-2.3-C6)）。
- **两条跨进程取证的权限边界**：`/proc/sys/kernel/yama/ptrace_scope`=1，所以 `strace -p <PID>` 与读别人的 `/proc/PID/syscall` 都报 `Operation not permitted`，观察只能改成「在 strace 下启动」和 `/proc/self/...`；`dmesg` 被 `dmesg_restrict`=1 挡住（`read kernel buffer failed: Operation not permitted`）。`fincore` 本机没装，`smaps`/`mincore` 两条路可走。
- **文件命名纪律**：本机 `/tmp` 在 ext4 根分区（`/dev/sda2`，`rw,relatime`）上，`/dev/shm` 是 tmpfs——正好用来演示 `rename` 跨文件系统的 `EXDEV`。本书的 C 组实验在 `/tmp/lab2c03_work` 下做，新建文件一律带 `lab2c03_` 前缀；在本书 VM 上做完**留着别删**，别人正在同一台机器上跑别的实验，宽通配删除会连别人的探针一起清掉。
- **写作机**：macOS arm64（Apple 芯片）。没有 `/proc`、没有 `strace`，`errno` 数值、页大小与 `O_*` 八进制值都和 Linux 不同，只能用来读源码形状；本章全部实验回 Linux 做。
- **口径**：本章凡是贴数字的地方（`blocks`、`runs`、`len`、错误码数值、调用号）都以本机复跑为准：aarch64 上 `SYS_mmap`=222、`SYS_fallocate`=47、`SYS_copy_file_range`=285（x86-64 分别是 9、285、326），`_SC_IOV_MAX`=1024，`ulimit -n`=1024。判断错误码写名字，要限制去运行时查，要读数回本机取。

## 路线标签与项目回链

- **应用/运维：必读** [2.3.1](ch03.md#sec-2.3.1)、[2.3.3](ch03.md#sec-2.3.3)、[2.3.6](ch03.md#sec-2.3.6)、[2.3.7](ch03.md#sec-2.3.7)。日志交错、单实例、配置发布这三件运维日常全在这四节；**可后补** [2.3.9](ch03.md#sec-2.3.9)–[2.3.14](ch03.md#sec-2.3.14)。
- **系统编程：必读** [2.3.1](ch03.md#sec-2.3.1)–[2.3.12](ch03.md#sec-2.3.12)、[2.3.15](ch03.md#sec-2.3.15)。`mmap` 语义、锁的归属、原子发布是这一档的基本功；**可后补** [2.3.16](ch03.md#sec-2.3.16)（内核函数名不影响先写对代码）。
- **内核/性能：必读** [2.3.4](ch03.md#sec-2.3.4)、[2.3.10](ch03.md#sec-2.3.10)、[2.3.13](ch03.md#sec-2.3.13)、[2.3.14](ch03.md#sec-2.3.14)、[2.3.16](ch03.md#sec-2.3.16)、[2.3.17](ch03.md#sec-2.3.17)。缺页路径、 fault 计数、块分配与零拷贝的取舍都在这里；**可后补** [2.3.12](ch03.md#sec-2.3.12)。
- **项目回链**：A1 `mycontainer` 里「rootfs 挂载点换文件系统后 `rename` 报 `EXDEV`」看 [2.3.7](ch03.md#sec-2.3.7) 与 [B4](ch03-exercises.md#ex-2.3-B4)；镜像内单实例锁「同一 inode 但不同挂载」的判据在 [2.3.15](ch03.md#sec-2.3.15)；共享内存传递（`memfd` + `SCM_RIGHTS`）的形状在 [2.3.12](ch03.md#sec-2.3.12)，与 [2.15 共享内存与信号量](ch15.md) 相接。

## 章末件

[章末总结](ch03-summary.md) · [闭卷回忆卡](ch03-recall.md) · [习题集](ch03-exercises.md) · [学习目标自检表](ch03-checklist.md) · [勘误与版本注记](ch03-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 4–5 章（`fcntl`/`dup`/`pread`/`readv`/截断）、第 13 章（`O_DIRECT`）、第 14 章（VFS）、第 49 章（`mmap` 与映射类型）、第 50 章（`mprotect`/`mlock`/`mincore`/`madvise`）、第 55 章（文件锁） | 2.3.1–2.3.4、2.3.6、2.3.8–2.3.11、2.3.15 |
| **K** | 第 61 章 61.4（`sendfile`） | 2.3.5、2.3.14：`splice`/`tee`/`vmsplice`/`copy_file_range` 是母本成书后新增，按 man 页写 |
| **C**（深入理解计算机系统） | 第 9 章 9.8（内存映射）、第 10 章（系统级 I/O） | 2.3.3、2.3.4：`mmap` 与 RIO 的对照 |
| **O**（操作系统导论） | 第 39–40 章（文件与目录、文件系统实现） | 2.3.7、2.3.8：inode、块分配、崩溃一致性 |
| **G**（鸟哥的 Linux 私房菜） | 第 5 章（文件权限）、第 7 章（磁盘与文件系统） | 2.3.7、2.3.8：`df`/`du`/稀疏文件的命令行证据 |

> K 的中文版覆盖到 Linux 3.2：`memfd_create`、seals、OFD 锁、`copy_file_range`、`MAP_HUGETLB` 之外的新 `MADV_*`、`MREMAP_DONTUNMAP` 都在它之后，本章这些一律按 man-pages 与本机头文件写；正文引 Kerrisk 的页码（p845–p935 一类）只作定位，换版本以[勘误页](ch03-errata.md)为准。CSAPP 中文第 3 版是纯扫描版，只能按章节号核对落点。
