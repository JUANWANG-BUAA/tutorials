# 2.3 勘误与版本注记

这一页收本章最容易「换一台机器、换一个内核、换一个架构、换一个挂载的文件系统就不成立」的东西：`O_*` 标志的八进制位、errno 的生效表头、`pwrite` 与 `O_APPEND` 的实现分歧、两套锁的互认边界、`mmap`/`O_DIRECT` 各自的对齐粒度、`/proc/locks` 与 `strace` 的输出形状、`fallocate` 在不同文件系统上的块账。正文里的 `errata` 盒讲**理解陷阱**（把 A 当成 B），这一页讲**搬家陷阱**（在这台机器成立、到那台机器悄悄变）。用之前先记住本章的三条纪律：**判断错误码写名字、要限制去运行时查、要读数回自己机器取**——这三条做对了，下面这张表大部分行都不需要背。

**本章基线**：本书测试虚拟机是 Ubuntu 24.04.5（**aarch64 / ARM64，不是 x86-64**）、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096，`/tmp` 在 ext4 根分区（`/dev/sda2`）、`/dev/shm` 是 tmpfs。`sudo` 与 `perf` 的事件计数不可用（`perf_event_paranoid`=4），`strace -p` 与读别人的 `/proc/PID/syscall` 被 `ptrace_scope`=1 挡住，`dmesg` 被 `dmesg_restrict`=1 挡住，`fincore` 未安装；可用：`cc`、`strace` 6.8、`lslocks`、`flock`(1)、`getconf`、`stat`、`/proc`。正文有四组读数是**别的机器的形状**：2.3.6 终端块 `/proc/locks` 的 PID `48211` 与设备号 `08:01`、2.3.17 的 `0x7f...` 地址形态与 `madvise` 行、2.3.13 的 `blocks=2056/1032`、2.3.3 注释里的 `len=30`；`mremap` 那一步在本机直接失败。它们不是「错」，但**不属于这台机器**——第 2 节是 2026-11-02 在这台 VM 上把正文十个程序逐个编译运行后的对照，本套件（回忆卡、习题集、自检表）引用的数值全部以那一节与第 1 节的本机实测为准。写作机是 Apple 芯片 macOS（arm64），没有 `/proc`、没有 `strace`、`fcntl.h` 里根本没有 `O_DIRECT`，只能读源码形状；跨机器对照一律标「未实测（本套件没有该机器）」。

