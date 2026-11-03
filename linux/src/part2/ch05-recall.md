# 2.5 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。22 张卡分三组：**A 组考字段、大小与时间（2.5.1–2.5.4、2.5.8、2.5.10）**，**B 组考 xattr、`statx`、`statvfs` 与 inode 标志（2.5.5、2.5.7、2.5.9、2.5.11、2.5.12）**，**C 组考 ACL、内核路径与取证（2.5.6、2.5.13–2.5.16）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 字段、大小与时间

::: method 回忆 1 · 四个 `stat` 变体与五种失败
`stat`/`lstat`/`fstat`/`fstatat` 各在什么时候用？`fstatat` 的两个关键 flag 是什么？`ENOENT`、`EACCES`、`ELOOP`、`ENAMETOOLONG`、`EOVERFLOW` 各对应什么现场？
::: sol 答案
`stat` 跟随符号链接看目标；`lstat` 看链接本身（`S_IFLNK`）；`fstat` 用已打开的 fd，不受路径重解析影响；`fstatat(dirfd, path, ...)` 相对 `dirfd` 解析，不受进程 `cwd` 变化影响，`AT_SYMLINK_NOFOLLOW` 等价于 `lstat`，`AT_EMPTY_PATH` 对 `dirfd` 本身取属性。成功返回 0，失败 -1。`ENOENT` 路径或中间某级不存在；`EACCES` 路径中某级目录缺搜索权限；`ELOOP` 符号链接层数超上限（本机实测：第 40 层能过、第 41 层报 `ELOOP`）；`ENAMETOOLONG` 路径或某段过长；`EOVERFLOW` 文件大小或 inode 号超出 `struct stat` 可表示范围（32 位程序读大文件）。写库代码优先 `fstat`/`fstatat`：路径检查和打开之间没有可被替换的窗口。
:::
:::

::: method 回忆 2 · 十二个字段各自谁写
`st_dev`、`st_ino`、`st_mode`、`st_nlink`、`st_uid`/`st_gid`、`st_rdev`、`st_size`、`st_blksize`、`st_blocks`、三个时间——逐个说「谁在什么时候改它」。判断「两个路径是不是同一个文件」用哪两个字段？
::: sol 答案
`st_dev`+`st_ino` 是文件在当前命名空间里的身份，只在**同一设备内**唯一，比较 `(dev, ino)` 而不是路径字符串；跨挂载点/绑定挂载要靠 `statx` 的 `stx_mnt_id`。`st_mode` 由 `chmod`、`chown`、创建时写；`st_nlink` 由 `link`/`unlink`；`st_uid`/`st_gid` 由 `chown`；`st_rdev` 只对块/字符设备有意义；`st_size` 由 `write`/`truncate`；`st_blksize` 由文件系统决定（是建议的 I/O 大小）；`st_blocks` 随实际分配变化；`atime` 由读（受挂载选项）、`mtime` 由写内容、`ctime` 由任何 inode 状态变更。`st_nlink==0` 不等于文件不存在——已删除但仍被打开的文件就是 0。
:::
:::

::: method 回忆 3 · 符号链接在 `lstat` 下长什么样
对指向 `/etc/hosts` 的符号链接做 `lstat`，`st_size`、`st_mode` 的类型位、`st_mode` 的权限位分别是什么？为什么不能用它判断目标文件的大小？
::: sol 答案
`st_size` 是链接目标字符串 `"/etc/hosts"` 的长度（10 字节），不是目标文件的大小；类型位是 `S_IFLNK`（`ls -l` 的 `l`）；符号链接自身的权限位在 Linux 上没有意义，`lstat` 通常报 `0777`。要目标的属性就用 `stat` 或 `fstatat(..., 0)`。本机复跑：`showstat` 对一个指向 `/etc/hosts` 的链接打印 `type=l size=10`，对目标打印 `size=235`。
:::
:::

