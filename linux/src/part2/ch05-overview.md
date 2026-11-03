# 2.5 文件属性、扩展属性与 ACL · 本章导航

::: preview 这一章在讲什么
[2.2](ch02.md) 把文件当字节流，[2.3](ch03.md) 加了映射与锁。这一章看文件的另一半：类型、权限、属主、大小、时间、扩展元数据。`ls -l` 的每一列都是 `struct stat` 的字段，`getfacl` 的每一条规则落盘是一个名为 `system.posix_acl_access` 的扩展属性（xattr，挂在 inode 上的键值对）。主线一句话：**元数据也是数据**——它占空间、有并发问题、有缓存与持久化语义。理解这点，才能解释 `du` 与 `ls -l` 为什么打架、拷文件为什么会丢 ACL、`chmod 640` 为什么悄悄改掉 ACL 的 mask。
:::

## 本章回答什么

- **`stat` 家族怎么选**：`stat` 跟随符号链接、`lstat` 看链接本身、`fstat` 用已开的 fd、`fstatat` 相对目录 fd 解析；`struct stat` 每个字段什么时候变（2.5.1）。
- **内核凭什么判断「你能不能开这个文件」**：类型宏、`rwx` 对目录的三种含义、root→属主→属组→其他四步检查算法、`umask` 只在创建时减位、`access()` 的双重问题（2.5.2）。
- **`ls -l` 与 `du` 为什么不一致**：`st_size` 是逻辑大小、`st_blocks` 固定按 512 字节数、稀疏文件读空洞不占块；三个时间戳各在何时更新、`ctime` 不是创建时间（2.5.3）。
- **`chmod`/`chown` 还做了什么**：`chown` 成功清 setuid/setgid（属主没变也清）；`fchmodat` 对符号链接在 Linux 返回 `ENOTSUP`；特殊位对文件与目录语义不同（2.5.4）。
- **扩展元数据存哪**：xattr 四个命名空间与各自的权限门槛、`getxattr` 的 `ERANGE`/`ENODATA` 与两步查询（2.5.5、2.5.12）。
- **比 `rwx` 更细的权限**：ACL 的 ACE 结构、`mask` 是命名用户/组和属组的有效上限、`chmod g=` 改的是 mask、默认 ACL 与 `umask`、`mode` 的联合算法（2.5.6、2.5.13、2.5.14）。
- **`stat` 装不下的东西**：`statx` 的 btime/`mnt_id`/直接 I/O 对齐、`stx_mask` 先看再读；`statvfs` 看整个文件系统的空间与 inode（2.5.7、2.5.9）。
- **字段不是「一堆整数」**：`struct stat` 是内核与用户态共享的 ABI，`_FILE_OFFSET_BITS` 改布局；`(st_dev, st_ino)` 只在同一设备内唯一（2.5.8）。
- **时间的完整语义**：`relatime`/`noatime`/`lazytime` 下 `atime` 何时不动、`utimensat` 与老接口 `utime`/`utimes`（2.5.10）。
- **inode 级强制**：`chattr` 与 `FS_IOC_*FLAGS`，哪些位属主能设、哪些要 capability，`immutable` 连 root 都得先清（2.5.11）。
- **落到内核与落到读数**：`statx`/xattr/ACL 在 ext4 里的函数路径；`strace` 与 `getfacl`/`acl_raw` 怎么把结论变成屏幕上的行；十八节收进三组坑与一张出口表（2.5.15–2.5.18）。

## 读完你会

- 用 `lstat`/`stat -c` 说清符号链接的 `st_size` 为什么是目标路径字符串的长度，`st_mode` 类型位为什么只有 `lstat` 能看到 `S_IFLNK`。
- 举一个稀疏文件解释 `ls -l` 显示 1 GiB 而 `du` 显示 0：`st_size`、`st_blocks * 512`、`st_blksize` 三个数各是什么口径。
- 说出 `atime`/`mtime`/`ctime` 的更新时机，并当场用 `chmod` 与追加写各验证一次「只动 `ctime`」与「`mtime`+`ctime` 一起动」。
- 写出正确处理 `errno` 的 xattr 两步查询（先 `getxattr(..., NULL, 0)` 问长度再取），并解释 `ERANGE`、`ENODATA`、`ENOTSUP`、`E2BIG`、`ENOSPC` 各对应什么原因。
- 用 `setfacl`/`getfacl` 给一个用户加读权限，`chmod 640` 之后指出被改的是 `mask`、条目还在、有效权限变小，并用 `setfacl -m m::rw` 恢复。
- 不依赖 libacl，直接解码 `system.posix_acl_access` 的原始字节：4 字节头 + 每条 8 字节，`e_tag`/`e_perm`/`e_id` 逐个念。
- 用 `statx` 取 `btime` 与 `mnt_id`，并先检查 `stx_mask` 再读字段；解释 `STATX_ALL` 为什么不可依赖。
- 判断「这个进程能不能打开这个文件」时按四步算法走，说出 `access()` 的 real/effective UID 差异与 TOCTOU 窗口，给出直接 `open` + 处理 `EACCES` 的替代。
- 说出 `chattr +i` 之后哪些系统调用全部 `EPERM`、为什么 root 也绕不过；说出普通用户在这台机器上实际能设哪几位。
- 遇到「新建文件权限不对」按固定顺序排查：父目录默认 ACL → `umask` → `mask::` 与 `effective:` → `stat -c %a` → 文件系统是否支持 ACL。

