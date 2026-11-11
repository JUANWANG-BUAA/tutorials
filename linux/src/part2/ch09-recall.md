# 2.9 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。21 张卡分三组：**A 组考 UID/GID 与用户数据库（2.9.1–2.9.2、2.9.9）**，**B 组考 setuid 纪律与攻击面（2.9.3–2.9.5、2.9.8、2.9.11）**，**C 组考 capability 与内核表示（2.9.6–2.9.7、2.9.10、2.9.12）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. UID/GID 与用户数据库

::: method 回忆 1 · 四个 UID 各管什么
一个进程有哪四个 UID？各决定什么？`id` 能看到哪几个、看不到哪个？`/proc/self/status` 的 `Uid:` 行四列按什么顺序排？
::: sol 答案
真实 UID 决定进程归属（信号权限、`/proc` 归谁）；有效 UID 是内核做权限检查用的身份；保存 UID 是 exec 时有效 UID 的快照，给临时降权留退路；文件系统 UID 只用于文件访问检查（Linux 专有，NFS 的历史产物）。`id` 只显示 real/effective 与附加组，看不到 saved。四列依次是 real、effective、saved、fs。本机实测普通用户四列都是 1000。
:::
:::

::: method 回忆 2 · exec setuid-root 那一刻
uid=1000 的用户 exec 一个属主 root、带 setuid 位的程序，四个 UID 各变成什么？capability 有效集呢？为什么脚本上的 setuid 位无效？
::: sol 答案
ruid 保持 1000；euid 与 suid 变成文件属主 0；fsuid 跟随 euid 变 0。有效 UID 为 0 让进程拿到 capability 全集（本机 CapBnd 实测 41 位）。脚本无效是因为脚本由解释器执行，内核忽略 `#!` 文件的 setuid/setgid 位，解释器用调用者的凭证运行。`nosuid` 挂载同样忽略这两个位。
:::
:::

::: method 回忆 3 · 非特权进程的切换规则
非特权进程（无 `CAP_SETUID`）调用 `setuid(u)`、`seteuid(u)`、`setresuid(r,e,s)` 各允许什么？什么时候 `EPERM`？
::: sol 答案
`setuid(u)` 只改有效 UID，u 必须等于当前 real 或 saved；`seteuid(u)` 同样只改 euid、目标限 real/saved；`setresuid` 三个参数各自必须是当前 r/e/s 之一，-1 表示不变。违反任一条返回 `EPERM`。本机 `cred_rules` 实测：`setresuid(0,0,0)` 报 Operation not permitted。有 `CAP_SETUID` 的特权进程才能设任意值。
:::
:::

::: method 回忆 4 · `setreuid` 副作用与 `setfsuid`
`setreuid(r,e)` 什么时候会顺手改保存 UID？这条规则坑过什么样的旧代码？`setfsuid` 为什么说「没有错误返回」？
::: sol 答案
若 r 不是 -1，或 e 被设成不等于旧 ruid 的值，saved 被设为新 e。旧代码「`setreuid(uid,0)` 提权、`setreuid(0,uid)` 降权」在第二步后 saved 已变成 uid，永久失去 root。`setfsuid` 无论成败都返回旧 fsuid，失败被静默忽略；正确用法是调用后再 `setfsuid(-1)` 读回比较。要显式控制三个值用 `setresuid`。
:::
:::

::: method 回忆 5 · 三文件字段与 shadow 权限
`/etc/passwd`、`/etc/shadow`、`/etc/group` 各有几个字段？密码字段的 `x` 是什么意思？为什么 `passwd` 程序必须 setuid root？
::: sol 答案
passwd 7 字段：用户名、密码占位、UID、主组 GID、GECOS、家目录、shell。shadow 9 字段：用户名、哈希、最后修改天数等；group 4 字段：组名、占位、GID、成员列表。`x` 表示哈希在 shadow 里。shadow 只有 root（或 shadow 组）可读：本机实测 `-rw-r----- root shadow`，普通用户读报 Permission denied。普通用户要改自己的密码，只能靠 setuid-root 的 `passwd` 代写。
:::
:::

::: method 回忆 6 · `getpwnam_r` 的三态返回
`getpwnam_r` 返回 0 就代表找到了吗？三种结果怎么区分？`ERANGE` 该怎么处理？`pw_dir` 等指针指向哪里？
::: sol 答案
不是。返回 0 且 `*result` 非 NULL 才是找到；返回 0 且 `*result` 为 NULL 是没找到（不是错误）；`ERANGE` 是缓冲区不够，要倍增重试；其它错误码是真错误。`_r` 函数用返回值报错、不设 errno，`perror` 前先 `errno=rc`。`pw_name`/`pw_dir`/`pw_shell` 指向调用者提供的 buf，buf 必须与结构体活得一样久。
:::
:::

