# CHECK-CSAPP-ERRORS：CSAPP/OSTEP 相关事实错误与实质漏节（CHECK-C）

> **只读审计**：本报告不修改 `src/`、`SUMMARY.md`、`book.toml`、`theme/`、`tools/` 下任何文件。
> **范围**：`src/part1/ch01.md`–`ch13.md`，重点抽查 1.1（工具链/ELF/PLT）、1.3（栈帧/浮点/溢出）、1.9（分配器/GC）、1.12（并发/强扩展）、1.13（调度/页替换/LFS/日志/磁盘）。
> **方法**：逐行核对原文；对数字重新演算；对可汇编/可编译的片段在本机实测（Apple clang 21，`--target=x86_64-linux-gnu` 仅汇编，不链接 Linux libc）；对无法在本机复现的 Linux 运行期结论，标注「未实测」并给出推理依据。
> **判定口径**：「事实错误」= 陈述与体系结构/ABI/POSIX/Linux 语义或自身给出的数字矛盾；「漏节」= 原书节有实质机制/API/算法未落点，不含小结、练习、纯历史与已明确淘汰的分布式章节。

---

## 结论速览

- **A 节 20 项**：其中 9 项会直接导致代码错、汇编不过或数字算错（A-01、A-02、A-03、A-04、A-05、A-06、A-11、A-12、A-20）；其余是 ABI/链接/浮点/调度/缓存口径错误。
- **B 节 15 项**：集中在 OSTEP 磁盘几何与调度（37.2/37.3/37.5）、IDE 驱动案例（36.8）、LFS 的缓冲/imap/liveness/恢复（43.3–43.12）、VAX 页替换与 VM 技巧（23.4/23.5）、分段机制（16.2–16.6），以及 CSAPP 5.12 的 load/store 性能。
- **实测结论**：`frame.s`、`a64.s`、`endian_sum.s` 可交叉汇编；`sched.c`/`lottery.c`/`page_repl.c`/`journal.c`/`mymalloc.c`/Y86 解释器可编译运行且多数输出与正文一致；`alloc.c` 的 112 B 请求会覆盖 footer；`sched.c` 的 RR 输出证明正文的 RR 区间列错。
- **只读**：未修改 `src/` 下任何正文；本文件是唯一写入物。

---

## A. 事实错误 top 20

> 编号按严重度排序：会导致代码不能汇编/运行、或直接算错数字的排在前面。

### A-01 栈对齐代码多减了 8 字节，`callee` 入口实际是 0 mod 16

- **位置**：`src/part1/ch03.md:326-339`（1.3.6 栈帧、call/ret 与参数传递）
- **原文**：
  ```asm
  caller:
      subq  $8, %rsp          # 对齐：call 前 rsp % 16 == 0
      pushq $7                # 第 7 个参数压栈
      ...
      call  callee
      addq  $16, %rsp
  ```
  正文并称：「进入 `caller` 时 `%rsp % 16 == 8`……再 `pushq $7` 后变成 0……所以这里先 `sub 8`、再 `push`，总共 16 字节，保持对齐。」
- **正确说法**：进入 `caller` 时 `rsp ≡ 8 (mod 16)`。只需 `pushq $7` 就得到 `rsp ≡ 0`，可以 `call`；再加 `subq $8` 会把 `call` 前的 `rsp` 变回 `≡ 8`，`callee` 入口变成 `≡ 0`，违反 SysV AMD64 ABI（callee 入口应为 `≡ 8`）。正确写法是二选一：
  ```asm
  pushq $7                 # 8 -> 0，直接 call
  call  callee
  addq  $8, %rsp
  ```
  或
  ```asm
  subq  $16, %rsp          # 预留一个 8 字节栈参数 + 8 字节对齐填充
  movq  $7, (%rsp)
  call  callee
  addq  $16, %rsp
  ```
- **证据**：
  1. 本机用 clang 编译同样的 7 参数调用（`clang --target=x86_64-linux-gnu -O2 -S`），生成的是 `pushq %rax; movq $7, (%rsp); callq callee`，只有一条 8 字节的 push，没有 `subq $8`。
  2. ABI 要求：`call` 指令执行前 `rsp % 16 == 0`；`call` 压入 8 字节返回地址后，callee 入口 `rsp % 16 == 8`。原文的 `sub 8 + push` 使 `call` 前为 `8`，callee 入口为 `0`。
  3. 原文自己的解释也漏掉了 `subq $8`：「进入 caller 时 8，再 push 后变成 0」只有在没有 `subq $8` 时才成立。

### A-02 `movq 8(%rdi), %eax` 是非法指令，汇编器直接报错

- **位置**：`src/part1/ch03.md:422-425`（1.3.7 数组、结构体与联合体的布局）
- **原文**：
  ```asm
  # struct Rect *p; p->br.x
  movq 8(%rdi), %eax      # br 在偏移 8，x 在 br 内偏移 0
  ```
- **正确说法**：`movq` 的操作数宽度是 64 位，目的寄存器必须是 64 位寄存器；`%eax` 是 32 位，操作数宽度冲突。`p->br.x` 是 `int`（4 字节），应写 `movl 8(%rdi), %eax`。若要一次读 8 字节（例如读 `long`），应写 `movq 8(%rdi), %rax`。
- **证据**：本机 `clang --target=x86_64-linux-gnu -c` 汇编该行，报
  ```text
  bad.s:4:19: error: invalid operand for instruction
      movq 8(%rdi), %eax
                    ^~~~
  ```
  把该行改为 `movl 8(%rdi), %eax` 后可正常汇编。

### A-03 「`add` 的目的不能是内存」是错的，x86 允许内存目的操作数

- **位置**：`src/part1/ch03.md:113`（1.3.3 数据传送与算术逻辑）
- **原文**：「**`add` 的源可以是内存，目的不能是内存**。`addq (%rdi), %rax` 合法；`addq %rax, (%rdi)` 非法，需要先 `mov` 到寄存器再写回。」
- **正确说法**：x86 的 `add` 是「寄存器/内存 ← 寄存器/内存 + 寄存器/立即数」，**目的可以是内存**；唯一禁止的是「内存 ← 内存」。`addq %rax, (%rdi)` 完全合法，机器码 `48 01 07`。
- **证据**：本机汇编
  ```asm
  addq %rax, (%rdi)
  ```
  退出码 0，`llvm-objdump -d` 得到 `48 01 07  addq %rax, (%rdi)`。原文前半句「源可以是内存」正确，后半句把「源和目的不能同时为内存」误写成了「目的不能是内存」。

### A-04 缓存手算表标了 5 次命中，正文却写「4 次命中，命中率 33%」

- **位置**：`src/part1/ch06.md:517-532`（1.6.10 组相联缓存：地址怎么拆、命中怎么算）
- **原文**：12 次访问的表中，第 4、6、8、9、12 次均标为 **命中**；紧接着正文写「12 次访问、4 次命中，命中率 33%」。
- **正确说法**：按表自身的 LRU 过程，命中是 5 次（第 4、6、8、9、12 次），命中率 `5/12 = 41.7%`。若坚持「4 次命中」，则表中必须有一次不是命中；按 LRU 追踪，第 9 次 `0x080` 确实命中（第 7 步装入后未被驱逐），不能算缺失。
- **证据**：按原文参数（C=128 B、B=16 B、E=2，4 组）重放该地址序列，LRU 结果为：
  ```text
  0x000 MISS, 0x010 MISS, 0x020 MISS, 0x000 HIT,
  0x040 MISS, 0x000 HIT, 0x080 MISS, 0x000 HIT,
  0x080 HIT, 0x0C0 MISS, 0x000 MISS, 0x020 HIT
  hits=5 miss=7 rate=0.4167
  ```
  与表中 5 个加粗「命中」一致，与正文「4 次/33%」矛盾。

### A-05 RR 手算的调度序列自相矛盾：B 只有 5 个时间单位，却被排了 7 个

- **位置**：`src/part1/ch13.md:82`（1.13.2 CPU 虚拟化：调度策略与指标）
- **原文**：「RR（片长 2）：A 0–2，B 2–4，C 4–6，A 6–8，B 8–10，A 10–12，B 12–14，A 14–16，B 16–17；周转 17/12/4，平均 11；响应 0/1/2。」
- **正确说法**：B 的总 burst 是 5。上面的序列给 B 分配了 `2–4`、`8–10`、`12–14`、`16–17` 共 7 个单位，已经超过 B 的总量；B 在 `12–13` 就用完最后 1 个单位，之后不应再出现在 `16–17`。正确序列是：
  ```text
  A 0–2, B 2–4, C 4–6, A 6–8, B 8–10,
  A 10–12, B 12–13, A 13–15, A 15–17
  ```
  完成时间 A=17、B=13、C=6；周转 A=17、B=12、C=4，平均仍是 11；响应 0/1/2。也就是说**最终数字 17/12/4 和平均 11 是对的，但列出的执行区间是错的**，不能作为推导依据。
- **证据**：
  1. 按原文的 `sched.c` 实际编译运行（macOS clang，`-std=c17 -O2`），RR 输出正是 `A end=17, B end=13, C end=6`，平均周转 11.00；程序没有复现原文的 `B 12–14`、`B 16–17`。
  2. 算术检查：B 的 burst=5，原文序列中 B 的运行区间总长 `2+2+2+1=7`，不可能成立。

