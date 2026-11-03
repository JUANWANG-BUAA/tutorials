# 1.17 Rust 系统编程 · 本章导航

::: preview 这一章在讲什么
[1.16](ch16.md) 把 C 与 Rust 放在同一条工具链上：同样的 ELF、ABI 与链接器。这一章换问题：**同一批系统调用，用 Rust 写会多出哪些编译期约束、少掉哪些运行时错误路径**。答案不在语法里，而在四个可检验的位置——所有权决定资源何时释放（1.17.1）、`Result`/`?` 决定错误怎么向上走（1.17.2）、`unsafe` 决定边界画在哪（1.17.3）、FFI 分层决定你离 C 有多近（1.17.7）。文件、线程、socket 三个完整程序只是把这三条约束摆到真实 fd 上。
:::

## 本章回答什么

- **所有权到底约束了什么**：一个值一个所有者、借用不得长于所有者、`&mut` 独占。这三条在系统编程里分别对应 fd/锁守卫的自动释放、悬垂指针的排除、数据竞争的编译期排除；`Drop` 保证的不是「不泄漏」，而是「正常路径上按作用域析构」（1.17.1）。
- **C 的 `errno` 怎么变成 `Result`**：`-1` + `errno` 映射为 `io::Error`；`ErrorKind` 与 `ENOENT/EACCES/EINTR/EAGAIN/EPIPE` 的对照表；`last_os_error()` 必须紧跟失败读，否则会被后续调用覆盖（1.17.2）。
- **ABI 与系统调用在哪儿交接**：SysV/AAPCS64/RISC-V psABI 三张参数表；裸 `syscall` 返回 `-errno`、libc 包装返回 `-1` 并设 `errno`，这一条差异决定了 Rust 侧谁来做错误转换（1.17.2）。
- **`unsafe` 的边界怎么画**：小范围、每块带 `// SAFETY:`、对外只暴露安全 API；六类典型操作各自要证明什么；Miri 能抓什么、抓不到什么（1.17.3）。
- **文件 I/O 的三条硬点**：`EINTR` 重试、`write` 短写、`close` 的错误不可重试也不可覆盖；Rust 的 `io::copy` 替你处理了前两条，`Drop` 会吞掉第三条（1.17.4）。
- **线程的两种所有权形状**：`thread::scope` 借用栈上数据、`spawn` 要求 `'static`；`Arc<Mutex<T>>` 把数据放进锁里而不是让锁和数据分离；poisoning 与死锁仍在（1.17.5）。
- **socket 的四类坑**：`SIGPIPE`、`accept` 的 `EINTR`、TCP 无消息边界、`SO_REUSEADDR` 不等于端口独占；以及「Rust 版本短 ≠ 自动并发」（1.17.6）。
- **四层 FFI 怎么选**：`std` → `std::os::unix` → `libc` → `nix`/`rustix`，越往下越灵活、越多 `unsafe`；判断依据是「`std` 覆不覆盖 + 要不要匹配内核头文件」（1.17.7）。
- **内核 Rust 的额外约束**：没有 `std`/`libc`/unwind/全局分配器，`Result`、`Mutex`、分配都要换成 `kernel` crate 的版本；`#[vtable]` 取代 `extern "C"`（1.17.8）。
- **怎样取证**：`strace` 看 `openat`/`clone`/`accept4` 的真实序列；`cargo check`/`clippy`/`miri` 各管哪一层；`size`/`nm` 看产物（1.17.9–1.17.10）。
- **十二条陷阱与本章小结**：所有权五个、panic/FFI 三个、错误与环境四个（1.17.11）；八条出口（1.17.12）。

## 读完你会

