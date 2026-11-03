# 1.10 闭卷回忆卡

这一页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。18 张卡分三组：**A 组考接口、返回值、元数据、目录、重定向与缓冲（1.10.1–1.10.10）**，**B 组考 RIO、`EINTR`/`EAGAIN`、`CLOEXEC`/`EMFILE`、`openat` 遍历与零拷贝（1.10.4–1.10.13）**，**C 组考 `strace`、`O_DIRECT`、page cache 与跨平台差异（1.10.14–1.10.16 与勘误页）**。建议在学完当天、隔天、第 3 天、第 7 天各做一次，每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 接口、返回值与元数据

::: method 回忆 1 · fd 的三层结构与共享
`open` 同一路径两次、`dup`、`fork` 之后，文件偏移与状态标志各是否共享？`FD_CLOEXEC` 存在哪一层？为什么 `O_CLOEXEC` 比「先 `open` 再 `fcntl`」可靠？

::: sol 答案
`open` 两次同一路径创建两个独立的打开文件描述（`struct file`），偏移与状态标志各自独立。`dup`/`dup2` 让两个 fd 号指向同一个打开文件描述，偏移与状态标志共享；`fork` 复制 fd 表但不复制打开文件描述，父子共享；`SCM_RIGHTS` 传递 fd 也是同一个打开文件描述。`FD_CLOEXEC` 是 fd 表项上的描述符标志，每个 fd 独立，用 `F_GETFD`/`F_SETFD` 读写；`O_APPEND`、`O_NONBLOCK`、`O_ASYNC` 等状态标志在打开文件描述里，用 `F_GETFL`/`F_SETFL` 读写，随 `dup` 共享。`O_CLOEXEC` 在 `open` 的同一原子操作里设置 `FD_CLOEXEC`；先 `open` 再 `fcntl` 的写法在多线程程序里有窗口：另一个线程可能在这两步之间 `fork` + `exec`，把不该继承的 fd 泄漏给子程序。

:::
:::

::: method 回忆 2 · read/write 的七种返回值
把 `read` 与 `write` 的返回值列全：`>0` 但小于请求、等于请求、`0`、`-1/EINTR`、`-1/EAGAIN`、`-1/EPIPE`、其他 `-1`。每一种后面该做什么？

::: sol 答案
`>0` 且小于 `count` 是短读/短写：移动指针，继续剩余部分。等于 `count` 是完成。`read` 返回 `0` 是 EOF，结束循环；`write` 返回 `0` 只在 `count == 0` 或设备不接受数据时出现，非零请求返回 0 应视为异常（可置 `EIO`）。`-1/EINTR` 是被信号打断且没有传输数据，重试。`-1/EAGAIN` 是非阻塞且暂无数据/缓冲区满，等可读/可写事件后重试，不能当 EOF。`-1/EPIPE` 是管道或 socket 对端关闭，同时会收到 `SIGPIPE`；忽略或处理信号后停止写。其他 `-1` 如 `EBADF`、`EIO`、`EISDIR`、`ENOSPC`、`EFBIG`、`EDQUOT` 记录并放弃。判断一律用 `errno` 宏，不写数字。

:::
:::

::: method 回忆 3 · 短读为什么发生
列出至少四条短读原因。`read(fd, buf, 4096)` 返回 100，能说明文件只剩 100 字节吗？怎样读满 4096？

::: sol 答案
短读原因：① 到达 EOF，文件只剩 100 字节；② 管道/socket 缓冲区里只有 100 字节且写端未关闭；③ 终端规范模式一次最多返回一行，行长受 `MAX_CANON` 限制；④ 信号在部分数据到达后打断，`read` 返回已读字节数而不是 `EINTR`；⑤ `O_DIRECT` 或特殊设备的对齐/块大小限制；⑥ NFS 等网络文件系统返回的块小于请求。返回 100 不能说明文件只剩 100 字节，只能说明这次只拿到 100。读满要循环：累加 `done`，每次读 `n-done`；`r == 0` 表示 EOF，返回短计数；`r == -1 && errno == EINTR` 继续；其他错误返回 -1。调用者必须比较返回值与请求长度，不能假设「没报错就是读满」。

:::
:::

::: method 回忆 4 · stat 的四个字段
`st_size`、`st_blocks`、`st_blksize`、`st_ctim` 各是什么？稀疏文件为什么能让 `ls -l` 与 `du` 对不上？`stat`、`lstat`、`fstatat` 在符号链接上差在哪？

