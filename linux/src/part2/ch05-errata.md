# 2.5 勘误与版本注记

这一页收本章最容易「换一个内核版本、换一个文件系统、换一台机器就不成立」的东西：xattr 与 ACL 的容量上限、btime 的支持面、时间戳的更新条件、`fchmodat` 对符号链接的行为、外部工具的有无。正文每节里的 errata 盒讲**理解陷阱**（把 A 当成 B）；这一页讲**搬家陷阱**（在这台机器上成立、到那台机器上悄悄变）。页内所有实测读数都来自下面这台机器，**任何别的机器上的数字都不能引用**——上一批套件里出现过拿另一台 x86-64 的读数冒充本机结论的情况，那类数字在本章一律作废。

**本章基线**：Ubuntu 24.04.5 虚拟机，**aarch64（ARM64）**，内核 `7.0.0-38-generic`，GCC 13.3.0（`cc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0`），glibc 2.39，4 vCPU，页大小 4096；`/` 与 `/tmp` 在 `/dev/sda2` **ext4** 上（挂载选项 `rw,relatime`），`/dev/shm` 是 tmpfs。`sudo` 与 `perf` 不可用；`ptrace_scope=1`。工具实测：`getfacl`/`setfacl`/`lsattr`/`chattr`/`strace`（6.8）可用，**`getfattr`/`setfattr` 未安装**；`cc -lacl` 可用，`<sys/xattr.h>` 由 libc6-dev 提供（不需要 attr 包）。写作机是 macOS（Apple 芯片 arm64）：没有 `/proc`、没有 `strace`，页大小 16384、`errno` 编号不同（如 `EAGAIN`=35 对 Linux 的 11），只当「换一个内核/libc 会怎样」的对照。正文实验一律回 Linux 做。

