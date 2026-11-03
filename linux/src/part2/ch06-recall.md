# 2.6 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。21 张卡分三组：**A 组考目录、链接与改名（2.6.1–2.6.4）**，**B 组考锚定、防护与改名语义（2.6.6–2.6.10）**，**C 组考 inotify 与取证（2.6.5、2.6.11–2.6.14）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 目录、链接与改名

::: method 回忆 1 · `readdir` 的四条纪律
`readdir` 返回 NULL 有哪两种可能、怎么区分？`d_name` 的内存归谁、能存进自己的数组吗？顺序有保证吗？`d_type` 什么时候不可信？
::: sol 答案
调用前 `errno = 0`，循环结束后 `errno != 0` 才是错误、否则是正常 EOF（`readdir` 不用返回值区分）。`d_name` 指向 libc 内部复用的同一个 `struct dirent`，下一次调用就被覆盖——要保留必须 `strdup`。顺序不保证：ext4 htree 按哈希序返回，`ls` 的字母序是 `ls` 自己排的。`d_type` 是优化不是保证：部分文件系统（某些 NFS、FUSE）返回 `DT_UNKNOWN`，此时用 `fstatat(dirfd(dir), name, &st, AT_SYMLINK_NOFOLLOW)` 补齐。
:::
:::

::: method 回忆 2 · 目录的三个权限位与 `st_size`
目录的 `r`、`w`、`x` 各控制什么？目录的 `st_size` 是什么口径、为什么 `du -s` 一个目录和「里面文件大小之和」对不上？为什么不能对目录 `read()`？
::: sol 答案
`x` 是「能否穿过」（按路径访问其中条目）、`r` 是「能否列出名字」（`readdir`）、`w` 是「能否增删目录项」（创建/删除/改名其中的条目）。只 `r` 不 `x`：能列名但 `stat` 不了；只 `x` 不 `r`：知道确切路径就能用，列不出内容。目录的 `st_size` 是**目录项占的字节数**（ext4 通常是 4096 的倍数），不是内容总大小；`du` 算的是块占用，两者口径都不同于「文件大小之和」。内核不提供对目录的 `read()`：目录内容只能经 `opendir`/`readdir`（底层 `getdents64`）取，写目录只能经 `open(O_CREAT)`/`link`/`mkdir`/`symlink`/`unlink`/`rmdir` 间接进行。
:::
:::

::: method 回忆 3 · 硬链接与符号链接的三层图
画出来：`ln a b`、`ln -s a b`、`rm a` 各在目录项、inode、数据三层动了什么？符号链接计入目标 `nlink` 吗？悬空链接是什么？
::: sol 答案
`ln a b`：目录层多一条 `(b, ino#N)`，inode 层 `nlink` 1→2，数据不动。`ln -s a b`：目录层多一条 `(b, ino#M)`，inode #M 是**新**的（类型 `S_IFLNK`），内容是字符串 `"a"`，目标 inode 完全不动、`nlink` 不变。`rm a`：目录层删 `(a, ino#N)`，`nlink` 2→1；`nlink` 降到 0 **且**无进程持 fd 才释放 inode 与数据。符号链接不计入目标 `nlink`（所以悬空合法）：目标被删后链接仍在，只是解引用时 `ENOENT`。本机复跑：`linkdemo` 输出 `soft.link type=l nlink=1 size=10`——那个 10 是目标字符串 `link_demo.txt` 的长度，不是目标文件大小。
:::
:::

::: method 回忆 4 · `unlink` 之后数据什么时候释放，`rm` 后空间为什么不降
`unlink` 做了哪三件事？「`nlink==0`」和「数据释放」之间还差什么？怎么找出持有已删除文件的进程？这个特性有什么正面的用法？
::: sol 答案
`unlink` 删目录项、`nlink` 减一、若降到 0 则**标记** inode 可释放。数据真正释放还要等所有打开的 fd 关闭——inode 上除了 `nlink` 还有打开文件描述计数。`lsof +L1`（或 `/proc/*/fd` 找 `(deleted)`）找出持有者；日志轮转后程序还在写旧文件就是这一类。正面用法：创建即 `unlink` 的临时文件（`tmpfile()` 的做法）——名字立即消失，进程照常用 fd 读写，退出即释放，还免了清理代码。注意：`nlink==0` 后**无法**把名字重新关联回去；`unlink` 删目录报 `EISDIR`（Linux；SUSv3 说 `EPERM`），删符号链接删的是链接本身（不解引用）。
:::
:::

