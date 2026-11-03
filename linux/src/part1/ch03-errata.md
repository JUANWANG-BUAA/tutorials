# 1.3 勘误与版本注记

这一页收本章最容易「记成永久真理」的版本敏感事实与汇编/ABI 陷阱。正文里的 `errata` 盒讲理解陷阱；这一页讲**换编译器、换架构、换汇编语法后要复核什么**。

**本章基线**：Ubuntu 24.04、gcc 13.2、binutils 2.42、System V AMD64 ABI、ARM64 AAPCS64。换环境时逐条复核。

## 1. 语法、寄存器与 ABI

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 1 | `mov %rax, %rbx` 是 `rax=rbx` | AT&T 是 `mov src,dst`；Intel 相反 | `objdump -d -M intel` 对比 |
| 2 | 参数都在栈上 | x86-64 前 6 个整数/指针在寄存器 | ABI 文档、`gdb info registers` |
| 3 | `rcx` 是第 4 个 syscall 参数 | syscall 用 `r10`；函数调用用 `rcx` | `syscall(2)`/ABI |
| 4 | `rax` 只做返回值 | 还用于可变参数个数/`div` 高位 | ABI/`objdump` |
| 5 | callee-saved 可以随便用 | `rbx/rbp/r12–r15` 必须保存/恢复 | push/pop、`gdb` |
| 6 | 栈帧必须用 `rbp` | `-fomit-frame-pointer` 常见；`rbp` 可选 | `objdump`、`-O2` |
| 7 | 红区可以随便用 | 信号/调用会破坏；叶子函数才安全 | ABI、`-mno-red-zone` |

## 2. 栈、对齐与布局

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 8 | 栈向高地址增长 | x86-64/ARM64 通常向低地址 | `push`/`&local` |
| 9 | 栈不需要对齐 | `call` 前 16 字节对齐；SSE/ABI 依赖 | `gdb $rsp`、崩溃 |
| 10 | 结构体按字段和大小 | 对齐/padding/尾部 padding | `pahole`/`offsetof` |
| 11 | 大结构体逐字段传寄存器 | 可能隐藏指针/内存传 | ABI、`objdump` |
| 12 | 联合体大小=最大字段 | 还要按最大对齐 | `sizeof`/`alignof` |
| 13 | 数组越界只读错值 | 可能踩栈/返回地址 | ASan、`gdb` |

## 3. 指令、机器码与多架构

| # | 看起来像 | 实际是 | 怎么验证 |
|--:|:--|:--|:--|
| 14 | `lea` 会访存 | 只算地址 | `objdump`、内存值 |
| 15 | `cmp` 会写结果 | 只改 flags | 寄存器/内存对比 |
| 16 | 机器码定长 | x86-64 变长；ARM64 定长 4 字节 | `objdump`/`readelf` |
| 17 | `call` 的 `e8` 后是绝对地址 | 是 `rel32` 相对偏移 | `objdump -d`、重定位 |
| 18 | 三架构寄存器名可互换 | x86-64 `rdi`、ARM64 `x0`、RISC-V `a0` | 交叉编译/`objdump` |
| 19 | `-O0` 汇编就是“真实逻辑” | 有冗余 load/store；`-O2` 会重排/内联 | `-S -O0/-O2` 对比 |
| 20 | inline asm 随便写 | 要声明 clobber/内存/对齐；否则 UB | 编译器文档、`asm!` |

## 4. 本章未实测项

以下结论来自文档与常见行为，但未在本书写作环境逐条复跑；在别的编译器/架构上使用前先验证：

- System V AMD64 ABI 的参数分类（INTEGER/SSE/MEMORY）依类型/大小；大结构体/浮点要查 ABI。
- ARM64 AAPCS64 的寄存器/对齐/变参依平台；Apple ARM64 有差异。
- x86-64 机器码编码依前缀/REX/操作数；`objdump` 输出依 binutils 版本。
- `-O2` 的优化/内联依编译器版本；读汇编要固定 `-O`/`-march`。
- Rust `asm!`/`extern "C"` 的 ABI/UB 依版本；Miri 不检查 inline asm。

## 5. 发现新问题怎么记

如果你在别的编译器/架构上发现本章结论不成立，按「现象 → 命令/输出 → 版本/架构 → 建议改法」记到 issue 或笔记里；不要只写「我这里不对」。这张表下一轮会按同一格式增补。
