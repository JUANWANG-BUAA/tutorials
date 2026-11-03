# 0.10 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与磁盘陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换文件系统、换发行版、换云盘后要复核什么**。

**本章基线**：Ubuntu 24.04、Linux 6.8、e2fsprogs 1.47、xfsprogs 6.6、LVM2 2.03、mdadm 4.3、smartmontools 7.4。换环境时逐条复核。

## 1. 容量、inode 与挂载

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `df` 与 `du` 应该相等 | `df` 看块/文件系统，`du` 看文件；稀疏/硬链接/deleted-open/保留块会差 | `df -h`、`du -xsh`、`lsof +L1` |
| 2 | `rm` 后空间立刻释放 | 被进程打开的文件仍占块，直到 fd 关闭 | `lsof +L1`、`ls -l /proc/PID/fd` |
| 3 | 有空间就能写 | inode 用尽也会 `No space left` | `df -i` |
| 4 | ext4 的 5% 保留块没用 | root 可用的保留空间，普通用户不可用 | `tune2fs -l` 的 Reserved block count |
| 5 | 设备名 `/dev/sda` 永久不变 | 插拔/重启/云盘可能变；fstab 用 UUID/PARTUUID | `blkid`、`lsblk -f` |
| 6 | fstab 改完直接重启 | 先 `mount -a` 验证；写错会进 emergency | `mount -a`、`findmnt --verify` |

## 2. LVM、RAID 与文件系统

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 7 | `lvextend` 后 `df` 就变大 | 还要 `resize2fs`/`xfs_growfs` 扩文件系统 | `lvs`、`df -hT` |
| 8 | LVM 快照不占空间 | 快照是 COW，写入多会满；满了快照失效 | `lvs` 看 Data%/Meta% |
| 9 | RAID 5 重建很安全 | 重建窗口另一块盘再坏会丢数据；有写洞 | `mdstat`、`smartctl`、备份 |
| 10 | RAID 能替代备份 | RAID 只防盘坏，不防误删/勒索/机房故障 | 3-2-1 备份 |
| 11 | XFS 也能缩容 | XFS 不支持缩容；ext4 可缩但需卸载 | `xfs_info`、`resize2fs` |
| 12 | `mkfs` 只是格式化分区 | 会覆盖分区/LV 上的数据；设备名先核对 | `lsblk -f`、`blkid`、快照 |

## 3. fsck、TRIM、配额与健康

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 13 | `fsck` 可以在挂载中跑 | 会与内核缓存冲突/误修；先卸载/只读 | `findmnt`、`mount -o ro` |
| 14 | XFS 用 `fsck.xfs` 修 | XFS 用 `xfs_repair`；`fsck.xfs` 只是占位 | `xfs_repair -n` |
| 15 | 超级块坏了只能重做 | ext4 有备份超级块，`e2fsck -b` 可救 | `dumpe2fs`、`mke2fs -n` |
| 16 | TRIM 对所有盘/文件系统都有效 | 依 SSD/文件系统/挂载选项；虚拟盘可能不支持 | `lsblk -D`、`fstrim -v` |
| 17 | 配额开了就生效 | 要在挂载选项启用 `usrquota/grpquota` 并初始化 | `findmnt`、`repquota` |
| 18 | SMART 通过 = 盘没问题 | SMART 只给预警，不保证；要看介质错误/增长 | `smartctl -a`、`dmesg` |
| 19 | 云盘/网络盘和本地盘一样 | 云盘/网络盘有延迟/限流/快照语义；TRIM/RAID 行为不同 | `findmnt`、厂商文档 |
| 20 | 扩容/RAID 操作可以先做再想回滚 | 先快照/备份，写回滚步骤；RAID 可 fail/remove | 快照、`mdadm --detail` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的文件系统/云盘上使用前先验证：

- ext4/XFS/Btrfs 的 `mkfs` 默认参数、保留块、inode 分配依版本/发行版；以 `mkfs -V`/`tune2fs -l`/`xfs_info` 为准。
- LVM 快照的 COW 空间、`lvextend` 的 `-r` 选项依 LVM2 版本；`lvs` 看 Data%。
- RAID 5/6 的写洞与重建行为依内核/mdadm/BBU；关键数据用 RAID6/RAID10 + 备份。
- TRIM 在虚拟化/云盘/overlayfs 上的支持依后端；`lsblk -D`/`fstrim -v` 验证。
- 配额、ACL、xattr 的支持依文件系统/挂载选项；`findmnt` 看 `usrquota`/`acl`。

## 5. 发现新问题怎么记

如果你在别的文件系统/云盘上发现本章结论不成立，按「现象 → 命令/输出 → 文件系统/版本 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
