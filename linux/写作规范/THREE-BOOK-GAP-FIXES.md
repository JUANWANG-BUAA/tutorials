# 三本重点书：审计缺口与已补记录（2026-10-18）

## 1. 独立审计

| 报告 | 范围 | 结论 |
|:--|:--|:--|
| `AUDIT-KERRISK-SECTIONS.md` | Kerrisk 584 个 `x.y` 节 + 227 个 `x.y.z` | 明确落点 275、合并 95、背景 57、淘汰 138、**可疑缺失 19** |
| `AUDIT-CSAPP-SECTIONS.md` | CSAPP 116 个编号节 + OSTEP 50 章 | 明确落点 78/28、合并 34/7、背景 1/12、淘汰 0/2、**可疑缺失 3/1** |
| `AUDIT-KERNEL-SECTIONS.md` | 奔跑吧 46 节 + OSTEP 36–44 | 进行中 |

## 2. Kerrisk 19 个可疑缺失：已补

| 节 | 缺口 | 补到 |
|:--|:--|:--|
| 4.8 | `ioctl` 通用接口 | 2.2.4.1 |
| 60.1/60.3/60.4 | 迭代/并发/服务器模型 | 2.17.1.1 |
| 10.2 | `gmtime_r/localtime_r/mktime/strftime/strptime` | 2.11.8.1 |
| 14.8/14.9 | `mount(2)/umount2(2)`、bind/private/detach | 2.6.8.1 |
| 5.12 | `mkstemp/tmpfile/O_TMPFILE` | 2.2.9.1 |
| 52.3 | `mqd_t` 在 Linux 是 fd | 2.14.6.1 |
| 10.7 | `times()/clock()` | 2.8.11.1 |
| 10.3 | `TZ/tzset`、夏令时 | 2.11.2.1 |
| 14.11 | `statvfs/fstatvfs` | 2.5.7.1 |
| 47.7/47.8 | `semop` 数组、`SEM_UNDO` | 2.15.7.1 |
| 38.9 | 缓冲区溢出/格式串 | 2.9.11 表 + 段 |
| 13.5 | `posix_fadvise` 全 flags | 2.2.8.1 |
| 55.7 | `lockf()` | 2.3.6.1 |
| 18.14 | `dirname/basename` | 2.6.2.1 |
| 20.8 | `strsignal/psignal`、`killpg` | 2.10.1.1 |

## 3. CSAPP/OSTEP 可疑缺失：已补

| 母本节 | 缺口 | 补到 |
|:--|:--|:--|
| CSAPP 3.10 | 栈帧/缓冲区溢出/ROP/canary/NX/ASLR | 1.3.12.1 |
| CSAPP 3.11 | 浮点参数/返回值/转换/比较/NaN | 1.3.11.1 |
| CSAPP 12.6 | 强/弱扩展、并行效率 | 1.12.13.1 |
| OSTEP 29 | 懒初始化链表/hand-over-hand/并发哈希 | 1.12.13.2 |
| CSAPP 11.5/11.6 | MIME 表、CGI 模型 | 1.11.5.1 |
| CSAPP 9.10 | mark-sweep/根集/保守 GC | 1.9.10.1 |

## 4. 映射修正

- ch01：K14 从「2.1 完整」移出，改指 0.10/3.12。
- ch07：K24 改为「合并」，注明 24.4/24.5 见 2.7.2/2.7.6。
- ch16：K60 改为「backlog/SO_REUSEADDR；服务器模型见 2.17.1.1」。
- ch18：K63.3 改指 2.2.9 + 2.18.1。
- `coverage.md` / `build_coverage.py`：K7 改为 1.9.6/1.9.10/1.9.11。

## 5. 仍未补/待审计

- Kerrisk 的 19 个缺口已按审计建议落点；子节（x.y.z）的独立缺口仍在报告备注中。
- CSAPP P1 的「信号量版读者-写者」、OSTEP 16/21 的分段/swap 细节，尚未单独展开。
- 内核审计报告尚未返回；返回后按同一格式补。

## 6. 审计后抽读修正（2026-10-18 10:16）

| 位置 | 问题 | 修正 |
|:--|:--|:--|
| 2.8.11.1 | `times()` 32 位回绕写成 497 天 | 改为约 **248 天**（有符号 long，100 Hz：2^31/100/86400≈248.5） |
| 2.11.8.1 | 说 `strftime` 返回 0 要查 `errno` | 改为「POSIX 未规定 strftime 设置 errno」，0 只表示空结果/缓冲区不足 |
| 2.9.11.1 | 新 H3 缺显式锚点 | 补 `{#sec-2.9.11.1}` |
| 2.19.3 | K62.10 终端标识只讲 ttyname | 补 `ctermid()` 与 `/dev/tty` 的区别 |

