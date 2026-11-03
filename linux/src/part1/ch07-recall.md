# 1.7 闭卷回忆卡

这一页不是摘要，而是一组**检索练习**。先只看问题，合上正文，开口说或落笔写；「看着熟」不算会。每张卡答完再展开核对。

建议在学完当天、隔天、第 3 天、第 7 天各做一次。每次只记三种结果：✓ 能完整写出；△ 有关键词但缺条件；× 完全想不起。下一轮只重做 △ 和 ×。本章分两遍写，回忆卡也照两遍分组：A 组要你能讲出一条链，B 组要你能讲出字节与全规则。凡是手算（回忆 5、回忆 10）务必落纸。

## A. 第一遍：链路、加载与动态链接

::: method 回忆 1 · 链接器四步与各自的报错

链接器拿到哪两类输入、产出什么？四步分别叫什么，各对应正文里哪一类错误文本？「编译通过」为什么不能说明程序能链接？

::: sol 答案

输入是可重定位目标文件（`.o`，`ET_REL`）与归档库（`.a`，一组 `.o`）；输出是可执行文件（`ET_EXEC` 或 PIE 的 `ET_DYN`）或共享库（`ET_DYN`）。四步：符号解析（每个未定义符号找到唯一强定义，失败报 `undefined reference to 'foo'`）、合并节（把各处 `.text`/`.data` 拼成输出节）、重定位（按重定位表改写指令与数据里的地址，失败如 `relocation truncated to fit`）、布局（分配虚拟地址、生成程序头、设入口）。编译器只看单个 `.c` 的语法与类型，函数只声明不定义它也不报警；符号是否存在、地址放不放得下，都是链接器的事。
:::
:::

::: method 回忆 2 · 节与段、bss 为什么不占文件

哪个视图给链接器、哪个给加载器？各用哪条命令读？`.bss` 与其他节的差别写在哪一个字段里，为什么 64 MB 的静态数组不会让二进制膨胀？`strip` 删掉了什么、留下了什么？

::: sol 答案

链接器按节（section）工作，加载器按段（segment）工作：一段含一或多个节，按页对齐、按权限合并。`readelf -S` 看节，调试链接错误用它；`readelf -l` 看段，调试加载与权限问题用它。`.bss` 的节类型是 `SHT_NOBITS`，文件里只留一个表项记大小与地址，加载器按 `p_memsz` 大于 `p_filesz` 的差值映射匿名零页，第一次写才触发缺页分配物理页，所以 `static char pool[64 << 20];` 不撑大文件。`strip` 删的是 `.symtab` 与配套字符串表，`.dynsym` 必须保留，否则动态链接器无从解析符号。
:::
:::

::: method 回忆 3 · 强、弱、COMMON 三条规则

给出强符号与弱符号的判定标准，以及冲突时的三条规则。GCC 10 起默认 `-fno-common` 改变了什么？弱符号只有声明没有定义时地址是多少，因此调用前必须做什么？

::: sol 答案

函数与已初始化的全局变量是强符号；未初始化全局变量在传统 C 里是弱符号（`COMMON`），`__attribute__((weak))` 可显式声明。规则：两个强同名 → 报 `multiple definition`；一强多弱 → 取强；多弱 → 取体积最大的那个（`COMMON` 的历史行为），谁赢不可依赖。GCC 10 起默认 `-fno-common`，未初始化全局变量进 `.bss` 并视为强符号，于是两个文件都写 `int counter;` 从静默合并变成链接错误。弱符号没有定义时地址解析为 0，所以要先判空 `if (my_hook)` 再调用，否则跳到 0 地址。
:::
:::

::: method 回忆 4 · 归档扫描四步与两个救火选项

链接器扫描命令行的四步是什么？为什么 `-lfoo -lbar` 与 `-lbar -lfoo` 结果可能不同？循环依赖、需要全部成员、想删未引用代码，各用哪个选项，代价是什么？

::: sol 答案

