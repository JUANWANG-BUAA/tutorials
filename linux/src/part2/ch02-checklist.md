# 2.2 学习目标自检表

这张表接管 [2.2.20 本章小结](ch02.md#sec-2.2.20) 的三条判据与正文各节末尾的「即时自测」：正文只给判据方向，这里按**概念（K）/动手（S）/实验（E）/口径（B）**四组展开成 22 条，左列是达标项，中列是「怎样算达标」，右列是「没达标回到哪一节」。达标线全部写成能当场做的动作——能写出、能说出、能跑出、能对上——做完再勾。中列凡是提到具体读数的，都以本书 Ubuntu 24.04.5 aarch64 虚拟机为准，换机器要重取；环境边界（哪些工具不可用、哪些结论换了架构就不成立）统一记在[勘误与版本注记](ch02-errata.md)，动手前请先读它的「本章基线」与那张「容易搬家的结论」表。

## 达标检验

### 概念（K）

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 三层对象** | 30 秒内说出 fd 表 / 打开文件描述 / inode 各存什么；对「同一路径开两次」「`dup` 之后」两种情况，能各说出偏移是否共享并归到正确的层 | [2.2.1](ch02.md#sec-2.2.1)；回忆 1、[A1](ch02-exercises.md#ex-2.2-A1) |
| **K2 `open` 的参数契约** | 能写出 flags 的三组分工与访问模式的掩码读法；能写出最终权限公式并解释 `umask` 只清位；能说出漏传 `mode` 会得到什么 | [2.2.2](ch02.md#sec-2.2.2)、[2.2.11](ch02.md#sec-2.2.11)；回忆 2、[A2](ch02-exercises.md#ex-2.2-A2) |
| **K3 两个原子性** | 能说出 `O_CREAT\|O_EXCL` 与 `O_APPEND` 各把哪两步合成一步、各**不**保证什么；能用一句竞争窗口解释 `access()+open()` 与 `lseek(END)+write()` 为什么错 | [2.2.2](ch02.md#sec-2.2.2)、[2.2.5](ch02.md#sec-2.2.5)、[2.2.16](ch02.md#sec-2.2.16)；回忆 4、[A2](ch02-exercises.md#ex-2.2-A2)、[B2](ch02-exercises.md#ex-2.2-B2) |
| **K4 返回值契约** | 能背出 `read`/`write` 的五种返回形态与处理；能说 `EINTR` 是事件、`EAGAIN` 是状态并给出各自的重试方式；能列出 `SA_RESTART` 盖不住的三个调用 | [2.2.3](ch02.md#sec-2.2.3)、[2.2.12](ch02.md#sec-2.2.12)；回忆 6/7、[A3](ch02-exercises.md#ex-2.2-A3)、[A4](ch02-exercises.md#ex-2.2-A4) |
| **K5 收尾与复制 fd** | 能说出 `close` 失败时 fd 的状态与「不重试」的理由；`dup2`/`dup3` 的两点差别；`fcntl` 能改哪三位、为什么改不了访问模式；`pread` 为什么不踩共享偏移 | [2.2.4](ch02.md#sec-2.2.4)、[2.2.14](ch02.md#sec-2.2.14)、[2.2.15](ch02.md#sec-2.2.15)；回忆 8/22、[A5](ch02-exercises.md#ex-2.2-A5)、[B4](ch02-exercises.md#ex-2.2-B4) |
| **K6 缓存与持久化** | 能回答「`write` 返回后 `kill -9` 丢不丢、断电丢不丢」并归到页缓存层；能写出四步持久化顺序并解释目录 `fsync`；能区分 `fsync`/`fdatasync`/`syncfs`/`sync` 的范围 | [2.2.5](ch02.md#sec-2.2.5)、[2.2.8](ch02.md#sec-2.2.8)、[2.2.17](ch02.md#sec-2.2.17)；回忆 10/13/24、[A6](ch02-exercises.md#ex-2.2-A6) |
| **K7 flags 的边界** | 能对 `O_PATH`、`O_NOFOLLOW`、`O_DIRECTORY`、`O_TMPFILE` 各说出「错用时报哪个 `errno`」；能说 `O_SYNC`/`O_DSYNC`/`O_ASYNC` 三者的语义差别与 `O_ASYNC` 为什么要在 `F_SETFL` 才生效 | [2.2.9](ch02.md#sec-2.2.9)、[2.2.9.1](ch02.md#sec-2.2.9.1)；回忆 15/16、[C1](ch02-exercises.md#ex-2.2-C1) |
| **K8 路径与权限的安全边界** | 能写出六个 `RESOLVE_*` 与违规时的 `errno`，并说明 `BENEATH` 与 `IN_ROOT` 的差别、`openat2` 为什么不能替 `chroot`；能说出默认 ACL 与 `umask` 怎么共同决定新文件权限 | [2.2.10](ch02.md#sec-2.2.10)、[2.2.11](ch02.md#sec-2.2.11)；回忆 17/18、[C5](ch02-exercises.md#ex-2.2-C5)、[B5](ch02-exercises.md#ex-2.2-B5) |
| **K9 空洞与向量 I/O** | 能用 `st_size` 与 `st_blocks*512` 解释稀疏文件；能说出 `SEEK_DATA`/`SEEK_HOLE` 各自返回什么、什么时候 `ENXIO`；能说出 `IOV_MAX` 从哪查、超了怎样、短写后为什么不能重试整个数组 | [2.2.13](ch02.md#sec-2.2.13)、[2.2.14](ch02.md#sec-2.2.14)；回忆 20/21、[C3](ch02-exercises.md#ex-2.2-C3) |
| **K10 错误码该怎么处理** | 给 12 个错误码（`EINTR`、`EAGAIN`、`EBADF`、`EFAULT`、`EINVAL`、`EISDIR`、`EFBIG`、`ENOSPC`、`EDQUOT`、`EPIPE`、`EROFS`、`EPERM`），能逐个标「重试 / 退避 / 放弃」；能说出 `EPIPE` 之前先发生了什么 | [2.2.12](ch02.md#sec-2.2.12)；回忆 19、总结表 1 |

### 动手（S）

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **S1 写出正确的 I/O 循环** | 合上正文写出 `read_full`/`write_full`，用 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2` 一次编译通过；四个分支（`EINTR`、`EAGAIN`、`n==0`、部分完成）都在 | [2.2.3](ch02.md#sec-2.2.3)、[2.2.7](ch02.md#sec-2.2.7)；[A3](ch02-exercises.md#ex-2.2-A3)、[A4](ch02-exercises.md#ex-2.2-A4) |
| **S2 造一次原子发布** | 写出「临时文件 + `O_CREAT\|O_EXCL` → 写完 → `fsync` → `close` → `rename` → 打开父目录 `fsync`」的小程序并跑通，`strace -yy` 里能看到**两次** `fsync`，第二次对象是目录 | [2.2.5](ch02.md#sec-2.2.5)、[2.2.7](ch02.md#sec-2.2.7)；[C4](ch02-exercises.md#ex-2.2-C4)；回忆 10/12 |
| **S3 管住 fd 的继承与清理** | 能用 `O_CLOEXEC`/`F_DUPFD_CLOEXEC`/`dup3`/`close_range` 四种写法各设一次 `FD_CLOEXEC`；能解释 `close_range(3, ~0U, 0)` 为什么比遍历 `/proc/self/fd` 可靠 | [2.2.2](ch02.md#sec-2.2.2)、[2.2.15](ch02.md#sec-2.2.15)；[C6](ch02-exercises.md#ex-2.2-C6)；回忆 5/22 |
| **S4 用 `openat2` 锁住目录** | 跑出 `inside` 成功、`../etc/passwd` 与 `/etc/passwd` 都返回 `errno=18 (EXDEV)`；能解释为什么这里 `EXDEV` 不代表「跨设备」 | [2.2.10](ch02.md#sec-2.2.10)；[C5](ch02-exercises.md#ex-2.2-C5)；回忆 17 |
| **S5 把 flags 变成可读事实** | 能用「查本机头文件」或「看 `strace` 打出的名字」两种方法解一个 `fdinfo flags`，不靠手工拆八进制；能写出 `grep -n "#define O_" /usr/include/aarch64-linux-gnu/asm/fcntl.h` 这类取证命令 | [2.2.9](ch02.md#sec-2.2.9)、[2.2.18](ch02.md#sec-2.2.18)；[C1](ch02-exercises.md#ex-2.2-C1)、[C7](ch02-exercises.md#ex-2.2-C7) |

### 实验（E）

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **E1 复现四个 flags 边界** | 跑 `openflags.c` 得到 `O_PATH read: n=-1 errno=9`、`O_NOFOLLOW ... errno=40`、`O_DIRECTORY ... errno=20`、`O_TMPFILE linkat: ok`，并说出 `linkat` 那步走的是 `AT_EMPTY_PATH` 还是 `/proc/self/fd` 回退 | [2.2.9](ch02.md#sec-2.2.9)；[C1](ch02-exercises.md#ex-2.2-C1) |
| **E2 复现七种读写异常** | 跑 `shortio.c` 得到 65536 短写、`EAGAIN`、`ENOSPC`(`/dev/full`)、`EISDIR`、`EPIPE` + `sigpipe=1`；能本机重取管道容量并说明这个数跟着页大小变 | [2.2.12](ch02.md#sec-2.2.12)；[C2](ch02-exercises.md#ex-2.2-C2) |
| **E3 读出空洞** | 跑 `sparse_scan.c` 得到 `allocated=8192` 与两段 `data` 区间，并用 `du`、`du --apparent-size`、`stat -c '%s %b'` 三个读数交叉验证 | [2.2.13](ch02.md#sec-2.2.13)；[C3](ch02-exercises.md#ex-2.2-C3) |
| **E4 用 fdinfo 与 `(deleted)` 定位资源** | 能用 bash `exec 3<>` 读出 `pos`/`flags`/`mnt_id`/`ino`，写入一次后 `pos` 变化；能把 `mnt_id` 在 `/proc/self/mountinfo` 里对上；能造出 `(deleted)` 并用 `ls -l /proc/self/fd` 或 `lsof +L1` 找到持有者 | [2.2.6](ch02.md#sec-2.2.6)、[2.2.18](ch02.md#sec-2.2.18)；[C7](ch02-exercises.md#ex-2.2-C7)、[B3](ch02-exercises.md#ex-2.2-B3) |

### 口径（B）

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **B1 读数分四类** | 能把本章任一结论归进「man/POSIX 条款」「本机工具输出」「量级示例」「未实测」并各举一例；能指出 `errno` 数值属于跨架构相同、八进制 flag 属于随架构变 | [勘误与版本注记](ch02-errata.md)；回忆 25 |
| **B2 常数一律本机重取** | 能说出本机 `open` 没有系统调用（走 `openat`=56）、`read`=63、`write`=64、`getpid`=172，且 `syscall(0,…)` 在本机是 `io_setup` 而不是 `read`；引用任何调用号前给出 `grep` 命令 | [2.2.17](ch02.md#sec-2.2.17)；[勘误页](ch02-errata.md) 第 1–2 行 |
| **B3 环境边界与待修读数** | 能说出本机 `sudo` 不可用、`perf stat` 每行 `<not supported>`、`docker` 免 sudo 可用；能列出正文三处与本机复跑不一致的读数（`fd=3`、`=3`、`18` 字节）并解释差异来源，不改数字去迁就正文 | [勘误页](ch02-errata.md)「复跑校正」与「本章未实测项」；[C5](ch02-exercises.md#ex-2.2-C5)、[C6](ch02-exercises.md#ex-2.2-C6) |

## 没达标怎么办

- **K 组卡住**：先讲一句完整因果，例如「因为偏移存在打开文件描述这一层，`dup` 只复制表项，所以两个 fd 一起前进」。讲不出因果就回对应小节的「即时自测」或 `errata` 盒重读那一段，多读几遍整章不解决问题。
- **S 组卡住**：拿纸画两张图——「fd 表 → `struct file` → inode」三层图，「`write` 返回 → 脏页 → 回写 → `fsync`」四层图；再合上正文默写四步持久化与 `read_full`。写不出就把 2.2.7 的 `copy.c` 抄一遍并逐行标注它防的是什么。
- **E 组卡住**：先确认环境与口径（`sudo`/`perf` 不可用，`strace`/`lsof`/`getconf` 可用），再确认你编译用的是正文原样源码。读数对不上时先分清三类原因：**跟会话变的**（fd 号、`ino`、`mnt_id`、`ulimit -n`）、**跟架构变的**（八进制 flags、系统调用号）、**跟正文不一致的**（[勘误页](ch02-errata.md)已列出三处）。前两类按本机重取，第三类按勘误页处理，不要改自己的输出。
- **B 组卡住**：这一组是全章的「防搬错」保险。把「POSIX 条款 / 本机工具输出 / 量级示例 / 未实测」四类各举一例写出来，写在笔记本扉页；凡引用数值就写「本机，aarch64，内核 7.0.0-38，glibc 2.39」。
- **只有 K 组全对**：说明还停在「会读」。本章要求会写循环、会造原子发布、会用 `strace` 与 `/proc` 取证；把 S 组与 E 组做完再来勾这一页。

全部达标后的接口：[2.3 高级文件 I/O](ch03.md) 接 `fcntl` 文件锁（B2 交错问题的正解）、`mmap` 与原子发布；[2.14](ch14.md)、[2.16](ch16.md) 会把短读短写与 `EAGAIN` 用到管道与 `epoll` 上；[2.1.3](ch01.md#sec-2.1.3) 回头解释为什么错误处理函数第一句要存 `errno`。
