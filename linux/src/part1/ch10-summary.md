# 1.10 章末总结

## 五段浓缩

| 单元 | 小节 | 核心问题 | 关键结论 | 最容易错的地方 |
|:--|:--|:--|:--|:--|
| **一、接口与句柄** | 1.10.1、1.10.7–1.10.8 | 一个整数怎样代表一个打开的文件？ | `open` 返回进程 fd 表里最小的空位；fd 表项指向打开文件描述（`struct file`），后者指向 inode。`open` 两次同一路径得到两个打开文件描述、两套偏移；`dup`、`fork`、`SCM_RIGHTS` 共享同一个打开文件描述，偏移与状态标志都共享。`FD_CLOEXEC` 是 fd 表项上的描述符标志，`O_APPEND`/`O_NONBLOCK` 是打开文件描述上的状态标志；`O_CLOEXEC` 的价值是原子，先 `open` 再 `fcntl` 在多线程里有泄漏窗口。 | 把 fd 当文件；以为 `dup2` 复制偏移；以为 `close(1)` 后 `printf` 一定报错；不区分 `EMFILE`（进程 fd 表满）与 `ENFILE`（系统文件表满）。 |
| **二、元数据与目录** | 1.10.2–1.10.3、1.10.13 | 文件内容之外还有什么？目录为什么不是文本？ | `st_size` 是逻辑大小，`st_blocks` 是实际分配的 512 B 块数，稀疏文件可以 size 很大而 blocks 为 0；`st_blksize` 是建议 I/O 粒度，不是扇区；`st_ctim` 是 inode 状态改变时间，不是创建时间。`stat` 跟随符号链接，`lstat` 不跟随，`fstatat` 用 `AT_SYMLINK_NOFOLLOW` 控制。目录不能 `read`（`EISDIR`），要用 `readdir`/`getdents64`；`d_type` 可能是 `DT_UNKNOWN`，必须 `fstatat` 补齐；`readdir` 返回的指针下一次调用可能被覆盖。 | 把 `st_size` 当占用空间；把 `st_blksize` 当磁盘扇区；以为 `d_type` 一定可信；用 `snprintf` 拼深路径再 `stat`。 |
| **三、返回值与健壮读写** | 1.10.4、1.10.9、1.10.11 | `read`/`write` 到底承诺了什么？ | 返回值有七种：`>0` 且小于请求是短读/短写；等于请求是完成；`0` 对 `read` 是 EOF；`-1/EINTR` 重试；`-1/EAGAIN` 等事件；`-1/EPIPE` 对端关闭；其他 errno 记录并放弃。短读不是异常，管道、socket、终端规范模式、信号、`O_DIRECT`、NFS 都会造成短读；短写同理。Linux 单次 `read`/`write` 最多处理 `MAX_RW_COUNT = 0x7ffff000`，更大的请求要自己分块。 | 把短读当完整报文；把 `EAGAIN` 当 EOF；把 0 当错误；`write` 返回 0 还继续循环；忘记 `EINTR` 重试。 |
| **四、共享、重定向与 fd 生命周期** | 1.10.5、1.10.8、1.10.10 | 重定向到底改了什么？fd 什么时候真正关闭？ | `dup2(oldfd, newfd)` 让 `newfd` 指向 `oldfd` 的打开文件描述，若 `newfd` 已打开则原子地先关闭；`oldfd == newfd` 直接返回；`dup3` 多一个 `O_CLOEXEC` 且 `oldfd == newfd` 返回 `EINVAL`。shell 的 `>` 是 `open` + `dup2` + `close`；顺序决定 `cmd 2>&1 >out` 与 `cmd >out 2>&1` 的结果。`close` 只删 fd 表项并减引用计数，计数归零才释放；`unlink` 后只要还有 fd 打开，数据块就不释放，`/proc/<pid>/fd` 里显示 `(deleted)`。 | 重定向顺序写反；多线程同时 `dup2` 到同一 `newfd`；`close` 失败后重试；以为 `unlink` 立即释放空间。 |
| **五、缓冲、落盘与接口选择** | 1.10.6–1.10.7、1.10.12、1.10.14–1.10.16 | `write` 成功后数据在哪？什么时候算落盘？ | `printf` 先在 stdio 用户缓冲区；`write` 把数据复制进 page cache 并标脏；`fsync` 把文件数据与元数据写到设备，`fdatasync` 省掉无关元数据，`O_SYNC` 每次写都等设备，`O_DIRECT` 绕过 page cache 但仍有对齐要求。stdio 三种缓冲：全缓冲、行缓冲、无缓冲；stdout 连终端默认行缓冲，重定向到文件默认全缓冲，`_exit` 或崩溃会丢用户缓冲区。持久化顺序是「写临时文件 → `fsync` → `rename` → `fsync` 父目录」。接口选型：格式化文本用 stdio，网络/管道用 RIO 或显式循环，大文件随机访问用 `mmap`，文件到 socket 用 `sendfile`，管道中转用 `splice`，同文件系统复制用 `copy_file_range`，高并发小 I/O 用 `epoll`/`io_uring`。 | 以为 `write` 成功就落盘；以为 `fsync` 文件就够、不 `fsync` 目录；用 stdio 写 socket；以为零拷贝一次拷贝都没有。 |