::: method 回忆 4 · `st_mode` 的位布局与判类型的唯一正确姿势
`st_mode` 的高位与低位分别装什么？为什么判类型必须用 `S_IS*()` 宏而不能写 `(st.st_mode & 0170000) == 0100000`？`chmod` 能改类型位吗？
::: sol 答案
Linux 用高位表示类型（`S_IFMT`，0xF000），低 12 位是权限与特殊位（setuid/setgid/sticky + 九个 `rwx`）。SUSv3 没规定类型位的具体值，不同系统的编码可以不同，所以只用 `S_ISREG`/`S_ISDIR`/`S_ISLNK`/`S_ISCHR`/`S_ISBLK`/`S_ISFIFO`/`S_ISSOCK` 这组宏。`chmod` 只传低 12 位，类型位被忽略；`S_ISSOCK` 判出的 socket 文件也不能用 `chmod` 改出别的类型。
:::
:::

::: method 回忆 5 · 内核的权限检查顺序
写出 `open`/`exec`/`mkdir` 时的四步检查。目录的 `r`、`w`、`x` 各自控制什么？只给 `r` 不给 `x`、只给 `x` 不给 `r` 分别是什么现象？
::: sol 答案
① `euid==0` 时读写直接放行，执行要求至少有一个 `x` 位（或用 `CAP_DAC_OVERRIDE`/`CAP_DAC_READ_SEARCH`）；② `euid==st_uid` 用 owner 三位；③ `egid==st_gid` 或属组在辅助组里，用 group 三位；④ 否则用 other 三位。**第一个命中的类别就出结果**，不会换一组再试。目录：`x` 是「能否穿过/按路径访问」，`r` 是「能否列出名字」，`w` 是「能否增删目录项」。只 `r` 不 `x`：`ls` 能看到名字但 `stat` 失败（`EACCES`）；只 `x` 不 `r`：知道确切路径就能访问，但列不出目录内容。
:::
:::

::: method 回忆 6 · `umask` 的时机与共享，`access()` 的两个问题
`umask` 在什么时候起作用、影响哪些调用？为什么它是进程级而不是线程级？`access()` 判的是哪个身份、为什么不能拿它做安全检查？
::: sol 答案
`umask` 只在**创建**时起作用：`open(..., O_CREAT, 0666)` 的实际权限是 `0666 & ~umask`，`mkdir`、`mkfifo`、`mknod` 同样受它影响；对已存在的文件用 `chmod` 才是直接设值。`umask(2)` 返回旧值且永不失败；它是进程级状态，工作线程里改它会影响同进程其他线程，所以启动时设一次、或创建后显式 `fchmod`。`access()` 用 **real** UID/GID，`open()` 用 **effective**，setuid 程序里两者可以相反；按 effective 检查要用 `faccessat(AT_FDCWD, path, mode, AT_EACCESS)`。第二个问题是检查与打开之间的 TOCTOU 窗口：中间文件可能被替换或改权限。安全做法是不预检，直接 `open` 并处理 `EACCES`。
:::
:::

::: method 回忆 7 · 三个大小字段与稀疏文件
`st_size`、`st_blocks`、`st_blksize` 分别回答什么问题？单位各是什么？一个 `truncate -s 1G` 的文件，三者的读数是多少、`du` 显示什么？
::: sol 答案
`st_size` 是逻辑大小（字节），`st_blocks` 是**已分配的 512 字节块数**（与 `st_blksize` 无关），实际占用 = `st_blocks * 512`；`st_blksize` 是文件系统给的「最优 I/O 块大小」，只是建议值。本机实测 ext4：`truncate -s 1G sparse.img` 后 `size=1073741824`、`blocks=0`、`du -h` 显示 0，而 C 侧 `lstat` 给的 `st_blksize=4096`。空洞读出来是 0 且不触发磁盘 I/O；要真正分配用 `fallocate`。所以 `ls -l` 与 `du` 打架时，先算 `st_blocks*512`。注意：`stat -c %B` 在本机对任何文件都打印 512，不能用它读 `st_blksize`（见[勘误页](ch05-errata.md)）。
:::
:::

