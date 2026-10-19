# 工程手册：构建、测试、压测与交付

项目能不能算「做完」，不取决于代码能不能跑，而取决于**别人能不能复现你的结果**。这本手册给出四条主线的统一工程基线：构建、测试、压测、交付。所有项目页都默认你已经按这里的方式搭好骨架。

## 1. 工具链基线

| 工具 | 版本 | 用途 |
|:--|:--|:--|
| GCC / Clang | 13 / 18 | C17 编译 |
| Make | 4.3 | 构建 |
| CMake | 3.28 | 跨平台构建（可选） |
| gdb | 14 | 调试 |
| valgrind | 3.22 | 内存/线程检查 |
| sanitizers | GCC 13 内置 | ASan/UBSan/TSan |
| perf | 6.8 | 性能采样 |
| bpftrace | 0.20 | 内核追踪 |
| wrk / hey | 最新 | HTTP 压测 |
| fio | 3.36 | 存储压测 |
| iperf3 | 3.16 | 网络带宽 |
| hyperfine | 1.18 | 命令基准 |
| shellcheck | 0.9 | Shell 静态检查 |

安装：

```bash
sudo apt -y install build-essential make cmake gdb valgrind linux-tools-common \
  linux-tools-$(uname -r) bpftrace fio iperf3 shellcheck hyperfine
# wrk 需要源码编译或 snap；hey 可用 go install
```

## 2. 构建：一个够用的 Makefile

不要为每个项目重写构建。下面这份模板支持：调试/发布、sanitizer、依赖头文件、并行构建、清理。

```makefile
# Makefile — 适用于中小型 C 项目
CC      ?= cc
CSTD    ?= -std=c17
WARN    ?= -Wall -Wextra -Wpedantic -Wshadow -Wconversion
DEFS    ?= -D_GNU_SOURCE
OPT     ?= -O2 -g
CFLAGS  ?= $(CSTD) $(WARN) $(DEFS) $(OPT)
LDFLAGS ?=
LDLIBS  ?= -pthread

SRC_DIR := src
OBJ_DIR := build
BIN     := $(OBJ_DIR)/app
SRCS    := $(wildcard $(SRC_DIR)/*.c)
OBJS    := $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
DEPS    := $(OBJS:.o=.d)

.PHONY: all clean test asan tsan release

all: $(BIN)

$(BIN): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -MMD -MP -c -o $@ $<

-include $(DEPS)

asan: CFLAGS += -fsanitize=address,undefined -fno-omit-frame-pointer -O1
asan: LDFLAGS += -fsanitize=address,undefined
asan: clean all

tsan: CFLAGS += -fsanitize=thread -fno-omit-frame-pointer -O1
tsan: LDFLAGS += -fsanitize=thread
tsan: clean all

release: OPT := -O3 -DNDEBUG -g
release: clean all

test: all
	./tests/run.sh

clean:
	rm -rf $(OBJ_DIR)
```

要点：

- `-MMD -MP` 生成头文件依赖，改 `.h` 会自动重编；
- `-Wconversion` 会抓出大量隐式截断，初期可关，交付前打开；
- sanitizer 目标必须 `clean`，否则旧对象文件不会重新插桩；
- 发布版保留 `-g`，便于线上符号化。

CMake 版本：

```cmake
cmake_minimum_required(VERSION 3.28)
project(myhttpd C)
set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
add_compile_options(-Wall -Wextra -Wpedantic -D_GNU_SOURCE)
add_executable(myhttpd src/main.c src/event.c src/http.c src/file.c)
target_link_libraries(myhttpd PRIVATE pthread)
```

## 3. 测试：三层，不要只写「能跑」

### 3.1 单元测试

不引入框架也能写：一个 `assert` + 一个 `main`，每个模块一个测试文件。

```c
/* tests/test_buffer.c */
#include <assert.h>
#include <string.h>
#include "../include/buffer.h"

static void test_append_and_consume(void)
{
    struct buf b;
    buf_init(&b, 16);
    assert(buf_append(&b, "hello", 5) == 5);
    assert(b.len == 5);
    assert(memcmp(b.data, "hello", 5) == 0);
    assert(buf_consume(&b, 3) == 3);
    assert(b.len == 2);
    buf_free(&b);
}

int main(void)
{
    test_append_and_consume();
    return 0;
}
```

编译并运行：

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -fsanitize=address,undefined \
   tests/test_buffer.c src/buffer.c -o /tmp/test_buffer && /tmp/test_buffer
```

### 3.2 集成测试

用 Shell 起服务、发请求、比对输出。测试脚本必须自己清理进程与临时文件。

```bash
#!/usr/bin/env bash
set -euo pipefail
PORT=18080
TMP=$(mktemp -d)
trap 'kill "$PID" 2>/dev/null || true; rm -rf "$TMP"' EXIT

