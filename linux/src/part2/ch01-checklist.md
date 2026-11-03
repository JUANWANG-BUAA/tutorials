# 2.1 学习目标自检表

这张表接管 [2.1.17 本章小结](ch01.md#sec-2.1.17)：左列是达标项，中列是「怎样算达标」，右列是「没达标回到哪一节」。正文只留证据口径，这里按**概念（K）、动手（S）、实验（E）、口径（B）** 四组展开成 24 条（K 11、S 5、E 4、B 4）；达标线全部写成能当场做的动作——能写出、能说出、能跑出来，做不到就回右列重读那一段，不要从头再读整章。环境边界（这台机器是 aarch64、`sudo` 与 `perf` 不可用、正文哪几处读数属于另一台机器）统一记在[勘误与版本注记](ch01-errata.md)，E 组与 B 组每一条都以那一页为准。

## 达标检验

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 六步路径与两次翻译** | 不看正文画出「用户态 glibc 包装 → 排寄存器 → 陷入 → 内核入口查表 → 返回值放原寄存器 → libc 翻译」，并指出「内核 `-errno` ↔ libc `-1`+`errno`」与「C 原型 ↔ 寄存器 ABI」这两个翻译点各在哪层 | [2.1.1](ch01.md#sec-2.1.1)；回忆 1、[A1](ch01-exercises.md#ex-2.1-A1) |
| **K2 系统与库的判据 + vDSO** | 30 秒内说出判据（是否执行陷入指令 + 语义由谁保证），把 `printf`/`write`/`malloc`/`mmap`/`getpid`/`clock_gettime` 六个归位，说明 `man` 分节为什么不算本质区别；再说出一类走 vDSO 的调用、为什么便宜一个数量级、为什么地址不能当常数引用 | [2.1.1](ch01.md#sec-2.1.1)、[2.1.2](ch01.md#sec-2.1.2)；回忆 3–4、[A2](ch01-exercises.md#ex-2.1-A2) |
| **K3 `errno` 七条规则** | 七条全说且不误写成「成功会清零」；说出线程私有是怎么实现的（`(*__errno_location())`）；复述「成功但 `errno` 仍是上次的值」那个场景；列出「不设 `errno` 的三类」：`pthread_*` 返回错误码、`snprintf` 截断、裸汇编陷入 | [2.1.3](ch01.md#sec-2.1.3)；回忆 6、[A3](ch01-exercises.md#ex-2.1-A3)、[B2](ch01-exercises.md#ex-2.1-B2) |
| **K4 三层错误处理与四步顺序** | 按「能否恢复 / 进程还有别的事吗 / 继续跑会错吗 / 在信号处理器里吗」给三个场景各选一层；说出信号处理器里为什么只能用 `write` 加预格式化字符串 | [2.1.4](ch01.md#sec-2.1.4)；回忆 8 |
| **K5 特性测试宏：机制与矩阵** | 说出宏控制声明可见性而非运行时行为、必须早于第一个系统头（`<features.h>` 只算一次）；说出 `-std=c17`/`-std=gnu17` 的差且 `gnu17 ≠ _GNU_SOURCE`；说出 `_GNU_SOURCE` 隐式打开哪些、显式 `_POSIX_C_SOURCE` 为什么让 `accept4`/`pipe2`/`strdup` 失去声明；说出 `_FILE_OFFSET_BITS=64` 改的是 `struct stat` 布局、`_TIME_BITS=64` 为什么要和它一起定义 | [2.1.5](ch01.md#sec-2.1.5)、[2.1.11](ch01.md#sec-2.1.11)；回忆 9–11、[A5](ch01-exercises.md#ex-2.1-A5)、[B1](ch01-exercises.md#ex-2.1-B1) |
| **K6 运行时限制的三态** | 把 `sysconf`/`pathconf`/`fpathconf` 的 `-1` 三种含义讲全（值 / 不确定 / 失败）并说明为什么要先 `errno = 0`；说出 `_SC_PAGESIZE`、`_SC_ARG_MAX`、`_PC_NAME_MAX`、`_PC_PIPE_BUF` 各查什么、哪个随文件系统变、哪个随会话 `ulimit` 变 | [2.1.6](ch01.md#sec-2.1.6)、[2.1.12](ch01.md#sec-2.1.12)；回忆 12–13、[def-2.1.3](ch01.md#def-2.1.3) |
| **K7 三层 fd 限制谁说了算** | 说出 `fs.nr_open`/`fs.file-max`、`RLIMIT_NOFILE` 的软与硬、`sysconf(_SC_OPEN_MAX)` 的层级关系；区分 `EMFILE` 与 `ENFILE`；说出程序该按哪个数分配 fd 表；按五步顺序说出排查动作 | [2.1.12](ch01.md#sec-2.1.12)；回忆 20、[B3](ch01-exercises.md#ex-2.1-B3) |
| **K8 系统调用 ABI** | 填出四架构的陷入指令、调用号寄存器、参数寄存器与返回寄存器；解释 x86-64 第四个参数为什么是 `r10`；说出「六」的由来与 `clone3`/`openat2` 的结构体 + `size` 解决什么 | [2.1.9](ch01.md#sec-2.1.9)、[def-2.1.4](ch01.md#def-2.1.4)；回忆 16、[A6](ch01-exercises.md#ex-2.1-A6) |
| **K9 内核侧：坏指针与短计数** | 说出传坏指针为什么不是 `SIGSEGV`、`access_ok` 与 `copy_*_user` 各查什么；用 `vfs_read` 的三行检查解释「截到约 2 GiB」「`EBADF` 与 `EINVAL` 分家」「`EFAULT`」；说明短计数不是失败、`0` 是 EOF | [2.1.9](ch01.md#sec-2.1.9)、[2.1.14](ch01.md#sec-2.1.14)；回忆 17、22、[B4](ch01-exercises.md#ex-2.1-B4) |
| **K10 错误码的对外翻译** | 说出 `strerror_r` 两个版本的返回值差异与 GNU 版的静态字符串坑；说出 `EAGAIN == EWOULDBLOCK`、`ENOTSUP != ENOSYS`、`ENODATA`/`ENOATTR` 的跨平台差；给出九个 `errno` 到 HTTP 的映射与「退出码只有 8 位」的后果（`exit(256)`→0） | [2.1.10](ch01.md#sec-2.1.10)；回忆 18–19 |
| **K11 `getopt_long`** | 说出 `struct option` 四字段与六种返回值；解释 `optstring` 开头 `:` 与 `+` 各改什么、`POSIXLY_CORRECT` 与 `--` 的角色、`optional_argument` 为什么必须写 `=`、`optind = 0` 为什么属于 GNU 扩展 | [2.1.13](ch01.md#sec-2.1.13)；回忆 21、[B5](ch01-exercises.md#ex-2.1-B5) |
| **S1 写出错误处理三件套** | 不看正文写出 `errMsg`/`errExit`/`errExitEN`（含 `int saved = errno;` 与还原、用 `vsnprintf` 而不是 `snprintf`），`cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror` 一次通过 | [2.1.4](ch01.md#sec-2.1.4)；[C1](ch01-exercises.md#ex-2.1-C1) |
| **S2 写对限制查询** | 写出「先 `errno = 0`，返回后区分失败/不确定/数值」的 `sysconf` 包装；用 `getrlimit(RLIMIT_NOFILE)` 打印本机软硬限制，并在硬限内提高软限一次（超硬限要能看到 `EPERM`） | [2.1.6](ch01.md#sec-2.1.6)、[2.1.12](ch01.md#sec-2.1.12)；[C2](ch01-exercises.md#ex-2.1-C2) |
| **S3 写对 `strerror_r`** | 写出按 `_GNU_SOURCE` 分支的 `err_text()`（或改用 `strerror_l`），不假设返回值等于自己的缓冲区、不 `free` 它 | [2.1.10](ch01.md#sec-2.1.10)；回忆 18 |
| **S4 写一个可用的解析器** | `opts.c` 编译通过后，六条命令（`-n3`、`--count=2 --color --output=...`、`--count`、`--col=never`、`-- -n`、`POSIXLY_CORRECT=1`）都能说出走到哪个 `case` 与退出码；用法错误与数据错误用不同退出码 | [2.1.8](ch01.md#sec-2.1.8)、[2.1.13](ch01.md#sec-2.1.13)；[C6](ch01-exercises.md#ex-2.1-C6) |
| **S5 用编译期断言锁 ABI** | 在需要 64 位偏移的程序里写 `_Static_assert(sizeof(off_t) == 8, "加 -D_FILE_OFFSET_BITS=64")`，并能把它故意改错一次，说出编译器如何拦住 | [2.1.11](ch01.md#sec-2.1.11)；[C3](ch01-exercises.md#ex-2.1-C3) |
| **E1 `errno` 实验** | 跑通 `errno_demo`，四行输出（含 `exit=0`）；改成 `SA_RESTART` 后用 `timeout 5` 观察到「不再打印第三行 + 退码 124」，并说出这两件事各证明哪条规则 | [2.1.3](ch01.md#sec-2.1.3)、[2.1.4](ch01.md#sec-2.1.4)；[C1](ch01-exercises.md#ex-2.1-C1) |
| **E2 本机取数并对照** | 跑 `limits`/`limits2`，做成「本机值 / 正文值 / 归属原因」四列表，至少列出四个差异：架构名与内核版本（`aarch64`、7.0.0-38）、`_SC_OPEN_MAX`（本机 1024，等于 `ulimit -n`，正文 1048576）、`_SC_NPROCESSORS_ONLN`（本机 4，正文 8）、`/tmp` 的文件系统（本机 ext4 根分区，`NAME_MAX` 255 与正文相同纯属巧合） | [2.1.6](ch01.md#sec-2.1.6)、[2.1.12](ch01.md#sec-2.1.12)；[C2](ch01-exercises.md#ex-2.1-C2) |
| **E3 特性宏与调用号** | 说出无宏版本为什么直接编译失败（`off_t undeclared`，`__STRICT_ANSI__` 关掉默认扩展）并给出修法；三种组合 `__USE_GNU`/`__USE_XOPEN2K8`/`__USE_MISC` 读出 `000`/`010`/`111`；复现「`accept4` 隐式声明 → 加 `_GNU_SOURCE` 就过 → 去掉 `-Werror` 仍能链接」；在 aarch64 上打印 `SYS_read`=63、`SYS_openat`=56 并与正文数字对照 | [2.1.5](ch01.md#sec-2.1.5)、[2.1.9](ch01.md#sec-2.1.9)、[2.1.11](ch01.md#sec-2.1.11)；[C3](ch01-exercises.md#ex-2.1-C3)、[C4](ch01-exercises.md#ex-2.1-C4) |
| **E4 `strace` 与 `/proc` 取证** | 用 `-f -yy -e trace=%file,%desc` 指出 fd 3 被两个不同路径依次复用；本机 libc 路径读出 `aarch64-linux-gnu`；看到 `pipe2(..., 0)` 并能拒绝「`pipe()` 自动设 `CLOEXEC`」；`fdinfo` 的 `flags` 用两个 fd 做差认位（不把 `0400000` 念成 `O_LARGEFILE`）；`/proc/self/syscall` 第一列读出 63；用 `-o` 数出目标 `openat` 是第 4 次后，`-e inject=openat:error=EACCES:when=4` 真的让程序走进 `EACCES` 分支 | [2.1.7](ch01.md#sec-2.1.7)、[2.1.15](ch01.md#sec-2.1.15)；[C5](ch01-exercises.md#ex-2.1-C5) |
| **B1 读数归属** | 对本章任意一个数字说出「哪个架构、哪个内核、哪个 libc、哪种会话限制」，并区分四类：规范/ABI 条款、本机工具输出、正文标注的示例读数、未实测；每类各举一例 | [本章依据](ch01-overview.md)、[勘误与版本注记](ch01-errata.md)；回忆 22 |
| **B2 环境边界** | 说出测试 VM 是 Ubuntu 24.04.5 **aarch64**（不是 x86-64）、内核 7.0.0-38、GCC 13.3.0、glibc 2.39、4 vCPU；列出本机不能做的三件事（`sudo`、`perf`、写 `/proc/sys/*`）与各自的替代读数 | [环境口径](ch01-overview.md)、[勘误与版本注记](ch01-errata.md) |
| **B3 换 libc / 换系统会搬家什么** | 说出至少四条：`SYS_read` 编号、`errno` 数值（写作机 macOS 实测 `EAGAIN`=35、`ENOTSUP`=45）、页大小（本机 4096、Apple Silicon 16384）、只给 XSI 版 `strerror_r` 的 libc；结论落回「按名字比较错误码、按运行时查询限制」 | [2.1.8](ch01.md#sec-2.1.8)、[2.1.10](ch01.md#sec-2.1.10)、[勘误与版本注记](ch01-errata.md) |
| **B4 手册与规范优先** | 遇到「这个接口要哪个宏」时给出查证动作而不是背数字：`man 2 accept4` 的 FEATURES 段、`man 3 errno`、`man 2 sysconf` 的返回值三态、`grep` 本机 `SYS_*` 定义 | [2.1.2](ch01.md#sec-2.1.2)、[2.1.5](ch01.md#sec-2.1.5)；[C3](ch01-exercises.md#ex-2.1-C3)、[C4](ch01-exercises.md#ex-2.1-C4) |

## 没达标怎么办

- **K 组卡住（概念行）**：先把因果讲成一句完整的话，例如「因为显式定义 `_POSIX_C_SOURCE` 后 glibc 不再默认给 `_DEFAULT_SOURCE`，`accept4` 的声明从 `<sys/socket.h>` 消失，所以编译器按未声明函数处理，链接却仍能命中 libc 里的符号」。讲不出这句就回对应小节的 `errata` 盒重读，不要靠多读几遍正文。
- **S 组卡住（动手行）**：三件必写的东西合上正文默写——`vErr` 的保存与还原、`sysconf` 的三态判断、`getopt_long` 的 `case ':'` 与 `case '?'` 两个分支。写不出就抄一遍 2.1.4 的 `err.c` 再默写一次；`errExitEN` 那条要连「它给谁用」一起写。
- **E 组卡住（实验行）**：先确认环境边界再排错。`cc`/`strace`/`getconf`/`/proc` 本机可用，`sudo` 与 `perf` 不可用；`strace -p <PID>` 可能被 `ptrace_scope` 挡住，改成「在 strace 下启动」；`-e inject=...:when=1` 命中的通常是动态链接器，先 `-o` 数清楚第几次才是你要的那次。跑不出预期就把结论降级成「未实测 + 原因」，不要用一次读数推一个常数。
- **B 组卡住（口径行）**：本章正文有四处标着或暗示 x86-64 的读数，而测试机是 aarch64。逐条对照[勘误页](ch01-errata.md)第 3 节「复跑校正」：调用号、libc 路径、CPU 数、纳秒数、vDSO 地址形态、`fdinfo` 的 `flags` 解释、`/proc/PID/syscall` 的权限，本机都已经复跑并取得对应数值；`_SC_OPEN_MAX`、`NAME_MAX`、管道容量属于「换内核配置 / 文件系统 / 会话限制要重取」。
- **只有 K 组全对**：说明还停在「会读」。这一章的出口是「能解释 + 能操作 + 能判断」三条判据（见[章末总结](ch01-summary.md)），S 组与 E 组没做完不要勾这一页。

全部达标后，往下的接口有三处：[2.2 文件 I/O](ch02.md) 会立刻用到 `EINTR` 重试、短计数与「fd 0 是合法值」；[2.10 信号](ch10.md) 把本章「`EINTR` 不是失败」「信号处理器里只能用 `write`」讲完整；[2.12 线程](ch12.md) 与 [2.13 线程同步](ch13.md) 会用到「`errno` 线程私有、`pthread_*` 返回错误码、`getopt` 用全局状态」这三条。
