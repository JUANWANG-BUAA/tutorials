# 2.6 目录、链接与文件事件 · 本章导航

::: preview 这一章在讲什么
[2.5](ch05.md) 看完了 inode 本身，但**inode 没有名字**——名字在目录里。目录把「名字 → inode 号」的映射存成目录项（dentry）：硬链接是同一个 inode 的第二个名字，符号链接是内容为路径字符串的独立 inode。这一章回答三个问题：名字怎么组织（目录读取、硬/软链接、`rename`）、名字怎么安全地用（目录 fd 与 `*at` 家族、`renameat2`、链接保护）、名字的变化怎么订阅（`inotify`——把「文件变了」变成「fd 可读」）。主线一句话：**名字与内容是两层**——`rm` 删的是名字、`mv` 改的是名字、`inotify` 订阅的是名字的变化，而 inode 与数据有自己的生命周期。
:::

## 本章回答什么

- **目录是什么**：目录在磁盘上是一串目录项，`st_size` 是项占的字节数不是内容总大小；`readdir` 的顺序为什么不定、`d_name` 为什么下次调用就失效、`d_type` 为什么可能是 `DT_UNKNOWN`（2.6.1、2.6.6）。
- **两种链接**：硬链接是多个名字指向同一 inode（`nlink` 计数），符号链接是独立 inode（内容是路径、不计入目标 `nlink`、可以悬空）；`link`/`symlink`/`readlink`/`unlink` 对符号链接各解不解引用（2.6.2）。
- **改名字**：`rename` 只动目录项不搬数据，同一文件系统内原子；`renameat2` 补了不覆盖（`RENAME_NOREPLACE`）与原子交换（`RENAME_EXCHANGE`）两种语义（2.6.3、2.6.9）。
- **遍历整棵树**：`nftw` 与 `fts` 怎么选；`FTW_PHYS`/`FTW_DEPTH`/`FTW_ACTIONRETVAL` 的意义；为什么回调里不能 `longjmp`（2.6.4、2.6.7）。
- **以目录 fd 为锚点**：`*at` 家族解决 TOCTOU 与「每线程虚拟工作目录」两个问题；`AT_FDCWD`、`O_NOFOLLOW`、`openat2` 的 `RESOLVE_BENEATH`（2.6.8）。
- **链接保护**：`fs.protected_hardlinks`/`protected_symlinks` 为什么把「能建链接」与「能跟随链接」管起来，`/tmp` 里的 `EACCES` 从哪来（2.6.10）。
- **文件事件**：`inotify` 的事件模型（fd 可读即有事）、事件会合并、队列会溢出（`IN_Q_OVERFLOW` 后全量重扫）、不递归（新建子目录自己补 watch）、`wd` 会复用（2.6.5、2.6.11、2.6.12）。
- **落到内核与取证**：`readdir` 与 inotify 在内核里的路径；`strace` 看 `getdents64`、`/proc/sys/fs/inotify` 看三道上限；十六节收进坑清单与一张出口表（2.6.13–2.6.16）。

## 读完你会

- 用 `opendir`/`readdir`/`closedir` 正确遍历目录：`errno=0` 区分 EOF 与错误、`d_name` 生命周期、`DT_UNKNOWN` 用 `fstatat` 补齐。
- 解释 `rm` 之后磁盘空间为什么没释放（`nlink` 与打开 fd 双计数）、`lsof +L1` 怎么找到持有已删除文件的进程。
- 用 `link`/`symlink` 构造两种链接，画出 inode 与目录项的关系图，说出符号链接的 `st_size` 是目标路径字符串长度。
- 说出 `rename` 的边界规则：同文件系统才原子（否则 `EXDEV`）、目标存在则覆盖、old 与 new 是同一文件时「成功且无变化」、两个参数都不解引用符号链接。
- 用 `renameat2` 的 `RENAME_NOREPLACE` 实现「原子地不覆盖别人」，用 `RENAME_EXCHANGE` 实现版本原子切换。
- 判断遍历该用 `readdir`、`scandir`、`nftw` 还是 `fts`，并说出 `nftw` 回调不能 `longjmp` 的原因。
- 把「相对路径以谁为基准」从进程 `cwd` 改成目录 fd：`openat` + `O_NOFOLLOW` + `openat2` 的 `RESOLVE_BENEATH`，写出防 TOCTOU 的文件访问。
- 写一个递归 inotify 监听：新建子目录补 watch、`IN_IGNORED` 删映射、`IN_Q_OVERFLOW` 全量重扫，缓冲区至少 `sizeof(event)+NAME_MAX+1`。
- 解释为什么 inotify 不能当消息队列用：尾部合并、队列溢出、非递归三个限制各对应什么现象。

