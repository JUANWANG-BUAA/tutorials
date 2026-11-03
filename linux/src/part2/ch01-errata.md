# 2.1 勘误与版本注记

这一页收本章最容易「换一台机器、换一个 libc、换一个内核、换一个挂载的文件系统就不成立」的东西：系统调用编号、`errno` 的实现与数值、vDSO 的地址形态、`sysconf`/`pathconf` 查出来的数、`strace` 的输出格式、`/proc` 的字段表头、特性测试宏的历史。正文里的 `errata` 盒讲**理解陷阱**（把 A 当成 B），这一页讲**搬家陷阱**（在 A 机器上成立、到 B 机器上悄悄变）。用之前先记住本章的一条纪律：**判断错误码写名字、要限制去运行时查、要读数回自己机器取**——这三件事做对了，下面这张表大部分行都不需要背。

**本章基线**：本书的测试虚拟机是 Ubuntu 24.04.5（**aarch64 / ARM64，不是 x86-64**）、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、约 12 GiB 内存，`sudo` 与 `perf` 不可用，`strace` 6.8、`getconf`、`namei`、`sysctl`（读）可用。正文有四处读数标着或暗示 x86-64：2.1.1 的 vDSO 地址、2.1.2 的三个纳秒数、2.1.6 的 `limits` 输出（`6.8.0-45-generic`、`x86_64`、8 CPU）、2.1.9 的 `abi_probe` 调用号、2.1.15 的 `strace` 行（`/lib/x86_64-linux-gnu/libc.so.6`）。它们不是错的，但**不属于这台机器**：照抄去解释本机现象一定会对不上。第 3 节是 2026-11-02 在这台 VM 上把正文九个程序逐个编译运行后的对照表，本机的对应数值都以那一节为准。写作机是 Apple 芯片的 macOS（arm64，实测版本 27.2），没有 `/proc`、没有 `strace`，`errno` 数值与页大小都不同（见第 4 节）。凡标「未实测」的，请看第 5 节。