## 1. 二十四条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「`umask` 是给新文件设权限的，写 `027` 文件就是 `027`」 | `umask` 只在**创建那一刻**对请求的 mode 做 `mode & ~umask` 的**减法**：`open(..., 0666)` 在 `umask 027` 下得 `640`，不是 `027`；它不设任何位，也不影响已存在的文件 | `umask 027; touch /tmp/lab2c05p_u.txt; stat -c %a /tmp/lab2c05p_u.txt` → `640`；再 `umask 777; chmod 666 同一文件` → 照样 `666`，`umask` 碰不到已有文件 |
| 「`umask` 只管 `open`」 | `mkdir`、`mkfifo`、`mknod` 全受它减位；它是**进程级**状态（不是线程级），工作线程里改它会影响同进程其他线程的创建动作 | `umask 077; mkdir /tmp/lab2c05p_d; stat -c %a .../lab2c05p_d` → `700`（请求 777 被减）；`man 2 umask` 的「进程级」段 |
| 「`fchmodat(..., AT_SYMLINK_NOFOLLOW)` 到处都能改符号链接的权限」 | 这条支持随内核与 libc 变：本机（内核 7.0.0-38、glibc 2.39）实测返回 `ENOTSUP`(95)，与正文一致；Linux 6.6+ 另有 `fchmodat2` 系统调用，glibc 2.39 没有它的包装，而符号链接本身在 Linux 上没有「权限」语义（`lstat` 恒显示 777）。换老内核/别的 libc 错误码与行为都可能不同 | 编译正文式探针：`fchmodat(AT_FDCWD, link, 0600, AT_SYMLINK_NOFOLLOW)` 打印 `errno`；`uname -r`；`man 2 fchmodat` 看 CAV 段（该 flag 的支持历史） |
| 「非特权用户 `chown` 能把文件给别人，或随便改组」 | 非特权只能**改组**、且只能改成**自己所属的组**；改属主一律 `EPERM`（改成自己也无效成功）。`CAP_CHOWN` 才放开 | 本机实测：`chown :adm 文件`（属于 adm）→ 0；`chown :65534 文件`（不属于）→ `Operation not permitted`；`chown root 文件` → `EPERM`；对照 `id` 的组列表 |
| 「`chown` 只动属主属组，别的都不碰」 | `chown` 成功会**清掉 setuid/setgid 位**——即使属主根本没变；本机实测 `chmod 4755` 后 `chown $USER:$USER` 得 `0755`。`chmod` 反过来不动属主属组 | `chmod 4755 f; chown $(id -u):$(id -g) f; stat -c %a f` → `755`；这是安全设计，提权程序 `chown` 一下就失效 |
| 「`stat` 的 `ctime` 就是创建时间；改不了文件时间」 | Linux 传统 `struct stat` **没有通用创建时间**；`ctime` 是 inode 状态改变时间（`chmod`/`chown`/`link`/`rename`/写内容都动它），且**不能手动设**。创建时间要 `statx` 的 `btime`，而 `btime` 依赖文件系统是否记录 | `stat -c 'm=%Y c=%Z' f` 前后对照；`chmod 600 f; sleep 2; stat -c 'm=%Y c=%Z' f` → m 不动 c 动；`statx` 看 `stx_mask` 的 `STATX_BTIME`(0x800) 位是否置 |
| 「读一次文件，`atime` 一定更新」 | 默认挂载是 `relatime`：atime 不晚于 mtime/ctime、或距今超过 24 小时才更新；`noatime` 干脆不更。本机实测新建文件第二次 `cat` 后 atime 纹丝不动 | `findmnt -T /tmp -o OPTIONS` → `rw,relatime`；`touch f; cat f >/dev/null; X1=$(stat -c %X f); cat f >/dev/null; stat -c %X f` 两次相同 |
| 「`st_blksize` 是文件系统块大小、恒等于 4096；`ls -l` 的大小就是磁盘占用」 | `st_blksize` 只是**建议 I/O 大小**，不是文件系统块大小；本机 ext4 普通文件、稀疏文件、目录、tmpfs 文件用 C 的 `lstat`/`statx` 读到的都是 4096。`st_blocks` 单位**固定 512 字节**、与 `st_blksize` 无关，占用 = `st_blocks*512`，所以稀疏文件的占用远小于 `st_size` | 三处对照：`showstat`（`lstat`）打印 `blksize=4096`；`stat -c '%b'` 乘 512 与 `du -h` 对账；`stat -f -c '%s'` 才是文件系统块大小的另一口径。**别用 `stat -c %B` 读 `st_blksize`**，见下一行 |
| 「`stat -c %B` 打印的就是 `st_blksize`，所以正文的 `blksize=512` 说明稀疏文件的块大小是 512」 | 本机（coreutils 9.4 + 内核 7.0.0-38 aarch64）`%B` 对**任何**文件都打印 512：稀疏文件、普通文件、目录、`/etc/hosts`、`/usr/bin/stat`、tmpfs 文件全是 512；同一 inode 用 `lstat`/`statx` 读到的 `st_blksize` 是 4096。正文那行读数「对得上」，但原因是 coreutils 的口径，不是稀疏造成的 | `for f in /etc/hosts /etc /dev/null $D/normal $D/sparse; do stat -c %B "$f"; done` → 清一色 512；`strace -e trace=statx stat -c %B /etc/hosts` 能看到 coreutils 用请求位为 0 的 `statx` 调用；同机 `./showstat` 给 4096 |
| 「`st_rdev` 也是设备号，跟 `st_dev` 差不多；inode 号全局唯一」 | `st_dev` 是文件**所在**文件系统的设备号，`st_rdev` 只对**设备文件本身**有意义（它指向的字符/块设备的主/次设备号）；`(st_dev, st_ino)` 只在同一设备内唯一，跨文件系统 inode 号可撞车 | `stat -c 'dev=%d rdev=%t:%T' /dev/null` → rdev=`1:3`；`stat -c '%d %i' 普通文件` 对照；不同挂载点各取一次 inode 号看是否可能相同 |
| 「谁都能给文件挂 xattr」 | 四个命名空间门槛不同：`user.*` 文件属主（受权限约束）；`trusted.*` 要 `CAP_SYS_ADMIN`——本机非特权实测 `EPERM`；`security.*` 归 LSM；`system.*` 归内核（ACL 就住在这）。`user.*` 还不允许挂在符号链接上：本机 `lsetxattr` 实测 `EPERM` | `setfattr`/自写程序对 `trusted.foo` 各试一次看 errno；`lsetxattr(link, "user.x", ...)` → `EPERM`；`man 7 xattr` 的 namespaces 段 |
| 「xattr 值最大 64 KiB，这个数到处一样」 | 64 KiB 只是 **VFS 层的单值上限**（本机超一点返回 `E2BIG`）；真正的总容量按文件系统算：ext4 的全部 xattr 要塞进 inode 所在的**一个块**（本机块 4096），塞不下返回 `ENOSPC`——本机一个 3000 字节的值还在，再写 4002 字节的值立刻 `ENOSPC`。tmpfs 有自己的上限，XFS 可以更大——换文件系统，能放多少整个重写 | `setxattr` 依次写 3000/4002/65536/65537 字节看 errno 序列；`stat -c %B` 之外用 `df -T`/`dumpe2fs -h`（要权限，按未实测）确认块大小 |
| 「ACL 条目可以随便加；上限就是 500 条」 | 上限是「文件系统实现 × 块大小」的乘积不是常数：本机 ext4 二分实测最多写进 **508 条**（与 Kerrisk「约 500」同一量级）；**tmpfs 能写 8192 条**（一路撞到 VFS 的 64 KiB 值上限才 `E2BIG`）；XFS 上限 25 条（本机无 XFS，未实测）。引用「500」必须带上 ext4/4 KiB 块 | 自写探针把 `system.posix_acl_access` 按 4+8n 字节构造后二分 `setxattr`，分别在 `/tmp`（ext4）与 `/dev/shm`（tmpfs）跑，报出各自失败点与 errno |
| 「文件系统都支持 ACL」 | 要内核 + 文件系统 + （老系统上）挂载选项三者齐：现代 ext4 默认开 `acl`，VFAT/exFAT 不支持直接 `ENOTSUP`；本机 tmpfs 实测 `setfacl` 可用。同一个调用换到 NFS/FUSE 上支持面完全不同 | `findmnt -T /tmp -o OPTIONS` 看有无 `acl`；`setfacl -m u:$USER:r /dev/shm/lab2c05p_aclt.txt && getfacl ...` → 成功；对 VFAT 盘试一次看 `ENOTSUP` |
| 「`chmod 640` 改的是属组权限」 | 文件带扩展 ACL 时，`chmod` 的 group 三位改的是 **`mask`**：条目一条不少，命名用户/命名组/属组的**有效权限**一起被压小；而且 `ls -l`/`stat` 显示的 group 位本来就是 mask 不是 `group::` 条目本身 | 本机实测链：`setfacl -m u:$USER:rw f; chmod 640 f; getfacl f` → `user:...:rw- #effective:r--`、`mask::r--`；`stat -c %a` → `640`；恢复 `setfacl -m m::rw f` |
| 「`ls -l` 那一行的组权限三位就是 `group::` 条目；`chmod` 加不加 setgid 与 ACL 显示无关」 | 两处都会被 `chmod` 的高位搅浑：① 有扩展 ACL 时那三位念的是 **mask**（上一条）；② `chmod` 写 setgid 位时，它占据**组执行位那一格**，`ls -l` 显示成 `r-s`/`r-S`，看着像「组少了执行权限」，而 mask 其实另有一个值——`stat -c %a` 会把 `2` 前缀和组位混着给你 | 本机实测：对 `chmod 640` + `setfacl -m u:daemon:r` 的文件执行 `chmod 2640` → `stat -c '%a %A'` 得 `2640 -rw-r-S---`，`getfacl` 里 `mask::r--` 未变、`acl_raw` 仍是 44 字节；再 `chmod 640` 后 setgid 位消失。判权限一律以 `getfacl` 的 `mask::`/`#effective:` 为准 |
| 「`getfacl`/`setfacl`/`getfattr` 是系统自带的」 | 全是外部包（acl/attr）里的工具，最小系统上没有；装没装、哪个版本都会改本章实验能不能照抄。本书这台机器上 **`getfattr`/`setfattr` 没有**，`getfacl`/`setfacl` 有 | `command -v getfacl setfacl getfattr setfattr` 逐条看输出；缺哪个就用正文的 `xattr_demo`/`acl_raw` 程序顶上 |
| 「目录设了 `setgid`，新建文件也带上 setgid；`setuid` 会被继承」 | setgid 目录只保证**属组继承**：普通文件不带 setgid 位（本机实测新文件 `664`，组随目录），子**目录**才继续带 `2` 前缀；setuid 位从不继承，且执行文件上的 setuid 还常被挂载选项 `nosuid` 与内核策略忽略 | `mkdir d; chmod 2775 d; touch d/f; mkdir d/sub; stat -c '%a %G' d/f d/sub` → `664 adm` 与 `2775 adm`（按你的所属组替换 adm） |
| 「粘滞位 `S_ISVTX` 限制读/写」 | 它只管**删除与改名**：目录上设了它，目录项只能由「项的属主、目录属主、或特权进程」删；`/tmp` 就是 `1777`——大家都能建文件，但不能互删。跨用户删不删得动要第二个账号，本机按未实测记 | `stat -c %a /tmp` → `1777`；`man 7 inode` 的 sticky 段；正文 2.5.2 表格第三行对照 |
| 「设了默认 ACL，新建文件权限还是 `mode & ~umask` 说了算」 | POSIX 语义是**默认 ACL 存在时 umask 不参与**：新文件的 base 三条由「创建 mode × 默认 ACL」相与得出。本机实测（详见第 2 节）：`umask 077` 下在带默认 ACL 的目录里 `touch`，得到 `mask::rw-`、`other::r--`，而不是 `---` | `setfacl -d -m u:$USER:rwx d; (umask 077; touch d/f); getfacl d/f` 看 `mask::` 与 `other::`；对照不带默认 ACL 的同名实验（那时 umask 才说话） |
| 「`cp -a` 会保住一切元数据」 | `cp -a` 保住属主/时间戳/符号链接，但 ACL、xattr 能不能带上取决于实现版本与**目标文件系统**；`tar` 要 `--xattrs`，`rsync` 要 `-X`；拷到 VFAT 上 ACL 直接蒸发。行为随工具版本变，别拿一次观察当定律 | 造 `setfacl -m u:$USER:r f`，`cp -a f g; getfacl g` 对比；`getfacl f \| setfacl --set-file=- g` 才是可移植的显式复制 |
| 「`statx` 一定给全字段；`STATX_ALL` 就是全部」 | `stx_mask` 才是「实际给了什么」：btime 看文件系统（本机 ext4 与 tmpfs 都填，老内核或 NFS 可能不填），直接 I/O 对齐要内核 6.1+（本机 ext4 给 `mem=512 off=512`，tmpfs **不给**，mask `0x3fff` 对 `0x1fff`）；`STATX_ALL` 是历史别名，新增位不自动在里面。旧内核直接 `ENOSYS` | 跑正文 `statx_full` 分别指 `/tmp` 与 `/dev/shm` 文件，比对两行 `mask`；`grep STATX_DIOALIGN /usr/include/aarch64-linux-gnu/linux/stat.h`；`man 2 statx` |
| 「inode flags 属主随便设；root 能绕过 immutable」 | 门槛分两档：`immutable`/`append` 要 `CAP_LINUX_IMMUTABLE`（设与清都要，root 也得先清 flag 才能改文件）；`nodump`/`noatime` 属主可设——本机实测 `FS_NODUMP_FL`、`chattr +A` 设置与清除都成功，`chattr +i`、`+a` 都 `EPERM`。文件系统支持面也不同：tmpfs 支持一部分，VFAT/NFS 可能 `EOPNOTSUPP` | `./inode_flags` 看 `0x80040 nodump` 往返；`chattr +i f; chattr +a f; chattr +A f; lsattr f`；换 `/dev/shm` 与 VFAT 挂载点各试一遍 |
| 「`strace -e trace=%stat` 是稳定写法」 | `%stat` 这个调用类在本机 strace 6.8 上**静默匹配不到任何东西**（打印一行都没有，不报错），而 glibc 的 `stat()` 实际落到 `newfstatat`；调用类名与系统调用名集合都随 strace/内核/libc 变 | `strace -e trace=%stat true` 看是不是空；改用 `strace -e trace=stat,lstat,fstat,newfstatat,statx ./prog` 显式列名；`strace -V` 记版本 |