::: method 回忆 5 · `rename` 的五条边界规则
`rename` 跨文件系统返回什么？目标存在会怎样？old 与 new 是同一文件的另一个名字呢？对符号链接解引用吗？old 是目录时 new 有什么限制？
::: sol 答案
跨文件系统 `EXDEV`（`mv` 退化为复制+删除+保留元数据）；目标存在则**原子覆盖**（目录要非空才 `ENOTEMPTY`）；old 与 new 指向同一文件时**成功且无任何变化**——这不是 bug，源于早期 BSD 检查「同文件」的实现方式，`rename("x","x")`、`rename("x","./x")` 因此安全；两个参数都**不解引用**符号链接（old 是符号链接就重命名链接本身；new 是符号链接就把它当普通路径覆盖掉）；old 是目录时 new 要么不存在、要么是空目录，且 new 不能含 old 作前缀（`/home/mtk` → `/home/mtk/bin` 报 `EINVAL`）。`rename` 只动目录项不搬数据，所以持有旧 fd 的进程完全无感。
:::
:::

::: method 回忆 6 · `mkdir` 的 mode 与特殊位
`mkdir(path, 0777)` 实际权限由谁定？setgid 位从哪来、setuid 位呢？新目录里有哪两个固定条目、POSIX 要求它们存在吗？
::: sol 答案
实际权限 = `mode & ~umask`（进程掩码在创建一刻减位）。setgid 位**从父目录继承**（保证目录树下新建文件的组归属一致）；setuid 位恒被清零（对目录无意义）；粘滞位 `S_ISVTX` 若在 mode 里设置了会生效（`/tmp` 的 1777）。新目录含 `.`（自身）与 `..`（父目录）两个条目——但 SUSv3 只要求路径解析时能解释 `.`/`..`，不要求条目物理存在，可移植代码别假设能从 `readdir` 里看到它们。`mkdir` 只建最后一级：`mkdir("a/b/c")` 要求 `a/b` 已存在。
:::
:::

## B. 锚定、防护与改名语义

::: method 回忆 7 · `*at` 家族解决的两个问题
`openat(dirfd, ...)` 相比 `open(path, ...)` 多解决了什么？`AT_FDCWD` 是什么？为什么说多线程程序不该用 `chdir` 切换工作目录？
::: sol 答案
动机一：**TOCTOU**——`open("a/b/c")` 解析路径的过程中，`a` 或 `a/b` 可能被替换（攻击者把自己可控的目录换进前缀）；先 `open` 目标目录拿 fd，再 `openat(fd, "c", O_NOFOLLOW)`，解析只从 fd 锚定的 inode 出发，中途替换无效。动机二：**每线程虚拟工作目录**——`cwd` 是进程级属性（所有线程共享），一个线程 `chdir` 影响全部；各线程持有自己的目录 fd + `openat` 就模拟出「线程私有 cwd」。`AT_FDCWD` 是特殊负值（-100），表示「相对当前 `cwd`」，等价于不带 at 的老接口；传普通文件 fd 当 `dirfd` 返回 `ENOTDIR`。注意 `*at` 本身不防 `..` 逃逸，要 `openat2` 的 `RESOLVE_BENEATH`。
:::
:::

::: method 回忆 8 · `nftw` 的 flags 与回调协议
`FTW_PHYS`、`FTW_DEPTH`、`FTW_MOUNT` 各什么意思？回调返回非 0 会怎样？为什么回调里不能 `longjmp`？要跳过子树怎么办？
::: sol 答案
`FTW_PHYS` 不跟随符号链接（推荐，链接本身以 `FTW_SL` 传给回调）；`FTW_DEPTH` 改后序（先子后父，删树用）；`FTW_MOUNT` 不跨挂载点；`FTW_CHDIR` 进每个目录（多线程危险）。回调返回 0 继续，非 0 立即停止且 `nftw` 返回该值。`nftw` 内部动态分配遍历状态，`longjmp` 跳过清理会泄漏 fd/内存——库函数回调里不要 `longjmp` 是通用规则。跳子树用 glibc 扩展 `FTW_ACTIONRETVAL` + 回调返回 `FTW_SKIP_SUBTREE`（还有 `FTW_SKIP_SIBLINGS`）。`nopenfd` 是同时打开目录 fd 的上限不是深度上限，超限会关重开、变慢但不错。
:::
:::

