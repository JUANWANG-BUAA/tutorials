# CHECK-CLOUD-REVIEW-ERRORS：第 5 篇 + 复习层 + 附录 + 卷首 事实核查与文稿核查报告

> 范围：`src/part5/ch01–ch06.md`、`src/review/*.md`（9 页）、`src/appendix/*.md`（6 页）、卷首 8 页（`src/index.md`、`preface.md`、`scope.md`、`objectives.md`、`roadmap.md`、`notation.md`、`env.md`、`entry-test.md`）。
> 性质：**边读边修**。本报告记录全部发现：硬错误直接修（「处置=已修复」），拿不准的只记录（「处置=存疑未修」）。
> 口径：内核 Linux 6.8、用户态 Ubuntu 24.04（Docker 26 / containerd 1.7 / runc 1.1 / systemd 255），以 `写作规范/00-写作总则.md` §3/§4/§5/§7 为准。
> 前置状态：`src/review/cheatsheet-sysprog.md`、`src/review/recall.md` 在工作区已有未提交修改（B6/C3/signal 三处），本次核查**未回退**，并与之保持口径一致。
> 本次另含任务一的 5 处 errata 盒拆分（8 条 → 3–5 + 3–4 条两组，内容逐字保留），见文末附注。

---

## 结论速览

- 第 5 篇逐章通读（6,465 行）：整体口径扎实（namespace/cgroup/overlayfs/OCI/K8s 语义与 man 7 namespaces、cgroup-v2.rst、overlayfs.rst、runtime-spec、K8s 文档一致）。硬错误 **4 处已修复**（1 处 errno 反转、1 处换算值错误、1 处命令错误、2 处章号指错，共 5 项）；存疑 **3 项**未修。
- 卷首 8 页通读：承诺与正文比对，硬错误 **1 处已修复**（总章数 79→85）；题目口径与正文比对，**1 处已修复**（entry-test D3 的「64 位虚拟地址」→「48 位有效虚拟地址」）。
- review 层抽查四张速查表 + recall/mock-exam/compare/glossary/interview 共 30+ 条 part2–part5 相关条目，与正文口径一致；**1 处已修复**（mock-exam 第 8 题与 entry-test 同源的「64 位虚拟地址」）。
- 附录 6 页轻扫：**1 处已修复**（bash 版本归属）；legacy/debugging/toolbox/coverage/references 未发现问题。

---

## A. 已修复（硬错误）

