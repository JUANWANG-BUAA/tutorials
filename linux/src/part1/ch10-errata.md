# 1.10 勘误与版本注记

这一页收本章最容易「换一台机器就不成立」的东西：GNU/Linux 与 BSD/macOS 的 `read`/`write` 语义、`O_DIRECT` 的对齐与可用性、`/proc` 字段的归属，以及正文里那些看起来像承诺的示例输出。正文的 `errata` 盒讲理解陷阱；这一页讲**换一个内核、换一个 libc、换一个文件系统之后要复核什么**。

**本章基线**：正文 1.10.11 的 `EINTR`/`EAGAIN`/短写输出标注为 Linux 6.8，1.10.12 的 256 MiB 吞吐标注为 NVMe/ext4，1.10.13 的目录统计是形状示例。本书在一台 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、glibc 2.39、strace 6.8，`sudo` 不可用）上复跑；BSD 侧只在一台 macOS 27.2 上做对照，没有 FreeBSD 机器。凡标「VM 实测」的是那台 Ubuntu 虚拟机，标「macOS 实测」的是 macOS 27.2，其余按末节当作未实测。

## 1. 语义、对齐与 `/proc`：十五个容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「BSD 可以 `read` 目录，Linux 不行」 | 现代 macOS 27.2 与 Ubuntu 24.04 的 `read(2)` 对目录都返回 `EISDIR`；不要把早期 BSD 的历史行为当现状，可移植代码一律用 `readdir`/`getdents64` | 用 `O_RDONLY` 与 `O_DIRECTORY` 打开目录后 `read(fd, buf, 8)`，看返回值与 `errno`；macOS 与 Linux 各跑一次 |
| 「`read(fd, buf, 0)` 会检查 fd 是否有效」 | POSIX 允许实现不检查；有效 fd 上 Linux 与 macOS 实测都返回 0。0 字节读没有数据语义，不要拿它探活 | 对有效 fd 调 `read(fd, buf, 0)`；再对已关闭 fd 调一次，记录 `errno`，不要跨平台假设 |
| 「`EAGAIN` 就是 11」 | Linux 是 11，macOS 27.2 实测是 35；`EWOULDBLOCK` 在 Linux 与 `EAGAIN` 同值，别的地方未必。比较一律用宏 | `errno -l` 里找 `EAGAIN` 与 `EWOULDBLOCK`；或写 C 打印两个宏的值，两个平台各跑一次 |
| 「往读端关闭的管道写，只会返回 `EPIPE`」 | 内核先发 `SIGPIPE`；默认动作是终止进程，忽略或阻塞后才返回 `-1/EPIPE`。shell 的 141 = 128+13 | `trap '' PIPE` 后写一个读端已关闭的管道，看 `write` 返回 -1/`EPIPE`；不忽略时看退出码 141 |
| 「一次 `write` 可以写 4 GiB」 | Linux 单次 `read`/`write` 最多处理 `MAX_RW_COUNT = 0x7ffff000`（约 2 GiB 减 4 KiB）；传入更大的 `count` 不报错，内核只处理这么多 | 写一个大于 2 GiB 的缓冲区，比较返回值与请求长度；或读内核源码里的 `MAX_RW_COUNT` |
| 「`O_DIRECT` 只要 512 B 对齐」 | 要求缓冲区地址、文件偏移、传输长度都按逻辑块大小对齐；块大小由文件系统/设备决定，常见 512 B 或 4 KiB。VM 实测：4 KiB 对齐写成功，偏移 1 与缓冲区 +1 都 `EINVAL` | `dd bs=4k iflag=direct` 与 `dd bs=1000 iflag=direct` 对照；再用 `posix_memalign` 写一个偏移/缓冲区不对齐的 `pwrite` |
| 「`O_DIRECT` 到处都有」 | 不是 POSIX；macOS 27.2 的 `fcntl.h` 不定义 `O_DIRECT`（实测编译走 `#else`），对应机制是 `F_NOCACHE`。跨平台代码要条件编译 | 用 `cc -dM -E -include fcntl.h - < /dev/null` 输出宏后找 `O_DIRECT`；macOS 与 Linux 各跑一次 |
| 「`O_DIRECT` 就不会有 page cache，所以不用 `fsync`」 | 它只绕过文件数据的 page cache；inode、目录项、设备缓存仍可能有。`O_DIRECT` 不是持久化的同义词，落盘边界仍要 `fsync`（设备缓存另说） | 写 `O_DIRECT` 文件后立刻断电或 `echo 3 > drop_caches`（需 root）再读；没有 root 就只核对语义，别宣称已落盘 |
| 「`st_ctime` 是创建时间」 | Linux 的 ctime 是 inode 状态改变时间；创建时间要走 `statx` 的 `stx_btime`，且依赖文件系统。macOS 的 `struct stat` 另有 `st_birthtime`，Linux 的 `struct stat` 没有 | `stat -c '%w %z %y' file`（GNU）看 btime/ctime/mtime；macOS 用 `stat -f '%SB %Sc %Sm' file` |
| 「`/proc` 在所有 Unix 上都有」 | Linux 专有；macOS 27.2 没有 `/proc`，实测 `readlink("/proc/self/fd/N")` 失败。对应的是 `/dev/fd`，语义不同 | `ls -ld /proc /dev/fd`；在 macOS 上跑本章 1.10.10 的 `fds.c`，观察 `readlink` 失败 |
| 「`/proc/self/fd/N` 是普通文件」 | 它是符号链接，`readlink` 读目标；文件被 `unlink` 后目标带 ` (deleted)`。macOS 的 `/dev/fd/N` 不是同样的符号链接目录，脚本不能照搬 | `ls -l /proc/self/fd`；打开一个文件、`unlink` 后再 `readlink /proc/self/fd/N`，看后缀 |
| 「`/proc/meminfo` 的 `Dirty` 是当前进程的脏页」 | 是整机视角；容器与宿主机共享内核，读到的也是整机值。cgroup v2 的 `memory.stat` 里 `file`/`inactive_file` 才是容器视角的页缓存 | 分别查 `/proc/meminfo` 的 `Dirty` 与 `Writeback`；在容器里再读一次，对照 `memory.stat` |
| 「`st_blocks` 的单位是字节」 | Linux/POSIX 以 512 B 为单位；`st_size` 是逻辑大小。VM 实测稀疏文件：`size=1048576`、`blocks=0`、`blksize=4096`。GNU `stat -c`、BSD/macOS `stat -f` 的格式串也不同 | `stat -c 'size=%s blocks=%b blksize=%o' file`；`du -h file`；macOS 用 `stat -f '%z %b %k' file` |
| 「`d_type` 一定可信」 | 可能是 `DT_UNKNOWN`（XFS、NFS 等），必须 `fstatat` 补齐；`readdir` 返回的指针下一次调用可能被覆盖，名字要复制 | 在 XFS/NFS 目录上打印 `d_type`；对 `DT_UNKNOWN` 的项再 `fstatat`，比较结果 |
| 「1000 行 `printf` 重定向后通常合并成 1–2 次 `write`」 | 正文 1.10.14 的「1–2 次」不是承诺。VM 实测（glibc 2.39）：重定向 `/dev/null` 是 3 次，大小 4096、4096、1808；pty 上是 1000 次。次数由 libc 缓冲策略与 `BUFSIZ` 决定 | `strace -c -e trace=write ./buffered > /dev/null` 与 `script -qec "strace -c -e trace=write ./buffered" /dev/null` 对照 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的量级、形状或方法**，不要抄成事实：

