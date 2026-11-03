# 1.16 闭卷回忆卡

这一页是检索练习，不是摘要。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。16 张卡分三组：**A 组考流水线、ELF 与库（1.16.1–1.16.3）**，**B 组考优化、裁剪、`no_std` 与 FFI（1.16.4–1.16.7）**，**C 组考实验取证与环境边界（1.16.8–1.16.11）**。建议学完当天、隔天、第 3 天、第 7 天各做一次，只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。

## A. 流水线、ELF 与库

::: method 回忆 1 · 四阶段与四种产物
C 从 `.c` 到 `a.out` 经过哪四个程序？每步输入输出是什么？Rust 在哪里不同、在哪里汇合？
::: sol 答案
`cpp` 预处理：`.c` → `.i`（宏展开、头文件并入、条件编译）；`cc1` 编译：`.i` → `.s`（GIMPLE/RTL、优化）；`as` 汇编：`.s` → `.o`（`ET_REL`，指令编码 + 重定位项）；`collect2` 调 `ld` 链接：`.o` + 库 → `a.out`（`ET_EXEC`/`ET_DYN`）。`rustc` 自己完成词法/语法/类型检查 → HIR → MIR（借用检查）→ 单态化，生成 LLVM IR 交给 LLVM 优化与代码生成，得到 `.o`，最后同样调系统链接器（Linux 上通常是 `cc`/`ld`）。所以 C 与 Rust 在 ELF 层汇合，链接错误也长得一样。`cc` 是驱动，不是编译器。
:::
:::

::: method 回忆 2 · 三种 ELF 文件类型
`ET_REL`、`ET_EXEC`、`ET_DYN` 各是什么？PIE 和共享库为什么都是 `ET_DYN`？先看哪个字段？
::: sol 答案
`ET_REL` 是可重定位目标文件（`.o`），地址未分配、保留重定位表；`ET_EXEC` 是固定地址可执行文件；`ET_DYN` 是位置无关的 ELF，既可以是 PIE 可执行文件，也可以是共享库。共享库要被加载到任意地址，PIE 可执行文件由内核与 `ld.so` 选基址后重定位，所以两者同属 `ET_DYN`。先看 `readelf -h` 的 `Type`，再看 `Machine` 与 `Entry`；`-no-pie`/`-static` 通常得到 `ET_EXEC`，`-static-pie` 仍是 `ET_DYN`。
:::
:::

::: method 回忆 3 · 节与段的分工
`.text/.rodata/.data/.bss/.symtab/.dynsym/.rela.text/.rela.dyn/.got.plt/.plt` 各存什么？为什么 `.bss` 不占文件？
::: sol 答案
`.text` 指令（ALLOC+EXECINSTR）；`.rodata` 只读常量、字符串、跳转表；`.data` 已初始化全局/静态变量；`.bss` 未初始化/零初始化全局，`SHT_NOBITS`，文件里只有节头，加载时映射零页，首次写才分配物理页；`.symtab`/`.strtab` 是静态符号表与字符串，可被 `strip` 删除；`.dynsym`/`.dynstr` 是动态链接所需的符号表，运行必需；`.rela.text` 是代码段重定位，链接后消失；`.rela.dyn`/`.rela.plt` 由 `ld.so` 在加载或首次调用时处理；`.got`/`.got.plt` 是地址表，RELRO 后可只读；`.plt` 是过程链接桩。节是链接器视图，段（segment）是加载器视图，`readelf -S` 看节、`-l` 看段。
:::
:::

::: method 回忆 4 · 符号表怎么读
`readelf -sW` 的 `Bind`/`Type`/`Ndx` 三列各有什么值？`UND`、`ABS`、`WEAK` 是什么意思？强符号重复定义会怎样？
::: sol 答案
`Bind`：`LOCAL`/`GLOBAL`/`WEAK`；`Type`：`FUNC`/`OBJECT`/`NOTYPE`/`TLS`；`Ndx`：节索引（`1` 常是 `.text`，`3`/`4` 可能是 `.data`/`.bss`，具体看 `readelf -S`）、`UND`（未定义，等链接器填）、`ABS`（绝对值，不随加载变化）、`COM`（common）。`WEAK` 可被强符号覆盖，这是 `__attribute__((weak))` 与 C++ 内联函数的基础；两个强符号同名会报 `multiple definition`。动态符号看 `.dynsym`（`nm -D`/`readelf --dyn-syms`），静态符号看 `.symtab`（`nm`）。
:::
:::