四步：从左到右扫描；遇到 `.o` 直接加入；遇到 `.a`，反复检查当前未定义符号，抽取能解决它们的成员，直到没有新成员被抽出；扫完仍有未定义符号就报错。已被扫过的归档不会再扫，所以「被依赖者放右边」——`foo` 依赖 `bar` 时 `-lfoo -lbar` 才对，反过来会把 `foo.o` 里的 `bar` 引用留成未定义。循环依赖用 `-Wl,--start-group ... -Wl,--end-group` 强制多轮扫描，代价是更慢；注册表式插件要全量装入用 `--whole-archive`；配合 `-ffunction-sections -fdata-sections` 与 `--gc-sections` 删除未被引用的节。另外 `--as-needed` 是发行版默认，只保留真正用到的依赖，插件靠 `DT_NEEDED` 自动初始化时可能要 `--no-as-needed`。
:::
:::

::: method 回忆 5 · 一次 PC 相对重定位的手算

写出 `ELF64_Rela` 的三个字段与记号 `S`、`A`、`P`、`L` 的含义。`R_X86_64_PC32` 与 `R_X86_64_PLT32` 的计算式各是什么？为什么加数常常是 `-4`？`R_X86_64_32S` 什么时候报错？

::: sol 答案

三个字段是 `r_offset`（要改写的位置）、`r_info`（高 32 位符号下标、低 32 位类型）、`r_addend`（加数）。`S` 是符号最终地址，`P` 是被改写字段的地址，`A` 是加数，`L` 是 PLT 桩地址。`R_X86_64_PC32` 是 `S + A - P`，`R_X86_64_PLT32` 是 `L + A - P`。`call rel32` 的位移字段紧跟 1 字节操作码，而 CPU 计算目标时用的是「下一条指令」地址即 `P + 4`，所以条目里预先写 `A = -4` 来补偿；正文 1.7.4 的 x86-64 例子算出 `rel32 = -0x115`，指令字节变成 `e8 eb fe ff ff`。`R_X86_64_32S` 要检查符号扩展，地址超过 32 位可表示范围时报 `relocation truncated to fit`。判据：读重定位先看 `A`，不要自己猜减几。
:::
:::

::: method 回忆 6 · 从 execve 到 _start

内核加载 ELF 的七步里，哪几步只做映射、哪一步把权力交给别人？`PT_INTERP` 是谁读的？入口为什么不是 `main`？`/proc/self/maps` 里同一个文件被映射成几段、最后一段为什么和前一页共用 `Offset`？怎么判断一个二进制是不是 PIE？

::: sol 答案

`execve` 走到 `load_elf_binary`：读 ELF 头查魔数与机器类型 → 读程序头找 `PT_INTERP` 并把动态链接器映射进来 → 对每个 `PT_LOAD` 用 `mmap` 建映射并按 `R`/`W`/`X` 设权限、文件尾部不足一页清零 → `.bss` 那段按匿名零页映射 → 把 `argv`、`envp`、辅助向量复制到新栈顶 → 设入口与栈指针（有解释器时入口是 `ld.so` 的）→ 返回用户态。`PT_INTERP` 由内核读出并用来映射解释器，之后解析依赖、填 GOT、跑构造函数都是 `ld.so` 的事，最后才到 `_start`、再到 `main`。`/proc/self/maps` 里同一个可执行文件按段映射成 `r--`、`r-x`、`r--`、`rw-` 多个区间，最后一个 `rw-` 同时装 `.data` 与 `.bss`，而 `.bss` 在文件里没有对应偏移，所以 `Offset` 与前一页相同、长度只由内存大小决定。判断 PIE 看 `readelf -h` 的 `Type`：`DYN` 是 PIE（或共享库），基址随 ASLR 变；`EXEC` 是固定地址。
:::
:::

::: method 回忆 7 · 搜索顺序、懒绑定与 dlopen 的三个标志