## 1. 十八条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「`errno` 是进程里一个全局 `int`，任何系统调用失败都会写它」 | glibc 里 `errno` 是**宏**，展开成 `(*__errno_location())`，槽位在 libc 的线程局部存储里，所以线程之间互不覆盖；而且只有**经过 libc 包装**的调用才写它。自己执行 `svc #0`/`syscall` 指令、或从 `ucontext`/裸汇编里直接陷入，内核返回的仍是 `-errno`，但没有任何人替你翻译成 `-1` 并写 `errno` | `man 3 errno`；`echo '#include <errno.h>' \| cc -E -x c - \| grep errno_location \| tail -2` 看宏展开；`nm -D /lib/aarch64-linux-gnu/libc.so.6 \| grep __errno_location` 看这个函数存在 |
| 「系统调用编号到处一样，`SYS_read` 是 0」 | 编号是**架构 ABI**。x86-64：`read`=0、`write`=1、`openat`=257、`statx`=332、`getrandom`=318；aarch64 走内核通用表：`read`=63、`write`=64、`openat`=56、`statx`=291、`getrandom`=278。正文 2.1.9 贴的那一行是 x86-64 的读数，别背数字——**以本机头文件的 grep 结果为准** | 跑正文的 `abi_probe`；`echo \| cc -dM -E -include sys/syscall.h - \| grep -wE 'SYS_read\|SYS_openat\|SYS_statx'`；`grep -rn '^#define __NR_read' /usr/include/aarch64-linux-gnu/asm/` |
| 「2.1.2 那三个纳秒数可以引用」 | 那组 318.4 / 315.7 / 19.2 ns 标在 `ubuntu 24.04 / x86-64`，属于另一台机器。本机（aarch64、内核 7.0.0-38）同一份 `syscall_cost.c` 多次复跑落在 133–139 ns（`syscall(SYS_getpid)` 与 `getpid()` 同步浮动），`clock_gettime` 13.6–15.4 ns；正文 2.1.2 贴的就是其中两次（134.1/133.5/14.6 与 139.1/139.1/15.4）——**比例关系成立**（陷入约为 vDSO 读的 10 倍；`syscall(SYS_getpid)` 与 `getpid()` 几乎相等，说明 `getpid` 不走 vDSO），绝对值只有正文的一半多一点。能带走的只有比例，绝对值受 CPU、虚拟化层、`CONFIG_*`、是否命中 vDSO 影响 | 本机重跑 `syscall_cost` 两次以上，记录 `uname -a`/`uname -m`、编译器版本与完整 flags；多次取中位数；只做同机同版本内的比较 |
| 「2.1.6 的 `limits` 输出就是这台机器的读数」 | 它打印 `6.8.0-45-generic` 与 `machine=x86_64`，而测试 VM 是内核 7.0.0-38 的 aarch64；`_SC_NPROCESSORS_ONLN` 那里是 8，本机复跑是 4；`_SC_OPEN_MAX` 那里是 1048576，本机是 **1024**（等于 `ulimit -n`，硬限制才是 1048576）。另外正文那段终端块写成 `sysname=Linux release=... machine=...`，而它自己的源码是 `printf("%s %s %s\n", ...)`，本机实际首行是 `Linux 7.0.0-38-generic aarch64`，没有等号 | `uname -a`、`nproc`、`ulimit -n`、`cat /proc/self/limits`、`./limits` 五连；把本机值与正文值做成两列 |
| 「`sysconf(_SC_OPEN_MAX)` 是系统能打开的文件总数」 | 在 Linux/glibc 上它是本进程 `RLIMIT_NOFILE` **软限制**的投影，软限制可被 `setrlimit`/`prlimit` 或启动方式（systemd 的 `LimitNOFILE=`、容器的 `ulimits`）随时改；系统侧还另有 `fs.nr_open`（单进程 fd 号绝对上限）与 `fs.file-max`（全系统打开文件总数）。换 libc 这个语义也可能不同 | `getconf OPEN_MAX`、`ulimit -n`、`sysctl fs.nr_open fs.file-max 2>/dev/null` 三个数并排看；程序里用 `getrlimit(RLIMIT_NOFILE, &rl)` 打印 `rlim_cur`/`rlim_max`；`strace -e trace=openat` 看什么时候先撞 `EMFILE` |
| 「页大小一定是 4096」 | 它由内核编译选项决定：arm64 内核可编成 4 KiB/16 KiB/64 KiB 页，Ubuntu 用 4 KiB，但同一份代码换到 64 KiB 内核上偏移计算会差 16 倍。非 Linux 更不同（写作机 macOS arm64 实测 16384） | `getconf PAGE_SIZE`；`uname -a`（64 KiB 版本的 Ubuntu 内核带 `+64k`）；代码里一律 `sysconf(_SC_PAGESIZE)`，不写 `4096` |
| 「`NAME_MAX` 255、`PATH_MAX` 4096 到处成立」 | `pathconf` 查的是**这个路径所在的文件系统**：ext4/tmpfs 常见 255，eCryptfs 可能只有 143，NFS 与 FUSE 随服务端/实现变，某些文件系统直接返回「不确定」（`-1` 且 `errno == 0`）。`PATH_MAX` 也不是 Linux 路径解析的硬上限，`openat2` 只看实际字符串长度 | `df -T /path` 先确认文件系统类型，再 `getconf NAME_MAX /path`、`getconf PATH_MAX /path`、`stat -f /path` 三个一起看；对同一台机器的 `/tmp`、`/proc`、`/sys` 分别查一次 |
| 「管道的默认容量 65536 字节到处一样」 | 默认是 16 个**页**，不是 65536 这个常数：4 KiB 页上是 65536，64 KiB 页的内核上同一默认页数就是 1 MiB。上限来自 `/proc/sys/fs/pipe-max-size`（默认 1048576，非特权只能升到它，超过要 `CAP_SYS_RESOURCE`）。正文 `limits2.c` 里那行 `F_SETPIPE_SZ max=1048576` 是直接打印的字面量，不是查询结果 | `fcntl(fd, F_GETPIPE_SZ)` 打印本机值；`getconf PAGE_SIZE`；`cat /proc/sys/fs/pipe-max-size`；顺手用 `fpathconf(fd, _PC_PIPE_BUF)` 对比「原子写」的门限（这个才是 POSIX 侧保证不交错的字节数） |
| 「vDSO 的地址在 `0x7ffd...` 附近，可以写进笔记当参考」 | 两件事都不成立：① 它每次 `exec` 都随机化，不能当常数引用，只能运行时从辅助向量或 `maps` 里取（本机连跑两次 `AT_SYSINFO_EHDR` 得到 `0xe3adbdc48000` 与 `0xe4c30b400000`）；② `0x7ffd...` 是 x86-64 的形态（靠近用户栈顶），aarch64 上 `[vvar]`/`[vdso]` 落在另一段随机高位（本机是 `0xf8b1a1eb4000` 一类），栈顶才在 `0xffff...` | `LD_SHOW_AUXV=1 /bin/true \| grep AT_SYSINFO_EHDR` **连跑两次**，地址必然不同；`grep -E 'vvar\|vdso' /proc/self/maps` 看本机位置；需要它时用 `AT_SYSINFO_EHDR` 或 `dlopen`/`_dl_vdso_vsym` 一类接口，不写死地址 |
| 「`clock_gettime` 一定走 vDSO」 | 取决于内核是否提供该时钟的 vDSO 实现、libc 是否选择用它、时钟源是否可用；`CLOCK_MONOTONIC_RAW`、部分实时时钟、虚拟化环境或旧内核都可能回落到真正的系统调用。所以「快一个数量级」是本机观察，不是保证 | `strace -e trace=clock_gettime ./syscall_cost` 数有没有调用行；`grep vdso /proc/self/maps` 确认有没有映射；两种时钟各测一次并列出本机条件 |
| 「`-D_GNU_SOURCE` 只是多几个声明，不改 ABI」 | 它同时改变**分派**与**符号版本**：`strerror_r` 在 `_GNU_SOURCE` 下选 GNU 版（返回 `char *`），否则是 XSI 版（返回 `int`）；`%m` 这类 `printf` 扩展、`__USE_*` 内部标记也由它决定。真正改布局的是 `_FILE_OFFSET_BITS=64`（`off_t` 与 `struct stat` 变 64 位、`stat` 重定向到 64 位符号）与 `_TIME_BITS=64`（要求同时定义前者）。用不同宏编出来的目标文件混在一起链，是静默的 ABI 破坏 | 三次编译正文的 `feature_matrix.c`（默认 / `-D_POSIX_C_SOURCE=200809L` / `-D_GNU_SOURCE`）比较 `__USE_GNU`、`__USE_MISC`；`grep -n strerror_r /usr/include/string.h` 看两种声明的条件；`_Static_assert(sizeof(struct stat) == ...)` 在两种宏下看是否触发 |
| 「`_DEFAULT_SOURCE` 一直都有，老代码写 `_BSD_SOURCE` 也一样」 | `_DEFAULT_SOURCE` 是 glibc 2.20 才引入的统一开关，用来替代被废弃的 `_BSD_SOURCE` 与 `_SVID_SOURCE`；在那之前显式定义 `_POSIX_C_SOURCE` 的行为细节也不同。反过来说：在新 glibc 上写 `_BSD_SOURCE` 只能得到废弃警告，在老 glibc 上写 `_DEFAULT_SOURCE` 等于没写——「同一份代码在别人机器上少声明」经常就是这个年代差 | `ldd --version \| head -1` 记 glibc 版本；`grep -n '_DEFAULT_SOURCE\|_BSD_SOURCE' /usr/include/features.h`；`cpp -dM` 分别在两种宏下看已定义集合 |
| 「`syscall()` 这个逃生口在所有 libc 上等价」 | 三个前提只在 glibc 上成立：它会做 `errno` 翻译、按 glibc 自己的规则排参数、并且**最多六个参数**（超过是未定义行为）。musl 等 libc 的实现细节不同（可用性检查、`errno` 写入路径、某些调用没有包装）；`clone`/`clone3` 这类需要换栈的调用不能用 `syscall()` 走通；从 `ucontext` 或自写汇编陷入时根本没有 `errno` 这回事 | `ldd --version`（或 `ls /lib/ld-musl-*`）确认 libc；`man 3 syscall` 的参数上限那一段；`strace ./prog` 看 `syscall()` 展开成了哪条真实调用；需要长期用的小众接口按 man 页的 FEATURES 段决定是否自己写包装 |
| 「`strerror_r` 有两种写法，`strerror_l` 到处都有」 | GNU 版与 XSI 版的选择靠 `_GNU_SOURCE`；只提供 XSI 版的 libc（不少非 glibc 实现）上，那份按 GNU 写的代码直接编译失败；`strerror_l` 属于 POSIX.1-2008，也不是所有 C 库都提供。GNU 版还有一个坑：未知错误码时返回的是**静态字符串**，不等于你传的缓冲区，也不能 `free` | `grep -n -A3 'strerror_r' /usr/include/string.h` 看条件编译；分别用 `-D_GNU_SOURCE` 与 `-D_POSIX_C_SOURCE=200809L` 编同一份调用代码；`./strerror_demo` 打印 `strerror_r(12345, buf, sizeof buf)` 是否指向 `buf` |
| 「错误码的数字到处一样：`EAGAIN` 就是 11」 | Linux 的 aarch64/x86-64 用通用表（`EAGAIN`=11、`ENOTSUP`/`EOPNOTSUPP`=95、`EDEADLK`=35），但 alpha、mips、sparc 这些架构的历史编号不同；非 Linux 更远：写作机 macOS arm64 实测 `EAGAIN`=35、`ENOTSUP`=45。所以「写 `errno == 11`」在跨架构与跨系统两个方向都会错 | `grep -rn -w EAGAIN /usr/include/asm-generic/errno.h /usr/include/asm/errno.h`（看真正被包含的是哪一个）；在别的系统上打印同一个宏的值再比较；代码里只写名字 |
| 「`strace` 的输出格式和选项名是稳定的」 | 调用类名（`%file`、`%desc`）、`-e inject=...`（故障注入）、`-yy` 的路径解码格式都随 strace 版本变化，老版本可能直接报未知选项。本机 strace 6.8 复跑：`%file`/`%desc`/`inject=`/`-yy` 都可用；但同一组 flags 的**打印顺序**与正文不同（本机 `O_RDONLY|O_CLOEXEC|O_DIRECTORY`，正文 `O_RDONLY|O_DIRECTORY|O_CLOEXEC`），`-yy` 显示的是解析后的真实路径（`/usr/lib/aarch64-linux-gnu/libc.so.6`）而传给 `openat` 的是 `/lib/...` 那个符号链接；示例里的库目录带架构名（`x86_64-linux-gnu` 属于 x86-64）；fd 号、inode 号、`pipe:[...]` 里的编号每次运行都不同 | `strace -V \| head -1`；`strace -e trace=%desc true` 看是否被识别；把正文那几行只当**行的形状**，逐行去比 `openat`/`pipe2`/`fcntl` 的结构，不比数字与顺序 |
| 「`/proc/self/fdinfo/N` 的表头固定是这四行，`flags` 能按用户态 `O_*` 直接念」 | `pos` 与 `flags` 是最稳的两个，`mnt_id`、`ino` 出现得更晚、且不保证一直只有这些：内核会按 fd 的类型**追加私有字段**（timerfd、eventfd、epoll、io_uring 各有自己的额外行）。更关键的是 `flags` 打印的是内核的 `f_flags`，不是用户态 `O_*` 的可见集合：本机只读打开 `/etc/hosts` 得 `flags: 0400000`，而本机 `<fcntl.h>` 里 `O_LARGEFILE`=**0**、`O_NOFOLLOW`=`0100000`、`O_DIRECTORY`=`040000`、`O_CLOEXEC`=`02000000`——正文那句「`0100000` 是 `O_LARGEFILE`」在本机不成立（那是 x86-64 时代另一位上的读法），位值本身随架构变 | `exec 3</etc/hosts; cat /proc/self/fdinfo/3`（本机得 `pos: 0` / `flags: 0400000` / `mnt_id: 35` / `ino: 2755550`）；再做**差法**：另开一个 `O_RDONLY|O_CLOEXEC` 的 fd，`flags` 变 `02400000`，多出的就是 `02000000`；开目录得 `0440000`，多出 `040000`；`echo \| cc -dM -E -include fcntl.h -` 看本机宏值；`man 5 proc` 看哪些字段属于特定 fd 类型 |
| 「`/proc` 里的数按列取就行；`/proc/PID/syscall` 随时能读」 | `/proc` 的文本列宽与字段数随版本变（正文用 `VmRSS` 举例：`awk '{print $2}'` 一旦前面插字段就取错）；`/proc/PID/syscall` 第一列是**该架构的调用号**，本机 `cat /proc/self/syscall` 打印 `63 0x3 0x... 0x20000 ...`，63 是 aarch64 的 `read`，正文示例的 `0` 是 x86-64 的编号。更要紧的是权限：读**别的进程**的这个文件需要 ptrace 权限，本机 `/proc/sys/kernel/yama/ptrace_scope` = 1，`cat /proc/<别人的 PID>/syscall` 实测报 `Operation not permitted`（同 uid 的兄弟进程也不行），`strace -p <PID>` 也在 `ptrace(PTRACE_SEIZE...)` 上失败 | 取数用 `grep '^VmRSS:'` 再切字段，或读字段顺序稳定的 `/proc/PID/stat`；`cat /proc/sys/kernel/yama/ptrace_scope` 先确认权限模型；观察别的进程改用「在 strace 下启动」而不是附着；`man 5 proc` 看每个文件的稳定性说明 |