::: method 回忆 5 · 重定位名与它填什么
`R_X86_64_PC32`、`R_X86_64_PLT32`、`R_AARCH64_CALL26`、`R_RISCV_CALL_PLT` 各由什么指令产生？链接器填什么？
::: sol 答案
`PC32`：x86-64 的 RIP 相对 32 位偏移，常见于同文件数据/函数引用（`lea`/`mov` 取地址），填「目标地址 − 下一条指令地址」。`PLT32`：x86-64 的 `call` 外部函数，指向 PLT 桩或直接调用，填「PLT 桩地址 − 下一条指令」。`R_AARCH64_CALL26`：ARM64 的 `bl`，填 26 位有符号偏移（±128 MiB）。`R_RISCV_CALL_PLT`：RISC-V 的 `call`（`auipc`+`jalr` 对），填 PC 相对偏移并可经 PLT。取数据地址在 ARM64/RISC-V 常配 `ADR_PREL_PG_HI21`/`ADD_ABS_LO12_NC`、`PCREL_HI20`/`PCREL_LO12_I`。共同点：目标文件不写死绝对地址，把绑定留到链接或加载。
:::
:::

::: method 回忆 6 · 静态库与共享库
`.a` 与 `.so` 在链接/运行时各怎么被处理？SONAME、`NEEDED`、`RUNPATH` 各是什么？为什么共享库必须 `-fPIC`？
::: sol 答案
`.a` 是 `.o` 的归档，链接器扫描时按「当前未定义符号」抽取成员，抽中一个就把整个 `.o` 拉进来；代码进入最终文件，运行时无额外依赖，升级要重链。`.so` 是 `ET_DYN`，链接时只记录 `NEEDED`（依赖的 `SONAME`），运行时由 `ld.so` 按 `RUNPATH`/`RPATH`、`LD_LIBRARY_PATH`、`/etc/ld.so.cache` 查找并映射。`SONAME` 是库的运行时身份（如 `libmath.so.1`），需要符号链接链 `libmath.so.1.0 → libmath.so.1 → libmath.so`。共享库加载地址不定，代码不能含绝对地址重定位，所以进 `.so` 的所有 `.o` 都要 `-fPIC`；`-fPIE` 是给可执行文件的对应选项。
:::
:::

## B. 优化、裁剪、`no_std` 与 FFI

::: method 回忆 7 · GOT/PLT 的一次调用
画出「调用点 → PLT → GOT → libc」；首次调用与之后调用差在哪？`LD_BIND_NOW`、`-fno-plt`、RELRO 各改什么？
::: sol 答案
调用点 `call printf@plt` 进入 `.plt` 桩；桩里 `jmp *printf@GOT(%rip)`。首次调用时 GOT 项指向 `plt0` 的 resolver，`ld.so` 解析出真实地址并写回 GOT；之后 `jmp *GOT` 直接到 libc，不再进 resolver。`LD_BIND_NOW=1` 或 `-Wl,-z,now` 改成加载时全部解析（更安全，启动稍慢）；`-fno-plt` 让调用点直接 `call *printf@GOT(%rip)`，省掉 PLT 一跳；RELRO（`-Wl,-z,relro,-z,now` 为完整 RELRO）在重定位后把 GOT 设为只读，防 GOT 劫持。
:::
:::