::: sol 答案
`st_size` 是文件的逻辑大小（字节），`st_blocks` 是实际分配的 512 字节块数，`st_blksize` 是推荐的 I/O 粒度（常见 4096，不是磁盘扇区），`st_ctim` 是 inode 状态改变时间，不是创建时间；Linux 的创建时间要走 `statx` 的 `stx_btime`，且依赖文件系统。稀疏文件 `st_size` 可以很大而 `st_blocks` 很小甚至为 0，所以 `ls -l` 看逻辑大小、`du` 看实际占用。`stat` 跟随符号链接，看到目标文件；`lstat` 不跟随，看到链接本身的 inode 与长度；`fstatat(dirfd, path, &st, flags)` 默认跟随，传 `AT_SYMLINK_NOFOLLOW` 才不跟随，且相对 `dirfd` 解析，适合遍历目录时避免 TOCTOU。

:::
:::

::: method 回忆 5 · 目录不是文本文件
为什么 `read` 一个目录会失败？`readdir` 的 `d_type` 为什么可能是 `DT_UNKNOWN`？`readdir` 返回的指针能保存吗？多线程遍历同一目录要注意什么？

::: sol 答案
目录在磁盘上是「名字 → inode」的结构化记录，不是字节流；Linux 与 macOS 的 `read(2)` 对目录都返回 `EISDIR`。要用 `opendir`/`readdir`/`closedir`，glibc 底层是 `getdents64`。`struct dirent` 的关键字段是 `d_ino`、`d_off`、`d_reclen`、`d_type`、`d_name`；`d_type` 只是目录项里的提示，XFS、NFS 等文件系统可能返回 `DT_UNKNOWN`，必须对每个名字做 `fstatat` 补齐。`readdir` 返回的指针由 `DIR` 内部缓冲区持有，下一次 `readdir` 可能覆盖它，要保存名字必须复制。`readdir` 不保证线程安全；多线程遍历同一目录要用各自的 `DIR`，或加锁。

:::
:::

::: method 回忆 6 · dup2 与重定向顺序
`cmd 2>&1 >out` 之后 stdout 与 stderr 分别去哪？`cmd >out 2>&1` 呢？`dup2(oldfd, newfd)` 在 `oldfd == newfd`、`newfd` 已打开、`oldfd` 无效时各是什么行为？`dup3` 多了什么？

::: sol 答案
`cmd 2>&1 >out` 从左到右：先把 fd 2 复制成 fd 1 当前指向的终端，再把 fd 1 改成 `out`；所以 stderr 仍在终端，stdout 进文件。`cmd >out 2>&1` 先把 fd 1 指向 `out`，再把 fd 2 复制 fd 1，两者都进文件。`dup2(oldfd, newfd)` 让 `newfd` 指向 `oldfd` 的打开文件描述；`oldfd == newfd` 直接返回 `newfd`，不关闭也不改标志；`newfd` 已打开时原子地先关闭再复制；`oldfd` 无效返回 -1/`EBADF`，`newfd` 不变；`newfd` 超出 `RLIMIT_NOFILE` 也返回 `EBADF`；多线程同时 `dup2` 到同一 `newfd` 是竞争。`dup3` 多一个 `flags` 参数（目前支持 `O_CLOEXEC`），且 `oldfd == newfd` 返回 `EINVAL`，语义更明确。

:::
:::

::: method 回忆 7 · write、fsync 与 stdio 缓冲
`write` 返回成功时数据在哪？`fsync`、`fdatasync`、`O_SYNC`、`O_DIRECT` 各把边界画在哪？stdio 三种缓冲是什么？为什么 `rename` 之后还要 `fsync` 目录？

::: sol 答案
`write` 通常只把数据复制进 page cache 并标脏，由内核 writeback 线程在几秒到几十秒后写回；进程崩溃不影响内核回写，机器掉电会丢。`fsync(fd)` 把文件数据与元数据写到设备；`fdatasync(fd)` 只保证数据与必要元数据，省掉无关元数据；`O_SYNC` 让每次 `write` 都等设备，语义最强、代价最大；`O_DIRECT` 绕过 page cache，但要求地址、偏移、长度对齐，且不代替 `fsync`。stdio 三种缓冲：`_IOFBF` 全缓冲（缓冲区满、`fflush`、`fclose` 刷新，重定向到文件常见）、`_IOLBF` 行缓冲（遇到 `\n` 刷新，终端常见）、`_IONBF` 无缓冲（`stderr` 常见）。`rename` 只改目录项；文件内容 `fsync` 了，目录项本身还可能没持久，所以要 `open` 父目录得到 `dirfd`，`fsync(dirfd)`。

