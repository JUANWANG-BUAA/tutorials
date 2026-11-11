# 2.9 学习目标自检表

这张表接管 [2.9.14 本章小结](ch09.md#sec-2.9.14)原有的达标线。正文原七条出口表抄存于下（正文末节已改为「本章小结」），再按**概念（K）、动手（S）、实验（E）、口径（B）**四组展开成 21 条——左列是达标项，中列是「怎样算达标」（全部写成能当场做的动作），右列是「没达标回到哪一节」。动手前先确认环境边界：测试机是 aarch64 VM，`sudo` 不可用、`unshare -Ur` 被 AppArmor 挡，哪些能做、哪些只能按「未实测」读，全在[勘误与版本注记](ch09-errata.md)。

## 出口表（接管正文 2.9.14）

| 检查项 | 达标线 | 没达标去哪 |
|:--|:--|:--|
| 说出四个 UID 各决定什么 | 能区分 real/effective/saved/fs | [2.9.1](ch09.md#sec-2.9.1) |
| 读懂 `/etc/passwd`/`shadow`/`group` | 能说出每个字段与权限 | [2.9.2](ch09.md#sec-2.9.2) |
| 解释 setuid exec 的凭证变化 | 能说出 ruid 不变、euid/suid 变 | [2.9.3](ch09.md#sec-2.9.3) |
| 写出正确降权顺序 | 组 → GID → UID → 验证 | [2.9.5](ch09.md#sec-2.9.5) |
| 解释 capability 五组集合 | 能说出 bounding 只能减 | [2.9.6](ch09.md#sec-2.9.6) |
| 用 `setcap` 替代 setuid | 能给出 `cap_net_bind_service=+ep` | [2.9.6](ch09.md#sec-2.9.6) |
| 解释 setuid 脚本为何无效 | 能说出内核忽略脚本的 setuid 位 | [2.9.3](ch09.md#sec-2.9.3) |

## 达标检验

| 检查项 | 达标线 | 回哪一节 |
|:--|:--|:--|
| **K1 四件套分工** | 能各说一句：real 管归属与信号、effective 管权限检查、saved 是 exec 快照留退路、fs 只管文件访问；说出 `id` 看不到 saved、`/proc` 四列的顺序 | [2.9.1](ch09.md#sec-2.9.1) |
| **K2 exec setuid 变换** | 能写出 uid=1000 执行 setuid-root 后四列 `1000 0 0 0`；说出两个前提（setuid 位、非 nosuid）与脚本例外 | [2.9.3](ch09.md#sec-2.9.3) |
| **K3 非特权切换规则** | 能说出 `setuid`/`seteuid` 只改 euid 且目标限 real/saved、`setresuid` 三参数各限当前 r/e/s；推出 `setresuid(u,u,u)` 后 `setuid(0)` 必 EPERM | [2.9.4](ch09.md#sec-2.9.4)、[2.9.8](ch09.md#sec-2.9.8) |
| **K4 三文件字段** | 能背 7/9/4 字段数与关键字段；解释 `x` 占位、shadow 的 root:shadow 权限、`passwd` 为什么 setuid | [2.9.2](ch09.md#sec-2.9.2) |
| **K5 `_r` 三态与 NSS** | 能画出「先 rc 后 `*result`」的判断顺序；ERANGE 倍增重试；说出 `getent` 走 NSS 全链、`grep` 只查本地 | [2.9.9](ch09.md#sec-2.9.9) |
| **K6 五集合与 bounding** | 能各说一句 Prm/Eff/Inh/Bnd/Amb 的角色；用 exec 公式解释 bounding 只能减；说出 `+ep` 与 `+p` 的差别 | [2.9.6](ch09.md#sec-2.9.6)、[2.9.10](ch09.md#sec-2.9.10) |
| **K7 降权顺序与不可逆** | 能写出组 → GID → UID → 验证；解释先降 UID 丢 `CAP_SETGID`；说出只降 euid 时 saved 仍是 0 的后门 | [2.9.5](ch09.md#sec-2.9.5) |
| **K8 no_new_privs 与 AT_SECURE** | 能说出 no_new_privs 不可逆、fork/exec 继承、让 setuid 与 file caps 失效；说出 AT_SECURE 剥离 `LD_*` 但不剥 `PATH`/`IFS` | [2.9.8](ch09.md#sec-2.9.8)、[2.9.11](ch09.md#sec-2.9.11) |
| **S1 show_creds 复跑** | 能编译正文 `show_creds.c` 并报出：Uid 四列全 1000、附加组 9 个（4 24 27 30 46 100 114 125 1000）、CapEff=0、CapBnd=`000001ffffffffff` | [2.9.3](ch09.md#sec-2.9.3) |
| **S2 cred_rules 复跑** | 能编译正文 `cred_rules.c` 并报出：`setresuid(r,r,s)` ok、`setresuid(r,s,s)` ok、`setresuid(0,0,0)` Operation not permitted、end 行与 start 一致 | [2.9.8](ch09.md#sec-2.9.8) |
| **S3 nss_lookup 复跑** | 能编译正文 `nss_lookup.c` 并报出：`user=juanwang uid=1000 gid=1000 home=/home/juanwang shell=/bin/bash`、groups(9) 含 sudo(27) 与 docker(125)；查不存在用户打印 no such user | [2.9.9](ch09.md#sec-2.9.9) |
| **S4 三件套程序** | 合上正文写出 `getuid`/`geteuid`/`getresuid` 打印程序（习题 C3），编译零警告；输出与 `/proc/self/status` 逐项一致 | [2.9.1](ch09.md#sec-2.9.1) |
| **S5 file_caps 解码** | 能编译正文 `file_caps.c` 对 `/usr/bin/ping` 报出：`magic=0x02000001 revision=2 effective_flag=1`、permitted 只有 CAP_NET_RAW(13)；对 passwd 报 no file capability | [2.9.10](ch09.md#sec-2.9.10) |
| **S6 no_new_privs 程序** | 能写出习题 C5 的程序（含 exec 前 `fflush(NULL)`）；带 `set` 跑报出 after=1、unset EINVAL、ping socket Operation not permitted | [2.9.11](ch09.md#sec-2.9.11) |
| **E1 位图解码** | 能用 `capsh --decode=000001ffffffffff` 数出 41 个能力；说出普通用户 Prm/Eff 全 0 而 Bnd 全集的含义（上限不是持有） | [2.9.6](ch09.md#sec-2.9.6) |
| **E2 身份与 shadow 边界** | 能跑 `id`/`id -G`/`getent` 对照，解释主组优先与升序两种排序；`head -1 /etc/shadow` 报 Permission denied 并连到 passwd 的 setuid | [2.9.2](ch09.md#sec-2.9.2) |
| **E3 两种特权来源** | 能用 `stat` 与 `getcap` 分清 passwd（4755 setuid）与 ping（0755 + `cap_net_raw=ep`）；说出后者为什么更克制 | [2.9.3](ch09.md#sec-2.9.3)、[2.9.6](ch09.md#sec-2.9.6) |
| **E4 no_new_privs 效果** | 能复现习题 C5 的两次运行对照：默认 ping 通、置 1 后 ping 报 missing cap_net_raw；解释这是 exec 不再授予新特权 | [2.9.11](ch09.md#sec-2.9.11) |
| **E5 需 root 项的判据** | 能写出 `setcap cap_net_bind_service=+ep` 与 `chown root + chmod 4755` 的命令与预期判据（习题 C7），并明确标注本机未实测；不伪造输出 | [2.9.5](ch09.md#sec-2.9.5)、[2.9.6](ch09.md#sec-2.9.6) |
| **B1 数字归属** | 能把本章数字分四类各举一例：规范条款（非特权目标限 r/e/s）、本机读数（UID 1000、41 位、调用号 146/147/90/91/167）、随内核/架构变（能力位数、调用号、nosuid）、未实测（setcap 授予、完整降权、unshare） | [勘误与版本注记](ch09-errata.md) |
| **B2 本机环境边界** | 能报出测试机口径（aarch64、内核 7.0.0-38、glibc 2.39、man-pages 6.7）；说出 sudo 不可用、AppArmor 挡 userns、getfattr 未装各挡住哪些实验 | [章总览·环境口径](ch09-overview.md)、[勘误页](ch09-errata.md) |

## 没达标怎么办

- **K 组卡住**：每个概念先讲一句完整因果再说下一步。例：「因为非特权进程的目标只能是当前 r/e/s 之一，而 `setresuid(u,u,u)` 之后三者都不是 0，所以 `setuid(0)` 必然 EPERM」。讲不出因果就回对应小节的 errata 盒重读。
- **S 组卡住**：合上正文在 `/tmp/lab2c9_` 前缀下重做对应程序（习题集 C 组有完整代码与编译命令）；跑不出先核对头文件与编译选项。正文程序一律从书里抽出来编译，不要另写副本——副本跑通不代表书里的版本跑通。
- **E 组卡住**：先确认命令在本机哪些跑不了（sudo 挡 setcap/chown、AppArmor 挡 unshare、getfattr 未装），把这些「跑不了」本身当读数记下来，不要改成凭印象的输出。
- **B 组卡住**：把想引用的每个数字问三遍：这是条款、本机读数，还是随内核/架构变的量？后两类必须带出处。aarch64 的调用号别抄 x86——`setuid` 是 146、`capget` 是 90。
- **只有 K 组全对**：说明还停在「会读」。本章要求会跑、会取证；把 S 组与 E 组做完再来勾这一页。

全部达标后，往下的接口有两处：[2.10 信号](ch10.md) 的「处理器里只能调 async-signal-safe 函数」与本章 2.9.7 的「读凭证安全、改凭证不安全」是同一类约束；[项目 A](../projects/pa.md) 的 Stage 7 把本章的 `capset`/`no_new_privs`/seccomp 组装成容器安全边界。项目侧「容器 root 不等于宿主 root」「服务降权不彻底」「exec 后重新提权」三类问题的判据分别沉淀在 [2.9.7](ch09.md#sec-2.9.7)、[2.9.5](ch09.md#sec-2.9.5) 与 [2.9.11](ch09.md#sec-2.9.11)。