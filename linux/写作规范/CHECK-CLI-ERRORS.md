# CLI / Part 0 事实核查报告（CHECK-0）

> 范围：`src/part0/ch01–ch14.md`（16,269 行，530 个 shell 代码块）。
> 母本：鸟哥《Linux 私房菜·基础学习篇》、Shotts《The Linux Command Line》、Blum《Linux Command Line and Shell Scripting Bible》、Kerrisk《The Linux Programming Interface》及现行 man-pages。
> 性质：**只读核查**。本报告不改正文；「正确说法」仅供主线程采纳。
> 口径：Ubuntu 24.04 LTS / bash 5.2+ / procps-ng 4.0 / sysstat 12.6 / util-linux 2.39 / iproute2 6.1 / systemd 255 / coreutils 9.4。书中明确写「以 Ubuntu 24.04 为准」的，按该版本判定。

## 统计

- 已读：14/14 章（结构、530 个代码块；命令密集节逐节抽读，长章按节抽读并交叉 grep）
- `bash -n`：**530/530 通过**（C.1）
- 已确认事实错误：**20 条**（A.1–A.20）
- 仍存疑、未计入：4 条（A.21）
- 漏节：**15 条**（B，按母本节级比对）
- 已核对无问题：C.2（83 项）+ C.3（跨章一致性）

---

## A. 事实错误（Top 20）

> 判定门槛：正文明确陈述、可被 man/规范/实测证伪，且会误导读者操作或排障。
> `实测` 指本机 bash 5.3.20 复现；涉及 Linux 专有语义的，另给 man/源码出处。