按顺序说出 `ld.so` 找库的五步。`DT_RPATH` 与 `DT_RUNPATH` 的关键差别是什么？首次调用与后续调用各走哪条路径？`-z now` 与 `-z relro` 各改什么？`RTLD_NOW`/`RTLD_LAZY`、`RTLD_LOCAL`/`RTLD_GLOBAL` 分别决定什么，`dlclose` 能保证卸载吗？

::: sol 答案

五步：有 `DT_RPATH` 且没有 `DT_RUNPATH` 时先搜 `DT_RPATH`；然后 `LD_LIBRARY_PATH`（安全执行模式下忽略）；然后 `DT_RUNPATH`；然后 `/etc/ld.so.cache`（`ldconfig` 生成）；最后默认目录 `/lib`、`/usr/lib` 及 `lib64` 变体。`RPATH` 会作用于依赖的依赖，`RUNPATH` 只作用于直接依赖，所以 `-Wl,-rpath,'$ORIGIN/../lib'` 对新链接器的间接依赖不生效。首次调用时 `jmp *GOT[n]` 落到 PLT 里的 `push index; jmp plt0`，由 `ld.so` 解析出真实地址并改写 `GOT[n]` 再跳过去；后续调用直接跳到目标，只剩一次间接跳转。`-z now`（`BIND_NOW`）把所有解析挪到加载时，牺牲启动时间换运行期确定性与更小的劫持面；`-z relro` 让 GOT 中不需要延迟绑定的部分在重定位后变只读，两者合用是 full RELRO。`RTLD_NOW` 在加载时解析全部未定义符号、错误立刻暴露，`RTLD_LAZY` 推迟到调用；`RTLD_LOCAL` 不让库的符号进入全局命名空间、避免插件互相覆盖，`RTLD_GLOBAL` 相反；`dlclose` 只减引用计数，不保证卸载。
:::
:::

## B. 第二遍：ELF 字段、符号规则与打桩

::: method 回忆 8 · 五种结构的大小与两条读表线

ELF64 的 Ehdr、Shdr、Sym、Rela、Phdr 各多少字节？`e_type`、`e_machine` 的取值怎么记？读符号名和读重定位符号分别要靠哪两个字段？

::: sol 答案

Ehdr 64、Shdr 64、Sym 24、Rela 24、Phdr 56。`e_type`：1 是 REL（`.o`）、2 是 EXEC、3 是 DYN（共享库或 PIE）、4 是 CORE；`e_machine`：62 是 x86-64、183 是 AArch64、243 是 RISC-V。符号项里没有名字字符串，`st_name` 是偏移，字符串表由该符号表节头的 `sh_link` 指出（重定位节同理：`sh_link` 指向符号表、`sh_info` 指向被修改的节）。Rela 的符号与类型都挤在 `r_info` 里：高 32 位是符号下标、低 32 位是类型；REL 格式没有 `r_addend`，加数在指令里。程序头里加载器只关心段：`p_type`（LOAD、DYNAMIC、INTERP、PHDR、TLS、GNU_STACK、GNU_RELRO）、`p_flags`（X、W、R）、`p_offset`、`p_vaddr`、`p_filesz`、`p_memsz`、`p_align`。
:::
:::

::: method 回忆 9 · 符号表四字段与可见性

`readelf -s` 一行的 Type、Bind、Ndx、Vis 各决定什么？`UND`、`ABS`、`COM`、`65521`、`65522` 分别是什么？`HIDDEN` 的符号能被外部库引用吗？

::: sol 答案

`Type` 是 `FUNC`/`OBJECT`/`NOTYPE`/`SECTION`/`FILE`（`st_info` 低 4 位：1 OBJECT、2 FUNC、3 SECTION、4 FILE、5 COMMON、6 TLS）；`Bind` 是 `LOCAL`（`static`）/`GLOBAL`/`WEAK`（高 4 位 0/1/2），决定它是否参与跨文件解析；`Ndx` 是所在节下标，`UND` 表示未定义、`ABS` 绝对值、`COM` 表示 common，数值上 `0xfff1` 即 65521 是 `SHN_ABS`、`0xfff2` 即 65522 是 `SHN_COMMON`；`Vis` 是 `DEFAULT`/`HIDDEN`/`PROTECTED`，`HIDDEN` 不进入动态符号表、不能被外部库引用。可见性配合 `-fvisibility=hidden` 只导出显式标记的符号，能减少 PLT/GOT 项和符号冲突。
:::
:::

