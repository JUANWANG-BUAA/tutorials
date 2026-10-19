# CHECK-KERNEL-NET-ERRORS：第 3 篇（3.1–3.15）与第 4 篇（4.1–4.12）事实核查

> 独立核查（CHECK-R），**只读**：未修改 `src/` 正文、`SUMMARY.md`、`book.toml`、`theme/`、`tools/`。本文件是唯一新增产物。
> 核查范围：`src/part3/ch01.md`–`ch15.md`、`src/part4/ch01.md`–`ch12.md`（快照共 36,961 行）。
> **最终快照：2026-10-19 08:50（Asia/Shanghai）**。行号以该快照为准。
>
> **重要说明（正文在核查期间被并行修改）**：08:46–08:48 有一批增补/修正落盘，本报告 08:37–08:45 首轮记录的 10 条中，**3.7.2/3.7.9/3.8.2/3.8.10/4.3.12（NUD_CONNECTED）/4.3.13（fn_trie、fib_result.nh）/4.3.17（tcpdump offset）等 8 条已被正文修好**，不再计入 A 表，只在 C.1 留档。A 表所有条目均以 08:50 快照重新逐条复核。
>
> 证据口径：
> - 内核事实以本地解压的 **Linux 6.8 源码**（`/tmp/linux68/linux-6.8`，来自 `cdn.kernel.org` 的 `linux-6.8.tar.xz`）逐条对照；引用格式 `路径:行`。
> - 网络协议以 RFC 791/792/793/768/8200/1191/4443、`man 7 ip/tcp/udp`、iproute2 与 tcpdump 的实际输出为准。
> - 代码/脚本按文中命令实测（C17 + `-Wall -Wextra -Werror`；bash 用 `bash -n`）；不能实测的（需 root/netns/QEMU/内核头）在 C 表单独标注。
> - 只判事实错误与实质漏节，不评文风、篇幅、练习设计。

---

## A. 事实错误 top 25

> 排序：先「会直接教错机制/字段」的，再「版本/命名/数值」的。每条给 `文件:行`、原文、正确说法、源码/规范证据。

### A.1 6.8 已无 `MAX_ORDER`，`free_area` 的维度和历史叙述都用了旧名

- **位置**：`src/part3/ch07.md:168`、`:246`、`:569`、`:592`（另 `:28`、`:200`、`:239`、`:243`、`:337`、`:342` 同）
- **原文**：
  > `struct free_area free_area[MAX_ORDER];   /* MAX_ORDER = 10 */`
  > `MAX_ORDER` 在 6.4 之前是 11，之后改成 10（最大块从 8 MiB 降到 4 MiB）。
- **正确说法**：Linux 6.8 已把 `MAX_ORDER` 重命名为 **`MAX_PAGE_ORDER`**，并新增 **`NR_PAGE_ORDERS = MAX_PAGE_ORDER + 1`**；`struct zone` 的成员是 `struct free_area free_area[NR_PAGE_ORDERS]`（11 项，order 0–10），不是 `[MAX_ORDER]`（10 项）。6.8 源码中没有任何 `#define MAX_ORDER`，按原文写 `free_area[MAX_ORDER]` 在 6.8 上编译不过。历史叙述也应改为「`MAX_PAGE_ORDER` 在 6.4 之前是 11，之后改成 10」。
- **证据**：`include/linux/mmzone.h:29-38`（`MAX_PAGE_ORDER`、`NR_PAGE_ORDERS`）、`:938`（`struct free_area free_area[NR_PAGE_ORDERS];`）；全树 `grep '#define MAX_ORDER'` 无结果。

### A.2 `__ksize()` 的代码与 6.8 源码不符：`struct slab` 没有 `size` 字段，非 slab 的大块也不是「打印并返回 0」

- **位置**：`src/part3/ch09.md:729-755`
- **原文**：
  > `/* mm/slub.c —— 6.8 节选，简化 */`
  > `slab = folio_slab(folio);`
  > `return slab->objects ? slab->size : 0;`
  > 它对「不是 slab 的指针」会打印 `mem_dump_obj` 并返回 0，而不是崩。
- **正确说法**：6.8 的 `__ksize()` 在 **`mm/slab_common.c`**（不是 `mm/slub.c`），且逻辑是：
  - `ZERO_SIZE_PTR` 返回 0；
  - `!folio_test_slab(folio)` 时，若 `folio_size(folio) <= KMALLOC_MAX_CACHE_SIZE` 或 `object != folio_address(folio)` 才 `WARN_ON` 并返回 0；**否则返回 `folio_size(folio)`**——这正是 `kmalloc_large`（> 8 KiB、物理连续的大块）的合法路径，不是「一律返回 0」；
  - slab 路径返回 `slab_ksize(folio_slab(folio)->slab_cache)`，`struct slab` **没有 `size` 成员**。
- **证据**：`mm/slab_common.c:951-971`（完整 `__ksize`）；`include/linux/slab.h:229` 声明；`struct slab` 定义见 `mm/slab.h`（字段为 `slab_cache`、`freelist`、`counters`、`inuse`、`objects`、`frozen`，无 `size`）。

### A.3 ext4 extent header 没有 `ee_checksum`，校验和在块尾的 `ext4_extent_tail`

- **位置**：`src/part3/ch12.md:1138-1145`
- **原文**：
  > `0x08 ee_generation`
  > `0x0A ee_checksum`
- **正确说法**：`struct ext4_extent_header` 只有 12 字节：`eh_magic`(0x00)、`eh_entries`(0x02)、`eh_max`(0x04)、`eh_depth`(0x06)、`eh_generation`(0x08)。**没有 `ee_checksum`**；extent 块的 CRC32c 存在块尾的 `struct ext4_extent_tail { __le32 et_checksum; }`，位置由 `EXT4_EXTENT_TAIL_OFFSET(hdr)` 计算（`12 + 12 * eh_max`），不在 header 的 0x0A。
- **证据**：`fs/ext4/ext4_extents.h:55-57`（`ext4_extent_tail`）、`:86-93`（`ext4_extent_header` 仅 5 个字段）、`:96-98`（`EXT4_EXTENT_TAIL_OFFSET`）。

### A.4 「extent 树最多 5 层（`ee_depth` 0–4）」把上限写少了一层

- **位置**：`src/part3/ch12.md:1160`
- **原文**：
  > extent 树最多 5 层（`ee_depth` 0–4）……
- **正确说法**：6.8 的 `EXT4_MAX_EXTENT_DEPTH` 是 **5**；`eh_depth` 合法范围是 **0–5**（0 为叶子，5 为最深索引层）。「最多 5 层」与「0–4」自相矛盾：若按 0 起算、最深为 5，则共 6 个 depth 值；若说 5 层，则 depth 应写 0–5 或明确「5 级索引」。ext4 的实际上限是 `depth <= 5`。
- **证据**：`fs/ext4/ext4_extents.h:94`（`#define EXT4_MAX_EXTENT_DEPTH 5`）；`fs/ext4/extents.c:898`（`depth < 0 || depth > EXT4_MAX_EXTENT_DEPTH`）。

