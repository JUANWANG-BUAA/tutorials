# 0.3 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · FHS 与 usrmerge

`/etc`、`/var`、`/run`、`/usr` 各放什么？usrmerge 后 `/bin` 是什么？为什么容器里有时 `/bin/sh` 会“不存在”？

::: sol 解答

`/etc` 配置，`/var` 可变状态（日志/缓存/队列/数据库），`/run` 本次启动的运行时状态（tmpfs，重启即清），`/usr` 只读程序/库/共享数据。usrmerge 后 `/bin` 通常是指向 `/usr/bin` 的符号链接。容器里如果只复制了 `/usr/bin/sh` 而没有建 `/bin -> /usr/bin` 链接，`/bin/sh` 就“不存在”；报错看起来像文件缺失，实际是路径/链接缺失。

:::
:::

::: ex A2 · 路径解析

`cd ..` 为什么有时不是“上一层目录”？`cd -P` 与 `pwd -P` 解决什么问题？

::: sol 解答

`..` 由内核按当前目录的目录项解析；如果当前路径经过符号链接，逻辑路径的“上一层”与物理父目录可能不同。`cd -P` 使用物理路径（跟随符号链接后解析），`pwd -P` 打印物理路径；默认 `pwd` 可能打印逻辑路径（含符号链接）。排障时用 `namei -l <path>` 逐段看权限与链接。

:::
:::

::: ex A3 · `ls -l` 与 `stat`

`ls -l` 的第三、四、五、六列各是什么？`stat` 比 `ls -l` 多给哪些字段？怎样只看 inode？

::: sol 解答

`ls -l`：mode、硬链接数、owner、group、size（apparent size）、mtime、name（第三列是 owner，第四列 group，第五列 size，第六列 mtime）。`stat` 额外给 inode 号、设备号、块数、块大小、atime/mtime/ctime、文件类型；`stat -c '%i %h %s %b %n' file` 可格式化。只看 inode 用 `ls -i` 或 `stat -c %i file`。

:::
:::

::: ex A4 · 硬链接与软链接

硬链接与软链接在 inode、链接数、跨文件系统、目录支持、删除原文件后的行为上各有什么不同？

::: sol 解答

硬链接：目录项指向同一 inode，链接数加一；不能跨文件系统；通常不能给目录建硬链接；删除一个名字只是链接数减一，inode 还在，直到链接数为 0 且无进程打开。软链接：独立 inode，内容是目标路径；可跨文件系统、可指向目录；删除原文件后软链接悬空，`readlink` 仍能读出目标路径。`ls -l` 的 `l` 类型和 `->` 可区分软链接。

:::
:::

::: ex A5 · `cp`/`mv`/`rm`

`cp -a` 比 `cp` 多保留什么？`mv` 同文件系统与跨文件系统分别做什么？`rm` 后数据会立刻清零吗？

::: sol 解答

`cp -a` 保留权限、时间、owner/group（权限允许时）、符号链接、硬链接关系、设备/特殊文件；普通 `cp` 受 umask 影响，通常不保留这些。`mv` 同文件系统是 `rename`（原子，只改目录项）；跨文件系统是 copy + unlink（不是原子，可能留下半成品）。`rm` 是 `unlink`，删除目录项、链接数减一；数据不会立刻清零，被打开的文件仍占空间，直到最后一个 fd 关闭。

:::
:::

::: ex A6 · `find` 表达式

`find . -name '*.log' -o -name '*.txt' -delete` 有什么风险？应该怎样写才安全？

::: sol 解答

`-delete` 只作用于 `-o` 右侧的 `-name '*.txt'`，因为隐式 AND 优先于 `-o`；`*.log` 不会删，或者动作与预期不符。安全写法：先 `find . \( -name '*.log' -o -name '*.txt' \) -print` 确认范围，再把 `-print` 换成 `-delete`；需要 `-exec` 时同样先用 `-print` 试运行。`-delete` 隐含 `-depth`，会先处理子目录。

:::
:::

::: ex A7 · `xargs -0`

为什么 `find . -name '*.log' | xargs rm` 在文件名带空格时会出错？`-print0` + `xargs -0` 怎样解决？`xargs -n`/`-P` 各做什么？

::: sol 解答

默认 `xargs` 按空白分词，文件名 `my app.log` 会被拆成 `my` 和 `app.log` 两个参数，导致删错或报错。`find -print0` 用 NUL 分隔，`xargs -0` 按 NUL 读参数，任何文件名都安全。`-n N` 每次传 N 个参数；`-P N` 并行跑 N 个进程；`-r`（GNU）在无输入时不执行命令。写操作先用 `xargs -0 -n1 echo` 试运行。

:::
:::

::: ex A8 · `du` 与 `ls`