| # | 文件:行 | 原文（摘） | 正确说法 | 证据 |
|--:|:--|:--|:--|:--|
| **A.1** | `ch05.md:195–213` | 未开 `pipefail` 时 `yes \| head -n 1` 的 `status=141`；并说「head 退出码是 0，但 bash 报 141」 | 未开 `pipefail` 时管道退出码是**最后一个命令**的状态，`head` 正常退出，`status=0`。只有 `set -o pipefail` 后 141 才成为整条管道的状态；`PIPESTATUS` 里始终是 `141 0`。原文自己写了「head 是 0」，与「报 141」矛盾。 | Bash 手册 §3.2.3 Pipelines：「The exit status of a pipeline is the exit status of the last command in the pipeline, unless the `pipefail` option is enabled.」实测 bash 5.3.20：`0`；`set -o pipefail` 后 `141`。 |
| **A.2** | `ch09.md:85` | 「在脚本里 `kill %1` 不可用，`jobs` 也不一定有输出」 | 非交互 bash 确实默认关闭作业控制（进程组/前台组不切换），但**作业表仍在**：`jobs` 会列出后台作业，`kill %1` 也能解析作业号。关闭作业控制影响的是停止/继续、终端前台组、SIGTTIN/SIGTTOU，不是作业号解析。 | Bash 手册 §7.1 Job Control Basics（默认只在交互式 shell 打开）；实测 `bash -c 'sleep 30 & jobs; kill %1'` 打印 `[1]+ Running` 且 kill 成功。 |
| **A.3** | `ch09.md:377` | 「`ulimit -n` 改的是当前 shell 及其子进程的 fd 软限制」 | bash 内建 `ulimit` 在**既不给 `-S` 也不给 `-H`** 时，同时设置软、硬限制。`ulimit -n 512` 会把硬限制也降到 512，且当前 shell 内不可再升回；只动软限制要写 `ulimit -S -n 512`。 | Bash 手册 §4.2 `ulimit`：「If neither `-H` nor `-S` is supplied, both the soft and hard limits are set.」实测：`hard=unlimited` → `ulimit -n 512` → `hard=512`。 |
| **A.4** | `ch08.md:101–103` | 「`EXIT` 在……收到未被捕获的致命信号时触发」 | `EXIT` trap 只在 shell **正常退出**（含 `exit N`、脚本末尾）时执行。收到未被捕获的 `SIGTERM`/`SIGINT` 时 bash 直接终止，不执行 `EXIT` trap；清理必须显式 `trap cleanup TERM INT`。 | Bash 手册 §4.1 `trap`：「If a sigspec is `0` or `EXIT`, action is executed when the shell exits.」实测：`trap 'echo EXITTRAP' EXIT; sleep 5` 被 `kill -TERM` 后无输出，`wait` 返回 143。 |
| **A.5** | `ch02.md:274` | 「`disown -h %1` 只从作业表移除并标记忽略 HUP」 | `disown -h` **只**标记「shell 退出时不发 SIGHUP」，作业仍在作业表里；`jobs` 仍能看到、`kill %1` 仍可用。从表中移除的是不带 `-h` 的 `disown %1`。本书 `ch09.md:153` 的写法是正确的，两处冲突。 | Bash 手册 §7.2：`disown -h` marks each job as not to receive SIGHUP when the parent shell exits；不带 `-h` 才删除。实测：`disown -h %1` 后 `jobs` 仍输出 `[1]+ Running`。 |
| **A.6** | `ch11.md:107`、`ch11.md:463` | 「`990` 通常是 `noble-updates`」；表「`990` 目标发行版默认」 | `990` 只在 APT 配置了 **target release**（`APT::Default-Release` 或 `apt-get -t`）时分配给该 target release 的版本。Ubuntu 24.04 的 deb822 源没有设置 target release，`noble`/`noble-updates`/`noble-security` 都是 **500**；`apt-cache policy` 不会出现 990。 | `apt_preferences(5)`（Ubuntu noble，apt 2.8.3）：“priority 500 to the versions that do not belong to the target release; priority 990 to the versions that belong to the target release”，随后：“If the target release has not been specified then APT simply assigns priority 100 to all installed package versions and priority 500 to all uninstalled package versions.” Ubuntu 默认 apt 配置（`/etc/apt/apt.conf.d/`）不设置 `APT::Default-Release`；`noble-updates` 的版本在 `apt-cache policy` 中显示为 500。 |
| **A.7** | `ch12.md:196`、`ch14.md:449` | 「`Result=resources` 表示被 cgroup 限制（内存、任务数）杀掉」「MemoryMax 触发 OOM 时……`Result=resources`」 | systemd 为 OOM kill 单独设了结果值 `Result=oom-kill`；`systemctl status` / `systemctl show -p Result` 显示 `oom-kill`。`resources` 是另一个值，源码注释明确说它是「errnos we didn't expect 的兜底」，不是 OOM 专用结果。ch14 同句已写 `journalctl` 出现 `oom-kill`，与 `Result=resources` 自相矛盾。 | systemd `src/core/service.h`：`SERVICE_FAILURE_RESOURCES, /* a bit of a misnomer, just our catch-all error for errnos we didn't expect */` 与独立的 `SERVICE_FAILURE_OOM_KILL, /* OOM Kill by the Kernel or systemd-oomd */`。 |
| **A.8** | `ch14.md:219` | 「`retrans:3/120` 表示当前这条连接重传 3 次、累计发送 120 个段」 | `M/N` 是 `tcpi_retrans / tcpi_total_retrans`：M 是当前重传计数，N 是**整条连接累计重传次数**，不是发送段数。发送段数看 `segs_out` / `data_segs_out`。`ch13.md:615` 写成「已重传/总重传」才对，两处不一致。 | `include/uapi/linux/tcp.h`：`__u32 tcpi_total_retrans;`，另有 `tcpi_segs_out` 表示发送段数；iproute2 `misc/ss.c`：`out(" retrans:%u/%u", s->retrans, s->retrans_total);`，赋值处 `s->retrans = info->tcpi_retrans; s->retrans_total = info->tcpi_total_retrans;`。 |
| **A.9** | `ch03.md:315` | 「`xargs` 只要有一次调用失败，它可能仍返回 0（取决于版本与 `-r`/`--exit`）」 | GNU xargs 的退出码是确定的：任一子命令以 1–125 退出 → **123**；子命令 255 → 124；被信号杀 → 125；找不到命令 → 127。不存在「失败了仍返回 0」的版本行为。 | `xargs(1)`（GNU findutils 4.9.0，Ubuntu noble）EXIT STATUS：0 success；123 if any invocation exited 1–125；124/125/126/127 如上述。 |
| **A.10** | `ch10.md:114` | 表格行「`du` 大，`df` 不满 \| 稀疏文件、硬链接、快照 \| `du --apparent-size`、`stat`」 | 默认 `du` 统计**已分配块**，稀疏文件只会让 `du` **小于** `df` 已用，不可能造成「`du` 大、`df` 不满」。只有加 `--apparent-size` 时稀疏文件才会显示得比 `df` 大；硬链接则相反（`du` 默认对同一 inode 只计一次，通常偏小）。该行把「表观大小」口径与默认口径混在一张表里。 | `du(1)`：默认报告磁盘使用量（blocks）；`--apparent-size` 才报告表观字节数，并提示 sparse file 的 apparent size 可能更小。`stat` 的 `%b`（512B 块）与 `%s`（表观大小）对比即可验证。 |
| **A.11** | `ch14.md:819` | 「`Pss_Anon` + `Pss_File` 才是 PSS 的完整拆分」 | `smaps_rollup` 的 PSS 由 `Pss_Anon + Pss_File + Pss_Shmem` 三部分组成；只加前两项会漏掉 tmpfs/共享内存映射，容器与数据库进程尤其明显。 | `proc(5)` 的 `/proc/PID/smaps_rollup` 字段表：`Pss`、`Pss_Anon`、`Pss_File`、`Pss_Shmem`，Pss 为三者之和。 |
| **A.12** | `ch09.md:404`、`ch09.md:440` | 表「`B` \| `SCHED_BATCH` \| …… \| `chrt -o -p PID`」；命令 `chrt -o -p 2210  # 改成 SCHED_BATCH` | `chrt -o` 是 **SCHED_OTHER**（默认分时策略）；SCHED_BATCH 用 **`chrt -b`**。按原文执行会把进程设回 OTHER，而不是批处理；`-o` 和 `-b` 是两个不同策略。 | `chrt(1)`（util-linux）：`-o, --other` Set scheduling policy to SCHED_OTHER；`-b, --batch` Set scheduling policy to SCHED_BATCH。 |
| **A.13** | `ch12.md:581` | 表「`RateLimitIntervalSec=` / `RateLimitBurst=` \| 限流 \| 30s / 1000 条」 | 现行 systemd 默认是 **30 秒 10000 条**（`RateLimitBurst=10000`），不是 1000 条。这直接影响「日志突然少了」时对限流的判断。 | `journald.conf(5)`（systemd 255，Ubuntu noble）：“Defaults to 10000 messages in 30s.” |
| **A.14** | `ch04.md:665` | 表「被 `chown` 后 \| 位被清除 \| 非 root chown 清 setuid/setgid」 | Linux 上**任何用户**（含 root）`chown` 可执行文件都会清 setuid/setgid；自 Linux 2.2.13 起 root 与其他用户同样处理。 | `chown(2)`：“When the owner or group of an executable file is changed by an unprivileged user, the S_ISUID and S_ISGID mode bits are cleared... since Linux 2.2.13, root is treated like other users.” |
| **A.15** | `ch09.md:471` | 「第 22 字段 `starttime`……它和 `/proc/uptime` 的单位都是时钟滴答，换算成秒要除以 `sysconf(_SC_CLK_TCK)`」 | `starttime` 的单位是时钟滴答；`/proc/uptime` 的单位是**秒**（两个数：系统运行秒数、空闲秒数），不需要除以 `_SC_CLK_TCK`。把两者混用会让开机时间计算错 100 倍。 | `proc(5)`：`/proc/uptime` “This file contains two numbers (values in seconds): the uptime of the system ... and the amount of time spent in the idle process.” |
| **A.16** | `ch13.md:416` | `nft add rule inet filter output meta mark set 0x1 ip daddr 10.20.0.0/16` | nft 规则从左到右求值；`meta mark set 0x1` 是**语句**，在 `ip daddr` 匹配之前就执行。即使目的地址不匹配，mark 也已经被设置，导致所有经过该规则的包都被打标。正确顺序是把匹配放前面：`ip daddr 10.20.0.0/16 meta mark set 0x1`。 | `nft(8)`：规则表达式从左到右求值；match 失败只终止后续求值，已经执行的 statement 不会回滚。 |
| **A.17** | `ch03.md:516` | 表「块数 \| `-s` \| `st_blocks` \| 单位 512 字节，稀疏文件远小于 `st_size`」 | `st_blocks` 的单位确实是 512 字节，但 GNU `ls -s` **默认按 1024 字节块**显示（`-k` 明确 1024；只有 `POSIXLY_CORRECT` 下才用 512）。把 `ls -s` 与 `st_blocks` 当成同一单位，会把占用算差一倍。 | GNU coreutils `ls(1)`：`-s` “print the allocated size of each file, in blocks”；`-k` “default to 1024-byte blocks for file system usage; used only with `-s`”。coreutils 手册：默认块大小 1024，`POSIXLY_CORRECT` 下为 512。 |
| **A.18** | `ch14.md:844` | 「`iostat` 的设备参数在部分版本要写 `-p` 或直接跟设备名」 | `-p` 不是「写设备参数」，而是「显示块设备**及其所有分区**」的开关；设备名始终作为位置参数直接给（`iostat -xz 1 3 /dev/nvme0n1`）。把 `-p` 当设备参数会多出分区行或改变输出范围。 | `iostat(1)`（sysstat 12.6）：“`-p [device]` Display statistics for block devices and all their partitions”；设备名在 SYNOPSIS 中是位置参数 `[device [...]]`。 |
| **A.19** | `ch10.md:83` | 「XFS 动态分配 inode，不会出现「inode 用尽」」 | XFS 的 inode 是动态分配，但**受 `maxpct` 上限约束**（<1TB 默认 25%，<50TB 5%，>50TB 1%），inode 空间用尽时同样会 `ENOSPC`；`sparse` inode 特性也说明碎片化时 inode 分配可能失败。本书 `ch10.md:607` 自己写了 `maxpct` 默认 25%，与「不会用尽」矛盾。 | `mkfs.xfs(8)`：`maxpct=value` “maximum percentage of space ... that can be allocated to inodes. The default value is 25% for filesystems under 1TB...”；`-i sparse` 说明无该特性时 inode 分配可能 out of space。 |
| **A.20** | `ch14.md:925` | 「四线程各占 25% 会显示 100%，不是「一个核跑满」」 | 进程 `%CPU` 是所有线程之和，100% **就是**一个核的算力（4×25% 正好等于 1 核）。原文想说的是「不是**单个线程**跑满一个核」，但写成「不是一个核跑满」会让读者以为 100% 还不到一个核。 | `pidstat(1)`：`%CPU` 是任务（进程）所有线程的 CPU 使用率总和，100% 表示一个 CPU 的算力；`top` 的 `%CPU` 同理。 |

