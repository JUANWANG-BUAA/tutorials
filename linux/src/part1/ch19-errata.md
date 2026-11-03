# 1.19 勘误与版本注记

这一页收本章最容易「换一版 rCore、换一条 Rust 工具链、换一版 Linux 或换一本扫描版教材就不成立」的东西：rCore 章节与本书的对应、只读源码与「运行过」的边界、RISC-V 特权级与 Linux 的差异、rcore-os 的 nightly 与主线 stable 的差异、CSAPP/李治军扫描版的页码问题，以及本章未实测项。正文的 `errata` 盒讲理解陷阱；这一页讲**换版本、换环境之后要复核什么**。

**本章基线**：1.19 的八阶段组织参考 rCore 教程 chapter1–8，代码与 `myrcore` 叙事独立重写，不复制 GPLv3 代码。**本机没有 RISC-V 硬件，也没有可用的 QEMU/GDB 运行链路；rCore 只能读源码对照，不构建、不运行。** 写作机能跑普通 `rustc`（macOS arm64、`rustc 1.99.1 (58cf8f9c3 2026-10-13)`），所以本章**三个不依赖目标机的主机程序已复跑**：`sv39.rs`（三级页表切片，输出含 `frames = 4`）、`myfs.rs`（文件系统镜像构造/解析，另加 `std::fs::write` 落盘后用 `xxd` 转储字段）、`lab1c19_sync.rs`（自旋锁 40000、无锁三次分别 32016/28283/29584、`fetch_add(Relaxed)` 三次 40000）。测试 VM（Ubuntu 24.04 aarch64）上复跑了一套产物读数：一个 `-e _start` 的静态 aarch64 ELF 的 `readelf -h/-l`、`nm`、`size`、`objdump -d`。**没有**本机证据的仍是 `cargo build` 出 RISC-V 内核、QEMU 串口、GDB 断点与寄存器值；交叉汇编连产物都拿不到——`clang --target=riscv64` 在本机直接失败，原文是 `clang (LLVM option parsing): Unknown command line argument '-riscv-add-build-attributes'`。凡标「未实测」的，见末节。

## 1. 十七条容易搬家的结论

