# 2.9 勘误与版本注记

这一页收本章最容易「换一个内核版本、换一个架构、换一台机器就不成立」的东西：capability 的数量与位图、aarch64 的系统调用号、`/tmp` 的挂载选项、用户命名空间的可用性、`ping` 的 socket 路径，以及正文示例输出与真机读数的差别。正文每节里的 errata 盒讲**理解陷阱**（把 A 当成 B）；这一页讲**搬家陷阱**（在这台机器上成立、到那台机器上悄悄变）外加**程序复跑的校正记录**。页内所有实测读数都来自下面这台机器，任何别的机器上的数字都不能引用——引用数字必须带上它属于哪台机器、哪个内核、哪个架构。

**本章基线**：Ubuntu 24.04.5 虚拟机，**aarch64（ARM64）**，内核 `7.0.0-38-generic`，GCC 13.3.0，glibc 2.39，4 vCPU，页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上，cgroup v2。`sudo` 需要密码不可用；`apparmor_restrict_unprivileged_userns=1`；`getfattr` 未安装；man-pages 6.7、strace 6.8、libcap 工具（`capsh`/`getcap`/`setcap`）已装。写作机是 macOS：没有 `/proc`，正文实验一律回 Linux 做。

## 1. 容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「setuid 程序里用 `system()`/`popen()` 没关系，glibc 会清环境」 | AT_SECURE 安全模式只剥离 `LD_PRELOAD`/`LD_LIBRARY_PATH`/`LD_AUDIT`/`GCONV_PATH` 等动态链接器变量，`PATH`/`IFS` 仍来自调用者；`system` 起的 shell 按 PATH 找命令，等于把 root 交给攻击者。必须执行外部程序就用绝对路径 `execve`，最好先永久降权 | man `ld.so(8)` 的 Secure-execution mode 段（本机 man-pages 6.7）列全剥离表；Kerrisk 第 38.3 节（PDF p690–691）「避免执行拥有权限的 shell」、38.8（p693–694）「不要信任环境列表」。setuid 现场的直接演示需 root，本机未实测 |
| 「非特权进程想设哪个 UID 都行」 | `setuid`/`seteuid` 只改有效 UID 且目标限当前 real/saved；`setresuid` 三参数各限当前 r/e/s 之一；违反即 `EPERM`。特权的标准是有 `CAP_SETUID`（man 原文 more precisely），不只是 euid==0 | man `setresuid(2)` DESCRIPTION；Kerrisk 9.7.1（p170–173）与表 9-1（p176）；本机 `cred_rules` 实测 `setresuid(0,0,0)` 报 Operation not permitted |
| 「capability 数量是固定的 40 来个」 | 数量随内核变：本机内核 7.0 的 `CapBnd=000001ffffffffff` 解码是 **41 个**（到 `cap_checkpoint_restore`=40）；perfmon、bpf、checkpoint_restore 都是 Kerrisk 成书（Linux 3.2）之后新增的位。正文写「Linux 6.8 有 41 个」，换内核要重数 | `capsh --decode=000001ffffffffff` 数名字；`/proc/self/status` 的 CapBnd；man `capabilities(7)` 各能力的 since 版本 |
| 「Kerrisk 讲了五组集合」 | Kerrisk 39.3 只讲进程三集合（许可/有效/可继承）加边界集；**ambient 是 Linux 4.3 加的**、`no_new_privs` 是 3.5 加的、`/proc` 的 `NoNewPrivs` 字段是 4.10 加的，都在成书之后。正文这些处按 man-pages 补 | man `capabilities(7)` 的 Ambient 段（since Linux 4.3）；man `prctl(2)` 的 PR_SET_NO_NEW_PRIVS 段（since Linux 3.5）；Kerrisk 39.3（p699–703） |
| 「`no_new_privs` 设了还能关」 | 不可逆：man prctl 写明 once set cannot be unset；`PR_SET_NO_NEW_PRIVS` 的 arg2 只接受 1，传 0 直接 `EINVAL`。fork/clone 继承、跨 exec 保留 | man `prctl(2)`；本机实测（习题 C5）：置 1 后读回 1、撤销 rc=-1 errno=22、exec 带 `cap_net_raw` 的 ping 报 socket: Operation not permitted |
| 「`setuid` 的系统调用号是 105」 | 那是 x86-64 的号。本机 aarch64 走 `asm-generic/unistd.h`：**`setuid`=146、`setresuid`=147、`getresuid`=148、`setresgid`=149、`getresgid`=150、`getgroups`=158、`setgroups`=159、`capget`=90、`capset`=91、`prctl`=167、`getuid`=174、`geteuid`=175** | `grep __NR_ /usr/include/asm-generic/unistd.h`（本机实测）；别抄 x86 表格 |
| 「`/tmp` 必然 nosuid，setuid 放那里一定失效」 | 发行版相关：本机 `/tmp` 与 `/` 同在 `/dev/sda2` ext4，选项只有 `rw,relatime`，**没有 nosuid**。setuid 失效要逐条核对：脚本、nosuid、属主、no_new_privs、执行位 | `findmnt -T /tmp`（本机实测）；正文 2.9.13 陷阱 1 的「常见于」是 hedge，不是通则 |
| 「`unshare -Ur` 免特权就能做用户命名空间实验」 | Ubuntu 24.04 默认 `kernel.apparmor_restrict_unprivileged_userns=1`，非特权 userns 被 AppArmor 挡：本机实测 `unshare -Ur` 报 `write failed /proc/self/uid_map: Operation not permitted`。正文 2.9.12 实验二按未实测读 | `cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns`→1；`timeout 10 unshare -Ur id` 实测失败。改这个 sysctl 需 root |
| 「`capsh --drop` 普通用户能跑」 | 改 bounding 集需要 `CAP_SETPCAP`：本机实测报 `unable to raise CAP_SETPCAP for BSET changes: Operation not permitted`。正文 2.9.6 的 `--drop` 示例与 2.9.14 自测 Q4 的命令都需 root | 本机实测 `capsh --drop=cap_net_raw -- -c true`；man `capsh(1)` |
| 「现代 `ping` 都用 DGRAM ICMP，不需要能力」 | 看 `ping_group_range`：本机实测是 `1 0`（禁用非特权 DGRAM），所以 ping 走 raw socket、靠文件上的 `cap_net_raw=ep`。正文 2.9.14 自测 A4 的「不一定失败」口径因机器而异；本机 C5 实验正是利用这条路径 | `cat /proc/sys/net/ipv4/ping_group_range`→`1 0`；`getcap /usr/bin/ping`→`cap_net_raw=ep`；习题 C5 两次运行对照 |
| 「`getfattr` 到处都有」 | 本机未安装（`command not found`）。读 `security.capability` 用正文 `file_caps.c` 的 `getxattr`，免特权可跑 | `command -v getfattr` 实测为空；`./file_caps /usr/bin/ping` 实测成功 |

