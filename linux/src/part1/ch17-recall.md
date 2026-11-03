# 1.17 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。16 张卡分三组：**A 组考三条编译期约束（1.17.1–1.17.3）**，**B 组考文件、线程、socket 与 FFI 分层（1.17.4–1.17.7）**，**C 组考内核、取证与环境边界（1.17.8–1.17.12）**。建议当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 三条编译期约束

::: method 回忆 1 · 所有权的三条规则在系统编程里各挡什么
一个值只有一个所有者、借用不得长于所有者、`&mut` 独占——这三条在 fd/锁/缓冲上分别对应什么 C 风险？
::: sol 答案
所有权对应 fd、缓冲区、锁守卫随作用域自动释放，挡住「忘记 `close`/`free`」与 double-free；借用生命周期对应「`&[u8]` 指向的缓冲区不能先被释放」，挡住悬垂指针与 use-after-free；`&mut` 独占对应「同一时刻只有一个可变访问」，在编译期排除数据竞争。关键是：这三条挡的是 UAF/double-free/数据竞争，**不挡泄漏**（`Box::leak`、`Rc` 环、`mem::forget`），也不保证 `Drop` 一定运行。
:::
:::

::: method 回忆 2 · `Drop` 什么时候不运行
哪些路径会让 `Drop` 不执行？这对「用 `Drop` 做事务提交/落盘」意味着什么？
::: sol 答案
`panic=abort`（不展开栈）、`std::process::exit`、`mem::forget`、泄漏的 `Rc` 环，都不会运行 `Drop`；`abort` 与 `_exit` 直接终止进程。所以 `Drop` 不能承担「必须成功」的语义：`Drop` 不能返回错误，`close`/`fsync` 失败会被吞。关键落盘要显式 `flush()`/`sync_all()`，不要指望析构替你报告错误。
:::
:::

::: method 回忆 3 · `Result`、`?` 与 `From` 的分工
`?` 到底做了哪两件事？为什么它能取代 C 的 `goto cleanup`？
::: sol 答案
`?` 在 `Ok(v)` 时取 `v` 继续；在 `Err(e)` 时先对 `e` 做 `From::from` 转成函数返回类型，再 `return Err(...)`。因为返回是正常作用域退出，所有局部值的 `Drop` 都会运行，所以不需要手写清理跳转。C 的 `goto cleanup` 要在每个错误点手工跳转且容易漏；Rust 把「清理」交给析构，把「转换」交给 `From`。
:::
:::

::: method 回忆 4 · `errno` 与 `ErrorKind` 的对照
`ENOENT/EACCES/EINTR/EAGAIN/EPIPE` 各对应哪个 `ErrorKind`？哪几个必须自己处理、怎么处理？
::: sol 答案
`ENOENT`→`NotFound`，`EACCES`/`EPERM`→`PermissionDenied`，`EINTR`→`Interrupted`，`EAGAIN`/`EWOULDBLOCK`→`WouldBlock`，`EPIPE`→`BrokenPipe`，`ENOSPC`→`StorageFull`（较新），`EINVAL`→`InvalidInput`。`EINTR` 要重试；`EAGAIN` 不是错误，非阻塞 fd 要交给 `poll`/`epoll`/async；`EPIPE` 要停止写并处理 `SIGPIPE`；`ENOENT`/`EACCES` 向上返回或提示。`ErrorKind` 是分类，原始值用 `raw_os_error()`。
:::
:::

::: method 回忆 5 · `last_os_error()` 的时机
`Err(e)` 里的错误和 `io::Error::last_os_error()` 有什么不同？什么时候只能用后者？
::: sol 答案
`Err(e)` 是失败瞬间由 `std` 捕获并保存的错误，之后怎么调用都不变；`last_os_error()` 读的是**当前线程**此刻的 `errno`，中间任何库调用都可能覆盖它。只有在拿到裸返回值（`libc::write` 返回 `-1`、`libc::open` 返回 `-1`）时才用 `last_os_error()`，而且必须在失败后第一句就读，先存 `raw_os_error()` 再格式化输出。
:::
:::

::: method 回忆 6 · `unsafe` 的三条纪律与六类操作
好的 `unsafe` 有哪三个特征？`*ptr` 解引用、`slice::from_raw_parts`、`transmute`、`Box::from_raw`、`extern "C"` 调用、`unsafe impl Send/Sync` 各要证明什么？
::: sol 答案
三个特征：范围小、每块有 `// SAFETY:` 说明、对外只暴露安全 API。解引用要证明非空、对齐、指向有效对象且在生命周期内；`from_raw_parts` 要求指针非空（长度为 0 也必须非空）、对齐、`len` 不越界；`transmute` 要求大小相同、位模式合法、无 padding 歧义；`Box::from_raw` 要求指针来自 `Box::into_raw` 且只接管一次；`extern "C"` 要保证 ABI、类型、所有权与 panic 不跨边界；`unsafe impl Send/Sync` 要证明内部状态真的可跨线程。写不出理由就是边界没画清。
:::
:::

