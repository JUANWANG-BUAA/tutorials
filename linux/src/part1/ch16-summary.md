# 1.16 章末总结

## 三段主线：三个单元，一条因果链

**第一段，产物与容器（1.16.1–1.16.2）。** `cc` 不是编译器而是驱动：`cpp` 展开宏与头文件得到 `.i`，`cc1` 生成 `.s`，`as` 把指令编码成 `ET_REL` 的 `.o`，最后 `collect2` 调 `ld` 完成符号解析、重定位与布局，产出 `ET_EXEC`/`ET_DYN`。`rustc` 只是把前半段换成自己的前端与 LLVM，最后一站仍是系统链接器，所以 C 与 Rust 的链接错误长得一样。`.o` 之所以比 `a.out` 好读，是因为它还保留完整的节、符号表与重定位表；一旦链接完成，`.rela.text` 被消费掉，地址也已分配，线索就断了。ELF 用同一套容器装三种文件，读它先看 `readelf -h` 的 `Type`，再看 `-SW` 的节、`-sW` 的符号、`-rW` 的重定位；`.bss` 是 `NOBITS`，文件里只有节头，`.symtab` 可被 `strip` 删除而 `.dynsym` 不能。

**第二段，库与绑定（1.16.3）。** 静态库是 `.o` 的归档，链接器按「当前未定义符号」逐个抽取成员，抽中一个成员就把整个 `.o` 拉进来；共享库是运行时映射的 `ET_DYN`，靠 `SONAME` 被记录为 `NEEDED`，靠 `RUNPATH`/`LD_LIBRARY_PATH`/`ld.so.cache` 被找到。共享库必须位置无关，所以所有进入 `.so` 的目标文件都要 `-fPIC`；`-fPIE` 是给可执行文件的近亲。外部调用走「调用点 → `.plt` 桩 → `.got.plt` → 真实地址」：首次调用由 `ld.so` 解析并写回 GOT，之后只是间接跳转；`LD_BIND_NOW`/`-z now` 改成加载时全解析，RELRO 再把 GOT 设为只读。`LD_PRELOAD` 能劫持 `math_sum`，正说明这条绑定链发生在运行时而不是编译时。

**第三段，优化、裁剪与边界（1.16.4–1.16.11）。** 优化发生在 IR 上：`-O2` 打开内联、常量传播、DCE、循环简化与指令调度，`-O3` 再加更激进的循环变换与向量化；Rust 的 `-C opt-level=3` 走 LLVM 管道，还受边界检查、panic 分支、别名元数据与 `codegen-units` 约束，因此**与 GCC 的 `-O3` 不等价，读数也不能跨编译器比较**。LTO 把 IR 留到链接阶段，换来跨文件内联与 DCE，代价是链接慢、内存高、归档要用 `gcc-ar`；`-ffunction-sections` + `--gc-sections` 删未引用节；`-fvisibility=hidden` 与版本脚本收窄导出；`strip` 删 `.symtab`/`.debug_*` 但保留 `.dynsym`。`no_std` 拆掉 `std` 后要自己给 `#[panic_handler]`，`panic=abort` 去掉 unwind 但也让 `catch_unwind` 失效；FFI 的难点是所有权、`#[repr(C)]`、固定宽度整数与「panic 不得跨 `extern "C"`」。最后用 `readelf -d`、`nm -D`、`LD_DEBUG=bindings`、`LD_PRELOAD` 把每条结论变成读数。

一句话主线：**先把「源码 → `.o` → 库 → 运行时绑定」每一站的产物与契约分开，再把优化与裁剪看成对同一份 IR 的不同选择，最后用 `no_std` 与 FFI 把语言运行时拆到边界上；看到一个构建问题，先问「东西在哪一层」，再问「谁改的」，最后问「用什么读出来」。**

## 表 1：优化开关对照

| 开关 | C | Rust | 实际做什么 / 代价 |
|:--|:--|:--|:--|
| 不优化 | `-O0` | `-C opt-level=0` | 逐条落栈、保留调试形状；只适合取证，不适合发布 |
| 基础优化 | `-O2` | `-C opt-level=2`（`cargo --release` 默认 3） | 内联、DCE、常量传播、循环简化；服务端常用档 |
| 激进优化 | `-O3` | `-C opt-level=3` | 向量化、展开、更多内联；可能膨胀 I-cache，收益依源码与 `-march` |
| 体积优先 | `-Os` | `-C opt-level=s` | 减小 `.text`，可能牺牲速度 |
| 目标 CPU | `-march=native`/`-mtune=` | `-C target-cpu=native` | 用 AVX/NEON 等扩展；换机器可能 `SIGILL`，发布包别用 |
| 溢出检查 | 有符号溢出是 UB，默认不检查 | debug 默认开，release 默认关 | `-C overflow-checks=on` 可强制 |
| 代码单元 | 无 | `-C codegen-units=1` | 更多跨单元内联，编译更慢 |
| 跨文件优化 | `-flto`/`-flto=auto` | `lto="fat"`/`"thin"` | 跨文件/crate 内联与 DCE；链接慢、工具链需匹配 |

## 表 2：工具链产物对照