::: method 回忆 8 · 三个时间戳谁能写、谁能设
`atime`/`mtime`/`ctime` 各在什么时候更新？哪两个能用 `utimensat` 设、哪个不能？`ctime` 到底是「什么时间」？`rename` 之后哪几个变了？
::: sol 答案
`atime`：`read`、`exec`、`readdir`、`mmap` 读（还要看挂载选项）；`mtime`：`write`、`truncate`、共享映射写；`ctime`：**inode 状态改变时间**，`chmod`/`chown`/`link`/`unlink`/`rename`/`setxattr` 都更新它，写内容时连同 `mtime` 一起更新。`utimensat`/`futimens` 能设 atime 与 mtime（`times[0]`/`times[1]`，特殊值 `UTIME_NOW`/`UTIME_OMIT`），**没有任何接口能设 ctime**——你一改它它就变成「现在」。`touch -a` 只改 atime、`touch -m` 只改 mtime、`touch -d` 两个都改，三者的 ctime 都会变成现在。本机实测 `rename`：文件 `ctime` +1、`mtime`/`atime` 不变，父目录的 `mtime` 和 `ctime` 都变。
:::
:::

::: method 回忆 9 · `relatime` 与另外三种 atime 策略
四种挂载选项分别做什么？`relatime` 下 `cat` 一次文件 atime 会不会变？怎么确认本机在用哪一种？做「访问审计」能不能靠 atime？
::: sol 答案
`strictatime` 每次读都更新；`relatime`（默认）只在 atime 早于 mtime/ctime、或超过 24 小时时才更新；`noatime` 完全不更新；`lazytime` 只改内存里的时间戳，回写时才落盘（崩溃可能丢）。所以 `relatime` 下大多数 `cat` 后 atime **不变**——本机实测两次连续读，atime 秒数一动不动；把 atime 设成很久以前再读，它才跳到「现在」。看当前策略用 `findmnt -T /path -o OPTIONS`（本机 `/` 与 `/tmp` 都是 `rw,relatime`）。结论：atime 不能当访问审计用，也不能用来判断「文件有没有被读过」。
:::
:::

::: method 回忆 10 · `chmod`/`chown` 的连带后果
`chown` 成功之后 mode 位会发生什么？非特权用户能把属组改成任意组吗？`fchmodat` 的 `AT_SYMLINK_NOFOLLOW` 在这台机器上什么行为？setuid/setgid/sticky 三个特殊位分别对文件与目录做什么？
::: sol 答案
`chown` 成功会**清掉 setuid/setgid 位**（安全设计；本机实测普通属主 `chmod 4755` 后改组，mode 变回 `0755`）。非特权用户不能改属主，只能把属组改成**自己所属的组**：本机 `lchown` 改成 `adm`(4) 成功，改成 `root`(0) 报 `EPERM`，改 uid 同样 `EPERM`。`fchmodat(..., AT_SYMLINK_NOFOLLOW)` 本机实测返回 `ENOTSUP`（`Operation not supported`），也就是内核不支持「改符号链接自身的权限」，`chmod` 只能跟随链接。特殊位：`S_ISUID` 执行时 euid=文件属主、`S_ISGID` 执行时 egid=属组，对目录则是新建项继承属组；`S_ISVTX` 对目录是 sticky（只有属主/目录属主/root 能删）。
:::
:::

## B. xattr、`statx`、`statvfs` 与 inode 标志

