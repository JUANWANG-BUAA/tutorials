# 2.6 勘误与版本注记

这一页收本章最容易「换一个内核版本、换一个文件系统、换一台机器就不成立」的东西：inotify 三道上限的默认值、`fs.protected_*` 的取值、`d_type` 的支持面、`renameat2` 的文件系统支持、外部工具的有无。正文每节里的 errata 盒讲**理解陷阱**（把 A 当成 B）；这一页讲**搬家陷阱**（在这台机器上成立、到那台机器上悄悄变）。页内所有实测读数都来自下面这台机器，**任何别的机器上的数字都不能引用**——引用数字必须带上它属于哪台机器、哪个内核、哪块盘。

**本章基线**：Ubuntu 24.04.5 虚拟机，**aarch64（ARM64）**，内核 `7.0.0-38-generic`，GCC 13.3.0，glibc 2.39，4 vCPU，页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上（挂载选项 `rw,relatime`），`/dev/shm` 是 tmpfs。`sudo` 与 `perf` 不可用；`ptrace_scope=1`。写作机是 macOS（Apple 芯片 arm64）：没有 `/proc`、没有 `strace`、`FIONREAD` 等行为不同，只当「换一个系统会怎样」的对照，正文实验一律回 Linux 做。

## 1. 容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「inotify 三道上限就是 16384/128/8192，到处一样」 | 都是 **sysctl 可调**的值：`max_queued_events`（每实例队列）、`max_user_instances`（每真实 UID 实例数）、`max_user_watches`（每真实 UID watch 数）。Kerrisk 成书时的默认是 16384/128/8192；现代发行版常把 `max_user_watches` 抬到 65536 或更高（本机读数见第 2 节）。改值要 root，本机只能读 | `cat /proc/sys/fs/inotify/max_queued_events max_user_instances max_user_watches` 逐个读；改值：`sysctl -w fs.inotify.max_user_watches=...`（要 root，本机未实测） |
| 「`d_type` 一定有值」 | `d_type` 是文件系统**可选**的优化：ext2/3/4、XFS、Btrfs、tmpfs 通常填；部分 NFS 服务器、FUSE、reiserfs 返回 `DT_UNKNOWN`。Kerrisk 成书时（Linux 3.2）还说「仅 Btrfs/ext2/3/4 全面支持」——XFS 后来才补上，这个支持面一直在变 | 在 `/tmp`（ext4）与 `/dev/shm`（tmpfs）各跑一次 `lsdir`；对可疑挂载点用 `fstatat` 分支验证 `DT_UNKNOWN` 是否出现 |
| 「`fs.protected_hardlinks`/`protected_symlinks` 默认是 1」 | 内核文档给的默认是 0，**发行版自己开**：Ubuntu 从 16.04 起默认 1、`protected_fifos`/`protected_regular` 默认 2。换发行版/老内核可能全 0，那时 `/tmp` 的链接攻击面完全不同 | `sysctl fs.protected_hardlinks fs.protected_symlinks fs.protected_fifos fs.protected_regular`；`man 5 proc_sys` 的 fs 段 |
| 「`renameat2` 的 flags 所有文件系统都支持」 | `RENAME_NOREPLACE` 支持面最广（基本等价 `rename`+独占检查）；`RENAME_EXCHANGE` 需要 `RENAME_WHITEOUT` 之外的 VFS 支持，NFS、部分 FUSE 返回 `EINVAL`；`RENAME_WHITEOUT` **仅 overlayfs** 有意义（容器镜像层的构建原语）。老内核（<3.15）没有这个系统调用，直接 `ENOSYS` | `./renamex` 在 `/tmp` 与 `/dev/shm` 各跑一次；对 NFS 挂载点（若有）重复，看 `EINVAL`/`EOPNOTSUPP` |
| 「`rename` 同文件时『成功且无变化』是 Linux 特例」 | 这是 **POSIX/SUSv 规定**的行为（源出早期 BSD 检查同文件的实现方式），不是 Linux 私货。但「两个路径是否指同一文件」的判定发生在调用内——跨文件系统时**没有**「同一文件」概念，照常 `EXDEV` | `touch x; ln x y; rename("x","y")` 返回 0 且两个名字都在；`man 2 rename` 的「If oldpath and newpath...」段 |
| 「`link` 对符号链接的行为到处一致」 | **POSIX 说实现定义**：Linux（与 Solaris）不解引用——给链接本身建硬链接，newpath 也是符号链接；多数其他 UNIX 按 SUSv3 解引用到目标。要跨平台确定行为用 `linkat(..., AT_SYMLINK_FOLLOW)`（跟）或不跟的 `linkat`，别用 `link()` | `ln a b && ln b c && readlink c`：Linux 上 `c` 是符号链接指向 `a`；`man 2 link` 的 BUGS/历史段 |
| 「`unlink` 删目录返回 `EPERM`」 | SUSv3 说 `EPERM`，**Linux 实际返回 `EISDIR`**（21）。跨平台代码两个都查，或先用 `S_ISDIR(lstat)` 分流 | `touch d; mkdir e; unlink("e")` 打印 errno → 21 |
| 「内核对符号链接环的容忍度就是 40 层」 | 两道限制：**单个路径部件**至少 `_POSIX_SYMLOOP_MAX`（8）次解引用（SUSv3 下限，Linux 2.6.18 前只有 5）；**整条路径**总共 40 次（Linux 实践值）。两个数字各管一段，混着说会算错极限用例 | `man 7 path_resolution` 的 SYMLOOP 段；自构造 40/41 层链接链实测（见[回忆卡](ch06-recall.md) 回忆 20） |
| 「`readlink` 的缓冲区开 `PATH_MAX` 就永不截断」 | Linux **没有定义** `SYMLINK_MAX`（SUSv3 要求 ≥255），目标字符串理论上可长于 `PATH_MAX` 的某些组合；规范姿势是「返回值 == bufsiz 就换更大的缓冲重试」。另外 `readlink` **不加 `\0`**，忘了补就是越界读 | `readlink` 返回值与 `bufsiz` 比较；`man 2 readlink` |
| 「`opendir` 的 fd 会在 exec 后泄漏」 | 不会：**`opendir` 自动设 `FD_CLOEXEC`**（SUSv3 要求）。但**你自己 `open` 的目录 fd 不会**——要显式 `O_CLOEXEC` | `strace -e trace=openat ./lsdir /tmp` 看 `opendir` 底层的 `openat` 带 `O_CLOEXEC`；`man 3 opendir` |
| 「inotify 监控期间权限被收走，事件就停了」 | `inotify_add_watch` 的读权限检查是**一次性**的（加 watch 那一刻）；之后文件权限怎么变，事件照发。这是设计（监控的是 inode 不是每次操作），但也意味着「能收到事件」不等于「有权读内容」 | 建 watch 后 `chmod 000` 该文件，事件照收（读内容才 `EACCES`） |
| 「`inotify` 可以替代文件系统日志/审计」 | 三个硬限制（合并/溢出/非递归）+ 两个语义（`IN_ONESHOT` 无 `IN_IGNORED`、`wd` 复用）决定了它只是**尽力而为的通知**。需要「不丢、可计数、可归因」用 fanotify（要 `CAP_SYS_ADMIN`）或审计子系统/应用层日志 | 本节 2.6.11 的六个坑；`man 7 inotify` 的「differences」段 |
| 「`lsof`/`findmnt`/`bpftrace` 是系统自带的」 | 全是外部包。这台机器上以第 2 节实测为准；`bpftrace` 未装时 2.6.14 实验二的后半段只能按未实测读，替代是读 `/proc/sys/fs/inotify/*` 与数 `/proc/*/fd` 的 `anon_inode:inotify` | `command -v lsof findmnt strace bpftrace` 逐条看 |

