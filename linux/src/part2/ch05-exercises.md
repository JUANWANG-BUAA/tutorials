# 2.5 习题集

三组分层：**A 组概念判断**考「会不会说理由」；**B 组诊断推理**给现象让你判机制、判断点、给修法；**C 组动手实验**全部在这台免 `sudo` 的 Ubuntu 24.04.5 aarch64 虚拟机上真跑过，每题都写「看到什么算对」。共 18 题。每题第一个动作都是「先猜」：把预期写下再验证，猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求说出一段完整因果，B 组写成「现象 → 机制 → 读数 → 修法」四段。
2. 卡住了回对应小节的 errata/method 盒重读，不要直接看答案：A 组对应 2.5.1–2.5.14，B 组对应 2.5.3–2.5.14 与 2.5.17，C 组对应 2.5.1–2.5.16。
3. C 组命令都按本机设计：临时目录统一 `D=/tmp/lab2c05_实验名_$(date +%s)`，程序用 `lab2c05_` 前缀编译。**这台机器禁止删除操作**，实验产物留着别删，下次换新目录再跑。
4. **环境边界**：`sudo` 与 `perf` 不可用，跨进程 ptrace 被 `ptrace_scope=1` 挡住；`getfacl`/`setfacl`/`lsattr`/`chattr`/`strace` 可用，**`getfattr`/`setfattr` 未安装**（凡是要 dump xattr 的地方用自写程序或 `python3` 走 libc）。凡需要 root 的步骤一律标「本机不可做」，不要为了跑通去猜数字。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch05-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.5-A1 · 四个 `stat` 变体与两个 flag {#ex-2.5-A1}

先猜：`stat` 和 `lstat` 对同一个符号链接给出的 `st_size` 会相同吗？`fstatat(dirfd, "name", ..., 0)` 和 `stat("name", ...)` 在什么情况下结果不同？

说明四个变体各自的适用场景；解释 `AT_SYMLINK_NOFOLLOW` 与 `AT_EMPTY_PATH` 的用途；说出 `ELOOP`、`EOVERFLOW` 各在什么现场出现。

::: sol 解答

`stat` 跟随符号链接、拿到的是目标的属性；`lstat` 不跟随，拿到链接本身（类型 `S_IFLNK`，大小是目标路径字符串的长度，本机实测指向 `/etc/hosts` 的链接 `size=10`，而目标 `size=235`）。`fstat(fd, ...)` 用已经打开的 fd，路径已经解析完，最不容易被中途替换；`fstatat(dirfd, path, ...)` 相对 `dirfd` 解析，不受进程 `cwd` 变化影响——多线程或 chroot 相关代码里这才是安全写法，`stat("name")` 依赖 `cwd`，两次调用之间 `cwd` 可能已经变了。`AT_SYMLINK_NOFOLLOW` 让 `fstatat` 等价于 `lstat`；`AT_EMPTY_PATH` 表示「path 为空就是问 dirfd 本身」，正文写的「需要 `CAP_DAC_READ_SEARCH`」是有条件的：本机实测，对自己可读的普通文件、自己的目录、以及 root 拥有但全局可读的 `/etc/hosts` 都不需要任何 capability（见[勘误页](ch05-errata.md)第 3 节）。`ELOOP` 是符号链接层数超上限，本机实测第 40 层通过、第 41 层报 `Too many levels of symbolic links`；`EOVERFLOW` 是文件大小或 inode 号超出 `struct stat` 能表示的范围，典型现场是 32 位程序读大于 2 GiB 的文件，修法是 `-D_FILE_OFFSET_BITS=64`（本机 `cc -m32` 不被支持，这一条按文档级结论读）。

**判据**：说清「跟随/不跟随」「相对谁解析」两条轴；知道符号链接的 `st_size` 是目标路径长度；`AT_EMPTY_PATH` 的权限条件能说出「取决于文件是否可读」而不是背一句「要 capability」；`ELOOP`/`EOVERFLOW` 的现场各一个。

:::
:::

::: ex 例 2.5-A2 · 三个大小字段的单位与用途 {#ex-2.5-A2}

先猜：一个 `truncate -s 1G` 的文件，`st_size`、`st_blocks`、`st_blksize` 三个数分别是什么？把 `st_blocks` 乘 512 和乘 `st_blksize`，哪个才是占用？

分别说出三个字段的单位与用途；解释稀疏文件的空洞从哪来、读空洞会不会触发磁盘 I/O；说明 `st_blksize` 该怎么用、为什么不能把它当文件系统块大小。

::: sol 解答

`st_size` 是逻辑大小（字节），`st_blocks` 是**已分配的 512 字节块数**，`st_blksize` 是文件系统给的「最优 I/O 大小」。本机实测：`truncate -s 1G sparse.img` 得 `size=1073741824`、`blocks=0`、`du -h` 显示 0，用 C 的 `lstat` 读到 `st_blksize=4096`。占用 = `st_blocks * 512`，**与 `st_blksize` 无关**——把它乘错单位会得到 0 或差 8 倍的数。空洞来自 `truncate`/`fallocate(..., KEEP_SIZE)`/`ftruncate` 扩展出的逻辑长度：文件系统没有为这些偏移分配数据块，读出来是 0，且**不触发磁盘 I/O**；要真正分配用 `fallocate`（见 [2.3](ch03.md)）。`st_blksize` 的唯一正确用法是「决定读写缓冲区的建议大小」，它是建议值不是文件系统块大小：同一台机器上 ext4 的普通文件报 4096，而 `stat -f -c %s` 给出的文件系统块大小是另一个口径；不同文件系统给的值也不同（tmpfs 本机也报 4096）。还要注意：coreutils 的 `stat -c %B` 在这台机器上对所有文件都打印 512，**不能**用它读 `st_blksize`。

**判据**：三个字段单位各说对；`st_blocks*512` 是唯一正确的占用算法；空洞「读返回 0 且不碰磁盘」说对；`st_blksize` 定位为建议值；能指出 `stat -c %B` 的口径问题。

:::
:::

::: ex 例 2.5-A3 · `ctime` 为什么改不了、也不是创建时间 {#ex-2.5-A3}

先猜：`touch -d "2001-01-01" f` 之后，三个时间里哪几个变成了 2001 年、哪几个是现在？为什么？

说出三个时间戳各自的更新时机；解释 `ctime` 为什么不能设；给出「在这台 Linux 上拿创建时间」的正确做法与它的两个前提。

::: sol 解答

`utimensat`/`futimens` 只能设 atime 与 mtime，**没有接口能设 ctime**：任何改动 inode 的动作都会把 ctime 刷成现在。所以 `touch -d` 会让 atime/mtime 变成 2001 年，而 ctime 是「执行 `touch` 的那一刻」——这正是判断「时间戳被人手工调过」的线索。`ctime` 的更新时机是「inode 状态变了」：`chmod`、`chown`、`link`、`unlink`、`rename`、`setxattr` 都动它；写内容时**同时**动 `mtime` 和 `ctime`，因为大小与数据块布局也是 inode 状态的一部分。所以不能用 ctime 判断「只改了内容」还是「只改了元数据」，它是两类操作的并集。本机实测 `rename`：文件 ctime +1、mtime/atime 不变，父目录的 mtime 与 ctime 都变。要创建时间只能问 `statx` 的 `stx_btime`，两个前提：① 内核与 libc 支持 `statx`（旧内核返回 `ENOSYS`，要回退）；② **该文件系统填了这个字段**，所以必须先检查 `stx_mask & STATX_BTIME`，位没置时读到 0 不能念成「1970 年创建」。本机 ext4 与 tmpfs 都给了 btime。

**判据**：三个时间的更新时机说对；「`ctime` 是并集、不可设」说清；`touch` 后 ctime 变现在是可复现的解释；给 `btime` 的两个前提并强调看 `stx_mask`。

:::
:::

::: ex 例 2.5-A4 · 权限检查顺序与 `access()` 的两种错 {#ex-2.5-A4}

先猜：`access(path, W_OK)` 返回 0，紧接着 `open(path, O_WRONLY)` 会失败吗？一个目录只有 `r` 没有 `x` 时，`ls` 和 `stat` 分别什么结果？

写出内核的四步检查顺序；解释 `access()` 的两个问题与替代写法；说明 `umask` 与 `chmod` 的作用时机为什么不同。

::: sol 解答

四步：① `euid==0` 读写放行、执行要求至少有一个 `x`（或用 `CAP_DAC_OVERRIDE`/`CAP_DAC_READ_SEARCH`）；② `euid==st_uid` 用 owner 三位；③ `egid==st_gid` 或属组在辅助组里用 group 三位；④ 否则 other 三位。第一个命中的类别就出结论。`access()` 的问题有两个：一是**身份不一致**——它用 real UID/GID，`open` 用 effective，setuid 程序里两者可以相反，要按 effective 检查得用 `faccessat(AT_FDCWD, path, mode, AT_EACCESS)`；二是 **TOCTOU**——检查与打开之间文件可被替换或改权限。正确做法是不预检，直接 `open` 然后处理 `EACCES`（需要区分「权限不足」和「文件不存在」时，把 `errno` 分支写全）。`umask` 只在**创建**时把请求 mode 的位掩掉（`0666 & ~umask`，`mkdir`/`mkfifo`/`mknod` 同样受影响），对已存在的文件毫无作用；`chmod` 是直接设值，二者时机不同，所以「umask 已经设成 077，为什么老文件还是 644」不矛盾。另外 `umask` 是进程级共享状态，工作线程里改它会影响同进程其他线程——要么启动时设一次，要么创建后立刻 `fchmod`。setuid 现场本机需要 root，无法复现，按机制结论读。

**判据**：四步顺序完整且不落「换一组再试」；两个问题分别定位到「身份」与「竞态」；替代写法给出 `open`+`EACCES` 或 `faccessat(..., AT_EACCESS)`；`umask` 与 `chmod` 的时机差说清，并点出进程级共享。

:::
:::

::: ex 例 2.5-A5 · xattr 的失败码各说明什么 {#ex-2.5-A5}

先猜：`setxattr` 报 `EPERM`、`ENOTSUP`、`ENOSPC`、`E2BIG`，哪个是「文件系统不支持」、哪个是「名字写错」、哪个是「放不下了」？

给 `getxattr` 的三种返回与 `ERANGE` 的正确处理；把 `EPERM`/`ENOTSUP`/`ENOSPC`/`E2BIG`/`ERANGE`/`ENODATA`/`EEXIST` 七个码各对应到什么现场；说明标准两步法为什么还不够。

::: sol 解答

`getxattr` 成功返回**值的长度**；-1 + `ENODATA` 是属性不存在；-1 + `ERANGE` 是缓冲区太小；`ENOTSUP` 是文件系统不支持 xattr。名字写错通常是 `EINVAL`/`ENODATA`，不是 `ENOTSUP`。七个码的现场（本机实测值见[勘误页](ch05-errata.md)）：`EPERM`=`trusted.*`/`security.*` 命名空间越权、对符号链接或别人拥有的文件加 `user.*`、sticky 目录里非属主；`ENOTSUP`=文件系统根本没有 xattr 处理（VFAT、某些挂载）；`ENOSPC`=超过 inode 附近可用空间（本机 ext4 第二个 3000 字节的值、4096 字节的单个值、ACL 条目 520 条时）；`E2BIG`=超过 VFS 的 64 KiB 单值上限（本机 66000 字节）；`ERANGE`=名字超 255 字节或 `getxattr` 缓冲区不足；`ENODATA`=属性不存在或 `XATTR_REPLACE` 时不存在；`EEXIST`=`XATTR_CREATE` 时已存在。空字符串是**合法值**（`getxattr` 返回 0），别把它当「不存在」。两步法（先 `getxattr(..., NULL, 0)` 问长度再取）本身仍不安全：两次调用之间属性可能变大或被删，所以要循环处理 `ERANGE`，或按上限直接分配；`listxattr` 列出的名字也可能因权限被过滤或中途消失，「列得到、读不到」是正常现象。

**判据**：七个码各有一个现场且 `ENOTSUP`≠名字错；知道空值合法；给出「循环处理 `ERANGE`」或「按上限分配」的修法；说得出 `listxattr` 可能过滤。

:::
:::

::: ex 例 2.5-A6 · mask、匹配顺序与一次 `chmod` {#ex-2.5-A6}

先猜：`chmod 640` 会删掉 `user:alice:rw-` 这条 ACL 吗？alice 还能写吗？`chmod 007` 之后 alice 和 other 谁受影响？

解释 mask 约束谁、不约束谁；完整说出内核的匹配顺序，并指出「组匹配上了但权限不够」的结果；说明为什么 `ls -l` 的组权限位不能当 `group::` 念。

::: sol 解答

`chmod` 不删条目，它改的是 **mask**。有扩展 ACL 时 `st_mode` 的组三位就是 mask 的投影，所以 `chmod 640` 把 mask 压成 `r--`，alice 的条目仍写 `rw-` 而有效权限只剩读，`getfacl` 会加一行 `#effective:r--`。mask 约束所有命名用户、命名组和 `group::`，**不约束** `user::` 与 `other::`——这就是 `chmod 007` 的现场：mask 变 `---`，命名用户与属组条目全部失效（`#effective:---`），但 other 的 `rwx` 照样有效。匹配顺序：root 特例 → 命中 `USER_OBJ` → 命中某个 `ACL_USER`（结果 & mask）→ `egid`/辅助组命中 `GROUP_OBJ` 或某个 `ACL_GROUP`（结果 & mask）→ 否则 `OTHER`。第 4 步的要点是：只要有组条目匹配上但权限不够，**直接拒绝，不会落到 OTHER**。所以判断某人能否访问，看的是「条目 + mask」，`ls -l`/`stat -c %a` 的组位念的是 mask；要恢复用 `setfacl -m m::rw file`。磁盘上 mask 就是一条 `e_tag=0x10` 的 8 字节条目，本机实测 `chmod 640` 后它从 `rw-` 变 `r--`，其余四条不动。

**判据**：「改 mask 不删条目」+「alice 只剩读」说对；mask 的作用范围（含 `group::`，不含 `other::`）说对；组匹配失败不落 OTHER 说对；能指出 `ls -l` 组位是 mask。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.5-B1 · `ls -l` 说 1 GiB，`du` 说 0 {#ex-2.5-B1}

先猜：是 `du` 算错了，还是文件真的没占空间？`stat -c '%s %b %B'` 三个数怎么读？

一个备份程序生成的镜像文件 `ls -lh` 显示 1.0G，`du -h` 显示 0。写出「现象 → 机制 → 读数 → 修法」，并说明为什么不能据此判断「拷贝它很快」。

::: sol 解答

现象：同一文件两个大小，差三个数量级。机制：稀疏文件——`truncate`/`ftruncate`/`fallocate(KEEP_SIZE)` 只延长逻辑大小，没有为空洞分配数据块；读空洞返回 0 且不触发磁盘 I/O，所以 `du`（看实际块）报 0。读数：本机 `stat -c 'size=%s blocks=%b blksize=%B'` 给 `size=1073741824 blocks=0 blksize=512`，`du -b` 给 1073741824（逻辑长度），而 C 侧 `lstat` 的 `st_blksize=4096`。占用 = `blocks * 512 = 0`。注意本机 `stat -c %B` 恒为 512，是 coreutils 的口径，不是稀疏造成的（见[勘误页](ch05-errata.md)第 3 节）。修法/结论：算容量永远用 `st_blocks*512`，别用 `st_size`；但**拷贝时间取决于工具**：`cp` 逐块读时会把空洞重新写成真实零块，落地的副本可能真的占 1 GiB，要用 `cp --sparse=always`/`--reflink` 或支持稀疏的传输（`rsync -S`）。判断「这个文件多大」先问「哪一个大小：逻辑还是占用」。

**判据**：定位到稀疏而不是 `du` 出错；给出 `st_blocks*512` 的算法并指出 `%B` 的坑；说出拷贝可能把空洞变实的后果与一个正确工具选项。

:::
:::

::: ex 例 2.5-B2 · `chmod 640` 之后同事突然不能写 {#ex-2.5-B2}

先猜：ACL 条目被删了吗？`getfacl` 里该看哪一行？

共享目录里一个文件原本 `setfacl -m u:bob:rw f`，bob 能写。运维执行了 `chmod 640 f` 之后 bob 报 `Permission denied`，`getfacl` 里 `user:bob:rw-` 明明还在。写出四段分析，给出两种修法与一种预防。

::: sol 解答

现象：条目还在但权限变小，`ls -l` 从 `-rw-rw----+` 变成 `-rw-r-----+`。机制：有扩展 ACL 时 mode 的组位是 **mask**，`chmod 640` 把 mask 设成 `r--`，而 mask 是所有命名用户/组和 `group::` 的上限，bob 的 `rw- & r-- = r--`。读数：`getfacl f` 会出现 `user:bob:rw-  #effective:r--` 与 `mask::r--`；`stat -c %a f` 得 `640`；直接解码 xattr 能看到 `MASK r--` 而 `USER rw-`（本机完整复现过，条目字节没变）。修法：① `setfacl -m m::rw f` 把 mask 抬回去；② 重新 `setfacl -m u:bob:rw f`（会连带重算 mask）。预防：共享目录用**默认 ACL**（`setfacl -d -m u:bob:rw dir`）并告诉运维「带 ACL 的文件别用 `chmod` 调组权限，要调就用 `setfacl`」；脚本里若必须批量改权限，用 `setfacl -n` 保住 mask（注意 `-n` 在 `setfacl` 里是「不重算 mask」，和 `getfacl -n` 的「显示数字 ID」完全不是一回事）。要确认自己看的是 mask 还是 `group::`，比较 `stat -c %a` 与 `getfacl` 的 `group::` 行即可。

**判据**：指出 chmod 改的是 mask 且条目未被删；引用 `#effective:` 这一行作为读数；给出两种修法；预防里出现默认 ACL 或「用 `setfacl` 而不是 `chmod`」。

:::
:::

::: ex 例 2.5-B3 · 拷一个文件之后属组多出了写权限 {#ex-2.5-B3}

先猜：`cp` 不带 `-a` 会不会保留 ACL？如果不会，权限会「丢」成什么样？

源文件 `chmod 640` 后 `setfacl -m u:self:rwx`，`ls -l` 显示 `-rw-rwx---+`。有人用普通 `cp src dst` 复制了一份，结果 `dst` 变成 `-rwxrw----`，同组的人获得了写权限。写出机制与两种正确做法。

::: sol 解答

机制：`setfacl` 加了命名条目后 mask 被重算为 `rwx`，而 mode 的组位投影出的就是 mask，所以 `src` 的 st_mode 已经是 `670`。普通 `cp` 不写 ACL（它新建目标文件并套用源 st_mode 的低 12 位），于是 **mask 的值被当成「组权限」落进一个没有 ACL 的文件**，`group::` 凭空变成 `rwx`。本机实测：源 `mode=670`，普通 `cp` 后目标 `mode=670` 且 `getfacl` 只有 `group::rwx`、没有命名条目；`cp -a` 后目标保留 `user:...:rwx / group::r-- / mask::rwx`，`user.*` xattr 也一起带过去。正确做法：① 用 `cp -a`（或 `cp --preserve=all`）再核对 `getfacl`；② 显式复制：`getfacl src | setfacl --set-file=- dst`；跨文件系统或目标不支持 ACL 时，`cp -a` 也会静默退化，必须用 `getfacl` 复核。反向的坑也一样真实：`tar` 要 `--acls --xattrs`，`rsync` 要 `-A -X`，否则备份恢复后权限模型变了。

**判据**：说出「组位=mask，`cp` 把 mask 当组权限写过去」这条因果；给出 `cp -a`/`getfacl|setfacl --set-file` 两种做法；提到「跨文件系统还要用 `getfacl` 复核」。

:::
:::

::: ex 例 2.5-B4 · 设了 `umask 077`，新建文件还是全局可读 {#ex-2.5-B4}

先猜：`umask 077` 在有默认 ACL 的目录里还起作用吗？新建文件的 `other` 位由谁决定？

运维给共享目录设了 `chmod 2775` + `setfacl -d -m u:bob:rwx dir`，用户在目录里 `umask 077; touch newfile`，结果 `newfile` 是 `664`、`other::r--`，且 bob 的条目标着 `rwx` 但有效权限是 `rw-`。写出机制、两条排查命令与两种修法。

::: sol 解答

机制：POSIX 语义是「父目录有默认 ACL 时**忽略 `umask`**」。新建文件的权限由三者共同决定：`open` 请求的 mode（`touch` 用 0666）、继承下来的默认 ACL 条目、以及按请求 mode 重算的 mask。本机实测：`umask 077` 下 `touch` 得到 `mode=664`、`mask::rw-`（由 mode 的组位 `rw-` 得来）、`other::r--`（来自请求 mode 的 other 位）、`user:bob:rwx #effective:rw-`。所以两件事同时发生——umask 没能收紧 anything，而目录默认 ACL 里的 `other::r-x` 直接把「全局可读」传给了新文件。排查两条：`getfacl -p DIR` 看有没有 `default:` 行（`-p` 保留绝对路径，输出可直接喂回 `setfacl --set-file`）、`getfacl FILE` 看 `mask::` 与 `#effective:`。修法：① 收紧目录的默认 ACL：`setfacl -d -m o::--- dir`（必要时同时 `setfacl -d -m g::--- dir`）；② 不需要继承就 `setfacl -k dir` 删掉默认 ACL，让 `umask` 重新说话。附加一条：`chmod 2775` 让新文件继承目录属组，和默认 ACL 是两件独立的事，别把它们当成一个开关。

**判据**：说出「有默认 ACL 时 umask 被忽略」；解释 mask 来自请求 mode 的组位、other 来自继承；给 `getfacl -p DIR` + `getfacl FILE` 两条读数；两种修法各对应一个方向（收紧默认 ACL / 删默认 ACL）。

:::
:::

::: ex 例 2.5-B5 · `setxattr` 说「没有空间可用」，`getfattr` 说「命令不存在」 {#ex-2.5-B5}

先猜：`ENOSPC` 是磁盘满了吗？一台没装 `attr` 包的机器上怎么验证 xattr？

一个程序在 ext4 上给文件写第二个 3000 字节的 `user.*` 值时得到 `ENOSPC`，同一台机器上磁盘还空着 30 GiB；工程师的第一反应是「磁盘满了」。另一台机器上他想 `getfattr -d file`，shell 报 command not found。写出两段的机制、读数与修法。

::: sol 解答

第一段：`ENOSPC` 在这里不是文件系统余量不足，而是**这个 inode 附近放不下**。VFS 只给名字（≤255 字节）和单值（≤64 KiB）两条上限，总量由文件系统决定：ext4 把 xattr 优先放进 inode 的额外空间，放不下才分配一个外部块，而一个块就是 blocksize（本机 4 KiB），所以一个属性的总容量大约在 4 KiB 量级。本机实测：单个 4000 字节的值可以、4096 报 `ENOSPC`；第一个 3000 字节可以、第二个 3000 报 `ENOSPC`，但之后还能塞进 1 字节的小属性（inode 内联那点空间）。同样的道理限制了 ACL 条目数——ext4 上 500 条命名用户 ACE（4036 字节）能写、520 条（4196 字节）报 `ENOSPC`。修法：把大值挪进文件内容或数据库，xattr 只放索引；需要多条规则时控制条目数（XFS 的上限更小，Kerrisk 记 25 条）；排查顺序是「先 `df -h` 排除真满，再换尺寸二分，最后看 `stat -f` 与文件系统类型」。第二段：`getfattr`/`setfattr` 属于发行版的 `attr` 包，不在 glibc 里，和 `getfacl`/`setfacl`（`acl` 包）是两回事。本书测试机就没装 `attr`（装了 `acl`）。先 `command -v getfattr` 确认，没有就用自己的程序或 `python3 -c` 直接调 libc 的 `listxattr`/`getxattr` 验证——这也正好是 2.5.5 教的接口。

**判据**：把 `ENOSPC` 归到 inode 侧空间而不是磁盘余量；给出「一个块」这个量级与本机二分读数；说出 ACL 条目数同源；`attr`/`acl` 两个包不混，并给出免依赖的验证路子。

:::
:::

## C 组 · 动手实验

统一口径：先建工作目录并复用同一批程序。以下命令都在本书测试 VM（Ubuntu 24.04.5 aarch64、内核 7.0.0-38、GCC 13.3.0、glibc 2.39，`sudo`/`perf` 不可用）上跑通过。程序源码取自正文，先编译一次，后面各题都用它们。

```bash
D=/tmp/lab2c05_run_$(date +%s); mkdir -p $D && cd $D
# 把正文的 showstat.c / xattr_demo.c / statx_full.c / acl_raw.c / acl_demo.c / inode_flags.c 放进 $D
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 showstat.c  -o $D/showstat
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 xattr_demo.c -o $D/xattr_demo
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 statx_full.c -o $D/statx_full
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 acl_raw.c    -o $D/acl_raw
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 inode_flags.c -o $D/inode_flags
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 acl_demo.c   -o $D/acl_demo -lacl
command -v getfacl setfacl lsattr chattr strace getfattr setfattr   # 后两个本机没有
```

::: ex 例 2.5-C1 · 四个对象、三个大小、三个时间 {#ex-2.5-C1}

先猜：`/dev/null` 的 `st_mode` 类型位是什么？目录的 `st_size` 会是 0 吗？

用 `$D/showstat` 依次看 `/etc/hosts`、`/dev/null`、一个指向 `/etc/hosts` 的符号链接、`/tmp`，把 `type/mode/size/blocks/blksize/ino` 与三个时间抄成表；再用 `stat -c '%d %i %h %s %b %B %a'` 对同一批对象取一次读数，比较两者差在哪。

::: sol 解答

本机读数（inode 号与时间会随你的机器变，形状不会）：`/etc/hosts` → `type=- mode=0644 size=235 blocks=8 blksize=4096`；`/dev/null` → `type=c mode=0666 size=0 blocks=0 blksize=4096`；指向 `/etc/hosts` 的链接 → `type=l mode=0777 size=10 blocks=0`（10 就是目标路径的字符数）；`/tmp` → `type=d mode=1777 size=16384 blocks=32 blksize=4096`，目录的 `st_size` 是它目录数据块的大小，不是 0。`stat -c '%d %i ...'` 与 `showstat` 的前五个数应当完全一致，唯一常不一致的是 `%B`：`showstat` 读到的 `st_blksize` 是 4096，而 coreutils 的 `%B` 在这台机器上恒为 512——这就是「同一个字段、两个口径」的现场，见 C2 与[勘误页](ch05-errata.md)。

**看到什么算对**：链接那一行是 `type=l size=10`；`/dev/null` 是 `type=c`；目录有非 0 的 `size` 与 `blocks`；`%B`=512 与 C 侧 4096 并存（若你的机器 `%B` 也是 4096，说明 coreutils 版本不同，把这条记成读数差异而不是「我错了」）。

:::
:::

::: ex 例 2.5-C2 · 稀疏文件：三种「大小」口径对齐 {#ex-2.5-C2}

先猜：`du -h`、`du -b`、`ls -lh`、`stat -c %b` 四个读数里，哪两个是一回事？

做一个 1 GiB 的稀疏文件，抄下四个读数；再用 `dd` 往里写 1 MiB 真实数据，看哪些数变了；最后用 `$D/showstat` 读 `st_blksize`，与 `stat -c %B` 对照。

::: sol 解答

本机：`truncate -s 1G sparse.img` 后 `ls -lh` 给 1.0G、`du -h` 给 0、`du -b` 给 1073741824、`stat -c 'blocks=%b blksize=%B'` 给 `blocks=0 blksize=512`，而 `$D/showstat` 给 `blksize=4096`。写入 1 MiB 后 `st_blocks` 变成 2048（=1 MiB/512），`st_size` 不变，`du -h` 变成 1.0M。结论：`du -h` 与 `st_blocks*512` 是同一口径（实际占用），`du -b` 与 `ls -l`/`st_size` 是另一口径（逻辑长度）；`stat -c %B` 不是 `st_blksize`，判断建议 I/O 大小要用程序或 `statx`。

**看到什么算对**：`blocks=0`、`du -h`=0、`du -b`=1073741824 三者同时成立；写完 1 MiB 后 `blocks` 恰为 2048；`%B` 与 C 侧 `blksize` 不同（或相同但你能说清是 coreutils 版本差异）。

:::
:::

::: ex 例 2.5-C3 · 时间戳：`utimensat`、`ctime` 与 `relatime` 的两条分支 {#ex-2.5-C3}

先猜：把 atime 设成很久以前，读一次文件它就变；连续读第二次它也变吗？

在新文件上用 `utimensat` 只把 mtime 固定为 1700000000（不动 atime），观察 ctime；再把 atime 与 mtime 都设成 1000000000，读一次、读两次，各抄一次 `stat -c '%X %Y %Z'`；用 `findmnt -T . -o OPTIONS` 记录挂载选项。

::: sol 解答

本机（`/tmp` 在 ext4，`findmnt` 给 `rw,relatime`）：`utimensat(AT_FDCWD, f, {{UTIME_OMIT},{1700000000,0}}, 0)` 成功，结果 `mtime=1700000000` 而 **`ctime` 变成现在**——这就是「ctime 不可设」的直接演示。第二步把 atime/mtime 都设成 1000000000 再 `cat`：第一次读后 atime 跳到现在（满足「超过 24 小时」这条分支），**第二次读 atime 不动**（既不早于 mtime、也没超 24h）。把符号链接也纳入一次：`utimensat(..., AT_SYMLINK_NOFOLLOW)` 只改链接自身三个时间，目标不变。所以：不要用 atime 判断「有没有人读过这个文件」，`relatime` 只保证「一天至少一次 + mtime 变了就更新」。`noatime`/`lazytime` 两条分支本机改不了挂载选项（要 root），按文档级结论读。

**看到什么算对**：mtime 是 1700000000 而 ctime 是当前时刻；第一次读 atime 变化、第二次不变化；`findmnt` 输出里能看到 `relatime`；链接与目标的 mtime 各自独立。

:::
:::

::: ex 例 2.5-C4 · xattr：写、读、枚举与七个失败码 {#ex-2.5-C4}

先猜：对 `/dev/shm`（tmpfs）写 `user.*` 会不会被拒？把名字写成 300 字节，报的是 `ERANGE` 还是 `EINVAL`？

跑 `$D/xattr_demo`；再用下面这段一次性观察命名空间与容量边界，把每个 errno 抄下来：`trusted.*`/`security.*`/符号链接/`user.*`、缓冲区给 3 字节、名字 300 字节、值 66000 字节、同一文件第二个 3000 字节的值。

::: sol 解答

`xattr_demo` 输出正文那三行（`user.release = 2026.10`、`xattr: user.release`、`removed user.release`）。用 `python3` 走 libc 复测的读数：`trusted.foo`、`security.foo` → `EPERM`；对符号链接 `lsetxattr("user.*")` → `EPERM`；对 root 拥有的 `/etc/hosts` 写 `user.*` → `EPERM`；`/dev/shm`（tmpfs）写 `user.t` → **成功**（这台内核支持，正文那句「某些 tmpfs/老版本不可用」要按内核版本读）；值 7 字节而缓冲区给 3 → `ERANGE`，给 0 → 返回 7（问长度的正确姿势）；名字 300 字节 → `ERANGE`；值 66000 → `E2BIG`；单个值 4000 → 成功、4096 → `ENOSPC`；同一文件第二个 3000 → `ENOSPC`，随后 1 字节的小属性仍写得进去；`XATTR_CREATE` 撞已存在 → `EEXIST`，`XATTR_REPLACE` 撞不存在 → `ENODATA`。`listxattr` 在没有任何属性的文件上返回 0，别 `malloc(0)` 之后当列表念。

**看到什么算对**：七个码各拿到一次且名字与上面一致；tmpfs 的 `user.*` 写成功（若失败，记下内核版本，这本身就是有效读数）；`ENOSPC` 出现时你能说出「磁盘还很空」——用 `df -h .` 当场对照。

:::
:::

::: ex 例 2.5-C5 · ACL：从 `getfacl` 到磁盘上的 44 字节 {#ex-2.5-C5}

先猜：`setfacl -m u:$USER:rw` 之后再 `chmod 640`，`$D/acl_raw` 打出来的条目里有几条会变？`bytes` 会变吗？

建一个 `chmod 640` 的文件，加一条给自己的命名用户条目，依次看 `ls -l`、`getfacl`、`stat -c %a`、`$D/acl_raw`；再 `chmod 640`、`chmod 007`、`setfacl -m m::rw` 各看一次；最后用 `$D/acl_demo` 在另一个文件上走 libacl 路径。

::: sol 解答

本机读数：加条目后 `ls -l` 显示 `-rw-rw----+`（**组位念的是 mask**，末尾 `+` 表示有 ACL），`getfacl` 五条 + `mask::rw-`，`stat -c %a` 得 `660`，`$D/acl_raw` 得 `version=2 bytes=44` 与 `USER_OBJ rw- / USER rw- id=1000 / GROUP_OBJ r-- / MASK rw- / OTHER ---`（正文示例把最后一行写成 `OTHER r--`，与本机不符，见勘误页）。`chmod 640` 之后只有 `MASK` 变 `r--`，字节数仍是 44，`getfacl` 多出一行 `#effective:r--`。`chmod 007` 之后 `mask::---`，命名用户与 `group::` 都变 `#effective:---`，而 `other::rwx` 不受 mask 约束。`setfacl -m m::rw` 把 mask 抬回来、`#effective:` 消失。`acl_demo`（`-lacl`）能编译能跑，输出与 `getfacl` 一致；它给 `chmod 640` 的文件加一条只读命名条目后，`acl_calc_mask` 算出的 mask 是 `r--`。顺带一条：`chmod 2640` 在这种文件上会显示成 `-rw-r-S---`——setgid 位占据了组执行位那一格，而 mask 仍是 `r--`，`ls -l` 那一行因此不能按「组权限」念。

**看到什么算对**：`bytes=44` 且只有 `MASK` 那一条随 `chmod` 变化；`#effective:` 在 mask 收紧时出现、恢复时消失；`chmod 007` 后 `other` 仍可访问；`ls -l` 末尾的 `+` 与 `getfacl` 同时出现或同时消失。

:::
:::

::: ex 例 2.5-C6 · 默认 ACL、`umask` 与继承：把三者算出来 {#ex-2.5-C6}

先猜：`umask 077` 在有默认 ACL 的目录里能新建出 `660` 的文件吗？子目录会拿到什么？

按正文那组命令做一个共享目录（`chmod 2775` + 访问 ACL + 默认 ACL），在 `umask 077` 下 `touch` 一个文件、`mkdir` 一个子目录，各自 `getfacl`；再试 `setfacl -x`/`-b`/`-k` 三种删除，和「普通 `cp` vs `cp -a`」的权限差别。

::: sol 解答

本机读数：`umask 077` 下 `touch shared/newfile` 得到 `mode=664`，`getfacl` 是 `user::rw- / user:$USER:rwx #effective:rw- / group::rwx #effective:rw- / mask::rw- / other::r--`——**`umask` 被忽略**，mask 来自请求 mode 的组位，`other::r--` 来自目录默认 ACL 的 `other::r-x`。新建子目录除了继承访问 ACL，还把父目录的默认 ACL 接为自己的默认 ACL（`getfacl` 里出现 `default:` 行）。`chmod 2775` 让新文件的属组等于目录的属组，这条独立于 ACL。删除三种：`setfacl -x u:daemon f` 只少一条命名条目、base 三项不动；`setfacl -b f` 清空扩展条目，文件退回普通 mode（本机退回 `664`）、`ls -l` 的 `+` 消失；`setfacl -k dir` 只删默认 ACL。复制对比：源文件 `mode=670`（组位是 mask），普通 `cp` 出来的目标也是 `670` 但**没有 ACL**，于是属组真的拿到 `rwx`；`cp -a` 保留条目与 `user.*`，甚至跨到 tmpfs 也保留。

**看到什么算对**：`umask 077` 挡不住 `664`（这正是「默认 ACL 时忽略 umask」的证据）；子目录的 `getfacl` 有 `default:` 行；三种删除的差别各看到一次；普通 `cp` 的目标 `getfacl` 里没有命名条目而组位是 `rwx`。

:::
:::

::: ex 例 2.5-C7 · `statx` 与 `strace`：把本章字段变成读数 {#ex-2.5-C7}

先猜：请求 mask 传 0，内核还会给你 mtime 吗？`strace -e trace=%stat` 在这台机器上能抓到 `statx` 吗？

用 `$D/statx_full` 看 ext4 文件、ext4 目录、tmpfs 文件三处，抄下 `mask`、`btime`、`mnt_id`、`dio`；再用一个只请求 `0`/`STATX_TYPE`/`STATX_BASIC_STATS`/`STATX_ALL` 的小程序对比 `stx_mask`；最后分别用 `-e trace=%stat` 与 `-e trace=statx,newfstatat` 跑 `strace`，看抓到什么。

::: sol 解答

`statx_full`（请求 `BASIC|BTIME|MNT_ID|DIOALIGN`）本机：ext4 普通文件 `mask=0x3fff`、有 `btime`、`mnt_id=35`、`dio mem=512 off=512`；ext4 **目录** `mask=0x1fff`（不给 `STATX_DIOALIGN`）；tmpfs 文件 `mask=0x1fff`、`mnt_id=37`、**btime 也给了**。分别请求时：`mask=0` 得到 `stx_mask=0x173f`——**没有 MTIME/CTIME/BTIME**，所以「没请求就不保证给」；请求 `STATX_ALL`(0xfff) 得到 `0x1fff`，`STATX_DIOALIGN` 不在其中，这正是正文「`STATX_ALL` 是历史别名，不含新字段」的直接证据，而 `MNT_ID` 反倒被带回来了。`strace` 侧：本机 strace 6.8 上 `-e trace=%stat` **一行都不输出**（`%stat` 类里没有 aarch64 实际使用的 `statx`/`newfstatat`），要写成 `-e trace=statx,newfstatat`，才看到正文那种行：`statx(AT_FDCWD, "/etc/hosts", AT_STATX_SYNC_AS_STAT, STATX_ALL|STATX_MNT_ID|STATX_DIOALIGN, {...}) = 0` 与 `newfstatat(AT_FDCWD, "/etc/hosts", {st_mode=S_IFREG|0644, st_size=235, ...}, AT_SYMLINK_NOFOLLOW) = 0`；示例里的 `st_size=221` 是另一台机器的读数，本机是 235。`getfacl`/`lsattr`/`findmnt` 补上另一半：`getfacl -p` 的输出可回灌 `setfacl --set-file`，`lsattr` 在 ext4 显示 `--------------e-------`、在 tmpfs 显示全空，`findmnt -T . -o OPTIONS` 给出 `relatime`。`getfattr` 本机不存在，dump 原始字节用 `$D/acl_raw` 或 `python3` 调 `getxattr`。

**看到什么算对**：目录与 tmpfs 上 `mask` 都少一位 DIOALIGN、tmpfs 仍有 btime；`mask=0` 的请求结果里看不到 MTIME/CTIME；`%stat` 空输出而显式列名有输出（若你的 strace 版本 `%stat` 可用，记成版本差异并写出 `-V` 读数）。

:::
:::

## 三题选做（需要额外条件）

- **需要 root**：`chattr +i` 之后连 root 都改不动、把 `relatime` 换成 `noatime`/`lazytime` 再复测 C3、`setfacl` 后由属主以外的人访问、`trusted.*` 与 `security.capability` 写入。本机 `sudo` 不可用（`sudo -n true` 报 `a password is required`），这四组一律按未实测读，别抄别人的输出当自己的。
- **需要 32 位工具链**：`EOVERFLOW` 与 `_FILE_OFFSET_BITS=64` 的直接复现。本机 `cc -m32` 不被支持。
- **需要网络文件系统**：NFS/VFAT 上 `ENOTSUP`、`FORCE_SYNC` 的差别、ACL 上限（XFS 的 25 条也要另一台机器）。
