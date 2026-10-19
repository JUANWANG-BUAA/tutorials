# B 跨书勘误与共享系统调用

## B.1 为什么单独列一页

这本书与《Linux 系统与内核》共享一批系统调用与 shell 语义。共享带来两个风险：**同一个错误被抄两遍**，以及**修了一本、另一本仍是错的**。

前面的 Linux 卷在五处出现过可复现的错误：wait status 被当成低 8 位退出码、`mq_open`/`sem_open` 被写成固定四参数、`clone` 的 `child_tid` 参数错位、`TZ` 空值被当成系统时区、`pipefail`/`ulimit`/`jobs` 的语义写反。本页把这五处集中纠正，并给出**在本仓库里真实运行过**的证据。正文（3.2、3.5、4.6、8.3、8.5、10.7、13.5、13.6）引用本页，不再各自造一套说法。

本页的原则是：**能跑的就跑，不能跑的就标平台**。Linux 专属的检查在 `experiments/errata/verify-linux.sh` 里；macOS 上运行会打印 `SKIP`，不会伪装通过。

## B.2 wait status：`0x2a00` 不是退出码

### B.2.1 编码

`waitpid` 返回的 `status` 是内核编码的**等待状态**，不是退出码：

| 位 | 含义 |
|:--|:--|
| 低 7 位 | 终止信号编号；0 表示正常退出 |
| 第 8 位（`0x80`） | core dump 标志 |
| 高 8 位 | 退出码（仅当 `WIFEXITED` 为真） |

所以正确顺序是：先 `WIFEXITED(status)`，再用 `WEXITSTATUS(status)` 取高 8 位。

::: note 定义 B.2.1 · 等待状态
`wait`/`waitpid`/`waitid` 返回的状态是一个位编码，不是进程的返回值。可移植的解读只能通过 `<sys/wait.h>` 的宏：

- `WIFEXITED(status)`：是否正常退出；
- `WEXITSTATUS(status)`：正常退出时的退出码；
- `WIFSIGNALED(status)` / `WTERMSIG(status)`：是否被信号终止、哪个信号；
- `WIFSTOPPED(status)` / `WSTOPSIG(status)`：是否停止、哪个信号；
- `WCOREDUMP(status)`：是否产生 core（非 POSIX，但 Linux/BSD 都有）。

直接对 `status` 做 `& 0xff` 或 `>> 8`，只在特定平台、特定路径上偶然正确。
:::

### B.2.2 可运行证据

`experiments/errata/wait_status.c` 让子进程 `_exit(42)`，父进程打印原始状态与宏的结果：

```bash
cd agent-systems/experiments/errata
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g wait_status.c -o /tmp/wait_status
/tmp/wait_status
```

```text
raw status      = 0x2a00
WIFEXITED       = 1
WEXITSTATUS     = 42
low byte        = 0x00
WIFSIGNALED     = 0
status as int   = 10752  (wrong)
```

这张输出说明什么：`0x2a00` 的低字节是 `0x00`，但退出码是 `42`。把低字节当退出码会得到 0（误判成功）；把整个 `status` 当退出码会得到 10752。两种错法都会让 agent 的 runner 误判工具执行结果。

### B.2.3 `/proc/PID/stat` 的 exit_code

`proc_pid_stat(5)` 对第 52 个字段的说明是「the thread's exit status in the form reported by `waitpid(2)`」。也就是说，它同样是等待状态编码，不是「低 8 位退出码」。`experiments/errata/proc_stat_exit.c` 在 Linux 上验证：子进程退出 42 后，父进程用 `waitid(WNOWAIT)` 保持僵尸，读第 52 字段，再 `waitpid` 对比。

预期输出（Ubuntu 24.04 / Linux 6.8）：

```text
/proc exit_code = 10752 (0x2a00)
wait status     = 0x2a00
WEXITSTATUS     = 42
low byte        = 0x00
```

结论：读 `/proc/PID/stat` 的 `exit_code` 之后，仍然要用 `WEXITSTATUS` 解读；更稳的做法是直接用 `waitid`/`waitpid`，不要依赖 `/proc` 的字段位置（它会随内核版本增加字段）。

::: errata 关于退出状态的四个误解
1. **「`status & 0xff` 就是退出码」**——低 7 位是信号，第 8 位是 core；退出码在高 8 位。
2. **「`WEXITSTATUS` 对信号终止也有效」**——只在 `WIFEXITED` 为真时有意义；被信号终止时退出码是未定义的。
3. **「`/proc/PID/stat` 的 exit_code 是 0–255」**——它是 wait 编码，可能是 10752 这样的值。
4. **「退出码 0 就是成功」**——还要看 `WIFSIGNALED`；一个被 `SIGKILL` 的进程没有正常退出码，不能当成 0。
:::

