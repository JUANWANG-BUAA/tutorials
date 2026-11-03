# 2.2 文件 I/O · 本章导航

::: preview 这一章在讲什么
[2.1](ch01.md) 已经立好三条规矩：进内核只靠一次陷入、失败要用「返回值 + `errno`（错误码变量）」判断、常数不能写死。这一章把这三条用在 Unix 最小的那张方法表上——`open`、`read`、`write`、`lseek`、`close` 五个调用，设备、管道、socket、终端全都套进同一个模型。重点不是背 flags，而是**把每一次调用当一份契约来读**：`read` 返回 100 不等于失败，`write` 返回 65536 不等于写完，`close` 返回 `-1` 不能重试，`fsync` 之前数据只待在页缓存（内核用空闲内存暂存的磁盘内容）里。本章每个结论都配了能在本机跑出来的读数：`strace -yy` 看程序真正用了哪些 flags，`/proc/self/fdinfo/N` 看某个 fd 当前的偏移与状态，稀疏文件用 `du` 与 `stat` 对出空洞。
:::

## 本章回答什么

- **一个 fd 到底是什么**：`fd`（文件描述符，进程内一张表的下标）→ 打开文件描述（内核里的 `struct file`，存偏移与 flags）→ inode（文件的磁盘记录），三层各存什么、谁和谁共享；同一路径开两次为什么偏移不同，`dup`/`fork` 后为什么偏移一起走（2.2.1）。
- **`open` 的参数各管什么**：flags 分访问模式、创建/截断、行为修饰三组；`mode` 只在 `O_CREAT`/`O_TMPFILE` 时有意义且会被 `umask` 清位；`O_CREAT|O_EXCL` 与 `O_APPEND` 各自把哪两步合成一次原子操作；`O_CLOEXEC` 为什么必须创建时设（2.2.2）。
- **`read`/`write` 的返回值承诺了什么**：五种返回形态、短读短写为什么是常态、`EINTR`（被信号打断）与 `EAGAIN`（现在不行）的分工、`SA_RESTART` 盖不住哪些调用，以及两个正确形状的 `_full` 循环（2.2.3）。
- **收尾的三个调用**：`close()` 失败为什么不能重试、`dup`/`dup2` 与 `fcntl(F_DUPFD_CLOEXEC)` 的差别、`fcntl` 能改哪些位（访问模式改不了）、`lseek`/`pread` 的分工，以及 `ioctl` 补上的那半边接口（2.2.4、[2.2.4.1](ch02.md#sec-2.2.4.1)）。
- **哪些组合天生原子**：`O_EXCL`、`O_APPEND`、`rename`、`renameat2`、`link` 与「先 `access` 再 `open`」「先 `lseek` 再 `write`」这类两步写法的区别；持久化的四步顺序为什么最后一步是 `fsync` 目录（2.2.5）。
- **fd 泄漏怎么看**：`/proc/PID/fd`、`limits`、`strace` 三步，`(deleted)` 为什么让磁盘不释放，`/dev/fd/N` 是复制而不是重新打开（2.2.6）。
- **一份能用的代码长什么样**：`copy.c` 把 `O_CLOEXEC`、`O_EXCL`、短读短写、`EINTR`、`fsync`、错误分支清理串成一个程序（2.2.7）。
- **写成功到底写到哪**：页缓存四条事实、`fsync` 的代价、`O_DIRECT` 的对齐要求，以及 `posix_fadvise`/`madvise` 只是「建议」不是「命令」（2.2.8、[2.2.8.1](ch02.md#sec-2.2.8.1)）。
- **flags 全表与各标志的边界**：`O_PATH` 只能当锚点、`O_NOFOLLOW` 只挡最后一段且报 `ELOOP`、`O_DIRECTORY` 报 `ENOTDIR`、`O_TMPFILE` 的 `linkat` 权限条件、`O_SYNC`/`O_DSYNC`/`O_ASYNC` 三个像名字不像的语义；`mkstemp`/`tmpfile`/`O_TMPFILE` 怎么选（2.2.9、[2.2.9.1](ch02.md#sec-2.2.9.1)）。
- **怎么把路径锁在目录里**：`openat2` 的六个 `RESOLVE_*` 位、为什么逃逸报 `EXDEV`、它和 `chroot` 不是一回事（2.2.10）。
- **谁改了新建文件的权限**：`mode & ~umask` 公式、setuid/setgid/sticky、默认 ACL 怎么插一脚、`mode=0` 建出来的文件连自己都打不开（2.2.11）。
- **每个错误码该重试还是放弃**：`read`/`write` 的完整错误码矩阵、短读/短写的七个真实来源、`count==0` 的陷阱（2.2.12）。
- **偏移与空洞**：`lseek` 的五种 `errno`、`lseek` 到末尾之外不占磁盘、`SEEK_DATA`/`SEEK_HOLE` 怎么列出稀疏文件的区段（2.2.13）。
- **不踩偏移、少一次调用**：`pread`/`pwrite` 为什么适合多线程共享 fd、Linux 的 `pwrite` + `O_APPEND` 为什么违反 POSIX、`readv`/`writev` 的段数上限与短写推进、`preadv2`/`pwritev2` 的 `RWF_*`（2.2.14）。
- **`fork`/`exec` 前后的 fd 归属**：`dup3` 与 `dup2` 的两点差别、`close_range` 的三个 flag、`/proc/self/fd` 数为什么不能当稳定清单（2.2.15）。
- **原子性保证到哪一步**：`O_APPEND` 不保证整条记录不交错、`O_EXCL` 在 NFSv2 不可靠、`rename` 跨文件系统返回 `EXDEV`、`rename` 只保证目录项不保证数据（2.2.16）。
- **内核里那几层在做什么**：`write` 的九层路径、`generic_perform_write` 的循环怎么解释「返回时数据还在内存」、`balance_dirty_pages` 的限速、`generic_write_sync` 才是等设备确认的地方（2.2.17）。
- **怎么把结论变成读数**：`strace -yy` 逐行读 `openat`/`read`/`fsync`/`rename`，`-e inject` 不改代码就走进错误分支，`/proc/self/fdinfo/N` 的 `pos`/`flags`/`mnt_id`/`ino` 各行是什么（2.2.18）。
- **本章的坑与收束**：两组跨节陷阱（2.2.19）与本章小结的三条判据（2.2.20），展开成[自检表](ch02-checklist.md)的 22 行。

## 读完你会

- 在白纸上画出 fd → 打开文件描述 → inode 三层，并说出「同一个文件开两次偏移独立」「`dup`/`fork` 后偏移共享」各由哪一层解释；手推 `open`+`dup`+三次 `read` 的读数表。
- 说出 `open` flags 的三组分工，解释为什么 `mode` 在漏写 `O_CREAT` 时是垃圾值、为什么最终权限是 `mode & ~umask`。
- 不查正文写出 `read_full`/`write_full`，并解释进度（`p + done`、`count - done`）、`EINTR` 重试、`n == 0` 三种情况各怎么处理；说出 `EAGAIN` 为什么不能忙等。
- 写对收尾：`close()` 失败只记录不重试；需要落盘先 `fsync` 再 `close`；`dup2(fd, 1)` 而不是 `close(1)` + `dup(fd)`；访问模式不能用 `fcntl` 改。
- 给「创建锁文件、追加日志、原子发布配置」三个需求各选出正确原语，并说清 `O_APPEND` 保证什么、不保证什么。
- 用 `ls /proc/PID/fd`、`/proc/PID/limits`、`strace -e trace=openat,close` 定位一次 fd 泄漏，并解释 `ls -l` 里的 `(deleted)` 与 `lsof +L1` 的读数关系。
- 编译并跑通正文的 `copy.c`，用 `strace -yy` 指出数据 `fsync`、`rename`、目录 `fsync` 三步各在哪一行，再用 `-e inject=openat:error=EACCES:when=1` 验证临时文件被清理。
- 用 `openflags.c` 复现 `O_PATH` 的 `read` 报 `EBADF`、`O_NOFOLLOW` 报 `ELOOP`、`O_DIRECTORY` 报 `ENOTDIR`、`O_TMPFILE` 靠 `linkat` 起名字这四个边界。
- 用 `openat2(RESOLVE_BENEATH|RESOLVE_NO_MAGICLINKS)` 把路径限制在目录内，并解释 `../etc/passwd` 与 `/etc/passwd` 为什么都返回 `EXDEV`。
- 用 `sparse_scan.c` 列出一个 4 MiB 稀疏文件的两个数据区段，并用 `du`、`du --apparent-size`、`stat -c '%s %b'` 三个读数区分逻辑大小与实占。
- 判断一个 `errno` 该重试（`EINTR`、`EAGAIN`）、该退避（`ENOMEM`）、还是该放弃（`ENOSPC`、`EDQUOT`、`EACCES`），并解释 `write` 返回 `EPIPE` 之前先有 `SIGPIPE`。
- 说出 `write()` 返回时数据位于哪一层、`kill -9` 与断电各丢什么，以及 `fsync`/`fdatasync`/`syncfs`/`sync` 的适用范围差别。

## 先修与预计学时

- 系统调用与错误码：[2.1.1 一次系统调用穿过什么](ch01.md#sec-2.1.1)、[2.1.3 `errno` 的规则](ch01.md#sec-2.1.3)、[2.1.12 资源限制](ch01.md#sec-2.1.12)（本章的 `EMFILE`、`RLIMIT_FSIZE`、`ulimit -n` 都接在那里）。
- 工具：`strace`、`getconf`、`ulimit`、`stat`、`du` 在第 0 篇与 2.1 已经用过；本章第一次大量读 `/proc/self/*`。
- 阅读：约 150 分钟（20 节，正文有 8 个可编译程序）。C 组七个实验：约 90 分钟（多数是「编译 + 跑 + 对读数」）。章末习题：约 80 分钟。
- 后续接口：[2.3 高级文件 I/O](ch03.md) 接 `fcntl` 文件锁、`mmap` 与原子发布；管道与 `epoll` 在 [2.14](ch14.md)、[2.16](ch16.md)；页缓存与回写的内核侧在 [3.12](../part3/ch12.md)。

## 这条主线怎么走

**第一段，模型与五个调用（2.2.1–2.2.4）。** 先把「fd 不是文件」这件事钉住：fd 只是进程表里的下标，偏移和 flags 住在中间那层 `struct file`，文件本身在 inode。这一层一分开，两个常见困惑就自己解决了——同一路径开两次为什么偏移不同，`dup`/`fork` 后为什么一起走；多进程日志交错的根源也在这里。然后是三个入口调用：`open` 的 flags 分成访问模式、创建/截断、行为修饰三组，`mode` 只在创建时有意义且被 `umask` 清位；`read`/`write` 的返回值是「这次实际搬了多少字节」，不是「成功/失败」的二值开关，所以短读短写要循环、`EINTR` 要重试、`EAGAIN` 要等就绪；`close` 的返回值是唯一不能重试的返回值。最后用 `ioctl` 补上「五个调用盖不住的那半边」：它的 `request` 是位段编码的整数，`ENOTTY` 只代表「这个 fd 不支持这个请求」。

**第二段，原子性与一个完整程序（2.2.5–2.2.7）。** 单条系统调用是原子的，多条之间不是——所以文件系统把几个高频组合做成了原语：`O_CREAT|O_EXCL`、`O_APPEND`、`rename`、`renameat2`、`link`。2.2.5 的对照表就是「两步写法」与「一步原语」的清单，2.2.7 的 `copy.c` 把纪律落地：临时文件 + `O_EXCL`、循环读写、先 `fsync` 文件、`rename`、再 `fsync` 目录。中间插一节 fd 泄漏，因为 fd 是有限资源，而它泄漏时最典型的读数——`(deleted)`——只有会看 `/proc` 的人才抓得到。

**第三段，页缓存与接口全表（2.2.8–2.2.11）。** 先回答「写成功数据到底在哪」：在页缓存，不在磁盘；`fsync` 才是等设备确认，`O_DIRECT` 绕开缓存但要求地址、偏移、长度都对齐。缓存策略只有 `posix_fadvise`/`madvise` 这种「建议」，`POSIX_FADV_NOREUSE` 不丢数据、`DONTNEED` 只丢干净页。2.2.9 把 `O_*` 摊成全表，逐个给「用错的后果」：`O_PATH` 读会 `EBADF`、`O_NOFOLLOW` 报 `ELOOP` 而不是 `EINVAL`、`O_TMPFILE` 的 `linkat` 要看权限、`O_SYNC`/`O_DSYNC`/`O_ASYNC` 三个名字像的语义完全不同。2.2.10 的 `openat2` 把「路径不能逃出这个目录」变成内核检查，2.2.11 解释新建文件权限的完整算式——`mode`、`umask`、特殊位与默认 ACL。

**第四段，返回矩阵与偏移、向量 I/O（2.2.12–2.2.15）。** 2.2.12 把 2.2.3 的三条规则补成矩阵：`read` 的九个错误码、`write` 的十二个，逐个标「重试 / 退避 / 放弃」，并列出短读短写的七个真实来源。2.2.13 让 `lseek` 从「移动指针」升级为「问出文件结构」：`SEEK_DATA`/`SEEK_HOLE` 是 `cp --sparse`、`tar -S` 与备份工具的底层依据。2.2.14 处理并发与效率：`pread`/`pwrite` 不动共享偏移，`readv`/`writev` 一次调用搬多段，`preadv2`/`pwritev2` 把同步语义降到每次 I/O 粒度——顺带给出 Linux 违背 POSIX 的那条（`O_APPEND` 的 fd 上 `pwrite` 仍追加）。2.2.15 管 fd 的一生：`dup3` 原子带 `CLOEXEC`、`close_range` 一次清空一段、`/proc/self/fd` 数本身会占一个 fd。

**第五段，边界、内核路径与取证（2.2.16–2.2.20）。** 2.2.16 把「原子」二字拆开量：`O_APPEND` 保证定位与写在同一把 inode 锁内，不保证整条记录不交错，`pwrite` 不尊重你的偏移；`O_EXCL` 在 NFSv2 不可信；`rename` 只保证目录项，跨文件系统 `EXDEV`。2.2.17 进内核看 `write` 的九层路径，`generic_perform_write` 的循环解释了为什么返回时数据只在内存、为什么脏页多了会被限速、`O_SYNC` 走的是 `generic_write_sync`。2.2.18 是两个实验：`strace -yy` 把 flags 与 fd 归属打在行内，`-e inject` 不改代码制造错误；`/proc/self/fdinfo/N` 给偏移、状态标志与挂载编号。2.2.19 把两组共八个坑按「一次调用成功 ≠ 整件事完成」归堆，2.2.20 以「能解释 / 能操作 / 能判断」三条判据收束全章。

一句话主线：**把每次调用当契约读——先看返回值说了什么、再看它没说什么；凡「两步合成一件事」就找有没有一步原语；凡结论依赖某个数值，就先用 `strace` 与 `/proc` 在本机拿到读数。**

## 本章路线：五段，一条主线

| 分段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、模型与五个调用** | [2.2.1](ch02.md#sec-2.2.1)、[2.2.2](ch02.md#sec-2.2.2)、[2.2.3](ch02.md#sec-2.2.3)、[2.2.4](ch02.md#sec-2.2.4)（含 [2.2.4.1 `ioctl`](ch02.md#sec-2.2.4.1)） | fd 到底是什么、偏移住哪层？`open` 的三组 flags 与 `mode`？`read`/`write` 的返回值承诺了什么？`close`/`dup`/`fcntl`/`lseek` 各管什么？五个调用盖不住的怎么办？ |
| **二、原子性与完整程序** | [2.2.5](ch02.md#sec-2.2.5)、[2.2.6](ch02.md#sec-2.2.6)、[2.2.7](ch02.md#sec-2.2.7) | 哪些组合天生原子、哪些两步写法有竞争窗口？fd 泄漏怎么查、`(deleted)` 怎么解释？一份带短读短写、`fsync`、错误清理的复制程序长什么样？ |
| **三、页缓存与接口全表** | [2.2.8](ch02.md#sec-2.2.8)（含 [2.2.8.1](ch02.md#sec-2.2.8.1)）、[2.2.9](ch02.md#sec-2.2.9)（含 [2.2.9.1](ch02.md#sec-2.2.9.1)）、[2.2.10](ch02.md#sec-2.2.10)、[2.2.11](ch02.md#sec-2.2.11) | 写成功数据在哪一层？每个 `O_*` 改什么、用错报什么？临时文件三种做法怎么选？怎么把路径锁在目录里？新建文件的权限被谁改过？ |
| **四、返回矩阵与偏移、向量 I/O** | [2.2.12](ch02.md#sec-2.2.12)、[2.2.13](ch02.md#sec-2.2.13)、[2.2.14](ch02.md#sec-2.2.14)、[2.2.15](ch02.md#sec-2.2.15) | 每个 `errno` 该重试还是放弃？`lseek` 怎么问出空洞？多线程共享 fd 用什么？`fork`/`exec` 前后哪些 fd 还在？ |
| **五、边界、内核路径与取证** | [2.2.16](ch02.md#sec-2.2.16)–[2.2.20](ch02.md#sec-2.2.20) | 原子性保证到哪一步失效？`write` 在内核经过几层、回写何时发生？怎么用 `strace` 与 `/proc/self/fdinfo` 拿证据？本章的坑与三条判据？ |

## 怎么读

- **第一次读**：2.2.1–2.2.4 一口气读完（这四节是全章的语法），在纸上画两张图：「fd → `struct file` → inode」三层图，和「`read` 返回值 → 循环 → 终止条件」的状态图；然后直接跑 2.2.7 的 `copy.c` 并用 2.2.18 的 `strace -yy` 看它的系统调用序列。第二遍再读 2.2.8–2.2.15 这些「全表 + 边界」节。
- **只想会读写文件**：必读 [2.2.1](ch02.md#sec-2.2.1)、[2.2.3](ch02.md#sec-2.2.3)、[2.2.7](ch02.md#sec-2.2.7)、[2.2.12](ch02.md#sec-2.2.12)；可跳 [2.2.4.1](ch02.md#sec-2.2.4.1)（`ioctl`）、[2.2.10](ch02.md#sec-2.2.10)（`openat2`）、[2.2.17](ch02.md#sec-2.2.17)（内核路径）。
- **正在排一个具体故障**：磁盘没满却 `ENOSPC`、`df` 不降 → [2.2.6](ch02.md#sec-2.2.6) 与 [习题 B3](ch02-exercises.md#ex-2.2-B3)；日志行互相穿插 → [B2](ch02-exercises.md#ex-2.2-B2)；读到的字节数总比请求少 → [B1](ch02-exercises.md#ex-2.2-B1)；新建文件权限诡异 → [B5](ch02-exercises.md#ex-2.2-B5)；多线程读到错位数据 → [B4](ch02-exercises.md#ex-2.2-B4)；改名报 `EXDEV` 或 `openat2` 报 `EXDEV` → [2.2.10](ch02.md#sec-2.2.10)、[2.2.16](ch02.md#sec-2.2.16) 与 [C5](ch02-exercises.md#ex-2.2-C5)；`exec` 后子进程继承了不该继承的连接 → [A5](ch02-exercises.md#ex-2.2-A5) 与 [C6](ch02-exercises.md#ex-2.2-C6)。
- **准备面试或课程考试**：五处必答——三层对象与各管什么（2.2.1）、短读短写与 `EINTR`/`EAGAIN`（2.2.3、2.2.12）、`O_APPEND`/`O_EXCL`/`rename` 的原子边界（2.2.5、2.2.16）、`write` 返回与落盘的差别及 `fsync` 家族（2.2.8、2.2.17）、`pread` 为什么适合多线程（2.2.14）；先做[习题集](ch02-exercises.md) A 组。
- **怕数字搬家**：本章正文里有两张表整列标着 x86-64 的数（2.2.9 的 `open` flags 八进制列、2.2.18 的 `fdinfo flags`），本书测试机是 aarch64，四个高位 flag 的八进制值不同，`flags: 0100002` 在本机是 `0400002`；`mnt_id`、`ino`、管道容量、`fd` 号都跟着机器与会话走。逐条列在[勘误与版本注记](ch02-errata.md)，出题与复跑前先读那一页。

## 环境口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096。可用（本机确认）：`cc`/`gcc`、`strace`（6.8）、`lsof`、`iostat`、`getconf`、`stat`、`du`、`truncate`、`findmnt`、`filefrag`、`python3`、`/proc`、`/sys`、bash 的 `exec 3<>file` 重定向。**`sudo` 不可用**（要密码），**`perf` 的计数器不可用**（`/usr/bin/perf` 在，但 `perf stat true` 每行都是 `<not supported>`），所以本章不引用任何 perf 读数。
- **`docker` 可用且免 sudo**（Server 29.1.3，本机实测 `docker run --rm busybox uname -m` 打印 `aarch64`），用来在干净 rootfs 里复现 `ldd`/挂载类现象，本章只在需要对照时提一句，不作为默认实验环境——容器里没有 `/proc/self/fdinfo` 以外的差异，但 fd 上限、seccomp 与挂载表都和宿主不同。
- **本机已实测的本章读数**（换机器要重取）：`/etc/hosts` 的 fdinfo 是 `mnt_id: 35`、`ino: 2755550`（`mnt_id 35` = 根挂载 `/dev/sda2 ext4`）；`O_RDONLY` 的 fd `flags: 0400000`，bash `exec 3<>` 打开的 `flags: 0400002`；`pipe()` 在 glibc 2.39/aarch64 上实测发出的是 `pipe2([3, 4], 0)`，**不带 `O_CLOEXEC`**；`getconf PAGESIZE`=4096、`IOV_MAX`=1024、`_SC_OPEN_MAX`=1024（等于当次会话的 `ulimit -n`），硬上限 1048576 来自 `/proc/sys/fs/nr_open`；默认管道容量 `F_GETPIPE_SZ`=65536；`/tmp`、`/etc`、家目录同在一个 ext4 挂载，`/dev/shm` 是 tmpfs——所以「跨文件系统 `rename` 报 `EXDEV`」要用 `/tmp` → `/dev/shm` 复现，不能用 `/tmp` → 家目录。
- **`open` 在本机不是系统调用**：aarch64 的 `asm-generic/unistd.h` 里没有 `__NR_open`，glibc 的 `open()` 走 `openat`（编号 56）；照抄 x86-64 的调用号表（`open`=2、`read`=0、`write`=1）会错，本机是 `read`=63、`write`=64、`getpid`=172、`statx`=291。
- **写作机**：macOS（Apple 芯片，arm64）。它能编译本章的 C 程序，但没有 `/proc`、没有 `strace`，`errno` 数值也不同（例如 `EAGAIN`=35），页大小 16384；只适合对照「换一个 libc/架构会怎样」，所有 Linux 专属接口（`openat2`、`close_range`、`/proc/self/fdinfo`）回到 VM 做。
- **口径**：正文的 flags 名、错误码名、内核函数名与文件路径是 man 手册或源码事实；数值分两类——Linux 架构间相同的 `errno`（本机实测 `EBADF`=9、`EAGAIN`=11、`ENOTDIR`=20、`EISDIR`=21、`EINVAL`=22、`ENOSPC`=28、`EPIPE`=32、`EXDEV`=18、`ELOOP`=40、`EMFILE`=24 与 x86-64 一致）与**跟着架构变的八进制 flag**（`O_DIRECT`、`O_DIRECTORY`、`O_NOFOLLOW`、`O_LARGEFILE`、`O_TMPFILE`）。凡是本机没跑出来的读数，一律标「未实测」，不编。

## 路线标签与项目回链

- **应用/运维：必读** [2.2.3](ch02.md#sec-2.2.3)、[2.2.6](ch02.md#sec-2.2.6)、[2.2.8](ch02.md#sec-2.2.8)、[2.2.11](ch02.md#sec-2.2.11)。日志为什么少了一段、磁盘没满为什么不释放空间、写文件要不要 `fsync`、新建目录权限为什么不对，都在这四节；**可后补** [2.2.13](ch02.md#sec-2.2.13)（稀疏文件）。
- **系统编程：必读** [2.2.1](ch02.md#sec-2.2.1)–[2.2.7](ch02.md#sec-2.2.7)、[2.2.9](ch02.md#sec-2.2.9)、[2.2.12](ch02.md#sec-2.2.12)–[2.2.16](ch02.md#sec-2.2.16)。写库、写并发读写、写原子发布绕不开；**可后补** [2.2.17](ch02.md#sec-2.2.17)（内核路径，读代码用）。
- **安全/沙箱：必读** [2.2.2](ch02.md#sec-2.2.2)（TOCTOU 与 `O_NOFOLLOW`）、[2.2.10](ch02.md#sec-2.2.10)（`openat2` 的 `RESOLVE_*`）、[2.2.11](ch02.md#sec-2.2.11)（`umask`、setuid/sticky 与默认 ACL）、[2.2.9](ch02.md#sec-2.2.9) 的 `O_TMPFILE`+`linkat` 权限条；**可后补** [2.2.14](ch02.md#sec-2.2.14)。
- **内核/性能：必读** [2.2.8](ch02.md#sec-2.2.8)、[2.2.13](ch02.md#sec-2.2.13)、[2.2.14](ch02.md#sec-2.2.14)、[2.2.17](ch02.md#sec-2.2.17)。页缓存、预读、对齐、回写与限速是存储类项目的日常；**可后补** [2.2.18](ch02.md#sec-2.2.18)。
- **项目回链**：[项目 D2](../projects/pd.md) 的文件工具要把「短读短写 + `EINTR` + `close` 不重试 + 原子发布」四条当成验收项；容器类项目里「`rename` 报 `EXDEV`」「挂载点上的 `rename` 报 `EBUSY`」「fd 泄漏导致 `(deleted)` 撑满磁盘」三条判据分别落在 [2.2.16](ch02.md#sec-2.2.16)、[2.2.16](ch02.md#sec-2.2.16) 的表和 [2.2.6](ch02.md#sec-2.2.6)。

## 章末件

[章末总结](ch02-summary.md) · [闭卷回忆卡](ch02-recall.md) · [习题集](ch02-exercises.md) · [学习目标自检表](ch02-checklist.md) · [勘误与版本注记](ch02-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 4 章 通用 I/O 模型、第 5 章 深入文件 I/O、第 13 章 I/O 缓冲 | 2.2.1–2.2.4、2.2.9–2.2.14（flags 全表、返回矩阵、`lseek`、`preadv2`）；2.2.5、2.2.16（原子性与 `O_TMPFILE`）；2.2.8（页缓存与 `O_DIRECT`） |
| **CSAPP** | 第 10 章 系统级 I/O | 2.2.1–2.2.3：fd 模型、RIO 包与短读的处理纪律 |
| **OSTEP** | 第 39 章 文件与目录 | 2.2.1、2.2.5：inode、目录项与「一次操作」的边界 |
| **鸟哥** | 第 6 章 文件与目录管理 | 2.2.11：权限、`umask`、setgid/sticky 的命令行证据 |
| **man-pages** | `open(2)`、`read(2)`、`write(2)`、`lseek(2)`、`close(2)`、`dup(2)`、`fcntl(2)`、`ioctl(2)`、`openat2(2)`、`close_range(2)`、`preadv2(2)` | 2.2.2、2.2.9–2.2.10、2.2.14–2.2.16：接口细节与 BUGS 段（`pwrite` + `O_APPEND`）按本机内核 7.0.0 的实际行为写 |

> K 的中文版覆盖到 Linux 3.2，`O_TMPFILE`、`openat2`、`close_range`、`preadv2`/`RWF_*`、`SEEK_DATA`/`SEEK_HOLE` 的细节都在它之后，本章这些接口按 man-pages 与本机头文件（`/usr/include/asm-generic/unistd.h`、`/usr/include/aarch64-linux-gnu/asm/fcntl.h`）写；CSAPP 中文第 3 版是纯扫描版，只能按章节号核对落点，不能引句子与页码。换版本以[勘误页](ch02-errata.md)为准。