::: method 回忆 10 · 重定位类型表与四阶段分工

`R_X86_64_GOTPCREL`、`R_X86_64_GLOB_DAT`、`R_X86_64_JUMP_SLOT`、`R_X86_64_RELATIVE`、`R_X86_64_COPY` 各自用在哪、算式是什么？静态链接、加载时、首次调用分别由谁处理哪些类型？

::: sol 答案

`GOTPCREL` 是 `G + GOT + A - P`，用于 PIC 代码经 GOT 取外部符号地址；`GLOB_DAT` 直接写 `S`，填 GOT 里的数据符号；`JUMP_SLOT` 也写 `S`，填 GOT 里的函数地址，是延迟绑定的那一项；`RELATIVE` 是 `B + A`，处理 PIE 内部指向自己映像的绝对地址（`B` 是加载基址）；`COPY` 把共享库数据对象的内容复制进可执行文件，用于可执行文件引用库里的数据对象。分工：编译与汇编阶段由汇编器留占位符与重定位项；静态链接阶段由 `ld` 或 `lld` 处理 `PC32`、`PLT32`、`64`；`execve` 之后、`main` 之前由 `ld.so` 处理 `RELATIVE`、`GLOB_DAT`、`COPY`；第一次经过 PLT 时由 `ld.so` 处理 `JUMP_SLOT`。`-z now` 或 `LD_BIND_NOW=1` 把 `JUMP_SLOT` 全部提前到加载时。
:::
:::

::: method 回忆 11 · elfdump 程序在做什么

不链 libelf 的程序靠哪几步把节名和符号名读出来？`.o` 里 `st_value` 是什么含义？`.rela.text` 的大小为什么是 48 字节？这个程序的解析边界在哪（哪些情况它不管）？

::: sol 答案

四步：读前 64 字节当 `Ehdr`，先验魔数 `7f 45 4c 46`；用 `e_shoff` 定位节头表、`e_shnum` 定项数，`e_shstrndx` 那一节的 `sh_offset` 就是节名字符串表，节名 = 表基址 + `sh_name`；遇到 `sh_type` 为 SYMTAB（2）或 DYNSYM（11）的节，按 `sizeof(Sym)` 切分数组，名字再用 `sh_link` 指向的字符串表解出；靠 `st_info` 的高低 4 位拆出绑定与类型。目标文件里 `st_value` 是节内偏移而不是虚拟地址——正文那个 x86-64 的 `demo.o` 里 `add` 是 0、`main` 是 0x10，`.text` 只有 26 字节。`.rela.text` 是 48 字节，因为一条 Rela 是 24 字节、正好两条（一次 `call`、一次 RIP 相对访问）。边界：它只处理小端 ELF64，不处理大端与 ELF32；真实工具还要处理压缩节、`SHT_GROUP`、`.gnu.hash` 以及 `e_shnum=0` 时改用第 0 节的 `sh_size` 这类扩展。
:::
:::

::: method 回忆 12 · LD_PRELOAD 与 --wrap 的分工

三种打桩时机各自的影响范围是什么？钩子里为什么必须 `dlsym(RTLD_NEXT, ...)` 而不是 `RTLD_DEFAULT`？为什么要设防递归标志、析构函数里为什么不能用 `printf`？`--wrap` 改不到哪两处？

::: sol 答案