### A.5 `DCACHE_WHITEOUT` 与 `DCACHE_PAR_LOOKUP` 的值都写错，0x80 实际是 `DCACHE_DONTCACHE`

- **位置**：`src/part3/ch12.md:808`、`:812`
- **原文**：
  > `| DCACHE_WHITEOUT | 0x80 | overlayfs 的白out 项 |`
  > `| DCACHE_PAR_LOOKUP | 0x1000000 | 正在做并行 lookup（见下） |`
- **正确说法**：6.8 中：
  - whiteout 的类型位是 **`DCACHE_WHITEOUT_TYPE = 1 << 20 = 0x100000`**（`DCACHE_ENTRY_TYPE` 掩码 `7 << 20` 的一部分）；`0x80` 是 **`DCACHE_DONTCACHE`（BIT(7)）**，与 whiteout 无关；
  - `DCACHE_PAR_LOOKUP` 是 **`BIT(28) = 0x10000000`**，不是 `0x1000000`（后者是 BIT(24)）。
- **证据**：`include/linux/dcache.h:154-158`（OP 位）、`:189-191`（MOUNTED/NEED_AUTOMOUNT/MANAGE_TRANSIT）、`:199-209`（`DCACHE_WHITEOUT_TYPE`、`DCACHE_PAR_LOOKUP`）；`:27-31`（`DCACHE_DONTCACHE`）。

### A.6 块位图不是用 `test_and_set_bit`「原子占用」：ext4 用的是非原子的 `ext4_set_bit`

- **位置**：`src/part3/ch12.md:1265-1266`
- **原文**：
  > 2. 用 `test_and_set_bit` 原子占用；
- **正确说法**：ext4 的块位图分配在 buffer head 锁下用 **`ext4_set_bit()`**（即 `__set_bit_le`，非原子、小端）置位；inode 位图分配用 **`ext4_test_and_set_bit()`**（`__test_and_set_bit_le`），同样不是通用 `test_and_set_bit()` 的原子 RMW。把它们说成「test_and_set_bit 原子占用」既错了函数名，也错了并发语义（位图并发由 `buffer_head`/组锁保护，而不是靠单个原子位操作）。
- **证据**：`fs/ext4/ext4.h:1269-1272`（`ext4_test_and_set_bit = __test_and_set_bit_le`、`ext4_set_bit = __set_bit_le`）；`fs/ext4/mballoc.c:483-488`（`mb_set_bit()` → `ext4_set_bit()`，块位图分配路径）；`fs/ext4/ialloc.c:1095`（inode 位图 `ext4_test_and_set_bit`）。

### A.7 `struct device_driver.remove` 是 `int`，且「void remove / int remove_new」把 platform_driver 的过渡类型说反了

- **位置**：`src/part3/ch14.md:611`
- **原文**：
  > `| remove | void (*)(struct device *) | 解绑时调用；6.8 里还有返回 void 的 remove 与返回 int 的 remove_new 过渡 |`
- **正确说法**：分两层看：
  - `struct device_driver`（本表标题）里是 **`int (*remove)(struct device *dev);`**，**没有 `remove_new`**；
  - 真正有 `remove_new` 的是 **`struct platform_driver`**：6.8 里是 **`int (*remove)(struct platform_device *);`** 与 **`void (*remove_new)(struct platform_device *);`** —— 即 `remove` 返回 int、`remove_new` 返回 void，和原文「void 的 remove 与 int 的 remove_new」正好相反。
  原文把核心结构与 platform 总线结构混在一行，且两个返回类型都写反。
- **证据**：`include/linux/device/driver.h:109-112`（`struct device_driver`：`int (*probe)`、`int (*remove)`、`void (*shutdown)`，无 `remove_new`）；`include/linux/platform_device.h:237-248`（`struct platform_driver`：`int (*remove)` + `void (*remove_new)`）。

### A.8 IST 索引在 6.8 是 5 个（含 `IST_INDEX_VC`），不是 4 个

- **位置**：`src/part3/ch03.md:75`
- **原文**：
  > `CONFIG_X86_64` 下 `IST_INDEX_DF/NMI/MCE/DB` 一共四个索引。
- **正确说法**：6.8 的 IST 索引枚举是 **`DF=0, NMI=1, DB=2, MCE=3, VC=4`**，共 5 个。`IST_INDEX_VC` 用于 AMD SEV-ES 的 `#VC`（虚拟化异常），同样占用 CEA 里的一张 IST 栈；说「一共四个」会漏掉 #VC，也会让「每 CPU 四张 IST 栈」的后续叙述失真。
- **证据**：`arch/x86/include/asm/page_64_types.h:27-31`（`IST_INDEX_DF/NMI/DB/MCE/VC`）；`arch/x86/kernel/idt.c:116`（`ISTG(X86_TRAP_VC, ..., IST_INDEX_VC)`）。

### A.9 3.3.10 的「装门函数」不是 6.8 的 API：`set_system_intr_gate`/`set_system_trap_gate`/`set_intr_gate_ist` 都不存在

- **位置**：`src/part3/ch03.md:590-625`（代码块与函数表）
- **原文**：
  > `/* arch/x86/include/asm/desc.h —— 6.8 节选 */`
  > `static inline void set_intr_gate(...) { ... _set_gate(n, GATE_INTERRUPT, ...); }`
  > `| set_system_intr_gate | 3 | 0 | int3、int 0x80 |`
  > `| set_system_trap_gate | 3 | 0 | 用户态 int 陷阱门 |`
- **正确说法**：6.8 中这些函数都不存在：
  - `set_intr_gate()` 是 `arch/x86/kernel/idt.c:203` 的 **static** 函数，不是 `desc.h` 的 inline；
  - 没有 `set_system_intr_gate`、`set_system_trap_gate`、`set_intr_gate_ist`、`_set_gate`；
  - 6.8 用 `struct idt_data` + `INTG`/`SYSG`/`ISTG` 宏 + `idt_init_desc()`（`arch/x86/include/asm/desc.h:420`）+ `idt_setup_from_table()` 装门。
  原文的代码块会误导读者去 `desc.h` 找不存在的 API。
- **证据**：`arch/x86/kernel/idt.c:37-48`（`INTG/SYSG/ISTG` 宏）、`:196-205`（`idt_setup_from_table`、`set_intr_gate`）、`arch/x86/include/asm/desc.h:420`（`idt_init_desc`）；全树 `grep set_system_intr_gate` 无结果。

### A.10 `int3` 与 `int 0x80` 在 Linux 里装的是中断门，不是陷阱门

- **位置**：`src/part3/ch03.md:46`、`:48`、`:662`
- **原文**：
  > `| 0x03 | int3 断点 | 陷阱门，DPL 3（用户态可用） |`
  > `| 0x80 | 32 位 int 0x80 系统调用 | 陷阱门，DPL 3 |`
  > 3.「`type=0xF` 与 `0xE` 只差中断是否关闭」：……系统调用用陷阱门（或 `syscall` 指令）……
