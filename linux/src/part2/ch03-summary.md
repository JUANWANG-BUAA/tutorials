# 2.3 章末总结

## 三段主线：三个单元，一条因果链

**第一段，骨架：八个能力点（2.3.1–2.3.8）。** `fcntl` 是万能把手，但它只能改行为位（`O_APPEND`、`O_NONBLOCK`、`O_ASYNC`、`O_DIRECT`、`O_NOATIME`），访问模式在 `open` 时定死，`F_SETFL` 塞进去的 `O_RDWR` 被内核静默忽略——返回 0、fd 仍然只读。而且「`F_GETFL` 读 → 改 → `F_SETFL` 写」是两步，多线程同时做会丢更新。`fd` 标志只有 `FD_CLOEXEC` 一位有意义，事后补有竞态窗口：另一个线程可能在你两步之间 `fork` + `exec`；`open(O_CLOEXEC)` 与 `F_DUPFD_CLOEXEC` 才是原子设置。

`dup` 家族复制的是 fd 表项而不是打开文件描述（`struct file`），所以两个 fd 共享偏移、状态 flags 与 `flock` 锁。`dup2(fd, 1)` 的价值是「原子关闭 + 复制」：`close(1); dup(fd);` 之间别人能抢走 fd 1。`dup3` 只接受 `O_CLOEXEC`，且 `oldfd == newfd` 时报 `EINVAL`——`dup2` 是同种情况的合法捷径。

`pread`/`pwrite` 把偏移变成参数、不碰 `f_pos`，一次消掉「共享偏移」这一整类竞态。Linux 上 `O_APPEND` 的 fd 做 `pwrite` 仍追加到末尾，`offset` 被忽略，违背 POSIX 且长期未修（本机实测：`pwrite(off=0)` 后内容是 `AAAABBBB`）。`readv`/`writev` 一次搬多段，返回总字节数、可能短写；短写后不能重试整个数组，要按已写字节推进或切短当前 `iovec`。`IOV_MAX` 本机是 1024（`sysconf(_SC_IOV_MAX)`）。

**第二段，映射、空间与搬运（2.3.4、2.3.9–2.3.14）。** `mmap` 只建一个 VMA（虚拟内存区域，内核描述一段地址范围的表项），访问映射区就是访问 page cache，缺页时才读盘。失败返回 `MAP_FAILED`（`(void *)-1`），**不是 NULL**。两个硬约束：`offset` 必须页对齐、`length` 向上取整到页；`length == 0` 或未对齐都是 `EINVAL`（本机实测：`offset=100` 报 22，`MAP_ANONYMOUS` 也一样查对齐）。

`MAP_SHARED` 的写反映到底层文件、对其他映射可见；`MAP_PRIVATE` 写触发 COW（写时复制），改动只在本进程，**永不落盘**。本机实测：私有映射上 `msync(MS_SYNC)` 返回 0 却什么都不写回——它是静默成功，不是报错。`prot` 与 fd 模式的规则比「不能超过」更精确：`O_RDONLY` + `MAP_SHARED` + `PROT_WRITE` 报 `EACCES`，`O_RDONLY` + `MAP_PRIVATE` + `PROT_WRITE` 可以，`O_WRONLY` 任何 `prot` 都不行，因为很多架构没有「只写页」。`mmap` 成功后立刻 `close(fd)` 映射仍然有效。

`SIGSEGV` 与 `SIGBUS` 的分界是全章最值钱的一条：地址不在任何 VMA 里是 `SIGSEGV`；在映射长度内、但落在文件 EOF 之后的**整页**是 `SIGBUS`；EOF 所在页的尾部字节读为 0、可访问。`read` 在同样情况下只返回 0——这就是「不能把文件大小当不变式」的理由。映射之后五个旋钮里只有 `msync(MS_SYNC)` 与 `mlock` 有强制语义：`MS_ASYNC` 只排队，`MADV_DONTNEED` 在私有匿名映射上是破坏性的（数据变 0），`mincore` 只是快照，`mremap(MREMAP_MAYMOVE)` 可能搬家所以只能保存偏移。

空间侧 `fallocate` 动块、`ftruncate` 只动逻辑大小；`PUNCH_HOLE` 必须与 `KEEP_SIZE` 合用；`posix_fallocate` 返回错误码而不设 `errno`，在不支持 `fallocate` 的系统调用上会退化成逐块写 0。搬运侧四个接口省的都是「内核 ↔ 用户态」那两次拷贝，DMA 与 page cache 一步不少：`sendfile` 的输入要可 `mmap`、`splice` 至少一端是管道、`tee` 只复制管道、`copy_file_range` 的 `flags` 必须是 0 且可能 `EXDEV`，每个都要写降级路径。