### A-06 PTE `0x1a2bd867` 的 D 位被读错：`0x867` 的 bit 6 是 1

- **位置**：`src/part1/ch09.md:529`（1.9.8 四级页表与地址翻译：手算一次 walk）
- **原文**：「最后一级 PTE `0x1a2bd867` 的低 12 位是 `0x867`：P=1、R/W=1、U/S=1、A=1、D=0、PS=0。」
- **正确说法**：`0x867 = 0b1000_0110_0111`。bit 5（A）=1，bit 6（D）=1，bit 7（PS）=0。因此应为 **A=1、D=1、PS=0**。原文把 D 写成了 0。
- **证据**：逐位展开
  ```text
  0x867 = 0x800 + 0x040 + 0x020 + 0x004 + 0x002 + 0x001
        = bit11 + bit6 + bit5 + bit2 + bit1 + bit0
  P(0)=1, RW(1)=1, US(2)=1, PWT(3)=0, PCD(4)=0,
  A(5)=1, D(6)=1, PS(7)=0, G(8)=0
  ```
  同一章 1.9.3 的 `0x2e8a0067` 低位 `0x67` 也被正确读成 A=1、D=1；两处口径应一致。

### A-07 PLT 懒绑定桩的第二个 `jmp` 目标应是 PLT0，不是 `_init`

- **位置**：`src/part1/ch01.md:803-812`（1.1.19 动态链接的两次绑定：PLT、GOT 与 `LD_DEBUG`）
- **原文**：
  ```text
  0000000000001050 <puts@plt>:
      1050: ff 25 b2 2f 00 00   jmp *0x2fb2(%rip)   # 4008 <puts@GOT>
      1056: 68 00 00 00 00      push $0x0
      105b: e9 a0 ff ff ff      jmp 1000 <_init>
  ```
  正文接着说「再跳到动态链接器的解析器」。
- **正确说法**：`push $index` 之后跳的是 **`.plt[0]`（PLT0，公共解析器 trampoline）**，PLT0 的第一条指令是 `push GOT+8`（link_map），第二条是 `jmp *GOT+16`（`_dl_runtime_resolve`）。`_init` 是 ELF 的初始化函数，和 PLT0 是两个不同的入口，不可能都在 `0x1000`。示例中若 `.plt` 桩在 `0x1050`，PLT0 通常在同一 `.plt` 节头部（如 `0x1020`），`jmp` 目标应是 PLT0 的地址，而不是 `_init`。
- **证据**：
  1. 本书 1.7.6（`src/part1/ch07.md:306`）自己写的是「`push $index; jmp plt0`」，与 1.1.19 的 `jmp _init` 矛盾；按 1.7.6 的口径，1.1.19 的示例目标标错了。
  2. 标准 lazy PLT 布局：`.plt[0]` 保存 `push GOT+8; jmp *GOT+16`，`.plt[n]` 保存 `jmp *GOT[n]; push n; jmp .plt[0]`；解析器入口由 GOT+16 提供，不由 `_init` 提供。

### A-08 `1.1.16` 速查表的动态库搜索顺序与 1.1.19 的表格互相矛盾

- **位置**：`src/part1/ch01.md:653`（1.1.16 一页速查与陷阱）
- **原文**：「动态库怎么找到？……`ld.so.cache → RPATH/RUNPATH → LD_LIBRARY_PATH`」
- **正确说法**：glibc `ld.so` 的顺序是：
  1. `DT_RPATH`（仅当没有 `DT_RUNPATH`）
  2. `LD_LIBRARY_PATH`（非 secure-execution）
  3. `DT_RUNPATH`（只作用于直接依赖）
  4. `/etc/ld.so.cache`
  5. 默认目录 `/lib`、`/usr/lib` 等

  即 `RPATH → LD_LIBRARY_PATH → RUNPATH → ld.so.cache`，不是「cache 最先」。
- **证据**：
  1. 同章 1.1.19 的表（`ch01.md:821-829`）已经给出正确顺序：`DT_RPATH`、`LD_LIBRARY_PATH`、`DT_RUNPATH`、`/etc/ld.so.cache`、默认目录；1.1.16 的速查行与它直接冲突。
  2. 同章 1.1.13 的 errata（`ch01.md:582`）也写「`RPATH` 优先于 `LD_LIBRARY_PATH`，`RUNPATH` 相反」，进一步证明速查行的顺序错了。
  3. `man 8 ld.so` 的搜索顺序与上述一致。

### A-09 AMAT 公式的 LaTeX 命令被制表符破坏，渲染后变成 `ext{AMAT}`

- **位置**：`src/part1/ch06.md:169`（1.6.4 命中、缺失、替换与写策略）
- **原文**（`od -c` 可见 `\t`）：
  ```text
  \text{AMAT} = \text{hit time} + \text{miss rate} \times \text{miss penalty}.
  ```
  实际文件中每个反斜杠都被替换成了 TAB：`\t` + `ext{AMAT}`、`\t` + `imes`，源码呈现为「`	ext{AMAT} = 	ext{hit time} + 	ext{miss rate} 	imes 	ext{miss penalty}.`」。
- **正确说法**：应为
  ```latex
  \text{AMAT} = \text{hit time} + \text{miss rate} \times \text{miss penalty}.
  ```
  否则 KaTeX 会把 `ext` 当普通变量、把 `imes` 当变量名，公式语义完全丢失；这不是排版小瑕疵，而是公式内容错误。
- **证据**：`sed -n '169p' ch06.md | od -c` 显示行首是 `\t e x t { A M A T }`，`imes` 前也是 `\t`；同一章其他公式（如 1.6.3 的地址拆分）均正常使用 `\text{}` 与 `\times`。

### A-10 nice 0 与 nice 10 在 4 核空机上不会得到 90%/10%，会各占满一个核

- **位置**：`src/part1/ch13.md:1153`（1.13.14 实验一：nice 值与 CPU 份额）
- **原文**：「预期：`ps` 的 `%CPU` 约为 90% 与 10%（4 核以上机器上两个进程各占满一个核时，比例仍是约 9:1）」
- **正确说法**：CFS/EEVDF 的权重只在**同一个运行队列上竞争 CPU 的任务之间**分配时间。两个 CPU 密集进程在一台空闲的 4 核机器上会被负载均衡放到不同核上，各自占满一个核：`ps -o pcpu` 会显示约 `100%` 与 `100%`（比例 1:1），而不是 90%/10%。要观察 9:1，必须把它们限制在同一个 CPU 上（`taskset -c 0`）或用单 CPU 的 cgroup quota，或者让机器上只有一个可用 CPU。
- **证据**：
  1. CFS 权重表：nice 0=1024、nice 10=110，比例 9.31:1；这个比例成立的前提是两个任务在同一 rq 上。多核调度器会把它们分散到不同 CPU（`select_task_rq_fair` 的负载均衡），每个任务获得各自 CPU 的 100%。
  2. 原文紧接着说「把 nice 改成 0 与 19，比例会拉到约 68:1（1024 对 15）」；同样只有在同一 CPU 上才成立。实验命令没有 `taskset`/cgroup 限制，因此预期值与命令不匹配。
  3. 正确的实验写法应是 `taskset -c 0 nice -n 0 ... & taskset -c 0 nice -n 10 ... &`，否则应把预期改为「两个进程各自约 100%」。

---

### A-11 `1.1.5` 的反汇编地址整体错位 2 字节：`xor`/`add`/`ret` 落在 `call` 的立即数里

- **位置**：`src/part1/ch01.md:241-249`（1.1.5 进程眼中的内存 → 从指令看 hello）
- **原文**：
  ```asm
  0000000000001149 <main>:
      1149: endbr64
      114d: sub    $0x8,%rsp
      1151: lea    0xeac(%rip),%rdi      # 2004 <_IO_stdin_used+0x4>
      1158: call   1050 <puts@plt>
      115b: xor    %eax,%eax
      115d: add    $0x8,%rsp
      1161: ret
  ```
- **正确说法**：`call rel32` 是 5 字节（`e8` + 4 字节位移），位于 `0x1158`，下一条指令在 `0x115d`；因此后续应是 `115d: xor`（2 字节）→ `115f: add`（4 字节）→ `1163: ret`。原文的 `115b`/`115d`/`1161` 分别落进了 `call` 的 rel32 位移字节、并与前一条指令重叠。
- **证据**：
  1. 指令长度：`endbr64` 4 + `sub` 4 + `lea` 7 + `call` 5 = 从 `0x1149` 到 `0x115d`；`xor %eax,%eax` 是 `31 c0` 2 字节，`add $0x8,%rsp` 是 `48 83 c4 08` 4 字节，`ret` 1 字节，故地址应为 `0x115d`、`0x115f`、`0x1163`。
  2. 同章 1.1.18（`ch01.md:752`）自己写「`call puts@plt` 位于 `0x1158`，长度 5，下一条在 `0x115d`」；1.1.18 的机器码 `e8 f3 fe ff ff` 也证明 `call` 占满 `0x1158–0x115c`。1.1.5 的列表与 1.1.18 直接矛盾。
  3. 用 clang 汇编同一串指令，`objdump` 得到 `0x0 endbr64`、`0x4 sub`、`0x8 lea`、`0xf call`、`0x14 xor`、`0x16 add`、`0x1a ret`；相对 `0x1149` 正是 `1149/114d/1151/1158/115d/115f/1163`。