## 先修与预计学时

- 文件与 fd：[2.2 文件 I/O](ch02.md)（`open` flags、`errno` 纪律）、[2.3 高级文件 I/O](ch03.md)（原子性概念——`rename` 是它的延续）。
- 文件属性：[2.5 文件属性](ch05.md)（`st_nlink`、`(st_dev, st_ino)`、`ctime`——本章大量引用）。
- 阅读：约 95 分钟（16 节，正文有 6 个可编译程序）。动手实验：约 45 分钟（全部免 `sudo`）。章末习题：约 55 分钟。

## 这条主线怎么走

**第一段，名字的两层结构（2.6.1–2.6.3）。** 先把目录当成特殊文件读（`readdir` 四条纪律），再放两种链接进同一张图：硬链接是目录项层面的多对一，符号链接是内容层面的路径引用。然后是改名字的调用：`rename` 的原子性与边界、`unlink` 之后 inode 与数据的双计数生命周期。这一段结束你应该能画出 `ln`/`ln -s`/`rm`/`mv` 每一步在目录项、inode、数据三层各动了什么。

**第二段，遍历与锚定（2.6.4–2.6.8）。** 从单目录上升到整棵树：`nftw` 的 flags 与回调协议、`fts` 的句柄迭代模型。然后把「相对路径的锚点」从进程 `cwd` 换成目录 fd——`*at` 家族的两个动机（TOCTOU、每线程虚拟 cwd）是后面所有安全文件操作的地基。

**第三段，改名的高级语义与防护（2.6.9–2.6.10）。** `renameat2` 的 `NOREPLACE`/`EXCHANGE` 是「原子发布」类程序的原语；`fs.protected_*` 则站在攻击者对面，解释 `/tmp` 里那些 `EACCES` 的出处。

**第四段，事件订阅（2.6.11–2.6.14）。** inotify 的完整事件语义（合并、溢出、`IN_IGNORED`、`wd` 复用）、递归监听的标准结构、内核里 watch 挂在 inode 上（所以 rename 后仍有效），最后用 `strace` 与 `/proc` 把结论变成读数。

**第五段，收口（2.6.15–2.6.16）。** 三组坑清单；出口检查表逐条打勾在[自检表](ch06-checklist.md)。

一句话主线：**名字与内容是两层——目录项存映射、inode 存属性、数据存内容；链接、rename、inotify 全部围绕「名字层」运作，读代码时先问自己这个调用动了哪一层。**

## 本章路线：五段，一条主线

