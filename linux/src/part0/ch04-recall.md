# 0.4 闭卷回忆卡

这页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 第一遍：先会用

### D1 · 拒绝的判定顺序

一次 `Permission denied`，按什么顺序判断是哪一层？每层给一条证据命令。

::: sol D1 核对

先看路径逐级权限（`namei -l`），再确认目录有 `x`（`ls -ld` 每一级），然后看文件 mode（`ls -l`）、ACL（`getfacl`）、capability（`getcap`/`capsh`）、LSM（`ausearch -m avc`/`dmesg`）、挂载（`findmnt -T` 看 `ro`/`noexec`）与 immutable（`lsattr`）。DAC 不是唯一层，777 也可能被 ACL mask、capability、LSM 或只读挂载挡住。
:::

### D2 · mode 十二位

mode 的十二位分别是什么？`4755`、`2755`、`1777` 各表示什么？

::: sol D2 核对

十二位 = setuid（4000）+ setgid（2000）+ sticky（1000）+ owner 的 rwx + group 的 rwx + other 的 rwx。`4755`：setuid + owner rwx + group r-x + other r-x；`2755`：setgid + 同样的 rwx/r-x/r-x；`1777`：sticky + 所有用户 rwx（如 `/tmp`）。`ls -l` 用 `s`/`S`/`t`/`T` 显示特殊位。
:::

### D3 · 目录的 r/w/x

目录的 `r`、`w`、`x` 各能做什么？只有 `r` 没有 `x` 会怎样？

::: sol D3 核对

`r` 允许列出目录项（`ls`）；`w` 允许创建/删除/重命名目录项；`x` 允许穿过目录、访问子项（`cd`、`stat` 子文件）。只有 `r` 没有 `x` 时，`ls dir` 可能列出名字，但无法 `cd` 进去或访问子项；只有 `x` 没有 `r` 时，知道路径就能访问已知名字，但不能列目录。
:::

### D4 · umask

新文件与新目录的默认权限怎么算？`umask 022` 时各是多少？`umask` 是“授予”还是“去掉”？

::: sol D4 核对

新文件 = `666 & ~umask`，新目录 = `777 & ~umask`。`umask 022`：文件 `644`（rw-r--r--），目录 `755`（rwxr-xr-x）。`umask` 是“去掉的位”，不是授予的位；它只影响新建文件/目录，不改已有文件。`umask -S` 用符号显示允许的位。
:::

### D5 · chmod、chown 与 setuid

`chmod` 与 `chown` 各改什么？setuid 位让程序以谁的 euid 运行？为什么 setuid 脚本不生效？

::: sol D5 核对

`chmod` 改 mode（权限位与特殊位）；`chown` 改 owner/group（通常需要 root 或 `CAP_CHOWN`）。setuid 让程序 exec 后 euid 变成文件 owner 的 uid（setgid 同理改 egid）。Linux 忽略脚本上的 setuid 位（解释器会以调用者身份运行），需要编译后的二进制或 capability。
:::

### D6 · ACL

ACL 给谁授权？`setfacl -m u:alice:rw file` 做了什么？mask 是什么？默认 ACL 有什么用？

::: sol D6 核对

ACL 给单个用户/组额外授权，存在 `system.posix_acl_access` xattr 里。`setfacl -m u:alice:rw file` 给 alice 加读写 ACL；`getfacl` 查看。mask 是 ACL 有效权限的上限，`ls -l` 的 group 三位显示的是 mask，不是 group 权限；`setfacl -m m::rwx` 调整 mask。目录上的默认 ACL（`setfacl -d -m ...`）让新建子项继承。
:::

### D7 · capability

capability 解决什么问题？五个集合是什么？`ping` 为什么不再 setuid root？

::: sol D7 核对

capability 把 root 的特权拆成小块，程序只拿需要的那一块，减少 setuid root 的攻击面。五个集合：inheritable（可继承）、permitted（允许的上限）、effective（当前生效）、bounding（能力边界）、ambient（环境继承）。`ping` 需要原始套接字，现代发行版给它 `cap_net_raw=ep`，不再需要 setuid root；`getcap $(command -v ping)` 可验证。
:::

## B. 第二遍：看内核与边界

### D8 · 账号文件

`/etc/passwd`、`/etc/shadow`、`/etc/group` 各存什么？`passwd` 的七个字段是什么？

::: sol D8 核对

`/etc/passwd` 存账号基本信息（名字、UID、GID、gecos、home、shell），密码哈希移到 `/etc/shadow`；`/etc/group` 存组名、GID 与成员。`passwd` 七个字段：`name:password:uid:gid:gecos:home:shell`；`shadow` 九个字段：`name:hash:lastchg:min:max:warn:inactive:expire:reserved`。`x` 表示密码在 shadow。
:::

### D9 · sudo

`sudo` 怎样提权？`sudoers` 的基本结构是什么？为什么说 `sudo` 不是沙箱？

::: sol D9 核对

`sudo` 是 setuid root 的程序：启动后获得 euid 0，按 `/etc/sudoers` 认证与授权，再用 `setresuid` 切到目标用户执行命令。基本结构：`user host=(runas) commands`。它不是沙箱：被授权的命令以目标用户（常为 root）权限运行，可以读写系统；`sudo` 只控制“谁能以谁的身份跑什么”，不限制命令内部行为。`sudo -l` 查看授权，`secure_path` 会重置 `PATH`。
:::

### D10 · sticky 与目录

sticky 位解决什么问题？`/tmp` 为什么是 `1777`？删除一个文件需要什么权限？

::: sol D10 核对

sticky 位限制目录中的删除/重命名：只有文件 owner、目录 owner 或 root 能删/改名。`/tmp` 是 `1777`（sticky + 所有人 rwx），任何用户可创建临时文件，但不能删别人的。删除文件需要目录的 `w`+`x`，以及 sticky 的 owner 检查；文件自身的 `w` 不决定能否删除。
:::

### D11 · 判定路径与凭证

内核判定权限时用哪些凭证？`fsuid`/`fsgid` 与 `euid`/`egid` 有什么关系？root 会绕过一切吗？

::: sol D11 核对

内核用进程的 `fsuid`/`fsgid`（通常等于 euid/egid）与 inode 的 mode、ACL、capability 逐层判定；`CAP_DAC_OVERRIDE`/`CAP_DAC_READ_SEARCH` 可绕过部分 DAC 检查。root 不等于绕过一切：LSM（SELinux/AppArmor）、immutable、只读挂载、`noexec`、capability bounding set 仍能阻止。`strace` 能看到 `setresuid` 等凭证切换。
:::

### D12 · 审计脚本

权限审计脚本应检查哪几类高风险文件？为什么必须排除 `/proc`、`/sys`、容器挂载？

::: sol D12 核对

检查 world-writable（`-perm -0002`）、无主（`-nouser`/`-nogroup`）、setuid/setgid（`-perm -4000`/`-2000`）、异常 capability（`getcap -r /`）、可写目录中的敏感文件。排除 `/proc`、`/sys`、`/dev`、容器/网络挂载，因为它们是虚拟文件系统或由 runtime 管理，权限语义与普通文件不同，会把审计结果淹没在假阳性里。脚本应支持 dry-run 与输出到日志。
:::
