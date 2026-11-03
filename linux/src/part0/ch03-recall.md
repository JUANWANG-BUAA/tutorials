# 0.3 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先会用

### D1 · FHS 与 usrmerge

`/etc`、`/var`、`/run`、`/usr` 各放什么？usrmerge 后 `/bin`、`/sbin`、`/lib` 变成什么？

::: sol D1 核对

`/etc` 放主机配置，要能改；`/var` 放可变状态（日志、缓存、队列、数据库），要持久化与备份；`/run` 放本次启动的运行时状态（tmpfs），重启即清；`/usr` 放只读的程序、库与共享数据，随包升级。usrmerge 后 `/bin`、`/sbin`、`/lib` 通常是指向 `/usr/bin`、`/usr/sbin`、`/usr/lib` 的符号链接；老的 `/bin/sh` 路径仍能用，但实际落在 `/usr`。
:::

### D2 · 路径解析

一个路径字符串从 `/` 开始解析，`.`、`..`、符号链接、挂载点各参与什么？为什么 `cd ..` 有时不是“上一层目录”？

::: sol D2 核对

内核按 `/` 分段解析，每段在父目录的 dentry 缓存里查找；`.` 指当前目录，`..` 指父目录，但父目录由目录项与挂载点决定。符号链接默认会被跟随（`open` 的 `O_NOFOLLOW` 可禁止）；挂载点让路径跨到另一个文件系统。`cd ..` 走的是逻辑当前目录的父目录；如果当前路径经过符号链接，物理父目录可能与 `..` 不同，`cd -P`/`pwd -P` 可看物理路径。
:::

### D3 · `ls -l` 与 `stat`

`ls -l` 的每一列是什么？`stat` 比 `ls -l` 多给哪些字段？

::: sol D3 核对

`ls -l`：mode、硬链接数、owner、group、size（apparent size）、mtime、name。`stat` 额外给 inode 号、设备号、块数（512B 块）、块大小、atime/mtime/ctime、文件类型；`stat -c` 可格式化输出。`ls -i` 直接看 inode，`ls -s` 看块数。
:::

### D4 · 硬链接与软链接

硬链接和软链接在 inode、链接数、跨文件系统、目录支持上有什么不同？删除原文件后它们各怎样？

::: sol D4 核对

硬链接：目录项指向同一个 inode，链接数加一；不能跨文件系统，通常不能给目录建硬链接；删除一个名字只是链接数减一，inode 还在，直到链接数为 0 且没有进程打开。软链接：独立 inode，内容是目标路径；可以跨文件系统、可以指向目录；删除原文件后软链接变成悬空（dangling），`ls -l` 会用红色/闪烁提示，`readlink` 仍能读出目标路径。
:::

### D5 · `cp`/`mv`/`rm`

`cp` 默认保留哪些元数据？`cp -a` 多了什么？`mv` 同文件系统与跨文件系统分别做什么？`rm` 到底做了什么？

::: sol D5 核对

`cp` 默认创建新文件，权限受 umask 影响，通常不保留 owner/时间/硬链接；`cp -a` 等价于 `-dR --preserve=all`，保留权限、时间、符号链接、硬链接关系等。`mv` 同文件系统是 `rename`，原子；跨文件系统是 copy + unlink，不是原子。`rm` 是 `unlink`：删除目录项、inode 链接数减一；数据不会立刻清零，被打开的文件仍占空间，直到最后一个 fd 关闭。
:::

### D6 · `find` 表达式

`find` 的隐式 AND、`-o`、`!`、括号的优先级是什么？`-delete` 与 `-exec` 有什么顺序边界？

::: sol D6 核对

`find` 表达式从左到右求值，隐式 AND 优先于 `-o`，`!` 高于 AND；需要改变优先级时用 `\( ... \)` 转义括号。动作（`-print`、`-delete`、`-exec`）本身返回真，会影响后续 `-o` 的短路；`-delete` 隐含 `-depth`，先处理子目录；`-exec ... \;` 对每个文件执行一次，`-exec ... +` 批量传参。先 `-print` 试运行，再换成 `-delete`/`-exec`。
:::

### D7 · `xargs -0`