为什么 `du -sh` 与 `ls -l` 的大小对不上？稀疏文件、硬链接、块大小分别怎样影响？

::: sol 解答

`ls -l` 是 apparent size（逻辑长度），`du` 是实际占用的块数。稀疏文件逻辑长度很大但只占少量块；硬链接指向同一 inode，`du` 默认只算一次，`ls` 每个名字显示同样大小；文件系统块大小让 `du` 向上取整。用 `du -h --apparent-size` 看逻辑大小，`ls -ls` 看块数；排查磁盘满时以 `du`/`df` 为准。

:::
:::

## B 组 · 诊断推理

::: ex B1 · 磁盘满了但 `du` 很小

`df -h` 显示根分区 100%，但 `du -sh /` 只有几十 GB。列出至少三种原因与对应验证命令。

::: sol 解答

① 已删除但仍被进程打开的文件：`lsof +L1`（或 `lsof | grep deleted`），重启/让进程关闭 fd；② 硬链接/挂载点重复计算或 `du` 没跨文件系统：`du -xsh /`、`findmnt`；③ inode 耗尽：`df -i`；④ 文件系统保留块（ext4 默认 5%）：`tune2fs -l` 看 Reserved block count；⑤ 日志/容器层在别的挂载点：`df -hT` 看所有挂载。最常见是 deleted-but-open。

:::
:::

::: ex B2 · 硬链接与删除

一个文件 `stat -c %h` 显示 3，删除其中一个名字后变成几？磁盘空间什么时候释放？怎样找所有硬链接？

::: sol 解答

链接数从 3 变 2；inode 与数据块要等链接数为 0 且没有进程打开才释放。找所有硬链接：`find / -xdev -samefile <path>`（同一文件系统）；`stat -c '%i %h %n'` 对比 inode；`ls -li` 看 inode。硬链接不能跨文件系统，所以 `find` 用 `-xdev` 避免跨挂载点。

:::
:::

::: ex B3 · `cp` 后权限/时间变了

你用 `cp file /backup/` 备份，恢复后发现权限、owner、mtime 都变了，硬链接也变成了独立文件。为什么？怎样备份才保留？

::: sol 解答

普通 `cp` 创建新文件，权限受 umask 影响，默认不保留 owner/时间/硬链接。备份用 `cp -a`（`-dR --preserve=all`）保留权限、时间、符号链接、硬链接；跨用户/跨文件系统时 owner 可能无法保留（非 root），需要 `rsync -aHAX` 或 `tar --numeric-owner`。恢复前先用 `stat` 对比源/目标。

:::
:::

::: ex B4 · `mv` 跨文件系统

`mv /data/big.iso /backup/` 跨了文件系统，中途断电会怎样？怎样做更安全？

::: sol 解答

跨文件系统 `mv` 是 copy + unlink，中途失败会留下部分目标文件，源可能还在或已被删，不是原子。更安全：先 `rsync -aHAX --partial` 或 `cp -a` 到目标临时名，校验大小/哈希，再 `mv` 到最终名（同文件系统 rename 原子），最后删源；或用 `tar` 管道。关键是把“复制”和“删除源”分开，并在删除前验证。

:::
:::

::: ex B5 · `find -delete` 与 `xargs rm`

为什么 `find ... -delete` 有时比 `find ... | xargs rm` 安全？各有什么边界？

::: sol 解答

`-delete` 在 `find` 进程内直接 unlink，文件名不经过分词，天然支持空格/换行；它隐含 `-depth`，先处理子目录。`xargs rm` 默认按空白分词，文件名带空格会出错；要用 `-print0 | xargs -0`。`-delete` 的风险是表达式写错会删多；`xargs` 的风险是分词与参数过长。两者都应先用 `-print`/`echo` 试运行。

:::
:::

::: ex B6 · `rm` 删不掉

`rm: cannot remove 'file': Operation not permitted`，但你是 root。列出至少三种原因与验证命令。

::: sol 解答

① immutable/append-only 属性：`lsattr file` 看 `i`/`a`，`chattr -i file` 后再删；② 文件被挂载点占用/只读挂载：`findmnt -T file`、`mount | grep ro`；③ 目录权限/粘滞位：`namei -l file`、`ls -ld` 父目录；④ 文件系统错误/只读：`dmesg`、`mount`；⑤ SELinux/AppArmor 拒绝：`ausearch -m avc`、`dmesg`。root 不等于绕过所有 LSM 与 immutable。

:::
:::

## C 组 · 动手实验

::: ex C1 · 硬链接与软链接

创建 `a.txt`，做硬链接 `b.txt` 和软链接 `c.txt`，比较 inode、链接数、删除 `a.txt` 后 `b.txt`/`c.txt` 的行为。