## 2. 另外三条常被当成定理的写法

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「`getopt_long` 的行为就是 POSIX 的行为」 | 三处是 GNU 扩展：默认**重排 `argv`**（POSIX 是遇到第一个非选项就停）、`optind = 0` 的重新初始化、`optstring` 里 `:`/`+` 的语义细节；长选项的唯一前缀缩写也是 GNU 行为，别人加一个同前缀选项就让旧脚本报 ambiguous。写作机（macOS 27.2，arm64）实测：`getopt_long` 存在且默认也会把 `-c 7` 从操作数后面提出来——所以「BSD 不重排」这句也不该到处抄，要按实现实测 | `POSIXLY_CORRECT=1 ./opts a.txt -v` 与不加对照；在别的机器上编同一个 `opts.c`；`man 3 getopt` 的 GNU 一节与 POSIX 版并列读；脚本里一律写全称选项、把选项放操作数之前 |
| 「`access(path, W_OK)` 过了就一定能打开；`EPERM` 就是文件权限」 | `access()` 按 real UID 检查、`open()` 按 effective UID 检查，两者本就可能不同；检查与打开之间还有 TOCTOU 窗口。反过来，`EPERM` 在容器里最常见的原因是 seccomp 的 `SECCOMP_RET_ERRNO`（看起来完全像普通失败），`EACCES` 也可能是 AppArmor/SELinux 或 LSM 而不是权限位 | `strace -f -e trace=access,openat ./app` 看两个调用的先后与结果；`namei -l path` 逐级看目录 `x` 位；`id` 对比 real/effective；容器侧看 `SecurityOpt`（这一步要别的机器上的 root，本机按未实测）；需要按 effective 身份预检查时用 `faccessat(..., AT_EACCESS)` |
| 「`sysexits.h` 与 8 位退出码到处一样」 | 退出码只有 8 位可被父进程读到，`exit(256)` 变成 0——这条在 POSIX 系统上成立，但它解释了脚本里「失败了但 `$?` 是 0」；`sysexits.h` 起源于 BSD，glibc 与 musl 提供，但不是所有 C 库都有，也没有 POSIX 强制。信号终止时 shell 报的是 `128 + 信号号`，与 `exit()` 的值是两套来源 | `ls /usr/include/sysexits.h`；写一个 `exit(256)` 的程序后 `echo $?`；用 `kill -TERM $$` 之类观察 shell 报的 143；跨平台项目把退出码集中在一张表里并加编译期检查 |