为什么文件名带空格/换行时 `find ... | xargs rm` 会出错？`-print0` + `xargs -0` 怎样解决？`xargs -n`/`-P` 各做什么？

::: sol D7 核对

默认 `xargs` 按空白分词，文件名里的空格/换行会被拆成多个参数，导致删错或报错。`find -print0` 用 NUL 分隔，`xargs -0` 按 NUL 读参数，任何文件名都安全。`xargs -n N` 每次传 N 个参数；`-P N` 并行跑 N 个进程；`-r`/`--no-run-if-empty` 在无输入时不执行命令（GNU）。
:::

## B. 第二遍：看内核与边界

### D8 · `du`、`ls` 与稀疏文件

为什么 `du -sh` 与 `ls -l` 的大小对不上？稀疏文件、硬链接、块大小分别怎样影响？

::: sol D8 核对

`ls -l` 显示 apparent size（文件逻辑长度），`du` 显示实际占用的块数（通常 1K/4K 块）。稀疏文件有很多“洞”，逻辑长度很大但只占少量块；硬链接指向同一 inode，`du` 默认只算一次（后续链接显示 0 或不重复计），`ls` 每个名字都显示同样大小；块大小与文件系统块分配也会让 `du` 向上取整。用 `du -h --apparent-size` 看逻辑大小，`ls -ls` 看块数。
:::

### D9 · `mv` 与 `renameat2`

`mv` 同文件系统为什么原子？跨文件系统为什么不是？`renameat2` 的 `RENAME_NOREPLACE`/`RENAME_EXCHANGE` 各做什么？

::: sol D9 核对

同文件系统 `mv` 调用 `rename`/`renameat`，只改目录项，不搬数据，所以原子；跨文件系统要复制数据再删除源，中间失败会留下半成品，不是原子。`renameat2` 支持 `RENAME_NOREPLACE`（目标存在则失败，不覆盖）、`RENAME_EXCHANGE`（交换两个路径）、`RENAME_WHITEOUT`（overlayfs 用）。`mv -n` 接近 `NOREPLACE`，但细节依实现。
:::

### D10 · `xattr` 与 `chattr`

扩展属性（xattr）与 `chattr` 各改什么？`chattr +i` 后 `rm` 会怎样？ACL 属于哪一层？

::: sol D10 核对

xattr 是文件系统给文件附加的键值对（`user.*`、`security.*`、`trusted.*`），用 `getfattr`/`setfattr` 读写；SELinux 标签、capability 也走 xattr。`chattr` 改的是文件系统 inode 标志（如 `+i` immutable、`+a` append-only），`+i` 后即使 root 也不能写/删/重命名，`rm` 报 `Operation not permitted`，要先 `chattr -i`。ACL 是权限模型的扩展（`getfacl`/`setfacl`），与 xattr、`chattr` 不是同一层。
:::

### D11 · `rsync` 与 `tar`

`rsync -a` 保留什么？`--delete` 的方向是什么？`tar` 的 `-C`、`--numeric-owner`、`--hard-dereference` 各做什么？

::: sol D11 核对

`rsync -a` 等价于 `-rlptgoD`：递归、保留符号链接、权限、时间、group、owner、设备/特殊文件；不保留硬链接（要 `-H`）、不保留 xattr/ACL（要 `-X`/`-A`）。`--delete` 删除**目标端**有、源端没有的文件；方向写反会删错。`tar -C dir` 切换打包/解包目录；`--numeric-owner` 按数字 UID/GID 还原，避免名字映射；`--hard-dereference` 把硬链接当独立文件存储（默认 tar 会保留硬链接关系）。
:::

### D12 · 磁盘满与 inode 满

“磁盘满了”有哪两种？各用什么命令确认？删了文件空间没释放，最常见的原因是什么？

::: sol D12 核对

两种：块耗尽（`df -h` 看 Use%）与 inode 耗尽（`df -i` 看 IUse%）。块满常见于大文件/日志；inode 满常见于大量小文件。删了文件空间没释放，最常见是文件仍被进程打开：`rm` 只删目录项，inode 与数据块要等最后一个 fd 关闭；用 `lsof +L1` 找 deleted 但仍打开的文件，重启/让进程关闭 fd 后释放。
:::
