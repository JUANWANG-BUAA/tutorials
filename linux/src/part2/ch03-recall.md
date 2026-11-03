# 2.3 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。24 张卡分三组：**A 组考骨架八个能力点（2.3.1–2.3.8）**，**B 组考映射全表、缺页与共享对象（2.3.9–2.3.12）**，**C 组考空间、锁、内核与取证（2.3.5、2.3.13–2.3.19）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 骨架：fcntl、dup、偏移与映射模型

::: method 回忆 1 · `fcntl` 的五类操作与第三参数
`fcntl(fd, cmd, ...)` 的五类 `cmd` 各是什么、第三参数各是什么类型、成功各返回什么？为什么编译器管不了这个函数？
::: sol 答案
五类：读文件状态 flags（`F_GETFL`，无第三参数，返回 flags）；改文件状态 flags（`F_SETFL`，`int flags`，返回 0）；读/改 fd 标志（`F_GETFD`/`F_SETFD`，`int`，返回 flags/0）；复制 fd（`F_DUPFD`/`F_DUPFD_CLOEXEC`，`int` 是**新 fd 的下界**，返回新 fd）；记录锁（`F_GETLK`/`F_SETLK`/`F_SETLKW`，`struct flock *`，返回 0；Linux 上还有 `F_OFD_*` 与 `F_ADD_SEALS`/`F_GET_SEALS`）。第三参数的类型由 `cmd` 决定，是可变参数，编译器不做类型检查，传错就是未定义行为——所以每个 `cmd` 的签名要背下来，不能靠提示。
:::
:::

::: method 回忆 2 · `F_SETFL` 的三个坑
哪三个标志改不了？`fcntl(fd, F_SETFL, O_NONBLOCK)` 错在哪？「读-改-写」本身有什么问题？
::: sol 答案
访问模式（`O_RDONLY`/`O_WRONLY`/`O_RDWR`）在 `open` 时定死，`F_SETFL` 只能改行为位：`O_APPEND`、`O_NONBLOCK`、`O_ASYNC`、`O_DIRECT`、`O_NOATIME`。三个坑：① 直接写 `fcntl(fd, F_SETFL, O_NONBLOCK)` 会把 `O_APPEND` 等其他位一起清掉，必须先 `F_GETFL` 再或上；② 以为 `F_SETFL` 能改访问模式——不能，内核静默忽略那几个位，返回 0 但 fd 仍然只读；③ `F_GETFL` + `F_SETFL` 不是原子的，两个线程同时读-改-写会丢更新，所以要么启动时一次设好，要么用互斥锁保护。本机实测的一条对照：先用 `F_SETFL(flags | O_APPEND)` 把追加位**加上**（改得动），再对这个 fd 调 `pwrite(fd, "BBBB", 4, 0)`，结果内容是 `AAAABBBB`、`errno` 为 0——追加位属于能改的行为位，而偏移被内核忽略；访问模式那三位无论怎么 `F_SETFL` 都不生效。
:::
:::

::: method 回忆 3 · `FD_CLOEXEC` 与 `F_DUPFD_CLOEXEC`
fd 标志有几位有意义？为什么「事后补 `FD_CLOEXEC`」有风险？`F_DUPFD_CLOEXEC` 的第三参数是什么，常被误当成什么？
::: sol 答案
只有 `FD_CLOEXEC` 一位有意义（`exec` 时关闭这个 fd）。三种设置方式：`open(..., O_CLOEXEC)` 在创建时原子设置；`fcntl(fd, F_SETFD, fdflags | FD_CLOEXEC)` 事后补；`F_DUPFD_CLOEXEC` 复制时带上。事后补有竞态窗口：`F_GETFL`→`F_SETFD` 两步之间，另一个线程可能已经 `fork` + `exec`，fd 就漏给了子程序——多线程程序必须用前两种原子写法。`F_DUPFD_CLOEXEC` 的第三参数是「新 fd 的下界」不是「指定的号」：`fcntl(fd, F_DUPFD_CLOEXEC, 3)` 返回 ≥3 的**最小可用** fd，很多人把它当 `dup2` 用，结果拿到的不是自己想要的号。
:::
:::

