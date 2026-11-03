# 0.4 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 判定顺序

一次 `Permission denied`，按什么顺序判断是哪一层？每层给一条证据命令。

::: sol 解答

先看路径逐级权限（`namei -l <path>`），确认每级目录有 `x`；再看文件 mode（`ls -l`）、ACL（`getfacl`）、capability（`getcap`/`capsh`）、LSM（`ausearch -m avc`/`dmesg`）、挂载（`findmnt -T` 看 `ro`/`noexec`）与 immutable（`lsattr`）。DAC 不是唯一层；777 也可能被 ACL mask、capability、LSM 或只读挂载挡住。

:::
:::

::: ex A2 · mode 十二位

mode 的十二位分别是什么？`4755`、`2755`、`1777` 各表示什么？`ls -l` 怎样显示特殊位？

::: sol 解答

十二位 = setuid（4000）+ setgid（2000）+ sticky（1000）+ owner rwx + group rwx + other rwx。`4755`：setuid + rwxr-xr-x；`2755`：setgid + rwxr-xr-x；`1777`：sticky + rwxrwxrwx。`ls -l` 用 `s`/`S`（setuid/setgid）、`t`/`T`（sticky）显示；大写表示对应 `x` 位没开。

:::
:::

::: ex A3 · 目录 r/w/x

目录的 `r`、`w`、`x` 各能做什么？只有 `r` 没有 `x`、只有 `x` 没有 `r` 各是什么效果？

::: sol 解答

`r` 列目录项（`ls`）；`w` 创建/删除/重命名目录项；`x` 穿过目录、访问子项（`cd`、`stat` 子文件）。只有 `r` 没有 `x`：能列出名字，但不能 `cd` 或访问子项；只有 `x` 没有 `r`：知道确切名字就能访问，但不能列目录。删除文件需要目录的 `w`+`x`，不是文件自身的 `w`。

:::
:::

::: ex A4 · umask

`umask 022` 时新文件与新目录的默认权限各是多少？`umask` 是授予还是去掉？`umask -S` 显示什么？

::: sol 解答

新文件 `666 & ~022 = 644`（rw-r--r--），新目录 `777 & ~022 = 755`（rwxr-xr-x）。`umask` 是“去掉的位”，不是授予的位；它只影响新建文件/目录，不改已有文件。`umask -S` 用符号显示允许的位（如 `u=rwx,g=rx,o=rx`）。

:::
:::

::: ex A5 · chmod、chown 与 setuid

`chmod` 与 `chown` 各改什么？setuid 位让程序以谁的 euid 运行？为什么 setuid 脚本不生效？

::: sol 解答

`chmod` 改 mode（权限位与特殊位）；`chown` 改 owner/group（通常需要 root 或 `CAP_CHOWN`）。setuid 让程序 exec 后 euid 变成文件 owner 的 uid；setgid 同理改 egid。Linux 忽略脚本上的 setuid 位，因为解释器会以调用者身份运行脚本；需要编译后的二进制或 capability。

:::
:::

::: ex A6 · ACL 与 mask

`setfacl -m u:alice:rw file` 做了什么？`getfacl` 里的 `mask` 是什么？为什么 `ls -l` 的 group 三位会变？

::: sol 解答

它给 alice 加读写 ACL，存在 `system.posix_acl_access` xattr 里。`mask` 是 ACL 有效权限的上限；`ls -l` 的 group 三位显示的是 mask，不是 group 权限。如果 mask 是 `r--`，即使 alice 的 ACL 是 `rw-`，有效权限也只有 `r--`；用 `setfacl -m m::rwx` 调整 mask。

:::
:::

::: ex A7 · capability 与 ping

capability 解决什么问题？五个集合是什么？`ping` 为什么不再 setuid root？

::: sol 解答

capability 把 root 的特权拆成小块，程序只拿需要的那一块，减少 setuid root 的攻击面。五个集合：inheritable、permitted、effective、bounding、ambient。`ping` 需要原始套接字，现代发行版给它 `cap_net_raw=ep`，不再需要 setuid root；`getcap $(command -v ping)` 可验证。

:::
:::

::: ex A8 · 账号文件

