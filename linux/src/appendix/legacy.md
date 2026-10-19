# A.1 历史与兼容：被淘汰的内容怎么读

## 1. 为什么要留这一章

很多教材写于 2010 年前后，里面的 `ifconfig`、`/etc/inittab`、`iptables`、ext3、32 位汇编在今天仍然能见到——在旧服务器、旧文档、旧面试题里。完全删掉会让读者在真实环境里断档；全部保留又会把主线拖回过去。

本章的原则：**只保留「它是什么、为什么被取代、今天怎么迁移」三件事**。不展开旧实现的细节；需要时给出可执行的对照命令。

## 2. init：SysV → systemd

### 2.1 旧模型

SysV init 是 PID 1，读 `/etc/inittab`，按 runlevel 执行 `/etc/rc.d/rcN.d/` 下的 `Snn`/`Knn` 脚本。串行启动，靠命名排序，依赖关系靠脚本自己写。

| 旧概念 | 今天 |
|:--|:--|
| runlevel 0–6 | `poweroff.target`、`rescue.target`、`multi-user.target`、`graphical.target`、`reboot.target` |
| `/etc/inittab` | `systemctl set-default`、`systemd.preset` |
| `/etc/rc.d/rc.local` | `rc-local.service`（仍可用，但不推荐） |
| `service foo start` | `systemctl start foo` |
| `chkconfig foo on` | `systemctl enable foo` |
| `update-rc.d` | `systemctl enable/disable` |
| `init q` / `telinit` | `systemctl daemon-reload` |

### 2.2 迁移一个 SysV 脚本

旧脚本：

```bash
#!/bin/sh
### BEGIN INIT INFO
# Provides:          myapp
# Required-Start:    $network $remote_fs
# Default-Start:     2 3 4 5
# Short-Description: my app
### END INIT INFO
case "$1" in
  start) /usr/local/bin/myapp --daemon ;;
  stop)  killall myapp ;;
  restart) "$0" stop; sleep 1; "$0" start ;;
esac
```

新 unit（`/etc/systemd/system/myapp.service`）：

```ini
[Unit]
Description=My App
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/myapp --foreground
Restart=on-failure
RestartSec=2
User=myapp
Group=myapp
LimitNOFILE=65536
NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

启用：

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now myapp
systemctl status myapp
journalctl -u myapp -f
```

关键差异：systemd 要求程序**前台运行**（`Type=simple`），不要自己 `daemon()`；日志写 stderr 即可，由 journald 收集。

### 2.3 仍然会遇到旧系统

- CentOS 6 / RHEL 6：SysV + Upstart 混合；
- Debian 7 及更早：SysV；
- 嵌入式：BusyBox init、`inittab`；
- 容器：很多镜像没有 init，PID 1 是你的程序，必须自己处理 `SIGCHLD` 与僵尸。

## 3. 网络工具：net-tools → iproute2

`net-tools`（`ifconfig`/`route`/`arp`/`netstat`）在多数新发行版已不预装。对照：

| 目的 | 旧命令 | 新命令 |
|:--|:--|:--|
| 看接口 | `ifconfig -a` | `ip link show` / `ip addr show` |
| 配 IP | `ifconfig eth0 10.0.0.2/24` | `ip addr add 10.0.0.2/24 dev eth0` |
| 启停接口 | `ifconfig eth0 up` | `ip link set eth0 up` |
| 路由 | `route -n` | `ip route show` |
| 加路由 | `route add -net 10.0.0.0/8 via 192.168.1.1` | `ip route add 10.0.0.0/8 via 192.168.1.1` |
| ARP | `arp -n` | `ip neigh show` |
| 监听端口 | `netstat -lntp` | `ss -lntp` |
| 连接 | `netstat -anp` | `ss -anp` |
| 统计 | `netstat -s` | `ss -s` / `nstat -az` |
| 规则 | `iptables -L` | `nft list ruleset` |
| 地址配置持久化 | `/etc/network/interfaces` | NetworkManager / systemd-networkd / netplan |

