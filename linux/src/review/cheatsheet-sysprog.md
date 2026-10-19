# R.2 系统编程速查

> 只放「写代码时会查」的语义与陷阱；完整解释回第 2 篇。

## 1. 编译与约定

```bash
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 -g prog.c -o prog
cc ... -pthread        # 线程
cc ... -lrt            # POSIX 实时（旧 glibc；新 glibc 已并入 libc）
cc ... -fsanitize=address,undefined   # ASan/UBSan
cc ... -fsanitize=thread              # TSan（不能与 ASan 同开）
```

- 系统调用失败返回 `-1` 并设 `errno`；**成功不清 `errno`**。
- `pthread_*` 返回错误码本身，不设 `errno`。
- 判断失败看返回值；只有失败后 `errno` 才有意义。

## 2. 文件 I/O

| API | 关键点 |
|:--|:--|
| `open(path, flags, mode)` | `O_CLOEXEC` 默认加；`mode & ~umask` |
| `openat(dirfd, path, ...)` | 避免 TOCTOU、限制沙箱逃逸 |
| `read(fd, buf, n)` | 短读合法；0=EOF；`EINTR` 重试 |
| `write(fd, buf, n)` | 短写合法；循环写剩余 |
| `pread/pwrite` | 不改变共享偏移，原子定位 |
| `close(fd)` | 失败不要重试（fd 可能被复用） |
| `dup/dup2` | 共享 `struct file`（偏移/flags） |
| `fcntl(F_GETFL/F_SETFL)` | 可改 `O_APPEND/O_NONBLOCK`；不能改访问模式 |
| `mmap` | `MAP_SHARED/PRIVATE/ANONYMOUS`；文件截断会 SIGBUS |
| `fsync/fdatasync` | 数据+元数据 / 仅数据（及必要元数据） |
| `rename` | 同文件系统原子替换；跨 FS 返回 `EXDEV` |

原子性：

```c
/* 创建新文件，已存在则失败 */
int fd = open(path, O_WRONLY|O_CREAT|O_EXCL|O_CLOEXEC, 0644);
/* 追加写：每次 write 原子定位到末尾 */
int fd = open(path, O_WRONLY|O_APPEND|O_CREAT|O_CLOEXEC, 0644);
/* 原子发布：写临时文件 → fsync → rename → fsync(dir) */
```

## 3. 进程

| API | 关键点 |
|:--|:--|
| `fork()` | 父得子 pid，子得 0，失败 -1；COW；fd 表复制 |
| `vfork()` | 共享地址空间；子进程只能 `_exit`/`exec` |
| `execve()` | 成功不返回；替换地址空间；pid 不变 |
| `waitpid(pid,&st,opt)` | `WIFEXITED/WEXITSTATUS/WIFSIGNALED/WTERMSIG` |
| `waitid()` | 可拿 `siginfo`（`CLD_EXITED` 等） |
| `exit()` | 刷 stdio、跑 `atexit`；`_exit()` 不刷 |
| `system()` | 经 shell，信号/注入风险；返回值要解码 |
| `posix_spawn()` | 无 `fork` 的受限环境可用 |

`fork` 在 multithreaded 程序里只应调用 async-signal-safe 函数；`malloc` 后 fork 可能死锁。子进程退出用 `_exit`，避免重复刷新父进程的 stdio 缓冲。

## 4. 信号

```c
struct sigaction sa = {0};
sa.sa_handler = handler;
sigemptyset(&sa.sa_mask);
sa.sa_flags = SA_RESTART | SA_SIGINFO;
sigaction(SIGTERM, &sa, NULL);
```

| 概念 | 要点 |
|:--|:--|
| 不可捕获 | `SIGKILL`、`SIGSTOP` |
| 阻塞 | `sigprocmask(SIG_BLOCK, &set, &old)` |
| 等待 | `sigsuspend(&mask)` 原子解除阻塞并睡眠 |
| 未决 | `sigpending(&set)` |
| 实时信号 | `SIGRTMIN..SIGRTMAX`，可排队 |
| `SA_RESTART` | 可重启的调用自动重启；`poll/epoll_wait/select` 不会 |
| 处理器内 | 只调用 async-signal-safe 函数；用 `volatile sig_atomic_t` |
| 转 fd | self-pipe 或 `signalfd` |

`EINTR` 处理：

```c
ssize_t n;
do { n = read(fd, buf, sizeof buf); } while (n == -1 && errno == EINTR);
```

## 5. 线程

| API | 关键点 |
|:--|:--|
| `pthread_create` | 返回错误码；栈大小可设 `pthread_attr` |
| `pthread_join` | 回收；detached 线程不能 join |
| `pthread_exit` | 只结束当前线程；主线程 `return` 结束进程 |
| `pthread_mutex_lock` | 普通/递归/错误检查；`trylock`/`timedlock` |
| `pthread_cond_wait` | 原子释放锁并睡眠；**必须 while 循环** |
| `pthread_cond_signal/broadcast` | 至少一个/全部唤醒 |
| `sem_wait/sem_post` | 计数信号量；`sem_getvalue` 仅调试 |
| `pthread_rwlock` | 读多写少；写者可能饿死 |
| `pthread_barrier` | 汇合点 |
| `pthread_key_create` | TLS；`__thread` 更轻 |

条件变量正确写法：

```c
pthread_mutex_lock(&m);
while (!ready) pthread_cond_wait(&cv, &m);
/* 消费 */
pthread_mutex_unlock(&m);
```

## 6. IPC