## 一条主线

这一章从「一个整数」走到「数据在哪一层」：**fd 是进程 fd 表的下标（1.10.1、1.10.8），它指向的打开文件描述保存偏移与状态标志，所以 `open` 两次偏移独立，`dup`/`fork` 偏移共享；返回值是接口契约（1.10.9），短读、短写、`EINTR`、`EAGAIN`、`EPIPE` 不是异常而是必须处理的分支；缓冲区是分层的事实（1.10.6），stdio、page cache、设备缓存各有一层，`write` 成功只证明数据进了 page cache，`fsync` 才把边界推到设备；路径与目录是另一套接口（1.10.2、1.10.3、1.10.13），不能拿 `read` 硬读。** 1.10.4 与 1.10.11 把这些规则写成 RIO 与 `read_full`/`write_full`；1.10.5 与 1.10.10 用 `dup2` 把规则落到重定向；1.10.12 用零拷贝接口说明「少一次拷贝」省的是哪一段；1.10.14 与 1.10.15 用 `strace`、`dd`、`/proc` 把缓冲、对齐与 page cache 变成读数；1.10.16 的十三条陷阱和 1.10.17 的本章小结收口。

如果只记一句话：**看到 I/O 异常，先问返回值是哪一种，再问数据在哪一层，最后问这个接口的边界在哪里。** 这三问能覆盖本章绝大多数故障：短读是返回值，日志丢失是缓冲区层次，`df` 不降是 fd 生命周期，`O_DIRECT` 的 `EINVAL` 是对齐边界。

## 症状 → 机制 → 命令

| 症状 | 机制 | 先跑什么 |
|:--|:--|:--|
| `read` 只返回 100 字节，解析器却当成一条完整报文 | 短读：管道/socket 缓冲区不足、EOF、终端行模式、信号在部分数据后到达 | `strace -e trace=read -s 32 ./prog`；把解析循环改成 `read_full`，比较返回值与请求长度 |
| `write` 返回小于请求长度，调用者忽略 | 短写：管道/socket 缓冲区满、非阻塞、磁盘满/配额、`MAX_RW_COUNT` | `strace -e trace=write ./prog`；循环写剩余部分，非阻塞时等 `EPOLLOUT` |
| 收到一个信号，进程从 `read` 处退出 | 把 `EINTR` 当致命错误；或信号处理函数打断了慢系统调用 | `strace -e trace=read,sigaction ./prog`；`EINTR` 重试，或评估 `SA_RESTART` |
| 非阻塞读返回 -1，被当成对端关闭 | `EAGAIN` 是「暂时没有数据」，`0` 才是 EOF | `strace -e trace=read ./prog`；`EAGAIN` 注册可读事件，只有 `0` 才关闭连接 |
| 日志重定向到文件后最后几行消失 | stdout 全缓冲，数据还在用户态；`_exit`、崩溃、没 `fflush` | `strace -e trace=write ./prog > out`；`fflush(stdout)`、改用行缓冲、正常 `exit` |
| 多进程写同一日志，行与行交错 | `O_APPEND` 只保证单次 `write` 的「定位 + 写」原子；一条日志分多次写仍会交错 | `strace -e trace=write -f ./prog`；把一条日志拼成一次 `write`，管道场景注意 `PIPE_BUF` |
| `rm` 了大文件，`df` 仍不降 | 还有进程持有打开的 fd，inode 与数据块未释放 | `ls -l /proc/<pid>/fd` 后筛 `deleted`；`lsof +L1`；关闭或重启持有者 |
| `accept` 报 `EMFILE` 后空转 | 进程 fd 表达到 `RLIMIT_NOFILE`，没有预留救急 fd | `ulimit -n`；统计 `/proc/<pid>/fd` 的条目数；预留 `/dev/null` fd，丢弃一个连接后补回 |
| `write` 成功，机器掉电后文件为空或很短 | 数据只在 page cache；进程崩溃不影响内核回写，掉电会丢 | 在 `/proc/meminfo` 里查 `Dirty` 与 `Writeback`；`strace -e trace=fsync,fdatasync`；按「文件 → 目录」顺序 `fsync` |
| `rename` 原子替换后掉电，看到的还是旧文件或空文件 | 只 `fsync` 了文件，没有 `fsync` 父目录，目录项未持久 | `strace -e trace=fsync,rename,openat`；`open(dir, O_DIRECTORY)` 后 `fsync(dirfd)` |
| `dd` 或自写程序用 `O_DIRECT` 读，报 `EINVAL` | 缓冲区地址、文件偏移或长度没有按逻辑块大小对齐 | `dd bs=4k iflag=direct` 与 `bs=1000 iflag=direct` 对照；`posix_memalign` 分配缓冲区 |
| `df` 与 `du` 对不上，或 `ls -l` 的大小远大于 `du` | 稀疏文件：`st_size` 是逻辑大小，`st_blocks` 是实际分配的 512 B 块数 | `stat -c 'size=%s blocks=%b blksize=%o' file`；`du -h file` 对照 |

