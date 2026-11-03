# 1.17 章末总结

## 三段主线：三个单元，一条因果链

**第一段，三条编译期约束（1.17.1–1.17.3）。** 所有权不是内存管理风格，而是一组可判定的资源规则：一个值只有一个所有者，所以 `File` 在作用域结束时 `Drop` → `close`，`Vec` 的 `Drop` 释放缓冲；借用不得长于所有者，所以 `Parser<'a>` 不能比它借用的 `&str` 活得更久，C 里靠文档约定的悬垂指针在这里是编译错误；`&mut` 独占，所以同一时刻只有一个线程能写，数据竞争被提前排除。但这三条挡的是 use-after-free、double-free 与数据竞争，不是泄漏：`Box::leak`、`Rc` 环、`mem::forget`，以及 `panic=abort`、`process::exit` 都会让 `Drop` 不运行。错误一侧，Rust 把系统编程的绝大多数失败放进 `Result`：`-1` + `errno` 变成 `io::Error`，`ErrorKind` 是分类而不是原因，`raw_os_error()` 才是原始整数；`?` 在返回 `Err` 时仍会走 `Drop`，这正是它比 C 的 `goto cleanup` 短的原因。`last_os_error()` 读的是当前线程的 `errno`，必须在失败后立刻取，中间任何一次库调用都可能把它覆盖。边界一侧，`unsafe` 不是关掉检查，而是由你承担编译器无法验证的前置条件：范围小、每块有 `// SAFETY:`、对外只暴露安全 API；写不出「为什么安全」就说明边界没画清。

**第二段，三个真实场景（1.17.4–1.17.6）。** 文件 I/O 把三条约束同时压上来：`read` 会被信号打断（`EINTR` 不是 EOF）、`write` 会短写（尤其 pipe/socket）、`close` 的错误既不能重试也不能覆盖前一个错误。C 版本用 `saved = errno` 保住第一个错误，并在每条失败路径上 `close`/`free`；Rust 的 `io::copy` 处理了重试与短写，`Drop` 负责关闭，但 `close` 的错误被丢弃——可靠性要求高的程序要显式 `flush`/`sync_all`。线程一侧，`thread::scope` 保证子线程在作用域结束前 join，所以能借用栈上的 `Mutex`，不需要 `Arc`；`spawn` 的线程可能活过当前栈帧，闭包就必须 `'static`。`Arc<Mutex<T>>` 的价值是「数据在锁里」，编译器无法替你检查的是锁顺序、死锁与 poisoning 之后的不一致状态。socket 一侧，除了 `SIGPIPE`、`accept` 的 `EINTR`，还有一条语言无关的事实：TCP 没有消息边界，一次 `read` 可能是半个请求。两版 echo 都是单线程串行，**代码短不等于自动并发**。

**第三段，FFI、内核与取证（1.17.7–1.17.12）。** 访问 Unix 接口分四层：`std` 最安全但细节不可控，`std::os::unix` 暴露 inode/权限/raw fd 而仍是安全 API，`libc` 与 C 一一对应但全 `unsafe`，`nix`/`rustix` 在其上做安全封装、错误转 `Errno`/`io::Result`。选择依据不是「哪个更现代」，而是「`std` 覆不覆盖」与「要不要匹配内核头文件」。内核 Rust 则把四层全部收走：没有 `std`、没有 `libc`、panic 通常不展开、分配要显式 `GFP_KERNEL`，`Result`/`Mutex`/分配器都换成 `kernel` crate 的版本，注册走 `#[vtable]` 而不是 `extern "C"`。取证靠三层工具：`strace` 看真实调用序列（`openat` 而非 `open`、`clone`/`futex`、`accept4`），`cargo check`/`clippy` 看编译期，`miri` 只看 UB 且抓不到系统调用与 FFI 时序。三者互不替代。

一句话主线：**先把「谁拥有资源、失败走哪条路、`unsafe` 的前置条件写在哪」变成三个可判定的问题，再把它们压到文件、线程、socket 三条真实路径上，最后用 FFI 分层与内核约束划清「Rust 替你做了什么、没替你做什么」；看到一个 Rust 系统程序，先问所有权，再问错误路径，最后问证据在哪。**

## 表 1：所有权与 C 的资源管理对照

| 资源 | C 的做法 | C 的典型故障 | Rust 的做法 | Rust 仍会出的问题 |
|:--|:--|:--|:--|:--|
| 堆内存 | `malloc`/`free` 成对 | 漏 `free`、double-free、悬垂 | `Box`/`Vec`/`String` + `Drop` | `Box::leak`、`mem::forget`、`Rc` 环 |
| 文件描述符 | `open`/`close` 成对 | 漏 `close`、错误路径提前 `return`、`exec` 泄漏 | `File` 的 `Drop` 关闭；`O_CLOEXEC` 默认 | `close` 错误被吞；`from_raw_fd` 与 `File` 双重关闭 |
| 锁 | `pthread_mutex_lock/unlock` | 忘记 `unlock`、异常路径跳过 | `MutexGuard` 随作用域释放 | 死锁、poisoning、跨 `.await` 持锁 |
| 共享数据 | 裸指针 + 约定 | 数据竞争 | `Arc<T>` / `&T`（scoped） | `unsafe impl Send` 绕过检查 |
| 缓冲区别名 | 两个指针写同一块 | UB、优化后行为异常 | `&mut` 独占，编译器拒绝别名 | `unsafe` 下重新造出别名 |