| # | 文件:行 | 原文（摘） | 正确说法 | 证据 | 处置 |
|--:|:--|:--|:--|:--|:--|
| A.1 | `src/part5/ch03.md:1083`（5.3 即时自测 A6） | 「`echo +memory` 会失败（内核返回 `ENOENT`；若控制器根本没编译进内核则是 `ENODEV`）」 | errno 映射写反了。给 `cgroup.subtree_control` 写一个**名字认识但父层未启用**的控制器返回 `ENODEV`；**名字不被内核认识**（如未编译/拼写错）才是 `ENOENT`。memory 属于前者。原答案还与本书 5.3.2 自己的表述（「父没启用，子写了也会 `ENODEV`/`EINVAL`」）矛盾。 | `Documentation/admin-guide/cgroup-v2.rst`（subtree_control 写入示例返回 `write error: No such device`）；内核 `kernel/cgroup/cgroup.c` 的 `cgroup_parse_control()`：名字不匹配注册表 → `-ENOENT`，`cgroup_control()` 未含该位 → `-ENODEV`。 | 已修复（两条 errno 对调） |
| A.2 | `src/part5/ch05.md:707`（5.5.9 resources→cgroup 文件映射表） | `cpu.shares` 行「`1 + ((shares-2)*9999)/262142`，默认 1024 → **100**」 | 按该行自己给出的公式，1024 shares 换算是 **39**（整数除法：1 + 1022×9999/262142 = 1+38 = 39），不是 100（100 是未给 shares 时的 `cpu.weight` 默认值）。本书 5.3.4 的 note 已写明「默认的 1024 shares 在 v2 里对应 `cpu.weight` 约 39，而不是 100」，两处自相矛盾。 | runc `libcontainer/cgroups` 的换算公式即 `1 + ((shares-2)*9999)/262142`；算术复核 1022×9999=10,218,978，÷262,142≈38.98。 | 已修复（100 → 39） |
| A.3 | `src/part5/ch04.md:331`（5.4.6） | 「用 `tar -tf x/blobs/sha256/<digest> \| zcat` 之类的方式看内容」 | 命令是坏的：GNU `tar -tf` 对 gzip blob 会自动解压并列出内容，把输出再管道给 `zcat` 会把**文件清单文本**当 gzip 解压而失败。正确写法 `tar -tzf x/blobs/sha256/<digest>`（或 `zcat <blob> \| tar -t`）。 | GNU tar 手册：`--auto-compress`/格式自动探测；`tar(1)` 对 `-t` 读取归档成员名，不输出压缩流。 | 已修复（改为 `tar -tzf ...`） |
| A.4 | `src/part5/ch02.md:1055`（5.2 出口检查表） | 「用 `NSpid` 读出多层编号 \| …… \| 没达标去哪：**5.2.12**」 | 多层 `NSpid` 实验在 **5.2.14**（「两个实验：嵌套 PID 编号与 `setns` 权限边界」实验一）；5.2.12 是 nsfs ioctl，不含 NSpid 内容。 | 目录核对：5.2.12 = nsfs ioctl；5.2.14 = 嵌套 PID 编号与 NSpid 实验。 | 已修复（5.2.12 → 5.2.14） |
| A.5 | `src/part5/ch04.md:1044`（5.4 出口检查表） | 「按现象定位磁盘与性能问题 \| 至少六条 \| **5.4.13**」 | 「现象→原因→修复」的 15 条排障表在 **5.4.14**（生产陷阱 15 条）；5.4.13 是硬链接、index 与 redirect。 | 目录核对。 | 已修复（5.4.13 → 5.4.14） |
| A.6 | `src/roadmap.md:3` | 「全书 **79 章** + 11 个项目」 | 实际 **85 章**：SUMMARY 逐篇统计 0/1/2/3/4/5 篇 = 14+19+19+15+12+6 = 85，且 `src/index.md` 封面与目录两处都写「85 章」。79 与任何口径都对不上。 | `src/SUMMARY.md` 逐 `- [..]` 计数（卷首 7、复习层 9、附录 6 不计入章）；`src/index.md:6,24`。 | 已修复（79 → 85） |
| A.7 | `src/entry-test.md:48`（D3）、`src/review/mock-exam.md:49`（第 8 题） | 「（一个）**64 位**虚拟地址、4 KiB 页、四级页表各 9 位，一级页表项覆盖……」 | 本书正文口径是 **48 位有效虚拟地址**（四级页表只翻译低 48 位，高 16 位是 canonical 约束）；recall.md C3 的工作区修订也刚统一成「48 位有效虚拟地址」。题干说 64 位会诱导读者用 64 位参与位分配计算。答案本身（12 位偏移、PML4 项覆盖 512 GiB）不用改。 | 本书 `src/part1/ch09.md:12,19,22,65,483`（通篇 48 位 VA + canonical address）；x86-64 四级分页事实（SDM Vol.3）。 | 已修复（两处题干改「48 位有效虚拟地址」，并注「一级（PML4）」防与最末级 PTE 混淆，与 recall C3 口径一致） |
| A.8 | `src/appendix/errata.md:80` | 「bash **5.2 新增** `EPOCHSECONDS`、`SRANDOM`、`wait -n` 等」 | 版本归属错：`EPOCHSECONDS/EPOCHREALTIME` 是 bash **5.0**、`SRANDOM` 是 **5.1**、`wait -n` 是 4.3/5.1 完善。5.2 没有新增这三者（对比 bash 4.x 的正确结论不变：5.x 里才有）。 | Bash 手册（bash 5.0/5.1 NEWS：EPOCHSECONDS in 5.0、SRANDOM in 5.1）。 | 已修复（改为「bash 5.0+ 陆续新增 `EPOCHSECONDS`（5.0）、`SRANDOM`（5.1）、`wait -n` 等」） |

