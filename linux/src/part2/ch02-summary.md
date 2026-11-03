# 2.2 章末总结

## 三段主线：三个单元，一条因果链

**第一段，模型与五个调用（2.2.1–2.2.4，第一个单元）。** fd（文件描述符）不是文件，它只是进程 fd 表里的一个下标；偏移 `f_pos` 与状态 flags 住在中间那层打开文件描述（`struct file`），文件本体在 inode。这一层一分开，两个困惑自动解决：同一路径 `open` 两次得到两个 `struct file`，偏移各走各的；`dup`/`fork` 复制表项但指向同一个 `struct file`，所以偏移共享——多进程写同一份日志时这正是交错的根源。`open` 的 flags 分三组：访问模式（低两位，必须有且只有一个）、创建/截断、行为修饰；`mode` 只在 `O_CREAT`/`O_TMPFILE` 时参与，且最终权限是 `mode & ~umask`，漏传 `mode` 拿到的是栈上的垃圾值。两个必须记住的原子性：`O_CREAT|O_EXCL` 把「不存在检查 + 创建」合成一步（`access` + `open` 有 TOCTOU 窗口），`O_APPEND` 把「定位末尾 + 写」合成一步（`lseek(END)` + `write` 会被别人插进来），但 `O_APPEND` 不保证一条记录不交错。`read`/`write` 的返回值是「这次搬了几字节」，不是开关：短读短写在管道、终端、socket 与信号打断时是常态，`EINTR` 要重试、`EAGAIN` 要等就绪不能忙等、`n == 0` 在写侧要报 `EIO` 防死循环；`SA_RESTART` 盖不住 `poll`/`epoll_wait`/`select`。收尾三件事：`close()` 失败时 fd 已经释放，**不要重试**，落盘靠 `fsync` 不靠 `close` 的返回值；`dup2(fd, 1)` 是原子的，`close(1)` + `dup(fd)` 不是；`fcntl` 能改 `O_APPEND`/`O_NONBLOCK`/`O_ASYNC`，改不了访问模式。`ioctl` 补上五个调用盖不住的那半边，`request` 是方向+大小+类型+序号编出来的位段，`ENOTTY` 只代表「这个 fd 不支持这个请求」而不是「不是终端」。

**第二段，原子性、资源与一个完整程序（2.2.5–2.2.11，第二个单元）。** 单条系统调用是原子的，多条之间不是，所以文件系统提供了几个把常见组合做成一步的原语：`O_CREAT|O_EXCL`、`O_APPEND`、`rename`、`renameat2(RENAME_EXCHANGE/RENAME_NOREPLACE)`、`link`。持久化有四步且顺序不能换：写临时文件 → `fsync(fd)` → `close` + `rename` → `fsync(dirfd)`，最后一步常被忘，因为 `rename` 改的是目录项，目录本身也要落盘。fd 是有限资源，泄漏看三处：`ls /proc/PID/fd | wc -l`、`/proc/PID/limits`、`strace -f -e trace=openat,close`；`(deleted)` 是「目录项没了但 inode 还有引用」，`df` 不降直到 fd 关闭，这是日志轮转后磁盘不释放的标准原因。`/dev/fd/N` 不是按路径重开文件，而是复制当前进程的 fd N。2.2.8 回答「写成功数据在哪」：`write()` 返回只代表数据进了页缓存，进程 `kill -9` 不丢（页在内核），掉电会丢（除非已 `fsync`/`O_SYNC`）；`fsync` 的代价是等设备确认，所以批量写 + 一次 `fsync` 远快于每条记录一次；`O_DIRECT` 绕缓存但要求地址、偏移、长度都对齐。缓存侧只有「建议」：`posix_fadvise` 六个值里 `NOREUSE` 不会把数据赶出缓存（Linux 2.6.18–6.2 是 no-op，6.3+ 只影响已映射页），要释放用 `DONTNEED` 且只对干净页生效；`madvise` 作用在 mmap 的虚拟区间而不是 fd。2.2.9 把 `O_*` 摊成全表并逐个给边界：`O_PATH` 只能 `fstat`/当 `dirfd`，`read` 报 `EBADF`；`O_NOFOLLOW` 只挡最后一段且报 `ELOOP`；`O_DIRECTORY` 对普通文件报 `ENOTDIR`；`O_TMPFILE` 建的是没有目录项的 inode，`linkat(..., AT_EMPTY_PATH)` 普通用户要 `CAP_DAC_READ_SEARCH`，带 `O_EXCL` 就永远不能链接；`O_DSYNC` 落数据与必要元数据、`O_SYNC` 连 mtime 全落、`O_ASYNC` 跟同步无关而是 `SIGIO`。临时文件三种做法按「要不要名字给别人看」选：`mkstemp`（有名，0600，要手动 `unlink`）、`tmpfile()`（无名，`fclose` 自动删）、`O_TMPFILE`（无名，不 `linkat` 就自动回收）。`openat2` 把路径解析的约束变成 flag：`RESOLVE_BENEATH` 逃逸报 `EXDEV`、`IN_ROOT` 把 `..` 夹住、`NO_SYMLINKS`/`NO_MAGICLINKS` 报 `ELOOP`、`NO_XDEV` 禁止跨挂载、`CACHED` 只查缓存否则 `EAGAIN`；它是单次解析的护栏，不是进程隔离。权限那侧的算式是 `mode & 07777 & ~umask`，但父目录的默认 ACL 会插一脚，setgid 目录会传属组，sticky 目录限制谁能删，`mode=0` 建出来的文件连创建者都打不开。