## 1. 二十一条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「POSIX 说 `pwrite` 忽略 `O_APPEND`，所以在指定偏移写一定生效」 | Linux 的实现相反：带 `O_APPEND` 的 fd 做 `pwrite` 仍追加到末尾、`offset` 被静默忽略且不报错（man 2 pwrite 的 BUGS 段）。本机实测：`write` 4 个 `A` 后 `pwrite(off=0,"BBBB")` 得 `AAAABBBB`、返回 4、`errno`=0。反过来 `O_APPEND` 的原子性也只罩住「单次调用的定位+写」，跨多次 `write` 的一条记录照样交错 | 任何机器 10 行程序：`open(O_RDWR|O_CREAT)` → `write AAAA` → `pwrite BBBB @0` → 读回全文；再对照清掉 `O_APPEND` 后的结果（`pwrite` 才真按偏移写） |
| 「`flock` 与 `fcntl` 记录锁是同一把锁的两种 API，总该互相挡吧」 | 内核里两套独立实现，冲突检测各查各表：`flock` 只与 `flock` 冲突；记录锁与 OFD 锁互通；`flock` 与记录锁/OFD 混用**互不知情**（不是竞态窗口，是根本不检查对方表）。本机实测 3×3 跨进程矩阵：父持 `flock` 时别的进程记录锁/OFD 都成功，父持记录锁时 `flock` 成功 | 正文 `lockfile` 持锁期间跑 `flock -n 锁文件 -c true`（本机退出码 0）；或起两个进程分别用两套 API 打印各自的返回码 |
| 「OFD 锁跟 `flock` 一样，认的是那个 fd 号」 | OFD 锁归**打开文件描述**：`dup`/`fork` 出的引用共享同一把，只有该描述的最后一个引用关闭才释放；它锁的是字节区间且与 POSIX 记录锁互通。`/proc/locks` 里它的 PID 列显示 -1（锁不属于某个进程）。本机实测一行：`1: OFDLCK ADVISORY  WRITE -1 08:02:292604 0 EOF` | 同一 fd `dup` 后从副本 `F_OFD_SETLK(F_UNLCK)` 能解「原件」的锁；`cat /proc/locks` 看 -1；换 x86/旧内核设备号与 inode 都不同，只认形状 |
| 「`dup` 之后两个 fd 各有一套锁，互不相干」 | `dup` 复制的是表项不是对象：`flock` 与 OFD 锁在两个号之间**共享同一把**（本机实测从 dup 出的 fd `LOCK_UN` 返回 0）；`fcntl` 记录锁归进程，同进程两个 fd 的锁直接**合并**、谈不上挡。锁的复制差异全部由「归属」推出，不用背 | 对 `dup` 出的 fd 试 `flock(fd2, LOCK_EX|LOCK_NB)`——同进程不冲突；跨进程才见分晓 |
| 「`F_SETLK` 返回 0 就说明互斥生效了」 | 记录锁只在**进程之间**互斥：同一进程在第二个 fd 上再加写锁返回 0（合并），`F_GETLK` 从持锁进程自己查询也看不到自己（实测 `l_type` 被改写成 `F_UNLCK`=2）。「自己挡不住自己」挡不住「自己关了别的 fd」——POSIX 锁关闭该文件**任意** fd 即释放全部（本机实测 `close(b)` 后子进程加锁成功）。OFD 补的正是这一条 | 三个动作：同进程两 fd 各 `F_SETLK` 看返回；`F_GETLK` 看 `l_type`；fork 一个子进程持锁前后各 `grep ":$(stat -c %i 文件) " /proc/locks` |
| 「`MAP_SHARED` 改了要 `msync` 别的进程才看得见」 | Linux 是统一页缓存，共享映射的写进的就是那份 cache：本机实测映射里改一字节，另一个进程用另一个 fd `pread` **不经任何同步**立刻读到新值。`msync` 管的是**回写磁盘**，不管可见性；`MAP_PRIVATE` 的写触发写时复制（COW）后只在本进程、永不落盘 | 两进程程序：一方 `MAP_SHARED` 写、另一方 `open`+`pread`；`MAP_PRIVATE` 版同样跑，另一方永远读不到 |
| 「`mmap` 的 `length` 会自动向上取整，所以 `offset` 也能随意给」 | 两个约束不是一件事：`length` 按页取整，但 `offset` 必须**严格页对齐**，否则 `EINVAL`(22)——`MAP_ANONYMOUS` 也一样查（本机实测 `offset=100` 三种写法全报 22，连 `fd=-1` 都拦）；`length=0` 同样 `EINVAL`。`msync`/`mprotect` 的 `addr` 同样要页对齐 | `strace -e trace=mmap,munmap,mprotect,msync` 下跑一个参数矩阵：offset∈{0,100}、length∈{0,4096}、flags∈{PRIVATE,PRIVATE|ANONYMOUS} |
| 「访问出界就 `SIGSEGV`，超过文件就 `SIGBUS`」 | 分界是「在不在 VMA 里」：超出映射长度 → `SIGSEGV`(11)；在映射内但整页落在 EOF 之后 → `SIGBUS`(7)；EOF 所在页的**页内尾部** → 可读、值为 0、写入不落盘。本机实测三档（文件 4000 B、映射 8192 B）：`u[4050]`=0、`u[6000]`=BUS、`u[100000]`=SEGV。另外截断让原来有效的页变成 BUS，是「别把 `st_size` 当不变式」的由来 | `fork` 出子进程分别访问三个偏移、父进程 `waitpid` 读信号号；或 `gdb --args` 看 stopping signal |
| 「`msync` 就是 `fsync` 的映射版，语义一样」 | 保证级别：`MS_SYNC` 等回写完成≈`fsync`；`MS_ASYNC` 只把脏页交给写回路径、不等，≈什么都不保证；`MS_INVALIDATE` 管缓存副本不管落盘；两者作用对象不同（映射区间 vs 文件区间）。对 `MAP_PRIVATE` 调 `msync(MS_SYNC)` **返回 0 且什么都不写回**（本机实测的静默无效）。崩溃一致性发布流程里 `fsync(fd)`+目录 `fsync` 不可替代 | 私有映射改字节→`msync(MS_SYNC)`→`pread` 读回旧值，检查返回码；共享映射改→不 `msync` 直接 `pread`（能读到）；「到磁盘」那一层只能靠 `MS_SYNC`/`fsync`，断电复现本机做不到 |
| 「`posix_fallocate` 就是 `fallocate` 的 POSIX 皮，到处走同一条路」 | 返回错误码而不设 `errno` 只是表层差异；底层路径随文件系统变：本机 ext4 与 tmpfs 都直接落 `fallocate(3, 0, 0, len)` 系统调用（strace 实测，64 MiB 分别 0.1 ms / 4.1 ms）；不支持该系统调用的文件系统上 glibc 退化为**逐块写 0**，可能比普通写还慢——这条慢路径本套件没有文件系统可复现（未实测） | `strace -e trace=fallocate,write ./prog` 看走了哪条；换 NFS/FUSE 的机器复跑同一程序比对耗时 |
| 「`posix_fadvise` 和 `madvise` 是同一件事的两种拼写」 | 作用对象不同：前者给「文件 fd + 字节区间」提建议，效果落在该文件的 page cache 上、**跨进程共享**；后者给「本进程 VMA 区间」提建议，只动自己映射的行为（如 `MADV_DONTNEED` 只丢自己这几页）。对同一个文件「`posix_fadvise(DONTNEED)` + 另一进程仍有映射」的组合里，被引用的页不会真消失。混发对象是常见事故：建议没报错，但发给了错的一层 | `strace -e trace=fadvise64,madvise` 看调用落在哪层；两进程各持映射时从一侧 `posix_fadvise(POSIX_FADV_DONTNEED)`，另一侧 `mincore` 看驻留变化（数值随内核变，本机不承诺） |
| 「给文件加了 `xattr`（扩展属性）就像给它上了锁/盖了章」 | `setfattr`/`getxattr` 只是 inode 上的键值元数据：不参与任何锁冲突检测、不进 `/proc/locks`、改它没有原子性可言，和「谁能写这段字节」完全两层。常与锁混谈是因为都挂「文件属性/标记」这个词。扩展属性的完整语义在 [2.5](ch05.md) | `getfattr -d 文件` 前后，`grep ":$(stat -c %i 文件) " /proc/locks` 纹丝不动即是证明；锁状态永远只看 `/proc/locks`/`lslocks` |
| 「`O_DIRECT`=00040000、`O_NOFOLLOW`=00400000 这类高位标志的八进制值是通用常数」 | 位值随**架构 ABI** 变。本机（aarch64，glibc 2.39）实测：`O_DIRECT`=**00200000**、`O_NOFOLLOW`=**00100000**、`O_DIRECTORY`=00040000、`O_CLOEXEC`=02000000、`O_TMPFILE`=020040000、`O_PATH`=010000000、`O_LARGEFILE`=**00000000**（内核内部位、用户态不可见）。x86-64 的 `O_DIRECT`/`O_NOFOLLOW` 位值不同（未实测——本套件没有该机器，按目标机 `<asm/fcntl.h>` 取） | 在目标机跑 `echo | cc -dM -E -include fcntl.h -` 后 grep；代码里永远用宏不用字面量；`/proc/self/fdinfo` 的 `flags` 打印的也是这套架构位 |
| 「errno 数值到处一样：`EINVAL` 就是 22、`EAGAIN` 就是 11」 | 本机 aarch64 的 `/usr/include/aarch64-linux-gnu/asm/errno.h` 只有一行 `#include <asm-generic/errno.h>`——**asm-generic 才是生效的那份**（22/11/13/18/95/35 都出自它；x86-64 同样走通用表，属文档级结论、本套件未在 x86 复算）。alpha/mips/sparc 历史上自带另一套编号（未实测）；非 Linux 更远：写作机 macOS arm64 实测 `EAGAIN`=35、`ENOTSUP`=45、`EOPNOTSUPP`=102、`EINVAL`=22、`EXDEV`=18 | `grep -rn include /usr/include/$(uname -m 相关)-linux-gnu/asm/errno.h` 看它包含谁；`echo | cc -dM -E -include errno.h -` 取生效值；代码只写名字，打印用 `strerror` |
| 「系统调用号可以背：`SYS_mmap` 是 9」 | 调用号是架构 ABI：本机实测 `SYS_mmap`=222、`SYS_fallocate`=47、`SYS_copy_file_range`=285、`SYS_sendfile`=71、`SYS_pread64`=67、`SYS_read`=63；x86-64 的 `mmap`=9、`copy_file_range`=326 属文档值（未实测）。更隐蔽的坑：**aarch64 没有独立的 `rename`/`pipe` 调用号**，glibc 把 `rename` 落成 `renameat(AT_FDCWD,…)`、`pipe()` 落成 `pipe2(…,0)`——`strace -e trace=rename` 在本机永远空 | `echo | cc -dM -E -include sys/syscall.h -` grep 要用的号；strace 时用类（`%file`）或把 `renameat`、`pipe2` 一并列进 `-e` |
| 「`O_DIRECT` 的对齐照 `st_blksize`（本机 4096）来就行」 | 对齐粒度与 `st_blksize` 是两回事：本机 ext4 `st_blksize`=4096，但实测 offset/长度/缓冲区地址按 **512 字节**对齐就能过——`off=512/1024/1536`、`len=512`、`buf+512/+2048` 全部成功；`off=1/256`、`len=100`、`buf+64` 报 `EINVAL`(22)。`posix_memalign(4096)` 是保守写法不是最低要求；粒度还随设备逻辑块与文件系统变，别背数字。本机内核的 tmpfs 上 `open(O_DIRECT)` 也成功（旧结论「tmpfs 必拒」搬家了，以实测为准） | 跑习题 C2 的矩阵；换 NVMe/512e 盘、换 XFS/btrfs 重跑一遍，先测后用 |
| 「强制锁还在：setgid + 关掉 group-execute 就能让内核挡写」 | Linux 5.15 已移除强制锁（man 2 fcntl 与 5.15 changelog；本机内核 7.0 更晚，机制不存在）；`/proc/locks` 的 `MANDATORY` 字样只是历史字段。 advisory 锁「挡不住不配合的进程」这条恰恰是本章反复强调的设计前提 | `grep -w MANDATORY /proc/locks` 为空；按 man 页版本注记核对；别写这类代码 |
| 「`copy_file_range` 跨文件系统一定失败（或 5.3 以后一定行）」 | 两个方向都过头：老内核直接 `EXDEV`；5.3+ 在部分场景回退通用复制；文件系统不支持时 `EOPNOTSUPP`。本机只实测了 ext4 内部 1 MiB 复制成功（`copied 1048576 bytes`），`/tmp`→`/dev/shm` 的组合**未实测**（本套件没有 btrfs/XFS）；无论结果如何，代码里必须保留 `EXDEV`/`EOPNOTSUPP`/`ENOSYS` → `read`/`write` 的降级路径 | 在自己的机器上对跨挂载点的两个文件跑一次并记录 errno；`df -T` 先确认两侧文件系统类型 |
| 「正文 `strace` 示例那几行是模板，照抄解释就行」 | 那是**另一台机器的形状**：`0x7f...` 是 x86-64 地址形态（本机 `mmap` 返回 `0xe5/0xeb/0xff` 一类高位）；示例里 `mmap(NULL, 4096, …)` 的 4096 在本机是 **23**（strace 打的是实参 `length`=文件字节数，不是页取整后的值）；示例的 `madvise(..., MADV_SEQUENTIAL)` 行根本不存在——`mmap_scan` 不调 `madvise`；fd 后的 `</tmp/mmap_demo.XXXX>` 路径装饰要加 `-yy` 才有 | `strace -yy -e trace=mmap,munmap,msync ./mmap_scan` 本机跑一遍逐行对比；只把示例当「行的形状」读 |
| 「`/proc/locks` 那行的 `08:01:7340033`、PID 48211 可以引用」 | 设备号 `major:minor` 是内核给该 super block 的编号：本机 `/` 在 `/dev/sda2` 上是 **08:02**，inode 与 PID 每次运行都不同（实测 `1: POSIX  ADVISORY  WRITE 135590 08:02:292672 0 EOF`）；`grep 文件名 /proc/locks` 永远查不到——那一列没有路径 | `stat -c %i 锁文件` 拿 inode 再 `grep ":<ino> "`；或 `lslocks` 直接看名字列 |
| 「`grep mmap_demo /proc/$$/smaps`、`fincore` 两条命令谁都能跑」 | `$$` 展开的是**当前 shell** 的 PID，shell 的 smaps 里当然没有 `mmap_demo`——这条命令永远为空（本机实测）；要读就读被观察进程的 `/proc/PID/smaps` 或在程序内读 `/proc/self/smaps`。`fincore` 本机未安装。本机实测替代读数：同一 1 MiB 共享映射，触碰 3 页 `Rss`=12 kB、触碰全部 256 页 `Rss`=1024 kB，`Pss` 与 `Private_Dirty` 同值（单映射者） | `grep -A12 lab2c03 /proc/$(pgrep -f lab2c03_smaps)/smaps`；或 C6 的程序内自读；`command -v fincore` 先确认有没有 |

