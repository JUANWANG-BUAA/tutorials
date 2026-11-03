# 1.7 勘误与版本注记

这一页收本章最容易「记成永久真理」的东西：链接器与加载器的行为随工具链（GNU ld、macOS ld64、lld）变、glibc 与符号版本是一对绑定的事、`readelf`/`objdump` 的显示措辞随版本变、PLT/GOT 的字节形状随架构变、Rust 的符号命名自成一套。正文里的 `errata` 盒讲理解陷阱；这一页讲**换一台机器、换一套工具链、换一个架构之后要复核什么**。

**本章基线**：正文没有为任何一段输出标注机器归属，归属集中记在这一页。实测基线是一台 Ubuntu 24.04.5 LTS 虚拟机（aarch64，内核 `7.0.0-38-generic`，GCC 13.3.0，GNU Binutils 2.42，glibc 2.39，`sudo` 需密码不可用）。本次在该机上复跑并与正文口径一致的，下文标「VM 实测」：默认 `-fno-common`（`nm` 给 `B counter`，加 `-fcommon` 才变 `C counter`）与 `multiple definition` 的报错形态、归档顺序错误点名库成员、弱默认实现被强定义覆盖的两组退出码、`-Wl,-rpath` 默认生成 `DT_RUNPATH`、`--disable-new-dtags` 得到的 `DT_RPATH` 优先于 `LD_LIBRARY_PATH`、默认产物即带 `BIND_NOW` 与 `GNU_RELRO`、`PT_INTERP` 为 `/lib/ld-linux-aarch64.so.1`、`--wrap=puts` 生效、`LD_PRELOAD` 钩子在 `ls`/`cat` 上无任何报告、glibc 2.39 下 `-ldl` 可省。写作机是 Apple 芯片的 macOS（arm64）：Apple clang 21.0.0、`ld` 为 ld64（构建 27037.1）、`nm` 是 llvm-nm、rustc 1.99.1，无 `readelf` 与 `ldd`（实测 `command -v` 为空）。除「VM 实测」「写作机实测」外，凡是带具体地址、字节、行号的 x86-64 输出都只是形状示例，一律按第 6 节当未实测。

## 1. GNU ld、macOS ld64 与 lld 的行为差异

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | 正文 1.7.1 的 `ld -pie --eh-frame-hdr ... -dynamic-linker /lib64/...` 在任何机器上都打得出 | 那是 Linux 上 GCC 驱动 GNU ld 的形态。VM 实测 `cc -v` 里同样出现 `-pie`、`--build-id`、`-dynamic-linker` 三个参数，但解释器路径是 aarch64 的；macOS 的 `cc` 调的是 ld64，不认这组 GNU 参数，产物是 Mach-O，本节其余各行谈的 ELF 行为都不适用于它 | 写作机实测：`file /bin/ls` 报 Mach-O 通用二进制；`ld -v` 报 ld64（PROJECT 行 27037.1）；`cc -v` 报 Apple clang 21.0.0 |
| 2 | `readelf`、`objdump`、`ldd`、`nm` 是通用工具 | 前三者在 macOS 上默认不存在（写作机实测 `command -v readelf` 与 `command -v ldd` 皆空），`nm` 是 llvm-nm（`nm --version` 自报「llvm-nm, compatible with GNU nm」）。C 组与判读行的命令全部要在 Linux 虚拟机上跑 | 对照表：依赖清单用 `otool -L`（实测 `/bin/ls` 列 `libSystem.B.dylib` 等，带 compatibility 与 current 双版本），装载命令用 `otool -l` |
| 3 | `nm` 里的符号名两边一致 | Mach-O 给 C 符号统一加前导下划线：写作机实测同一个 `main` 在 macOS 显示 `_main`，ELF 侧是 `main`。跨平台对符号做差集前先把这一层对齐，否则会误判「定义缺失」 | `cc lab.c -o lab && nm lab`（两个平台各跑一次） |
| 4 | `-Wl,-rpath,'$ORIGIN/../lib'` 写进去的就是 `RUNPATH` | 取决于链接器默认：VM 实测 GNU ld 2.42 默认生成 `DT_RUNPATH`，加 `-Wl,--disable-new-dtags` 才得到 `DT_RPATH`；ld64 没有这两个标签，写的是 `LC_RPATH` 装载命令（写作机实测 `otool -l` 可见）。正文 1.7.6 的五步搜索顺序只对 Linux 的 `ld.so` 成立 | `readelf -d` 看标签名；`otool -l` 看 `LC_RPATH` |
| 5 | lld 与 GNU ld 选项行为完全一致 | 本章没有单独测 `ld.lld`。`--wrap`、`--as-needed`、`--build-id` 在 lld 里有同名选项，但 dtags 默认、加固默认等策略未逐项比对，用 lld 时把第 2、4 节涉及「默认」的结论全部当未实测重测 | `-fuse-ld=lld` 重链一次，对比 `readelf -d` 的 `RUNPATH`/`BIND_NOW` 行 |