::: method 回忆 11 · 四个 xattr 命名空间与谁能写
`user.*`、`trusted.*`、`security.*`、`system.*` 分别谁能读写、典型用途是什么？为什么 `user.*` 不允许用在符号链接上？ACL 存在哪个命名空间？
::: sol 答案
`user.*`：文件属主（受文件权限约束），放应用自定义元数据；`trusted.*`：`CAP_SYS_ADMIN`，系统级标记；`security.*`：LSM 与特权进程，SELinux label、`security.capability`；`system.*`：内核，POSIX ACL 就住在 `system.posix_acl_access`，目录的默认 ACL 在 `system.posix_acl_default`。符号链接对所有人都是「跟随即可访问」，无法用权限阻止别人往里塞东西，所以 `user.*` 只允许普通文件与目录；sticky 目录（如 `/tmp`）里非属主也不能加。本机实测：`trusted.foo` 与 `security.foo` 都返回 `EPERM`，对符号链接 `lsetxattr` 也返回 `EPERM`，对 root 拥有的 `/etc/hosts` 加 `user.*` 同样 `EPERM`。
:::
:::

::: method 回忆 12 · xattr API 的返回语义与正确重试
`setxattr`/`getxattr`/`listxattr`/`removexattr` 分别返回什么？两个 `flags` 常量各在什么时候失败？「先问大小再取」的标准两步法有什么竞态，怎么处理？
::: sol 答案
`setxattr`/`removexattr` 返回 0/-1；`XATTR_CREATE`（已存在则 `EEXIST`）、`XATTR_REPLACE`（不存在则 `ENODATA`）、`0` 是创建或替换。`getxattr` 成功返回**值的长度**，缓冲区不够返回 -1/`ERANGE`，属性不存在返回 -1/`ENODATA`，文件系统不支持 xattr 返回 `ENOTSUP`。`listxattr` 返回名字列表的总字节数，名字之间以 `\0` 分隔，没有任何属性时返回 0（此时 `malloc(0)` 可能给 NULL，要单独处理）。两步法（`getxattr(path,name,NULL,0)` 取长度 → 分配 → 再取）仍有竞态：第二次调用前属性可能变大或被删，所以要**循环处理 `ERANGE`**，或干脆按上限分配。本机实测：值 7 字节时 `getxattr(buf,3)` 报 `ERANGE`，`getxattr(buf,0)` 返回 7（相当于问大小）。
:::
:::

::: method 回忆 13 · xattr 的三条天花板与「拷不拷得走」
名字、值、总量各自的上限是多少、由谁决定？为什么 `listxattr` 里有的名字 `getxattr` 会失败？`cp -a`、`tar`、`rsync` 分别要什么参数才带走 xattr 与 ACL？
::: sol 答案
VFS 层对所有文件系统规定：名字 ≤ 255 字节、值 ≤ 64 KiB、所有 xattr 的总和受 inode 可用空间限制——最后这条才是真正的天花板，由文件系统与 blocksize 决定。`listxattr` 出于安全可能省略调用者无权读的名字（如 `trusted.*`），加上两次调用之间属性可能被删，所以「列出来但读不到」是正常现象。传输侧：GNU `cp -a`（等价 `--preserve=all` 的一部分）会带 xattr 与 ACL，`tar` 要 `--xattrs`（ACL 另有 `--acls`），`rsync` 要 `-X`/`-A`；目标是 VFAT/exFAT 这类不支持的文件系统时会静默退化。本机实测的 ext4 数字（见[勘误页](ch05-errata.md)第 3 节）：3000 字节的值能放，第二个 3000 就 `ENOSPC`；4096 字节的单个值 `ENOSPC`，4000 可以；66000 字节报 `E2BIG`；名字超 255 报 `ERANGE`。
:::
:::