`/etc/passwd`、`/etc/shadow`、`/etc/group` 各存什么？`passwd` 的七个字段是什么？`x` 表示什么？

::: sol 解答

`/etc/passwd` 存账号基本信息（名字、UID、GID、gecos、home、shell）；`/etc/shadow` 存密码哈希与过期策略；`/etc/group` 存组名、GID 与成员。`passwd` 七个字段：`name:password:uid:gid:gecos:home:shell`；`x` 表示密码哈希在 `/etc/shadow`，不是密码就是 `x`。

:::
:::

## B 组 · 诊断推理

::: ex B1 · `chmod 777` 后仍拒绝

你把文件 `chmod 777`，仍然 `Permission denied`。列出至少四种原因与验证命令。

::: sol 解答

① 目录缺 `x`：`namei -l <path>`、`ls -ld` 每一级；② ACL mask 限制：`getfacl` 看 `mask::`；③ LSM 拒绝：`ausearch -m avc -ts recent`、`dmesg`；④ 只读挂载/`noexec`：`findmnt -T <path>`；⑤ immutable：`lsattr`；⑥ capability/用户命名空间限制：`capsh --print`、`id`。777 只改 DAC mode，不改其他层。

:::
:::

::: ex B2 · 能 ls 不能 cd

`ls /data` 能列出名字，但 `cd /data` 报 `Permission denied`。为什么？怎样修？

::: sol 解答

目录有 `r` 但没有 `x`；`r` 允许列目录项，`x` 才允许穿过/进入。`ls -ld /data` 看 mode，`namei -l /data` 看逐级。修复：`chmod +x /data`（或 `chmod 755`），但先确认这是有意的最小权限，不要直接 777。

:::
:::

::: ex B3 · 共享目录删别人文件

`/tmp` 是 `1777`，为什么普通用户不能删别人的文件？删除文件需要什么权限？

::: sol 解答

`1777` 的 sticky 位限制删除/重命名：只有文件 owner、目录 owner 或 root 能删/改名。删除文件需要目录的 `w`+`x`，再加 sticky 的 owner 检查；文件自身的 `w` 不决定能否删除。`ls -ld /tmp` 看 `t` 位；`rm /tmp/otherfile` 会报 `Operation not permitted`。

:::
:::

::: ex B4 · setuid 脚本不生效

你给一个 bash 脚本 `chmod 4755`，执行后 `id` 仍是当前用户。为什么？怎样达到目的？

::: sol 解答

Linux 忽略脚本上的 setuid 位；内核 exec 脚本时实际运行解释器，解释器以调用者身份运行，不会继承脚本的 setuid。需要编译后的二进制并设置 setuid（风险高），或用 capability 给二进制最小特权，或用 `sudo`/systemd 服务做受控提权。不要用 setuid shell 脚本做提权。

:::
:::

::: ex B5 · `sudo` 找不到命令

你自己的程序在 `~/bin`，`sudo mytool` 报 `command not found`，但直接运行正常。为什么？怎样修？

::: sol 解答

`sudo` 默认用 `secure_path` 重置 `PATH`，不包含 `~/bin`；`sudo -E` 通常也绕不开 `secure_path`。修复：用绝对路径 `sudo /home/you/bin/mytool`；或把目录加进 sudoers 的 `secure_path`（有风险）；或把程序装到 `/usr/local/bin`。先 `sudo -l` 看环境与授权。

:::
:::

::: ex B6 · ACL 设了没生效

`setfacl -m u:alice:rw file` 后 alice 仍不能写。列出至少三种原因与验证。

::: sol 解答

① mask 限制：`getfacl file` 看 `mask::`，必要时 `setfacl -m m::rw`；② alice 不属于该用户/UID 不匹配：`id alice`；③ 目录缺 `x`/文件系统不支持 ACL：`namei -l`、`mount` 看 `acl` 选项；④ LSM 拒绝：`ausearch -m avc`；⑤ 文件是只读挂载/immutable：`findmnt`、`lsattr`。ACL 不是绕过 DAC 目录检查的万能钥匙。

:::
:::

## C 组 · 动手实验

::: ex C1 · 读一次权限判定

对 `/etc/shadow` 运行 `namei -l`、`ls -l`、`stat`、`getfacl`，说明普通用户为什么读不了。