### A-12 手写分配器 `alloc.c` 的块大小只加了 header，漏掉 footer，`malloc(105..112)` 会越界写 footer

- **位置**：`src/part1/ch09.md:303-310`（1.9.6 例 1.9.2）、`ch09.md:326-327`（`HDR 16`/`FTR 8`）、`ch09.md:360`（`need = align_up(n + HDR)`）
- **原文**：
  > 堆初始是一个 64 KiB 的空闲块（头部 16 B、脚部 8 B，块大小按 16 字节对齐）。请求 100 字节：需要 `100 + 16 = 116`，向上取整到 128；

  代码：
  ```c
  #define HDR       16
  #define FTR       8
  ...
  size_t need = align_up(n + HDR);
  ```
- **正确说法**：一个块占 `header(16) + payload(n) + footer(8)`，因此 `need = align_up(n + HDR + FTR) = align_up(n + 24)`。原文的 `n + 16` 漏了 8 字节 footer。请求 100 B 时 `124 → 128` 与 `116 → 128` 恰好同值，所以例子看不出问题；但 `n = 105..112` 时 `n + 16` 仍落在 128，而 `n + 24` 需要 144，`mark(off, 128, ...)` 会把 footer 写在 payload 的最后 8 字节里。
- **证据**：把该代码原样编译（`alloc.c`），调用 `my_malloc(112)`，向返回的 112 字节 payload 写 `0xAA`，再读块尾 footer（`p + 104`）：
  ```text
  footer after payload write = 0xaaaaaaaaaaaaaaaa (expected 128)
  ```
  footer 已被 payload 覆盖。随后 `my_free` 依赖 header 重写 footer 才能“掩盖”这次破坏；但只要在 free 之前发生前向/后向合并，或用户写入了可被误读为 `prev_size` 的值，就会读错前块大小。修正：`need = align_up(n + HDR + FTR)`，并把例 1.9.2 的 `100 + 16` 改为 `100 + 24`（或把 footer 从布局中删掉）。

### A-13 ARM64 的 `x30` 不是被调用者保存寄存器

- **位置**：`src/part1/ch03.md:496`（1.3.9 ARM64 对照）
- **原文**：「被调用者保存 | `%rbx`、`%rbp`、`%r12`–`%r15` | `x19`–`x28`、`x29`、`x30`（若使用）」
- **正确说法**：AAPCS64 规定被调用者必须保存 `x19`–`x29` 和 `SP`；`x30` 是 Link Register（LR），不是 callee-saved。`bl` 会把返回地址写入 `x30`，任何非叶子函数在调用别的函数前必须自己保存 `x30`（以及 `x29`），否则自己的返回地址被覆盖。把 `x30` 列为「被调用者保存」会误导读者以为可以随意调用而不保存 LR。
- **证据**：AAPCS64（Procedure Call Standard for the Arm 64-bit Architecture）6.1.1：「A subroutine must preserve the contents of the registers r19-r29 and SP」；`x30` 不在其中。`bl` 的语义就是 `x30 = PC + 4; PC = target`，这正是 x30 被调用者/调用者共同改写的原因。

### A-14 「GCC 在 C 语言下默认 `-ffp-contract=fast`」在 ISO C 模式下是错的

- **位置**：`src/part1/ch02.md:774`（1.2.10 融合乘加与双重舍入）
- **原文**：「GCC 在 C 语言下默认 `-ffp-contract=fast`，允许把乘加收缩成 FMA；这会让结果依赖目标机是否支持 FMA。」
- **正确说法**：GCC 的默认值是：**标准兼容模式**（`-std=c11`、`-std=c17` 等）下为 `-ffp-contract=off`；其他模式（GNU C、C++、Fortran 等）才是 `fast`。本书代码统一用 `-std=c17`，因此默认是 `off`，不会自动把 `a*b+c` 收缩成 FMA；要观察 FMA 必须显式加 `-ffp-contract=fast` 或 `-mfma`（并允许 contraction）。
- **证据**：GCC 官方文档 *Optimize Options* 对 `-ffp-contract=style` 的说明原文：
  > The default is `-ffp-contract=off` for C in a standards compliant mode (`-std=c11` or similar), `-ffp-contract=fast` otherwise.
  （<https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html>）
  Clang 的默认值不同（通常为 `on`），这也说明「C 语言下默认 fast」不能作为跨编译器结论。

### A-15 「CSAPP 12.5.4 用三个信号量」与紧随其后的代码（只有两个）矛盾

- **位置**：`src/part1/ch12.md:956-960`（1.12.11.1 信号量版读者-写者）
- **原文**：「CSAPP 12.5.4 用三个信号量实现「读者优先」：」，紧接着的代码只声明了：
  ```c
  sem_t mutex;      /* 保护 readcnt */
  sem_t write_sem;  /* 写者互斥，也挡住新读者 */
  ```
- **正确说法**：CSAPP 12.5.4 的读者-写者代码只有 **两个**信号量：`mutex`（保护 `readcnt`）和 `w`（写者互斥/挡住新读者）。第三个 `queue` 出现在「公平版/写者优先」变体中，用来让新读者排在写者后面；正文自己也在下一段说「要公平，加一个 `sem_t queue`」。因此这里应说「两个信号量」，或把标题/正文改成「公平版用三个」。
- **证据**：代码块自身只有 `mutex` 和 `write_sem` 两个 `sem_t`；CSAPP 12.5.4 的 `reader`/`writer` 代码同样只有 `mutex`、`w` 两个信号量，`readcnt` 是普通 `int`。

### A-16 LFS 不是「段满后写 checkpoint」，checkpoint 是周期性写入

- **位置**：`src/part1/ch13.md:511`（1.13.5 闪存与 LFS）
- **原文**：「LFS 的写路径：把 inode、数据、inode map 更新一起追加到当前段；段满后写 checkpoint，切换到新段。」
- **正确说法**：段满后只是切换到下一个段继续追加；checkpoint region 是**周期性**写入的（OSTEP 43.6 的典型值是每 30 秒一次），并不是每个段满都写。每个段都写 checkpoint 会把固定区域的写放大到不可接受，也违背 LFS「顺序写」的初衷。
- **证据**：同节表格（`ch13.md:507`）自己写的是「checkpoint region | 固定位置，周期性写入」；OSTEP 43.6 *Checkpoint Region* 明确说 LFS 周期性地（例如每 30 秒）把 inode map 和 segment summary 的指针写入 checkpoint region。两处表述应统一为「段满切换；checkpoint 周期性写」。

### A-17 五级页表不是「Linux 5.14 起可用」，而是 4.14 起

- **位置**：`src/part1/ch13.md:673`（1.13.8 页表项）
- **原文**：「第五级页表（LA57）把虚拟地址扩到 57 位，多一级 9 位索引，Linux 5.14 起在支持的 CPU 上可用。」
- **正确说法**：Linux 对 5-level paging（LA57）的支持在 **4.14**（2017 年）合并；`CONFIG_X86_5LEVEL` 从 4.14 起存在。5.14 是 2021 年的版本，晚于该功能近四年。若想强调「某发行版默认开启」应另说，不能写成「Linux 5.14 起可用」。
- **证据**：Linux 4.14 发布说明/内核新特性（kernelnewbies *Linux_4.14*）已列出 5-level paging，虚拟地址上限从 256 TiB 提升到 128 PiB；内核文档 `Documentation/arch/x86/x86_64/5level-paging.rst` 也说明该功能是 4-level 的直接扩展，QEMU 2.9+ 支持。Linux 5.14 的变更集中不包含「首次支持 LA57」。

### A-18 LFS 的 greedy 清理反复搬的是「热段」，不是「老段」

- **位置**：`src/part1/ch13.md:513`（1.13.5 闪存与 LFS）
- **原文**：「总是选「利用率最低」的段可以回收最多空间，但会让老段反复被搬；按「年龄 + 利用率」折中更稳。」
- **正确说法**：greedy 策略按最低利用率选段，问题在于**正在被写的热段**利用率低（刚追加、还没填满），清理后很快又被写脏，于是被反复清理/搬运；老的冷段被清理一次后就稳定了。cost-benefit 策略引入「年龄」正是为了避开热段、优先清理冷段。把「老段」写成反复被搬，方向反了。
- **证据**：OSTEP 43.11 *Policy Question: Which Blocks to Clean, and When?* 对 greedy 的批评是「it may repeatedly clean hot segments」；cost-benefit 用 `(utilization × age)` 的收益/成本比来选择，年龄大（冷）的段更值得清理。原文的「年龄 + 利用率」结论正确，但前一句的因果说反了。

### A-19 `x / 2^k` 的前提条件写成「x ≠ TMin 或 k=0」是错的：正整数除数不会溢出

- **位置**：`src/part1/ch02.md:600`（1.2.9 表三：移位与除法的等价关系）
- **原文**（表三的一行）：
  ```text
  | `x / 2^k`（有符号） | 向零截断 | x ≠ TMin 或 k=0 | 与 `>>` 差一个偏移 |
  ```