::: method 回忆 4 · `dup`、`dup2`、`dup3` 各复制什么
`dup` 家族复制的是 fd 表项还是打开文件描述？两个 fd 共享哪三样？`dup2` 为什么比 `close`+`dup` 安全？`dup2(fd, fd)` 与 `dup3(fd, fd, ...)` 分别怎样？
::: sol 答案
复制的是**进程 fd 表里的表项**，不新建 `struct file`，所以两个 fd 共享偏移 `f_pos`、状态 flags 和 `flock` 锁。`dup2(oldfd, newfd)` 的关键是**原子**：`close(1); dup(fd);` 之间另一个线程能抢走 fd 1，`dup2(fd, 1)` 一步完成关闭与复制；`newfd` 已打开时先原子关闭。`dup2(fd, fd)` 直接返回 `fd`（不做任何事），`dup3` 同参数相等返回 `EINVAL`。`dup3` 的 `flags` 只接受 `O_CLOEXEC`。用 `dup2` 重定向 stdout 前后都要 `fflush(stdout)`：它只换 fd，不搬 stdio 缓冲区，不刷就把旧缓冲写进新目标。
:::
:::

::: method 回忆 5 · `pread`/`pwrite` 消灭的是哪类竞态
两个线程共用一个 fd 都用 `lseek`+`read` 会出什么问题？`pread` 为什么没这个问题？它的错误码有哪些？Linux 上 `pwrite` 与 `O_APPEND` 有什么不守规矩的行为？
::: sol 答案
`lseek` 改的是共享的 `f_pos`：线程 1 定位到 100、线程 2 定位到 200，线程 1 再读就从 200 开始，数据错位。`pread(fd, buf, n, offset)` 把偏移当参数、**不改变 `f_pos`**，天然无竞态，这也是多线程共用一个 fd 的正确写法。返回值与 `read`/`write` 一样可能短读短写；`errno`：`EBADF`、`EINVAL`（负偏移或 `O_DIRECT` 未对齐）、`ESPIPE`（管道/socket 没有偏移）、`EINTR`。Linux 的不守规矩之处：POSIX 规定 `pwrite` 忽略 `O_APPEND` 在指定偏移写，**Linux 不遵守**——带 `O_APPEND` 的 fd 做 `pwrite` 仍追加到末尾、`offset` 被忽略（本机实测：内容 `AAAA` 后 `pwrite(off=0, "BBBB")` 得到 `AAAABBBB`，`errno` 还是 0）。可移植代码别在 `O_APPEND` fd 上用 `pwrite`，或先清掉 `O_APPEND`。
:::
:::

::: method 回忆 6 · `readv`/`writev` 与短写后怎么办
`writev` 返回什么？`IOV_MAX` 是多少、从哪查？短写之后为什么不能重试整个数组，正确做法是什么？
::: sol 答案
`writev` 把多段缓冲区拼成一次 I/O，返回**总字节数**（不是段数），可能短读短写；`errno` 有 `EINVAL`（`iovcnt < 0` 或超过 `IOV_MAX`）、`EFAULT`、`EINTR`、`EAGAIN`。Linux 的 `IOV_MAX` 是 1024，本机 `sysconf(_SC_IOV_MAX)` 与 `getconf IOV_MAX` 都给 1024。短写后重试整个数组会把已经写出去的那段再写一遍，文件内容重复错位。正确做法是**推进 iovec**：每轮只提交剩余段（`&iov[i]`、`iovcnt - i`），按已写字节数整段跳过、并在中间那一段上把 `iov_base` 前移、`iov_len` 减小；`n == 0` 时置 `EIO` 退出，否则会死循环。
:::
:::

::: method 回忆 7 · `mmap` 的模型与两个硬约束
`mmap` 到底把什么带进进程？成功/失败各返回什么？`offset` 和 `length` 各有什么约束？哪些 `errno` 最常见？
::: sol 答案
`mmap` 在进程地址空间建一个 **VMA**（虚拟内存区域，内核里描述一段地址范围的表项 `vm_area_struct`），把 `[offset, offset+length)` 按页登记进来；访问映射区就是访问 page cache，缺页时由 `filemap_fault()` 读入。它既不「把文件读进内存」也不绕过内核。成功返回映射区首地址，失败返回 `MAP_FAILED`（`(void *)-1`），**不是 NULL**——按 NULL 判断会漏掉错误。两个硬约束：`offset` 必须是页大小（本机 4096）的整数倍，`length == 0` 不合法，两者都返回 `EINVAL`（本机实测 `offset=100` → `EINVAL`）；`length` 向上取整到页，最后一页超出 EOF 的部分读为 0、写回去不会扩展文件。常见 `errno`：`EACCES`（fd 模式与 `prot` 冲突）、`EINVAL`、`ENODEV`（文件系统不支持）、`ENOMEM`、`EOVERFLOW`。`mmap` 成功后可以立刻 `close(fd)`，映射仍然有效。
:::
:::

