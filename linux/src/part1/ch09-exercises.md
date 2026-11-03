# 1.9 习题集

三组分层：**A 组概念判断**考「会不会读、会不会判」，对应 1.9.1–1.9.7 的模型；**B 组诊断推理**给现象让你判「泄漏、越界、UAF、TLB、COW」中的哪一类，两遍的知识都要用；**C 组动手实验**考「会不会跑、会不会读输出」，四个实验都能在 Ubuntu 24.04 上**免 `sudo`** 完成。每题末尾给出**判据**：做到哪一步算过，做不到时最可能是哪一步漏了。先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述完整因果，B 组要求写「现象 → 机制 → 证据 → 修法」四段，C 组要求贴出自己机器的真实输出。
2. B 组最常见的错法是跳过分类直接改代码：先判「是地址不在 VMA、页不在内存，还是释放点错了」，再谈工具。
3. 卡住了回对应小节的「即时自测」或[回忆卡](ch09-recall.md)的同号卡，不要直接看答案。
4. C 组的环境是 Ubuntu 24.04.5（aarch64、内核 7.0.0-38、页大小 4096、glibc 2.39、GCC 13.3.0、`sudo` 不可用、`perf_event_paranoid=4`）。标注「VM 实测」的是这台机器上跑出来的；你自己的机器若页大小是 16 KiB（Apple Silicon），涉及页边界的数字会差 4 倍，按 `sysconf(_SC_PAGESIZE)` 报，不要抄 4096。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch09-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.9-A1 · 三句关于虚拟内存的判断 {#ex-1.9-A1}

逐句判断并改正：①「虚拟内存就是内存不够时用磁盘顶替，所以关掉 swap 就没有虚拟内存了」；②「`malloc` 返回的内存一定是零」；③「进程的 `VSZ` 有 10 GB，肯定是内存泄漏」。

::: sol 解答

① 错。虚拟内存是地址翻译、隔离与按需分页；swap 只是页回收的一个去处。没有 swap，内核仍能做 COW、文件映射、按需分配，只是内存压力下只能回收干净文件页或触发 OOM。② 错。只有 `calloc` 保证清零；`malloc` 返回未初始化内存，可能含旧数据（安全敏感代码要用 `calloc` 或自己 `memset`）。③ 错。`VSZ`/`VmSize` 是虚拟大小，包含只保留未提交的映射与大块 `mmap`；判断泄漏看 `Rss`/`Pss` 是否随请求持续上涨，并用 `valgrind --leak-check` 或 heaptrack 复核。

**判据**：三句都能给出「错在哪 + 正确说法」，且第 ③ 句能说出「看 `Rss`/`Pss` 而不是 `VSZ`」。只判对错、说不出替代指标，算未达标。

:::
:::

::: ex 例 1.9-A2 · 四个缺页场景各是哪一类 {#ex-1.9-A2}

① 第一次写一块刚 `mmap` 的私有匿名内存；② 读一个已经 `read` 过一遍、现在还在 page cache 里的文件页；③ 解引用一个从未映射过的空指针；④ 访问一个被换出到 swap 的匿名页。分别属于次缺页、主缺页还是无效缺页？处理时要不要读存储？

::: sol 解答

① 次缺页：匿名页首次按需分配，内核分配物理页并清零，不读存储；② 次缺页：页已在 page cache，建立 PTE 即可，不读存储；③ 无效缺页：地址不在任何 VMA，内核发 `SIGSEGV`，没有「修复」；④ 主缺页：页在 swap，需要读回，毫秒级。注意 ① 虽然叫 minor，仍可能分配、清零物理页，不能理解成「只填 PTE」；② 也可能因为页表层级未建而分配页表页。

**判据**：四个分类全对，且能指出「minor 仍可能分配/清零」「major 必须读存储」「invalid 只发信号」。把 ① 说成「只填 PTE」算未达标。

:::
:::

::: ex 例 1.9-A3 · 页表项的四个位 {#ex-1.9-A3}

`P=0` 时页表项还能用吗？`A` 位与 `D` 位各帮内核做什么？`PS` 位在哪一级表项里表示大页，为什么普通 4 KiB 叶 PTE 的 bit 7 不是 `PS`？`NX` 位依赖什么才生效？

::: sol 解答

`P=0` 时其余位可由内核软件解释，例如 swap 槽号或文件位置；用户态只看到「访问会触发缺页」。`A`（accessed）记录最近被访问，页面回收扫描时用它判断冷热，清掉后下一轮再看；`D`（dirty）记录被写过，换出/回写时决定是否要写磁盘。`PS` 在 PD 或 PDPT 项里置 1，表示提前终止为 2 MiB 或 1 GiB 大页；普通 4 KiB 叶 PTE 的 bit 7 是 PAT（页属性表索引），不是 `PS`。`NX` 需要 `EFER.NXE` 打开才生效，否则该位保留。`RW`、`US` 分别控制写权限与用户态可访问。

**判据**：能说出 `P=0` 的软件复用、`A`/`D` 与回收/回写的关系、`PS` 在上级表项、`NX` 依赖 `EFER.NXE`。把 `PS` 说成「每个 PTE 都有」算未达标。

:::
:::

::: ex 例 1.9-A4 · mmap 的四种组合 {#ex-1.9-A4}

`MAP_PRIVATE`/`MAP_SHARED` 与「文件/匿名」交叉，写时分别发生什么？`MAP_PRIVATE` 映射文件后修改 `p[0]`，文件会变吗？`MAP_SHARED` 呢？要保证落盘还需要什么？

::: sol 解答

私有文件映射：写触发 COW，修改只对当前映射可见，不写回文件；共享文件映射：写 page cache，其他映射同一文件的进程可见，内核在合适时机回写；私有匿名：COW 零页，`malloc` 的大块分配走这里；共享匿名：父子进程共享，`fork` 后仍可见。`MAP_PRIVATE` 下改 `p[0]` 文件不变；`MAP_SHARED` 下文件会变（通过 page cache），但要保证落盘还需 `msync(MS_SYNC)` 或 `fsync`，`msync` 本身只保证写到设备缓存的情况也要分清。`MAP_SHARED` + 只读 fd + `PROT_WRITE` 会得到 `EACCES`。

**判据**：四种组合的写时行为全对，且能区分「文件可见」与「落盘」两件事。把 `MAP_PRIVATE` 说成「完全不占物理页」算未达标（它仍要建页表、按需分配，只是延迟复制）。

:::
:::

::: ex 例 1.9-A5 · 多级页表、TLB 与 shootdown {#ex-1.9-A5}

48 位地址、4 KiB 页，单级页表要多大？多级页表省在哪？TLB 64 项配 4 KiB 与 2 MiB 各覆盖多少？为什么 `munmap` 在多核上不是免费的本地操作？

::: sol 解答

单级页表有 $2^{48}/2^{12}=2^{36}$ 项，每项 8 B，共 $2^{39}$ B = 512 GiB，而且每个进程一份。多级页表把大表拆成四级树，只给已映射的区间分配下级表；一个只映射少量页的进程只花几个页表页。TLB 覆盖 = 项数 × 页大小：64 × 4 KiB = 256 KiB；64 × 2 MiB = 128 MiB。改页表后，其他核 TLB 里的旧翻译必须失效：单核 `invlpg`，多核要发 IPI 让所有可能缓存了该翻译的核执行失效，这就是 TLB shootdown；`munmap`、`mprotect`、页迁移都要付这笔跨核同步成本。PCID 只省上下文切换时的整体冲刷，不省同一地址空间内的页表修改。

**判据**：512 GiB、256 KiB/128 MiB 两个数算对，且能说出「改页表要跨核失效」。只说「TLB 是缓存」而说不出 shootdown，算未达标。

:::
:::

::: ex 例 1.9-A6 · 分配器的边界标记与归还 {#ex-1.9-A6}

为什么空闲块要同时有头部和脚部？首次适配怎么分裂？`free` 之后内存为什么通常不还给操作系统？glibc 的 128 KiB 阈值在这里起什么作用？

::: sol 解答

头部记录「块大小 + 是否已分配」，脚部在块尾复制一份大小，目的是**向前合并**：释放当前块时，`p - prev_size` 就能找到前一个块的头，判断它是否空闲；没有脚部就只能从头扫描。首次适配从堆头线性扫描，找到第一个足够大的空闲块；若剩余空间 ≥ 最小块（常见 32 B），分裂成「已分配 + 新空闲」，否则整块给出。`free` 通常只把块标记为空闲并尝试与前后合并，内存仍留在 arena/tcache 里供复用，所以 RSS 不一定下降；只有 `mmap` 的大块在 `free` 时 `munmap`，或 `malloc_trim` 收缩堆顶，才可能还给内核。glibc 的 `mmap_threshold` 默认 128 KiB（动态调整）：大于它的请求直接 `mmap`，`free` 时直接 `munmap`；小于它的走堆/arena，`free` 后留在空闲链表。

**判据**：能画出「头 | payload | 脚」并解释脚部用于向前合并；能说出分裂条件与 128 KiB 的两条路径。把「`free` 一定归还 OS」当答案算未达标。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.9-B1 · RSS 一直涨，是泄漏还是碎片 {#ex-1.9-B1}

一个长跑服务每小时处理百万请求，`VmRSS` 从 200 MiB 涨到 1.2 GiB 后被 OOM 杀；`VmSize` 基本不变。列出三种可能，并给出能在没有 `sudo`、没有 `perf` 的机器上区分它们的证据。

::: sol 解答

三种可能：① 真泄漏——某条路径 `malloc` 后没有 `free`，或容器/回调持有对象；② 分配器碎片——小块分配与释放交错，空闲总量够但没有连续块，arena/tcache 也不归还；③ 缓存型增长——应用自己做了无上限缓存，或 `MADV_FREE` 的页尚未被回收。证据顺序：先看 `/proc/$pid/smaps_rollup` 的 `Rss`、`Pss`、`Private_Dirty` 与 `AnonHugePages`，确认涨的是匿名私有页还是文件页；再对可疑路径做 `valgrind --leak-check=full --show-leak-kinds=definite`（慢，但不需要 root），或在测试环境用 `MALLOC_ARENA_MAX=1` 与 `malloc_trim(0)` 做 A/B：如果 `malloc_trim` 后 RSS 明显回落，更像碎片/缓存而不是真泄漏；如果 `definitely lost` 随请求数线性增长，就是泄漏。还可以读 `/proc/$pid/status` 的 `VmData` 与 `VmRSS`，对比「堆虚拟大小」与「驻留」的走势。

**判据**：三种可能都写到，且给出至少两条可执行的证据（`smaps_rollup`、Valgrind、`malloc_trim` A/B）。只写「用 Valgrind 查泄漏」算半达标；能区分「泄漏」与「碎片」才算过。

:::
:::

::: ex 例 1.9-B2 · 0x10 处的 SIGSEGV {#ex-1.9-B2}

服务偶发 `SIGSEGV`，`si_addr=0x10`。同事说「肯定是空指针」。列出至少三种可能，并说明怎么用 ASan 与 `/proc/$pid/maps` 缩小范围。

::: sol 解答

`0x10` 可能是：① 空指针加偏移——`struct` 的某个字段在偏移 16，基址是 NULL；② UAF——对象已 `free`，指针指向的块被复用或 `munmap`，字段偏移仍在；③ 越界/野指针——指针被写坏，落在低地址；④ 栈溢出或对齐错误也可能给出低地址。区分：先看 core/`dmesg` 的 `si_code`（`SEGV_MAPERR` 是地址未映射，`SEGV_ACCERR` 是权限不符），再用 `/proc/$pid/maps` 确认 `0x10` 不在任何 VMA；如果是 UAF，ASan 会在 `free` 后的第一次读写就报 `heap-use-after-free` 并给出分配/释放栈。没有 core 时，用 `-fsanitize=address -g -O1` 重编复现，或在测试环境打开 `MALLOC_CHECK_=3` 做快速筛查（它抓不到所有 UAF，只作辅助）。

**判据**：至少给出「空指针+偏移」「UAF」「野指针」三种，且能说出 `si_code` 的 `MAPERR`/`ACCERR` 区别。把 `0x10` 直接判成空指针算未达标。

:::
:::

::: ex 例 1.9-B3 · 文件被截断后的 SIGBUS {#ex-1.9-B3}

进程 `mmap` 了一个日志文件并长期读；另一个进程把文件 `truncate` 到更短，读映射的进程收到 `SIGBUS`。解释为什么不是 `SIGSEGV`，以及两条修法。

::: sol 解答

`mmap` 建立的是「文件页 ↔ 地址区间」的映射；映射本身还在，VMA 有效，所以不是「地址不在映射内」的 `SIGSEGV`。但被访问的页已经超出文件当前 EOF，底层没有数据可填，内核只能发 `SIGBUS`（「映射存在但数据不可用」）。修法：① 不要对可能被截断的文件做长期映射，改用 `read`/`pread` 并处理短读；② 如果必须映射，约定文件只追加不截断，或在截断方与读方之间加锁/版本号，读方在每次访问前用 `fstat` 检查 `st_size`，并对 `SIGBUS` 做捕获与重映射。`MAP_PRIVATE` 也不能幸免：COW 只改变写语义，不改变「页必须来自文件」这一点。

**判据**：能说出「VMA 还在，所以不是 SEGV；页超出 EOF，所以是 BUS」，并给出至少一条可落地的修法。把 `SIGBUS` 说成「访问了未映射地址」算未达标。

:::
:::

::: ex 例 1.9-B4 · free 时才崩的 1 字节越界 {#ex-1.9-B4}

一个循环写 `buf[n] = 0`，`buf = malloc(n)`；程序运行很久都正常，直到某次 `free(buf)` 报 `free(): invalid next size`。解释崩溃点为什么滞后，并给出定位步骤。

::: sol 解答

`malloc(n)` 实际给的块通常比 `n` 大（对齐 + header），越界 1 字节可能落在 padding 或下一块的 `prev_size`/`size` 字段里，暂时不影响数据；直到 `free` 读取下一块的 header、发现大小不合理，才由 glibc 的 `malloc_printerr` 报错并 `abort`。定位：用 `-fsanitize=address -g -O1` 重编，ASan 会在 `buf[n] = 0` 那一行直接报 `heap-buffer-overflow`；如果不能用 ASan，用 Valgrind 的 memcheck（慢但不用重编译），或 `MALLOC_CHECK_=3` 先复现。注意 `malloc_usable_size(buf)` 返回的是可用大小，不是你可以合法写入的承诺；不要用它来「证明」越界没问题。

**判据**：能解释「越界落在元数据/padding，`free` 才校验」这一滞后机制，并给出 ASan 或 Valgrind 的具体编译/运行命令。只说「数组越界了」算未达标。

:::
:::

::: ex 例 1.9-B5 · 大页加了却没变快 {#ex-1.9-B5}

一个随机访问 1 GiB 数组的程序很慢，`cachegrind` 显示 `DLmr` 不算高；你加了 `madvise(MADV_HUGEPAGE)`，时间没变。`/sys/kernel/mm/transparent_hugepage/enabled` 显示 `always [madvise] never`。下一步查什么？如果 `AnonHugePages` 是 0，说明什么？

::: sol 解答

先怀疑地址翻译而不是数据缓存：`DLmr` 不高而随机访问大数组慢，可能是 TLB 覆盖不够（4 KiB 页下 64 项只覆盖 256 KiB，2048 项也只覆盖 8 MiB）。`enabled` 是 `madvise`，意味着只有显式 `madvise(MADV_HUGEPAGE)` 的区间才可能用大页；`madvise` 返回 0 只表示调用成功，不表示大页生效。下一步读 `/proc/self/smaps_rollup` 或对应 VMA 的 `smaps`：`AnonHugePages` 为 0 说明一段 2 MiB 页也没拿到，常见原因是映射未按 2 MiB 对齐、长度不够、内存碎片/`defrag` 策略不允许，或触碰方式没有促成合并。此时「时间没变」是合理的，不能反推「TLB 不是瓶颈」。可再确认 `/sys/kernel/mm/transparent_hugepage/defrag`，并检查映射的起止地址是否 2 MiB 对齐。

**判据**：能说出「`madvise` 返回 0 ≠ 生效」并读 `AnonHugePages`；能列出至少两个导致 0 的原因（对齐、碎片/defrag）。把「没变快」直接当成「TLB 无关」算未达标。

:::
:::

::: ex 例 1.9-B6 · fork 之后次缺页暴涨 {#ex-1.9-B6}

一个 Redis 风格的进程用 `fork` 做快照：父进程有 8 GiB 数据，子进程刚起来时 RSS 很小，随后子进程遍历字典，父进程继续写，系统出现大量次缺页与内存紧张。解释机制，并说明 `Rss` 为什么会「重复计算」、`Pss` 为什么更可信。

::: sol 解答

`fork` 后父子共享同一批物理页，页表被复制但页标记为只读；任何一方写某页就触发保护故障，内核复制该页并恢复写权限，这就是写时复制（COW）。子进程遍历字典只读时不该复制，但父进程继续写会不断触发 COW；每次 COW 都是一次次缺页（可能还要分配/清零），所以 minor faults 暴涨。`Rss` 按进程统计常驻页，共享页在父子两边各算一次，于是两个进程的 `Rss` 相加会大于实际物理占用；`Pss` 把每个共享页按共享进程数均摊，父子各算一半，合计接近真实值。快照期间的内存开销取决于「被改写的页数」，不是整个数据集；减少 fork 前的大内存、用 `posix_spawn`/`vfork`（在合适场景）、或把快照做成增量，都能降低这笔成本。

**判据**：能讲清 COW 的「读共享、写复制」，并解释 `Rss` 重复计数与 `Pss` 均摊。把「fork 会立刻复制 8 GiB」当答案算未达标。

:::
:::

## C 组 · 动手实验

::: ex 例 1.9-C1 · 读自己进程的地址空间 {#ex-1.9-C1}

不用 `sudo`，报出你这台机器的页大小，并从一个真实进程的 `maps` 与 `smaps_rollup` 里指出：代码段、堆、栈、共享库各一行；`Rss` 与 `Pss` 各是多少。字段拿不到时如实记录。

::: sol C1 核对

```bash
getconf PAGE_SIZE
getconf PAGESIZE
cat /proc/self/maps | sed -n '1,8p'
cat /proc/self/smaps_rollup | grep -E -e Rss -e Pss -e AnonHugePages -e Swap
cat /proc/self/status | grep -E -e VmSize -e VmRSS
```

读法：`maps` 每行是「起始-结束 权限 偏移 设备 inode 路径」。同一个可执行文件通常有 4–5 段：`r--p`（ELF 头/只读数据）、`r-xp`（代码）、`r--p`（只读常量）、`rw-p`（数据/BSS）；`[heap]` 是 `brk` 区，`[stack]` 是主线程栈，`[vdso]`/`[vvar]` 是内核映射的只读页，大块 `---p` 是 `PROT_NONE` 的 guard page。`smaps_rollup` 的 `Rss` 是驻留，`Pss` 是按共享份额折算；`VmSize` 是虚拟大小。VM 实测（Ubuntu 24.04.5、aarch64、内核 7.0.0-38）：`getconf PAGE_SIZE` 与 `getconf PAGESIZE` 都给 4096；`cat` 的 `smaps_rollup` 除 `Rss`、`Pss`、`AnonHugePages`、`Swap` 外，还有 `Pss_Dirty`、`Pss_Anon`、`Pss_File`、`Pss_Shmem`、`SwapPss` 等字段——**不要按行号读，按 key 读**。

需要 `sudo` 的替代：读 `/proc/$pid/pagemap` 的 PFN 需要 `CAP_SYS_ADMIN`，本机跳过；`perf` 的硬件事件被 `perf_event_paranoid=4` 挡住，改用 `/usr/bin/time -v` 与 `smaps_rollup`。本实验全部免特权。

**判据**：报出自己机器的真实页大小；能从 `maps` 里指出至少三类区间；能说出 `Rss` 与 `Pss` 的差别。若把 `VmSize` 当内存用量，或把示例里的 4096 当所有机器的页大小，算未达标。

:::
:::

::: ex 例 1.9-C2 · 64 MiB 与 100 KiB 各走哪条路 {#ex-1.9-C2}

写一个最小程序：`malloc(64 MiB)` 并逐页触碰，再 `malloc(100 KiB)` 并触碰；用 `strace -e trace=brk,mmap` 观察两次分配各走 `mmap` 还是 `brk`。再释放 64 MiB 的那块，看是否出现 `munmap`。

::: sol C2 核对

```c
/* mpath.c：cc -O0 -g mpath.c -o mpath */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(void)
{
    size_t big = 64u << 20, small = 100u << 10;
    char *a = malloc(big);
    if (!a) return 1;
    for (size_t i = 0; i < big; i += 4096) a[i] = 1;   /* 逐页触碰 */
    char *b = malloc(small);
    if (!b) return 1;
    for (size_t i = 0; i < small; i += 4096) b[i] = 2;
    printf("big=%p small=%p\n", (void *)a, (void *)b);
    free(a);
    free(b);
    return 0;
}
```

```bash
cc -O0 -g mpath.c -o mpath
strace -f -e trace=brk,mmap,munmap ./mpath 2>&1 | grep -E -e brk -e mmap -e munmap
```

预期形状：64 MiB 那次出现一条约 64 MiB 的 `mmap(NULL, 67112960, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0)`（glibc 会多算一页左右的头），100 KiB 那次通常只让 `brk` 增长；`free(a)` 后出现对应的 `munmap`，`free(b)` 后通常没有。VM 实测：`brk(NULL)` 后 `brk(0x... + 0x21000)`（132 KiB 左右）承载 100 KiB 的小块，64 MiB 那次是 `mmap(..., 67112960, ...)`。地址、顺序与阈值随 glibc 版本、分配历史变，**判据是「大块 mmap、小块 brk」这条分工，不是具体地址**。

**判据**：能在自己的 `strace` 输出里指认「哪一条对应 64 MiB、哪一条对应 100 KiB」，并解释 128 KiB 阈值；能指出 `free` 大块出现 `munmap`、小块通常不出现。只贴输出不做对应，算未达标。

:::
:::

::: ex 例 1.9-C3 · 在 EOF 之后撞一次 SIGBUS {#ex-1.9-C3}

编译运行 1.9.12 的 `mapfile`（或自己写一个等价程序），对一个已知长度的文件：打印 `len`、首页/末字节、`body` 页边界，故意访问 `p[body]` 并捕获 `SIGBUS`，再用 `mincore` 报告驻留页数。说明为什么 `p[len]` 不崩而 `p[body]` 崩。

::: sol C3 核对

```bash
# 先造一个长度已知的文件；/etc/hostname 也行，但长度随机器变
printf 'hello\n' > /tmp/maptest.txt
wc -c /tmp/maptest.txt
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 mapfile.c -o mapfile
./mapfile /tmp/maptest.txt
```

关键代码（与 1.9.12 同形）：`ps = sysconf(_SC_PAGESIZE)`；`body = ceil(len/ps)*ps`；`maplen = body + ps`；`p = mmap(NULL, maplen, PROT_READ, MAP_PRIVATE, fd, 0)`；访问 `p[body]`，用 `sigsetjmp/siglongjmp` 捕获 `SIGBUS`/`SIGSEGV`；`mincore(p, len, vec)` 后数 `vec[i] & 1`。`p[len]` 在文件最后一页内，尾部由内核零填充，读到 0；`p[body]` 是第一整页都在 EOF 之后的页，映射存在但没有文件数据，所以 `SIGBUS`。VM 实测（aarch64、页 4096、`/etc/hostname` 21 字节）：`len=21 p[0]=106 maplen=8192`，`SIGBUS/SIGSEGV caught at p[4096]`，`mincore=0 pages=1 resident=1`。注意 1.9.12 正文写的是 13 字节，那是另一台机器；长度与首末字符随文件变，**只有「边界 = 页大小」这条不变**。

**判据**：能报出自己机器的 `ps` 与 `body`，并让 `caught at` 的地址等于 `ps`（4 KiB 页是 4096，16 KiB 页是 16384）；能解释「最后一页尾部零填充」与「完全在 EOF 之后」的区别。把 `p[len]` 也说成会 `SIGBUS` 算未达标。

:::
:::

::: ex 例 1.9-C4 · 让 ASan 在越界处报错 {#ex-1.9-C4}

写一个 `malloc(8)` 后写 `p[8]` 的程序，先用普通编译跑（可能不崩），再用 `-fsanitize=address` 跑，拿到 `heap-buffer-overflow` 的报告。说明为什么普通编译可能「看起来正常」。

::: sol C4 核对

```c
/* overflow.c：先 cc -O0 overflow.c -o ov，再 cc -O0 -g -fsanitize=address overflow.c -o ov_asan */
#include <stdlib.h>
int main(void)
{
    volatile char *p = malloc(8);   /* volatile 防止越界写被优化掉 */
    if (!p) return 1;
    p[8] = 1;                       /* 越界 1 字节 */
    free((void *)p);
    return 0;
}
```

```bash
cc -O0 overflow.c -o ov && ./ov; echo plain=$?
cc -O0 -g -fsanitize=address overflow.c -o ov_asan
ASAN_OPTIONS=abort_on_error=1 ./ov_asan
```

普通编译可能正常退出：8 字节的请求会被 glibc 对齐到 24 或 32 字节的块，`p[8]` 落在 padding 里，没碰到下一块的 header，`free` 也不校验；这不是「程序正确」，只是「还没踩到元数据」。ASan 在分配周围放红区（redzone），`p[8]` 一写就报 `ERROR: AddressSanitizer: heap-buffer-overflow`，并给出 `WRITE of size 1` 与源码行。VM 实测（GCC 13.3.0）：`-fsanitize=address` 编译通过，`volatile` 版本稳定报 `heap-buffer-overflow`；若不加 `volatile` 或开了 `-O2`，这个写可能被当成死代码删掉，ASan 就不会报——这也是「为什么我的 ASan 没报」的常见原因。

需要 `sudo` 的替代：ASan 不需要 root；`perf` 与 `pagemap` 的 PFN 需要特权，本实验不依赖它们。

**判据**：能贴出 ASan 的 `heap-buffer-overflow` 报告与源码行；能解释普通编译为什么不崩（padding/未校验元数据）。若把「普通编译没崩」当成「没有越界」，或 ASan 没报却不检查 `volatile`/优化级别，算未达标。

:::
:::