编译期（`#define malloc my_malloc`、函数指针）只管自己的源码；链接期 `-Wl,--wrap=symbol` 只影响当前链接单元里对该符号的未定义引用，把引用改写成 `__wrap_symbol`、并提供 `__real_symbol` 指向原实现；加载期 `LD_PRELOAD` 让指定库先于其他库加载，同名符号优先用它，作用到该进程及其动态依赖。`RTLD_DEFAULT` 从头按普通顺序找，会找到钩子自己造成无限递归；`RTLD_NEXT` 按「当前库之后」的搜索顺序找，才拿到 libc 的实现。`dlsym` 内部可能调 `malloc`，所以首次解析要设 `resolving` 标志；析构函数里 `snprintf`/`printf` 可能分配内存，要用 `write` 直接写。`--wrap` 改不到两处：共享库内部已经绑定好的调用，以及同文件内被内联（或被优化掉）的调用。
:::
:::

::: method 回忆 13 · PIC、PIE 与四组选项

PIC 的核心约束是什么？编译器用哪两种手法满足它？`-fPIC` 与 `-fPIE`、`-pie` 与 `-no-pie` 分别决定什么？把四组选项与产物类型、基址、用途对应出来，再说 PIE 之外还有哪四项加固。

::: sol 答案

核心约束是代码段里不出现需要链接期确定的绝对地址，这样同一份 `.text` 可以映射到任意基址并被多个进程共享。两种手法：模块内的函数与静态变量用 PC 相对寻址（`lea sym(%rip), %reg`），跨模块的全局变量与外部函数地址放 `.got`、代码只引用 GOT 表项相对自己的偏移。`-fPIC` 生成共享库用的 PIC、`-fPIE` 生成可执行文件用的 PIE，两者都位置无关，但 PIE 可以假定「本可执行文件不会被别的模块插入同名符号」从而多做一些优化；`-pie` 产出 `ET_DYN`、`-no-pie` 产出 `ET_EXEC`。四组：`-fno-pic -no-pie` → `ET_EXEC`、固定 `0x400000`、老式二进制与内核模块；`-fPIE -pie` → `ET_DYN`、随机基址、现代发行版默认；`-fPIC -shared` → `ET_DYN`、共享库；`-fPIC -pie` → `ET_DYN`、少见但合法。PIE 之外的四项：NX（靠 `PT_GNU_STACK` 标记栈不可执行）、Stack Canary（`-fstack-protector-strong`）、RELRO 与 `-z now`（GOT 只读）、FORTIFY（`-D_FORTIFY_SOURCE=2`）。
:::
:::

::: method 回忆 14 · Rust 与链接：同一套 ELF，不同的名字

Rust 的产物在链接器与 `readelf` 眼里和 C 有什么不同？导出 C ABI 要写什么？`--crate-type staticlib` 与 `cdylib` 各给谁用？为什么 `nm` 里找不到符号、`nm -C` 能做什么？跨 `extern "C"` 边界的 panic 会怎样？

::: sol 答案

产物就是普通 ELF，链接器、`readelf`、`LD_PRELOAD` 照常工作；差别在符号命名与代码生成：Rust 默认做 v0 mangling（`_RNv...`），C 的符号名与函数名相同。导出 C ABI 要 `#[no_mangle] pub extern "C"`，结构体要给 `#[repr(C)]`（Rust 默认可重排字段）；`staticlib` 产出含 Rust 运行时的 `.a` 给 C 侧静态链、`cdylib` 产出 `.so` 给动态加载。链接期优化用 `-C lto=fat`（C 是 `-flto`），未使用代码默认按可达性删除（C 靠 `--gc-sections`），要保留用 `#[used]`；可见性默认隐藏、`#[no_mangle]` 才导出（C 用 `-fvisibility=hidden`）。`nm` 找不到是因为符号被 mangle 或被 LTO 删掉，`nm -C` 能还原 v0 mangling，`perf` 也支持 demangle；把数据放进指定节用 `#[used]` 加 `#[link_section = ".rodata.mydata"]`，内核模块、eBPF、固件常用。panic 默认展开，跨 `extern "C"` 边界会 abort，需要 `-C panic=abort` 或在边界内 `catch_unwind`；发布库建议只导出 `#[no_mangle]` 的薄封装。
:::
:::