## 2. 复跑校正（2026-11-02，同一台 aarch64 VM）

下表只列**在这台 7.0.0-38 aarch64 VM 上真实跑出来**的项。方法：把正文六个 C 程序（`showstat`、`xattr_demo`、`acl_demo`、`statx_full`、`inode_flags`、`acl_raw`）逐字抽出，按正文给的编译命令原样编译，再跑正文命令序列；实验文件全部留在 `/tmp/lab2c05p_*`，没有删除任何东西。六个程序**全部一次编译通过**（`acl_demo` 需要 `-lacl`，本机 libacl 齐）。

| 正文原写法 | 本机实测 | 结论 |
|:--|:--|:--|
| 2.5.13 `acl_raw` 示例注释：`OTHER r--`（其命令序列是 `chmod 640` 后 `setfacl`） | `version=2 bytes=44`、`USER rw- id=1000`、`MASK rw-` 全对上，但 `OTHER` 是 `---`：`chmod 640` 的 other 本来就是 0 | 示例的 OTHER 一行与自身命令不符，应为 `---`；其余读数本机复现 |
| 2.5.14 示例段：「`umask 077` 下……`ACL_MASK` 可能被限制为 `---`，命名用户的 `rwx` 有效权限变成 `---`」 | 同一条链在 `/tmp/lab2c05p_shared`（`chmod 2775` + `setfacl -d -m u:juanwang:rwx`）实测：新文件 `mode=664`、`mask::rw-`、`user:juanwang:rwx #effective:rw-`、`other::r--` | **与正文不符**。`umask 077` 被默认 ACL 忽略了（正文章节自己的 POSIX 说法才是本机行为），示例现象与那段说法互相矛盾；「条目在但 mask 让它们无效」的现象要复现得换 `mode` 请求或目录默认项 |
| 2.5.4 「`fchmodat` 的 `AT_SYMLINK_NOFOLLOW` 在 Linux 上对符号链接返回 `ENOTSUP`」 | 探针实测 `errno=95 (Operation not supported)`；`lstat` 看链接 mode 恒 `0777` | 与正文一致（内核 7.0 上仍如此） |
| 2.5.1 「`AT_EMPTY_PATH`（对 `dirfd` 本身取属性，需要 `CAP_DAC_READ_SEARCH`）」 | 三种 fd 上 `fstatat(fd, "", &st, AT_EMPTY_PATH)` 全部成功且不需要任何能力：自己的普通文件、自己的目录、root 拥有但 0644 全局可读的 `/etc/hosts` | **与正文不符**。内核要的是「按当前凭据能否访问这个 fd」，不是「一律要 capability」；正文这句应补条件 |
| 2.5.3 稀疏文件示例 `size=1073741824 blocks=0 blksize=512` | `truncate -s 1G` 后逐字复跑：`size=1073741824 blocks=0` 成立、`du -h` → `0`；但 `blksize=512` 这一项**不能**当成本机的 `st_blksize`——`stat -c %B` 在这台机器上对普通文件、目录、`/dev/null`、tmpfs 文件一律打印 512，而 `lstat`/`statx` 对这些对象都给 4096 | 三个数里两个与正文一致；`%B` 是 coreutils 9.4 的口径，不是稀疏文件的特征。判 `st_blksize` 要用程序（见第 1 节最后两行），正文那行注释最好补上这一点 |
| 2.5.5/2.5.16 的 `getfattr`/`setfattr` 命令（2.5.5 注释「没有也能用程序验证」） | `command -v getfattr setfattr` 本机为空（attr 包未装）；`xattr_demo` 照常编译运行成功 | 正文的免工具路线成立；但 2.5.16 实验二的四条 `setfattr`/`getfattr` 命令本机跑不了，替代：`xattr_demo` + `acl_raw` + `setfacl`/`getfacl`（acl 包在） |
| 2.5.11 「普通用户对 `FS_NODUMP_FL` 的设置通常成功」 | `inode_flags` 实测 `flags=0x80040 nodump` 设置与清除都成功；`chattr +A` 也可；`chattr +i`、`+a` 均 `Operation not permitted` | 与正文一致，并量化：属主可设的是低风险位，capability 位是 `i`/`a` |
| 2.5.12 「ext4 上实际能放的 ACL 条目约 500 条」 | 构造 `system.posix_acl_access` 二分实测：`/tmp`（ext4，块 4096）最多 **508** 条，超一点 `ENOSPC`；`/dev/shm`（tmpfs）一路到 **8192** 条才被 64 KiB 值上限（`E2BIG`）拦住 | 「约 500」在本机成立（508）；补一条正文没有的：同一台机器换 tmpfs，上限立刻变成另一回事 |
| 2.5.9 errata 盒「tmpfs/部分网络文件系统可能不填 `STATX_BTIME`」 | 本机 tmpfs 实测 mask=`0x1fff`（含 BTIME），btime 给了值；不给的是 DIOALIGN | 「可能不填」在本机 tmpfs 上不成立；换 NFS/FUSE 才是它想说的场景（未实测） |
| 2.5.16 实验一 `strace -yy -e trace=%stat,getxattr,listxattr,setxattr ./statx_full /etc/hosts` | strace 6.8 上 `%stat` 类**静默输出为空**；显式列 `stat,lstat,fstat,newfstatat,statx` 后：`stat()`/`lstat()` 落到 `newfstatat`（后者带 `AT_SYMLINK_NOFOLLOW`），`statx_full` 落到 `statx` | 正文「glibc `stat` 走 `newfstatat`」这句本机证实；但示例命令本身要改成显式列名才出东西 |
| 2.5.7 errata 盒 `f_bavail` 与 `f_bfree` 差 root 保留 | `statvfs("/")` 实测 `blocks=16163483 bfree=10056609 bavail=9227438`（frsize 4096），`df` 的 1K 可用数与 `bavail×4` 对账一致 | 与正文一致；「算普通用户还能写多少用 `bavail`」本机成立 |
| 2.5.2 示例行 `# type=l, size=10`（`ln -s /etc/hosts`） | `showstat /tmp/lab2c05p_link` → `type=l size=10 mode=0777` | 与正文一致；链接自身的 `blksize` 也报 4096，`blocks=0` |
| 2.5.3 表格「`utimensat` 可设 atime/mtime，`ctime` 不能设」+ 2.5.10「`touch -d` 两个都改、ctime 变现在」 | `utimensat` 只设 mtime 实测：`mtime=1700000000`，`atime` 未动，`ctime=当时` | 与正文一致 |