## 表 2：FFI 与错误映射规则

| 规则 | 具体要求 | 违反后果 | 怎么验证 |
|:--|:--|:--|:--|
| 符号名 | `#[no_mangle]`（2024 edition 写 `#[unsafe(no_mangle)]`）+ `pub extern "C"` | 默认 mangle（`_ZN`/`_R`），C 侧按名字找不到 | `nm -D --defined-only` 看是否有前缀 |
| 布局 | 跨边界结构体 `#[repr(C)]`，整数用固定宽度 | 字段偏移随编译器变化，读到垃圾 | 两侧各打印 `sizeof`/`offsetof` 对照 |
| 字符串 | C 要 NUL 结尾；`&str` 不是 | 越界读、截断 | `CString::new` 并检查内部 NUL |
| 所有权 | 明确「谁分配谁释放」，跨边界用 `into_raw`/`from_raw` 各一次 | 双重释放或泄漏 | 只保留一个所有者；`mem::forget` 转移 |
| `errno` | 裸 `-1` 返回值后立刻 `last_os_error()`；裸 syscall 是 `-errno` | 读到被覆盖的错误码 | 失败后第一句就取 `raw_os_error()` |
| panic | 不得穿过 `extern "C"` | UB/abort | 边界内 `catch_unwind`，或 `panic=abort`，或 `extern "C-unwind"` |
| 回调 | C 保存 Rust 指针异步调用要保证生命周期与线程安全 | UAF、数据竞争 | 改同步 API，或 `Arc` + 明确文档 |

## 表 3：陷阱清单

| 陷阱 | 看起来像 | 实际是 | 当场怎么验证 |
|:--|:--|:--|:--|
| Rust 没有内存泄漏 | 有所有权就不会泄漏 | 所有权只防 UAF/double-free；`leak`/`forget`/`Rc` 环照漏 | 写一个 `Rc` 环，`Weak` 化后看计数 |
| `Drop` 一定运行 | 析构由类型系统保证 | `abort`、`process::exit`、`mem::forget` 都不跑 | 在 `Drop` 里打印，用 `exit(0)` 提前退出 |
| `EINTR` 已被处理 | `std` 都重试了 | `File::read/write` 会重试；裸 `libc`/`accept`/`openat` 不会 | `strace` 看到 `-1 EINTR` 后有没有紧跟重试 |
| `read` 返回正数就是全部 | 读到了就完整 | 短读合法；TCP 无消息边界 | 用 4096 缓冲读大文件，统计循环次数 |
| `write` 一次写完 | 返回值不用看 | 短写常见于 pipe/socket，必须循环 | 大块写 pipe，看 `strace` 的多次 `write` |
| `close` 失败可重试 | 失败就再关一次 | fd 已释放，重试可能关掉别人的 fd；错误还会覆盖前一个 | C 里用 `saved` 保存首个错误，只 `close` 一次 |
| `SIGPIPE` 是网络问题 | 对端断了才报错 | 默认动作是**杀死进程** | C 版不忽略 `SIGPIPE`，`nc` 提前断开看进程是否消失 |
| `Arc<Mutex<T>>` 就没有竞争 | 类型安全等于并发安全 | 死锁、poisoning、锁顺序仍在 | 两把锁反序加锁，看是否挂住 |
| `thread::scope` 会自动并发 | 作用域线程更现代 | 作用域结束要 join，长任务会阻塞退出 | 起一个 `sleep` 线程，看 `scope` 何时返回 |
| Rust 的 `TcpListener` 自动并发 | 代码短、`incoming()` 优雅 | `for conn in incoming()` 是串行 | 两个 `nc` 同时连，看第二个是否等待 |
| `unsafe` 等于 UB | 写了 `unsafe` 就不安全 | `unsafe` 只是把证明责任交给你；正确使用不产生 UB | 能写出 `// SAFETY:` 且 Miri 无报错 |
| `miri` 通过就没事 | 工具说没 UB | Miri 抓不到系统调用、FFI 时序、真实并发 | 故意读 `/proc`，看 Miri 是否直接报不支持 |

## 下一站

[1.18 RISC-V 裸机](ch18.md) 把这一章的 `no_std`、所有权与 FFI 放进没有操作系统的环境：那里没有 `Drop` 能依赖的进程退出、没有 `errno`、没有 `std::sync`，`Result` 要让位于链接脚本、栈指针、SBI 与 trap。用户态的「资源随作用域释放」在裸机上要先有内存布局与入口地址才谈得上。

自检入口：[闭卷回忆卡](ch17-recall.md) 先合上正文叫出 16 个答案；[习题集](ch17-exercises.md) 的 B 组专练「现象 → 机制 → 证据 → 修法」；[学习目标自检表](ch17-checklist.md) 接管 1.17.12 的八条出口；[勘误与版本注记](ch17-errata.md) 的「Rust 符号 v0 mangling」「panic 跨 FFI」两条请先读一遍。