### A.21 仍存疑（未计入 Top 20，建议主线程复核）

| # | 文件:行 | 原文 | 疑点 | 复核方式 |
|--:|:--|:--|:--|:--|
| A.21.1 | `ch02.md:156` | `sudo cmd` 找不到自编译程序时「用绝对路径或 `sudo -E`（有风险）」 | Ubuntu 默认 sudoers 的 `secure_path` 会覆盖 PATH；`-E` 只关闭 `env_reset`，通常不能绕过 `secure_path`。正确修法是绝对路径或改 `secure_path`。 | `sudoers(5)` 的 `secure_path`；Ubuntu `/etc/sudoers` 默认行 |
| A.21.2 | `ch10.md:411` | SMART 重点看 `Pending_Sector`、`Media_Wearout` | 标准属性名是 `Current_Pending_Sector`、`Media_Wearout_Indicator`；缩写不致错但会影响按名 grep。 | `smartctl(8)`/smartmontools 属性表 |
| A.21.3 | `ch02.md:155` | 「`su user` 后别名没了」 | `su user`（不带 `-`）启动的是非登录**交互** shell，bash 会读 `~/.bashrc`；别名通常仍存在。只有当别名只写在 `/etc/profile` 时才丢。 | bash 启动文件规则 + 实测 |
| A.21.4 | `ch03.md:321` | 「Linux 没有通用的创建时间字段」 | `statx` 的 `btime` 在 ext4/XFS/Btrfs 上可用，本书 `ch03.md:571` 也列了 btime；「通用」若指「所有文件系统都支持」则成立，但表述容易被读成「Linux 没有 btime」。 | `statx(2)`、`stat(1)` `%w` |