::: method 回忆 14 · `statx` 补了什么、为什么先读 `stx_mask`
`stat` 缺哪些信息，`statx` 怎么补？三个 `AT_STATX_*` 分别什么语义？旧内核上会发生什么？为什么 `stx_btime` 是 0 不能直接念成「1970 年创建」？
::: sol 答案
`statx`（Linux 4.11，glibc 2.28）补上创建时间 `btime`、挂载 ID `mnt_id`、直接 I/O 对齐 `dioalign`、属性位，并且允许调用者只请求需要的部分：`statx(dirfd, path, flags, mask, &stx)`。`AT_STATX_SYNC_AS_STAT` 是默认缓存行为，`AT_STATX_FORCE_SYNC` 强制回源（网络文件系统才有意义），`AT_STATX_DONT_SYNC` 只读缓存。请求的 `mask` 是「我要什么」，返回的 `stx_mask` 是「实际给了什么」，文件系统不支持的位会被清掉——所以**先看 `stx_mask` 再读字段**，`STATX_BTIME` 位没置时 `stx_btime` 无意义，可能是 0。旧内核没有 `statx` 会返回 `ENOSYS`，必须回退到 `stat`/`fstatat`。
:::
:::

::: method 回忆 15 · `stx_attributes` 与 `chattr` 的对应，`STATX_ALL` 的陷阱
哪几个属性位对应 `chattr` 的字母？`STATX_BASIC_STATS` 和 `STATX_ALL` 各是什么、为什么别依赖后者？`mnt_id` 拿来干什么？
::: sol 答案
`STATX_ATTR_COMPRESSED`↔`c`、`IMMUTABLE`↔`i`、`APPEND`↔`a`、`NODUMP`↔`d`；`ENCRYPTED`、`VERITY`、`DAX`、`AUTOMOUNT`、`MOUNT_ROOT` 没有对应的 `chattr` 字母。`STATX_BASIC_STATS` 是常用基础字段的集合；`STATX_ALL` 是「全部」的**历史别名**，新加的字段（如 `STATX_DIOALIGN`，Linux 6.1+）不在它里面，请求它拿不到新字段。`stx_mnt_id` 能和 `/proc/self/mountinfo` 第一列对上，用来区分绑定挂载——同一个 inode 在不同挂载点上可能有不同的 `st_dev`，只有 `mnt_id` 能说清「哪一次挂载」。
:::
:::

::: method 回忆 16 · `statvfs` 的字段与 `df` 的口径差
`statvfs` 和 `stat` 分别描述什么？算剩余空间用哪个字段？`f_bfree` 与 `f_bavail` 差在哪？判断「普通用户还能写多少」用哪个？
::: sol 答案
`stat`/`statx` 描述**一个文件**，`statvfs(fd/path, &buf)` 描述**这个文件所在的文件系统**。算空间要用 `f_frsize`（片段大小）而不是 `f_bsize`：总量 = `f_blocks * f_frsize`，可用 = `f_bavail * f_frsize`。`f_bfree` 是含 root 保留块的空闲数，`f_bavail` 已把保留块（通常 5%）扣掉，所以判断非特权用户还能写多少只能用 `f_bavail`。`df` 的显示口径与它不同（默认按 1K 块折算），两边数字对不上时先统一单位。其余字段：`f_files`/`f_ffree`/`f_favail` 是 inode 总数/空闲/可用，`f_namemax` 是文件名最大长度。
:::
:::

::: method 回忆 17 · inode 标志怎么读写，immutable 挡住谁
`chattr` 那套标志程序里怎么用？`FS_IMMUTABLE_FL` 设置后哪些操作会失败、root 能绕过吗？`FS_APPEND_FL` 和 `O_APPEND` 差在哪？属主是不是什么标志都能设？
::: sol 答案
用 `ioctl(fd, FS_IOC_GETFLAGS, &flags)` 读、`FS_IOC_SETFLAGS` 写。`immutable`（`i`）一旦设置，`write`、`truncate`、`chmod`、`chown`、`unlink`、`link`、`rename`、`setxattr` 全部返回 `EPERM`，**包括 root**——必须先 `chattr -i`，而这需要 `CAP_LINUX_IMMUTABLE`。`append`（`a`）是 inode 级强制：不以 `O_APPEND` 打开写就失败，`truncate` 也失败；`O_APPEND` 只是每次打开时的选项，管不住别人。权限分工上不是「属主全能设」：`i`/`a` 要 capability，`d`/`A`/`S`/`D`/`T` 属主通常可以，`j` 要 `CAP_SYS_RESOURCE`。本机实测（无 sudo）：ext4 上 `FS_NODUMP_FL` 能加能清（`0x80000`→`0x80040`→`0x80000`），`chattr +i` 报 `Operation not permitted`；`lsattr` 显示的 `e`（extent）是只读展示位，不能用 `chattr` 设。tmpfs 支持一部分标志（本机 `FS_IOC_GETFLAGS` 返回 0，`NODUMP` 也能设）。
:::
:::