::: method 回忆 8 · `-O2` 与 `-O3` 各做什么
GCC 的 `-O2`/`-O3` 与 Rust 的 `-C opt-level` 分别打开什么？为什么等级不是越高越快？
::: sol 答案
`-O2` 打开成熟的标量优化：内联、常量传播、死代码删除、循环简化、指令调度；`-O3` 再加更激进的循环变换、循环展开与向量化。Rust 的 `-C opt-level` 映射到 LLVM 优化管道，`3` 与 C 的 `-O3` 接近但不等价，因为 Rust 还插入边界检查、panic 分支、别名元数据，并受 `codegen-units` 限制跨单元内联。`-O3` 可能让代码膨胀、I-cache 命中下降；`-march=native` 会让二进制换机器 `SIGILL`。收益必须同源码、同编译器版本、同架构内测，不能跨编译器比较。
:::
:::

::: method 回忆 9 · LTO 的收益与代价
LTO 为什么能做跨文件内联？`-flto` 与 `gcc-ar` 有什么关系？`plugin needed to handle lto object` 是什么错？
::: sol 答案
传统编译每个 `.c` 独立出 `.o`，链接器只看符号与重定位，跨文件内联/常量传播/DCE 都做不了。LTO 把 IR 保留到链接阶段，链接器调用 LTO 插件，看到整个程序的 IR 再做优化。静态库若装的是 LTO 对象，归档工具必须认识这种成员，所以要用配套的 `gcc-ar`/`gcc-ranlib`；用不配套的 `ar` 打包，链接时会报 `plugin needed to handle lto object`，这是工具链不匹配，不是代码错。代价：链接变慢、内存占用上升、调试信息与符号形状变化。
:::
:::

::: method 回忆 10 · 节回收、可见性与 strip
`-ffunction-sections -Wl,--gc-sections`、`-fvisibility=hidden`、版本脚本、`strip` 各删/藏什么？`strip` 后为什么 `backtrace` 还能工作？
::: sol 答案
`-ffunction-sections -fdata-sections` 让每个函数/数据独立成节，`--gc-sections` 让链接器删掉未被引用的节。`-fvisibility=hidden` 把默认符号可见性改为隐藏，只有显式导出的才进 `.dynsym`；版本脚本精确列出 `global`/`local`，两者常一起用。`strip` 默认删 `.symtab` 与 `.debug_*`，保留 `.dynsym`（动态链接需要）。`backtrace` 靠 `.eh_frame` 与 `.debug_line` 还原函数名/行号；strip 后只剩地址，需要 `objcopy --only-keep-debug` 保留的独立 debug 文件或符号服务器。
:::
:::

::: method 回忆 11 · `no_std` 要补什么
`#![no_std]` 之后还链接什么？最小可用的 `no_std` 静态库要提供什么？`panic=abort` 的连带影响有哪些？
::: sol 答案
`no_std` 只去掉 `std`，仍链接 `core`、`compiler_builtins`；若最终是普通可执行文件，还会链 C 运行时。最小 `no_std` 库要提供 `#[panic_handler]`；真正裸机还要 `#![no_main]` + 自定义 `_start`/链接脚本、入口、若用 `alloc` 要给 `#[global_allocator]`、若 panic 走 unwind 还要 `eh_personality`（通常直接 abort 避免）。`panic=abort` 的连带影响：`catch_unwind` 失效；`Drop`/析构不保证执行；panic 跨 FFI 是 UB；`#[should_panic]` 测试失效；体积变小但 panic 格式化代码仍可能在，除非 `panic_immediate_abort` 或自定义 handler。
:::
:::

::: method 回忆 12 · C 的 freestanding 对应物
不依赖 libc 的 C 程序要哪些编译/链接选项？`_start` 与 `main` 的差别是什么？
::: sol 答案
`-ffreestanding -nostdlib -static -Wl,-e,_start`：`-ffreestanding` 告诉编译器不假设标准库环境，`-nostdlib` 不链启动文件与 libc，`-Wl,-e,_start` 指定入口。没有 `main`、没有 `printf`、没有 `exit`；要输出就直接用内联汇编发 `syscall`/`svc`/`ecall`，结束后必须走 `exit`/`exit_group`，不能 `ret`（没有调用者）。`_start` 收到的栈顶是 `argc/argv/envp/auxv`，不是返回地址。它和 Rust `no_std` 的差别只在语言层：C 本来就接近裸机，Rust 需要显式声明并补 panic 语义。
:::
:::