---

## B. 漏节（Top 15）

> 口径：按 `写作规范/source-toc/` 的母本目录逐节比对；「真缺口」= 正文完全没有该主题的落点；「薄落点」= 只有一句/一个表项，读者无法回答「它是什么、解决什么问题、和谁相邻」。
> 只列实质知识/命令，不列练习、总结、GUI、打印、X Window、内核编译等淘汰/外篇内容。

| # | 母本 | 节号/标题 | 为什么算漏（证据） | 建议补到 |
|--:|:--|:--|:--|:--|
| **B.1** | Shotts | 第 21 章 格式化输出（`nl`、`fold`、`fmt`、`pr`、`column`、`printf`） | Part0 只在各处用 `printf`；`nl`、`fold`、`fmt`、`pr`、`column` 在 14 章中没有任何一节/表项（grep 仅命中变量名与英文单词）。整章的输出排版工具链缺失。 | `0.6.15` 文本处理速查末尾新增「0.6.15.x 格式化输出」，3–5 行表 + 一个 `column -t`/`nl -ba` 例子 |
| **B.2** | Shotts | 第 17 章 查找文件（`locate`、`updatedb`、`mlocate` 数据库） | 只有 `find`（0.3.6/0.3.14）；`locate`/`updatedb` 全文零命中（grep 只命中 `fallocate`）。读者遇到「全盘找文件」只会 `find /`。 | `0.3.6` 末尾补 1–2 段：locate 数据库、`updatedb.conf` 的 PRUNEPATHS、与 find 的取舍 |
| **B.3** | Shotts 第 16 章 / 鸟哥网络章 | `scp`、`sftp`（SSH 文件传输） | 0.13.14 只讲密钥、跳板、端口转发；`scp`/`sftp`/`ftp` 全文零命中。SSH 的四件事里「传文件」没有落点。 | `0.13.14` 末尾新增「0.13.14.x scp/sftp 与 rsync over ssh」，含 `-r`、`-P`、`-i`、`sftp -b` 批处理 |
| **B.4** | 鸟哥第 15 章 / Blum 16.6 | `at`、`batch`、`atq`、`atrm`、`at.allow`/`at.deny` | 只有 `ch12.md:317` 一段（两句话），没有 at 的时间语法、队列、权限文件、与 cron/timer 的取舍表。 | `0.12.11` 之后新增「0.12.11.x 一次性任务：at/batch」，或并入 0.12.5 |
| **B.5** | 鸟哥第 18 章 | rsyslog 配置：facility/priority、`/etc/rsyslog.conf`、`logger`、`logwatch` | 只有 journald、logrotate；`rsyslog` 仅 3 处提及（ch12:250/340/582），没有 facility.priority 规则、`/etc/rsyslog.d/*.conf`、`logger -p`、`logwatch` 日报。Ubuntu 同时装 rsyslog 与 journald，这是排障高频边界。 | `0.12.4` 或 `0.12.10` 补 1 张「journald vs rsyslog」表 + `logger`/`/etc/rsyslog.d` 例子 |
| **B.6** | 鸟哥第 20 章 | `hostnamectl`、`timedatectl`、`localectl`（主机名/时区/locale） | `hostnamectl`/`localectl` 零命中；`timedatectl` 只在 ch12:1096 的答案里出现一次。基础系统设置没有落点。 | `0.1.6` 或 `0.12.1` 补 1 个小表（三个命令 + 持久化文件 + `timedatectl set-timezone`） |
| **B.7** | Blum 9.4 | snap / flatpak 容器化包管理 | 只有 `ch11.md:345` 一句「`snap`/`flatpak` 是另一条路……服务器上通常不用」；没有 `snap list/install/connections`、`/snap`、`flatpak` 命令，也没有与 apt 依赖模型的对照表。Ubuntu 24.04 大量预装 snap，读者无法解释 `snap list`。 | `0.11.2` 或 `0.11.7` 末尾补 1 段「apt/deb 之外：snap 与 flatpak 的边界」，含 `snap list`/`snap install`/`snap connections` |
| **B.8** | 鸟哥第 8 章 | 备份策略与工具：全量/增量/差异、`dd`、`cpio`、`xfsdump`、恢复演练 | 0.8.6 只有 tar 全量快照 + 按天保留；`xfsdump` 零命中，`cpio` 只在 `ch01.md:532` 作为 initramfs 格式提了一句，`dd` 只在实验里当填充工具。没有「备份介质、3-2-1、恢复演练、增量链」这些策略层内容。 | `0.8.6` 之后新增「0.8.6.x 备份策略与恢复演练」，1 张策略表 + `rsync --link-dest` 增量快照例子 |
| **B.9** | Shotts 第 16 章 | `wget`（递归/断点/镜像） | 全文零命中；只有 `curl`（0.13.5）且用于单请求。`wget -r`/`-c`/`-m`/`--limit-rate` 是离线抓取/镜像的常用 CLI。 | `0.13.5` 补 1 段「curl vs wget」，含 `wget -c`、`wget -r -np`、`--limit-rate` |
| **B.10** | Kerrisk 第 36 章 | 进程资源限制：`RLIMIT_*` 全表、soft/hard、fork/exec 继承 | 0.9.8 只有 `ulimit -n/-u/-c` 三行 + `prlimit` 一行，没有 RLIMIT 表、继承规则、`/proc/PID/limits`、systemd `LimitNOFILE=` 的优先级。 | `0.9.8` 补 1 张 8–10 行 RLIMIT 表 + `/proc/PID/limits` 读法 |
| **B.11** | Kerrisk 第 27 章 / Blum | `system()`、`popen()` 与 `exec` 家族（`execl*`/`execv*`/`execve`） | 0.5.4 讲管道，0.9.7 讲 `/proc`，但 `system()`/`popen()` 只在 ch04:676 作为安全警告出现一次；没有「system 走 /bin/sh、popen 单向管道、exec 替换映像」的对照。 | `0.5.4` 或 `0.9.7` 补 1 个小表（system/popen/exec 的进程数、shell 参与、返回值） |
| **B.12** | Shotts 第 36 章 | `date`、`cal`、`sleep`、`time` 等日常命令 | `date` 只作为示例出现（ch03/ch05/ch08），没有格式化/解析小节；`cal` 零命中；`sleep` 只在作业控制里出现。 | `0.6.15` 或 `0.14.9` 补 1 张「日期/时间/计时」速查表 |
| **B.13** | 鸟哥第 11 章 | `diff`/`cmp`/`patch` 工作流 | `0.6.15` 只有一行 `diff` 表项 + 一个 `patch -p1` 例子；没有 `diff -u` 生成补丁、`patch --dry-run`、`.rej`/`.orig`、`cmp` 的字节级比较。 | `0.6.15` 把该行扩成 3–5 行小表 + 一个「改配置→生成 patch→回滚」例子 |
| **B.14** | 鸟哥第 4 章 | 关机/重启：`shutdown`、`reboot`、`poweroff`、`halt`、`systemctl poweroff` | `shutdown`/`poweroff`/`halt` 零命中；`reboot` 只在 ch10:191 救援步骤里出现一次。CLI 基础操作没有落点。 | `0.12.1` 开机链路末尾补 1 段「关机/重启的三种入口与风险」（`shutdown -h +10`、`systemctl poweroff`、`reboot`） |
| **B.15** | 鸟哥第 16 章 | SELinux 初探：`getenforce`/`setenforce`、Enforcing/Permissive/Disabled、`ls -Z`、`restorecon`/`chcon`、`ausearch`/`audit2why` | 只有 `0.4.1` 第 5 步的两句（`aa-status`/`getenforce`）+ 指向第 3 篇；`setenforce`/`semanage`/`chcon`/`ls -Z`/`ausearch`/`audit2why` 全文零命中。若第 3 篇未落点，这是「DAC 正常但仍 denied」的真缺口。 | `0.4.1` 后补 1 张「LSM 快速判定」表（Enforcing/Permissive、`ls -Z`、`restorecon -v`、`ausearch -m avc`），或明确交叉引用第 3 篇 |

