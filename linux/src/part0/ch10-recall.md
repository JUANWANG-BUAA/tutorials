# 0.10 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先看清存储

### D1 · 四层对应

块设备、分区、文件系统、挂载点怎样对应？用哪三条命令画出来？

::: sol D1 核对

块设备是磁盘/LVM/RAID 等；分区是设备上的区间；文件系统在分区/LV 上创建；挂载点把文件系统接到目录树。`lsblk -f` 看设备→分区→文件系统→挂载点；`findmnt` 看挂载树；`df -hT` 看已挂载文件系统的类型/容量/使用率。`blkid` 看 UUID/PARTUUID。
:::

### D2 · `df` 与 `du`

`df` 与 `du` 各看什么？为什么两者会对不上？`du -x` 的 `-x` 是什么？

::: sol D2 核对

`df` 看文件系统块占用/可用（含保留块）；`du` 递归统计文件占用的块。对不上因为：稀疏文件（逻辑大、块少）、硬链接（`du` 只算一次/各名字显示）、deleted-but-open（`df` 还算，`du` 看不到）、保留块（ext4 默认 5%）、挂载点/权限。`du -x` 不跨文件系统，避免把别的挂载算进来。
:::

### D3 · inode 用尽

inode 用尽是什么现象？怎样确认？常见原因是什么？

::: sol D3 核对

现象：`df -h` 还有空间，但创建文件报 `No space left on device`。确认：`df -i` 看 IUse% 100%。常见原因：大量小文件（邮件队列、缓存、容器层、日志碎片）。处理：删小文件/归档、扩 inode（重建文件系统，ext4 `-N`）、换 XFS/Btrfs（动态 inode）。
:::

### D4 · fstab 与救援

`/etc/fstab` 每列是什么？为什么推荐 UUID/PARTUUID？改错后怎样救援？

::: sol D4 核对

列：设备（UUID/PARTUUID/路径）、挂载点、类型、选项、dump、pass。UUID/PARTUUID 不随设备名（`/dev/sda`）变化，避免插拔/重启后错挂。改完先 `mount -a` 验证；启动失败进救援：`mount -o remount,rw /`、检查 fstab、`systemctl daemon-reload`、`mount -a`；必要时 `rd.break`/`emergency.target`。
:::

### D5 · LVM

LVM 的 PV/VG/LV 是什么？在线扩容的步骤是什么？扩容后为什么还要 `resize2fs`/`xfs_growfs`？

::: sol D5 核对

PV 是物理卷（磁盘/分区），VG 是卷组（PV 池），LV 是逻辑卷（可格式化/挂载）。扩容：`pvcreate`→`vgextend`→`lvextend -L +10G /dev/vg/lv`→`resize2fs`（ext4）或 `xfs_growfs`（XFS）。LVM 只扩了块设备，文件系统还要扩才能用新空间。`lvs`/`vgs`/`pvs` 查看。
:::

### D6 · RAID

RAID 0/1/5/6/10 的容量/冗余/性能怎样取舍？`/proc/mdstat` 看什么？重建期间为什么危险？

::: sol D6 核对

RAID 0 条带无冗余、容量全用、性能高；RAID 1 镜像、容量减半、可坏一块；RAID 5 单校验、容量 n-1、可坏一块、重建压力大；RAID 6 双校验、容量 n-2、可坏两块；RAID 10 镜像+条带、容量减半、性能/恢复好。`/proc/mdstat` 看阵列状态/成员/重建进度；重建期间另一块盘再坏会丢数据，且性能下降。
:::

### D7 · swap、TRIM、配额、SMART

swap、TRIM、磁盘配额、SMART 各解决什么？各给一条命令。

::: sol D7 核对

swap：内存不足时换出，`mkswap`/`swapon`/`free`；TRIM：通知 SSD 哪些块可回收，`fstrim -av`/`discard`；磁盘配额：限制用户/组空间/inode，`quota`/`repquota`/`setquota`；SMART：磁盘健康/坏道预警，`smartctl -a /dev/sdX`。swap 不是越多越好；TRIM 依文件系统/SSD；配额要在挂载选项启用。
:::

## B. 第二遍：底层与证据

### D8 · 分区表与对齐

MBR 与 GPT 差在哪？4K 对齐为什么重要？`fdisk`/`sgdisk`/`parted` 各适合什么？

::: sol D8 核对

MBR：2 TB 上限、4 主分区、旧 BIOS；GPT：大容量、128 分区、CRC、UEFI。4K 对齐让分区起始扇区是 4K 的倍数，避免跨块读写放大；`parted`/`sgdisk` 默认对齐。`fdisk` 交互式（MBR/GPT），`sgdisk` 脚本化 GPT，`parted` 通用/脚本。改分区表前备份。
:::

### D9 · `mkfs` 与挂载选项

`mkfs.ext4`/`mkfs.xfs` 的块大小/inode/日志怎样选？挂载 `noatime`/`ro`/`noexec`/`nosuid` 各做什么？

::: sol D9 核对

块大小依负载（默认 4K）；inode 数量依小文件量（ext4 `-N`/`-i`）；日志（`-J`）影响崩溃恢复/性能。`noatime` 不更新访问时间（减少写）；`ro` 只读；`noexec` 禁止执行；`nosuid` 忽略 setuid。`mount -o remount` 可改部分选项；fstab 持久化。
:::

### D10 · `fsck` 与超级块

`fsck`/`e2fsck`/`xfs_repair` 各做什么？为什么不能对挂载中的文件系统跑？超级块坏了怎样救？

::: sol D10 核对

`fsck` 是前端，ext4 用 `e2fsck`，XFS 用 `xfs_repair`（XFS 不用 fsck 修）。挂载中跑会与内核缓存冲突/误修，先卸载或只读。ext4 超级块有备份（`mke2fs -n` 看位置），用 `e2fsck -b 32768 /dev/sdX` 尝试备份超级块；先备份/快照。
:::

### D11 · 块层证据

`iostat -x`、`blktrace`、`/proc/diskstats` 各给什么证据？`await`/`util`/`aqu-sz` 是什么？

::: sol D11 核对

`iostat -x 1` 给每设备 r/s、w/s、rkB/s、wkB/s、await、util、aqu-sz；`blktrace` 追块层请求/完成；`/proc/diskstats` 是累计计数。`await` 平均 I/O 等待（ms，含队列+服务）；`util` 设备忙占比；`aqu-sz` 平均队列长度。它们说明“慢在哪一层”，不直接说明文件/进程；配合 `strace`/`iotop`。
:::

### D12 · 回滚与陷阱

动磁盘前应做哪些准备？任选三个陷阱，说出“现象 → 原因 → 修复”。

::: sol D12 核对

准备：确认设备名（`lsblk`/`blkid`）、备份/快照、确认挂载点/文件系统、准备救援介质、写回滚步骤。陷阱示例：① `mkfs` 选错盘——设备名变化/手滑，先 `lsblk -f` 核对；② fstab 写错起不来——`mount -a` 验证/救援；③ LVM 快照满——快照空间要够，监控 `lvs`；④ RAID5 写洞——用 BBU/日志/RAID6；⑤ TRIM 不支持——查 `lsblk -D`/文件系统；⑥ deleted-but-open 空间不释放——`lsof +L1`。
:::