| 看起来像 | 实际是 | 怎么验证 |
|:--|:--|:--|
| 「rCore chapter1–8 与本书 1.19.2–1.19.7 可以按章节号一一对号入座」 | 只对「主题顺序」成立。本书把 chapter1/2 压进 1.19.2，把 chapter3 拆成 1.19.3 的「多任务」与「抢占」，把 chapter4 对到 1.19.4，把 chapter5–8 对到 1.19.5–1.19.7；具体小节号不一一对应 | 以 [1.19.1 的映射表](ch19.md#sec-1.19.1) 为准；引用 rCore 时写「chapter N 的主题」，不写「rCore 第 N 章第 x 节 = 本书 1.19.x」 |
| 「rCore 只有一个版本，书里的 API 就是 rCore 的 API」 | rcore-os 组织下有 rCore、rCore-Tutorial-v3 及课程衍生分支；`TaskControlBlock` 字段、`File` trait 是否含 `seek`、`MemorySet` 的命名随 commit 变。本书不绑定 commit，代码独立重写 | 读你手上仓库的 `README`、`rust-toolchain.toml`、`Cargo.lock` 与目录；引用写仓库 URL + commit，不写「rCore 就是这样」 |
| 「读过 rCore 源码，所以 `myrcore` 的构建和 QEMU 输出都验证过」 | **只读源码不能声称运行。** 本机没有 RISC-V 硬件/QEMU/GDB；所有 `cargo build`、`qemu-system-riscv64`、`batch: app exit`、GDB 断点都是形状示例，不是本机会话 | `command -v qemu-system-riscv64 gdb-multiarch`；`rustup target list --installed`；没有就标未实测，不要抄输出 |
| 「1.19.2 说四个文件可以直接 `cargo build`，所以它一定能编译」 | 这是正文的**声称**，不是本机结果；构建还依赖 `riscv64gc-unknown-none-elf` target、链接脚本路径、`panic=abort` 与 `global_asm!` 引用的文件存在。本套件未构建 | 在装了 target 的机器上 `cargo build --release`，保留完整错误；构建失败不等于概念错，构建成功也不等于能启动 |
| 「RISC-V 有 M/S/U 三级，Linux 也跑在三级上，所以本章 `TrapFrame` 可直接套 Linux」 | RISC-V 规范定义 M/S/U；Linux 只实现 S 态内核与 U 态用户，M 态交给 OpenSBI 一类固件。Linux 的 trap 入口、`pt_regs` 布局、`sscratch`/`tp` 分工、定时器与 IPI 的 SBI 调用、页表级别（Sv39/Sv48/Sv57 与 4/5 级折叠）都与教学内核不同 | 对照 `arch/riscv/kernel/entry.S`、`asm/ptrace.h` 的 `pt_regs`、`Documentation/riscv/vm-layout.rst`；不要把教学 `TrapFrame` 当 Linux ABI |
| 「rcore-os 的 Rust 写法可以原样搬到主线 stable」 | rcore-os 的仓库通常用 `rust-toolchain.toml` 钉住某一 nightly，使用当时的 `#![feature(...)]`、`asm!`/裸函数写法与 `spin`/`riscv` 依赖版本；主线 stable 没有这些 feature gate，宏与依赖 API 也会变。具体 nightly 日期以仓库文件为准，本书不抄 | `rustc --version`；读 rCore 的 `rust-toolchain.toml` 与 `Cargo.lock`；移植时按 stable 重写，不按旧 nightly 报错搜 |
| 「可以按 CSAPP 扫描版页码或李治军课程视频页码核对本章」 | 扫描版页码、图号、习题编号随版次与扫描批次漂移；李治军操作系统课程还有多个录制版本。**只能按目录、章节标题与概念核对**，不能把页码当稳定锚点 | 用纸质版目录或出版社电子版章节号；引用写「CSAPP 第 9 章 虚拟内存」「李治军课程『进程与线程』模块」，不写 p.xxx |
| 「1.19.4 和 1.19.6 的主机程序能 `rustc` 直接跑，所以输出就是实测」 | 本套件**没有复跑**这两个主机程序；`rustc` 版本、64 位主机、`usize` 宽度都会影响结果。即便主机能跑，也只证明「字节布局/遍历逻辑自洽」，不证明内核里能跑 | 在 64 位主机上 `rustc -O sv39.rs`、`rustc -O myfs.rs`；记录 `rustc --version` 与输出；失败时按编译错误修，不要改正文 |
| 「1.19.2 的『同一阶段的 C 视角』给了完整 C 版」 | 该节只有一段文字说明 C 与 Rust 的差异，**没有 C 代码块**；不要声称存在一个可编译的 C 版批处理内核 | 对照 1.19.2 的标题与代码块；需要 C 版时按 Rust 结构自行重写，并注明「本书未给出」 |
| 「1.19.7 的『4 个线程各加 10000 次』有完整程序和实测输出」 | 该节只给出一个 C 自旋锁片段；「运行」「预期输出」两段是空的，`counter = 40000` 与 `order = ["main","worker"]` 没有对应完整代码与命令 | 按 1.19.7 的标题与代码块核对；要验证就自己补线程/信号量代码，不要把预期输出当实测 |
| 「`PageTable::drop` 里的 `frame.drop_in_place()` 会释放整个页表页」 | `drop_in_place()` 只 drop 指针处的一个 `PageTableEntry` 值，不会释放 512 项的页，也不会把物理页还给分配器；示例是类型示意，不是可用的页表释放器 | 看 `Drop` 实现与 `frames` 的所有权注释；真正释放要交给 `FrameAllocator`，并区分页表页与数据页 |
| 「1.19.2 的批处理示例已经处理好用户栈」 | 示例只设 `sscratch`，没有给 U 态准备独立 `sp`；它能跑是因为应用只有 `addi`+`ecall`，不使用栈。真实应用第一条压栈就会踩内核数据 | 看 1.19.2 的加载器六步与「最容易错的是第 3 步」；补用户栈后再 `sret` |
| 「`PageTableEntry::is_leaf` 只看 `R/W/X` 就够了」 | 示例的 `is_leaf()` 是 `self.0 & 0b1110 != 0`，**没有检查 `V`**；对无效 PTE 也会返回 true。遍历时应先判 `V`，再判叶子 | 看 1.19.4 的 `is_valid`/`is_leaf`；在自己的实现里写成 `V && (R || X)`，或先 `is_valid` 再 `is_leaf` |
| 「`myfs` 的 inode 槽 32 字节，所有字节都有定义」 | `write_inode` 只用 `mode`（0–1）、`size`（4–7）、`direct`（8–23），共 24 字节；2–3 与 24–31 未定义。镜像里这些字节是 0，不代表字段 | 对照 1.19.6 的 `write_inode`/`read_inode`；扩展字段前先定偏移与对齐，不要依赖未定义字节 |
| 「`myfs` 就是 easy-fs，块号可以互读」 | `myfs` 是 512 字节块、五段布局、4 个直接块号的教学简化；easy-fs 的位图/inode/目录项布局与缓存策略不同，不能拿 `myfs` 的块号去读 easy-fs 镜像 | 对照 [1.19.6 的表](ch19.md#sec-1.19.6) 与 rCore chapter6 的磁盘布局；只对照「超级块/inode/位图/数据区」的概念，不互读镜像 |
| 「1.19.9 的 Linux 6.8 对照就是当前内核」 | 对照表锁在 Linux 6.8；主线内核的调度器、`struct file`、VFS 接口与 RISC-V 页表支持都在演进。把 6.8 当「读源码的起点」，不要当「当前事实」 | `uname -r`；查你读的版本的 `Documentation/` 与头文件；引用时写明版本 |
| 「rCore 是 MIT/BSD，可以随便复制进自己的项目」 | 本章参考的 rCore 教程标注 GPLv3；本书不摘录、不复制代码。你要复用 rCore 代码，必须按 GPLv3 处理，不能当成无版权示例 | 看 rCore 仓库的 `LICENSE`；本书示例是独立重写，许可证以本书为准 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**待验证的形状、量级或方法**，不要抄成事实：

- **所有 rCore 构建与运行**：本机不附带 rCore 仓库，不执行 `cargo build`；测试 VM 上 `command -v qemu-system-riscv64 gdb-multiarch riscv64-linux-gnu-as` 无输出、退出码 1（实测），写作机也没有这些命令，且 `sudo` 需要密码、无法安装。因此 1.19.2–1.19.10 的串口输出、断点命中、寄存器值都没有本机记录。
- **本章 `myrcore` 构建**：`riscv64gc-unknown-none-elf` target、链接脚本、`entry.asm`/`trap.asm` 的路径与 `panic=abort` 配置未在本机验证；`batch: load app at 0x80400000`、`batch: app exit` 只是形状。
- **主机示例已复跑（不再是预期形状）**：1.19.4 的 `sv39.rs`、1.19.6 的 `myfs.rs`、1.19.7 的并发程序都在写作机 `rustc -O` 下真跑过，正文里的数值就是那次输出；但三只程序证明的只是**算法与布局**，不证明 RISC-V 上的指令编码、页表实际写入与设备时序。
- **交叉汇编**：原本以为写作机可做 `clang --target=riscv64-unknown-elf -march=rv64gc -mabi=lp64d -S/-c`，本次实测**不成立**：Apple clang 21 的汇编器不认 RISC-V，`clang --target=riscv64 -c` 报 `Unknown command line argument '-riscv-add-build-attributes'`（原文见上），连 `.o` 都没有。测试 VM 只有 aarch64 的 `as`/`ld`/`objdump`。所以本章所有 RISC-V 指令的**编码**都只有纸面依据。
- **GDB 命令**：`gdb-multiarch ... -ex 'target remote :1234'`、`info registers satp scause sepc` 只是命令形状；GDB 是否识别某个 CSR、断点能否命中，取决于版本与符号。
- **版本细节**：rCore 的 chapter/字段/API 随仓库与 commit 变；rcore-os 的 nightly 日期、`spin`/`riscv` 依赖版本、`asm!`/裸函数写法随版本变；Linux 6.8 的结构名与字段以你读的源码树为准。本页不给「某年某月某 commit」的断言。
- **扫描版教材**：CSAPP 与李治军课程只按目录、章节标题与概念核对；页码、图号、习题编号不作引用锚点。

## 发现新问题怎么记

按「现象 → 命令与输出 → 版本与环境 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大多挂在 rCore 版本、Rust 工具链与 QEMU 上，所以请一并附上：`uname -a` 与 `uname -m`；`rustc --version` 与 `rustup target list --installed`；rCore 仓库 URL 与 commit；`rust-toolchain.toml` 与 `Cargo.lock` 的关键行；`qemu-system-riscv64 --version`（如果有）与完整命令行；`gdb-multiarch --version`；以及 `satp`/`scause`/`sepc` 的十六进制值。涉及数字时写明口径：是教程组织、规范条款、量级示例，还是「未实测」。本章多数分歧都出在把「读源码」当成「跑过」，或把「预期输出」当成「本机记录」。