---

## C. 已核对无问题清单

### C.1 全部 shell 代码块语法

- 对 `src/part0/ch01–14.md` 中 530 个标记为 `bash`/`sh`/`shell`/`zsh` 的围栏代码块逐个执行 `bash -n`（去掉行首 `$ ` 提示符），**530/530 通过**，无语法错误、无未闭合的 `if/for/case/heredoc`。
- 说明：`bash -n` 只证明语法，不证明运行结果；含 `sudo`、`/proc`、`/sys`、`losetup`、`mdadm` 的块按设计无法在本机执行，未做运行验证。`shellcheck` 未全量跑（会引入大量风格告警，超出事实核查范围）。

### C.2 已逐条核对、未发现事实错误的高风险点（83 项）

| 章节 | 核对内容 | 结论 |
|:--|:--|:--|
| 0.1.1 | `uname -a` 八字段、`-s/-r/-m/-o`、Ubuntu ABI 编号 | 正确 |
| 0.1.2 | 内核职责边界、宏内核、`/proc`/`/sys` 伪文件系统 | 正确 |
| 0.1.3 | GNU 用户态组成、coreutils/glibc 分工 | 正确 |
| 0.1.6 | `os-release` 字段、容器内核与用户态 | 正确 |
| 0.1.9 | man 分区 1/2/3/5/7/8、`apropos`/`whatis`/`man -k` | 正确 |
| 0.1.10 | 8 个发行版的 glibc/systemd/内核/支持窗口 | 正确 |
| 0.1.11 | `lsmod`/`modinfo`/`modules.builtin`、内置模块不显示在 lsmod | 正确 |
| 0.1.12 | UEFI 变量、`/boot`、initramfs、GRUB 配置位置 | 正确 |
| 0.1.13 | syscall ABI、vDSO、`clock_gettime`、`seccomp` | 正确（示例未实测） |
| 0.1.14 | FHS、usrmerge、`/etc` 覆盖优先级 | 正确 |
| 0.2.1 | tty/pty、行规程、`isatty` | 正确 |
| 0.2.4 | 登录/非登录/交互/非交互四象限与启动文件 | 正确（Ubuntu `ssh` 读 `.bashrc` 补丁未展开，不构成错误） |
| 0.2.6 | `Ctrl-Z`=`SIGTSTP`、`fg/bg`、`disown %1` 语义 | 除 A.5 外正确 |
| 0.2.9 | `stty -a` 字段、`-icanon/-echo/-isig/-ixon/tostop`、`stty -g` | 正确 |
| 0.3.3 | `ls -l` 列、inode、`st_blocks` | 正确 |
| 0.3.6 | `find -mtime -7`、`-size` 单位、`-perm`、`-delete` | 正确 |
| 0.3.7 | `xargs -0`、`-I{}`、`sh -c '...' _ {}` | 除 A.9 外正确 |
| 0.3.10 | 路径解析、dentry、`openat`/`O_NOFOLLOW` | 正确 |
| 0.3.11 | `stat` 格式符、`%b/%B`、`btime`、`statx` | 正确 |
| 0.3.13 | 稀疏文件、`truncate`、`fallocate`、`du --apparent-size` | 正确（与 A.10 的表格口径不同） |
| 0.3.17 | `cp -a`、`rsync -aH`、`tar --acls --xattrs` | 正确 |
| 0.4.2 | mode 十二位、`s/S/t/T` 显示 | 正确 |
| 0.4.3 | 目录 r/w/x 三种能力、sticky 删除规则 | 正确 |
| 0.4.4 | umask 计算、`umask -S`、systemd `UMask=` 默认 0022 | 正确 |
| 0.4.14 | setuid 脚本被忽略、`nosuid`、`no_new_privs`、`AT_SECURE` | 正确（除 A.14 的 chown 一行） |
| 0.4.15 | ACL mask、默认 ACL、`setfacl -b/-k`、umask 参与 | 正确 |
| 0.4.16 | capability 五集合、`+ep`、`AmbientCapabilities`、bounding | 正确 |
| 0.4.17/18 | passwd/shadow/group 字段、`chage`、`passwd -S`、`usermod -aG` | 正确 |
| 0.5.2 | 重定向求值顺序、`2>&1 >file`、`&>`、`noclobber` | 正确 |
| 0.5.3 | here-doc 引号、`<<-` 只去 tab、here-string 补换行、进程替换 | 正确 |
| 0.5.4 | 管道退出码、`PIPESTATUS`、`SIGPIPE`、64KiB 缓冲 | 除 A.1 的示例外正确 |
| 0.5.5 | 管道子 shell、`lastpipe` | 正确 |
| 0.6.10 | `grep` 选项表、退出码 0/1/2、`-r/-R` 符号链接 | 正确 |
| 0.6.11 | sed 模式空间/D 循环/地址 | 正确 |
| 0.6.13 | awk FS/OFS/RS、`-v` 求值时机、`NF` 重建 `$0` | 正确 |
| 0.7.8 | 退出码 126/127/128+n、`set -e` 例外、`local x=$(false)` | 正确 |
| 0.7.9 | 展开顺序、`IFS`、`nullglob/failglob/dotglob` | 正确 |
| 0.7.10 | 参数展开全表 | 正确 |
| 0.8.3 | `trap` 骨架、信号转发、`wait` 被打断 | 除 A.4 外正确 |
| 0.8.4 | `mktemp`、`flock`、`wait -n -p`、`{fd}>`、锁文件不可删 | 正确 |
| 0.8.6 | `tar` 退出码 1 的含义、原子 `mv`、`flock` 与 NFS | 正确 |
| 0.9.1 | `ps` 五列、`STAT` 字母、`%CPU` 生命周期平均 | 正确 |
| 0.9.2 | 进程组/会话/控制终端、`$$` 与 `$BASHPID` | 正确 |
| 0.9.3 | `D` 状态、load average 含不可中断睡眠、僵尸回收 | 正确 |
| 0.9.5 | 信号编号/默认动作、`kill -0`、143/137/130、`timeout -k` | 正确 |
| 0.9.8 | nice 权重表、`chrt -f/-r`、autogroup、`/proc/PID/sched` | 除 A.12/A.15 外正确 |
| 0.9.9 | `ps` 字段、`top` 头部五行、`top -b` 首帧 | 正确 |
| 0.9.9.1 | cgroup v2 文件、`cpu.max`/`cpu.weight`、`cgroup.kill` 5.14+ | 正确 |
| 0.10.1 | `lsblk`/`findmnt`/`df` 视角、`Use%` 与预留块 | 正确 |
| 0.10.3 | `df`/`du` 口径、`lsof +L1`、`truncate` fd | 除 A.10 外正确 |
| 0.10.5 | fstab 六字段、`nofail`、`x-systemd.device-timeout` | 正确 |
| 0.10.6 | LVM 扩容顺序、`lvextend -r`、4MiB extent | 正确 |
| 0.10.7 | RAID 级别容量/容错、`mdadm` 故障替换、`[3/2] [UU_]` | 正确 |
| 0.10.8 | swap 文件、`fstrim.timer`、`discard` 取舍、SMART 思路 | 正确（属性名见 A.21.2） |
| 0.10.8.1 | ext4/XFS quota、`setquota` 单位、project quota | 正确（`setquota` 支持 K/M/G 后缀，已核 man） |
| 0.10.9 | MBR/GPT 限制、`sgdisk -n`、`parted align-check`、4Kn | 正确 |
| 0.10.10 | `mkfs.ext4`/`mkfs.xfs` 参数、stride/stripe_width、`maxpct` | 正确（除 A.19 的「不会用尽」） |
| 0.10.11 | e2fsck 五阶段/位掩码退出码、备份超级块、`xfs_repair -n/-L` | 正确 |
| 0.11.1 | `.deb` 结构、`dpkg -S/-L/-l`、`ii` 状态 | 正确 |
| 0.11.2 | deb822 源、`apt update/upgrade/full-upgrade` | 除 A.6 外正确 |
| 0.11.4 | soname、`-fPIC`、RUNPATH/RPATH、search order | 正确 |
| 0.11.8 | dpkg 状态机、维护者脚本四时机、conffile | 正确 |
| 0.11.13 | `pkg-config`/`ldd`/`readelf` 对账、`ldd` 不可信二进制 | 正确 |
| 0.12.3 | service/timer unit、`Persistent`、`AccuracySec`、oneshot/restart | 正确 |
| 0.12.4 | journalctl 组合、优先级 0–7、vacuum | 正确 |
| 0.12.10 | journald 字段、`_` 可信字段、持久化、限额 | 除 A.13 外正确 |
| 0.12.11 | cron 的 PATH/`%`/用户字段、timer 语义差异 | 正确（`at` 见 B.4） |
| 0.12.15 | `systemd-analyze blame/critical-chain/verify/calendar`、`cat` vs `show` | 正确 |
| 0.13.3 | `ss` 列、LISTEN `Recv-Q/Send-Q`、`ss -s` | 正确 |
| 0.13.9 | 路由表/`ip rule`/`ip route get`/netns/veth | 正确 |
| 0.13.11 | TCP 状态机、TIME-WAIT 60s、`tcp_tw_recycle` 4.12 移除、`ss -K` | 正确（除 A.8 的 retrans 解释） |
| 0.13.12 | nftables 表/链/hook 优先级、`inet`、命名集合、NAT、`nft -c -f` | 正确（除 A.16 的 mark 顺序） |
| 0.13.13 | tcpdump `-i any`/`-nn`/`-s0`/`-C/-W/-G`、BPF 原语 | 正确 |
| 0.13.14 | SSH 主机密钥、`ssh-keygen -F/-R`、`ProxyJump`、三种转发 | 正确（文件传输见 B.3） |
| 0.14.1 | USE 矩阵、load average、`%util`/`aqu-sz` | 正确 |
| 0.14.3 | `free` 的 `available`、`/proc/meminfo` 字段 | 正确 |
| 0.14.4 | `iostat` 首帧、`await`、`aqu-sz`、`iotop -oPa` | 除 A.18 外正确 |
| 0.14.10 | PSI `some/full`、`total` 微秒、cgroup v2 文件 | 正确 |
| 0.14.11 | RSS/PSS/USS、`smaps_rollup` 4.14+、THP | 除 A.11 外正确 |
| 0.14.12 | `%util` 基于 `io_ticks`、Little's law、I/O 调度器 | 正确 |
| 0.14.13 | `lsof` FD 列、`+L1`、`+D`、fd 截断、`umount -l` | 正确 |
| 0.14.17 | `vmstat` 字段、首行均值、`pidstat %CPU`、perf 多路复用 | 除 A.20 的表述外正确 |