为什么换：

- `ip` 用 netlink，能表达策略路由、VRF、网络命名空间、多路径；
- `ss` 直接读内核 socket 表，比 `netstat` 扫 `/proc` 快得多；
- `nft` 支持原子规则集、集合、映射、多族（inet）。

## 4. 防火墙：iptables → nftables

iptables 的 `filter/nat/mangle/raw` 表、链、规则，在 nftables 里对应「表（family）→ 链（hook）→ 规则」。新系统上 `iptables` 命令通常是 `iptables-nft` 兼容层，底层仍是 nftables。

旧：

```bash
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -P INPUT DROP
```

新：

```bash
nft add table inet filter
nft add chain inet filter input '{ type filter hook input priority 0; policy drop; }'
nft add rule inet filter input ct state established,related accept
nft add rule inet filter input tcp dport 22 accept
```

对照要点：

| iptables | nftables |
|:--|:--|
| `-t filter` | `table inet filter`（family 可 `inet/ip/ip6/arp/bridge`） |
| `-A INPUT` | `chain input { type filter hook input ... }` |
| `-m state --state` | `ct state` |
| `-m multiport` | `tcp dport { 80, 443 }` |
| `-m set` | `ip saddr @allowlist` |
| `-j SNAT --to` | `snat to` |
| `-j DNAT --to` | `dnat to` |
| `iptables-save` | `nft list ruleset` |
| `iptables-restore` | `nft -f file.nft` |

迁移工具：`iptables-restore-translate -f rules.v4 > rules.nft`，人工复核后再 `nft -f`。

## 5. 文件系统：ext2/ext3 → ext4/XFS/Btrfs

| 旧 | 今天 | 说明 |
|:--|:--|:--|
| ext2 | ext4（无日志） | ext2 无日志，崩溃后需 `fsck`；ext4 可关日志但仍有 extents |
| ext3 | ext4 | ext4 兼容 ext3 挂载；`data=journal/ordered/writeback` |
| ReiserFS | XFS/Btrfs | 已从主线移除 |
| `mke2fs -j` | `mkfs.ext4` | 默认启用日志、extents、delayed allocation |
| `tune2fs -O dir_index` | 默认 | ext4 默认开启 |
| `mount -t ext3` | `mount -t ext4` | 内核按魔数识别，通常不用显式 `-t` |

选型建议：

- **通用服务器**：ext4（成熟、工具全）或 XFS（大文件、高并发）；
- **需要快照/校验/压缩**：Btrfs（单机）或 ZFS（注意许可证）；
- **数据库**：XFS + `noatime`，独立数据盘；WAL 与数据分盘；
- **容器**：overlayfs（第 5 篇）。

旧挂载选项的现状：

- `noatime` 仍有效，推荐；
- `data=writeback` 性能好但崩溃后数据可能旧，慎用；
- `barrier=0` 已废弃/危险，不要用；
- `discard` 对 SSD 有性能影响，优先 `fstrim.timer`。

## 6. 启动：BIOS/MBR → UEFI/GPT

| 旧 | 今天 |
|:--|:--|
| BIOS + MBR（446 字节引导代码 + 4 个主分区） | UEFI + GPT（128 个分区、CRC、备份表） |
| GRUB Legacy（`menu.lst`） | GRUB 2（`grub.cfg`、`grub-mkconfig`）或 systemd-boot |
| `initrd`（ext2 镜像） | `initramfs`（cpio.gz，可含 udev/systemd） |
| `lilo` | 已淘汰 |
| `fdisk`（MBR） | `gdisk`/`parted`/`fdisk`（GPT） |

查看：

```bash
[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS
lsblk -o NAME,SIZE,FSTYPE,PARTTYPENAME
efibootmgr -v
```

迁移注意：