./build/app --port "$PORT" --root tests/fixtures >"$TMP/log" 2>&1 &
PID=$!
for _ in $(seq 1 50); do
  curl -fsS "http://127.0.0.1:$PORT/" >/dev/null 2>&1 && break
  sleep 0.1
done

body=$(curl -fsS "http://127.0.0.1:$PORT/hello.txt")
[ "$body" = "hello" ] || { echo "body mismatch: $body"; exit 1; }
code=$(curl -s -o /dev/null -w '%{http_code}' "http://127.0.0.1:$PORT/nope")
[ "$code" = "404" ] || { echo "expected 404, got $code"; exit 1; }
echo "integration ok"
```

### 3.3 故障注入

系统项目的 bug 大多在错误路径。至少做这四类：

| 注入 | 方法 | 期望 |
|:--|:--|:--|
| 内存不足 | `ulimit -v`、`LD_PRELOAD` 失败注入 | 返回错误，不崩溃、不泄漏 |
| fd 耗尽 | `ulimit -n 64` + 压测 | `accept` 失败被处理，服务不崩 |
| 磁盘满 | 挂一个 10 MB 的 loop 设备 | 写失败被记录，不丢已确认数据 |
| 网络中断 | `tc netem loss 10%`、`iptables -j DROP` | 超时/重试，不永久挂起 |
| 崩溃恢复 | `kill -9` 后重启 | WAL/日志能恢复，状态一致 |

## 4. sanitizer 与 valgrind

```bash
# 内存越界、UAF、泄漏
make asan && ./build/app

# 线程竞争
make tsan && ./build/app

# 详细泄漏栈
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes ./build/app

# 线程错误
valgrind --tool=helgrind ./build/app
```

纪律：

- ASan 与 TSan **不能同时开**；
- TSan 下程序会慢 5–15 倍，压测数据不能用 TSan 版本；
- 交付前必须有一轮「全测试 + ASan/UBSan」零报告；
- 泄漏报告要区分「仍可达」与「确定泄漏」，前者常是全局缓存。

## 5. 压测：先方法，后工具

### 5.1 方法论

1. **定义指标**：吞吐（req/s、MB/s）、延迟（P50/P95/P99/P999）、错误率、资源（CPU/内存/fd/连接）。
2. **固定变量**：CPU 频率、绑核、关闭其他负载、同一客户端/服务端网络。
3. **预热**：先跑 10–30 秒，丢弃。
4. **重复**：至少 3 次，报告均值与方差；不要只报最好的一次。
5. **逐步加压**：从低并发开始，找到拐点（吞吐不再上升、延迟陡增）。
6. **记录配置**：内核版本、`sysctl`、编译选项、连接数、payload 大小。

### 5.2 HTTP

```bash
# wrk：4 线程、100 连接、30 秒、keep-alive
wrk -t4 -c100 -d30s --latency http://127.0.0.1:8080/hello

# hey：固定 QPS 上限，观察延迟
hey -z 30s -c 200 -q 0 http://127.0.0.1:8080/hello
```

报告至少包含：

```text
Running 30s test @ http://127.0.0.1:8080/hello
  4 threads and 100 connections
  Latency   1.23ms   0.98ms   12.4ms   78.2%
  Req/Sec    20.1k    1.2k     22.3k    91.2%
  Socket errors: connect 0, read 0, write 0, timeout 0
  Requests/sec: 80231.42
  Transfer/sec:     12.4MB
```

### 5.3 存储

```bash
# 随机读 4K、队列深度 32、直接 I/O
fio --name=randread --ioengine=libaio --direct=1 --rw=randread \
    --bs=4k --size=1G --numjobs=4 --iodepth=32 --runtime=30 --time_based \
    --group_reporting

# 顺序写、fsync 每次
fio --name=seqwrite --ioengine=psync --rw=write --bs=1M --size=1G \
    --fsync=1 --runtime=30 --time_based
```

看 `iops`、`bw`、`clat`（完成延迟）的 p99，不只看平均。

### 5.4 网络

```bash
# 带宽
iperf3 -s            # 服务端
iperf3 -c 10.0.0.2 -t 30 -P 4

# 延迟/丢包
ping -c 100 10.0.0.2
mtr -rwc 100 10.0.0.2
```

### 5.5 性能剖析

```bash
# CPU 采样
perf record -F 999 -g -- ./build/app
perf report --stdio | head -40

# 系统调用耗时
strace -c -T -f ./build/app
strace -T -e trace=epoll_wait,accept4,read,write -p $PID