### C.3 跨章一致性核对

| 主题 | 一致 | 冲突 |
|:--|:--|:--|
| `disown -h` 语义 | `ch09.md:153` | **`ch02.md:274`（错，A.5）** |
| `ss -ti` 的 `retrans` | `ch13.md:615` | **`ch14.md:219`（错，A.8）** |
| OOM 的 systemd 结果 | `ch14.md:449` 提到 `journalctl` 的 `oom-kill` | **`ch12.md:196` / `ch14.md:449` 的 `Result=resources`（错，A.7）** |
| `pipefail` 与管道退出码 | `ch07.md:885`、`ch08.md:249` 表述谨慎 | **`ch05.md:213` 的 `status=141`（错，A.1）** |
| XFS inode 上限 | `ch10.md:607` 的 `maxpct` 25% | **`ch10.md:83`「不会用尽」（错，A.19）** |
| `ls -s` 与 `st_blocks` | `ch03.md:528` 的 `%b` 512B 正确 | **`ch03.md:516` 把 `ls -s` 也写成 512B（错，A.17）** |

---

*本报告只写核查结论，不修改 `src/part0/` 正文。*

---

## 修复记录（2026-10-24）

> 处置口径：报告行号基于旧快照，均按「原文（摘）」重新 grep 定位。当前工作区在本次会话前已有一批改进，多数条目已被先行修复，本会话只修仍残留者；改动仅限 `src/part0/`，均为原行内替换，未新增 H2、未改锚点/编号/表格结构。