## 先修与预计学时

- 文件与 fd：[2.2 文件 I/O](ch02.md)（`open`/`read`/`write`/`close` 与 `errno` 纪律）、[2.3 高级文件 I/O](ch03.md)（`truncate`/`fallocate` 的分配语义、`mmap`）。
- 目录与链接：[2.6 目录、链接与文件事件](ch06.md) 在后半章用得到（硬链接数、`rename`），先读本章没有障碍。
- 阅读：约 110 分钟（18 节，正文有 6 个可编译程序）。动手实验：约 40 分钟（全部免 `sudo`）。章末习题：约 60 分钟。

## 这条主线怎么走

**第一段，字段与含义（2.5.1–2.5.3）。** 先把 `struct stat` 逐个字段过一遍，重点在三件事：`stat`/`lstat`/`fstatat` 对符号链接的分野；`st_mode` 的类型位加 12 位权限与内核的四步检查算法；大小与时间的口径——`st_size` 是逻辑长度、`st_blocks` 固定按 512 字节计、`ctime` 是「inode 状态改变时间」而不是创建时间。这一段是所有后续结论的坐标系。

**第二段，写它（2.5.4–2.5.6）。** 改属性有两条通道：内核知道你是属主还是特权——`chmod`/`chown` 各有连带效果（`chown` 清 setuid）；xattr 把键值对挂上 inode，命名空间决定门槛；ACL 把「属主/属组/其他」三格扩展成若干条 ACE，代价是多出一个 `mask`，而 `chmod g=` 动的恰是它。这一段结束你应该能解释「`chmod 640` 之后 alice 突然不能写」。

**第三段，扩展接口与 ABI（2.5.7–2.5.9）。** `statx` 补创建时间、挂载 ID、直接 I/O 对齐，但一切先看 `stx_mask`；`statvfs` 从「一个文件」跳到「一个文件系统」。2.5.8 说明为什么这些字段不能跨 32/64 位、跨 libc 混用：`struct stat` 是内核与用户态共享的 ABI，宏会改布局。

**第四段，实现语义（2.5.10–2.5.14）。** 时间戳的更新频率由挂载选项决定（`relatime` 是默认）、`utimensat` 设不了 `ctime`；inode flags 各有权限门槛；xattr 的容量按文件系统算（ext4 塞进一个 inode 块，XFS 另有限制）；ACL 落盘是一个 xattr，内核按固定顺序匹配、第一个命中说了算；新建文件时 `mode`、`umask`、默认 ACL 三方联合决定结果。

**第五段，取证与收口（2.5.15–2.5.18）。** `statx`/xattr/ACL 在内核里经过哪些函数；`strace` 与 `getfacl`/`acl_raw` 怎么拿读数；三组坑清单；出口检查表逐条打勾在[自检表](ch05-checklist.md)。

一句话主线：**把「文件的元数据」当成有格式、有容量、有权限、有版本语义的数据来看——先看字段口径，再看谁有权改、改了连带什么，最后用 `statx`/`getfacl`/`strace` 把每条结论变成读数。**

## 本章路线：五段，一条主线