## B.3 `mq_open` / `sem_open` 是 variadic

### B.3.1 原型

```c
#include <mqueue.h>
mqd_t mq_open(const char *name, int oflag, ... /* mode_t mode, struct mq_attr *attr */);

#include <semaphore.h>
sem_t *sem_open(const char *name, int oflag, ... /* mode_t mode, unsigned int value */);
```

规则只有一条：**可变参数只在带 `O_CREAT` 时出现**。

| 调用 | 参数个数 | 额外参数 |
|:--|--:|:--|
| `mq_open(name, O_RDONLY)` | 2 | 无 |
| `mq_open(name, O_CREAT \| O_RDWR, 0600, NULL)` | 4 | `mode`, `attr`（`attr` 可为 `NULL`） |
| `sem_open(name, 0)` | 2 | 无 |
| `sem_open(name, O_CREAT, 0600, 1)` | 4 | `mode`, `value` |

写成「固定四参数」会导致两个问题：无 `O_CREAT` 时多传参数（未定义行为/编译告警），以及把 `sem_open` 的 `value` 与 `mq_open` 的 `attr` 混淆。

### B.3.2 可运行证据

`experiments/errata/mq_sem_proto.c` 同时写 2 参数与 4 参数调用。它不要求 2 参数调用成功（队列不存在时返回 `ENOENT`），只要求编译、链接、运行通过：

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 mq_sem_proto.c -o /tmp/mq_sem_proto
/tmp/mq_sem_proto
```

预期输出包含：

```text
mq_open 2-arg: errno=2 (ENOENT) — 编译通过即证明 variadic
sem_open 2-arg: errno=2 (ENOENT) — 编译通过即证明 variadic
```

注意：老 glibc 需要 `-lrt`；新 glibc 已并入 libc。若链接报 `mq_open` 未定义，加 `-lrt`。

::: note 为什么 agent 书要管 POSIX 消息队列
多 agent 或多进程工具总线常被实现为消息队列。你可以用 HTTP/gRPC，但在本机低延迟场景，POSIX mq 仍有价值。第 8.3 节用它作对照：消息边界、优先级、阻塞语义。这里纠正原型，是为了让「用 mq 做总线」的示例不会因为参数写错而编译失败。
:::

## B.4 `clone` 的可变参数顺序

### B.4.1 原型与顺序

```c
#define _GNU_SOURCE
#include <sched.h>

int clone(int (*fn)(void *), void *stack, int flags, void *arg,
          ... /* pid_t *parent_tid, void *tls, pid_t *child_tid */);
```

可变参数顺序固定为：

```text
第 5 个参数：parent_tid   （CLONE_PARENT_SETTID 时写入）
第 6 个参数：tls          （CLONE_SETTLS 时作为 TLS 指针）
第 7 个参数：child_tid    （CLONE_CHILD_SETTID 时写入子进程内存）
```

常见错位是**只传两个可变参数**，把 `child_tid` 放到 `tls` 的位置：

```c
/* 错：child_tid 被当成 tls；CLONE_CHILD_SETTID 不生效或崩溃 */
clone(fn, stack, CLONE_CHILD_SETTID | SIGCHLD, arg, &child_tid);
```

正确写法（即使 `tls` 不用，也要占位）：

```c
pid_t parent_tid = 0, child_tid = 0;
clone(fn, stack, CLONE_PARENT_SETTID | CLONE_CHILD_SETTID | SIGCHLD,
      arg, &parent_tid, NULL, &child_tid);
```

更稳的做法是用 `clone3` + `struct clone_args` + `size`，避免可变参数错位；`clone3` 还能返回 `ENOSYS` 时优雅回退。

### B.4.2 可运行证据

`experiments/errata/clone_order.c` 同时设置两个 TID 标志，按 `parent_tid → tls → child_tid` 传参。在 Linux 上：

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 clone_order.c -o /tmp/clone_order
/tmp/clone_order
```

预期：

```text
pid=12345 parent_tid=12345 child_tid=0 WEXITSTATUS=0
```

`child_tid=0` 是正常的：没有 `CLONE_VM` 时，`CLONE_CHILD_SETTID` 写的是**子进程地址空间**里的变量，父进程看不到。关键验证是 `parent_tid == pid` 且子进程正常退出。

## B.5 `TZ` 空值、无法解释与 tzdata 缺失

### B.5.1 规则

`tzset(3)` 的行为：

- `TZ` 未设置：使用系统时区（发行版配置，通常是 `/etc/localtime`）。
- `TZ` 为空串：**UTC**。
- `TZ` 无法解释（如 `TZ=Not/AZone`）：**UTC**。
- `tzdata` 缺失、无法读取时区文件：**静默 UTC**，通常不报错。