**第三段，返回矩阵、偏移与取证（2.2.12–2.2.20，第三个单元）。** 2.2.12 把返回值补成矩阵：等于/小于请求、0、`-1+EINTR`、`-1+其他`；每个错误码标了该重试（`EINTR`、`EAGAIN`）、该退避（`ENOMEM`）、还是该放弃（`EBADF`、`EFAULT`、`EINVAL`、`EISDIR`、`EFBIG`、`ENOSPC`、`EDQUOT`、`EPIPE`、`EIO`、`EPERM`、`EROFS`），`EPIPE` 默认先送 `SIGPIPE` 杀进程再返回错误，服务端要么 `SIG_IGN` 要么 `MSG_NOSIGNAL`。短读有七个真实来源，其中 `/proc`、`/sys` 的许多文件一次只产一页左右且 `st_size` 是 0，所以「按 `st_size` 决定读几次」必错。`lseek` 只改内存里的偏移，不触发 I/O；移到末尾之外不会分配磁盘块，写下去才形成空洞，`st_size` 是逻辑大小、`st_blocks * 512` 是实占，`SEEK_DATA`/`SEEK_HOLE` 就是用来跳读空洞的（文件系统可以保守地全报数据，只当优化不当正确性依赖）。`pread`/`pwrite` 不碰共享偏移，所以多线程共用一个 fd 要靠它们而不是 `lseek`+`read`；Linux 上 `O_APPEND` 的 fd 做 `pwrite` 仍追加到末尾，违背 POSIX 且长期未修。`readv`/`writev` 一次搬多段，段数上限查 `sysconf(_SC_IOV_MAX)`（本机 1024，glibc 不替你拆分，超了直接 `EINVAL`），短写后不能重试整个数组，要推进 `iovec`；`preadv2`/`pwritev2` 把同步与非阻塞降到每次 I/O（`RWF_DSYNC`、`RWF_SYNC`、`RWF_NOWAIT`、`RWF_HIPRI`、`RWF_APPEND`）。fd 的一生：`dup3` 与 `dup2` 只差两点——只接受 `O_CLOEXEC`、`oldfd == newfd` 时报 `EINVAL`；`close_range(first, last, flags)` 在内核里一次关掉一段，`CLOSE_RANGE_UNSHARE` 避免影响共享 fd 表的线程，`CLOSE_RANGE_CLOEXEC` 只标记不关闭，`close_range(3, ~0U, 0)` 是 exec 前清空的标准写法。原子性的边界要量着说：`O_APPEND` 在本地文件系统上是 inode 锁内完成，NFS 依赖服务器；`O_EXCL` 在 NFSv2 不可信、路径最后是符号链接时报 `EEXIST`；`rename` 只在同一文件系统内原子，跨文件系统 `EXDEV`（本机实测：`/tmp` → `/dev/shm` 报 `EXDEV`，而 `/tmp` → 家目录同属一个 ext4 挂载会成功），`new` 是挂载点报 `EBUSY`。2.2.17 的九层路径解释了三个现象：`copy_page_from_iter_atomic` 只把数据拷进内核页，所以返回时还在内存；`balance_dirty_pages` 会主动把写者拖慢；`O_SYNC`/`O_DSYNC` 是在 `write_iter` 返回前调 `generic_write_sync` 才走到设备等确认。取证两招：`strace -yy` 把 fd 映射回路径（没它会在 fd 复用时误判），`-e inject=openat:error=EACCES:when=1` 不改代码就踩进错误分支；`/proc/self/fdinfo/N` 四行分别是偏移、八进制的打开标志、挂载编号与 inode 号——注意 `flags` 与 inode 号都跟着架构和机器变，`mnt_id: 35`、`ino: 2755550` 是这台机器的读数，不能当常数引用。