| # | 处置 | 说明 |
|--:|:--|:--|
| A.1 | 此前已修复（＋本次清残留） | ch05 `yes \| head` 终端示例已改为「未开 `pipefail` 时 `status=0`，141 只在 `PIPESTATUS`」；本次另修同章 0.5.4 末尾残留的同型错误：代码块注释 `# status=141` 改为演示 `status=0 yes=${PIPESTATUS[0]}`，并给前导段补了一句「141 只出现在 `PIPESTATUS` 里」。 |
| A.2 | 此前已修复（＋本次清残留） | ch09:85 已写明「作业表仍在，`jobs`/`kill %1` 可用」；本次另修同章 0.9.13 边界表第 3 行残留：「非交互 shell 默认无作业控制」改为「作业已退出被收走，或 `%1` 是父 Shell 的作业（作业表不跨进程继承）」。 |
| A.3 | 此前已修复 | ch09 已写明 `ulimit` 不带 `-S`/`-H` 时同时设置软硬限制。 |
| A.4 | **本次修复** | ch08 §0.8.2 定义段与 §0.8.10 trap 表的 `EXIT` 行均删去「未捕获的致命信号触发」；改为「只在正常退出（脚本末尾、`exit N`）时触发；未捕获的 `SIGTERM`/`SIGINT` 直接终止、不执行 `EXIT` 处理器，要清理须显式注册信号处理器」。 |
| A.5 | 此前已修复 | ch02:274 与 ch09 的 `disown -h` 语义已一致（只标记不发 HUP，不移出作业表）。 |
| A.6 | 此前已修复 | ch11:107、ch11:463 均已按「990 只在 target release 下出现；Ubuntu 24.04 默认全为 500」表述。 |
| A.7 | 此前已修复 | ch12:196、ch14:449 均已写 `Result=oom-kill`，并注明 `resources` 不是 OOM 结果。 |
| A.8 | 此前已修复 | ch14:219 已写「累计重传 120 次（不是发送段数）」，与 ch13 一致。 |
| A.9 | **本次修复** | ch03 §0.3.7 末段改为确定约定：任一子命令 1–125 → 123、255 → 124、被信号杀 → 125、找不到命令 → 127，并指向 0.3.15 的全表。 |
| A.10 | **本次修复** | ch10 §0.10.3 表第 4 行改为「`du` 比 `df` 大 ← 用 `--apparent-size` 统计了稀疏文件」，并注明默认口径下 `du` 只会偏小、硬链接/快照通常让 `du` 偏小。 |
| A.11 | 此前已修复 | ch14:819 已写 `Pss_Anon + Pss_File + Pss_Shmem` 三项之和。 |
| A.12 | 此前已修复 | ch09 调度类表与示例均已改为 `chrt -b`（并注明 `-o` 是 SCHED_OTHER）。 |
| A.13 | 此前已修复 | ch12:581 已写「30s / 10000 条（systemd 默认）」。 |
| A.14 | 此前已修复 | ch04:624、ch04:665 均已写「Linux 2.2.13 起 root 的 chown 也同样清除」。 |
| A.15 | 此前已修复 | ch09:471 已写明 `starttime` 是时钟滴答、`/proc/uptime` 直接是秒。 |
| A.16 | 此前已修复 | ch13:416 规则已改为匹配在前（`ip daddr ... meta mark set 0x1`）。 |
| A.17 | **本次修复** | ch03 §0.3.11 表「块数」行的易错点改为：`st_blocks` 单位 512 字节，`ls -s` 默认按 1 KiB 块显示。 |
| A.18 | 此前已修复 | ch14:844 已写明 `-p` 是「包含分区」开关、设备名是位置参数。 |
| A.19 | 此前已修复 | ch10:83 已写「XFS 动态分配但仍受 `imaxpct`/`maxpct` 限制，极端小文件场景仍可能 inode 用尽」。 |
| A.20 | 此前已修复 | ch14:925 已写「四线程各占 25% 会显示 100%，正好等于一个核」。 |
| A.21.1 | **本次修复**（判定为错） | Ubuntu 默认 sudoers 的 `secure_path` 覆盖 `PATH` 且 `sudo -E` 绕不开它，原建议无效。ch02:156 改为「可靠做法是用绝对路径，或把目录加进 sudoers 的 `secure_path`（有风险）」。 |
| A.21.2 | 不修（非错误） | `Current_Pending_Sector`、`Media_Wearout_Indicator` 是全名，但原缩写作为 grep 子串仍能命中（`grep Pending_Sector`、`grep Media_Wearout`），按报告自述「缩写不致错」，维持原文。 |
| A.21.3 | **本次修复**（判定为错） | `su user`（不带 `-`）是非登录**交互** Shell，仍读 `~/.bashrc`，别名通常还在。ch02:155 改为「多半是误解」，并保留「只有别名只写在 `/etc/profile` 等登录文件里才会丢」的边界。 |
| A.21.4 | **本次修复**（判定为需澄清） | 原表述易被读成「Linux 没有 btime」。ch03:129 与 errata 第 4 条均改为：创建时间要经 `statx` 的 `btime`（`stat %w`）读，ext4/XFS/Btrfs 可用、并非所有文件系统都有——保留「跨文件系统不通用」的原意，消除歧义。 |