## 2. 复跑校正（2026-11-02，同一台 VM）

下面这些是把正文的十个程序（`iov_log`、`mmap_scan`、`mmap_bus`、`mmap_ops`、`lockfile`、`publish`、`memfd_demo`、`fallocate_demo`、`zerocopy`、`oflock`）在这台 Ubuntu 24.04.5 aarch64 虚拟机（`cc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0`、glibc 2.39、strace 6.8、`/tmp` 为 ext4）上逐个编译运行后的对照。十个程序都能用正文给的命令一次编译通过；这一节只记录**本机读数与正文的差**，正文本身的修订由正文的改写者处理，套件（回忆卡、习题集、自检表）里引用的数字一律以下列值为准。

| 正文位置 | 正文写的 | 本机复跑得到的 | 处理 |
|:--|:--|:--|:--|
| 2.3.3 的 `iov_log` 注释 | `seq=1 len=30 body=disk full …` | `seq=1 len=34`——字符串 `disk full on /var; retry scheduled` 实际 34 字节，程序自己算的 `strlen` 就是 34 | 正文注释属笔误级偏差；套件一律写 34（见 C1）；这也是「代码注释里的数字不是实测」的现成教材 |
| 2.3.11 的 `mmap_ops` 末两行 | `mlock first page: ok` 之后 `mremap: moved, new page writable` | `mlock first page: ok` 复现，但 `mremap: Bad address`（`EFAULT`=14）、程序退出码 1 | 隔离实验（习题口径）：对**部分** mlock 过的 2 页区间做 `mremap(MREMAP_MAYMOVE)` 失败；mlock 整段或先 `munlock` 再 `mremap` 都成功。正文该步在本机失败，引用「mremap 搬家」这个演示前要么先 munlock 要么换机 |
| 2.3.13 的 `fallocate_demo` 块数 | `written` 2056 (1028 KiB)、`punched` 1032 (516 KiB)、`data [0, 1048576)` | `sparse 0 → prealloc 2048 (1024 KiB) → written 2048 → punched 2048`，数据段只有一个：`data [524288, 528384)` | 本机 ext4 上 `KEEP_SIZE` 预分配只给了前 1 MiB；4 KiB 的 `pwrite` 落在已分配区内不再新增块；`PUNCH_HOLE` 打的 1–2 MiB 本来就是空洞、无块可放。正文那组数属于另一台机器的分配行为；正文自己也写了「分段随文件系统而异」，本机以 2048/2048 为准 |
| 2.3.6 终端块的 `/proc/locks` 行 | `1: POSIX  ADVISORY  WRITE 48211 08:01:7340033 0 EOF` | `1: POSIX  ADVISORY  WRITE 135590 08:02:292672 0 EOF`（PID/inode 每次变） | 设备号 `08:01`、PID、inode 都是另一台机器的形状；本机 `08:02`。套件引用这行时只讲八列顺序，数字标注「本机每次不同」 |
| 2.3.13 errata 盒第 2 条 | 「`PUNCH_HOLE` 必须与 `KEEP_SIZE` 合用，否则 `EINVAL`」 | 本机 ext4 上单独 `PUNCH_HOLE` 报 **`EOPNOTSUPP`(95)**（`fallocate(fd, FALLOC_FL_PUNCH_HOLE, 0, 4096)` → -1/95） | 错误码名称对不上结论本身仍成立（必须合用）；「否则 EINVAL」是另一份 man 页/实现的说法，本机以 95 为准，跨文件系统未实测 |
| 2.3.17 实验一的 strace 块 | `mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_SHARED, 3</tmp/mmap_demo.XXXX>, 0) = 0x7f...`，且含 `madvise(..., MADV_SEQUENTIAL) = 0` 一行 | 本机：`mmap(NULL, 23, …, MAP_SHARED, 3) = 0xebb6672ed000`；**没有任何 madvise 行**（`mmap_scan` 不调 `madvise`）；fd 路径装饰需另加 `-yy`，加了之后是 `3</tmp/mmap_demo.Vuyo14>` | 该块是示意不是复跑：长度打的是实参 23（文件字节数）不是 4096；`0x7f` 是 x86 形态；madvise 行在本机不存在。习题 C4/C6 的命令已改成本机可复现的过滤器 |
| 2.3.16 note 盒的 `perf stat -e page-faults` | 命令直接可用 | `perf stat -e page-faults true` 报 `No supported events found`（`perf_event_paranoid`=4）；`perf stat true`（不带 `-e`）会退出但计数列 `<not supported>` | 全套件按「未实测」处理，替代路径 `getrusage` 已实测并写进 C6；顺带纠正一种过度说法：不是 `perf` 这个文件不存在，是事件被权限挡住 |
| 2.3.17 实验二的两条命令 | `grep -A12 'mmap_demo' /proc/$$/smaps`；`fincore --pages=false /etc/hosts` | 前者永远为空（`$$` 是 shell 自己的进程）；后者 `fincore` 未安装 | 替代已实测：程序内读 `/proc/self/smaps`——触碰 3 页 `Rss`=12 kB、256 页 `Rss`=1024 kB（与 summary 页引用一致）；`grep VmLck /proc/PID/status` 可用 |
| 2.3.7 的发布 strace 命令 | `strace -e trace=openat,write,fsync,rename,close …` | 本机 `fsync` 两次（`fsync(4)` 出现两回：第二次是目录重新 `openat` 后也分到 fd 4，不是重复调用）；替换动作是 `renameat(AT_FDCWD, …, AT_FDCWD, …) = 0`——**`-e trace=rename` 抓不到**（aarch64 无 `rename` 调用） | 命令要改成 `-e trace=%file,fsync` 或显式加 `renameat`；「两次 fsync」是目录步存在的证据，这条写进 C4 判据 |
| 2.3.4 `mmap_scan` 终端 | `file now: HELLO MMAP / SECOND LINE` | 实际打印两行：`file now: HELLO MMAP` 换行 `SECOND LINE`（源文本自带 `\n`） | 单行「/」是示意写法；按两行读，不影响结论 |

