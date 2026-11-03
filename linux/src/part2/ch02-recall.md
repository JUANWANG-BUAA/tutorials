# 2.2 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。25 张卡分三组：**A 组考三层对象与五个调用（2.2.1–2.2.4.1）**，**B 组考原子性、页缓存与接口全表（2.2.5–2.2.11）**，**C 组考返回矩阵、偏移、生命周期与取证（2.2.12–2.2.20）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下次只重做 △ 和 ×。

## A. 三层对象与五个调用

::: method 回忆 1 · 三层对象与一次手推
fd、打开文件描述、inode 各存什么、谁共享？设文件内容是 `ABCDE`，依次执行 `a=open`、`b=dup(a)`、`c=open`、`read(a,2)`、`read(b,1)`、`read(c,1)`、`close(a)`、`read(b,1)`，每次读到什么？
::: sol 答案
三层：进程 fd 表（`files_struct`，下标 → `struct file *`，同进程线程共享，`fork` 后各自一份）；打开文件描述（`struct file`，存偏移 `f_pos`、状态标志、引用计数、`f_op`，`dup`/`fork` 后共享）；inode（文件类型、权限、大小、时间、数据块位置，所有打开同一文件的进程共享）。手推读数：`read(a,2)` 得 `AB`，共用偏移推到 2；`read(b,1)` 得 `C`，共用偏移推到 3；`read(c,1)` 得 `A`（第二次 `open` 是另一个 `struct file`，偏移独立），c 的偏移推到 1；`close(a)` 只删 a 的表项，`struct file` 仍被 b 引用；最后一个 `read(b,1)` 得 `D`。迁移：若在此之前 `lseek(b,0,SEEK_SET)`，b 读 `A`、c 仍从自己的偏移 1 读 `B`。
:::
:::

::: method 回忆 2 · `open` 的三组 flags 与 `mode`
flags 分哪三组？`mode` 什么时候有意义？最终权限怎么算？漏写 `mode` 会怎样？`creat()` 是什么的别名？
::: sol 答案
三组：访问模式（低两位且必须有且只有一个：`O_RDONLY`=0、`O_WRONLY`=1、`O_RDWR`=2，用 `O_ACCMODE` 掩出来）；创建/截断（`O_CREAT`、`O_EXCL`、`O_TRUNC`、`O_NOCTTY`）；行为修饰（`O_APPEND`、`O_NONBLOCK`、`O_SYNC`/`O_DSYNC`、`O_DIRECT`、`O_CLOEXEC`、`O_TMPFILE`）。`mode` 只在带 `O_CREAT` 或 `O_TMPFILE` 时参与，最终权限 = `mode & 07777 & ~umask`，`umask` 只清位不加位。带 `O_CREAT` 却省略 `mode` 是未定义行为——它是可变参数，通常读到栈上的垃圾值，于是创建出权限诡异的文件。`creat(path, mode)` 等价于 `open(path, O_WRONLY|O_CREAT|O_TRUNC, mode)`，同样受 `umask` 影响。
:::
:::

::: method 回忆 3 · `openat` 的三个价值
`openat(dirfd, ...)` 比 `open` 多什么？`AT_FDCWD` 是什么？说出三个不能只靠 `open` 的理由。
::: sol 答案
多一个 `dirfd` 作解析锚点；`AT_FDCWD` 表示「按进程当前目录」，此时 `openat` 等价于 `open`。三个价值：① 避免 TOCTOU（time-of-check-to-time-of-use，检查与使用之间的时间窗）——先 `open(dir)` 再 `openat(dirfd, "file")`，即使目录被 `rename`，解析仍锚在同一个目录 inode 上；② 限制逃逸——配合 `O_NOFOLLOW`、`openat2` 的 `RESOLVE_BENEATH` 可以禁止 `..` 跳出目录；③ 线程安全——不依赖进程级 `cwd`，别的线程 `chdir` 不影响你的相对路径。
:::
:::

::: method 回忆 4 · 两个必须记住的原子性
`O_CREAT|O_EXCL` 与 `O_APPEND` 各把哪两步合成一步？各自不保证什么？为什么 `access()` + `open()`、`lseek(END)` + `write()` 是错的？
::: sol 答案
`O_CREAT|O_EXCL`：「检查不存在 + 创建」原子，并发只有一个成功、另一个 `EEXIST`，所以锁文件与临时文件的正确做法是它；`access` + `open` 之间别人能插进来，两个进程都以为拿到锁。`O_APPEND`：每次 `write` 的「定位末尾 + 写」在 inode 锁内原子，多进程不会互相覆盖；但**不保证整条记录不交错**——一次逻辑记录若由多次 `write`（或 stdio 多次 flush）完成，仍会与别人的字节穿插；`lseek(END)` + `write` 之间也可能被别人追加，你的写会盖掉对方。另外：`O_EXCL` 不带 `O_CREAT` 被忽略；NFS 上两者都依赖服务器实现（NFSv2 的 `O_EXCL` 不可靠）。
:::
:::