::: method 回忆 8 · `SIGBUS`：映射后文件被截断
什么条件下访问映射区收 `SIGBUS`？同样情况下 `read` 怎样？两种防御是什么？`mmap` 为什么不能把文件大小当不变式？
::: sol 答案
`mmap` 只建映射、不锁文件大小。若另一个进程 `truncate` 了文件，访问**超出新 EOF 的整页**会触发 `SIGBUS`（本机实测：映射 8 KiB、截断到 4 KiB 后访问第 5 KiB，子进程被信号 7 杀掉）；`read` 在同样情况下只返回 0。防御两条：访问前 `fstat` 比对 `st_size` 与映射长度；或安装 `SIGBUS` 处理器跳出并重建映射（`siglongjmp` 不在 async-signal-safe 列表里，只能受限使用）。更稳的做法是别把「文件不会被截断」当假设，除非你持有写锁。`msync`/`munmap` 的边界也在这段：`MS_SYNC` 等回写完成、`MS_ASYNC` 只排队、`MS_INVALIDATE` 让其他副本失效；`msync` 的 `addr` 必须页对齐否则 `EINVAL`（本机实测）；`munmap` 不保证写回。
:::
:::

## B. 映射全表、缺页与共享对象

::: method 回忆 9 · `MAP_*` 的分类与两个 `FIXED`
`flags` 里哪一位必须有且只有一个？`MAP_SHARED` 与 `MAP_PRIVATE` 的写各走到哪里？`MAP_FIXED` 与 `MAP_FIXED_NOREPLACE` 差在哪，为什么前者危险？
::: sol 答案
`MAP_SHARED`/`MAP_PRIVATE` 必须有且只有一个，其余是可选修饰位（`MAP_ANONYMOUS`、`MAP_FIXED`、`MAP_POPULATE`、`MAP_LOCKED`、`MAP_NORESERVE`、`MAP_HUGETLB`、`MAP_SYNC`…）。`MAP_SHARED` 的写直接改 page cache，最终回写文件、其他映射者看得见；`MAP_PRIVATE` 的写触发 COW（写时复制），改动只在本进程、**永不写回文件**。`MAP_FIXED` 会**静默解除**目标区间已有的映射再建立新的，用它去赌「这个地址应该空闲」会踩掉别人的映射；`MAP_FIXED_NOREPLACE`（Linux 4.17+）在区间被占用时返回 `EEXIST`。正确顺序是先用 `mmap(NULL, ...)` 建匿名保护区，再用 `MAP_FIXED` 覆盖其中一段。
:::
:::

::: method 回忆 10 · 四种映射类型与 `fork` 后的表现
私有/共享 × 文件/匿名四种组合各怎么创建、写操作去哪、`fork` 后父子看得见什么？哪一种最适合父子通信？
::: sol 答案
① 私有文件映射（`MAP_PRIVATE` + fd）：写走 COW，不写回文件，父子各自 COW；② 共享文件映射（`MAP_SHARED` + fd）：写 page cache、最终回写文件，父子共享同一物理页；③ 私有匿名映射（`MAP_PRIVATE|MAP_ANONYMOUS`）：本进程私有、初始为 0，父子 COW；④ 共享匿名映射（`MAP_SHARED|MAP_ANONYMOUS`）：所有映射者共享，`fork` 后父子共享同一块内存。第四种是 `fork` 后父子通信最便宜的方式之一——不需要文件、不需要 `shm_open`；要「有 fd、可传、可加 seal」就换 `memfd_create` + `MAP_SHARED`。`MAP_ANONYMOUS` 时 Linux 忽略 `fd`（传 0 或真实 fd 都能成功，本机实测），但可移植代码应传 -1；`offset` 仍需页对齐，否则 `EINVAL`。
:::
:::