最后一条最危险：容器镜像为了减小体积删掉 `/usr/share/zoneinfo`，程序不会崩，只是所有本地时间都变成 UTC。日志、trace、审计时间戳会整体偏移，而且很难从错误信息发现。

### B.5.2 可运行证据

在 macOS（Linux 行为相同）上：

```bash
TZ= date '+%Z %z %H:%M'
TZ=Not/AZone date '+%Z %z %H:%M'
env -u TZ date '+%Z %z %H:%M'
```

```text
UTC +0000 01:40
UTC +0000 01:40
CST +0800 09:40
```

第一行是空值，第二行是无法解释的值，二者都是 UTC；第三行取消设置，才回到系统时区（示例机器是 `CST +0800`）。Python 的 `time.tzname` 在 `TZ=` 时也是 `('UTC', 'UTC')`。

::: errata 关于时间的三个误解
1. **「`TZ=` 等于使用系统时区」**——空值是 UTC；要系统时区，必须 unset，而不是设空。
2. **「时区解析失败会报错」**——多数实现静默回退 UTC；tzdata 缺失也是。
3. **「时间戳带 `Z` 就一定是 UTC」**——`Z` 是格式后缀，不是内容保证；写入前要确认时钟源与时区设置。
:::

## B.6 `pipefail` / `ulimit` / `jobs` 的真实语义

### B.6.1 `pipefail` 与 `PIPESTATUS`

`set -o pipefail` 改变的是**管道的退出状态**：默认取最后一个命令；开启后取**最右边一个非零**状态。`PIPESTATUS` 数组保留每一段的状态，但任何后续命令都会覆盖它。

`experiments/errata/verify_shell.sh` 的真实输出：

```text
pipefail off, status=0
pipefail on,  status=5
PIPESTATUS=0
PIPESTATUS after rerun: 3 5 0
```

对应命令：

```bash
set +o pipefail
( exit 3 ) | ( exit 5 ) | true
echo $?                    # 0：最后一段 true

set -o pipefail
( exit 3 ) | ( exit 5 ) | true
echo $?                    # 5：最右非零

( exit 3 ) | ( exit 5 ) | true
ps=("${PIPESTATUS[@]}")    # 立即取，别让 echo 覆盖
echo "${ps[*]}"            # 3 5 0
```

这张输出说明什么：`pipefail` 不是「任意一段失败就返回该段」，而是「最右非零」。要定位具体哪一段失败，必须用 `PIPESTATUS`，并且**紧接着**取。

### B.6.2 `ulimit` 的软硬限制

`ulimit` 的默认行为**随 shell 不同**，这是最容易被写反的一处：

| shell / 调用 | 默认改谁 | 例子 |
|:--|:--|:--|
| bash，不带 `-S`/`-H` | **同时改软限与硬限** | `ulimit -n 512` 后软硬都是 512 |
| POSIX sh / dash / zsh，不带选项 | 只改软限 | `ulimit -n 512` 后硬限不变 |
| bash / zsh，`-S` | 只改软限 | `ulimit -Sn 4096` |
| bash / zsh，`-H` | 只改硬限 | `ulimit -Hn 8192` |

真实输出（macOS，bash 5.3 与 zsh 对比）：

```text
bash before  S=1048575 H=unlimited
bash after   S=512     H=512          # 默认同时改两者
zsh  before  S=1048575 H=unlimited
zsh  after   S=512     H=unlimited     # 默认只改软限
```

这张输出说明什么：写 `ulimit -n 512` 以为只降软限，在 bash 里会把硬限也降下去；之后想恢复到原来的 `unlimited` 会失败。跨 shell 的脚本必须显式写 `ulimit -S` 或 `ulimit -H`，不要依赖默认值。

软限不能超过硬限；非特权进程可以**降低**硬限，但不能**抬高**。同一脚本的后续输出：

```text
set soft 1024: ok (now 1024, was 1048575)
lower hard to 1024: ok (now 1024)
raise hard to 4096: failed (current 1024); 非 root 不能抬高硬限
```

很多沙箱脚本先 `ulimit -Hn 1024` 再想恢复，结果恢复不了；正确做法是记录原值、在子进程里设置，或由父进程保留高硬限、只给子进程低软限。

还要注意：`rlimit` 是**每进程**的限制，不是聚合限制。它能防单进程打开太多文件，不能防 100 个进程各开 1000 个文件；聚合要靠 cgroup（`pids.max`、`memory.max`）。

### B.6.3 `jobs` 的作用域

`jobs` 列的是**当前 shell 的作业表**。子 shell 是另一个进程，看不到父 shell 的作业。

真实输出：

```text
parent jobs:
[1]+ 88280 Running                    sleep 1 &
subshell jobs:
```

第二段为空。这不是 bug，而是作业控制的定义。沙箱 runner 若要管理后台进程，不能依赖 `jobs`，要用进程组（`setpgid`）、`pidfd` 或 cgroup；`jobs` 只适合交互式 shell。