- **正确说法**：Linux 用 **`SYSG` = `GATE_INTERRUPT`、DPL3** 安装 `int3`（`X86_TRAP_BP`）和 `int 0x80`（`IA32_SYSCALL_VECTOR`），不是 trap gate（`type=0xF`）。从 CPU 架构角度 `int3` 是 trap 类异常，但 **Linux 的 IDT 门类型是 interrupt gate（0xE/0xEE）**；把「异常分类」与「门类型」混为一谈，会让读者按 0xEF 去解析 IDT。`syscall` 指令本身不经过 IDT 门，是 MSR 入口，和「用陷阱门」无关。
- **证据**：`arch/x86/kernel/idt.c:37-38`（`SYSG` 定义：`GATE_INTERRUPT, DPL3`）、`:65`（`SYSG(X86_TRAP_BP, asm_exc_int3)`）、`:124`（`SYSG(IA32_SYSCALL_VECTOR, asm_int80_emulation)`）。

### A.11 `CONFIG_DEBUG_STACK_OVERFLOW` 不存在，栈魔数检查由 `CONFIG_DEBUG_STACK_USAGE` 控制

- **位置**：`src/part3/ch02.md:99`
- **原文**：
  > `set_task_stack_end_magic(&init_task)` 在栈底写一个魔数，`CONFIG_DEBUG_STACK_OVERFLOW` 打开时，调度器每次切换会检查它是否被踩坏……
- **正确说法**：内核没有 `CONFIG_DEBUG_STACK_OVERFLOW`（这是 FreeBSD 的选项名）。Linux 的对应配置是 **`CONFIG_DEBUG_STACK_USAGE`**（`lib/Kconfig.debug:764`），它启用 `check_stack_usage()` 统计/告警；`set_task_stack_end_magic()` 本身是无条件写 `STACK_END_MAGIC`，检查逻辑在 `check_stack_usage()` 里，也不是「调度器每次切换」都查。
- **证据**：`lib/Kconfig.debug:764`（`config DEBUG_STACK_USAGE`）；`kernel/fork.c` 的 `set_task_stack_end_magic()` 与 `kernel/sched/core.c` 的 `check_stack_usage()` 调用点。

### A.12 nice 权重表的表头与「50% → 55.6%」方向都错了

- **位置**：`src/part3/ch05.md:84-97`
- **原文**：
  > `| nice | 权重 | 相对 nice 0 的份额 | 两个这样的进程各占 |`
  > `| −20 | 88761 | 86.7× | 97.7% |`
  > 所以「把 nice 从 0 调到 1」在双进程场景下把 50% 变成 55.6%，而不是 40%。
- **正确说法**：
  - 表头应是「**与一个 nice 0 进程竞争时，本进程的份额**」；若是「两个这样的进程」，两者各占 50%，与表中 97.7%/90.3% 等值不符。
  - 表中 −20 的 97.7% 也算错了：`88761 / (88761 + 1024) = 98.9%`（97.7% 对应的是 88761/(88761+2048)，即对两个 nice 0）。
  - nice 0→1 是**降低**优先级：nice 1 权重 820，份额 `820/(820+1024)=44.5%`；55.6% 是**另一个** nice 0 进程的份额。原文把「对方拿 55.6%」写成了「自己从 50% 变成 55.6%」。
- **证据**：`kernel/sched/core.c:11496-11505` 的 `sched_prio_to_weight[]`（nice 0=1024、nice 1=820）；份额公式 `weight_i / sum(weights)`。

### A.13 ECMP：同一条 TCP 流不会因哈希策略被分到不同路径；与本节上一句自相矛盾

- **位置**：`src/part4/ch03.md:777`（对照 `:775` 的「同一条流固定走一条路」）
- **原文**：
  > 如果哈希策略选错，同一条 TCP 流可能被分到不同路径，产生乱序……
- **正确说法**：`fib_multipath_hash()` 的输入是**流键**（源/目的地址，policy 1/3 再加 L4 端口与协议）；同一条 TCP 流的五元组固定，哈希值固定，只会命中同一条 nexthop。哈希策略改变的是**不同流之间**的分布（L3-only 会把同源/同目的的多条流压到同一条路径），不是「同一条流在包与包之间换路」。默认 ECMP 不是 per-packet；要 per-packet 需要专门的负载均衡配置。原文上一行自己写了「同一条流固定走一条路」，下一行又反着说。
- **证据**：`net/ipv4/route.c:2039-2100`（policy 0 用 v4 addrs；policy 1 用 addrs+ports+proto；`flow_hash_from_keys()` 对固定五元组是确定值）。

### A.14 ICMPv6 对应列有两处错：Protocol Unreachable 不是 1/1，Host Unreachable 也不是 1/1

- **位置**：`src/part4/ch03.md:796-797`
- **原文**：
  > `| 3 | 1 | Host Unreachable | ... | 1/1 |`
  > `| 3 | 2 | Protocol Unreachable | ... | 1/1 |`
- **正确说法**：ICMPv6（RFC 4443）没有「Host Unreachable」这个 code：
  - IPv4 type 3 code 1（host unreachable）在 IPv6 里没有一一对应；最接近的是 type 1 code 3（address unreachable），而 type 1 code 1 是 **communication with destination administratively prohibited**；
  - IPv4 type 3 code 2（protocol unreachable）对应 ICMPv6 **type 4（Parameter Problem）code 1（unrecognized Next Header type encountered）**，不是 1/1。
  表中 1/0（no route）、1/4（port unreachable）、2（packet too big）、3/0（hop limit exceeded）、3/1（reassembly time exceeded）、4（parameter problem）是对的。
- **证据**：RFC 4443 §3.1（Destination Unreachable codes 0–4）、§3.4（Parameter Problem codes 0–2）；RFC 4443 没有 host-unreachable code。

### A.15 conntrack 的 ESTABLISHED 不是 `nf_conntrack_confirm` 设置的

- **位置**：`src/part4/ch03.md:905`
- **原文**：
  > `| ESTABLISHED | 两个方向都看到过包 | 收到回包，nf_conntrack_confirm |`
- **正确说法**：`nf_conntrack_confirm()` 在 **POST_ROUTING** 对**首个原始方向包**执行，设置的是 `IPS_CONFIRMED` 并把连接插入哈希表，它**不决定 NEW/ESTABLISHED**。conntrack 看到**回复方向**的包时置 `IPS_SEEN_REPLY`；之后 `resolve_normal_ct()` 用 `IPS_SEEN_REPLY` 把 ctinfo 判为 `IP_CT_ESTABLISHED`。所以「收到回包」对，「`nf_conntrack_confirm`」错；下一段 `:910` 自己写「收到 SYN-ACK 后才变成 ESTABLISHED」，与表格自相矛盾。
- **证据**：`net/netfilter/nf_conntrack_core.c:1860`（`if (likely(status & IPS_SEEN_REPLY)) ctinfo = IP_CT_ESTABLISHED;`）、`:2030-2035`（`IP_CT_ESTABLISHED_REPLY` 时置 `IPS_SEEN_REPLY`）、`:1151-1288`（`__nf_conntrack_confirm` 只置 `IPS_CONFIRMED`/插哈希）。

