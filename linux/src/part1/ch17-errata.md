# 1.17 勘误与版本注记

这一页收本章最容易「换一台机器、换一个工具链版本、换一个平台就不成立」的东西：Rust 符号名、`unsafe` 的语义、`Drop` 的保证范围、`errno` 映射、跨 FFI 的 panic 与所有权、macOS 与 Linux 的产物格式，以及内核 Rust 的版本漂移。正文的 `errata` 盒讲理解陷阱；这一页讲**换环境、换版本之后要复核什么**。

**本章基线**：正文与套件里标「VM」的读数来自本书 Ubuntu 24.04.5 虚拟机（aarch64、GCC 13.3.0、4 vCPU，`sudo` 不可用）。`cc`、`strace`、`readelf`、`nm`、`size`、`nc` 可用；**VM 没有 Rust 工具链**（`rustc`/`cargo`/`rustup`/`miri`/`clippy` 均不在）。写作机是 macOS arm64 + `rustc 1.99.1`：单文件示例能编能跑，但**产物是 Mach-O，不是 ELF**，`readelf` 读不了，`nm`/`size` 的字段口径也不同，且不能拷进 VM 执行。凡标「未实测」的，请看末节。

## 1. 十六条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「Rust 符号名总是 `_ZN...` 开头，按这个 grep 就行」 | 符号名由 mangling 方案决定：legacy 是 `_ZN` 前缀（Itanium 风格），**v0 方案**是 `_R` 前缀，且编码里带 crate、泛型实参与版本信息，名字随编译器版本变化。默认方案随 Rust 版本切换过，`-C symbol-mangling-version=v0` 可显式指定；**不要背前缀，要背「默认被 mangle」这一事实** | `nm librustffi.a \| grep -E '_ZN\|_R'`；同一 crate 用 `-C symbol-mangling-version=v0` 与默认各编一次，比较 `nm` 输出；`nm -C` 能看到 demangle 后的形状 |
| 「写了 `pub extern "C" fn`，C 就能按原名链接」 | `extern "C"` 只改 **ABI**（调用约定、参数寄存器），不改**符号名**；不加 `#[no_mangle]` 名字仍被 mangle。Rust 2024 edition 起属性本身要写成 `#[unsafe(no_mangle)]`，否则编译报错。反过来，加了 `#[no_mangle]` 但没写 `extern "C"`，名字对了、ABI 错了，C 侧调用会读错参数 | `nm -D --defined-only lib.so \| grep 名字`；`readelf -sW` 看 `Bind`/`Type`；C 侧 `dlsym` 后调用一次，观察参数是否错位 |
| 「panic 跨 `extern "C"` 只是会崩一下」 | 语言层面这是 **UB**：C 侧没有 unwind 表，栈展开会越过未知帧。当前实现在边界处直接 abort（报错形如 `panic in a function that cannot unwind`），但这属于实现行为，不能当作可依赖语义；要传播必须用 `extern "C-unwind"` 且两边运行时都支持，要隔离就在边界内 `catch_unwind` 或 `panic=abort` | 写一个在 `extern "C"` 函数里 `panic!` 的用例，观察进程是 abort 而非返回；`readelf -SW` 看是否有 `.eh_frame`；`nm` 看 unwind 相关符号 |
| 「写了 `unsafe` 就是不安全，就会有 UB」 | `unsafe` 只是把「编译器无法验证的前置条件」交给你证明；**正确使用的 `unsafe` 不产生 UB**，安全代码也可能因逻辑错误而崩溃。反过来，**没有 `unsafe` 也可能有 UB**：依赖里有 `unsafe`、`build.rs`、FFI 或编译器 bug | 能对每块 `unsafe` 写出 `// SAFETY:`；用 `cargo +nightly miri test` 抓一部分 UB；对外只暴露安全 API，让调用者不需要 `unsafe` |
| 「`Drop` 由类型系统保证，所以资源一定会释放」 | 保证的是「正常作用域退出时按序析构」；`panic=abort`、`std::process::exit`、`mem::forget`、泄漏的 `Rc` 环都不触发 `Drop`。`Drop` 还不能返回错误，`close`/`fsync` 失败会被吞 | 在 `Drop` 里打印，再用 `exit(0)`/`abort()` 提前退出对比；关键落盘改用显式 `flush()`/`sync_all()` |
| 「Rust 的所有权就等于 C 的 `malloc`/`free` 自动配对」 | 相近但不等价：`Box<T>` 的大小与对齐由类型决定，释放必须回到**同一个分配器**；`Vec` 有 len/cap 两套语义，`shrink`/`reserve` 会重新分配；跨 FFI 用 `Box::into_raw` 交出去后，必须由 Rust 侧同一分配器的 `Box::from_raw` 收回，C 的 `free` 不行。所有权还额外约束别名与线程 | 跨边界只用「谁分配谁释放」一条规则；`Vec::as_ptr` 的指针在 `push` 后可能失效；用 `Box::into_raw`/`from_raw` 各一次并检查没有第二条释放路径 |
| 「macOS 上 `rustc` 编出来的东西，拿到 Linux 也能跑/能读」 | 默认目标是 `aarch64-apple-darwin`，产物是 **Mach-O**（段名 `__TEXT`/`__DATA`，`LC_SYMTAB`，没有 `.dynsym`/`NEEDED`/`.rela.plt`）；Linux 只认 ELF 魔数 `7f 45 4c 46`，执行时返回 `ENOEXEC`，`readelf` 直接报 `Not an ELF file`。两者连节/段的模型都不同 | `file echo-rs` 显示 `Mach-O 64-bit executable arm64`；`xxd -l 4` 看魔数；`readelf -h` 报错即证明格式不符；要 Linux 产物就交叉编译到 `aarch64-unknown-linux-gnu` 或在 Linux 上重编 |
| 「`read` 返回 0 就是 EOF，返回负数就是失败」 | 对常规文件与 pipe，`0` 是 EOF；但非阻塞 fd 无数据时返回 `-1`/`EAGAIN`（`WouldBlock`），信号打断返回 `-1`/`EINTR`，两者都不是 EOF。把「非正数」一律当结束，是「文件被读短」的经典根因 | `strace -e trace=read` 看 `= -1 EINTR` 与 `= 0` 的区别；对非阻塞 fd 观察 `EAGAIN`；代码里三态分开写 |
| 「`EINTR` 标准库都处理了，不用管」 | `File::read`/`write`、`io::copy` 会重试；但 `libc::read`/`libc::write`、`nix` 的裸调用、以及 `accept`/`connect`/`openat` 这类直接封装**不会**替你重试。`EAGAIN` 则从来不是「重试」，而是「等就绪」 | 用 `libc::write` 写一个被信号打断的用例，看是否返回 `-1`；`strace` 里 `-1 EINTR` 后有没有紧跟一次重试 |
| 「`close` 失败就再关一次」 | fd 在 `close` 返回前已经释放；重试可能关掉另一个线程刚打开的 fd（经典的「关错 fd」）。`close` 的错误（如 NFS 上的 `EIO`）也不该覆盖之前保存的错误 | C 里只 `close` 一次并 `saved = errno`；Rust 侧知道 `Drop` 会吞掉 `close` 错误，关键路径显式 `sync_all()` 或用 `into_raw_fd` + `libc::close` 检查返回值 |
| 「`Arc<Mutex<T>>` 用了就线程安全」 | 它只保证 Rust 层面的数据竞争被排除；死锁、锁顺序、优先级反转、poisoning 之后的不一致状态都还在。跨 `.await` 持 `std::sync::MutexGuard` 会让任务饿死，且该 guard 不是 `Send` | 两把锁反序加锁复现死锁；`cargo clippy` 会提示跨 `await` 持锁（`await_holding_lock`）；用 `tokio::sync::Mutex` 或缩小作用域 |
| 「`thread::scope` 只是写法更短」 | 它是**生命周期契约**：作用域结束前 join 全部子线程，所以闭包可以借用栈上数据，不需要 `Arc`/`'static`。代价是长任务会阻塞退出；`thread::scope` 需要 Rust 1.63+，更老的版本没有 | 起一个 `sleep(2s)` 的 scoped 线程，观察 `scope` 返回时机；`rustc --version` 确认版本；对比 `spawn` 的 `'static` 报错 |
| 「`ErrorKind` 可以穷举 match」 | `ErrorKind` 是 `#[non_exhaustive]`，新变体会随版本加入（如 `StorageFull` 在较新版本才有）；match 必须带 `_`，且 `kind()` 是**分类**不是原因，精确原因看 `raw_os_error()` | 用不带 `_` 的 `match e.kind()` 编译，看是否报非穷尽；打印 `kind()` 与 `raw_os_error()` 对照同一个失败 |
| 「`last_os_error()` 随时能读到刚才的错误」 | 它读的是**当前线程此刻**的 `errno`，中间任何库调用（包括 `println!`、`env::var`）都可能覆盖。只有拿到裸 `-1` 返回值时才用，且必须第一时间读 | 失败后先做一次无关调用再读，比较 `raw_os_error()` 是否变了；代码里先保存 `raw_os_error()` 再格式化 |
| 「`clippy -D warnings` 一定会抓出 `unwrap()`」 | 默认 lint 集**不含** `clippy::unwrap_used`/`expect_used`（属 restriction 组，需显式开启）；默认会抓的是 `await_holding_lock`、`as` 截断类、未使用的 `Result` 等。把「clippy 通过」当成「没有 `unwrap`」是误读 | `cargo clippy -- -D warnings` 与 `cargo clippy -- -D clippy::unwrap_used` 各跑一次，比较报错数 |
| 「内核 Rust 的 API 与用户态一样稳定」 | 内核 Rust 仍快速演进：`Arc::new(..., GFP_KERNEL)` 这类签名、`Registration::new_pinned`、`#[vtable]` 的形状都随内核版本变；示例必须按目标内核版本核对。`std`/`libc`/`tokio`/默认 `serde` 都不可用 | 拿示例去对应版本的内核树 `make LLVM=1` 编译；查该版本 `rust/kernel/` 的头文件；`CONFIG_RUST=y` 是否开启 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的形状或方法**，不要抄成事实：