## 2. 复跑校正（2026-11-03，同一台 aarch64 VM）

下表只列**在这台 7.0.0-38 aarch64 VM 上真实跑出来**的项。方法：正文 C 程序（`lsdir`、`linkdemo`、`du2`、`watchdir`、`dirwalk`、`renamex`）按正文编译命令原样编译运行；实验文件全部留在 `/tmp/lab2c06p_*`，没有删除任何东西。

| 正文原写法 | 本机实测 | 结论 |
|:--|:--|:--|
| 2.6.14 「`max_user_watches` 通常 65536 或更高」 | `/proc/sys/fs/inotify/`：`max_queued_events=16384`、`max_user_instances=128`、`max_user_watches=1048576`（Ubuntu 24.04 的默认已抬到 1 MiB） | 与正文一致且更具体：本机 watch 配额非常宽裕，递归监听大树撞 `ENOSPC` 的概率低，但换容器/老内核要重读这三个数 |
| 2.6.2 `linkdemo` 预期输出（`nlink=2/2/1`、`soft.link size=10`） | 原样复跑：`link_demo.txt type=- nlink=2 size=6`、`hard.link type=- nlink=2 size=6`、`soft.link type=l nlink=1 size=10`、`soft.link -> link_demo.txt`、`unlink hard 后 nlink=1` | 与正文一致 |
| 2.6.9 `renamex` 预期输出 | 原样复跑（ext4）：`NOREPLACE onto existing: rc=-1 errno=17 (File exists)`、`NOREPLACE onto free name: rc=0`、`EXCHANGE: rc=0`、`rx_b = AAA`、`rx_c = BBB` | 与正文一致；同程序在 `/dev/shm`（tmpfs）同样通过 |
| 2.6.14 实验一 `strace -e trace=openat,getdents64` | strace 6.8 显式列名有效：`getdents64(4, 0x..., 32768) = 80`、`= 0`；`-yy` 正常把 fd 映射成 `/tmp/tree` | 与正文一致；补充：`%stat` 类调用类名在本机 strace 6.8 上静默为空（同 2.5 的坑），必须显式列名 |
| 2.6.10 「`fs.protected_*` 默认（常见）」表 | `sysctl fs.protected_hardlinks fs.protected_symlinks fs.protected_fifos fs.protected_regular` → `1 1 2 2` | 与正文一致（Ubuntu 24.04 全部收紧）；这四个值是发行版开的，不是内核编译默认 |
| 2.6.3 `lsof +L1` 找已删除文件 | 本机 **`lsof` 未安装**（`command -v lsof` 为空） | 正文命令跑不了；替代：`ls -l /proc/*/fd/* 2>/dev/null | grep deleted`（免特权、覆盖同用户进程），或按未实测读 |
| 2.6.14 实验二 `sudo bpftrace -e 'kprobe:inotify_add_watch ...'` | `bpftrace` 未安装且 `sudo` 不可用 | 本机不可做，按未实测读；可做的替代是数 `find /proc/*/fd -lname 'anon_inode:inotify' \| wc -l` |
| 2.6.5 `watchdir` 事件序列（`echo` 产生 CREATE/MODIFY/CLOSE_WRITE、`mv` 产生 MOVED_FROM+MOVED_TO 同 cookie） | 后台起 `./watchdir /tmp/lab2c06p_w` 后执行 `echo hi > a.txt` 与 `mv a.txt b.txt`：读数与正文一致，两个 MOVED 事件 `cookie` 相同 | 与正文一致 |
| 2.6.1 `lsdir` 对 `/tmp`（ext4）与 `/dev/shm`（tmpfs） | 两处 `d_type` 均正常返回（无 `DT_UNKNOWN`）；`DT_UNKNOWN` 分支未触发 | 本机两个文件系统都填 `d_type`；「会遇 `DT_UNKNOWN`」的场景在本机要靠 NFS/FUSE（无，未实测），代码分支仍必须写 |

