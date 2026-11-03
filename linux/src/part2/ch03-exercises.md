# 2.3 习题集

三组分层：**A 组概念判断**考「会读、会说理由、会把机制一层层串起来」；**B 组诊断推理**给现象让你判归属、判原子性边界、判修法；**C 组动手实验**在 Ubuntu 24.04 aarch64 上免 `sudo` 复现本章的关键证据。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 [2.3.1](ch03.md#sec-2.3.1)–[2.3.15](ch03.md#sec-2.3.15)，B 组对应 [2.3.3](ch03.md#sec-2.3.3)–[2.3.18](ch03.md#sec-2.3.18)，C 组对应 [2.3.3](ch03.md#sec-2.3.3)、[2.3.4](ch03.md#sec-2.3.4)、[2.3.6](ch03.md#sec-2.3.6)、[2.3.7](ch03.md#sec-2.3.7)、[2.3.8](ch03.md#sec-2.3.8)、[2.3.13](ch03.md#sec-2.3.13)–[2.3.14](ch03.md#sec-2.3.14)、[2.3.17](ch03.md#sec-2.3.17)。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38、GCC 13.3.0、glibc 2.39）上真跑过；实验目录用 `/tmp/lab2c03_work`，新建文件一律带 `lab2c03_` 前缀，做完**留着别删**——别人正在同一台机器上跑别的实验。
4. **`sudo` 与 `perf` 的事件计数不可用**；`strace -p <PID>` 与读别人的 `/proc/PID/syscall` 被 `ptrace_scope`=1 挡住，观察一律改成「在 strace 下启动」或 `/proc/self/...`；来历不明的自写程序一律套 `timeout`，可能挂住的（比如持锁睡 30 秒的 `lockfile`）先想好怎么收尾再按 `&`。
5. 解答里贴的数字都是这台机器跑出来的；你的机器（尤其 x86-64、别的内核、别的文件系统）读数以你跑出来的为准，对照口径见[勘误与版本注记](ch03-errata.md)。
6. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch03-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.3-A1 · `fcntl` 的五类操作与 `F_SETFL` 的边界 {#ex-2.3-A1}

先猜：`fcntl(fd, F_SETFL, O_NONBLOCK)` 会出什么问题？对一个 `O_RDONLY` 的 fd 执行 `fcntl(fd, F_SETFL, flags | O_RDWR)` 返回什么、fd 变得能写吗？

说出五类 `cmd`（读写状态 flags、读写 fd 标志、复制 fd、记录锁、`F_OFD_*`）各自的第三参数类型与成功返回值；解释为什么编译器帮不了 `fcntl`；说明为什么「`F_GETFL` 读 → 改 → `F_SETFL` 写」在多线程下仍会丢更新，以及 `F_DUPFD_CLOEXEC` 的第三个参数是什么。

::: sol 解答

第三参数类型由 `cmd` 决定（`int`、`struct flock *` 或没有），走的是可变参数，编译器不做类型检查，传错就是未定义行为，所以每个 `cmd` 的签名只能背。`F_SETFL` 只能改行为位（`O_APPEND`、`O_NONBLOCK`、`O_ASYNC`、`O_DIRECT`、`O_NOATIME`）；访问模式在 `open` 时定死，塞进去的 `O_RDWR` 被内核静默忽略。本机实测：对 `O_RDONLY` 的 fd 执行 `F_SETFL(flags | O_RDWR)` 返回 0、`F_GETFL` 读回的访问模式位仍是 `O_RDONLY`，随后 `write` 报 `EBADF`(9)——「返回 0」不等于「改成了」。直接写 `fcntl(fd, F_SETFL, O_NONBLOCK)` 会把 `O_APPEND` 等其他位一并清掉，必须先读再或。读-改-写是两条系统调用（syscall），两个线程各做一遍，后写入的用的是自己那一份旧 flags，会丢掉对方的更新；启动时一次设好，或加互斥锁。`F_DUPFD_CLOEXEC` 的第三参数是「新 fd 的下界」不是「指定的号」：本机给下界 50 返回了 50，但那只是「≥50 的最小可用」的巧合，它替代不了 `dup2`。

**判据**：五类 `cmd` 与第三参数不混；说出「返回 0 但什么都没改」的静默忽略；说清读-改-写丢更新的窗口；`F_DUPFD` 下界与 `dup2` 的区别说对。

:::
:::

::: ex 例 2.3-A2 · `dup` 家族复制的是哪一层 {#ex-2.3-A2}

先猜：`dup(fd)` 出来的两个 fd，偏移共享吗？`flock` 锁共享吗？`fcntl` 记录锁呢？`close(1); dup(fd);` 和 `dup2(fd, 1)` 差在哪一步？

说明 `dup` 家族复制 fd 表项而不是打开文件描述（`struct file`）这句话的含义，列出两个 fd 共享的三样东西；解释 `dup2` 的「原子关闭 + 复制」价值、`dup2(fd, fd)` 与 `dup3(fd, fd, 0)` 的返回值差异（本机实测：前者返回 fd 本身，后者报 `EINVAL`）；说出 `dup3` 的 `flags` 只接受什么；解释重定向 stdout 前后为什么各要一次 `fflush`。

::: sol 解答

fd 表 → 打开文件描述 → inode（索引节点，文件的内核对象）三层里，`dup` 复制的是第一层的表项：两个号指向同一个 `struct file`，所以共享偏移 `f_pos`、共享状态 flags、共享同一把 `flock` 锁（锁归打开文件描述）。`fcntl` 记录锁归「进程 + inode」，同一进程内两个 fd 上的锁会合并，看起来也「共享」，但那是归属模型不同导致的，不是同一种共享。`close(1); dup(fd);` 之间另一个线程能抢走 fd 1（它新打开的东西正好落在 1 号上），随后 `dup` 把日志写进那个不相干的文件；`dup2(fd, 1)` 一步完成关闭与复制，窗口消失。`dup2` 允许 `oldfd == newfd`（直接返回 fd，什么也不做），`dup3` 同参数相等返回 `EINVAL`(22)，且 `flags` 只认 `O_CLOEXEC`。`dup2` 只换 fd、不搬 stdio 缓冲区：缓冲里残留的旧内容会被写进新目标，所以换之前 `fflush`、换回来之前再 `fflush`——这是 [2.4](ch04.md) 的主题，这里先记住纪律。

**判据**：「复制表项不是对象」说对；三样共享（偏移、状态 flags、`flock`）报全；`dup2` 原子性针对的竞态说清；`dup2(fd,fd)` 与 `dup3(fd,fd,0)` 的实测差异不混；`fflush` 两条各在什么时候。

:::
:::

::: ex 例 2.3-A3 · `pread`/`pwrite` 消灭什么、和 `O_APPEND` 撞上什么 {#ex-2.3-A3}

先猜：两个线程共用一个 fd，都用 `lseek` + `read`，最坏情况是什么？`pread` 为什么没有这个问题？对一个带 `O_APPEND` 的 fd 执行 `pwrite(fd, "BBBB", 4, 0)`，文件会变成 `BBBB` 开头，还是变成别的什么？

说明 `pread`/`pwrite` 把偏移当参数、不碰 `f_pos` 为什么一次消掉整类竞态；列出它们各自的错误码（管道上 `pread` 报什么？本机实测 `ESPIPE`=29）；解释 Linux 上 `pwrite` 与 `O_APPEND` 的组合为什么不守 POSIX——POSIX 说忽略 `O_APPEND` 按给定偏移写，Linux 的实际行为是把数据追加到末尾、`offset` 被无视——以及可移植代码该怎么防。

::: sol 解答

`lseek` 改的是共享 `struct file` 里唯一的 `f_pos`：线程 1 定位到 100，线程 2 定位到 200，线程 1 的 `read` 就从 200 开始，读回错位数据；`pread` 把偏移放进这一次调用、不读写 `f_pos`，天然无竞态。错误码：`EBADF`、`EINVAL`（负偏移，或 `O_DIRECT` 三项对齐不满足）、`ESPIPE`（管道/socket 没有偏移，本机实测 `pread`/`pwrite` 都报 29）、`EINTR`（可重试）。Linux 的 `pwrite` + `O_APPEND`：本机实测先 `write` 4 个 `A` 再 `pwrite(off=0, "BBBB")`，文件内容是 `AAAABBBB`、返回 4、`errno` 为 0——`O_APPEND` 的追加语义压过了显式偏移，这不是报错，是静默的语义反转（man 2 pwrite 的 BUGS 段承认这一点）。可移植代码：不在 `O_APPEND` 的 fd 上用 `pwrite`；要么先 `F_SETFL` 清掉 `O_APPEND`（注意它属于能改的行为位，本机实测能加也能清），要么换独立打开的非追加 fd。

**判据**：竞态窗口描述具体（谁在什么时候读到什么）；四类错误码报到 `ESPIPE`；`AAAABBBB` 这个反直觉结果说得出机制；防御方案给得出来。

:::
:::

::: ex 例 2.3-A4 · `mmap` 的模型、两个硬约束与三种越界 {#ex-2.3-A4}

先猜：`mmap` 失败返回 NULL 吗？`offset=100` 会怎样？文件 4000 字节、映射 8192 字节：读第 4050 个字节、读第 6000 个字节、读第 100000 个字节，结果分别是什么？

说明 `mmap` 只登记 VMA（虚拟内存区域，内核描述一段地址范围的表项）、访问即访问 page cache、缺页（page fault）才读盘这三句模型；给出失败返回值与常见 `errno`；解释「offset 必须页对齐、length 向上取整到页」在参数检查时怎么生效（本机实测：`MAP_ANONYMOUS` 也照样查 offset 对齐）；再按「同页尾部 / 超出 EOF 的整页 / 超出映射长度」三种越界分别说出结果（读 0 / `SIGBUS` / `SIGSEGV`）与内核给不同信号的理由。

::: sol 解答

成功返回映射区首地址；失败返回 `MAP_FAILED`（`(void *)-1`），**不是 NULL**——按 NULL 判断会漏掉整个错误分支。参数检查：`offset=100` 报 `EINVAL`(22)、`length=0` 报 `EINVAL`、`MAP_PRIVATE|MAP_ANONYMOUS` 配 `offset=100` 同样报 `EINVAL`（匿名映射不查 fd，但查对齐，本机实测）。三种越界（本机实测，文件 4000 B、映射 2 页）：`u[4050]` 在 EOF 所在页的尾部——可读、值为 0，写入不落盘也不与其他进程共享；`u[6000]` 落在 EOF 之后的整页——`SIGBUS`(7)，因为 VMA 有这个地址、文件没有对应页；`u[100000]` 超出映射长度——`SIGSEGV`(11)，这个地址根本不属于任何 VMA。内核分开报是对的：`SIGSEGV` 是程序 bug（越界），`SIGBUS` 是外部状态变化（文件被截断、`length` 超出真实内容）；`read` 在同样情形只返回 0，所以「`mmap` 不能把文件大小当不变式」。

**判据**：`MAP_FAILED != NULL`；两条硬约束各有实测失败案例；三种越界的信号/取值报全且能说出内核理由；`read` 对照说一句。

:::
:::

::: ex 例 2.3-A5 · 共享与私有：写到哪一层、谁能看见、什么时候到磁盘 {#ex-2.3-A5}

先猜：`MAP_PRIVATE` 的修改会落盘吗？`MAP_SHARED` 里改一个字节，另一个进程用 `read` 立刻看得见吗？对私有映射调 `msync(MS_SYNC)` 会报错吗？`msync` 和 `fsync` 谁保证到磁盘？

把四个问题连成一条链：写可见性（page cache 统一，本机实测共享映射写入后另一个 fd 的 `pread` 不经任何同步立刻读到新值）、写回与否（`MAP_SHARED` 最终回写文件，`MAP_PRIVATE` 触发写时复制（COW）后永不落盘）、`msync` 的真实语义（`MS_SYNC` 阻塞等回写、`MS_ASYNC` 只排队、对 `MAP_PRIVATE` 返回 0 但什么都不写回——本机实测的静默无效）、以及 `madvise(MADV_DONTNEED)` 在私有匿名映射上的破坏性（页内容变 0，调用即数据丢失）。

::: sol 解答

Linux 是统一页缓存：`mmap` 与 `read`/`write` 面对同一份 page cache，所以「让别人看见」不需要 `msync`——需要的是**落盘**时的 `msync(MS_SYNC)`/`fsync`。`MAP_PRIVATE` 的首次写触发 COW，新页只在本进程，`msync` 也救不回来；本机实测私有映射上写 `Z`、`msync(MS_SYNC)` 返回 **0**（不是报错），`pread` 读回的还是旧内容——静默无效比报错危险，因为你会以为它成功了。`MADV_DONTNEED` 对私有匿名映射是破坏性的：`p[0]='B'` 后调用它，再读 `p[0]` 得 0（本机实测）；其他 UNIX 可能只当「建议换出」，可移植代码不该依赖。判断链背一句：**谁可见看 page cache，谁落盘看 `MS_SYNC`/`fsync`，会不会丢数据看共享位与 `MADV_*`**。

**判据**：四问四答应，尤其「私有 msync 返回 0 但不写回」这条反直觉的要能复述；`MS_ASYNC` 与 `MS_SYNC` 差在哪；`DONTNEED` 为什么是数据丢失事故而不是性能提示。

:::
:::

::: ex 例 2.3-A6 · 三种锁的归属、释放与「挡不住」的四种情形 {#ex-2.3-A6}

先猜：A 进程用 `flock` 加锁、B 进程用 `fcntl` 记录锁锁同一个文件，谁挡得住谁？同一进程把同一个文件 `open` 两次，`fcntl` 锁在第二个 fd 上会冲突吗？`flock` 呢？OFD 锁呢？

用「归属」解释三组行为：`flock` 归打开文件描述（`fork`/`dup` 后共享同一把，只有最后一个引用关闭才释放；本机实测同一进程两次独立 `open` 的两个 fd 互相冲突、报 `EAGAIN`）；POSIX 记录锁归进程 + inode（`fork` 不继承；同一进程内两个 fd 的锁**合并**、不冲突；关闭该文件**任意**一个 fd 就释放全部——历史缺陷）；OFD 锁归打开文件描述（同进程两个 fd 冲突、`/proc/locks` 里 PID 显示 -1）。再说明 `lockf()` 与 `fcntl` 记录锁是同一套、与 `flock` 互不知情，以及为什么结论是「一个程序只用一套」。

::: sol 解答

归属决定一切。本机跨进程矩阵（父进程只持一种锁，另一个进程三种都试）：父持 `flock` → 别的进程 `flock` 被挡（`EAGAIN`=11）、`fcntl` 记录锁与 OFD 锁**都成功**；父持 POSIX → `flock` 成功、记录锁与 OFD 被挡；父持 OFD → `flock` 成功、记录锁与 OFD 被挡。也就是说 `flock` 与另两套完全互不知情，记录锁与 OFD 互通。「挡不住别人」的四种情形按序排查：两套锁混用、锁只在进程之间有效（同进程 `fcntl` 合并后自己骗自己「加锁成功」）、`close` 了另一个指向同文件的 fd 把 POSIX 锁顺手放掉、以及 `unlink` 换 inode 后新进程锁的是另一个对象（锁挡不住目录写权限）。OFD 补的正是第三条：锁跟打开文件描述走，`dup` 出的引用要全部关完才释放，`fork` 后子进程还能共享。`F_GETLK` 只报告**别人**的锁：本机从持锁进程自己查询，`l_type` 被改写成 `F_UNLCK`(2)，看不到自己。

**判据**：3×3 冲突矩阵说对（至少「flock 与记录锁互不知情」「OFD↔记录锁互通」两条）；同进程三种锁各自行为对；「关任意 fd 释放全部」归给 POSIX 且能给出 OFD 修法；`F_GETLK` 的「看不见自己」说得出。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.3-B1 · 日志交错：加了锁还是两条记录咬在一起 {#ex-2.3-B1}

先猜：三个线程各自 `write` 「头部 8 字节 + 正文」两段，日志里出现「甲的头咬乙的正文」。改成整进程互斥锁能解决吗？为什么 `writev` 一次写出就对了？短写之后重试整个 `iovec` 数组又会出什么新问题？

写成「现象 → 机制 → 证据 → 修法」四段。机制层要点：一条记录由两次 `write` 完成时，两次调用之间没有原子性，`O_APPEND` 只保证「单次 write 的追加定位 + 写」原子，不保证「跨多次写的一条记录」原子；`writev` 把多段拼成一次调用、由内核保证一次搬完（可能短写但不会与其他线程交错）。修短的循环按已写字节推进 `iov_base`/切短 `iov_len`，重试整个数组会把已写部分再写一遍。

::: sol 解答

现象：同一 fd 上不同线程的记录互相咬合，字节级交错。机制：POSIX 只保证单次 `write` 的原子性（管道上另有 `PIPE_BUF` 门限），一次记录两次 `write` 就是两个调度点；`O_APPEND` 的原子范围是「这一次写的定位+写入」，跨调用不管。`writev` 一次提交，内核层面没有插入点；`IOV_MAX` 本机 1024，超过时 `writev` 直接 `EINVAL`(22)（实测 iovcnt=1025 失败、1024 成功）。短写处理：`writev` 返回的是**总字节数**，可能只覆盖前一段的一半；每轮只提交剩余段（`&iov[i]`、`iovcnt - i`），整段跳过、中间段把 `iov_base` 前移、`iov_len` 减小；返回 0 要判 `EIO` 退出否则死循环；重试整个数组等于内容重复。证据：2.3.3 的 `iov_log.c` 本机跑出来 `seq=1 len=34 body=disk full on /var; retry scheduled`，文件里没有重复段；交错用 `strace -e trace=write,writev` 看调用序列。修法：要么 `writev` 单调用，要么把「组装 + 单次写」整个锁进临界区；`len` 字段让读端能按记录边界切分，防的也是交错后的重读。

**判据**：把「单次 write 原子」与「一条记录原子」分开；`writev` 短写的推进逻辑写对；`IOV_MAX` 超限的报错码给对；证据想到 `strace` 而不是「看起来不乱了」。

:::
:::

::: ex 例 2.3-B2 · 「我明明加了锁」：flock 与记录锁互不知情 {#ex-2.3-B2}

先猜：守护进程用 `fcntl` 记录锁防重复实例，运维脚本里一句 `flock -n lockfile -c 'app'`，两个 app 都起来了。谁错了？`/proc/locks` 里怎么看出来？

写成四段。机制：`flock`(2)/`flock`(1) 与 `fcntl` 记录锁是内核里两套完全独立的机制，冲突检测互不执行；`lockf()` 与 `fcntl` 同属记录锁一套。证据与修法都要落到能当场跑的动作上（本机实测：`lockfile` 持有 POSIX 写锁期间，`flock -n 同一文件 -c true` 照样拿到锁、退出码 0；`/proc/locks` 里 `FLOCK` 与 `POSIX` 两类条目并存互不阻挡）。

::: sol 解答

现象：双实例同时跑，两边日志都宣称「拿到锁」。机制：`flock`(2) 与 `fcntl` 记录锁在内核里是两套独立实现（`flock` 归打开文件描述、记录锁归进程 + inode），冲突检测各查各的表，永远不跨表报错；这不是 bug，是 man 2 flock 的 BUGS 段写明的行为。`lockf()` 是 `fcntl` 的包装，和记录锁同套，但与 `flock` 依旧互不知情。所以「挡不住」的第一排查项不是锁没加，是**加的不是同一套**。证据：`grep ":$(stat -c %i 锁文件) " /proc/locks` 看到同一 inode 同时挂 `FLOCK` 与 `POSIX` 两行；`lslocks` 的类型列直接可读（本机实测：`lockfile` 持 POSIX 锁期间 `flock -n` 拿到锁退出 0）。修法：全项目锁死一套并写进文档；新代码优先 OFD（与记录锁互通、归属比 `flock` 干净、比 POSIX 少「关任意 fd」坑）；跨机器场景别忘了锁只对**同机**的 inode 有效，NFS 上的语义另有一套。

**判据**：四段齐全；「两套锁各查各表」说成机制不是玄学；`/proc/locks`/`lslocks` 证据可当场跑；修法收敛到「一个程序只用一套」。

:::
:::

::: ex 例 2.3-B3 · `mmap` 后进程被信号 7 杀掉：不是越界 {#ex-2.3-B3}

先猜：程序 `mmap` 一个共享文件，运行到某次访问崩了；`dmesg` 拿不到（本机被 `dmesg_restrict` 挡住），core 里的信号是 `SIGBUS` 而不是 `SIGSEGV`。第一反应怀疑什么？为什么「数组越界」的解释在这里不成立？

写成四段，落到 2.3.10 的分界表：`SIGBUS` 说明地址在映射长度内、但落在文件 EOF 之后的整页——最常见的成因为别的进程 `ftruncate` 了文件、或映射时文件本来就比 `length` 短；`read` 在同一情形只是返回 0，所以用 `read` 写的代码迁移到 `mmap` 时不会带着这个假设。修法的两条路（访问前 `fstat` 重查 `st_size`、文件锁防截断）与各自的失效场景（`fstat` 与访问之间仍可能被截断——检查不是原子的，又回到本章主线）要说明白。

::: sol 解答

现象：`SIGBUS`(7) 而非 `SIGSEGV`(11)。机制：`SIGSEGV` 是「地址不属于任何 VMA」，`SIGBUS` 是「地址属于你、背后的对象不在了」——内核缺页路径在 `filemap_fault` 发现请求页整页超出当前 `i_size` 时返回 `VM_FAULT_SIGBUS`。本机实测：映射 2 页、文件 4000 B，`u[4050]` 读 0、`u[6000]` `SIGBUS`、`u[100000]` `SIGSEGV`；正文 `mmap_bus` 复现「截断到 4 KiB 后访问第 5 KiB」，子进程 `child killed by signal 7 (Bus error)`。证据动作：`strace` 下启动看有没有别人的 `ftruncate`/`open(O_TRUNC)`；比对映射长度与当下 `st_size`；`/proc/PID/maps`（自己的进程）确认 VMA 边界。修法：要么「`fstat` → 只在 `st_size` 范围内访问」并把截断当常态重查，要么加记录锁/OFD 锁让截断者排队；追求绝对安全的用 `read` + 短读循环。信号处理器里 `siglongjmp` 跳出属于受限技巧，不当正路。

**判据**：信号即线索（7 vs 11 各指向什么）说清；「同页尾部可读 0」这个缓冲带提到；证据列的是动作不是愿望；修法里承认 `fstat` 检查本身不是原子的。

:::
:::

::: ex 例 2.3-B4 · 发布后读到半个文件，或干脆没换过来 {#ex-2.3-B4}

先猜：配置「发布」脚本用了临时文件 + `rename`，断电重启后读到半个 JSON；另一台机器上同样的脚本报 `EXDEV`。两个事故各自缺了哪一步？shell 里 `mv` 跨文件系统能成功，为什么 C 代码里 `rename` 不行？

写成四段：机制层「`rename` 原子替换目录项，但目录项本身是元数据、也要落盘」；「跨文件系统 `rename` 是语义上不可能原子，直接 `EXDEV`(18)」；证据：本机 `python3 os.rename("/tmp/…", "/dev/shm/…")` 报 `errno=18 Invalid cross-device link`，而 `mv` 同一条路径却成功——因为 `mv` 检测到 `EXDEV` 后退化成「复制 + 删除」，原子性归零，这恰是发布代码不能交给 `mv` 的理由；修法：四步顺序（同目录 `O_CREAT|O_EXCL` 临时文件 → 写完 `fsync(fd)` → `close` → `rename` → 打开父目录 `fsync`）+ `O_TMPFILE` 变体（`linkat` 走 `/proc/self/fd/N`）。

::: sol 解答

半个 JSON 来自「内容落盘了但读端在替换前打开了旧 fd」或「根本没 `fsync`，崩溃时新文件半页在缓存里」；名字没换过来来自缺目录 `fsync`：`rename` 改的是目录项，目录本身也要 `fsync`，否则回来「内容在、名字还是旧的」。`EXDEV` 缺的是「同文件系统」前提：临时文件必须与目标同目录（放 `/tmp` 是新手事故重灾区，本机 `/tmp` 在 ext4、`/dev/shm` 是 tmpfs，跨这两条就够）。`mv` 的成功不是反例而是陷阱：它的 fallback 是逐块复制，崩溃留下半个目标文件，等于回到 `O_TRUNC` 的原点。`O_TMPFILE` 建「有 inode、没目录项」的临时文件，写完两条链接路径：`linkat(fd, "", dfd, name, AT_EMPTY_PATH)` 需要 `CAP_DAC_READ_SEARCH`（本机没有，报 `EPERM` 是文档级预期），普通进程走 `linkat(AT_FDCWD, "/proc/self/fd/N", ...)`；`rename` 成功后 `unlink(tmp)` 是 `ENOENT`，别当错误处理。

**判据**：两种事故定位到两步不同的 `fsync`；`EXDEV` 的数值（18）与「mv 会掩盖它」都说出；四步顺序一步不乱；`O_TMPFILE` 至少给一条普通进程可用的链接路径。

:::
:::

::: ex 例 2.3-B5 · 锁莫名消失：close 了「另一个」fd {#ex-2.3-B5}

先猜：库 A 在 fd 7 上给状态文件加了 `fcntl` 写锁；业务代码后来 `open` 了同一个文件、用完 `close(fd 12)`；几秒后第二个实例加锁成功，双实例并发写。fd 12 和锁有什么关系？换成 OFD 锁还会发生吗？

写成四段。机制：POSIX 记录锁归「进程 + inode」，不属于某个 fd——关闭该 inode 上**任意**一个 fd 会释放该进程在这个文件上的全部记录锁（man 2 fcntl 明文；这是历史设计缺陷，Glibc 的 `lockf` 同样中招）。本机实测：同一进程 fd a 持写锁、fd b 只是开着没加锁，`close(b)` 之后另一个进程加锁成功——锁随无关 fd 的关闭蒸发。OFD 锁归打开文件描述，`close(b)` 伤不到 a 的锁（本机 a 的 OFD 锁在 `close(b2)` 后仍与子进程冲突、`/proc/locks` 报 `OFDLCK ... -1 ... EOF`）；`dup` 出的引用要全部关完才释放。修法：库内加锁后禁止再 open 同一文件（做不到就几乎必须 OFD）、或 `flock`；守护进程锁选一套写死。

::: sol 解答

现象：锁「自己没了」，日志里没有任何解锁调用。机制：见上——POSIX 锁的归属模型让它跟进程而不是跟 fd 走，`close` 是该进程对该 inode 的「最后一次引用」以外的动作也照样触发全量释放；同进程不同 fd 之间锁还会**合并**（本机第二 fd 加锁返回 0），所以「加锁成功」在自己进程内根本不是互斥证据，`F_GETLK` 也看不到自己的锁（实测 `l_type` 被改回 `F_UNLCK`(2)）。证据动作：`grep ":$(stat -c %i 文件) " /proc/locks` 前后各看一次；strace 抓 `close` 序列。修法三条按侵入性排序：改用 OFD（语义最接近「我想要的那把锁」）、或 `flock` + 纪律、或代码层保证「加锁的 fd 永不关闭、别人不许再 open」。顺带记住 `fork`：子进程不继承记录锁但共享 `flock`/OFD。

**判据**：定位到「关任意 fd 释放全部」而不是并发 bug；「同进程合并 + F_GETLK 看不见自己」两条自查陷阱提到；OFD 为何免疫说清；证据给的是当场可跑的 grep。

:::
:::

## C 组 · 动手实验

::: ex 例 2.3-C1 · 追加、偏移与 `F_SETFL` 的实测边界 {#ex-2.3-C1}

先猜：`F_SETFL` 加 `O_APPEND` 改得动吗？对 `O_RDONLY` 的 fd 用 `F_SETFL` 设 `O_RDWR` 之后 `write` 能过吗？`O_APPEND` 的 fd 上 `pwrite(fd,"BBBB",4,0)` 之后文件是什么？

本实验跑三件事：正文 2.3.3 的 `iov_log.c`（原样编译运行）；`F_SETFL` 对行为位/访问位的不同待遇；`pwrite` + `O_APPEND` 的静默追加。

::: sol C1 核对

```bash
mkdir -p /tmp/lab2c03_work && cd /tmp/lab2c03_work
# ① 正文程序：从 ch03.md 2.3.3 抄 iov_log.c 存为 lab2c03_iov_log.c
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c03_iov_log.c -o lab2c03_iov_log
timeout 10 ./lab2c03_iov_log
# ② 边界探针，存为 lab2c03_append.c：
cat > lab2c03_append.c <<'EOF'
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
int main(void) {
    char path[] = "/tmp/lab2c03_work/lab2c03_append.bin";
    unlink(path);
    int fd = open(path, O_RDWR | O_CREAT | O_TRUNC | O_CLOEXEC, 0644);
    int fl = fcntl(fd, F_GETFL);
    printf("F_SETFL|O_APPEND: rc=%d, now=%s\n",
           fcntl(fd, F_SETFL, fl | O_APPEND),
           (fcntl(fd, F_GETFL) & O_APPEND) ? "SET" : "CLEAR");
    int rd = open(path, O_RDONLY);
    printf("F_SETFL|O_RDWR on O_RDONLY: rc=%d, mode_bits=0%o\n",
           fcntl(rd, F_SETFL, fcntl(rd, F_GETFL) | O_RDWR),
           fcntl(rd, F_GETFL) & O_ACCMODE);
    errno = 0;
    printf("write on it: n=%zd errno=%d (%s)\n",
           write(rd, "x", 1), errno, strerror(errno));
    close(rd);
    if (write(fd, "AAAA", 4) != 4) perror("write");
    errno = 0;
    printf("pwrite(off=0, BBBB): n=%zd errno=%d\n",
           pwrite(fd, "BBBB", 4, 0), errno);
    fsync(fd); close(fd);
    fd = open(path, O_RDONLY);
    char buf[16] = {0};
    ssize_t n = read(fd, buf, 15);
    printf("content=%s (n=%zd)\n", buf, n);
    close(fd);
    return 0;
}
EOF
cc -std=c17 -Wall -Wextra -O2 lab2c03_append.c -o lab2c03_append
timeout 10 ./lab2c03_append
```

本机读数：① `seq=1 len=34 body=disk full on /var; retry scheduled`（注意正文代码注释写的是 `len=30`，字符串实际 34 字节，见[勘误页](ch03-errata.md)复跑校正）；② `F_SETFL|O_APPEND: rc=0, now=SET` → `F_SETFL|O_RDWR on O_RDONLY: rc=0, mode_bits=00` 且 `write ... errno=9 (Bad file descriptor)`；`pwrite` 后 `content=AAAABBBB`。看到什么算对：行为位改得动、访问位「返回 0 但没改」、追加语义吃掉显式偏移，三件事同时复现即过；顺手记下 `len=34`，这是「注释里的数字不是实测」的现场教材。

**判据**：三条读数与机制一一对应；能解释为什么 `mode_bits=00` 却 `rc=0`；能解释 `AAAABBBB` 里 `BBBB` 为什么不在开头。

:::
:::

::: ex 例 2.3-C2 · 对齐的两张面孔：`mmap` 的 EINVAL 与 `O_DIRECT` 三项对齐 {#ex-2.3-C2}

先猜：`mmap` 的 `offset=100` 报什么？`O_DIRECT` 的三项对齐（缓冲区地址、文件偏移、长度）各自要求对齐到多少——是 `st_blksize` 的 4096 还是别的？`off=512、len=512` 的组合能过吗？

一段程序把两组对齐全测出来：`mmap` 参数检查（offset/length/ANON）+ prot×fd 模式矩阵；`O_DIRECT` 在 ext4 上跑一个 offset×长度×缓冲区的小矩阵，再看 tmpfs 上的 `open(O_DIRECT)`。

::: sol C2 核对

```bash
cd /tmp/lab2c03_work
cat > lab2c03_align.c <<'EOF'
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <unistd.h>
static void mm(const char *tag, size_t len, int prot, int flags, int fd, off_t off) {
    errno = 0;
    void *p = mmap(NULL, len, prot, flags, fd, off);
    printf("%-34s -> %s errno=%d\n", tag, p == MAP_FAILED ? "FAIL" : "ok", errno);
    if (p != MAP_FAILED) munmap(p, len ? len : 4096);
}
static void od(int fd, void *buf, size_t len, off_t off, const char *tag) {
    errno = 0;
    ssize_t n = pread(fd, buf, len, off);
    printf("%-34s -> %s errno=%d\n", tag, n == -1 ? "FAIL" : "ok",
           n == -1 ? errno : 0);
}
int main(void) {
    unlink("/tmp/lab2c03_work/lab2c03_align.bin");
    int fd = open("/tmp/lab2c03_work/lab2c03_align.bin",
                  O_RDWR | O_CREAT | O_TRUNC, 0644);
    if (ftruncate(fd, 1024 * 1024) == -1) { perror("ft"); return 1; }
    struct stat st; fstat(fd, &st);
    printf("st_blksize=%ld\n", (long)st.st_blksize);
    mm("mmap offset=100",            4096, PROT_READ, MAP_PRIVATE, fd, 100);
    mm("mmap length=0",              0,    PROT_READ, MAP_PRIVATE, fd, 0);
    mm("ANON offset=100",            4096, PROT_READ,
       MAP_PRIVATE | MAP_ANONYMOUS, -1, 100);
    int rd = open("/tmp/lab2c03_work/lab2c03_align.bin", O_RDONLY);
    int wr = open("/tmp/lab2c03_work/lab2c03_align.bin", O_WRONLY);
    mm("RDONLY+SHARED+PROT_WRITE",   4096, PROT_READ | PROT_WRITE,
       MAP_SHARED, rd, 0);
    mm("RDONLY+PRIVATE+PROT_WRITE",  4096, PROT_READ | PROT_WRITE,
       MAP_PRIVATE, rd, 0);
    mm("WRONLY+SHARED+PROT_WRITE",   4096, PROT_READ | PROT_WRITE,
       MAP_SHARED, wr, 0);
    close(rd); close(wr);
    int dfd = open("/tmp/lab2c03_work/lab2c03_align.bin", O_RDWR | O_DIRECT);
    void *abuf;
    if (posix_memalign(&abuf, 4096, 16384) || !abuf) return 1;
    memset(abuf, 'S', 16384);
    if (pwrite(dfd, abuf, 4096, 0) != 4096) perror("seed");
    od(dfd, abuf, 4096, 0,    "DIRECT 4096@0（基准）");
    od(dfd, abuf, 4096, 1,    "DIRECT off=1");
    od(dfd, abuf, 4096, 512,  "DIRECT off=512");
    od(dfd, abuf, 4096, 256,  "DIRECT off=256");
    od(dfd, abuf, 512,  0,    "DIRECT len=512");
    od(dfd, abuf, 100,  0,    "DIRECT len=100");
    od(dfd, (char*)abuf + 64, 4096, 0, "DIRECT buf+64");
    od(dfd, (char*)abuf + 512, 4096, 0, "DIRECT buf+512");
    close(dfd);
    errno = 0;
    int t = open("/dev/shm/lab2c03_direct.bin",
                 O_RDWR | O_CREAT | O_TRUNC | O_DIRECT, 0644);
    printf("tmpfs open O_DIRECT -> %s errno=%d\n", t == -1 ? "FAIL" : "ok", errno);
    if (t != -1) close(t);
    close(fd);
    return 0;
}
EOF
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -O2 lab2c03_align.c -o lab2c03_align
timeout 15 ./lab2c03_align
```

本机读数（ext4、内核 7.0.0-38）：`st_blksize=4096`；mmap 三行全 `FAIL errno=22`，prot 矩阵 `RDONLY+SHARED` 报 13（`EACCES`）、`RDONLY+PRIVATE` ok、`WRONLY+SHARED` 报 13；`O_DIRECT` 基准 ok，`off=1`/`off=256`/`len=100`/`buf+64` 全 `errno=22`，而 `off=512`/`len=512`/`buf+512` 全部 **ok**——这台机器上 `O_DIRECT` 的对齐粒度是 **512 字节**（设备逻辑块），不是 `st_blksize` 的 4096；tmpfs `open(O_DIRECT)` 在本内核也成功返回。看到什么算对：`mmap` 的「页」粒度（4096，报错 22）与 `O_DIRECT` 的「512」粒度同时复现，且你能说出两个数字来源不同。

**判据**：两个对齐粒度数值各报对；prot×模式三格结论对；能说「正文示例的 posix_memalign(4096) 是保守写法，不是最低要求」；换文件系统/内核版本读数会变，先跑再用（见[勘误页](ch03-errata.md)）。

:::
:::

::: ex 例 2.3-C3 · 单实例锁：exit=2 与 `/proc/locks`、`lslocks` 取证 {#ex-2.3-C3}

先猜：第二个实例退出码是几？`/proc/locks` 里那行的设备号列在本机是多少？锁文件被 `flock`(1) 命令的持有者挡得住吗？

正文 2.3.6 的 `lockfile.c` 跑起来，用三种工具看同一把锁：`/proc/locks`、`lslocks`、`flock -n`。

::: sol C3 核对

```bash
cd /tmp/lab2c03_work
# 从 ch03.md 2.3.6 抄 lockfile.c 存为 lab2c03_lockfile.c
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c03_lockfile.c -o lab2c03_lockfile
L=/tmp/lab2c03_work/lab2c03_demo.lock
(timeout 8 ./lab2c03_lockfile "$L" >/dev/null 2>&1 &)
sleep 0.5
./lab2c03_lockfile "$L"; echo "exit=$?"          # 期望 2
INO=$(stat -c %i "$L")
grep ":$INO " /proc/locks                        # 按 inode 查，不是按文件名
lslocks | grep lab2c03_demo
timeout 5 flock -n "$L" -c 'echo "flock(1) 也拿到了"'; echo "flock_rc=$?"
```

本机读数：第二个实例 `another instance holds …` + `exit=2`；`/proc/locks` 一行形如 `1: POSIX  ADVISORY  WRITE <PID> 08:02:<inode> 0 EOF`——设备号是 `08:02`（正文示例的 `08:01` 属于别的机器），PID 与 inode 每次都会变，所以 `grep 文件名 /proc/locks` 永远查不到，这一列只有 inode 号；`lslocks` 显示 `lab2c03_lockfi <PID> POSIX WRITE 0 0 0 /tmp/.../lab2c03_demo.lock`；`flock(1)` **照样拿到锁**（`flock_rc=0`）——两套锁互不知情的命令行版证据。看到什么算对：三件同时成立（exit=2、按 inode 查到 POSIX 行、flock 拿到锁）。

**判据**：会按 inode 查 `/proc/locks`；能背出八列顺序；`flock -n` 拿锁不意外而是预期；知道 `lockfile` 会睡 30 秒所以必须 `timeout` 或换持锁时长。

:::
:::

::: ex 例 2.3-C4 · 原子发布四步与两次 `fsync`、`EXDEV` 的真实形状 {#ex-2.3-C4}

先猜：`strace` 里能数到几次 `fsync`？第二次 `fsync` 的参数为什么可能和第一次同为 4？跨 `/tmp` → `/dev/shm` 的 `rename` 报什么、`mv` 为什么看起来能成？

正文 2.3.7 的 `publish.c` 在 strace 下跑一遍，再用 `python3` 直接调 `rename(2)` 看 `EXDEV`。

::: sol C4 核对

```bash
cd /tmp/lab2c03_work
# 从 ch03.md 2.3.7 抄 publish.c 存为 lab2c03_publish.c
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c03_publish.c -o lab2c03_publish
rm -f lab2c03_app.conf
timeout 20 strace -e trace=%file,fsync ./lab2c03_publish \
    /tmp/lab2c03_work/lab2c03_app.conf '{"workers":8}' 2>&1 | \
    grep -E 'fsync|rename|O_TMPFILE|\.tmp'
python3 -c 'import os
try:
    os.rename("/tmp/lab2c03_work/lab2c03_app.conf", "/dev/shm/lab2c03_app.conf")
except OSError as e:
    print("rename errno=%d %s" % (e.errno, os.strerror(e.errno)))'
touch /tmp/lab2c03_work/lab2c03_rf.txt
mv /tmp/lab2c03_work/lab2c03_rf.txt /dev/shm/lab2c03_rf.txt && echo "mv 成功（但走的是复制）"
```

本机读数：strace 里两次 `fsync(4) = 0`——第一次是数据 fd，`close` 后目录被重新 `openat(O_RDONLY|O_CLOEXEC|O_DIRECTORY)` 又分到 4，所以两个 `fsync` 都写着 `(4)`，别以为漏了一次；替换动作打印成 `renameat(AT_FDCWD, "…tmp.PID", AT_FDCWD, "…conf") = 0`——aarch64 上**没有独立的 `rename` 系统调用**，glibc 走 `renameat`，`strace -e trace=rename` 抓不到它（本机实测：加了 `renameat2` 也不显示，必须 `%file` 类或显式 `renameat`）。`os.rename` 报 `errno=18 Invalid cross-device link`；`mv` 成功——它的 fallback 是复制+删除，不原子。看到什么算对：`published … bytes` + `cat` 到完整内容；两次 fsync；`renameat` 行；`errno=18` 与 `mv` 的反差。

**判据**：能解释「两个 fsync(4) 不是重复」；知道 `-e trace=rename` 在本机为什么是空的；`mv` 成功不构成可移植性证据；说得出目录 `fsync` 防的那一种崩溃。

:::
:::

::: ex 例 2.3-C5 · 搬运三家：`splice`、`copy_file_range` 与降级路径 {#ex-2.3-C5}

先猜：`splice` 文件→管道→文件一次调用能搬完 1 MiB 吗？`copy_file_range` 在本机同文件系统上返回多少？把它指向 `/dev/shm` 上的目标会返回什么——这算不算「跨文件系统一定 EXDEV」的反例？

正文 2.3.14 的 `zerocopy.c` 原样跑；再用 `dd`/`cmp` 验证搬运结果字节级一致。

::: sol C5 核对

```bash
cd /tmp/lab2c03_work
# 从 ch03.md 2.3.14 抄 zerocopy.c 存为 lab2c03_zerocopy.c
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c03_zerocopy.c -o lab2c03_zerocopy
timeout 20 ./lab2c03_zerocopy
# 手动验证：文件在 unlink 前对比（把源码末尾三行 unlink 注释掉再编译一次也可）
```

本机读数：`splice copied 1048576 bytes`、`copy_file_range copied 1048576 bytes`——注意正文代码为演示简洁都只调一次就拿到全量，是因为 1 MiB 没触发限制；生产代码必须按「返回 0 是 EOF、短计数继续循环」写（正文 `copy_range()` 的 `EXDEV`/`EOPNOTSUPP`/`ENOSYS` → 回退 `read`/`write` 就是降级路径的形状）。跨 fs 的 `copy_file_range`：本机 `/tmp` → `/dev/shm` 的组合随内核版本变化（5.3+ 允许部分场景回退为通用复制），本套件没有逐内核复测，所以判据只要求你**在自己的机器上跑一次**并把结果记进[勘误页](ch03-errata.md)说的四段格式；无论结果如何，代码里都要写回退。看到什么算对：两行 copied 都是 1048576；`cmp zc_src.bin zc_dst.bin` 无差异。

**判据**：两个数值报得出；说出「省的是内核↔用户态两次拷贝，DMA（直接内存访问）一步不少」；`splice` 两端都非管道时 `EINVAL` 的约束讲得清；降级路径是默认配置不是兜底。

:::
:::

::: ex 例 2.3-C6 · 本机可用的缺页/驻留取证：`getrusage` 与 `smaps` 替代 `perf`/`fincore` {#ex-2.3-C6}

先猜：`mmap` 返回时读盘了吗？触碰 256 页会产生 256 次缺页吗？`perf stat -e page-faults` 在本机报什么？正文用 `grep mmap_demo /proc/$$/smaps` 为什么永远是空的？

一段程序在三个阶段各读一次 `getrusage(RUSAGE_SELF)` 的 `ru_minflt`/`ru_majflt`，再从自己的 `/proc/self/smaps` 里取该映射的 `Rss`；对照 perf 与 fincore 的报错。

::: sol C6 核对

```bash
cd /tmp/lab2c03_work
cat > lab2c03_pf.c <<'EOF'
#define _GNU_SOURCE
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <fcntl.h>
#include <unistd.h>
static void snap(const char *tag, const char *needle) {
    struct rusage ru;
    getrusage(RUSAGE_SELF, &ru);
    printf("%-26s minflt=%ld majflt=%ld", tag, ru.ru_minflt, ru.ru_majflt);
    if (needle) {                       /* 从自身 smaps 找 Rss */
        FILE *f = fopen("/proc/self/smaps", "r");
        char line[512]; int hit = 0;
        while (fgets(line, sizeof line, f)) {
            if (strstr(line, needle)) { hit = 1; continue; }
            if (hit && !strncmp(line, "Rss:", 4)) { printf("  %s", line); break; }
        }
        fclose(f);
    } else printf("\n");
}
int main(void) {
    const char *path = "/tmp/lab2c03_work/lab2c03_pf.bin";
    unlink(path);
    int fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0644);
    size_t mb = 1024 * 1024;
    if (ftruncate(fd, mb) == -1) { perror("ft"); return 1; }
    snap("baseline", NULL);
    volatile char *p = mmap(NULL, mb, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (p == MAP_FAILED) { perror("mmap"); return 1; }
    snap("after mmap() only", "lab2c03_pf.bin");
    p[0] = 'X'; p[4096] = 'X'; p[8192] = 'X';   /* 只触碰 3 页 */
    snap("touch 3 pages", "lab2c03_pf.bin");
    for (size_t i = 0; i < mb; i += 4096) p[i] = 'Y';
    snap("touch all 256 pages", "lab2c03_pf.bin");
    return 0;
}
EOF
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -O2 lab2c03_pf.c -o lab2c03_pf
timeout 15 ./lab2c03_pf
timeout 10 perf stat -e page-faults true 2>&1 | head -3
command -v fincore || echo "fincore 未安装"
```

本机读数：`mmap()` 本身不产生读盘（majflt 不涨、`Rss` 0 kB）；只触碰 3 页时 `Rss: 12 kB`；触碰全部 256 页后 `Rss: 1024 kB`，而 `minflt` 总增量远小于 256（内核 fault-around 一次映射多页；另一次以 `PROT_READ|MAP_PRIVATE` 复跑时 62→73→85、majflt=1）——「缺页数 = 访问页数」的直觉在本机就不成立。`perf stat -e page-faults true` 报 `No supported events found`（`perf_event_paranoid`=4），`perf stat true`（不带 `-e`）倒是能退出但计数列 `<not supported>`；`fincore` 未安装。`grep mmap_demo /proc/$$/smaps` 为空的原因：`$$` 是 shell 自己的 PID，读的是 shell 的 smaps——要看就读被观察进程的 `/proc/PID/smaps` 或在程序内读 `/proc/self/smaps`。看到什么算对：三档 `Rss`（0/12 kB/1024 kB）+ minflt 增幅明显小于页数 + perf 的两条报错形状。

**判据**：能区分「建映射便宜、第一次访问才付费」并用读数佐证；知道 fault-around 让缺页数不可当常量背；perf/fincore 不可用时报出替代路径而不是编数。

:::
:::