另两条不是差值而是本机确认过的边界：`mv` 跨 `/tmp`→`/dev/shm` 会**成功**（复制+删除的回退），而 `rename(2)` 同一对路径报 `EXDEV`(18)（`python3 os.rename` 实测）——「脚本能搬」不等于「原子发布能搬」，这条已写进 B4/C4。`getrusage` 三档实测：`minflt` 62→73→85、`majflt`=1——触碰 256 页的缺页增量远小于 256（fault-around 合并），所以「缺页数=访问页数」不能当常数背，`Rss` 才是驻留的直接证据。

## 3. 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的形状、量级或方法**，不要抄成事实：

- **x86-64 对照的全部数值**：`O_DIRECT`/`O_NOFOLLOW` 等标志在该架构的八进制位值、`SYS_mmap`=9/`SYS_copy_file_range`=326、正文 `/proc/locks` 的 `08:01` 设备号、strace 的 `0x7f` 地址段。未实测（本套件只有一台 aarch64）；需要时在目标机跑第 1 节给的取值命令。
- **写作机对照**：macOS arm64 无 `O_DIRECT`（`fcntl.h` 里就没有这个宏，用 `F_NOCACHE` 是另一套模型）、无 `/proc`、errno 数值不同（`EAGAIN`=35 等，本页第 1 节已实测引用）——Linux 侧实验没有一条能在写作机复跑。
- **XFS/btrfs 上的行为**：`copy_file_range` 的 reflink 元数据复制、`SEEK_DATA` 分段粒度、`PUNCH_HOLE` 的单独使用返回码、`FALLOC_FL_ZERO_RANGE` 是否分配块。本机只有 ext4 + tmpfs，正文「分段随文件系统而异」的提醒在方向上被本机证实（数据段合并成不同区间），但各文件系统的具体账没有复算。
- **`posix_fallocate` 的慢路径**（无 `fallocate` 系统调用时逐块写 0）：本机 ext4/tmpfs 都走快路径（strace 实测），NFS/FUSE 上没有对应挂载可测，「可能比普通写还慢」按文档级结论读。
- **巨页与持久内存**：`MAP_HUGETLB`（巨页大 TLB）、`MFD_HUGETLB`、`MAP_SYNC`+DAX——需要预留巨页或 DAX 挂载，本机没有条件，未实测。
- **`MADV_PAGEOUT`/`MADV_COLD`/`MADV_MERGEABLE`（KSM）、`MREMAP_DONTUNMAP`、`userfaultfd` 场景**：机制按 man 页叙述，本机没有制造出可引用的读数。
- **容器与跨挂载可见性**：`/proc/locks` 按 PID 命名空间过滤（4.9+）、`flock`/记录锁在 NFS 上的另一套语义、`docker` 里看宿主机锁——本机 `docker` 免 sudo 可用但本套件没有复现这些现场，全部按文档级结论读；`strace -p`/跨进程 `/proc` 附着被权限挡死（`ptrace_scope`=1，2.1 已实测），这类观察只能「在 strace 下启动」。
- **`linkat(…, AT_EMPTY_PATH)` 普通进程能否走通**：正文预期需要 `CAP_DAC_READ_SEARCH`；本机没有对该断言做过正反测试，按未实测读（`/proc/self/fd/N` 那条路径在回忆卡里已实测通过）。
- **`vmsplice`/`tee` 的行为细节、`SPLICE_F_GIFT` 的生命周期坑**：本机只实测了 `splice` 文件→管道→文件与 `copy_file_range` 同盘复制，其余按 man 页形状引用。