## 3. 复跑校正（2026-11-02，同一台 VM）

下面这些是把正文的九个程序（`syscall_cost`、`errno_demo`、`limits`、`limits2`、`abi_probe`、`strerror_demo`、`feature_matrix`、`sysinfo_demo`、`opts`）在这台 Ubuntu 24.04.5 aarch64 虚拟机（`cc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0`、`ldd (Ubuntu GLIBC 2.39-0ubuntu8.9) 2.39`、strace 6.8、`/tmp` 在 ext4 根分区）上逐条编译运行后得到的。程序全部能用正文给的命令一次编译通过，只有 `feature_matrix.c` 例外（第 6 行）。这一节只记录**本机读数与正文的差**，正文本身的修订由正文的改写者处理；套件里凡是引用读数的地方都已改成下面这些值。

| 正文位置 | 正文写的 | 本机复跑得到的 | 处理 |
|:--|:--|:--|:--|
| 2.1.1 的 vDSO 两行 | `AT_SYSINFO_EHDR: 0x7ffd5c4fe000`、`[vdso]` 在 `0x7ffd5c4fe000-0x7ffd5c4ff000` | 本机连跑两次得 `0xe3adbdc48000`、`0xe4c30b400000`；`/proc/self/maps` 里 `[vvar]`/`[vdso]` 是 `f8b1a1eb4000`/`f8b1a1eb8000` 一类随机高位（`0xffff...` 那段是栈） | 属 x86-64 形态。套件按「地址每次 exec 都变、位置随架构不同」讲，不引用具体地址 |
| 2.1.2 的三次计时 | 318.4 / 315.7 / 19.2 ns，标签 `x86-64` | 多次复跑 133–139 / 133–139 / 13.6–15.4 ns（正文取 134.1/133.5/14.6 与 139.1/139.1/15.4） | 比例关系（约 10 倍、`getpid` 不走 vDSO）成立，绝对值本机约为正文的一半多；引用时改成本机数并注明机器 |
| 2.1.6 的 `limits` 终端块 | 首行 `sysname=Linux release=6.8.0-45-generic machine=x86_64` | 首行 `Linux 7.0.0-38-generic aarch64`（源码是 `printf("%s %s %s\n", ...)`，没有 `name=` 标签） | 两处问题叠在一起：机器归属不对，格式也与自身源码不符 |
| 2.1.6 的五个数 | `_SC_OPEN_MAX` 1048576、`_SC_NPROCESSORS_ONLN` 8、其余 4096/100/2097152 | 本机 1024、4、4096、100、2097152；`ulimit -n`=1024、`/proc/self/limits` hard=1048576、`sysctl fs.nr_open`=1048576 | 「`_SC_OPEN_MAX` = 软限制」这句被本机直接证实：它与 `ulimit -n` 相同、与 `nr_open` 不同 |
| 2.1.6 的两个 `pathconf` | `_PC_NAME_MAX(/tmp)` 255、`_PC_PATH_MAX(/tmp)` 4096 | 相同（255 / 4096），但 `df -T /tmp` 显示本机 `/tmp` 在 `ext4` 根分区上，不是 tmpfs；`getconf NAME_MAX /proc` 也给 255 | 数值巧合，不能当「到处 255」的证据；先 `df -T` 再引用 |
| 2.1.9 的 `abi_probe` | `SYS_read=0 SYS_write=1 SYS_openat=257`、`SYS_statx=332`、`SYS_clone3=435`、`syscall(SYS_getpid)=48211` | `SYS_read=63 SYS_write=64 SYS_openat=56`、`SYS_statx=291`、`SYS_clone3=435`；`__NR_getrandom`=278；`getpid` 那次得 84611、`errno=0`；`getrandom(bad) = -1 errno=14` 且退出码 0 | 调用号差异如正文自己预告的那样成立；`clone3` 两边都是 435 属于巧合，正好说明「看着一样也不能背」 |
| 2.1.11 的三次编译 | 三条命令都能编出来，差别只在 `__USE_*` 输出 | **无宏那条直接失败**：`error: 'off_t' undeclared`（`-std=c17` 打开 `__STRICT_ANSI__`，又没有特性宏，glibc 不暴露 `off_t`）。补 `#include <sys/types.h>` 后可编，且三个标记全是 0；`_POSIX_C_SOURCE=200809L` 得 `0/1/0`，`_GNU_SOURCE` 得 `1/1/1` | 「`-std=c17` 会关掉一部分默认声明」这条坑是真的，但例子本身在无宏那一档跑不通，需要按上面两种写法之一补 |
| 2.1.15 的 `strace` 五行 | `openat(... "/lib/x86_64-linux-gnu/libc.so.6" ...) = 3`、`pipe2([4<pipe:[123456]>, 5<...>], O_CLOEXEC)`、`fcntl(5<...>, F_GETPIPE_SZ) = 65536` | 本机：`/lib/aarch64-linux-gnu/libc.so.6`，`-yy` 解析成 `/usr/lib/aarch64-linux-gnu/libc.so.6`；`/tmp` 那行解码成 `O_RDONLY|O_CLOEXEC|O_DIRECTORY`（顺序与正文不同）；`pipe2([3<pipe:[341634]>, 4<...>], 0)`——**flags 是 0，没有 `O_CLOEXEC`**；`fcntl(4, F_GETPIPE_SZ) = 65536` | 「`pipe()` 在 glibc 内部用 `pipe2` 原子设 CLOEXEC」这句本机没有印证：`pipe()` 落到 `pipe2(..., 0)`（aarch64 没有单独的 `pipe` 调用号），要 CLOEXEC 得自己传 |
| 2.1.15 的 `fdinfo` 四行 | `pos: 0`、`flags: 0100000`（正文说这是 `O_LARGEFILE`）、`mnt_id: 28`、`ino: 1835009` | 本机 `pos: 0`、`flags: 0400000`、`mnt_id: 35`、`ino: 2755550`；且本机 `<fcntl.h>` 里 `O_LARGEFILE`=**0**、`O_NOFOLLOW`=`0100000`、`O_DIRECTORY`=`040000`、`O_CLOEXEC`=`02000000` | 正文那句按 `O_LARGEFILE` 解释 `flags` 在本机不成立；`f_flags` 与用户态 `O_*` 不是一回事，认位要用两个 fd 做差（`0400000`→加 `O_CLOEXEC` 变 `02400000`，加 `O_DIRECTORY` 变 `0440000`） |
| 2.1.15 的 `/proc/self/syscall` | `0 0x3 0x7ffd... 0x10 ...`（第一列 0 = `read`） | 本机 `cat /proc/self/syscall` 得 `63 0x3 0x... 0x20000 ...`；读**别的进程**的同名文件报 `Operation not permitted`（`ptrace_scope`=1），`strace -p <PID>` 也在 `PTRACE_SEIZE` 上失败 | 第一列随架构变（63 对 0）；「配合 `cat` 能快速确认」只对自家进程成立，跨进程观察在这台机器上要权限 |
| 2.1.15 的注入示例 | `strace -e inject=openat:error=EACCES:when=1 ./limits2` | 本机四次 `openat` 依次是 `/etc/ld.so.cache`、`libc.so.6`、`/sys/devices/system/cpu/online`、`/tmp`；`when=1` 打到链接器后程序**照常跑完并退出 0**，`when=4` 才得到 `= -1 EACCES (INJECTED)` 与程序自己的 `open /tmp: Permission denied` | 教学结论要补一句：注入前先用 `-o` 数清第几次是目标调用 |
| 2.1.13 的六条命令 | 只列命令，不给输出 | 本机退出码：`-v -n3 a.txt b.txt` 0（打印 `operands=2`）、`--count` **2** 且报 `option -n requires an argument`（报的是 `val`，不是长选项名）、`--col=never a.txt` 0、`-- -n` 0、`POSIXLY_CORRECT=1 ./opts a.txt -v` **0 且无任何输出**；`./opts a.txt --count` 是 2，加 `POSIXLY_CORRECT=1` 变 0 | 「GNU 重排 vs POSIX 停止」的干净对照是这一对；`-n abc` 与 `-n0` 都是 `EXIT_FAILURE`(1) |
| 2.1.7 的 `sysinfo` | 只给源码，没给读数 | 本机 `uptime 20904 s, procs 504`、`totalram 11921 MiB, freeram 10146 MiB`（与本书声明的约 12 GiB 内存一致） | 补一条本机读数，说明 `totalram` 与规格对得上、单位是 `mem_unit` 字节 |