## B. 存疑未修（记录，不改）

| # | 文件:行 | 原文（摘） | 疑点 | 证据情况 | 处置 |
|--:|:--|:--|:--|:--|:--|
| B.1 | `src/part5/ch01.md:491–492`（5.1.9 合法性矩阵） | 「`CLONE_SIGHAND \| CLONE_NEWPID` → `EINVAL`」「`CLONE_SIGHAND \| CLONE_NEWUSER` → `EINVAL`」 | `man 2 clone` 的 ERRORS 只明确列出 NEWNS+FS、NEWUSER+FS、THREAD 无 SIGHAND、SIGHAND 无 VM 等；SIGHAND+NEWPID/NEWUSER 两条不在 man 页清单里。书内 5.1.11 实验一声称在 6.8 上实测返回 EINVAL，且 errata 已注「某些内核先做 capabilities 检查返回 EPERM」。 | 本核查环境为 macOS，无法在 Linux 6.8 上复现；man 页未列 ≠ 不成立（copy_process 里确有多个标志组合检查）。倾向可信。 | 存疑未修 |
| B.2 | `src/part5/ch03.md:512`（5.3.9） | 「v2 把 v1 的十几个子系统收敛成**九个**控制器」随后表格 9 行，其中 freezer 行备注「v2 里不再算独立控制器」 | 计数与备注有轻微张力：若 freezer 不算，则是 8 个。属表述层面，不是可证伪的硬错误（cgroup-v2.rst 的控制器清单也正是 cpu/cpuset/memory/io/pids/hugetlb/rdma/misc 共 8 个 + freezer 说明）。 | `Documentation/admin-guide/cgroup-v2.rst` 控制器列表。 | 存疑未修（如需改：把「九个」改「八个（freezer 升为核心功能）」） |
| B.3 | `src/roadmap.md:93`（路线 C） | 路线 C「可以跳过：0.7–0.9、2.5–2.6、**5.6**」，但其最小必读集完全不含第 5 篇，而项目选项 A1（mini 容器运行时）依赖 5.1–5.5 | 「可以跳过」仅点名 5.6、却未把 5.1–5.5 列入任何集合，读者选 A1 时所需的第 5 篇路径没有交代。属课程设计层面取舍，非硬错误，不宜由核查代理代改。 | 路线 A（应用运维）已完整覆盖 5.1–5.6。 | 存疑未修（建议主线程决定是否在路线 C 加一句「选 A1 需补第 5 篇」） |

## C. 已核对无问题（要点摘录）

