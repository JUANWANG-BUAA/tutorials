# 1.2 习题集

三组分层：A 组概念判断（口答即可）、B 组诊断推理（写出步骤）、C 组动手实验（在虚拟机里跑）。**全部附解答**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；
2. 卡住了，回到对应小节的「即时自测」重读，不要直接看答案；
3. 做完再对照解答，重点看自己卡在哪一步；
4. 做错的题记一个记号，三天后只重做记号题。

## A 组 · 概念判断

::: ex A1 · 位、字节、字与十六进制

位/字节/字/十六进制各是什么？LP64 与 ILP32 下 `long`/指针各几字节？

::: sol 解答

位 0/1；字节 8 位；字是机器字长（指针宽度）；十六进制 4 位一组。LP64：`long`/指针 8 字节、`int` 4；ILP32：`long`/指针 4、`int` 4。用 `sizeof`/`getconf LONG_BIT` 确认。

:::
:::

::: ex A2 · 补码

补码怎样表示负数？`-x` 的位运算是什么？有符号范围为什么不对称？

::: sol 解答

补码最高位权为 `-2^(w-1)`；`-x = ~x + 1`。w 位有符号范围 `[-2^(w-1), 2^(w-1)-1]`，负数比正数多一个（`INT_MIN` 没有正对应），所以 `-INT_MIN` 溢出。

:::
:::

::: ex A3 · 扩展、截断与转换

符号扩展与零扩展差在哪？截断会怎样？`int`→`unsigned` 的规则是什么？

::: sol 解答

符号扩展复制符号位，零扩展补 0；截断保留低位、丢高位。`int`→`unsigned` 按模 `2^w` 重解释（负数变大正数）；`unsigned`→`int` 实现定义/回绕，避免依赖。混用会触发整数提升/转换，比较时特别危险。

:::
:::

::: ex A4 · 溢出与移位

有符号溢出与无符号溢出各是什么？移位有哪些 UB？`x & -x` 取出什么？

::: sol 解答

有符号溢出是 UB；无符号按 `2^w` 回绕。移位：移位数负数/≥位宽是 UB；左移负数/溢出有符号是 UB；右移有符号是实现定义。`x & -x` 取出最低位的 1（`x=0` 时为 0）。

:::
:::

::: ex A5 · 字节序与布局

小端/大端差在哪？为什么有 padding？`offsetof`/`sizeof` 各给什么？

::: sol 解答

小端低字节在低地址，大端高字节在低地址；网络字节序通常大端。对齐要求字段地址是 `alignof` 的倍数，编译器插 padding；`offsetof` 给字段偏移，`sizeof` 给总大小（含尾部 padding）。`repr(C)` 固定 C 布局。

:::
:::

::: ex A6 · IEEE 754

float/double 的符号/指数/尾数各几位？偏置是多少？规格化/非规格化/NaN/Inf 怎样区分？

::: sol 解答

float：1/8/23，偏置 127；double：1/11/52，偏置 1023。指数全 0：非规格化；指数全 1：尾数 0 是 Inf、非 0 是 NaN；其余规格化（隐含 1）。`-0.0` 符号位 1、指数/尾数 0。

:::
:::

::: ex A7 · 舍入、ULP 与比较

为什么 `0.1+0.2 != 0.3`？ULP 是什么？NaN 比较有什么特殊？

::: sol 解答

0.1/0.2/0.3 不能精确表示，加法舍入到最近可表示值，所以不等。ULP 是最小间距（随指数变化）；比较用容差/ULP，不用 `==`。NaN 与任何值（包括自己）比较都为假；`isnan` 判断；`-0.0 == 0.0` 为真但符号不同。

:::
:::

::: ex A8 · C 与 Rust

C 的 UB/实现定义 vs Rust 的安全/checked 各是什么？FFI 为什么用 `repr(C)`？

::: sol 解答

C 有 UB（溢出/别名/越界）和实现定义（右移/`int` 宽度）；Rust 安全代码禁止 UB，`checked_*`/`wrapping_*`/`saturating_*` 明确语义。FFI 用 `repr(C)` 固定字段顺序/对齐，与 C 结构体一致；默认 Rust 布局可重排。

:::
:::

## B 组 · 诊断推理

::: ex B1 · 有符号溢出

`int x = INT_MAX; x = x + 1;` 在 `-O2` 下行为可能和 `-O0` 不同。为什么？怎样避免？

::: sol B1 核对

有符号溢出是 UB，编译器可假设不发生并做优化（删除/改分支）。避免：用无符号/更宽类型/`__builtin_add_overflow`/`-fsanitize=undefined`/Rust `checked_add`。不要依赖回绕。

:::
:::

::: ex B2 · `0.1+0.2`

为什么 `0.1 + 0.2 == 0.3` 是假？怎样比较浮点？

::: sol B2 核对

0.1/0.2/0.3 的二进制表示是无限循环，存储时舍入；0.1+0.2 的结果与 0.3 的舍入值不同。比较用绝对/相对容差或 ULP；金额用整数分；`isnan`/`isinf` 单独处理。

:::
:::