**第三段，锁、内核与取证（2.3.6、2.3.7、2.3.15、2.3.16–2.3.19）。** 三种锁的归属决定一切：`flock` 归打开文件描述（`fork` 后父子共享同一把，父进程退出不会释放）、`fcntl`/POSIX 记录锁归进程 + inode（`fork` 不继承，**关闭该文件任意 fd 就释放全部**）、OFD 锁归打开文件描述（补上 POSIX 锁的缺陷，`/proc/locks` 里 PID 显示 -1）。本机实测：`flock` 与记录锁、`flock` 与 OFD 锁互相都不冲突（两边都返回 0），只有记录锁 ↔ OFD 锁、同类之间报 `EAGAIN`。混用不互斥，一个程序只用一套。

原子发布四步的顺序不能换：同目录 `O_CREAT|O_EXCL` 临时文件 → 写完 → `fsync(fd)` → `close` → `rename` → **打开父目录再 `fsync`**。第三步防的是「内容在、名字还是旧的」：`rename` 改的是目录项，目录本身也要落盘。跨文件系统 `rename` 报 `EXDEV`（本机 `/tmp` → `/dev/shm` 实测 18）。`O_TMPFILE` 连临时名字都省掉，`linkat` 走 `/proc/self/fd/N` 或 `AT_EMPTY_PATH` 两条路。

内核侧只记三句：`mmap` 登记 VMA 时拿 `mmap_lock` 写锁、不读文件页；缺页走 `filemap_fault`（读）、`do_wp_page`（私有写，COW）、`do_shared_fault` → `->page_mkwrite`（共享写，标脏）；`msync`/`fsync` 最终都落到 `vfs_fsync_range` → `file->f_op->fsync`。取证两件：`strace` 看调用与 flags（`strace -e trace=mmap,munmap,msync`），`/proc/PID/smaps` 看 `Rss`/`Pss`/`Private_Dirty`（本机 1 MiB 共享映射只触碰 3 页时 `Rss`=12 kB、触碰全部时 1024 kB）。

一句话主线：**凡「两步合成一件事」先问内核有没有一步原语；凡结论依赖某个数值或某个行为，先在本机跑一遍再说。**

## 三条判据