一句话主线：**把每次调用当契约读——先看返回值说了什么、再看它没说什么；凡「两步合成一件事」先找有没有一步原语；凡结论依赖某个数值，先在本机用 `strace` 与 `/proc` 拿到读数再说话。**

## 三条判据

| 判据 | 具体要求（做不到就回右列） | 主要落点 |
|:--|:--|:--|
| **能解释** | 画出三层对象并说出哪层存偏移、哪层被 `dup`/`fork` 共享；说清短读短写的七个来源与 `EINTR`/`EAGAIN` 的分工；说出 `O_APPEND`/`O_EXCL`/`rename` 各保证到哪一步、各在什么条件下失效；说出 `write()` 返回时数据在哪层、`fsync` 之后到了哪层 | [2.2.1](ch02.md#sec-2.2.1)、[2.2.3](ch02.md#sec-2.2.3)、[2.2.12](ch02.md#sec-2.2.12)、[2.2.16](ch02.md#sec-2.2.16)、[2.2.17](ch02.md#sec-2.2.17) |
| **能操作** | 写出 `read_full`/`write_full`；写对 `close` 的返回值处理与 `dup2`/`dup3`/`F_DUPFD_CLOEXEC`/`close_range` 的用法；跑通 `copy.c` 并复现 `fsync` → `rename` → `fsync(dir)` 三步；用 `openat2(RESOLVE_BENEATH)` 挡住 `../`；用 `SEEK_DATA`/`SEEK_HOLE` 列出稀疏区段 | [2.2.2](ch02.md#sec-2.2.2)、[2.2.4](ch02.md#sec-2.2.4)、[2.2.5](ch02.md#sec-2.2.5)、[2.2.7](ch02.md#sec-2.2.7)、[2.2.10](ch02.md#sec-2.2.10)、[2.2.13](ch02.md#sec-2.2.13)–[2.2.15](ch02.md#sec-2.2.15) |
| **能判断** | 给现象能定位到层：交错写在 `O_APPEND` 语义层、少数据在短写处理层、磁盘不释放在 fd 引用层、权限不对在 `umask`/ACL 层、`EXDEV` 要分清是 `rename` 跨挂载还是 `RESOLVE_BENEATH` 挡逃逸；拿读数前先说清它属于哪个架构/内核/libc，八进制 flag 与 `mnt_id`/`ino` 一律本机重取 | [2.2.6](ch02.md#sec-2.2.6)、[2.2.9](ch02.md#sec-2.2.9)、[2.2.11](ch02.md#sec-2.2.11)、[2.2.18](ch02.md#sec-2.2.18)、[2.2.19](ch02.md#sec-2.2.19)、[勘误页](ch02-errata.md) |

## 表 1：返回值 → 动作

| 读数 | 含义 | 动作 |
|:--|:--|:--|
| `read` 返回 `0 < n < count` | 短读：EOF 逼近、管道里只有这些、终端行模式、信号在部分传输后到达、`/proc` 一次一页 | 推进缓冲区与剩余长度，继续；**不能当 EOF，也不能当错误** |
| `read` 返回 `0` | EOF（普通文件到末尾；管道/socket 写端全关） | 结束读循环；`count == 0` 时的 0 不是 EOF |
| `write` 返回 `n < count`（如管道上 1 MiB 只回 65536） | 缓冲/配额/信号造成的短写，**没有报错** | 循环写剩余部分；只认「写完」= 累计等于请求长度 |
| `write` 返回 `0` 且 `count > 0` | 极少见，设备特殊语义 | 报 `EIO` 并退出循环，继续循环会死锁 |
| `-1` + `EINTR` | 阻塞中被信号打断，可能已传部分 | 重试剩余部分；不要依赖调用方设了 `SA_RESTART` |
| `-1` + `EAGAIN`/`EWOULDBLOCK` | `O_NONBLOCK` 下暂无数据或缓冲满 | 保存进度，等 `epoll`/`poll` 就绪；忙等是错的 |
| `-1` + `ENOSPC`/`EDQUOT`/`EROFS`/`EACCES`/`EPERM` | 空间、配额、只读挂载、权限 | 放弃重试，先清空间或改权限/挂载 |
| `-1` + `EPIPE` | 管道/socket 读端已关 | 默认先收 `SIGPIPE` 直接终止；服务端 `SIG_IGN` 后按错误处理 |
| `close` 返回 `-1` | fd 在返回前已释放（Linux 语义），错误可能来自 NFS 写回 | 记录，**不重试**；要确保落盘用 `fsync` |
| `posix_fadvise` 返回非 0 | 它返回错误码，不设 `errno` | 判返回值本身，别去读 `errno` |

## 表 2：原子性边界速查

| 原语 | 保证 | 不保证 / 会失效 |
|:--|:--|:--|
| `open(O_CREAT\|O_EXCL)` | 本地文件系统上「检查不存在 + 创建」一步完成，并发只有一个成功 | 不带 `O_CREAT` 时被忽略；NFSv2 不可靠；最后一段是符号链接时报 `EEXIST`；文件不会自动删除（stale lock） |
| `open(O_WRONLY\|O_APPEND)` | 每次 `write` 的「取末尾 + 写」在 inode 锁内完成，多进程不互相覆盖 | 不保证一条记录不交错（多次 `write` 拼一行仍会穿插）；`pwrite` 在 Linux 上仍追加；NFS 依赖服务器 |
| `rename(old, new)` | 同一文件系统内目录项替换原子，目标不会短暂消失 | 跨文件系统 `EXDEV`；`new` 是挂载点 `EBUSY`；只保证目录项，不保证数据落盘（要 `fsync` 文件 + `fsync` 目录） |
| `renameat2(RENAME_EXCHANGE/NOREPLACE)` | 原子交换两个路径；不覆盖地重命名 | 同样只在同一文件系统内成立 |
| `link(tmp, dst)` | 原子地建立硬链接（不覆盖） | 跨文件系统 `EXDEV`；不能链接目录 |
| `O_TMPFILE` + `linkat` | 崩溃不留垃圾文件，写完再命名 | 文件系统要支持；跨文件系统 `EXDEV`；普通用户要 `CAP_DAC_READ_SEARCH`，改走 `/proc/self/fd/N` |
| `openat2(RESOLVE_BENEATH)` | 单次解析不逃出 `dirfd`，`..` 与绝对路径都报 `EXDEV` | 只约束这一次调用；不改进程根目录，不能替 `chroot`/namespace |

## 只记一件事

**「一次系统调用返回成功」不等于「整个操作完成」。** 这一条同时管着本章四件事：`write` 返回 65536 时还剩 917504 字节没写；`write` 返回 0 时数据只在页缓存、掉电会丢；`rename` 成功时目录项还没落盘；`close` 报错时 fd 已经释放不能再重试。记不住 flags 全表没关系，把「返回成功」当成「做完」，第 2 篇后面每一章都会再犯一次。

## 六页怎么用

1. **[章总览](ch02-overview.md)**：先看五段一览表与「环境口径」，确认走哪条路径、哪些节可以后补，以及本机哪些读数是实测过的。
2. **[章末总结](ch02-summary.md)**（这一页）：合上正文读一遍，把三段主线当目录自查；两张表是「返回值怎么办」和「原子性到哪步」的速查。
3. **[闭卷回忆卡](ch02-recall.md)**：25 张卡，只看问题作答；`✓/△/×` 三种结果，下次只做 `△` 与 `×`。
4. **[习题集](ch02-exercises.md)**：A 组概念判断 6 题、B 组诊断推理 5 题、C 组动手实验 7 题（全部免 `sudo`，在本机 aarch64 上跑）；每题第一个动作都是「先猜」。
5. **[学习目标自检表](ch02-checklist.md)**：接管 [2.2.20 本章小结](ch02.md#sec-2.2.20) 的三条判据与正文各节的「即时自测」，按概念/动手/实验/口径四组逐条当场做。
6. **[勘误与版本注记](ch02-errata.md)**：本章有两张表整列是 x86-64 的八进制值，测试机是 aarch64，另有三处正文读数在本机复跑时对不上——抄数字、出题前先读这一页。

## 下一站

[2.3 高级文件 I/O](ch03.md) 把本章留下的三个尾巴接走：`fcntl` 文件锁（`O_APPEND` 交错问题的正解）、`mmap` 与页缓存的关系、原子发布的工程化写法。管道与 `epoll` 上的短读短写在 [2.14](ch14.md)、[2.16](ch16.md) 继续出现，`EINTR`/`EAGAIN` 的处理纪律从本章开始不再解释。往回查：[2.1.3 `errno` 的七条规则](ch01.md#sec-2.1.3) 解释为什么错误处理函数第一句要存 `errno`，[2.1.12 资源限制](ch01.md#sec-2.1.12) 解释 `EMFILE` 先撞哪一层。