### A.16 `[ASSURED]` 不是「可以提前淘汰」，恰恰是「禁止 early drop」

- **位置**：`src/part4/ch03.md:950`
- **原文**：
  > `[ASSURED]` 表示「两个方向都确认过，可以提前淘汰」；`use=1` 是引用计数。
- **正确说法**：`IPS_ASSURED` 的作用是**保护连接不被 `gc_worker_can_early_drop()` 提前淘汰**：该函数在 `!test_bit(IPS_ASSURED_BIT, &ct->status)` 时返回 true（可 early drop），有 ASSURED 时返回 false。ASSURED 由协议状态机在连接「完全建立/双向确认」后设置（TCP 在 `TCP_CONNTRACK_ESTABLISHED` 时置位），不是「可以提前淘汰」。把它讲反，会让读者以为 ASSURED 是低优先级标记。
- **证据**：`net/netfilter/nf_conntrack_core.c:1438-1452`（`gc_worker_can_early_drop`）、`net/netfilter/nf_conntrack_proto_tcp.c:1318-1331`（`set_bit(IPS_ASSURED_BIT, ...)`）。

### A.17 `nf_nat_l4proto_unique_tuple()` 返回 `void`，不会返回 `-ENOMEM`/`-EINVAL`

- **位置**：`src/part4/ch03.md:922-926`
- **原文**：
  > 3. 全被占用时返回 `-ENOMEM`/`-EINVAL`，包被丢，表现为「新连接建不上」。
- **正确说法**：6.8 的 `nf_nat_l4proto_unique_tuple()` 返回类型是 **`void`**；找不到唯一元组时它只是保留一个可能重复的 tuple 返回。真正的丢包发生在 `__nf_conntrack_confirm()`：如果插入时发现同 key 已存在，`insert_failed` 增加并 `NF_DROP`。源码注释明确写：「It might not be possible to get a unique tuple, but we try. At worst (or if we race), we will end up with a final duplicate in `__nf_conntrack_confirm` and drop the packet.」
- **证据**：`net/netfilter/nf_nat_core.c:465`（返回 `void`）、`:585-597`（尝试失败直接 `return`）、`:601-621` 的注释；`net/netfilter/nf_conntrack_core.c` 的 `insert_failed` 分支。

### A.18 `arp_queue` 满时丢的是最老的排队 skb，不是新 skb

- **位置**：`src/part4/ch03.md:621`
- **原文**：
  > `arp_queue` 有长度限制（`net.ipv4.neigh.default.unres_qlen`，默认 3）。队列满时新 skb 被丢弃……
- **正确说法**：`__neigh_event_send()` 在 `NUD_INCOMPLETE` 时执行：
  ```c
  while (neigh->arp_queue_len_bytes + skb->truesize > QUEUE_LEN_BYTES) {
      buff = __skb_dequeue(&neigh->arp_queue);   /* 从队头取最老的 */
      ...
      kfree_skb_reason(buff, SKB_DROP_REASON_NEIGH_QUEUEFULL);
  }
  __skb_queue_tail(&neigh->arp_queue, skb);      /* 新 skb 反而入队 */
  ```
  即**丢掉队列里最老的 skb，给新 skb 腾位置**；只有队列为空仍超限时才 `break`。把它说成「新 skb 被丢弃」会误导排障方向（该看 `unres_discards` 与队列里的旧包，而不是新包）。另外 `unres_qlen` 是「按 `SKB_TRUESIZE(ETH_FRAME_LEN)` 折算的包数视图」，真实限额是 `unres_qlen_bytes`（默认 64 KiB）。
- **证据**：`net/core/neighbour.c:1223-1236`（dequeue 队头、drop、再 tail 入队）、`:3539-3556`（`unres_qlen` 与 bytes 的换算）、`:3744`（`unres_qlen_bytes` sysctl）。

### A.19 `NUD_FAILED` 不会在下一包到来时「触发重新解析」

- **位置**：`src/part4/ch03.md:619`
- **原文**：
  > 4. **`NUD_FAILED`**：直接丢包，不再重试，直到下一次 `arp_queue` 触发重新解析。
- **正确说法**：邻居进入 `NUD_FAILED` 后，后续 `__neigh_event_send()` 对 `NUD_FAILED` 走 else 分支：再次把状态写成 `NUD_FAILED`、直接 `kfree_skb_reason(..., SKB_DROP_REASON_NEIGH_FAILED)` 并返回 1，**不会发 solicitation**。重新解析要等该 neighbour 被 GC/删除，或由 `neigh_update()`/`arp` 命令显式改状态；不是「下一包自动触发」。
- **证据**：`net/core/neighbour.c:1204-1213`（`else { state=FAILED; ... drop; return 1; }`）、`:1190-1202`（只有非 INCOMPLETE/FAILED 才 solicit）。

### A.20 `tcp_info` 的 `tcpi_busy_time` / `tcpi_rwnd_limited` 单位是微秒，不是毫秒

- **位置**：`src/part4/ch06.md:1090-1091`
- **原文**：
  > `| busy | tcpi_busy_time | ms | 有在途数据的累计时间 | 当 CPU 时间 |`
  > `| rwnd_limited | tcpi_rwnd_limited | ms | 因接收窗口受限的时间 | ... |`
- **正确说法**：UAPI 明确注释这两个字段是 **usec**（微秒）：`__u64 tcpi_busy_time; /* Time (usec) busy sending data */`、`__u64 tcpi_rwnd_limited; /* Time (usec) limited by receive window */`。`ss` 显示时才换算成 ms，和 `rtt`/`rto` 行同一规则（表里 `rtt`/`rto` 写了「µs（显示 ms）」，这两行却写成 ms）。同一本书 `src/part4/ch10.md:975` 也写的是 µs，前后矛盾。
- **证据**：`include/uapi/linux/tcp.h:276-277`；`net/ipv4/tcp.c:3833` 附近对 `tcpi_*` 的赋值；`src/part4/ch10.md:975`。

### A.21 「带 12 字节选项时，实际段长仍是 MSS」是错的：有效 MSS 会减去选项增量

- **位置**：`src/part4/ch06.md:1071`
- **原文**：
  > MSS 只约束 TCP 载荷。`MSS = MTU - 40`（IPv4/TCP 无选项）；它不包含以太网头，也不包含 TCP 选项——带 12 字节选项时，实际段长仍是 MSS，只是首部变长、有效载荷变少。