## 3. 本章未实测项

下面这些在这台 VM 上拿不到证据，引用时一律当**待验证的机制结论**，不要抄成读数：

- **一切要 root 的现象终局**：`chattr +i` 设上后 root 写不写得动、`trusted.*` 真正写入、`chown` 给别人、`CAP_*` 系行为、跨用户验证粘滞位（本机只有一个普通账号，`/tmp` 的 `1777` 只能读数不能验证互删）。`sudo` 不可用，全部按未实测。
- **XFS / NFS / VFAT / FAT 上的对应结论**：ACL 25 条上限、`ENOTSUP` 行为、xattr 容量、时间戳精度（FAT 的 2 秒）都是文档级结论；这台机器没有第二块可挂载的盘（挂载本身也要 root）。ext4 与 tmpfs 的对照读数见第 1、2 节，**别把它们外推**。
- **32 位程序的 `EOVERFLOW`**（正文 2.5.1/2.5.8）：本机没有 32 位支持可编（同目录的[第 1 章勘误页](ch01-errata.md)已实测 `cc -m32` 不被支持），`_FILE_OFFSET_BITS` 混链破坏 ABI 的现场无法在本机复现，按文档级读。
- **`lazytime` 的落盘时机**：本机根分区没有挂 `lazytime`（`findmnt` 只报 `relatime`），改挂载选项要 root；「崩溃可能丢时间」没有验证手段。
- **容器内的属性实验**（docker 免 sudo 可用、`--rm` 起容器换 rootfs）：容器内 ACL/xattr 行为受宿主内核与卷的文件系统类型影响，这次只确认了 `docker version` 可通，没有把正文程序搬进容器跑。
- **写作机（macOS arm64）对照**：没有 `statx`、xattr 命名空间叫 `com.apple.*`、没有 `getfacl` 这套工具，`EAGAIN`=35、页大小 16384——只能证明「换个系统这些接口整个换名字换语义」，不能提供任何 Linux 侧读数。