::: method 回忆 5 · `O_CLOEXEC` 为什么要原子
`FD_CLOEXEC` 管什么？为什么「先 `open` 再 `fcntl(F_SETFD)`」不安全？本章给了哪四个能原子设置它的入口？
::: sol 答案
`FD_CLOEXEC` 决定 `exec()` 时是否关闭该 fd；没设它的 fd 会被 `fork`+`exec` 的子程序继承，日志、socket、数据库连接就这样漏出去。两步法不安全是因为多线程里 `open` 与 `fcntl` 之间有窗口：另一个线程刚好 `fork`+`exec`，fd 就漏过去了。四个原子入口：`open`/`openat` 的 `O_CLOEXEC`、`socket`/`accept4`/`pipe2` 的 `O_CLOEXEC`、`fcntl(fd, F_DUPFD_CLOEXEC, 0)`、`dup3(old, new, O_CLOEXEC)`；`close_range(..., CLOSE_RANGE_CLOEXEC)` 是「批量只标记不关闭」。`O_CLOEXEC` 只影响 `exec`，不影响 `fork`——子进程照样继承，要 `fork` 后就关得在子进程里 `close` 或 `close_range`。
:::
:::

::: method 回忆 6 · `read`/`write` 的返回形态
不看正文列出 `read`/`write` 的五种返回形态与各自处理。正文那五个高频错误是什么？`count == 0` 时 `read` 返回 0 算 EOF 吗？
::: sol 答案
五种：`== count` 完成；`0 < n < count` 短读/短写，推进缓冲区与剩余长度继续；`0` — 读侧是 EOF（普通文件到末尾、管道写端全关），写侧通常是 `count == 0`，视为完成；`-1 + EINTR` 被打断，重试剩余部分；`-1 + 其他` 按错误码决定。五个高频错误：① `if (read(...) != n) error()` 把短读当错误；② `write` 不检查返回值，短写时静默丢数据；③ `EINTR` 一律当失败；④ `read` 返回 0 后继续读，循环空转；⑤ 把 `count == 0` 的返回 0 当 EOF。`count == 0` 时 Linux 的 `read`/`write` 返回 0 且**可能不检查 fd 是否有效**，所以不能用 `read(fd, buf, 0)` 探测 fd。
:::
:::

::: method 回忆 7 · 两个 `_full` 循环与三种「不行」
写出 `read_full`/`write_full` 的骨架并解释 `p + done`、`count - done`；`EINTR`、`EAGAIN`、`SA_RESTART` 三者的分工是什么？`write_full` 里 `n == 0` 为什么要报 `EIO`？
::: sol 答案
循环条件 `while (done < count)`，每次 `read(fd, p + done, count - done)`：`-1` 且 `errno == EINTR` 就 `continue`（进度不变，重试同一段），其他 `-1` 返回失败；读侧 `n == 0` 是 EOF 就 `break`，写侧 `n == 0` 且 `count > 0` 继续循环会死锁，所以设 `errno = EIO` 返回失败；否则 `done += n`。以写 `HELLO` 为例：第一次返回 2 后 `done=2`，第二次必须传 `p+2`、长度 3；若这次 `-1/EINTR`，进度仍是 2，重试的还是剩下的 3 字节；若每次都用 `p` 和 5，就会重复写前缀。`EINTR` 是**事件**（被信号打断，重试即可）；`EAGAIN`/`EWOULDBLOCK`（Linux 上同值）是**状态**（`O_NONBLOCK` 下现在没数据/缓冲满），要等 `epoll`/`poll` 就绪，忙等是错的；`SA_RESTART` 只让「可重启」的调用自动重来，`poll`/`epoll_wait`/`select`/`msgrcv` 不重启，所以库函数不能假设调用者设了它。
:::
:::

::: method 回忆 8 · `close`、`dup2`/`dup3`、`fcntl` 与偏移
`close()` 失败时 fd 处于什么状态，为什么不能重试？`dup`、`dup2`、`dup3`、`F_DUPFD_CLOEXEC` 差别在哪？`fcntl` 能改哪些 flag、不能改什么？`pread` 和 `lseek`+`read` 差在哪？
::: sol 答案
Linux 上 `close()` 会先释放 fd 再返回错误（例如 NFS 写回失败），重试可能关掉另一个线程刚打开的同号 fd，所以只记录不重试；要确保落盘用 `fsync(fd)` 再 `close(fd)`，不要用 `close` 的返回值判断数据安全性。`dup(fd)` 取当前最小可用 fd、共享同一个 `struct file`（偏移与 flags 一起）；`dup2(fd, 1)` 复制到指定 fd 并原子关闭原来的 1（`close(1); dup(fd);` 在多线程下会被抢走 fd 1）；`dup3` 与 `dup2` 只差两点：`flags` 只接受 `O_CLOEXEC`（原子设置），且 `oldfd == newfd` 时返回 `EINVAL`（`dup2` 直接返回 `newfd`）。`fcntl(F_SETFL)` 能改 `O_APPEND`/`O_NONBLOCK`/`O_ASYNC`，**不能改访问模式**（`open` 时固定）；`F_GETFL` 读回状态标志（含用 `O_ACCMODE` 掩出的访问模式），`F_GETFD` 读的是 fd 标志（`FD_CLOEXEC`）。`pread`/`pwrite` 把「定位 + 读写」合成一次原子操作且不改变共享偏移，多线程读同一 fd 用它而不是 `lseek`+`read`；管道上 `lseek`/`pread` 报 `ESPIPE`。
:::
:::