- **正确说法**：有符号除法的溢出只发生在 `TMin / -1`。`2^k`（k≥0）是正整数，`TMin / 2`、`TMin / 1` 都完全定义：
  ```c
  INT_MIN / 2   == -1073741824
  INT_MIN / 1   == -2147483648
  ```
  因此这个前提条件没有依据；`x / 2^k` 与 `x >> k` 的差别是「向零截断 vs 向下取整」，不是溢出。若把行改成 `x / -2^k`，才需要担心 `TMin / -1`。
- **证据**：在 x86-64/macOS 上编译运行 `printf("%d %d\n", INT_MIN/2, INT_MIN/1);`，输出 `-1073741824 -2147483648`，无 `SIGFPE`。C 标准只把 `INT_MIN / -1` 列为未定义。

### A-20 `ikj` 矩阵乘的总缺失写成 `N^3/8`，漏掉了 C 矩阵的同样一份；N=512 应是约 2.1 GB 而不是 1 GB

- **位置**：`src/part1/ch06.md:252`（1.6.5 矩阵乘与分块）
- **原文**：「内层 $N$ 次访问只触发 $N/8$ 次缺失，总缺失约 $N^3/8$，流量降到约 1 GB。仅仅交换循环顺序，缺失数降 8 倍……」
- **正确说法**：`ikj` 的内层同时流式访问 `B[k][j]` 和 `C[i][j]`，两者各贡献约 `N^3/8` 次缺失，总计约 `N^3/4`。对 `N=512`、64 B 行：
  ```text
  N^3 = 1.342e8
  B: N^3/8 = 1.677e7 misses
  C: N^3/8 = 1.677e7 misses
  合计 3.355e7 misses × 64 B = 2.15 GB
  ```
  不是 1 GB。相对 `ijk` 的 `N^3`，总缺失降的是 4 倍（按单个数组 B 才是 8 倍）。同章例 1.6.1（`ch06.md:282`）对 `N=1024` 写的是 `N^3/8 + N^3/8 + N^2/8`，正是两个 `N^3/8`，与 1.6.5 的「总缺失 N^3/8」自相矛盾。
- **证据**：上述算术；以及 1.6.1 的公式 `2.68e8 ≈ 2×1024^3/8`，对应流量 `2.68e8 × 64 B ≈ 17 GB`（原文 1.6.1 也写 17 GB），若按 1.6.5 的「N^3/8」则只有 8.6 GB。

---

## B. 实质漏节 top 15

> 判定标准：原书该节有独立机制、算法、API 或可复现实验，而本书对应落点只有一句名词、只在落点表里标「已覆盖/合并」、或干脆没有。**不含**小结、练习、纯历史、已明确淘汰的分布式章节。部分条目在别的篇章有间接覆盖，已在「为什么漏」里注明。

### B-01 OSTEP 37.2 基本几何形状

- **原书**：37.2 *Basic Geometry*（盘片/磁道/扇区/柱面、CHS 寻址）。
- **本书现状**：`src/part1/ch13.md:331` 只有一句「磁盘的物理结构是盘片、磁道、扇区、磁头」；没有柱面/磁头/扇区编号，没有 zone。
- **为什么算漏**：后续 37.3 的「简单磁盘驱动器」和 37.5 的调度都建立在几何与寻址模型上；没有 CHS/zone，读者无法理解「换道要等多转」和「同一柱面优先」。
- **建议补到**：`1.13.5.2 磁盘时间账` 开头，补 10–15 行几何图 + CHS 例子；或新增 `1.13.5.3 磁盘几何与调度`。

### B-02 OSTEP 37.3 简单的磁盘驱动器

- **原书**：37.3 *A Simple Disk Drive*（单磁道/多磁道、track skew、seek/rotation/transfer 的时序图、不同 zone 的扇区数）。
- **本书现状**：`ch13.md:357-370` 只给 `T = seek + rotation + transfer + queue` 和 7200 RPM 数字；没有时序图、track skew、zone。
- **为什么算漏**：这是 OSTEP 把「几何」变成「时间」的关键一节；缺了它，后面的 12 ms 随机读只是套公式，读者无法解释「为什么顺序读快、随机读慢」。
- **建议补到**：`1.13.5.2`，与 B-01 合并成一节。

### B-03 OSTEP 37.5 磁盘调度

- **原书**：37.5 *Disk Scheduling*（FIFO、SSTF、SCAN、C-SCAN、SPTF；starvation/arm 移动；一个具体的请求序列对比）。
- **本书现状**：`ch13.md:333` 只列了「FIFO、SSTF、SCAN、CFQ、mq-deadline/kyber/bfq」这些名字；`ch13.md:380` 只讲现代 blk-mq 调度器。没有经典算法的请求序列、总寻道距离、饥饿分析。
- **为什么算漏**：`3.13.3` 讲的是 Linux 的 `mq-deadline`/`bfq`/`kyber`，不是 OSTEP 37.5 的经典算法；读者知道名字但不会手算「SSTF 比 FIFO 少走多少磁道」，也不会解释 SCAN 的饥饿。
- **建议补到**：`1.13.5.2` 增加一个 8 请求的例子（FIFO/SSTF/SCAN/C-SCAN 的磁头轨迹与总移动距离）；或放到 `3.13.3` 作为「经典算法 → blk-mq」的过渡。

### B-04 OSTEP 36.8 案例研究：简单的 IDE 磁盘驱动

- **原书**：36.8 *Case Study: A Simple IDE Disk Driver*（寄存器、命令/状态、`outb/inb`、中断、请求队列、`ide_rw` 的完整路径）。
- **本书现状**：`1.13.5.1` 用网卡收包举例（`pci_enable_device`/`ioremap`/NAPI），没有块设备驱动；`1.13.6 项目 8` 只有 5 行侧写；`3.14` 是字符设备驱动（`misc`），没有块设备 `request_queue`/`gendisk` 的完整案例。
- **为什么算漏**：OSTEP 36.8 是把「设备寄存器 + 中断 + DMA + 请求队列」串起来的唯一完整案例；本书的驱动章节偏字符设备，块设备路径只在 `3.13` 讲 bio/request，缺少「驱动如何真正发命令」的一层。
- **建议补到**：`1.13.5.1 设备驱动模型` 增加一个「最小块设备驱动」侧写；或把 `1.13.6 项目 8` 扩成 30–50 行，与 `3.13` 的 bio/request 对接。

### B-05 OSTEP 43.3 要缓冲多少

- **原书**：43.3 *How Much to Buffer?*（写缓冲的时机、段大小与写放大/延迟的权衡）。
- **本书现状**：`1.13.5` 的 LFS 五机制表（`ch13.md:503-509`）没有「缓冲」一项；`ch13.md:511` 只写「把 inode、数据、inode map 更新一起追加」。
- **为什么算漏**：LFS 的顺序写性能取决于「攒多少再写」；不讨论缓冲，读者无法理解为什么 LFS 要延迟写、段大小如何影响清理成本。
- **建议补到**：`1.13.5 闪存与 LFS`，在五机制表后加一段「写缓冲与段大小」。

### B-06 OSTEP 43.4 问题：查找 inode

- **原书**：43.4 *Problem: Finding Inodes*（inode 号不再对应固定磁盘位置，LFS 如何定位最新 inode）。
- **本书现状**：`ch13.md:505` 只写「inode map | inode 号 → 最新 inode 位置」，没有说明「为什么不能按 inode 号算偏移」。
- **为什么算漏**：这是 LFS 与 FFS 的核心差异；不点出「inode 会随日志移动」，inode map 的存在就没有动机。
- **建议补到**：`1.13.5 闪存与 LFS`，在 inode map 行前加 1 段问题陈述。

### B-07 OSTEP 43.5 通过间接解决方案：inode 映射

- **原书**：43.5 *Solution Through Indirection: The Inode Map*（imap 的结构、imap 块如何随日志追加、固定位置只保留 imap 指针）。
- **本书现状**：`ch13.md:505-506` 只有两行表格名词；没有 imap 的磁盘结构、更新路径、与 checkpoint 的关系。
- **为什么算漏**：只记「有 inode map」等于没学 LFS 的寻址机制；读者无法回答「imap 自己存在哪、怎么找最新的 imap」。
- **建议补到**：`1.13.5 闪存与 LFS`，紧接 B-06 补 imap 结构图与一次写路径。

### B-08 OSTEP 43.10 确定块的死活

- **原书**：43.10 *Determining Block Liveness*（segment summary + inode map 检查、版本号、清理时如何判断块是否仍被引用）。
- **本书现状**：`ch13.md:508` 只写「segment summary | 段内每个块属于哪个 inode/偏移 | 清理时判断块是否仍存活（liveness）」。
- **为什么算漏**：这是 LFS 清理正确性的核心；没有「查 imap 版本/偏移」的判定过程，读者会以为看 segment summary 就能判断死活。
- **建议补到**：`1.13.5 闪存与 LFS`，在 cleaning 行后加 1 段判定流程。

### B-09 OSTEP 43.12 崩溃恢复和日志