::: ex B3 · 结构体 padding

`struct { char c; int i; }` 在 x86-64 上多大？字段偏移是多少？怎样避免 padding？

::: sol B3 核对

通常 `sizeof=8`，`c` 偏移 0，`i` 偏移 4（3 字节 padding）；尾部可能再 padding。避免/控制：按对齐从大到小排、`#pragma pack`（有风险）、`repr(C)` 固定布局；用 `offsetof`/`pahole` 验证。

:::
:::

::: ex B4 · 字节序

`0x12345678` 在小端/大端内存里字节顺序是什么？网络字节序是哪种？怎样转换？

::: sol B4 核对

小端：`78 56 34 12`（低字节在前）；大端：`12 34 56 78`。网络字节序是大端；用 `htonl/ntohl`/`htons/ntohs` 转换。用 `xxd`/`od` 或 union 验证。

:::
:::

::: ex B5 · 移位 UB

`1 << 32`、`x >> -1`、`-1 >> 1` 各有什么问题？怎样写可移植？

::: sol B5 核对

`1<<32` 在 32 位 int 是 UB（移位数 ≥ 位宽）；`x>>-1` 负数移位 UB；`-1>>1` 有符号右移是实现定义（算术/逻辑）。可移植：用无符号、检查移位范围、避免负数移位；需要算术右移用有符号但接受实现定义或显式处理。

:::
:::

::: ex B6 · `repr(C)`/FFI

Rust 结构体默认布局与 C 有什么不同？FFI 为什么必须 `repr(C)`？对齐怎样对齐？

::: sol B6 核对

Rust 默认布局可重排字段/插 padding，不保证与 C 一致；`repr(C)` 按 C 规则布局，FFI 必须。对齐用 `#[repr(align(N))]`/`alignas`；`sizeof`/`alignof` 两边核对；`bindgen` 生成绑定，Miri/UBSan 检查 UB。

:::
:::

## C 组 · 动手实验

::: ex C1 · 手算

手算 `-5` 的 8 位补码、`0xF0` 的有符号值、`1u<<31`、`INT_MAX+1u`，再用程序验证。

::: sol C1 核对

`-5`：5=`00000101`，取反 `11111010`，+1=`11111011`=0xFB。`0xF0` 有符号 8 位 = -16。`1u<<31`=0x80000000（无符号 2147483648）。`INT_MAX+1u` 无符号 = 2147483648。用 `printf`/`gdb` 验证。

:::
:::

::: ex C2 · 溢出/转换取证（gdb 只到寄存器）

先用 `gdb` 看 `INT_MAX`、字面量转换和寄存器；再用 UBSan 看 `INT_MAX + 1`，用 `printf` 看 `int`→`unsigned`、`short`→`int`。最后说明：为什么本机 gdb 打不出变量，替代路径是什么。

::: sol C2 核对

```bash
gcc -g -O0 -fsanitize=undefined -fno-sanitize-recover=all demo.c -o demo
./demo
gdb -q -batch -ex 'break main' -ex run -ex 'p (int)0xFFFFFFF0' ./demo
```

UBSan 报 `signed integer overflow`；`printf` 给出转换结果；gdb 的字面量能算，但 `print x` 在本机会报 `Unable to fetch SVE/SSVE vector length`。验收：能说出「值变了但位模式没变」，并知道换 UBSan/`printf`/DWARF 取证。

:::
:::

::: ex C3 · 结构体布局

用 `offsetof`/`sizeof`/`pahole` 看 `struct { char c; int i; double d; }` 的偏移/大小；调整字段顺序对比。

::: sol C3 核对

```bash
gcc -g layout.c -o layout
pahole ./layout
```

看 `c` 偏移 0、`i` 偏移 4、`d` 偏移 8、`sizeof=16`；调整顺序可能改变大小。`offsetof`/`sizeof` 打印验证；`#pragma pack`/`repr(C)` 对比。验收：能解释 padding 来源。

:::
:::

::: ex C4 · 浮点位模式

用 `memcpy` 把 `float` 转 `uint32_t`，打印符号/指数/尾数；验证 `0.1f`、`-0.0f`、`NaN`。

::: sol C4 核对

```c
float f = 0.1f; uint32_t u;
memcpy(&u, &f, 4);
printf("%08x sign=%u exp=%u frac=%u\n", u, u>>31, (u>>23)&0xff, u&0x7fffff);
```

`0.1f` 的位模式不是精确 0.1；`-0.0f` 符号 1；NaN 指数全 1、尾数非 0。用 `%a`/`isnan` 辅助。

:::
:::

::: ex C5 · objdump/字节序

写一个 `0x12345678` 的全局变量，用 `objdump -s`/`xxd` 看它在小端机器上的字节；用汇编/union 验证。

::: sol C5 核对

```bash
printf 'int x = 0x12345678;\n' > x.c
gcc -c x.c -o x.o
objdump -s -j .data x.o
xxd x.o | head
```

小端看到 `78 56 34 12`；`objdump -s` 按字节显示。用 union/`memcpy` 打印内存字节验证；跨架构用 `readelf -h` 看 machine。

:::
:::