## 7. 当前验收状态

- Kerrisk：19 个可疑缺失均已补节；3 处抽读错误已修；584 个节号有逐条判定表。
- CSAPP：3 个 CSAPP + 1 个 OSTEP 可疑缺失已补；P1 级「信号量读者-写者 / OSTEP 16/21 分段/swap」仍标为待加厚，不算零遗漏。
- 内核：`AUDIT-KERNEL-SECTIONS.md` 仍在生成；返回后按同格式补。
- 全书：120,389 行、113 页、67 章 ≥1000 行；`mdbook build` 与根 `./build.sh` 均 exit 0，`check_book` 无问题页。

## 8. AUDIT-C 结构/落点修正（2026-10-18 10:17）

- **1.13.7 缺号**：新增「从 OSTEP 到 Linux：机制与策略的对照」表，填上 1.13.7；章导语同步。
- **1.13.12 表 10 行**：25 改背景；29 改 1.12.13.2 已覆盖；36/37/40/41/43 改「合并/深落第 3 篇」；48 NFS→3.12.8.1、49 AFS→3.12.8.2 已覆盖；50→3.12.8.3 背景。
- **母本表同步**：ch03 3.10→1.3.12.1、3.11→1.3.11.1；ch09 9.10→1.9.10.1；ch11 11.2 补 4.1–4.3、11.3 补 4.7.5–4.7.6、11.5/11.6→1.11.5.1；ch12 12.6→1.12.13.1、12.5.4→1.12.11.1、OSTEP29→1.12.13.2。
- **12.5.4 偏薄**：1.12.11.1 补信号量版读者-写者（readcnt/mutex/write_sem、写者饥饿）。
- **OSTEP 16/21/23 偏薄**：1.13.3.1/1.13.3.2 补分段布局/共享/外部碎片、swap 槽/present 位/换入路径、VAX/VMS 一句。
- AUDIT-C 当前结论：CSAPP 84 明确/31 合并/1 背景/**0 缺失**；OSTEP 29 明确/7 合并/12 背景/2 淘汰/**0 缺失**。

## 9. AUDIT-R 内核/OSTEP 缺口修正（2026-10-18 10:20）

- **LFS**：1.13.5 补 inode map/indirect map/checkpoint region/segment summary/cleaning 五机制表。
- **数据完整性**：3.12.5.1 补 misdirected write、lost write、校验和成本/端到端 T10-PI。
- **FFS**：1.13.5 补柱面组、同组优先、目录分散、大文件例外、ext4 `mballoc`。
- **日志替代**：1.13.11 补 soft updates/CoW/backpointer 表。
- **cmwq**：3.3.4.1 补 per-CPU/unbound/ordered、`max_active`、`flush_workqueue`、`WQ_MEM_RECLAIM`。
- **bitmap**：3.12.12.1 补块位图分配四步与日志一致性。
- **mm 锁矩阵**：3.11.7.1 补 `mmap_lock/pte_lock/zone->lock/PG_locked/slab/anon_vma` 表。
- **分配 API 表**：3.9.12.1 补 `alloc_pages/kmalloc/kvmalloc/vmalloc/slab/dma` 选型。
- **polling/中断/DMA**：3.14.11.1 补三者取舍与 NAPI/busy_poll/io_uring SQPOLL。
- **3.13 母本表**：37/38/44 程度改为「完整但几何在 1.13.5」「RAID 在 1.13.5/0.10」「合并到 3.12.5.1」；修正 3.6.11 的错误交叉引用。

## 10. AUDIT-R 复核后精度/表修正（2026-10-18 10:24）

| 位置 | 问题 | 修正 |
|:--|:--|:--|
| 3.11.7.1 | 说 `mmap_lock` 5.8 后改为 per-VMA 混合方案 | 改为：`mmap_lock` 仍是 rwsem；6.4 的 per-VMA lock 是缺页路径补充，不是替换 |
| 3.9.12.1 | `kmalloc ≤ 4 MB（SLUB）` | 改为：≤8 KiB 走 slab；更大走 page allocator（`kmalloc_large`），仍要求物理连续 |
| 3.12.5.1 | 把 backpointer 与 Linux RMAP 混用 | 区分：backpointer 是磁盘「块→属主」；RMAP 是内存「页→映射者」 |
| 母本表 | ch03 5.3、ch09 2.19、ch11 4.7、ch14 36、ch12 40–44、ch13 36/38/43/44 未跟上新子节 | 全部补到 3.3.4.1/3.9.12.1/3.11.7.1/3.14.11.1/3.12.5.1/3.12.12.1 |

AUDIT-R 10:23 快照：奔跑吧 41 明确/4 合并/1 背景/**0 可疑**；OSTEP 31/44/9/1/**0 可疑**。