## B. 场景与 FFI 分层

::: method 回忆 7 · 文件的三条硬点
`read`/`write`/`close` 各有一个必须处理的行为，分别是什么？Rust 版本替你处理了哪几条？
::: sol 答案
`read` 会被信号打断返回 `-1`/`EINTR`（不是 EOF），要重试；`write` 可能短写，必须循环推进指针与剩余长度；`close` 可能返回 `EIO` 但 fd 已关闭，不能重试，也不能覆盖前一个错误（C 用 `saved = errno`）。Rust 的 `io::copy` 处理了 `EINTR` 与短写，`File` 的 `Drop` 负责关闭但**丢弃 `close` 错误**；可靠性要求高的程序要显式 `flush`/`sync_all`。
:::
:::

::: method 回忆 8 · `thread::scope` 与 `spawn` 的所有权差别
为什么 `scope` 能借用栈上的 `Mutex` 而 `spawn` 不行？`Arc<Mutex<T>>` 解决了什么、没解决什么？
::: sol 答案
`spawn` 的线程可能在当前栈帧结束后仍运行，闭包捕获的引用必须 `'static`，所以要 `move` 所有权或 `Arc::clone`；`scope` 保证所有子线程在作用域结束前 join，借用不会逃逸，因此可以直接借用 `&Mutex<T>`。`Arc<Mutex<T>>` 解决「共享所有权 + 互斥访问」，并把数据放进锁里；它不解决死锁、锁顺序、competing 一致性，也不阻止 panic 后的 poisoning（`unwrap` 会再 panic，`into_inner` 可取出但状态可能不一致）。
:::
:::

::: method 回忆 9 · socket 的四个坑
C 的 echo server 要处理哪四件事？Rust 版本哪几件仍要自己做？
::: sol 答案
① `SIGPIPE`：对端关闭后 `write` 触发信号，默认杀死进程，要 `signal(SIGPIPE, SIG_IGN)` 或 `MSG_NOSIGNAL`；② `accept` 的 `EINTR` 要重试；③ TCP 无消息边界，一次 `read` 可能是半个请求，协议要带长度前缀或分隔符；④ `SO_REUSEADDR` 只解决 TIME_WAIT，端口被占要 `SO_REUSEPORT`。Rust 的 `TcpStream`/`Drop` 管了资源释放，`write_all` 管了短写，但 `SIGPIPE`（裸 `libc::write` 时）、消息边界、串行 `incoming()` 仍要自己处理。
:::
:::

::: method 回忆 10 · 四层 FFI 怎么选
`std`、`std::os::unix`、`libc`、`nix`/`rustix` 各适合什么？给出四种需求的选择。
::: sol 答案
`std`：跨平台、安全、覆盖常见操作；`std::os::unix`：要 inode/权限/`as_raw_fd` 等 Unix 细节但仍是安全 API；`libc`：与 C 一一对应、最灵活但全 `unsafe`、错误码自管；`nix`/`rustix`：对 libc 的安全封装，错误转 `Errno`/`io::Result`。四种需求：「读 inode/权限」用 `std::os::unix`；「`epoll` 事件循环」用 `rustix`（或 `nix`）；「匹配内核 `ioctl` 结构体」用 `libc` + 手工/bindgen 并把 `unsafe` 收进小模块；「跨平台库」以 `std` 为主，`cfg(target_os = "linux")` 分层，不把 Linux 常量暴露到公共 API。
:::
:::

::: method 回忆 11 · 内核 Rust 少什么
用户态 Rust 与内核 Rust 的五个差异是什么？为什么不能搬 `tokio`？
::: sol 答案
① `std::io::Result` → `kernel::Result`（内核 errno 负数）；② `Box`/`Vec` → `KBox`/`KVec` + 显式 `GFP_KERNEL`（分配可能睡眠/失败）；③ `std::sync::Mutex` → `kernel::sync::Mutex`（自旋/睡眠语义不同，中断上下文受限）；④ `panic!` 展开 → 终止/`BUG`，内核通常不允许 unwind；⑤ `extern "C"` → `#[vtable]`/`FileOperations`，通过内核 trait 表注册。`tokio` 依赖 `std`、线程与用户态调度器，内核里没有这些前提，不能直接用。
:::
:::

## C. 取证与环境边界

