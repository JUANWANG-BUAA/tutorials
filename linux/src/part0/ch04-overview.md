# 0.4 权限与安全模型 · 本章导航

::: preview 这一章在讲什么
看到 `Permission denied`，很多人的第一反应是 `chmod 777`。但 Linux 的权限不是一层：DAC 的 mode、目录的 `r/w/x`、umask、ACL、capability、sudo、LSM 各自管一段。这一章先给你一条判定顺序，再分两遍走：第一遍先会用 `ls -l`、`chmod`、`chown`、ACL、capability 与 sudo；第二遍回到内核，看 mode 的位、目录与 sticky、setuid 的真实边界、ACL 的 mask 与 capability 的五个集合。学完你至少知道：该改哪一层，而不是一上来就 777。
:::

## 读完你会

- 按「DAC → ACL → capability → sudo/LSM」的顺序判定一次 `Permission denied`，知道先看哪条证据。
- 逐位读出 mode 的十二位（含 setuid/setgid/sticky），解释目录的 `r`、`w`、`x` 是三种不同能力。
- 用 `umask` 算出新文件/新目录的默认权限，知道它的三个来源与优先级。
- 用 `chmod`/`chown`/`setfacl`/`getfacl` 完成常见授权，不把 ACL 当成 mode 的同义词。
- 解释 capability 为什么能把 root 拆成小块，`ping` 为什么不再 setuid。
- 读懂 `passwd`、`shadow`、`group` 的字段，知道 `sudo` 不是沙箱。
- 用 `strace` 看到 `setresuid`、`setxattr`、`setcap` 的真实调用。
- 写一个权限审计脚本，找出 world-writable、无主、setuid 的高风险文件。

## 先修与预计学时

- 先修：读完 [0.3 文件系统导航与文件操作](ch03.md)；会 `ls -l`、`chmod`、`chown`。**不需要**学过安全理论；DAC/ACL/capability 的白话解释在本章开头。
- 阅读：约 120–150 分钟；实验与脚本：约 60 分钟；章末习题：约 60 分钟。

## 本章路线：两遍，五个单元

| 单元 | 小节 | 这一单元回答什么 |
|:--|:--|:--|
| **第一遍 · 先会用** |  |  |
| 一、先定位是哪一层 | [0.4.1](ch04.md#sec-0.4.1) | 一次 `Permission denied`，按什么顺序判断是 mode、目录、ACL、capability、sudo 还是 LSM？ |
| 二、mode、目录与 umask | [0.4.2](ch04.md#sec-0.4.2)–[0.4.5](ch04.md#sec-0.4.5) | mode 十二位各是什么？目录的 `r/w/x` 分别能做什么？`umask` 怎样影响新文件？`chmod`/`chown`/特殊位怎么用？ |
| 三、特殊授权与账号 | [0.4.6](ch04.md#sec-0.4.6)–[0.4.9](ch04.md#sec-0.4.9) | 怎样给某个人单独开权限（ACL）？怎样把 root 拆成小块（capability）？`passwd`/`shadow`/`group` 与 `sudo` 的边界是什么？ |
| **第二遍 · 看内核与边界** |  |  |
| 四、位级结构与判定路径 | [0.4.10](ch04.md#sec-0.4.10)–[0.4.19](ch04.md#sec-0.4.19) | mode 的位级结构、内核判定路径、目录/sticky、umask 三个来源、`chmod`/`chown` 全语法、setuid 的真实边界、ACL mask/默认 ACL、capability 五集合、账号字段、`sudo` 配置。 |
| **压成能力** |  |  |
| 五、实验与脚本 | [0.4.20](ch04.md#sec-0.4.20)–[0.4.22](ch04.md#sec-0.4.22) | 怎样用 `strace`/`getfacl`/`capsh` 取证？审计脚本怎样写？最容易踩的坑有哪些？ |

一句话主线：**先用判定顺序定位是哪一层（0.4.1），再学会 mode、目录、umask、`chmod`/`chown`（0.4.2–0.4.5），然后用 ACL、capability、账号与 `sudo` 处理特殊需求（0.4.6–0.4.9）。第一遍只要求会用。第二遍回到内核：mode 位级结构 → 判定路径 → 目录/sticky → umask 来源 → setuid 边界 → ACL mask → capability 集合 → 账号字段 → `sudo`（0.4.10–0.4.19）。最后用三个实验、两个脚本与陷阱清单收口（0.4.20–0.4.22）。**

## 怎么读

- **第一次读**：先读第一遍（0.4.1–0.4.9），每节做完「即时自测」；如果只想会用，到这里可以先去处理自己机器上的权限问题。
- **要排障**：先看 [0.4.1](ch04.md#sec-0.4.1) 的判定顺序，再按症状回到 [0.4.3](ch04.md#sec-0.4.3)（目录权限）、[0.4.6](ch04.md#sec-0.4.6)（ACL）、[0.4.7](ch04.md#sec-0.4.7)（capability）、[0.4.8](ch04.md#sec-0.4.8)（账号/sudo）。
- **要深入**：第二遍（0.4.10–0.4.19）配合 [0.4.20](ch04.md#sec-0.4.20) 的三个实验一起读。
- **非科班补课**：不需要先懂安全模型。先记住「mode 是 DAC 的九个权限位，目录的 `x` 是“能穿过”，ACL 是给单个人/组开小灶，capability 是把 root 的特权拆成小块」；第二遍再展开。

## 路线标签与项目回链

- 应用/运维：**必读**（整章；0.4.1、0.4.8、0.4.9、0.4.19 最常用）。
- 系统编程：**必读**（0.4.10–0.4.16；`setuid`/ACL/capability 是写特权程序的基础）。
- 内核/性能：**可后补**（0.4.10、0.4.14、0.4.16 的内核判定与 capability 集合）。
- 项目回链：项目 A1（`mycontainer`）需要 capability 与用户命名空间；D1（`mysh`）需要权限判定；B2（`mydb`）需要文件权限与 umask。

## 章末件

[章末总结](ch04-summary.md) · [闭卷回忆卡](ch04-recall.md) · [习题集](ch04-exercises.md) · [学习目标自检表](ch04-checklist.md) · [勘误与版本注记](ch04-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **Kerrisk** | 第 8–9 章（用户与组、进程凭证）、第 15 章（文件属性）、第 39 章（capability） | 0.4.1、0.4.7、0.4.8、0.4.10–0.4.19 |
| **CSAPP** | 第 9 章（虚拟内存与保护）、第 8 章（异常控制流） | 0.4.10、0.4.14 |
| 鸟哥 | 第 5 章（文件权限与目录配置）、第 13 章（账号管理与 ACL） | 0.4.2–0.4.8、0.4.17–0.4.19 |
| Shotts | 第 9 章（权限） | 0.4.2–0.4.5 |
| man-pages | `acl(5)`、`capabilities(7)`、`sudoers(5)`、`credentials(7)` | 0.4.6、0.4.7、0.4.15、0.4.16、0.4.19 |