- UEFI 需要 ESP（FAT32，通常 512 MB–1 GB，挂 `/boot/efi`）；
- 安全启动（Secure Boot）会限制未签名内核模块；
- 换引导方式后要重装 bootloader，别只改分区表。

## 7. 32 位 x86：`int 0x80`、`sysenter` 与 32 位兼容

| 项 | 32 位 | x86-64 |
|:--|:--|:--|
| 系统调用入口 | `int 0x80` / `sysenter` | `syscall` |
| 系统调用号寄存器 | `%eax` | `%rax` |
| 参数寄存器 | `%ebx/%ecx/%edx/%esi/%edi/%ebp` | `%rdi/%rsi/%rdx/%r10/%r8/%r9` |
| 返回值 | `%eax` | `%rax` |
| 地址空间 | 4 GB | 48/57 位 |
| 通用寄存器 | 8 个 | 16 个 |

今天仍会遇到：

- 32 位二进制在 x86-64 内核上通过 `CONFIG_IA32_EMULATION` 运行；
- `int 0x80` 在 64 位程序里仍可用，但只支持 32 位系统调用号、指针截断到 32 位，**不要用**；
- `vsyscall` 页是历史兼容机制，新内核默认 `vsyscall=none` 或 emulated。

## 8. 调度器：O(1) → CFS → EEVDF

| 版本 | 调度器 | 核心思想 | 现状 |
|:--|:--|:--|:--|
| 2.4 | O(n) | 每次遍历所有任务 | 历史 |
| 2.6 | O(1) | 优先级数组 + 位图 | 历史 |
| 2.6.23+ | CFS | `vruntime` 红黑树，按权重分配 CPU | 6.5 前主线 |
| 6.6+ | EEVDF | 用 lag/vslice 做更公平的延迟分配 | 当前主线 |

旧教材里的「CFS 红黑树 + `vruntime`」仍然是理解调度公平性的好模型；但 6.6 之后内核默认 EEVDF，`/proc/sched_debug` 的字段与调参项有变化。读旧资料时注意版本。

## 9. IPC：SysV → POSIX

| 目的 | SysV | POSIX / 现代 |
|:--|:--|:--|
| 共享内存 | `shmget/shmat/shmdt` | `shm_open` + `mmap` |
| 信号量 | `semget/semop/semctl` | `sem_open/sem_wait/sem_post` |
| 消息队列 | `msgget/msgsnd/msgrcv` | `mq_open/mq_send/mq_receive` |
| 键 | `key_t` + `IPC_PRIVATE`/`ftok` | 路径名 `/name` |
| 生命周期 | 显式删除，否则残留 | `shm_unlink`/`sem_unlink`/`mq_unlink` |

SysV IPC 仍在内核里（`/proc/sysvipc/`），但新代码优先 POSIX：命名更直观、与 fd 模型更近（消息队列可用 `mq_notify`/`mqfd` 风格）、更容易容器化。

## 10. 打包与部署：源码 → 包 → 容器

| 时代 | 做法 | 问题 |
|:--|:--|:--|
| 源码 tarball | `./configure && make && make install` | 依赖漂移、难卸载、污染 `/usr/local` |
| 发行版包 | deb/rpm + 依赖解析 | 版本旧、跨发行版难 |
| 语言包管理 | pip/npm/cargo | 运行时依赖、锁文件 |
| 容器镜像 | Dockerfile + 多阶段构建 | 镜像膨胀、供应链安全 |
| 声明式部署 | Kubernetes/Helm/GitOps | 复杂度高 |

今天的主线：**构建产物用容器固化，运行环境用声明式配置**。但底层仍是包管理与动态库，[0.11](../part0/ch11.md) 讲的是这一层，不要跳过。

## 11. 桌面与网络管理（只列，不展开）