::: sol 解答

```bash
namei -l /etc/shadow
ls -l /etc/shadow
stat -c '%A %U %G %a %n' /etc/shadow
getfacl /etc/shadow 2>/dev/null || true
```

预期：`/etc` 有 `x`，`/etc/shadow` 通常是 `640 root:shadow` 或 `600 root:root`；普通用户既不是 owner，也不在 shadow 组，所以 DAC 拒绝。`namei -l` 逐级显示权限，能确认不是目录 `x` 的问题；`getfacl` 若显示 `mask`，说明 ACL 也可能参与。

:::
:::

::: ex C2 · umask 实验

在子 Shell 里设置 `umask 077`，创建文件和目录，比较默认权限；再恢复 `umask 022`。

::: sol 解答

```bash
( umask 077; touch f; mkdir d; stat -c '%a %n' f d )
( umask 022; touch f2; mkdir d2; stat -c '%a %n' f2 d2 )
```

预期：`umask 077` 下文件 `600`、目录 `700`；`umask 022` 下文件 `644`、目录 `755`。子 Shell 里的 `umask` 不影响父 Shell；`umask` 只影响新建文件/目录，不改已有文件。

:::
:::

::: ex C3 · ACL 与 mask

创建 `acl.txt`，给 `nobody` 读写 ACL，观察 `getfacl` 与 `ls -l` 的 group 三位；把 mask 改成只读，再验证 `nobody` 能否写。

::: sol 解答

```bash
printf 'x\n' > /tmp/acl.txt
setfacl -m u:nobody:rw-,m::rw- /tmp/acl.txt
getfacl -n /tmp/acl.txt
ls -l /tmp/acl.txt
setfacl -m m::r-- /tmp/acl.txt
getfacl -n /tmp/acl.txt
sudo -u nobody sh -c 'printf y >> /tmp/acl.txt' || echo denied
```

预期：`getfacl` 显示 `user:nobody:rw-` 与 `mask::rw-`；`ls -l` 的 group 三位显示 mask（`rw-`）。把 mask 改成 `r--` 后，nobody 的有效权限被压到只读，写入被拒绝。ACL 存在 `system.posix_acl_access` xattr 里，`getfattr` 可看十六进制。

:::
:::

::: ex C4 · capability 与 `ping`

查看 `ping` 的 capability，解释它为什么不需要 setuid root；用 `capsh` 解码当前进程的 `CapEff`。

::: sol 解答

```bash
getcap "$(command -v ping)"
getpcaps $$
grep '^Cap' /proc/self/status
capsh --decode=$(grep '^CapEff' /proc/self/status | awk '{print $2}')
```

预期：`ping` 可能有 `cap_net_raw=ep`；普通 Shell 的 `CapEff=0`；`capsh --decode` 把十六进制翻译成名字。`cap_net_raw` 允许原始套接字，足以发 ICMP，不需要完整 root；这降低了 setuid root 的攻击面。

:::
:::

::: ex C5 · 权限审计脚本

写一个只读审计脚本：找出 world-writable、无主、setuid/setgid 文件；排除 `/proc`、`/sys`、`/dev`；输出到文件，支持 `--dry-run`。

::: sol 解答

```bash
#!/usr/bin/env bash
set -euo pipefail
root=${1:-/}
out=${2:-./audit.txt}
{
    echo "== world-writable"
    find "$root" -xdev \( -path /proc -o -path /sys -o -path /dev \) -prune -o \
        -type f -perm -0002 -print
    echo "== unowned"
    find "$root" -xdev \( -path /proc -o -path /sys -o -path /dev \) -prune -o \
        \( -nouser -o -nogroup \) -print
    echo "== setuid/setgid"
    find "$root" -xdev \( -path /proc -o -path /sys -o -path /dev \) -prune -o \
        -type f \( -perm -4000 -o -perm -2000 \) -print
} > "$out"
echo "wrote $out"
```

关键点：`-xdev` 不跨文件系统；`-prune` 排除虚拟文件系统；`-perm -0002` 是“other 可写”；`-nouser`/`-nogroup` 找无主文件；脚本只读，不自动修。生产审计还应加 `getcap -r`、日志、时间戳与告警。

:::
:::