::: method 回忆 9 · `ioctl` 补的那半边
`ioctl` 的 `request` 是哪几个位段编出来的？`ENOTTY`、`EINVAL`、`EFAULT`、`EPERM` 各说明什么？正文四个危险是什么？为什么新子系统不该再发明 `ioctl`？
::: sol 答案
`request` 是 32 位编码：方向（`_IOC_NONE`/`_IOC_READ`/`_IOC_WRITE`）、大小（`_IOC_SIZEBITS`，通常 14 位，即第三个参数指向的结构体大小）、类型（8 位 magic，代表设备/子系统）、序号（8 位命令号）；构造宏 `_IO`/`_IOR`/`_IOW`/`_IOWR`，例如 `TIOCGWINSZ` 是「读一个 `struct winsize`」、`FIONREAD` 是「读一个 `int`」、`FS_IOC_GETFLAGS` 是「读 inode 的 flags」。错误码分工：`ENOTTY` = 这个 fd/设备不支持该 request（最常见，普通文件也返回它，它不等于「不是终端」）；`EINVAL` = request 认识但参数内容不合法；`EFAULT` = 第三个参数指向的地址不可访问；`EPERM` = 需要 `CAP_SYS_ADMIN`/`CAP_NET_ADMIN` 之类能力。四个危险：内核不校验你的指针类型（传错结构体会写坏栈）；`_IOR/_IOW` 编进去的结构体大小是 ABI 的一部分，32/64 位程序对同一 request 可能不同，驱动要 compat_ioctl；不要把 `ioctl` 当通用「发命令」接口——request 空间是稀缺资源，新子系统优先 netlink/sysfs/configfs；`ENOTTY` 的含义常被读错。
:::
:::

## B. 原子性、页缓存与接口全表

::: method 回忆 10 · 原子原语与持久化四步
「创建新文件已存在则失败」「追加写」「原子替换」「原子交换」「不覆盖地重命名」「原子建硬链接」各用什么原语？写一个文件并确保崩溃后可见的四步顺序是什么？为什么最后一步容易漏？
::: sol 答案
依次为 `open(O_CREAT|O_EXCL)`、`open(O_APPEND)` + 单次 `write`、`rename(tmp, dst)`、`renameat2(..., RENAME_EXCHANGE)`、`renameat2(..., RENAME_NOREPLACE)`、`link(tmp, dst)`；对应错误做法是 `access()+open()`、`lseek(END)+write()`、先 `unlink` 再 `rename`、两次 `rename`、`access()+rename`、先检查再 `link`。四步：写临时文件 → `fsync(fd)`（数据落盘）→ `close(fd)` + `rename(tmp, dst)`（原子替换）→ `fsync(dirfd)`（目录项落盘）。最后一步容易漏，因为 `rename` 改的是目录这个文件的内容，目录本身也要回写；不 `fsync` 目录，崩溃后可能看不到新名字。打开目录做 `fsync` 要带 `O_DIRECTORY`。
:::
:::

::: method 回忆 11 · fd 泄漏与 `(deleted)`
泄漏的三种表现是什么？三步排查各看什么？`(deleted)` 为什么让 `df` 不降？`/dev/fd/N` 是「按路径重开」吗？三个边界在哪？
::: sol 答案
表现：`Too many open files`（`EMFILE`）、`accept` 失败、连接随机断。三步：① `ls /proc/$PID/fd | wc -l` 加 `grep 'open files' /proc/$PID/limits` 看数量与上限；② `ls -l /proc/$PID/fd` 看每个 fd 指向什么；③ `strace -f -e trace=openat,close -p $PID` 看打开/关闭是否配对（`-p` 挂别人的进程可能被 `ptrace_scope` 挡住，用自己跑的程序最稳）。`(deleted)` 是目录项已删但 inode 仍有引用：空间要等最后一个 fd 关闭才释放，这是日志轮转后磁盘不释放的标准原因；`lsof +L1` 能列出链接数为 0 的打开文件。`/dev/fd/N` 是 `/proc/self/fd/N` 的符号链接，`open("/dev/fd/N", ...)` **复制当前进程的 fd N**（继承同一个 `struct file` 的偏移与状态），不是按路径重新打开；shell 的 `<(cmd)` 就靠它。三个边界：`O_PATH` 的 fd 只能 `fstat`/`openat`/`fchdir` 一类，不能 `read`/`write`，`/dev/fd/N` 对它的作用依内核而异；对 socket/pipe「重新打开」没有意义，可能 `ENXIO`/`ENODEV`；带 `O_CLOEXEC` 的 fd 在 `exec` 后就没了，`/dev/fd/N` 也就不存在。
:::
:::