:::
:::

## B. 程序、路径与接口

::: method 回忆 8 · RIO 的不变量
`rio_read` 什么时候调用 `read`、一次读多少？`rio_readn` 遇到 `0` 与 `EINTR` 各怎么做？`rio_writen` 遇到 `write` 返回 0 为什么置 `EIO`？`rio_readlineb` 的 `maxlen` 包含什么？

::: sol 答案
`rio_read` 只有在内部缓冲区为空（`rio_cnt <= 0`）时才调用 `read`，一次读 `RIO_BUFSIZE`（8192）字节；`EINTR` 重试，`0` 返回 0（EOF），否则把缓冲区指针与计数装好，再 `memcpy` 最多 `n` 字节给调用者，返回值可能小于请求。`rio_readn` 循环读剩余字节；`EINTR` 继续；`0` 表示 EOF，跳出并返回已读的短计数；其他错误返回 -1。`rio_writen` 循环写剩余字节；`EINTR` 继续；`write` 返回 0 时置 `errno = EIO` 并返回 -1，否则 `nleft` 不变会死循环。`rio_readlineb` 的 `maxlen` 包含结尾的 `\0`；超长行会被截断，调用者要根据「最后有没有换行」判断是否还有剩余。

:::
:::

::: method 回忆 9 · EINTR、EAGAIN 与 SA_RESTART
哪些系统调用遇到 `EINTR` 应该重试，哪些不应该？`SA_RESTART` 能保证什么、不能保证什么？非阻塞读返回 `-1/EAGAIN` 与返回 `0` 有什么区别？

::: sol 答案
`read`/`write` 重试，除非已经返回了部分数据（那就从短计数继续）；`open` 重试通常可接受，但理论上可能打开两次；`close` 不要重试（Linux 上 fd 已释放，重试可能关掉另一个线程刚打开的同号 fd）；`accept`/`connect`/`recv` 重试，或用 `SA_RESTART`；`nanosleep` 返回剩余时间，应把剩余时间再传回去继续睡。`SA_RESTART` 让一部分被信号打断的系统调用自动重启，少写重试循环；但 `read` 在终端、socket 上仍可能返回 `EINTR`，不能完全依赖。非阻塞读返回 `-1/EAGAIN` 是「暂时没有数据」，应等可读事件再试；返回 `0` 是 EOF（管道/socket 的写端全部关闭）。把两者混淆会导致「对端还活着却提前关闭连接」。

:::
:::

::: method 回忆 10 · CLOEXEC 与 EMFILE
`O_CLOEXEC` 解决的是什么竞争？`EMFILE` 与 `ENFILE` 分别是什么满了？`accept` 遇到 `EMFILE` 为什么要预留一个「救急 fd」？

::: sol 答案
`O_CLOEXEC` 在 `open` 的同一原子操作里设置 `FD_CLOEXEC`，避免「先 `open` 再 `fcntl(F_SETFD)`」之间被另一个线程 `fork` + `exec`，把不该继承的 fd 泄漏给子程序；对已有 fd 可以用 `fcntl(fd, F_DUPFD_CLOEXEC, 0)` 复制出带 `CLOEXEC` 的新 fd。`EMFILE` 是进程 fd 表达到 `RLIMIT_NOFILE` 软限制；`ENFILE` 是系统文件表满（全局上限或内存不足）；排查分别用 `ulimit -n`、`ls /proc/<pid>/fd | wc -l` 与 `cat /proc/sys/fs/file-nr`。`accept` 返回 `EMFILE` 后如果继续 `accept` 会空转；正确做法是预留一个 `/dev/null` fd，检测到 `EMFILE` 时关掉它，`accept` 一个连接后立刻关闭（丢弃），再补回救急 fd，给自己留出打日志和退出的余地。

:::
:::

::: method 回忆 11 · openat 遍历与 fdopendir 的所有权
为什么遍历深目录不要用 `snprintf` 拼路径？`O_NOFOLLOW` 在遍历里防什么？`fdopendir` 成功后 fd 归谁？失败时呢？