- **原书**：43.12 *Crash Recovery and Logging*（checkpoint region 的双缓冲/日志、崩溃后如何找到最近一致的 checkpoint、LFS 的恢复路径）。
- **本书现状**：`1.13.5` 只写「checkpoint region 固定位置，周期性写入；崩溃后从最近 checkpoint 恢复」；`1.13.11` 讲的是传统 redo 日志，不是 LFS 的 checkpoint+log 恢复。
- **为什么算漏**：LFS 的崩溃一致性方案与 FFS+journal 不同；不写这一节，读者会把 1.13.11 的 redo 协议直接套到 LFS 上。
- **建议补到**：`1.13.5 闪存与 LFS`，补「checkpoint 双缓冲 + 崩溃恢复」一小节。

### B-10 OSTEP 23.4 页替换

- **原书**：23.4 *Page Replacement*（VAX/VMS 的 segmented FIFO、clean/dirty 队列、页回收）。
- **本书现状**：`ch13.md:301` 只有一句「VAX/VMS 是早期把分段+分页+swap 组合得最完整的系统之一」；`3.10` 讲的是 Linux 的 LRU/active-inactive，不是 VAX 的算法。
- **为什么算漏**：VAX 的 segmented FIFO + clean/dirty 队列是「页替换在真实系统里怎么落地」的经典案例，不是纯历史；它能解释「为什么脏页要单独链表」「为什么 FIFO 要分段」。
- **建议补到**：`1.13.3.2 交换` 或 `1.13.10 页替换模拟`，补 1 页案例对照（VAX vs Linux）。

### B-11 OSTEP 23.5 其他漂亮的虚拟内存技巧

- **原书**：23.5 *Other Neat VM Tricks*（demand zeroing、copy-on-write、lazy optimization、page clustering、按需清零）。
- **本书现状**：`1.13.3.2` 只讲 present 位/swap 槽/换入五步；COW 在 `1.9`/`1.13.8` 有提及，但没有 VAX 这一组「用 VM 做优化」的技巧。
- **为什么算漏**：这些技巧是现代 fork/COW、零页、惰性分配的直接来源；只讲「缺页换入」会漏掉 VM 作为**优化机制**的一面。
- **建议补到**：`1.13.3.2`，在 swap 流程后加「VM 作为优化：demand zeroing/COW/lazy」。

### B-12 OSTEP 16.2–16.6 分段机制

- **原书**：16.2 *Which Segment Are We In?*、16.3 *What About the Stack?*、16.4 *Supporting Sharing*、16.5 *Fine-Grained and Coarse-Grained Segmentation*、16.6 *OS Support*。
- **本书现状**：`1.13.3.1` 只有一段：基址/界限、外部碎片、compact、Linux 用分页；没有「显式/隐式段选择」「栈段如何增长」「段共享」「粗/细粒度」「OS 如何保存段表」。
- **为什么算漏**：分段不是纯历史——x86 保护模式、段选择子、Linux 的 `LDT`/`modify_ldt`、以及「分段+分页」组合仍出现在内核与虚拟化里；只讲基址/界限不足以回答 OSTEP 16 的问题。
- **建议补到**：`1.13.3.1`，补段选择/栈段/共享/粒度四小段；或在 `3.8` 加「x86 分段与 Linux 的兼容层」。

### B-13 OSTEP 41.5 测量文件的局部性

- **原书**：41.5 *Measuring File Locality*（用 seek 模式/块访问轨迹测量 FFS 的局部性）。
- **本书现状**：`ch13.md:516` 只讲 FFS 的柱面组分配策略；没有测量方法、没有「怎么证明同组优先真的减少寻道」。
- **为什么算漏**：这是 OSTEP 从「策略」走到「证据」的一节；本书的 FFS 段落只有结论，没有可复现的测量，读者无法验证。
- **建议补到**：`1.13.5 文件系统` 的 FFS 段，加一个 `fio`/`blktrace` 测量 seek 距离的小实验；或放到 `3.12.5`。

### B-14 OSTEP 42.2 解决方案 1：文件系统检查

- **原书**：42.2 *Solution 1: File System Checker*（超级块检查、位图与 inode 表交叉验证、目录检查、重复块/坏块处理、fsck 的检查步骤及局限）。
- **本书现状**：`1.13.11` 只有一句「FSCK：启动时扫描全盘，检查并修复不一致；慢，且不一定能恢复语义」；`0.10.11` 有 e2fsck 的五个阶段和退出码，但没有 OSTEP 的检查逻辑（超级块/位图/inode/目录/重复块）。
- **为什么算漏**：只记住「fsck 很慢」不够；读者需要知道它到底检查什么、为什么不能恢复语义、为什么日志文件系统仍需要 fsck 兜底。
- **建议补到**：`1.13.11` 的 FSCK bullet 扩成 1 段，并与 `0.10.11` 交叉引用；或把 `0.10.11` 的「五阶段」补上检查对象。

### B-15 CSAPP 5.12 理解内存性能（load/store 吞吐）

- **原书**：5.12 *Understanding Memory Performance*（load 单元、store buffer、读写依赖/别名对吞吐的影响）；相邻的 6.6 还有 memory mountain（固定 stride 扫工作集、固定工作集扫 stride）。
- **本书现状**：`ch05.md:1088` 的母本表把 5.12 标为「合并 | 1.5.8、1.5.12」；但 1.5.8 讲的是分块/SoA/预取，1.5.12 是矩阵乘 CPE 实测，没有 load/store 吞吐的实验；6.6 的 memory mountain 也没有 size×stride 扫描。
- **为什么算漏**：5.12 的 load/store 性能模型（store buffer、读写依赖、别名）是理解「为什么同样指令数会差几倍」的关键；memory mountain 则是把缓存层次与程序性能连起来的标准测量。只做矩阵乘分块，读者不会测自己的程序到底卡在 load、store 还是某一级缓存。
- **建议补到**：`1.5.8` 增加 load/store 吞吐实验与 `memory_mountain.c`（工作集 4 KiB–1 GiB × stride 1–64；后者对应 6.6）；或放到 `1.6.14` 的 `cachegrind/perf` 之后。

---

## C. 已核对无问题清单

> 这一节只列**抽查过且未发现事实错误**的点，不代表全章逐字无误；A 节已列出的错误不重复。

### C.1 数字与公式（逐项复算）

| # | 位置 | 核对内容 | 结果 |
|--:|:--|:--|:--|
| 1 | `ch01.md:364-386` | Amdahl：`p=0.6,s=4 → 1.82`、`Smax=2.5`；`p=0.95 → 3.48/20`；表 40/10/5/1% 的 4/16 核值；例 1.1.1 的 1.67/1.25/2.5 | 全部一致 |
| 2 | `ch01.md:1048-1071` | CPI：`IPC=2.56/3.2=0.8`、`CPI=1.25`；基础 1.3e9、分支 0.3e9、LLC 1.6e9；CPI 贡献 0.508/0.117/0.625；LLC 减半 1.33、消分支 1.10、两者 1.52 | 全部一致 |
| 3 | `ch01.md:960-972` | Little 定律：25 GB/s×80 ns=2000 B≈31 行；L1 260 B/4 行；NVMe 20 µs×500k=10；1 GbE 62.5 KB；10 GbE 625 KB | 全部一致 |
| 4 | `ch01.md:746-758` | 重定位：`0x2004-4-0x1154=0xEAC`；`0x1050-4-0x1159=-0x10D=0xfffffef3`；`e8 f3 fe ff ff` | 全部一致 |
| 5 | `ch01.md:889-914` | auxv 编号：`AT_SYSINFO_EHDR=33`、`AT_RANDOM=25`、`AT_ENTRY=9`、`AT_PAGESZ=6`；`AT_RANDOM` 16 B | 全部一致 |
| 6 | `ch01.md:1102-1111` | `e_machine` 62/183/243；`write` 1/64/64；`exit_group` 231/94/94；参数寄存器 rdi…/x0–x5/a0–a5 | 全部一致 |
| 7 | `ch02.md:436-462` | `0.15625 → 0x3E200000`；`0.1f=0x3DCCCCCD`；`0.1d=0x3FB999999999999A`；`1.0/0.5/∞/qNaN` 位模式 | 全部一致 |
| 8 | `ch02.md:700-715` | ULP 表：[1,2) 2^-23、[2,4) 2^-22、[2^20,2^21) 0.125、[2^23,2^24) 1；double 对应值 | 全部一致 |
| 9 | `ch02.md:719-738` | 四种舍入模式的 1.5/-1.5 结果；`ε=2^-23/2^-52`；相对误差 ≤ε/2 | 全部一致 |
| 10 | `ch02.md:767-772` | FMA 例：`(1+2^-23)(1-2^-23)=1-2^-46`；先乘后加 0，FMA 得 `-2^-46` | 全部一致 |
| 11 | `ch03.md:576-581` | 六个机器码：`48 89 07`、`48 8b 07`、`48 83 c7 08`、`48 8d 44 b7 08`、`b8 01 00 00 00`、`ff e0` | 全部一致 |
| 12 | `ch04.md:240-243` | 分支 CPI：`1+0.2×0.1×15=1.30`；99% 时 1.03；加速 1.30/1.03≈1.26 | 全部一致 |
| 13 | `ch04.md:713-720` | ROB Little 定律：224/30=7.5；1% L3：224/32=7.0；10% DRAM：224/60=3.7 | 全部一致 |
| 14 | `ch05.md:529` | `1e8×0.5/3e9≈16.7 ms` | 一致 |
| 15 | `ch05.md:540` | `p=0.9,s=10 → 1/(0.1+0.09)=5.26` | 一致 |
| 16 | `ch06.md:507-511` | 32 KB/8 路/64 B：S=64、offset 6、index 6、48 位 VA 的 tag 36 | 一致 |
| 17 | `ch06.md:140-148` | `0xA5C8`：offset 8、index 23、tag 0xA；元数据 `512×22 bit=1408 B=4.3%` | 一致 |
| 18 | `ch06.md:166-172` | AMAT：`1+0.1×20=3 ns`；`1+0.02×20=1.4 ns`（公式标记问题见 A-09） | 数值一致 |
| 19 | `ch09.md:84-110` | 1.9.3 页表 walk：四级索引 254/241/233/232、offset 0xa40、PA 0x2e8a0a40 | 全部一致 |
| 20 | `ch09.md:512-527` | 1.9.8 页表 walk：索引 0xff/0x30/0x91/0x145、表项地址、PA 0x1a2bd678 | 地址与索引一致（D 位见 A-06） |
| 21 | `ch13.md:80-82` | FIFO 周转 10/14/15 平均 13、响应 0/9/13；SJF 10/16/10 平均 12、响应 0/11/8 | 一致 |
| 22 | `ch13.md:811` | 引用串 1 2 3 4 1 2 5 1 2 3 4 5：FIFO 3 框 9、4 框 10；OPT 7→6；LRU 10→8；Clock 9→10 | 全部一致（用 Python 重放） |
| 23 | `ch13.md:699-711` | CFS 权重：-20 88761（86.7×）、-10 9548（9.3×）、0 1024、10 110（0.107×）、19 15（0.015×） | 一致 |
| 24 | `ch13.md:794` | lottery/stride 程序输出：50.2/24.6/25.2，stride 50/25/25，pass 均 5,000,000 | 实跑一致 |
| 25 | `ch13.md:1023` | journal.c 输出：无日志 1/2 步不一致，3 步一致；redo 四行一致 | 实跑一致 |
| 26 | `ch13.md:357-370` | 7200 RPM 一圈 8.33 ms、平均 4.17 ms；`8+4.17+0.04≈12 ms`、IOPS≈83；4 KiB/100 MB/s=0.04 ms | 一致（取整后） |
| 27 | `ch13.md:384-391` | RAID 0/1/4/5/6/10 的最少盘数、容量利用率、容错盘数 | 全部一致 |

