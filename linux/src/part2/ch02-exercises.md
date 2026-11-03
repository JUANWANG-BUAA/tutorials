# 2.2 习题集

三组分层：**A 组概念判断**考「会读返回值、会说理由、把三层对象的关系讲清」；**B 组诊断推理**给现象让你判层、判契约、判修法；**C 组动手实验**在本书的 Ubuntu 24.04.5 aarch64 虚拟机上免 `sudo` 复现本章的关键读数。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段，C 组要求先把预期读数写在纸上再敲命令。
2. 卡住了回对应小节的「即时自测」或 `errata` 盒重读，不要直接看答案：A 组对应 2.2.1–2.2.8、2.2.15–2.2.17，B 组对应 2.2.2–2.2.14，C 组对应 2.2.4.1、2.2.7–2.2.18。
3. C 组的源码一律用正文里那八个程序（`openflags.c`、`ioctl_demo.c`、`shortio.c`、`sparse_scan.c`、`rwv.c`、`fdlife.c`、`safeopen.c`、`copy.c`），**抄，不要手敲**——手敲改一个字符就会得到不同读数。工作目录建在 `~/lab2c02`，临时文件统一带 `lab2c02_` 前缀，做完删掉。
4. **`sudo` 不可用**（`sudo -n true` 报「需要密码」），**`perf` 的计数器不可用**：`/usr/bin/perf` 这个文件在，但 `perf stat true` 每行都是 `<not supported>`，所以本章一律不用 perf 取读数，替代是 `strace -c`/`-T`、`/proc/self/io`、`/proc/meminfo` 与计时。可用：`cc`（GCC 13.3.0）、`strace` 6.8、`lsof`、`iostat`、`getconf`、`stat`、`du`、`truncate`、`findmnt`、`filefrag`、`python3`、`/proc`、`/sys`、bash 的 `exec 3<>file`。`docker` 免 sudo 可用（本机实测 `docker run --rm busybox uname -m` 打印 `aarch64`），只在需要干净 rootfs 时用。
5. **正文有两张表整列是 x86-64 的八进制值**（2.2.9 的 `open` flags 列、2.2.18 的 `fdinfo flags`），本书的机器是 aarch64：`O_DIRECT`、`O_DIRECTORY`、`O_NOFOLLOW`、`O_LARGEFILE`、`O_TMPFILE` 的数不同，`flags: 0100002` 在本机是 `0400002`。另有三处正文读数在本机复跑时对不上（见 [C4](ch02-exercises.md#ex-2.2-C4)、[C6](ch02-exercises.md#ex-2.2-C6)、[勘误页](ch02-errata.md)）。**「和正文不一样」不是你做错了**，写出差异并解释，不要改数字去迁就正文。
6. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch02-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.2-A1 · 三层对象决定谁看见同一个偏移 {#ex-2.2-A1}

先猜：同一个进程里对 `/etc/hosts` 调两次 `open` 得到 fd 3 和 fd 4，读 fd 3 前进 100 字节后读 fd 4，会从 100 开始吗？`fd 4 = dup(3)` 之后读 4 呢？

用「fd 表 / 打开文件描述 / inode」三层解释这两种情况各为什么如此；说出偏移、状态 flags、文件内容分别住在哪一层；再解释为什么多进程往同一个日志文件写会交错，以及 `fork` 后父子轮流读同一个 fd 为什么要额外同步。

::: sol 解答

不会。每次 `open` 都新建一个打开文件描述（内核里的 `struct file`），偏移 `f_pos` 存在这一层，所以 fd 3 与 fd 4 各有自己的偏移，读 fd 4 仍从 0 开始；两个 `struct file` 指向同一个 inode，所以看到的**内容**一致。`dup(3)` 只往 fd 表里多写一个表项、指向**同一个** `struct file`，于是偏移共享：读 4 前进 100，再读 3 就从 100 开始。分工：偏移与状态 flags（`O_APPEND`、`O_NONBLOCK`）在 `struct file`；文件的类型、权限、大小、时间、数据块位置在 inode；fd 本身只是进程表的下标，只在所属进程内有意义。`fork` 复制的是 fd 表，表项仍指向同一个 `struct file`——所以父子共享偏移，谁读都推进同一个位置，轮流读同一个 fd 会各自拿到一段而不会重复；反过来，父子各自 `open` 同一个文件就是不共享偏移，谁从头开始取决于各自的 `f_pos`。多进程写同一份日志的交错根源也在这：不同进程各自 `open` → 不同 `struct file` → 各自的定位与写入之间没有协调，除非用 `O_APPEND`（把「定位到末尾 + 写」合成一步）或文件锁。读表时先问「这个操作改的是哪一层」，`close(fd)` 只删表项，不动 `struct file`（还有其他 fd 指向它时它继续活着），更不动 inode。

**判据**：两次 `open` 偏移独立、`dup`/`fork` 偏移共享两条都说对且归到正确的层；说出偏移/flags/内容各属哪层；能解释日志交错的根源并给出 `O_APPEND` 或锁作为对策；说出 `close` 只影响表项。

:::
:::

::: ex 例 2.2-A2 · `open` 的参数契约与两个原子性 {#ex-2.2-A2}

先猜：`open(path, O_CREAT | O_WRONLY)` 少写第三个参数，会编译失败、创建出 0644、还是创建出随机权限的文件？两个进程同时 `open(path, O_CREAT|O_EXCL)`，会都成功吗？

写出 flags 的三组分工与访问模式的位掩码读法；给出 `mode` 参与计算的条件和最终权限公式；说清 `O_CREAT|O_EXCL` 与 `O_APPEND` 各把哪两步原子化、各不保证什么，以及为什么 `access()+open()`、`lseek(END)+write()` 是错的。

::: sol 解答

第三种：`mode` 是可变参数，只在带 `O_CREAT` 或 `O_TMPFILE` 时才有意义；带了 `O_CREAT` 却不传，编译器不会报错，内核会读到栈上的残留值当权限，于是创建出权限诡异的文件（正文 2.2.19 第一条坑就是这个）。flags 三组：访问模式占低两位且必须有且只有一个（`O_RDONLY`=0、`O_WRONLY`=1、`O_RDWR`=2，读回时用 `O_ACCMODE` 掩码），创建/截断组（`O_CREAT`、`O_EXCL`、`O_TRUNC`、`O_NOCTTY`），行为修饰组（`O_APPEND`、`O_NONBLOCK`、`O_SYNC`/`O_DSYNC`、`O_DIRECT`、`O_CLOEXEC`、`O_TMPFILE`）。最终权限 = `mode & 07777 & ~umask`，`umask` 只清位不加位。两个进程同时 `O_CREAT|O_EXCL`：只有一个成功，另一个 `EEXIST`，因为「检查不存在 + 创建」是一条原子操作——这正是锁文件的正确写法。`O_APPEND` 把「取当前末尾 + 写入」合成一步（本地文件系统上在 inode 锁内完成），所以多进程追加不会互相覆盖；但它不保证一条记录不交错（一次逻辑记录若由多次 `write` 或 stdio 多次 flush 完成仍会穿插），也不保证 `pwrite` 尊重你给的偏移。两步写法错在有竞争窗口：`access()` 说「不存在」与你的 `open()` 之间别人能创建，两个进程都以为拿到锁；`lseek(END)` 与 `write` 之间别人能追加，你的写会盖掉对方的数据。附带两条：`O_EXCL` 不带 `O_CREAT` 被忽略；`O_TRUNC` 配 `O_RDONLY` 是未定义行为，要截断就显式用 `O_WRONLY`/`O_RDWR`。

**判据**：漏 `mode` 判成「编译通过但权限是垃圾值」；三组分工与 `mode & ~umask` 公式对；两个原子性各说清「合成的是哪两步」与「不保证什么」；两步写法的失败窗口讲得出；知道 `O_EXCL` 单独用被忽略。

:::
:::

::: ex 例 2.2-A3 · 返回值是「搬了几字节」不是开关 {#ex-2.2-A3}

先猜：`write(fd, buf, 1u<<20)` 在管道上返回 65536，程序该报错、该重试整个 1 MiB、还是该继续？`read(fd, buf, 4096)` 返回 100，是错吗？

列出 `read`/`write` 的五种返回形态与各自处理；解释两个 `_full` 循环里 `p + done`、`count - done` 的作用；说明读侧 `n == 0` 与写侧 `n == 0` 为什么处理不同；给出「短读不是异常」的至少四个真实来源。

::: sol 解答

该继续：`write` 返回的是这次实际写入的字节数，短写在管道/socket/终端上是常态而不是异常。重试整个 1 MiB 会把已经写出去的 65536 字节重复写一遍——这是最常见的数据错乱来源；正确做法是 `p + done`、`count - done` 继续写剩下的部分，直到累计等于请求长度，「写完」的定义是**累计字节数**等于请求长度，不是「返回过一次非负」。`read` 返回 100 同理不是错，只有返回 `-1` 才是错。五种形态：`== count` 完成；`0 < n < count` 短，推进指针继续；`0` 对读是 EOF（普通文件到末尾、管道/socket 写端全关），对写通常意味着 `count == 0`；`-1 + EINTR` 重试剩余部分；`-1 + 其他` 按错误码决定。读侧 `n == 0` 要 `break`（继续读还是 0，循环空转）；写侧 `n == 0` 且 `count > 0` 不能继续循环（可能永不推进），正文的处理是设 `errno = EIO` 返回失败。短读的真实来源：① 接近 EOF；② 管道/socket 缓冲里只有这些；③ 终端行模式一次给一行；④ 信号在部分传输后到达（Linux 返回已读字节数而不是 `EINTR`）；⑤ `O_DIRECT` 尾块不足一个对齐单位；⑥ `/proc`、`/sys` 的许多文件一次只产一页左右且 `st_size` 是 0；⑦ 驱动按自己的块大小返回。顺带一条边界：`count == 0` 时 `read`/`write` 返回 0 且**可能不检查 fd 是否有效**，所以不能拿 `read(fd, buf, 0)` 探测 fd。

**判据**：三选项里选「继续」并解释重复写前缀的后果；五种形态齐全；读侧 0 与写侧 0 的处理差别说清；短读来源至少四条；知道 `count == 0` 的 0 不是 EOF。

:::
:::

::: ex 例 2.2-A4 · `EINTR`、`EAGAIN` 与 `SA_RESTART` 的分工 {#ex-2.2-A4}

先猜：给信号处理器设了 `SA_RESTART`，`epoll_wait` 被信号打断后会自动重来吗？`errno == EAGAIN` 时立刻原地 `while` 重试，和 `EINTR` 时立刻重试，哪个是错的？

说明 `EINTR` 与 `EAGAIN` 分别是「事件」还是「状态」，各自正确的重试方式；列出 `SA_RESTART` 盖不住的调用；解释为什么库函数不该依赖调用者设置 `SA_RESTART`；说出 `EAGAIN` 与 `EWOULDBLOCK` 的关系。

::: sol 解答

不会自动重来：`SA_RESTART` 只让「可重启」的那批慢调用（`read`/`write`/`open`/`wait`/`accept` 一类）在被打断后自己继续，`poll`、`epoll_wait`、`select`、`msgrcv` 明确不在其列，它们就是要把「被打断」告诉你好去重算超时。分工：`EINTR` 是**事件**——这次调用被信号打断了，重试同一段即可，进度不用丢；`EAGAIN`/`EWOULDBLOCK`（Linux 上同值）是**状态**——`O_NONBLOCK` 的 fd 现在没数据可读或缓冲已满，正确做法是保存进度、把 fd 交给 `epoll`/`poll` 等就绪通知，原地忙等既烧 CPU 又可能在对方永远不写时变成活锁。库函数不能依赖 `SA_RESTART`，因为信号处置方式是进程级、由主程序决定的，库不能假设主程序替你把 `read` 自动重启；写库的纪律是始终自己处理 `EINTR`。判据形状统一是：`if (n == -1) { if (errno == EINTR) continue; if (errno == EAGAIN || errno == EWOULDBLOCK) /* 等就绪 */; else /* 真错误 */ }`，且在进 `read`/`write` 之前把 `errno` 清 0，因为成功时不保证清零（见 [2.1.3](ch01.md#sec-2.1.3)）。另外 `open`、`close`、`read`、`write` 都可能返回 `EINTR`，「只有阻塞调用会被打断」是误解。

**判据**：答出 `epoll_wait` 不自动重启；`EINTR`=事件、`EAGAIN`=状态各配正确的重试方式（一个立即重来、一个等就绪不忙等）；至少说出三个 `SA_RESTART` 盖不住的调用；解释库不能依赖调用者的信号设置；知道 `EAGAIN` 与 `EWOULDBLOCK` 同值。

:::
:::

::: ex 例 2.2-A5 · `O_CLOEXEC` 与一个 fd 的一生 {#ex-2.2-A5}

先猜：`open(path, O_RDONLY)` 之后紧接着 `fcntl(fd, F_SETFD, FD_CLOEXEC)`，单线程程序里有没有风险？`dup2(fd, fd)` 与 `dup3(fd, fd, O_CLOEXEC)` 结果一样吗？`close_range(3, ~0U, 0)` 在 5.9 之前的内核上会怎样？

说清 `FD_CLOEXEC` 管的是 `fork` 还是 `exec`；列出四个能原子设置它的入口；解释两步法在多线程下的窗口；说明 `dup3` 与 `dup2` 的两点差别；给出 `close_range` 的三个 flag 和它在老内核上的回退。

::: sol 解答

有风险，但不是「单线程自己抢自己」那种：窗口在**另一个线程**——你的进程里只要有第二个线程在 `open` 与 `fcntl` 之间执行了 `fork`+`exec`（`fork` 复制整张 fd 表），那个 fd 就带着「没有 CLOEXEC」的状态漏进了子程序。所以规则是「在创建时就把标志带上」，四个原子入口：`open`/`openat` 的 `O_CLOEXEC`、`socket`/`accept4`/`pipe2` 的 `O_CLOEXEC`、`fcntl(fd, F_DUPFD_CLOEXEC, 0)`、`dup3(old, new, O_CLOEXEC)`；`close_range` 的 `CLOSE_RANGE_CLOEXEC` 是「批量标记不关闭」。`FD_CLOEXEC` 管的是 `exec`：`fork` 后子进程照样继承所有 fd，要 `fork` 后就关得在子进程里显式 `close` 或用 `close_range`。`dup2(fd, fd)` 直接返回 `fd` 什么都不做；`dup3(fd, fd, O_CLOEXEC)` 返回 `-1`、`errno = EINVAL`——这就是「用 `dup2` 保证某 fd 已打开」这类代码换成 `dup3` 会坏的原因（`dup3` 的 `flags` 也只接受 `O_CLOEXEC`，别的值 `EINVAL`）。`close_range` 是 Linux 5.9 引入、glibc 2.34 起有包装，老内核返回 `ENOSYS`，回退是 `for (fd = first; fd <= last; fd++) close(fd);`；它比遍历 `/proc/self/fd` 可靠，因为读目录本身要占一个 fd、并发开关时清单随时变。最后一条纪律：`close()` 失败时 Linux 已经释放了 fd，**不要重试**——重试可能关掉别的线程刚打开的同号 fd；要确保数据落盘用 `fsync` 而不是盯着 `close` 的返回值。

**判据**：指出窗口来自多线程 `fork+exec` 而不是单线程自己；四个原子入口给全；`O_CLOEXEC` 管 `exec` 不管 `fork` 说清；`dup2(fd,fd)` 与 `dup3(fd,fd,...)` 的行为差别正确；`close_range` 的 `ENOSYS` 回退与「不重试 `close`」都提到。

:::
:::

::: ex 例 2.2-A6 · 写成功了，数据在哪一层 {#ex-2.2-A6}

先猜：`write` 返回之后立刻 `kill -9` 这个进程，数据会丢吗？机器断电呢？`rename` 成功之后断电，文件会不会「不存在」？

说明 `write()` 返回时数据的位置与接下来经过的层（脏页、`balance_dirty_pages`、回写）；给出「写完并确保崩溃后可见」的四步顺序并解释每一步；区分 `fsync`/`fdatasync`/`syncfs`/`sync`；说出 `O_SYNC`/`O_DSYNC` 在哪一层等设备确认，以及批量写为什么远快于每条一次。

::: sol 解答

`kill -9` 不丢：`write` 返回只表示数据被 `copy_page_from_iter_atomic` 拷进了内核的页缓存，`write_end` 把页标脏，之后由内核的回写线程刷盘——进程死了，页还在内核里，回写照做。机器断电会丢：还没回写的脏页在内存里，除非已经 `fsync`/`O_SYNC`（日志型文件系统只保证元数据一致，不保证你的数据没丢）。`rename` 之后断电可能「看不到新名字」：`rename` 只保证目录项替换是原子的（目标要么旧内容要么新内容，不会短暂消失），它本身是一次对目录这个文件的修改，也需要回写。所以四步顺序是：写临时文件 → `fsync(fd)`（数据落盘）→ `close` + `rename(tmp, dst)`（原子替换）→ `fsync(dirfd)`（目录项落盘）；`copy.c` 就是这个形状，而且打开目录要带 `O_DIRECTORY`。四个接口按范围分：`fsync(fd)` 回写该文件脏页并让文件系统提交元数据；`fdatasync(fd)` 只保证数据与「读回数据必需的元数据」，不保证 mtime 之类，数据库 WAL 通常用它就够；`syncfs(fd)` 刷该 fd 所在的整个文件系统；`sync()` 刷所有文件系统，代价最大、影响别人。`O_SYNC`/`O_DSYNC` 是在 `file->f_op->write_iter` 返回前调 `generic_write_sync` → `vfs_fsync_range` → `ext4_sync_file` 才等设备确认，等于每次写都 `fsync`，所以「每条记录一次同步」比「批量写 + 一次 `fsync`」慢一个数量级是必然的；脏页超过 `vm.dirty_ratio` 时 `balance_dirty_pages` 还会主动把写者拖慢，这是限速而不是卡死。

**判据**：`kill -9` 不丢 / 断电丢 两条都给对并归到页缓存这一层；四步顺序不乱且解释最后一步为什么不能省；四个同步接口的范围分清；说出 `generic_write_sync` 的位置；批量 vs 逐条的差异给出理由而不是结论。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.2-B1 · 每次只读到 100 字节，程序提前收尾 {#ex-2.2-B1}

先猜：`read(fd, buf, 4096)` 返回 100，是文件坏了吗？如果这个 fd 是一个管道或 `/proc` 下的文件，结论会变吗？

现象：一段读文件的代码写的是 `if (read(fd, buf, 4096) != 4096) break;`，从管道读时只拿到 100 字节就停了，但发送方明明发了 400 字节。写出「现象 → 机制 → 证据 → 修法」四段，并说明为什么「按 `st_size` 决定读几次」在 `/proc` 上必错。

::: sol 解答

现象：请求 4096、返回 100，代码判定「结束」，剩下 300 字节被丢弃；同一段代码在普通文件上往往看起来没问题。机制：`read` 的返回值是这次实际搬运的字节数，短读是正常状态而不是错误信号。管道里此刻只有 100 字节，`read` 就把这 100 给你（阻塞的 `read` 只保证「至少读到 1 字节或到 EOF」，不保证读满）；普通文件上通常一次给满，除非接近 EOF 或被信号打断，所以这个 bug 在文件上被掩盖、在管道/socket/终端上必现。用 `!= count` 判结束，等于把短读同时当成 EOF 和错误。证据：把返回值原样打印就能看出 `n=100`、`errno=0`——不是错误；`strace -yy -e trace=read` 能看到多次 `read(...) = 100`、`= 150` 这样的序列与 fd 指向；对同一个管道分两次发数据可复现「读满失败、循环成功」。修法：改成累积循环（`read_full` 的形状）——`while (done < count)`，`-1 + EINTR` 重试，`n == 0` 才是 EOF，其余 `done += n` 并推进缓冲区；如果只需要「读到多少算多少」，那也要把「返回值大于 0」当成功处理。另一条相关判据：`/proc`、`/sys` 下很多文件的 `st_size` 是 0（或是一次生成一页左右的内容），文件「大小」与「可读字节数」根本不是一回事，所以不能按 `st_size` 决定循环次数，也不能 `lseek(fd, 0, SEEK_END)` 的返回值当大小；要大小用 `fstat`，要读完就循环到 `n == 0`。

**判据**：定位到「把短读当 EOF/错误」而不是文件坏；说出阻塞 `read` 的最低承诺；证据里有返回值与 `errno` 或 `strace` 读数；修法给成累积循环并含 `EINTR`；能独立说出「`/proc` 不能按 `st_size` 读」这条。

:::
:::

::: ex 例 2.2-B2 · 多进程写同一份日志，行与行穿插 {#ex-2.2-B2}

先猜：所有进程都用 `open(path, O_WRONLY|O_APPEND|O_CREAT, 0644)` 打开，内容还是穿插了——是 `O_APPEND` 失效了吗？如果它们改用 `fprintf` 呢？

现象：四个进程各写一条 200 字节的记录，文件长度对（没有覆盖），但一条记录的中间夹进了另一条的一部分。写出四段分析：`O_APPEND` 保证了什么、没保证什么；`fprintf` + 行缓冲为什么会加剧；什么条件下才真的不交错；更强的做法是什么。

::: sol 解答

现象：长度等于四条记录之和（说明没有互相覆盖，`O_APPEND` 的定位是原子的），但记录内部被切开——这正是「原子性保证定位，不保证整条记录」的教科书案例。机制：`O_APPEND` 把「取当前末尾 + 写入」合成一次操作，在 inode 锁内完成，所以两个进程的写不会盖掉对方；但一次**逻辑记录**如果由多次 `write` 系统调用发出（`writev` 的多段、stdio 的多次 flush、或者你分两次 `write` 拼一行），那么第 1 次与第 2 次之间另一个进程的 `write` 可以整段插进来。`fprintf` 更糟：libc 有自己的缓冲区，换行是否 flush、一次 flush 写多少由缓冲策略决定，同一行可能被拆成两次 `write`；多线程里如果各线程共用一个 `FILE *`，还会再叠一层交织。证据：把每条记录改成一次 `write(fd, rec, 200)` 再跑同样的压力，穿插消失；`strace -f -e trace=write` 能看到一个进程的两次 `write` 之间夹着别的进程的 `write`；`lsof` 或 `/proc/PID/fd` 确认它们是否共享同一个打开文件描述（不共享，所以没有任何协调）。修法（按强度排）：① 一条记录一次 `write`，且长度不超过实践上安全的几 KiB——注意普通文件没有 `PIPE_BUF` 那样的规范保证，别把它当契约；② 单进程内自己拼好缓冲区再写，别用行缓冲 `fprintf` 拼记录；③ 要真正的「整条记录不可分割」就上文件锁（`fcntl`/`flock`，见 [2.3](ch03.md)）；④ 或者换一条路：每进程写自己的文件，由采集端合并。顺带一条误判：`lseek(fd, 0, SEEK_END)` + `write` 不等价于 `O_APPEND`，前者两条调用之间有竞争窗口，会真的覆盖别人的数据。

**判据**：先肯定「没覆盖」来自 `O_APPEND` 的原子定位，再把问题定位到「记录由多次调用组成」；说出 `fprintf`/stdio 缓冲为什么会拆；至少给两条真解（一次写完、加锁）；不把 `PIPE_BUF` 当成普通文件的保证；能区分 `O_APPEND` 与 `lseek+write`。

:::
:::

::: ex 例 2.2-B3 · 磁盘没满，空间却不回来 {#ex-2.2-B3}

先猜：`rm` 删掉一个 20 GiB 的日志后 `df` 一点没降，是 `rm` 失败了吗？还是文件系统坏了？

现象：日志轮转脚本 `rm` 掉旧文件，`df` 显示仍然满；重启应用后空间立刻回来。写出四段分析：谁还在持有这个文件；`(deleted)` 是什么状态；在本机怎么当场定位到具体进程；怎么把空间拿回来而不重启应用。

::: sol 解答

现象：目录里已经没有那个名字，`df` 却不降——不是 `rm` 失败，`rm` 只删**目录项**（硬链接数减 1）。机制：磁盘空间属于 inode，inode 要等硬链接数为 0 **且** 没有任何打开文件描述引用它时才释放。轮转脚本删了名字，但应用进程一直持有那个 fd 在写，于是 inode 还活着，`/proc/PID/fd` 里那条链接的目标会显示成 `/var/log/app.log (deleted)`——这正是「删了但空间不释放」的标准读数。证据（本机免 root 可跑）：`ls -l /proc/<pid>/fd | grep '(deleted)'` 直接看到哪个 fd 指向已删文件；`lsof +L1` 列出链接数为 0 的打开文件（本机实测能列出自己进程的 `(deleted)` 记录）；对照 `stat -c '%s %b'` 与 `df` 判断是虚占还是实占。修法（从轻到重）：让应用**先关再删**，或者用「重命名 + 重新打开」的轮转方式（`copytruncate` 之外更常见的是 `rename` 到 `.1` 再让进程开新文件）；如果应用支持信号重载配置（如 `nginx -s reopen`、`logrotate` 的 `postrotate`），发信号让它关闭旧 fd，空间立刻回来；实在需要在线回收又不想停进程，可以 `gdb -p` 强制 `close(fd)`（有停摆风险，要评估）；最后一档才是重启应用。预防：程序里每个 `open` 都有配对的 `close`（含错误分支），fd 上限三层都查——`ulimit -n`（或 `/proc/PID/limits`）、`/proc/sys/fs/nr_open`、`/proc/sys/fs/file-max`。

**判据**：说清「目录项 vs inode 引用」两条独立的计数；`(deleted)` 的解释正确；至少给一条本机免 root 的定位命令（`/proc/<pid>/fd` 或 `lsof +L1`）；修法给出「先关再删 / 信号 reopen」这类不重启的方案；不把「重启」当唯一答案。

:::
:::

::: ex 例 2.2-B4 · 同一个 fd 被两个线程用，读到错位数据 {#ex-2.2-B4}

先猜：两个线程各自 `lseek(fd, off_i, SEEK_SET)` 然后 `read`，结果可能串成什么样？把 `lseek` 换成 `pread` 就好了，为什么？如果这个 fd 是 `O_APPEND` 打开的，`pwrite` 会写到 `pread` 旁边的位置吗？

现象：多线程下载器共用一个 fd，各线程负责不同区段，拼出来的文件段落顺序错乱、中间出现重复或空洞。写出四段分析：共享的是哪一层状态；`lseek`+`read` 为什么不是「一步」；`pread`/`pwrite` 解决什么、还剩什么没解决；Linux 上 `O_APPEND` 与 `pwrite` 的那条例外。

::: sol 解答

现象：不是数据损坏，是**偏移被别的线程推进了**。机制：`lseek` 改的是打开文件描述里的 `f_pos`，这个状态由共享同一个 `struct file` 的所有 fd 和所有线程可见；`lseek(fd, off)` 与 `read(fd, ...)` 是两条系统调用，中间另一个线程的 `lseek` 或 `read` 都会改变 `f_pos`，于是你的 `read` 从别人的位置开始读——结果就是段落错乱、重复读同一段，或者跳过一段。修法是 `pread(fd, buf, count, offset)`/`pwrite(...)`：偏移作为参数传入，**不读写 `f_pos`**，一次调用完成「定位 + 传输」，所以线程之间不再共享这个状态，也不需要给偏移加锁。`pread` 还剩什么没解决：它只保证「这次调用从指定偏移开始」，不保证多次调用的原子性（仍可能短读，仍需累积循环），也不保证你写的整块内容对并发读取方原子可见——那需要应用层的记录格式或锁。管道/FIFO/socket 上 `pread` 返回 `ESPIPE`，这类对象根本没有偏移可言。Linux 的那条例外要单独记：POSIX 规定 `pwrite` 忽略 `O_APPEND` 在 `offset` 处写，Linux 内核实现不遵守——fd 带 `O_APPEND` 时 `pwrite` 仍追加到末尾、`offset` 被忽略，`man 2 pwrite` 的 BUGS 段有记录且长期未修；所以「先 `O_APPEND` 打开、再指望 `pwrite` 随机写」的代码在 Linux 上静默写错位置。可移植做法：需要随机写就别带 `O_APPEND`，或先 `fcntl(fd, F_SETFL, flags & ~O_APPEND)` 清掉。同理，`O_APPEND` 的 fd 上 `lseek` 设的位置也会被忽略。

**判据**：定位到「共享的是 `struct file` 的偏移」而不是缓冲区问题；说清两条调用之间被抢先的窗口；`pread` 为什么解决（偏移变参数、不碰 `f_pos`）以及它不解决什么（短读、跨调用原子性）；Linux 的 `pwrite` + `O_APPEND` 例外能给出来并给可移植写法；知道 `pread` 在管道上 `ESPIPE`。

:::
:::

::: ex 例 2.2-B5 · 同一个程序在不同目录建出不同权限 {#ex-2.2-B5}

先猜：`open(path, O_CREAT|O_WRONLY, 0666)` 在 A 目录建出 `0644`，在 B 目录建出 `0660` 还多了一个「命名用户可读」，是程序的问题还是 `umask` 的问题？给 `chmod 0755` 之后又被谁改回去了？

写出四段分析：`umask` 的算式与作用范围；默认 ACL 怎么插一脚；`mode` 里的 setuid/setgid/sticky 各在什么条件下生效或被清掉；目录的 setgid 与 sticky 各自改变什么。最后给一条本机可执行的验证顺序。

::: sol 解答

现象：`mode` 相同、结果不同，说明差异来自**创建环境**而不是程序。机制：第一层是 `umask`——最终权限 = `mode & 07777 & ~umask`，`umask` 是进程级状态（`fork` 继承、`exec` 保留、多线程共享，所以别在工作线程里改它），默认常见 `022`，于是 `0666` 变 `0644`、`0777` 变 `0755`；它是位屏蔽不是减法，对 `0600` 没有影响。第二层是父目录的**默认 ACL**（`setfacl -d` 设的）：内核拿默认 ACL 当模板，把 `mode` 里没请求的位从 ACL 的 mask 清掉，`umask` 此时作用在 mask 上，命名用户/组的条目可以保留——这就是 B 目录里多出「某个用户可读」的来源，也是同一份代码在不同目录建出不同权限的原因；文件不会因为 ACL 里写了 `x` 就拿到执行位，除非 `mode` 请求了。特殊位：`mode` 可以直接带 setuid(04000)/setgid(02000)/sticky(01000)，但 `open` 创建的文件之后一旦被 `chown`，setuid/setgid 会被清掉（安全考虑）；目录带 setgid 时，其中新建的文件继承**目录的属组**、子目录继续带 setgid（团队协作目录 `chmod 2775` 就是这个用法）；sticky 只对目录有意义，规定只有文件属主、目录属主或 root 能删除/改名其中的项（`/tmp` 的 `1777`）。`chmod` 设的是精确权限，不再受 `umask` 影响——「`chmod` 之后又被改回去」通常是程序重新创建了该文件（新文件重新过一遍 `umask`/ACL），不是 `chmod` 失效。本机验证顺序：`umask` 看当前值 → 在目标目录里 `touch t1 && stat -c '%a %n' t1` → `getfacl -p <目录>` 看有没有 default ACL → `ls -ld <目录>` 看 setgid/sticky 位 → 换 `umask 077` 再建一次对比。顺带一条相关的坑：`open(path, O_CREAT|O_WRONLY, 0)` 建出来的是权限全 0 的文件，普通用户连自己都打不开（root 可以），只能 `chmod` 补救——这不是「用默认权限」。

**判据**：先分「`umask` 与默认 ACL 两层」而不是只怪 `umask`；算式写对且说明是位屏蔽；能解释命名用户条目与 mask 的关系；setgid 目录传属组、sticky 目录限制删除各说一条；给出本机可执行的验证顺序（至少含 `umask`、`getfacl`、`stat -c '%a'`）；知道 `mode=0` 的后果。

:::
:::

## C 组 · 动手实验

::: ex 例 2.2-C1 · `openflags.c` 与 `ioctl_demo.c`：flags 边界和 `ENOTTY` {#ex-2.2-C1}

先猜：`O_NOFOLLOW` 打开符号链接报的是 `EINVAL`、`EMLINK` 还是 `ELOOP`？`O_PATH` 的 fd 上 `read` 报什么？把 `TIOCGWINSZ` 打在普通文件上会得到什么？

抄正文 2.2.9 的 `openflags.c` 与 2.2.4.1 的 `ioctl_demo.c`，编译运行，逐行核对输出里每个错误码的名字与数值。

::: sol C1 核对

```bash
mkdir -p ~/lab2c02 && cd ~/lab2c02      # 源码从正文 2.2.9 / 2.2.4.1 抄来
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 openflags.c -o openflags
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 ioctl_demo.c -o ioctl_demo
./openflags; echo "rc=$?"
./ioctl_demo; echo "rc=$?"
```

看到什么算对（下面这份是本书 aarch64 虚拟机上的实测输出）：

```text
O_PATH fstat: ok
O_PATH read: n=-1 errno=9 (Bad file descriptor)
O_PATH 指向: /tmp/openflags.XXXXXX        ← 随机名，每次不同
open(symlink, O_NOFOLLOW): fd=-1 errno=40 (Too many levels of symbolic links)
open(symlink, O_PATH|O_NOFOLLOW): ok
open(file, O_DIRECTORY): fd=-1 errno=20 (Not a directory)
O_TMPFILE linkat: ok -> /tmp/openflags.linked
F_GETFL: append=1 nonblock=1 accmode=1
rc=0
```

`ioctl_demo` 在没有终端的会话里（例如脚本执行、`ssh host './ioctl_demo'`）实测是：

```text
TIOCGWINSZ: Inappropriate ioctl for device
stdin readable: 0 bytes
inode flags: 0x80000
rc=0
```

读法与判据：`ELOOP`=40、`ENOTDIR`=20、`EBADF`=9 这三个数值在 aarch64 与 x86-64 上相同（Linux 用同一套 `asm-generic` 错误码），可以放心对照；但 `ENOTTY` 那行的含义是「这个 fd 不支持这个 request」，不是「不是终端」，普通文件也一样返回它。`O_PATH|O_NOFOLLOW` 那行是 ok，说明「想引用符号链接本身」要靠这两个位组合。`O_TMPFILE` 那步能打印 `linkat: ok`，是因为程序里预置了回退：`AT_EMPTY_PATH` 需要 `CAP_DAC_READ_SEARCH`，普通用户失败后改走 `linkat(AT_FDCWD, "/proc/self/fd/N", ..., AT_SYMLINK_FOLLOW)`，两条路都不通才打印错误——看到回退生效而不是 `EPERM` 就是对的。`inode flags: 0x80000` 是本机 ext4 上该 inode 的原始 flags（`FS_IOC_GETFLAGS` 读的是文件系统语义，跟 `open` flags 不是一回事），换文件系统或换机器这个数会变，别当常数；根目录若换成 tmpfs，这一步会直接 `ENOTTY`。做完清掉残留：`rm -f /tmp/openflags.* /tmp/openflags.link /tmp/openflags.linked`。

:::
:::

::: ex 例 2.2-C2 · `shortio.c`：短写、`EAGAIN`、`EPIPE`、`EISDIR` 一次跑齐 {#ex-2.2-C2}

先猜：往管道一次 `write` 1 MiB，返回多少？第二次 `write` 会阻塞、返回 0，还是报错？对目录 fd 调 `read`、对 `/dev/full` 调 `write` 各是什么错误码？

抄正文 2.2.12 的 `shortio.c`（它用 `pipe2(p, O_CLOEXEC | O_NONBLOCK)`），编译运行并核对七行输出，再查一次本机管道容量。

::: sol C2 核对

```bash
cd ~/lab2c02
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 shortio.c -o shortio
./shortio
```

看到什么算对（本机实测）：

```text
write 1MiB to pipe: n=65536 errno=0 (Success)
write again:        n=-1 errno=11 (Resource temporarily unavailable)
read 64KiB:         n=65536 errno=0
read empty:         n=-1 errno=11 (Resource temporarily unavailable)
write /dev/full:    n=-1 errno=28 (No space left on device)
read directory:     n=-1 errno=21 (Is a directory)
write broken pipe:  n=-1 errno=32 (Broken pipe) sigpipe=1
```

关键读数是第一行：1 MiB 只写进 **65536** 字节且 `errno=0`——这不是错误，是短写；任何「`write` 返回非负就算写完」的代码在这里丢 983040 字节。第二行的 `EAGAIN`(11) 是「现在不行」，正确反应是等可写事件而不是忙转。验证容量：`getconf PAGESIZE` 本机 4096，默认管道容量是 16 页 = 65536；`/proc/sys/fs/pipe-max-size` 本机是 1048576（那是单进程能申请的上限，不是默认值），`fcntl(F_GETPIPE_SZ)` 直接读也得到 65536。**换到页大小 16 KiB 的 ARM64 内核或别人改过容量的机器，第一行的数就不是 65536**，这时要按本机重取，别把 65536 当常量。`/dev/full` 是本机存在的设备（`ls -l /dev/full`），它的 `write` 恒返回 `ENOSPC`(28)，是最便宜的空间不足演练；若你的环境里没有它（例如某些精简 rootfs），跳过这一行并注明。最后一行 `sigpipe=1` 说明进程先收到了 `SIGPIPE`——程序用 `sigaction` 接管了它才没被杀；把这段处理删掉再跑，进程会直接终止，这就是服务端「连接一断整个进程没了」的机制。

**判据**：七行全部对上，且能指出第一行的 65536 是短写而不是错误；说出 `EAGAIN` 与 `EINTR` 的处理差别；能解释 `sigpipe=1` 的来源并预告「不接管就被杀」；给出本机管道容量的验证命令，并写明这个数跟着页大小与 `F_SETPIPE_SZ` 变。

:::
:::

::: ex 例 2.2-C3 · `sparse_scan.c`：用 `lseek` 问出空洞 {#ex-2.2-C3}

先猜：`ftruncate` 到 4 MiB 之后文件占多少磁盘？往 0 和 2 MiB 各写 4 KiB 后，`SEEK_DATA` 会给你几段？`du` 和 `du --apparent-size` 哪个数更大？

抄正文 2.2.13 的 `sparse_scan.c`，运行后用三个命令行读数交叉验证。

::: sol C3 核对

```bash
cd ~/lab2c02
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 sparse_scan.c -o sparse_scan
./sparse_scan
truncate -s 4M lab2c03_sp.bin
du        lab2c03_sp.bin            # 实占
du --apparent-size lab2c03_sp.bin   # 逻辑大小
stat -c 'size=%s blocks=%b (x512=%b*512)' lab2c03_sp.bin
rm -f lab2c03_sp.bin
```

看到什么算对（本机实测）：

```text
logical=4194304 bytes, allocated=8192 bytes
data [0, 4096)  4096 bytes
data [2097152, 2101248)  4096 bytes
```

`logical` 是 `st.st_size`（逻辑 4 MiB），`allocated` 是 `st_blocks * 512` = 8192，正好两个 4 KiB 数据块——中间与尾部的空洞不占磁盘块，这就是「`lseek`/`ftruncate` 超出末尾不分配空间」的读数。命令行交叉验证：`truncate -s 4M` 造出来的纯空洞文件 `du` 显示 **0**、`du --apparent-size` 显示 **4.0M**、`stat -c '%s %b'` 给 `4194304 0`（本机实测）——三个读数说的是同一件事，用哪个取决于你问的是「逻辑大小」还是「实占」。备份类工具（`cp --sparse=always`、`tar -S`）就是把 `SEEK_DATA`/`SEEK_HOLE` 的答案用来跳过空洞。三条边界要记住：文件系统可以保守地把所有区域都报成数据（这时 `SEEK_HOLE` 只返回 EOF，程序仍正确，只是不省 I/O）；`SEEK_DATA` 起点超出文件末尾返回 `ENXIO`；正文那段代码特意留了 `if (hole <= off)` 的防死循环检查，因为「不前进」是这类跳读接口的真实风险。本机根文件系统是 ext4（`findmnt -T /` 显示 `/dev/sda2 ext4`），`O_TMPFILE` 与 `SEEK_DATA` 都可用；换到某些网络文件系统上这两项可能返回 `EOPNOTSUPP`，所以先查文件系统再查代码。

**判据**：`allocated=8192` 与两段 `data` 区间对上；能用 `du`/`du --apparent-size`/`stat -c '%s %b'` 三个读数解释逻辑大小与实占；说出「文件系统可以保守报告」这条边界；能解释代码里那个防死循环检查防的是什么。

:::
:::

::: ex 例 2.2-C4 · `copy.c` + `strace`：把契约变成可见的调用序列 {#ex-2.2-C4}

先猜：`strace` 的输出里你会看到几次 `fsync`？第二次 `fsync` 的对象是文件还是目录？如果让第一个 `openat` 就失败，`/tmp` 下会不会留下 `.tmp.<pid>` 垃圾文件？

抄正文 2.2.7 的 `copy.c`，编译后用 `strace -yy` 看完整序列，再用 `-e inject` 不改代码地踩一次错误分支。

::: sol C4 核对

```bash
cd ~/lab2c02
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 copy.c -o copy
printf 'hello\n' > lab2c04_src.txt
strace -yy -e trace=openat,read,write,close,fsync,rename ./copy lab2c04_src.txt lab2c04_dst.txt 2>&1 | tail -14
cmp lab2c04_src.txt lab2c04_dst.txt && echo "identical"
# 故障注入：让第一次 openat 失败，看有没有清理
strace -e inject=openat:error=EACCES:when=1 ./copy lab2c04_src.txt /tmp/lab2c04_x 2>&1 | tail -3
ls /tmp/lab2c04_x.tmp.* 2>/dev/null && echo "临时文件泄漏" || echo "清理正确"
rm -f lab2c04_src.txt lab2c04_dst.txt
```

看到什么算对（本机实测的调用序列形状）：源文件 `openat(..., O_RDONLY|O_CLOEXEC)`；目标 `openat(..., O_WRONLY|O_CREAT|O_EXCL|O_CLOEXEC, 0644)`；一组 `read`/`write`，**最后一次 `read` 返回 0**（EOF，不是错误）；`fsync(数据 fd) = 0`；`close`；`rename("....tmp.<pid>", 目标)`；然后 `openat(AT_FDCWD, ".", O_RDONLY|O_DIRECTORY|O_CLOEXEC)` 与第二次 `fsync`。两次 `fsync` 缺任何一次都不算完整发布，第二次针对的是**目录**。「清理正确」是故障注入那步的期望结果——源打不开时程序应在 `die()` 前不留垃圾。`-yy` 不是装饰：没有它只能看到 `read(3, ...)`，而 fd 3 在这段序列里被复用过两次（源文件、以及后来打开的目录），据此判断「读了什么」必错。正文贴的那段示例里 `inside: fd=3` 之类的具体 fd 号、以及 `read` 返回的 262144/221 这些字节数都属于「那次会话的读数」，你这里会看到不同的 fd 号与块大小（`BUF_SIZE` 是 256 KiB，但源文件只有 6 字节时 `read` 返回 6）。

`-e inject` 支持 `error=`、`retval=`、`signal=`，`when=N` 限定第几次调用命中——这是不改代码测错误路径最便宜的工具。

**判据**：能指出两次 `fsync` 各自的对象并说出漏掉目录那次会怎样；能解释 `read` 返回 0 不是错误；故障注入看到「清理正确」；能说出 `-yy` 在 fd 复用场景下的必要性；不把自己这次的 fd 号当成正文的号。

:::
:::

::: ex 例 2.2-C5 · `safeopen.c`：`RESOLVE_BENEATH` 与两种 `EXDEV` {#ex-2.2-C5}

先猜：`openat2(dirfd, "../etc/passwd", RESOLVE_BENEATH)` 报的是 `EACCES`、`EPERM` 还是 `EXDEV`？绝对路径 `/etc/passwd` 呢？「跨文件系统改名」的 `EXDEV` 和这个是同一回事吗？

抄正文 2.2.10 的 `safeopen.c` 跑一遍，再用两个挂载点复现真正的那个 `EXDEV`。

::: sol C5 核对

```bash
cd ~/lab2c02
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 safeopen.c -o safeopen
./safeopen; echo "rc=$?"
# 真正的跨文件系统 rename：/tmp 与家目录同属一个 ext4 挂载，要用 /dev/shm
echo x > /tmp/lab2c05_x
python3 -c 'import os
try:
    os.rename("/tmp/lab2c05_x", "/dev/shm/lab2c05_y"); print("rename ok")
except OSError as e:
    print("errno=%d (%s)" % (e.errno, e.strerror))'
rm -f /tmp/lab2c05_x /dev/shm/lab2c05_y
```

看到什么算对（本机实测）：

```text
inside:  fd=4 ok
escape:  fd=-1 errno=18 (Invalid cross-device link)
absolute:fd=-1 errno=18 (Invalid cross-device link)
rc=0
errno=18 (Invalid cross-device link)      # os.rename 跨挂载
```

三条要点：① `RESOLVE_BENEATH` 对逃逸统一报 `EXDEV`，`..` 和绝对路径都一样——这是本章最反直觉的一条：**错误码不描述原因，只描述类别**，排障时先看 `resolve` 位再看路径。② 正文那三行把 `fd=3` 印在 `inside` 前面，本机实测是 `fd=4`：程序在此之前已经 `open` 过一次目标文件（拿到 3）并 `close`，但紧接着又 `open(dir)` 占掉了 3，所以成功的那次是 4。**fd 号取决于这个程序此前开了什么、关了什么**，别把它当可复现的常数，也别因为对不上就怀疑自己。③ `EXDEV` 有两个完全不同的来源：这里是「解析要逃出 `dirfd`」，另一处是「`rename`/`link` 跨文件系统」。第二个更值得当场验证：本机上 `/tmp`、`/etc`、家目录都在同一个 ext4 挂载（`findmnt -T` 三者都给 `/dev/sda2`），所以 `/tmp` → 家目录的 `rename` 会**成功**，必须用 `/dev/shm`（独立 tmpfs）才能看到 `EXDEV`——而 `mv` 跨设备时会自己降级成「复制 + 删除」，所以 `mv /tmp/x /dev/shm/y` 反而不报错；要看 `rename(2)` 的真行为就用 `python3 os.rename` 或直接写 C。正文 2.2.16 那句「临时文件必须与目标同目录」在这台机器上的正确检验方式就是这个，而不是「放 `/tmp` 再改名到家目录」。

**判据**：两条逃逸尝试都报 `EXDEV` 并能解释「错误码只给类别」；指出本机 `fd=4` 与正文 `fd=3` 的差异并给出原因；能区分两种 `EXDEV` 的来源；用 `/dev/shm` 复现跨文件系统改名并说明为什么 `mv` 不报错。

:::
:::

::: ex 例 2.2-C6 · `fdlife.c` 与 `EMFILE`：fd 的一生与上限 {#ex-2.2-C6}

先猜：`dup3(a, 100, O_CLOEXEC)` 之后 `fcntl(a, F_GETFD)` 的 `FD_CLOEXEC` 会变成 1 吗？`fcntl(b, F_DUPFD_CLOEXEC, 3)` 会返回 3 吗？把 `ulimit -n` 调到 16，第几次 `open` 会失败？

抄正文 2.2.15 的 `fdlife.c` 跑一遍，再用 `ulimit` 逼出 `EMFILE`，并读出三层上限。

::: sol C6 核对

```bash
cd ~/lab2c02
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 fdlife.c -o fdlife
./fdlife; echo "rc=$?"
grep 'open files' /proc/self/limits
getconf _SC_OPEN_MAX; cat /proc/sys/fs/nr_open
bash -c 'ulimit -n 16; python3 -c "import os
n=0
try:
    for i in range(40):
        os.open(\"/etc/hosts\", os.O_RDONLY); n+=1
except OSError as e:
    print(\"opened\", n, \"errno\", e.errno, e.strerror)"'
```

看到什么算对（本机实测）：

```text
dup3(a,100,CLOEXEC)=100 fd0_cloexec=1
F_DUPFD_CLOEXEC(b,3)=5
fds before close_range: 7
fds after close_range:  5
opened 13 errno 24 Too many open files
```

三条要点：① `dup3` **不给源 fd 设标志**，它设置的是新 fd（100）的 `FD_CLOEXEC`；本机打印 `fd0_cloexec=1` 说的是 `a` 这个变量存的 `/etc/hosts` 的 fd——它在 `open` 时就带了 `O_CLOEXEC`（正文那行 `fd0_cloexec` 的措辞容易读成「fd 0」，其实是「变量 a 的 fd」），别把两个来源混起来。② `F_DUPFD_CLOEXEC(b, 3)` 本机返回 **5**，正文印的是 3：`F_DUPFD` 系列返回「不小于第三参数的最小可用 fd」，此刻 3 与 4 已经被两次 `open` 占着，所以是 5。**这不是你做错了**，返回几号取决于此前占用了哪些 fd。`fds before/after` 的 7 与 5 能对上的原因：计数含 `stdin/stdout/stderr` 三个，还含 `opendir("/proc/self/fd")` 自己那个（代码里已减 1），所以数字比自己开的 fd 数大 3。③ `close_range` 之后 fd 号立刻可复用：如果还有代码持有 100 这个数字，它会指向新打开的对象——这就是「关掉之后不要用旧数字」和「不要重试 `close`」两个规矩的共同原因。上限三层各读一处：软限制 `ulimit -n`（=1024，`getconf _SC_OPEN_MAX` 在本机就是它的投影，换一次 SSH 会话可能不同）、硬上限 `/proc/sys/fs/nr_open`（1048576）、系统级 `/proc/sys/fs/file-max`；`EMFILE`(24) 先撞的是软限制，本机把软限制压到 16 后第 13 次 `os.open` 失败（16 减去 `stdin/stdout/stderr` 与解释器自己占用的几个）。

**判据**：说清 `dup3` 设的是新 fd 的标志、而不是源 fd；解释 `F_DUPFD_CLOEXEC` 为什么本机返回 5 而正文写 3；给出 fd 计数的两个 +1/+3 来源；`EMFILE` 复现成功且能说出三层限制各自从哪读、先撞哪一层。

:::
:::

::: ex 例 2.2-C7 · `fdinfo` 与 `(deleted)`：读一个 fd 的当前状态 {#ex-2.2-C7}

先猜：`exec 3<>/tmp/x` 之后 `/proc/self/fdinfo/3` 的 `flags` 会是正文里那个 `0100002` 吗？删掉 `/tmp/x` 之后 `pos`、`ino`、`df` 各怎么变？`mnt_id` 能不能当常数抄进笔记？

用 bash 的 `exec` 重定向做一次 fdinfo 读数，再做一次「删名字不关 fd」的演示，并把 `mnt_id` 和 `mountinfo` 对上。

::: sol C7 核对

```bash
exec 3<>/tmp/lab2c07_demo
cat /proc/self/fdinfo/3
ls -l /proc/self/fd/3
printf hello >&3
cat /proc/self/fdinfo/3            # pos 变了
exec 4>/tmp/lab2c07_del; rm /tmp/lab2c07_del
ls -l /proc/self/fd/4              # 末尾带 (deleted)
lsof +L1 | grep lab2c07_del | head -2
exec 4>&-                          # 关掉之后才算真释放
exec 3>&-; rm -f /tmp/lab2c07_demo
awk '$1==35' /proc/self/mountinfo  # 用上面读到的 mnt_id 替换 35
```

看到什么算对（本机实测）：

```text
pos:	0
flags:	0400002
mnt_id:	35
ino:	2883634
```

写入之后 `pos` 变成 5，`flags` 与 `mnt_id` 不变——`pos` 是打开文件描述里的共享偏移，同一个 `struct file` 的多个 fd 会一起变；`mnt_id: 35` 能在 `/proc/self/mountinfo` 第一列查到，本机对应 `8:2 / / rw,relatime shared:1 - ext4 /dev/sda2 rw`，也就是根挂载；`ino` 是本机这个文件的 inode 号。关键差异在这里：**正文 2.2.18 贴的是 `flags: 0100002` 并解释「去掉 `O_LARGEFILE`（`0100000`）后是 `02`」，那是 x86-64 的读法。本机 `flags: 0400002`，其中 `0400000` 是 aarch64 的 `O_LARGEFILE`、`2` 是 `O_RDWR`**（`/usr/include/aarch64-linux-gnu/asm/fcntl.h` 原文可查：`O_LARGEFILE 0400000`、`O_NOFOLLOW 0100000`）。也就是说，同样这个 `0400002` 用 x86 的表去解，会解成「带 `O_NOATIME`/`O_NDELAY` 之类」的怪组合；反过来 `0100000` 在 aarch64 上是 `O_NOFOLLOW`。所以正确解法只有两条：把八进制数交给本机的头文件去查，或者干脆看 `strace` 打出来的**名字**——`strace -yy` 里那行 `openat(..., O_RDWR|O_CREAT|O_TRUNC, 0666)` 才是可读事实，数字只是它的编码。另一个坑：`/usr/include/aarch64-linux-gnu/bits/fcntl-linux.h` 里 glibc 自己还写着 `__O_LARGEFILE 0100000`（x86 风格的兜底值），和内核 aarch64 头的 `0400000` 并存——**同一个数字名在三处定义不同**，手工拆位必然出错。`(deleted)` 那步：删名字后 `ls -l /proc/self/fd/4` 目标带 `(deleted)`，`lsof +L1` 能列出这条记录（本机实测打印的是当前 shell 的 fd 4），只有 `exec 4>&-` 关掉之后 inode 引用才归零、空间才真正回收。`mnt_id` 与 `ino` 每台机器、每次挂载都不同（正文示例 `mnt_id: 28`、`ino: 1234567` 与本机 35/2883634 都不一样），不能当常数引用，也不能跨机器比较。

**判据**：本机 `flags` 读出 `0400002` 并正确解释两个八进制段；能指出正文那条 x86 解释在本机不成立、并给出「查本机头文件 / 看 strace 名字」两种正确解法；`mnt_id` 能在 `mountinfo` 里对上；`(deleted)` 前后 `pos`/`ino`/空间三者关系说清，并知道关掉 fd 才回收。

:::
:::