::: method 回忆 11 · `prot` 与 fd 打开模式的精确规则
「`prot` 不能超过 fd 模式」这句话哪里不够精确？`O_RDONLY`、`O_WRONLY`、`O_RDWR` 三种 fd 在两种映射下各允许什么 `prot`？为什么没有「只写映射」？
::: sol 答案
`O_RDONLY`：`MAP_PRIVATE` 下任意 `prot`（写只影响私有副本，本机实测 `PROT_READ|PROT_WRITE` 成功）；`MAP_SHARED` 下只能 `PROT_READ`（可加 `PROT_EXEC`），要 `PROT_WRITE` 报 `EACCES`。`O_WRONLY`：两种映射下任何 `prot` 都 `EACCES`（本机实测）。`O_RDWR`：任意 `prot`。原因在硬件：很多架构不支持「只写可映射」的页，`PROT_WRITE` 隐含可读；而 `O_WRONLY` 的文件不允许读出初始内容，内核直接拒绝。`PROT_EXEC` 另受 `noexec` 挂载与 W^X 策略限制。`mprotect` 能把「先读写、后只读」和 guard page 做出来：`mmap(PROT_NONE)` 一块、只对中间段 `mprotect(PROT_READ|PROT_WRITE)`，访问 `PROT_NONE` 页报的是 `SIGSEGV`（本机实测信号 11）。
:::
:::

::: method 回忆 12 · `msync` 到底在同步什么
`MS_SYNC`/`MS_ASYNC`/`MS_INVALIDATE` 各保证什么？Linux 的统一页缓存让 `msync` 的主要作用变成什么？对 `MAP_PRIVATE` 调 `msync` 会怎样？
::: sol 答案
`MS_SYNC` 把脏页写回并**等待设备确认**；`MS_ASYNC` 只把改动交给页缓存排队，不保证落盘；`MS_INVALIDATE` 让其他缓存副本失效、下次访问重新从文件读。Linux 是统一页缓存（unified page cache，`mmap` 与 `read`/`write` 用的是同一份缓存），所以 `msync` 的主要作用是**强制回写**，而不是「让其他进程看见」——本机实测：`MAP_SHARED` 里改一个字节、不 `msync`，另一个 fd 的 `pread` 立刻读到新值。但 SUSv3 不要求统一页缓存，可移植程序在映射与 `read` 混用时仍要正确使用 `msync`/`MS_INVALIDATE`。对 `MAP_PRIVATE` 调 `msync(MS_SYNC)` 不会把修改写回文件，而且它**返回 0、不报错**（本机实测：返回 0 但 `pread` 仍是旧内容）——静默无效比报错更危险。
:::
:::

::: method 回忆 13 · `madvise`：哪几条不是提示
`MADV_SEQUENTIAL`/`WILLNEED`/`RANDOM`/`DONTNEED`/`FREE`/`DONTFORK` 各做什么？哪一条在 Linux 上是破坏性的？为什么可移植程序不该依赖它？
::: sol 答案
`MADV_SEQUENTIAL` 加大预读、`MADV_WILLNEED` 提前读进内存（不保证保留多久）、`MADV_RANDOM` 禁用预读、`MADV_DONTFORK` 让子进程不保留这段、`MADV_FREE`（Linux 4.5+）标记「可回收但先保留内容，等内存压力才丢」。破坏性的是 `MADV_DONTNEED`：在 Linux 上对 `MAP_PRIVATE` **匿名**映射它会丢弃页上的修改、下次访问读回 0；对文件私有映射则重新从文件读。Kerrisk 提醒可移植程序不该依赖这个语义，其他 UNIX 把它当成「建议换出」。本机实测 `mmap_ops`：`p[0]='B'` 后 `madvise(MADV_DONTNEED)`，再读 `p[0]` 变 0——业务数据上调用它等于数据丢失。
:::
:::

