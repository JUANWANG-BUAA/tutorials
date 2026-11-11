# 2.9 习题集

三组分层：**A 组概念判断**考「会不会说理由」；**B 组诊断推理**给现象让你判机制、判断点、给修法；**C 组动手实验**除最后一题外全部在这台免 `sudo` 的 Ubuntu 24.04.5 aarch64 虚拟机上真跑过，每题都写「看到什么算对」。共 19 题。每题第一个动作都是「先猜」：把预期写下再验证，猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟；A 组要求说出一段完整因果，B 组写成「现象 → 机制 → 读数 → 修法」四段。
2. 卡住了回对应小节的 errata/method 盒重读，不要直接看答案：A 组对应 2.9.1–2.9.6，B 组对应 2.9.3–2.9.13，C 组对应 2.9.1–2.9.12。
3. C 组命令都按本机设计：临时文件统一 `lab2c9_` 前缀，程序用 `cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2` 编译。清理时**只删 `lab2c9_` 这个精确前缀**，不要宽通配，别碰别人的文件。
4. **环境边界**：`sudo` 需要密码不可用；`unshare -Ur` 被 AppArmor 挡（`apparmor_restrict_unprivileged_userns=1`）；`getfattr` 未装。凡需 root 的步骤一律标「需 root，本机未实测」，不要为了跑通去猜数字。aarch64 的调用号与 x86 不同，别抄 x86 表格。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch09-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 2.9-A1 · 四个 UID 与 `id` 的盲区 {#ex-2.9-A1}

先猜：一个 setuid-root 程序运行时，`id` 显示 `uid=1000` 还是 `uid=0`？`/proc/self/status` 的 `Uid:` 行四列是什么？哪一列 `id` 永远看不到？

说出四个 UID 各自的用途；解释为什么排查 setuid 问题必须看 `/proc` 而不是只看 `id`。

::: sol 解答

`id` 显示真实 UID（1000）与有效 UID（0）两个值，但看不到保存 UID 与文件系统 UID。四件套分工：真实 UID 决定归属与信号权限；有效 UID 是权限检查用的身份；保存 UID 是 exec 时的快照、给临时降权留退路；文件系统 UID 只管文件访问（Linux 专有）。setuid-root 程序的 `Uid:` 行是 `1000 0 0 0`——第三列的 0 正是「还能变回 root」的退路，`id` 看不到它，就会误判降权是否彻底。**判据**：四个用途说全；「id 看不到 saved」点明；`1000 0 0 0` 的顺序写对。

:::
:::

::: ex 例 2.9-A2 · exec setuid-root 的变换与脚本例外 {#ex-2.9-A2}

先猜：uid=1000 的用户 exec 属主 root 的 setuid 程序，ruid/euid/suid/fsuid 各是多少？给一个 `#!/bin/sh` 脚本 `chmod 4755` 再执行，euid 会变吗？

解释变换规则的两个条件（setuid 位、非 nosuid）；说明脚本为什么无效；给出需要提权时的替代方案。

::: sol 解答

ruid=1000 不变，euid=suid=fsuid=0（fsuid 跟随 euid）。规则成立要两个条件：文件带 setuid 位、文件系统没有以 `nosuid` 挂载。脚本无效：脚本由解释器执行，Linux 内核忽略 `#!` 文件上的 setuid/setgid 位，解释器进程用的是调用者的凭证——这是为了防止解释器启动过程中的竞态攻击。替代方案：编译成二进制再 setuid，或用 `sudo` 规则授权特定命令；更克制的做法是给二进制 `setcap` 单一能力。**判据**：四个值写对；两个条件说全；「解释器用调用者凭证」是脚本无效的根因。

:::
:::

::: ex 例 2.9-A3 · 非特权进程的合法目标集合 {#ex-2.9-A3}

先猜：普通用户进程（r=e=s=1000）调用 `setresuid(0,0,0)` 返回什么？`setuid(1000)` 呢？`seteuid(0)` 呢？

说出三个调用对非特权进程的规则；解释 `setresuid(u,u,u)` 之后为什么 `setuid(0)` 必然失败。

::: sol 解答

`setresuid(0,0,0)` 返回 -1、`EPERM`：三个参数各自必须是当前 r/e/s 之一，0 不在其中。`setuid(1000)` 成功但只改有效 UID（非特权语义），这里三个值本来就相等、等于没变。`seteuid(0)` 同样 `EPERM`。`setresuid(u,u,u)` 把三个都设成 u 后，当前 r/e/s 里没有 0，非特权进程的任何切换目标都不合法，所以 `setuid(0)` 必然 `EPERM`——这就是「不可逆降权」的机制。本机 `cred_rules` 实测第三条报 Operation not permitted。**判据**：三个返回值判对；「目标限当前 r/e/s」说死；不可逆的推理链完整。

:::
:::

::: ex 例 2.9-A4 · 三文件与 `passwd` 的特权来源 {#ex-2.9-A4}

先猜：`/etc/passwd` 一行有几个字段？密码字段的 `x` 是什么意思？普通用户为什么写不了 `/etc/shadow`，`passwd` 又凭什么能写？

背出三文件的字段数与关键字段；用权限位解释 `passwd` 必须是 setuid root。

::: sol 解答

passwd 7 字段（用户名、占位、UID、主组 GID、GECOS、家目录、shell）；shadow 9 字段（用户名、哈希、最后修改天数等）；group 4 字段（组名、占位、GID、成员）。`x` 表示密码哈希移到了 shadow。本机实测 `/etc/shadow` 是 `-rw-r----- root shadow`，普通用户既不是属主也不在 shadow 组，读都报 Permission denied，更不用说写。`passwd` 是 `4755 root:root`（本机实测）：exec 后 euid=0，以 root 身份代写用户自己的哈希，写完降回。这就是「把一段小程序提权」比「把用户提权」更克制的例子。**判据**：7/9/4 说对；shadow 权限位与组解释清楚；setuid 代写逻辑完整。

:::
:::

::: ex 例 2.9-A5 · 五组集合与 bounding 的单向性 {#ex-2.9-A5}

先猜：普通用户的 `CapPrm`、`CapEff`、`CapBnd` 各是什么？进程能不能用 `capset` 把 `CapBnd` 里被删掉的位加回来？

说出五组集合各自的角色；解释 bounding 为什么只能减；说明 `+ep` 与 `+p` 在 exec 后的差别。

::: sol 解答

本机实测普通用户 CapPrm/CapEff/CapInh/CapAmb 全 0，CapBnd 是 `000001ffffffffff`（41 位全集）。五组角色：Permitted 是可用池，Effective 是当前生效子集，Inheritable 声明可经文件带入的位，Bounding 是 exec 获得能力的上限，Ambient 让非特权程序带能力过 exec。bounding 只能用 `PR_CAPBSET_DROP` 减（需 `CAP_SETPCAP`），`capset` 碰不到它——被删的位在 exec 公式里与文件许可集取 AND，文件上有也拿不到。`+ep` 的文件 effective 位为 1，exec 后 E'=P' 直接生效；`+p` 则 E' 为空，程序要自己 `capset` 提升。**判据**：五角色说全；「只能减」的机制（AND 公式）讲清；ep/p 差别说对。

:::
:::

::: ex 例 2.9-A6 · `getpwnam_r` 返回 0 的两种含义 {#ex-2.9-A6}

先猜：`getpwnam_r("nosuchuser", &pw, buf, sizeof buf, &res)` 返回 0，能直接读 `pw.pw_uid` 吗？返回 `ERANGE` 是失败吗？

画出三态返回的判断顺序；说明 `ERANGE` 的正确处理与 buf 的生命周期。

::: sol 解答

不能。返回 0 有两种含义：`res != NULL` 才是找到；`res == NULL` 是没找到，此时 `pw` 内容未定义，直接读是 bug。`ERANGE` 不是失败而是「缓冲区不够」：从合理大小（如 1024）开始倍增重试，设上限防御。其它非零返回码是真错误（`EIO`、`ENOMEM`、NSS 后端错误），且 `_r` 函数不设 errno，`perror` 前先 `errno = rc`。`pw.pw_name`/`pw_dir`/`pw_shell` 指向 buf 内部，buf 释放后这些指针全部悬空——要么 buf 与结构体同生命周期，要么立刻 `strdup`。**判据**：三态顺序先 rc 后 res；ERANGE 是重试；buf 生命周期说清。

:::
:::

## B 组 · 诊断推理

::: ex 例 2.9-B1 · 权限被拒：先分层再怀疑人生 {#ex-2.9-B1}

现象：服务进程读一个文件报 `EPERM`；`ls -l` 看 rwx 位明明够，`id` 看 UID/GID 也对。

按「现象 → 机制 → 读数 → 修法」四段作答；给出从 DAC 到 LSM 的排查顺序。

::: sol 解答

**现象**：DAC 位与身份都「对」，仍然被拒。**机制**：Linux 的拒绝可能来自四层——capability 不足、LSM（SELinux/AppArmor）拒绝、只读挂载、seccomp 过滤；四层的报错都是 `EPERM`/`EACCES`，光看 errno 分不出来。**读数**：先 `id` 与 `/proc/<pid>/status` 的 `Uid:` 四件套、`CapEff`（`capsh --decode` 解码）确认有效身份与能力；再 `findmnt -T` 看挂载是否只读；`dmesg`/audit 日志找 LSM 拒绝记录（本机 `dmesg_restrict` 下需特权，按未实测读）。**修法**：按层修——缺能力用 `setcap` 补单一位而不是整个 root；LSM 拒绝改策略；只读挂载换路径。顺序是先身份、再能力、再挂载、最后 LSM，不要一上来就 `chmod 777`。**判据**：四层说全；`CapEff` 与 `Uid:` 四件套是第一读数；「chmod 777 修不了 capability」点明。

:::
:::

::: ex 例 2.9-B2 · 降权后还能回到 root {#ex-2.9-B2}

现象：一个 setuid-root 程序自认为已降权（`geteuid()` 返回 1000），但安全审计发现它被利用后仍能读 `/etc/shadow`。

按四段作答；指出最可能的代码缺陷；给出验证降权彻底性的两行代码。

::: sol 解答

**现象**：euid 已是 1000，特权却还在。**机制**：代码只调了 `seteuid(1000)`（或 `setuid(1000)` 的非特权语义），保存 UID 仍是 0；攻击者控制执行流后调 `seteuid(0)` 就回到 root——saved 就是为此设计的退路，降权不删它等于留后门。**读数**：`/proc/<pid>/status` 的 `Uid:` 行是 `1000 1000 0 1000`，第三列暴露 saved=0。**修法**：用 `setresuid(u,u,u)` 三个一起降；降完验证 `errno=0; if (setuid(0)==0 || errno!=EPERM) { /* 降权失败，退出 */ }`，再核对 `getresuid` 三个值都等于 u。附加组也要清（`setgroups(0,NULL)`），否则 shadow 组照样能读。**判据**：「saved 还是 0」是根因；四件套第三列是读数；验证代码与附加组都提到。

:::
:::

::: ex 例 2.9-B3 · 降权顺序写反之后 {#ex-2.9-B3}

现象：降权代码写成 `setresuid(u,u,u); setgroups(0,NULL); setresgid(g,g,g);`，运行日志里后两个调用都报 `EPERM`，进程却还属于一堆特权组。

按四段作答；解释为什么后两步失败；写出正确顺序。

::: sol 解答

**现象**：UID 降了，组没降掉。**机制**：`setresuid(u,u,u)` 之后进程失去 `CAP_SETUID` 也失去 `CAP_SETGID`（capability 随 UID 0 一起没了）；`setgroups` 与 `setresgid` 都需要 `CAP_SETGID`，于是 `EPERM`。结果是「半降权」：UID 是普通用户，附加组与 GID 还是 root 的，shadow、docker 等组权限照样生效。**读数**：日志里两个 `EPERM`；`/proc/<pid>/status` 的 `Gid:` 行与 `Groups:` 行仍是旧值。**修法**：顺序固定为附加组 → GID → UID，每步检查返回值，任何一步失败立即退出而不是继续。提升时顺序相反（先 UID 后 GID）。**判据**：「先降 UID 丢 CAP_SETGID」是根因；半降权的后果说清；顺序与失败即退出都给出。

:::
:::

::: ex 例 2.9-B4 · setuid 程序里的 `system("cp ...")` {#ex-2.9-B4}

现象：setuid-root 程序里一行 `system("cp /etc/shadow /tmp/backup");`，安全评审直接打回。开发者的理由是「glibc 在 setuid 时会清环境变量，PATH 注入不了」。

按四段作答；指出开发者混淆了哪两件事；给出两种正确写法。

::: sol 解答

**现象**：评审打回，开发者不服。**机制**：混淆了「动态链接器变量」与「所有环境变量」。AT_SECURE 安全模式剥离的是 `LD_PRELOAD`、`LD_LIBRARY_PATH`、`LD_AUDIT`、`GCONV_PATH` 等（man ld.so 有全表）；`PATH`、`IFS` 不在剥离之列，仍来自调用者。`system` 起 `/bin/sh -c`，shell 按 PATH 找 `cp`——攻击者把恶意 `cp` 放进 PATH 前置目录，就以 root 执行了任意代码。**读数**：`getauxval(AT_SECURE)` 返回 1 只说明 `LD_*` 被清；`getenv("PATH")` 仍能读到调用者的值。**修法**：① 根本不过 shell——`execve("/bin/cp", argv, 最小环境)` 绝对路径加参数数组；② 更好是把特权缩到最小：开 fd 的小程序提权，把 fd 传给降权后的 worker。**判据**：两件事分开；PATH/IFS 不在剥离列表是根因；execve 绝对路径修法给出。

:::
:::

::: ex 例 2.9-B5 · `chmod 4755` 放在 /tmp 提权失败 {#ex-2.9-B5}

现象：教程说「`/tmp` 下的 setuid 程序不生效」；你在自己的 Ubuntu 24.04 VM 上 `findmnt -T /tmp` 却看不到 `nosuid`。谁错了？

按四段作答；列出 setuid 失效的全部条件；说明本机 `/tmp` 的实测口径。

::: sol 解答

**现象**：通则与本机观测冲突。**机制**：「`/tmp` 必然 nosuid」是发行版相关的加固做法（部分发行版与容器把 `/tmp` 单独挂载加 `nosuid`），不是内核通则。setuid 失效的条件共有：文件是脚本、挂载 `nosuid`、属主不对、`no_new_privs` 已置、执行位没置（大写 S）。**读数**：本机实测 `findmnt -T /tmp` 显示 `/tmp` 与 `/` 同在 `/dev/sda2` ext4，选项只有 `rw,relatime`——这台机器上 `/tmp` 并不忽略 setuid（但 `chown root` 需要 root，未实测完整提权）。**修法**：判断时逐条核对而不是背通则；`findmnt -T <路径>` 看挂载、`stat` 看属主与 s 位、`/proc/self/status` 看 `NoNewPrivs`。**判据**：「发行版相关」说清；五个失效条件列全；本机读数与通则分开引用。

:::
:::

::: ex 例 2.9-B6 · `getent` 查得到，`grep` 查不到 {#ex-2.9-B6}

现象：`id someuser` 与 `getent passwd someuser` 都正常，`grep someuser /etc/passwd` 却一行都没有。

按四段作答；解释 NSS 查询链；给出排查命令与容器里的对应现象。

::: sol 解答

**现象**：三个查询结果不一致。**机制**：glibc 的用户查询走 NSS（Name Service Switch），按 `/etc/nsswitch.conf` 的 `passwd:` 行依次尝试后端；`grep` 只查本地文件。后端可能是 `files systemd`（动态用户）或 `sss`/`ldap`（网络目录），用户不在 `/etc/passwd` 里也能被查到。**读数**：本机实测 `passwd: files systemd sss`；`getent passwd $(whoami)` 与 `grep` 结果一致（本地用户），差异要造一个 NSS-only 用户才能看到（需 root，未实测）。**修法**：排查用户问题一律用 `getent` 而不是 `grep`；容器里 `/etc/passwd` 是镜像自带的静态文件，挂载宿主机文件后数字 UID 相同但名字映射可能不同——`ls -l` 显示数字 UID 就是「当前 NSS 链里没有这个名字」。**判据**：NSS 链是根因；getent 是正确工具；容器数字 UID 现象解释对。

:::
:::

## C 组 · 动手实验

::: ex 例 2.9-C1 · 读自己的四件套与五个 capability 集合 {#ex-2.9-C1}

先猜：普通用户 shell 的 `CapPrm`/`CapEff` 是全 0 还是全 1？`CapBnd` 呢？`Uid:` 四列会不同吗？

运行下面的命令，把五行位图用 `capsh --decode` 翻成名字，数一数 bounding 里有几个能力。

```bash
grep -E '^(Uid|Gid|CapInh|CapPrm|CapEff|CapBnd|CapAmb|NoNewPrivs):' /proc/self/status
capsh --decode=000001ffffffffff
```

::: sol 解答

本机实测（ubuntu24，aarch64，UID 1000）：

```text
实测（ubuntu24 aarch64）：
Uid:	1000	1000	1000	1000
Gid:	1000	1000	1000	1000
CapInh:	0000000000000000
CapPrm:	0000000000000000
CapEff:	0000000000000000
CapBnd:	000001ffffffffff
CapAmb:	0000000000000000
NoNewPrivs:	0
```

`capsh --decode` 把这个位图翻成 41 个名字（实测，中间节选）：`cap_chown,cap_dac_override,cap_dac_read_search,…,cap_perfmon,cap_bpf,cap_checkpoint_restore`。读法：普通用户没有任何可用能力（Prm/Eff 全 0），但 bounding 是全集——它只是「exec 时最多能拿到」的上限，不是「现在拥有」。四列 UID 相同说明这不是 setuid 程序。**看到什么算对**：Prm/Eff/Inh/Amb 全 0；Bnd 解码数出 41 个；能说出「bounding 是上限不是持有」。

:::
:::

::: ex 例 2.9-C2 · `id`、`getent` 与 shadow 的权限边界 {#ex-2.9-C2}

先猜：`id -G` 与 C 程序 `getgroups()` 返回的组列表顺序一样吗？普通用户 `head -1 /etc/shadow` 会报什么？

运行下面的命令，对照三处组列表的顺序与 `/etc/shadow` 的权限位。

```bash
id
id -u
id -G
getent passwd $(whoami)
grep "^$(whoami):" /etc/passwd
ls -l /etc/shadow
head -1 /etc/shadow
```

::: sol 解答

本机实测（ubuntu24，aarch64）：

```text
实测（ubuntu24 aarch64）：
uid=1000(juanwang) gid=1000(juanwang) groups=1000(juanwang),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),100(users),114(lpadmin),125(docker)
1000
1000 4 24 27 30 46 100 114 125
juanwang:x:1000:1000:JUANWANG:/home/juanwang:/bin/bash
juanwang:x:1000:1000:JUANWANG:/home/juanwang:/bin/bash
-rw-r----- 1 root shadow 1360 Oct 21 20:07 /etc/shadow
head: cannot open '/etc/shadow' for reading: Permission denied
```

读法：`id -G` 把主组放最前（1000 4 24 …），而 `getgroups()` 返回升序（4 24 … 1000，见 C3）——同一个集合、两种排序，别当成不一致。`getent` 与 `grep` 对本地用户结果相同；shadow 属主 root、属组 shadow、其他用户无权限，普通用户读报 Permission denied，这正是 `passwd` 需要 setuid 的原因。**看到什么算对**：两种组顺序都能解释；shadow 权限位读对；Permission denied 与「passwd 为什么 setuid」连起来。

:::
:::

::: ex 例 2.9-C3 · 写 C 程序打印三件套与附加组 {#ex-2.9-C3}

先猜：`getuid()`、`geteuid()`、`getresuid()` 三个接口在普通用户进程里返回什么？`getgroups(0, NULL)` 返回什么？`prctl(PR_GET_NO_NEW_PRIVS)` 呢？

编译运行下面的程序，把输出与 C1 的 `/proc` 读数逐项对照。

```c
/* lab2c9_ids.c：免特权打印 UID/GID 三件套、附加组与 no_new_privs */
#include <errno.h>
#include <grp.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/prctl.h>
#include <unistd.h>

int main(void)
{
    uid_t r, e, s;
    gid_t gr, ge, gs;
    if (getresuid(&r, &e, &s) == -1 || getresgid(&gr, &ge, &gs) == -1) {
        perror("getresuid/getresgid");
        return EXIT_FAILURE;
    }
    printf("getuid=%ld geteuid=%ld\n", (long)getuid(), (long)geteuid());
    printf("getresuid: real=%ld effective=%ld saved=%ld\n",
           (long)r, (long)e, (long)s);
    printf("getresgid: real=%ld effective=%ld saved=%ld\n",
           (long)gr, (long)ge, (long)gs);

    int n = getgroups(0, NULL);
    if (n == -1) {
        perror("getgroups");
        return EXIT_FAILURE;
    }
    gid_t *list = calloc((size_t)n + 1, sizeof *list);
    if (list == NULL) {
        perror("calloc");
        return EXIT_FAILURE;
    }
    if (getgroups(n, list) == -1) {
        perror("getgroups");
        free(list);
        return EXIT_FAILURE;
    }
    printf("supplementary groups (%d):", n);
    for (int i = 0; i < n; i++)
        printf(" %ld", (long)list[i]);
    printf("\n");
    free(list);

    int nnp = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
    if (nnp == -1) {
        perror("prctl(PR_GET_NO_NEW_PRIVS)");
        return EXIT_FAILURE;
    }
    printf("PR_GET_NO_NEW_PRIVS = %d\n", nnp);
    return EXIT_SUCCESS;
}
```

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c9_ids.c -o lab2c9_ids
timeout 10 ./lab2c9_ids
```

::: sol 解答

本机实测（ubuntu24，aarch64，GCC 13.3.0，编译零警告）：

```text
实测（ubuntu24 aarch64）：
getuid=1000 geteuid=1000
getresuid: real=1000 effective=1000 saved=1000
getresgid: real=1000 effective=1000 saved=1000
supplementary groups (9): 4 24 27 30 46 100 114 125 1000
PR_GET_NO_NEW_PRIVS = 0
```

读法：三个接口与 `/proc/self/status` 完全一致；`getresuid` 是唯一能拿到 saved 的标准接口（`getuid`/`geteuid` 各只给一个）。`getgroups(0, NULL)` 不填数组、只返回数量，用来先探大小再分配——这是「两段式调用」的标准姿势。附加组升序排列，与 `id -G` 的主组优先不同。**看到什么算对**：三件套与 C1 对上；两段式 getgroups 说清；nnp=0 与 `/proc` 的 `NoNewPrivs: 0` 一致。

:::
:::

::: ex 例 2.9-C4 · 只读观察系统的两种特权来源 {#ex-2.9-C4}

先猜：`/usr/bin/passwd` 与 `/usr/bin/ping` 的特权来源一样吗？`stat` 的 s 位与 `getcap` 的输出各说明什么？ping 的 xattr 里 permitted 有几个位？

运行下面的命令；`file_caps.c` 从正文 2.9.10 原样抽出编译（本机已复跑验证），用它解码 ping 的 `security.capability`。

```bash
stat -c '%A %a %U:%G %n' /usr/bin/passwd /usr/bin/ping
getcap /usr/bin/ping
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 file_caps.c -o file_caps
timeout 10 ./file_caps /usr/bin/ping
timeout 10 ./file_caps /usr/bin/passwd
```

::: sol 解答

本机实测（ubuntu24，aarch64）：

```text
实测（ubuntu24 aarch64）：
-rwsr-xr-x 4755 root:root /usr/bin/passwd
-rwxr-xr-x 755 root:root /usr/bin/ping
/usr/bin/ping cap_net_raw=ep
magic=0x02000001 revision=2 effective_flag=1
permitted : CAP_NET_RAW(13)
inheritable: (empty)
mode=0755 setuid=0 setgid=0
/usr/bin/passwd: no file capability
```

读法：passwd 靠 setuid 位（4755 的 s），exec 后 euid=0、拿到全部能力；ping 没有 s 位，靠 file capability 只拿 `CAP_NET_RAW` 一个位——这就是「拆 root」的现成样例。xattr 头 4 字节 `0x02000001`：revision=2、最低位 effective=1（对应 `=ep` 的 e）；permitted 只有第 13 位。本机 `getfattr` 未装，读 xattr 用 `getxattr` 程序即可，免特权。**看到什么算对**：两种特权来源分清；magic 的 revision 与 effective 位读对；permitted 只有 CAP_NET_RAW(13)。

:::
:::

::: ex 例 2.9-C5 · `no_new_privs`：读回、不可逆、挡住 file capability {#ex-2.9-C5}

先猜：普通用户能设置 `no_new_privs` 吗？设置后还能撤销吗？本机 `ping_group_range` 是 `1 0`（实测，禁用了非特权 ICMP DGRAM），ping 靠 file capability 用 raw socket——先置 `no_new_privs` 再 exec ping 会怎样？

编译运行下面的程序，先不带参数跑一遍，再带 `set` 跑一遍，对照两次输出。

```c
/* lab2c9_nnp.c：no_new_privs 的读回、不可逆与对 file capability 的效果 */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/prctl.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    int before = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
    printf("before: PR_GET_NO_NEW_PRIVS=%d\n", before);

    if (argc > 1 && strcmp(argv[1], "set") == 0) {
        if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) == -1) {
            perror("prctl(PR_SET_NO_NEW_PRIVS,1)");
            return EXIT_FAILURE;
        }
        int after = prctl(PR_GET_NO_NEW_PRIVS, 0, 0, 0, 0);
        printf("after set: PR_GET_NO_NEW_PRIVS=%d\n", after);

        /* 尝试撤销：arg2 只允许 1，传 0 直接 EINVAL */
        errno = 0;
        int rc = prctl(PR_SET_NO_NEW_PRIVS, 0, 0, 0, 0);
        printf("unset try: rc=%d errno=%d (%s)\n", rc, errno, strerror(errno));
    }

    /* exec 会换掉地址空间，先冲刷 stdio 缓冲，否则上面的 printf 全部丢失 */
    fflush(NULL);
    char *av[] = { "ping", "-c1", "-W2", "127.0.0.1", NULL };
    execv("/usr/bin/ping", av);
    perror("execv ping");
    return EXIT_FAILURE;
}
```

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 lab2c9_nnp.c -o lab2c9_nnp
timeout 10 ./lab2c9_nnp
timeout 10 ./lab2c9_nnp set
```

::: sol 解答

本机实测（ubuntu24，aarch64）。不带参数：ping 正常收到回包（exec 时 file capability 授予了 `CAP_NET_RAW`）：

```text
实测（ubuntu24 aarch64，./lab2c9_nnp）：
before: PR_GET_NO_NEW_PRIVS=0
PING 127.0.0.1 (127.0.0.1) 56(84) bytes of data.
64 bytes from 127.0.0.1: icmp_seq=1 ttl=64 time=0.064 ms
```

带 `set`：置 1 成功、撤销报 EINVAL、ping 的 raw socket 被拒（退出码 2）：

```text
实测（ubuntu24 aarch64，./lab2c9_nnp set）：
before: PR_GET_NO_NEW_PRIVS=0
after set: PR_GET_NO_NEW_PRIVS=1
unset try: rc=-1 errno=22 (Invalid argument)
ping: socktype: SOCK_RAW
ping: socket: Operation not permitted
ping: => missing cap_net_raw+p capability or setuid?
```

读法：三条结论一次看清——① 设置它不需要任何特权；② 不可逆（传 0 撤销直接 `EINVAL`，man prctl 也写明 once set cannot be unset）；③ 它让 exec 不再授予新特权，ping 文件上的 `cap_net_raw=ep` 失效，socket 报 `Operation not permitted`。这正是容器运行时堵提权路径的机制。程序里 `fflush(NULL)` 不能省：stdout 接管道时是全缓冲，exec 换掉地址空间会把没冲刷的 printf 全部带走。RTT 数值每次运行不同，属正常波动，别当固定值。**看到什么算对**：两次运行对照成立；EINVAL 与 ping 失败都复现；能解释 fflush 为什么必需。

:::
:::

::: ex 例 2.9-C6 · 复跑正文 `cred_rules`：非特权切换规则 {#ex-2.9-C6}

先猜：普通用户进程依次调 `setresuid(r,r,s)`、`setresuid(r,s,s)`、`setresuid(0,0,0)`，各成功还是失败？失败时 errno 是什么？

把正文 2.9.8 的 `cred_rules.c` 原样抽出编译运行（不要自己另写一份），对照规则矩阵预测每一步。

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 cred_rules.c -o cred_rules
timeout 10 ./cred_rules
```

::: sol 解答

本机实测（ubuntu24，aarch64，程序与正文逐字一致）：

```text
实测（ubuntu24 aarch64）：
start : ruid=1000 euid=1000 suid=1000 rgid=1000 egid=1000 sgid=1000
setresuid(r,r,s): ok
after1: ruid=1000 euid=1000 suid=1000 rgid=1000 egid=1000 sgid=1000
setresuid(r,s,s): ok
setresuid(0,0,0): Operation not permitted (expected for non-root)
end   : ruid=1000 euid=1000 suid=1000 rgid=1000 egid=1000 sgid=1000
```

读法：前两步的目标都在当前 r/e/s 集合里，合法（这里三者相等，改了等于没改）；第三步目标 0 不在集合里，`EPERM`。失败的调用不改变任何凭证（0/1 效应），所以 `end` 行与 `start` 行一致。若把程序 setuid-root 后再跑，`start` 会变成 `ruid=1000 euid=0 suid=0`，第三步也会成功——因为 0 在集合里（需 root，本机未实测）。**看到什么算对**：三步结果与矩阵预测一致；「失败不改凭证」说清；setuid 后的变体能推演。

:::
:::

::: ex 例 2.9-C7 · 需 root 的完整验证：setcap 与降权骨架 {#ex-2.9-C7}

先猜：给 `/bin/true` 的副本 `setcap cap_net_bind_service=+ep` 后，`getcap` 显示什么？正文 `drop_privs.c` 做成 setuid-root 后以普通用户跑，`Uid:` 行降权后是什么？

本题需要 root（`setcap`、`chown`、`chmod 4755`），**本机未实测**。在有 root 的机器上按下面命令做，逐条核对预期判据；不要在没有权限的机器上猜输出。

```bash
# 需 root：file capability 授予与读回
cp /bin/true /tmp/lab2c9_capdemo
sudo setcap cap_net_bind_service=+ep /tmp/lab2c9_capdemo
getcap /tmp/lab2c9_capdemo
timeout 10 ./file_caps /tmp/lab2c9_capdemo

# 需 root：降权骨架的完整验证（drop_privs.c 见正文 2.9.5）
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 drop_privs.c -o drop_privs
sudo chown root:root drop_privs && sudo chmod 4755 drop_privs
timeout 10 ./drop_privs

# 需 root：cap_drop 的完整路径（cap_drop.c 见正文 2.9.6）
sudo timeout 10 ./cap_drop
```

::: sol 解答

预期判据（未实测，需 root；机制依据见正文 2.9.5、2.9.6、2.9.10）：

```text
未实测（需 root）——预期形状：
/tmp/lab2c9_capdemo cap_net_bind_service=ep
magic=0x02000001 revision=2 effective_flag=1
permitted : CAP_NET_BIND_SERVICE(10)
before drop: open /etc/shadow -> ok
Uid:	1000	1000	1000	1000
after  drop: open /etc/shadow -> Permission denied
before: raw socket -> ok
after : raw socket -> Operation not permitted
```

逐条核对：`getcap` 显示 `cap_net_bind_service=ep`；`file_caps` 解码 permitted 只有第 10 位；`drop_privs` 降权前能开 shadow、降权后四列全 1000 且再开报 Permission denied、`setuid(0)` 验证失败、最后 exec `id` 显示附加组已清；`cap_drop` 丢 `CAP_NET_RAW` 前 raw socket 成功、之后 `EPERM`。任何一条不符都说明该机器上有额外限制（nosuid、LSM、bounding 裁剪），按 B1 的分层顺序排查。本机已实测的边界：`drop_privs` 以普通用户跑会打印「需要 setuid root（当前 euid=1000）」退出；`cap_drop` 在 `prctl(PR_CAPBSET_DROP)` 处报 Operation not permitted——这两条本身就是「特权路径不可用」的读数。**看到什么算对**：在 root 机器上四条判据全过；能把本机两条边界读数与完整路径区分开。

:::
:::