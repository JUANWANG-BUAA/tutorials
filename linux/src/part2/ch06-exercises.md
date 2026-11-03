# 2.6 习题集

三组分层：**A 组概念判断**考「会不会说理由」；**B 组诊断推理**给现象让你判机制、判断点、给修法；**C 组动手实验**全部在这台免 `sudo` 的 Ubuntu 24.04.5 aarch64 虚拟机上真跑过，每题都写「看到什么算对」。共 18 题。每题第一个动作都是「先猜」：把预期写下再验证，猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求说出一段完整因果，B 组写成「现象 → 机制 → 读数 → 修法」四段。
2. 卡住了回对应小节的 errata/method 盒重读，不要直接看答案：A 组对应 2.6.1–2.6.3，B 组对应 2.6.3–2.6.12 与 2.6.15，C 组对应 2.6.1–2.6.14。
3. C 组命令都按本机设计：临时目录统一 `D=/tmp/lab2c06_实验名_$(date +%s)`，程序用 `lab2c06_` 前缀编译。**这台机器禁止删除操作**，实验产物留着别删，下次换新目录再跑。
4. **环境边界**：`sudo` 与 `perf` 不可用，`lsof`/`bpftrace` 未装（用 `/proc/*/fd` 替代）；`fs.protected_*` 与 inotify 上限只能读不能改。凡需要 root 的步骤一律标「本机不可做」，不要为了跑通去猜数字。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch06-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.6-A1 · 硬链接与符号链接的本质差别 {#ex-2.6-A1}

先猜：`ln a b` 与 `ln -s a b` 之后分别 `lstat` 这两个名字，`st_ino`、`st_nlink`、`st_size` 三个读数有什么不同？删掉 `a` 之后各自什么现象？

说明两种链接在目录项、inode、数据三层的结构差别；解释符号链接为什么不计入目标 `nlink`、为什么可以悬空；说出硬链接的两条限制及各自原因。

::: sol 解答

`ln a b`：两个名字的 `st_ino` **相同**（同一个 inode），`st_nlink=2`，`st_size` 都是真文件大小。`ln -s a b`：`b` 是**新 inode**（类型 `S_IFLNK`），`st_nlink=1`，`st_size` 是目标字符串的长度（本机 `linkdemo` 里指向 `link_demo.txt` 的链接 `size=10`）。删掉 `a`：硬链接 `b` 完全不受影响（`nlink` 降 1、数据还在）；符号链接 `b` 变成**悬空链接**——文件本身还在（它自己的 inode），但解引用失败 `ENOENT`。符号链接不计入目标 `nlink` 是结构决定的：它引用的是**路径字符串**而不是 inode 号，路径解析发生在使用时刻。硬链接两条限制的原因：① 必须同文件系统——目录项存的是 inode 号，inode 号只在单个文件系统内唯一；② 不能对目录建硬链接——会在树里造环，让 `find`/`nftw` 这类遍历和「目录内容大于子内容」的约定全部失效（规避：符号链接可以对目录，或用 bind mount）。**判据**：三层图画对；「引用路径 vs 引用 inode」说清；两条限制各给出结构原因。

:::
:::

::: ex 例 2.6-A2 · `rm` 删的是什么 {#ex-2.6-A2}

先猜：`rm big.log` 之后 `df` 的数字一定立刻下降吗？`rm` 这个名字与 `unlink` 这个系统调用名，哪个更接近它实际做的事？

说出 `unlink` 做的三件事；解释「`nlink==0` 且无打开 fd」的双计数；给出这个特性的一个正面用法。

::: sol 解答

不一定。`unlink` 删的是**目录项**（名字 → inode 的映射）：删条目、`nlink` 减一、若降到 0 则标记可释放。数据真正释放还要 inode 的**打开文件描述计数**也归零——有进程持有 fd（比如日志轮转后还在写旧文件的 daemon），磁盘空间就不释放，`ls -l /proc/*/fd/* | grep deleted` 能找到持有者。名字 `unlink` 比 `rm` 诚实：它移除的是一个链接，不是「删除文件」；同一 inode 的其他名字不受影响，`nlink` 降到 0 之后**无法**再把名字关联回去。正面用法：创建后立即 `unlink` 的临时文件——名字瞬间消失，进程照常经 fd 读写，退出即释放，`tmpfile()` 就是这么做的；既免清理代码，也杜绝了临时文件被别的进程打开的窗口。**判据**：三件事说全；「双计数」说出 `nlink` 与 fd 两路；正面用法给出 `tmpfile` 或等价模式。

:::
:::

::: ex 例 2.6-A3 · `rename` 的「成功且无变化」 {#ex-2.6-A3}

先猜：`touch x; ln x y; rename("x", "y")` 返回什么？调用之后 `x` 和 `y` 还在吗？

解释这条规则的内容、来源与动机；说明 `rename` 为什么不能跨文件系统、`mv` 怎么补偿。

::: sol 解答

返回 **0（成功）**，且 `x`、`y` 都还在、什么都没变。规则：oldpath 与 newpath 指向**同一文件**时，`rename` 成功且不产生任何变化。动机：内核必须检查「old 与 new 是否同一文件」来保证 `rename("x","x")`、`rename("x","./x")`、`rename("x","somedir/../x")` 这类调用不会把文件删掉；这条语义源自早期 BSD 实现的同文件检查方式，后来 POSIX 固化——所以它是**规范行为**，不是 Linux 私货。直觉「newpath 存在就覆盖」在这里失效，正是因为覆盖的判定先于目录项替换、且同文件判定优先。跨文件系统返回 `EXDEV`：目录项里存 inode 号，改名只改**一个**文件系统内的目录页，跨设备没法只动目录项；`mv` 检测到 `EXDEV` 后退化为「复制到目标临时名 + 保留元数据 + `rename` 到终名 + 删源」——所以跨盘 `mv` 变慢且**不是原子**的。**判据**：返回值与两名字都在说对；动机从「防误删同文件」讲清；`EXDEV` 的结构原因与 `mv` 的退化路径说全。

:::
:::

::: ex 例 2.6-A4 · `*at` 家族为什么存在 {#ex-2.6-A4}

先猜：`openat(dirfd, "conf.json", O_RDONLY)` 比 `open("conf.json", O_RDONLY)` 多了什么保障？`AT_FDCWD` 传给 `dirfd` 时行为等价于谁？

说出 `*at` 的两个动机；解释 `cwd` 为什么是进程级而非线程级、这带来什么问题；说明 `*at` 不防什么。

::: sol 解答

两个动机。① **TOCTOU**：`open("a/b/c")` 逐级解析路径，解析期间 `a` 或 `a/b` 可能被换成攻击者可控的目录；先 `open("a", O_DIRECTORY)` 拿 fd 再 `openat(fd, "b/c", ...)`，解析从 fd 锚定的 inode 出发，前缀替换失效。② **每线程虚拟工作目录**：`cwd` 是**进程级**属性（所有线程共享），一个线程 `chdir` 会影响其他线程的全部相对路径解析；各线程持自己的目录 fd + `openat`，就模拟出线程私有 cwd。`dirfd = AT_FDCWD`（特殊负值 -100）时等价于不带 at 的老接口——这也是库代码把「相对 `cwd`」做成可选项的通用姿势。`*at` **不防 `..` 逃逸**：`openat(fd, "../etc/passwd")` 照样出去；要限制在子树内用 `openat2` 的 `RESOLVE_BENEATH`；最后一段被换成符号链接要 `O_NOFOLLOW`。**判据**：两个动机各配一个攻击/故障场景；`AT_FDCWD` 值与语义说对；「不防逃逸」与补法（`openat2`）说清。

:::
:::

::: ex 例 2.6-A5 · inotify 是通知不是日志 {#ex-2.6-A5}

先猜：对同一个文件连续 `write` 100 次（每次都触发 `IN_MODIFY`），`read` 一次能拿到几条 `IN_MODIFY`？「事件丢了」和「事件被合并」怎么区分？

说出合并与溢出的机制与正确应对；解释为什么 inotify 不能用来精确计数。

::: sol 答案

不一定——**可能只有 1 条**。合并规则：新事件与队列**尾部**事件的 `wd`/`mask`/`cookie` 完全相同则被丢弃（内核省内存 + 多数应用不关心次数）。连续写 100 次若中间没有其他事件插入，队列里就是一条 `IN_MODIFY`。溢出是另一回事：队列超过 `max_queued_events`（本机 16384）时**前面的事件整体丢失**、队列尾放入 `IN_Q_OVERFLOW`（`wd=-1`）——区分点就在这条特殊事件：有它说明丢了，没有只能说明可能合并过。应对：溢出后必须**全量重扫**（重新 `readdir`/`stat` 建立当前状态基线）再继续增量，继续处理残缺增量只会越走越偏。因为「次数、频率都不可靠」且「非递归」「`wd` 可复用」，inotify 的正确定位是**尽力而为的变更通知**：配合全量扫描做增量优化，不承担可靠性——要可靠日志用应用层记录或审计/fanotify。**判据**：合并的「尾部同 wd/mask/cookie」条件说对；溢出与合并的区分（`IN_Q_OVERFLOW`）说清；「重扫」作为唯一正确应对。

:::
:::

::: ex 例 2.6-A6 · 符号链接的解引用分野 {#ex-2.6-A6}

先猜：`stat`、`unlink`、`rename`、`readlink` 四个调用，对路径**最后一段**是符号链接的，各操作链接本身还是目标？路径**中间**的目录部分呢？

给出「解引用/不解引用」的分界与层数限制。

::: sol 解答

最后一段：`stat` 解引用（拿目标属性）、`unlink` 不解引用（删链接本身——所以要删符号链接用 `unlink`，删目标要 `stat`+名字）、`rename` 不解引用（**两个参数都不**：old 是链接就搬链接本身，new 是链接就把它当普通路径覆盖掉）、`readlink` 不解引用（它的职责就是读链接内容）。中间的**目录部分总是解引用**：`/somedir/file` 里 `somedir` 是链接，任何调用都会跟过去——分野只在最后一段。少数场景需要「同一功能两套」：`stat`/`lstat`、`link`/`linkat(AT_SYMLINK_FOLLOW)`、`open` 的 `O_NOFOLLOW`。层数：每个部件至少 `_POSIX_SYMLOOP_MAX`=8 次（SUSv3 下限；Linux 2.6.18 前只有 5），整条路径 Linux 实践上限 40 次，超限 `ELOOP`——防链接成环与内核解析栈溢出。**判据**：四个调用的行为全对；「中间总是跟随」说对；8/40 两个数字各管一段说清。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.6-B1 · 日志轮转后空间不降 {#ex-2.6-B1}

现象：运维 `logrotate` 移走并 `rm` 了 80 GiB 的 `app.log`，`df` 显示空间一点没降，重启应用才释放。

按「现象 → 机制 → 读数 → 修法」四段作答；`lsof` 不在时怎么找持有者？

::: sol 解答

**现象**：删除大文件后空间不释放，重启进程才降。**机制**：应用仍持有旧文件的打开 fd——`unlink` 只删目录项，inode 的打开计数还在，数据要等最后一个 fd 关闭才释放；「轮转后改名+删名」对持有 fd 的进程完全透明（fd 指向打开文件描述，与名字无关），它还在往旧 inode 写。**读数**：`ls -l /proc/<pid>/fd/` 能看到指向 `app.log (deleted)` 的 fd（本机 `lsof` 未装，用这条免权替代）；对照 `df` 与 `du` 的差值就是这些隐形数据。**修法**：正确姿势是让应用响应 `SIGHUP` 重新打开日志（syslog 风格），或写前用 `O_APPEND` 且轮转发信号；已中招时用 `: > /proc/<pid>/fd/<n>` 清空旧 fd 内容立即回收空间（截断 fd 指向的 inode），不用重启。这类现象的正解不是「重启大法」，是理解名字层与数据层的双计数。**判据**：双计数机制说对；`/proc` 替代命令给出；「截断 fd」这类无损修法至少一个。

:::
:::

::: ex 例 2.6-B2 · 递归监听漏了新目录 {#ex-2.6-B2}

现象：同步工具用 inotify 监控目录树，深处的子目录里新建文件收不到事件；重启后又能同步。

按四段作答；给出递归监听的标准结构与竞态窗口的补法。

::: sol 解答

**现象**：新增子目录内的事件收不到，重启（重新全量加 watch）后正常。**机制**：inotify **非递归**——`inotify_add_watch` 只监视指定目录本身；「遍历树加 watch」与「目录被创建」之间有竞态窗口：先 `readdir` 后 `add_watch` 的间隙里新建的目录，既不在已加列表里、又不会再有全量扫描，就成了盲区。**读数**：`find /proc/*/fd -lname 'anon_inode:inotify'` 确认实例在；对事件打日志看有没有 `IN_CREATE|IN_ISDIR`/`IN_MOVED_TO|IN_ISDIR`（有就说明补 watch 分支没写或没生效）。**修法**：标准结构四步——① `nftw(FTW_PHYS)` 给**每个**目录加 watch，`wd→path` 入表；② 循环处理事件：`IN_CREATE|IN_ISDIR` 或 `IN_MOVED_TO|IN_ISDIR` 对新目录递归 `nftw` 补加；`IN_IGNORED`/`IN_DELETE_SELF` 删映射；`IN_Q_OVERFLOW` 全量重扫；③ **加完 watch 后再扫一遍**树，补掉「先扫后加」窗口里创建的目录（重复 `add_watch` 对同一路径返回同一 `wd` 并更新 mask，幂等安全）；④ 退出 `close(fd)` 自动清全部 watch。**判据**：「非递归 + 竞态窗口」两个原因都点到；「加完再扫」这个补法说对；重复 `add_watch` 幂等说清。

:::
:::

::: ex 例 2.6-B3 · `/tmp` 里的 EACCES 不是权限问题 {#ex-2.6-B3}

现象：root 运行的备份工具读取 `/tmp/u1/link`（u1 建的符号链接，指向 `/home/u1/data`）报 `EACCES`；同一路径 u1 自己读正常。

按四段作答；给出排查顺序。

::: sol 解答

**现象**：链接目标明明可读，跨用户访问却 `EACCES`；不是经典 `chmod` 问题。**机制**：`fs.protected_symlinks=1`（本机实测值）——在 sticky 且全局可写目录（`/tmp`，`1777`）里**跟随**符号链接时，要求「链接属主 == 跟随者」或「目标属主 == 跟随者」；root 跟随 u1 的链接、目标也是 u1，两个条件都不满足，`EACCES`。它防的是「往 `/tmp` 放指向 `/etc/shadow` 的链接骗特权程序跟随」。同族的 `fs.protected_hardlinks=1` 挡「把别人的文件硬链进自己的目录再读」。**读数**：`sysctl fs.protected_symlinks fs.protected_hardlinks`；`stat -c '%A %U' /tmp /tmp/link` 看 sticky 位与属主。**修法**：程序侧避免依赖 `/tmp` 的跨用户链接（用属主目录或受控目录）；运维侧确认这是预期防护而不是故障——**不要**关 sysctl 来「修」。排查顺序：① `sysctl fs.protected_*`；② 路径组件属主与 sticky 位；③ 才轮到普通 `chmod`/ACL。**判据**：两个条件的检查逻辑说对；攻击动机点明；「别拿 sysctl 当故障修」。

:::
:::

::: ex 例 2.6-B4 · `RENAME_EXCHANGE` 报 EINVAL {#ex-2.6-B4}

现象：发布脚本在本地 ext4 测试 `renameat2(RENAME_EXCHANGE)` 正常，上到 NFS 共享目录报 `EINVAL`；另一台老内核机器直接 `ENOSYS`。

按四段作答；给出可移植的降级方案。

::: sol 解答

**现象**：同一调用三处三样：ext4 成功、NFS `EINVAL`、老内核 `ENOSYS`。**机制**：`renameat2` 是 Linux 3.15+ 的调用；flags 的支持**按文件系统**实现——`RENAME_EXCHANGE` 需要 fs 的 rename 实现 pairwise 交换，NFS/部分 FUSE 没做，返回 `EINVAL`（或 `EOPNOTSUPP`）；`RENAME_WHITEOUT` 只有 overlayfs 有意义。**读数**：`uname -r` 看内核（<3.15 必 `ENOSYS`）；`df -T 目标` 看文件系统；对照本机 `/tmp`（ext4）与 `/dev/shm`（tmpfs）都能过。**修法**：可移植降级——`EXCHANGE` 换「`rename(a, tmp)` → `rename(b, a)` → `rename(tmp, b)`」三步（**不原子**，中间态可见，要配合锁或接受窗口）；或检测到 `EINVAL`/`ENOSYS` 后退回 `RENAME_NOREPLACE` + 换名方案。调用前用 `renameat2` 试探一次并缓存结果，别每轮重试失败路径。**判据**：「调用存在性」与「fs 支持」两层分开说；降级方案给出且标注非原子；试探缓存的做法。

:::
:::

::: ex 例 2.6-B5 · `wd` 指向了错误的目录 {#ex-2.6-B5}

现象：监控服务把事件归因到目录时张冠李戴——`/data/a` 的写事件被记到已删除的 `/data/old` 名下。

按四段作答；说清 `wd` 的生命周期。

::: sol 解答

**现象**：`wd→path` 映射错配，事件归因到旧路径。**机制**：`wd` 是**实例内的小整数**，watch 被移除后这个数字会被后续 `inotify_add_watch` **复用**；受监控目录被 `rm -r` 后内核发出 `IN_IGNORED` 并释放 `wd`，若程序没删映射，新建的 `/data/new` 拿到同一个 `wd`，旧映射把事件全归到 `/data/old`。**读数**：事件日志里新旧目录出现**相同的 wd 值**是铁证；时间上 `IN_IGNORED` 之后紧跟着新路径的事件。**修法**：收到 `IN_IGNORED` **立即**删映射（它有三种来源：显式 `rm_watch`、对象被删、文件系统卸载——`IN_UNMOUNT` 后也跟着 `IN_IGNORED`）；`IN_ONESHOT` 触发后没有 `IN_IGNORED`，这类一次性 watch 别进映射表。防御性写法：映射删除前保留 tombstone，归因时对「最近被 IGNORED 的 wd」打警告而不是静默归属。**判据**：「`wd` 复用」是根因；三种 `IN_IGNORED` 来源说全；`IN_ONESHOT` 例外提到。

:::
:::

::: ex 例 2.6-B6 · 遍历工具把符号链接内容也统计了 {#ex-2.6-B6}

现象：自研的目录统计工具对 `/usr` 统计出的体积是 `du` 的数倍；`/usr/lib` 下指向 `/lib` 的符号链接内容被算了两次。

按四段作答；比较 `nftw` 与 `fts` 的解法。

::: sol 解答

**现象**：统计值虚高数倍，符号链接指向的子树被重复计入。**机制**：遍历默认**跟随符号链接**——`nftw` 不加 `FTW_PHYS` 时链接被解引用成目标（悬空链接报 `FTW_SLN`），目标子树被完整走一遍；`du` 的默认行为是**不跟随**（链接只算自身那一项）。目录树里 `/usr/lib → /lib` 这类共享链接很多，重复计数是乘法效应。**读数**：对照 `du -s /usr` 与工具输出；打印 `typeflag`/`fts_info` 看 `FTW_SL`（`FTW_PHYS` 下链接本身的回调）是否出现过。**修法**：`nftw` 加 `FTW_PHYS`（链接以 `FTW_SL` 回调、自己决定要不要加 0）；需要跳过某个链接子树时用 glibc `FTW_ACTIONRETVAL` + 回调返回 `FTW_SKIP_SUBTREE`；`fts` 用 `FTS_PHYSICAL` 打开、`fts_set(FTS_SKIP)` 跳子树。另注意统计口径：`st_blocks*512` 是块占用、`st_size` 是逻辑大小，`du` 用前者。**判据**：「默认跟随」是根因；`FTW_PHYS`/`FTS_PHYSICAL` 修法；统计口径（blocks vs size）提一句。

:::
:::

## C 组 · 动手实验

::: ex 例 2.6-C1 · readdir 循环与 DT_UNKNOWN {#ex-2.6-C1}

先猜：`readdir` 循环里不加 `errno=0` 重置会怎样？对本机 `/tmp` 跑 `lsdir`，`DT_UNKNOWN` 分支会触发吗？

编译正文 `lsdir.c`（`cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lsdir.c -o lsdir`），分别在 `/tmp`（ext4）与 `/dev/shm`（tmpfs）运行。

::: sol 解答

不加重置的风险：某次 `readdir` 中途其他 libc/系统调用残留了非零 `errno`，循环正常结束时 `errno != 0`，误报错误——所以循环体内每次调用前重置。本机实测：两个文件系统跑 `./lsdir /tmp`、`./lsdir /dev/shm` 都正常列出名字与类型（`-`/`d`/`l`），**`DT_UNKNOWN` 分支未触发**——ext4 与 tmpfs 都填 `d_type`。把 `lsdir` 指向一个 FUSE 挂载点（若机器上有）才可能见到 `?`（`DT_UNKNOWN` 走 `fstatat` 补齐也失败的输出）。验证纪律：故意制造错误（`./lsdir /nonexistent` 应报 `opendir: No such file or directory`），确认错误路径本身也是实测过的。**看到什么算对**：目录名与类型逐行输出；错误现场 `perror` 信息与 `errno` 对得上。

:::
:::

::: ex 例 2.6-C2 · 硬链接的 nlink 生命周期 {#ex-2.6-C2}

先猜：创建文件 → 硬链接 → 删原名 → 再删硬链接，`nlink` 依次怎么走？数据在删到第几个名字时释放？

编译 `linkdemo.c` 运行；再用 shell 复现一遍并逐步 `stat -c 'ino=%i nlink=%h'`。

::: sol 解答

`nlink` 序列：创建后 1 → `link` 后 2 → `unlink` 原名后 1 → `unlink` 最后一个名字后 **0（释放）**——本机 `linkdemo` 输出与正文预期一致（`nlink=2/2/1`，`soft.link size=10`）。shell 复现：`D=/tmp/lab2c06_c2_$(date +%s); mkdir $D; cd $D; echo hello > f; stat -c '%i %h' f; ln f g; stat -c '%i %h' f g`（两行 ino 相同、`nlink=2`）；`rm f; stat -c '%i %h' g`（nlink=1，`g` 内容完好）；`rm g` 后 `ls` 空目录。关键读数：删第一个名字后 `g` **完全正常**——两个名字地位平等，没有「原名」特权。**看到什么算对**：每一步 ino 恒定、`nlink` 序列 1→2→1→释放；`readlink` 输出的符号链接部分 `size` 等于目标字符串字节数。

:::
:::

::: ex 例 2.6-C3 · renameat2 的 NOREPLACE 与 EXCHANGE {#ex-2.6-C3}

先猜：`NOREPLACE` 打在已有目标上返回什么 errno？`EXCHANGE` 之后两个名字的内容怎么变？tmpfs 上行为一样吗？

编译 `renamex.c`，分别在 `/tmp`（当前目录）与 `/dev/shm` 下运行。

::: sol 解答

本机实测（ext4 与 tmpfs 结果一致）：`NOREPLACE onto existing: rc=-1 errno=17 (File exists)`；`NOREPLACE onto free name: rc=0`；`EXCHANGE: rc=0`，随后 `rx_b = AAA`、`rx_c = BBB`——内容互换、两个名字都在。扩展验证 `EXCHANGE` 前置条件：只造一个文件再 `EXCHANGE`，应得 `ENOENT`（两边都必须存在）。需要 `#include <linux/fs.h>` 拿 `RENAME_*` 常量（glibc 头里不一定有）。跨文件系统（`/tmp` 的文件 exchange 到 `/dev/shm` 的名字）应得 `EXDEV`——同 `rename`。**看到什么算对**：三个读数与正文一致；`ENOENT` 与 `EXDEV` 两个边界当场复现。

:::
:::

::: ex 例 2.6-C4 · inotify 的事件流与 cookie {#ex-2.6-C4}

先猜：`echo hi > f` 产生哪几个事件、什么顺序？`mv f g` 的两个事件怎么配对？连续 `echo` 两次只 `read` 一次，事件会合并吗？

编译 `watchdir.c`，后台运行后做上述操作，逐行核对掩码与 cookie。

::: sol 解答

本机实测：`echo hi > f` 依次 `IN_CREATE`（name=f）→ `IN_MODIFY`（写 3 字节）→ `IN_CLOSE_WRITE`（关闭可写 fd）；`mv f g` 产生 `IN_MOVED_FROM`（name=f）与 `IN_MOVED_TO`（name=g），**cookie 相同**、且 FROM 恒先于 TO。合并验证：`for i in 1 2 3; do echo x >> f; done` 之间不睡，一次 `read` 可能只见到一条 `IN_MODIFY`（尾部合并）——但每次 `echo` 都开关 fd，`IN_CREATE`（对 `>>` 不新建则无）与 `IN_CLOSE_WRITE` 会穿插打断合并，所以「合并多少」依赖操作模式，这正是「不能计数」的实证。读法：掩码用十六进制对照（`IN_CREATE=0x100`、`IN_MOVED_FROM=0x40`、`IN_MOVED_TO=0x80`），`IN_ISDIR=0x40000000` 在对目录操作时出现。**看到什么算对**：事件序列完整、cookie 配对成功、能当场演示一次合并或解释为什么没合并。

:::
:::

::: ex 例 2.6-C5 · 递归监听的三件事 {#ex-2.6-C5}

先猜：`mkdir -p a/b/c` 一条命令会触发几次补 watch？`rm -r` 之后映射清理靠哪个事件？

编译 `watchrec.c`，后台运行后执行 `mkdir -p /tmp/lab2c06_c5/a/b/c`、`touch .../a/b/c/f`、`mv a a2`、`rm -r a2`，逐段核对。

::: sol 解答

`mkdir -p a/b/c` 逐级创建：每级都触发 `IN_CREATE|IN_ISDIR`，程序对 `a` 补 watch → `a/b` 的事件随后到达 → 再补 `a/b` 的 watch → 收到 `b/c` 的 `IN_CREATE`……**补加是链式的**，一条命令触发三次补 watch（a、b、c），日志里能看到顺序依赖。`touch` 后 `c` 的事件正常到达（补 watch 生效的铁证）。`mv a a2`：`IN_MOVED_FROM|IN_ISDIR` + `IN_MOVED_TO|IN_ISDIR`（cookie 配对）+ 被移动目录自身的 `IN_MOVE_SELF`（如果有 watch 在它上面）——程序对 `a2` 递归补 watch。`rm -r a2`：由深到浅 `IN_DELETE`（对 `f`、`c`、`b`……）+ 每个被监控目录的 `IN_DELETE_SELF` + 最后 `IN_IGNORED` 逐个清映射。**看到什么算对**：链式补加日志完整、事件归因路径正确（无 `dir=?`）、`IN_IGNORED` 与映射清理一一对应。

:::
:::

::: ex 例 2.6-C6 · strace 辨认 getdents64 与 inotify 实例 {#ex-2.6-C6}

先猜：`dirwalk` 的一次目录读取在 strace 下长什么样？本机当前有多少个 inotify 实例？

`strace -yy -e trace=openat,getdents64,close ./dirwalk /tmp/tree 2>&1 | head -15`；`find /proc/*/fd -lname 'anon_inode:inotify' 2>/dev/null | wc -l`。

::: sol 解答

strace 读数（本机 strace 6.8，显式列调用名）：`openat(AT_FDCWD, "/tmp/tree", O_RDONLY|O_DIRECTORY|O_CLOEXEC) = 3</tmp/tree>`；递归层 `openat(3</tmp/tree>, ".", ...O_NOFOLLOW...) = 4</tmp/tree>`；`getdents64(4</tmp/tree>, 0x..., 32768) = 80` 然后 `= 0`（读完）；`-yy` 把 fd 注释成路径。读法：32768 是 glibc `DIR` 内部缓冲（一次向内核要这么多），80 是一次取到的变长记录总字节，返回 0 是 EOF；看到 `read()` 而非 `getdents64` 说明读的是普通文件不是目录。实例统计：本机数出的值随桌面环境浮动（读数记进你自己的实验记录即可，重点是**口径**：`anon_inode:inotify` 是匿名 inode，只覆盖同用户可数的进程）。对照：跑起 `watchdir` 后再数一次，数量 +1。**看到什么算对**：strace 行能逐字段解读；实例数前后对照有差值。

:::
:::