| 旧 | 今天 |
|:--|:--|
| `ifupdown`（`/etc/network/interfaces`） | NetworkManager / systemd-networkd / netplan |
| X11 | Wayland（XWayland 兼容） |
| `syslogd` | `rsyslog` / `journald` |
| `cron` 唯一 | systemd timer、cron、anacron |
| `iptables` 脚本 | `nftables` + firewalld/ufw |
| `init.d` 脚本 | systemd unit |

## 11.1 其他历史接口：一张表

| 旧接口/概念 | 今天 | 本书处理 |
|:--|:--|:--|
| LinuxThreads（glibc 2.3 前的线程实现） | NPTL；`clone` + futex | 只在 2.12 一句带过；不要按 LinuxThreads 的 `getpid` 语义写代码 |
| `syslog()` + `/etc/syslog.conf` | `journald` / `rsyslog`；`syslog(3)` API 仍在 | 0.12 讲 `journalctl`；旧配置进本节 |
| `utmp`/`wtmp`/`lastlog` | 仍由 `systemd-update-utmp` 维护，但容器/`loginctl` 更常用 | 0.12.4.1 讲现状与边界 |
| `inetd`/`xinetd` | systemd socket activation（`.socket` unit） | 0.12 讲 socket unit，不展开 inetd |
| TCP Wrappers（`hosts.allow`/`hosts.deny`） | `nftables`、sshd `AllowUsers`、应用层鉴权 | 0.13/5.6 讲 nftables；本节说明已淘汰 |
| `devfs` | `devtmpfs` + udev | 3.14 讲设备模型；本节一句 |
| `X Window` 配置（`xorg.conf`） | Wayland（XWayland 兼容） | 不属本书范围 |
| `ifupdown`（`/etc/network/interfaces`） | NetworkManager / systemd-networkd / netplan | 0.13 讲 iproute2；本节对照 |
| `initrd`（ext2 镜像） | `initramfs`（cpio.gz） | 0.12/3.2 讲 initramfs |
| `a.out` / `libc5` | ELF / glibc 2.x | 1.7 讲 ELF；本节一句 |
| `O(1)` 调度器、`cfq` I/O 调度器 | EEVDF、`blk-mq`（`mq-deadline`/`kyber`/`bfq`） | 3.5/3.13 讲现代实现 |
| `tcp_tw_recycle` | 4.12 移除 | 4.5 明确不要用 |

> 判断标准：如果新代码/新系统已经不应使用它，就进本表；如果只是「有更现代的选择」，留在正文并标注兼容。

## 12. 兼容性检查清单

遇到旧系统/旧文档，按这个顺序确认：

1. **发行版与版本**：`cat /etc/os-release`；
2. **init**：`ps -p 1 -o comm=`；
3. **内核**：`uname -r`；
4. **网络管理**：`systemctl is-active NetworkManager systemd-networkd`；
5. **防火墙**：`nft list ruleset` / `iptables -L`；
6. **文件系统**：`findmnt -T /`；
7. **引导**：`[ -d /sys/firmware/efi ]`；
8. **libc**：`ldd --version`；
9. **包管理**：`command -v apt dnf yum zypper`；
10. **容器运行时**：`docker info` / `crictl info`。

## 13. 哪些内容本书不再讲

以下内容只在本章出现，正文不再展开：

- SysV init 脚本的 `start-stop-daemon` 细节；
- `iptables` 的 `-m owner`/`-m recent` 等模块细节；
- ext2 的间接块映射（只讲 ext4 extents）；
- 32 位分段（segment）与 `__USER32_CS`；
- O(1) 调度器的优先级数组；
- `initrd` 的 ext2 镜像制作；
- `inittab` 的 `respawn`/`sysinit` 语法；
- `lilo`、`grub-legacy`、`ReiserFS`；
- `ifupdown` 的 `pre-up`/`post-down` 钩子。

> **下一站**：[A.2 工具箱](toolbox.md)给出今天该装的命令与调试器。