| 分段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、名字的两层结构** | [2.6.1](ch06.md#sec-2.6.1)、[2.6.2](ch06.md#sec-2.6.2)、[2.6.3](ch06.md#sec-2.6.3) | 目录怎么读？硬链接与符号链接差在哪？`rename`/`unlink` 的边界在哪？ |
| **二、遍历与锚定** | [2.6.4](ch06.md#sec-2.6.4)–[2.6.8](ch06.md#sec-2.6.8) | 整棵树怎么走？为什么用目录 fd 锚定路径？ |
| **三、改名语义与防护** | [2.6.9](ch06.md#sec-2.6.9)、[2.6.10](ch06.md#sec-2.6.10) | `renameat2` 补了什么？`/tmp` 的 `EACCES` 从哪来？ |
| **四、事件订阅** | [2.6.11](ch06.md#sec-2.6.11)–[2.6.14](ch06.md#sec-2.6.14) | inotify 会丢事件吗？递归监听怎么写？内核里谁在发事件？ |
| **五、收口** | [2.6.15](ch06.md#sec-2.6.15)、[2.6.16](ch06.md#sec-2.6.16) | 哪些坑最常踩？本章出口在哪？ |

## 小节一览

| 小节 | 标题 | 一句话 | 本机（免 `sudo`）能做到什么 |
|:--|:--|:--|:--|
| [2.6.1](ch06.md#sec-2.6.1) | 目录也是文件：`dirent` 与 `readdir` | 目录是「名字 → inode 号」的表 | 全部可做，正文 `lsdir.c` 直接编译运行 |
| [2.6.2](ch06.md#sec-2.6.2) | 硬链接与符号链接 | 两种链接、三层结构 | 全部可做（`linkdemo.c`） |
| [2.6.3](ch06.md#sec-2.6.3) | `mkdir`、`rmdir`、`rename` 与 `unlink` | 改名字的调用与边界 | 全部可做；`lsof` 若未装按未实测 |
| [2.6.4](ch06.md#sec-2.6.4) | 遍历目录树：`nftw` | 前序/后序与 flags | 全部可做（`du2.c`） |
| [2.6.5](ch06.md#sec-2.6.5) | `inotify`：把文件变化变成事件 | fd 可读即有事 | 全部可做（`watchdir.c`） |
| [2.6.6](ch06.md#sec-2.6.6) | `getdents64` 与真实布局 | 变长记录与 `d_name` 覆盖 | 全部可做（`dirwalk.c`） |
| [2.6.7](ch06.md#sec-2.6.7) | `scandir`、`fts` 与 `nftw` 的选择 | 四个接口一个决策表 | 全部可做（`fts_skip.c`） |
| [2.6.8](ch06.md#sec-2.6.8) | `*at` 家族与目录 fd 编程 | 锚点从 `cwd` 换成 fd | 全部可做 |
| [2.6.9](ch06.md#sec-2.6.9) | `renameat2` 的四种语义 | `NOREPLACE` 与 `EXCHANGE` | 全部可做（`renamex.c`） |
| [2.6.10](ch06.md#sec-2.6.10) | 链接保护：`fs.protected_*` | sysctl 管住链接 | 读 sysctl 可做；改值要 root |
| [2.6.11](ch06.md#sec-2.6.11) | inotify 的完整事件语义 | 合并、溢出、`IN_IGNORED` | 全部可做 |
| [2.6.12](ch06.md#sec-2.6.12) | 递归监听与溢出恢复 | 新目录补 watch + 重扫 | 全部可做（`watchrec.c`） |
| [2.6.13](ch06.md#sec-2.6.13) | 内核路径 | VFS 到文件系统的分工 | 只读代码级结论 |
| [2.6.14](ch06.md#sec-2.6.14) | 两个实验 | `strace` 与 `/proc` | `strace` 可做（显式列调用名） |
| [2.6.15](ch06.md#sec-2.6.15) | 本章陷阱清单 | 三组坑 | 大部分可复现 |
| [2.6.16](ch06.md#sec-2.6.16) | 本章小结 | 八条达标线 | 展开在[学习目标自检表](ch06-checklist.md) |

## 怎么读

- **第一次读**：2.6.1–2.6.3 一口气读完，边读边画三层图（目录项 / inode / 数据）；然后跑 `linkdemo` 与 `watchdir` 两个程序，先见过现象再读语义。
- **只想解释一个现象**：`rm` 后空间没释放看 [2.6.3](ch06.md#sec-2.6.3)；`mv` 跨盘变慢看 [2.6.3](ch06.md#sec-2.6.3) 的 `EXDEV`；inotify 收不到子目录事件看 [2.6.11](ch06.md#sec-2.6.11)；`/tmp` 里 open 报 `EACCES` 看 [2.6.10](ch06.md#sec-2.6.10)。
- **准备面试或课程考试**：四处必答——硬链接与符号链接的本质差别（2.6.2）、`rename` 的原子性与 `EXDEV`（2.6.3）、inotify 三个限制（合并/溢出/非递归，2.6.11）、`*at` 家族解决什么（2.6.8）。先做[习题集](ch06-exercises.md) A 组。
- **写同步/部署/构建工具**：必读 [2.6.9](ch06.md#sec-2.6.9)（`RENAME_NOREPLACE` 是「原子发布」的原语）与 [2.6.12](ch06.md#sec-2.6.12)（递归监听的标准结构与溢出恢复）。
- **怕数字搬家**：inotify 三道上限、`fs.protected_*` 默认值、`d_type` 的文件系统支持面都随内核与发行版变。逐条列在[勘误与版本注记](ch06-errata.md)，引用任何数字前先读那一页。

## 环境口径

- **测试 VM**：Ubuntu 24.04.5，**aarch64（ARM64，不是 x86-64）**、内核 `7.0.0-38-generic`、GCC 13.3.0、glibc 2.39、4 vCPU、页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上，`/dev/shm` 是 tmpfs。本章实验都在 ext4 上跑过，`d_type`、inotify 行为换文件系统可能不同，引用时要带上「哪一块盘」。
- **`sudo` 不可用**。`fs.protected_*` 只能读不能改；`max_user_watches`/`max_queued_events` 只能读不能调；`bpftrace` 观测 watch 数不可做，正文 2.6.14 实验二的对应命令按「机制结论 + 未实测」读。
- **`perf` 计数器不可用**；跨进程 `ptrace` 被 `ptrace_scope=1` 挡（`strace -p <PID>` 不可用），取证一律「在 strace 下启动」。
- **工具可用性（本机 `command -v` 实测）**：`strace` 6.8 可用；`lsof`、`bpftrace` 是否在装以[勘误页](ch06-errata.md)为准；`find /proc/*/fd -lname 'anon_inode:inotify'` 统计实例数免特权可做。
- **`docker` 免 sudo 可用**。容器里 inotify 行为与宿主一致（同一个内核）；挂载卷上的事件订阅受卷的文件系统类型影响，别拿 ext4 的结论外推到 bind mount 之外。

## 路线标签与项目回链

- **应用/运维：必读** [2.6.1](ch06.md#sec-2.6.1)、[2.6.3](ch06.md#sec-2.6.3)、[2.6.5](ch06.md#sec-2.6.5)、[2.6.10](ch06.md#sec-2.6.10)。日志轮转后程序还在写旧文件、`rm` 后空间不降、配置热重载、`/tmp` 的 `EACCES` 都在这四节；**可后补** [2.6.4](ch06.md#sec-2.6.4)、[2.6.13](ch06.md#sec-2.6.13)。
- **系统编程：必读** [2.6.2](ch06.md#sec-2.6.2)、[2.6.6](ch06.md#sec-2.6.6)、[2.6.8](ch06.md#sec-2.6.8)、[2.6.9](ch06.md#sec-2.6.9)、[2.6.11](ch06.md#sec-2.6.11)、[2.6.12](ch06.md#sec-2.6.12)。`*at` 与目录 fd 是 2.9（凭证）、2.18（`epoll`）的地基；**可后补** [2.6.7](ch06.md#sec-2.6.7)。
- **内核/性能：必读** [2.6.6](ch06.md#sec-2.6.6)、[2.6.11](ch06.md#sec-2.6.11)、[2.6.13](ch06.md#sec-2.6.13)。变长记录布局、尾部合并的实现位置、watch 挂 inode 而不是路径，都在这里；**可后补** [2.6.14](ch06.md#sec-2.6.14)。
- **项目回链**：`mycontainer` 类项目里「overlayfs 上 inotify 收不到下层事件」「容器里 `renameat2` 报 `EINVAL`」「镜像构建时 `.git` 没排除」三类现象，判据分别在本章 [2.6.13](ch06.md#sec-2.6.13) 的分层表、[2.6.9](ch06.md#sec-2.6.9) 的支持面、[2.6.7](ch06.md#sec-2.6.7) 的 `fts_set(FTS_SKIP)`；「`rm` 后空间不降」的判据在 [2.6.3](ch06.md#sec-2.6.3)。

## 章末件

[章末总结](ch06-summary.md) · [闭卷回忆卡](ch06-recall.md) · [习题集](ch06-exercises.md) · [学习目标自检表](ch06-checklist.md) · [勘误与版本注记](ch06-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **K**（Linux/UNIX 系统编程手册） | 第 18 章（目录与链接：`readdir`、硬/软链接、`rename`、`nftw`、目录 fd）、第 19 章（inotify：事件、队列限制、dnotify 对比） | 2.6.1–2.6.14；表 18-1 的符号链接解释行为、`link` 不解引用、`rename` 同文件规则、inotify 权限一次性检查为重点 |
| **Linux 3.15+/5.x/6.x** | `renameat2(2)`、`fs.protected_*`、`openat2` 的 `RESOLVE_BENEATH`（母本成书后新增） | 2.6.8–2.6.10：按 man 页与本机内核 6.8/7.0 行为补充 |
| **C**（深入理解计算机系统） | 第 10 章 10.7（目录与链接） | 2.6.1、2.6.2：目录项与 inode 的对照 |
| **O**（操作系统导论） | 第 39–40 章（文件与目录、文件系统实现） | 2.6.1–2.6.3：目录实现与链接计数的背景 |
| **G**（鸟哥的 Linux 私房菜） | 第 5 章（权限）、第 6 章（文件与目录管理）、第 7 章（磁盘与文件系统） | 2.6.2、2.6.3：`ln`/`readlink`/`find` 的命令行证据 |
| **N**（深入理解 Linux 网络） | — | 未用：本章不涉及网络栈 |

> K 的中文版覆盖到 Linux 3.2：`renameat2`、`fs.protected_*`、`openat2`、`IN_EXCL_UNLINK` 都在它之后，正文这些处按 man-pages 与本机实测写；inotify 三道上限的默认值、`d_type` 的支持面换内核与文件系统就搬家，以[勘误页](ch06-errata.md)为准。