- **1.10.12 的 256 MiB 参考吞吐**（`read/write` 621.4 MiB/s、`copy_file_range` 1230.8 MiB/s、`sendfile` 1190.7 MiB/s）：属于正文标注的 NVMe/ext4 机器；本书 VM 的 `/tmp` 实测是 `ext2/ext3`（`stat -f -c %T`），不是 NVMe/ext4，未复测这三行。
- **1.10.13 的目录统计**（`/usr/share/doc` 的 421 个目录、3120 个文件、18446732 字节）：是形状示例，本书未在 VM 上重跑；不同发行版的 `/usr/share/doc` 差别很大。
- **1.10.15 的冷读/热读吞吐与 `drop_caches`**：`echo 3 > /proc/sys/vm/drop_caches` 需要 root，本书 `sudo` 不可用，未跑；`Dirty`/`Writeback` 字段可读，但 SATA/NVMe 的 500 MB/s、2–7 GB/s、5–20 GB/s 是量级，不是本书读数。
- **`fsync` 的「几十毫秒」**：正文 1.10.15 第 3 步说 `fsync` 可能耗时几十毫秒；本书未在特定设备上计时，只确认 `strace` 能看到 `fsync` 调用。
- **`fdatasync` 与 `O_SYNC` 的相对性能**：未计时；只按语义说明它们比 `fsync` 省什么/等什么。
- **`sendfile`/`splice`/`copy_file_range` 的吞吐与 reflink 行为**：未在本书环境测；`copy_file_range` 在 btrfs/XFS 上可能走 reflink 是文件系统特性，依版本与挂载选项。
- **`O_DIRECT` 在 `/tmp` 之外的文件系统**：只在 VM 的 `/tmp` 上验过 4 KiB 对齐成功、偏移/缓冲区不对齐 `EINVAL`；其他文件系统可能有更严格的块大小或直接不支持。
- **FreeBSD 与其他 BSD**：只在一台 macOS 27.2 上做了 `read` 目录、`EAGAIN`、`O_DIRECT`、`/proc` 的对照；FreeBSD/OpenBSD 的手册与行为未实测。
- **`EMFILE`/`ENFILE` 的实际触发**：未在本书环境把 fd 表打满；救急 fd 模式是按语义写的，未做压力测试。
- **`O_TMPFILE`、`SCM_RIGHTS` 传递 fd、`close` 返回 `EINTR` 的未定义行为**：正文提到但本书未写程序验证；`close` 失败不要重试这条按 Linux 语义引用。
- **CSAPP 第 10 章的页码与小节边界**：只按正文「母本对应」表核对结构，没有重读原书；中文版是扫描件，引用的是章节号而不是书内句子。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/内核/libc/文件系统 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在环境上，所以请一并附上：`uname -a`；`ldd --version | head -1`；`strace -V | head -1`；`stat -f -c %T /tmp`（GNU）或 `stat -f %T /tmp`（BSD/macOS）；`mount | grep ' /tmp '`；`ulimit -n`；`grep -E 'Dirty|Writeback' /proc/meminfo`；以及完整编译命令（有没有 `-O2`、有没有 `-D_GNU_SOURCE`）。涉及数字时写明口径：是 `strace` 的次数、`/proc/self/io` 的字节、`dd` 的墙钟，还是正文的参考形状。本章多数分歧都出在把后一种数当前一种用。