## 2. glibc、加载器与符号版本

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 6 | `memcpy@@GLIBC_2.14`、`puts@GLIBC_2.2.5` 是所有 glibc 的标签史 | 那是 x86-64 glibc 的版本沿革；aarch64 的 glibc 从更高的最低标签起步。VM 实测现编的 hello 在 `readelf -V` 里只需求 `GLIBC_2.17` 与 `GLIBC_2.34` 两个节点。拿正文的标签去查你自己的二进制，对不上是正常的 | `readelf -V ./prog` 看 `.gnu.version_r`；`nm -D /lib/.../libc.so.6` 看导出集 |
| 7 | 「`version not found` 与 `cannot open shared object file` 是同一类找不到」 | 不同层：后者是路径层，前者是符号标签层——文件已找到、需求表里的标签对不上。判据不同命令：路径层走 `LD_DEBUG=libs`，标签层走 `readelf -V` 加 `nm -D` 做两侧差集。这条区分是工具用法结论，与机器无关 | 习题 [B3](ch07-exercises.md#ex-1.7-B3)、[C8](ch07-exercises.md#ex-1.7-C8)：用版本脚本自造「FOO_1.0 换成 FOO_2.0」的复现，不需要 root |
| 8 | 「glibc 2.34+ 后 `-ldl` 可省」到处成立 | 在 VM（glibc 2.39）实测：`malloc_count.c` 带不带 `-ldl` 都能编译通过。更老的发行版上不加会失败，正文 1.7.13 的 errata 第 4 条只在这个意义上可靠 | `getconf GNU_LIBC_VERSION`；两种链接命令各跑一次 |
| 9 | `DT_RPATH` 优先于 `LD_LIBRARY_PATH` 是背来的结论 | VM 实测成立：两个同名库放 A、B 目录，主程序以 `--disable-new-dtags` 记 `DT_RPATH=A`，`LD_LIBRARY_PATH=B` 时仍加载 A（`LD_DEBUG=libs` 与程序自报的取值一致） | 按第 4 节命令复现；注意默认 `RUNPATH` 时顺序相反（环境变量在前） |
| 10 | setuid 程序忽略 `LD_LIBRARY_PATH` 随手可验 | 需要 setuid 测试程序与 root；VM 的 `sudo` 需密码、不可用，本书未复现这条。口径沿用 Kerrisk 第 41、42 章，安全执行模式还影响 `RPATH` 的处理细节，引用时写明未实测 | 有 root 的机器上 `chmod u+s` 一个测试程序对照；`ldconfig -p` 的只读查询不需要特权（VM 实测可列 `libc.so.6`） |
| 11 | 静态链接的程序不依赖系统 | 「glibc 静态下 NSS/`dlopen`/locale 行为受限」是文档级结论，本书未构造对照程序。静态产物不吃 `LD_PRELOAD` 这一点正文与习题 C3 给了自查方法（`readelf -d` 无 `NEEDED` 即确认） | 在旧系统对照跑一个静态程序做名字解析；本章未做 |

## 3. ELF 字段显示随工具链版本变化

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 12 | `readelf`/`objdump` 的输出格式是接口 | 措辞与列排布随 binutils 版本变，本章只在 Binutils 2.42 上核对过（如 VM 实测 `Type: DYN (Position-Independent Executable file)`）。把判读写成「找 `Type` 列里的 DYN/EXEC」，不要 grep 整行字符串 | `readelf --version` 先报版本；跨版本对比同一文件的 `-h`/`-S`/`-d` 输出 |
| 13 | 1.7.9 的三行十六进制与 1.7.12 的 elfdump 输出可复现 | 那是标注 x86-64 的示例对象（`machine=62`、`shnum=11`、`shoff=0x228`）。VM 无 x86-64 交叉编译器（实测 `command -v x86_64-linux-gnu-gcc` 为空），同做一份 `.o` 的 `e_machine` 会是 183。这些数值只用来练「按偏移读字段」，不是任何人的读数 | 拿自己机器编的 `.o` 跑 [C6](ch07-exercises.md#ex-1.7-C6) 与 `readelf` 对账，对得上才是判据 |
| 14 | 1.7.15 的 hello 会话（入口 `0x1050`、`main` 在 `0x1139`、PLT 字节 `ff 25 ...`）是你的机器也会给出的 | 全组 x86-64 形状。VM 上同一条命令实测：`Machine: AArch64`、入口 `0x640`。具体地址与字节随架构、编译器版本、优化级别变，只有「`Type` 是 `DYN` 即 PIE」这类判读可移植 | `readelf -h`、`nm`、`objdump -d --section=.plt` 三步在自己机器上各跑一次 |
| 15 | `/proc/self/maps` 里同一个文件固定映射成四行 `r--/r-x/r--/rw-` | 正文那六行是 x86-64 示例。VM 实测 `cat` 只有 `r-xp/r--p/rw-p` 三个区间、地址是另一套形态——段数取决于该二进制自己的 `PT_LOAD` 个数与权限拆分方式，不是定律 | `readelf -l` 数 `PT_LOAD`，再对照 `/proc/self/maps`，两者一致才算读懂 |
| 16 | `e_shnum=0` 时改用节 0 的 `sh_size`、压缩节、`.gnu.hash` 这些扩展行为随遍可得 | 正文 1.7.12 只是点到 `readelf` 还处理这些边界；本章未构造触发任何一个的文件，`elfdump.c` 也明说只处理小端 ELF64。当作已知未验证的读表备注 | 想要实证就自己造（`e_shnum` 溢出需 >65535 个节，本章未做）；或直接 `readelf -h` 一个大型 C++ 目标文件看扩展字段 |
| 17 | 1.7.7 那段 `checksec` 输出格式是依据 | `checksec` 未安装（VM 实测）。正文两行只是形状示例；替代判据四条全在 `readelf`：`-h` 的 `Type`、`-d` 的 `BIND_NOW`/`FLAGS`、`-l` 的 `GNU_RELRO` 与 `GNU_STACK` 权限位，见 [C7](ch07-exercises.md#ex-1.7-C7) | 上面四条判据；`Stack Canary` 与 `FORTIFY` 要看反汇编与 `__*_chk` 符号，本章未逐一验证 |

## 4. x86-64 与 aarch64 的 PLT/GOT 差别

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 18 | `jmp *GOT[n]`、`push 索引`、`jmp plt0` 三条就是所有平台的 PLT 桩 | 那是 x86-64 形状。VM 实测 AArch64 的 `.plt` 头是 `stp x16, x30`、`adrp`、`ldr`、`add`、`br x17` 加 nop 补齐，没有 `push` 序列。机制（首次经解析器、之后一次间接跳转）同，字节与寄存器约定不通 | `objdump -d --section=.plt ./prog`，两种架构各看一次 |
| 19 | 延迟绑定是 ELF 动态链接的默认 | 取决于发行版给编译器的 specs，不是架构属性。VM 实测 Ubuntu 24.04 默认产物：`FLAGS` 含 `BIND_NOW`、`FLAGS_1` 含 `NOW PIE`、`.rela.plt` 里 `JUMP_SLOT` 计数为 0——「第一次调用才解析」在这台机器上根本不发生，与习题 [C4](ch07-exercises.md#ex-1.7-C4)、[C7](ch07-exercises.md#ex-1.7-C7) 的口径一致；正文 1.7.6、1.7.15 按通用教学形态讲的懒绑定要显式 `-Wl,-z,lazy` 才复现 | `readelf -d` 看 `BIND_NOW`，`readelf -r` 数 `JUMP_SLOT`；再编一份加 `-Wl,-z,lazy` 对比 |
| 20 | 1.7.11 的类型表到处适用 | 表是 `R_X86_64_*`。AArch64 是 `R_AARCH64_*` 一族（VM 实测 `readelf -r` 出现 `R_AARCH64_RELATIVE`），名字、编码、哪些类型存在都不同；`S + A - P` 的算术与 `A = -4` 的补偿推理是确定性的纸面结论，概念可移植，字节形状不可 | 两架构各 `readelf -r` 一个 `.o` 对照类型列 |
| 21 | `PT_INTERP` 的内容是 `/lib64/ld-linux-x86-64.so.2` | 随架构：VM 实测为 `/lib/ld-linux-aarch64.so.1`（`readelf -p .interp`）。正文 1.7.2 布局图与 1.7.15 的 `ldd` 输出都是 x86-64 形态 | `readelf -p .interp`；aarch64 上 `ldd` 的库路径带 `aarch64-linux-gnu`（实测） |
| 22 | 「非 PIC 目标混进 PIE 会报 `relocation truncated to fit`」在哪台机器都打得出 | 该错误形态与 `R_X86_64_32S` 同属 x86-64 语境；aarch64 上的等价失败本章未构造，VM 也无法编 x86-64。引用户型时先注明架构 | 在 x86-64 机器上用 `-fno-pie` 对象混链一份；AArch64 侧未测 |

## 5. Rust 的链接与命名

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 23 | Rust 符号长成 `_RNv...` | v0 mangling 以 `_R` 开头，后续编码随项与 crate 名变。写作机实测（macOS，rustc 1.99.1）`nm` 看到 `__RINvNtNt...` 形态——`_R` 前再叠了一层 Mach-O 前导下划线；ELF 侧的实际形态与 `nm -C` 能否还原，因 VM 无 Rust 工具链未验证（实测 `command -v rustc cargo` 为空） | 在 Linux 上 `rustc -O t.rs -o t && nm t`、`nm -C t` 各看一次；macOS 上注意多出的下划线 |
| 24 | 正文 1.7.14 的对照表逐格可复现 | 除第 23 行的 mangling 片段外，整表（`--crate-type staticlib`/`cdylib` 的产物形态、`#[repr(C)]`、`#[used]` 加 `link_section` 的落节、`-C lto=fat`、panic 跨 `extern "C"` 边界 abort、默认可见性隐藏）本书未在任一机器运行验证，属文档级结论 | 装好 Rust 的机器上按表格逐格编一份，`nm`/`readelf -S` 对照；本章未做 |
| 25 | 正文 1.7.16 第 10 条「Rust 符号 `nm` 找不到」的原因已实测 | 「被 mangle」由第 23 行的写作机输出支持；「被 LTO 删除」与 `#[used]` 保住它，两种情形都未构造。修法方向可用，别把条目号当实验结论引用 | `nm` 与 `nm -C` 对同一产物；开 `lto = "fat"` 再对比符号数 |

## 本章未实测项

下面这些没有本机证据支撑，引用前请当作**形状示例或待验证结论**，不要抄成事实：

- **全部 x86-64 专属输出**：1.7.2 的 `readelf -h hello` 与 `readelf -s hello.o` 摘录行、1.7.4 的 `objdump -dr call.o` 字节与 `R_X86_64_PLT32 puts-0x4`、1.7.9 的 `demo.o` 十六进制、1.7.11 含 `vsum - 4` 的 `readelf -r` 记录、1.7.15 的整段会话（`file`、`ldd`、`objdump`、`nm` 各输出）。VM 是 aarch64 且无交叉工具链，一条都无法原位复跑；只能在 x86-64 的 GNU 工具链上自己重跑。两处手算（`e8 eb fe ff ff`、`-0xa7`）是确定算术，判据在纸上不在机器上。
- **1.7.13 的 `LD_PRELOAD=./libcount.so ls` 打印 `live allocations = 0`、1.7.8 的 `count_malloc.so` 配 `/bin/ls` 演示**：VM 实测同一份钩子编出来后，`ls` 与 `cat` 一行报告都没有（它们经 `_exit` 一类路径收场，ELF 析构不执行），从 `main` 正常返回的自写程序才有输出。正文那两行是形状示例；习题 [B7](ch07-exercises.md#ex-1.7-B7)、[C3](ch07-exercises.md#ex-1.7-C3) 已把这点立为验收边界，别拿「没输出」当打桩失败，也别拿它当成功证据。
- **两个完整程序的编译运行**：1.7.6 的 `dlopen.c` 与 1.7.12 的 `elfdump.c` 本书未在 VM 上跑过（后者对 AArch64 目标文件的对账由 C6 自行完成，正文那份 x86-64 输出见上一条）。`count_malloc.c` 的三处缺陷（多线程丢计数、`dlsym` 递归风险、析构里 `snprintf` 可能分配）是机制推断，未做压测。
- **懒绑定路径的逐项观测**：`LD_DEBUG=bindings` 的绑定次数对比、`LD_BIND_NOW=1` 前后第一次调用的耗时差，VM 只做了一次 `LD_DEBUG=libs` 的目录列举；绑定计数未逐条核对。
- **需要特权的条目**：setuid/sgid 安全执行模式、`/etc/ld.so.cache` 的更新（`ldconfig` 写缓存）、把库装进系统目录——VM 无 `sudo`，全部未实测；`ldconfig -p` 的只读查询可用（实测）。
- **lld、旧 binutils 与 x86-64 Ubuntu 的默认加固**：第 1、3 节标注的「默认」结论只对 GNU ld 2.42 与这台 aarch64 VM 成立；x86-64 的 Ubuntu 24.04 未验证，跨发行版（尤其非 Debian 系是否默认 `-z now`）更未验证。
- **Rust 侧除第 23 行 mangling 片段外的一切**：ELF 产物形态、`crate-type`、`link_section`、`panic` 边界行为，见第 5 节；VM 没有 Rust 工具链。
- **与 CSAPP、Kerrisk 的核对方式**：CSAPP 中文第 3 版在本机是纯扫描版、没有文本层，`tesseract` 缺 `chi_sim`，中文 OCR 不可用。本章只按第 7 章 7.1–7.14 的小节结构核对覆盖面（见正文末对照表），没有引用书里的句子和页内数字；Kerrisk 两册可抽页，用它核对的是 `PT_INTERP` 归属、库命名与搜索顺序、`dlopen`/`LD_PRELOAD`/`LD_DEBUG` 这一侧的用户态接口口径。

## 发现新问题怎么记

按「现象 → 命令与完整输出 → 机器/内核/工具链版本 → 建议改法」四段记，不要只写「我这里不对」。本章的结论大量挂在工具链与架构上，所以请把这些行一并贴上：`uname -m` 与 `/etc/os-release` 的发行版行；`gcc --version`、`ld --version`、`readelf --version`、`getconf GNU_LIBC_VERSION`；完整的编译与链接命令（`-O` 级别、有没有 `-fcommon`/`-fno-common`、有没有显式 `-Wl,-z,lazy`/`-z now`、`-rpath` 写法）。涉及加载行为的，附 `readelf -d` 与 `readelf -p .interp` 的输出；涉及符号版本的，附两侧（需求方与库）的 `readelf -V` 和那个库 `realpath` 后的完整路径；涉及 `LD_PRELOAD` 的，写明被测程序是自己写的还是系统命令，`_exit` 那一条会改变全部结论。数字与地址请写明架构——aarch64 与 x86-64 的 PLT 形状、重定位类型名、解释器路径本来就是两套，混着报会把形状示例当成别人的读数。这张表按同一格式继续增补。