::: errata 关于 shell 的三个误解
1. **「`pipefail` 会返回第一个失败段」**——返回最右非零；要每段状态用 `PIPESTATUS`。
2. **「`ulimit` 默认只改软限」**——bash 不带选项时同时改软硬；POSIX sh/zsh 才默认只改软。要可移植，显式写 `-S`/`-H`。
3. **「`jobs` 能看到所有后台进程」**——只看当前 shell 的作业表；子 shell、其他会话、daemon 都不在表里。
:::

## B.7 Landlock ABI：网络规则不是 ABI 6

Landlock 的 ABI 与内核版本对应关系容易被记错。按 `landlock(7)`（man-pages 6.19）：

| ABI | 内核 | 新增能力 |
|--:|:--|:--|
| 1 | 5.13 | 文件系统读/写/执行/删除/创建 |
| 2 | 5.19 | `LANDLOCK_ACCESS_FS_REFER`（跨目录 link/rename） |
| 3 | 6.2 | `LANDLOCK_ACCESS_FS_TRUNCATE` |
| 4 | 6.7 | `LANDLOCK_ACCESS_NET_BIND_TCP` / `NET_CONNECT_TCP` |
| 5 | 6.10 | `LANDLOCK_ACCESS_FS_IOCTL_DEV` |
| 6 | 6.12 | `LANDLOCK_SCOPE_ABSTRACT_UNIX_SOCKET` / `SCOPE_SIGNAL` |
| 7 | 6.15 | `landlock_restrict_self` 的日志控制 |
| 8 | 7.0 | `LANDLOCK_RESTRICT_SELF_TSYNC` |
| 9 | 7.1 | `LANDLOCK_ACCESS_FS_RESOLVE_UNIX` |

本书基线 Ubuntu 24.04 / Linux 6.8 → **ABI 4**，因此可以使用 TCP bind/connect 规则，但不能使用 ABI 5/6 的 ioctl 与 IPC scope。`experiments/errata/landlock_probe.c` 在 Linux 上查询 ABI：

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 landlock_probe.c -o /tmp/landlock_probe
/tmp/landlock_probe
```

Linux 6.8 的预期输出：

```text
Landlock ABI = 4
网络规则（TCP bind/connect）可用
```

若输出 `Landlock 不可用`，先检查内核是否启用 `CONFIG_SECURITY_LANDLOCK`、`lsm=` 是否包含 `landlock`。

## B.8 其他容易过时的事实

| 事实 | 本书写法 | 检查方式 |
|:--|:--|:--|
| MCP 最新版 | 2026-07-28；2025-11-25 作为迁移对照 | 看 `modelcontextprotocol.io/specification/2026-07-28` |
| MCP 生命周期 | 新版无 `initialize`/session；`server/discover` + 每请求 `_meta` | 2.5 的两版对照表 |
| MCP 弃用 | Roots/Sampling/Logging 已弃用；Tasks 移到扩展 | 2.9 的迁移表 |
| OCI Runtime Spec | v1.3.0（2025-11） | `specs.opencontainers.org/runtime-spec/` |
| OTel semconv | 1.44.0 | `opentelemetry.io/docs/specs/semconv/` |
| Landlock 网络 | ABI 4（Linux 6.7+） | `landlock(7)` 的 VERSIONS 表 |
| `openat2` | Linux 5.6+；`RESOLVE_BENEATH` 等 | `openat2(2)` |
| `clone3` | Linux 5.3+；用 `size` 字段做版本化 | `clone3(2)` |

这张表说明什么：版本事实要能指向一个可查的页面或命令。正文里写「最新」时，必须带日期；写「支持」时，必须带 ABI 或内核版本。

## B.9 复核清单

发布前逐条跑：

```bash
# 1) 本机可跑：wait status + shell 语义
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 experiments/errata/wait_status.c -o /tmp/wait_status
/tmp/wait_status
bash experiments/errata/verify_shell.sh

# 2) Linux 专属：/proc、mq/sem、clone、landlock
bash experiments/errata/verify-linux.sh

# 3) 时区
TZ= date '+%Z %z'; TZ=Not/AZone date '+%Z %z'
```

预期：`wait_status` 输出 `0x2a00` 与 `WEXITSTATUS=42`；`verify_shell.sh` 输出 `pipefail on, status=5`、`PIPESTATUS 3 5 0`、硬限抬高失败、子 shell 的 `jobs` 为空；`verify-linux.sh` 在 Linux 上全 PASS，在 macOS 上 SKIP；两个 `TZ` 命令都输出 `UTC`。

五项都通过，才能说「跨书勘误已关闭」。任何一项失败，先修本页与正文，再修 Linux 卷对应章节；不要只改一处。