::: method 回忆 12 · `strace` 读法
读 `strace` 的四步顺序是什么？为什么 Rust 的 `File::open` 显示的是 `openat` 而不是 `open`？
::: sol 答案
四步：先看返回值（`-1` 后的 errno 是根因）；再看 fd 生命周期（`openat` 的 fd 是否在 `close` 前泄漏）；再看短读/短写/`EINTR`；最后看重复次数是否异常。`std` 在现代 Linux 上走 `openat(AT_FDCWD, ...)`，并且默认带 `O_CLOEXEC`，所以看不到 `open`；C 侧要显式加 `O_CLOEXEC` 才等价。
:::
:::

::: method 回忆 13 · `check`/`clippy`/`miri` 各管什么
三者的检查层次与盲区分别是什么？为什么不能互相替代？
::: sol 答案
`cargo check` 只做类型与借用检查、不生成代码；`clippy` 抓常见 API 误用（`unwrap`、`as` 截断、未使用的 `Result`），`-D warnings` 把提示变错误；`miri` 在 MIR 解释器里跑，抓越界、悬垂、未初始化读、别名违规等 UB。盲区：`check`/`clippy` 通过不代表链接通过或运行正确；`miri` 抓不到系统调用、FFI 时序、真实并发与竞态，遇到系统调用会拦截或忽略。所以对 `unsafe` 密集的代码是 Miri + ASan + fuzz 的组合。
:::
:::

::: method 回忆 14 · FFI 的三条硬规则
导出给 C 的函数要写什么？跨边界结构体与字符串各要注意什么？panic 为什么不能穿过 `extern "C"`？
::: sol 答案
要 `#[no_mangle]`（Rust 2024 edition 起 `#[unsafe(no_mangle)]`）+ `pub extern "C"`：`extern "C"` 只改 ABI 不改符号名，不加 `no_mangle` 名字会被 mangle（legacy `_ZN` 或 v0 `_R`）。结构体用 `#[repr(C)]` 且整数用固定宽度，否则偏移随编译器变。字符串 C 要 NUL 结尾，`&str` 不是，要 `CString::new` 并检查内部 NUL。panic 穿过 `extern "C"` 是 UB（实际常 abort），要么边界内 `catch_unwind`，要么 `panic=abort`，要么用 `extern "C-unwind"` 且两边运行时都支持。
:::
:::

::: method 回忆 15 · 十二章陷阱里的三条所有权坑
`Rc` 跨线程、`RefCell` 运行时 panic、跨 `.await` 持锁——各自的现象、机制与修法是什么？
::: sol 答案
`Rc` 不是 `Send`，`spawn` 时编译失败，报错要求 `Send`；修法用 `Arc`，不要 `unsafe impl Send` 掩盖。`RefCell` 的 `borrow()` 与 `borrow_mut()` 同时存在会在**运行时** panic（不是编译期），修法是缩小借用作用域或改用 `Mutex`/`RwLock`。跨 `.await` 持 `std::sync::MutexGuard` 会让锁在挂起期间不释放、其他任务饿死，且 `MutexGuard` 不是 `Send`；修法是缩小锁作用域或用 `tokio::sync::Mutex`。
:::
:::

::: method 回忆 16 · 本环境能测什么、不能测什么
哪些结论在本书环境有读数，哪些必须标「未实测」？为什么 Rust 的 ELF 行为不能用写作机代替？
::: sol 答案
有读数：VM 上 C 侧的 `openat`/`read`/`write`/`close` 序列、`strace` 行、`readelf`/`nm`/`size` 对 C 产物的输出。未实测：所有 Rust 编译产物在 Linux 上的 ELF 形状与运行行为（VM 无 `rustc`/`cargo`，`cargo check`/`clippy`/`miri` 都跑不了）；写作机 `rustc 1.99.1` 能编译，但产物是 **Mach-O**，`readelf` 读不了，`nm`/`size` 的段与符号表模型也不同（`__TEXT`/`__DATA`、`LC_SYMTAB`，没有 `.dynsym`/`NEEDED`），也不能在 VM 上执行。所以 Rust 的节名、动态段、`O_CLOEXEC` 是否出现，只能写成「命令形状 + 判据」，不能抄成输出。
:::
:::

## 计分与下一步

- **12 个以上 ✓**：可以做[习题集](ch17-exercises.md) C 组的 C 侧实验，并去[自检表](ch17-checklist.md)勾 S 组。
- **8–11 个 ✓**：重做 △ 卡，回对应小节只读那一段，不要从头读。
- **少于 8 个**：先读[章末总结](ch17-summary.md)的三段主线与三张表，再回来做 A 组。