- **part5 逐章硬断言**：八种 namespace 表与引入版本、`PROC_PID_INIT_INO=0xEFFFFFFC=4026531836`、`CLONE_NEW*` 常量值、PID 1 信号语义（无处理器信号忽略、祖先 ns 的 SIGKILL 例外、init 退出全组杀）、`setns` 进 PID ns 只能后代（`EINVAL`）、`uid_map`/`gid_map` 一次写、`setgroups=deny` 前置、Ubuntu 24.04 `apparmor_restrict_unprivileged_userns=1`、`max_*_namespaces` 触顶 `ENOSPC`、cgroup v2 三条规则与 `EBUSY/ENOTEMPTY/ENODEV`、`cpu.max` 期程范围 1000–1000000µs、`--cpu-shares→cpu.weight` 公式、`memory.high` 节流 vs `memory.max` OOM、`pids` 计任务数、`cgroup.freeze`=5.2/`kill`=5.14/`memory.reclaim`=5.19、PSI、委托公共祖先检查、overlayfs 四目录/copy-up 触发条件（写打开即复制）/whiteout 0:0/opaque/redirect/metacopy 冲突矩阵（与 v6.8 `overlayfs.rst` 逐条一致，含 `redirect_dir=follow`+`metacopy=on`+upperdir → EINVAL、`nfs_export` 依赖 `index`）、`OVL_MAX_STACK=500`、`d_type` 与 NFS 不能做 upper、`xino`、chainID/diffID/cache-id、OCI `config.json` 字段落点与 hooks 时机（createRuntime 在 runtime ns、createContainer 在容器 ns 且 pivot 前）、`--privileged` 四件事、Docker 默认 14 能力与 `CapEff=a80425fb`、runc 三阶段 nsexec 顺序、CNI 环境变量/`prevResult`/host-local 租约、kube-proxy `statistic` 按连接、ClusterIP ping 不通、VXLAN 50 字节、`nf_conntrack_tcp_timeout_established=432000s`、br_netfilter 实验结论——均与 man-pages/内核文档/runtime-spec/K8s 文档一致。
- **卷首承诺一致性**：preface 三条路线、scope 母本清单、objectives C1–C12 的章节引用（0.4/2.9/5.2/5.6 等均有效）、notation/env/entry-test 其余 23 题答案、index 路线卡与项目数（11 个：A1–A3/B1–B2/C1–C3/D1–D3）——均与正文/项目页一致。
- **review 层抽查（30+ 条）**：cheatsheet-kernel 版本差异表（io_uring 5.1/clone3 5.3/pidfd 5.1/openat2 5.6/tcp_tw_recycle 4.12 移除）、cheatsheet-net（MSS=MTU-40/-60、最小 MTU 68、softnet_stat 第二列 drop、SYN/accept 两队列、syncookies 默认 1）、cheatsheet-sysprog（errno 语义、`sem_post` 在 async-signal-safe 列表、close 不重试、sigsuspend 行——均为工作区既有修订，保留）、recall B/C/E/F 各卡、mock-exam 单选 1–10 答案与简答评分点、compare 五张表（含 namespace/cgroup/VM、CFS/EEVDF 6.6+）、glossary F 组、interview 送命题——与 part2–part5 口径一致。
- **appendix**：legacy（ReiserFS 已移除、EEVDF 6.6+、vsyscall=none/emulated）、toolbox、debugging（`%util`/`svctm`/`aqu-sz` 误读提示）、references、coverage 矩阵的 part5 行——无问题。

## D. 附注：errata 盒拆分（任务一）

| 章 | 原盒 | 拆分后 |
|:--|:--|:--|
| ch01:1003 | 「OCI 配置与换根的八个坑」(8) | 「OCI config 字段的五个坑」(5) +「运行时与镜像的三个坑」(3) |
| ch02:878 | 「nsfs ioctl 的八个坑」(8) | 「ioctl 返回值与 fd 的五个坑」(5) +「访问权限与身份标识的三个坑」(3) |
| ch03:999 | 「委托的八个坑」(8) | 「文件属主与进程迁移的四个坑」(4) +「systemd 委托与 nsdelegate 的四个坑」(4) |
| ch04:990 | 「硬链接、index 与 redirect 的八个坑」(8) | 「index 与 redirect 的四个坑」(4) +「metacopy、userxattr 与层一致性的四个坑」(4) |
| ch06:874 | 「四个开关的八个坑」(8) | 「sysctl 开关与 VXLAN 开销的四个坑」(4) +「PMTU、netns 转发与规则顺序的四个坑」(4) |

五盒均无 `{#anchor}`（无需迁移）；条目文字逐字保留，仅组内重新编号；`:::` 配平经 `tools/check_book.py` 复核。ch05 无 8 条盒（最大 6 条），不在拆分范围。

---

> 复核命令：`cd linux && python3 tools/check_book.py`（拆分后与收工后均为 0 问题）；行数变化见任务报告（远小于 ±3%）。