### C.2 代码/汇编实测

| 对象 | 命令/环境 | 结果 |
|:--|:--|:--|
| `ch03` `frame.s`（sum_to/my_strlen/swap_pair/add6） | `clang --target=x86_64-linux-gnu -c frame.s` | 汇编通过；无语法错误 |
| `ch03` `a64.s`（a64_sum_to/a64_strlen/a64_add6） | `clang --target=aarch64-linux-gnu -c a64.s` | 汇编通过 |
| `ch02` `endian_sum.s` | `clang --target=x86_64-linux-gnu -c endian_sum.s` | 汇编通过 |
| `ch04` Y86-64 解释器 | `cc -std=c17 -O2` 编译运行 | `status=2 steps=43 pc=0x2b ZF=1 SF=0 OF=0`、`rax=55`，与原文一致 |
| `ch09` `mymalloc.c`（1.9.11） | clang 编译运行 | `used=208`；free b 后 `malloc(64)` 复用 b；`used=160`；全部 free 后 0，与原文一致 |
| `ch09` `alloc.c`（1.9.6） | clang 编译 + 112 B 测试 | 编译通过，但 `my_malloc(112)` 的 footer 被 payload 覆盖（A-12） |
| `ch13` `sched.c` | clang 编译运行 | FIFO/SJF 输出与原文一致；RR 输出 A=17/B=13/C=6，与原文列出的 B 12–14、16–17 不符（A-05） |
| `ch13` `lottery.c` | clang 编译运行 | 输出 50.2/24.6/25.2、pass 5,000,000，与原文一致 |
| `ch13` `page_repl.c` | clang 编译运行 | 3 框 9/7/10/9，4 框 10/6/8/10，与原文一致 |
| `ch13` `journal.c` | clang 编译运行 | 与原文「写 1/2 步不一致、写 3 步一致；redo 全一致」一致 |
| `ch12` `race.c` | clang 编译运行 | 本机一次运行恰好 4,000,000（数据竞争不保证每次复现；非错误） |
| `ch12` `pc.c` | clang 编译 | macOS 上 `sem_init` 被标 deprecated 且运行时 ENOSYS；Linux 目标代码，**未在 Linux 实跑** |

说明：本机为 Apple clang 21 / arm64 macOS；x86-64 与 AArch64 汇编仅做**交叉汇编**，未链接 Linux libc；所有 `/proc`、`strace`、`perf`、`epoll`、`fio` 相关的运行期结论均未在本机实测，只做静态核对。

### C.3 其他已核对无误的点

- `ch01` 1.1.12 `_start` 栈布局与 `envp = argv + argc + 1`：x86-64 `lea 16(%rsp,%rdi,8)`、ARM64/RISC-V 的 `+8` 都正确。
- `ch01` 1.1.13/1.1.19 动态链接搜索顺序表（RPATH→LD_LIBRARY_PATH→RUNPATH→cache）正确；仅 1.1.16 速查行写反（A-08）。
- `ch03` 1.3.11 结构体分类：P/Q/R/S/T 的 INTEGER/SSE/MEMORY 分类、`%rax:%rdx`/`%xmm0:%xmm1` 返回、`MEMORY` 隐藏指针在 `%rdi`，均正确。
- `ch03` 1.3.11 变参 `%al` 规则、`ucomisd` + `jp` 判 NaN、`cvttsd2si` 截断，均正确。
- `ch04` 1.4.2 Y86-64 编码：`irmovq $1,%rax = 30 F0 …`、`jne` 无寄存器字节、`call` 9 字节、`valP` 计算，均正确。
- `ch06` 1.6.4 3C 缺失、写回/写分配、MESI 四状态与伪共享，均正确。
- `ch07` 1.7.9 ELF 结构：`Ehdr=64`、`Shdr=64`、`Sym=24`、`Rela=24`、`Phdr=56`；`p_type` 的 `GNU_STACK=0x6474e551`、`GNU_RELRO=0x6474e552`，均正确。
- `ch07` 1.7.11 重定位：PLT32 的 `P=0xa3`、`vsum-4`、`e8 00 00 00 00`，与 1.1.18 的口径一致。
- `ch08` 1.8.4 标准信号不排队、`SIGCHLD` 合并、`SA_RESTART` 不重启 `poll/epoll_wait/select`、`sigsuspend` 原子性，均正确。
- `ch10` 1.10.8 fd 三层结构、`dup2` 共享偏移/状态标志、`FD_CLOEXEC`/`O_CLOEXEC`、`EMFILE` vs `ENFILE`，均正确。
- `ch11` 1.11.6 MSS：IPv4 1500−20−20=1460；IPv6 1500−40−20=1440；`ping -s 1472` 加 8+20=1500，均正确。
- `ch11` 1.11.3 `TIME_WAIT=2×MSL≈60 s`、`SO_REUSEADDR` 只解决 `TIME_WAIT` bind，均正确。
- `ch12` 1.12.9 内存序表（relaxed/acquire/release/acq_rel/seq_cst 与 x86/ARM64 指令）基本正确；`seq_cst` store 在 x86 需 `xchg`/`mfence`，ARM64 需 `dmb ish`。
- `ch12` 1.12.10 futex 三态 0/1/2 与 `FUTEX_WAIT` 睡眠前原子比较状态字，正确。
- `ch13` 1.13.4 并发 bug 分类（原子性违反/顺序违反/死锁/活锁/饥饿）与 1.12 的展开一致。
- `ch13` 1.13.8 `fork` 复制页表+清 RW（COW）、`clone` 标志共享 mm/files、`task_struct` 字段分组，均正确。
- `ch13` 1.13.11 redo 日志协议（写日志→commit→checkpoint→回收；有 commit 重放、无 commit 丢弃）与 ext4 `data=journal/ordered/writeback` 表，均正确。
- `ch13` 1.13.12 OSTEP 50 章落点表的章号/主题/页码与 `clean-ostep.md` 基本对应；个别状态标「已覆盖」但内容偏薄，见 B 节。

### C.4 未计入 top 20 的次级问题（供修订参考，不计入 A 节排名）