- **正确说法**：MSS 是「TCP 载荷」的上限，不是「首部变长后仍发 MSS 字节载荷」。如果载荷仍取 MSS，而首部多了 12 字节，IP 包就会超过 MTU。6.8 的 `tp->mss_cache` 是**含除 SACK 外所有 TCP 选项的有效发送 MSS**；`tcp_current_mss()` 还会按 `header_len - tp->tcp_header_len` 再减一次：
  ```c
  if (header_len != tp->tcp_header_len) {
      int delta = (int)header_len - tp->tcp_header_len;
      mss_now -= delta;
  }
  ```
  即带 12 字节选项时，载荷上限要减 12（或对应增量），不是「仍为 MSS」。
- **证据**：`net/ipv4/tcp_output.c:1816-1875`（`mss_cache` 注释与 `tcp_current_mss()` 的 delta 调整）。

### A.22 `tcp_options_write()` 的写入顺序不是「MSS、窗口缩放、SACK permitted、时间戳、SACK 块」

- **位置**：`src/part4/ch06.md:1235`
- **原文**：
  > `tcp_options_write()` 按固定顺序写：MSS、窗口缩放、SACK permitted、时间戳、SACK 块……
- **正确说法**：6.8 的实际顺序（无 MD5/AO/TFO 时）是：
  1. **MSS**；
  2. 若同时有 TS 和 SACK_PERM：把 **SACK permitted + Timestamps** 打进同一个 4 字节字（`SACK_PERM|TS`），否则写 NOP NOP + TS；
  3. 单独的 **SACK permitted**（仅当 TS 没把 SACK_PERM 带走）；
  4. **Window Scale**（NOP + WS）；
  5. **SACK blocks**；
  6. Fast Open / MPTCP 等。
  也就是说 WS 在 TS/SACK_PERM **之后**，不是之前；抓包里的 `[mss 1460,sackOK,TS ...,nop,wscale 7]` 正是这个顺序。原文的顺序会让读者对不上真实 SYN 的选项字节。
- **证据**：`net/ipv4/tcp_output.c:672-724`（MSS → TS/SACK_PERM 合并 → 单独 SACK_PERM → WS → SACK blocks）。

### A.23 ICMP 差错的「剩余 4 字节固定为 0」不成立：type 3 code 4 用它携带下一跳 MTU

- **位置**：`src/part4/ch03.md:790`
- **原文**：
  > ICMP 首部只有 8 字节：类型（1）、代码（1）、校验和（2）、以及 4 字节的「剩余部分」。差错报文（type 3、11、12）的剩余部分固定为 0……
- **正确说法**：RFC 792 的 Destination Unreachable 头 4 字节在多数 code 下 unused=0，但 **type 3 code 4（Fragmentation Needed and DF Set）** 按 RFC 1191 把这 4 字节的低 16 位用作 **Next-Hop MTU**；这正是 PMTUD 能工作的字段。Linux `__icmp_send()` 在发 type 3 code 4 时把调用方给的 MTU 放进 ICMP 头的 `un` 字段（`icmp_param.data.icmph.un.gateway = info`；该 union 在 Frag Needed 下就是 next-hop MTU）。说「固定为 0」会让读者在抓包时忽略 PMTUD 的关键字段。
- **证据**：RFC 792（Destination Unreachable 格式）、RFC 1191 §4（Next-Hop MTU 放在 unused 的低 16 位）；Linux `net/ipv4/icmp.c:726`（`icmph.un.gateway = info`）与 `:904`（接收侧 `ntohs(icmph->un.frag.mtu)`）。

### A.24 「IPv4 选项长度必须是 4 的倍数」不准确：每个选项长度不必是 4 的倍数，是整个首部按 4 字节对齐

- **位置**：`src/part4/ch03.md:481`
- **原文**：
  > `ip_options_compile()` 负责解析和校验，选项长度必须是 4 的倍数，不足时用 `IPOPT_END`（0）填充。
- **正确说法**：IPv4 的 IHL 以 4 字节为单位，因此**整个首部（20 + 选项）长度必须是 4 的倍数**；单个选项的 length 字段只要求 ≥2 且不越界，不要求是 4 的倍数（例如 Timestamp 选项长度 4/8/12…、Record Route 3+4n，单个选项可能不是 4 的倍数，靠 NOP/EOL 补到 4 字节边界）。把「首部对齐」说成「每个选项长度必须 4 的倍数」，会让读者误判合法选项为畸形。
- **证据**：RFC 791 §3.1（IHL 单位 4 字节；option length 包含 type/length）；`net/ipv4/ip_options.c` 的 `ip_options_compile()` 按 `optlen` 逐项解析，最后检查 `optlen` 总长与 `IPOPT_END` 填充。

### A.25 NAT 钩子表里的 `nf_nat_ipv4_local_out` 在 6.8 不存在，实际是 `nf_nat_ipv4_local_fn`

- **位置**：`src/part4/ch03.md:870`
- **原文**：
  > `| NF_INET_LOCAL_OUT | −100 | nf_nat_ipv4_local_out | 本机出方向的 DNAT |`
- **正确说法**：6.8 的 `nf_nat_ipv4_ops[]` 在 `NF_INET_LOCAL_OUT` 挂的是 **`nf_nat_ipv4_local_fn`**，不是 `nf_nat_ipv4_local_out`。全树没有 `nf_nat_ipv4_local_out` 这个函数；按原文去源码里搜会找不到，也会把 `nf_nat_ipv4_out`（POST_ROUTING 的 SNAT）与 LOCAL_OUT 的 DNAT 混淆。
- **证据**：`net/netfilter/nf_nat_proto.c:843-849`（`.hook = nf_nat_ipv4_local_fn, .hooknum = NF_INET_LOCAL_OUT, .priority = NF_IP_PRI_NAT_DST`）；`:828-857` 的完整 `nf_nat_ipv4_ops[]`。

---

## B. 实质漏节 top 15

> **口径**：以 `写作规范/source-toc/clean-running-linux.md`（奔跑吧 6 章 45 节）与 `clean-network.md`（深入理解 Linux 网络 10 章）、`clean-ostep-sections.md`（36–44 章）逐节对照。
> **总判定**：**没有整节缺失**（与 10-18 的 AUDIT-KERNEL-SECTIONS 结论一致）；下列 15 项是「原书有实质机制、本书只有一句/一张表/只在他篇覆盖」的偏薄项。前 13 项建议补正文，后 2 项只需补交叉引用即可闭环。
> 「不是总结/练习/淘汰」：已排除各章「本章总结」「本章思考题」「最新更新与展望」（总结/展望类）、OSTEP 36.8 IDE（淘汰）、奔跑吧 6.3 SystemTap（按本书政策以 bpftrace 替代，属明确改写，不计漏节）。