::: method 回忆 9 · `renameat2` 的两种新语义
`RENAME_NOREPLACE` 与 `RENAME_EXCHANGE` 分别解决什么？目标存在时各返回什么？「先 `access` 再 `rename`」差在哪？
::: sol 答案
`NOREPLACE`：目标存在返回 `EEXIST`、不覆盖——这是「原子地占住一个名字」，配合「写临时文件 + 改名」实现安全发布；先 `access` 检查再 `rename` 两步之间别人可以抢占同名，是 TOCTOU。`EXCHANGE`：两边都存在时原子互换（一边不存在 `ENOENT`），`current` 与 `next` 互换后读者永远看到完整版本——版本切换的底层原语。两者都可能遇到文件系统不支持：老内核 `ENOSYS`，NFS/overlayfs 可能 `EINVAL`/`EOPNOTSUPP`（`WHITEOUT` 仅 overlayfs 有意义）。同文件系统约束与 `rename` 相同（`EXDEV`）。
:::
:::

::: method 回忆 10 · `fs.protected_hardlinks`/`protected_symlinks` 管什么
为什么普通用户不能对 `/etc/shadow` 建硬链接？`/tmp` 里的符号链接为什么有时 `open` 报 `EACCES`？这两个 sysctl 在 sticky 目录里各检查什么？
::: sol 答案
`protected_hardlinks=1`：在 sticky 且全局可写目录（如 `/tmp`）里建硬链接，要求你是文件属主或有读写权——否则 `EPERM`。挡的是「把 root 的文件硬链进我的目录再从我的 fd 读它」（`nlink` 计数让「属主」检查失效的老攻击）。`protected_symlinks=1`：sticky 全局可写目录里**跟随**符号链接，要求链接属主 == 跟随者、或目标属主 == 跟随者——否则 `EACCES`。挡的是「在 `/tmp` 放指向 `/etc/shadow` 的链接骗 root 程序跟随」。所以 `/tmp` 里的 `EACCES` 未必是 `chmod` 问题：先 `sysctl fs.protected_symlinks`，再看链接/目标属主与 sticky 位。容器通常继承宿主 sysctl，跨环境对齐先看这两个值。
:::
:::

::: method 回忆 11 · `readlink` 与 `realpath` 的边界
`readlink` 返回值怎么读、加 `\0` 吗？`buf` 太小会报错吗？`realpath` 为什么不能做安全检查？
::: sol 答案
`readlink` 返回写入 `buf` 的**字节数**，**不加终止 `\0`**（调用者自己补）；`buf` 太小时**截断不报错**、返回 `bufsiz`——所以要判断 `n == bufsiz` 换更大的缓冲区重试。Linux 未定义 `SYMLINK_MAX`，实践中按 `PATH_MAX` 开缓冲。`realpath` 解析全部符号链接与 `.`/`..` 得绝对路径（`resolved` 传 NULL 由 libc 分配，glibc 扩展、SUSv4 已定义），但它同样是**快照**：解析完到 `open` 之间路径仍可能被换掉，安全锚定要用 `open(dir)` + `openat(dirfd, name, O_NOFOLLOW)`。
:::
:::

## C. inotify 与取证

::: method 回忆 12 · inotify 的基本模型与三个限制
inotify 的使用四步是什么？「会合并、会溢出、不递归」各是什么现象、怎么应对？
::: sol 答案
四步：`inotify_init1(IN_CLOEXEC|IN_NONBLOCK)` 建实例得 fd → `inotify_add_watch(fd, path, mask)` 加监控得 `wd` → 对 fd `read` 取 `struct inotify_event` 数组 → `close(fd)` 自动清掉全部 watch。合并：新事件与队列**尾部**事件的 `wd/mask/cookie` 全同则被丢弃——同一文件连写 100 次可能只收 1 次 `IN_MODIFY`，所以不能计数、不能当逐条日志。溢出：队列超 `max_queued_events`（默认 16384）后事件丢失、放入 `IN_Q_OVERFLOW`（`wd=-1`），正确反应是**全量重扫**再继续增量。非递归：`add_watch` 只管指定目录本身；子目录要自己加，新目录靠 `IN_CREATE|IN_ISDIR`/`IN_MOVED_TO|IN_ISDIR` 事件补加，且加完后再扫一遍补「遍历与加 watch 之间」的窗口。
:::
:::