## C. ACL、内核路径与取证

::: method 回忆 18 · ACL 的六类条目与 mask 的定义
`getfacl` 的六行分别是什么？`mask` 限制谁、不限制谁？`chmod g=...` 在有扩展 ACL 时改的是什么？`ls -l` 的组权限位念的是哪一个？
::: sol 答案
六类：`user::`（属主）、`user:名字:`（命名用户）、`group::`（属组）、`group:名字:`（命名组）、`mask::`、`other::`。**`mask` 是所有命名用户、命名组和 `group::` 的有效权限上限**，对 `user::` 与 `other::` 不起作用。有扩展 ACL 时，`chmod` 改的组位是 mask，不是 `group::`：`chmod 640` 会把 mask 压成 `r--`，于是条目仍写 `rw-` 的 alice 实际只能读（`getfacl` 标 `#effective:r--`）。`stat -c %a`/`ls -l` 的组三位显示的就是 mask，所以要恢复就 `setfacl -m m::rw file`（`setfacl -n` 可以不让它重算 mask，但那是非默认用法）。
:::
:::

::: method 回忆 19 · ACL 在磁盘上长什么样，内核按什么顺序判
扩展 ACL 存在哪里、多少字节一条？六个 tag 的取值与 `e_id` 的哨兵值？把内核的匹配顺序完整说一遍，并指出「组匹配上了但权限不够」会发生什么。
::: sol 答案
最小 ACL（只有 owner/group/other）不占 xattr，直接住在 `st_mode` 的 9 位里；一旦有扩展条目，就写进 `system.posix_acl_access`（目录的默认 ACL 在 `system.posix_acl_default`）。格式是 4 字节头（version=2）+ 每条 8 字节（`e_tag` 2、`e_perm` 2、`e_id` 4），`e_perm` 是 4=读、2=写、1=执行 的位或，`e_id` 只对 `ACL_USER`/`ACL_GROUP` 有意义，其余填 `0xffffffff`。tag：`USER_OBJ`=0x01、`ACL_USER`=0x02、`GROUP_OBJ`=0x04、`GROUP`=0x08、`MASK`=0x10、`OTHER`=0x20。检查顺序（`posix_acl_permission`）：① root 特例；② euid 命中属主 → 用 `USER_OBJ`；③ euid 命中某 `ACL_USER` → 该条目 **& mask**；④ egid 或辅助组命中 `GROUP_OBJ` 或某个 `ACL_GROUP` → 该条目 **& mask**，只要有一个匹配的组条目授予了请求权限就通过，否则**直接拒绝，不会再落到 `OTHER`**；⑤ 都不命中才用 `OTHER`。本机实测 `chmod 640` + `setfacl -m u:self:rw` 的文件，dump 出来正是 44 字节 5 条。
:::
:::