另外三条不是差值，而是本机确认过的边界：`cc -m32` 报 `unrecognized command-line option`（32 位 ABI 那组结论无法在本机验证）；`namei -l /etc/hosts` 可用（2.1.15 排障第 3 步在本机可做）；`dmesg` 仍被 `dmesg_restrict` 挡住，所以 2.1.15 排障第 3 步里的 `dmesg | grep -i apparmor` 保持未实测。

## 4. 写作机对照（macOS 27.2，Apple 芯片 arm64）

下面四条是在写作机上真实跑出来的，用来把「Linux 的形状」和「换个系统就不成立」分开。它们**不是**本书测试 VM 的读数，也不能拿来替代 Linux 侧的实验。

- `sysconf(_SC_PAGESIZE)` = **16384**，`EAGAIN` = **35**，`ENOTSUP` = **45**；同一份打印这三个值的程序在 aarch64 Linux 上给出 4096/11/95。结论：`errno` 数值与页大小都属于系统/内核配置，代码里只能写名字、只能运行时查。
- `getopt_long` 在本机存在并可编译运行（`gcc -Wall -Wextra opts.c`），`x y -c 7` 这种「操作数在前」的写法也能解析到 `-c`，`POSIXLY_CORRECT=1` 会改变行为。所以「BSD/macOS 不重排」这句话在本书环境里**没有得到印证**，跨平台时对 `getopt` 的实现差异要按目标机实测，而不是按印象写进代码注释。
- 本机没有 `/proc`、没有 `strace`、没有 `__GLIBC__`：2.1.7 与 2.1.15 的所有取证动作只能回 Linux 做；`__GLIBC__` 的缺失也正是 `err_text()` 那段 `#if defined(__GLIBC__) && defined(_GNU_SOURCE)` 分支存在的理由。
- 没有 Linux 内核源码与 `/lib/modules`，2.1.14 的函数名与调用号一律按文档级结论读。

