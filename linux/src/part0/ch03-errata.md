# 0.3 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与文件系统陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换文件系统、换 coreutils、换发行版后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、GNU coreutils 9.4、findutils 4.9、rsync 3.2.7、ext4。换环境时逐条复核。

## 1. 目录、路径与链接

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `/bin` 是真实目录 | usrmerge 后通常是指向 `/usr/bin` 的符号链接 | `ls -ld /bin`、`readlink -f /bin/sh` |
| 2 | `..` 总是物理上一层 | 逻辑路径经过符号链接时，`..` 与物理父目录可能不同 | `pwd`、`pwd -P`、`namei -l` |
| 3 | 硬链接与软链接差不多 | 硬链接共享 inode、不能跨文件系统；软链接独立 inode、可跨文件系统 | `ls -li`、`stat -c '%i %h %F'` |
| 4 | 删除原文件后软链接会一起消失 | 软链接还在，只是悬空；`readlink` 仍显示目标路径 | `rm target; readlink link; cat link` |
| 5 | 目录可以随便建硬链接 | 普通用户不能给目录建硬链接（防止环）；`.`/`..` 是特例 | `ln dir dirlink` 报错 |

## 2. 大小、inode 与占用

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 6 | `ls -l` 的大小就是磁盘占用 | 那是 apparent size；`du` 看块占用 | `ls -ls`、`du -h`、`du -h --apparent-size` |
| 7 | 稀疏文件占满磁盘 | 稀疏文件逻辑大、实际块少 | `truncate -s 1G f; du -h f; ls -lh f` |
| 8 | 硬链接会复制空间 | 硬链接共享 inode，`du` 默认只算一次 | `ln a b; du -h a b; du -h .` |
| 9 | `rm` 后空间立刻释放 | 被进程打开的文件仍占空间，直到最后一个 fd 关闭 | `lsof +L1`、`ls -l /proc/PID/fd` |
| 10 | 磁盘满就是块满 | 也可能是 inode 满（大量小文件） | `df -h`、`df -i` |

## 3. 复制、移动、删除与属性

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 11 | `cp` 会保留权限/时间/硬链接 | 普通 `cp` 不保留；用 `cp -a`/`rsync -aHAX` | `stat` 对比源/目标；`ls -li` 看 inode |
| 12 | `mv` 总是原子 | 同文件系统是 rename；跨文件系统是 copy + unlink，不原子 | `strace -e rename,renameat2,openat,unlink mv ...`；`df` 看是否同一挂载 |
| 13 | `find ... -o ... -delete` 会删两类 | 隐式 AND 优先，`-delete` 只作用于 `-o` 右侧 | 先 `-print` 看结果，再加括号 |
| 14 | `xargs` 能处理任意文件名 | 默认按空白分词；要 `-print0` + `xargs -0` | 创建带空格/换行文件名测试 |
| 15 | `chattr +i` 只是“只读” | immutable：root 也不能写/删/重命名，需先 `chattr -i` | `lsattr`、`rm` 报 `Operation not permitted` |
| 16 | `rsync --delete` 会删源端 | 删的是**目标端**有、源端没有的文件 | 先在临时目录用 `--dry-run` 对比 |
| 17 | `tar` 默认展开硬链接 | 默认保留硬链接关系；要展开用 `--hard-dereference` | `tar -tvf` 看链接标记 |
| 18 | `renameat2` 所有文件系统都支持 | `RENAME_NOREPLACE`/`EXCHANGE` 依文件系统与内核；不支持时返回 `EINVAL`/`ENOSYS` | `strace` 看返回值；查 `man 2 renameat2` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的文件系统/发行版上使用前先验证：

- ext4 的保留块比例（默认 5%）与 `tune2fs -m` 会改变 `df` 的可用空间；XFS/Btrfs 行为不同。
- `du` 默认块大小与 `POSIXLY_CORRECT`、`BLOCKSIZE`、`-B` 有关；不同 coreutils 版本输出可能不同。
- `find -delete` 的 `-depth` 隐含行为与 GNU findutils 版本有关；BSD find 的表达式/动作不同。
- `rsync -a` 的 `-a` 不含 `-H/-A/-X`；不同版本对 `--delete` 与 `--delete-after` 的时序有差异。
- `chattr +i` 需要文件系统支持（ext4/XFS 支持，tmpfs/overlayfs 可能不支持）。
- `renameat2` 的 `RENAME_EXCHANGE`/`WHITEOUT` 依内核与文件系统；容器 overlayfs 上行为可能不同。

## 5. 发现新问题怎么记

如果你在别的文件系统/发行版上发现本章结论不成立，按「现象 → 命令/输出 → 文件系统与版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