::: method 回忆 14 · `mlock`/`mlockall` 与 `mincore`
锁页花的是什么限制？锁在 `fork`/`exec`/`munmap` 时怎么变？同一页锁两次要几次解锁？`mincore` 返回 1 能用来做正确性判断吗？
::: sol 答案
非特权进程受 `RLIMIT_MEMLOCK` 软限制，超限 `mlock` 报 `ENOMEM`（或无 `CAP_IPC_LOCK` 时报 `EPERM`）；`mlock` 以页为单位，`addr` 不必页对齐（内核向下取整）、`len` 向上取整。锁**不被 `fork` 继承**，`exec` 时自动解除，`munmap` 或用 `MAP_FIXED` 覆盖也解除。锁不叠加：同一页 `mlock` 两次、`munlock` 一次就全解锁；但同一文件映射到两个地址分别加锁，要两次 `munlock`。`mlockall(MCL_FUTURE)` 会让后续 `mmap`/`sbrk` 失败，甚至栈增长触发 `SIGSEGV`。`mincore` 每页一个字节、bit0=1 表示当前驻留，但结果只是**快照**，返回后页随时可能被换出——适合监控与启发式，不能用于正确性判断。本机读数：`/proc/PID/status` 的 `VmLck` 与 `ulimit -l` 是 shell 视图；`getrlimit(RLIMIT_MEMLOCK)` 本机 cur=max=1562615808 字节，而 `sysconf(_SC_MEMLOCK)` 只给 200809——取限制要用 `getrlimit`。
:::
:::

::: method 回忆 15 · `mremap` 搬家与指针纪律
`mremap` 什么时候返回的地址和旧地址不一样？不带 `MREMAP_MAYMOVE` 空间不足会怎样？为什么映射里的指针不能存绝对地址？
::: sol 答案
带 `MREMAP_MAYMOVE` 时内核可以把映射搬到别处，返回值就是新起始地址、**可能不等于旧地址**；不带它且原地扩不开返回 `ENOMEM`。`MREMAP_FIXED`（要同时给 `MAYMOVE`）把映射搬到指定地址；`MREMAP_DONTUNMAP`（5.7+）搬走但保留旧映射，用于 `userfaultfd`。所以映射区里的数据结构只能用**偏移量**保存内部指针，不能存绝对地址——搬家后所有绝对指针失效。`realloc` 对大块 `mmap` 内存会走 `mremap`，避免整块复制。本机一条实测警告：正文的 `mmap_ops` 在这台内核 7.0.0-38 上跑到 `mremap` 直接失败（`Bad address`，`EFAULT`）——原因是它先前只 `mlock` 了这段 2 页 VMA 的**第一页**；单独验证：锁整段或先 `munlock` 再 `mremap` 都成功。见[勘误页](ch03-errata.md)的复跑校正。
:::
:::

::: method 回忆 16 · `memfd_create` 与五种 seal
`memfd` 和普通匿名映射、和 `/tmp` 文件比强在哪？五种 seal 各挡什么？`F_SEAL_WRITE` 什么时候报 `EBUSY`？seal 能撤销吗？
::: sol 答案
`memfd_create`（Linux 3.17）创建的是一个**匿名文件**：没有路径、只在 `/proc/PID/fd/N` 下可见，但可以 `mmap`、`write`、`fork` 继承、通过 `SCM_RIGHTS` 传给别的进程；不落盘也不依赖 `/tmp`。带 `MFD_ALLOW_SEALING` 后用 `fcntl(fd, F_ADD_SEALS, seals)` 加封印：`F_SEAL_SEAL` 禁止再添加任何 seal；`F_SEAL_SHRINK` 禁止 `ftruncate` 缩小；`F_SEAL_GROW` 禁止扩大；`F_SEAL_WRITE` 禁止写（新 `write` 报 `EPERM`、新建可写映射也报 `EPERM`）；`F_SEAL_FUTURE_WRITE` 允许已有可写映射继续写、只挡新的。`F_SEAL_WRITE` 要求当前没有可写映射，否则 `EBUSY`——这就是 `F_SEAL_FUTURE_WRITE` 存在的理由。**seal 一旦加上不可撤销**，所以它能把「内容不可变」变成内核强制，适合配置快照、共享库镜像、密封证书包。本机实测 `memfd_demo`：`seals=0xe`、`write` 与 `ftruncate` 都返回 `EPERM`(1)、只读映射与 `fork` 后的子进程都读到原内容。
:::
:::

## C. 空间、锁、内核与取证