::: method 回忆 7 · 附加组与 NSS
附加组从哪来、参与什么检查？`setgroups` 与 `initgroups` 差在哪？`getent` 与 `grep /etc/passwd` 为什么可能结果不同？
::: sol 答案
登录时从组文件初始化，fork 继承；与有效 GID 一起参与文件组权限检查。`setgroups` 直接替换集合（需 `CAP_SETGID`）；`initgroups` 查询某用户的组列表再设置，内部走 NSS。`getent` 按 `/etc/nsswitch.conf` 走完整链（本机实测 `passwd: files systemd sss`），grep 只查本地文件——LDAP/动态用户就会出现「getent 有、grep 无」。
:::
:::

## B. setuid 纪律与攻击面

::: method 回忆 8 · 降权顺序
setuid-root 程序永久降权的正确顺序是什么？为什么先降 UID 会失败？最后一步验证什么？
::: sol 答案
附加组（`setgroups(0,NULL)` 或 `initgroups`）→ GID（`setresgid(g,g,g)`）→ UID（`setresuid(u,u,u)`）→ 验证 `setuid(0)` 必须 `EPERM`、`geteuid()` 等于目标。先降 UID 会失去 `CAP_SETGID`，后面的 `setgroups`/`setresgid` 全部 `EPERM`，附加组还留着 root 的组。每步都要检查返回值，降权失败就退出。
:::
:::

::: method 回忆 9 · 只降 euid 为什么不够
setuid-root 程序里只调 `seteuid(1000)`，之后还能回到 0 吗？为什么？怎样才算不可逆？
::: sol 答案
能。`seteuid` 只改有效 UID，保存 UID 仍是 0，`seteuid(0)` 合法。要不可逆必须 `setresuid(u,u,u)` 把三个都降掉，此后 `setuid(0)` 与 `seteuid(0)` 都 `EPERM`——非特权进程的目标只能是当前 r/e/s 之一，而三者都已不是 0。临时提权再降回的场景才用 `seteuid` 来回切换。
:::
:::

::: method 回忆 10 · setuid 失效的三个原因
`chmod 4755` 之后提权失败，可能有哪三个原因？各用什么命令确认？
::: sol 答案
① 文件系统 `nosuid` 挂载——`findmnt -T` 看选项（本机 `/tmp` 实测无 nosuid，这条是发行版相关）；② 目标是脚本——Linux 忽略脚本的 setuid 位；③ 属主不是 root 或 `no_new_privs` 已置——`stat` 看属主，`/proc/self/status` 看 `NoNewPrivs`。大写 `S` 表示 setuid 位置了但执行位没置，也不能 exec。
:::
:::

::: method 回忆 11 · `system`/`popen` 为什么禁用
setuid-root 程序里为什么不能用 `system()`/`popen()`？AT_SECURE 不是已经清了环境变量吗？
::: sol 答案
两者都起 `/bin/sh`，shell 的功能面大到几乎不可能审计干净；`PATH`、`IFS` 仍来自调用者，`system("cp ...")` 会执行攻击者 PATH 里的同名程序。AT_SECURE 只剥离 `LD_PRELOAD` 等动态链接器变量，不清 `PATH`/`IFS`。必须执行外部程序就用绝对路径 `execve`、参数作数组传、先清环境，最好先永久降权。
:::
:::

::: method 回忆 12 · AT_SECURE 与 `secure_getenv`
AT_SECURE 什么时候置 1？glibc 安全模式剥离哪些变量？`secure_getenv("HOME")` 在 setuid 程序里返回什么？
::: sol 答案
exec 后真实与有效 UID（或 GID）不同，或非 root 进程执行了授予 capability 的文件，内核在 auxv 置 AT_SECURE=1。glibc 剥离 `LD_PRELOAD`、`LD_LIBRARY_PATH`、`LD_AUDIT`、`GCONV_PATH`、`LOCPATH` 等（man ld.so 有全表）。`secure_getenv` 在安全模式下对任何变量都返回 NULL，家目录要用 `getpwuid` 取。
:::
:::

::: method 回忆 13 · `no_new_privs` 的不可逆
`no_new_privs` 置 1 之后发生什么？能撤销吗？子进程继承吗？seccomp 过滤器与它什么关系？
::: sol 答案
后续 `execve` 不再授予新特权：setuid/setgid 位与 file capability 全部失效。不可撤销（man prctl 写明 once set cannot be unset；本机实测传 0 撤销报 `EINVAL`），fork/clone 继承、跨 exec 保留。装 seccomp 过滤器要么先置它、要么有 `CAP_SYS_ADMIN`，否则 `EACCES`。本机实测：置 1 后 exec 带 `cap_net_raw` 的 ping，socket 报 Operation not permitted。
:::
:::

::: method 回忆 14 · 攻击面清单
setuid 程序启动时，除了环境变量还要假设哪些东西已被攻击者控制？各给一个加固动作。
::: sol 答案
fd 0/1/2 可能被关闭或指向攻击者文件（open `/dev/null` 补齐）；cwd 可被换成符号链接农场（`chdir("/")`、绝对路径加 `O_NOFOLLOW`）；umask 影响新建文件权限（显式 `umask(022)`）。core dump 会泄内存（`RLIMIT_CORE=0`、`PR_SET_DUMPABLE=0`）；信号处理器在 root 下跑（只设 `sig_atomic_t` 标志）；检查与使用之间路径可被换（对 fd 做 `fstat`）。
:::
:::