| 产物 | 谁生成 | ELF/格式 | 关键内容 | 用什么读 |
|:--|:--|:--|:--|:--|
| `.i` | `cpp`（`cc -E`） | 文本 | 宏已展开、头文件已并入 | 编辑器、`grep` |
| `.s` | `cc1`（`cc -S`）、`rustc --emit=asm` | 文本 | 目标 ISA 汇编、符号与节指令 | 编辑器、`grep` |
| `.ll` | `clang -S -emit-llvm`、`rustc --emit=llvm-ir` | 文本 IR | 优化前/后的 IR，LTO 的输入 | 编辑器、`opt` |
| `.o` | `as`（`cc -c`）、`rustc --emit=obj` | `ET_REL` | 节、`.symtab`、`.rela.text` | `readelf -SW/-sW/-rW`、`objdump -dr` |
| `.a` | `ar rcs` | 归档 | 一组 `.o`，按成员抽取 | `ar t`、`nm` |
| `.so` | `cc -shared -fPIC` | `ET_DYN` | `.dynsym`、`SONAME`、`.plt`/`.got.plt` | `readelf -d/-sW`、`nm -D`、`ldd` |
| 可执行文件 | `ld`/`cc`/`rustc` | `ET_EXEC`/`ET_DYN`（PIE） | 段映射、`INTERP`、`NEEDED` | `readelf -h/-l/-d`、`size`、`objdump -d` |
| 调试文件 | `objcopy --only-keep-debug` | ELF 调试副本 | `.debug_*`，可用 `--add-gnu-debuglink` 关联 | `readelf -S`、`gdb` |

## 表 3：陷阱清单

| 陷阱 | 看起来像 | 实际是 | 当场怎么验证 |
|:--|:--|:--|:--|
| 库存在却 `undefined reference` | 库没装或路径错 | 命令行顺序错：`-lfoo` 在引用它的 `.o` 之前；静态库按需抽取，循环依赖要 `--start-group` | 交换 `main.o` 与 `-lmath` 的位置各链一次 |
| `cannot open shared object file` | 库文件不存在 | 运行时找不到：没有 `RUNPATH`、`LD_LIBRARY_PATH` 或 `ld.so.cache` 条目；SONAME 与文件名不一致 | `readelf -d` 看 `NEEDED`/`RUNPATH`，`ldd` 看解析结果 |
| `relocation ... can not be used when making a shared object` | 链接器 bug | 进 `.so` 的 `.o` 没加 `-fPIC`，绝对地址重定位不能进共享库 | 看报错点名的重定位类型；全部重编 `-fPIC` |
| `-O3` 一定比 `-O2` 快 | 等级越高越好 | 优化收益依源码、编译器版本与 `-march`；可能膨胀 I-cache、降低命中 | 同机同版本计时 + `size` + 汇编对照，只做组内比较 |
| `#[no_mangle]` 可省 | `pub extern "C" fn` 就够了 | 默认符号被 mangle，C 侧按名字找不到；cdylib 只导出可导出符号 | `nm -D --defined-only lib.so \| grep 名字`，看是否有 `_ZN`/`_R` 前缀 |
| `strip` 后动态链接失败 | `strip` 删多了 | 正确 `strip` 保留 `.dynsym`；失败多因手工删节或用错对象 | `readelf -SW` 看 `.dynsym` 是否还在；换 `--strip-debug`/`--strip-unneeded` |
| LTO 静态库报 `plugin needed to handle lto object` | 代码错 | 归档工具不认 LTO IR；要用 `gcc-ar`/`gcc-ranlib` | `ar t` 能看到成员，但链接器报插件缺失；换 `gcc-ar` 重建 |
| `-march=native` 在别的机器 `SIGILL` | 编译器生成了坏指令 | 二进制用了目标机没有的指令集扩展 | 发布用基线 `-march=x86-64-v2`/`-mcpu=generic`；`objdump -d` 找新指令 |
| `.bss` 占 64 MiB 文件 | `ls -l` 应该很大 | `.bss` 是 `NOBITS`，文件里只有节头，加载时映射零页 | `readelf -SW` 看 `NOBITS`；`size` 的 `bss` 列与文件大小分开读 |
| `panic=abort` 后 `catch_unwind` 还能兜底 | 捕获panic就能隔离 | abort 不展开栈，`catch_unwind` 捕不到；跨 `extern "C"` 的 panic 是 UB | 用 abort 构建跑一个会 panic 的 FFI 用例，观察进程直接终止 |
| CSAPP 扫描版能引页码 | 中文第 3 版和英文版一样 | 纯扫描版没有文本层，页码不对应 | 选中文字复制为空，或 `pdftotext` 无输出 |

## 下一站

1.17 把本章的所有权、错误、FFI 与工具链放进真实系统调用：[1.17 Rust 系统编程](ch17.md) 会用文件、线程与 socket 把「ABI 边界」变成 `EINTR`、短写、`Send/Sync` 与生命周期错误。往内核走，[2.1.1 一次系统调用穿过什么](../part2/ch01.md#sec-2.1.1) 会把本章链接好的可执行文件真正送进内核路径。

自检入口：[闭卷回忆卡](ch16-recall.md) 先合上正文叫出 16 个答案；[习题集](ch16-exercises.md) 的 B 组专练「现象 → 机制 → 证据 → 修法」；[学习目标自检表](ch16-checklist.md) 接管 1.16.11 的八条出口；[勘误与版本注记](ch16-errata.md) 的「`-O2`/`-O3` 不可跨编译器比较」「链接顺序」两条请先读一遍。