## 4. 发现新问题怎么记

按「**现象 → 命令与输出 → 机器/内核/文件系统/工具版本 → 建议改法**」四段写，缺第四段就没有可比较的基准。四段这样填：

1. **现象**：一句话说清谁看起来坏了。例：「`strace -e trace=%stat` 跑了但一行输出都没有」。
2. **命令与输出**：贴**原样敲的命令**与**未经删减的输出**（含 errno 数字与退出码）。例：`stat -c 'size=%s blocks=%b blksize=%B' /tmp/lab2c05p_sparse` → `1073741824 0 512`。
3. **机器口径**：至少附 `uname -a`、`getconf PAGE_SIZE`、`df -T /tmp`、`findmnt -T /tmp -o OPTIONS`、`cc --version | head -1`、`ldd --version | head -1`、`strace -V | head -1`、`command -v getfacl setfacl getfattr setfattr`；涉及 ACL/xattr 上限时附上文件所在文件系统与块大小。
4. **建议改法**：写「该改成什么动作」。例：「正文实验一的 `%stat` 应改为显式调用名并补一句『调用类随版本变』；508 条上限应标注 ext4/4 KiB 块口径」。

归类再说话：**规范条款**（`st_blocks` 单位 512，可断言）、**本机工具输出**（508 条、`ENOTSUP`=95，可复算）、**别的文件系统/机器上的量**（XFS 25 条——引用必须带出处）、**未实测**（写清为什么没测）。本章最常见的分歧有两种：把「ext4 的容量数」当「Linux 的容量数」，以及把「`ls -l` 的 group 位」当「属组条目的权限」。