| 机制 | API | 适用 |
|:--|:--|:--|
| 匿名管道 | `pipe2(O_CLOEXEC)` | 父子/兄弟进程 |
| FIFO | `mkfifo` + `open` | 无亲缘进程 |
| POSIX 消息队列 | `mq_open/mq_send/mq_receive` | 有边界消息、优先级 |
| POSIX 共享内存 | `shm_open/ftruncate/mmap` | 大块共享数据 |
| POSIX 信号量 | `sem_open/sem_wait/sem_post` | 跨进程同步 |
| UNIX socket | `socket(AF_UNIX)` | 本机双向、传 fd |
| 文件锁 | `flock` / `fcntl(F_SETLK)` | 单机互斥 |

共享内存本身不提供同步；必须配信号量或 `PTHREAD_PROCESS_SHARED` 互斥锁。

## 7. 套接字

```c
int s = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, 0);
int one = 1;
setsockopt(s, SOL_SOCKET, SO_REUSEADDR, &one, sizeof one);
bind(s, (struct sockaddr *)&addr, sizeof addr);
listen(s, 128);
int c = accept4(s, NULL, NULL, SOCK_CLOEXEC);
```

| 主题 | 要点 |
|:--|:--|
| `bind` | 端口 <1024 需 root/capability；`INADDR_ANY` |
| `listen` backlog | accept 队列上限；`somaxconn` 封顶 |
| `accept` | 新 fd 不继承 `O_NONBLOCK`；用 `accept4` 设 flags |
| `connect` | 非阻塞返回 `EINPROGRESS`；用 `poll(POLLOUT)` 等 |
| `send/recv` | 字节流无边界；短读/短写 |
| `shutdown(SHUT_WR)` | 半关闭；对端读到 EOF |
| `SO_REUSEADDR` | 快速重启；不等于 `SO_REUSEPORT` |
| `TCP_NODELAY` | 关 Nagle；小包低延迟 |
| `SO_RCVTIMEO` | 阻塞 socket 超时 |
| `SCM_RIGHTS` | `sendmsg/recvmsg` 传 fd |

消息边界：长度前缀（推荐）或分隔符；不要假设一次 `read` 一条消息。

## 8. epoll

```c
int ep = epoll_create1(EPOLL_CLOEXEC);
struct epoll_event ev = { .events = EPOLLIN | EPOLLET, .data.fd = fd };
epoll_ctl(ep, EPOLL_CTL_ADD, fd, &ev);
int n = epoll_wait(ep, events, 64, -1);
```

| 模式 | 行为 | 纪律 |
|:--|:--|:--|
| LT（水平） | 只要可读就持续通知 | 可以不一次读完 |
| ET（边缘） | 状态变化时通知一次 | fd 非阻塞；循环读到 `EAGAIN` |
| `EPOLLONESHOT` | 触发一次后失效 | 重新 `epoll_ctl(MOD)` |
| `EPOLLEXCLUSIVE` | 多 epoll 只唤醒一个 | 缓解惊群 |
| `EPOLLERR/HUP` | 总是上报 | 必须关闭并 `DEL` |

`epoll_wait` 返回 0 是超时；-1 且 `EINTR` 可重试。

## 9. errno 速查

| 错误 | 常见原因 |
|:--|:--|
| `EINTR` | 被信号打断；通常重试 |
| `EAGAIN/EWOULDBLOCK` | 非阻塞暂无数据/缓冲区满 |
| `EACCES` | 权限不足 |
| `ENOENT` | 路径不存在 |
| `EEXIST` | `O_CREAT\|O_EXCL` 已存在 |
| `ENOSPC` | 磁盘/inode 满 |
| `EMFILE` | 进程 fd 耗尽 |
| `ENFILE` | 系统 fd 耗尽 |
| `EINVAL` | 参数/对齐/不支持 |
| `ESPIPE` | 管道/套接字不支持 `lseek` |
| `EPIPE` | 管道读端关闭；通常伴随 `SIGPIPE` |
| `ETIMEDOUT` | 超时 |
| `ECONNRESET` | 对端重置 |
| `EADDRINUSE` | 端口被占用 |
| `ENOBUFS/ENOMEM` | 内核内存不足 |

## 10. 常见错误速查

| 写法 | 问题 | 正确 |
|:--|:--|:--|
| `if (read(...) != n)` | 短读当错误 | 循环读到 EOF/够数 |
| 忽略 `write` 返回值 | 短写丢数据 | `write_full` |
| `close` 重试 | fd 可能被复用 | 记录错误，不重试 |
| `if (pthread_mutex_lock(...) == -1)` | 永远不成立 | 判断 `rc != 0` |
| 条件变量用 `if` | 虚假唤醒 | `while` |
| 信号处理器里 `printf` | 非 async-signal-safe | `write` + 静态缓冲 |
| `fork` 后子进程 `exit` | 重复刷 stdio | `_exit` |
| `mmap` 文件后截断 | SIGBUS | 处理 `SIGBUS`/加锁 |
| ET 只读一次 | 丢事件 | 读到 `EAGAIN` |
| `accept` 后忘 `CLOEXEC` | fd 泄漏给子进程 | `accept4` |

## 11. 一页调用链

```text
open → read/write → close
fork → execve → waitpid
sigaction → kill/raise → handler/self-pipe
pthread_create → mutex/cond → join
socket → bind → listen → accept → recv/send → shutdown → close
epoll_create1 → epoll_ctl → epoll_wait → 处理 → 关闭
```

> 回 [R.1 命令行速查](cheatsheet-cli.md)；内核侧路径去 [R.3](cheatsheet-kernel.md)，网络侧去 [R.4](cheatsheet-net.md)。