::: method 回忆 12 · `copy.c` 的纪律清单
正文那份复制程序里，哪八处是刻意写成这样的？说出每一处防的是什么。
::: sol 答案
① 两个 `open` 都带 `O_CLOEXEC`：防止 fd 漏给 `exec` 出去的子程序。② 目标先写成 `DST.tmp.<pid>` 并带 `O_CREAT|O_EXCL`：防止并发覆盖、防止半成品覆盖目标。③ `read_full`/`write_full` 处理短读短写与 `EINTR`：防止少拷一段还报成功。④ 每个错误分支都 `close` 两个 fd 并 `unlink(tmp)`：防止 fd 泄漏与垃圾文件残留。⑤ 先 `fsync(out)` 再 `close`：数据落盘后才允许被改名，`close` 的返回值只用来记错误。⑥ `rename(tmp, DST)`：目录项原子替换。⑦ 用 `O_RDONLY|O_DIRECTORY` 打开 `.` 再 `fsync`：目录项本身落盘。⑧ 缓冲区 256 KiB 而不是 4 KiB：一次调用搬更多，摊薄系统调用成本。编译验证用 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2`，读数用 `strace -e trace=openat,read,write,fsync,rename`。
:::
:::

::: method 回忆 13 · 页缓存四条
`write()` 返回说明什么？`read()` 命中缓存时碰不碰磁盘？`fsync` 贵在哪？`O_DIRECT` 有什么前提？`kill -9` 和断电各丢什么？
::: sol 答案
① `write()` 返回只代表数据进了 page cache（除非 `O_DIRECT`/`O_SYNC`）：进程崩溃不丢（页在内核里），机器掉电未回写会丢。② `read()` 命中页缓存时完全不碰磁盘；首次读触发预读（readahead），所以顺序读吞吐远高于随机读。③ `fsync()` 的代价是等设备确认，批量写 + 一次 `fsync` 远快于每条记录一次，数据库 WAL 就按这个原则设计。④ `O_DIRECT` 绕过页缓存，但缓冲区地址、文件偏移、长度都要按块对齐，否则 `EINVAL`；栈上的 `char buf[4096]` 不保证对齐，要 `posix_memalign`。排查顺序也是这一节给的：先确认瓶颈在 I/O 还是 CPU（`iostat -x 1`），再看是否命中缓存（`free -h` 的 `buff/cache`、`/proc/meminfo` 的 `Cached`），再看读写比例与块大小、是否同步写（`strace -c -e trace=fsync,fdatasync`）、文件系统与挂载选项（`findmnt -T`），最后才动 `vm.dirty_ratio` 这类内核参数。
:::
:::

::: method 回忆 14 · `posix_fadvise` 与 `madvise`
六个 advice 各是什么？哪个最容易误用？`madvise` 作用在什么对象上？`fadvise` 的返回值怎么看？
::: sol 答案
`NORMAL` 默认、`SEQUENTIAL` 顺序读（预读加倍）、`RANDOM` 随机读（关预读）、`WILLNEED` 提前读入、`DONTNEED` 尝试丢弃、`NOREUSE` 提示替换算法可忽略该区间。最容易被误用的是 `NOREUSE`：它**不会**把数据赶出页缓存（Linux 2.6.18–6.2 上是 no-op，6.3+ 只影响已映射页），要释放缓存用 `DONTNEED`，且 `DONTNEED` 只对**干净页**生效、脏页要先回写，它也只是提示不是命令，不能当 `drop_caches` 或内存泄漏的解药。`madvise(addr, len, advice)` 作用于 **mmap 的虚拟地址区间**而不是 fd，`MADV_SEQUENTIAL/RANDOM/WILLNEED/DONTNEED` 与 fadvise 对应，`MADV_HUGEPAGE`/`MADV_NOHUGEPAGE` 控制透明大页。`posix_fadvise` **返回错误码**、不设 `errno`，判返回值本身。
:::
:::

::: method 回忆 15 · `O_PATH`、`O_NOFOLLOW`、`O_DIRECTORY`、`O_TMPFILE`
`O_PATH` 的 fd 能做什么、不能做什么、权限要求有何不同？`O_NOFOLLOW` 报什么错、作用范围到哪？`O_TMPFILE` 有哪四条限制？临时文件三种做法怎么选？
::: sol 答案
`O_PATH` 只取「路径句柄」：不能读、不能写、不能 `mmap`，但能当 `*at()` 系列的 `dirfd`、能 `fstat`、能 `readlink("/proc/self/fd/N")` 取回路径、能 `fchdir`、能当 `execveat` 的 `dirfd`；权限上只要路径各级目录有 `x` 位，不需要目标文件可读。对它的 fd 调 `read` 返回 `-1`、`errno=EBADF`（本机实测 9）。`O_NOFOLLOW` 只检查**最后一段**：`open("/a/b/link", O_NOFOLLOW)` 在 `link` 是符号链接时报 `ELOOP`（本机实测 40），不是 `EINVAL` 也不是 `EMLINK`；中间目录里的符号链接仍会被跟随，要全禁得用 `openat2` 的 `RESOLVE_NO_SYMLINKS`。`O_DIRECTORY` 要求对象是目录，否则 `ENOTDIR`（20），常与 `O_PATH` 组合得到「只能当锚点」的目录 fd。`O_TMPFILE` 的路径参数必须是目录，内核建一个没有目录项的 inode；四条限制：文件系统要支持（ext4/XFS/tmpfs/btrfs 支持，部分网络文件系统不支持，否则 `EOPNOTSUPP`）、`linkat(fd,"",...,AT_EMPTY_PATH)` 不检查创建者（fd 一旦传给别人对方也能链接）、不能跨文件系统（目标目录要同属一个文件系统，否则 `EXDEV`）、打开时带 `O_EXCL` 就**永远不能** `linkat`；普通用户走 `AT_EMPTY_PATH` 要 `CAP_DAC_READ_SEARCH`，替代是 `linkat(AT_FDCWD, "/proc/self/fd/N", ..., AT_SYMLINK_FOLLOW)`。选型：要把路径交给别的程序用 `mkstemp`（有名、0600、要手动 `unlink`）；纯本进程临时流用 `tmpfile()`（`fclose` 自动删）；先写完整再原子发布用 `O_TMPFILE`。
:::
:::

::: method 回忆 16 · `O_SYNC`、`O_DSYNC`、`O_ASYNC` 与 flags 的六个坑
三个名字像的标志各做什么？代价怎么衡量？`F_GETFL` 与 `F_GETFD` 分别查什么？正文六个坑里最常被写错的是哪三个？
::: sol 答案
`O_DSYNC`：`write` 返回前把数据与「读回数据所必需的元数据」落盘；`O_SYNC`：连 mtime/ctime 等全部元数据都落，等价于每次写完 `fsync`，一次 4 KiB 写要等设备确认，机械盘上可能是毫秒级，批量导入用 `O_DSYNC` 或「写完统一 `fsync`」通常快一个数量级；`O_ASYNC` 与同步无关，是 fd 可读/可写时发 `SIGIO`，Linux 上在 `open` 时指定它没有实质效果，必须 `F_SETFL` 开启并配 `F_SETOWN`，`epoll` 时代基本不用。`F_GETFL` 查的是打开文件描述的状态标志（`O_APPEND`/`O_NONBLOCK` 以及用 `O_ACCMODE` 掩出的访问模式），`F_GETFD` 查的是 fd 标志（`FD_CLOEXEC`）。六个坑里最常写错：`O_TRUNC` 配 `O_RDONLY`（POSIX 未定义，别依赖，要截断就 `O_WRONLY`/`O_RDWR`）、`O_EXCL` 单独用（没 `O_CREAT` 时被忽略）、`O_DIRECT` 只看文件系统支持（还得对齐，栈数组不保证对齐）。另三个：`O_APPEND` 的 fd 上 `pwrite` 在 Linux 仍追加；`O_NONBLOCK` 对普通文件基本无效但会改变 FIFO/设备的打开与读写行为；`O_CLOEXEC` 只管 `exec` 不管 `fork`。
:::
:::

::: method 回忆 17 · `openat2` 的六个 resolve 位
写出六个 `RESOLVE_*` 与违规时的 `errno`。`BENEATH` 与 `IN_ROOT` 的差别？`size` 参数为什么是协议的一部分？它能替 `chroot` 吗？旧内核没有它怎么办？
::: sol 答案
`RESOLVE_BENEATH`（不允许 `..` 或绝对路径逃出 `dirfd`，`EXDEV`）、`RESOLVE_IN_ROOT`（把 `dirfd` 当 `/`，绝对路径与 `..` 都被限制在其中，不报错）、`RESOLVE_NO_MAGICLINKS`（禁 `/proc/self/fd/N` 这类魔法链接，`ELOOP`）、`RESOLVE_NO_SYMLINKS`（禁路径中任何符号链接，`ELOOP`）、`RESOLVE_NO_XDEV`（禁跨挂载点，`EXDEV`）、`RESOLVE_CACHED`（只查缓存不触发 I/O，否则 `EAGAIN`）。`BENEATH` 是「逃逸就报错」，适合「必须留在这个目录」的断言；`IN_ROOT` 是「夹住」，像 `chroot` 但不改进程状态，更宽容。调用形状是 `openat2(dirfd, path, struct open_how *how, size_t size)`，`size` 必须不大于当前内核认识的 `sizeof(struct open_how)`：传大了 `E2BIG`，传小了按旧版本解释——这就是「带 size 字段的结构体」让新字段能追加而不破坏旧程序的做法（glibc 2.37 起有包装，老的用 `syscall(SYS_openat2, ...)`）。它不能替 `chroot`：只约束这一次解析，真沙箱还要 mount namespace、`pivot_root`、seccomp、capability 收缩。旧内核返回 `ENOSYS`，回退是「逐段 `openat` + `O_NOFOLLOW|O_DIRECTORY`，自己拒绝 `..`」。反直觉的一条：`EXDEV` 在这里不描述原因只描述类别，排障先看 `resolve` 位再看路径。
:::
:::

::: method 回忆 18 · 新建文件的权限谁说了算
`umask` 是减法吗？它影响哪些接口、跨 `fork`/`exec` 怎么传递？`mode` 的高位（setuid/setgid/sticky）各管什么？默认 ACL 怎么插一脚？`open(path, O_CREAT|O_WRONLY, 0)` 建出什么？
::: sol 答案
`umask` 是**位屏蔽**不是减法：最终权限 = `mode & 07777 & ~umask`，默认常为 `022`，所以 `0666` 建出来是 `0644`，而 `0600` 不受 `022` 影响。它影响所有创建接口（`open`、`mkdir`、`mkfifo`、`mknod`、`socket` 绑定的文件、`sem_open`），`fork` 后继承、`exec` 后保留，且是进程级共享——工作线程里改它会影响其他线程。特殊位：setuid 04000、setgid 02000、sticky 01000；`open` 创建时带的 setuid/setgid 会在后续 `chown` 时被清掉；目录的 setgid 让其中新建的文件继承目录的属组、子目录继续带 setgid；sticky 只对目录有意义，只有文件属主、目录属主或 root 能删除其中的项（`/tmp` 的 `1777`）。默认 ACL（`setfacl -d`）会当模板：内核以它为基础，把 `mode` **没请求**的位从 ACL 的 mask 里清掉，`umask` 仍生效但作用在 mask 上，命名用户条目可能保留、有效权限受 mask 限制，文件不会因为 ACL 拿到执行位——所以同一个 `open(..., 0666)` 在不同目录里建出不同权限。`mode=0` 是「显式请求 0000」而不是「用默认权限」，普通用户之后连自己都打不开（root 可以），只能 `chmod` 补救。`chmod` 设的是精确权限，不受 `umask` 影响。
:::
:::

## C. 返回矩阵、偏移、生命周期与取证

::: method 回忆 19 · 错误码矩阵与短读的七个来源
给 `read` 与 `write` 各列至少八个错误码，标「重试 / 退避 / 放弃」。短读的七个来源是什么？`EPIPE` 之前先发生什么？
::: sol 答案
`read`：`EBADF`（未打开或不是读模式，含 `O_PATH`）、`EFAULT`（缓冲不可访问）、`EINVAL`（fd 不适合读、`O_DIRECT` 未对齐）、`EISDIR`（对目录 read）、`EAGAIN`/`EWOULDBLOCK`（重试，等可读）、`EINTR`（重试）、`EIO`（设备/文件系统错误，放弃并告警）、`ENOMEM`（可退避重试）、`ETIMEDOUT`（网络文件系统超时，视语义）。`write`：`EBADF`、`EFAULT`、`EINVAL`、`EFBIG`（超 `RLIMIT_FSIZE` 或文件系统上限）、`ENOSPC`、`EDQUOT`（配额）、`EPIPE`、`EAGAIN`（等可写）、`EINTR`（重试）、`EIO`、`EPERM`（append-only/immutable）、`EROFS`（只读挂载）。短读七个来源：① 到 EOF 剩不足；② 管道里只有这些；③ 终端行模式一次给一行；④ 信号在部分传输后到达（Linux 返回已读字节数而不是 `EINTR`）；⑤ `O_DIRECT` 尾块不足一个对齐单位；⑥ `/proc`、`/sys` 的许多文件一次只产一页左右且 `st_size` 为 0；⑦ 驱动按自己的块大小返回。`EPIPE` 默认**先**送 `SIGPIPE` 直接终止进程，所以服务端要么 `signal(SIGPIPE, SIG_IGN)` 要么对 socket 用 `MSG_NOSIGNAL`，才能看到 `write` 返回 `EPIPE`。
:::
:::

::: method 回忆 20 · `lseek` 与稀疏文件
`lseek` 的五种 `errno`？`lseek(fd, 1MiB, SEEK_SET)` 后文件大小与实占各是多少？`SEEK_DATA`/`SEEK_HOLE` 各返回什么、什么时候 `ENXIO`？逻辑大小与实占用哪两个读数区分？
::: sol 答案
`EBADF`（未打开或不可寻址）、`ESPIPE`（管道、FIFO、socket、终端）、`EINVAL`（`whence` 非法或结果偏移为负）、`EOVERFLOW`（超出 `off_t`）、`ENXIO`（`SEEK_DATA`/`SEEK_HOLE` 起点超出文件末尾）。`lseek` 只改内存里的 `f_pos`，不触发任何 I/O，也不分配空间：`lseek` 到 1 MiB 后 `write` 1 字节，逻辑大小变 1 MiB+1，中间 1 MiB 是空洞、不占数据块，读这些位置返回 0。`SEEK_DATA` 返回 `off` 之后第一个含数据的偏移（`off` 本身在数据区就返回 `off`），`off >= 文件大小` 时 `ENXIO`；`SEEK_HOLE` 返回 `off` 之后第一个空洞的偏移，后面全是数据就返回文件末尾。文件系统可以保守地把所有区域都报成数据（`SEEK_HOLE` 只返回 EOF），程序仍正确，只是没省 I/O——所以只当优化不当正确性依赖。逻辑大小看 `st_size`，实占看 `st_blocks * 512`；命令行对照是 `du`（实占）与 `du --apparent-size`（逻辑）、`stat -c '%s %b'`。`O_APPEND` 的 fd 上 `lseek` 设的位置会被忽略（本地文件系统上 `write` 总是原子地定位到末尾）。
:::
:::

::: method 回忆 21 · `pread`/`pwrite`、向量 I/O 与 `RWF_*`
多线程共享 fd 为什么用 `pread`？Linux 的 `pwrite` 在哪一点上违背 POSIX、man 手册怎么标的？`readv`/`writev` 的段数上限从哪查、超了怎样、短写后为什么不能重试整个数组？`preadv2` 的五个 `RWF_*` 与 `RWF_NOWAIT` 的适用场景？
::: sol 答案
`pread`/`pwrite` 从给定偏移读写且**不改 `f_pos`**，所以两个线程用同一个 fd 不会互相踩偏移；管道/FIFO/socket 上 `pread` 返回 `ESPIPE`。Linux 的实现不遵守 POSIX：fd 带 `O_APPEND` 时 `pwrite` 仍追加到末尾、`offset` 被忽略，`man 2 pwrite` 的 BUGS 段有记录且长期未修；可移植写法是别在同一 fd 上混用，或先 `fcntl` 清掉 `O_APPEND`。`readv`/`writev` 把多段内存拼成一次 I/O，返回**总字节数**（可能小于各段长度之和）；上限查 `sysconf(_SC_IOV_MAX)`（本机 1024），glibc 只是薄包装、不会替你拆分数组，超过直接 `EINVAL`，要更多段就分批；总长度不能超过 `SSIZE_MAX`；`iovcnt == 0` 返回 0；整组不是原子的，管道上单次 `writev` 不超过 `PIPE_BUF` 才保证不交错。短写后重试整个数组会把已写出的部分重复写一遍，必须推进 `iovec`：跳过写满的段、把当前段按剩余量切短。`preadv2`/`pwritev2` 的 flags：`RWF_HIPRI` 高优先级（配 `O_DIRECT`）、`RWF_DSYNC`/`RWF_SYNC` 只让本次写同步、`RWF_NOWAIT` 不等待（缓存未命中直接 `EAGAIN`）、`RWF_APPEND` 本次写追加（4.16+）。`RWF_NOWAIT` 适合「有活就干、没活就切走」的线程池，比给普通文件加 `O_NONBLOCK` 更可控；`RWF_DSYNC` 不被支持时可能 `EINVAL`，生产代码要能降级到 `pwritev` + `fdatasync`。
:::
:::

::: method 回忆 22 · `dup3`、`close_range` 与 fd 计数
`close_range` 的三个 flag 各做什么？为什么它比遍历 `/proc/self/fd` 可靠？`count_fds()` 为什么要减 1、为什么比「自己打开的 fd 数」大 3？关闭后的 fd 号能继续用吗？
::: sol 答案
`close_range(first, last, flags)`（Linux 5.9，glibc 2.34 起有包装；老的用 `syscall(SYS_close_range, ...)`）一次关掉 `[first, last]` 区间内所有 fd，在内核里完成，不会因为信号或并发 `open` 漏掉；flag：`0` 直接关、`CLOSE_RANGE_UNSHARE` 先 unshare fd 表避免影响共享该表的线程、`CLOSE_RANGE_CLOEXEC` 只设 `FD_CLOEXEC` 不关。`first > last` 返回 `EINVAL`，内核不支持返回 `ENOSYS`。标准写法是 `close_range(3, ~0U, 0)`——比遍历 `/proc/self/fd` 可靠，因为读目录本身要占一个 fd、并发开关会让清单随时变。`count_fds()` 用 `opendir("/proc/self/fd")` 数条目，目录里包含 `opendir` 自己那个 fd，所以减 1；结果还包含 `stdin/stdout/stderr` 三个，比自己开的 fd 数大 3。`close_range` 之后 fd 号立刻可被复用，如果还有代码持有旧数字，它会指向新打开的对象——这正是「关闭 fd 后不要再用旧数字」的原因，也是「不要重试 `close`」的原因。
:::
:::

::: method 回忆 23 · 三个原子性的边界
`O_APPEND` 保证到哪一步、不保证什么？`O_EXCL` 的四个例外？`rename` 的七种场景结果？怎么用最便宜的办法验证 `O_APPEND` 有没有覆盖？
::: sol 答案
`O_APPEND`：本地文件系统上「取末尾偏移 + 写入」在 inode 锁内完成，多个进程各自 `open(O_APPEND)` 并**单次 `write`** 不会互相覆盖；不保证——多次 `write` 组成的记录不交错、`writev` 的多段不被当成一个不可分割条目、NFS 上跨客户端仍原子、`pwrite` 尊重你给的偏移（Linux 上仍追加）。要强「一条记录不交错」，记录必须一次 `write` 且不超过文件系统上限（普通文件没有 `PIPE_BUF` 那样的常量，实践上单次几 KiB 安全但不是规范保证），更强用文件锁。`O_EXCL` 四个例外：NFSv2 不支持原子独占创建（两个客户端可能都成功）、路径最后一段是符号链接时报 `EEXIST`（即使链接悬空，这是安全特性）、不带 `O_CREAT` 时被忽略、`O_TMPFILE|O_EXCL` 建的文件永远不能 `linkat`。锁文件还要处理 stale lock：正确做法不是「看到文件就退出」，而是创建失败后对已有文件加锁并判断持有者是否活着，或直接用随进程释放的 `flock`/`fcntl` 锁。`rename` 场景表：跨文件系统 `EXDEV`、目标是「非空目录」而源是目录 `ENOTEMPTY`、目录 → 文件 `ENOTDIR`、文件 → 目录 `EISDIR`、目标存在且只读**允许**（权限看目录不看文件）、目标是挂载点 `EBUSY`、目标在另一个挂载命名空间可能成功但不可见。验证：让 N 个进程各写一条固定长度、内容可识别的记录，检查文件长度是否等于 `N × 记录长度`、每条记录是否完整；再用 `lseek(END)` + `write` 做对照组，同样压力下会出现覆盖或长度偏短。
:::
:::

::: method 回忆 24 · `write` 的内核路径与 `fsync` 家族
从 libc 到磁盘，一次 `write` 经过哪几层？`generic_perform_write` 的循环解释哪三个现象？`fsync`/`fdatasync`/`sync`/`syncfs` 各刷什么？对 WAL 和对「改名发布」分别要哪个？
::: sol 答案
九层：libc 的 `write`（`sysdeps/unix/sysv/linux/write.c`）→ 系统调用入口（`ksys_write` → `vfs_write`）→ 检查（`FMODE_WRITE`、`rw_verify_area`、`MAX_RW_COUNT`）→ 迭代器（`import_iovec`/`iov_iter_ubuf` 把用户缓冲包成 `iov_iter`）→ 文件系统接口（`file->f_op->write_iter`）→ ext4（`ext4_file_write_iter` → `generic_file_write_iter`）→ 页缓存（`generic_perform_write` → `copy_page_from_iter_atomic`）→ 脏页（`mm/page-writeback.c` 的 `balance_dirty_pages`、`wakeup_flusher_threads`）→ 回写（`ext4_writepages` → `ext4_bio_write_page` → 块层）。三个现象：① `copy_page_from_iter_atomic` 只把数据拷进内核页、`write_end` 把页标脏，所以返回时数据在内存不在磁盘；② 脏页超过 `vm.dirty_ratio` 时 `balance_dirty_pages` 主动把写者拖慢，而不是无限吃内存；③ `O_SYNC`/`O_DSYNC` 是在 `write_iter` 返回前调 `generic_write_sync` → `vfs_fsync_range` → `f_op->fsync` → `ext4_sync_file`，这才是等设备确认的地方。`fsync(fd)` 做两件事：回写该文件所有脏页 + 让文件系统提交元数据；`fdatasync(fd)` 只保证数据与「读回数据必需的元数据」，不保证 mtime 之类；`sync()` 刷所有文件系统（全局，代价最大），`syncfs(fd)` 只刷该 fd 所在的那个文件系统。数据库 WAL 用 `fdatasync` 通常够；「写完再改名发布」必须有目录的 `fsync`，否则崩溃后可能看不到新名字。
:::
:::

::: method 回忆 25 · 两个取证实验：`strace` 与 `/proc/self/fdinfo`
`strace -yy` 的 `-yy` 解决什么问题？读一次 `./copy` 的输出要看到哪几行才算程序做对了？`-e inject` 能注入什么、拿来干什么？`/proc/self/fdinfo/N` 的四行各是什么、哪两行不能当常数引用？
::: sol 答案
`-yy` 把每个 fd 打印成它当前指向的路径（`read(3</etc/hosts>, ...)`）。没有它只能看到 `read(3, ...)`，而 fd 会被复用——同一个数字前后可能指向两个不同文件，据此判断「读了什么」必错。看 `copy` 做对没做对，要在序列里找齐五件事：源以 `O_RDONLY|O_CLOEXEC` 打开、目标以 `O_WRONLY|O_CREAT|O_EXCL|O_CLOEXEC` 打开并带 `0644` 这个 `mode`、一组 `read`/`write` 且**最后一次 `read` 返回 0**（那是 EOF 不是错误）、`fsync(数据 fd)` → `close` → `rename` → 再以 `O_RDONLY|O_DIRECTORY` 打开目录并 `fsync` 它。缺目录那次 `fsync` 就不算完整发布。`-e inject=openat:error=EACCES:when=1` 能在第 1 次 `openat` 上伪造错误（还支持 `retval=`、`signal=`），用来不改代码就踩进错误分支，验证临时文件有没有被清理（`ls /tmp/x.tmp.*`）。`fdinfo` 四行：`pos` 是当前偏移（同一 `struct file` 的多个 fd 会同时变），`flags` 是**八进制的打开标志**（本机 `exec 3<>file` 得到 `0400002`，其中 0400000 是 aarch64 的 `O_LARGEFILE`、低位 2 是 `O_RDWR`；x86-64 常见 `0100002`），`mnt_id` 能和 `/proc/self/mountinfo` 第一列对上（本机 `mnt_id: 35` = 根挂载 `/dev/sda2 ext4`），`ino` 是 inode 号。后两行每台机器、每次挂载都不同，不能当常数引用也不能跨机器比较。
:::
:::