- **本次修复**：A 表 4 条（A.4、A.9、A.10、A.17）＋ A.1/A.2 的同章残留 2 处；A.21 修 3 条（A.21.1、A.21.3、A.21.4）、不修 1 条（A.21.2）。此前已修复：A 表 16 条。
- **B 类漏节 15 条（B.1–B.15）未补写**，仅确认计数，留待主线程处理。
- **报告未覆盖的新发现（只报告，未修改）**：
  - `ch12.md:769`（0.12.6 实验）：「`Result=exit-code` 或 `resources`」——203/EXEC 时 systemd 的 Result 是 `exit-code`（`SERVICE_FAILURE_EXIT_CODE`），不会是 `resources`；「或 resources」的兜底易误导。
  - `ch10.md:146`（0.10.4）：「XFS 没有这个问题，它的 inode 是动态分配的」——严格说仍受 `maxpct` 约束（与 A.19 同型、程度轻；该句上下文指 ext4 固定 inode 数的问题，尚可辩护，建议后续措辞收紧）。
- **验证**：改动的 bash 块（ch05 `bash -c 'yes | head … PIPESTATUS[0]'`）过 `bash -n`；`python3 tools/check_book.py` 修复前后输出一致（`pages: 113  total lines: 127031  substantial: 103`，exit 0），无新增问题页/断链/断锚点/重复锚点。
