# 2.9 进程凭证、用户、组与能力 · 本章导航

::: preview 这一章在讲什么
[2.8](ch08.md) 说 exec 保留凭证，但没回答「换完程序之后，这个进程是谁」。内核做权限检查时不看程序名，只看进程凭证（credentials，进程随身携带的一组 UID/GID 与能力位）里的整数。这一章讲清四个 UID 各管什么、setuid 程序怎样提权再安全降权、capability 怎样把 root 拆成小份。主线一句话：**权限是凭证的函数，不是用户名的函数。**
:::

## 本章回答什么

- **同一个进程为什么有多个 UID**：真实、有效、保存、文件系统 UID 各决定什么，`/proc/self/status` 的四列怎么读（2.9.1）。
- **用户名怎样变成数字**：`/etc/passwd`、`/etc/shadow`、`/etc/group` 的字段，`getpwnam`/`getgrnam` 与 NSS 查询链（2.9.2、2.9.9）。
- **setuid 程序在 exec 那一刻发生了什么**：真实 UID 不变，有效与保存 UID 变成文件属主（2.9.3）。
- **提权之后怎样安全降权**：`setuid` 家族的切换规则、「附加组 → GID → UID → 验证」的纪律（2.9.4、2.9.5、2.9.8）。
- **capability 怎样把 root 拆成位**：五组集合、file capability、`no_new_privs` 与 seccomp 初识（2.9.6、2.9.10、2.9.11）。
- **内核把身份存在哪里**：`struct cred` 的复制—提交路径，`capable()` 与 `ns_capable()` 的区别（2.9.7）。

## 读完你会

- 读懂 `/proc/self/status` 的 `Uid:`/`Gid:` 四列与 `CapInh`/`CapPrm`/`CapEff`/`CapBnd`/`CapAmb` 五行，用 `capsh --decode` 把位图翻成名字。
- 说出 `setuid`/`seteuid`/`setreuid`/`setresuid` 对非特权进程各允许什么，解释 `setresuid(u,u,u)` 之后为什么回不去。
- 写出 setuid-root 程序的降权顺序，并解释先降 UID 为什么会丢掉 `CAP_SETGID`、让后面的 `setgroups` 失败。
- 用 `getcap`/`setcap` 观察与授予单一能力，说出 `+ep` 与 `+p` 的差别、bounding 集合为什么只能减。
- 解释 setuid 脚本为什么无效、`LD_PRELOAD` 为什么在 setuid 执行时被剥离、`no_new_privs` 为什么不可逆。

## 先修与预计学时

- 进程与 exec：[2.7 进程创建与终止](ch07.md)（fork 继承凭证）、[2.8 程序执行与子进程监控](ch08.md)（exec 保留清单里的 UID/GID 与 `system` 的注入面）。
- 文件权限：[0.4 权限与安全模型](../part0/ch04.md)（rwx 位、setuid 位、ACL 的命令行视角——本章接着讲内核侧）。
- 阅读：约 100 分钟（14 节，正文有 6 个可编译程序）。动手实验：约 50 分钟（C 组前 6 题全部免 `sudo`）。章末习题：约 60 分钟。

## 本章路线：四个单元，一条主线

