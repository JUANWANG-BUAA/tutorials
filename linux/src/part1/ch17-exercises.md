# 1.17 习题集

三组分层：**A 组概念判断**考「会读、会说理由、会画路径」；**B 组诊断推理**给现象让你判所有权、判错误路径、判修法；**C 组动手实验**在 Ubuntu 24.04 aarch64 上免 `sudo` 复现本章的关键证据。全部附解答与判据；先独立完成，再展开对照。每题的第一个动作都是「先猜」：把预期写下来，再去验证；猜错的地方才是这题的价值。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读；A 组对应 1.17.1–1.17.7，B 组对应 1.17.2–1.17.11，C 组对应 1.17.4–1.17.10。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、GCC 13.3.0、4 vCPU）上设计；临时文件统一用 `lab1c17_` 前缀，实验结束删掉。
4. **VM 没有 Rust 工具链**（`rustc`/`cargo`/`rustup`/`miri`/`clippy` 均不在）：C 组里凡是 Rust 编译、`cargo check`、`miri`、Rust 二进制的 `strace`，一律标「未实测 + 原因」，只写命令形状与判据。写作机是 macOS arm64 + `rustc 1.99.1`，产物是 Mach-O，`readelf` 读不了，不能代替 Linux 读数。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch17-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.17-A1 · 所有权三条规则各挡什么 {#ex-1.17-A1}

先猜：Rust 有所有权，是否就等于「不会内存泄漏」？`Drop` 一定能运行吗？

用一个 `read_all` 的例子，说出所有权、借用生命周期、`&mut` 独占三条规则在系统编程中各对应哪种 C 风险；再指出这三条**不能**保证什么。给出 `Drop` 不运行的两个具体路径。

::: sol 解答

所有权：一个值一个所有者，`File` 随作用域 `Drop` → `close`，`Vec` 的 `Drop` 释放缓冲，挡住「漏 `close`/`free`」与 double-free。借用生命周期：`&[u8]` 不得长于缓冲区所有者，挡住悬垂指针与 use-after-free；C 里靠文档约定，Rust 变成编译错误（如 `fn dangling() -> &str { let s = String::new(); &s }`）。`&mut` 独占：同一时刻只有一个可变访问，挡住数据竞争，也让编译器能做别名优化。不能保证的是：泄漏（`Box::leak`、`Rc` 环、`mem::forget`）、死锁、资源语义错误（比如把错误文件写进去），以及 `Drop` 一定运行——`panic=abort`、`process::exit`、`mem::forget` 都不跑。

**判据**：三条规则各自绑到具体 C 风险；明确说出「不挡泄漏」；`Drop` 不运行至少给两条路径。

:::
:::

::: ex 例 1.17-A2 · `?`、`From` 与自定义错误 {#ex-1.17-A2}

先猜：函数返回 `Result<_, LoadError>`，里面写 `File::open(path)?` 时，`io::Error` 是怎么变成 `LoadError` 的？

写出 `LoadError` 需要实现的三件套；说明 `?` 在 `Ok`/`Err` 两个分支各做什么；解释为什么这套机制能替代 C 的 `goto cleanup`。

::: sol 解答

三件套：`impl fmt::Display`（给用户看的消息）、`impl std::error::Error`（提供 `source()`，让错误链可追）、`impl From<io::Error> for LoadError`（供 `?` 自动转换）。`?` 在 `Ok(v)` 时取出 `v` 继续执行；在 `Err(e)` 时执行 `From::from(e)` 得到函数声明的错误类型，然后 `return Err(...)`。替代 `goto cleanup` 的原因：返回是正常的作用域退出，所有局部值的 `Drop` 都会运行，因此 `File` 关闭、`Vec` 释放都不需要手写清理标签；`From` 则把「错误类型统一」从散落的 `if` 判断收进一处。要注意 `Drop` 里不能返回错误，所以 `close`/`fsync` 的失败仍然需要显式处理。

**判据**：三件套齐全且说清 `source` 的作用；`?` 两分支正确；能指出「依靠 `Drop` 做清理」与「`close` 错误仍会丢」这一对张力。

:::
:::

::: ex 例 1.17-A3 · `errno`、`ErrorKind` 与重试策略 {#ex-1.17-A3}

先猜：`EAGAIN` 和 `EINTR` 在 Rust 里都会变成错误吗？哪个该重试、哪个该交给 `poll`？

列出 `ENOENT/EACCES/EINTR/EAGAIN/EPIPE/ENOSPC/EINVAL` 对应的 `ErrorKind` 与正确处理；说明 `last_os_error()` 与 `Err(e)` 的区别及使用时机；解释裸 syscall 的返回值约定与 libc 包装的差别。

::: sol 解答

`ENOENT`→`NotFound`（返回错误或创建）；`EACCES`/`EPERM`→`PermissionDenied`（提示或提权）；`EINTR`→`Interrupted`（重试）；`EAGAIN`/`EWOULDBLOCK`→`WouldBlock`（不是错误，交给 `poll`/`epoll`/async）；`EPIPE`→`BrokenPipe`（停止写、处理 `SIGPIPE`）；`ENOSPC`→`StorageFull`（清理或报错）；`EINVAL`→`InvalidInput`（修正调用）。`Err(e)` 保存失败瞬间的错误，稳定；`last_os_error()` 读当前线程此刻的 `errno`，会被后续调用覆盖，只在拿到裸 `-1` 返回值时用且要立刻读。裸 syscall 返回 `-errno`（如 `-2` 表示 `ENOENT`），libc 包装返回 `-1` 并把原因写进 `errno`；用 `asm!` 直接发系统调用时，要自己 `io::Error::from_raw_os_error(-ret)`。

**判据**：七个映射至少对六个；明确 `EAGAIN` 不是错误；`last_os_error` 的「立刻读」说清；`-errno` 与 `-1+errno` 不混。

:::
:::

::: ex 例 1.17-A4 · `unsafe` 的边界与 `// SAFETY:` {#ex-1.17-A4}

先猜：一段代码里出现 `unsafe`，是否意味着它一定有未定义行为？

说明好的 `unsafe` 的三个特征；对 `slice::from_raw_parts`、`transmute`、`Box::from_raw`、`extern "C"` 调用各写一句「必须证明什么」；解释 `OwnedFd::from_raw` 那个例子为什么要 `mem::forget(f)`，以及为什么真实代码应优先用标准类型。

::: sol 解答

三个特征：范围小（一个块或一个函数，不要整模块）、每块有 `// SAFETY:` 写明前置条件、对外只暴露安全 API。`from_raw_parts`：指针非空（长度 0 也要求非空）、对齐、`len` 不越界、内存已初始化；`transmute`：大小相同、位模式合法（`bool` 只能是 0/1）、无 padding 歧义；`Box::from_raw`：指针来自 `Box::into_raw`、只接管一次；`extern "C"`：ABI 匹配、类型与所有权正确、panic 不跨边界。`mem::forget(f)` 是因为 `File` 已拥有 fd，若既保留 `File` 又构造 `OwnedFd`，两个所有者都会 `close`，造成 double-close；`forget` 放弃原所有权，由新类型接管。真实代码应用 `File`/标准 `OwnedFd`，不要手写这层。`unsafe` 本身不产生 UB，写错前置条件才产生。

**判据**：三个特征齐；四类操作的前置条件各说到点；double-close 的机制说清；明确「`unsafe` ≠ UB」。

:::
:::

::: ex 例 1.17-A5 · 线程的所有权形状 {#ex-1.17-A5}

先猜：`thread::scope` 里的闭包能借用栈上的 `Mutex`，换成 `thread::spawn` 还编译得过吗？

对比 `spawn` 与 `scope` 对闭包的生命周期要求，解释原因；说明 `Arc<Mutex<T>>` 与 `Mutex<T>` 在「数据在不在锁里」上的差别；列出 `Send`/`Sync` 各表达什么、`Rc`/`RefCell` 为什么不能跨线程。

::: sol 解答

`spawn` 的线程可能在当前栈帧结束后仍运行，闭包捕获的引用必须 `'static`，所以要么 `move` 所有权、要么 `Arc::clone`；`scope` 在作用域结束前 join 所有子线程，借用不会逃逸，因此可以借用 `&Mutex<T>`，无需 `Arc`。`Mutex<T>` 把数据放进锁里，访问必须先 `lock()` 拿到 `MutexGuard`，不会出现「锁和数据分离、忘了加锁」；`Arc<Mutex<T>>` 在此之上加共享所有权，用于线程要活过作用域的场景。`Send` 表示可以转移所有权到另一线程，`Sync` 表示 `&T` 可以共享到多线程；`Rc` 的引用计数非原子，不是 `Send`；`RefCell` 的借用计数非原子，不是 `Sync`。`unsafe impl Send` 可以绕过，但后果自负。

**判据**：`'static` 的因果说清；能说出 scope 靠 join 收窄生命周期；`Mutex<T>` 的「数据在锁里」说对；`Send`/`Sync` 分工不混。

:::
:::

::: ex 例 1.17-A6 · 四层 FFI 的选择与代价 {#ex-1.17-A6}

先猜：要读 `st_ino` 和权限位，需要下沉到 `libc` 吗？

列出四层各自的优点与代价；给「读 inode/权限」「`epoll` 事件循环」「匹配内核 `ioctl` 结构体」「跨平台库」四种需求各选一层并说明理由；解释 `from_raw_fd`/`into_raw_fd` 为什么是所有权转移点。

::: sol 解答

`std`：安全、可移植、维护成本低，但只覆盖常见操作；`std::os::unix`：暴露 Unix 细节（`MetadataExt::ino`、`PermissionsExt::mode`、`AsRawFd`）而仍是安全 API，代价是仅 Unix、部分差异要 `cfg`；`libc`：与 C 一一对应、最灵活，代价是全 `unsafe`、错误码与结构体自管；`nix`/`rustix`：安全封装、错误转 `Errno`/`io::Result`，代价是额外依赖与版本差异。四种需求：读 inode/权限用 `std::os::unix`；`epoll` 用 `rustix`（或 `nix`）；匹配 `ioctl` 结构体用 `libc` + 把 `unsafe` 收进小模块；跨平台库以 `std` 为主，`cfg(unix)`/`cfg(target_os = "linux")` 分层。`from_raw_fd` 接管一个已有 fd 的所有权（之后 `Drop` 会关闭它），`into_raw_fd` 放弃所有权（之后不再关闭），所以一次 fd 生命周期里两者各用一次，用错就是 double-close 或泄漏。

**判据**：四层代价各一句；四种需求选择有理由；`into_raw`/`from_raw` 的所有权方向不反。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.17-B1 · `read` 返回 0 但不该是 EOF {#ex-1.17-B1}

先猜：一段 C 代码在信号频繁到达时把文件「读短了」，`read` 返回的是 `-1` 还是 `0`？

**现象**：`copy` 程序在定时信号（`SIGALRM` 每 10 ms）存在时偶尔只复制前几 KB 就报告成功。

按「现象 → 机制 → 证据 → 修法」四段分析，并说明 Rust 版本在同一场景下会不会出同样问题。

::: sol 解答

现象：程序正常退出，目标文件比源文件短，没有报错。机制：信号打断 `read` 时返回 `-1`/`EINTR`，若代码把「非正数」一律当 EOF，就会提前结束循环——这不是 `read` 返回 0，而是把 `-1` 误判成了结束。证据：`strace -e trace=read` 能看到 `read(3, ...) = -1 EINTR`，紧接着程序退出；`strace -f` 还能看到信号投递。修法：`if (n < 0) { if (errno == EINTR) continue; /* 真错误 */ }`，并单独判断 `n == 0` 才是 EOF。Rust 的 `File::read` 与 `io::copy` 内部对 `EINTR` 重试，标准库路径不会复现；但用 `libc::read` 或 `nix::unistd::read` 时同样要自己判 `ErrorKind::Interrupted`。

**判据**：指出根因是「`-1/EINTR` 被当 EOF」而不是「`read` 返回 0」；给出 `strace` 证据；修法区分三态；说清 Rust 侧哪条路径仍要自己重试。

:::
:::

::: ex 例 1.17-B2 · 路径没错却 `PermissionDenied` {#ex-1.17-B2}

先猜：`ErrorKind::PermissionDenied` 一定等于 `EACCES` 吗？

**现象**：Rust 程序 `File::open("/var/log/app.log")` 失败，打印 `kind=PermissionDenied raw=Some(13)`，但 `ls -l` 看权限是 `644`，当前用户也在所属组里。

按四段分析，并说明如何用 `raw_os_error()` 区分「权限不足」与「目录不可穿越」。

::: sol 解答

现象：文件权限看起来够，打开仍被拒。机制：`PermissionDenied` 同时覆盖 `EACCES`（13）与 `EPERM`（1）；而且打开文件要逐级穿越父目录，任一级缺少 `x` 位都会返回 `EACCES`，报错点却是最终路径。证据：`raw=Some(13)` 说明是 `EACCES` 而非 `EPERM`；用 `namei -l /var/log/app.log` 看每一级的权限，或 `strace -e trace=openat` 看失败的具体路径与 flags。修法：先确认父目录 `x` 位；再看是否被 ACL/SELinux/AppArmor 拦截（`getfacl`、`ausearch`）；代码里应把路径与 `raw_os_error()` 一起打出来，而不是只打 `kind`。C 侧对应的就是 `perror` + `errno`，同样要区分 `EACCES`/`EPERM`。

**判据**：知道 `PermissionDenied` 覆盖两个 errno；指出目录穿越；给出 `namei`/`strace` 之一作为证据；修法包含「打印路径」。

:::
:::

::: ex 例 1.17-B3 · `write` 只写了一半 {#ex-1.17-B3}

先猜：对一个 64 KiB 缓冲调用一次 `write`，返回值一定是 65536 吗？

**现象**：C 写的日志转发程序把数据写进 pipe 后，下游偶尔收到被截断的行；程序没有报错。

按四段分析，并说明 Rust 侧 `write` 与 `write_all` 的差别。

::: sol 解答

现象：下游收到半行，上游认为写成功。机制：`write` 可以短写，pipe 缓冲区满、信号、非阻塞 fd 都会导致只写一部分；返回值是实际写入字节数，代码若忽略返回值就丢数据。证据：`strace -e trace=write` 看到同一逻辑写被拆成多次 `write(..., 4096) = 4096`；或在下游用 `wc -c` 对比总量。修法：循环推进 `p` 与 `n`，遇 `EINTR` 重试，`w == 0` 视为异常（设 `EIO` 防死循环）；对非阻塞 fd 遇 `EAGAIN` 要等可写而不是重试忙等。Rust 的 `write` 同样可能短写，`write_all` 才保证写完；`io::copy` 内部用 `write_all` 语义。

**判据**：明确「短写合法」；修法含循环 + `EINTR` + `w == 0`；`write` vs `write_all` 的差别说对。

:::
:::

::: ex 例 1.17-B4 · 线程编译不过：`'static` 与 `Send` {#ex-1.17-B4}

先猜：把 `Rc<RefCell<u64>>` 移进 `thread::spawn`，编译器报的是生命周期错误还是 `Send` 错误？

**现象**：下面这段代码编译失败。判断失败原因、给出两种修法，并说明各自代价。

```rust,ignore
use std::rc::Rc;
use std::cell::RefCell;
use std::thread;

fn main() {
    let n = Rc::new(RefCell::new(0u64));
    let h = thread::spawn(move || {
        *n.borrow_mut() += 1;
    });
    h.join().unwrap();
}
```

::: sol 解答

现象：`spawn` 要求闭包 `Send + 'static`，而 `Rc<T>` 不是 `Send`（引用计数非原子），`RefCell<T>` 不是 `Sync`；`move` 已经把所有权移入闭包，所以这里不是生命周期问题，而是 **`Send` 不满足**，报错会点名 `Rc<RefCell<u64>>` 不能在线程间发送。修法一：换成 `Arc<Mutex<u64>>` 或 `Arc<AtomicU64>`，代价是原子操作/加锁开销与 `Mutex` poisoning 语义；修法二：用 `thread::scope`，让闭包借用栈上的 `Mutex<u64>`，不需要 `Arc`，代价是线程必须在作用域内结束。不要用 `unsafe impl Send for ...` 绕过——那只是把 UB 藏起来。证据：编译器报错文本里的 `cannot be sent between threads safely` 与 `` `Rc<RefCell<u64>>` cannot be sent between threads safely ``。

**判据**：判定为 `Send` 而非 `'static`；两种修法各给代价；明确拒绝 `unsafe impl Send`。

:::
:::

::: ex 例 1.17-B5 · Rust 二进制在 Linux 上读不出符号 {#ex-1.17-B5}

先猜：在 macOS 上用 `rustc` 编出的二进制，拿到 Linux 上 `readelf -h` 会成功吗？

**现象**：同学在写作机（macOS arm64）上 `rustc --edition 2021 echo.rs -o echo-rs`，把 `echo-rs` 拷进 VM 后 `./echo-rs` 报 `cannot execute binary file: Exec format error`，`readelf -h echo-rs` 也报 `Error: Not an ELF file`。

按四段分析，并说明这解释了本章哪些结论必须标「未实测」。

::: sol 解答

现象：同一个文件在 macOS 能跑，在 Linux 不能，连 `readelf` 都拒绝解析。机制：macOS 的 `rustc` 默认目标是 `aarch64-apple-darwin`，产物是 **Mach-O**（`MH_MAGIC_64`，段名 `__TEXT`/`__DATA`，符号表由 `LC_SYMTAB` 描述），不是 ELF；Linux 内核的执行器按 ELF 魔数判断，看到 Mach-O 直接返回 `ENOEXEC`。证据：`file echo-rs` 会显示 `Mach-O 64-bit executable arm64`；`xxd -l 4` 看到的是 Mach-O 魔数而不是 `7f 45 4c 46`。修法：要么在 Linux 上装工具链重编，要么交叉编译到 `aarch64-unknown-linux-gnu`（需要对应 linker 与 sysroot）。因此「Rust 二进制的节名、`.dynsym`、`NEEDED`、`R_AARCH64_*` 重定位、`strace` 里是否出现 `O_CLOEXEC`」在本环境都只能标未实测：VM 无 `rustc`，写作机产物格式不对。

**判据**：识别 Mach-O 与 `ENOEXEC`；给出 `file`/魔数证据；说清「格式不同 ≠ 代码错」；列出因此未实测的 Rust ELF 结论。

:::
:::

::: ex 例 1.17-B6 · `SIGPIPE` 把 echo server 打死 {#ex-1.17-B6}

先猜：客户端 `nc` 连上又立刻断开，C 版 echo server 会返回 `EPIPE` 还是被信号终止？

**现象**：单线程 C echo server 在客户端提前关闭后整个进程消失，shell 显示 `Broken pipe`；Rust 版本没有这个现象。

按四段分析，并说明 Rust 侧用裸 `libc::write` 时会不会重现。

::: sol 解答

现象：一个连接断开，整个服务进程退出。机制：对已关闭的 socket 写数据，内核给进程发 `SIGPIPE`，默认动作是终止；`write` 本身不会返回 `EPIPE`，因为进程已经死了。证据：`strace -f -e trace=write,rt_sigaction` 能看到信号；`dmesg` 或 shell 的 `Broken pipe` 提示；对比「忽略信号后」的行为。修法：启动时 `signal(SIGPIPE, SIG_IGN)`（或 `sigaction` 不设 handler 只设 `SIG_IGN`），或对 socket 用 `send(..., MSG_NOSIGNAL)`；之后 `write` 会返回 `-1`/`EPIPE`，按普通错误处理。Rust 标准库在写 socket 时内部规避了 `SIGPIPE`（在支持的平台用 `MSG_NOSIGNAL` 或等效手段），所以 `TcpStream::write` 不触发；但裸 `libc::write` 到 socket 仍会触发，要自己忽略信号或换 `send`。

**判据**：指出默认动作是「终止进程」而非返回错误；给出忽略信号或 `MSG_NOSIGNAL` 的修法；说清 Rust 只在标准库路径上规避。

:::
:::

## C 组 · 动手实验

::: ex 例 1.17-C1 · 用 strace 对照 C 的文件复制调用序列 {#ex-1.17-C1}

先猜：`copy.c` 复制 `/etc/hosts` 时，`open` 还是 `openat`？一次 `read` 就读完吗？`O_CLOEXEC` 会出现吗？

在 VM 上编译正文 1.17.4 的 `copy.c`，用 `strace -e trace=openat,read,write,close` 对照预期；再把 `O_CLOEXEC` 去掉重编一次，看序列变化。**Rust 侧的 `copy.rs` 在 VM 上跑不了（无 `rustc`），按未实测处理。**

::: sol C1 核对

```bash
mkdir -p ~/lab1c17_work && cd ~/lab1c17_work
# 把正文 1.17.4 的 copy.c 存为 copy.c
cc -std=c17 -D_GNU_SOURCE -g -O0 -Wall -Wextra -Werror copy.c -o copy-dbg

strace -e trace=openat,read,write,close ./copy-dbg /etc/hosts /tmp/lab1c17_a 2>&1 | tail -20
```

应看到（顺序与次数依文件大小与 libc 版本）：

- `openat(AT_FDCWD, "/etc/hosts", O_RDONLY|O_CLOEXEC) = 3`：正文的 `copy.c` 已显式加 `O_CLOEXEC`；去掉后这一行变成 `O_RDONLY`。
- 目标文件是 `O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC`，`mode` 参数 `0644` 会被 `umask` 掩掉。
- 若文件大于缓冲区（64 KiB），会出现多次 `read`/`write`；每次 `write` 的返回值应等于当次 `read` 的返回值。
- 结尾的 `close(3)`/`close(4)` 各一次；没有多余的 `close` 说明没有 fd 泄漏。

**未实测部分**：`./copy-rs` 的 `strace` 序列（Rust 的 `File::open` 是否走 `openat`、是否默认 `O_CLOEXEC`）需要 Linux 上的 `rustc` 才能取；VM 没有工具链，写作机产物是 Mach-O 且不能执行。正文 1.17.9 的判据「Rust 走 `openat` 且默认 `O_CLOEXEC`」来自标准库实现与文档，不是本机读数。

**判据**：能读出 `openat` 而非 `open`；能指出 `O_CLOEXEC` 有无的差别；能解释短读短写对应的多次 `read`/`write`；如实标注 Rust 侧未实测。

:::
:::

::: ex 例 1.17-C2 · 用 strace 看线程与 socket 的系统调用 {#ex-1.17-C2}

先猜：4 线程计数程序会看到 4 次 `clone` 还是 5 次？`accept` 还是 `accept4`？`futex` 会出现吗？

在 VM 上编译 1.17.5 的 `threads.c` 与 1.17.6 的 `echo.c`，分别用 `strace -f` 过滤 `clone,futex,exit_group` 与 `socket,bind,listen,accept,accept4,read,write`；记录实际出现的调用名。**Rust 版本（`threads.rs`/`echo.rs`）不跑，按未实测处理。**

::: sol C2 核对

```bash
cd ~/lab1c17_work
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -pthread threads.c -o threads
strace -f -e trace=clone,futex,exit_group ./threads 2>&1 | tail -20

cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror echo.c -o echo
strace -f -e trace=socket,bind,listen,accept,accept4,read,write ./echo 7878 2>&1 | tail -20
```

要点：

- `clone` 的次数包含主线程本身的创建（glibc 的 `pthread_create` 走 `clone3` 或 `clone`），所以「4 个 `pthread_create`」不等于「4 行 `clone`」，以实际输出为准，不要先写死数字。
- `futex` 是 `pthread_mutex_lock` 的底层等待；无竞争时可能一次都不进系统调用（用户态快速路径直接 CAS），所以计数不可当作「锁用了几次」。
- `accept` 与 `accept4`：C 用 `accept` 就是 `accept`；`accept4` 需要显式传 `SOCK_CLOEXEC` 等标志。glibc/标准库是否换用 `accept4` 依实现与版本，**以 `strace` 实际显示为准**。
- `exit_group` 在进程退出时出现一次；`-f` 才会跟到子线程。

**未实测部分**：Rust 版 `threads-rs`/`echo-rs` 的 `clone`/`futex` 序列、Rust `TcpListener` 是否使用 `accept4`、`TcpStream::write` 是否带 `MSG_NOSIGNAL`——都需要 Linux 上的 Rust 工具链；本环境两者都没有，只给命令形状。

**判据**：知道「`pthread_create` 次数 ≠ `clone` 行数」；知道 `futex` 只在慢路径出现；能用 `strace` 输出纠正自己的猜测；Rust 侧标注未实测。

:::
:::

::: ex 例 1.17-C3 · 复现 `SIGPIPE` 打死服务与 `EINTR` 误判 {#ex-1.17-C3}

先猜：不忽略 `SIGPIPE` 时，客户端 `nc` 提前断开，服务进程的退出码是多少？信号编号是多少？

在 VM 上用 C 复现两个故障并修好：① 去掉 `signal(SIGPIPE, SIG_IGN)` 的 echo server，客户端 `printf 'x' | nc -N 127.0.0.1 7878` 提前断开；② 把 `read` 的 `EINTR` 分支改成 `break` 的 `copy`，配一个 `SIGALRM` 定时器复现「读短」。用 `$?`、`kill -l`、`strace` 取证。

::: sol C3 核对

```bash
cd ~/lab1c17_work
# ① 去掉 SIGPIPE 忽略行后重编
sed 's/signal(SIGPIPE, SIG_IGN);//' echo.c > echo_nopipe.c
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror echo_nopipe.c -o echo_nopipe
./echo_nopipe 7879 & sleep 0.2
printf 'hello\n' | nc -N 127.0.0.1 7879
wait $!; echo "exit=$?"        # 被信号终止时 shell 报 128+13=141
kill -l 13                     # PIPE

# ② 定时信号 + 把 EINTR 当 EOF 的 copy
# 在 copy.c 的 read 分支把 `if (errno == EINTR) continue;` 改为 `break;` 得到 copy_bug.c
# 另写一个 setitimer(SIGALRM, 10ms) 的包装或用 `timeout -s ALRM` 反复触发
timeout -s ALRM 0.01 ./copy_bug /etc/hosts /tmp/lab1c17_short || true
ls -l /etc/hosts /tmp/lab1c17_short
strace -e trace=read,rt_sigreturn ./copy_bug /etc/hosts /tmp/lab1c17_short 2>&1 | tail -10
```

要点：

- 被 `SIGPIPE` 终止时，shell 的 `$?` 是 **141**（128+13），不是 1；`strace -f` 能看到 `--- SIGPIPE ---`。
- 加回 `signal(SIGPIPE, SIG_IGN)` 后，`write` 返回 `-1/EPIPE`，服务继续运行，`$?` 由程序自己决定。
- `EINTR` 误判的实验需要在 `read` 阻塞期间投递信号；`timeout -s ALRM` 只是最省事的近似，能否稳定复现取决于时序——**复现不出来不算你错**，能说出「`read` 返回 `-1/EINTR`，被当成 EOF 就会提前结束」即可，`strace` 里的 `= -1 EINTR` 是关键证据。

**未实测部分**：Rust 版在同场景下的行为（标准库是否重试、是否触发 `SIGPIPE`）未在 VM 上验证；`rustc`/`cargo` 不在，写作机产物不能执行。

**判据**：读出 141 与 `SIGPIPE`；能用 `strace` 指出 `-1 EPIPE` 或 `-1 EINTR`；修法分别是「忽略信号/`MSG_NOSIGNAL`」与「`EINTR` 重试」；如实标注 Rust 侧未实测。

:::
:::

::: ex 例 1.17-C4 · `cargo check`/`clippy`/`miri` 与 FFI 错误映射 {#ex-1.17-C4}

先猜：`cargo check` 通过的程序，`cargo clippy -- -D warnings` 一定通过吗？`miri` 能跑 `strace` 能看到的系统调用吗？

按 1.17.10 写出完整命令序列（建 crate、`check`、`clippy -D warnings`、`miri`、`size`/`nm`、静态库 FFI 错误映射）。**本环境无法执行，全部标未实测 + 原因**；请写出「如果在一台有 Rust 工具链的 Linux 上跑，每一步的判据是什么」。

::: sol C4 核对

命令形状（照 1.17.10）：

```bash
cargo new --bin sysdemo && cd sysdemo
cargo check
cargo clippy -- -D warnings
rustup component add miri && cargo +nightly miri test
cargo build --release && size target/release/sysdemo && nm -C target/release/sysdemo | head
# FFI：c_errno.c 里 errno=ENOENT; return -1，ar 成 libcerrno.a，rustc 链接后
./ffi_errno            # 期望 rc=-1 kind=NotFound raw=Some(2)
```

如果可跑，判据是：

- `check` 只做类型/借用检查，不产码；它通过后仍可能链接失败或运行错误。
- `clippy -D warnings` 会把 `unwrap()`、`as` 截断、未使用的 `Result` 等变成错误；它通过不代表没有逻辑错。
- `miri` 抓越界、悬垂、未初始化读、别名违规；遇到系统调用会拦截或不支持，**不能**用它验证文件/socket 行为。
- `size`/`nm` 读的是 ELF 产物的段与符号；`nm -C` 会 demangle，看不到 `_R`/`_ZN` 前缀时要改 `nm` 原样输出确认导出名。
- FFI 用例的期望输出是 `rc=-1 kind=NotFound raw=Some(2)`，它证明「`-1` + `errno` → `io::Error` 的映射」在真实链接下成立。

**未实测 + 原因**：VM 是 Ubuntu 24.04.5 aarch64，**没有 `rustc`/`cargo`/`rustup`**，四条命令一条都跑不了；写作机是 macOS arm64 + `rustc 1.99.1`，能编单文件，但没有 `cargo` 工作流的完整验证环境，且产物是 **Mach-O**——`readelf` 读不了、`nm`/`size` 的字段模型不同（`__TEXT`/`__DATA`、`LC_SYMTAB`，无 `.dynsym`/`NEEDED`），`miri` 组件也未必安装。因此本套件只给命令与判据，不给任何输出数字。

**判据**：命令序列完整；三层工具的盲区各说一句；FFI 期望输出给出 `kind`/`raw` 两项；明确写出「无工具链 + Mach-O」两条原因。

:::
:::