| 分段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、字段与含义** | [2.5.1](ch05.md#sec-2.5.1)、[2.5.2](ch05.md#sec-2.5.2)、[2.5.3](ch05.md#sec-2.5.3) | `stat` 家族四个函数怎么选？权限怎么被检查？`st_size`/`st_blocks` 差在哪、三个时间各何时变？ |
| **二、写它：权限、xattr 与 ACL** | [2.5.4](ch05.md#sec-2.5.4)、[2.5.5](ch05.md#sec-2.5.5)、[2.5.6](ch05.md#sec-2.5.6) | `chmod`/`chown` 的连带效果？xattr 存在哪、谁能写？ACL 的 `mask` 与 `chmod` 怎么互相绊？ |
| **三、扩展接口与 ABI** | [2.5.7](ch05.md#sec-2.5.7)、[2.5.8](ch05.md#sec-2.5.8)、[2.5.9](ch05.md#sec-2.5.9) | `statx` 补了什么、`stx_mask` 为什么必须先看？`struct stat` 为什么不能混用布局？`statvfs` 和 `df` 差在哪？ |
| **四、实现语义** | [2.5.10](ch05.md#sec-2.5.10)–[2.5.14](ch05.md#sec-2.5.14) | `relatime` 下 atime 为什么不动？`chattr +i` 拦住谁？xattr/ACL 的容量上限归谁定？ACL 二进制长什么样？新建文件权限由谁决定？ |
| **五、取证与收口** | [2.5.15](ch05.md#sec-2.5.15)–[2.5.18](ch05.md#sec-2.5.18) | 内核里谁填这些字段？`strace`/`getfacl` 怎么用？哪些坑最常踩？本章出口在哪？ |

## 小节一览

| 小节 | 标题 | 一句话 | 本机（免 `sudo`）能做到什么 |
|:--|:--|:--|:--|
| [2.5.1](ch05.md#sec-2.5.1) | `stat` 家族与 `struct stat` | 四个变体的差别与十二个字段 | 全部可做，正文 `showstat.c` 直接编译运行 |
| [2.5.2](ch05.md#sec-2.5.2) | 类型、权限位与检查算法 | 宏、四步检查、`umask`、`access()` 的竞态 | 权限位与 `umask` 可做；setuid 现场要 root |
| [2.5.3](ch05.md#sec-2.5.3) | `st_size`、`st_blocks` 与三个时间 | 稀疏文件与时间戳分工 | 全部可做（注意 `stat -c %B` 的口径） |
| [2.5.4](ch05.md#sec-2.5.4) | `chmod`、`chown` 与特殊位 | `chown` 清 setuid、`fchmodat` 的标志 | 全部可做（改组只能选自己所属的组） |
| [2.5.5](ch05.md#sec-2.5.5) | 扩展属性：xattr | 键值对与六种返回码 | 可做；`getfattr`/`setfattr` 本机未装，用自写程序 |
| [2.5.6](ch05.md#sec-2.5.6) | ACL：比 `rwx` 更细的权限 | `mask` 与 `chmod` 的交互 | 可做，`getfacl`/`setfacl`/libacl 都在 |
| [2.5.7](ch05.md#sec-2.5.7) | `statx`：更新的字段 | `btime`、`mnt_id` 的雏形 | 全部可做，ext4 与 tmpfs 各跑一次 |
| [2.5.7.1](ch05.md#sec-2.5.7.1) | `statvfs`：文件系统余量 | `f_frsize` 与 `f_bavail` 的算法 | 全部可做，可与 `df` 对账 |
| [2.5.8](ch05.md#sec-2.5.8) | `struct stat` 的 ABI 与布局 | 字段宽度是内核与用户态的契约 | 64 位侧可做；`cc -m32` 本机不支持 |
| [2.5.9](ch05.md#sec-2.5.9) | `statx` 全字段与属性位 | 先看 `stx_mask` 再读字段 | 全部可做，含 DIO 对齐与属性位 |
| [2.5.10](ch05.md#sec-2.5.10) | `relatime`、`lazytime` 与 `utimensat` | 时间戳的完整语义 | `relatime` 两条分支可实测；改挂载选项要 root |
| [2.5.10.1](ch05.md#sec-2.5.10.1) | 老接口 `utime`/`utimes` | 秒级与微秒级为什么不够用 | 编译与运行都可做 |
| [2.5.11](ch05.md#sec-2.5.11) | inode 标志：`chattr` 与 `FS_IOC_*` | 属主能设哪些、root 也躲不过哪些 | 读与 `NODUMP` 可做；`+i`/`+a` 要 capability |
| [2.5.12](ch05.md#sec-2.5.12) | xattr 命名空间与实现限制 | 名字/值/总量三条天花板 | 全部可做，能实测出本机上限 |
| [2.5.13](ch05.md#sec-2.5.13) | ACL 的二进制与检查算法 | 4 字节头 + 8 字节一条 | 全部可做（`acl_raw.c` 不依赖 libacl） |
| [2.5.14](ch05.md#sec-2.5.14) | 默认 ACL、`umask` 与创建权限 | 三者联合算法与排查顺序 | 全部可做 |
| [2.5.15](ch05.md#sec-2.5.15) | 内核路径：落到 ext4 | 谁在 VFS、谁在文件系统 | 只读代码级结论，本机没有内核源码 |
| [2.5.16](ch05.md#sec-2.5.16) | 两个实验 | `strace` 与四个验证工具 | `strace` 可做（要显式列调用名） |
| [2.5.17](ch05.md#sec-2.5.17) | 本章陷阱清单 | 三组坑：大小时间 / ACL / xattr 与 flags | 大部分可复现 |
| [2.5.18](ch05.md#sec-2.5.18) | 本章出口检查 | 九条达标线 | 展开在[学习目标自检表](ch05-checklist.md) |

## 怎么读

- **第一次读**：2.5.1–2.5.3 一口气读完，边读边跑 `showstat` 打印 `/etc/hosts`、`/dev/null` 和一个符号链接，把三个样本的字段抄成三列对照；然后 2.5.5 跑 `xattr_demo`、2.5.6 跑 `setfacl`/`getfacl` 各一次，再往后读 2.5.13 的二进制格式——先见过文本输出，解码才有落点。
- **只想解释一个现象**：`du` 与 `ls -l` 不一致看 [2.5.3](ch05.md#sec-2.5.3)；`cat` 后 atime 不动看 [2.5.10](ch05.md#sec-2.5.10)；`chmod` 后别人突然没权限看 [2.5.6](ch05.md#sec-2.5.6) 与 [2.5.13](ch05.md#sec-2.5.13)；新建文件权限不对看 [2.5.14](ch05.md#sec-2.5.14) 末尾的排查顺序。
- **准备面试或课程考试**：四处必答——`ctime` 的语义（2.5.3）、权限四步检查与目录 `r`/`w`/`x` 各管什么（2.5.2）、ACL mask 与 `chmod` 的交互（2.5.6、2.5.13）、稀疏文件的三个数（2.5.3）。先做[习题集](ch05-exercises.md) A 组。
- **写备份/同步/部署脚本**：必读 [2.5.12](ch05.md#sec-2.5.12) 的 `cp -a`/`tar --xattrs`/`rsync -X` 保留规则与 [2.5.10](ch05.md#sec-2.5.10) 的时间戳精度；[2.5.7.1](ch05.md#sec-2.5.7.1) 的 `f_bavail` 与 `f_bfree` 差别决定「还能写多少」算得对不对。
- **怕数字搬家**：本章的容量上限、btime 支持、工具可用性都随文件系统与安装包变。逐条列在[勘误与版本注记](ch05-errata.md)，引用任何数字前先读那一页。

## 环境口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096、默认 `umask 0002`；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上（`findmnt` 显示 `rw,relatime`），`/dev/shm` 是 **tmpfs**（`rw,nosuid,nodev,inode64`）。本章的 xattr、ACL、btime、inode flags 在两种文件系统上都各跑过一遍，行为并不完全相同，引用时要带上「哪一块盘」。
- **`sudo` 不可用**。这决定了本章能做多少：`chattr +i`/`+a`、`chown` 给别人、`trusted.*` xattr、跨用户测粘滞位，全部只能按「机制结论 + 未实测」读；免权的对照（属主 `chmod`/`chown` 改所属组、`user.*` xattr、`FS_NODUMP_FL`）都在本机跑过，读数见[勘误页](ch05-errata.md)。
- **`perf` 计数器不可用**；跨进程 `ptrace` 被 `ptrace_scope=1` 挡（`strace -p <PID>` 不可用），取证一律「在 strace 下启动」或用 `/proc/self/...`。
- **工具可用性（本机 `command -v` 实测）**：`getfacl`/`setfacl`/`lsattr`/`chattr`/`strace` 6.8 可用；**`getfattr`/`setfattr` 未安装**（attr 包缺失），正文 2.5.16 实验二那几条 `setfattr`/`getfattr` 命令本机跑不了，替代是自己编译 `xattr_demo`/`acl_raw`，或用 `setfacl`/`getfacl`。libacl 头文件与库存在，`acl_demo.c` 直接 `-lacl` 编译通过；`<sys/xattr.h>` 由 libc6-dev 提供，`xattr_demo.c` 不需要 attr 包。
- **`docker` 免 sudo 可用**（本机 `docker version` 报 29.1.3）。容器里 `uname -r` 仍是宿主内核 `7.0.0-38-generic`：容器换的是文件系统与能力集，不是内核。
- **写作机**：macOS（Apple 芯片，arm64）。没有 `/proc`、没有 `strace`，`errno` 数值也不同（`EAGAIN`=35 对 Linux 的 11）、页大小 16384。**ACL 语义整体换一个模型**：`getfacl`/`setfacl`/`getfattr`/`setfattr`/`lsattr`/`chattr` 都不存在，ACL 是 NFSv4 风格、用 `chmod +a "everyone allow read"` 设置、`ls -lde` 查看，**没有 `mask` 这个概念**；BSD 的 `stat -f` 里 `%k` 是 `st_blksize`、`%SB` 直接给 birth time（Linux 的传统 `struct stat` 没有）。它只能当「换一个内核/libc/系统会怎样」的对照，本章全部实验回 Linux 做。

## 路线标签与项目回链

- **应用/运维：必读** [2.5.3](ch05.md#sec-2.5.3)、[2.5.6](ch05.md#sec-2.5.6)、[2.5.12](ch05.md#sec-2.5.12)、[2.5.14](ch05.md#sec-2.5.14)。磁盘为什么「满了」`du` 却说没占、共享目录为什么新用户突然不能写、备份恢复后权限为什么丢，都在这四节；**可后补** [2.5.8](ch05.md#sec-2.5.8)、[2.5.15](ch05.md#sec-2.5.15)。
- **系统编程：必读** [2.5.1](ch05.md#sec-2.5.1)–[2.5.6](ch05.md#sec-2.5.6)、[2.5.9](ch05.md#sec-2.5.9)、[2.5.13](ch05.md#sec-2.5.13)。`fstatat`/`statx` 的正确调用形状与 mask 语义是后面每章的地基；**可后补** [2.5.11](ch05.md#sec-2.5.11)。
- **内核/性能：必读** [2.5.8](ch05.md#sec-2.5.8)、[2.5.10](ch05.md#sec-2.5.10)、[2.5.13](ch05.md#sec-2.5.13)、[2.5.15](ch05.md#sec-2.5.15)。ABI 布局、`relatime`/`lazytime` 的写放大取舍、`posix_acl_permission` 的匹配顺序都在这里；**可后补** [2.5.7](ch05.md#sec-2.5.7)。
- **项目回链**：`mycontainer` 一类项目里「容器里 `chmod` 报只读」「挂载卷上 ACL 全丢」「镜像复制后 xattr 不见了」三类现象，判据分别在本章 [2.5.2](ch05.md#sec-2.5.2) 的 `EROFS`/LSM 分支、[2.5.6](ch05.md#sec-2.5.6) 的文件系统支持表和 [2.5.12](ch05.md#sec-2.5.12) 的保留规则；`st_dev`/`st_ino` 判同文件是 [2.6](ch06.md) 硬链接实验的前置。

## 章末件

[章末总结](ch05-summary.md) · [闭卷回忆卡](ch05-recall.md) · [习题集](ch05-exercises.md) · [学习目标自检表](ch05-checklist.md) · [勘误与版本注记](ch05-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 14 章（inode/VFS）、第 15 章（文件属性、时间戳、inode flags）、第 16 章（扩展属性）、第 17 章（ACL） | 2.5.1–2.5.17；ACL 二进制格式与检查算法、xattr 限制、inode flags 为重点 |
| **Linux 4.11+ 的 `statx(2)`** | `STATX_*` 接口（母本成书时尚无） | 2.5.7、2.5.9：按 man 页与本机内核源码行为补充 |
| **C**（深入理解计算机系统） | 第 10 章 10.6（文件元数据） | 2.5.1、2.5.2：`stat` 与目录项的对照 |
| **O**（操作系统导论） | 第 39–40 章（文件与目录、文件系统实现） | 2.5.1、2.5.3：inode 与块分配的背景 |
| **G**（鸟哥的 Linux 私房菜） | 第 5 章（文件权限与目录配置）、第 13 章（账号管理与 ACL） | 2.5.2、2.5.6：`ls -l`、`getfacl`/`setfacl` 的命令行证据 |
| **N**（深入理解 Linux 网络） | — | 未用：本章不涉及网络栈 |

> K 的中文版覆盖到 Linux 3.2，`statx`、`DIOALIGN`、tmpfs 的 `user.*` 支持都在它之后；正文这些处按 man-pages 与本机实测写，容量上限之类的数字换文件系统就搬家，以[勘误页](ch05-errata.md)为准。
