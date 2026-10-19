# 项目 B · 存储主线：Redis 复现 · B+ 树/WAL 引擎

<div class="chapter-index">
<div><span class="ci-label">项目目标</span><p>用 C17 写两个能跑、能压、能崩的存储系统：<code>myredis</code> 复现内存 KV 的协议、数据结构、持久化与主从复制；<code>mydb</code> 实现 4 KiB 页式 B+ 树、buffer pool、WAL、崩溃恢复与最小 SQL。两条线共用「页、日志、恢复」这套存储语言。</p></div>
<div><span class="ci-label">完成后你能</span><p>独立实现 RESP 解析器与事件循环；解释并实现 RDB/AOF 的取舍；写出可用的 B+ 树分裂/借位/合并；设计 WAL 记录与组提交；用 <code>kill -9</code> 验证崩溃一致性；用 <code>redis-benchmark</code>、<code>fio</code>、<code>perf</code> 给出有基线的性能报告。</p></div>
</div>

存储系统是操作系统知识最密集的用户态程序：它同时使用文件 I/O、内存映射、页缓存、锁、信号、进程与网络。你在这个项目里写下的每一个 bug，几乎都能在正文里找到对应的机制：短写没处理，对应 [2.2.3](../part2/ch02.md#sec-2.2.3)；`fsync` 漏了目录，对应 [2.3.7](../part2/ch03.md#sec-2.3.7)；buffer pool 刷脏页先于日志落盘，对应 WAL 的 write-ahead 规则；`fork` 快照与 COW，对应进程地址空间的页表复制。

本章选两个真实对应物：**Redis** 与 **SQLite/LevelDB**。前者把「内存数据结构 + 单线程事件循环 + 可选的持久化」做到极致；后者把「磁盘页 + 缓冲池 + 日志 + 崩溃恢复」做到极致。它们的共同问题是：**在一次崩溃之后，怎么让用户相信刚才那条写成功了**。Redis 用 RDB/AOF 回答，SQLite 用 WAL 回答；两条路线的答案不同，但都要面对顺序、原子性与持久性。

> 阅读方式：B.0 先建立两条线的地图；B.1、B.2 按 Stage 做，每个 Stage 都有可验收命令。不要一次读完再做——做完 Stage N 的验收，再开 Stage N+1。

## B.0 总览：内存 KV 与磁盘页式存储

### B.0.1 两个系统，一套存储问题

| 维度 | `myredis`（B.1） | `mydb`（B.2） |
|:--|:--|:--|
| 真实对应物 | Redis 7.x | SQLite（B+ 树 + WAL）、LevelDB（LSM，仅对照） |
| 数据位置 | 内存为主，磁盘只做恢复 | 磁盘为主，内存做页缓存 |
| 寻址单位 | key（任意字节串） | 4 KiB 页 + B+ 树节点 |
| 写路径 | 改内存 → 追加 AOF / fork 快照 | 改页 → 写 WAL → 刷脏页 |
| 崩溃恢复 | 重放 AOF / 加载 RDB | 分析 WAL → redo → undo |
| 并发模型 | 单线程事件循环 | 单写线程 + 读写锁（教学版） |
| 核心难点 | 协议、过期、复制积压 | 分裂/合并、WAL 顺序、undo |

<pre class="layout">
 myredis：epoll → RESP → 命令表 → dict/expire → RDB/AOF/复制
 mydb   ：SQL → B+ 树 → buffer pool → WAL → pager
 共同问题：崩溃之后，刚才那条写还在不在？
</pre>

读图：`myredis` 把持久化当作旁路，`mydb` 把持久化当作主路径。这决定了两个项目的验收方式不同：`myredis` 用「重启后 key 还在吗、AOF 重放是否幂等」验收；`mydb` 用「`kill -9` 后 redo/undo 是否把页恢复到一致状态」验收。

### B.0.2 前置章节与回看时机

| 项目 | 必读 | 卡住时回看 |
|:--|:--|:--|
| `myredis` | [2.1](../part2/ch01.md#sec-2.1.3)（返回值/`errno`）、[2.2](../part2/ch02.md#sec-2.2.3)（短读短写）、[2.12](../part2/ch12.md#sec-2.12.1)（线程模型）、[2.14](../part2/ch14.md#sec-2.14.1)（管道与阻塞语义） | 连接挂死回看 2.2.3 的 `EAGAIN`；`fork` 与 fd 继承回看 2.7（待发布）；锁顺序回看 [2.13](../part2/ch13.md#sec-2.13.6) |
| `mydb` | [2.2](../part2/ch02.md#sec-2.2.2)（`open`/`O_DIRECT`）、[2.3](../part2/ch03.md#sec-2.3.4)（`mmap`）、[2.3.7](../part2/ch03.md#sec-2.3.7)（`fsync`+`rename`）、[2.3.6](../part2/ch03.md#sec-2.3.6)（文件锁） | 页刷不出去回看 2.2.8 页缓存；`fsync` 语义回看 2.3.7；并发回看 2.13 |

epoll 的内核侧（`ep_poll_callback`、就绪队列）在 2.18 与 4.10，B+ 树的文件系统对照在 3.12–3.13。这两处正文尚未发布时，先按本章的接口说明做，不要停下来等。

### B.0.3 难度、投入与裁剪

| 子项目 | 难度 | 预计投入 | 最小可交付 | 可以裁剪 |
|:--|:--|:--|:--|:--|
| `myredis` | ★★★★★ | 40–60 h | RESP + GET/SET/EXPIRE + AOF + 主从 | zset 有序数组；复制只做全量 |
| `mydb` | ★★★★★ | 40–60 h | B+ 树 + WAL + redo/undo + 单表 SQL | 事务用单写锁；SQL 不做 JOIN |

建议顺序：**B.1 Stage 0→2 先打通「网络 → 协议 → 命令」**，再回头做 B.2 Stage 0→3 打通「页 → 缓存 → 树」，然后两条线各自补持久化。这样你在做 RDB/WAL 时，已经有一个能演示的前台。

可裁剪点只有三处：zset 用有序数组、复制只做全量、SQL 只做单表。**RESP 解析、B+ 树分裂、WAL 恢复不能裁**——它们是这两个项目的骨架。

### B.0.4 代码目录与构建基线

两个项目都放在仓库外（或 `linux/code/`），构建模板用[工程手册](engineering.md)第 2 节那份 Makefile。目录约定：

```text
myredis/{Makefile,include/{resp,dict,obj,db,persist}.h,
         src/{main,event,resp,dict,obj,db,expire,rdb,aof,repl}.c,
         tests/{test_resp,test_dict}.c,tests/run.sh,bench/}
mydb/   {Makefile,include/{pager,bufpool,btree,wal,txn,sql}.h,
         src/{main,pager,bufpool,btree,wal,recovery,txn,sql}.c,
         tests/{test_btree,test_wal,test_bp}.c,bench/{crash.sh,report.md}}
```

证据标签沿用全书约定：`实测` 表示作者用 ASan/UBSan 跑过；`未实测` 表示只给命令与模板，数字要你自己填。本章所有性能数字都标 `未实测`——你的机器、内核、文件系统不同，抄数字没有意义。

## B.1 `myredis`：从 epoll 到主从复制

### B.1.1 目标与真实对应物

`myredis` 是一个 RESP2 兼容的单线程 KV 服务器。它不追求与 Redis 完全兼容，而是把 Redis 的**主路径**复现一遍：

| 阶段 | 交付 | 对应 Redis 机制 |
|:--|:--|:--|
| 0 | epoll + 非阻塞 accept | `ae` 事件循环、`acceptTcpHandler` |
| 1 | RESP 解析/编码 | `networking.c` 的协议层 |
| 2 | 命令表 + 5 个命令 | `server.c` 的 `commandTable` |
| 3 | dict/list/hash/zset | `t_hash.c`、`t_zset.c`、`dict.c` |
| 4 | 惰性 + 定期过期 | `expire.c`、`activeExpireCycle` |
| 5 | RDB 快照 | `rdb.c`、`fork` + COW |
| 6 | AOF 与重写 | `aof.c`、`appendfsync` |
| 7 | 全量 + 增量复制 | `replication.c`、backlog |
| 8 | 压测与剖析 | `redis-benchmark`、`perf` |

最终验收命令：

```text
$ make -C myredis test
test_resp: ok
test_dict: ok
$ ./myredis --port 6379 &
$ redis-cli -p 6379 SET user:1 alice
OK
$ redis-cli -p 6379 GET user:1
"alice"
$ redis-benchmark -p 6379 -t set,get -n 100000 -c 50 -q
SET: 91240.88 requests per second
GET: 94876.66 requests per second
```

上面的 benchmark 数字是**报告格式示例，未实测**；你的结果可能差一个数量级，原因见 Stage 8。

### B.1.2 架构与模块

<pre class="layout">
 main.c ──▶ event.c ──▶ 可读事件 ──▶ db.c:process_input()
                                  │
                                  ├─▶ resp.c:resp_parse()      解析
                                  ├─▶ db.c:dispatch()          查命令表
                                  │      ├─▶ t_string.c        GET/SET/INCR
                                  │      ├─▶ t_list.c          LPUSH/LRANGE
                                  │      ├─▶ t_hash.c          HSET/HGET
                                  │      └─▶ t_zset.c          ZADD/ZRANGE
                                  ├─▶ expire.c                 惰性/定期过期
                                  ├─▶ aof.c:feed()             写后追加
                                  └─▶ repl.c:feed()            传播给从库
</pre>

三个纪律，从第一行代码就要守住：

1. **单线程主循环内不做阻塞 I/O**。RDB 的 `fork` 与 AOF 的 `fsync` 是仅有的例外，前者在子进程，后者用 `fdatasync` 且受 `appendfsync` 控制。
2. **所有 fd 非阻塞**，所有读写处理 `EINTR`/`EAGAIN`/短写；输出必须有用户态缓冲。
3. **命令执行只改内存**，持久化是「写后通知」：先执行，再 `aof_feed`，最后 `repl_feed`。顺序反了，从库或 AOF 会记录一条没有生效的写。

### B.1.3 Stage 0：epoll 事件循环与非阻塞 accept

**目标**：服务器能接受并发连接、回显字节、在客户端断开时清理 fd；不因为一个慢客户端阻塞其他连接。

```text
$ make
$ ./build/myredis 6379 &
$ printf 'hello\n' | nc -q1 127.0.0.1 6379
hello
```

**关键概念**：水平触发（LT）下，只要 fd 还有数据，`epoll_wait` 会再次报告；因此每次可读都要**循环读到 `EAGAIN`**，否则一个连接的大量数据会反复触发。`accept4` 的 `SOCK_NONBLOCK|SOCK_CLOEXEC` 把两个 `fcntl` 合并进 accept，避免「先 accept 再设置」期间被 `fork+exec` 继承。[2.2.3](../part2/ch02.md#sec-2.2.3) 的短读/短写规则在这里全部适用。

**代码**（`src/event.c` 与 `src/main.c` 的核心，可单独编译运行）：

```c
/* stage0.c — 编译：cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 stage0.c
 * 本阶段只验证 accept + 事件循环：读到数据就原样写回一次。可靠的非阻塞
 * 输出缓冲（EPOLLOUT + 短写续传）在 Stage 1 接入协议层时再加。 */
#define _GNU_SOURCE
#include <errno.h>
#include <fcntl.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/epoll.h>
#include <sys/socket.h>
#include <unistd.h>

#define MAX_CONN 1024
static int g_fd[MAX_CONN];

static int set_nonblock(int fd)
{
    int f = fcntl(fd, F_GETFL);
    return f < 0 ? -1 : fcntl(fd, F_SETFL, f | O_NONBLOCK);
}

static int ep_add(int ep, int fd)
{
    struct epoll_event ev = { .events = EPOLLIN | EPOLLRDHUP, .data.fd = fd };
    return epoll_ctl(ep, EPOLL_CTL_ADD, fd, &ev);
}

/* 返回 1 关闭连接，0 继续，-1 错误。 */
static int on_read(int fd)
{
    char buf[4096];
    for (;;) {
        ssize_t n = read(fd, buf, sizeof buf);
        if (n == 0) return 1;
        if (n < 0) {
            if (errno == EINTR) continue;
            if (errno == EAGAIN || errno == EWOULDBLOCK) return 0;
            return -1;
        }
        size_t off = 0;
        while (off < (size_t)n) {          /* 短写要续写；EAGAIN 先关连接 */
            ssize_t w = write(fd, buf + off, (size_t)n - off);
            if (w > 0) off += (size_t)w;
            else if (w == -1 && errno == EINTR) continue;
            else return -1;
        }
    }
}

int main(int argc, char **argv)
{
    int port = argc > 1 ? atoi(argv[1]) : 6379;
    int lfd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
    if (lfd < 0) { perror("socket"); return 1; }
    int one = 1;
    if (setsockopt(lfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one) < 0) {
        perror("setsockopt"); close(lfd); return 1;
    }
    struct sockaddr_in addr = {
        .sin_family = AF_INET, .sin_port = htons((uint16_t)port),
        .sin_addr = { .s_addr = htonl(INADDR_LOOPBACK) },
    };
    if (bind(lfd, (struct sockaddr *)&addr, sizeof addr) < 0 ||
        listen(lfd, 128) < 0 || set_nonblock(lfd) < 0) {
        perror("bind/listen/fcntl"); close(lfd); return 1;
    }
    int ep = epoll_create1(EPOLL_CLOEXEC);
    if (ep < 0 || ep_add(ep, lfd) < 0) { perror("epoll"); close(lfd); return 1; }
    for (size_t i = 0; i < MAX_CONN; i++) g_fd[i] = -1;

    for (;;) {
        struct epoll_event evs[64];
        int n = epoll_wait(ep, evs, 64, -1);
        if (n < 0) {
            if (errno == EINTR) continue;
            perror("epoll_wait"); break;
        }
        for (int i = 0; i < n; i++) {
            int fd = evs[i].data.fd;
            if (fd == lfd) {
                for (;;) {
                    int cfd = accept4(lfd, NULL, NULL, SOCK_NONBLOCK | SOCK_CLOEXEC);
                    if (cfd < 0) {
                        if (errno == EINTR) continue;
                        if (errno == EAGAIN || errno == EWOULDBLOCK) break;
                        perror("accept4"); break;
                    }
                    if (cfd >= MAX_CONN) { close(cfd); continue; }
                    g_fd[cfd] = cfd;
                    if (ep_add(ep, cfd) < 0) { close(cfd); g_fd[cfd] = -1; }
                }
                continue;
            }
            if (evs[i].events & (EPOLLERR | EPOLLHUP)) {
                epoll_ctl(ep, EPOLL_CTL_DEL, fd, NULL);
                close(fd); g_fd[fd] = -1;
                continue;
            }
            if ((evs[i].events & (EPOLLIN | EPOLLRDHUP)) && on_read(fd) != 0) {
                epoll_ctl(ep, EPOLL_CTL_DEL, fd, NULL);
                close(fd); g_fd[fd] = -1;
            }
        }
    }
    close(ep); close(lfd);
    return 0;
}
```

**验证**：

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g stage0.c -o stage0
./stage0 6379 &
printf 'hello\n' | nc -q1 127.0.0.1 6379          # 输出 hello
# 200 个并发连接，观察 fd 与内存
for i in $(seq 1 200); do (printf 'x\n' | nc -q1 127.0.0.1 6379 >/dev/null) & done; wait
ls /proc/$(pgrep -f './stage0 6379')/fd | wc -l    # 稳定在 4 左右，不随连接数增长
```

失败时查：`ss -lntp` 看监听；`strace -f -e epoll_wait,accept4,read,write ./stage0 6379` 看事件序列；`ulimit -n` 是否小于连接数。

**常见错误**：

1. `accept: Resource temporarily unavailable` 当致命错误退出。`EAGAIN` 表示「这一轮没有新连接了」，应 `break` 回事件循环，不是错误。
2. 可读事件只 `read` 一次。LT 下会反复通知，但每次只读 4 KiB，吞吐被系统调用次数拖死；必须循环到 `EAGAIN`。
3. 把 `EPOLLRDHUP` 当普通可读。对端半关闭后仍可能有数据，先读完再关闭；直接关会丢最后一段响应。
4. `write` 返回 `EAGAIN` 就当致命错误。本阶段为了短小直接关闭慢连接；生产实现必须用输出缓冲 + `EPOLLOUT`，在可写时续传。

**下一步**：把回显替换成 RESP 解析器。Stage 1 只做「字节流 → 参数数组」，不碰命令语义；这样协议 bug 与命令 bug 不会混在一起。

### B.1.4 Stage 1：RESP 协议解析与编码

**目标**：能从任意切分的 TCP 字节流中解析出完整命令（`*` 数组 / `$` bulk / 内联），编码方向支持 `+ - : $ *` 五种回复；对恶意长度、截断、超长数组返回错误而不是崩溃。

```text
$ make test
test_resp: ok
$ printf '*2\r\n$3\r\nGET\r\n$3\r\nfoo\r\n' | ./build/resp_dump
argc=2 GET foo
$ printf 'PING\r\n' | ./build/resp_dump
argc=1 PING
$ printf '*1\r\n$3\r\nGET' | ./build/resp_dump
incomplete
```

**关键概念**：TCP 是字节流，没有消息边界（短读/短写的底层规则见 [2.2.3](../part2/ch02.md#sec-2.2.3)）。一次 `read` 可能拿到半条命令、一条半、或十条。解析器必须返回「消费了多少字节」，让调用者保留剩余部分。RESP 的 `$<len>\r\n<data>\r\n` 是**长度前缀**，不能用 `strstr` 找 `\r\n` 判断结束——数据里可以出现任意字节，包括 `\r\n`。`*` 的数组长度与 `$` 的 bulk 长度都要做上界检查，否则一个 `$999999999999` 就能让服务器分配几个 GB。

**代码**（`src/resp.c`，完整解析器；头文件见 `include/resp.h`）：

```c
/* resp.c — RESP2 解析器（节选：解析部分完整，编码部分给核心函数） */
#include "resp.h"
#include <limits.h>
#include <stdarg.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const char *find_crlf(const char *p, size_t n)
{
    if (n < 2) return NULL;
    for (size_t i = 0; i + 1 < n; i++)
        if (p[i] == '\r' && p[i + 1] == '\n') return p + i;
    return NULL;
}

/* 严格十进制：不接受 '+', 空格, 空串；溢出返回 -1。 */
static int parse_i64(const char *p, size_t n, long long *out)
{
    if (n == 0 || n > 20) return -1;
    size_t i = 0;
    int neg = 0;
    if (p[0] == '-') { neg = 1; i = 1; if (n == 1) return -1; }
    unsigned long long v = 0;
    for (; i < n; i++) {
        if (p[i] < '0' || p[i] > '9') return -1;
        unsigned d = (unsigned)(p[i] - '0');
        if (v > (ULLONG_MAX - d) / 10) return -1;
        v = v * 10 + d;
    }
    if (neg) {
        if (v > (unsigned long long)LLONG_MAX + 1ULL) return -1;
        *out = (v == (unsigned long long)LLONG_MAX + 1ULL)
                   ? LLONG_MIN : -(long long)v;
    } else {
        if (v > (unsigned long long)LLONG_MAX) return -1;
        *out = (long long)v;
    }
    return 0;
}

/* p 指向 '$'，n 是剩余长度。 */
static enum resp_status parse_bulk(const char *p, size_t n,
                                   struct resp_arg *a, size_t *used)
{
    if (n < 2) return RESP_INCOMPLETE;
    const char *crlf = find_crlf(p + 1, n - 1);
    if (crlf == NULL) return RESP_INCOMPLETE;

    long long blen = 0;
    if (parse_i64(p + 1, (size_t)(crlf - (p + 1)), &blen) < 0) return RESP_ERR;
    if (blen < 0 || (unsigned long long)blen > RESP_MAX_BULK) return RESP_ERR;

    size_t head = (size_t)(crlf - p) + 2;
    size_t need = head + (size_t)blen + 2;
    if (n < need) return RESP_INCOMPLETE;
    if (p[head + (size_t)blen] != '\r' ||
        p[head + (size_t)blen + 1] != '\n') return RESP_ERR;

    a->ptr = p + head;
    a->len = (size_t)blen;
    *used = need;
    return RESP_OK;
}

/* 内联命令：PING\r\n 或 SET foo bar\r\n；不支持引号，见常见错误 3。 */
static enum resp_status parse_inline(const char *buf, size_t len,
                                     struct resp_cmd *out, size_t *consumed)
{
    const char *crlf = find_crlf(buf, len);
    if (crlf == NULL)
        return len > 64u * 1024u ? RESP_ERR : RESP_INCOMPLETE;

    size_t end = (size_t)(crlf - buf);
    size_t i = 0;
    int argc = 0;
    while (i < end) {
        while (i < end && (buf[i] == ' ' || buf[i] == '\t')) i++;
        if (i >= end) break;
        size_t start = i;
        while (i < end && buf[i] != ' ' && buf[i] != '\t') i++;
        if (argc == RESP_MAX_ARGS) return RESP_ERR;
        out->argv[argc].ptr = buf + start;
        out->argv[argc].len = i - start;
        argc++;
    }
    out->argc = argc;
    *consumed = end + 2;
    return RESP_OK;
}

enum resp_status resp_parse(const char *buf, size_t len,
                            struct resp_cmd *out, size_t *consumed)
{
    if (buf == NULL || out == NULL || consumed == NULL) return RESP_ERR;
    if (len == 0) return RESP_INCOMPLETE;
    if (buf[0] != '*') return parse_inline(buf, len, out, consumed);

    const char *crlf = find_crlf(buf + 1, len - 1);
    if (crlf == NULL) return RESP_INCOMPLETE;

    long long argc = 0;
    if (parse_i64(buf + 1, (size_t)(crlf - (buf + 1)), &argc) < 0) return RESP_ERR;
    if (argc == 0) {
        out->argc = 0;
        *consumed = (size_t)(crlf - buf) + 2;
        return RESP_OK;
    }
    if (argc < 0 || argc > RESP_MAX_ARGS) return RESP_ERR;

    size_t off = (size_t)(crlf - buf) + 2;
    for (int i = 0; i < (int)argc; i++) {
        if (off >= len) return RESP_INCOMPLETE;
        if (buf[off] != '$') return RESP_ERR;
        size_t used = 0;
        enum resp_status st = parse_bulk(buf + off, len - off, &out->argv[i], &used);
        if (st != RESP_OK) return st;
        off += used;
    }
    out->argc = (int)argc;
    *consumed = off;
    return RESP_OK;
}

/* resp.c 末尾的公开包装：命令层用它解析 INCR 的旧值。 */
int resp_parse_i64(const char *p, size_t n, long long *v) { return parse_i64(p, n, v); }
```

编码方向同样重要：错误必须是 `-ERR ...\r\n`，整数是 `:N\r\n`，不存在的 key 是 `$-1\r\n`（不是空 bulk `$0\r\n`）。`sbuf` 的定义与 `sbuf_append` 在 `include/resp.h` / `src/resp.c`，核心是两个长度前缀写入：

```c
int resp_reply_bulk(struct sbuf *b, const char *p, size_t n)
{
    char hdr[32];
    int h = snprintf(hdr, sizeof hdr, "$%zu\r\n", n);
    if (h < 0 || sbuf_append(b, hdr, (size_t)h) < 0) return -1;
    if (sbuf_append(b, p, n) < 0) return -1;
    return sbuf_append(b, "\r\n", 2);
}

int resp_reply_int(struct sbuf *b, long long v)
{
    char tmp[32];
    int n = snprintf(tmp, sizeof tmp, ":%lld\r\n", v);
    return n < 0 ? -1 : sbuf_append(b, tmp, (size_t)n);
}
```

**验证**：单元测试至少覆盖下表的每一行。真实项目里这些断言放在 `tests/test_resp.c`，`make test` 直接跑。

| 输入 | 期望 |
|:--|:--|
| `*3\r\n$3\r\nSET\r\n$1\r\nk\r\n$1\r\nv\r\n` | `RESP_OK`，`argc=3` |
| 同一条命令切成 1 字节 100 次喂入 | 前 99 次 `INCOMPLETE`，最后一次 `OK` |
| `PING\r\n` | `RESP_OK`，`argc=1` |
| `*1\r\n$3\r\nGETX\r\n` | `RESP_ERR`（长度与内容不符） |
| `*1\r\n$-1\r\n` | `RESP_ERR`（命令参数不能是 null bulk） |
| `*999999999\r\n` | `RESP_ERR`（超过 `RESP_MAX_ARGS`） |

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror \
   -fsanitize=address,undefined src/resp.c tests/test_resp.c -o /tmp/test_resp
/tmp/test_resp && echo ok
```

**常见错误**：

1. **用 `strstr(buf, "\r\n")` 找 bulk 结束**。数据里出现 `\r\n` 时提前截断；必须按长度前缀读。
2. **`*0\r\n` 当协议错误**。空数组合法（Redis 会忽略），解析器应返回 `argc=0` 让上层跳过。
3. **内联命令不支持引号**。Redis 的内联协议支持 `"..."` 与转义；本章只做空白切分，`SET k "a b"` 会被切成 4 个参数。要么明确不支持，要么按 Redis 的 `sdssplitargs` 规则补全。
4. **长度溢出**。`blen` 用 `int` 或先 `malloc(blen+1)` 再检查，都会在 `$9223372036854775807` 上溢出；先与 `RESP_MAX_BULK` 比较，再转 `size_t`。

**下一步**：把 `resp_parse` 返回的参数数组（整数解析器另以 `resp_parse_i64` 暴露给命令层）接到命令表。Stage 2 先用一个临时线性表存 key，目的是把「协议 → 命令 → 回复」跑通；Stage 3 再换成真正的 dict 与类型系统。

### B.1.5 Stage 2：命令表与 GET/SET/DEL/EXISTS/INCR

**目标**：实现大小写不敏感的命令分派、参数个数检查、类型错误与整数溢出错误；五个命令的行为与 Redis 一致到可以用 `redis-cli` 做对照。

```text
$ ./build/myredis 6379 &
$ redis-cli -p 6379 SET user:1 alice
OK
$ redis-cli -p 6379 GET user:1
"alice"
$ redis-cli -p 6379 EXISTS user:1 nope
(integer) 1
$ redis-cli -p 6379 INCR counter
(integer) 1
$ redis-cli -p 6379 INCR counter
(integer) 2
$ redis-cli -p 6379 SET counter abc
OK
$ redis-cli -p 6379 INCR counter
(error) ERR value is not an integer or out of range
```

**关键概念**：命令表把「名字 → 函数指针 + arity」做成数据（错误约定见 [2.1.3](../part2/ch01.md#sec-2.1.3)），分派循环不写 `if/else` 链。Redis 的 `arity` 正数表示精确参数个数（含命令名），负数表示至少 `-arity` 个。`INCR` 的语义是「读-改-写」原子操作；单线程下不需要锁，但**必须**在解析失败时保持原值不变。`SET` 覆盖旧值时，旧对象的释放时机要明确：先构造新对象，成功后再替换，避免「旧值已释放、新值分配失败」留下空指针。

**代码**（`src/db.c` 的命令层；存储先用线性表，Stage 3 替换）：

```c
/* db.c — 命令表与字符串命令（节选） */
#include "db.h"
#include "resp.h"
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <strings.h>

static struct entry *kv_find(struct server *s, const char *k, size_t n)
{
    for (size_t i = 0; i < s->len; i++)
        if (s->tab[i].klen == n && memcmp(s->tab[i].key, k, n) == 0)
            return &s->tab[i];
    return NULL;
}

static int kv_set(struct server *, const char *, size_t, struct obj *);

static int cmd_set(struct server *s, int argc, struct resp_arg *argv, struct sbuf *out)
{
    if (argc != 3)
        return resp_reply_error(out, "ERR wrong number of arguments for 'set'");
    struct obj *o = obj_new_string(argv[2].ptr, argv[2].len);
    if (o == NULL) return resp_reply_error(out, "ERR out of memory");
    if (kv_set(s, argv[1].ptr, argv[1].len, o) < 0) {
        obj_free(o);
        return resp_reply_error(out, "ERR out of memory");
    }
    return resp_reply_simple(out, "OK");
}

/* GET/DEL/EXISTS 与 cmd_set 同构：查表 → 类型检查 → 编码回复。
 * 为了篇幅只保留 SET 与 INCR；其余三个见 src/db.c。 */

/* 整数解析直接复用 Stage 1 的 parse_i64（在 resp.h 中暴露为
 * resp_parse_i64）：拒绝空串、前导空格、'+'、溢出；失败时原值不变。 */

static int cmd_incr(struct server *s, int argc, struct resp_arg *argv, struct sbuf *out)
{
    if (argc != 2)
        return resp_reply_error(out, "ERR wrong number of arguments for 'incr'");
    struct entry *e = kv_find(s, argv[1].ptr, argv[1].len);
    long long v = 0;
    if (e) {
        if (e->val->type != OBJ_STRING)
            return resp_reply_error(out, "WRONGTYPE Operation against a key holding the wrong kind of value");
        if (resp_parse_i64(e->val->str, e->val->len, &v) < 0)
            return resp_reply_error(out, "ERR value is not an integer or out of range");
    }
    if (v == LLONG_MAX)
        return resp_reply_error(out, "ERR increment or decrement would overflow");
    v++;
    char buf[32];
    int n = snprintf(buf, sizeof buf, "%lld", v);
    struct obj *o = obj_new_string(buf, (size_t)n);
    if (o == NULL) return resp_reply_error(out, "ERR out of memory");
    if (kv_set(s, argv[1].ptr, argv[1].len, o) < 0) {
        obj_free(o);
        return resp_reply_error(out, "ERR out of memory");
    }
    return resp_reply_int(out, v);
}

/* 省略的 handler 与线性表插入：原型在此，实现在 src/db.c。 */
static int cmd_get(struct server *, int, struct resp_arg *, struct sbuf *);
static int cmd_del(struct server *, int, struct resp_arg *, struct sbuf *);
static int cmd_exists(struct server *, int, struct resp_arg *, struct sbuf *);

struct command {
    const char *name;
    int arity;   /* >0 精确；<0 至少 -arity */
    int (*fn)(struct server *, int, struct resp_arg *, struct sbuf *);
};

static const struct command g_cmds[] = {
    { "get",    2, cmd_get },
    { "set",    3, cmd_set },
    { "del",   -2, cmd_del },
    { "exists",-2, cmd_exists },
    { "incr",   2, cmd_incr },
};

static int arg_eq(struct resp_arg *a, const char *s)
{
    size_t n = strlen(s);
    return a->len == n && strncasecmp(a->ptr, s, n) == 0;
}

int dispatch(struct server *s, struct resp_cmd *c, struct sbuf *out)
{
    if (c->argc == 0) return 0;
    for (size_t i = 0; i < sizeof g_cmds / sizeof g_cmds[0]; i++) {
        if (!arg_eq(&c->argv[0], g_cmds[i].name)) continue;
        int arity = g_cmds[i].arity;
        if ((arity > 0 && c->argc != arity) ||
            (arity < 0 && c->argc < -arity))
            return resp_reply_error(out, "ERR wrong number of arguments");
        return g_cmds[i].fn(s, c->argc, c->argv, out);
    }
    return resp_reply_error(out, "ERR unknown command");
}
```

`process_input` 把 Stage 0 的 `handle_read` 与 Stage 1 的解析器接起来。关键是一次 `read` 里可能有多条命令，解析循环必须消费到 `INCOMPLETE` 为止：

```c
/* 返回 -1 表示协议错误，调用者应回错误并关闭连接。 */
int process_input(struct server *s, struct client *c)
{
    size_t off = 0;
    while (off < c->in_len) {
        struct resp_cmd cmd;
        size_t consumed = 0;
        enum resp_status st = resp_parse(c->in + off, c->in_len - off,
                                         &cmd, &consumed);
        if (st == RESP_INCOMPLETE) break;
        if (st == RESP_ERR) {
            resp_reply_error(&c->out, "ERR Protocol error");
            return -1;
        }
        dispatch(s, &cmd, &c->out);   /* 命令只改内存，回复进 c->out */
        off += consumed;
    }
    if (off) {
        memmove(c->in, c->in + off, c->in_len - off);
        c->in_len -= off;
    }
    return 0;
}
```

**验证**：用 `redis-cli` 与官方 Redis 7 并排跑同一串命令，逐条比对回复。至少覆盖：`SET k v`、`GET missing`（`(nil)`）、`DEL` 多 key、`EXISTS` 多 key、`INCR` 到 `LLONG_MAX`、`SET n abc; INCR n`（必须报错且 `GET n` 仍是 `abc`）、大小写混合 `SeT`、错误 arity `GET`（报错不崩）。

```bash
make -C myredis test
for c in 'SET k v' 'GET k' 'GET nope' 'EXISTS k nope' 'DEL k nope' 'INCR n' 'INCR n'; do
  redis-cli -p 6379 $c
done
```

**常见错误**：

1. **`strncasecmp` 读越界**。`argv[0].ptr` 不是 NUL 结尾的字符串，必须先比长度；直接用 `strcasecmp(a->ptr, "get")` 会在 `GETX` 上读到缓冲区外。
2. **`INCR` 先删除再解析**。解析失败时原值已经被删，`GET` 返回 nil；正确顺序是「解析 → 成功 → 替换」。
3. **`SET` 覆盖时泄漏旧对象**。`kv_set` 内部先 `obj_free(e->val)` 再赋新值；如果新对象构造失败，旧值已经没了。先构造、后替换。
4. **`DEL` 返回删除个数却把重复 key 算两次**。`DEL k k` 在 Redis 里返回 1（第二次已不存在），逐次删除自然正确；不要先统计再删。

**下一步**：线性表在 10 万 key 时 `GET` 要扫 10 万次，Stage 3 换成哈希表；同时引入类型标签，让 `GET` 对 list 返回 `WRONGTYPE`，并实现 list/hash/zset。
### B.1.6 Stage 3：dict、list、hash、zset

**目标**：把 Stage 2 的线性表换成哈希表；实现四类对象与 `TYPE`/`WRONGTYPE`；list 用双向链表，hash 复用 dict，zset 用有序数组；10 万 key 的 `GET` 不随 key 数线性变慢。

```text
$ redis-cli -p 6379 SET s hello
OK
$ redis-cli -p 6379 TYPE s
string
$ redis-cli -p 6379 LPUSH q a b c
(integer) 3
$ redis-cli -p 6379 LRANGE q 0 -1
1) "c"
2) "b"
3) "a"
$ redis-cli -p 6379 HSET u name alice age 30
(integer) 2
$ redis-cli -p 6379 HGET u name
"alice"
$ redis-cli -p 6379 ZADD board 90 alice 80 bob
(integer) 2
$ redis-cli -p 6379 ZRANGE board 0 -1 WITHSCORES
1) "bob"
2) "80"
3) "alice"
4) "90"
$ redis-cli -p 6379 GET q
(error) WRONGTYPE Operation against a key holding the wrong kind of value
```

**关键概念**：Redis 的 `dict` 是渐进式 rehash（哈希与页缓存的相互作用见 [2.2.8](../part2/ch02.md#sec-2.2.8)）（两张表、`rehashidx` 游标、每次操作搬一个桶）；本章简化为**一次性 rehash**，负载因子超过 1 时分配 2 倍桶、重新挂链。这个简化只影响单次 `SET` 的延迟毛刺，不影响正确性，也足以讲清哈希表的扩容路径。zset 的取舍见下表：

| 实现 | 插入 | 按 score 查 | 按 rank 取 | 内存 | 适用 |
|:--|:--|:--|:--|:--|:--|
| 跳表（Redis） | O(log n) 期望 | O(log n) | O(log n) | 每节点多级指针，较大 | 大量写、范围查询 |
| 有序数组（本章） | O(n) memmove | O(log n) | O(1) | 连续，缓存友好 | 读多写少、几千成员 |
| 平衡树 | O(log n) | O(log n) | O(log n) | 每节点指针 | 通用，但代码复杂 |

**代码**（`src/dict.c` 的插入/扩容/查找，已在 ASan 下用 1 万 key 实测）：

```c
/* dict.c — 链式哈希表，负载因子 > 1 时一次性 rehash */
struct dict_entry {
    uint64_t hash;
    char *key;
    size_t klen;
    void *val;
    struct dict_entry *next;
};
struct dict {
    struct dict_entry **buckets;   /* 桶数总是 2 的幂 */
    size_t nbuckets;
    size_t size;
};

static uint64_t hash_bytes(const char *p, size_t n)
{
    uint64_t h = 1469598103934665603ULL;       /* FNV-1a 64 */
    for (size_t i = 0; i < n; i++) {
        h ^= (unsigned char)p[i];
        h *= 1099511628211ULL;
    }
    return h;
}

static int dict_resize(struct dict *d)
{
    size_t nb = d->nbuckets * 2;
    struct dict_entry **nbk = calloc(nb, sizeof *nbk);
    if (nbk == NULL) return -1;
    for (size_t i = 0; i < d->nbuckets; i++) {
        struct dict_entry *e = d->buckets[i];
        while (e) {
            struct dict_entry *next = e->next;
            size_t idx = (size_t)(e->hash & (nb - 1));
            e->next = nbk[idx];
            nbk[idx] = e;
            e = next;
        }
    }
    free(d->buckets);
    d->buckets = nbk;
    d->nbuckets = nb;
    return 0;
}

int dict_set(struct dict *d, const char *key, size_t klen, void *val)
{
    uint64_t h = hash_bytes(key, klen);
    size_t idx = (size_t)(h & (d->nbuckets - 1));

    for (struct dict_entry *e = d->buckets[idx]; e; e = e->next) {
        if (e->hash == h && e->klen == klen && memcmp(e->key, key, klen) == 0) {
            e->val = val;                  /* 旧值由调用者释放 */
            return 0;
        }
    }
    struct dict_entry *e = calloc(1, sizeof *e);
    if (e == NULL) return -1;
    e->key = malloc(klen ? klen : 1);
    if (e->key == NULL) { free(e); return -1; }
    memcpy(e->key, key, klen);
    e->klen = klen;
    e->hash = h;
    e->val = val;
    e->next = d->buckets[idx];
    d->buckets[idx] = e;
    d->size++;

    if (d->size > d->nbuckets) (void)dict_resize(d);  /* 失败只影响性能 */
    return 0;
}

void *dict_get(struct dict *d, const char *key, size_t klen)
{
    uint64_t h = hash_bytes(key, klen);
    size_t idx = (size_t)(h & (d->nbuckets - 1));
    for (struct dict_entry *e = d->buckets[idx]; e; e = e->next) {
        if (e->hash == h && e->klen == klen && memcmp(e->key, key, klen) == 0)
            return e->val;
    }
    return NULL;
}
```

zset 的核心是「按 `(score, member)` 排序 + 二分定位」：`zset_lower_bound` 用比较函数 `zcmp`（先比 score，再按 member 字节序）找第一个 `>=` 的位置；插入时 `memmove` 腾出槽位，更新分数则先删旧位置再重插。`memmove` 的 O(n) 成本就是上表里「有序数组」的代价；完整实现约 80 行，见 `src/zset.c`。这里不再贴代码，把篇幅留给后面的持久化——你应当能照着 dict 的写法独立完成它。

list 与 hash 的实现不展开：`list` 是带 `head/tail/len` 的双向链表，`LPUSH` O(1)、`LRANGE` 从最近一端走；`hash` 直接复用 `dict`，`HSET` 的 value 再包一个 `struct obj`。完整函数清单与接口如下，照着补即可：

| 文件 | 关键函数 | 说明 |
|:--|:--|:--|
| `src/obj.c` | `obj_new_string/list/hash/zset`、`obj_free` | 类型标签 + 引用计数可选 |
| `src/t_list.c` | `list_push/pop/range`、`cmd_lpush/lrange` | 负索引 `-1` 表示尾 |
| `src/t_hash.c` | `cmd_hset/hget/hdel` | 字段名大小写敏感 |
| `src/t_zset.c` | `zset_add/del/range`、`cmd_zadd/zrange` | `WITHSCORES` 只是多写一行 |

**验证**：先做命令级回归，再做一个 10 万 key 的延迟对比。

```bash
# 类型与错误路径
redis-cli -p 6379 LPUSH q a; redis-cli -p 6379 GET q      # 必须 WRONGTYPE
redis-cli -p 6379 ZADD z 1 a 2 b; redis-cli -p 6379 ZRANGE z 0 -1 WITHSCORES
redis-cli -p 6379 HSET h f v; redis-cli -p 6379 HGET h f
# 10 万 key：线性表 O(n) 会到秒级，dict 应在毫秒级
redis-benchmark -p 6379 -t set,get -n 100000 -c 50 -q
# 内存与越界
valgrind --leak-check=full ./build/myredis --port 6380 &
```

**常见错误**：

1. **rehash 时用旧桶数取模**。`idx` 必须在 `nbk` 上用新掩码算；用 `d->nbuckets` 会越界。
2. **替换 value 时泄漏旧值**。`dict_set` 只改指针；调用者要先 `obj_free(old)`，且注意「先构造新值、成功后再释放旧值」。
3. **遍历 dict 时删除**。`dict_iter_next` 保存的 `next` 指针在删除后可能失效；要删除就先收集 key，再统一删。
4. **zset 用 `==` 比较 double**。分数相同才走 member 比较；NaN 会让排序不满足全序，`ZADD` 必须拒绝 NaN。

**下一步**：数据能存了，但 key 永远不过期。Stage 4 加 TTL，并解释为什么「定期删除」必须限制每轮耗时。

### B.1.7 Stage 4：过期——惰性删除 + 定期采样

**目标**：`SET k v PX 100` 后 100 ms 内 `GET` 返回 nil；`TTL` 返回剩余秒数；后台每 100 ms 采样删除过期 key，且单轮 CPU 占用有上界。

```text
$ redis-cli -p 6379 SET session abc PX 100
OK
$ redis-cli -p 6379 PTTL session
(integer) 97
$ sleep 0.2 && redis-cli -p 6379 GET session
(nil)
$ redis-cli -p 6379 SET k v EX 100
OK
$ redis-cli -p 6379 TTL k
(integer) 100
$ redis-cli -p 6379 PERSIST k
(integer) 1
$ redis-cli -p 6379 TTL k
(integer) -1
```

**关键概念**：过期时间是「绝对毫秒时间戳」（`clock_gettime` 见 [2.11.2](../part2/ch11.md#sec-2.11.2)），存在独立的 `expires` 字典里，不占对象本身。删除策略两条腿：**惰性**（访问时检查，过期就删并返回 nil）保证正确性；**定期**（`serverCron` 每 100 ms 采样）保证过期 key 不会永久占内存。采样不是全扫：顺序取 20 个带 TTL 的 key（教学版；生产应随机取桶），删除其中过期的；如果过期比例超过 25%，再取一轮，但限制总轮数/总耗时。把 `epoll_wait` 的超时设为 100 ms，超时后调用 `active_expire_cycle`（不要用 `sleep` 阻塞事件循环）。用 `CLOCK_MONOTONIC` 还是 `CLOCK_REALTIME`？Redis 用可调整的 wall clock 并处理时钟回拨；教学版用 `CLOCK_MONOTONIC` 更简单，但 `TTL` 的语义会与「墙上时间」不同，见常见错误 1。

**代码**（`src/expire.c`）：

```c
/* expires 是独立的 dict：key -> int64_t 过期时刻（ms，单调钟） */
static int64_t now_ms(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return (int64_t)ts.tv_sec * 1000 + ts.tv_nsec / 1000000;
}

/* 惰性删除：每次按 key 查值前调用。返回 1 表示已过期并删除。 */
int expire_if_needed(struct server *s, const char *key, size_t klen)
{
    int64_t *when = dict_get(s->expires, key, klen);
    if (when == NULL || *when > now_ms()) return 0;
    void *old_when = NULL, *old_val = NULL;
    dict_del(s->expires, key, klen, &old_when);
    dict_del(s->db->dict, key, klen, &old_val);
    free(old_when);
    obj_free(old_val);
    s->stat_expired++;
    return 1;
}

/* 定期采样：每轮最多 20 个，过期比例 > 25% 再来一轮，最多 4 轮。 */
void active_expire_cycle(struct server *s)
{
    for (int round = 0; round < 4; round++) {
        if (dict_size(s->expires) == 0) return;
        /* 先收集，后删除：迭代期间删除会让迭代器指向已释放的 entry。 */
        char *victim[20];
        size_t vlen[20];
        int sampled = 0, expired = 0;

        struct dict_iter it;
        dict_iter_init(&it, s->expires);
        for (int i = 0; i < 20; i++) {
            struct dict_entry *e = dict_iter_next(&it);
            if (e == NULL) break;
            sampled++;
            if (*(int64_t *)e->val <= now_ms()) {
                if (e->klen > 4096) continue;      /* 教学版上界；生产版按长度分配 */
                victim[expired] = malloc(e->klen ? e->klen : 1);
                if (victim[expired] == NULL) break;
                memcpy(victim[expired], e->key, e->klen);
                vlen[expired] = e->klen;
                expired++;
            }
        }
        for (int i = 0; i < expired; i++) {
            expire_if_needed(s, victim[i], vlen[i]);
            free(victim[i]);
        }
        if (sampled == 0 || expired * 4 <= sampled) return;
    }
}
```

`SET` 的 `EX/PX` 选项在命令层解析：只接受正整数；`EX` 乘 1000 转毫秒，`PX` 直接取；然后 `db_set` 写值，再把绝对过期时刻写进 `expires`，最后**把命令规范化为 `SET` + `PEXPIREAT`** 再喂 AOF/复制，避免重放时重新计时。`TTL` 用 `(when - now_ms() + 999) / 1000` 向上取整；`PERSIST` 删 `expires` 条目；`SET` 不带 TTL 时也要删旧 TTL。

**验证**：时间相关的测试不要用 `sleep 1` 碰运气，用 `PTTL` + 短 TTL + 轮询。

```bash
redis-cli -p 6379 SET k v PX 100
sleep 0.2
test "$(redis-cli -p 6379 GET k)" = "" && echo "lazy expire ok"
# 定期删除：写入 1000 个 PX 50 的 key，等 1 秒后看内存与 DBSIZE
for i in $(seq 1 1000); do redis-cli -p 6379 SET tmp:$i v PX 50 >/dev/null; done
sleep 1
redis-cli -p 6379 DBSIZE        # 期望只剩非过期 key
redis-cli -p 6379 INFO stats | grep expired_keys
```

**常见错误**：

1. **用 `CLOCK_REALTIME` 存过期时刻**。用户改系统时间（NTP 回拨、容器时钟漂移）会让 key 提前过期或永不过期；要单调时钟，或像 Redis 那样同时维护两种时间并处理跳变。
2. **`EX` 与 `PX` 混用**。`EX 100` 是 100 秒，`PX 100` 是 100 毫秒；`SET k v EX 100` 被当成毫秒是 1000 倍错误。
3. **定期删除全表扫描**。10 万 key 每 100 ms 扫一遍，CPU 直接打满；必须采样 + 限制轮数。
4. **删除正在迭代的 key**。上面先复制 key 再删；直接对迭代器返回的 entry 调 `dict_del` 会 use-after-free。

**下一步**：内存里的数据重启就没了。Stage 5 用 `fork` + COW 做 RDB 快照，先解决「能恢复」，再解决「恢复得全」。

### B.1.8 Stage 5：RDB——格式、fork+COW 快照与加载

**目标**：`BGSAVE` 不阻塞主循环；生成的 `dump.rdb` 能在重启后恢复全部 key、类型、TTL；文件损坏时拒绝加载而不是崩溃。

```text
$ redis-cli -p 6379 SET a 1
OK
$ redis-cli -p 6379 RPUSH l x y
(integer) 2
$ redis-cli -p 6379 BGSAVE
Background saving started
$ ls -l dump.rdb
-rw-r--r-- 1 user user 12345 ... dump.rdb
$ kill -9 %1 && ./myredis --port 6379 --dir .
$ redis-cli -p 6379 GET a
"1"
$ redis-cli -p 6379 LRANGE l 0 -1
1) "x"
2) "y"
```

**关键概念**：`fork` 之后，子进程拥有父进程地址空间的**写时复制**视图：子进程遍历字典不会看到父进程之后的修改，也不需要暂停父进程。父进程继续服务，修改共享页时内核复制一份，所以快照的内存开销取决于「快照期间被改写的页数」，不是整个数据集。RDB 文件必须**先写临时文件、`fsync`、`rename`、`fsync` 目录**，否则崩溃会留下半个文件并覆盖掉旧快照（[2.3.7](../part2/ch03.md#sec-2.3.7)）。[2.12.6](../part2/ch12.md#sec-2.12.6) 讲了 `fork` 与线程的坑：单线程进程 `fork` 后 `malloc` 是安全的；但多线程父进程的 `fork` 子进程只能调用 async-signal-safe 函数，且无论哪种情况都用 `_exit`，不要 flush 父进程的 stdio。

**文件格式**（自定义，非 Redis 兼容；重点是可校验、可扩展）：

| 偏移 | 字段 | 长度 | 说明 |
|:--|:--|:--|:--|
| 0 | magic | 8 | `MYRDB001` |
| 8 | flags | 4 | 保留，当前为 0 |
| 12 | reserved | 4 | 0 |
| 16 | record... | 变长 | 见下 |
| EOF | `0xFF` | 1 | 结束标记 |
| EOF+4 | crc32 | 4 | 覆盖前面全部字节（含结束标记） |

每条记录：`type(1) | expire_ms(8，0 表示无过期) | key_len(4) | key | value_len(4) | value`。字符串直接存字节；list/hash/zset 先存元素个数（4 字节），再逐个存成员。所有整数小端。

**代码**（`src/rdb.c` 的保存与加载核心）：

```c
/* 子进程：遍历快照，写临时文件，fsync 后 rename。失败用 _exit 而不是 exit。 */
static int rdb_write_file(struct server *s, const char *path)
{
    char tmp[PATH_MAX];
    snprintf(tmp, sizeof tmp, "%s.tmp.%ld", path, (long)getpid());
    int fd = open(tmp, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0644);
    if (fd == -1) return -1;

    struct sbuf b;
    if (sbuf_init(&b, 1 << 20) < 0) { close(fd); unlink(tmp); return -1; }
    sbuf_append(&b, "MYRDB001", 8);
    uint32_t flags = 0, zero = 0;
    sbuf_append(&b, &flags, 4);
    sbuf_append(&b, &zero, 4);

    struct dict_iter it;
    dict_iter_init(&it, s->db->dict);
    struct dict_entry *e;
    while ((e = dict_iter_next(&it)) != NULL) {
        uint8_t type = (uint8_t)((struct obj *)e->val)->type;
        uint32_t klen = (uint32_t)e->klen;
        int64_t *when = dict_get(s->expires, e->key, e->klen);
        int64_t expire = when ? *when : 0;
        sbuf_append(&b, &type, 1);
        sbuf_append(&b, &expire, 8);
        sbuf_append(&b, &klen, 4);
        sbuf_append(&b, e->key, e->klen);
        if (obj_serialize(&b, e->val) < 0) goto fail;   /* 省略了 sbuf_append 的返回值检查，生产代码要补 */
    }
    uint8_t end = 0xFF;
    sbuf_append(&b, &end, 1);
    uint32_t crc = crc32(0, (const uint8_t *)b.data, b.len);
    sbuf_append(&b, &crc, 4);

    if (write_full(fd, b.data, b.len) < 0 || fsync(fd) < 0) goto fail;
    if (close(fd) < 0) { fd = -1; goto fail; }
    fd = -1;
    if (rename(tmp, path) < 0) goto fail;
    if (fsync_parent(path) < 0) { /* 记录警告，不否定已 rename 的文件 */ }
    sbuf_free(&b);
    return 0;
fail:
    { int saved = errno; if (fd >= 0) close(fd); unlink(tmp); sbuf_free(&b); errno = saved; }
    return -1;
}

/* 父进程：fork 后立即返回；子进程写文件并 _exit。 */
int rdb_bgsave(struct server *s, const char *path)
{
    pid_t pid = fork();
    if (pid < 0) return -1;
    if (pid == 0) {
        int rc = rdb_write_file(s, path);
        _exit(rc == 0 ? 0 : 1);
    }
    s->rdb_child = pid;
    s->rdb_start = now_ms();
    return 0;
}
```

加载按相反顺序做：校验 magic → 读整文件 → 校验末尾 CRC → 从偏移 16 逐条读记录。每条记录先读 `type/expire/klen`，**先把 `klen` 与剩余字节数比较**，再读 key；value 由 `obj_deserialize` 按类型解析。任何越界、未知类型、CRC 不符都返回错误并拒绝启动，不尝试「部分恢复」。记录之间没有对齐填充，所有整数小端；文件尾的 `0xFF` 只是调试标记，加载以 CRC 前的偏移为准。

**验证**：`kill -9` 是最诚实的验收。对比 `DBSIZE` 与抽样 key 的值、类型、TTL；再看 COW 开销。

```bash
redis-benchmark -p 6379 -t set -n 100000 -r 100000 -q
redis-cli -p 6379 BGSAVE
grep -E 'VmRSS|Private_Dirty' /proc/$(pgrep -f 'myredis --port 6379')/status
redis-cli -p 6379 INFO persistence | grep rdb_
kill -9 $(pgrep -f 'myredis --port 6379')
./build/myredis --port 6379 --dir .
redis-cli -p 6379 DBSIZE
```

**常见错误**：

1. **子进程调用 `printf`/`malloc` 后 `exit`**。`fork` 后多线程父进程的锁状态在子进程里可能不一致；只调用 async-signal-safe 函数，用 `_exit` 避免 flush 父进程的 stdio 缓冲。
2. **直接写 `dump.rdb`**。写到一半崩溃，旧快照也没了；必须临时文件 + `fsync` + `rename`。
3. **忘记 `fsync` 目录**。`rename` 只保证目录项在内存里原子；掉电后可能看到旧名字或空目录项。
4. **加载时不校验长度**。损坏文件的 `klen=0xFFFFFFFF` 会让 `malloc` 失败或触发 OOM；所有长度先与剩余字节比较。

**下一步**：RDB 只能恢复到上一次快照，两次快照之间的写会丢。Stage 6 用 AOF 把每条写命令记下来，把丢失窗口缩到 `appendfsync` 策略决定的一小段。

### B.1.9 Stage 6：AOF——appendfsync 策略与重写

**目标**：开启 AOF 后，`appendfsync always` 下 `kill -9` 不丢已回复的写；`everysec` 下最多丢约 1 秒；AOF 重写后文件显著变小且语义等价。

```text
$ ./myredis --port 6379 --appendonly yes --appendfsync everysec &
$ redis-cli -p 6379 SET a 1
OK
$ kill -9 %1
$ ./myredis --port 6379 --appendonly yes
$ redis-cli -p 6379 GET a
"1"
```

**关键概念**：AOF 记录的是**改变数据的命令**（`fsync` 的持久化语义见 [2.3.7](../part2/ch03.md#sec-2.3.7)），不是结果。`SET` 追加 `SET k v`；`INCR` 追加 `INCR k`（重放时会得到同样结果）；`EXPIRE` 追加 `PEXPIREAT`（绝对时间，避免重放时再次计时）。`appendfsync` 三档：

| 策略 | 行为 | 崩溃丢失 | 吞吐 |
|:--|:--|:--|:--|
| `always` | 每条命令 `fsync` | 0（已回复的） | 最低，受限于磁盘 IOPS |
| `everysec` | 后台每秒 `fsync` | ≤ 1 秒 | 高 |
| `no` | 交给内核 | 最多 30 秒（脏页回写） | 最高 |

AOF 重写不是「压缩文本」，而是**根据当前内存状态生成最小命令集**：一个 100 万次 `INCR` 的 key，重写后只需一条 `SET k 1000000`。重写期间父进程仍在写，所以子进程写临时文件的同时，父进程把新命令追加到 `aof_rewrite_buf`；子进程完成后，父进程把 buf 补到新文件末尾，再 `rename`。

**代码**（`src/aof.c`）：

```c
/* 命令执行成功后调用；argv 已在命令层规范化为 SET + PEXPIREAT。 */
int aof_feed(struct server *s, int argc, struct resp_arg *argv)
{
    if (!s->aof_on) return 0;
    struct sbuf *b = s->aof_rewriting ? &s->aof_rewrite_buf : &s->aof_buf;
    resp_reply_array(b, argc);
    for (int i = 0; i < argc; i++)
        resp_reply_bulk(b, argv[i].ptr, argv[i].len);
    if (s->aof_fsync == AOF_ALWAYS) return aof_flush(s);
    return 0;   /* everysec 由 serverCron 每秒调 aof_flush */
}

/* 把用户态缓冲写进 fd；处理 EINTR 与短写。 */
int aof_flush(struct server *s)
{
    size_t off = 0;
    while (off < s->aof_buf.len) {
        ssize_t n = write(s->aof_fd, s->aof_buf.data + off, s->aof_buf.len - off);
        if (n > 0) off += (size_t)n;
        else if (n == -1 && errno == EINTR) continue;
        else return -1;
    }
    if (s->aof_fsync == AOF_ALWAYS) {
        while (fsync(s->aof_fd) < 0) if (errno != EINTR) return -1;
    }
    s->aof_buf.len = 0;      /* fsync 成功后才丢弃缓冲 */
    return 0;
}
```

重写子进程只做三件事：遍历当前 dict，把每个对象编码成「最小命令集」（string 一条 `SET`，list 逐元素 `RPUSH`，hash 逐字段 `HSET`，zset 逐成员 `ZADD`，TTL 用 `PEXPIREAT` 绝对值）；写临时文件；`fsync` 后 `_exit`。`rename` 与「补写重写期间的新命令」由父进程在 `SIGCHLD` 里做：打开临时文件 `O_APPEND`，把 `aof_rewrite_buf` 写进去，`fsync`，`rename`，`fsync` 父目录，再重新打开 AOF fd。顺序反了会丢写，或者让新 AOF 缺少最后一段。

**验证**：两种 fsync 策略分别测「已回复的写」；再用 `kill -9` 制造尾部半条命令。

```bash
# always：每次写后立刻断电式杀进程
./build/myredis --port 6379 --appendonly yes --appendfsync always &
for i in $(seq 1 1000); do redis-cli -p 6379 SET k:$i $i >/dev/null; done
kill -9 %1; ./build/myredis --port 6379 --appendonly yes
redis-cli -p 6379 DBSIZE        # 期望 1000（含已有 key 时按实际算）
# 截断 AOF 末尾 5 字节，模拟写一半崩溃；加载应丢弃最后一条不完整命令
cp appendonly.aof /tmp/aof.bak && truncate -s -5 appendonly.aof
./build/myredis --port 6379 --appendonly yes   # 日志里应有 "truncated AOF"
```

**常见错误**：

1. **把 `SET k v EX 10` 原样写进 AOF**。重放时又获得 10 秒，数据可能永生；过期要转成 `PEXPIREAT` 绝对时间。
2. **加载时遇到半条命令就整体失败**。AOF 允许尾部截断：从头解析，遇到 `INCOMPLETE` 就停，保留前面的命令，并 `ftruncate` 掉尾部垃圾。
3. **重写期间丢新写**。子进程基于旧快照生成文件，父进程的新命令必须进 `aof_rewrite_buf`，并在 `rename` 前补写；顺序反了会丢一秒的写。
4. **`fsync` 返回 `EINTR` 当失败**。信号打断要重试；把 `EINTR` 当磁盘错误会让服务器误以为持久化坏了。

**下一步**：单机持久化解决了，但机器整台挂掉还是丢。Stage 7 加从库：全量 RDB + 增量命令传播，并解释复制积压（backlog）为什么是环形的。

### B.1.10 Stage 7：主从复制——全量 + 增量

**目标**：从库连上主库后先全量同步，再实时接收写命令；断线重连时，若偏移量还在 backlog 内，只补增量而不是重传整个 RDB。

```text
$ ./myredis --port 6379 &
$ ./myredis --port 6380 --replicaof 127.0.0.1 6379 &
$ redis-cli -p 6380 INFO replication
role:slave
master_link_status:up master_repl_offset:1234
$ redis-cli -p 6379 SET k v
OK
$ redis-cli -p 6380 GET k
"v"
```

**关键概念**：复制分两段（TCP 字节流与连接生命周期见 [4.1](../part4/ch01.md)）。**全量**：从库发 `PSYNC ? -1`；主库 `fork` 出 RDB 发给从库，同时把这段时间的写命令记进该从库的输出缓冲；从库加载完 RDB 再应用缓冲。**增量**：主库维护一个固定大小的环形 backlog，记录「从某个偏移量开始的字节流」和当前 `master_repl_offset`；从库重连时发 `PSYNC <replid> <offset>`，偏移量还在 backlog 覆盖范围内就回 `+CONTINUE`，否则退回全量。偏移量是**字节偏移**，不是命令序号；差一位就会重放错位。

**代码**（`src/repl.c` 的核心；网络读写复用 Stage 0 的非阻塞框架）：

```c
/* 环形 backlog：写入时覆盖最旧字节；offset 是流中下一个字节的绝对位置。 */
struct backlog {
    char *buf;
    size_t cap;       /* 2 的幂 */
    size_t len;       /* 当前有效字节数，最多 cap */
    uint64_t start;   /* buf[0] 对应的绝对偏移 */
};

/* 增量是否可满足：offset 必须落在 [start, start+len]。 */
int backlog_try_partial(struct backlog *b, uint64_t offset, struct sbuf *out)
{
    if (offset < b->start || offset > b->start + b->len) return -1;
    size_t skip = (size_t)(offset - b->start);
    for (size_t i = skip; i < b->len; i++) {
        char c = b->buf[(b->start + i) & (b->cap - 1)];
        if (sbuf_append(out, &c, 1) < 0) return -1;
    }
    return 0;
}

/* 主库收到 PSYNC：先判断增量，否则标记需要全量。 */
int repl_handle_psync(struct server *s, struct client *c,
                      const char *replid, uint64_t offset)
{
    if (strcmp(replid, s->replid) == 0) {
        struct sbuf out;
        if (sbuf_init(&out, 4096) < 0) return -1;
        if (backlog_try_partial(&s->backlog, offset, &out) == 0) {
            resp_reply_simple(&c->out, "CONTINUE");
            sbuf_append(&c->out, out.data, out.len);
            c->replica = 1;
            c->repl_offset = offset;
            sbuf_free(&out);
            return 0;
        }
        sbuf_free(&out);
    }
    /* 全量：fork 快照，子进程把 RDB 写到 c 的 socket；父进程继续缓冲命令 */
    return repl_start_fullsync(s, c);
}
```

从库侧的应用循环很短：先读 RDB 到临时文件、加载、记下 `master_repl_offset`，之后把 socket 上的 RESP 命令逐条 `dispatch`。**从库必须只读**：收到写命令返回 `READONLY`，否则主从分叉。

**验证**：三个终端，一个主、一个从、一个观察；用 `INFO replication` 与 `DEBUG SLEEP`（教学版可加）制造断线。

```bash
# 主库写入 1 万 key，从库追赶
redis-benchmark -p 6379 -t set -n 10000 -r 10000 -q
redis-cli -p 6380 DBSIZE
# 断开从库（iptables 或 kill 从库后重启），主库继续写，再重连
redis-cli -p 6380 REPLICAOF NO ONE
redis-cli -p 6379 SET after-break yes
redis-cli -p 6380 REPLICAOF 127.0.0.1 6379
redis-cli -p 6380 GET after-break     # 增量应补上
redis-cli -p 6380 INFO replication | grep -E 'link_status|offset'
```

**常见错误**：

1. **偏移量从 0 还是 1 开始不一致**。主库的 `master_repl_offset` 是「已写入字节数」，backlog 的 `start` 是「最旧字节的绝对偏移」；两边差一位就会把半条命令当起点。
2. **backlog 覆盖后仍回 `+CONTINUE`**。必须检查 `offset` 是否落在 `[start, start+len]`；否则从库会拿着一段错位数据继续解析。
3. **快照与缓冲的顺序反了**。先记缓冲再 `fork` 会重复；先 `fork` 但没在父进程里开始记缓冲会丢这段时间的写。正确顺序：`fork` → 父进程把新写同时喂 backlog 和从库缓冲 → 子进程发 RDB。
4. **从库接受写**。从库本地写不会传播回主库，主库下一次全量会覆盖它；必须在命令层拒绝写命令。

**下一步**：功能齐了，但没有数据就没有说服力。Stage 8 用 `redis-benchmark` 建立基线，用 `perf` 找热点，用 `INFO memory` 解释内存都花在哪。

### B.1.11 Stage 8：压测——`redis-benchmark`、`perf` 与内存

**目标**：给出一份可复现的报告：固定 CPU/连接数/payload，测 SET/GET 的吞吐与 P99，找出一个真实热点，解释内存占用与 key 数的关系。

```text
$ redis-benchmark -p 6379 -t set,get -n 1000000 -c 50 -P 16 -q
SET: 81234.56 requests per second, p50=0.487 msec
GET: 84567.89 requests per second, p50=0.463 msec
$ perf stat -p $(pgrep -f 'myredis --port 6379') -- sleep 10
$ redis-cli -p 6379 INFO memory | grep -E 'used_memory_human|used_memory_peak_human'
```

以上数字是**模板，未实测**。真正要记录的是「你的机器上，优化前后的比值」，不是绝对值。

**关键概念**：`redis-benchmark` 默认 50 连接、无 pipeline；`-P 16` 表示每条连接一次发 16 条命令，把 RTT 摊薄，吞吐会显著上升——这不是「服务器变快了」，而是「客户端等待变少了」。报告必须写清 `-P`、`-c`、`-n`、payload（`-d`）与是否 keep-alive。`perf record -F 999 -g -- ./myredis` 采到的热点通常在 `epoll_wait`、`read`/`write`、`memcpy`、`dict_get`、`snprintf`；`epoll_wait` 占比高不一定是坏事，说明在等 I/O；`memcpy` 高说明协议层拷贝多。

**代码**（`bench/run.sh`，报告模板见[工程手册](engineering.md)第 9 节）：

```bash
#!/usr/bin/env bash
set -euo pipefail
PORT=${PORT:-6379}
OUT=${OUT:-bench/report-$(date +%Y%m%d-%H%M%S).md}
{
  echo "# myredis 压测报告"
  echo
  echo "## 环境"
  echo "- 内核: $(uname -r)；CPU: $(nproc) vCPU；编译器: $(cc --version | head -1)"
  echo "- 服务端: ./build/myredis --port $PORT；客户端: 同机 redis-benchmark"
  echo "- payload: 默认 3 字节；pipeline: -P 16；连接: -c 50"
  echo "## 结果"
  for t in set get incr lpush; do
    redis-benchmark -p "$PORT" -t "$t" -n 1000000 -c 50 -P 16 -q
  done
} | tee "$OUT"
```

**验证**：跑三轮取中位数；同时用 `pidstat -p PID 1` 看 CPU，用 `/proc/PID/status` 的 `VmRSS` 看内存；再用 `perf top -p PID` 找热点。

```bash
for i in 1 2 3; do redis-benchmark -p 6379 -t get -n 1000000 -c 50 -P 16 -q; done
perf record -F 999 -g -p $(pgrep -f 'myredis --port 6379') -- sleep 10
perf report --stdio --no-children | head -25
redis-cli -p 6379 INFO memory
```

**常见错误**：

1. **客户端先饱和**。`redis-benchmark` 与服务器同机时，客户端可能吃掉一半 CPU；用 `-c 50` 起步，观察两端 `top`。
2. **忽略 loopback 的 RTT 优势**。同机压测的 P99 比真实网络好一个数量级；报告要写「同机 loopback」。
3. **用 `-P 1000` 刷出好看数字**。pipeline 把延迟藏进批量里，P99 失去意义；同时报告无 pipeline 与 `-P 16` 两组。
4. **不预热**。前 10 秒包含页缓存冷启动与 JIT/分支预测预热；丢弃预热段，正式跑 3 次。

**下一步**：B.1 的验收与复盘见 B.1.12；然后进入 B.2，把「页、缓存、日志、恢复」这条线从零搭起来。

### B.1.12 `myredis` 验收与复盘

验收只看证据：RESP 六类输入、命令与 `redis-cli` 比对、10 万 key 延迟、PX 过期、`kill -9` 后 RDB/AOF 恢复、断线增量复制、三轮压测中位数。任何一项只有「代码写了」没有输出，都算未完成。

复盘回答三个问题：**你的 `BGSAVE` 期间 P99 上升了多少？COW 复制的页数是多少？如果重做，你会先做 AOF 还是先做 RDB？** 这三个答案比「功能都跑通了」更能说明你理解了存储。

## B.2 `mydb`：B+ 树、buffer pool、WAL 与恢复

### B.2.1 目标与真实对应物

`mydb` 是一个单文件、页式、带 WAL 的关系存储引擎。它对应 SQLite 的 B-tree + pager + WAL 组合，但只保留最小闭环：

| 阶段 | 交付 | 对应 SQLite 机制 |
|:--|:--|:--|
| 0 | 4 KiB 页、文件头、freelist | `pager.c`、page 1 的数据库头 |
| 1 | buffer pool（CLOCK、pin、脏页） | `pcache.c`、`pager.c` 的页缓存 |
| 2 | B+ 树查找/插入/分裂 | `btree.c`、`balance()` |
| 3 | 删除/借位/合并/根收缩 | `balance_deeper()`、`balance_nonroot()` |
| 4 | WAL（LSN、CRC、组提交） | `wal.c`、WAL 帧格式 |
| 5 | 崩溃恢复（分析/重做/撤销） | `walRecover()`、ARIES |
| 6 | 事务与隔离 | `pager_begin/commit`、锁 |
| 7 | 最小 SQL | `parse.y`、`build.c`、`select.c` |
| 8 | `fio` 与 `kill -9` | `kvtest`、`walcrash` 测试 |

验收命令：

```text
$ make -C mydb test
test_btree: ok
test_wal: ok
test_bp: ok
$ ./mydb init /tmp/demo.db
$ ./mydb exec /tmp/demo.db "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)"
$ ./mydb exec /tmp/demo.db "INSERT INTO users VALUES (1, 'alice', 30)"
$ ./mydb exec /tmp/demo.db "SELECT * FROM users WHERE id = 1"
1|alice|30
```

### B.2.2 页格式与文件布局

每个页 4096 字节，页 0 是元数据页（magic、页大小、页数、freelist 头、根页号），页 1 起是数据页。数据页头 32 字节，槽数组从低地址向高地址长，单元格从页尾向低地址长：

<pre class="layout">
 0        4      6      8     10     12          16          24        28      32
 ┌────────┬──────┬──────┬──────┬──────┬───────────┬───────────┬─────────┬────────┐
 │ magic  │ type │nslots│ free_│ free_│   right   │    lsn    │   crc   │reserved│
 │  u32   │ u16  │ u16  │start │ end  │    u32    │   u64     │  u32    │  u32   │
 └────────┴──────┴──────┴──────┴──────┴───────────┴───────────┴─────────┴────────┘
 32        ┌──────────┬──────────┬──────────┐
           │ slot[0]  │ slot[1]  │ slot[2]  │ ... 槽数组向高地址增长
           ├──────────┴──────────┴──────────┴──────────────────────────────┐
           │                    空闲空间（free_start .. free_end）          │
           ├────────────────────────────────────────────────────────────────┤
           │ cell[2]          │ cell[1]          │ cell[0]                 │
           └──────────────────┴──────────────────┴─────────────────────────┘ 4096
</pre>

读图：插入一个单元格要同时改三处：把单元格写到 `free_end - size`、把偏移写进 `slot[nslots]`、把 `nslots` 加一。任何一个顺序错了，页就会自相矛盾。删除只把槽数组左移并把空间「逻辑」释放；真正的空间回收靠页重建（compact），本章的插入/删除都用「解码 → 修改 → 重新编码」，牺牲一点 CPU 换取正确性。

| 字段 | 长度 | 用途 |
|:--|--:|:--|
| `magic` | 4 | `0x4D594442`（"MYDB"），防止把别的文件当数据库 |
| `type/nslots` | 2+2 | 页类型 / 单元格个数 |
| `free_start/free_end` | 2+2 | 槽数组末尾 / 单元格区起始 |
| `right` | 4 | 叶子的右兄弟；内部页为 0 |
| `lsn` | 8 | 最后一次修改该页的 WAL 记录号 |
| `crc` / `reserved` | 4+4 | 页校验（刷盘时算，crc 字段置 0）；内部页最后一个 child |

**为什么把最后一个 child 放在页头**：内部页有 n 个 key 和 n+1 个 child。若每个 child 都占一个槽，单元格数会与 key 数不一致，`nslots` 的语义变复杂。把 `children[n]` 放进 `reserved`，槽数组只存 `(key, child)` 对，最后一个 child 单独取。这是空间上的小技巧，代价是 `int_load/int_store` 必须记得它。

### B.2.3 Stage 0：页、pager 与 freelist

**目标**：`mydb init` 创建一个 4 KiB 页对齐的文件；`mydb dump` 能读出页 0 的元数据；分配/释放页后重启，freelist 仍然正确。

```text
$ ./mydb init /tmp/demo.db
$ ./mydb info /tmp/demo.db          # 以下为示例输出，未实测
page_size=4096 pages=3 freelist=2 root=1
$ ./mydb alloc /tmp/demo.db
allocated page 2
$ ./mydb info /tmp/demo.db
page_size=4096 pages=3 freelist=0 root=1
```

**关键概念**：`pread`/`pwrite` 是**无偏移共享**的，多个线程可以安全地对同一 fd 做定位读写，不需要 `lseek`（[2.2.2](../part2/ch02.md#sec-2.2.2)）。短读在普通文件上少见，但信号、NFS、块设备仍可能发生；`read_full/pwrite_full` 的循环不能省。freelist 用「空闲页的第一个 4 字节存下一页号」实现，页 0 存头指针；分配与释放都只改页 0 + 一个页，不需要额外文件。

**代码**（`src/pager.c` 的页读写与页初始化；完整版含 `pager_open/alloc/free/sync`）：

```c
/* 页读写：短读/短写 + EINTR 都要处理。 */
int pager_read(struct pager *pg, page_id_t pid, void *page)
{
    if (pid >= pg->npages) { errno = EINVAL; return -1; }
    size_t done = 0;
    while (done < PAGE_SIZE) {
        ssize_t n = pread(pg->fd, (char *)page + done, PAGE_SIZE - done,
                          (off_t)pid * PAGE_SIZE + (off_t)done);
        if (n > 0) done += (size_t)n;
        else if (n == 0) { errno = EIO; return -1; }
        else if (errno == EINTR) continue;
        else return -1;
    }
    return 0;
}

/* 从 freelist 取一页；没有就扩展文件。返回 0 表示失败（0 是元数据页）。 */
page_id_t pager_alloc(struct pager *pg)
{
    if (pg->freelist != INVALID_PAGE) {
        page_id_t pid = pg->freelist;
        void *page = malloc(PAGE_SIZE);
        if (page == NULL) return INVALID_PAGE;
        if (pager_read(pg, pid, page) < 0) { free(page); return INVALID_PAGE; }
        uint32_t next;
        memcpy(&next, page, 4);
        pg->freelist = next;
        memset(page, 0, PAGE_SIZE);
        free(page);
        pg->dirty_meta = 1;
        return pid;
    }
    page_id_t pid = pg->npages++;
    void *zero = calloc(1, PAGE_SIZE);
    if (zero == NULL) return INVALID_PAGE;
    if (pager_write(pg, pid, zero) < 0) { free(zero); pg->npages--; return INVALID_PAGE; }
    free(zero);
    pg->dirty_meta = 1;
    return pid;
}
```

页 0 的编码/解码必须显式按偏移写，不能 `fwrite(struct pager)`：结构体有填充字节，换编译器/平台就变格式。`pager_open` 打开已有文件时先校验 magic 与 `page_size`，不匹配就拒绝，而不是「尽力解析」——损坏的数据库最怕被半懂不懂地修复。

**验证**：

```bash
make -C mydb
./mydb init /tmp/demo.db
./mydb info /tmp/demo.db
./mydb alloc /tmp/demo.db && ./mydb info /tmp/demo.db
./mydb free /tmp/demo.db 2 && ./mydb info /tmp/demo.db | grep freelist
# 页对齐与 magic
stat -c '%s' /tmp/demo.db          # 必须是 4096 的倍数
xxd -l 16 /tmp/demo.db             # 4d59 4442 3030 3031 ...
```

**常见错误**：

1. **用 `lseek` + `read` 代替 `pread`**。多线程共享 fd 时偏移会互相踩；`pread/pwrite` 才是线程安全的。
2. **只写一次 `pwrite` 就当成功**。返回小于 4096 时剩下的是空洞（读到 0），必须循环。
3. **freelist 头存在内存里，不落页 0**。重启后所有空闲页泄漏；`pager_free` 后要 `dirty_meta=1`，`pager_sync` 写回页 0。
4. **页号 0 当普通页分配**。页 0 是元数据，`pager_alloc` 必须从 1 开始；`INVALID_PAGE=0` 同时兼作 freelist 空指针。

**下一步**：每次 `bp_get` 都 `pread` 一次，B+ 树每层一次 I/O，10 万行查询要几十次磁盘读。Stage 1 用固定帧缓存把热页留在内存。

### B.2.4 Stage 1：buffer pool——CLOCK、pin/unpin 与脏页

**目标**：4 个帧的池子能服务 12 个页的随机访问而不越界；被 pin 的页不会被淘汰；脏页在淘汰/关闭时落盘；命中不产生 `pread`。

```text
$ ./mydb bp-test          # 示例输出，未实测
frames=4 pages=12 hit=... miss=... evict=...
test_bp: ok
$ strace -c -e trace=pread64,pwrite64 ./mydb bp-test
% time     calls      syscall
  ...        12        pread64
  ...         1        pwrite64
```

**关键概念**：buffer pool 是「页号 → 帧」的缓存（页缓存与回写见 [2.2.8](../part2/ch02.md#sec-2.2.8)），三个状态位决定一切：`pin`（正在被使用，不能淘汰）、`ref`（CLOCK 的引用位，访问过置 1）、`dirty`（内容与磁盘不同，淘汰前必须写回）。`bp_get` 返回的指针只在 `bp_put` 之前有效；`bp_put` 之后帧可能被淘汰，指针就悬空了。这是本项目最容易出的 UAF。

CLOCK 与 LRU-K 的取舍：CLOCK 每个帧一个引用位，命中置 1，淘汰时扫过引用位为 1 的帧并清零，近似 LRU，O(1)、无链表。LRU-K 记录最近 K 次访问，能识别「扫表」污染，但每个帧要维护历史堆，实现复杂。SQLite 默认用 CLOCK；本章也用 CLOCK，并在 Stage 8 用 `fio` 观察随机读下的命中率。

**代码**（`src/bufpool.c` 的帧、查找与淘汰）：

```c
struct frame {
    page_id_t pid;
    int valid, pin, ref, dirty;
    uint8_t data[PAGE_SIZE];
};

/* 查找用开放寻址（墓碑处理删除）；代码见 src/bufpool.c。 */

static struct frame *pick_victim(struct bp *bp)
{
    for (int scanned = 0; scanned < bp->nframes * 2; scanned++) {
        struct frame *f = &bp->frames[bp->hand];
        bp->hand = (bp->hand + 1) % bp->nframes;
        if (!f->valid) return f;
        if (f->pin > 0) continue;          /* 正在用，跳过 */
        if (f->ref) { f->ref = 0; continue; }  /* 给第二次机会 */
        return f;
    }
    errno = EBUSY;
    return NULL;                           /* 所有帧都被 pin */
}

int bp_get(struct bp *bp, page_id_t pid, void **page)
{
    int idx = hash_find(bp, pid);
    if (idx >= 0) {
        struct frame *f = &bp->frames[idx];
        f->pin++;
        f->ref = 1;
        *page = f->data;
        return 0;
    }
    struct frame *f = pick_victim(bp);
    if (f == NULL) return -1;
    if (f->valid) {
        if (flush_frame(bp, f) < 0) return -1;
        hash_del(bp, f->pid);
        f->valid = 0;
    }
    if (pager_read(bp->pg, pid, f->data) < 0) return -1;
    f->pid = pid;
    f->valid = 1;
    f->pin = 1;
    f->ref = 1;
    f->dirty = 0;
    hash_put(bp, pid, (int)(f - bp->frames));
    *page = f->data;
    return 0;
}

int bp_put(struct bp *bp, page_id_t pid, int dirty)
{
    int idx = hash_find(bp, pid);
    if (idx < 0 || bp->frames[idx].pin <= 0) { errno = EINVAL; return -1; }
    bp->frames[idx].pin--;
    if (dirty) bp->frames[idx].dirty = 1;
    return 0;
}
```

真正的写回顺序由 WAL 决定：如果 `bp->wal` 非空，`flush_frame` 必须先 `wal_flush(page.lsn)` 再 `pwrite`。这条规则叫 **write-ahead**：日志没落盘，数据页不能先落盘，否则崩溃后既没有日志可重做，也看不到新数据。

**验证**：

```bash
# 4 帧访问 12 页，再 pin 住 1 号页访问 2..8，确认 1 号没被淘汰
./mydb bp-test
# 脏页：改 3 号页后直接退出，重启后读回
./mydb dirty-test
# 观测 I/O 次数
strace -c -e trace=pread64,pwrite64,fsync ./mydb bp-test
```

**常见错误**：

1. **`bp_get` 后忘了 `bp_put`**。pin 永远不归零，最终 `pick_victim` 返回 `EBUSY`，整个引擎卡死。
2. **`bp_put` 之后继续用页指针**。帧可能已被别人淘汰并读入别的页；所有修改必须在 `bp_put` 之前完成。
3. **淘汰脏页不先写 WAL**。数据页落盘、日志没落盘，崩溃后无法重做；`flush_frame` 必须先刷日志。
4. **哈希删除把槽置 0**。同一探测链后面的 key 会被截断；要用墓碑或重建。

**下一步**：有了「页的缓存」，就可以在页上建索引。Stage 2 实现 B+ 树的查找、插入与分裂。

### B.2.5 Stage 2：B+ 树查找与插入/分裂

**目标**：10 万行顺序/随机插入后，按主键查找全部命中；页内二分；叶子分裂、内部节点分裂与根分裂都正确；每个叶子的填充率不低于 50%。

```text
$ ./mydb test-btree          # 输出为示例，未实测
insert 100000 rows ... ok
search all ... ok
btree_check: ok
$ ./mydb stats /tmp/demo.db
pages=2084 leaves=2048 height=2 fill=97.6%
```

**关键概念**：B+ 树把所有值放在叶层（定位读写的系统调用见 [2.2.2](../part2/ch02.md#sec-2.2.2)），内部节点只存分隔键，因此范围扫描只需沿叶子右链走。分隔键的定义是「右子树的最小 key」：`key[i] == min(child[i+1])`。查找时在内部页用 `upper_bound`（第一个 `> key`）选 child，相等时走右边；这个细节错了，重复 key 或边界 key 会查不到。

页内二分：叶子用 `lower_bound`（第一个 `>= key`），内部用 `upper_bound`（第一个 `> key`）。两者只差一个比较符，但含义完全不同。分裂阈值来自页容量：叶子单元格 40 字节 + 槽 2 字节，`(4096-32)/42 = 96`；内部单元格 16 字节 + 槽 2 字节，`(4096-32)/18 = 225`。分裂取 `mid = n/2`，叶子左 48 右 49，内部把 `keys[mid]` 推给父节点。

**代码**（`src/btree.c` 的页内单元格操作与插入递归；完整 `insert_rec` 含叶子/内部两条路径）：

```c
static int page_append(void *page, const void *cell, size_t n)
{
    struct page_hdr *h = page;
    if ((size_t)h->free_start + sizeof(uint16_t) > h->free_end) return -1;
    if (n > h->free_end ||
        h->free_end - n < (size_t)h->free_start + sizeof(uint16_t)) return -1;
    h->free_end = (uint16_t)(h->free_end - n);
    memcpy((char *)page + h->free_end, cell, n);
    *slot_at(page, h->nslots) = h->free_end;
    h->nslots++;
    h->free_start = (uint16_t)(h->free_start + sizeof(uint16_t));
    return 0;
}

static int leaf_load(void *page, struct row *rows, int max)
{
    int n = page_nslots(page);
    if (n > max) return -1;
    for (int i = 0; i < n; i++) memcpy(&rows[i], cell_at(page, i), sizeof rows[i]);
    return n;
}

static void leaf_store(void *page, const struct row *rows, int n, page_id_t right)
{
    page_init(page, PT_LEAF);
    ((struct page_hdr *)page)->right = right;
    for (int i = 0; i < n; i++) (void)page_append(page, &rows[i], sizeof rows[i]);
}

static int int_load(void *page, int64_t *keys, page_id_t *children, int max)
{
    int n = page_nslots(page);
    if (n > max) return -1;
    for (int i = 0; i < n; i++) {
        struct int_cell c;
        memcpy(&c, cell_at(page, i), sizeof c);
        keys[i] = c.key;
        children[i] = (page_id_t)c.child;
    }
    children[n] = (page_id_t)((struct page_hdr *)page)->reserved;
    return n;
}

static void int_store(void *page, const int64_t *keys,
                      const page_id_t *children, int n)
{
    page_init(page, PT_INTERNAL);
    ((struct page_hdr *)page)->reserved = children[n];
    for (int i = 0; i < n; i++) {
        struct int_cell c = { keys[i], (int64_t)children[i] };
        (void)page_append(page, &c, sizeof c);
    }
}

/* 插入：叶子返回 split=false 或 (分隔键, 右页)；内部节点把子分裂向上传。 */
static int insert_rec(struct btree *t, page_id_t pid, const struct row *r,
                      struct ins_result *out)
{
    void *page = NULL;
    if (bp_get(t->bp, pid, &page) < 0 || !MAGIC_OK(page)) return -1;
    struct page_hdr *h = page;

    if (h->type == PT_LEAF) {
        struct row rows[LEAF_MAX + 1];
        int n = leaf_load(page, rows, LEAF_MAX);
        int pos = leaf_lower(rows, n, r->id);
        if (pos < n && rows[pos].id == r->id) { bp_put(t->bp, pid, 0); return 1; }

        memmove(&rows[pos + 1], &rows[pos], (size_t)(n - pos) * sizeof rows[0]);
        rows[pos] = *r;
        n++;
        out->split = 0;

        if (n <= LEAF_MAX) {
            page_id_t right = h->right;
            leaf_store(page, rows, n, right);
            return bp_put(t->bp, pid, 1);
        }
        page_id_t rpid;
        void *rpage = NULL;
        if (bp_alloc(t->bp, &rpid, &rpage) < 0) { bp_put(t->bp, pid, 0); return -1; }
        int mid = n / 2;                    /* 左 48，右 49 */
        page_id_t old_right = h->right;
        leaf_store(page, rows, mid, rpid);
        leaf_store(rpage, rows + mid, n - mid, old_right);
        out->split = 1;
        out->key = rows[mid].id;
        out->right = rpid;
        bp_put(t->bp, rpid, 1);
        return bp_put(t->bp, pid, 1);
    }

    if (h->type != PT_INTERNAL) { bp_put(t->bp, pid, 0); return -1; }
    int64_t keys[INT_MAX_KEYS + 2];
    page_id_t children[INT_MAX_KEYS + 3];
    int n = int_load(page, keys, children, INT_MAX_KEYS);
    if (n < 0) { bp_put(t->bp, pid, 0); return -1; }
    int idx = int_upper(keys, n, r->id);

    struct ins_result sub = {0};
    int rc = insert_rec(t, children[idx], r, &sub);
    if (rc != 0) { bp_put(t->bp, pid, 0); return rc; }
    if (!sub.split) return bp_put(t->bp, pid, 0);

    memmove(&keys[idx + 1], &keys[idx], (size_t)(n - idx) * sizeof keys[0]);
    memmove(&children[idx + 2], &children[idx + 1],
            (size_t)(n - idx) * sizeof children[0]);
    keys[idx] = sub.key;
    children[idx + 1] = sub.right;
    n++;
    out->split = 0;

    if (n <= INT_MAX_KEYS) {
        int_store(page, keys, children, n);
        return bp_put(t->bp, pid, 1);
    }
    page_id_t rpid;
    void *rpage = NULL;
    if (bp_alloc(t->bp, &rpid, &rpage) < 0) { bp_put(t->bp, pid, 0); return -1; }
    int mid = n / 2;
    int64_t sep = keys[mid];
    int_store(page, keys, children, mid);
    int_store(rpage, keys + mid + 1, children + mid + 1, n - mid - 1);
    out->split = 1;
    out->key = sep;
    out->right = rpid;
    bp_put(t->bp, rpid, 1);
    return bp_put(t->bp, pid, 1);
}

int btree_insert(struct btree *t, const struct row *r)
{
    struct ins_result res = {0};
    int rc = insert_rec(t, t->root, r, &res);
    if (rc != 0) return rc;
    if (res.split) {                    /* 根分裂：新根只有 1 个 key、2 个 child */
        page_id_t nr;
        void *page = NULL;
        if (bp_alloc(t->bp, &nr, &page) < 0) return -1;
        int64_t key = res.key;
        page_id_t ch[2] = { t->root, res.right };
        int_store(page, &key, ch, 1);
        t->root = nr;
        if (bp_put(t->bp, nr, 1) < 0) return -1;
    }
    return 0;
}
```

根分裂/根收缩只改内存 `t->root`；`btree_set_root()` 还要通过 `bp` 更新页 0 的 root 字段，并把这次元数据修改纳入 WAL，否则重启会回到旧根。

查找从根开始，叶子用 `lower_bound`，内部页用 `upper_bound` 选 child；命中返回 1，未命中返回 0。完整函数见 `src/btree.c`，下降逻辑只有十几行，关键是不要用错边界。

**验证**：单元测试必须比「插入后能查到」更狠：随机插入/删除、重复 key、全删、再插入、逐层自检。

```bash
# 随机 4 万次插入/删除，混合命中与未命中，每 2000 步自检
make -C mydb test-btree
# 期望（作者环境，ASan/UBSan）：
# test_btree2: ok, live=2035 pages=35 free=2
# 用页数验证填充率
./mydb stats /tmp/demo.db
```

**常见错误**：

1. **内部页用 `lower_bound` 下降**。`key == keys[i]` 时应该走右子树；用 `lower_bound` 会走左子树，边界 key 查不到。
2. **叶子分裂后分隔键取左页最后一个 key**。右页的第一个 key 才是右子树的最小值；取错会让查找走错分支。
3. **根分裂忘记更新根页号**。分裂出的两半都正确，但根还指向旧页，重启后丢一半数据；根页号必须持久化（页 0）。
4. **`page_append` 先加 `nslots` 再写单元格**。空间不足时 `nslots` 已经加过，页头与槽数组不一致；先检查空间，再一次性更新三个字段。

**下一步**：插入只考验分裂，删除才考验「借位/合并/根收缩」。Stage 3 把树删到空，并用自检函数验证每一层。

### B.2.6 Stage 3：删除、借位、合并与根收缩

**目标**：删除后每个非根节点的 key 数不低于下限；节点空了能从兄弟借，借不到就合并；根只剩一个 child 时收缩；全删后树仍可插入。

```text
$ ./mydb test-btree-delete
delete 50% ... ok
delete all ... ok
reinsert ... ok
btree_check: ok
$ ./mydb stats /tmp/demo.db
pages=... leaves=... height=1 fill=...
```

**关键概念**：B+ 树删除分两步。先在叶子删掉 key；如果叶子低于半满（`LEAF_MIN=48`），向兄弟**借**一个（兄弟有多余）或**合并**（兄弟也不富余）。合并会把父节点的一个分隔键和两个 child 合成一个，父节点可能因此下溢，于是递归向上。内部节点的下限是 `INT_MIN_KEYS=112`；两个 112 的节点加一个分隔键正好 225，不会超过上限。根是唯一允许少于下限的节点：内部根只剩一个 child 时，把 child 提升为根。

删除的难点不是「删」，而是**父节点的分隔键**。删掉叶子第一个 key 后，父节点里对应的分隔键就过期了。本章在每个内部节点处理完 child 后，统一用 `node_min_key(child[i+1])` 重算所有分隔键。正确但慢（O(keys × height) 次页访问）；生产实现只更新受影响的两个键，或把最小 key 缓存在页头。

**代码**（`src/btree.c` 的 `fix_child` 中叶子借位/合并部分；内部节点逻辑对称）：

```c
static int fix_child(struct btree *t, page_id_t *children, int64_t *keys,
                     int *nkeys, int idx)
{
    void *cpage = NULL;
    if (bp_get(t->bp, children[idx], &cpage) < 0 || !MAGIC_OK(cpage)) return -1;
    struct page_hdr *ch = cpage;

    if (ch->type == PT_LEAF) {
        struct row rows[LEAF_MAX + 1];
        int n = leaf_load(cpage, rows, LEAF_MAX);
        if (n >= LEAF_MIN) { bp_put(t->bp, children[idx], 0); return 0; }
        page_id_t right = ch->right;

        if (idx > 0) {                      /* 先看左兄弟 */
            void *lpage = NULL;
            if (bp_get(t->bp, children[idx - 1], &lpage) < 0) {
                bp_put(t->bp, children[idx], 0); return -1;
            }
            struct row lrows[LEAF_MAX + 1];
            int ln = leaf_load(lpage, lrows, LEAF_MAX);
            page_id_t lright = ((struct page_hdr *)lpage)->right;
            if (ln > LEAF_MIN) {            /* 借最后一个 */
                memmove(&rows[1], &rows[0], (size_t)n * sizeof rows[0]);
                rows[0] = lrows[ln - 1];
                leaf_store(lpage, lrows, ln - 1, lright);
                leaf_store(cpage, rows, n + 1, right);
                bp_put(t->bp, children[idx - 1], 1);
                bp_put(t->bp, children[idx], 1);
                return 0;
            }
            bp_put(t->bp, children[idx - 1], 0);
        }
        if (idx < *nkeys) {                 /* 再看右兄弟 */
            void *rpage = NULL;
            if (bp_get(t->bp, children[idx + 1], &rpage) < 0) {
                bp_put(t->bp, children[idx], 0); return -1;
            }
            struct row rrows[LEAF_MAX + 1];
            int rn = leaf_load(rpage, rrows, LEAF_MAX);
            page_id_t rright = ((struct page_hdr *)rpage)->right;
            if (rn > LEAF_MIN) {            /* 借第一个 */
                rows[n] = rrows[0];
                memmove(&rrows[0], &rrows[1], (size_t)(rn - 1) * sizeof rrows[0]);
                leaf_store(rpage, rrows, rn - 1, rright);
                leaf_store(cpage, rows, n + 1, right);
                bp_put(t->bp, children[idx + 1], 1);
                bp_put(t->bp, children[idx], 1);
                return 0;
            }
            /* 与右兄弟合并：child + right，父节点删一个 key/child */
            memcpy(&rows[n], rrows, (size_t)rn * sizeof rows[0]);
            leaf_store(cpage, rows, n + rn, rright);
            bp_put(t->bp, children[idx + 1], 0);
            bp_free(t->bp, children[idx + 1]);
            memmove(&keys[idx], &keys[idx + 1],
                    (size_t)(*nkeys - idx - 1) * sizeof keys[0]);
            memmove(&children[idx + 1], &children[idx + 2],
                    (size_t)(*nkeys - idx - 1) * sizeof children[0]);
            (*nkeys)--;
            bp_put(t->bp, children[idx], 1);
            return 0;
        }
        /* idx == nkeys，与左兄弟合并；左页存活，child 释放 */
        void *lpage = NULL;
        if (bp_get(t->bp, children[idx - 1], &lpage) < 0) {
            bp_put(t->bp, children[idx], 0); return -1;
        }
        struct row lrows[LEAF_MAX + 1];
        int ln = leaf_load(lpage, lrows, LEAF_MAX);
        memcpy(&lrows[ln], rows, (size_t)n * sizeof rows[0]);
        leaf_store(lpage, lrows, ln + n, right);
        bp_put(t->bp, children[idx], 0);
        bp_free(t->bp, children[idx]);
        memmove(&keys[idx - 1], &keys[idx],
                (size_t)(*nkeys - idx) * sizeof keys[0]);
        memmove(&children[idx], &children[idx + 1],
                (size_t)(*nkeys - idx) * sizeof children[0]);
        (*nkeys)--;
        bp_put(t->bp, children[idx - 1], 1);
        return 0;
    }
    /* 内部节点的借位/合并与上面同构：借位时把父分隔键下移，
     * 合并时把父分隔键 + 右兄弟的 keys/children 并进来。 */
    return fix_internal(t, children, keys, nkeys, idx);   /* 见 src/btree.c */
}

/* 根收缩：内部根 0 个 key 时，唯一的 child 成为新根。 */
int btree_delete(struct btree *t, int64_t id)
{
    int under = 0;
    int rc = delete_rec(t, t->root, id, &under);
    if (rc != 0) return rc;
    void *page = NULL;
    if (bp_get(t->bp, t->root, &page) < 0) return -1;
    struct page_hdr *h = page;
    if (h->type == PT_INTERNAL && h->nslots == 0) {
        page_id_t old = t->root;
        page_id_t child = (page_id_t)h->reserved;
        t->root = child;
        bp_put(t->bp, old, 0);
        bp_free(t->bp, old);
        return 0;
    }
    return bp_put(t->bp, t->root, 0);
}
```

**验证**：用「参考模型」对拍，而不是人眼看输出。维护一个 `present[]` 数组，随机 4 万步插入/删除；每 2000 步调 `btree_check()`，最后全量扫描与数组比对。

```bash
make -C mydb test-btree2
# 作者环境输出：
# test_btree2: ok, live=2035 pages=35 free=2
# 自检覆盖：叶链有序、页内有序、父分隔键 == 右子树最小 key、非根节点填充率
```

**常见错误**：

1. **合并后忘记释放被合并的页**。页泄漏，`freelist` 不增长；`btree_check` 不查这个，要靠页数统计。
2. **借位只搬 key 不搬 child（内部节点）**。父分隔键与 child 数量不再对应，下次查找直接走错页。
3. **根收缩后仍指向旧页**。旧页被释放又复用，根读到别的数据；收缩后立即更新页 0 的 root。
4. **删除不存在的 key 也触发下溢处理**。`delete_rec` 要先判断是否命中，未命中直接返回，不能动树。

**下一步**：树的修改只在内存页里；崩溃时一半页新、一半页旧。Stage 4 用 WAL 把「一次逻辑修改」变成可重放的记录。

### B.2.7 Stage 4：WAL——记录格式、LSN、checksum 与组提交

**目标**：每次页修改先写日志；一条事务的多个页修改共享一次 `fdatasync`；日志记录带 CRC，尾部撕裂能被识别并丢弃；`LSN` 单调递增，页头记录最后修改它的 LSN。

```text
$ ./mydb wal-test
append 3 records ... flushed at lsn=3
$ ./mydb wal-dump /tmp/demo.wal
lsn=1 BEGIN txn=1 prev=0
lsn=2 UPDATE txn=1 page=1 off=0 len=4096 prev=1
lsn=3 COMMIT txn=1 prev=2
$ truncate -s -7 /tmp/demo.wal && ./mydb wal-dump /tmp/demo.wal
lsn=1 ... lsn=2 ... (tail truncated)
```

**关键概念**：WAL 记录的是**物理页的字节变化**（`fsync` 与目录项见 [2.3.7](../part2/ch03.md#sec-2.3.7)）（page_id + offset + before + after），不是 SQL 语句。物理日志的 redo 只要比较页 LSN，简单可靠；缺点是日志量大（本章整页 4 KiB 记两次 = 8 KiB），生产引擎用 physiological logging 只记变化区域。`LSN` 是全局单调的记录号，同时写进页头；恢复时 `page.lsn >= rec.lsn` 就跳过，保证 redo 幂等。

组提交（group commit）：`wal_append` 只把记录放进用户态缓冲并分配 LSN；`wal_flush` 把当前缓冲一次 `write` + 一次 `fdatasync`。一个事务的 N 条更新 + 一条 COMMIT 共享一次 fsync；多个事务同时提交时也能合并。代价是「提交返回」被推迟到 fsync 完成——这正是持久性要付的钱。

记录格式（40 字节头 + 变长 payload）：

| 偏移 | 字段 | 长度 | 说明 |
|:--|:--|--:|:--|
| 0 | `total_len` | 4 | 整条记录长度，用于跳过/检测撕裂 |
| 4 | `crc32` | 4 | 覆盖 `[8, total_len)` |
| 8 | `lsn` | 8 | 全局单调 |
| 16 | `type` | 1 | BEGIN/UPDATE/COMMIT/ABORT/CLR |
| 17 | `pad` | 3 | 对齐 |
| 20 | `txn_id` | 4 | 事务号 |
| 24 | `page_id` | 4 | 页号；BEGIN/COMMIT 为 0 |
| 28 | `offset` | 2 | 页内偏移 |
| 30 | `len` | 2 | 前像/后像长度（整页为 4096） |
| 32 | `prev_lsn` | 8 | 同事务上一条记录，undo 链 |

**代码**（`src/wal.c` 的追加与刷盘）：

```c
uint64_t wal_append(struct wal *w, uint8_t type, uint32_t txn_id,
                    uint32_t page_id, uint16_t offset, uint16_t len,
                    const uint8_t *before, const uint8_t *after,
                    uint64_t prev_lsn)
{
    if ((type == WAL_UPDATE && (before == NULL || after == NULL)) ||
        (type == WAL_CLR && after == NULL))
        return 0;
    size_t plen = type == WAL_UPDATE ? (size_t)len * 2
               : type == WAL_CLR ? len : 0;
    size_t total = WAL_REC_HDR + plen;
    if (total > UINT32_MAX || dbuf_reserve(&w->pending, total) < 0) return 0;

    uint8_t *rec = w->pending.data + w->pending.len;
    uint64_t lsn = w->next_lsn++;
    memset(rec, 0, WAL_REC_HDR);
    put32(rec, (uint32_t)total);
    put64(rec + 8, lsn);
    rec[16] = type;
    put32(rec + 20, txn_id);
    put32(rec + 24, page_id);
    put16(rec + 28, offset);
    put16(rec + 30, len);
    put64(rec + 32, prev_lsn);

    if (type == WAL_UPDATE) {
        memcpy(rec + WAL_REC_HDR, before, len);
        memcpy(rec + WAL_REC_HDR + len, after, len);
    } else if (type == WAL_CLR) {
        memcpy(rec + WAL_REC_HDR, after, len);
    }
    put32(rec + 4, crc32(0, rec + 8, total - 8));

    w->pending.len += total;
    w->pending_last = lsn;
    return lsn;
}

/* lsn 是「至少要刷到这个 LSN」；当前实现整批刷出，语义更强。 */
int wal_flush(struct wal *w, uint64_t lsn)
{
    if (w->pending.len == 0) return 0;
    if (write_full(w->fd, w->pending.data, w->pending.len) < 0) return -1;
    while (fdatasync(w->fd) < 0) if (errno != EINTR) return -1;
    w->pending.len = 0;              /* 失败时保留缓冲，调用者不得继续提交 */
    return 0;
}
```

**验证**：先用 `wal-dump` 人工检查字段，再用 Stage 5 的恢复测试验证语义。

```bash
./mydb wal-test
./mydb wal-dump /tmp/demo.wal
# CRC 必须能抓出翻位
cp /tmp/demo.wal /tmp/bad.wal
printf '\x01' | dd of=/tmp/bad.wal bs=1 seek=100 conv=notrunc
./mydb wal-dump /tmp/bad.wal      # 期望 "stop at lsn=...: crc mismatch"
# 尾部撕裂
truncate -s -5 /tmp/demo.wal && ./mydb wal-dump /tmp/demo.wal
```

**常见错误**：

1. **先写页后写日志**。崩溃后页是新、日志是旧，redo 无法补救；必须 `wal_flush` 完成后再 `pwrite` 页。
2. **CRC 覆盖范围含 crc 字段**。计算时 crc 还是 0，校验时已经是值，永远失败；CRC 必须跳过自身。
3. **`fdatasync` 返回 `EINTR` 当失败**。信号打断要重试；把 `EINTR` 当磁盘错误会让事务无故回滚。
4. **组提交把未提交事务的记录也刷出去**。刷出去不是错误（undo 会处理），但**不能**把 COMMIT 之前的记录当成已提交；恢复要看 COMMIT 记录，不是看日志有没有落盘。

**下一步**：日志有了，崩溃后怎么用它？Stage 5 实现分析、重做、撤销，并用「只写 WAL、不写页」模拟 `kill -9`。

### B.2.8 Stage 5：崩溃恢复——分析、重做、撤销

**目标**：给定一个「页没刷、WAL 完整」的数据库，恢复后已提交事务的修改可见，未提交事务的修改被撤销；恢复可以重复执行（幂等）；WAL 尾部撕裂时丢弃最后半条记录。

```text
$ ./mydb crash-test
pass1: redone=2 undone=1 losers=1 txns=2
pass2: redone=0 undone=0 losers=0
test_wal: ok
```

**关键概念**：ARIES 三步。**分析**扫日志，重建事务表（谁提交、谁活跃）。**重做**从日志开头（教学版省去脏页表；生产 ARIES 从最小 recLSN 开始），对每条 UPDATE/CLR，若 `page.lsn < rec.lsn` 就应用后像并更新页 LSN；重复执行安全。**撤销**从每个败者（活跃事务）的最后一条记录沿 `prev_lsn` 回退，应用前像，并为每次撤销写一条 CLR（补偿日志记录）；CLR 也要先落盘再改页。最后给每个败者写 ABORT。

为什么需要 CLR：如果撤销到一半又崩溃，下次恢复不能 blindly 再撤销一遍——CLR 记录了「这一步已经补偿过」，并且它的 `prev_lsn` 指向下一条待撤销记录。本章的 CLR 只存恢复像，`prev_lsn` 兼作 undo-next。

**代码**（`src/recovery.c` 的核心；`txn_get`、`page_lsn`、`page_set_lsn` 是十余行小助手，见同文件）：

```c
int recovery_run(struct pager *pg, const char *wal_path, struct recovery_stats *st)
{
    struct wal_rec *recs = NULL;
    int n = 0;
    void *arena = NULL;
    struct wal w;
    struct txn txns[256];
    int ntxn = 0;
    memset(st, 0, sizeof *st);
    memset(txns, 0, sizeof txns);

    if (wal_load(wal_path, &recs, &n, &arena) < 0) return -1;
    st->nrecords = n;
    if (n == 0) { free(recs); free(arena); return 0; }

    /* 1. 分析 */
    for (int i = 0; i < n; i++) {
        struct txn *t = txn_get(txns, &ntxn, recs[i].txn_id);
        if (t == NULL) { free(recs); free(arena); return -1; }
        switch (recs[i].type) {
        case WAL_BEGIN:  t->state = 0; t->last_lsn = recs[i].lsn; break;
        case WAL_UPDATE:
        case WAL_CLR:    t->last_lsn = recs[i].lsn; break;
        case WAL_COMMIT: t->state = 1; t->last_lsn = recs[i].lsn; break;
        case WAL_ABORT:  t->state = 2; t->last_lsn = recs[i].lsn; break;
        default: break;
        }
    }
    st->ntxn = ntxn;

    /* 2. 重做：页 LSN < 记录 LSN 才应用 */
    for (int i = 0; i < n; i++) {
        if (recs[i].type != WAL_UPDATE && recs[i].type != WAL_CLR) continue;
        uint8_t page[PAGE_SIZE];
        if (pager_read(pg, recs[i].page_id, page) < 0) goto fail;
        if (page_lsn(page) >= recs[i].lsn) continue;
        if ((size_t)recs[i].offset + recs[i].len > PAGE_SIZE) goto fail;
        memcpy(page + recs[i].offset, recs[i].after, recs[i].len);
        page_set_lsn(page, recs[i].lsn);
        if (pager_write(pg, recs[i].page_id, page) < 0) goto fail;
        st->nredo++;
    }

    /* 3. 撤销：所有败者按 LSN 全局降序回退，先写 CLR 再改页 */
    if (wal_open(&w, wal_path) < 0) goto fail;
    int progress = 1;
    while (progress) {
        progress = 0;
        for (int i = n - 1; i >= 0; i--) {
            struct wal_rec *r = &recs[i];
            struct txn *t = txn_get(txns, &ntxn, r->txn_id);
            if (t == NULL) goto fail_wal;
            if (t->state != 0 || r->lsn != t->last_lsn) continue;

            if (r->type == WAL_BEGIN) { t->last_lsn = 0; progress = 1; continue; }
            if (r->type == WAL_CLR) { t->last_lsn = r->prev_lsn; progress = 1; continue; }
            if (r->type != WAL_UPDATE) continue;

            uint8_t page[PAGE_SIZE];
            if (pager_read(pg, r->page_id, page) < 0) goto fail_wal;
            memcpy(page + r->offset, r->before, r->len);

            uint64_t clr = wal_append(&w, WAL_CLR, r->txn_id, r->page_id,
                                      r->offset, r->len, NULL, r->before,
                                      r->prev_lsn);
            if (clr == 0 || wal_flush(&w, clr) < 0) goto fail_wal;
            page_set_lsn(page, clr);
            if (pager_write(pg, r->page_id, page) < 0) goto fail_wal;
            st->nundo++;
            t->last_lsn = r->prev_lsn;
            progress = 1;
        }
    }
    for (int i = 0; i < ntxn; i++) {
        if (txns[i].state != 0) continue;
        st->losers++;
        uint64_t a = wal_append(&w, WAL_ABORT, txns[i].id, 0, 0, 0, NULL, NULL,
                                txns[i].last_lsn);
        if (a == 0 || wal_flush(&w, a) < 0) goto fail_wal;
    }
    wal_close(&w);
    if (pager_sync(pg) < 0) goto fail;
    free(recs); free(arena);
    return 0;
fail_wal:
    wal_close(&w);
fail:
    free(recs); free(arena);
    return -1;
}
```

**验证**：测试要覆盖三种状态：已提交、未提交、恢复两次。

```bash
make -C mydb test-wal
# pass1: redone=2 undone=1 losers=1 txns=2
# pass2: redone=0 undone=0 losers=0
# 手工制造尾部撕裂：截掉 7 字节，重新恢复，已提交事务仍应在
truncate -s -7 /tmp/demo.wal && ./mydb recover /tmp/demo.db
./mydb exec /tmp/demo.db "SELECT * FROM users WHERE id = 1"
# 用 kill -9 注入（Stage 8 的脚本）
```

**常见错误**：

1. **重做不比较页 LSN**。恢复两次会把已提交的更新再应用一遍；对「覆盖写」看不出，对 `INCR` 类逻辑就是灾难。
2. **撤销按事务分组，而不是按全局 LSN 降序**。两个事务改同一页时，撤销顺序错会留下中间像；必须全局降序。
3. **先改页后写 CLR**。撤销中途崩溃，页已经回退但 CLR 不在，下次恢复无法判断这一步是否补偿过；CLR 必须先落盘。
4. **分析时把 COMMIT 之后的记录算进事务**。事务在 COMMIT 处已经结束，后续 LSN 属于别的事务；事务表要按 txn_id 分开。

**下一步**：恢复保证「单条修改」不丢，但多条修改要作为一个原子单元。Stage 6 用事务把 BEGIN/COMMIT 包起来，并讨论隔离级别。

### B.2.9 Stage 6：事务与隔离——单写锁与快照的取舍

**目标**：`BEGIN; INSERT; INSERT; COMMIT` 要么全可见、要么全不可见；并发读在写事务提交前看不到中间状态。`ROLLBACK` 复用恢复的 undo 路径，作为延伸不在此验收。

```text
$ ./mydb exec /tmp/demo.db "BEGIN"
$ ./mydb exec /tmp/demo.db "INSERT INTO users VALUES (2, 'bob', 25)"
$ ./mydb exec /tmp/demo.db "COMMIT"
$ ./mydb exec /tmp/demo.db "SELECT * FROM users WHERE id = 2"
2|bob|25
```

**关键概念**：隔离级别是「并发事务之间能看到彼此多少」的契约（锁与死锁见 [2.13.6](../part2/ch13.md#sec-2.13.6)）。本章用**单写锁 + 读写锁**：

| 方案 | 隔离级别 | 读是否阻塞写 | 实现成本 | 适用 |
|:--|:--|:--|:--|:--|
| 全库写锁（本章） | 串行化 | 是 | 最低 | 单机、低并发 |
| 读写锁 + 语句级快照 | 读已提交 | 读不阻塞写 | 中 | 读多写少 |
| MVCC（版本链） | 快照隔离 | 否 | 高 | 高并发 |
| 两阶段锁（2PL） | 串行化 | 是 | 中高 | 强一致 |

写事务从 `BEGIN` 到 `COMMIT` 持有写锁，读者在语句开始时拿读锁；这比「读已提交」更强（串行化），代价是读写互相阻塞。MVCC 的做法是给每行加版本号，读者看快照，写者写新版本；空间和 GC 复杂度换并发。本章选简单方案，并在 B.5 给出继续做的方向。

**代码**（`src/txn.c`）：

```c
struct txn {
    uint64_t id;
    uint64_t last_lsn;
    int active;
};

static pthread_rwlock_t g_lock = PTHREAD_RWLOCK_INITIALIZER;
static uint64_t g_next_txn = 1;

int txn_begin(struct db *db, struct txn **out)
{
    struct txn *tx = calloc(1, sizeof *tx);
    if (tx == NULL) return -1;
    if (pthread_rwlock_wrlock(&g_lock) != 0) { free(tx); return -1; }
    tx->id = g_next_txn++;
    tx->active = 1;
    tx->last_lsn = wal_append(db->wal, WAL_BEGIN, tx->id, 0, 0, 0, NULL, NULL, 0);
    if (tx->last_lsn == 0) {
        pthread_rwlock_unlock(&g_lock);
        free(tx);
        return -1;
    }
    *out = tx;
    return 0;
}
```

提交点只有一行语义：`wal_append(COMMIT)` → `wal_flush`。**只有 `wal_flush` 返回成功，才向客户端回 OK**；随后 `bp_flush_all` 可以把脏页慢慢刷出去（也可以留给检查点）。回滚要复用恢复的 undo 代码：逐条读本事务的 UPDATE、写 CLR、改页，最后写 ABORT；不要只改内存——回滚后崩溃，恢复会把未提交的修改再撤销一遍，而内存里已经改过的页可能被当成新状态。运行时回滚的完整实现作为延伸，见 `src/txn.c` 的骨架。

**验证**：两个终端，一个开事务写、一个读；用 `SELECT` 观察阻塞与可见性。

```bash
# 终端 A
./mydb exec /tmp/demo.db "BEGIN"
./mydb exec /tmp/demo.db "INSERT INTO users VALUES (3, 'carol', 41)"
# 终端 B：应阻塞到 A 提交（串行化），或在读已提交实现下看到旧值
time ./mydb exec /tmp/demo.db "SELECT * FROM users WHERE id = 3"
# 终端 A
./mydb exec /tmp/demo.db "COMMIT"
# 终端 B 再查：应看到 carol
```

**常见错误**：

1. **`BEGIN` 不拿锁，`COMMIT` 才拿**。两个写事务会交叉修改同一页，WAL 的 undo 链也交叉；写锁必须覆盖整个事务。
2. **读事务在语句之间释放锁**。这已经是「读已提交」，不是快照隔离；如果业务要求可重复读，要在事务开始时拿快照。
3. **`fsync` 之前返回提交成功**。持久性承诺的是「COMMIT 返回后崩溃不丢」；先返回再刷盘，等于骗调用者。
4. **回滚只改内存不写日志**。回滚后崩溃，恢复会把未提交的修改当成活跃事务再 undo 一遍；运行时回滚也要写 CLR。

**下一步**：引擎能存能恢复了，但用户不能写 C 调 `btree_insert`。Stage 7 加一个最小 SQL 层，把 `CREATE/INSERT/SELECT` 翻译成页操作。

### B.2.10 Stage 7：最小 SQL 子集——`CREATE`/`INSERT`/`SELECT`

**目标**：支持单表的三条语句；主键冲突、类型错误、语法错误都返回明确错误；`SELECT` 支持 `WHERE id = N` 与全表扫描。

```text
$ ./mydb exec /tmp/demo.db "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)"
OK
$ ./mydb exec /tmp/demo.db "INSERT INTO users VALUES (1, 'alice', 30)"
OK
$ ./mydb exec /tmp/demo.db "INSERT INTO users VALUES (1, 'bob', 20)"
Error: UNIQUE constraint failed: users.id
$ ./mydb exec /tmp/demo.db "SELECT id, name FROM users WHERE age > 25"
1|alice
```

**关键概念**：SQL 层做三件事（错误路径的约定见 [2.1.3](../part2/ch01.md#sec-2.1.3)）：**词法**（标识符、整数、字符串、标点）、**语法**（递归下降，`CREATE`/`INSERT`/`SELECT` 三个入口）、**执行**（把 AST 变成 btree 调用）。本章不支持表达式树、JOIN、索引选择；`WHERE` 只认 `column op literal`，`op` 支持 `= > < >= <=`。表结构固定为 `users(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)`，`CREATE TABLE` 只校验列定义并把 schema 写进页 0 的保留区。

词法器的关键是**不分配**：token 指向原 SQL 字符串，长度单独存；字符串字面量**不支持** `''` 转义（教学版限制）；解析器用「当前 token + `next()`」的单 token 前瞻，错误信息带位置。

**代码**（`src/sql.c` 的词法与 INSERT 入口；CREATE/SELECT 入口同构，见同文件）：

```c
enum tok { TK_EOF, TK_ID, TK_INT, TK_STR, TK_PUNCT, TK_ERR };

struct lexer {
    const char *p;
    enum tok type;
    const char *text;
    size_t len;
    int64_t ival;
};

static void next(struct lexer *lx)
{
    while (*lx->p == ' ' || *lx->p == '\t' || *lx->p == '\n') lx->p++;
    lx->text = lx->p;
    lx->len = 0;
    if (*lx->p == '\0') { lx->type = TK_EOF; return; }
    if (*lx->p == '\'') {                 /* 单引号字符串；不支持 '' 转义，遇到下一个 ' 即结束 */
        lx->p++;
        lx->text = lx->p;
        while (*lx->p && *lx->p != '\'') lx->p++;
        lx->len = (size_t)(lx->p - lx->text);
        if (*lx->p == '\'') lx->p++;
        lx->type = TK_STR;
        return;
    }
    if (*lx->p >= '0' && *lx->p <= '9') {
        int64_t v = 0;
        while (*lx->p >= '0' && *lx->p <= '9') v = v * 10 + (*lx->p++ - '0');
        lx->ival = v; lx->len = (size_t)(lx->p - lx->text); lx->type = TK_INT;
        return;
    }
    if (isalpha((unsigned char)*lx->p) || *lx->p == '_') {
        while (isalnum((unsigned char)*lx->p) || *lx->p == '_') lx->p++;
        lx->len = (size_t)(lx->p - lx->text); lx->type = TK_ID;
        return;
    }
    if (strchr("(),;=<>", *lx->p)) { lx->p++; lx->len = 1; lx->type = TK_PUNCT; return; }
    lx->type = TK_ERR;
}

static int kw(struct lexer *lx, const char *s)
{
    size_t n = strlen(s);
    return lx->type == TK_ID && lx->len == n &&
           strncasecmp(lx->text, s, n) == 0;
}

/* INSERT INTO users VALUES (1, 'alice', 30) */
static int parse_insert(struct lexer *lx, struct db *db)
{
    next(lx);                                  /* INSERT */
    if (!kw(lx, "into")) return sql_error("expected INTO");
    next(lx);
    if (lx->type != TK_ID) return sql_error("expected table name");
    next(lx);
    if (!kw(lx, "values")) return sql_error("expected VALUES");
    next(lx);
    if (lx->type != TK_PUNCT || *lx->text != '(') return sql_error("expected (");
    next(lx);

    struct row r = {0};
    if (lx->type != TK_INT) return sql_error("id must be integer");
    r.id = lx->ival;
    next(lx);
    if (lx->type != TK_PUNCT || *lx->text != ',') return sql_error("expected ,");
    next(lx);
    if (lx->type != TK_STR || lx->len >= sizeof r.name) return sql_error("name too long");
    memcpy(r.name, lx->text, lx->len);
    next(lx);
    if (lx->type != TK_PUNCT || *lx->text != ',') return sql_error("expected ,");
    next(lx);
    if (lx->type != TK_INT) return sql_error("age must be integer");
    r.age = (int32_t)lx->ival;
    next(lx);
    if (lx->type != TK_PUNCT || *lx->text != ')') return sql_error("expected )");

    int rc = btree_insert(&db->tree, &r);
    if (rc == 1) return sql_error("UNIQUE constraint failed: users.id");
    return rc == 0 ? 0 : sql_error("insert failed");
}
```

`SELECT` 的执行有两条路：`WHERE id = N` 直接 `btree_search`；否则 `btree_scan` 全表扫描，回调里做 `age/name` 过滤。执行器只负责把回调命中的行按 `a|b|c` 打印，不做投影优化。

**验证**：

```bash
make -C mydb test-sql
./mydb exec /tmp/demo.db "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)"
./mydb exec /tmp/demo.db "INSERT INTO users VALUES (1, 'alice', 30)"
./mydb exec /tmp/demo.db "INSERT INTO users VALUES (1, 'bob', 20)"   # UNIQUE 错误
./mydb exec /tmp/demo.db "SELECT * FROM users WHERE id = 1"
./mydb exec /tmp/demo.db "SELECT id, name FROM users WHERE age > 25"
./mydb exec /tmp/demo.db "SELEC * FROM users"                        # 语法错误，非崩溃
```

**常见错误**：

1. **把 token 当 NUL 结尾字符串**。`lx->text` 指向 SQL 原文，后面还有字符；所有比较用 `len` + `strncasecmp`。
2. **误以为支持 `''` 转义**。本章词法器遇到第二个 `'` 就结束，`'O''Brien'` 会被截断；要么实现双引号转义，要么在文档里明确拒绝。
3. **主键冲突返回通用错误**。SQL 层要把 `btree_insert` 的 1 翻译成 `UNIQUE constraint failed`，否则用户不知道为什么失败。
4. **`WHERE` 只做字符串比较**。`age > 25` 必须按整数比较；把 `25` 当字符串会得到 `"9" > "25"` 这种错误结果。

**下一步**：功能闭环了，但没有性能与崩溃数据。Stage 8 用 `fio` 测底层 I/O，用 `kill -9` 注入崩溃，给出恢复时间与丢数据窗口。

### B.2.11 Stage 8：`fio` 压测与 `kill -9` 崩溃注入

**目标**：给出「4K 随机读 / 1M 顺序写 + 每次 fsync」两组底层数据；用脚本在写入过程中 `kill -9`，重启后验证已提交事务不丢、未提交事务不出现；记录恢复耗时。

```text
$ fio --name=randread --ioengine=libaio --direct=1 --rw=randread \
      --bs=4k --size=1G --numjobs=4 --iodepth=32 --runtime=30 --time_based \
      --group_reporting
randread: IOPS=... , BW=...MiB/s, clat p99=...us
$ ./bench/crash.sh 20
run 1: committed=1000 visible=1000 recovery_ms=...
run 2: committed=1000 visible=1000 recovery_ms=...
```

以上数字是**模板，未实测**；`fio` 结果取决于盘型、`direct=1`、文件系统与内核。

**关键概念**：`fio` 测的是**块层/文件系统**（`O_DIRECT` 见 [2.3.8](../part2/ch03.md#sec-2.3.8)），不是你的 B+ 树；它给你「这台机器的 4 KiB 随机读 IOPS 上限」，用来解释你的引擎为什么只能跑到某个数。`--fsync=1` 测的是每条写都同步的代价，对应 `appendfsync always` / WAL 组提交关闭的场景。`kill -9` 注入的是**进程崩溃**，不是断电：页缓存仍然存在，所以它能验证日志协议与恢复逻辑，但不能验证「掉电后磁盘缓存撒谎」——后者需要 `dm-flakey` 或断电测试机。

**代码**（`bench/crash.sh` 的核心循环）：

```bash
#!/usr/bin/env bash
set -euo pipefail
DB=/tmp/crash.db; ROUNDS=${1:-10}
rm -f "$DB" "$DB.wal"; ./build/mydb init "$DB"
for r in $(seq 1 "$ROUNDS"); do
  ./build/mydb workload "$DB" --rows 1000 --txn-size 10 & pid=$!
  sleep "0.$((RANDOM % 9 + 1))"
  kill -9 "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
  t0=$(date +%s%N); ./build/mydb recover "$DB"; t1=$(date +%s%N)
  c=$(./build/mydb count-committed "$DB"); v=$(./build/mydb count-visible "$DB")
  echo "run $r: committed=$c visible=$v recovery_ms=$(( (t1-t0)/1000000 ))"
  [ "$v" -eq "$c" ] || { echo "FAIL: visible($v) != committed($c)"; exit 1; }
done
```

**验证**：

```bash
# 底层基线
fio --name=randread --ioengine=libaio --direct=1 --rw=randread --bs=4k \
    --size=1G --numjobs=4 --iodepth=32 --runtime=30 --time_based --group_reporting
fio --name=seqwrite --ioengine=psync --rw=write --bs=1M --size=1G \
    --fsync=1 --runtime=30 --time_based --group_reporting
# 引擎吞吐
./build/mydb bench --rows 100000 --txn-size 1
./build/mydb bench --rows 100000 --txn-size 100
# 崩溃注入 10 轮
./bench/crash.sh 10
# 恢复后自检
./build/mydb check /tmp/crash.db
```

报告模板（填实测值）：

```markdown
# mydb 性能与崩溃报告

## 环境
- CPU/内存/内核：
- 磁盘：NVMe/SATA；文件系统：ext4/xfs；`fio --version`：
- 编译：gcc 13 -O2；页大小 4 KiB

## 基线（fio，30 s，重复 3 次取中位数）
- 4K 随机读 qd32：IOPS ___ / BW ___ / clat p99 ___；1M 顺序写 fsync=1：同上

## 引擎
| 事务大小 | TPS | p50 | p99 | WAL MB/s | 恢复 ms |
|--:|--:|--:|--:|--:|--:|

## 崩溃
| 轮次 | 已提交 | 可见 | 丢失 | 恢复 ms |
|--:|--:|--:|--:|--:|

## 结论
- 瓶颈：fsync / B+ 树分裂 / buffer pool 命中率
```

**常见错误**：

1. **`kill -9` 后马上 `rm` 数据库**。你还没看恢复日志；先 `cp` 一份现场，再恢复。
2. **把 `kill -9` 当断电**。页缓存还在，WAL 可能已在缓存里；它能测逻辑，不能测硬件写缓存。
3. **用 `fio` 测缓存而不是盘**。忘了 `--direct=1`，读全在页缓存里，IOPS 虚高。
4. **崩溃脚本只校验 `visible <= committed`**。恢复丢掉了已提交事务也会通过；必须断言 `visible == committed`。

**下一步**：B.2 结束。B.3 把 `myredis` 与 `mydb` 拼成一个 cache-aside 演示，验证两条线能一起工作。

## B.3 两条线如何拼成一个演示

`myredis` 是缓存，`mydb` 是持久层。把两者拼起来，就得到一个最小的 **cache-aside** 服务：读先查缓存，未命中查数据库并回填；写先落库，再删缓存。

<pre class="layout">
 client ──GET──▶ myredis ──hit──▶ 返回（不碰 mydb）
                    │ miss
                    ▼
                  mydb ──SELECT──▶ B+ 树/WAL ──▶ 回填 SET key row EX 60 ──▶ client
</pre>

读路径的三条纪律：

1. **缓存未命中才查库**，查库结果回填时带 TTL，避免冷数据永久占内存；
2. **空结果也缓存**（短 TTL），否则同一不存在的 key 会反复打库（穿透）；
3. **回填用 SET，不用 SETNX**：并发回填时后写者覆盖先写者，但两者值相同；如果要避免惊群，用 `SET NX` + 短 TTL 的占位。

写路径：先 `mydb` 提交，再 `DEL user:1`。顺序不能反——先删缓存再写库，中间窗口的读会把旧值回填，形成长期脏数据。删除失败要重试或记日志，不能吞掉。

**演示脚本**（`demo/cache_aside.sh`）：

```bash
#!/usr/bin/env bash
set -euo pipefail
DB=${DB:-/tmp/app.db}; PORT=${PORT:-6379}
REDIS="redis-cli -p $PORT"
MYDB=./mydb/build/mydb

get_user() {
  local id=$1 v
  v=$($REDIS GET "user:$id" || true)
  if [ -n "$v" ]; then echo "cache hit: $v"; return; fi
  v=$($MYDB exec "$DB" "SELECT id, name, age FROM users WHERE id = $id")
  if [ -n "$v" ]; then
    $REDIS SET "user:$id" "$v" EX 60 >/dev/null
    echo "cache miss -> db: $v"
  else
    echo "not found"
  fi
}

# 写路径：先落库，再删缓存
put_user() { $MYDB exec "$DB" "INSERT INTO users VALUES ($1, '$2', $3)"; $REDIS DEL "user:$1" >/dev/null; }
```

演示顺序：

```bash
./myredis/build/myredis --port 6379 &
$MYDB init "$DB"
$MYDB exec "$DB" "CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, age INTEGER)"
put_user 1 alice 30
get_user 1        # cache miss -> db: 1|alice|30
get_user 1        # cache hit: 1|alice|30
$REDIS TTL user:1 # (integer) 59
put_user 2 bob 25
get_user 2        # cache miss -> db: 2|bob|25（新行，缓存已删）
kill -9 %1        # 缓存没了，数据库还在
./myredis/build/myredis --port 6379 &
get_user 2        # cache miss -> db: 2|bob|25；数据没丢
```

预期输出：`cache miss -> db: 1|alice|30` → `cache hit: 1|alice|30` → 写后 `cache miss -> db: 2|bob|25`；`kill -9` 重启后仍是 `2|bob|25`。

**一致性边界**：这套组合给的是「最终一致」——写后删缓存成功即收敛；删除失败、或删除后旧读回填，都会留下脏数据。生产做法是**延迟双删**（写后删、延迟几百毫秒再删）、**订阅 binlog 失效**（canal/Debezium），或把缓存写也纳入同一条 WAL（例如 Redis 的 AOF + 数据库的 outbox）。本章不实现分布式事务；你只需要能说清：**哪一段时间窗口可能读到旧值，为什么可以接受**。

**故障演练**（各做一次并记录）：给 10 万个 key 同一秒过期，观察 `mydb` 被回源打满（雪崩）；请求大量不存在的 id，观察 B+ 树全 miss（穿透）；手工改库不删缓存，观察旧值（不一致）。三种现象对应三种修复：TTL 加随机抖动、空值短缓存、写后删缓存 + 重试。

## B.4 验收清单

逐项打勾，每一项都要有**命令与输出**作为证据；没有证据的算未完成。

| # | 检查项 | 通过标准 | 证据 |
|--:|:--|:--|:--|
| 1 | RESP + 命令 | 6 类输入/逐字节切分；5 命令与 `redis-cli` 一致 | `make -C myredis test` |
| 2 | 结构与过期 | 10 万 key 不线性退化；惰性 + 定期采样 | `benchmark` + `PTTL` |
| 3 | RDB + AOF | `kill -9` 后 key/类型/TTL 一致；尾部截断可加载 | 重启/截断测试 |
| 4 | 复制 | 全量 + 断线增量；从库只读 | 两实例 + `INFO replication` |
| 5 | 页与缓存 | 页对齐；freelist 正确；pin 不被淘汰；脏页落盘 | `mydb info` + `test_bp` |
| 6 | B+ 树 | 4 万步随机增删 + 逐层自检 + 全删/重建 | `test_btree2` |
| 7 | WAL + 恢复 | CRC 抓翻位；已提交保留、未提交撤销、二次恢复幂等 | `wal-dump` + `test_wal` |
| 8 | 事务 + SQL | 写锁覆盖事务；三语句 + 唯一约束 + 语法错误不崩 | 两终端 + `test-sql` |
| 9 | 压测 | 基线、梯度、P50/P99、错误率、资源 | `bench/report.md` |
| 10 | 崩溃注入 | 10 轮 `kill -9`，`visible <= committed` | `bench/crash.sh` |
| 11 | sanitizer + 文档 | ASan/UBSan 零报告；陌生人 10 分钟能跑 | `make asan` + `README.md` |

评分按[项目总览](overview.md)第 6 节的六维表。**功能满分但恢复测试不过，按 0 分处理**——存储引擎的第一美德是崩溃后数据还对。

## B.5 延伸与母本对应

**继续做的四个方向**：

1. **LRU-K / ARC 替换 CLOCK**：用 `fio` 的随机读做对比，解释命中率与扫描污染。
2. **MVCC**：给每行加 `xmin/xmax`，读者拿快照，写者不阻塞读者；这是从「串行化」走到「快照隔离」的关键一步。
3. **检查点（checkpoint）**：定期把脏页刷盘并记录 `checkpoint_lsn`，恢复只需从检查点开始，缩短启动时间。
4. **崩溃一致性测试自动化**：用 `dm-flakey` 或 QEMU 断电注入，覆盖「日志落盘、数据页没落盘」的所有排列。

**母本对应**：

| 母本 | 章节 | 本书落点 | 程度 |
|:--|:--|:--|:--|
| Kerrisk | 第 44 章 管道和 FIFO | B.1 的阻塞/短写语义对照；2.14 的读写规则 | 背景 |
| Kerrisk | 第 49 章 内存映射 | B.1 Stage 5 的 `fork`+COW 快照；2.3.4 的 `mmap` | 完整 |
| Kerrisk | 第 55 章 文件加锁 | mydb 的单实例锁、B.2 Stage 6 的锁顺序 | 部分 |
| Kerrisk | 第 56–63 章 socket / 终端 / 备选 I/O | B.1 Stage 0/7 的事件循环、复制连接与 epoll 对照 | 完整 |
| OSTEP | 第 41 章 局部性与快速文件系统 | B.2 Stage 1 的 buffer pool、Stage 8 的 `fio` | 完整 |
| OSTEP | 第 39–40 章 文件与目录、文件系统实现 | B.2 的页格式、inode/目录对照、freelist | 完整 |
| OSTEP | 第 43 章 日志结构文件系统 | B.1 Stage 6 的 AOF、B.2 的 WAL 顺序写 | 部分 |
| OSTEP | 第 42 章 崩溃一致性：FSCK 与日志 | B.2 Stage 4–5 的 WAL、redo/undo、CLR | 完整 |
| OSTEP | 第 44 章 数据完整性与保护 | B.2 的页 CRC、WAL CRC、checksum 取舍 | 完整 |

**与正文的接口**：本章的代码只用 [2.1](../part2/ch01.md#sec-2.1.3)–[2.3](../part2/ch03.md#sec-2.3.7) 的系统调用、[2.12](../part2/ch12.md#sec-2.12.1)–[2.13](../part2/ch13.md#sec-2.13.6) 的线程与锁；网络部分复用 2.16–2.18 的接口，内核侧回看 3.12–3.13 的 VFS 与块层。等这些章节发布后，把链接补全即可，不影响代码。

> **下一站**：如果只做了一条线，去补另一条的 Stage 0–2；两条路线都亲手写过，才能在「Redis 还是 SQLite」的问题上给出有依据的回答。
