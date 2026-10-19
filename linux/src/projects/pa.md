# 项目 A · 云原生主线：容器运行时 · HTTP 服务器 · eBPF 观测

<div class="chapter-index">
<div><span class="ci-label">项目目标</span><p>不借助 Docker、nginx、bpftrace 的成品，用 C17 写出三个能互相咬合的系统：一个能跑真实进程的迷你容器运行时 <code>mycontainer</code>，一个能扛住 <code>wrk</code> 的 HTTP/1.1 服务器 <code>myhttpd</code>，一个能在内核里数清 <code>openat</code> 与 TCP 事件的观测器 <code>mybpf</code>。最后把三者拼成一条演示链路：容器里跑服务器，服务器产生负载，eBPF 从内核侧解释负载的形状。</p></div>
<div><span class="ci-label">完成后你能</span><p>用 <code>clone</code> 与 cgroup v2 起一个受限额的进程；用 <code>pivot_root</code> 与 overlayfs 换根并解释写时复制；读懂 OCI <code>config.json</code> 的字段如何落到系统调用；写一个 ET 模式的 epoll 服务器并解释每一次 <code>EAGAIN</code>；用 <code>sendfile</code> 与 <code>SO_REUSEPORT</code> 把吞吐推上去；用 bpftrace 定位问题，再用 libbpf 把它做成常驻指标。</p></div>
</div>

第 5 篇讲清了容器的三件套，第 4 篇讲清了 epoll 与收包路径，第 3 篇讲清了 kprobe 与 tracepoint 的挂载点。但它们各自停在「原理」这一侧：`unshare` 是别人写的，`epoll` 的循环没有真的跑过一万个连接，`bpftrace` 一行命令背后的 verifier 与 map 也没有亲手碰过。

这一页把三块拼成一个项目。它不要求你复刻 Docker 或 nginx，而要求**把核心机制做对，并用测试、压测与观测证明它是对的**。三个子项目的分工是：

- `mycontainer` 造出**边界**：一组进程看见不同的 `/`、不同的 PID、不同的网卡，并且被限额；
- `myhttpd` 在边界里制造**负载**：一个真的能解析 HTTP、能 keep-alive、能被 `wrk` 压出数据的服务器；
- `mybpf` 从边界外**观测**：不修改被测程序，从内核侧数清 `openat` 与 TCP 状态变化。

三者共享同一批内核对象——`task_struct`、`cgroup`、`struct socket`、`struct file`。只会其中一个，排查线上问题时就只能猜：容器里慢了，是 cgroup 限流、是 epoll 事件丢了、还是 overlayfs 在 copy-up？这三样正好是三个子项目各自教会你观察的东西。

## A.0 总览与选做路线 {#sec-a.0}

三个子项目不是三道互不相干的练习题，而是一条闭环：**造边界 → 在边界里跑 → 从边界外看**。

<pre class="layout">
        ① 造边界                        ② 在边界里跑                     ③ 从边界外看
┌────────────────────────┐      ┌────────────────────────┐      ┌────────────────────────┐
│      mycontainer       │      │        myhttpd         │      │         mybpf          │
│ namespace / cgroup v2  │ 跑   │ epoll ET / HTTP 解析   │ 负载 │ kprobe / tracepoint    │
│ overlayfs / pivot_root │─────▶│ sendfile / 线程池      │─────▶│ map 聚合 / libbpf      │
│ OCI / 信号 / seccomp   │      │ keep-alive / 超时      │      │ Prometheus / 开销对比  │
└───────────┬────────────┘      └───────────┬────────────┘      └───────────┬────────────┘
            │                               │                               │
            └──── 限额：memory.max ─────────┴──── 同一批请求与进程 ─────────┘
                              A.4 把三条线接成一个可复现的演示
</pre>

读这张图要抓住两条箭头：`mycontainer → myhttpd` 是「同一台机器上的真实负载」，`myhttpd → mybpf` 是「同一个问题的两种证据」。A.4 的演示里，`wrk` 的 P99、`myhttpd` 的 `/metrics`、`mybpf` 的 `openat` 速率会同时出现在一张表上；三者对不上，就说明你对系统的理解还有一块是猜的。

**为什么选这三个而不是别的**：容器、HTTP 服务器、eBPF 是云原生栈上三个不同层次的代表，而且它们的依赖关系是单向的——容器不需要 HTTP，HTTP 不需要 eBPF，但演示需要前两者。这意味着你可以只做其中一个而不烂尾，也可以按任意顺序做（A.3 的 Stage 5 会复用 A.2 的 `/metrics`，所以全做时建议 A.2 在前）。

| 子项目 | 难度 | 投入 | 前置章节 | 最小可交付 | Stage 数 |
|:--|:--|:--|:--|:--|--:|
| A.1 `mycontainer` | ★★★★ | 30–40 h | 5.1、5.2 | `run` 起 busybox，PID/mount/net 隔离 + 内存上限 + 信号转发 | 9 |
| A.2 `myhttpd` | ★★★★ | 30–40 h | 2.16–2.18、4.5、4.8 | 静态文件 + keep-alive + 1 万连接压测报告 | 9 |
| A.3 `mybpf` | ★★★★ | 20–30 h | 3.3、3.15、4.8 | 追踪 `openat` 与 TCP 状态，导出 Prometheus 指标 | 7 |

### 环境与安全 {#sec-a.0.1}

容器与 eBPF 都会改宿主状态：前者建 namespace、挂 overlay、写 cgroup；后者加载内核程序、挂 kprobe。**必须在一台可以随时回滚的虚拟机里做**，不要在共享机器、公司开发机或你自己的主力机上直接跑。