1. **`ch01.md:279-289` 的「1 周期 = 1 秒」换算表按 1 GHz 计算，但正文说 1 周期≈0.3 ns（约 3.3 GHz）**。按 0.3 ns 重算，DRAM 90 ns≈300 s（5 分钟）而非 1.5 分钟，NVMe 50 µs≈42–46 小时而非 14 小时，HDD 10 ms≈350–390 天而非 116 天。建议把表头改成「1 ns = 1 秒」，或按 0.3 ns/cycle 重算。
2. **`ch01.md:1124`「GNU readelf 可能只编入本机架构支持」**。GNU `readelf` 通常能解析任意 `e_machine` 的 ELF 头/节/符号；发行版 binutils 多数配置了多目标。建议改成「某些裁剪版 binutils 可能缺少目标相关的注释/unwind 解析，交叉核对优先用 `llvm-readelf`」。
3. **`ch13.md:657` 标题「10 个位决定一次翻译」与表（9 行）不一致**：表列了 P/RW/US/PWT/PCD/A/D/PS/NX 共 9 个，漏了 `G`（bit 8）。若标题按 10 个算，应补 G；若只讲常用位，标题改 9。
4. **`ch13.md:274`「LRU 理论最优之一」**：LRU 不是最优，OPT（Belady）才是；LRU 只是栈算法、无 Belady 异常且通常接近 OPT。建议改「LRU 是栈算法，命中率通常接近 OPT，但需要访问顺序」。
5. **`ch13.md:574-575` 项目 8 的 `request_queue`/`hd_request` 是 Linux 2.6+ 的结构**；Linux 0.11 的块设备层是 `blk_dev[]` + `struct request` 数组 + `ll_rw_block`，没有 `request_queue`。建议改成 Linux 0.11 的实际结构。
6. **`ch06.md:925` 矩阵乘 A 的流量写「约 1 GB（实际按行加载 8 MB × 复用）」**：若 A 行（8 KB）能留在 L1，A 的总流量就是 8 MB，不是 1 GB；1 GB 是「每次都不命中」的上界。建议把「约 1 GB」改成「上界 1 GB；实际约 8 MB」。
7. **`ch06.md:939` L2=1 MB 时 `b≤208`，却建议「取 128 或 256」**：`b=256` 的工作集 `3×256²×8=1.5 MB > 1 MB`，不满足前面的不等式。建议改为「取 128」或把 256 标注为「会溢出 L2，仅作对照」。
8. **`ch03.md:829`「输入 80 个字节就会覆盖保存的 rbp 与返回地址」**：这是无 canary 的经典布局；Ubuntu 默认 `-fstack-protector-strong` 下，80 B 会先触发 `__stack_chk_fail`，不会正常 `ret` 到被改地址。建议补一句「示例假设 `-fno-stack-protector`；默认发行版会先被 canary 拦截」。
9. **`ch13.md:301` VAX/VMS 只有一句**，落点表（`ch13.md:1074`）却标「背景」；这不是事实错误，但属于 B-10/B-11 的漏节。
10. **`ch01.md:806` PLT 桩示例没有 `endbr64`**：现代 GCC/Clang 默认 `-fcf-protection` 时，PLT 桩以 `endbr64` 开头，桩内偏移会多 4 字节。示例作为教学简化可以接受，但若读者拿真实 `objdump` 对照会对不上；建议注明「省略了 endbr64」。

---

## D. 结论与优先级

1. **必改（会导致代码错/汇编不过/数字错）**：A-01、A-02、A-03、A-04、A-05、A-06、A-11、A-12、A-20。
2. **应改（事实/口径错，影响理解）**：A-07、A-08、A-09、A-10、A-13、A-14、A-15、A-16、A-17、A-18、A-19。
3. **应补（原书节有实质内容未落点）**：B-01～B-05（磁盘/驱动）、B-06～B-09（LFS）、B-10～B-12（VAX/分段）、B-13～B-15（FFS/fsck/内存山）。
4. **建议在修订后复跑**：`ch13` 的 `sched.c`（RR 序列）、`ch09` 的 `alloc.c`（112 B footer）、`ch06` 的 `ikj` 流量（2.1 GB），以及 `ch01` 的 `objdump` 地址（`115d/115f/1163`）。

> 本报告只读；未修改正文。所有 `文件:行` 均对应当前工作区版本（2026-10-19 快照）。

---

## 修复记录（2026-10-24）

> 在 2026-10-19 快照之后的并行改动基础上逐条核查。「已修复」= 并行改动已落实，本次只复核；「本次修复」= 仍残留、由本轮补齐。B 类漏节按要求只统计、不补写。

### A 节处置（20/20；此前已修复 13、本次修复 7、未找到 0）

| 编号 | 处置 | 说明 |
|:--|:--|:--|
| A-01 | 已修复 | 1.3.6 现为 `subq $8` + `movq $7,(%rsp)`：`call` 前 rsp≡0，callee 入口 ≡8；保留「不能先 sub 8 再 push」警告。抽出 caller 片段用 `clang --target=x86_64-linux-gnu -c` 复核可汇编 |
| A-02 | 已修复 | 已改为 `movl 8(%rdi), %eax`（int 字段 32 位传送） |
| A-03 | 已修复 | 已改为「目的可以是寄存器或内存；两操作数不能同时是内存」 |
| A-04 | 已修复 | 正文「12 次访问、5 次命中（第 4/6/8/9/12 次），命中率 41.7%」，与 LRU 表逐行重放一致 |
| A-05 | 已修复 | RR 区间已改为 `…A 10–12，B 12–13，A 13–15，A 15–17`；B 恰好 5 个单位，周转 17/12/4、平均 11、响应 0/1/2 自洽 |
| A-06 | 已修复 | 1.9.8 已读作 A=1、D=1，bit 7 注明为 PAT |
| A-07 | 已修复 + 本次修复 | `jmp` 目标已改 `1020 <plt0>`；但并行改动留下的机器码 `e9 a0 ff ff ff`（0x105b+5−0x60=0x1000）与标号 0x1020 矛盾，本次改为 `e9 c0 ff ff ff`（0x1060−0x40=0x1020），字节与标号自洽 |
| A-08 | 已修复 | 1.1.16 速查行已是 `RPATH → LD_LIBRARY_PATH → RUNPATH → ld.so.cache → 默认目录` |
| A-09 | 本次修复 | 1.6.4 公式行与例题行共 2 处 `\text`/`\times` 的反斜杠仍被 TAB 破坏（`TABext{…}`/`TABimes`），本次还原为 `\text{…}`/`\times` |
| A-10 | 已修复 | 实验已用 `taskset -c 0` 绑核，并注明「不绑核时两进程各占一核、都约 100%」 |
| A-11 | 已修复 | 1.1.5 地址已是 `115d/115f/1163`，与 1.1.18 的 `call` 长度 5 一致 |
| A-12 | 已修复 + 本次修复 | 代码已是 `align_up(n + HDR + FTR)`；但例 1.9.2 正文仍是 `100 + 16 = 116`、`216 → 224`，本次改为 `100 + 16 + 8 = 124 → 128`、`200 + 24 = 224`。抽出代码编译运行：`my_malloc(112)` 块 144、payload 写满 0xAA 后 footer=144 完好；例题序列得 128/224 |
| A-13 | 已修复 | 表格与正文已注明 x30 是 link register、非 callee-saved |
| A-14 | 本次修复 | 并行改写「`-std=c17` 仍允许 contraction（on）」不实：GCC 文档明确标准兼容模式默认 `off`、否则 `fast`（GCC 14 起落实，更早版本各模式均默认 `fast`）；Clang 默认 `on`。已按此重写，并说明本书 `-std=c17` 下 GCC 14+ 不自动收缩 |
| A-15 | 本次修复 | 「用三个信号量」→「用两个信号量」（代码只有 `mutex`/`write_sem`；`queue` 属公平版，正文下一段已交代） |
| A-16 | 已修复 | 已写「checkpoint region 是周期性写入的（不是每个段都写）」 |
| A-17 | 已修复 | 已改「Linux 4.14 起可用」 |
| A-18 | 本次修复 | 并行改动方向已对但仍含混（「仍含热数据的段」）；本次按 OSTEP 43.11 写明机制：热段刚追加、未填满、利用率天然低，故被反复清理；冷段清一次即稳 |
| A-19 | 已修复 | 前提已改「恒定义（除 `TMin / -1`）」 |
| A-20 | 已修复 + 本次修复 | 1.6.5 已是「B、C 各 N³/8，总 N³/4；N=512 约 3350 万次、2.15 GB」；出口检查表残留「会算 N³/8」，本次改为「会算 N³/4（B、C 各 N³/8）」 |

### ch14–ch19 快速扫描（报告未覆盖篇目）

核过无误的抽查点：Sv39 `satp`/PTE 字段（MODE=8、PPN 在 53:10、V=1 且 R/X 规则）、7 个指令编码手算（`0x8B010000`、`0xF9400420`、`0x91000400`、`0x00B50533`、`0x00150513`、`0x00113423`、`0x00B51463`）、三套 ABI 寄存器责任表与红区（仅 x86-64 有 128 B）、SBI 的 EID/FID 与「a0=错误码、a1=值」、trap 保存区 34 槽与 `__switch` 14 槽偏移（s0 在 16、s11 在 104）、`CONFIG_RUST` 于 Linux 6.1、`rustup target add`/`cargo +nightly miri`/`qemu-system-riscv64 -bios` 等命令。

本次修复的硬错误 3 处：