## 5. 本章未实测项

下面这些在本环境拿不到证据，引用时请当作**待验证的形状、量级或方法**，不要抄成事实：

- **正文标着 x86-64 的读数本身**：2.1.2 的三个纳秒、2.1.6 `limits` 的整段输出、2.1.9 `abi_probe` 的调用号与 `SYS_getpid` 那个 48211、2.1.15 的 `strace`/`fdinfo` 里的 inode 与 `mnt_id`（`123456` 这种整齐的数字只当占位）——这些是**另一台机器**的读数，本机无法复现它们，只能证明本机不是那个值。本机的对应读数已全部复跑并取得（见第 3 节），所以两边都可以引用；仍然没有的是「在同一台 x86-64 机器上复算正文那一组数」。
- **32 位 ABI 的两个后果**（`EOVERFLOW`、`_TIME_BITS=64`、`sizeof(time_t)` 变 4）：本机复跑确认 `cc -m32` 直接报 `unrecognized command-line option '-m32'`（没有 32 位支持），`sizeof(off_t)`/`sizeof(time_t)` 在三种宏下都是 8。这一组全部按文档级结论读；`_Static_assert` 只能反向演示（故意写错断言看编译器拦住），见 C3。
- **`prlimit` 跨进程与 `strace -p` 附着**：本机实测 `strace -p <同 uid 的兄弟进程>` 报 `ptrace: attach: ptrace(PTRACE_SEIZE, ...): Operation not permitted`，`cat /proc/<别人的 PID>/syscall` 同样报 `Operation not permitted`，`/proc/sys/kernel/yama/ptrace_scope` 为 1。所以「附着到已经在跑的进程」这一整类在本机不可用，一律改成在 strace 下启动；`prlimit --pid` 对别人的进程是否可用未测（`sudo` 不可用）。
- **内核侧探针**（2.1.14 结尾的 `sudo bpftrace -e 'kfunc:vfs_read ...'` 与 `sudo perf probe`）：`sudo` 与 `perf` 都不可用，而且符号可能被内联（`vfs_read` 在部分配置下是 `static inline`），探不到时要换 `ksys_read` 或架构的 `__arm64_sys_read`。免 root 的替代是 `/proc/self/io`、`strace -c`/`-T`、`/proc/self/fdinfo`。
- **写内核参数**：`echo 20 > /proc/sys/vm/dirty_ratio` 一类动作需要 root；`sysctl fs.nr_open fs.file-max` 只读到数值，没有验证写入路径。
- **seccomp 与容器复现**（2.1.9 errata 第 4 条、2.1.16 第三组坑）：`docker inspect`、换 `--security-opt seccomp=unconfined` 复跑都不在这台 VM 的权限内；「`EPERM` 常常是 seccomp」是机制层面的结论，本套件没有制造出一个容器内的 `EPERM` 现场。
- **LSM 日志**：`dmesg` 被 `dmesg_restrict=1` 挡住（这一点在第 1 篇的 1.8/1.9 套件里已实测），所以 2.1.15 排障第 3 步里的 `dmesg \| grep -i apparmor` 在本机不可用，只保留命令形状。
- **`strace` 与内核的字段稳定性**：`%file`/`%desc`、`inject=`、`-yy` 的可用性与 strace 版本相关，`fdinfo` 的字段与内核版本相关；本套件只确认了本机（strace 6.8、内核 7.0.0-38）能跑出这些形状，不承诺别的版本。
- **母本页码**：正文两处引 Kerrisk 第 11 章的页码（p177），本书约定只按章节号核对（中文版页码随印次变化）；`_SC_OPEN_MAX` 与 `RLIMIT_NOFILE` 的对应关系另有 `man 3 sysconf` 与本机的 `getconf OPEN_MAX` 可直接复核，页码不作为依据。