- **Rust 在 Linux 上的全部构建与运行**：VM 无 `rustc`/`cargo`/`rustup`；写作机 `rustc 1.99.1` 能编单文件，但产物是 Mach-O，既不能与 Linux `cc`/`ld` 链接，也不能在 VM 执行。因此 1.17.4–1.17.7 的 Rust 示例、1.17.9 的 `copy-rs-dbg` 追踪、1.17.10 的 `cargo check`/`clippy`/`miri`/`size`/`nm`、习题 C4，全部只给命令形状与判据。
- **Rust 二进制的 ELF 形状**：节名、`.dynsym`、`NEEDED`、`R_AARCH64_*` 重定位、`O_CLOEXEC` 是否出现在 `strace` 里——这些必须由 Linux 上的 `rustc` 产物验证，本环境没有读数。正文里「Rust 走 `openat` 且默认 `O_CLOEXEC`」来自标准库实现与文档，不是本机输出。
- **`miri` 的行为边界**：Miri 只能跑纯 Rust 与部分 FFI，系统调用会被拦截或忽略；具体哪些调用被支持随 nightly 版本变化。本章只给「它抓 UB、不抓系统调用与并发时序」这条定性结论。
- **`strace` 的具体文本**：`accept` 还是 `accept4`、`clone` 还是 `clone3`、`futex` 出现几次，随 glibc 版本、内核版本与竞争情况变化；正文只给过滤表达式与读法，不抄会话记录。
- **内核 Rust 示例**：1.17.8 的模块骨架是**概念性**代码，未在任何内核树上编译；`Arc::new`/`Registration`/`#[vtable]` 的签名随版本变，按目标内核核对。
- **C 组 C1–C3 的 VM 读数**：命令只用 VM 确认可用的 `cc`/`strace`/`nc` 设计，本套件写作时未逐条复跑；具体行数、信号时序以你机器为准。

## 发现新问题怎么记

按「现象 → 命令与输出 → 机器/架构/编译器/内核 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在工具链与平台上，所以请一并附上：`uname -a` 与 `uname -m`；`cc --version`；`rustc --version`/`cargo --version`（如果用了 Rust）；`file` 判定的产物格式；`nm`/`readelf -h` 的原始几行；`strace` 的关键几行；以及 `miri`/`clippy` 的组件版本。涉及数字时写明口径：是语言/ABI 条款、工具输出、量级示例，还是「未实测」。本章多数分歧都出在把「macOS 上编过」当成「Linux 上能跑」，或把「`unsafe`」当成「一定是 UB」。
