# 0.10 章末总结

## 四单元一览

| 单元 | 核心问题 | 关键结论 | 典型陷阱 |
|:--|:--|:--|:--|
| **一、看清存储**（0.10.1–0.10.4） | 设备/分区/文件系统/挂载怎样对应？空间去哪了？ | `lsblk -f`/`findmnt`/`df -hT` 画出四层；`df` 看块，`du` 看文件；稀疏文件、硬链接、deleted-but-open、保留块会让两者对不上；inode 用尽看 `df -i`。 | 把 `df` 当文件大小；`rm` 后空间没释放；忽略 inode；把保留块当可用空间。 |
| **二、挂载与扩容**（0.10.5–0.10.8） | fstab/LVM/RAID/swap/TRIM/配额/健康怎样管？ | fstab 用 UUID/PARTUUID，改完 `mount -a` 验证；LVM PV→VG→LV，扩容后 `resize2fs`/`xfs_growfs`；RAID 用 `mdadm`/`/proc/mdstat`；swap/TRIM/quota/SMART 各有工具。 | fstab 写错进救援；`mkfs` 选错盘；RAID5 写洞；LVM 快照满；TRIM 不支持。 |
| **三、底层**（0.10.9–0.10.11） | 分区表/对齐/`mkfs`/`fsck` 怎样做？ | MBR/GPT、4K 对齐；`mkfs` 选块/inode/日志；挂载选项 `noatime`/`ro`/`noexec`/`nosuid`；fsck 先备份超级块，xfs 用 `xfs_repair`。 | 分区未对齐；`mkfs` 覆盖数据；`fsck` 在挂载状态跑；超级块坏了不会救。 |
| **四、证据与回滚**（0.10.12–0.10.16） | 怎样证明/回滚？ | `strace`/`iostat -x`/`blktrace`/`/proc/diskstats` 找块层证据；操作前快照/备份，RAID 可 fail/remove 回滚；脚本默认 dry-run。 | 不看证据就换盘；不做快照；`mdadm --create` 写错设备；回滚路径没验证。 |

## 一条主线

这一章先把存储看清：**块设备 → 分区 → 文件系统 → 挂载点**，再用 `df`/`du`/inode 解释“空间去哪了”。然后学会挂载与扩容：`/etc/fstab`、救援、LVM、RAID、swap/TRIM/配额/健康。第二遍回到底层：分区表/对齐、`mkfs`/挂载选项、`fsck`/超级块救援。最后用脚本、在线扩容/RAID 校验/块层证据/回滚实验与十四个陷阱收口。**每次动磁盘前，先能说出设备名、挂载点、文件系统与回滚路径。**

## 看到问题先选工具

| 症状 | 第一动作 | 为什么 |
|:--|:--|:--|
| 磁盘满了 | `df -hT`、`du -xsh /*`、`df -i` | 先分块满/inode 满/挂载点；`-x` 不跨文件系统。 |
| `df` 与 `du` 对不上 | `lsof +L1`、`du -h --apparent-size` | deleted-but-open/稀疏/硬链接/保留块。 |
| 写不进去但还有空间 | `df -i`、`df -h` | inode 用尽或保留块。 |
| 设备/分区关系不清 | `lsblk -f`、`findmnt`、`blkid` | 四层对应；UUID/PARTUUID。 |
| 改 fstab 后起不来 | 救援：`mount -o remount,rw /`、`mount -a` | fstab 错会卡启动；先 `mount -a` 验证。 |
| 要扩容 | `lvextend` + `resize2fs`/`xfs_growfs` | LVM 在线扩容；文件系统要跟着扩。 |
| RAID 降级 | `cat /proc/mdstat`、`mdadm --detail` | 看哪个盘坏、重建进度。 |
| 磁盘健康 | `smartctl -a`、`dmesg` | SMART/介质错误；先备份再换盘。 |
| 块层慢 | `iostat -x 1`、`blktrace`、`/proc/diskstats` | 看 await/util/队列，不猜。 |
| 配额/TRIM | `repquota`、`fstrim -av` | 配额按用户/组；TRIM 依文件系统/SSD。 |

## 能否讲出这八句话

1. `lsblk -f`/`findmnt`/`df -hT` 把「块设备 → 分区 → 文件系统 → 挂载点」连起来。
2. `df` 看块占用，`du` 看文件；稀疏文件、硬链接、deleted-but-open、保留块会让两者对不上。
3. inode 用尽是“有块但写不进去”，用 `df -i` 看；大量小文件是常见原因。
4. `/etc/fstab` 用 UUID/PARTUUID，改完 `mount -a` 验证；写错会进救援/只读根。
5. LVM 是 PV→VG→LV，扩容 `lvextend` 后还要 `resize2fs`/`xfs_growfs`。
6. RAID 0/1/5/6/10 在容量/冗余/性能间取舍；`/proc/mdstat` 看状态，重建有窗口。
7. 分区表/4K 对齐、`mkfs` 块/inode/日志、挂载 `noatime`/`ro`/`noexec`、`fsck` 超级块救援是底层四件事。
8. `strace`/`iostat`/`blktrace`/`/proc/diskstats` 给块层证据；动盘前先快照/备份，回滚路径要验证。

## 学完之后

1. **[闭卷回忆卡](ch10-recall.md)**：先合上正文，把四层对应、df/du、fstab、LVM、RAID、fsck 六组结论从空白纸上叫出来。
2. **[习题集](ch10-exercises.md)**：A 组检查概念，B 组诊断“为什么满了/为什么起不来/为什么扩容没生效”，C 组做 LVM/RAID/fsck/块层实验。
3. **[学习目标自检表](ch10-checklist.md)**：把卡住的点对到正文小节和习题，回到那一节重读。
4. **[勘误与版本注记](ch10-errata.md)**：把 ext4/XFS/Btrfs、LVM/RAID、TRIM/配额的版本差异过一遍。
5. **下一站**：[0.11 软件包、编译、库与镜像](ch11.md) 会从存储转到软件供应链；本章的挂载/空间/依赖会在那里接到包管理与镜像。