- 用一个 `read_all` 例子说清 C 要在几条失败路径上 `close`/`free`，而 Rust 的 `?` + `Drop` 如何把「正常路径」缩短，同时**不改变错误语义仍需你决定**这件事。
- 写出 `LoadError` 这类自定义错误：`Display`、`Error::source`、`From<io::Error>` 三件套，并解释 `?` 在哪一步做转换。
- 背出 `ENOENT/EACCES/EINTR/EAGAIN/EPIPE/ENOSPC/EINVAL` 与 `ErrorKind` 的对照，并说出哪一种必须自己重试、哪一种要交给 `poll/epoll`。
- 判断一段代码该不该用 `unsafe`：能写出前置条件、`// SAFETY:` 理由，并把 `File::from_raw_fd`、`mem::forget` 的所有权转移讲圆。
- 手写 C 的 `copy_file` 与 Rust 的 `copy_file`，指出两边各自漏掉 `EINTR`/短写/`close` 错误会发生什么；说出为什么 Rust 侧要显式 `flush`/`sync_all`。
- 用 `thread::scope` 写 4 线程计数，并解释为什么它不需要 `Arc`；再说明换成 `spawn` 后编译器会逼你做什么。
- 写单线程 TCP echo 的 C 与 Rust 两版，指出 `SIGPIPE`、`accept` 的 `EINTR`、消息边界三处如何处理，并说清两版都**不自动并发**。
- 在四层 FFI 里做选择：给「读 inode/权限」「`epoll` 事件循环」「匹配 `ioctl` 结构体」「跨平台库」四种需求各选一层并说出代价。
- 说出用户态 Rust 与内核 Rust 的五个差异（`Result`、分配器、`Mutex`、panic、注册方式），并解释为什么不能把 `tokio` 搬进内核。
- 用 `strace -e trace=openat,read,write,close` 证明「Rust 的 `File::open` 走 `openat` 且默认 `O_CLOEXEC`」；用 `clippy -D warnings` 与 `miri` 各自的盲区说明它们不能互相替代。

## 先修与预计学时