::: method 回忆 13 · 事件读取的缓冲区纪律
一次 `read` 返回什么？每个事件占多少字节？缓冲区最小多大？`len` 字段和 `strlen(name)` 什么关系？
::: sol 答案
一次 `read` 返回缓冲区里装得下的**若干个完整事件**（个数 = min(已排队事件, 缓冲区容量)），按 `sizeof(struct inotify_event) + ev->len` 逐个推进，**不能**按 `sizeof(struct dirent)` 或固定步长跳。缓冲区最小 `sizeof(struct inotify_event) + NAME_MAX + 1`，小于一个完整事件 `read` 返回 `EINVAL`（内核 2.6.21 前返回 0）。`len` 是 name 字段的分配长度，含 NUL **与对齐填充**，可能大于 `strlen(name)+1`；监视对象自身的事件（如 `IN_DELETE_SELF`）`len==0`、无 name。
:::
:::

::: method 回忆 14 · `IN_IGNORED`、`wd` 复用与权限一次性检查
什么时候收到 `IN_IGNORED`？为什么收到后必须删 `wd→path` 映射？`IN_ONESHOT` 触发后有 `IN_IGNORED` 吗？`inotify_add_watch` 的读权限检查在什么时候做？
::: sol 答案
三种来源：显式 `inotify_rm_watch`；受监控对象被删（`IN_DELETE_SELF` 之后）；所在文件系统被卸载（`IN_UNMOUNT` 之后）。`IN_ONESHOT` 触发后 watch 自动消失但**不产生** `IN_IGNORED`——不要等它来清理。`wd` 是实例内的小整数，watch 移除后**会被复用**：映射不删，新 watch 的事件会被认成旧路径——这是「事件错配到错误目录」的典型来源。读权限在 `inotify_add_watch` 时**一次性**检查：之后即使权限被收走，事件照发不误（监控的是 inode，不是每次操作重新鉴权）。
:::
:::

::: method 回忆 15 · rename 事件的配对与 watch 的挂载点
`IN_MOVED_FROM`/`IN_MOVED_TO` 怎么配对？同目录内改名产生几个事件？watch 挂在路径还是 inode 上、rename 被监控对象后 watch 还有效吗？
::: sol 答案
两事件的 `cookie` 字段值相同（目前**只有** rename 用 cookie；其他事件 cookie==0）。同目录内改名也产生两个事件（同一 wd 两条，cookie 相同）；跨目录时分别来自源目录与目标目录的 watch。顺序有保证：`IN_MOVED_FROM` 一定先于 `IN_MOVED_TO`（事件队列有序）。watch 挂在 **inode** 上（`fsnotify_add_inode_mark`），不是路径字符串上——所以 rename 被监控对象后 watch 依然有效，只是会另发一个 `IN_MOVE_SELF` 告诉你「对象本身被移走了」。
:::
:::

::: method 回忆 16 · 三道上限与排障顺序
`/proc/sys/fs/inotify/` 下三个文件各限什么？`inotify_add_watch` 返回 `ENOSPC` 是磁盘满吗？收不到事件按什么顺序排障？
::: sol 答案
`max_queued_events`（默认 16384，`inotify_init` 时生效、溢出发 `IN_Q_OVERFLOW`）；`max_user_instances`（默认 128，每真实 UID 的实例数）；`max_user_watches`（默认 8192 或更高，每真实 UID 的 watch 总数——大树上递归监听最先撞的是它）。`ENOSPC` 这里是 **watch 配额耗尽**，不是磁盘满。排障顺序：`add_watch` 失败先分 `ENOENT`（路径消失）/`ENOTDIR`（`IN_ONLYDIR`）/`EACCES`（无读权限）/`ENOSPC`（配额）；收不到事件先确认监视对象是目录还是文件、子目录是否单独加过 watch；事件太少查尾部合并；事件丢失查 `IN_Q_OVERFLOW`；`wd` 错乱查 `IN_IGNORED` 后是否删了映射。`ioctl(fd, FIONREAD, &n)` 可查当前排队字节数。
:::
:::