## C. capability 与内核表示

::: method 回忆 15 · 五组集合各管什么
进程的五组 capability 集合各是什么、各管什么？`/proc/self/status` 对应哪五行？
::: sol 答案
Permitted（`CapPrm`）是可用池；Effective（`CapEff`）是当前真正用于检查的子集；Inheritable（`CapInh`）声明哪些位可经文件可继承集带入新程序；Bounding（`CapBnd`）是 exec 能获得的上限、只能减；Ambient（`CapAmb`）让非特权程序把能力带过 exec（Linux 4.3+）。普通用户本机实测前三与 Amb 全 0、Bnd 为 41 位全集。
:::
:::

::: method 回忆 16 · exec 变换公式
写出 exec 时新许可集与新有效集的公式。「`+p` 不带 `e`」的文件执行后能力生效吗？bounding 在哪一步起作用？
::: sol 答案
`P'(permitted)=(I&F(inheritable))|(F(permitted)&B)|P'(ambient)`；`P'(effective)=F(effective)?P'(permitted):P'(ambient)`。只有 `+p` 时 F(effective)=0，新有效集为空（ambient 除外），程序要自己 `capset` 提升。bounding 与文件许可集取 AND，被 `PR_CAPBSET_DROP` 掉的位文件上有也拿不到。
:::
:::

::: method 回忆 17 · `capset` 的边界
`capset()` 能改哪三个集合？新有效集、新许可集各受什么约束？bounding 能用 `capset` 加回来吗？
::: sol 答案
能改 effective、inheritable、permitted。新 effective 必须是新 permitted 的子集；无 `CAP_SETPCAP` 时新 permitted 不能超出旧 permitted∪旧 inheritable，新 inheritable 不能超出旧 inheritable∪旧 permitted。bounding 不能碰，只能 `PR_CAPBSET_DROP` 减（需 `CAP_SETPCAP`）。从 permitted 删掉的位再也拿不回，除非 exec 重新授予。
:::
:::

::: method 回忆 18 · ambient 的规则
ambient capability 解决什么问题？提升一位 ambient 要满足什么条件？四个 prctl 子命令是什么？
::: sol 答案
让非特权程序在 exec 后仍保留指定能力（否则普通文件的 permitted 会被清）。该位必须同时在 permitted 与 inheritable 中，且 `SECBIT_NO_CAP_AMBIENT_RAISE` 未置。子命令：`IS_SET` 查询、`RAISE` 提升、`LOWER` 移除、`CLEAR_ALL` 清空。典型用法：root 启动的服务降权后仍保留 `CAP_NET_BIND_SERVICE` 绑 80 端口。
:::
:::

::: method 回忆 19 · file capability 的 xattr
`setcap` 把能力写进哪个扩展属性？数据结构里 `magic_etc` 怎么读？`+e` 对应哪一位？
::: sol 答案
`security.capability`。头 4 字节 magic_etc：高 8 位是 revision（2 或 3），最低位是 effective 标志；随后是两个 `{permitted, inheritable}` 对（cap 0–31 与 32–63）。revision 3 多一个 rootid，声明对哪个用户命名空间的 root 有效。本机实测 `/usr/bin/ping`：`magic=0x02000001`、permitted 只有 `CAP_NET_RAW(13)`。
:::
:::

::: method 回忆 20 · `struct cred` 的复制—提交
内核为什么把凭证设计成不可变？修改三步是什么？多线程进程里 `setresuid` 改的是谁的凭证？
::: sol 答案
不可变让读路径（`current_cred()`）无锁、信号处理器里读 `geteuid()` 安全。三步：`prepare_creds()` 复制并加引用 → 在副本上改 → `commit_creds()` 用 RCU 原子替换指针，旧副本延迟释放。cred 是线程级的：`setresuid` 只改调用线程，glibc 的 setxid 机制向所有线程广播，以满足 POSIX 的进程级语义。
:::
:::

::: method 回忆 21 · `capable` 与用户命名空间
`capable()` 与 `ns_capable()` 差在哪？容器里的 root 为什么对宿主机文件无效？`uid_map` 的「0 1000 1」怎么读？
::: sol 答案
`capable(cap)` 等价于 `ns_capable(&init_user_ns, cap)`，查初始命名空间；`ns_capable(ns,cap)` 查指定命名空间。容器 root 的 `CAP_SYS_ADMIN` 只在自己的用户命名空间有效。`uid_map` 三列是「命名空间内起点、父命名空间起点、长度」：0 1000 1 表示容器内 UID 0 映射到宿主机 1000。本机 `unshare -Ur` 被 AppArmor 挡，此条按机制读。
:::
:::