## 3. 本章未实测项

下面这些在这台 VM 上拿不到证据，引用时一律当**待验证的机制结论**，不要抄成读数：

- **一切要 root 的动作**：改 `fs.protected_*`、调 inotify 三道上限、`bpftrace` 观测 `inotify_add_watch`、`fanotify`（要 `CAP_SYS_ADMIN`）。`sudo` 不可用，全部按「机制结论 + 未实测」。
- **`DT_UNKNOWN` 真实现场**：本机 ext4/tmpfs 都填 `d_type`；NFS、FUSE、reiserfs 的行为是文档级结论，这台机器没有可挂载的第二块盘（挂载本身要 root）。
- **`RENAME_EXCHANGE` 在 NFS/FUSE 上 `EINVAL`**：本机没有 NFS/FUSE 挂载点；ext4/tmpfs 都支持。
- **符号链接环 40 层的边界**：[回忆卡](ch06-recall.md) 回忆 20 引用的 40/41 层实测来自 2.5 章 `lstat` 实验（同一台机器、同一机制），本章未单独重跑；跨内核版本别外推。
- **`IN_Q_OVERFLOW` 现场复现**：要写入超过 `max_queued_events`=16384 个事件且消费慢于生产，构造耗时且对机器不友好，未在本机复现；溢出后「全量重扫」是机制结论。
- **`getcwd` 的 4096 页大小限制**（Kerrisk §18.10）：内核为返回路径分配一页（本机页 4096），超长 cwd 会截断——本机没构造超 4096 字节的深层目录验证，按文档级读。
- **容器内对照**：docker 免 sudo 可用但本轮未把本章程序搬进容器跑；overlayfs 的 `RENAME_WHITEOUT`、卷上的 inotify 行为都留待第 5 篇。

## 4. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/内核/文件系统/工具版本 → 建议改法**」四段写，缺第四段就没有可比较的基准：

1. **现象**：一句话说清谁看起来坏了。例：「`watchdir` 对子目录里建文件毫无反应」。
2. **命令与输出**：贴**原样敲的命令**与**未经删减的输出**（含 errno 数字与退出码）。
3. **机器口径**：至少附 `uname -a`、`df -T /tmp`、`cat /proc/sys/fs/inotify/*`、`sysctl fs.protected_*`、`strace -V | head -1`、`command -v lsof bpftrace`；涉及 `d_type`/`renameat2` 的附文件系统类型。
4. **建议改法**：写「该改成什么动作」。例：「正文 2.6.3 的 `lsof` 应补 `/proc/*/fd` 的免权替代命令」。

归类再说话：**规范条款**（`_POSIX_SYMLOOP_MAX`=8、rename 同文件行为是 POSIX 规定）、**本机读数**（16384/128/1048576、protected 1/1/2/2）、**随内核/文件系统/发行版变的量**（`d_type` 支持面、sysctl 默认值、`renameat2` flags 支持）、**未实测**（写清为什么没测）。本章最常见的分歧有两种：把「Ubuntu 开的 sysctl 默认值」当「内核默认值」，以及把「inotify 的尽力而为通知」当「可靠日志」。