::: method 回忆 17 · `fallocate` 的七种 mode 与 `posix_fallocate`
`fallocate` 与 `ftruncate` 的差别是什么？`PUNCH_HOLE` 为什么必须配 `KEEP_SIZE`？`COLLAPSE_RANGE`/`INSERT_RANGE` 有什么额外要求？`posix_fallocate` 有哪两点不一样？
::: sol 答案
`ftruncate` 只改逻辑大小，扩展部分可以是稀疏空洞、不占块；`fallocate` 真正分配磁盘块。mode：`0` 分配并把 `st_size` 至少扩到 `offset+len`；`FALLOC_FL_KEEP_SIZE` 只分配不改大小；`FALLOC_FL_PUNCH_HOLE` 把区间打成洞，**必须**与 `KEEP_SIZE` 合用否则 `EINVAL`；`FALLOC_FL_ZERO_RANGE` 清零（有些文件系统就是用写 0 实现）；`FALLOC_FL_COLLAPSE_RANGE` 删除区间并把后面前移、`INSERT_RANGE` 插入空洞并把后面后移，两者都要求**块对齐**否则 `EINVAL`；`UNSHARE_RANGE`（5.13+）解除 reflink 共享。`fallocate` 不改文件偏移、不走常规 page cache 写路径；失败有 `EOPNOTSUPP`、`ENOSPC`、`EDQUOT`、`EINVAL`、`EFBIG`、`EPERM`、`ETXTBSY`。`posix_fallocate(fd, offset, len)` 两点不同：它**返回错误码而不设 `errno`**（成功返回 0）；glibc 在 `fallocate` 系统调用（syscall）不被支持的文件系统上退化成逐块写 0，可能比普通写还慢。本机实测 ext4 与 tmpfs 都走 `fallocate` 系统调用（见[勘误页](ch03-errata.md)）。
:::
:::

::: method 回忆 18 · `O_DIRECT` 的三项对齐
`O_DIRECT` 绕过了什么、代价是什么？哪三个量必须对齐、不对齐报什么？什么时候该用、什么时候反而更慢？
::: sol 答案
`O_DIRECT` 绕过 page cache，代价是**对齐**：缓冲区地址、文件偏移、传输长度三者都必须是逻辑块大小（本机 `st_blksize`=4096）的整数倍，任一项不对齐返回 `EINVAL`（本机实测：`4096@0` 成功，`@1` 偏移、长度 100、非对齐地址三种都 `EINVAL`）。做法是 `posix_memalign(&buf, 4096, 4096)` 拿对齐缓冲，再用 `pread(fd, buf, 4096, 0)`。它适合自建缓存的数据库与 WAL 这类「我知道自己在管什么」的场景；普通应用用它通常更慢，因为没有页缓存也没有预读。`O_DIRECT` 也不能和 `mmap` 混着用（2.3.4 的 `think` 盒把这条列为「不适合 mmap 的场景」之一）。
:::
:::

::: method 回忆 19 · 三种锁的归属与释放时机
`flock`、POSIX 记录锁、OFD 锁各归属什么？`fork` 后各怎么表现？关闭一个 fd 各释放什么？为什么「`flock` 与 `fcntl` 混用」不互斥？
::: sol 答案
`flock` 归**打开文件描述**、锁整个文件；POSIX 记录锁（`F_SETLK`）归**进程 + inode**、锁字节区间；OFD 锁（`F_OFD_SETLK`，Linux 3.15+）归**打开文件描述**、锁字节区间。`fork` 后：`flock` 子进程共享同一把（父进程退出不会释放），POSIX 记录锁子进程**不继承**，OFD 锁子进程共享。关闭时：`flock` 只有最后一个引用关闭才释放；POSIX 记录锁**关闭该文件任意 fd 就释放全部**——一个库加的锁会被调用者关掉另一个 fd 时顺手释放，这是历史设计缺陷，OFD 锁正是为补它而来。冲突范围：`flock` 只与 `flock` 冲突，POSIX 与 OFD 互相冲突。本机实测四组：`flock`↔记录锁、`flock`↔OFD 两边都返回 0（互不认对方），记录锁↔OFD 与同类之间报 `EAGAIN`。结论是**一个程序只用一套**。
:::
:::