| 单元 | 小节 | 这一单元回答什么 |
|:--|:--|:--|
| **一、身份与数据库** | [2.9.1](ch09.md#sec-2.9.1)–[2.9.2](ch09.md#sec-2.9.2) | 四个 UID 各管什么？用户名怎样映射到数字 ID？ |
| **二、提权与降权** | [2.9.3](ch09.md#sec-2.9.3)–[2.9.5](ch09.md#sec-2.9.5) | setuid exec 那一刻变什么？怎样降权才回不去？ |
| **三、把 root 拆成位** | [2.9.6](ch09.md#sec-2.9.6)–[2.9.7](ch09.md#sec-2.9.7) | capability 五组集合怎么运作？内核把身份存在哪里？ |
| **四、完整规则与收口** | [2.9.8](ch09.md#sec-2.9.8)–[2.9.14](ch09.md#sec-2.9.14) | 规则矩阵、NSS、攻击面与十四个陷阱 |

一句话主线：**先认清四个 UID 各管一摊，再看 setuid 程序怎样临时提权、按纪律降权，最后看 capability 把 root 拆成可单独授予的位，`no_new_privs` 把「不再提权」变成不可逆的承诺。**

## 小节一览

| 小节 | 标题 | 一句话 | 本机（免 `sudo`）能做到什么 |
|:--|:--|:--|:--|
| [2.9.1](ch09.md#sec-2.9.1) | UID 与 GID 的四件套 | real/effective/saved/fs 各管一摊 | 全部可做（`/proc/self/status`、`id`） |
| [2.9.2](ch09.md#sec-2.9.2) | 用户数据库三文件 | 字段顺序与查询接口 | 读侧可做（`getent`、`stat`）；`useradd` 需 root |
| [2.9.3](ch09.md#sec-2.9.3) | setuid 程序：exec 那一刻 | ruid 不变、euid/suid 变属主 | 观察可做（`stat` 看 s 位、`show_creds`）；制造 setuid-root 需 root |
| [2.9.4](ch09.md#sec-2.9.4) | setuid 家族的规则 | 非特权只能在 r/e/s 之间切换 | 非特权路径可做（`cred_rules`） |
| [2.9.5](ch09.md#sec-2.9.5) | setuid 程序的编写纪律 | 组 → GID → UID → 验证 | 骨架可编译；完整降权验证需 root |
| [2.9.6](ch09.md#sec-2.9.6) | capability：把 root 拆成位 | 五组集合与 `setcap` | 读侧可做（`getcap`、`capsh --print`）；`setcap` 需 root |
| [2.9.7](ch09.md#sec-2.9.7) | `struct cred` 与提交路径 | 凭证不可变、复制后原子提交 | `/proc` 投影可读；内核路径按源码读 |
| [2.9.8](ch09.md#sec-2.9.8) | 完整规则矩阵 | 每个调用改哪些、何时 EPERM | 非特权列可做；`setreuid` 副作用与 AT_SECURE 需 root |
| [2.9.9](ch09.md#sec-2.9.9) | NSS 与 `_r` 函数 | 三态返回与 ERANGE 重试 | 全部可做（`nss_lookup`、`getent`） |
| [2.9.10](ch09.md#sec-2.9.10) | 五组集合、`capset` 与 ambient | exec 变换公式与 xattr | 读侧可做（`file_caps` 解码 ping）；`capset`/ambient 提升需 root |
| [2.9.11](ch09.md#sec-2.9.11) | 攻击面与加固清单 | 输入与环境都不可信 | 清单可对照；完整 setuid 场景需 root |
| [2.9.12](ch09.md#sec-2.9.12) | 两个观测实验 | xattr 与用户命名空间 | 实验一读侧可做；`setcap` 需 root；实验二被 AppArmor 挡（未实测） |
| [2.9.13](ch09.md#sec-2.9.13) | 十四个陷阱 | 现象 → 原因 → 修复 | 多数可免特权复现或推理 |
| [2.9.14](ch09.md#sec-2.9.14) | 本章小结 | 三条判据 + 5 问章级自测 | 达标线展开在[自检表](ch09-checklist.md) |

## 怎么读

- **第一次读**：2.9.1–2.9.2 先跑 `grep -E '^(Uid|Gid|Cap)' /proc/self/status` 和 `id`，亲眼看到四列与五个位图再读定义；然后读 2.9.3–2.9.5，把「提权—降权」当成一条完整路径走一遍。
- **只想排障**：权限被拒先看 [2.9.1](ch09.md#sec-2.9.1) 与 [2.9.13](ch09.md#sec-2.9.13)；setuid 行为异常看 [2.9.8](ch09.md#sec-2.9.8) 的规则矩阵；`setcap` 后仍无权限看 [2.9.6](ch09.md#sec-2.9.6) 与 [2.9.10](ch09.md#sec-2.9.10)。
- **准备面试或课程考试**：四处必答——四个 UID 的分工（2.9.1）、非特权进程的切换规则（2.9.4）、降权顺序与不可逆条件（2.9.5）、capability 五集合与 bounding 只能减（2.9.6）。先做[习题集](ch09-exercises.md) A 组。
- **写服务、沙箱或容器运行时**：必读 [2.9.5](ch09.md#sec-2.9.5)（降权纪律）、[2.9.10](ch09.md#sec-2.9.10)（exec 变换公式）、[2.9.11](ch09.md#sec-2.9.11)（攻击面）。
- **怕数字搬家**：能力位数、aarch64 调用号、`/tmp` 挂载选项、用户命名空间可用性都随机器变。逐条列在[勘误与版本注记](ch09-errata.md)，引用任何数字前先读那一页。

## 环境口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上，cgroup v2。man-pages 6.7。
- **`sudo` 需要密码，不可用**。`setcap` 给文件加能力、`chown` 改属主、`useradd`、改 `/etc/passwd`、完整的 setuid-root 降权验证，一律标「需 root，本机未实测」并给命令与预期判据。
- **免特权可真跑**：`id`、`getent`、`/proc/self/status` 的 Uid/Gid 与五个 Cap 集合、`capsh --print`（读自己）、`getcap` 读文件能力、`prctl(PR_GET_NO_NEW_PRIVS)` 读回、写 C 程序打印 `getuid`/`geteuid`/`getresuid`。本章 C 组前 6 题都在这条边界内真跑过。
- **本机现成的观察对象**（实测）：`/usr/bin/passwd`、`/usr/bin/su`、`/usr/bin/mount` 是 `4755 root:root`；`/usr/bin/ping` 是 `0755` 但带 `cap_net_raw=ep`——两种特权来源各看一个。
- **`/tmp` 没有 `nosuid`**（实测 `findmnt -T /tmp`：与 `/` 同在 ext4，选项只有 `rw,relatime`）。「`/tmp` 必然 nosuid」是发行版相关说法，别当通则。
- **用户命名空间被 AppArmor 挡住**：`apparmor_restrict_unprivileged_userns=1`（实测），`unshare -Ur` 写 `uid_map` 报 `Operation not permitted`。2.9.12 实验二按「未实测」读。
- **`getfattr` 未安装**；读 `security.capability` 扩展属性用正文的 `file_caps.c`（`getxattr`），免特权可跑。
- **架构提醒**：aarch64 的调用号是 `setuid`=146、`setresuid`=147、`getresuid`=148、`capget`=90、`capset`=91、`prctl`=167（实测 grep `/usr/include/asm-generic/unistd.h`），别抄 x86 表格。

## 路线标签与项目回链

- **应用/运维：必读** [2.9.1](ch09.md#sec-2.9.1)、[2.9.2](ch09.md#sec-2.9.2)、[2.9.13](ch09.md#sec-2.9.13)。权限被拒、账号查询、setuid 失效的排障都在这几节；**可后补** [2.9.7](ch09.md#sec-2.9.7)。
- **系统编程：必读** [2.9.3](ch09.md#sec-2.9.3)、[2.9.4](ch09.md#sec-2.9.4)、[2.9.5](ch09.md#sec-2.9.5)、[2.9.8](ch09.md#sec-2.9.8)。写任何要提权或降权的程序前先过这几节；**可后补** [2.9.12](ch09.md#sec-2.9.12)。
- **内核/性能：必读** [2.9.6](ch09.md#sec-2.9.6)、[2.9.7](ch09.md#sec-2.9.7)、[2.9.10](ch09.md#sec-2.9.10)。`struct cred` 的提交路径与 capability 变换公式是第 3 篇安全章的地基；**可后补** [2.9.11](ch09.md#sec-2.9.11)。
- **项目回链**：[项目 A](../projects/pa.md) 的 Stage 7（`capset` + `no_new_privs` + seccomp）直接以本章为前置——「容器里 uid=0 却 mount 失败」的判据在 [2.9.6](ch09.md#sec-2.9.6) 与 [2.9.7](ch09.md#sec-2.9.7)，「exec 后不再提权」的判据在 [2.9.11](ch09.md#sec-2.9.11)。

## 章末件

[章末总结](ch09-summary.md) · [闭卷回忆卡](ch09-recall.md) · [习题集](ch09-exercises.md) · [学习目标自检表](ch09-checklist.md) · [勘误与版本注记](ch09-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 8 章「用户和组」（PDF p153–164：passwd/shadow/group 字段、getpwnam/getgrnam、crypt）、第 9 章「进程凭证」（p165–179：四件套、setuid 家族、表 9-1 规则总结） | 2.9.1–2.9.5、2.9.8、2.9.9；非特权切换规则与降权不可逆为重点 |
| **K** | 第 39 章「能力」（p698–714：三集合与边界集、exec 变换、securebits）、第 38 章「编写安全的特权程序」（p686–697：最小权限、避免执行 shell、不信任环境） | 2.9.6、2.9.10、2.9.11；五集合语义与攻击面清单为重点 |
| **C**（深入理解计算机系统） | 第 8 章 8.2「进程」（扫描版，按 `source-toc` 结构核对，未 OCR 页内句子与数字） | 2.9.1、2.9.3：进程抽象与用户态背景 |
| **G**（鸟哥的 Linux 私房菜） | 第 13 章 13.2「帐号管理」（p650–655 抽读：useradd 默认值、私有/公共群组机制） | 2.9.2：账号管理命令与发行版差异 |
| **Linux man-pages 6.7** | `capabilities(7)`、`setuid(2)`、`setresuid(2)`、`prctl(2)`、`ld.so(8)` | 2.9.8、2.9.10、2.9.11：ambient（4.3）、`no_new_privs`（3.5）、AT_SECURE 剥离列表等成书后新增之处 |

> K 的中文版覆盖到 Linux 3.2：ambient capability（4.3）、`no_new_privs`（3.5）、`/proc` 的 `NoNewPrivs` 字段（4.10）都在它之后，正文这些处按 man-pages 与本机 aarch64 实测写。能力位数、调用号、挂载选项换架构换机器就搬家，以[勘误页](ch09-errata.md)为准。