| # | 原书节号 + 标题 | 类型 | 为什么算「实质未落点」 | 建议补到哪 |
|--:|:--|:--|:--|:--|
| 1 | 奔跑吧 **2.14 匿名页面生命周期**（p272–274） | 真缺口 | 3.10.2 只讲 LRU 升降与二次机会，3.10.11 只讲 swap entry；没有「分配 → 建 PTE → fork/COW → swap out → swap in → unmap → free」的完整生命周期，读者答不出匿名页在各阶段 `mapping`/`index`/`_mapcount` 怎么变。 | **3.10.11** 新增「匿名页的一生」小节（或 3.10.2 末尾补一张生命周期表）。 |
| 2 | 奔跑吧 **4.5 读写锁**（p552–564） | 偏薄 | 3.11.2 只有一段 `rwlock_t` 定义，3.11.8 只列 `rw_semaphore` 字段；没有 `rwlock_t`（qrwlock）与 `rwsem` 的分工、读者饥饿/写者优先、递归读、降级写、`read_trylock` 失败语义。 | **3.11.4** 加「rwlock_t vs rwsem」对照表；**3.11.8** 补 qrwlock 字段。 |
| 3 | OSTEP **36.2 标准设备** | 真缺口 | 3.14.1 直接从 Linux 设备模型（bus/device/driver）起讲，没有讲设备对 CPU 暴露的接口：status/data/control 寄存器、MMIO vs PIO、寄存器轮询。 | **3.14.1** 开头补半页「设备寄存器接口」。 |
| 4 | OSTEP **36.3 标准协议** | 真缺口 | 没有讲「读 status 的 busy 位 → 写 data → 写 command → 等 status」的轮询协议，以及中断如何替代轮询；3.14.3 只讲 Linux 中断注册，不还原设备侧协议。 | **3.14.1/3.14.3** 补一个 5 步协议时序图。 |
| 5 | OSTEP **38.2 故障模型** | 真缺口 | 第 3 篇只讲块层/flush；RAID 故障模型在 1.13.5 的 RAID 表里隐含「整盘坏」，没有区分整盘故障、扇区/潜在扇区错误、写洞；读者无法解释「RAID 5 重建期间为什么危险」。 | **3.13.5** 或 **3.12.5.1** 加「RAID 的故障模型」一段，并链到 1.13.5。 |
| 6 | OSTEP **40.1 思考方式（VSFS）** | 真缺口 | 3.12.12 只有一条 `note` 提「VSFS 五个部分」，没有实际构造 VSFS 的布局、inode 表/位图/数据区关系与一次读写的块映射；读者无法从 VSFS 过渡到 ext4 块组。 | **3.12.12** 开头补「从 VSFS 到 ext4」一页（五区布局 + 一次写路径）。 |
| 7 | OSTEP **44.1 磁盘故障模式** | 真缺口 | 3.12.5.1 只列静默坏块/写错位置/丢失写，没有「整盘故障 vs 部分故障（扇区错误、潜在扇区错误）」的分类，也没有故障率/重建窗口的讨论。 | **3.12.5.1** 开头补故障分类表。 |
| 8 | OSTEP **44.2 处理潜在扇区错误** | 真缺口 | 全树没有「潜在扇区错误/latent sector」内容；没有讲磁盘每扇区 ECC、备用扇区重映射、RAID 重建时如何绕开坏扇区。 | **3.12.5.1** + **3.13.13**（I/O 错误处理）各补一段。 |
| 9 | OSTEP **44.3 检测讹误：校验和** | 偏薄 | 3.12.5.1 只提 CRC32c 与 T10-PI，没有讲校验和「放在哪」（extent tail、inode、block pointer）、覆盖范围、何时验证；与 A.3 的 extent tail 错误相关。 | **3.12.5.1** 补「校验和放在哪」表；**3.12.12** 讲 extent tail。 |
| 10 | OSTEP **44.4 使用校验和** | 偏薄 | 没有讲校验和不匹配后的恢复流程（副本/RAID/备份）、「校验和只能发现不能修复」的边界，以及 scrub 与在线读的差异。 | **3.12.5.1** 补恢复决策树。 |
| 11 | 深入理解 Linux 网络 **7.2 Linux 内核如何管理内存**（p204–213） | 偏薄 | 4.11.7 只给 `struct sock`/缓冲区/skb 的大小表，没有讲 slab/skbuff/page allocator 如何支撑「百万连接」的内存账；读者会算对象大小，但说不清 `skbuff_head_cache`、`TCP` slab、`tcp_mem` 压力之间的关系。 | **4.11.7** 加「协议栈内存从哪来」一段（slab + skb + `tcp_mem`）。 |
| 12 | 深入理解 Linux 网络 **6.5 异常 TCP 连接建立情况**（p185–194） | 偏薄 | 4.5 覆盖 RST、SYN flood、超时，但没有系统覆盖 simultaneous open、SYN 重传、ACK 异常、半开队列清理、`TCPAbortOnSynDrop` 等异常分支；4.5.14 只做三种异常实验。 | **4.5.14** 扩为「握手异常矩阵」，或在 4.5.10 后加一小节。 |
| 13 | 深入理解 Linux 网络 **4.3 网卡启动准备**（p106–107） | 偏薄 | 4.8.2 讲 RX ring 初始化，4.9.7 讲 TX ring 完成；但没有讲驱动 probe 的 PCI 资源映射/复位/固件加载/DMA mask 设置，读者不知道「网卡启动」在驱动里对应哪些步。 | **4.8.2** 或 **3.14.10** 补「PCI probe 到 ring ready」步骤表。 |
| 14 | OSTEP **37.2 基本几何形状 / 37.3 简单的磁盘驱动器 / 37.4 I/O 时间：用数学**（p314–325） | 仅交叉引用 | 这三节的机制（柱面/磁道/扇区、寻道+旋转+传输的时间账）已在 **1.13.5.2** 完整落点，但 3.13.3 只写「减少寻道（对 HDD 有效）」，没有指回 1.13.5.2；只读第 3 篇的读者接不上。 | **3.13.3** 开头加一句「几何与 I/O 时间账见 1.13.5.2」；不必重复正文。 |
| 15 | OSTEP **41.4 策略：如何分配文件和目录 / 41.6 大文件例外**（p355–362） | 仅交叉引用 | FFS 的同组优先/目录分散/大文件例外已在 **1.13.5** 的 FFS 段完整落点；3.12.12 只讲 ext4 块组，没有指回 FFS 策略，读者会把「块组」当成 ext4 独有设计。 | **3.12.12** 开头加一句「FFS 分配策略见 1.13.5」；不必重复。 |

> 另有 3 项也属「只在他篇」但影响较小，未进 top 15：OSTEP 43.4–43.6（LFS inode map/checkpoint，见 1.13.5）、42.1/42.2（崩溃点枚举/fsck，见 1.13.11）、39.15（创建并挂载，见 3.12.6）。

---

## C. 已核对无问题清单

### C.1 核查期间已被正文修好、不再计入 A 表的条目（留档，避免重复报）

08:46–08:48 的并行修改已修好以下 8 条；本报告首轮曾记录，最终快照复核为**已正确**：