::: sol 答案
`snprintf` 拼路径会遇到 `PATH_MAX` 上限，深目录会截断；而且「先拼路径再 `stat`」在并发 `rename` 下会得到错的对象（TOCTOU）。正确做法是全程用 `openat`/`fstatat`，以目录 fd 为锚点逐层下钻，路径永远只是一个名字，不会变长。`O_NOFOLLOW` 让目录项是符号链接时 `openat` 返回 `ELOOP`，不会跑到目标目录里形成环；遍历不可信目录树时必须加。`fdopendir(dfd)` 成功后由 `DIR` 接管 fd 的所有权，不能再 `close(dfd)`，`closedir` 会关；失败时 fd 仍归调用者，要自己关闭。这是最容易写错的所有权转移。

:::
:::

::: method 回忆 12 · 零拷贝接口的边界
`sendfile`、`splice`、`copy_file_range` 各适合什么、主要限制是什么？零拷贝省掉的是哪一次拷贝？`sendfile` 真的「没有拷贝」吗？

::: sol 答案
`sendfile(out, in, ...)` 适合文件到 socket，数据从 page cache 直接挂到 socket 缓冲区（可配合 DMA）；`in` 必须是支持 `mmap` 的文件，早期要求 `out` 是 socket。`splice` 适合用管道做中转，在两个 fd 之间移动页引用，至少一端是管道。`copy_file_range` 适合同文件系统内复制，内核内复制，btrfs/XFS 上可能走 reflink；跨文件系统可能返回 `EXDEV`，NFS 支持依版本。零拷贝省掉的是**内核态与用户态之间**的那次拷贝，以及相应的系统调用；`sendfile` 仍要把数据从磁盘读进 page cache（DMA 拷贝），网卡不支持 scatter-gather 时也可能再复制一次。名字是营销术语，理解成「少一次拷贝」更准确。

:::
:::

::: method 回忆 13 · 接口选型
五个场景各选什么、为什么：① 格式化日志；② 网络上的行协议；③ 8 GiB 文件的随机读；④ 文件内容发到 socket；⑤ 高并发小 I/O。

::: sol 答案
① 格式化日志用 stdio（`printf`/`fprintf`），缓冲、格式化、错误处理成熟；但要注意全缓冲与 `fflush`。② 网络行协议用 RIO 或手写循环，必须处理短读短写与 `EINTR`；不要用 stdio 写 socket，`fprintf` 可能缓冲、可能部分写、错误码被 `FILE` 状态掩盖。③ 8 GiB 文件随机读用 `mmap` 或 `pread`，避免多次拷贝、按页缺页；`mmap` 要注意 `SIGBUS` 与文件截断。④ 文件到 socket 用 `sendfile`，省掉用户态拷贝；需要 TLS 或用户态处理时就不能直接用。⑤ 高并发小 I/O 用 `epoll` + 非阻塞 fd，极高 IOPS/批量提交用 `io_uring`。选型的共同判据是：返回值语义、数据层次、是否需要持久化边界。

:::
:::

## C. 证据、对齐与跨平台

::: method 回忆 14 · 用 strace 看缓冲
1.10.14 的四个步骤各证明什么？1000 行 `printf` 重定向到 `/dev/null` 与接到终端，`write` 次数为什么不同？本书虚拟机上各是多少次、每次多大？

::: sol 答案
步骤 1 证明 `printf` 不是一次 `write`、stdio 会合并；步骤 2 用 `-y` 把 fd 号翻译成路径（`write(1</dev/null>, ...)`）；步骤 3 观察 `cat`/逐行程序的预读；步骤 4 的 `strace -c` 按系统调用聚合，只能数次数，不能测性能（`strace` 会把每次系统调用放大 10–100 倍）。重定向到 `/dev/null` 时 stdout 是全缓冲，1000 行（每行 10 字节，共 10000 字节）被合并；接到终端时是行缓冲，每行一次 `write`。本书 VM 实测（Ubuntu 24.04.5、glibc 2.39、strace 6.8）：重定向是 3 次 `write`，大小 4096、4096、1808；用 `script -qec` 分配 pty 后是 1000 次。正文 1.10.14 说「通常 1–2 次」，在这台机器上不成立，按自己的 libc 与缓冲大小读。

:::
:::

::: method 回忆 15 · O_DIRECT 的对齐
`O_DIRECT` 要求哪三样对齐？`dd bs=4k iflag=direct` 与 `bs=1000 iflag=direct` 在本书 VM 上各是什么结果？自写程序里偏移 1、缓冲区 +1 各会怎样？