## 6. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/架构/内核/libc → 建议改法**」四段记，不要只写「我这里不对」——本章的结论大多挂在架构、内核配置、libc 版本和会话限制上，缺了最后一段就没有可比较的基准。四段这样填：

1. **现象**：一句话写清「谁在什么时候看起来坏了」。例：「`sysconf(_SC_OPEN_MAX)` 打印 1024，但正文写 1048576」。
2. **命令与输出**：贴你**原样敲的命令**与**未经删减的输出**（含退出码）。例：`ulimit -n` → `1024`；`cat /proc/self/limits | head -2` → 两行原文；`./limits` → 整段。
3. **机器/架构/内核/libc**：至少附 `uname -a`、`uname -m`、`cc --version \| head -1`、`ldd --version \| head -1`、`getconf PAGE_SIZE`、`nproc`、`ulimit -n`、`sysctl fs.nr_open fs.file-max 2>/dev/null`、`strace -V \| head -1`；涉及调用号时附 `./abi_probe` 的输出；涉及宏时附完整的编译命令行。
4. **建议改法**：写「该改成什么动作」而不是「正文错了」。例：「正文这一段应标成 x86-64 示例并补一句本机读数；程序应改用 `getrlimit(RLIMIT_NOFILE)`」。

最后把结论归到四类里的一类再说话：**规范/ABI 条款**（可以断言，如「ARM64 调用号在 `x8`」）、**本机工具输出**（可复算，如「本机 `_SC_PAGESIZE`=4096」）、**正文标注的示例读数**（只作形状参考，如那三个纳秒）、**未实测**（必须写清为什么没测，如 `perf`/`bpftrace`）。本章最常见的分歧来自把第三类当第一类引用，以及把「我这台机器的 `ulimit`」当成「程序的运行时限制」。
