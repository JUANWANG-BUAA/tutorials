# 2.5 学习目标自检表

这张表接管 [2.5.18 本章小结](ch05.md#sec-2.5.18)的达标线：左列是达标项，中列是「怎样算达标」——全部写成能当场做的动作，右列是「没达标回到哪一节」。出口表只有 9 条，这里按**概念（K）、动手（S）、实验（E）、口径（B）**四组展开成 21 条。动手前先确认环境边界：测试机是 aarch64 VM，`sudo` 不可用、`getfattr`/`setfattr` 未安装，哪些能做、哪些只能按「未实测」读，全在[勘误与版本注记](ch05-errata.md)。

## 达标检验

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 stat 家族分工** | 能说出 `stat`/`lstat`/`fstat`/`fstatat` 对符号链接与 `cwd` 的差别；能说出 `AT_SYMLINK_NOFOLLOW`、`AT_EMPTY_PATH` 各干什么、后者要什么能力 | [2.5.1](ch05.md#sec-2.5.1) |
| **K2 三个「块/大小」口径** | 能写出 `st_size`、`st_blocks × 512`、`st_blksize` 各是什么，并举一个稀疏文件说明为什么 `du` 与 `ls -l` 差一个数量级 | [2.5.3](ch05.md#sec-2.5.3) |
| **K3 三个时间戳** | 能说出 `atime`/`mtime`/`ctime` 各在什么操作后更新、哪个设不了；能一句纠正「`ctime` 是创建时间」，并说出取创建时间该用什么、它有什么前提 | [2.5.3](ch05.md#sec-2.5.3)、[2.5.10](ch05.md#sec-2.5.10) |
| **K4 权限检查算法** | 能按顺序背出四步（root→属主→属组/辅助组→其他），并说出目录的 `r`/`w`/`x` 各管什么：为什么只给 `r` 不给 `x` 时 `ls` 能列名但 `stat` 失败 | [2.5.2](ch05.md#sec-2.5.2) |
| **K5 `umask` 与 `chmod` 的时机** | 能说出 `umask` 只在创建一刻**减去**位（`mode & ~umask`），对已存在文件无效；`chmod` 才改已有文件；两者各影响 `mkdir`/`mkfifo` 与否 | [2.5.2](ch05.md#sec-2.5.2)、[2.5.4](ch05.md#sec-2.5.4) |
| **K6 xattr 命名空间** | 能列出 `user.`/`trusted.`/`security.`/`system.` 四个命名空间各自的写入门槛，并说出 `trusted.*` 无权限调用返回什么错误 | [2.5.5](ch05.md#sec-2.5.5)、[2.5.12](ch05.md#sec-2.5.12) |
| **K7 ACL 的 mask 语义** | 能说出 `mask` 是谁的上限（命名用户、命名组、属组）；能解释 `chmod 640` 之后 `getfacl` 里 `user:xxx:rw-` 后面为什么会跟 `#effective:r--`，以及 `stat` 的 group 位为什么显示的是 mask | [2.5.6](ch05.md#sec-2.5.6)、[2.5.13](ch05.md#sec-2.5.13) |
| **K8 ACL 检查顺序** | 能按五步走完一个例子（属主？命名用户命中？组命中但权限不够？……），并说出「组类命中但权限不足时不会落到 other」这条规则 | [2.5.13](ch05.md#sec-2.5.13) |
| **K9 statx 的用法纪律** | 能说出为什么必须先查 `stx_mask` 再读字段；`btime` 位在什么条件下不置；`STATX_ALL` 为什么不可依赖；旧内核没有 `statx` 时返回什么 | [2.5.7](ch05.md#sec-2.5.7)、[2.5.9](ch05.md#sec-2.5.9) |
| **S1 符号链接读数** | 能用 `stat -c` 对一个符号链接报出 `type=symbolic link size=10`，并写出这个 10 从哪来 | [2.5.1](ch05.md#sec-2.5.1)、[2.5.2](ch05.md#sec-2.5.2) |
| **S2 稀疏文件三连** | 能跑出 `truncate -s 1G` 后 `ls -lh`、`du -h`、`stat -c 'size=%s blocks=%b blksize=%B'` 三条命令并报出本机三个读数 | [2.5.3](ch05.md#sec-2.5.3) |
| **S3 时间戳变化实验** | 能用 `stat -c 'm=%Y c=%Z'` 依次跑 `chmod`、追加写、`rename` 三种操作，报出「只动 c / m、c 同动 / 文件 c 动且父目录 m、c 动」三组读数 | [2.5.3](ch05.md#sec-2.5.3)、[2.5.10](ch05.md#sec-2.5.10) |
| **S4 xattr 两步查询** | 能写出「`getxattr(..., NULL, 0)` 问长度 → 分配 → 再取」的代码，并说出 `ERANGE`、`ENODATA`、`ENOTSUP`、`E2BIG`、`ENOSPC` 各对应什么原因 | [2.5.5](ch05.md#sec-2.5.5)、[2.5.12](ch05.md#sec-2.5.12) |
| **S5 setfacl 全流程** | 能在本机走完 `setfacl -m u:名字:rw` → `chmod 640` → `getfacl` 看到 effective 变小 → `setfacl -m m::rw` 恢复，全程不查命令表 | [2.5.6](ch05.md#sec-2.5.6) |
| **S6 utimensat 部分修改** | 能用 `UTIME_OMIT` 只改 `mtime`，并当场用 `stat` 验证 `atime` 未动、`ctime` 变成现在 | [2.5.10](ch05.md#sec-2.5.10) |
| **E1 statx_full 读数** | 能跑出正文程序并解读：ext4 上 `mask` 里 btime/`mnt_id`/DIOALIGN 各位，tmpfs 上少了哪一位；`stx_mnt_id` 与 `/proc/self/mountinfo` 第一列对得上 | [2.5.9](ch05.md#sec-2.5.9)、[2.5.16](ch05.md#sec-2.5.16) |
| **E2 acl_raw 解码** | 能对一条 5 条目 ACL 跑出 44 字节，报出 4 字节头 + 每条 8 字节的来历；`chmod 640` 前后指出变的是哪一条的哪两个字节含义 | [2.5.13](ch05.md#sec-2.5.13)、[2.5.16](ch05.md#sec-2.5.16) |
| **E3 inode flags 边界** | 能跑出属主设/清 `FS_NODUMP_FL` 成功，`chattr +i`、`+a` 返回 `Operation not permitted`，并解释两者权限门槛差在哪 | [2.5.11](ch05.md#sec-2.5.11) |
| **E4 strace 辨调用** | 能用显式列出的 stat 类调用名跑出 `newfstatat`（glibc `stat()` 的真身）与 `statx` 两种行，并说出正文实验一那条 `%stat` 命令在本机为什么是空输出 | [2.5.16](ch05.md#sec-2.5.16)、[勘误页](ch05-errata.md) |
| **B1 数字归属** | 能把本章数字分成四类说出来：规范条款（`st_blocks` 单位 512）、本机工具输出（ext4 约 508 条 ACL 上限）、按文件系统变的量（btime 支持、xattr 容量）、未实测（特权项、XFS/NFS）；每类各举一例 | [勘误与版本注记](ch05-errata.md) |
| **B2 本机环境边界** | 能报出测试机口径（aarch64、内核 7.0.0-38、`/tmp` 在 ext4、挂载选项 `relatime`），并说出 `getfattr`/`setfattr` 未装、`getfacl`/`setfacl` 可用、`sudo` 与 `perf` 不可用对各节实验的影响 | [章总览·环境口径](ch05-overview.md)、[勘误页](ch05-errata.md) |

## 没达标怎么办

- **K 组卡住**：每个概念先讲一句完整因果再说下一步。例：「因为 `stat` 的 group 位在 ACL 存在时显示的是 mask，所以 `ls -l` 看到 `rw-` 不代表属组真有 `rw-`」。讲不出因果就回对应小节的 errata 盒重读，不要多刷几遍文字。
- **S 组卡住**：合上正文在 `/tmp/lab2c05p_` 前缀下重做一遍对应命令序列（总览与勘误页里都有原样命令）；跑不出就先核对工具在不在：`command -v getfacl setfacl lsattr chattr strace`。
- **E 组卡住**：先确认正文那几条命令在本机哪些跑不了（`getfattr`/`setfattr` 缺失、`%stat` 类名不存在、特权项被 `sudo` 挡），把这些「跑不了」本身当成读数记下来，不要改成「凭印象的输出」。
- **B 组卡住**：把想引用的每个数字问三遍：这是条款、工具输出，还是某台机器某文件系统的量？后两类必须带出处引用。[勘误页](ch05-errata.md)的「复跑校正」表就是示范。
- **只有 K 组全对**：说明还停在「会读」。本章要求会跑、会取证；把 S 组与 E 组做完再来勾这一页。

全部达标后，往下的接口有两处：[2.6 目录、链接与文件事件](ch06.md) 把 `st_nlink`、`(st_dev, st_ino)` 与 `rename` 放回目录树，`inotify` 会把本章的时间戳变化变成可订阅的事件；项目侧「备份恢复丢 ACL」「容器卷上 xattr 消失」两类问题的判据都在 [2.5.12](ch05.md#sec-2.5.12) 与[勘误页](ch05-errata.md)。