::: sol 答案
`O_DIRECT` 要求缓冲区地址、文件偏移、传输长度都按逻辑块大小对齐；块大小由文件系统/设备决定，常见 512 B 或 4 KiB。本书 VM 实测（`/tmp`）：`dd bs=4k iflag=direct` 成功；`dd bs=1000 iflag=direct` 报 `Invalid argument`（`errno = EINVAL`，22），0 字节。自写程序用 `posix_memalign(..., 4096, 4096)` 分配缓冲区，4 KiB 对齐、偏移 0、长度 4096 的 `pwrite` 成功；偏移 1 或缓冲区 `+1` 都返回 -1/`EINVAL`。不对齐时 `read`/`write` 直接失败，不会自动帮你拆；数据库自己管理对齐缓冲区就是为了这个。`O_DIRECT` 不是 POSIX，macOS 上没有 `O_DIRECT`。

:::
:::

::: method 回忆 16 · 没有 root 怎么看 page cache
`sudo` 不可用时，1.10.15 的 `drop_caches` 不能跑。还能用什么证明「第二次读没有进块层」？`/proc/self/io` 的 `rchar` 与 `read_bytes` 各是什么？本书 VM 上的 32 MiB 实验给出什么数？

::: sol 答案
用 `posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED)` 把文件的干净页从 page cache 丢掉，再读两遍，同时读 `/proc/self/io`。`rchar` 是进程读过的总字节数（包括命中 page cache 的），`read_bytes` 是实际从块层读到的字节数；前者只增不减，后者只在真正发生块 I/O 时增加。本书 VM 实测：32 MiB 文件 `fsync` 后 `fadvise`，第一次读 `read_bytes` 增加 33554432（正好 32 MiB），`rchar` 增加约 32 MiB；`lseek` 回 0 再读，`rchar` 再增加约 32 MiB，`read_bytes` 不再增加。第二次读完全命中 page cache，这就是「热读为什么快」的直接证据。`drop_caches` 是整机操作、需要 root；`fadvise` 只影响一个文件、不需要特权。

:::
:::

::: method 回忆 17 · 十三条陷阱里的六条
从 1.10.16 里任选六条，说出「现象 → 原因 → 修复」。至少包含一条返回值、一条生命周期、一条持久化。

::: sol 答案
① `read` 只返回一部分就继续解析 → 把短读当完整报文 → 循环读到所需长度或 EOF。② 非阻塞读把 `EAGAIN` 当 EOF → 混淆「暂无数据」与「对端关闭」 → `EAGAIN` 等事件，`0` 才是 EOF。③ `fork` 后子进程重复输出 → 继承了 stdio 缓冲且调用 `exit` → 子进程用 `_exit`，或 `fork` 前 `fflush(NULL)`。④ 日志行交错 → 一条日志分多次 `write`，`O_APPEND` 只保证单次原子 → 拼成一次 `write`。⑤ `fsync` 后仍丢数据 → 只同步文件，没同步目录项 → `rename` 后 `fsync` 父目录 fd。⑥ `EMFILE` 后 `accept` 空转 → 没有预留救急 fd → 预留 `/dev/null` fd，丢弃一个连接后补回。其余七条：`write` 短写被忽略、把 `EINTR` 当致命错误、`close` 后仍用 fd 号、多线程 `dup2` 覆盖别人的 fd、混用 `FILE *` 与 `read`、重定向顺序写反、`O_DIRECT` 未对齐。

:::
:::

::: method 回忆 18 · GNU/Linux 与 BSD/macOS 的差异
`EAGAIN` 在 Linux 与 macOS 上各是多少？macOS 有 `O_DIRECT` 与 `/proc` 吗？`read` 目录在两边各返回什么？`st_ctime` 与 `st_birthtime` 差在哪？

::: sol 答案
`EAGAIN` 在 Linux 是 11，macOS 是 35；比较用宏，不写数字。macOS 27.2 实测没有定义 `O_DIRECT`（对应机制是 `F_NOCACHE`），也没有 `/proc`：`readlink("/proc/self/fd/N")` 失败，对应的是 `/dev/fd`，而且 `/dev/fd` 是 fdesc 目录，不是 Linux 那种符号链接目录。`read` 目录在 Linux 与 macOS 27.2 实测都返回 `EISDIR`，所以「BSD 可以读目录」不能当现状。`st_ctime` 在 Linux 是 inode 状态改变时间，创建时间要走 `statx` 的 `stx_btime`；macOS 的 `struct stat` 另有 `st_birthtime`，Linux 的 `struct stat` 没有。正文的 `O_DIRECT` 对齐实验与 `/proc` 证据都只能在 Linux 上做。

:::
:::