## 4. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/架构/内核/文件系统 → 建议改法**」四段记，不要只写「我这里不对」——本章的结论挂在架构位值、内核版本、文件系统类型和会话权限上，缺了第三段就没有可比较的基准。四段这样填：

1. **现象**：一句话写清「谁在什么时候看起来坏了」。例：「`PUNCH_HOLE` 单独用报 `EOPNOTSUPP`，正文 errata 盒说应是 `EINVAL`」。
2. **命令与输出**：贴**原样敲的命令**与**未经删减的输出**（含退出码与 errno 数值）。例：fallocate 那一行调用 + `rc=-1 errno=95 (Operation not supported)`。
3. **机器/架构/内核/文件系统**：至少附 `uname -a`、`uname -m`、`cc --version | head -1`、`ldd --version | head -1`、`getconf PAGE_SIZE`、`df -T 涉及路径`、`cat /proc/sys/kernel/perf_event_paranoid /proc/sys/kernel/yama/ptrace_scope`；涉及宏附 `echo | cc -dM -E -include fcntl.h -` 的相关行；涉及调用号附 `echo | cc -dM -E -include sys/syscall.h -`；涉及锁附 `/proc/locks` 原始行与 `lslocks` 版本；自写程序一律 `timeout` 后再贴。
4. **建议改法**：写「该改成什么动作」而不是「正文错了」。例：「errata 盒的『否则 EINVAL』改成『否则报错（本机 ext4 报 EOPNOTSUPP，跨文件系统未实测）』；习题 C 的判据改成先跑矩阵再用数字」。

最后把结论归到四类里再说话：**规范/ABI 条款**（可以断言，如「记录锁归进程 + inode」）、**本机实测**（可复算，如「`O_DIRECT`=00200000、对齐粒度 512」）、**正文标注的另一台机器的形状**（只当行读，如 `08:01`、`0x7f`、`blocks=2056`）、**未实测**（写清为什么没测，如 XFS reflink、`perf` 事件、慢路径）。本章最常见的分歧，出自把第三类当第一类引用，以及把「我这台 aarch64 的位值/粒度」当成「所有 Linux 的位值/粒度」。