1. `src/part3/ch08.md:107-125` 4 级页表类型/索引：已改为 `pgd`(PML4)/`pud`(PDPT)/`pmd`(PD)/`pte`(PT)，并补「4 级无独立 p4d」说明。
2. `src/part3/ch08.md:646-658` 手算 4 级 walk：已改为 `pgd/pud/pmd/pte` 四段，`pud=0x0b1`、`pmd=0x000`、`pte=0x001`。
3. `src/part3/ch07.md:557-598` `struct zone`：已改为 `per_cpu_pageset`、明确 6.8 无 `lru_lock`/`lruvec`、`CACHELINE_PADDING`。
4. `src/part3/ch07.md:655` `zone_batchsize()` 16 GiB 算例：已改为 `batch=4096`、`high≈6138`。
5. `src/part3/ch07.md:515-535` `pglist_data`：字段已改为 `__lruvec`。
6. `src/part3/ch07.md:81-135` `struct page`：slab/compound 字段已改为「在 `struct slab`/`struct folio`」。
7. `src/part4/ch03.md:616` `NUD_CONNECTED`：已改为 `PERMANENT|NOARP|REACHABLE`，并注明 DELAY 不属于。
8. `src/part4/ch03.md:722/732/1213`：`fn_trie_lookup`→`fib_table_lookup`、`nh`→`nhc`、tcpdump `offset 172`→`offset 1376` 均已修正；第二片 `length 124`/载荷 104 也是正确的（`ping -s 1472` 的 IP 载荷是 1480，1376+104=1480）。

> 结论：**正文在核查窗口内仍在快速增补**；发布前应重跑本报告，行号与「已修复」状态会继续漂移。

### C.2 内核：抽查过且未发现事实错误的高风险点

- **3.3.4.1 cmwq**：`alloc_workqueue(name, WQ_UNBOUND|WQ_MEM_RECLAIM, max_active)`、`queue_work`、`flush_workqueue`、`cancel_work_sync` 的语义；`worker_pool`/`pool_workqueue`/`nr_running`/`max_active` 的定位与 `kernel/workqueue.c` 一致；`WQ_MEM_RECLAIM` 的「内存回收路径也要能推进」解释正确。
- **3.9.12.1 分配 API 总表**：`kmalloc` 在 4 KiB 页上 `KMALLOC_MAX_CACHE_SIZE = 8 KiB`，更大走 `kmalloc_large`（页分配器，要求物理连续）；`kvmalloc` 返回必须 `kvfree`；`kvmalloc` 可能睡眠；`vmalloc` 虚拟连续/物理离散。与 `include/linux/slab.h`、`mm/util.c` 一致。
- **3.11.7.1 mm 锁矩阵**（修后版本）：`mmap_lock`（rwsem）、`pte_lock`（spinlock）、`zone->lock`、`PG_locked`、`anon_vma->lock` 的「能否睡眠」列基本正确；`mmap_lock` 读侧也能睡眠（原文「可以（写侧）」仍偏窄，但不构成硬错，未进 A 表）。
- **3.12.5.1 写错/丢失写**：misdirected write 需要父指针/上层校验；lost write 需要写后读、`REQ_FUA`、RAID 卡缓存保护；「RMAP 是内存反向映射，不是磁盘 backpointer」的区分正确；`metadata_csum` 自 e2fsprogs 1.43 默认、T10-PI 8 B/扇区、CRC32c SSE4.2 指令均正确。
- **3.12.12.1 块位图流程**（除 A.6 的「原子」措辞）：找 0 位 → 置位 → 更新 `bg_free_blocks_count` → 位图/组描述符同事务，与 ext4 `balloc.c`/`jbd2` 的总体顺序一致。
- **3.13.3 磁盘调度**：`mq-deadline` 读/写过期时间默认 `HZ/2`、`5*HZ`，`writes_starved=2`；`bfq.weight` 1–1000/默认 100；`none`/`kyber` 的定位；`%util` 对 SSD 会虚高的解释，均与 `block/mq-deadline.c`、`block/bfq-iosched.c` 一致。
- **3.14.11.1 轮询/中断/DMA**：NAPI「第一个包中断、随后关中断批量轮询、预算用完再开」；`SO_BUSY_POLL` 需要驱动 `ndo_busy_poll`；`IORING_SETUP_SQPOLL` 用内核线程轮询 SQ；与 `net/core/dev.c`、`net/ipv4/udp.c` 一致。
- **3.7.2/3.7.9/3.8.2/3.8.10**（修后版本）：`struct page` 的 `mapping` 低位、`PageAnon`、`_refcount/_mapcount`；`pglist_data.__lruvec`/`node_lruvec()`；PTE 低 12 位标志、`_PAGE_NX` bit 63；4/5 级切分与 `TASK_SIZE` 上限，均已复核正确。
- **3.2.2 启动顺序**：`setup_arch → mm_core_init → sched_init` 的依赖关系、`start_kernel` 头尾代码、`rest_init()` 创建 PID1/kthreadd 的顺序正确；仅 A.11 的配置名错误。
- **3.9.10 kmalloc 大小类**：`kmalloc-96`/`kmalloc-192` 的存在、96/192 的省碎片解释、`kmalloc_size_roundup(100)=128`、`ZERO_SIZE_PTR=(void*)16` 正确；`kmalloc_index()` 代码块为「简化」但漏了 96/192 特例（未进 A 表，属教学简化边界）。

### C.3 网络：抽查过且未发现事实错误的高风险点