::: method 回忆 13 · Rust 导出给 C
`#[no_mangle]`、`extern "C"`、`#[repr(C)]` 各解决什么问题？为什么 `String`/`Vec` 不能直接跨边界？
::: sol 答案
`#[no_mangle]` 阻止符号被 mangle，C 侧才能按原名找到；`extern "C"` 使用 C 的调用约定与 ABI；`#[repr(C)]` 让结构体字段布局与 C 一致（否则 Rust 可重排字段，C 侧偏移读错）。`String`/`Vec` 的布局不是 C ABI，C 侧无法构造也无法释放；跨边界用 `CString`/裸指针 + 显式长度，并约定「谁分配谁释放」，常见做法是成对的 `foo_new`/`foo_free`。`extern "C"` 下 panic 跨边界是 UB，要么边界内 `catch_unwind`，要么 `panic=abort`；需要传播才用 `extern "C-unwind"` 且两边都支持。
:::
:::

::: method 回忆 14 · C 导出给 Rust 与 bindgen/cbindgen
Rust 怎么链接 C 静态库？bindgen 与 cbindgen 各往哪个方向生成、依赖什么？
::: sol 答案
`#[link(name = "math", kind = "static")] extern "C" { fn math_sum(...); }`，编译时 `-L .` 指定目录；动态库把 `kind` 改成 `"dylib"` 并保证运行时可找到。bindgen 是 C → Rust：输入 C 头文件，输出 `bindings.rs`，需要 `libclang`，常用 `--allowlist-function`/`--allowlist-type` 限制范围；cbindgen 是 Rust → C：输入 crate，输出 `.h`，可按 `cbindgen.toml` 配 `include_guard`/`cpp_compat`。把生成物提交仓库并在 CI 里 `git diff --exit-code`，能防止声明漂移。
:::
:::

## C. 实验取证与环境边界

::: method 回忆 15 · 四个工具逐层读数
`readelf -d`、`readelf -r`、`objdump -d -j .plt`、`LD_DEBUG=bindings` 各回答什么？「库找不到」按什么顺序查？
::: sol 答案
`readelf -d` 看动态段：`NEEDED`（依赖的 SONAME）、`SONAME`、`RUNPATH`/`RPATH`、`BIND_NOW`、`FLAGS`。`readelf -r` 看动态重定位：`JUMP_SLOT` 对应 PLT 函数，`GLOB_DAT` 对应数据符号，`RELATIVE` 对应基址相对重定位；aarch64 上是 `R_AARCH64_JUMP_SLOT`。`objdump -d -j .plt` 看桩里的 `jmp *...@GOTPCREL(%rip)`；`LD_DEBUG=bindings` 看每个符号从哪个对象解析到哪个地址。库找不到时按序查：`ldd` → `readelf -d` 的 `RUNPATH` → `LD_LIBRARY_PATH` → `/etc/ld.so.cache`（`ldconfig -p`）。
:::
:::

::: method 回忆 16 · 环境边界与未实测项
本环境哪些工具可用、哪些不可用？VM 没有 Rust 工具链时怎么写 Rust 相关内容？写作机的 Rust 产物为什么不能直接用？
::: sol 答案
VM：`cc`/`gcc`、`as`、`ar`、`ld`、`objdump`、`readelf`、`nm`、`size`、`strip`、`objcopy` 可用；`sudo` 与 `perf` 不可用，`perf stat`/`perf record` 全部标「未实测」，替代是 `clock_gettime`/`/usr/bin/time` 计时。**VM 没有 `rustc`/`cargo`**：1.16.3 的 cdylib/staticlib、1.16.6 的 `no_std` 库、1.16.7 的双向 FFI 在 VM 上无法构建，只能给命令形状与判据并标「未实测 + 原因」。写作机 macOS arm64 + `rustc 1.99.1` 能编译，但产物是 Mach-O，不是 ELF；不能与 Linux `cc`/`ld` 混链，也不能在 VM 上执行。`bindgen`/`cbindgen`/`cargo bloat`/`cargo llvm-lines` 未安装，按未实测处理。
:::
:::
