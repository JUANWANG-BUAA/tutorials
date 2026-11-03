# 0.10 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 四层对应

块设备、分区、文件系统、挂载点怎样对应？用哪三条命令画出来？

::: sol 解答

块设备是磁盘/LVM/RAID；分区是设备上的区间；文件系统在分区/LV 上创建；挂载点把文件系统接到目录树。`lsblk -f` 看设备→分区→文件系统→挂载点；`findmnt` 看挂载树；`df -hT` 看已挂载文件系统的类型/容量/使用率。`blkid` 看 UUID/PARTUUID。

:::
:::

::: ex A2 · `df` 与 `du`

`df` 与 `du` 各看什么？为什么两者会对不上？`du -x` 的 `-x` 是什么？

::: sol 解答

`df` 看文件系统块占用/可用（含保留块）；`du` 递归统计文件占用的块。对不上因为：稀疏文件、硬链接、deleted-but-open、保留块（ext4 默认 5%）、挂载点/权限。`du -x` 不跨文件系统，避免把别的挂载算进来。

:::
:::

::: ex A3 · inode 用尽

inode 用尽是什么现象？怎样确认？常见原因是什么？

::: sol 解答

现象：`df -h` 还有空间，但创建文件报 `No space left on device`。确认：`df -i` 看 IUse% 100%。常见原因：大量小文件（邮件队列、缓存、容器层、日志碎片）。处理：删小文件/归档、扩 inode（重建文件系统，ext4 `-N`）、换 XFS/Btrfs（动态 inode）。

:::
:::

::: ex A4 · fstab 与救援

`/etc/fstab` 每列是什么？为什么推荐 UUID/PARTUUID？改错后怎样救援？

::: sol 解答

列：设备（UUID/PARTUUID/路径）、挂载点、类型、选项、dump、pass。UUID/PARTUUID 不随设备名变化，避免插拔/重启后错挂。改完先 `mount -a` 验证；启动失败进救援：`mount -o remount,rw /`、检查 fstab、`systemctl daemon-reload`、`mount -a`；必要时 `rd.break`/`emergency.target`。

:::
:::

::: ex A5 · LVM

LVM 的 PV/VG/LV 是什么？在线扩容的步骤是什么？扩容后为什么还要 `resize2fs`/`xfs_growfs`？

::: sol 解答

PV 是物理卷（磁盘/分区），VG 是卷组（PV 池），LV 是逻辑卷（可格式化/挂载）。扩容：`pvcreate`→`vgextend`→`lvextend -L +10G /dev/vg/lv`→`resize2fs`（ext4）或 `xfs_growfs`（XFS）。LVM 只扩了块设备，文件系统还要扩才能用新空间。`lvs`/`vgs`/`pvs` 查看。

:::
:::

::: ex A6 · RAID

RAID 0/1/5/6/10 的容量/冗余/性能怎样取舍？`/proc/mdstat` 看什么？重建期间为什么危险？

::: sol 解答

RAID 0 条带无冗余、容量全用、性能高；RAID 1 镜像、容量减半、可坏一块；RAID 5 单校验、容量 n-1、可坏一块、重建压力大；RAID 6 双校验、容量 n-2、可坏两块；RAID 10 镜像+条带、容量减半、性能/恢复好。`/proc/mdstat` 看阵列状态/成员/重建进度；重建期间另一块盘再坏会丢数据，且性能下降。

:::
:::

::: ex A7 · `mkfs`、挂载与 `fsck`

`mkfs.ext4`/`mkfs.xfs` 的块大小/inode/日志怎样选？挂载 `noatime`/`ro`/`noexec`/`nosuid` 各做什么？`fsck` 为什么不能对挂载中的文件系统跑？

::: sol 解答

块大小依负载（默认 4K）；inode 数量依小文件量（ext4 `-N`/`-i`）；日志影响崩溃恢复/性能。`noatime` 不更新访问时间；`ro` 只读；`noexec` 禁止执行；`nosuid` 忽略 setuid。`fsck` 在挂载中跑会与内核缓存冲突/误修，先卸载或只读；XFS 用 `xfs_repair`。

:::
:::