1. `ch14.md` 1.14.2 表：RISC-V 通用寄存器「31 个（`x0`…`x31`）」→「32 个（`x0`…`x31`，其中 `x0` 恒 0）」；1.14.1 布局图「16/31 个」→「16/31/32 个」。
2. `ch18.md` 1.18.3.1：S 态 `ecall` 落入 M 态，陷阱原因写成 `scause=9`；该陷阱由 M 态处理（同句已在用 `mepc`/`mret`），本次改为 `mcause=9`（Environment call from S-mode）。
3. `ch19.md` 实验二：`p/x *(unsigned long*)$satp` 把 satp 原值当地址，不是根页表（satp = MODE|ASID|PPN）；本次改为 `p/x (($satp & 0xfffffffffff) << 12)`，由 PPN 求根页表物理地址。

记录未改的存疑点（非硬错误）：ch14「定长 4 字节（可扩展 2/6）」中 48 位编码只是规范保留、未标准化；ch19 GDB 读物理内存依赖 QEMU gdbstub 的翻译行为，实验以教程环境为准。

### B 类漏节

B-01…B-15 共 **15 项**，按任务要求全部未补写，仅统计。

### 验证

- `python3 tools/check_book.py`：修复前后输出一致（pages 113 / total lines 127036 / substantial 103），未引入新问题。
- `python3 tools/verify_teaching_examples.py`：4 个测试 OK（含 ch09 页表算例）。
- ch09 分配器抽出编译运行（`cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -O2`）：A-12 修复后 112 B 请求不再覆盖 footer，例 1.9.2 数值与正文一致。
- ch03 caller 片段 `clang --target=x86_64-linux-gnu -c` 汇编通过。

---

## 漏节处置（2026-10-25）

> 逐条处置 B-01…B-15。判定口径按 `50-节级审计规程.md` 的五种判定（覆盖/合并/背景/淘汰/真缺口）；补写规则：并入最相关现有小节末尾、不新起 H2、每缺口 ≤40 行、不动已有编号与锚点。本轮只改 `src/part1/ch05.md`、`ch06.md`、`ch13.md` 与本文件。

### 判定与处置总表

| 编号 | 母本节 | 判定 | 处置位置 / 理由 |
|:--|:--|:--|:--|
| B-01 | OSTEP 37.2 基本几何 | 真缺口 | 新增 `ch13.md` `### 磁盘几何与经典调度 {#sec-1.13.5.3}`（H3 编号顺延，锚点全书唯一；part3/ch13 落点表本就写明「CHS 几何在 1.13.5」，此处是既定落点）：盘片/磁头/磁道/扇区/柱面、CHS 三元组示例、LBA 取代 CHS、ZBR |
| B-02 | OSTEP 37.3 简单磁盘驱动器 | 真缺口 | 同 `1.13.5.3`：「几何→时间」对照表（换道/旋转/zone）+ 磁道偏斜（track skew）一段，解释「为什么顺序快、随机慢」的物理来源 |
| B-03 | OSTEP 37.5 磁盘调度 | 真缺口 | 同 `1.13.5.3`：6 请求手算表（FIFO 226 / SSTF 95 / SCAN 100 / C-SCAN 服务 57+回程 65，磁道 40 起点），四算法轨迹与饥饿边界已用脚本复算一致；SPTF 一句；`mq-deadline` = SCAN + 过期，链到 3.13.3。经典算法的 Linux 实现不重复 3.13.3 内容 |
| B-04 | OSTEP 36.8 IDE 驱动案例 | 覆盖（合并） | 不补。机制（设备寄存器 + 命令 + 中断 + DMA + 请求队列）已有两个等价最小案例：`1.13.5.1` 网卡五步、`1.13.6` 项目 8（块设备 `outb` 发命令、中断搬运、`bread/bwrite` 上层路径）；块设备 `bio/request/blk-mq` 深落在 3.13，字符设备 `probe/remove` 深落在 3.14。OSTEP 36.8 的 IDE 寄存器位定义属历史案例，按背景口径不展开（正文已有等价现代案例，无需加指路句） |
| B-05 | OSTEP 43.3 要缓冲多少 | 真缺口 | `1.13.5 闪存与 LFS` 写路径段后补「写缓冲」段：段大小/缓冲量与写放大、延迟、崩溃丢失窗口的权衡 |
| B-06 | OSTEP 43.4 查找 inode | 真缺口 | 同处补问题陈述：FFS 可按 inode 号算固定偏移，LFS 的 inode 随日志移动，按号算失效——imap 的动机 |
| B-07 | OSTEP 43.5 inode 映射 | 真缺口 | 同处补 imap 存法：imap 块随段追加、checkpoint region 固定位置只存「最新 imap 指针」、写路径四步（数据→inode→imap→checkpoint） |
| B-08 | OSTEP 43.10 块死活判定 | 真缺口 | `闪存与 LFS` 清理段后补判定流程：读 segment summary 得 (inode, 偏移)，再查 imap 现状定死活——summary 只记「出身」，死活以 imap 为准 |
| B-09 | OSTEP 43.12 崩溃恢复 | 真缺口 | 同处补 checkpoint 双缓冲（两份交替写、取时间戳新者）、roll forward，并明确与 `1.13.11` redo 日志的区别（就地写+重放 vs 数据本在日志里、只需找一致起点） |
| B-10 | OSTEP 23.4 VAX/VMS 页替换 | 背景已提 | 不改。`ch13.md` 1.13.3.2 已有一句 VAX/VMS 定位句；segmented FIFO 与脏/净分队列的**现代对应物**（active/inactive 双链表、脏页单独回写）在 3.10 展开，正文机制不缺。VAX 细节按背景归类，不写入正文 |
| B-11 | OSTEP 23.5 VM 技巧 | 真缺口（部分） | `1.13.3.2` swap 五步后补一段：按需清零（共享零页）/COW（指向 1.9）/聚簇换入（swap 预读）——聚簇换入此前全书无落点（grep 确认无 readahead/预读/聚簇），COW 与零页是收拢指路 |
| B-12 | OSTEP 16.2–16.6 分段机制 | 真缺口 | `1.13.3.1` 末补「四问四答」：段号怎么来（隐式高位 vs x86 段选择子/GDT/LDT）、栈段反向增长位、粗/细粒度共享、切换代价；x86-64 的遗产 = FS/GS 基址（TLS/per-CPU） |
| B-13 | OSTEP 41.5 测量文件局部性 | 覆盖（合并）+ 指路 | FFS 段末补一句：`filefrag -v`（1.13.14 实验三已用）看物理块聚集、`blktrace`+`btt` 看块距离分布（3.13.7）。可复现测量的工具落点已存在，不另起实验小节 |
| B-14 | OSTEP 42.2 fsck 检查逻辑 | 真缺口 | `1.13.5 崩溃一致性` FSCK bullet 后补一段：三张表交叉验证（数据位图 vs inode 指针、inode 位图 vs 目录项、目录连通性）、重复块/坏块、修结构不修语义、ext4 有日志仍留 `e2fsck` 兜底；交叉引用 0.10.11 的五阶段与退出码 |
| B-15 | CSAPP 5.12 load/store 吞吐（含 6.6 memory mountain） | 真缺口 | 两处：`ch05.md` 1.5.10 末补 store buffer/写后读依赖/别名让 load 等 store（7 行，回扣 1.5.11 restrict 的微架构原因，`ld_blocks.store_forward` 标注未实测口径）；`ch06.md` 1.6.14 末补 `mountain.c` 内存山（47 行，程序在 macOS clang `-std=c17 -Werror` 实机编译运行通过，读数标「M1 实跑、未在 x86-64 复测」）。母本为 5.12 与 6.6 两节，两处各 ≤47 行 |

### 统计

- 真缺口：12（B-01、B-02、B-03、B-05、B-06、B-07、B-08、B-09、B-11、B-12、B-14、B-15），全部已补。
- 覆盖/合并：2（B-04 合并于 1.13.5.1 + 1.13.6 项目 8 + 3.13/3.14；B-13 合并于 1.13.14 实验三 + 3.13.7，仅补指路一句）。
- 背景已提：1（B-10，VAX/VMS 定位句已在 1.13.3.2）。
- 淘汰：0（报告 B 节 15 项均不属淘汰；分布式类已在 1.13.12 表另行归类，不在本范围）。

### 增补形态与验证

- 新增 H3 仅 1 个：`ch13.md` `### 磁盘几何与经典调度 {#sec-1.13.5.3}`（编号顺延 1.13.5.1/.2，锚点全书唯一，grep 确认无冲突）；其余增补全部并入现有小节内容末尾，未动任何已有编号与锚点。
- 行数：part1 共 +98 行（ch05 +7、ch06 +47、ch13 +44），23413 → 23511，增幅 +0.42%（上限 +4%）。
- 磁盘调度手算例（FIFO 226 / SSTF 95 / SCAN 100 / C-SCAN 57+65）用 Python 脚本逐算法重放，与正文表一致；`mountain.c` 实机编译运行，输出量级与正文「示意」标注一致（小工作集高原受加法链封顶、stride ≥ 64 理想折损 1/8 等口径见正文）。
- `python3 tools/check_book.py`：pages 113 / total lines 127589 / substantial 103，无问题页（与改前同为 0）。`mdbook build` exit 0，仅既有的 search index 大小 WARN 与 katex 提示，无页面级 WARN 新增。