::: method 回忆 20 · `struct flock` 与三个 `cmd`
`l_len = 0` 是什么意思？`F_SETLK` 与 `F_SETLKW` 冲突时各怎样？`F_GETLK` 会加锁吗、能看到自己进程的锁吗？`lockf()` 是哪套的简写、有什么限制？
::: sol 答案
`struct flock` 五个字段：`l_type`（`F_RDLCK`/`F_WRLCK`/`F_UNLCK`）、`l_whence`（`SEEK_SET`/`CUR`/`END`）、`l_start`（相对起点）、`l_len`（**0 表示到文件末尾，含未来增长**）、`l_pid`（`F_GETLK` 返回持锁者）。`F_SETLK` 非阻塞，冲突返回 -1、`errno` 为 `EACCES` 或 `EAGAIN`（Linux 用 `EAGAIN`）；`F_SETLKW` 阻塞等待，可能被信号打断返回 `EINTR`，内核检测到死锁返回 `EDEADLK`（检测不是万能的，复杂环形等待还要靠超时）。`F_GETLK` **不加锁**，只报告：无人阻挡时把 `l_type` 改成 `F_UNLCK`，否则填入阻挡者信息，而且它只报告**其他进程**的锁，自己进程的锁不会出现。`lockf()` 是 `fcntl` 记录锁的旧式简写：`F_LOCK` 阻塞写锁、`F_TLOCK` 非阻塞、`F_ULOCK` 解锁、`F_TEST` 测试；它只能从**当前偏移**开始锁区间，不能指定起点，要锁任意区间仍得用 `struct flock`。锁与 stdio 的顺序固定为：加锁 → 写 → `fflush` → 解锁。
:::
:::

::: method 回忆 21 · 原子发布四步，每步防什么
写出配置发布的安全顺序，并说明每一步防的是哪一种崩溃。为什么临时文件必须与目标同目录？为什么 `rename` 之后还要 `fsync` 目录？`O_TMPFILE` 怎么省掉临时名字？
::: sol 答案
四步：① 在**目标同目录**用 `O_WRONLY|O_CREAT|O_EXCL|O_CLOEXEC` 建临时文件并写满；② `fsync(fd)` 让数据落盘；③ `close(fd)` 后 `rename(tmp, dst)` 原子替换；④ 打开父目录再 `fsync(dirfd)`。防的东西：`O_TRUNC` 直接改原文件会在崩溃时留下空文件或半个文件，先写新的、`rename` 保证 `dst` 要么旧要么新；第①步的 `O_EXCL` 防两个发布者互相覆盖；第②步防「名字换了、内容还在缓存里」；第④步防「新文件内容在、目录项没提交」，即名字还是旧的甚至两个名字都丢。跨文件系统 `rename` 返回 `EXDEV`，所以临时文件不能放 `/tmp`（本机实测 `/tmp` → `/dev/shm` 报 18）。`rename` 成功后临时名字已消失，`unlink(tmp)` 会 `ENOENT`，别当错误。`O_TMPFILE` 建的是没有目录项的 inode，写完用 `linkat(AT_FDCWD, "/proc/self/fd/N", ..., AT_SYMLINK_FOLLOW)` 链接进目录；`linkat(fd, "", ..., AT_EMPTY_PATH)` 更直接，本机两条都成功。
:::
:::

::: method 回忆 22 · `/proc/locks` 每列读什么
给一行 `/proc/locks`，说出八列各是什么；为什么 OFD 锁的 PID 是 -1？容器里能看到宿主机的锁吗？强制锁还能用吗？
::: sol 答案
八列依次是：序号、锁类型（`POSIX`/`FLOCK`/`OFDLCK`）、`ADVISORY`/`MANDATORY`、`READ`/`WRITE`、持有者 PID、`major:minor:inode`、起始字节、结束字节（`EOF` 表示到文件末尾）。OFD 锁的 PID 是 **-1**，因为锁属于打开文件描述而不是某个进程。`/proc/locks` 从 Linux 4.9 起按 PID 命名空间过滤，容器里看不到宿主机的锁。`lslocks` 的输出更易读（本机可用，直接给文件名）。**不要按 `MANDATORY` 设计程序**：强制锁在 Linux 5.15 已被移除，旧代码里「setgid + 关闭 group-execute」的技巧不再有效。锁也挡不住 `unlink`——有目录写权限就能删文件。本机一条纪律：`grep 文件名 /proc/locks` 取不到东西，因为这一列只有 inode 号没有路径，要用 `stat -c %i` 拿到 inode 再 `grep ":<ino> "`，或者直接用 `lslocks`。
:::
:::