- **4.3.10 IPv4 首部逐字段**：版本/IHL 0x45/0x46、DSCP+ECN 高低位、总长度 16 位、ID 在 DF 包可为 0（RFC 6864）、DF=0x4000/MF=0x2000/低 13 位偏移单位 8、TTL 默认 64 与增量校验和、协议号 1/2/6/17/41/47/50/51/132、首部校验和只覆盖首部、martian 源检查，均正确（除 A.24 的「选项长度」措辞）。
- **4.3.11 分片与重组**：`ip_local_deliver()` 的 `ip_is_fragment()`/`ip_defrag()` 返回 0 / `-EINPROGRESS` 语义；`ip_do_fragment()` 的 `(mtu - hlen) & ~7`、`frag_off = offset >> 3`、最后一片 MF=0；`ipfrag_high_thresh/low_thresh/time/max_dist` 默认 4 MiB/3 MiB/30 s/64；`nf_defrag_ipv4` −400 在 conntrack −200 之前，均与 6.8 源码/RFC 一致。
- **4.3.12 邻居子系统**（除 A.18/A.19）：`struct neighbour` 的 `ha/nud_state/ops/arp_queue/confirmed/used/refcnt/timer` 字段；`unres_qlen` 默认 3；`gc_thresh1/2/3=128/512/1024`、`base_reachable_time_ms=30000`、`retrans_time_ms=1000`、`ucast_solicit/mcast_solicit=3`、`app_solicit=0`、`gc_stale_time=60`；`arp_ignore` 0/1/2、`arp_announce` 0/1/2、`arp_filter`、`proxy_arp` 的语义，均正确。
- **4.3.13 路由查找**（除 A.13）：`ip route` 命令到 `RTM_*`/`inet_rtm_*` 的对应；`fib_rules_lookup` 按 `pref` 升序、默认 0/32766/32767 三条规则；`local` 表本机地址必须命中；`fib_result` 的 `table/prefixlen/type/fi/nhc/nh_sel/scope`（修后）；`ip route get` 的 `via/dev/src/uid` 字段；Linux 3.6 后无路由缓存；ECMP 策略 0/1/2/3 的哈希字段，均正确。
- **4.3.14 ICMP**（除 A.14/A.23）：8 字节首部、type 3/11/12 的典型 code、`icmp_send()` 的「不回 ICMP 差错/广播/非首片/非单播源」规则、`icmp_ratelimit=1000ms`、`icmp_ratemask=0x1818` 对应 type 3/4/11/12、`icmp_msgs_per_sec=1000`/`burst=50`、`ping`/`traceroute -I`/UDP traceroute/`tracepath` 的 ICMP 用法，均正确。
- **4.3.15 NAT**（除 A.15/A.16/A.17/A.25）：五个 netfilter 钩子优先级（defrag −400、conntrack −200、NAT_DST −100、NAT_SRC 100、confirm INT_MAX）；DNAT 必须在路由前、SNAT 在路由后；`nf_conn`/`nf_conntrack_tuple` 的 `src.u3/dst.u3`、`src.u.all`、`l3num`、`protonum`、`dir` 字段；`nf_conntrack_tcp_timeout_established=432000`、`time_wait=120`；`[ASSURED]` 之外的 `conntrack -L` 字段读法，均正确。
- **4.3.16 分片程序**：`frag_plan.c` 实测编译通过（C17 `-Wall -Wextra -Werror`），`4000/1500` 与 `4000/1400` 三组输出（1480/1480/1020、1376/1376/1228、校验和 `0x2edb/0x2e22/0x4f35`、`0x2f43/0x2e97/0x4e7f`）与文中逐字一致。
- **4.3.17 实验脚本**：`frag_lab.sh` `bash -n` 通过；三个 netns/veth/MTU 1400/DF 位/tcpdump 过滤表达式在语法上可执行；`offset 1376` 与第二片 `length 124`（载荷 104）均已修正，账目正确：IP 载荷 1480 = 1376 + 104。
- **4.6.19 UDP 首部**：8 字节布局、源/目的端口、长度最小 8 与「大于 IP 载荷丢弃、小于忽略填充」（修后）、校验和可选（IPv4 0=未计算，IPv6 0=丢弃）、伪首部 12 字节、反码和、结果 0 写 `0xffff`、`SO_NO_CHECK`/`sk_no_check_tx`、分片后只在重组完成校验，均正确；`udp_csum.c` 实测编译运行，输出 `UDP 长度 17，校验和 0xaab5` 与 `0xffff` 与文中一致。
- **4.6.20 TCP 首部**：20 字节固定首部、源/目的端口、序号/确认号、doff 单位 4 B（5=20、15=60）、保留 3 位+NS、8 个标志、16 位窗口、校验和、紧急指针、MSS=MTU−40、wscale 0–14、SACK permitted、Timestamps 10 B、选项总长 20 B 的算式，均正确（除 A.21/A.22）。
- **4.6.21 `tcp_info`**：`rtt`/`rttvar`、`rto`、`ato`、`snd_mss`、`pmtu`、`snd_cwnd`（MSS 单位）、`tcpi_retrans`（当前在途重传）/`tcpi_total_retrans`、`bytes_acked`、`unacked`、`delivery_rate`（B/s，ss 显示 bps）、`app_limited` 的读法均正确（除 A.20 的 busy/rwnd 单位）。
- **4.6.22 观测脚本**：`tcp_observe.sh` `bash -n` 通过；`ss -tinm state established "( sport = :$PORT )"` 过滤、`nstat -r` 清零、`rtt`/`retrans` 解析、netem 20 ms 下 RTT≈40 ms 的预期，语法与语义可执行（需 root/netem，未实跑）。
- **4.6.23 内核路径**（除 A.22）：`tcp_sendmsg_locked→tcp_push`、`tcp_write_xmit`、`tcp_transmit_skb→tcp_options_write`、`tcp_v4_rcv→tcp_rcv_established`、`tcp_parse_options`、`udp_sendmsg→udp_send_skb→ip_send_skb` 的函数/文件对应；`doff*4-20` 选项区长度、`opsize` 越界停止解析、UDP `uh->len/uh->check=0/udp_v4_check/CSUM_MANGLED_0` 的路径，均正确。

### C.4 代码/命令实测记录（不能实测的已标注）

- **Shell**：抽取 173 个 `bash`/`sh` 围栏块做 `bash -n`，**172 个通过**；唯一失败是 `src/part4/ch12.md:1011` 把 C 调用 `setsockopt(fd, ...)` 放进了 `bash` 围栏（`bash: syntax error near unexpected token 'fd,'`）。这是**围栏语言标错**，不是正文事实错误，未进 A 表；建议改成 `c` 围栏或加 `# 伪代码`。
- **C**：抽取 63 个含 `main()` 的完整程序，在 macOS + Clang 下编译：
  - **42 个直接通过**（C17 `-Wall -Wextra -Werror`）；
  - **21 个未能编译**，原因均为环境而非代码事实：Linux 专属头（`sys/epoll.h`、`linux/tcp.h`、`linux/errqueue.h`、`linux/mempolicy.h`、`numa.h`、`liburing.h`、`bpf/libbpf.h`）、macOS 无 `clone/MAP_STACK/PTRACE_*/O_DIRECT/SYS_finit_module`、Linux `mount()` 5 参数签名与 macOS 4 参数不同。**这些需要在 Linux 6.8 环境复测**，本报告不据此判错。
  - 两个纯协议程序 **`frag_plan.c`** 与 **`udp_csum.c`** 编译并运行，输出与文中示例逐字一致（见 C.3）。
- **未实测**：所有需要 root/netns/QEMU/内核模块/`tc netem`/`perf`/`bpftrace`/`liburing`/`libbpf` 的实验与脚本；本报告只做语法检查与源码/规范对照。

### C.5 结论与建议

1. **A 表 25 条中，13 条在网络篇（4.3/4.6），12 条在内核篇（3.2/3.3/3.5/3.7/3.9/3.12/3.14）**；其中 A.3/A.4/A.5/A.6 都集中在 3.12 的「ext4 磁盘结构与 dentry 缓存」两节，建议一次性修完。
2. **A.1（MAX_ORDER）与 A.2（__ksize）是「按 6.8 写却用了 5.x 名字/结构」的典型**；同类风险还有 `mm/slub.c` vs `mm/slab_common.c` 的文件路径，建议全篇做一次「6.8 符号名」grep。
3. **B 表没有整节缺失，最大缺口是「设备侧协议/故障模型/VSFS 心智模型」三组**；补的时候优先补机制图，不要把 part1 的内容整段复制过来。
4. 发布前请以本报告 A 表的 `文件:行` 重跑一遍；正文 08:46–08:48 的并行增补已修掉 8 条，说明**行号漂移是常态**，建议把本报告当作「待修清单」而不是「最终判决」。