# 内核态
sudo bpftrace -e 'profile:hz:99 /pid == '"$PID"'/ { @[kstack] = count(); }'
```

## 6. 可观测性

### 6.1 日志

- 结构化：`时间 级别 模块 事件 key=value`；不要用 `printf("here\n")`。
- 级别：`ERROR`（需人工）、`WARN`（异常但可恢复）、`INFO`（生命周期）、`DEBUG`（默认关）。
- 每条错误日志必须带 `errno` 与上下文（fd、路径、连接四元组）。
- 日志不能阻塞主循环：用无锁队列 + 后台线程，或 `writev` 批量写。

```c
#define LOG_ERROR(fmt, ...) \
    fprintf(stderr, "%s ERROR %s:%d " fmt "\n", now_iso(), __FILE__, __LINE__, ##__VA_ARGS__)
```

### 6.2 指标

至少四个：

| 指标 | 类型 | 用途 |
|:--|:--|:--|
| 请求数 / 错误数 | counter | 吞吐与错误率 |
| 当前连接数 / fd 数 | gauge | 泄漏与容量 |
| 请求延迟 | histogram | P99 抖动 |
| 队列长度 | gauge | 背压 |

导出：Prometheus 文本格式（`/metrics`）最简单：

```text
# HELP myhttpd_requests_total Total HTTP requests
# TYPE myhttpd_requests_total counter
myhttpd_requests_total{code="200"} 123456
myhttpd_connections 42
myhttpd_request_duration_seconds_bucket{le="0.01"} 120000
```

### 6.3 trace

单机项目用 `perf`/`bpftrace` 足够；分布式才需要 OpenTelemetry。不要在单机项目里引入一整套 Jaeger。

## 7. CI

GitHub Actions 最小模板：

```yaml
name: ci
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-24.04
    steps:
      - uses: actions/checkout@v4
      - run: sudo apt-get update && sudo apt-get install -y build-essential valgrind
      - run: make
      - run: make test
      - run: make asan && ./tests/run.sh
```

三条纪律：

1. CI 必须能在 10 分钟内跑完；慢测试放 nightly。
2. 测试失败要能本地复现；不要只在 CI 里神秘失败。
3. 构建产物带 git commit 与版本号：`-DVERSION=$(git describe --always --dirty)`。

## 8. 交付：容器镜像

多阶段构建，运行镜像只带二进制与必要配置：

```dockerfile
FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install -y build-essential
WORKDIR /src
COPY . .
RUN make release

FROM ubuntu:24.04
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=build /src/build/app /usr/local/bin/app
RUN useradd -r -u 10001 app
USER 10001
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/app"]
```

检查：

```bash
docker build -t myhttpd:dev .
docker run --rm -p 8080:8080 --read-only --tmpfs /tmp myhttpd:dev
docker image ls myhttpd
```

## 9. 性能报告模板

```markdown
# myhttpd 性能报告

## 环境
- CPU: 8 vCPU / RAM: 16 GB / 内核: 6.8.0
- 客户端: 同机 wrk，服务端绑核 2-5
- 编译: gcc 13.2 -O2 -g

## 方法
- 预热 15 s，正式 60 s，重复 3 次取中位数
- payload: 1 KB 静态文件，keep-alive

## 结果
| 并发 | RPS | P50 | P99 | 错误率 | CPU |
|---:|---:|---:|---:|---:|---:|
| 100 | 82k | 1.2 ms | 8 ms | 0 | 320% |
| 1000 | 91k | 9 ms | 45 ms | 0.1% | 680% |

## 瓶颈
- `perf top`: `epoll_wait` 12%，`memcpy` 18%，`tcp_sendmsg` 9%
- 结论：单 acceptor + 每次拷贝是瓶颈

## 优化
- 多 acceptor + `SO_REUSEPORT`：RPS +18%
- `sendfile` 替换用户态拷贝：P99 -22%

## 复现
```bash
make release && ./bench/run.sh
```
```

## 10. 代码评审清单

- [ ] 所有系统调用检查返回值，`EINTR`/短读/短写有处理
- [ ] 所有 `malloc`/`open`/`socket` 在错误路径释放
- [ ] 没有 `strcpy`/`sprintf`/`gets`；用 `snprintf` 并检查截断
- [ ] 边界检查：数组下标、协议长度、整数溢出
- [ ] 并发：共享数据有锁或原子；锁顺序一致；没有在持锁时调用回调
- [ ] 信号处理器只调用 async-signal-safe 函数
- [ ] 日志不泄露密码/token/完整请求体
- [ ] 有单元测试、集成测试、至少一个故障注入
- [ ] ASan/UBSan/TSan 零报告
- [ ] README 能让陌生人 10 分钟内跑起来

## 11. 调试工作流

```text
现象 → 复现 → 缩小范围 → 假设 → 证据 → 修复 → 回归
```

- **复现**：固定输入、固定环境、固定并发；不能复现的 bug 先加日志/指标。
- **缩小**：二分（git bisect）、注释法、最小输入。
- **假设**：一次只验证一个；写下「如果假设成立，应该看到什么」。
- **证据**：`strace`/`perf`/`bpftrace`/`gdb`/core dump；不要靠猜。
- **修复**：先加回归测试，再改代码。
- **回归**：跑全量测试 + sanitizer + 压测。

> **下一站**：选一条主线：[项目 A](pa.md)、[项目 B](pb.md)、[项目 C](pc.md)、[项目 D](pd.md)。