::: method 回忆 17 · `getdents64` 与内核路径
`readdir(3)` 底层是什么调用？内核返回的是数组还是变长记录？`d_off` 是什么？ext4 的 htree 对顺序有什么影响？
::: sol 答案
底层是 `getdents64(2)`（`fs/readdir.c` 的 `iterate_dir` → 文件系统的 `iterate_shared`，ext4 是 `ext4_readdir`）。内核返回**变长记录**：每条 `struct linux_dirent64`（`d_ino`/`d_off`/`d_reclen`/`d_type`/`d_name[]`），记录按 8 字节对齐所以 `d_reclen` ≥ 头部+名字；调用者必须按 `d_reclen` 推进。`d_off` 是**不透明**的下一项位置值，只配 `telldir`/`seekdir` 用，不是字节偏移、不跨文件系统可移植。htree 目录按哈希序返回——`readdir` 顺序既不是字母序也不是 inode 序的根因。
:::
:::

::: method 回忆 18 · 目录流与 fd 的关系
`opendir` 返回的 `DIR *` 底下藏着一个 fd 吗？`opendir` 对它设了什么标志？`fdopendir` 之后 fd 归谁管？`dirfd` 有什么用？
::: sol 答案
有，每个目录流对应一个打开的目录 fd。`opendir` 自动给它设 `FD_CLOEXEC`（SUSv3 要求，exec 时自动关闭——别手动补）。`fdopendir(fd)` 成功后 **fd 归 `DIR` 管理**：不能再单独 `close(fd)`，`closedir` 统一关——双重 close 是 bug。`dirfd(dir)` 取出底层 fd：可传给 `fstatat` 补 `DT_UNKNOWN`、传给 `fchdir` 切换工作目录、当 `*at` 家族的 `dirfd` 用——「以目录 fd 为锚点」的入口。
:::
:::

::: method 回忆 19 · `scandir` 与 `fts` 的定位
什么时候用 `scandir`？`fts` 与 `nftw` 的模型差在哪？`fts_read` 对一个目录返回几次？
::: sol 答案
`scandir`：要**排序后的单目录列表**时用（`alphasort` 受 locale 影响、`versionsort` 处理 `file2 < file10`），它一次性分配整个数组，`namelist` 与每个元素都要 `free`。`fts` 是**句柄+迭代**模型（`fts_open`/`fts_read`/`fts_set`/`fts_close`），`nftw` 是回调模型——`fts` 能在遍历中决定跳过（`fts_set(FTS_SKIP)`）、先看一层再决定递归（`fts_children`），灵活性最高。`fts_read` 对目录返回**两次**：前序 `FTS_D`、后序 `FTS_DP`；文件与符号链接各一次。错误分两层：单条目失败返回有效 `FTSENT`（`fts_info` 为 `FTS_DNR`/`FTS_ERR`/`FTS_NS`），整体失败才返回 NULL 并设 `errno`——所以循环里每次都要 `errno = 0`。
:::
:::

::: method 回忆 20 · 符号链接的解引用规则
哪些调用解引用符号链接、哪些不解？路径中间的目录部分呢？内核允许的解引用层数是多少？
::: sol 答案
解引用（对目标操作）：`stat`/`open`/`chmod`/`chown`/`unlink` 之外的大多数——`unlink`、`rename`、`rmdir`、`readlink`、`link`（Linux）**不解引用**。路径中间的**目录部分总是解引用**（`/somedir/file` 里 `somedir` 是链接一定跟过去），分野只在最后一段。层数：路径名中每个符号链接部件至少 `_POSIX_SYMLOOP_MAX`（8）次、整条路径总共 40 次（本机实测第 40 层过、第 41 层 `ELOOP`）——超限即 `ELOOP`，防的是链接成环与堆栈溢出。ext 系还有 fast symlink 优化：目标字符串 ≤60 字节时直接存进 inode 的数据块指针区，不占数据块。
:::
:::

::: method 回忆 21 · `strace` 看什么
怎么确认程序读目录用的是 `getdents64`？glibc 的 `opendir` 一次向内核要多少字节？`/proc` 里怎么数 inotify 实例？
::: sol 答案
`strace -e trace=openat,getdents64,close ./prog`（本机 strace 6.8 要**显式列调用名**，`%stat` 这类调用类会静默匹配不到）：看到 `getdents64(fd, 0x..., 32768) = 80` 与 `= 0`（读完）即可确认；32768 是 glibc `DIR` 内部缓冲的大小，80 是一次取到的多条变长记录总字节。`-yy` 把 fd 映射成路径方便对照。inotify 实例是匿名 inode：`find /proc/*/fd -lname 'anon_inode:inotify' | wc -l` 免特权可数（同用户范围内）。本机 `strace -p` 被 `ptrace_scope=1` 挡，一律「在 strace 下启动」目标程序。
:::
:::