| 项 | 建议值 | 说明 |
|:--|:--|:--|
| 系统 | Ubuntu 24.04 LTS（x86-64 或 arm64） | 本书命令以 24.04 为准；22.04 也可，`clone3`/`openat2` 都在 |
| 内核 | ≥ 5.15，推荐 6.8 | cgroup v2、`openat2`、`BPF_MAP_TYPE_RINGBUF` 都需要较新内核 |
| 资源 | 4 vCPU / 8 GB / 40 GB | `wrk` 与服务端同机会抢 CPU，压测时再调整 |
| 权限 | root（`sudo -i`） | namespace、cgroup、mount、eBPF 都要 `CAP_SYS_ADMIN` |
| 快照 | 动手前打一个 | 挂载传播写错会污染宿主 `/proc`，见 [5.1.4](../part5/ch01.md#sec-5.1.4) |
| 网段 | `10.88.0.0/24` | 容器地址 `10.88.0.2`，网桥 `10.88.0.1`，避免与局域网冲突 |
| 端口 | 8080、9090 | 8080 给 `myhttpd`，9090 留给 Prometheus（可选） |

```bash
# 在虚拟机里；确认版本与 cgroup 模式
uname -r                       # 6.8.0-xx-generic
stat -fc %T /sys/fs/cgroup     # cgroup2fs
nproc; free -h
```

`cgroup2fs` 是硬性前提：cgroup v1 的 `memory.limit_in_bytes` 与本书代码完全不兼容。若输出是 `tmpfs`，说明系统仍挂载 v1，需要改内核启动参数 `systemd.unified_cgroup_hierarchy=1`（24.04 默认已是 v2）。

::: note 三条安全红线
1. **不要在宿主机上验证挂载传播**。`mount --make-rshared /` 加一次错误的 `mount` 就能覆盖宿主的 `/proc`，恢复要重启。
2. **不要给容器 `--privileged` 做实验**。A.1 的 Stage 7 专门讲为什么它等价于宿主 root；自己写的运行时永远不要默认给。
3. **eBPF 只挂自己的实验环境**。kprobe 挂错符号最多让内核报错，但 `bpf()` 程序写错循环会让 soft lockup；用 `timeout` 包住你的加载器。
:::

### 建议顺序与裁剪 {#sec-a.0.2}

| 你的目标 | 顺序 | 可以砍掉 |
|:--|:--|:--|
| 想懂「容器到底是什么」 | A.1 Stage 0–7，再做 A.4 的前半 | A.2 的 Stage 5–7、A.3 全部 |
| 想做高性能服务 | A.2 Stage 0–8，A.3 Stage 0–3 | A.1 全部（用 Docker 代替） |
| 想学内核观测 | A.3 Stage 0–6，再补 A.2 Stage 6 | A.1 全部，A.2 的 Stage 3–5 |
| 全做（推荐） | A.2 → A.1 → A.3 → A.4 | 时间不够时，每条只做到 Stage 4 |

三条裁剪原则：

- **Stage 0–2 不能跳**。它们是「能编译、能跑、能验证」的地基，后面所有 Stage 都在这个地基上加东西。
- **Stage 5 之后的增强可以换顺序**。比如 A.1 的 Stage 6（信号）与 Stage 7（安全）互不依赖；A.2 的 Stage 5（`SO_REUSEPORT`）可以先做再补 Stage 3（线程池）。
- **压测与观测不能省**。一个没有数据的项目只是「代码写完了」，验收表里的性能与可观测两栏会是 0 分。

### 这一页怎么用 {#sec-a.0.3}

每个 Stage 固定六件：

1. **目标**：一条命令加预期输出，做到什么算过；
2. **关键概念**：回看哪一章、用哪些系统调用；
3. **代码**：完整可编译的函数或文件，标注文件名；
4. **验证**：`make`、运行、预期输出、失败时查什么；
5. **常见错误**：3–6 条，带真实报错文本；
6. **下一步**：这一 Stage 留下的债务。

工作流只有一条硬规则：**每个 Stage 结束打一个 `git tag stage-N`**。Tag 是回滚点，也是你写复盘时的证据链；不要停在「改了一半编译不过」的状态。

::: note 关于「实测」的说明
本页的 HTTP 解析器、定时器最小堆、Prometheus 指标渲染三个纯用户态模块，已在 Apple clang 21（C17、`-Wall -Wextra -Werror`）下通过单元测试与 ASan/UBSan。**容器与 eBPF 部分依赖 Linux 内核，写作环境（macOS）无法运行**：所有预期输出按 Ubuntu 24.04 + 内核 6.8 的语义给出，命令旁标注「未实测」的，需要你在虚拟机里跑过再把真实输出写进报告。

这不是免责声明，而是工程纪律：没跑过的数字不许进压测报告。本书正文里的容器示例（[5.1.4](../part5/ch01.md#sec-5.1.4)）同理。
:::

## A.1 迷你容器运行时 `mycontainer` {#sec-a.1}

### A.1.1 目标与真实对应物 {#sec-a.1.1}

`mycontainer` 要实现 `runc` 的核心路径：读一份配置，准备 rootfs，创建命名空间，写 cgroup，换根，收窄权限，`execve` 用户进程，然后在生命周期内转发信号、回收僵尸、把退出码传回去。

真实的 `runc` 有 2 万多行 Go，还依赖 `libcontainer`、nsenter 自举、console、cgroupfs 与 systemd 两套驱动。我们只做**单机、单容器、无镜像仓库**的子集，但每一个动作都对应真实实现里的一个函数：

| 我们做的 | 真实对应物 | 不做的 | 为什么可以不做 |
|:--|:--|:--|:--|
| `clone(CLONE_NEW*)` | `libcontainer/nsenter` + `clone` | user namespace 默认开启 | 需要 subuid 配置，放到 5.2.6 与扩展里 |
| 写 `memory.max`/`cpu.max`/`pids.max` | `cgroups/fs2` | systemd cgroup 驱动 | 直接写 cgroupfs 更容易看清语义 |
| overlayfs + `pivot_root` | `rootfs_linux.go` | 镜像解包与 layer 校验 | 用 `docker export` 得到一个现成 rootfs |
| 读 `config.json` | `spec.go` + `validate` | 完整 OCI 校验 | 只实现用到的字段，缺字段给默认值 |
| `capset`/`seccomp`/`no_new_privs` | `libcontainer/security` | LSM 策略（AppArmor/SELinux） | 发行版默认策略已在，讲清接口即可 |
| 信号转发 + 回收僵尸 | `runc init` + `signalHandler` | console/pty 管理 | 用继承的 stdio 就够演示 |
| 退出码与 `delete` | `runc delete` | checkpoint/restore（CRIU） | 超出单机项目范围 |

九个 Stage 与 `runc` 内部模块的对应关系：

| Stage | 你写的东西 | `runc` 里的位置 | 验收信号 |
|--:|:--|:--|:--|
| 0 | CLI、`fork`/`exec`、退出码 | `main.go`、`utils_linux.go` | 能跑 `/bin/echo`，退出码原样返回 |
| 1 | `clone` + 五种 namespace | `nsenter`、`init_linux.go` | `ps` 只看到自己，`hostname` 独立 |
| 2 | cgroup v2 限额 | `cgroups/fs2/*.go` | 超内存被 OOM kill，fork 炸弹被 `pids.max` 挡住 |
| 3 | overlayfs + `pivot_root` | `rootfs_linux.go` | `/` 是 overlay，写入落到 upper |
| 4 | OCI `config.json` | `spec.go` | `spec` 生成的配置能被自己消费 |
| 5 | veth/bridge + 容器内配网 | `network`（真实实现里在 CNI 插件） | 容器能 ping 宿主与外网 |
| 6 | init、信号、`ps`/`kill`/`rm` | `init.go`、`signal.go` | `kill -TERM` 能优雅退出，无僵尸 |
| 7 | capabilities/seccomp/NNP | `security/*.go` | `CapEff` 为空、`Seccomp: 2`、`mount` 返回 `EPERM` |
| 8 | 验收脚本与复盘 | `tests/` | 六项检查全绿，报告可复现 |

**最小可交付**（做完 Stage 7 就该有）：

```bash
# 需要 root；在虚拟机里执行
sudo ./build/mycontainer run \
    --rootfs /var/lib/mycontainer/rootfs \
    --hostname demo --memory 64M --pids 32 --cpu 50 \
    --ip 10.88.0.2 --init -- /bin/sh
# 进入后：
#   hostname            → demo
#   ps                  → 只有 sh 与 ps
#   grep -E 'CapEff|Seccomp|NoNewPrivs' /proc/self/status
#   CapEff: 0000000000000000
#   Seccomp: 2
#   NoNewPrivs: 1
```

### A.1.2 架构：父子分工与数据流 {#sec-a.1.2}

容器的初始化有一条硬约束：**有些事必须在 `clone` 之前做，有些必须在子进程里做，有些必须在 `clone` 之后由父进程做**。分错边，代码就会在 `EPERM` 与 `EINVAL` 之间反复。

<pre class="layout">
父进程（mycontainer run）                          子进程（clone 出来的 PID 1）
─────────────────────────────                     ─────────────────────────────
解析参数、生成 id
mkdir /run/mycontainer/{id}
挂 overlay（lower=rootfs）  ─────────────────────▶   mount --make-rprivate /
建 cgroup、写限额                                   mount --bind merged merged
                                    clone()         pivot_root + umount 旧根
                                                   mount /proc /sys /dev /tmp
                                                   sethostname
                                                   capset + no_new_privs + seccomp
                                                   （可选）fork 用户进程 + init 循环
                                                   execve(argv)
等子进程退出 / 转发信号   ◀─────────────────────   退出码
删 cgroup、卸 overlay、删目录
</pre>

为什么这样分：

| 动作 | 必须由谁做 | 原因 |
|:--|:--|:--|
| 挂 overlay | 父进程 | lower 是宿主路径，子进程换根后就看不见了；且父进程要保留 merged 路径用于清理 |
| 建 cgroup | 父进程 | 子进程还不知道自己的宿主 PID；父进程拿到 `clone` 返回值后才能写 `cgroup.procs` |
| `make-rprivate` | 子进程 | 必须在自己的 mount namespace 里执行，否则会改到宿主 |
| `pivot_root` | 子进程 | 只影响调用者的 mount namespace |
| `sethostname` | 子进程 | 只影响自己的 UTS namespace |
| `capset`/`seccomp` | 子进程 | 凭证与过滤器是 per-task 的，且要在 `execve` 前生效 |
| `veth` 的宿主端 | 父进程 | 需要宿主 netns；容器端由子进程用 ioctl 配地址 |

数据用一个 `struct container` 从父进程传到子进程。`clone` 的 `arg` 直接指向它，所以这个结构体必须在子进程运行期间一直有效（放在 `main` 的栈上即可，不要提前 `free`）：

```c
/* include/container.h — 全项目唯一的共享状态；Stage 0 就定型，后面只加字段 */
#ifndef MYCONTAINER_H
#define MYCONTAINER_H

#include <stdbool.h>
#include <sys/types.h>

#define MC_MAX_ARGS 64
#define MC_PATH_MAX 256

struct container {
    char  id[16];                  /* 8 位十六进制，同时用于目录名与 veth 名 */
    char  rootfs[MC_PATH_MAX];     /* 只读 lower（Stage 3 起） */
    char  merged[MC_PATH_MAX];     /* overlay 挂载点，也是新根 */
    char  upper[MC_PATH_MAX];      /* 可写层 */
    char  work[MC_PATH_MAX];       /* overlay 的 workdir */
    char  cgroup[MC_PATH_MAX];     /* /sys/fs/cgroup/mycontainer/{id} */
    char  hostname[64];
    char  ip[16];
    char *argv[MC_MAX_ARGS];
    int   argc;
    long  memory_max;              /* 字节，0 = 不限制 */
    long  pids_max;                /* 0 = 不限制 */
    long long cpu_quota;           /* 微秒/周期，0 = 不限制 */
    long long cpu_period;          /* 固定 100000 */
    int   ns_flags;                /* CLONE_NEW* 的集合 */
    bool  init;                    /* Stage 6：是否启用 PID 1 init */
    int   sync_fd;                 /* 父 → 子：网络就绪 */
    int   ack_fd;                  /* 子 → 父：配置完成 */
    int   netns_fd;                /* 父进程持有的容器 netns */
    pid_t pid;                     /* 子进程的宿主 PID */
};

int  cg_create(struct container *c);
int  cg_attach(struct container *c, pid_t pid);
int  cg_write(const char *dir, const char *file, const char *val);
void cg_destroy(struct container *c);
int  rootfs_prepare(struct container *c);
int  rootfs_enter(struct container *c);
void rootfs_cleanup(struct container *c);
int  net_setup(struct container *c);
int  net_configure(const char *ip);
int  security_apply(void);

#endif
```


### A.1.3 Stage 0 · 骨架：先跑起来，再谈隔离 {#sec-a.1.3}

**目标**：一条命令执行 rootfs 里的程序，退出码原样返回；此时**刻意不做任何隔离**，作为后面每个 Stage 的对照基线。

```bash
# 需要 root
make
sudo ./build/mycontainer run --rootfs / -- /bin/echo hello
# hello

sudo ./build/mycontainer run -- /bin/sh -c 'exit 42'; echo "exit=$?"
# exit=42
```

**关键概念**：`fork` + `execvp` + `waitpid` 的三段式，以及退出码的三种情况——正常退出（`WIFEXITED`）、被信号杀死（`WIFSIGNALED`）、被停止（`WIFSTOPPED`，本项目不处理）。父进程必须循环 `waitpid` 并处理 `EINTR`，否则一个无关信号就能让 `waitpid` 提前返回、把退出码读成 0。信号与进程的细节在 2.7、2.8 与 [2.10](../part2/ch10.md) 里。

::: intuition 为什么要先写一个「没有隔离」的版本
因为它给了你一个可比较的基线。后面每加一个 namespace，你都应该能指着输出说「这一行变了，因为内核换了那个视图」。如果没有 Stage 0，你无法区分「隔离生效了」与「程序根本没跑起来」。这也是实验方法的基本要求：先固定对照，再改一个变量。
:::

**代码**：`Makefile` 与 `src/main.c`。

```makefile
# Makefile — mycontainer
CC       ?= cc
CFLAGS   ?= -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g
CFLAGS   += $(shell pkg-config --cflags json-c 2>/dev/null)
LDLIBS   := $(shell pkg-config --libs json-c 2>/dev/null)
SRCS     := $(wildcard src/*.c)
OBJS     := $(SRCS:src/%.c=build/%.o)
BIN      := build/mycontainer

all: $(BIN)

$(BIN): $(OBJS) | build
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDLIBS)

build/%.o: src/%.c | build
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

build:
	mkdir -p build

-include $(OBJS:.o=.d)

clean:
	rm -rf build

.PHONY: all clean
```

`-D_GNU_SOURCE` 由 Makefile 统一提供，源文件里不再重复 `#define _GNU_SOURCE`——两者同时出现会触发 `-Wmacro-redefined`，在 `-Werror` 下直接编译失败。`json-c` 到 Stage 4 才用得上；`pkg-config` 找不到时变量为空，前三个 Stage 照样能编。

```c
/* src/main.c — Stage 0：参数解析 + fork/exec + 退出码 */
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#include "container.h"

static void usage(void)
{
    fputs("用法: mycontainer run [--rootfs DIR] [--hostname NAME] [--memory SIZE]\n"
          "       [--pids N] [--cpu PERCENT] [--ip ADDR] [--init] -- CMD [ARG...]\n",
          stderr);
}

/* "64M" → 67108864；拒绝负号、零、未知后缀与多余字符 */
static int parse_size(const char *s, long *out)
{
    errno = 0;
    char *end = NULL;
    long v = strtol(s, &end, 10);
    if (errno != 0 || end == s || v <= 0)
        return -1;
    if (*end == '\0') { *out = v; return 0; }
    if (end[1] != '\0')
        return -1;
    switch (*end) {
    case 'k': case 'K': v *= 1024L; break;
    case 'm': case 'M': v *= 1024L * 1024; break;
    case 'g': case 'G': v *= 1024L * 1024 * 1024; break;
    default: return -1;
    }
    *out = v;
    return 0;
}

static int parse_args(struct container *c, int argc, char **argv)
{
    int i = 2;                                  /* argv[1] == "run" */

    while (i < argc) {
        const char *a = argv[i++];
        if (strcmp(a, "--") == 0) break;
        if (strcmp(a, "--init") == 0) { c->init = true; continue; }
        if (i >= argc)
            return -1;
        if (strcmp(a, "--rootfs") == 0)
            snprintf(c->rootfs, sizeof c->rootfs, "%s", argv[i]);
        else if (strcmp(a, "--hostname") == 0)
            snprintf(c->hostname, sizeof c->hostname, "%s", argv[i]);
        else if (strcmp(a, "--ip") == 0)
            snprintf(c->ip, sizeof c->ip, "%s", argv[i]);
        else if (strcmp(a, "--memory") == 0) {
            if (parse_size(argv[i], &c->memory_max) == -1) return -1;
        } else if (strcmp(a, "--pids") == 0) {
            if (parse_size(argv[i], &c->pids_max) == -1) return -1;
        } else if (strcmp(a, "--cpu") == 0) {
            long pct;
            if (parse_size(argv[i], &pct) == -1 || pct > 10000) return -1;
            c->cpu_quota = pct * 1000;          /* 百分比 → 每 100 ms 微秒数 */
        } else {
            return -1;
        }
        i++;
    }
    c->argc = argc - i;
    if (c->argc == 0 || c->argc >= MC_MAX_ARGS)
        return -1;
    for (int k = 0; k < c->argc; k++)
        c->argv[k] = argv[i + k];
    c->argv[c->argc] = NULL;
    return 0;
}

static int run(struct container *c)
{
    pid_t pid = fork();
    if (pid == -1) { perror("fork"); return 1; }
    if (pid == 0) {
        if (c->rootfs[0] != '\0' && chdir(c->rootfs) == -1) {
            fprintf(stderr, "chdir %s: %s\n", c->rootfs, strerror(errno));
            _exit(127);
        }
        execvp(c->argv[0], c->argv);
        fprintf(stderr, "exec %s: %s\n", c->argv[0], strerror(errno));
        _exit(127);
    }

    int status = 0;
    while (waitpid(pid, &status, 0) == -1) {
        if (errno != EINTR) { perror("waitpid"); return 1; }
    }
    if (WIFEXITED(status))
        return WEXITSTATUS(status);
    if (WIFSIGNALED(status))
        return 128 + WTERMSIG(status);
    return 1;
}

int main(int argc, char **argv)
{
    if (argc < 3 || strcmp(argv[1], "run") != 0) {
        usage();
        return 2;
    }
    struct container c = { .cpu_period = 100000, .ip = "10.88.0.2" };
    snprintf(c.hostname, sizeof c.hostname, "mc");
    if (parse_args(&c, argc, argv) == -1) {
        usage();
        return 2;
    }
    return run(&c);
}
```

**验证**：

```bash
# 需要 root
make clean && make
sudo ./build/mycontainer run -- /bin/true; echo "true=$?"        # true=0
sudo ./build/mycontainer run -- /bin/sh -c 'exit 42'; echo "=$?" # =42
sudo ./build/mycontainer run -- /bin/sh -c 'kill -9 $$'; echo "=$?"
# 容器被信号 9 终止
# =137
sudo ./build/mycontainer run -- /nope
# exec /nope: No such file or directory（退出码 127）
```

三条对照要在 Stage 1 之后重跑：那时 `hostname` 会变、`ps` 会只剩自己、`/proc` 里的 PID 从 1 开始。把这些输出贴进 `docs/stage-notes.md`，复盘时要用。

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `error: '_GNU_SOURCE' macro redefined` | 源文件与 `-D_GNU_SOURCE` 重复定义 | 只在 Makefile 里定义 |
| `undefined reference to 'json_object_from_file'` | 没装 `libjson-c-dev` 或没链接 `-ljson-c` | `sudo apt install libjson-c-dev`，确认 `pkg-config --libs json-c` 有输出 |
| `exec /bin/sh: No such file or directory`，但文件存在 | rootfs 里的二进制是动态链接，缺 `ld-linux` | 用 `busybox-static`，或把 `ldd` 的库一起拷进 rootfs |
| `64MB` 被当成合法参数 | 只检查了 `end[1]`，没检查整个后缀 | 本页版本已拒绝；写测试固定这个行为 |
| 退出码永远是 0 | `waitpid` 被 `EINTR` 打断后没重试，`status` 未被赋值 | 循环 `waitpid` 直到不返回 `EINTR` |

**下一步**：Stage 1 把 `fork` 换成 `clone`，一次加上 `CLONE_NEWPID | CLONE_NEWNS | CLONE_NEWNET | CLONE_NEWUTS | CLONE_NEWIPC`，并在子进程里重挂 `/proc`。你会第一次看到同一个进程的两套 PID。

### A.1.4 Stage 1 · namespace：把「看见什么」拆开 {#sec-a.1.4}

**目标**：一条命令让子进程进入新的 PID/mount/net/UTS/IPC 视图：`hostname` 变成自己的，`ps` 只剩自己，`/proc/net/dev` 只剩一块 `lo`。

```bash
# 需要 root（未实测：以下是 Ubuntu 24.04 + 内核 6.8 的预期输出）
sudo ./build/mycontainer run --rootfs / --hostname demo -- \
    /bin/sh -c 'hostname; echo pid=$$; ps -e; cat /proc/net/dev'
# demo
# pid=1
#     PID USER     TIME  COMMAND
#       1 root      0:00 /bin/sh
#       2 root      0:00 ps
# Inter-|   Receive ...
#  face |bytes    packets ...
#     lo:       0       0 ...
```

**关键概念**：`clone(2)` 的 `CLONE_NEW*` 位一次创建多个 namespace；`CLONE_NEWPID` 让**子进程**成为新 PID namespace 的 1 号（`fork` 版本只影响后代）；新 PID namespace 必须配一份新的 `procfs`，否则 `ps` 读到的仍是旧视图；mount namespace 的第一件事是 `mount --make-rprivate /`，切断与宿主的传播。这些在 [5.2.2](../part5/ch02.md#sec-5.2.2) 与 [5.2.7](../part5/ch02.md#sec-5.2.7) 有完整展开。

::: intuition 为什么 `ps` 要同时满足两个条件
PID namespace 决定「内核给进程编几号」，`procfs` 决定「`ps` 读哪份目录」。只建 PID namespace 而不重挂 `/proc`，`ps` 仍然读宿主那份 procfs，看到的是宿主编号；只重挂 `/proc` 而不建 PID namespace，新 procfs 里的编号与旧 namespace 相同，看到的是全量。两个条件缺一不可——这也是「隔离是组合出来的」最直观的例子。
:::

**代码**：新增 `src/child.c`，并把 `main.c` 的 `fork` 换成 `clone`。

```c
/* src/child.c — Stage 1：子进程的视图建立顺序 */
#include <errno.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>
#include <unistd.h>

#include "container.h"

#define MC_STACK_SIZE (1024 * 1024)

static int setup_mount_view(struct container *c)
{
    /* 1. 先切断传播，否则后面的 mount 可能沿 shared 关系回到宿主 */
    if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) == -1) {
        perror("mount --make-rprivate /");
        return -1;
    }
    /* 2. 新 PID namespace 需要自己的 procfs 才能看到新编号 */
    if (mount("proc", "/proc", "proc",
              MS_NOSUID | MS_NODEV | MS_NOEXEC, NULL) == -1) {
        perror("mount proc");
        return -1;
    }
    /* 3. Stage 1 只 chdir；真正的换根在 Stage 3 用 pivot_root 做 */
    if (c->rootfs[0] != '\0' && chdir(c->rootfs) == -1) {
        perror("chdir rootfs");
        return -1;
    }
    return 0;
}

int child_main(void *arg)
{
    struct container *c = arg;

    if (setup_mount_view(c) == -1)
        return 1;
    if (sethostname(c->hostname, strlen(c->hostname)) == -1) {
        perror("sethostname");
        return 1;
    }
    execvp(c->argv[0], c->argv);
    fprintf(stderr, "exec %s: %s\n", c->argv[0], strerror(errno));
    return 127;
}
```

`clone` 需要调用者提供栈，函数签名固定为 `int (*)(void *)`；父进程的 `run()` 把 `fork()` 换成 `clone(child_main, stack + MC_STACK_SIZE, c->ns_flags | SIGCHLD, c)`，拿到返回值后记进 `c->pid`（宿主视角的 PID；容器内看到的是 1），其余 `waitpid` 与退出码解包逻辑与 Stage 0 完全相同。
**验证**：

```bash
# 需要 root
make
sudo ./build/mycontainer run --rootfs / --hostname demo -- \
    /bin/sh -c 'hostname; ps -e | wc -l; ls /proc/1/ns'
# demo
# 3                     ← 表头 + sh + ps，宿主上通常是几百
# cgroup  ipc  mnt  net  pid  pid_for_children  time  time_for_children  user  uts
```

在容器外另开一个终端，`ps -ef | grep mycontainer` 能找到这个 `sh`，它有一个宿主 PID——**同一个进程，两套编号**。用宿主 PID `sudo kill -TERM <pid>` 能杀掉它；在容器里 `kill 1` 则会被内核拒绝（PID 1 没有默认处理函数的信号会被忽略，见 [5.2.5](../part5/ch02.md#sec-5.2.5)）。

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `clone: Operation not permitted` | 不是 root，或宿主 seccomp/AppArmor 拦了带 namespace 标志的 `clone` | 用 root；虚拟机里确认没有被自定义 seccomp 限制 |
| `ps` 仍列出宿主全部进程 | 缺 `CLONE_NEWPID`，或没有重挂 `/proc` | 两个条件同时满足；先确认 `ls /proc/1/ns` 的 pid inode 变了 |
| `mount proc: Device or resource busy` | `/proc` 在共享挂载上，传播把操作顶回宿主 | 先 `mount --make-rprivate /`，再挂 proc |
| `hostname: Function not implemented` / 改了宿主主机名 | 缺 `CLONE_NEWUTS`，或误在父进程调用 `sethostname` | 只在子进程里调，且带上 `CLONE_NEWUTS` |
| 父进程 `kill(pid)` 杀不到容器内进程 | 拿容器内的 PID 去 `kill`，命名空间不同 | 父进程始终用 `clone` 返回的宿主 PID |

**下一步**：Stage 2 给这组进程加限额。namespace 只改「看得见」，改不了「用多少」——一个 `yes` 仍然能把宿主 CPU 吃满。

### A.1.5 Stage 2 · cgroups v2：把「用多少」限住 {#sec-a.1.5}

**目标**：三条限额都能被触发并留下证据——内存超限被 OOM kill、`pids.max` 挡住 fork 炸弹、`cpu.max` 产生 throttling。

```bash
# 需要 root（未实测）
sudo ./build/mycontainer run --memory 64M -- /bin/sh -c \
    'python3 -c "a = bytearray(200*1024*1024)"'
# Killed
# 退出码 137
sudo cat /sys/fs/cgroup/mycontainer/*/memory.events
# low 0
# high 0
# max 12
# oom 3
# oom_kill 1
```

**关键概念**：cgroup v2 是**单层级**——所有控制器挂在同一棵树上，一个进程只属于一个 cgroup。三条规则决定了它的用法：

1. **控制器要先在父层打开**。`/sys/fs/cgroup/mycontainer/cgroup.subtree_control` 里写上 `+memory +pids +cpu`，子目录 `{id}` 才会出现对应的 `memory.max`、`pids.max`、`cpu.max`。
2. **非根 cgroup 不能既放进程又放子 cgroup**（no internal process）。所以我们把进程放进叶子 `{id}`，中间层 `mycontainer` 只放子目录。
3. **限额是子树级的**。`memory.max` 限制的是这个 cgroup 及其所有后代的合计用量，不是单个进程。

| 文件 | 写入格式 | 读什么判断生效 |
|:--|:--|:--|
| `memory.max` | 字节数，或 `max` | `memory.current`、`memory.events` 的 `oom_kill` |
| `pids.max` | 整数，或 `max` | 写 `pids.current`；fork 失败返回 `EAGAIN` |
| `cpu.max` | `"<quota> <period>"`，微秒 | `cpu.stat` 的 `nr_throttled` / `throttled_usec` |
| `cgroup.procs` | 宿主 PID（十进制） | 读回来确认进程已在组内 |
| `cgroup.kill` | `1` | 5.14+ 的整组击杀，比逐个 `kill` 可靠 |

**代码**：`src/cgroup.c`（完整）与 `main.c` 的接入点。

```c
/* src/cgroup.c — Stage 2：cgroup v2 的建、限、放、删 */
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "container.h"

static int mkdir_p(const char *path)
{
    char tmp[MC_PATH_MAX];
    size_t n = strlen(path);

    if (n == 0 || n >= sizeof tmp) {
        errno = ENAMETOOLONG;
        return -1;
    }
    memcpy(tmp, path, n + 1);
    for (char *p = tmp + 1; *p != '\0'; p++) {
        if (*p != '/')
            continue;
        *p = '\0';
        if (mkdir(tmp, 0755) == -1 && errno != EEXIST)
            return -1;
        *p = '/';
    }
    if (mkdir(tmp, 0755) == -1 && errno != EEXIST)
        return -1;
    return 0;
}

int cg_write(const char *dir, const char *file, const char *val)
{
    char path[MC_PATH_MAX];
    int n = snprintf(path, sizeof path, "%s/%s", dir, file);

    if (n < 0 || (size_t)n >= sizeof path) {
        errno = ENAMETOOLONG;
        return -1;
    }
    int fd = open(path, O_WRONLY | O_CLOEXEC);
    if (fd == -1)
        return -1;

    size_t len = strlen(val), off = 0;
    while (off < len) {
        ssize_t w = write(fd, val + off, len - off);
        if (w == -1) {
            if (errno == EINTR)
                continue;
            int saved = errno;
            close(fd);
            errno = saved;
            return -1;
        }
        off += (size_t)w;
    }
    return close(fd);
}

int cg_create(struct container *c)
{
    char buf[64];

    if (mkdir_p("/sys/fs/cgroup/mycontainer") == -1)
        return -1;
    /* 控制器必须在父层启用；EBUSY 通常表示父层还有进程 */
    if (cg_write("/sys/fs/cgroup/mycontainer", "cgroup.subtree_control",
                 "+memory +pids +cpu") == -1)
        fprintf(stderr, "警告: 启用控制器失败: %s\n", strerror(errno));

    snprintf(c->cgroup, sizeof c->cgroup,
             "/sys/fs/cgroup/mycontainer/%s", c->id);
    if (mkdir(c->cgroup, 0755) == -1 && errno != EEXIST)
        return -1;

    if (c->memory_max > 0) {
        snprintf(buf, sizeof buf, "%ld", c->memory_max);
        if (cg_write(c->cgroup, "memory.max", buf) == -1)
            return -1;
        cg_write(c->cgroup, "memory.oom.group", "1");   /* 整组一起杀 */
    }
    if (c->pids_max > 0) {
        snprintf(buf, sizeof buf, "%ld", c->pids_max);
        if (cg_write(c->cgroup, "pids.max", buf) == -1)
            return -1;
    }
    if (c->cpu_quota > 0) {
        snprintf(buf, sizeof buf, "%lld %lld", c->cpu_quota, c->cpu_period);
        if (cg_write(c->cgroup, "cpu.max", buf) == -1)
            return -1;
    }
    return 0;
}

int cg_attach(struct container *c, pid_t pid)
{
    char buf[32];

    snprintf(buf, sizeof buf, "%d", (int)pid);
    return cg_write(c->cgroup, "cgroup.procs", buf);
}

void cg_destroy(struct container *c)
{
    if (c->cgroup[0] == '\0')
        return;
    /* 5.14+：一次杀掉组内全部进程，避免 rmdir 时 EBUSY */
    cg_write(c->cgroup, "cgroup.kill", "1");
    if (rmdir(c->cgroup) == -1 && errno != ENOENT)
        fprintf(stderr, "警告: 删除 %s 失败: %s\n", c->cgroup, strerror(errno));
}
```

接入点只有三行：`run()` 里生成 id、`cg_create`，`clone` 返回后 `cg_attach`，退出后 `cg_destroy`。

```c
/* src/main.c — Stage 2 新增的三个调用点 */
static void gen_id(char *out, size_t n)
{
    unsigned char b[4];
    int fd = open("/dev/urandom", O_RDONLY | O_CLOEXEC);
    if (fd == -1 || read(fd, b, sizeof b) != (ssize_t)sizeof b) {
        perror("urandom");
        _exit(1);
    }
    close(fd);
    snprintf(out, n, "%02x%02x%02x%02x", b[0], b[1], b[2], b[3]);
}

/* run() 中，clone 之前 / 之后 / 退出后 */
gen_id(c->id, sizeof c->id);
if (cg_create(c) == -1) {
    fprintf(stderr, "cgroup: %s\n", strerror(errno));
    return 1;
}
/* ... clone 成功之后 ... */
if (cg_attach(c, pid) == -1) {
    perror("cg_attach");
    kill(pid, SIGKILL);
    waitpid(pid, NULL, 0);
    cg_destroy(c);
    return 1;
}
/* ... waitpid 之后 ... */
cg_destroy(c);
```

**验证**：

```bash
# 需要 root（未实测）
# 1) 内存：200 MiB 的分配在 64 MiB 的组里触发 OOM
sudo ./build/mycontainer run --memory 64M -- /bin/sh -c \
    'python3 -c "a = bytearray(200*1024*1024); print(len(a))"'
echo "exit=$?"                      # exit=137
sudo cat /sys/fs/cgroup/mycontainer/*/memory.events | grep oom_kill
# oom_kill 1

# 2) pids：100 个后台 sleep 在 pids.max=32 下必然失败
sudo ./build/mycontainer run --pids 32 -- /bin/sh -c \
    'for i in $(seq 1 100); do sleep 30 & done; wait'
# sh: fork: retry: Resource temporarily unavailable
# sh: fork: Resource temporarily unavailable

# 3) CPU：50% 配额在 5 秒内应出现 throttling
sudo ./build/mycontainer run --cpu 50 -- /bin/sh -c 'timeout 5 yes > /dev/null'
sudo cat /sys/fs/cgroup/mycontainer/*/cpu.stat
# usage_usec 2493xxx
# nr_periods 49
# nr_throttled 24
# throttled_usec 24xxxxx
```

三条验证的共同点：**证据都在 cgroup 文件里**，不在容器输出里。容器只告诉你「被杀了」或「fork 失败」，`memory.events` 与 `cpu.stat` 才告诉你「为什么」。

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `write .../memory.max: No such file or directory` | 父层没启用 memory 控制器，叶子没有这个文件 | 先写 `cgroup.subtree_control`，再建叶子；确认 `cat /sys/fs/cgroup/cgroup.controllers` 含 `memory` |
| `write .../cgroup.subtree_control: Device or resource busy` | 父 cgroup 里还有进程（no internal process 规则） | 进程放进叶子，中间层只放子目录 |
| `write .../memory.max: Invalid argument` | 写的是 `64M` 这种带单位的字符串 | 只写十进制字节数；单位换算在用户态完成 |
| OOM 没发生，进程被 `SIGKILL` 但 `oom_kill` 为 0 | `memory.max` 写在错误的层级，或进程根本不在组里 | 读 `{id}/cgroup.procs` 确认 PID 在；限额写在叶子 |
| `rmdir: Device or resource busy` | 组里还有进程或子组 | 先 `cgroup.kill`，`waitpid` 回收后再 `rmdir` |
| `pids.max` 设了 32，实际起了 40 个线程 | `pids.current` 数的是**任务**（线程）不是进程 | 按线程数估算，或同时限制应用的线程池 |

**下一步**：Stage 3 换根。现在的 `chdir(rootfs)` 只是换工作目录，容器里的 `/` 仍是宿主的根；`pivot_root` 才会真正换掉它，overlayfs 则让「只读镜像 + 可写层」落地。

### A.1.6 Stage 3 · rootfs：overlayfs 与 `pivot_root` {#sec-a.1.6}

**目标**：容器里的 `/` 是 overlayfs，写文件落到可写层；宿主上的只读 rootfs 不被修改。

```bash
# 需要 root（未实测）
sudo ./build/mycontainer run --rootfs /var/lib/mycontainer/rootfs -- /bin/sh
# / # mount | grep ' / '
# overlay on / type overlay (rw,relatime,lowerdir=/var/lib/...,upperdir=/run/...,workdir=/run/...)
# / # echo hi > /hello && ls -l /hello
```

**关键概念**：overlayfs 把只读的 **lower** 与可写的 **upper** 叠成一个 **merged** 目录；第一次修改 lower 里的文件会触发 **copy-up**，删除则写 **whiteout**（[5.4](../part5/ch04.md)）。`pivot_root` 与 `chroot` 的区别在于它操作的是挂载树：新根必须**先是一个挂载点**，旧根必须**被移到新根之下**再卸载（[5.1.3](../part5/ch01.md#sec-5.1.3)）。三个前提缺一不可：新根是挂载点、`put_old` 在新根内、挂载传播已改成 private。

::: intuition 为什么 upper 与 work 必须同一个文件系统
overlayfs 在 upper 里记录「哪些文件被改过」，work 目录用于原子地完成 rename 与 copy-up。如果两者跨文件系统，`rename(2)` 无法原子完成（`EXDEV`），overlayfs 就拒绝挂载。这也是为什么容器运行时把 upper 放在 `/var/lib/...` 的同一块盘上，而不是 `/run`（tmpfs）与磁盘混用。
:::

**代码**：`src/rootfs.c`（完整）。

```c
/* src/rootfs.c — Stage 3：overlayfs 挂载、pivot_root、伪文件系统与设备节点 */
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/mount.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/sysmacros.h>
#include <unistd.h>

#include "container.h"

/* mkdir_p 与 cgroup.c 里的实现相同（实际项目抽到 util.c），此处省略以省篇幅 */

int rootfs_prepare(struct container *c)
{
    char base[MC_PATH_MAX], opts[3 * MC_PATH_MAX];

    snprintf(base, sizeof base, "/run/mycontainer/%s", c->id);
    snprintf(c->merged, sizeof c->merged, "%s/merged", base);
    snprintf(c->upper, sizeof c->upper, "%s/upper", base);
    snprintf(c->work, sizeof c->work, "%s/work", base);
    if (mkdir_p(base) == -1 || mkdir_p(c->merged) == -1 ||
        mkdir_p(c->upper) == -1 || mkdir_p(c->work) == -1)
        return -1;

    int n = snprintf(opts, sizeof opts, "lowerdir=%s,upperdir=%s,workdir=%s",
                     c->rootfs, c->upper, c->work);
    if (n < 0 || (size_t)n >= sizeof opts) {
        errno = ENAMETOOLONG;
        return -1;
    }
    if (mount("overlay", c->merged, "overlay", 0, opts) == -1) {
        perror("mount overlay");
        return -1;
    }
    /* pivot_root 的 put_old 必须事先存在，且位于新根之内 */
    n = snprintf(opts, sizeof opts, "%s/.oldroot", c->merged);
    if (n < 0 || (size_t)n >= sizeof opts ||
        (mkdir(opts, 0755) == -1 && errno != EEXIST))
        return -1;
    return 0;
}

int rootfs_enter(struct container *c)
{
    static const struct {
        const char *path, *type, *data;
        unsigned long flags;
    } fs[] = {
        { "/proc", "proc",  NULL,           MS_NOSUID | MS_NODEV | MS_NOEXEC },
        { "/sys",  "sysfs", NULL,           MS_NOSUID | MS_NODEV | MS_NOEXEC | MS_RDONLY },
        { "/tmp",  "tmpfs", "size=64m",     MS_NOSUID | MS_NODEV },
        { "/dev",  "tmpfs", "size=1m",      MS_NOSUID },
    };

    if (mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) == -1)
        return -1;
    /* 新根先变成挂载点，否则 pivot_root 返回 EINVAL */
    if (mount("none", c->merged, NULL, MS_BIND | MS_REC, NULL) == -1)
        return -1;
    if (chdir(c->merged) == -1)
        return -1;
    if (syscall(SYS_pivot_root, ".", ".oldroot") == -1)
        return -1;
    if (umount2("/.oldroot", MNT_DETACH) == -1)
        return -1;
    if (rmdir("/.oldroot") == -1 && errno != ENOENT)
        return -1;

    for (size_t i = 0; i < sizeof fs / sizeof fs[0]; i++) {
        if (mount(fs[i].type, fs[i].path, fs[i].type, fs[i].flags, fs[i].data) == -1) {
            fprintf(stderr, "mount %s: %s\n", fs[i].path, strerror(errno));
            return -1;
        }
    }

    /* 不挂 devtmpfs：那会把宿主所有设备暴露给容器。只造五个必需的字符设备 */
    if (mknod("/dev/null", S_IFCHR | 0666, makedev(1, 3)) == -1 ||
        mknod("/dev/zero", S_IFCHR | 0666, makedev(1, 5)) == -1 ||
        mknod("/dev/full", S_IFCHR | 0666, makedev(1, 7)) == -1 ||
        mknod("/dev/random", S_IFCHR | 0666, makedev(1, 8)) == -1 ||
        mknod("/dev/urandom", S_IFCHR | 0666, makedev(1, 9)) == -1)
        return -1;
    return 0;
}

void rootfs_cleanup(struct container *c)
{
    if (c->merged[0] == '\0')
        return;
    /* 子进程退出后，挂载点里可能还有进程的 cwd；MNT_DETACH 保证能摘掉 */
    if (umount2(c->merged, MNT_DETACH) == -1 && errno != EINVAL && errno != ENOENT)
        fprintf(stderr, "警告: umount %s: %s\n", c->merged, strerror(errno));
    /* 只删空目录；upper 里残留的文件由 Stage 8 的清理脚本处理 */
    rmdir(c->work);
    rmdir(c->upper);
    rmdir(c->merged);
}
```

`child_main` 的调用顺序变成：`rootfs_enter(c)` → `sethostname` → `execvp`。注意 `rootfs_enter` 内部已经做了 `make-rprivate`，Stage 1 的 `setup_mount_view` 就此退休；保留它会导致「先挂 proc 再换根」，换根后 proc 挂载点丢失。

**验证**：

```bash
# 准备最小 rootfs（需要 root）
sudo apt install -y busybox-static
sudo mkdir -p /var/lib/mycontainer/rootfs/{bin,proc,sys,dev,tmp}
sudo cp /bin/busybox /var/lib/mycontainer/rootfs/bin/
for a in sh ls cat echo mount ps hostname id sleep; do
    sudo ln -sf busybox "/var/lib/mycontainer/rootfs/bin/$a"
done

# 运行并写入（未实测）
sudo ./build/mycontainer run --rootfs /var/lib/mycontainer/rootfs -- /bin/sh
# / # stat -f -c %T /
# overlayfs
# / # echo hi > /hello
# / # cat /hello
# hi

# 另一个终端：写入落在 upper，lower 没有变
sudo cat /run/mycontainer/*/upper/hello       # hi
sudo ls /var/lib/mycontainer/rootfs/hello     # ls: cannot access ...: No such file or directory

# 清理
sudo rm -rf /run/mycontainer/*
```

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `pivot_root: Invalid argument` | 新根不是挂载点，或 `.oldroot` 不在新根内 | 先 `mount --bind merged merged`；确认 `merged/.oldroot` 存在 |
| `mount overlay: Invalid argument` | upper 与 work 不在同一文件系统，或 lower 路径不存在 | `df` 看两者是否同盘；`ls` 确认 lower 是目录 |
| `mount overlay: No such file or directory` | upper/work 目录没建 | 先 `mkdir -p` 三个目录再挂 |
| 换根后 `/bin/sh: not found` | busybox 是动态链接，rootfs 缺 `ld-linux` 与 libc | 用 `busybox-static`；`ldd /bin/busybox` 确认 |
| 打开 `/dev/null` 报 `No such file or directory` | 只挂了 tmpfs，没 `mknod` | 按上表造五个字符设备，或从宿主 bind mount |
| 退出后宿主 `mount` 里残留 overlay | `rootfs_cleanup` 没执行（进程被 `SIGKILL`） | 用 `sudo umount -l /run/mycontainer/*/merged` 手工清理 |

**下一步**：Stage 4 把这些硬编码的参数搬进 OCI `config.json`，让 `mycontainer spec` 生成的配置能被自己消费——这一步做完，你的运行时才算「认标准」。

### A.1.7 Stage 4 · OCI：把参数变成一份标准配置 {#sec-a.1.7}

**目标**：`mycontainer spec` 生成一份 `config.json`；`mycontainer run --bundle DIR` 只读这份配置就能起容器，命令行不再出现 rootfs 与限额参数。

```bash
# 需要 root（未实测）
sudo ./build/mycontainer spec > /tmp/bundle/config.json
sudo ./build/mycontainer run --bundle /tmp/bundle
# hello from oci config
```

**关键概念**：OCI runtime-spec 把「容器」描述成**一份配置 + 一个 rootfs**，而不是某个程序的参数。`config.json` 的每一段都对应一组系统调用：

| OCI 字段 | 我们的落点 | 系统调用/文件 |
|:--|:--|:--|
| `root.path` | `c->rootfs` | overlay 的 `lowerdir` |
| `process.args` | `c->argv` | `execvp` |
| `process.env` | 本项目忽略（继承宿主） | `execve` 的 `envp` |
| `hostname` | `c->hostname` | `sethostname` |
| `linux.namespaces[].type` | `c->ns_flags` | `clone` 的 `CLONE_NEW*` |
| `linux.resources.memory.limit` | `c->memory_max` | `memory.max` |
| `linux.resources.pids.limit` | `c->pids_max` | `pids.max` |
| `linux.resources.cpu.quota/period` | `c->cpu_quota/period` | `cpu.max` |
| `process.capabilities` | 本项目固定最小集 | `capset` |

不要自己写 JSON 解析器。解析器的边界情况（转义、深嵌套、数字精度）会把项目拖进无底洞，而这一 Stage 要学的是**语义映射**。用 `json-c`，把精力留给「字段缺失时给什么默认值」「类型不对时怎么报错」。

**代码**：`src/oci.c`。先看结构与数组字段，再看资源字段。

```c
/* src/oci.c — Stage 4：OCI config.json 到 struct container 的映射 */
#include <errno.h>
#include <sched.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <json-c/json.h>

#include "container.h"

static int copy_str(char *dst, size_t cap, const char *src)
{
    int n = snprintf(dst, cap, "%s", src);
    return (n < 0 || (size_t)n >= cap) ? -1 : 0;
}

static const char *str_field(struct json_object *obj, const char *key)
{
    struct json_object *v;
    if (obj == NULL || !json_object_object_get_ex(obj, key, &v))
        return NULL;
    return json_object_get_string(v);          /* 非字符串返回 NULL */
}

static long long int_field(struct json_object *obj, const char *key, long long dflt)
{
    struct json_object *v;
    if (obj == NULL || !json_object_object_get_ex(obj, key, &v))
        return dflt;
    return json_object_get_int64(v);
}

static int load_args(struct container *c, struct json_object *process)
{
    struct json_object *args;
    if (process == NULL ||
        !json_object_object_get_ex(process, "args", &args) ||
        !json_object_is_type(args, json_type_array))
        return -1;

    size_t n = json_object_array_length(args);
    if (n == 0 || n >= MC_MAX_ARGS)
        return -1;
    for (size_t i = 0; i < n; i++) {
        const char *s = json_object_get_string(json_object_array_get_idx(args, i));
        c->argv[i] = strdup(s != NULL ? s : "");
        if (c->argv[i] == NULL)
            return -1;
    }
    c->argc = (int)n;
    c->argv[n] = NULL;
    return 0;
}

static void load_namespaces(struct container *c, struct json_object *linux)
{
    struct json_object *ns;
    if (linux == NULL || !json_object_object_get_ex(linux, "namespaces", &ns))
        return;
    size_t n = json_object_array_length(ns);
    for (size_t i = 0; i < n; i++) {
        const char *t = str_field(json_object_array_get_idx(ns, i), "type");
        if (t == NULL)
            continue;
        if (strcmp(t, "pid") == 0)        c->ns_flags |= CLONE_NEWPID;
        else if (strcmp(t, "mount") == 0) c->ns_flags |= CLONE_NEWNS;
        else if (strcmp(t, "net") == 0)   c->ns_flags |= CLONE_NEWNET;
        else if (strcmp(t, "uts") == 0)   c->ns_flags |= CLONE_NEWUTS;
        else if (strcmp(t, "ipc") == 0)   c->ns_flags |= CLONE_NEWIPC;
    }
}

int oci_load(struct container *c, const char *path)
{
    struct json_object *root = json_object_from_file(path);
    if (root == NULL) {
        fprintf(stderr, "读取 %s 失败: %s\n", path, json_util_get_last_err());
        return -1;
    }

    struct json_object *process = NULL, *rootfs = NULL, *linux = NULL;
    struct json_object *res = NULL, *mem = NULL, *pids = NULL, *cpu = NULL;
    json_object_object_get_ex(root, "process", &process);
    json_object_object_get_ex(root, "root", &rootfs);
    json_object_object_get_ex(root, "linux", &linux);
    json_object_object_get_ex(linux, "resources", &res);
    json_object_object_get_ex(res, "memory", &mem);
    json_object_object_get_ex(res, "pids", &pids);
    json_object_object_get_ex(res, "cpu", &cpu);

    if (str_field(rootfs, "path") != NULL &&
        copy_str(c->rootfs, sizeof c->rootfs, str_field(rootfs, "path")) == -1)
        goto bad;
    if (str_field(root, "hostname") != NULL &&
        copy_str(c->hostname, sizeof c->hostname, str_field(root, "hostname")) == -1)
        goto bad;

    c->memory_max = (long)int_field(mem, "limit", 0);
    c->pids_max = (long)int_field(pids, "limit", 0);
    c->cpu_quota = int_field(cpu, "quota", 0);
    c->cpu_period = int_field(cpu, "period", 100000);
    load_namespaces(c, linux);

    if (load_args(c, process) == -1)
        goto bad;
    json_object_put(root);
    return 0;

bad:
    fprintf(stderr, "config.json 字段不完整或类型不对\n");
    json_object_put(root);
    return -1;
}

void oci_free(struct container *c)
{
    for (int i = 0; i < c->argc; i++) {
        free(c->argv[i]);
        c->argv[i] = NULL;
    }
    c->argc = 0;
}
```

`json_object_get_int64` 对负数与超大值会截断；本项目假设配置可信（`runc` 会做完整校验，我们不重复）。`--bundle` 的接入只有两步：`chdir(bundle)`，然后 `oci_load(c, "config.json")`；若没有任何 `CLONE_NEW*`，就退回 Stage 0 的 `fork` 路径，保证「空配置也能跑」。

`spec` 子命令不需要模板引擎：把一份最小 `config.json` 用 `fputs` 打出来即可。字段与上表一一对应，注意 `ociVersion` 必须是 `1.0.2` 或更高，否则 `runc` 会拒绝同一份文件。

**验证**：

```bash
# 需要 root（未实测）
mkdir -p /tmp/bundle/rootfs
sudo cp -a /var/lib/mycontainer/rootfs/. /tmp/bundle/rootfs/
sudo ./build/mycontainer spec > /tmp/bundle/config.json
python3 -m json.tool /tmp/bundle/config.json | head -20   # 确认是合法 JSON
sudo ./build/mycontainer run --bundle /tmp/bundle
# hello from oci config

# 改一个字段，确认它真的生效
sudo sed -i 's/"hostname": "demo"/"hostname": "oci-demo"/' /tmp/bundle/config.json
sudo ./build/mycontainer run --bundle /tmp/bundle -- /bin/hostname
# oci-demo
```

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `读取 ... 失败: (null)` | 文件不存在，或 `json-c` 的错误缓冲为空 | 先 `ls`；错误信息建议改用 `json_tokener` 自己解析以获得行列号 |
| `undefined reference to 'json_object_from_file'` | 没链接 `-ljson-c` | Makefile 里用 `pkg-config --libs json-c` |
| `config.json 字段不完整` | `process.args` 缺失或不是数组 | 对照上表补齐；空数组也算非法 |
| `json_object_get_string` 返回 `NULL` 后直接 `strcmp` | 字段是数字/对象而非字符串 | 每个取值都判空，或用 `json_object_is_type` 先验证 |
| `runc spec` 生成的配置自己读不了 | 只实现了子集，未知字段被忽略是**正确行为** | 不要报错；OCI 允许扩展字段，忽略即可 |

**下一步**：Stage 5 解决「容器只有 lo」的问题。veth 对、网桥、NAT 三件事分别在宿主与容器两侧完成，你会第一次需要父子进程同步。

### A.1.8 Stage 5 · 网络：veth、bridge 与容器内配网 {#sec-a.1.8}

**目标**：容器有自己的 `eth0`，能 ping 通宿主网桥地址 `10.88.0.1`，也能经 NAT 访问外网。

```bash
# 需要 root（未实测）
sudo ./build/mycontainer run --ip 10.88.0.2 -- /bin/sh -c \
    'ip -brief addr; ping -c1 -W1 10.88.0.1; ping -c1 -W1 1.1.1.1'
# eth0   UP   10.88.0.2/24
# lo     UNKNOWN  127.0.0.1/8
# 1 packets transmitted, 1 received
# 1 packets transmitted, 1 received
```

**关键概念**：veth 是一对**互相连通的虚拟网卡**——从一端写入的帧从另一端出来。把宿主端放进网桥，容器端留在容器的 netns，两者就有了二层连通；网桥上的 IP 是容器的默认网关；宿主打开 `ip_forward` 并加一条 `MASQUERADE`，容器才能访问容器外（[4.12](../part4/ch12.md) 与 N 第 10 章）。`ip link set <dev> netns <pid>` 按**进程的 netns** 移动设备，这是父子进程之间唯一需要的同步点。

::: intuition 为什么需要一根同步管道
父进程必须在 `clone` 之后才知道子进程的 PID，才能把 veth 的另一端移进它的 netns；子进程又必须等 veth 出现后才能配地址。两边谁先谁后都不行，所以要一根管道做栅栏：父进程移完设备写一个字节，子进程读到才继续。这类「父子各做一半、必须对齐」的初始化，在真实运行时里用 `syncPipe` 或 netlink 的 ACK 完成，思路相同。
:::

**代码**：父进程侧 `net_setup`（建桥、建 veth、移设备、开 NAT）。

```c
/* src/net.c — 父进程侧：只做宿主能做的事 */
#include <errno.h>
#include <net/if.h>
#include <stdio.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#include "container.h"

static int run_cmd(const char *const argv[])
{
    pid_t pid = fork();
    if (pid == -1)
        return -1;
    if (pid == 0) {
        execvp(argv[0], (char *const *)argv);
        _exit(127);
    }
    int st = 0;
    while (waitpid(pid, &st, 0) == -1)
        if (errno != EINTR)
            return -1;
    if (!WIFEXITED(st) || WEXITSTATUS(st) != 0) {
        errno = ECHILD;
        return -1;
    }
    return 0;
}

#define IP(...) run_cmd((const char *const[]){ "ip", __VA_ARGS__, NULL })

static int ensure_bridge(void)
{
    if (if_nametoindex("mc-br0") != 0)
        return 0;
    return IP("link", "add", "mc-br0", "type", "bridge") == 0 &&
           IP("addr", "add", "10.88.0.1/24", "dev", "mc-br0") == 0 &&
           IP("link", "set", "mc-br0", "up") == 0 ? 0 : -1;
}

/* NAT：先 sysctl 打开 ip_forward，再确保这条规则存在（-C 检查，失败才 -A）
 *   iptables -t nat -A POSTROUTING -s 10.88.0.0/24 ! -o mc-br0 -j MASQUERADE
 * 真实运行时由 CNI 插件完成；这里用两次 run_cmd 即可，不再展开 */

int net_setup(struct container *c)
{
    char host[IFNAMSIZ], peer[IFNAMSIZ], pidbuf[16];

    if (ensure_bridge() == -1)
        return -1;
    snprintf(host, sizeof host, "mc%s0", c->id);   /* 8 位 id → 11 字节，够用 */
    snprintf(peer, sizeof peer, "mc%sp", c->id);
    snprintf(pidbuf, sizeof pidbuf, "%d", (int)c->pid);

    if (IP("link", "add", host, "type", "veth", "peer", "name", peer) == -1 ||
        IP("link", "set", peer, "netns", pidbuf) == -1 ||
        IP("link", "set", host, "master", "mc-br0") == -1 ||
        IP("link", "set", host, "up") == -1)
        return -1;
    return 0;
}
```

子进程侧不调用 `ip`，而是用 `ioctl` 直接改内核里的接口属性——这正是 `ip` 命令内部做的事，也是理解 `SIOCSIFADDR`、`SIOCSIFFLAGS`、`SIOCADDRT` 的机会。

```c
/* src/net.c — 子进程侧：在容器的 netns 里配地址与默认路由 */
#include <arpa/inet.h>
#include <errno.h>
#include <net/if.h>
#include <net/route.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <unistd.h>

static int set_addr(int fd, const char *name, const char *addr, unsigned long req)
{
    struct ifreq ifr;
    memset(&ifr, 0, sizeof ifr);
    snprintf(ifr.ifr_name, sizeof ifr.ifr_name, "%s", name);
    struct sockaddr_in *sin = (struct sockaddr_in *)&ifr.ifr_addr;
    sin->sin_family = AF_INET;
    if (inet_pton(AF_INET, addr, &sin->sin_addr) != 1) {
        errno = EINVAL;
        return -1;
    }
    return ioctl(fd, req, &ifr);
}

static int set_up(int fd, const char *name)
{
    struct ifreq ifr;
    memset(&ifr, 0, sizeof ifr);
    snprintf(ifr.ifr_name, sizeof ifr.ifr_name, "%s", name);
    if (ioctl(fd, SIOCGIFFLAGS, &ifr) == -1)
        return -1;
    ifr.ifr_flags |= IFF_UP | IFF_RUNNING;
    return ioctl(fd, SIOCSIFFLAGS, &ifr);
}

static int add_default_route(int fd, const char *gw, const char *dev)
{
    struct rtentry rt;
    memset(&rt, 0, sizeof rt);
    ((struct sockaddr_in *)&rt.rt_dst)->sin_family = AF_INET;
    ((struct sockaddr_in *)&rt.rt_genmask)->sin_family = AF_INET;
    struct sockaddr_in *gate = (struct sockaddr_in *)&rt.rt_gateway;
    gate->sin_family = AF_INET;
    if (inet_pton(AF_INET, gw, &gate->sin_addr) != 1) {
        errno = EINVAL;
        return -1;
    }
    rt.rt_flags = RTF_UP | RTF_GATEWAY;
    rt.rt_dev = (char *)dev;
    return ioctl(fd, SIOCADDRT, &rt);
}

int net_configure(const char *ip)
{
    int fd = socket(AF_INET, SOCK_DGRAM | SOCK_CLOEXEC, 0);
    if (fd == -1)
        return -1;
    int rc = -1;
    if (set_up(fd, "lo") == -1)
        goto out;
    if (set_addr(fd, "eth0", ip, SIOCSIFADDR) == -1 ||
        set_addr(fd, "eth0", "255.255.255.0", SIOCSIFNETMASK) == -1 ||
        set_up(fd, "eth0") == -1)
        goto out;
    if (add_default_route(fd, "10.88.0.1", "eth0") == -1)
        goto out;
    rc = 0;
out:
    close(fd);
    return rc;
}
```

`child_main` 的接线：换根之后、`execvp` 之前，等父进程一个字节再配网；父进程在 `clone` 返回后调用 `net_setup`，再写这个字节。管道用 `pipe2(O_CLOEXEC)` 创建，两端各关掉自己不用的方向。

**验证**：

```bash
# 需要 root（未实测）
sudo ./build/mycontainer run --ip 10.88.0.2 -- /bin/sh -c \
    'cat /sys/class/net/eth0/address; ip route; ping -c1 -W1 10.88.0.1'
# 1a:2b:3c:4d:5e:6f          ← 每次不同
# default via 10.88.0.1 dev eth0
# 10.88.0.0/24 dev eth0 scope link
# 1 packets transmitted, 1 received

# 宿主侧对照
ip -brief link show mc-br0
bridge link show master mc-br0
sudo iptables -t nat -L POSTROUTING -n | grep 10.88

# 清理
sudo ip link del mc-br0
sudo iptables -t nat -D POSTROUTING -s 10.88.0.0/24 ! -o mc-br0 -j MASQUERADE
```

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `RTNETLINK answers: Invalid argument`（`ip link add`） | 网卡名超过 `IFNAMSIZ-1`=15 字节 | 用短 id；名字里不要带完整容器 ID |
| `Cannot open network namespace "1234": No such file` | 子进程已退出，`/proc/<pid>/ns/net` 消失 | 先修子进程；或在 `clone` 后立即 `open` 并持有 netns fd |
| 容器里 `ping` 不通外网，但能 ping 网关 | 宿主没开 `ip_forward`，或缺 MASQUERADE | `sysctl net.ipv4.ip_forward`，检查 `iptables -t nat -L` |
| `ping: sendto: Network unreachable` | 没加默认路由，或 `eth0` 没 up | `ip route` 确认；顺序必须是先配地址再 up 再加路由 |
| `ioctl(SIOCSIFADDR): No such device` | `eth0` 还没被移进 netns（同步字节发早了） | 父进程先 `net_setup` 再写管道；子进程读到才继续 |
| 容器能出网但宿主访问不到 `10.88.0.2` | 网桥没 up，或宿主防火墙 DROP 了 FORWARD | `ip link set mc-br0 up`；`iptables -L FORWARD -n -v` |

**下一步**：Stage 6 处理生命周期。现在的容器一按 Ctrl-C，信号只到 `mycontainer`，容器里的进程可能变成孤儿；PID 1 还必须负责回收僵尸。

### A.1.9 Stage 6 · 生命周期：PID 1、信号与僵尸 {#sec-a.1.9}

**目标**：`--init` 下容器里的 1 号进程能把 `SIGTERM` 转发给应用、回收所有孤儿，并在应用退出后带着它的退出码结束。

```bash
# 需要 root（未实测）
sudo ./build/mycontainer run --init -- /bin/sh -c \
    'trap "echo got TERM; exit 0" TERM; sleep 100 & wait'
# 另一个终端：sudo kill -TERM <宿主 PID>
# got TERM
```

**关键概念**：PID namespace 的 1 号进程有两条特殊规则（[5.2.5](../part5/ch02.md#sec-5.2.5)）：

1. **没有处理函数的信号会被直接丢弃**，连 `SIGTERM` 也不会终止它。所以「容器不响应 `docker stop`」通常不是 Docker 的问题，而是应用没装 handler。
2. **它是整个 namespace 的收尸人**。任何孤儿进程都会被重新挂到它名下，它必须 `waitpid`，否则僵尸越积越多；PID 1 退出时，内核会杀掉该 namespace 里所有进程。

`SIGCHLD` 与转发要同时处理，单靠 `waitpid` 会阻塞在信号上，单靠 `sigwaitinfo` 又会漏掉已经退出的子进程。正确结构是「先非阻塞回收，再等信号」。

**代码**：`src/init.c`（完整）。

```c
/* src/init.c — Stage 6：容器内的 1 号进程 */
#include <errno.h>
#include <signal.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <unistd.h>

#include "container.h"

static void noop(int sig)
{
    (void)sig;
}

int init_loop(pid_t main_pid)
{
    sigset_t mask;
    sigfillset(&mask);

    /* PID 1 对 SIG_DFL 的信号直接忽略，且不会排队；先装空处理函数再阻塞 */
    for (int sig = 1; sig < NSIG; sig++) {
        if (sig == SIGKILL || sig == SIGSTOP)
            continue;
        struct sigaction sa;
        sa.sa_handler = noop;
        sa.sa_flags = SA_RESTART;
        sigemptyset(&sa.sa_mask);
        sigaction(sig, &sa, NULL);
    }
    if (sigprocmask(SIG_BLOCK, &mask, NULL) == -1)
        return 1;

    for (;;) {
        int status = 0;
        pid_t p;

        /* 先回收已经退出的（包括被过继来的孤儿） */
        while ((p = waitpid(-1, &status, WNOHANG)) > 0) {
            if (p != main_pid)
                continue;
            /* 主进程退出：PID 1 随之退出，内核会清掉这个 pid ns 的其余进程 */
            return WIFEXITED(status) ? WEXITSTATUS(status)
                                     : 128 + WTERMSIG(status);
        }
        if (p == -1 && errno != ECHILD) {
            /* ECHILD 表示暂时没有子进程，继续等信号 */
        }

        siginfo_t si;
        if (sigwaitinfo(&mask, &si) == -1) {
            if (errno == EINTR)
                continue;
            return 1;
        }
        if (si.si_signo != SIGCHLD)
            kill(main_pid, si.si_signo);
    }
}
```

`child_main` 的末段改为：`--init` 时 `fork` 出应用进程并进入 `init_loop(app)`，否则直接 `execvp`。父进程的 `mycontainer kill` 只需向容器的 cgroup 写 `cgroup.kill`（整组），`mycontainer ps` 读 `cgroup.procs` 再逐个查 `/proc/<pid>/comm`——两处都是十几行，不再展开。

**验证**：

```bash
# 需要 root（未实测）
# 1) 信号转发：trap 能打印说明 TERM 到了应用
sudo ./build/mycontainer run --init -- /bin/sh -c \
    'trap "echo got TERM; exit 0" TERM; sleep 100 & wait' &
sleep 1
sudo kill -TERM $(pgrep -f 'mycontainer run --init' | head -1)
# got TERM

# 2) 僵尸回收：应用反复产生短命子进程，容器内不应出现 defunct
sudo ./build/mycontainer run --init -- /bin/sh -c \
    'i=0; while [ $i -lt 200 ]; do (true) & i=$((i+1)); done; sleep 2; ps -o stat,pid,comm'
# 输出里不应出现 Z（zombie）

# 3) 退出码透传
sudo ./build/mycontainer run --init -- /bin/sh -c 'exit 7'; echo $?
# 7
```

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `kill -TERM` 后容器毫无反应 | PID 1 没有该信号的处理函数，内核直接丢弃 | 用 `--init`，或让应用自己 `sigaction` |
| 容器里 `ps` 出现大量 `Z` / `defunct` | PID 1 没有 `waitpid` 回收孤儿 | 用 `init_loop` 的回收循环；不要只等主进程 |
| `sigwaitinfo: Interrupted system call` 反复出现 | 信号没被阻塞，或装了 `SA_RESTART` 之外的处理函数 | 先 `sigprocmask(SIG_BLOCK)` 再 `sigwaitinfo` |
| `kill: (1): Operation not permitted` | 从宿主对容器 PID 1 发信号，或跨 user namespace 权限不足 | 从同一 ns 内发；宿主上用 `cgroup.kill` 整组击杀 |
| 退出码总是 0 | `waitpid` 的 `status` 没解包 `WIFEXITED` | 用 `WEXITSTATUS` / `128 + WTERMSIG` |

**下一步**：Stage 7 收窄权限。到现在为止，容器里的 root 仍拥有默认 capabilities、可以 `mount`、可以 `mknod`——离「能跑」只差一步，离「安全」还差三套机制。

### A.1.10 Stage 7 · 安全：capabilities、seccomp 与 `no_new_privs` {#sec-a.1.10}

**目标**：容器里的 `uid=0` 不再拥有任何 capability，`mount` 返回 `EPERM`，`/proc/self/status` 显示 `Seccomp: 2`、`NoNewPrivs: 1`。

```bash
# 需要 root（未实测）
sudo ./build/mycontainer run -- /bin/sh -c \
    'grep -E "CapEff|Seccomp|NoNewPrivs" /proc/self/status; mount -t tmpfs none /mnt'
# CapEff: 0000000000000000
# Seccomp:          2
# NoNewPrivs:       1
# mount: mounting none on /mnt failed: Operation not permitted
```

**关键概念**：三套机制各管一段，缺一不可（[5.1.7](../part5/ch01.md#sec-5.1.7)）。**capabilities** 决定 root 能调用哪些特权操作，`CapEff` 是 effective 集合的位图；**`no_new_privs`** 让 `execve` 不再赋予新特权，堵住 setuid 与文件 capability 的提权路径；**seccomp** 用 BPF 按系统调用号过滤，把危险调用直接变成 `EPERM` 或杀死进程。三者都必须在 `execve` 之前生效。

顺序有讲究：先 `PR_SET_NO_NEW_PRIVS`，再清空 **bounding set**（它决定 `execve` 后能重新获得哪些能力），最后 `capset` 清空当前集合，最后装 seccomp。反过来的话，清空 permitted 后就没有 `CAP_SETPCAP` 去改 bounding set 了。

**代码**：`src/security.c`（完整）。

```c
/* src/security.c — Stage 7：最小权限 + 系统调用过滤 */
#include <errno.h>
#include <linux/audit.h>
#include <linux/capability.h>
#include <linux/filter.h>
#include <linux/seccomp.h>
#include <stddef.h>
#include <sys/prctl.h>
#include <sys/syscall.h>
#include <unistd.h>

#include "container.h"

static int drop_bounding_set(void)
{
    /* 上界集合是 execve 后能重新获得的权限上限。内核只定义了 0..40，
       更大的值返回 EINVAL，忽略即可，不必去读 cap_last_cap */
    for (int cap = 0; cap <= 63; cap++) {
        if (prctl(PR_CAPBSET_DROP, cap, 0, 0, 0) == -1 && errno != EINVAL)
            return -1;
    }
    return 0;
}

static int drop_all_caps(void)
{
    struct __user_cap_header_struct hdr;
    struct __user_cap_data_struct data[2];

    hdr.version = _LINUX_CAPABILITY_VERSION_3;
    hdr.pid = 0;
    for (int i = 0; i < 2; i++) {
        data[i].effective = 0;
        data[i].permitted = 0;
        data[i].inheritable = 0;
    }
    return (int)syscall(SYS_capset, &hdr, data);
}

static int install_seccomp(void)
{
#if defined(__x86_64__)
    const unsigned int native_arch = AUDIT_ARCH_X86_64;
#elif defined(__aarch64__)
    const unsigned int native_arch = AUDIT_ARCH_AARCH64;
#else
#error "只支持 x86-64 与 aarch64"
#endif
    struct sock_filter filter[] = {
        /* 先验架构：x86-64 上混入 32 位 ABI 是经典绕过手法 */
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, arch)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, native_arch, 1, 0),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_KILL_PROCESS),
        BPF_STMT(BPF_LD | BPF_W | BPF_ABS, offsetof(struct seccomp_data, nr)),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_mount, 3, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_pivot_root, 2, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_reboot, 1, 0),
        BPF_JUMP(BPF_JMP | BPF_JEQ | BPF_K, __NR_init_module, 0, 1),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ERRNO | (EPERM & SECCOMP_RET_DATA)),
        BPF_STMT(BPF_RET | BPF_K, SECCOMP_RET_ALLOW),
    };
    struct sock_fprog prog;
    prog.len = (unsigned short)(sizeof filter / sizeof filter[0]);
    prog.filter = filter;
    return prctl(PR_SET_SECCOMP, SECCOMP_MODE_FILTER, &prog);
}

int security_apply(void)
{
    if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0) == -1)
        return -1;
    if (drop_bounding_set() == -1 || drop_all_caps() == -1)
        return -1;
    return install_seccomp();
}
```

第 4–8 条指令是一张跳转表：命中所禁调用就跳到 `SECCOMP_RET_ERRNO`，否则落到 `SECCOMP_RET_ALLOW`。改这个数组就能加规则，但**不要禁掉 `execve`、`openat`、`write`**——你的 `execvp` 与日志还在用它们。

**验证**：

```bash
# 需要 root（未实测）
sudo ./build/mycontainer run -- /bin/sh -c \
    'capsh --decode=$(grep CapEff /proc/self/status | awk "{print \$2}"); \
     grep -E "Seccomp|NoNewPrivs" /proc/self/status'
# 0000000000000000=（空集合）
# Seccomp:          2
# NoNewPrivs:       1

# 对照：Stage 6 之前的版本，CapEff 应是 00000000a80425fb（14 个默认能力）
```

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `capset: Operation not permitted` | 顺序错了：先清空 permitted，就再也不能改 bounding set | 先 `PR_CAPBSET_DROP`，再 `capset` |
| `prctl(PR_CAPBSET_DROP): Operation not permitted` | 进程已没有 `CAP_SETPCAP` | 在 drop 之前不要先清空能力；确认以 root 启动 |
| 程序启动即被 `SIGSYS` 杀死 | 架构常量不匹配（arm64 上用了 x86），或过滤器漏了 `ALLOW` | 用 `#if` 选 `AUDIT_ARCH_*`；用 `strace` 看最后一条系统调用 |
| `Seccomp: 0`，但 `mount` 仍失败 | 被 capability 拦住，不是 seccomp | 两套机制分开验证：先看 `CapEff`，再看 `Seccomp` |
| `mount` 返回 `EPERM` 而不是被杀死 | 用了 `SECCOMP_RET_ERRNO` | 这是预期行为；要硬失败改成 `SECCOMP_RET_KILL_PROCESS` |

**下一步**：Stage 8 把前七个 Stage 收进一份可重复执行的验收脚本，并做两类故障注入。到这里，`mycontainer` 已经能跑一个真实的、被限额、被隔离、被收窄权限的进程。

### A.1.11 Stage 8 · 验收：脚本、故障注入与复盘 {#sec-a.1.11}

**目标**：一条命令跑完六项检查；两类故障注入有确定的观察结果；复盘写清三个问题。

```bash
# 需要 root（未实测）
sudo ./tests/run.sh
# PASS uts
# PASS pid
# PASS memory
# PASS caps
# PASS exit-code
# all checks passed
```

**代码**：`tests/run.sh`（完整，注意它自己清理挂载与 cgroup）。

```bash
#!/usr/bin/env bash
# tests/run.sh — mycontainer 验收；需要 root，在虚拟机里跑
set -uo pipefail
BIN=./build/mycontainer
ROOT=/var/lib/mycontainer/rootfs
fail=0

check() {  # check 名称 命令
    if eval "$2"; then echo "PASS $1"; else echo "FAIL $1"; fail=1; fi
}

out=$(sudo "$BIN" run --rootfs "$ROOT" --hostname t1 -- /bin/hostname 2>/dev/null)
check uts '[ "$out" = t1 ]'

out=$(sudo "$BIN" run --rootfs "$ROOT" -- /bin/sh -c 'ps -e | wc -l' 2>/dev/null)
check pid '[ "$out" -le 4 ]'

out=$(sudo "$BIN" run --rootfs "$ROOT" --memory 32M -- /bin/sh -c \
      'head -c 100000000 /dev/zero | tail -c 1 >/dev/null; echo alive' 2>/dev/null)
check memory '[ "$out" != alive ]'

out=$(sudo "$BIN" run --rootfs "$ROOT" -- /bin/sh -c \
      'grep -cE "^CapEff:[[:space:]]+0+$" /proc/self/status' 2>/dev/null)
check caps '[ "$out" = 1 ]'

sudo "$BIN" run --rootfs "$ROOT" --init -- /bin/sh -c 'exit 9' >/dev/null 2>&1
check exit-code '[ "$?" = 9 ]'

sudo umount -R /run/mycontainer 2>/dev/null || true
sudo rm -rf /run/mycontainer
[ "$fail" = 0 ] && echo "all checks passed"
exit "$fail"
```

`head -c /dev/zero` 不会真的分配内存，它只是读一个字符设备——用它测 OOM 是**假测试**，必须换成真正分配的程序（`stress-ng --vm` 或一个 `malloc` + `memset` 的小 C 程序）。这个反例值得保留在复盘里：验收脚本最危险的不是跑不过，而是**跑过了但没测到**。

**故障注入**：

| 注入 | 命令 | 期望 |
|:--|:--|:--|
| 父进程被杀 | 容器运行中 `sudo kill -9 <mycontainer 父 PID>` | overlay 与 cgroup 残留；下次启动前必须能清理干净 |
| `/run` 写满 | `sudo mount -t tmpfs -o size=1M tmpfs /run/mycontainer` | overlay 建 upper 失败，报 `ENOSPC`，不崩溃 |
| fd 耗尽 | `sudo bash -c 'ulimit -n 16; ./build/mycontainer run ...'` | `open`/`clone` 失败有明确错误，不泄漏 |
| OOM | `--memory 32M` + 真正分配 100 MB 的程序 | 被 `SIGKILL`，`memory.events` 的 `oom_kill` 加 1 |

**复盘**（写进 `docs/retro.md`，四个问题）：

1. **假设与证伪**：原以为「namespace 做完就隔离了」，结果 `CapEff=00000000a80425fb`——默认 14 个能力仍在，容器 root 还能 `mknod`、`chown`。隔离与权限是两件事。
2. **最难的 bug**：`rmdir: Device or resource busy`。根因是 `cgroup.kill` 之后没等 `waitpid` 回收，进程还在组里；修复是先回收再删，并在退出路径统一调 `cg_destroy`。
3. **如果重做**：先写 `tests/run.sh` 再写 Stage 1；用 netlink 替代 `ip` 命令；用 `clone3` 的 `CLONE_INTO_CGROUP` 消除「先 clone 再 attach」的窗口。

## A.2 高性能 HTTP 服务器 `myhttpd` {#sec-a.2}

### A.2.1 目标与真实对应物 {#sec-a.2.1}

`myhttpd` 对应 nginx/lighttpd 的核心路径：非阻塞 `accept`、`epoll` 事件循环、HTTP/1.1 增量解析、`sendfile` 零拷贝、keep-alive 与超时、优雅关闭。我们做单机静态文件服务器，不做 TLS、HTTP/2、反向代理与动态脚本。

九个 Stage 是一条性能曲线：Stage 0 能 echo，Stage 1 能解析，Stage 2 能发文件，Stage 3 多核，Stage 4 不被慢客户端拖死，Stage 5 用 `SO_REUSEPORT` 让内核帮你分发连接，Stage 6 用数据说话，Stage 7 能解释线上现象，Stage 8 收口。**每一 Stage 都要能跑 `wrk`**，否则你无法判断优化是否有效。

### A.2.2 架构：连接状态机与多 reactor {#sec-a.2.2}

一条连接的生命周期被拆成四个状态：`C_READ`（攒请求头）→ `C_WRITE`（写响应头）→ `C_SENDFILE`（循环发文件体）→ `C_CLOSE`。每个状态只做一件事，且必须在 `EAGAIN` 时把控制权交回 `epoll_wait`——这是 ET 模式唯一正确的写法。

```c
/* include/server.h — 连接、worker 与共享状态（Stage 3 起使用） */
struct buffer {
    char  *data;
    size_t cap, len, off;      /* off：已消费到的位置，避免每次 memmove */
};

struct conn {
    int fd;
    struct buffer in, out;
    struct http_request req;
    int file_fd;
    off_t file_off;
    size_t file_left;
    uint64_t deadline_ms;
    enum { C_READ, C_WRITE, C_SENDFILE, C_CLOSE } state;
    bool keep_alive;
    struct worker *w;
};

struct worker {
    int epfd;
    int notify_fd;                 /* eventfd：主线程把新连接交给 worker */
    pthread_mutex_t mu;
    int queue[256];                /* fd 是进程级资源，跨线程传 int 即可 */
    size_t qhead, qtail;
    struct timer_heap timers;
    struct metrics *metrics;
};
```

两个设计决定值得先说清。**fd 不需要 `SCM_RIGHTS`**：线程共享文件描述符表，主线程 `accept` 出来的 fd 直接放进队列，worker 拿到就能用；跨进程（Stage 5 的 `SO_REUSEPORT`）才需要每个进程自己 `accept`。**缓冲区用 `off` 而不是每次 `memmove`**：HTTP 解析需要「保留未消费的尾部」，把已消费的前缀留在原地、只移动指针，能把每请求一次的内存搬移降为零；`buf_compact` 只在 `off` 超过容量一半时调用。

### A.2.3 Stage 0 · epoll 回显：先把事件循环跑对 {#sec-a.2.3}

**目标**：`nc` 连上去发什么回什么；1000 个并发连接不断、不卡、CPU 不飙。

```bash
make && ./build/myhttpd 8080 &
printf 'hello\n' | nc -q1 127.0.0.1 8080
# hello
```

**关键概念**：水平触发（LT）下，只要缓冲区还有数据，`epoll_wait` 会反复通知；边缘触发（ET）只在状态**变化**时通知一次，所以必须循环读到 `EAGAIN`。本项目的监听 fd 用 LT（接受连接简单可靠），连接 fd 用 ET（减少唤醒）；两者混用是常见做法。`accept4` 的 `SOCK_NONBLOCK | SOCK_CLOEXEC` 一次到位，避免 `accept` + `fcntl` 的竞态。

**代码**：`src/main.c`（Stage 0 全量，可直接编译运行）。

```c
/* src/main.c — Stage 0：epoll 回显服务器 */
#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/socket.h>
#include <unistd.h>

#define MAX_EVENTS 64

static int set_nonblock(int fd)
{
    int fl = fcntl(fd, F_GETFL);
    if (fl == -1)
        return -1;
    return fcntl(fd, F_SETFL, fl | O_NONBLOCK);
}

static int write_all(int fd, const char *buf, size_t len)
{
    size_t off = 0;
    while (off < len) {
        ssize_t n = write(fd, buf + off, len - off);
        if (n == -1) {
            if (errno == EINTR)
                continue;
            return -1;                    /* EAGAIN 也在这里：调用方需缓冲 */
        }
        off += (size_t)n;
    }
    return 0;
}

int main(int argc, char **argv)
{
    int port = argc > 1 ? atoi(argv[1]) : 8080;

    int lfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
    if (lfd == -1) {
        perror("socket");
        return 1;
    }
    int one = 1;
    setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);

    struct sockaddr_in sa = {
        .sin_family = AF_INET,
        .sin_addr.s_addr = htonl(INADDR_ANY),
        .sin_port = htons((uint16_t)port),
    };
    if (bind(lfd, (struct sockaddr *)&sa, sizeof sa) == -1 ||
        listen(lfd, 128) == -1 || set_nonblock(lfd) == -1) {
        perror("bind/listen");
        return 1;
    }

    int ep = epoll_create1(EPOLL_CLOEXEC);
    struct epoll_event ev = { .events = EPOLLIN, .data.fd = lfd };
    if (ep == -1 || epoll_ctl(ep, EPOLL_CTL_ADD, lfd, &ev) == -1) {
        perror("epoll");
        return 1;
    }

    struct epoll_event evs[MAX_EVENTS];
    for (;;) {
        int n = epoll_wait(ep, evs, MAX_EVENTS, -1);
        if (n == -1) {
            if (errno == EINTR)
                continue;
            perror("epoll_wait");
            break;
        }
        for (int i = 0; i < n; i++) {
            int fd = evs[i].data.fd;
            if (fd == lfd) {
                for (;;) {
                    int c = accept4(lfd, NULL, NULL, SOCK_NONBLOCK | SOCK_CLOEXEC);
                    if (c == -1) {
                        if (errno == EAGAIN || errno == EWOULDBLOCK)
                            break;
                        if (errno == EINTR || errno == ECONNABORTED)
                            continue;
                        perror("accept4");
                        break;
                    }
                    struct epoll_event cev = { .events = EPOLLIN | EPOLLRDHUP, .data.fd = c };
                    epoll_ctl(ep, EPOLL_CTL_ADD, c, &cev);
                }
            } else if (evs[i].events & (EPOLLERR | EPOLLHUP | EPOLLRDHUP)) {
                close(fd);                     /* Stage 4 会改成状态机收尾 */
            } else {
                char buf[4096];
                ssize_t r = read(fd, buf, sizeof buf);
                if (r > 0 && write_all(fd, buf, (size_t)r) == -1)
                    close(fd);
                else if (r == 0 || (r == -1 && errno != EAGAIN && errno != EINTR))
                    close(fd);
            }
        }
    }
    close(ep);
    close(lfd);
    return 0;
}
```

这段代码有**故意留下的两个缺陷**，Stage 2 与 Stage 4 会修：`write_all` 遇到 `EAGAIN` 直接失败（正确做法是缓冲剩余数据、注册 `EPOLLOUT`）；`close(fd)` 后没有从 `epoll` 删除，依赖内核在 `close` 时自动摘除（这一点恰好是安全的，但显式 `EPOLL_CTL_DEL` 更清晰）。

**验证**：

```bash
make
./build/myhttpd 8080 &
printf 'hello\n' | nc -q1 127.0.0.1 8080        # hello
# 1000 条并发连接，观察 fd 与内存
ulimit -n 4096
seq 1 1000 | xargs -P200 -I{} sh -c 'printf x | nc -q0 127.0.0.1 8080 >/dev/null'
ls /proc/$(pgrep myhttpd)/fd | wc -l            # 连接关闭后应回落到 4 左右
```

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `epoll_wait` 返回后 `read` 一直是 `EAGAIN` | 用了 ET 却没有循环读，或读的长度太小 | 循环读到 `EAGAIN`；单次读 4–64 KB |
| `accept4: Too many open files` | `ulimit -n` 太小，或 fd 泄漏（没 `close`） | 提高 `ulimit -n`；每条错误路径都 `close` |
| 客户端收不到回显，服务端 CPU 100% | `EPOLLHUP` 分支没关 fd，`epoll_wait` 立刻再次返回 | `EPOLLERR|EPOLLHUP` 必须 `close` |
| `bind: Address already in use` | 上次进程没退，`TIME_WAIT` 占着端口 | `SO_REUSEADDR`；或换端口 |
| 压测几千连接后 `epoll_ctl: Bad file descriptor` | fd 被 `close` 后仍留在 epoll 里（跨线程竞态） | 关闭前 `EPOLL_CTL_DEL`，或保证同一线程操作 |

**下一步**：Stage 1 把回显换成 HTTP 解析。先写解析器与单元测试，再接进事件循环——解析器的 bug 不应该靠 `curl` 才发现。

### A.2.4 Stage 1 · HTTP/1.1 解析：先写解析器，再接事件循环 {#sec-a.2.4}

**目标**：解析器单元测试全绿——正常请求、缺尾、坏版本、重复 `Content-Length` 各有确定结果。

```bash
make test
# test_http: all assertions passed
```

**关键概念**：HTTP/1.1 是**增量协议**：一次 `read` 可能只到半个请求行，所以解析器必须能回答「还不够」（`HTTP_INCOMPLETE`）、「好了」（`HTTP_DONE`）、「坏了」（`HTTP_BAD`）三种状态，且**不能假设输入以 `\0` 结尾**。安全上有三条硬规则：字段名与冒号之间不许有空白（请求走私的经典入口）；重复且不一致的 `Content-Length` 必须拒绝；请求行里的控制字符必须拒绝。

```c
/* include/http.h — 解析结果（只保留指针，不复制头部值） */
#define HTTP_MAX_HEADERS 32
#define HTTP_MAX_TARGET  1024
#define HTTP_MAX_HEADER_BYTES 8192

struct http_header { const char *name; size_t name_len; const char *value; size_t value_len; };

struct http_request {
    char method[8];
    char target[HTTP_MAX_TARGET];
    int  minor;                                  /* HTTP/1.<minor> */
    struct http_header headers[HTTP_MAX_HEADERS];
    size_t nheaders;
    unsigned long long content_length;
    bool keep_alive;
    size_t head_len;
};

enum http_status { HTTP_INCOMPLETE = 0, HTTP_DONE, HTTP_BAD };
enum http_status http_parse_request(const char *buf, size_t len,
                                    struct http_request *req, int *err_status);
```

```c
/* src/http.c — 请求行：方法、目标、版本 */
static bool token_char(unsigned char c)
{
    return c > 0x20 && c < 0x7f &&
           (isalnum(c) || strchr("!#$%&'*+-.^_`|~", c) != NULL);
}

static const char *find_head(const char *b, size_t n)
{
    for (size_t i = 0; i + 3 < n; i++)
        if (b[i] == '\r' && b[i + 1] == '\n' && b[i + 2] == '\r' && b[i + 3] == '\n')
            return b + i;
    return NULL;
}

enum http_status http_parse_request(const char *buf, size_t len,
                                    struct http_request *req, int *err)
{
    memset(req, 0, sizeof *req);
    *err = 0;

    const char *end = find_head(buf, len);
    if (end == NULL) {
        if (len > HTTP_MAX_HEADER_BYTES) { *err = 431; return HTTP_BAD; }
        return HTTP_INCOMPLETE;
    }
    req->head_len = (size_t)(end - buf) + 4;

    const char *eol = memchr(buf, '\r', req->head_len);
    if (eol == NULL || eol[1] != '\n') { *err = 400; return HTTP_BAD; }
    const char *sp1 = memchr(buf, ' ', (size_t)(eol - buf));
    const char *sp2 = sp1 ? memchr(sp1 + 1, ' ', (size_t)(eol - sp1 - 1)) : NULL;
    if (sp1 == NULL || sp2 == NULL) { *err = 400; return HTTP_BAD; }

    size_t mlen = (size_t)(sp1 - buf), tlen = (size_t)(sp2 - sp1 - 1);
    if (mlen == 0 || mlen >= sizeof req->method) { *err = 400; return HTTP_BAD; }
    for (size_t i = 0; i < mlen; i++)
        if (!token_char((unsigned char)buf[i])) { *err = 400; return HTTP_BAD; }
    memcpy(req->method, buf, mlen);
    req->method[mlen] = '\0';

    if (tlen == 0) { *err = 400; return HTTP_BAD; }
    if (tlen >= sizeof req->target) { *err = 414; return HTTP_BAD; }
    memcpy(req->target, sp1 + 1, tlen);
    req->target[tlen] = '\0';

    if ((size_t)(eol - sp2 - 1) != 8 || memcmp(sp2 + 1, "HTTP/1.", 7) != 0 ||
        (sp2[8] != '0' && sp2[8] != '1')) { *err = 505; return HTTP_BAD; }
    req->minor = sp2[8] - '0';
    req->keep_alive = req->minor >= 1;
```

```c
    /* 头部：每一行都是 name ":" OWS value OWS CRLF；最后一行的 CRLF 恰好是 end */
    const char *p = eol + 2;
    while (p < end) {
        const char *he = memchr(p, '\r', (size_t)(end - p) + 2);
        if (he == NULL || he > end || he[1] != '\n') { *err = 400; return HTTP_BAD; }
        const char *colon = memchr(p, ':', (size_t)(he - p));
        if (colon == NULL || colon == p) { *err = 400; return HTTP_BAD; }
        for (const char *q = p; q < colon; q++)
            if (!token_char((unsigned char)*q)) { *err = 400; return HTTP_BAD; }

        const char *v = colon + 1, *ve = he;
        while (v < ve && (*v == ' ' || *v == '\t')) v++;
        while (ve > v && (ve[-1] == ' ' || ve[-1] == '\t')) ve--;
        if (req->nheaders == HTTP_MAX_HEADERS) { *err = 431; return HTTP_BAD; }
        req->headers[req->nheaders++] =
            (struct http_header){ p, (size_t)(colon - p), v, (size_t)(ve - v) };
        if (he == end) break;
        p = he + 2;
    }

    bool saw_cl = false;
    for (size_t i = 0; i < req->nheaders; i++) {
        const struct http_header *h = &req->headers[i];
        if (h->name_len == 14 && strncasecmp(h->name, "content-length", 14) == 0) {
            char tmp[20];
            if (saw_cl || h->value_len == 0 || h->value_len >= sizeof tmp ||
                !isdigit((unsigned char)h->value[0])) { *err = 400; return HTTP_BAD; }
            memcpy(tmp, h->value, h->value_len);
            tmp[h->value_len] = '\0';
            char *stop = NULL;
            req->content_length = strtoull(tmp, &stop, 10);
            if (stop == NULL || *stop != '\0') { *err = 400; return HTTP_BAD; }
            saw_cl = true;
        } else if (h->name_len == 10 && strncasecmp(h->name, "connection", 10) == 0) {
            for (size_t k = 0; k + 5 <= h->value_len; k++) {
                if (strncasecmp(h->value + k, "close", 5) == 0)
                    req->keep_alive = false;
                if (req->minor == 0 && k + 10 <= h->value_len &&
                    strncasecmp(h->value + k, "keep-alive", 10) == 0)
                    req->keep_alive = true;
            }
        }
    }
    return HTTP_DONE;
}
```

这段代码的边界处理值得逐个看：`find_head` 找不到终止符时，只有**超过上限**才报 431，否则返回「还不够」；头部的最后一行没有自己的独立空行，它的 CRLF 与终止空行共用 `\r\n\r\n` 的前两个字节，所以搜索范围是 `end - p + 2` 而不是 `end - p`——这个 off-by-two 是手写解析器最常见的 bug，本文的单元测试专门覆盖它。

**验证**：`tests/test_http.c` 用 12 个 `assert` 覆盖正常请求、缺尾、坏版本、重复 `Content-Length`、字段名与冒号间空白等边界；`make test` 运行。这三个关键用例分别锁住：正常路径、重复 `Content-Length` 的走私面、字段名与冒号之间的空白。测试代码本身也要过 ASan——本页的解析器、定时器堆、指标渲染在 clang 21 + ASan/UBSan 下零报告。

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| 每个请求都返回 `HTTP_INCOMPLETE` | 只读了请求行就调用解析；或比较的是 `\n\n` 而不是 `\r\n\r\n` | 先 `find_head`，再解析 |
| 最后一个头部丢失 | 头部搜索范围写成 `end - p`，漏掉最后一行与终止空行共用的 CRLF | 搜索范围 `end - p + 2` |
| `strncasecmp` 读越界 | 用 `\0` 结尾假设，但缓冲区不是字符串 | 所有比较都带长度 |
| 合法请求被判 400 | 方法/字段名里含 `-`、`_`、`.` 等 token 字符 | `token_char` 的白名单要完整 |
| 客户端发 `Expect: 100-continue` 后卡住 | 服务器没回 `100 Continue` | 静态服务器直接读 body 或回 `417` |

**下一步**：Stage 2 把解析结果变成文件响应：路径归一化、`openat2` 防逃逸、`sendfile` 循环发送与 `EAGAIN` 处理。

### A.2.5 Stage 2 · 静态文件与 `sendfile` {#sec-a.2.5}

**目标**：`curl -I` 返回正确的 `Content-Length`，`curl` 拿到文件字节；`../` 与符号链接逃逸被拒绝。

```bash
curl -sI http://127.0.0.1:8080/index.html | head -3
# HTTP/1.1 200 OK
# Content-Length: 12
# Content-Type: text/html
```

**关键概念**：路径归一化必须在**打开之前**完成，打开之后再用 `openat2` 的 `RESOLVE_BENEATH` 把「不能逃出 root」交给内核保证；`sendfile` 把文件页直接送进 socket，省掉用户态缓冲区，但它可能只发一部分，遇到 `EAGAIN` 必须注册 `EPOLLOUT` 后继续。`openat2` 需要 Linux 5.6+，更老的核只能逐段 `openat(O_NOFOLLOW|O_DIRECTORY)`。

```c
/* src/file.c — 打开 root 下的文件；路径已由 http_target_to_path 归一化 */
#include <errno.h>
#include <fcntl.h>
#include <linux/openat2.h>
#include <sys/syscall.h>
#include <unistd.h>

int open_beneath(int dirfd, const char *path)
{
    struct open_how how = {
        .flags = O_RDONLY | O_CLOEXEC | O_NONBLOCK,
        .resolve = RESOLVE_BENEATH | RESOLVE_NO_MAGICLINKS,
    };
    int fd = (int)syscall(SYS_openat2, dirfd, path, &how, sizeof how);
    if (fd == -1 && errno == ENOSYS)   /* 5.6 之前：只能挡住最后一段符号链接 */
        fd = openat(dirfd, path, O_RDONLY | O_CLOEXEC | O_NOFOLLOW);
    return fd;
}

/* 返回 1 发完、0 需要等 EPOLLOUT、-1 出错；*left 跨事件保留 */
int send_file(int out_fd, int in_fd, off_t *off, size_t *left)
{
    while (*left > 0) {
        ssize_t n = sendfile(out_fd, in_fd, off, *left);
        if (n == -1) {
            if (errno == EINTR)
                continue;
            if (errno == EAGAIN || errno == EWOULDBLOCK)
                return 0;
            return -1;
        }
        if (n == 0)
            return -1;                 /* 文件在发送中被截断 */
        *left -= (size_t)n;
    }
    return 1;
}
```

`http_target_to_path` 负责三件事：百分号解码（拒绝 `%00` 与 `%2F`）、拒绝 `..` 段、目录补 `index.html`。它返回 `200` 时才调用 `open_beneath`；返回 `403`/`400` 直接生成错误响应。**不要**先拼出完整路径再 `realpath` 比较——那是 TOCTOU 的温床。

**验证**：

```bash
curl -s http://127.0.0.1:8080/hello.txt            # hello
curl -s -o /dev/null -w '%{http_code}\n' \
     --path-as-is http://127.0.0.1:8080/../../etc/passwd   # 403
ln -s /etc/passwd www/leak && \
curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8080/leak  # 403
```

**常见错误**：

| 报错文本 | 原因 | 修复 |
|:--|:--|:--|
| `sendfile: Invalid argument` | `in_fd` 不是普通文件（如目录或 socket） | 打开前 `fstat` 判 `S_ISREG` |
| 大文件只发出前 8 KB | 没循环 `sendfile`，或把 `EAGAIN` 当致命错误 | 用 `*left` 记录剩余，`EPOLLOUT` 后继续 |
| `openat2: Function not implemented` | 内核 < 5.6 或容器 seccomp 拦了 | 走 `openat` 回退；确认 seccomp 白名单 |
| 目录请求返回 500 | 打开的是目录，`sendfile` 失败 | 目录补 `index.html`；没有则 403/404 |
| `Content-Length` 与实际字节不符 | 用 `stat` 的大小，但文件在发送中被改 | 发送前 `fstat` 一次，以打开的 fd 为准 |

**下一步**：Stage 3 把单线程换成「一个 acceptor + N 个 worker」，每个 worker 一个 epoll；先解决 CPU 打不满一个核的问题。

### A.2.6 Stage 3 · 线程池与多 reactor {#sec-a.2.6}

**目标**：`nproc` 个 worker 各自 `epoll_wait`，`wrk -t4` 时四个核都在忙；主线程只做 `accept`。

```bash
wrk -t4 -c400 -d10s http://127.0.0.1:8080/hello.txt
# 与 Stage 2 的单线程基线相比，RPS 应接近线性增长（上限由网卡与内存带宽决定）
```

**关键概念**：`epoll` 实例是**进程级**的，多个线程可以各自持有一个；fd 只需注册进其中一个。主线程 `accept` 后把 fd 放进某 worker 的队列，再用 `eventfd` 叫醒它——这是「一个 acceptor + N 个 reactor」。不要在多个线程里对同一个 fd 调 `epoll_ctl`，否则会出现「谁最后改谁生效」的竞态。

```c
/* src/worker.c — 把新连接交给 worker；fd 是进程级资源，传 int 即可 */
int worker_push(struct worker *w, int fd)
{
    pthread_mutex_lock(&w->mu);
    size_t next = (w->qtail + 1) % (sizeof w->queue / sizeof w->queue[0]);
    if (next == w->qhead) {                    /* 队列满：拒绝，别阻塞 acceptor */
        pthread_mutex_unlock(&w->mu);
        errno = EAGAIN;
        return -1;
    }
    w->queue[w->qtail] = fd;
    w->qtail = next;
    pthread_mutex_unlock(&w->mu);

    uint64_t one = 1;
    return write(w->notify_fd, &one, sizeof one) == (ssize_t)sizeof one ? 0 : -1;
}

/* worker 主循环：eventfd 可读 → 收下所有新 fd；其余事件走状态机 */
void *worker_main(void *arg)
{
    struct worker *w = arg;
    struct epoll_event evs[256];

    for (;;) {
        int n = epoll_wait(w->epfd, evs, 256, next_timeout_ms(w));
        if (n == -1) {
            if (errno == EINTR)
                continue;
            break;
        }
        for (int i = 0; i < n; i++)
            handle_event(w, &evs[i]);          /* 含 eventfd、监听错误、连接读写 */
        run_timers(w, now_ms());               /* Stage 4 的超时扫描 */
    }
    return NULL;
}
```

**常见错误**：`eventfd` 没用 `EFD_NONBLOCK` 导致 worker 卡死；队列满时阻塞 `accept` 线程；`epoll_ctl` 跨线程操作同一 fd；worker 退出时没 `join`。**下一步**：Stage 4 处理慢客户端——没有超时，一个只发一半请求的连接就能占住 worker 的槽位。

### A.2.7 Stage 4 · keep-alive、超时与优雅关闭 {#sec-a.2.7}

**目标**：一条连接上连发 100 个请求都成功；空闲 5 秒被服务端关闭；`SIGTERM` 后不再接新连接，存量请求在 10 秒内收尾。

```bash
for i in $(seq 100); do curl -s -o /dev/null -w '%{http_code} ' \
    --keepalive-time 30 http://127.0.0.1:8080/hello.txt; done; echo
# 100 个 200
```

**关键概念**：keep-alive 要求响应带正确的 `Content-Length` 或 `Transfer-Encoding: chunked`，否则客户端无法判断边界；每个连接维护一个 `deadline_ms`，用最小堆取最近到期者作为 `epoll_wait` 的 timeout；优雅关闭用 `signalfd` 把 `SIGTERM` 变成可读事件，先 `close` 监听 fd、再等存量连接归零或超时。

```c
/* src/server.c — 每个连接的三条时间线：读超时、写超时、keep-alive 空闲超时 */
static void arm(struct conn *c, uint64_t ms)
{
    c->deadline_ms = now_ms() + ms;
    timer_set(&c->w->timers, c->fd, c->deadline_ms);   /* 更新即重排堆 */
}

static void on_request_done(struct conn *c)
{
    metrics_observe(c->w->metrics, now_ms() - c->start_ms);

    if (!c->keep_alive || c->req.minor == 0) {
        conn_close(c);
        return;
    }
    /* 复用连接：清空输入输出，回到读状态，重新武装空闲超时 */
    buf_consume(&c->in, c->req.head_len + c->req.content_length);
    buf_reset(&c->out);
    c->state = C_READ;
    arm(c, IDLE_TIMEOUT_MS);
}
```

`epoll_wait` 的 timeout 取 `timer_next()` 与当前时间的差，没有定时器就传 `-1`。关闭流程的顺序不能反：先停 acceptor（否则新连接不断进来），再 `shutdown(fd, SHUT_WR)` 让客户端知道结束，最后 `close`。收到 `SIGTERM` 后给存量连接一个总期限（比如 10 秒），到点强制 `close` 并记录 `metrics.errors_total`。

**常见错误**：keep-alive 下忘记 `buf_consume` 导致同一请求被解析两次（表现为重复响应）；`Content-Length` 缺失时客户端一直等；`epoll_wait` 用固定 1000 ms 轮询，空闲连接多时 CPU 空转；`SIGTERM` 处理函数里调 `printf`（非 async-signal-safe）。**下一步**：Stage 5 用 `SO_REUSEPORT` 把「一个 acceptor」也去掉。

### A.2.8 Stage 5 · `SO_REUSEPORT` 多 acceptor {#sec-a.2.8}

**目标**：`ss -ltnp` 显示 N 个进程各自监听同一端口；`wrk` 下连接在 N 个进程间大致均匀分布。

```bash
ss -ltnp 'sport = :8080'
# LISTEN 0 4096 0.0.0.0:8080 users:(("myhttpd",pid=...),("myhttpd",pid=...))
```

**关键概念**：`SO_REUSEPORT` 让多个 socket 绑定同一四元组，内核按**四元组哈希**把新连接分给其中一个监听者，因此分发在连接级别、不需要用户态 acceptor。所有 socket 必须同一 euid、同一协议；内核 3.9+ 支持。缺点是负载可能不均（连接少时尤其明显），可用 `SO_ATTACH_REUSEPORT_EBPF` 自定义分发。

```c
/* src/listen.c — 每个进程都执行一次；关键是 bind 之前设选项 */
int listen_reuseport(int port)
{
    int fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC | SOCK_NONBLOCK, 0);
    int one = 1;
    if (fd == -1)
        return -1;
    setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);
    if (setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &one, sizeof one) == -1)
        return -1;                        /* 老内核返回 ENOPROTOOPT */
    struct sockaddr_in sa = { .sin_family = AF_INET,
                              .sin_addr.s_addr = htonl(INADDR_ANY),
                              .sin_port = htons((uint16_t)port) };
    if (bind(fd, (struct sockaddr *)&sa, sizeof sa) == -1 || listen(fd, 4096) == -1)
        return -1;
    return fd;
}
```

**常见错误**：在 `bind` 之后才设 `SO_REUSEPORT`（无效）；父子进程继承同一个监听 fd（变成共享 accept，不是多 acceptor）；N 个进程但只有一个 `epoll`（回到起点）。**下一步**：Stage 6 把「感觉快了」变成「有基线、有梯度、有 P99」的报告。

### A.2.9 Stage 6 · 压测与调优 {#sec-a.2.9}

**目标**：一份能复现的报告：环境、方法、并发梯度、RPS、P50/P99、错误率、CPU。

```bash
# 预热 15 s 不计入；正式每档 60 s，重复 3 次取中位数
wrk -t4 -c100  -d60s --latency http://127.0.0.1:8080/hello.txt
wrk -t4 -c1000 -d60s --latency http://127.0.0.1:8080/hello.txt
wrk -t4 -c5000 -d60s --latency http://127.0.0.1:8080/hello.txt

# 瓶颈证据
pidstat -p $(pgrep -n myhttpd) 1
perf top -p $(pgrep -n myhttpd)
strace -c -f -p $(pgrep -n myhttpd)
```

报告模板（数字按你的机器填，**不要抄示例**）：

| 并发 | RPS | P50 | P99 | 错误率 | CPU% | fd |
|--:|--:|--:|--:|--:|--:|--:|
| 100 | — | — | — | 0 | — | — |
| 1000 | — | — | — | — | — | — |
| 5000 | — | — | — | — | — | — |

调优先动这五个旋钮，每改一个都要重跑同一档：`net.core.somaxconn`、`net.ipv4.tcp_max_syn_backlog`、`ulimit -n`、`SO_REUSEPORT` 的进程数、绑核（`taskset`）。**改内核参数前记录原值**，报告里附 `sysctl -a | grep ...` 的差异。**下一步**：Stage 7 让服务自己说出这些数字。

### A.2.10 Stage 7 · 日志与指标 {#sec-a.2.10}

**目标**：`curl /metrics` 返回 Prometheus 文本；每条访问日志一行 JSON，能按状态码与耗时过滤。

```bash
curl -s http://127.0.0.1:8080/metrics | grep -E 'requests_total|duration_seconds_bucket' | head -4
# myhttpd_requests_total 42
# myhttpd_request_duration_seconds_bucket{le="0.001"} 30
# myhttpd_request_duration_seconds_bucket{le="0.005"} 41
```

**关键概念**：计数器用 `atomic_fetch_add`，直方图用**固定桶 + 每桶计数**，渲染时累加成 `le` 语义；日志用 `writev` 或后台线程，不能在事件循环里 `fprintf` 到慢磁盘。指标要能回答三个问题：现在多少 QPS、P99 多少、错误率多少。

```c
/* src/metrics.c — 记录一次请求；桶上界单位微秒，渲染时再累加 */
void metrics_observe(struct metrics *m, uint64_t us)
{
    static const uint64_t bounds[] = { 100, 250, 500, 1000, 2500, 5000,
                                       10000, 25000, 50000, 100000, 250000, 500000 };
    atomic_fetch_add_explicit(&m->duration_count, 1, memory_order_relaxed);
    atomic_fetch_add_explicit(&m->duration_sum_us, us, memory_order_relaxed);
    for (size_t i = 0; i < sizeof bounds / sizeof bounds[0]; i++) {
        if (us <= bounds[i]) {
            atomic_fetch_add_explicit(&m->duration_buckets[i], 1, memory_order_relaxed);
            return;
        }
    }
}
```

这份 `observe` 与配套的 `metrics_render` 已在本机通过单元测试（含小缓冲区截断）；完整渲染函数见仓库的 `src/metrics.c`，输出格式与 [工程手册](engineering.md) 的示例一致。

**常见错误**：把 `Content-Type` 写成 `text/plain`（Prometheus 要求 `text/plain; version=0.0.4`）；桶边界不是单调递增；`/metrics` 请求本身也被计入业务 QPS，形成自激。**下一步**：Stage 8 用脚本把这八件事一次验收。

### A.2.11 Stage 8 · 验收与复盘 {#sec-a.2.11}

**验收清单**（每条都要有输出，不接受「应该可以」）：

| 检查 | 命令 | 通过标准 |
|:--|:--|:--|
| 单元测试 | `make test` | 解析器 12 例全过 |
| 集成 | `curl` 200/404/403/431 | 四个状态码各一次 |
| 慢客户端 | `nc` 只发半行，等 6 s | 连接被服务端关闭，无 fd 泄漏 |
| fd 耗尽 | `ulimit -n 64` 后压测 | `accept4` 失败被记录，进程不崩 |
| keep-alive | 100 个请求一条连接 | 全 200，`ss` 无残留 |
| 压测 | Stage 6 报告 | 三档、P99、错误率齐全 |
| sanitizer | `make asan && make test` | 零报告 |
| 优雅关闭 | `kill -TERM` | 10 s 内退出，存量请求完成 |

**复盘三问**：最初假设「单 acceptor 够用」是否被 `perf` 证伪？最难的 bug 是 `EPOLLHUP` 漏关 fd 还是解析器的 off-by-two？如果重做，会不会先写压测脚本再写业务？

## A.3 eBPF 可观测性 `mybpf` {#sec-a.3}

### A.3.1 目标与真实对应物 {#sec-a.3.1}

`mybpf` 对应 bpftrace/Pixie 的最小闭环：**用 bpftrace 在一小时内得到答案，再用 libbpf 把它变成常驻指标**。前者是原型工具，后者是产品形态；两者的分界线是「要不要把程序分发给别人、要不要控制开销」。

我们追踪两件事：`openat` 的调用者与频率（文件 I/O 的形状），以及 TCP 状态迁移（连接是被拒绝、重置还是正常关闭）。这两个探针正好覆盖 kprobe 与 tracepoint 两类挂载点。

### A.3.2 架构：从一行命令到常驻进程 {#sec-a.3.2}

```text
bpftrace 原型                libbpf 常驻
─────────────                ─────────────
一行 -e 表达式         →     .bpf.c 编译成 .bpf.o
内核 verifier 校验           用户态 open/load/attach
map 聚合 + 定时打印     →     map 轮询 + Prometheus 文本
Ctrl-C 结束                   systemd 常驻 + 指标文件
```

三个阶段的分工：Stage 0–2 用 bpftrace 确认「探针挂得上、字段读得到」；Stage 3 理解 map 聚合与 `bpf()` 系统调用；Stage 4 换成 libbpf；Stage 5 把 map 导出成 Prometheus 能抓的文本。

### A.3.3 Stage 0 · bpftrace 原型：先问出答案 {#sec-a.3.3}

**目标**：三条一行命令在 5 分钟内给出可解释的数字。

```bash
# 需要 root（未实测）
sudo bpftrace -e 'kprobe:do_sys_openat2 { @[comm] = count(); }'
# Ctrl-C 后打印，按进程名分组的 openat 次数
sudo bpftrace -e 'tracepoint:syscalls:sys_enter_openat { @files[str(args->filename)] = count(); } interval:s:5 { print(@files); clear(@files); }'
sudo bpftrace -e 'kprobe:tcp_rcv_established { @[comm] = hist(args->skb->len); }'
```

**关键概念**：bpftrace 把脚本编译成 BPF 字节码，挂到 kprobe/tracepoint 上；`@` 是 map，`count()`/`hist()` 是聚合函数。第一行按 `comm`（进程名，15 字节）分组，能立刻回答「谁在疯狂打开文件」；第二行按文件名分组，能回答「打开的是不是同一批文件」——两者结合才能区分「每次请求都 open」与「某个后台进程在扫盘」。**下一步**：把命令固化成脚本，加过滤条件。

### A.3.4 Stage 1 · kprobe：追踪 `openat` {#sec-a.3.4}

**目标**：只统计目标进程的 `openat`，并打印前 5 个路径。

```bash
# 需要 root（未实测）
sudo bpftrace bpf/openat.bt -c './build/myhttpd 8080' &
curl -s http://127.0.0.1:8080/hello.txt >/dev/null
# @count: 37
# /srv/www/hello.txt   12
```

```text
// bpf/openat.bt — 参数过滤 + 路径采样（bpftrace 语法）
kprobe:do_sys_openat2
/pid == $1/
{
    @count = count();
    @path[str(args->filename)] = count();
}
interval:s:5 { print(@count); print(@path); clear(@path); }
```

**关键概念**：`openat(2)` 在 6.x 内核里进入 `do_sys_openat2`，真正的路径参数是第二个参数（`args->filename`），第一个是 `dfd`；`args->filename` 可能为 `NULL`（`O_TMPFILE` 路径），`str()` 会返回空串而不是崩溃。用 `pid == $1` 过滤比 `comm == "myhttpd"` 更准，因为进程名会被截断到 15 字节。**下一步**：kprobe 依赖内核符号名，换内核版本可能失效；改用稳定的 tracepoint。

### A.3.5 Stage 2 · tracepoint：稳定的挂载点 {#sec-a.3.5}

**目标**：用 `syscalls:sys_enter_openat` 与 `sock:inet_sock_set_state` 得到同样的问题答案，且换内核不用改脚本。

```bash
# 需要 root（未实测）
sudo bpftrace -l 'tracepoint:sock:*' | head
sudo bpftrace -e 'tracepoint:sock:inet_sock_set_state
  /args->newstate == 7/ { @[comm] = count(); }'   # 7 = TCP_CLOSE
```

**关键概念**：tracepoint 是内核**显式埋点**，参数布局由 `format` 文件固定，属于稳定 ABI；kprobe 挂的是函数地址/符号，内核改个内联或改名就失效。`/sys/kernel/tracing/events/<cat>/<name>/format` 能看到每个字段的偏移与类型，bpftrace 的 `args->` 就是照着它生成的。代价是 tracepoint 只覆盖内核作者埋过的点。**下一步**：把多次采样聚合起来，理解 map 的生命周期。

### A.3.6 Stage 3 · map 聚合与 `bpf()` 系统调用 {#sec-a.3.6}

**目标**：不写 BPF 程序，只用 `bpf()` 建一个 hash map、写入、读出，理解「map 是内核里的对象，用户态拿 fd 访问」。

```bash
sudo ./build/mapdemo
# map fd = 4, lookup: key=hello value=42
```

```c
/* src/mapdemo.c — 直接调 bpf(2)：建 map / 更新 / 查找 */
#include <linux/bpf.h>
#include <stdio.h>
#include <string.h>
#include <sys/syscall.h>
#include <unistd.h>

static int bpf(int cmd, union bpf_attr *attr)
{
    return (int)syscall(SYS_bpf, cmd, attr, sizeof *attr);
}

int main(void)
{
    union bpf_attr attr = {0};
    attr.map_type = BPF_MAP_TYPE_HASH;
    attr.key_size = 8;
    attr.value_size = 8;
    attr.max_entries = 1024;
    int fd = bpf(BPF_MAP_CREATE, &attr);
    if (fd == -1) { perror("BPF_MAP_CREATE"); return 1; }

    char key[8] = "hello";
    unsigned long long val = 42, out = 0;
    memset(&attr, 0, sizeof attr);
    attr.map_fd = (unsigned)fd;
    attr.key = (unsigned long)key;
    attr.value = (unsigned long)&val;
    if (bpf(BPF_MAP_UPDATE_ELEM, &attr) == -1) { perror("update"); return 1; }

    attr.value = (unsigned long)&out;
    if (bpf(BPF_MAP_LOOKUP_ELEM, &attr) == -1) { perror("lookup"); return 1; }
    printf("map fd = %d, key=%s value=%llu\n", fd, key, out);
    close(fd);
    return 0;
}
```

**关键概念**：`union bpf_attr` 的字段按 `cmd` 复用，必须 `memset` 清零；`BPF_MAP_CREATE` 返回的是**文件描述符**，进程退出才释放；verifier 只在 `BPF_PROG_LOAD` 时介入，纯 map 操作不需要它。**下一步**：把「建 map」的代码换成「加载一个真正的程序」。

### A.3.7 Stage 4 · libbpf：把探针做成程序 {#sec-a.3.7}

**目标**：`clang -target bpf` 编译一个统计 `openat` 的 BPF 程序，libbpf 负责加载、挂载、读 map。

```bash
sudo apt install -y libbpf-dev clang llvm
make -C bpf && sudo ./build/mybpf
# comm=myhttpd openat=1204
```

**代码**：BPF 侧（`bpf/openat.bpf.c`）与用户态加载器。

```c
/* bpf/openat.bpf.c — 按 comm 统计 openat 次数 */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1024);
    __type(key, char[16]);
    __type(value, __u64);
} counts SEC(".maps");

SEC("kprobe/do_sys_openat2")
int count_openat(struct pt_regs *ctx)
{
    char comm[16] = {0};
    bpf_get_current_comm(comm, sizeof comm);
    __u64 *v = bpf_map_lookup_elem(&counts, comm);
    if (v != NULL)
        __sync_fetch_and_add(v, 1);
    else {
        __u64 one = 1;
        bpf_map_update_elem(&counts, comm, &one, BPF_NOEXIST);
    }
    return 0;
}

char LICENSE[] SEC("license") = "GPL";
```

```c
/* src/mybpf.c — 加载、挂载、每秒读一次 map */
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <signal.h>
#include <stdio.h>
#include <unistd.h>

static volatile sig_atomic_t stop;

static void on_signal(int sig) { (void)sig; stop = 1; }

int main(void)
{
    struct bpf_object *obj = bpf_object__open_file("bpf/openat.bpf.o", NULL);
    if (libbpf_get_error(obj)) {
        fprintf(stderr, "open: %s\n", strerror(errno));
        return 1;
    }
    if (bpf_object__load(obj) != 0) {
        fprintf(stderr, "load 失败，检查 verifier 日志与 CAP_BPF\n");
        return 1;
    }
    struct bpf_program *prog = bpf_object__find_program_by_name(obj, "count_openat");
    struct bpf_link *link = bpf_program__attach_kprobe(prog, false, "do_sys_openat2");
    if (libbpf_get_error(link)) {
        fprintf(stderr, "attach 失败（内核符号不存在？）\n");
        return 1;
    }
    struct bpf_map *map = bpf_object__find_map_by_name(obj, "counts");
    int map_fd = bpf_map__fd(map);

    signal(SIGINT, on_signal);
    signal(SIGTERM, on_signal);
    while (!stop) {
        sleep(1);
        char key[16], next[16];
        unsigned long long val;
        int cur = 0;
        while (bpf_map_get_next_key(map_fd, cur ? &key : NULL, &next) == 0) {
            if (bpf_map_lookup_elem(map_fd, &next, &val) == 0)
                printf("comm=%-15s openat=%llu\n", next, val);
            memcpy(key, next, sizeof key);
            cur = 1;
        }
    }
    bpf_link__destroy(link);
    bpf_object__close(obj);
    return 0;
}
```

**常见错误**：`bpf_object__load` 返回 `-EPERM`（缺 `CAP_BPF`/`CAP_SYS_ADMIN`，或内核 `unprivileged_bpf_disabled=2`）；attach 失败（`do_sys_openat2` 被内联或不存在，换 `do_sys_open`）；忘记 `-g` 编译导致 BTF 缺失；map 满后 `update` 返回 `E2BIG`（`max_entries` 按 comm 数量估算）。**下一步**：把 `printf` 换成 Prometheus 文本。

### A.3.8 Stage 5 · 导出 Prometheus {#sec-a.3.8}

**目标**：`mybpf` 每秒把 map 写成 `/var/lib/node_exporter/textfile/myopenat.prom`，Prometheus 直接抓取；或由 `myhttpd` 的 `/metrics` 提供。

```text
# HELP myopenat_total openat calls by comm
# TYPE myopenat_total counter
myopenat_total{comm="myhttpd"} 1204
myopenat_total{comm="sshd"} 12
```

**关键概念**：文本文件收集器（textfile collector）是最省事的集成方式：原子写（临时文件 + `rename`），格式符合 exposition format，Prometheus 每 15 秒抓一次。指标名带单位、标签基数可控（`comm` 最多几十个；不要把路径当标签）。

```c
/* src/export.c — 原子写：同目录临时文件 + rename，读者永远看不到半个文件 */
int write_prom(const char *path, const struct sample *s, size_t n)
{
    char tmp[256];
    snprintf(tmp, sizeof tmp, "%s.tmp", path);
    FILE *f = fopen(tmp, "w");
    if (f == NULL)
        return -1;
    fputs("# HELP myopenat_total openat calls by comm\n"
          "# TYPE myopenat_total counter\n", f);
    for (size_t i = 0; i < n; i++)
        fprintf(f, "myopenat_total{comm=\"%s\"} %llu\n", s[i].comm, s[i].count);
    if (fclose(f) != 0)
        return -1;
    return rename(tmp, path);
}
```

**验证**：`curl -s localhost:9100/metrics | grep myopenat`（node_exporter 已开 textfile collector）；`promtool check metrics < file.prom` 检查格式。**常见错误**：标签值没转义引号/反斜杠；直接覆盖写导致抓取到空文件；指标名重复注册。**下一步**：Stage 6 验收，并测量探针开销。

### A.3.9 Stage 6 · 验收：正确性、开销与边界 {#sec-a.3.9}

| 检查 | 方法 | 通过标准 |
|:--|:--|:--|
| 探针生效 | `bpftrace -l 'kprobe:do_sys_openat2'` | 能列出 |
| 计数正确 | 对比 `strace -c -e openat` 与 map | 数量级一致（过滤条件相同） |
| 开销 | 开/关探针各压测 60 s | RPS 下降 < 5%，P99 上升 < 10% |
| 无权限 | 非 root 运行加载器 | `EPERM`，有清晰提示，不崩溃 |
| verifier 拒绝 | 故意写越界访问 | 加载失败并打印 verifier 日志 |
| map 满 | `max_entries=1` 压测 | `update` 失败被计数，不丢已有键 |

**复盘**：最难的是 verifier 的「证明」而不是语法——它要求你能证明每个指针都可解引用；开销主要来自每事件一次的 map 查找，用 `per-CPU` map 可以去掉原子操作与缓存行争用。

## A.4 三条线拼成一个演示 {#sec-a.4}

**目标**：一条 `demo.sh` 起容器、跑 `myhttpd`、压测、用 `mybpf` 观测，最后打印一张三方对照表。

```bash
# 需要 root（未实测）
sudo ./demo.sh
# container up: pid=... cgroup=/sys/fs/cgroup/mycontainer/...
# http: 200, rps=..., p99=...
# openat/s ≈ 2 × rps        ← 每个请求两次 open：静态文件 + 日志
# memory.current = ... MiB (limit 128 MiB)
# cpu.stat: nr_throttled=...
```

演示脚本的关键步骤：

1. 用 `docker export` 或 `busybox-static` 准备 rootfs，把 `myhttpd` 静态编译后放进去；
2. `mycontainer run --memory 128M --cpu 50 --ip 10.88.0.2 --init -- /bin/myhttpd 8080`；
3. 宿主 `wrk -t4 -c200 -d30s http://10.88.0.2:8080/hello.txt`；
4. 同时跑 `mybpf`，按 `comm=myhttpd` 过滤；
5. 采集 `memory.current`、`cpu.stat`、`/metrics` 的 P99，打印一张表。

**第一次跑，三者对不上是正常的**。典型现象与解释：

| 现象 | 证据 | 解释 |
|:--|:--|:--|
| RPS 只有宿主的一半 | `cpu.stat` 的 `nr_throttled` 持续增长 | `--cpu 50` 真的限住了，不是 bug |
| P99 抖动、openat 速率不高 | `mybpf` 显示 `openat` 集中在少数路径 | overlayfs 首次 copy-up，第二次就命中 upper |
| 连接被重置 | `sock:inet_sock_set_state` 出现 `TCP_CLOSE` 突增 | `pids.max` 或 `memory.max` 触顶，init 退出 |

这张表就是「三件套」的意义：单看 `wrk` 的数字，你只知道慢；加上 cgroup 文件与 eBPF，才知道慢在哪一层。

**清理**（顺序不能反）：

```bash
sudo pkill -f mybpf || true
sudo ./build/mycontainer kill <id> 2>/dev/null || true
sudo ip link del mc-br0 2>/dev/null || true
sudo iptables -t nat -D POSTROUTING -s 10.88.0.0/24 ! -o mc-br0 -j MASQUERADE 2>/dev/null || true
sudo umount -R /run/mycontainer 2>/dev/null || true
sudo rm -rf /run/mycontainer
```

## A.5 验收清单 {#sec-a.5}

按 [项目总览](overview.md) 的六维 12 分制自评。三条线的最低通过线：

- [ ] `mycontainer`：Stage 0–7 全过，六项验收脚本全绿，OOM 与 `pids.max` 各有一次真实触发记录；
- [ ] `myhttpd`：解析器单测 + 三个状态码 + 1000 连接 keep-alive；压测报告含三档并发、P50/P99、错误率、CPU；
- [ ] `mybpf`：kprobe 与 tracepoint 各一个探针，map 聚合正确，Prometheus 文本通过 `promtool check metrics`；
- [ ] 三条线各有 `README.md`（10 分钟能跑起来）、`docs/retro.md`（四问）、`git tag stage-*` 链；
- [ ] ASan/UBSan 零报告；并发部分补 TSan；
- [ ] `demo.sh` 一条命令跑通，输出的三方对照表能解释至少一个反常现象。

## A.6 延伸与母本对应 {#sec-a.6}

**延伸方向**（按投入从低到高）：

| 方向 | 起点 | 要补的东西 |
|:--|:--|:--|
| user namespace 默认开启 | A.1 Stage 2 | `newuidmap`/`newgidmap`、`/etc/subuid`，见 [5.2.6](../part5/ch02.md#sec-5.2.6) |
| `clone3` + `CLONE_INTO_CGROUP` | A.1 Stage 1 | `struct clone_args`，消除 attach 窗口 |
| io_uring 版本 | A.2 Stage 3 | `io_uring_setup`、SQE/CQE、固定缓冲区 |
| XDP 丢包观测 | A.3 Stage 2 | `xdp:` 程序、`bpf_link`、驱动支持 |
| Kubernetes CRI | 全部 | CRI 接口、镜像仓库、CNI 插件；这一步开始「不是一个人写的」 |

**母本对应**：

| 母本 | 章节 | 本书落点 | 程度 |
|:--|:--|:--|:--|
| K | 第 28 章（`clone`）、第 39 章（capabilities） | A.1.4、A.1.10 | 完整 |
| K | 第 56–61 章（socket、epoll、TCP） | A.2.3–A.2.8 | 完整（API 层） |
| R | 第 2 章（内存回收）、第 3 章（进程创建） | A.1.5、A.1.9 | 背景（OOM 与 task 生命周期） |
| R | 第 5 章（中断/软中断）、第 6 章（ftrace） | A.3.1–A.3.5 | 精选（探针挂载点） |
| N | 第 3 章（epoll 协作）、第 10 章（容器网络） | A.1.8、A.2.4 | 完整（veth/bridge、事件通知） |
| O | 第 33 章（基于事件的并发）、第 39 章（文件与目录） | A.2.2–A.2.5 | 背景 |
| C | 第 8–11 章（异常、虚拟内存、I/O、网络） | A.1.4、A.2.3 | 背景（系统调用与内存模型） |
| OCI | runtime-spec `config.json` | A.1.7 | 精选（字段子集） |
| libbpf | `bpf-helpers(7)`、libbpf API 文档 | A.3.4–A.3.8 | 精选（加载与 map） |

> **下一站**：如果你更关心存储一致性，去做 [项目 B](pb.md)；想继续在网络栈里往下挖，[项目 C](pc.md) 的用户态 TCP 会把 A.2 的 epoll 用到极限。
