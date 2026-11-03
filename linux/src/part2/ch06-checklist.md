# 2.6 学习目标自检表

这张表接管 [2.6.16 本章小结](ch06.md#sec-2.6.16)的达标线：左列是达标项，中列是「怎样算达标」——全部写成能当场做的动作，右列是「没达标回到哪一节」。出口表只有 8 条，这里按**概念（K）、动手（S）、实验（E）、口径（B）**四组展开成 20 条。动手前先确认环境边界：测试机是 aarch64 VM，`sudo` 不可用、`fs.protected_*` 与 inotify 上限只能读不能改，哪些能做、哪些只能按「未实测」读，全在[勘误与版本注记](ch06-errata.md)。

## 达标检验

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 目录的两层结构** | 能说出目录在磁盘上是什么（名字→inode 号的映射表）、`st_size` 是什么口径；说出目录 `r`/`w`/`x` 各管什么；为什么不能对目录 `read()`/`write()` | [2.6.1](ch06.md#sec-2.6.1)、[2.6.6](ch06.md#sec-2.6.6) |
| **K2 `readdir` 四条纪律** | 能完整说出：`errno=0` 区分 EOF 与错误、`d_name` 下次调用被覆盖要 `strdup`、顺序不保证（htree 哈希序）、`DT_UNKNOWN` 用 `fstatat` 补齐 | [2.6.1](ch06.md#sec-2.6.1) |
| **K3 硬链接 vs 符号链接** | 能画出两种链接在目录项/inode/数据三层的差别；说出符号链接不计入目标 `nlink`、相对目标以链接自身位置为参照、可以悬空；硬链接的两条限制（同 FS、不能对目录）各为什么 | [2.6.2](ch06.md#sec-2.6.2) |
| **K4 数据释放的双计数** | 能说出 `unlink` 之后数据在什么条件下释放（`nlink==0` **且**无打开 fd）；能用这个机制解释「`rm` 后 `df` 不降」与「`tmpfile()` 式临时文件」两个现象 | [2.6.3](ch06.md#sec-2.6.3) |
| **K5 `rename` 边界规则** | 能说出：同文件系统才原子（`EXDEV`）、目标存在则覆盖、old 与 new 同文件时成功且无变化、两个参数都不解引用符号链接、目录改名时 new 不能含 old 前缀（`EINVAL`） | [2.6.3](ch06.md#sec-2.6.3) |
| **K6 `*at` 家族的两个动机** | 能说出 TOCTOU（路径前缀可被替换）与每线程虚拟工作目录（`cwd` 进程级共享）各是什么；`AT_FDCWD` 是什么值；为什么 `*at` 本身不防 `..` 逃逸、要用什么补 | [2.6.8](ch06.md#sec-2.6.8) |
| **K7 inotify 三个限制** | 能说出尾部合并（不能计数）、队列溢出（`IN_Q_OVERFLOW` 后全量重扫）、非递归（新目录补 watch）的现象与应对；`IN_IGNORED` 的三种来源与 `wd` 复用的后果 | [2.6.11](ch06.md#sec-2.6.11)、[2.6.12](ch06.md#sec-2.6.12) |
| **K8 watch 挂在 inode 上** | 能说出为什么 rename 被监控对象后 watch 仍有效（`IN_MOVE_SELF` 另发）；`inotify_add_watch` 的读权限是一次性检查——之后收权限事件照发 | [2.6.11](ch06.md#sec-2.6.11)、[2.6.13](ch06.md#sec-2.6.13) |
| **S1 正确的 readdir 循环** | 合上正文写出：`errno=0` 前置、跳过 `.`/`..`、`DT_UNKNOWN` 分支调 `fstatat(dirfd(d), ...)`、循环后查 `errno` 的完整循环，编译零警告 | [2.6.1](ch06.md#sec-2.6.1) |
| **S2 两种链接构造与读数** | 能跑 `linkdemo` 并报出：硬链接 `nlink=2`、符号链接 `nlink=1 size=10`（10 是目标字符串长度）、`unlink` 一个后 `nlink=1`；`readlink` 后自己补 `\0` | [2.6.2](ch06.md#sec-2.6.2) |
| **S3 renameat2 两连** | 能编译 `renamex` 并报出：`NOREPLACE` 打在已有目标上 `errno=17 (EEXIST)`、打在空名上成功、`EXCHANGE` 后两个文件内容互换 | [2.6.9](ch06.md#sec-2.6.9) |
| **S4 目录 fd 锚定访问** | 能写出 `open(dir, O_RDONLY|O_DIRECTORY)` → `openat(dirfd, name, O_RDONLY|O_NOFOLLOW)` 的完整代码，并说出每一步防了什么（`chdir` 干扰、最后一段被换成符号链接） | [2.6.8](ch06.md#sec-2.6.8) |
| **S5 `nftw` 统计** | 能编译 `du2` 统计 `/usr/include` 的块占用（`st_blocks*512` 口径），说出为什么用 `FTW_PHYS`、回调为什么不能 `longjmp` | [2.6.4](ch06.md#sec-2.6.4) |
| **S6 递归 inotify** | 能编译 `watchrec`，对一棵树验证三件事：新建子目录后事件照收（补 watch 生效）、`rm -r` 后 `IN_IGNORED` 清映射、说出溢出时该做什么 | [2.6.12](ch06.md#sec-2.6.12) |
| **E1 `strace` 辨调用** | 能用显式调用名跑 `strace -e trace=openat,getdents64,close ./dirwalk /tmp/tree`，报出 `getdents64(..., 32768) = 80` 与 `= 0` 两行并解读；说出 `%stat` 类名在本机为什么是空输出 | [2.6.14](ch06.md#sec-2.6.14)、[勘误页](ch06-errata.md) |
| **E2 inotify 上限读数** | 能报出本机 `/proc/sys/fs/inotify/` 三个文件的实际值，并说出每个限制「每实例还是每 UID」；`find /proc/*/fd -lname 'anon_inode:inotify' | wc -l` 数实例 | [2.6.14](ch06.md#sec-2.6.14) |
| **E3 链接保护现场** | 能报出本机 `sysctl fs.protected_hardlinks fs.protected_symlinks` 的值；对 `/tmp` 里不属于自己的文件建硬链接实测 `EPERM`（或解释为什么本机测不了） | [2.6.10](ch06.md#sec-2.6.10) |
| **E4 数据释放取证** | 能构造「打开大文件 → `unlink` → `df` 不降 → 关 fd → `df` 下降」的完整实验（或用 `du` 前后对照），说出每一刻 `nlink` 与 fd 的状态 | [2.6.3](ch06.md#sec-2.6.3) |
| **B1 数字归属** | 能把本章数字分成四类：规范条款（`_POSIX_SYMLOOP_MAX`=8、整路径 40 是 Linux 实践）、本机读数（`max_queued_events=16384` 等）、按内核/文件系统变的量（`d_type` 支持面、`fs.protected_*` 默认值）、未实测（改 sysctl、`bpftrace`）；每类各举一例 | [勘误与版本注记](ch06-errata.md) |
| **B2 本机环境边界** | 能报出测试机口径（aarch64、内核 7.0.0-38、`/tmp` 在 ext4），并说出 `sudo` 不可用挡住了哪些实验（改 sysctl、调 inotify 上限）、`strace -p` 不可用对取证的影响 | [章总览·环境口径](ch06-overview.md)、[勘误页](ch06-errata.md) |

## 没达标怎么办

- **K 组卡住**：每个概念先讲一句完整因果再说下一步。例：「因为 watch 挂在 inode 上而不是路径上，所以 rename 之后事件照发、只是另发一个 `IN_MOVE_SELF`」。讲不出因果就回对应小节的 errata 盒重读，不要多刷几遍文字。
- **S 组卡住**：合上正文在 `/tmp/lab2c06p_` 前缀下重做一遍对应程序（总览与勘误页里都有编译命令）；跑不出先核对头文件与编译选项（`fts_skip.c` 需要 `<fts.h>`，`watchrec.c` 用了 `-D_GNU_SOURCE`）。
- **E 组卡住**：先确认命令在本机哪些跑不了（`sudo` 挡住改 sysctl、`bpftrace` 未装），把这些「跑不了」本身当成读数记下来，不要改成「凭印象的输出」。
- **B 组卡住**：把想引用的每个数字问三遍：这是条款、本机读数，还是随内核/文件系统变的量？后两类必须带出处引用。[勘误页](ch06-errata.md)的「复跑校正」表就是示范。
- **只有 K 组全对**：说明还停在「会读」。本章要求会跑、会取证；把 S 组与 E 组做完再来勾这一页。

全部达标后，往下的接口有两处：[2.7 进程创建与终止](ch07.md) 把视角从文件树切到进程生命周期（`fork` 复制的正是本章反复出现的 fd 表与 `cwd`）；项目侧「日志轮转后还写旧文件」「容器卷上 inotify 丢事件」「镜像里 `.git` 没排除」三类问题的判据分别沉淀在 [2.6.3](ch06.md#sec-2.6.3)、[2.6.13](ch06.md#sec-2.6.13) 与 [2.6.7](ch06.md#sec-2.6.7)。