| 判据 | 具体要求（做不到就回右列） | 主要落点 |
|:--|:--|:--|
| **能解释** | 说出 `fcntl` 能改哪三位、为什么改不了访问模式；说清 `dup`/`fork` 复制的是哪一层、所以什么共享；说清 `MAP_SHARED` 与 `MAP_PRIVATE` 的写各走到哪一层；说出 `SIGBUS` 与 `SIGSEGV` 的分界；说出三种锁的归属与释放时机各不同在哪 | [2.3.1](ch03.md#sec-2.3.1)、[2.3.2](ch03.md#sec-2.3.2)、[2.3.9](ch03.md#sec-2.3.9)、[2.3.10](ch03.md#sec-2.3.10)、[2.3.15](ch03.md#sec-2.3.15) |
| **能操作** | 写出 `writev_full` 的推进逻辑；跑出 `mmap_scan` 并 `pread` 验证大写生效；用记录锁实现单实例（第二个实例退出码 2）并 `lslocks` 看见它；写出四步原子发布并 `strace` 出两次 `fsync`；用 `fallocate` 打洞后 `st_blocks` 变小而 `st_size` 不变 | [2.3.3](ch03.md#sec-2.3.3)、[2.3.4](ch03.md#sec-2.3.4)、[2.3.6](ch03.md#sec-2.3.6)、[2.3.7](ch03.md#sec-2.3.7)、[2.3.13](ch03.md#sec-2.3.13) |
| **能判断** | 给现象能定位到机制层：日志交错在「一次记录由多次 `write` 完成」层；`mmap` 崩在 `SIGBUS` 而非越界；「加了锁挡不住」多半是两套锁混用；锁莫名消失是关了指向同一文件的另一个 fd；发布后读到半个文件是缺目录 `fsync` 或目标跨了文件系统；拿读数前先说清哪个架构、哪个内核、哪个文件系统 | [2.3.5](ch03.md#sec-2.3.5)、[2.3.10](ch03.md#sec-2.3.10)、[2.3.14](ch03.md#sec-2.3.14)、[2.3.17](ch03.md#sec-2.3.17)、[2.3.18](ch03.md#sec-2.3.18)、[勘误页](ch03-errata.md) |

## 表 1：谁共享什么（本章最容易混的一层）

| 关系 | 偏移 `f_pos` | 状态 flags | `flock` 锁 | 记录锁 / OFD 锁 | 映射区 |
|:--|:--|:--|:--|:--|:--|
| 同进程两次 `open` | 各一份 | 各一份 | 各一把（互相冲突） | **同进程合并，不冲突** | 两个 VMA，同一份 page cache |
| `dup` / `F_DUPFD` | 共享 | 共享 | 共享同一把 | 共享（同进程） | 同一 `struct file`，映射各自建 |
| `fork` | 共享 | 共享 | 共享（父退不释放） | 子进程**不继承** | 子进程复制 VMA，共享映射同物理页 |
| `exec` | 保留（除非 CLOEXEC） | 保留 | 保留（最后一个引用被 CLOEXEC 关掉才释放） | 保留 | 全部解除——`exec` 换掉整个地址空间 |

## 表 2：一步原语 vs 两步写法

| 想做的事 | 两步写法（有窗口） | 内核给的一步原语 | 本机验证 |
|:--|:--|:--|:--|
| 追加一条记录 | `lseek(END)` + `write` | `O_APPEND` | [C1](ch03-exercises.md#ex-2.3-C1) |
| 只改文件中间一段 | `lseek` + `write` | `pwrite(fd, buf, n, off)` | [C1](ch03-exercises.md#ex-2.3-C1) |
| 不存在才创建 | `access` + `open` | `open(O_CREAT\|O_EXCL)` | 2.2 已做 |
| 发布新版本配置 | 写原文件 + `rename` 不同目录 | 同目录临时文件 + `fsync` + `rename` + 目录 `fsync` | [C4](ch03-exercises.md#ex-2.3-C4) |
| 单实例 | 检查 pid 文件 + 写 | `fcntl` 记录锁 / OFD 锁 / `flock` | [C3](ch03-exercises.md#ex-2.3-C3) |
| 复制整文件 | `read` + `write` 循环 | `copy_file_range` / `splice` | [C5](ch03-exercises.md#ex-2.3-C5) |

## 只记一件事

**多条系统调用之间没有原子性。** 这一条同时管着本章全部：`F_GETFL` + `F_SETFL` 会丢更新；`lseek` + `write` 会被别人插；`O_TRUNC` + 写会留下空文件；`rename` 之后不 `fsync` 目录，崩溃回来名字还是旧的；加锁 → 写 → 解锁之间忘了 `fflush`，别人拿到锁也看不见你的数据。看到「先检查再动手」的代码，第一反应应该是「这两步之间能发生什么」。

## 六页怎么用

1. **[章总览](ch03-overview.md)**：先看五段一览表与「环境口径」，确认走哪条路径、哪些节可后补、本机哪些读数已实测。
2. **[章末总结](ch03-summary.md)**（这一页）：合上正文读一遍，把三段主线当目录自查；两张表分别回答「谁共享什么」和「哪件事有一步原语」。
3. **[闭卷回忆卡](ch03-recall.md)**：24 张卡，只看问题作答；`✓/△/×` 三种结果，下次只做 `△` 与 `×`。
4. **[习题集](ch03-exercises.md)**：A 组概念判断 6 题、B 组诊断推理 5 题、C 组动手实验 6 题（全部免 `sudo`，在本机 aarch64 上跑过）；每题第一个动作都是「先猜」。
5. **[学习目标自检表](ch03-checklist.md)**：接管 [2.3.19 本章出口检查](ch03.md#sec-2.3.19) 的九行与正文各节 `errata` 盒，按概念（K）/动手（S）/实验（E）/口径（B）四组逐条当场做。
6. **[勘误与版本注记](ch03-errata.md)**：本章有四处正文读数在本机复跑时对不上（`len=30`、`mremap`、`fallocate` 的 `blocks`、`/proc/locks` 那行），另有 `strace`/`smaps` 三处命令在本机拿不到正文说的输出——抄数字、出题、照抄命令前先读这一页。

## 下一站

[2.4 缓冲与 stdio](ch04.md) 接走本章留下的两个尾巴：`dup2` 之前为什么必须 `fflush`，以及「加锁 → 写 → 解锁」为什么少了 `fflush` 就等于没写。[2.5 文件属性](ch05.md) 会把 `st_size` 与 `st_blocks` 的差异摊到 `stat` 全表上；[2.15 共享内存与信号量](ch15.md) 把本章 `MAP_SHARED|MAP_ANONYMOUS` 与 `memfd` 扩成跨进程的正式共享内存。往回查：[2.2.5 的原子性](ch02.md#sec-2.2.5) 与 [2.2.8 的页缓存](ch02.md#sec-2.2.8) 是本章「原子发布」那一步的前提，`O_APPEND` 交错的结论在 [2.2.16](ch02.md#sec-2.2.16)。