## 能否讲出这八句话

1. **fd 是下标，不是文件。** `open` 在进程 fd 表里找最小空位，创建一个新的打开文件描述；`open` 两次同一路径有两套偏移，`dup`/`fork`/`SCM_RIGHTS` 共享同一套偏移与状态标志。
2. **返回值是契约。** `read`/`write` 的 `>0` 短计数、`0` EOF、`-1/EINTR`、`-1/EAGAIN`、`-1/EPIPE` 各有后续动作；把短读当完整报文、把 `EAGAIN` 当 EOF，是网络代码最常见的两个错误。
3. **短读短写要循环。** 普通文件也会因为 EOF、信号、`O_DIRECT` 或文件系统块边界短读；管道与 socket 更常见。`read_full`/`write_full` 要同时处理短计数、`EINTR` 与 `EAGAIN`，`write` 返回 0 要当异常。
4. **四个 `stat` 字段各有口径。** `st_size` 逻辑大小、`st_blocks` 512 B 块数、`st_blksize` 建议 I/O 粒度、`st_ctim` inode 状态改变时间；`lstat` 不跟随符号链接，`fstatat` 用 `AT_SYMLINK_NOFOLLOW` 控制。
5. **目录不是文本。** `read` 目录返回 `EISDIR`，要用 `readdir`/`getdents64`；`d_type` 可能是 `DT_UNKNOWN`，必须 `fstatat` 补齐；`readdir` 的返回指针会被下一次调用覆盖，名字要复制。
6. **重定向是 `dup2` 的顺序。** `cmd 2>&1 >out` 先把 stderr 复制到当前 stdout（终端），再把 stdout 指向文件，所以 stderr 仍在终端；`cmd >out 2>&1` 才是两者都进文件。
7. **`write` 成功不等于落盘。** 数据先在 page cache；`fsync` 把文件数据与元数据写到设备，`fdatasync` 省掉无关元数据；`rename` 之后还要 `fsync` 父目录，目录项才持久。stdio 又加了一层用户缓冲区，`_exit` 或崩溃会丢。
8. **接口按边界选。** stdio 适合格式化文本，RIO/显式循环适合网络与管道，`mmap` 适合大文件随机访问，`sendfile`/`splice`/`copy_file_range` 省掉用户态拷贝，`epoll`/`io_uring` 适合高并发；零拷贝省的是内核与用户之间那次拷贝，不是所有拷贝。

## 学完之后

1. **[闭卷回忆卡](ch10-recall.md)**：18 张卡分三组——A 组考 fd、返回值、`stat`、目录、重定向、缓冲；B 组考 RIO、`EINTR`/`EAGAIN`、`CLOEXEC`/`EMFILE`、`openat` 遍历、零拷贝；C 组考 `strace`、`O_DIRECT`、page cache 与 BSD/GNU 差异。合上正文，把七种返回值、三层结构、`2>&1 >out` 的顺序从空白纸上叫出来。
2. **[习题集](ch10-exercises.md)**：A 组 6 题考「会读会判」，B 组 6 题给现象让你判返回值与生命周期，C 组 4 题在 Ubuntu 24.04 上免 `sudo` 复现。先做 A、B，再跑 C；每题都有判据。
3. **[学习目标自检表](ch10-checklist.md)**：这张表接管 [1.10.17 本章小结](ch10.md#sec-1.10.17)，把 6 条出口展开成 19 条，卡住时按右列回到小节与习题。
4. **[勘误与版本注记](ch10-errata.md)**：本章最容易搬家的是 GNU 与 BSD/macOS 的 `read`/`write` 语义、`O_DIRECT` 的对齐与可用性、`/proc` 字段的归属，以及 1.10.12/1.10.13 的示例输出。引用任何数字前先读未实测项。
5. **下一站**：fd 在 [1.11 网络编程](ch11.md) 里会变成 socket，短读短写与 `EAGAIN` 会在 epoll 服务器里再来一遍；第 2 篇的 [2.2.1](../part2/ch02.md#sec-2.2.1) 会把本章的三层结构重讲成系统编程接口，[2.2.12](../part2/ch02.md#sec-2.2.12) 给完整返回矩阵。