::: method 回忆 23 · 四个零拷贝（省内核↔用户态拷贝）接口的限制与降级
`sendfile`、`splice`、`tee`、`vmsplice`、`copy_file_range` 各要求什么 fd 类型？返回 0 和短计数分别是什么意思？「零拷贝」到底省掉的是什么？
::: sol 答案
省掉的是**内核 ↔ 用户态**那两次拷贝；磁盘 ↔ page cache ↔ 网卡的 DMA 一步不少。`sendfile(out_fd, in_fd, offset, count)`：`in_fd` 必须是可 `mmap` 的文件，输出到 socket（2.6.33 起也可以是文件），不能 socket→socket；`offset == NULL` 会推进 `in_fd` 的偏移，非 NULL 则不改。`splice` 至少一端是管道，两端都不是管道返回 `EINVAL`；`flags` 有 `SPLICE_F_MOVE`/`NONBLOCK`/`MORE`。`tee` 在两个管道间复制、不消费源。`vmsplice` 把用户页「借」给管道，内核可能随时引用这些页，除非 `SPLICE_F_GIFT` 不能马上改或释放。`copy_file_range` 的 `flags` 必须为 0，同文件系统且支持 reflink（XFS/btrfs）时只复制元数据，ext4 可能退化成普通复制，老内核跨文件系统返回 `EXDEV`。五个接口都返回**实际传输字节数**，`0` 表示 EOF、短于请求要继续循环；收到 `EXDEV`/`EOPNOTSUPP`/`ENOSYS` 就退回 `read`/`write` 循环，别把 `copy_file_range` 当跨设备复制。本机实测 `zerocopy`：`splice copied 1048576 bytes`、`copy_file_range copied 1048576 bytes`。
:::
:::

::: method 回忆 24 · 内核路径与两条取证手段
`mmap` 在内核里经过哪几层、为什么建映射快而第一次访问慢？缺页的三个岔口分别去哪？拿到「映射没生效」这类问题时按什么顺序取证？本环境哪两条路被权限挡住？
::: sol 答案
建映射：系统调用入口 → `ksys_mmap_pgoff` → `vm_mmap_pgoff` → `do_mmap` → `mmap_region`（拿 `mmap_lock` 写锁）→ `vma_merge`/`vma_link` 插进 `mm_struct` 的 maple tree → `call_mmap` → 文件系统 `generic_file_mmap` 设置 `vm_ops`。`mmap` 只登记 VMA 不读页，`MAP_POPULATE` 才在建立时预缺页，所以调用本身便宜、第一次访问才贵。缺页走 `handle_mm_fault` → `__handle_mm_fault` → `do_fault`，三个岔口：读用 `do_read_fault` → `filemap_fault`（可能 `page_cache_sync_readahead` 读盘，`filemap_map_pages` 一次映射多页）；私有写用 `do_wp_page`（COW）；共享写用 `do_shared_fault` → `->page_mkwrite`（标脏等回写）。地址不在任何 VMA → `SIGSEGV`；在 VMA 内但超出 EOF 的整页 → `VM_FAULT_SIGBUS` → `SIGBUS`。`msync`/`fsync` 最终都落到 `vfs_fsync_range` → `file->f_op->fsync`。取证顺序五条：`strace -e trace=mmap,munmap,mprotect,msync` 看调用与 flags → `/proc/PID/maps` 看 VMA 权限与偏移 → `/proc/PID/smaps` 看 `Rss`/`Pss`/`Private_Dirty` → 收到 `SIGBUS` 就 `fstat` 比对 `st_size` → 收到 `SIGSEGV` 就查是否越过 `length` 或被 `mprotect` 改成 `PROT_NONE`。本环境两条限制：`perf` 被 `perf_event_paranoid`=4 挡住，缺页计数改用 `getrusage` 的 `ru_minflt`/`ru_majflt`；`fincore` 未安装，驻留看 `smaps` 或 `mincore`。`strace -p` 附着别的进程被 `ptrace_scope`=1 挡住，只能「在 strace 下启动」。
:::
:::