::: ex A8 · 块层证据

`iostat -x`、`blktrace`、`/proc/diskstats` 各给什么证据？`await`/`util`/`aqu-sz` 是什么？

::: sol 解答

`iostat -x 1` 给每设备 r/s、w/s、rkB/s、wkB/s、await、util、aqu-sz；`blktrace` 追块层请求/完成；`/proc/diskstats` 是累计计数。`await` 平均 I/O 等待（ms，含队列+服务）；`util` 设备忙占比；`aqu-sz` 平均队列长度。它们说明“慢在哪一层”，不直接说明文件/进程；配合 `strace`/`iotop`。

:::
:::

## B 组 · 诊断推理

::: ex B1 · `df` 与 `du` 对不上

`df -h` 显示根分区 100%，`du -xsh /` 只有几十 GB。列出至少四种原因与验证命令。

::: sol B1 核对

① deleted-but-open：`lsof +L1`；② 稀疏文件：`du -h --apparent-size`；③ 硬链接：`du -h` 只算一次；④ ext4 保留块：`tune2fs -l` 看 Reserved block count；⑤ 其他挂载点/容器层：`df -hT`、`findmnt`；⑥ inode 满：`df -i`。最常见是 deleted-but-open。

:::
:::

::: ex B2 · fstab 写错起不来

改完 `/etc/fstab` 重启，系统进 emergency mode。为什么？救援步骤是什么？

::: sol B2 核对

fstab 行写错（UUID 错、挂载点不存在、选项不支持、类型错）会让 systemd 挂载失败，进 emergency。救援：`mount -o remount,rw /`；`cat /etc/fstab` 校对；`mount -a` 看报错；改回/注释错误行；`systemctl daemon-reload`；`systemctl default`/重启。改 fstab 前先备份、先 `mount -a` 验证。

:::
:::

::: ex B3 · LVM 扩容没生效

`lvextend -L +10G /dev/vg/lv` 成功，但 `df -h` 还是原来的大小。为什么？怎样修？

::: sol B3 核对

LVM 只扩了块设备，文件系统没扩。ext4：`resize2fs /dev/vg/lv`；XFS：`xfs_growfs /mountpoint`（XFS 只能在线扩，不能缩）。先 `lvs`/`df -hT` 确认 LV 与文件系统；扩完 `df -h` 复核。缩容要非常小心（XFS 不支持缩）。

:::
:::

::: ex B4 · RAID 降级

`cat /proc/mdstat` 显示 `[U_]`/`degraded`。列出至少三种原因与处理步骤。

::: sol B4 核对

① 磁盘故障/掉线：看 `dmesg`/`smartctl -a`；② 线缆/背板/控制器问题；③ 误 `--fail`/`--remove`；④ 重建未完成。处理：`mdadm --detail /dev/mdX` 看成员；`smartctl` 判断盘；换盘后 `mdadm --add` 重建；监控 `/proc/mdstat`；重建期间避免再次故障，先备份。

:::
:::

::: ex B5 · inode 满

`df -h` 还有空间，但创建文件报 `No space left on device`。怎样确认是 inode 满？怎样找“小文件大户”？

::: sol B5 核对

`df -i` 看 IUse% 100%。找小文件：`du -x --inodes -d1 /` 看各目录 inode 数；`find /var -xdev -type f | wc -l`；`ls -la` 看隐藏文件；容器层/邮件队列/缓存常见。处理：删/归档、扩 inode（重建 FS）、换 XFS/Btrfs。

:::
:::

::: ex B6 · 超级块救援

ext4 文件系统挂载报 `bad superblock`。怎样用备份超级块救援？

::: sol B6 核对

先备份/快照；`dumpe2fs /dev/sdX | grep -i superblock` 或 `mke2fs -n /dev/sdX` 看备份超级块位置；`e2fsck -b 32768 /dev/sdX`（常见备份块）尝试；必要时 `e2fsck -f -y`。XFS 用 `xfs_repair`（先 `-n` 只读检查）。不要对挂载中的 FS 跑 fsck；设备名/分区号先核对。

:::
:::

## C 组 · 动手实验

::: ex C1 · 画出存储四层