- 所有权与借用的语言层直觉：Rust Book 第 4 章；本章只讲它在 fd/线程/socket 上的落点。
- C 侧系统调用语义：[1.14 文件与 I/O](ch14.md)、[1.15 汇编与 ABI](ch15.md#sec-1.15.1)；`errno`、短读短写、`EINTR` 的读法与本章一致。
- 工具链与 FFI：[1.16 编译、链接与优化](ch16.md#sec-1.16.7)（`#[no_mangle]`、`extern "C"`、`panic` 边界）。
- 阅读：约 95 分钟（12 节）。习题 A 组约 20 分钟，B 组约 25 分钟；C 组以 C 侧为主，约 30 分钟。

### 环境与口径

- **VM**：Ubuntu 24.04.5（aarch64、GCC 13.3.0、4 vCPU，`sudo` 不可用）。`cc`、`strace`、`readelf`、`nm`、`size`、`nc` 可用；**VM 没有 Rust 工具链**：`rustc`、`cargo`、`rustup`、`miri`、`clippy` 均不在。本章全部 Rust 示例、1.17.9 的 `rustc -g` 对比、1.17.10 的 `cargo check`/`miri` 在 VM 上都跑不了，按「未实测 + 原因」读。
- **写作机**：macOS arm64 + `rustc 1.99.1`。单文件示例可以 `rustc --edition 2021 ... -o ...` 编过并运行，但**产物是 Mach-O，不是 ELF**：`readelf` 读不了它，`nm`/`size` 的字段口径也不同（Mach-O 用 `__TEXT`/`__DATA` 段与 `LC_SYMTAB`，没有 `.dynsym`/`.needed`）；产物也不能拷到 VM 上执行。凡涉及「Rust 二进制在 Linux 上的 ELF 形状」（节名、动态段、`R_AARCH64_*` 重定位、`O_CLOEXEC` 是否出现在 `strace` 里）一律标**未实测**。
- **口径**：正文的 ABI 表、`errno` 名、`ErrorKind` 变体、`strace` 过滤表达式是文档与工具约定的形状；`size` 数字、线程计数、字节数只在同机同版本内可比。C 组只把工具输出当读数，先写预期再跑；Rust 侧没有证据的地方不编造输出。

## 本章路线：三段，一条主线

| 段 | 小节 | 这一段回答什么 |
|:--|:--|:--|
| **一、三条编译期约束** | [1.17.1](ch17.md#sec-1.17.1)–[1.17.3](ch17.md#sec-1.17.3) | 所有权管资源、`Result` 管错误、`unsafe` 管边界；三者的判据各是什么？ |
| **二、三个真实场景** | [1.17.4](ch17.md#sec-1.17.4)–[1.17.6](ch17.md#sec-1.17.6) | 文件、线程、socket 上，C 的每条错误路径对应 Rust 的哪个类型或哪个 `?`？ |
| **三、FFI、内核与取证** | [1.17.7](ch17.md#sec-1.17.7)–[1.17.12](ch17.md#sec-1.17.12) | 四层 FFI 怎么选；内核 Rust 少什么；用 `strace`/`clippy`/`miri` 怎么把结论变成读数。 |

一句话主线：**先把「资源何时释放、错误怎么上浮、边界画在哪」变成三个可判定的问题（1.17.1–1.17.3），再把它们压到文件、线程、socket 三条真实路径上（1.17.4–1.17.6），最后用 FFI 分层与内核约束说明「Rust 替你做了什么、没替你做什么」（1.17.7–1.17.12）；看到一个 Rust 系统程序，固定问三件事——谁拥有这个 fd、失败走哪条路、这段 `unsafe` 的前置条件写在哪。**

## 怎么读

- **第一次读**：1.17.1–1.17.3 连读，边读边把「C 的风险列」与「Rust 的约束列」抄成两栏；然后直接跳到 1.17.4 的两个 `copy_file` 对照，看 `?` 到底省掉了哪几行。
- **正在排一个具体故障**：`PermissionDenied` 但路径没错看 1.17.2 的 `errno` 表与[习题 B2](ch17-exercises.md#ex-1.17-B2)；`read` 返回 0 却以为读到数据看 B1；线程编译不过看 B4；`write` 把进程打死看 B5 与[勘误页](ch17-errata.md)。
- **准备面试或课程考试**：所有权三条（1.17.1）、`Result`/`?` 与 `errno`（1.17.2）、`unsafe` 检查清单（1.17.3）、`Send`/`Sync`（1.17.5）、四层 FFI（1.17.7）是五处必答；先做[习题集](ch17-exercises.md) A 组。
- **怕数字搬家**：线程计数、`size` 输出、`strace` 行都可复算，但只在同机同版本同架构内可比；Rust 在本环境没有可运行的 Linux 产物，统一记在[勘误页](ch17-errata.md)的「本章未实测项」。

## 路线标签与项目回链

- **应用/运维：必读** [1.17.2](ch17.md#sec-1.17.2)、[1.17.4](ch17.md#sec-1.17.4)、[1.17.6](ch17.md#sec-1.17.6)。短写、`EINTR`、`SIGPIPE` 是线上事故的常客；**可后补** [1.17.8](ch17.md#sec-1.17.8)（不写内核模块可跳）。
- **系统编程：必读** [1.17.1](ch17.md#sec-1.17.1)–[1.17.7](ch17.md#sec-1.17.7)、[1.17.11](ch17.md#sec-1.17.11)。所有权、`unsafe`、FFI 是日常工作；**可后补** [1.17.10](ch17.md#sec-1.17.10)（`cargo`/`miri` 本环境不可用）。
- **内核/性能：必读** [1.17.5](ch17.md#sec-1.17.5)、[1.17.8](ch17.md#sec-1.17.8)、[1.17.9](ch17.md#sec-1.17.9)。锁语义与用户/内核边界是理解内核 Rust 的前提；**可后补** [1.17.7](ch17.md#sec-1.17.7)（用户态 FFI 分层）。
- **项目回链**：A2 `mycontainer` 的 `fork`/`exec` 与 fd 继承，最终落在「`O_CLOEXEC` 加没加、`close` 错误有没有被吞」；本章 1.17.4 的 `copy_file` 与 1.17.9 的 `strace` 读法就是最短检查路径。

## 章末件

[章末总结](ch17-summary.md) · [闭卷回忆卡](ch17-recall.md) · [习题集](ch17-exercises.md) · [学习目标自检表](ch17-checklist.md) · [勘误与版本注记](ch17-errata.md)

## 这一章的依据

| 母本 | 章节 | 主要落点 |
|:--|:--|:--|
| **Rust Book** | 第 4 章所有权、第 9 章错误、第 16 章无畏并发 | 1.17.1、1.17.2、1.17.5：三条约束与 `Send`/`Sync` |
| **Rust Book** | 第 19 章 `unsafe`、第 20 章 FFI | 1.17.3、1.17.7：安全封装与 C 互调 |
| **Rustonomicon** | 别名、`repr(C)`、unwind、FFI | 1.17.3、1.17.7：按系统编程重写 |
| **K Kerrisk** | 第 4–5、29–33、56–61 章 | 1.17.4–1.17.7：C 语义与错误码对照 |
| **rCore** | 第 1–4 章 Rust 裸机 | 1.17.8：只借 `no_std` 与内核组织方式 |

> 母本只按章节号核对落点；本章的 `strace` 行、`errno` 名与内核 API 形态以你机器上的实际输出为准，详见[勘误页](ch17-errata.md)。