::: sol 解答

```bash
printf 'hello\n' > a.txt
ln a.txt b.txt          # 硬链接
ln -s a.txt c.txt       # 软链接
ls -li a.txt b.txt c.txt
stat -c '%i %h %F %n' a.txt b.txt c.txt
rm a.txt
cat b.txt               # hello，硬链接仍指向同一 inode
cat c.txt               # 失败：No such file or directory（悬空）
readlink c.txt          # a.txt
```

预期：`a.txt` 与 `b.txt` inode 相同、链接数 2；`c.txt` 是独立 inode、类型 symbolic link。删除 `a.txt` 后 `b.txt` 仍可读，`c.txt` 悬空但 `readlink` 仍显示目标。

:::
:::

::: ex C2 · 稀疏文件与占用

创建一个逻辑 1 GiB、实际占用很小的稀疏文件，比较 `ls -l`、`du -h`、`du -h --apparent-size`。

::: sol 解答

```bash
truncate -s 1G sparse.img
ls -lh sparse.img
du -h sparse.img
du -h --apparent-size sparse.img
stat -c 'size=%s blocks=%b block_size=%B' sparse.img
```

预期：`ls`/`--apparent-size` 显示约 1G；`du` 显示很小（只有元数据/少量块）；`stat` 的 `blocks` 远小于 `size/512`。写满数据后 `du` 才接近 1G。这个差异解释了“为什么备份/复制稀疏文件要用 `cp --sparse=always` 或 `rsync -S`”。

:::
:::

::: ex C3 · `find -print0` + `xargs -0`

创建带空格和换行的文件名，用 `find -print0 | xargs -0` 安全列出；再对比不加 `-0` 的结果。

::: sol 解答

```bash
mkdir -p /tmp/names && cd /tmp/names
touch 'a b.log' $'line\nbreak.log' normal.log
find . -name '*.log' -print0 | xargs -0 -n1 printf '<%s>\n'
find . -name '*.log' | xargs -n1 printf '<%s>\n'   # 对比：空格/换行会被拆
```

预期：`-print0`/`-0` 每条文件名完整；不加 `-0` 时 `a b.log` 被拆成两个参数，换行文件名被拆成两行。批量删除/改名先接 `echo` 或 `printf` 试运行。

:::
:::

::: ex C4 · 用 `strace` 看文件操作

用 `strace` 跟踪 `cat` 打开文件、`ln -s` 创建软链接、`mv` 同文件系统重命名，指出 `openat`、`readlink`、`renameat2` 各在哪。

::: sol 解答

```bash
strace -e trace=openat,readlink,readlinkat,rename,renameat,renameat2,unlink \
    cat /etc/hosts >/dev/null
strace -e trace=symlinkat,readlinkat ln -s /etc/hosts /tmp/hosts.link
strace -e trace=rename,renameat,renameat2 mv /tmp/a /tmp/b
```

`cat` 会看到 `openat("/etc/hosts", O_RDONLY)`；`ln -s` 会看到 `symlinkat`；`mv` 同文件系统会看到 `rename`/`renameat`/`renameat2`（取决于 coreutils 与文件系统）。跨文件系统时不会看到单个 rename，而是 copy + unlink。用 `-y` 可把 fd 显示成路径。

:::
:::

::: ex C5 · 安全清理脚本

写一个 `safe-clean.sh`：删除目录下超过 N 天的普通文件；默认 dry-run，`-x` 才真删；拒绝 `/`、`/usr`、`/etc` 等危险根目录；用 `-print0`/`-xargs -0` 或 `find -delete`。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
dry=1 dir='' days=''
while getopts ':xd:m:' opt; do
    case $opt in
        x) dry=0 ;;
        d) dir=$OPTARG ;;
        m) days=$OPTARG ;;
        *) echo "usage: $0 [-x] -d DIR -m DAYS" >&2; exit 2 ;;
    esac
done
[[ -n $dir && -n $days ]] || { echo "missing -d/-m" >&2; exit 2; }
root=$(realpath -e -- "$dir")
case $root in
    /|/usr|/etc|/var|/home|/root|/boot|/dev|/proc|/sys)
        echo "refusing $root" >&2; exit 2 ;;
esac
if (( dry )); then
    find "$root" -xdev -type f -mtime +"$days" -print0 | xargs -0 -n1 printf 'would remove <%s>\n'
else
    find "$root" -xdev -type f -mtime +"$days" -delete
fi
```

关键点：默认 dry-run；`realpath -e` 解析真实路径；拒绝危险根；`-xdev` 不跨文件系统；`-print0`/`-0` 处理任意文件名；真删前先用 dry-run 核对清单。生产脚本还应加日志、锁与 `--` 防止选项注入。

:::
:::