用 `lsblk -f`、`findmnt`、`df -hT`、`blkid` 画本机「设备 → 分区 → 文件系统 → 挂载点」，标出根分区。

::: sol C1 核对

```bash
lsblk -f
findmnt /
df -hT /
blkid
```

`lsblk -f` 给树状设备/分区/FSTYPE/MOUNTPOINT；`findmnt /` 给根挂载源/类型/选项；`df -hT /` 给容量/使用率；`blkid` 给 UUID/PARTUUID。验收：能说出根分区设备名、文件系统类型、挂载选项、UUID。

:::
:::

::: ex C2 · LVM 扩容

在虚拟机加一块盘/分区，创建 PV/VG/LV，格式化挂载，扩 LV 10G，再扩文件系统，验证 `df`。

::: sol C2 核对

```bash
pvcreate /dev/sdb1
vgcreate vgdemo /dev/sdb1
lvcreate -L 5G -n lvdemo vgdem
mkfs.ext4 /dev/vgdem/lvdemo
mkdir -p /mnt/demo && mount /dev/vgdem/lvdemo /mnt/demo
lvextend -L +10G /dev/vgdem/lvdemo
resize2fs /dev/vgdem/lvdemo
df -h /mnt/demo
```

关键：`lvextend` 后必须 `resize2fs`（ext4）/`xfs_growfs`（XFS）；`lvs`/`vgs`/`pvs` 查看；实验前快照，别在宿主真盘上做。

:::
:::

::: ex C3 · RAID 1 实验

用两块 loop/空盘建 RAID 1，查看 `/proc/mdstat`，模拟一块盘故障并重建。

::: sol C3 核对

```bash
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/loop0 /dev/loop1
cat /proc/mdstat
mdadm --detail /dev/md0
mdadm /dev/md0 --fail /dev/loop0 --remove /dev/loop0
mdadm /dev/md0 --add /dev/loop0
```

`/proc/mdstat` 看 `[U_]`/`[UU]` 与重建进度；`--detail` 看成员/状态；换盘后 `--add` 重建。实验用 loop 设备，别碰真盘；RAID 5/6 重建窗口更危险。

:::
:::

::: ex C4 · fsck 与超级块

在 loop 文件系统上制造/模拟超级块损坏，用备份超级块救援；先 `e2fsck -n` 只读检查。

::: sol C4 核对

```bash
dd if=/dev/zero of=/tmp/fs.img bs=1M count=64
mkfs.ext4 /tmp/fs.img
sudo mount -o loop /tmp/fs.img /mnt
# 卸载后模拟损坏（仅实验）
sudo umount /mnt
sudo dd if=/dev/zero of=/tmp/fs.img bs=1024 count=2 seek=1 conv=notrunc
sudo e2fsck -n /tmp/fs.img   # 只读检查
sudo e2fsck -b 32768 /tmp/fs.img
```

关键：先备份/快照；`-n` 只读；备份超级块位置用 `dumpe2fs`/`mke2fs -n` 查；XFS 用 `xfs_repair`，不要混用。

:::
:::

::: ex C5 · 块层证据与巡检脚本

用 `iostat -x 1`/`/proc/diskstats` 看一次 I/O；写一个磁盘巡检脚本：`df -h`、`df -i`、`lsblk`、SMART、`/proc/mdstat`。

::: sol C5 核对

```bash
iostat -x 1 3
cat /proc/diskstats | head
```

巡检脚本：

```bash
#!/usr/bin/env bash
set -euo pipefail
echo "== df"; df -hT
echo "== inode"; df -i
echo "== block"; lsblk -f
echo "== raid"; cat /proc/mdstat 2>/dev/null || true
echo "== smart"
for d in /dev/sd? /dev/nvme?n1; do
    [[ -e $d ]] || continue
    smartctl -H "$d" 2>/dev/null | grep -E 'SMART overall|result' || true
done
```

关键：`df -h`/`df -i` 分块/inode；`lsblk -f` 看四层；`/proc/mdstat` 看 RAID；`smartctl -H` 看健康。脚本只读，先 dry-run；生产加告警/日志。

:::
:::