## 2. 复跑校正（2026-11-09，同一台 aarch64 VM）

下表只列**在这台 7.0.0-38 aarch64 VM 上真实跑出来**的项。方法：正文 C 程序用脚本从 `ch09.md` 按代码块原样抽出（不是另写副本），统一 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2` 编译，全部零警告；新实验程序用 `lab2c9_` 前缀，自写二进制一律套 `timeout`。

| 正文原写法 | 本机实测 | 结论 |
|:--|:--|:--|
| 2.9.3 `show_creds` 普通用户输出块（附加组 `1000 27`） | 原样抽出重编重跑：Uid 四列全 1000、附加组 **9 个**（4 24 27 30 46 100 114 125 1000）、CapInh/Prm/Eff/Amb 全 0、CapBnd=`000001ffffffffff` | **已于 2026-11-09 订正正文**：普通用户块换成本机真读数（附加组 9 个）；setuid-root 块标「示意（未实测）」并说明需 root 才能复现；另补「给自己文件设 4755 不提权」与 passwd/mount 均 4755 root:root 的免特权实测 |
| 2.9.3 `show_creds` setuid-root 后输出块（`Uid: 1000 0 0 0`、CapEff 全 1） | 需 root（`chown root` + `chmod 4755`），本机未实测 | 机制结论保留；给命令与预期判据在习题 C7 |
| 2.9.5 `drop_privs` 完整降权输出 | 编译零警告；以普通用户跑实测打印「需要 setuid root（当前 euid=1000）」、退出码 1 | 守卫分支实测；完整降权路径需 root 未实测 |
| 2.9.6 `cap_drop` 的 root 路径 | 编译零警告；普通用户跑实测 `before: raw socket -> Operation not permitted`，随后 `prctl(PR_CAPBSET_DROP): Operation not permitted`、退出码 1 | 特权边界本身是读数；root 下 before ok/after EPERM 未实测 |
| 2.9.8 `cred_rules` 输出块 | 原样重跑：`setresuid(r,r,s): ok`、`setresuid(r,s,s): ok`、`setresuid(0,0,0): Operation not permitted`、end 行与 start 行一致 | 与正文一致（正文示例账号数值恰与本机相同） |
| 2.9.9 `nss_lookup` 输出块（alice、groups(3)） | 原样重跑（juanwang）：`user=juanwang uid=1000 gid=1000 home=/home/juanwang shell=/bin/bash`、`groups(9): juanwang(1000) adm(4) cdrom(24) sudo(27) dip(30) plugdev(46) users(100) lpadmin(114) docker(125)`；查不存在用户打印 `no such user`、退出码 0 | **已于 2026-11-09 订正正文**：输出块换成 juanwang 真读数（groups 9 个），并补 cap=16 时三次 `rc=34`（16→32→64→128）的 ERANGE 重试实测；NSS 链正文已写全 `files systemd sss` |
| 2.9.10 `file_caps` 预期输出（setcap 后的 python3.12） | 对系统现成的 `/usr/bin/ping` 原样重跑：`magic=0x02000001 revision=2 effective_flag=1`、`permitted : CAP_NET_RAW(13)`、`inheritable: (empty)`、`mode=0755`；对 passwd 报 `no file capability` | 解码逻辑免特权验证通过；**正文已于 2026-11-09 改为以 `/usr/bin/ping` 为主实测**（revision=2、permitted 仅 CAP_NET_RAW(13)、setuid=0），`setcap` 自造示例保留并标「需 root 未实测」 |
| 2.9.12 实验一（setcap 副本 + getfattr） | `setcap` 需 root 未实测；`getcap /usr/bin/ping` 实测 `cap_net_raw=ep`；`getfattr` 未装 | 读侧实测、写侧未实测；xattr 读法改用 `file_caps.c` |
| 2.9.12 实验二（unshare -Ur） | 实测 `unshare: write failed /proc/self/uid_map: Operation not permitted`；`apparmor_restrict_unprivileged_userns`=1 | **正文已于 2026-11-09 重写为「失败本身就是读数」**：失败原文 + `unshare -U` 成功对照 + 四个 sysctl 读数（unprivileged_userns_clone=1、max_user_namespaces=43361、apparmor_restrict_unprivileged_userns=1、AppArmor enabled=Y）+ newuidmap 未装；跑通后的形状明确标「预期、未实测」 |
| 2.9.6 跑着的 ping 的 CapEff（2026-11-09 新测） | 裸跑 `ping -c 2 127.0.0.1` 成功（0% 丢包），但运行中 `/proc/<pid>/status` 的 CapEff/Prm 十次采样全 0；strace 抓到 ping 自己 `capset({effective=0,permitted=0,inheritable=0})`；本机 `ping_group_range=1 0`（空区间）故必须走 SOCK_RAW；strace 下 socket 反而 EACCES/EPERM | 结论：文件能力在 exec 时确实授予，ping 开好套接字后主动清空（最小特权窗口）；strace 下失败是 ptrace 安全规则阻止 exec 授予文件能力（观察者效应）。已写进正文例 2.9.2 |
| 习题 C5 `lab2c9_nnp` | 默认模式：nnp=0、ping 通（file cap 授予 CAP_NET_RAW）；set 模式：nnp=1、撤销 errno=22、ping 报 `socket: Operation not permitted` 与 `missing cap_net_raw+p capability or setuid?`、退出码 2 | 三条结论（免特权可设、不可逆、挡 file cap）一次实测 |

**习题程序初稿的一个 bug（写入书里前已修复并复跑）**：`lab2c9_nnp.c` 初稿在 `execv` 前没有 `fflush(NULL)`，stdout 接 ssh 管道时是全缓冲，`before`/`after set`/`unset try` 三行 printf 随旧地址空间一起丢失——第一次复跑只看到 ping 的输出。补上 `fflush(NULL)` 后重编重跑，两模式输出才完整。书里印的是修后版本。这与 2.8 章「exec 前冲刷 stdio」是同一条教训：**程序输出消失时先怀疑缓冲，再怀疑机制。**

## 3. 本章未实测项

下面这些在这台 VM 上拿不到证据，引用时一律当**待验证的机制结论**，不要抄成读数：

- **一切要 root 的动作**：`setcap` 授予/删除文件能力、`chown` 改属主、`chmod 4755` 制造 setuid-root、`useradd`/`usermod`/`passwd` 改账号、改 `/etc/passwd`/`/etc/shadow`、`capsh --drop`（改 bounding）、`drop_privs` 与 `cap_drop` 的完整特权路径、`show_creds` 的 setuid-root 运行。`sudo` 需要密码，全部按「机制结论 + 未实测」；正文与习题 C7 给了命令和预期判据。
- **AT_SECURE 下 `LD_*` 被剥离的直接观察**：需要一个 setuid-root 二进制配合 `LD_PRELOAD` 做对照，制造它需 root。剥离列表本身来自本机 man `ld.so(8)`（文档级依据）；「非 root 执行授予能力的文件」这条路径已由 C5 的 ping 实测间接覆盖。
- **用户命名空间与 `uid_map`**：`unshare -Ur` 被 AppArmor 挡（实测），容器环境本机也没有；2.9.7 的 `ns_capable`、2.9.9 的 uid_map、2.9.12 实验二都按机制读。
- **seccomp 过滤器的安装与 `EACCES`**：本章只初识（2.9.6 note、2.9.11）；「无 `CAP_SYS_ADMIN` 且未置 no_new_privs 时装过滤器报 EACCES」来自 man `prctl(2)`/`seccomp(2)`，本机未构造过滤器实验，第 5 篇展开。
- **NFS 服务器的 `setfsuid` 场景**：历史动机按 Kerrisk 9.5（p168–169）读；本机没有 NFS 服务现场。
- **CSAPP 第 8.2 节的具体页内表述**：中文第 3 版是纯扫描版、本机 tesseract 无 `chi_sim`，**未 OCR**；本章对 CSAPP 只按 `source-toc/clean-csapp.md` 的结构（8.2 进程，p544）核对，不引用其具体句子或页内数字。
- **`initgroups` 在 LDAP/SSSD 后端的网络超时**：本机 NSS 链虽配了 `sss`，但没有可用的目录服务；2.9.9 的「容器里卡住」按机制读。

## 4. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/内核/架构/工具版本 → 建议改法**」四段写，缺第四段就没有可比较的基准：

1. **现象**：一句话说清谁看起来坏了。例：「`capsh --drop` 在普通用户下报 unable to raise CAP_SETPCAP」。
2. **命令与输出**：贴**原样敲的命令**与**未经删减的输出**（含 errno 数字与退出码）。
3. **机器口径**：至少附 `uname -a`、`ldd --version | head -1`、`gcc --version | head -1`、`cat /proc/sys/kernel/apparmor_restrict_unprivileged_userns`、`cat /proc/sys/net/ipv4/ping_group_range`；涉及调用号的附架构与 `/usr/include/asm-generic/unistd.h` 对应行。
4. **建议改法**：写「该改成什么动作」。例：「正文 2.9.6 的 `capsh --drop` 示例应标注需 root，免特权替代是习题 C5 的 no_new_privs 路径」。

归类再说话：**规范条款**（非特权目标限 r/e/s、no_new_privs 不可逆是 man 明文）、**本机读数**（UID 1000、41 位、调用号 146/147/90/91/167、ping_group_range=`1 0`）、**随内核/架构/发行版变的量**（能力数量、调用号、nosuid、AppArmor userns 策略、ping 的 socket 路径）、**未实测**（写清为什么没测）。本章最常见的分歧有三种：把 x86 的调用号当本机结论、把演示账号的输出块当可复现读数、把「/tmp 必 nosuid」「unshare 必可用」这类发行版相关说法当内核通则。