::: method 回忆 20 · libacl 的用法与两个必须记住的时机
`acl_get_file` 失败怎么取错误？`ACL_TYPE_DEFAULT` 用在哪？为什么 `acl_calc_mask()` 必须在 `acl_set_file` 之前？返回的文本怎么释放？
::: sol 答案
`acl_get_file(path, type)` 失败返回 NULL，错误看 `errno`（`ENOENT`、`ENOTSUP`、`EACCES`）；`type` 是 `ACL_TYPE_ACCESS`（访问 ACL）或 `ACL_TYPE_DEFAULT`（只能用于目录）。用 `acl_create_entry` → `acl_set_tag_type` → `acl_set_qualifier`（传 `uid_t`/`gid_t` 指针）→ `acl_get_permset`/`acl_add_perm`/`acl_set_permset` 组装条目，然后**必须 `acl_calc_mask(&acl)` 再 `acl_set_file`**，否则可能写入一个 mask 与条目不一致的 ACL。`acl_to_text` 返回的字符串要用 `acl_free` 释放，`acl_t` 本身也要 `acl_free`。`acl_set_file` 需要你是文件属主或有 `CAP_FOWNER`，否则 `EPERM`；FAT/exFAT 不支持会 `ENOTSUP`。编译要 `-lacl`（本机头与库都在，直接可链）。
:::
:::

::: method 回忆 21 · `setfacl`/`getfacl` 的常用选项与备份恢复
`-m`、`-x`、`-b`、`-k`、`-d`、`--set`、`-R`、`-p` 各做什么？`-n` 在两条命令里为什么含义不同？怎么把一棵子树的 ACL 备份再恢复？
::: sol 答案
`setfacl -m` 修改/增加条目、`-x u:alice` 只删那一条（不动 base 三项）、`-b` 删所有扩展条目（保留最小 ACL）、`-k` 删默认 ACL、`-d` 操作默认 ACL、`--set` 整体替换、`-R` 递归。`getfacl -a`/`-d` 只看访问/只看默认，`-R` 递归，`-n` 显示数字 UID/GID，`-t` 表格化，`-p` 保留绝对路径。`-n` 是个陷阱：在 `getfacl` 里是「显示数字 ID」，在 `setfacl` 里是「不要重算 mask」。备份恢复：`getfacl -R -p /srv > acl.bak` 之后 `setfacl --restore=acl.bak`；复制 ACL 用 `getfacl file1 | setfacl --set-file=- file2`。本机实测：`-b` 把文件恢复成普通 mode（如 `664`），`-k` 让目录的 `default:` 行消失。
:::
:::

::: method 回忆 22 · 创建路径、内核分界与排障顺序
有默认 ACL 的目录里新建文件，权限由谁决定？`statx`/xattr/ACL 三条调用分别经过内核哪些层，「VFS 拒绝」和「文件系统拒绝」怎么分？元数据排障的固定顺序是什么？
::: sol 答案
父目录没有默认 ACL 时，`mode & ~umask` 决定权限、最小 ACL 写在 mode 位里；**有默认 ACL 时 POSIX 忽略 `umask`**：新文件继承默认 ACL 的条目，`mode` 里没请求的权限会从 `USER_OBJ`、`MASK`、`OTHER` 中清掉，`umask` 不再单独决定结果。子目录还会把父目录的默认 ACL 继承为自己的默认 ACL。内核侧：`statx` 走 `__do_sys_statx`→`do_statx`→`vfs_statx`/`vfs_getattr`→`security_inode_getattr`→`ext4_getattr`/`generic_fillattr`→`cp_statx`；xattr 走 `fs/xattr.c` 的 `xattr_permission` 再到 `ext4_xattr_get`（inode 内或外部块），写入在日志事务里；ACL 读取走 `get_acl`→`posix_acl_from_xattr`，判定走 `generic_permission`→`acl_permission_check`→`posix_acl_permission`，继承走 `posix_create`→`posix_acl_create_masq`。VFS 层先做权限、命名空间与锁的通用检查，所以同一调用在 ext4 与 NFS 上错误码可能不同（`EOPNOTSUPP` 对 `ENOTSUP`）。排障顺序固定五步：`stat`/`statx` 看基础字段与 `stx_mask` → `getfacl`+`lsattr`+xattr 看三类扩展 → `findmnt` 看挂载选项 → `strace` 看程序实际调了什么、返回什么 `errno` → 跨容器时对照 `/proc/PID/mountinfo` 与 `stx_mnt_id`。
:::
:::
