# 1.13 习题集

三组分层：**A 组概念判断**考「会读、会算、会说理由」；**B 组诊断推理**给现象让你判调度、替换、持久化与限额；**C 组动手实验**在 Ubuntu 24.04 上免 `sudo` 复现本章的关键证据。**全部附解答与判据**；先独立完成，再展开对照。

## 怎么用

1. 先读题，不看解答，给自己 2–3 分钟找思路；A 组要求口述或写一段完整因果，B 组要求写成「现象 → 机制 → 证据 → 修法」四段。
2. 卡住了回对应小节的「即时自测」重读，不要直接看答案；A 组对应 1.13.1–1.13.11，B 组对应 1.13.2、1.13.10、1.13.11、1.13.15，C 组对应 1.13.9、1.13.10、1.13.14。
3. C 组的命令都在本书的 Ubuntu 24.04.5 虚拟机（aarch64、内核 7.0.0-38-generic、GCC 13.3.0、4 vCPU、约 12 GiB 内存）上跑过；标「VM 实测」的是这台机器的读数。临时文件统一用 `lab1c13_` 前缀，实验结束删掉。
4. **`sudo` 不可用**：`vmstat`、`iostat`、`strace`、`filefrag`、`findmnt`、`taskset` 可用；`stress-ng`、`fio` 未安装；`perf sched` 因 tracefs 权限报 `can't access trace events`，C 组不用它；`sudo dumpe2fs`、`sudo debugfs` 用不了，实验三改用 `findmnt` + `filefrag`。
5. 做错的题记一个记号，三天后只重做记号题，并去[自检表](ch13-checklist.md)勾对应行。

## A 组 · 概念判断

::: ex 例 1.13-A1 · 三件事、两个抽屉，以及三处互相调用 {#ex-1.13-A1}

操作系统要同时解决哪几类矛盾？把它们填进「虚拟化 CPU / 虚拟化内存 / 并发 / 持久化」四格，每格写出机制与策略各一条。再举三个「两块代码互相调用」的例子，并说明为什么这三个例子恰好对应第 3 篇的三章。

::: sol 解答

四格：虚拟化 CPU——机制是「受限直接执行 + 定时器中断 + 上下文保存」，策略是「下一个选谁」（FIFO/SJF/RR/MLFQ/CFS）；虚拟化内存——机制是「页表 + TLB + 缺页异常」，策略是「换哪一页」（FIFO/LRU/Clock）；并发——机制是「原子指令 + 等待队列」，策略是「锁粒度与等待方式」；持久化——机制是「DMA + 中断 + 日志」，策略是「布局与回写时机」（FFS/LFS/`data=` 模式）。三处调用：① 缺页异常要用进程上下文与陷入机制（内存借用 CPU 的 trap，见 3.8 与 3.3）；② 文件系统的 page cache 就是物理页（持久化借用内存的页缓存，见 3.12.4）；③ 自旋锁依赖原子指令与关抢占（并发借用 CPU 的机制，见 3.11）。三处调用说明「三件事」不是三个模块，而是同一台机器的三种视角；第 3 篇按「陷入 → 调度 → 内存 → 文件系统 → 块层」组织，正好把这三处接口各写一章。

**判据**：四格齐全且机制/策略不混；三个例子各指出两块的名称；能说出「启动顺序」或「page cache」这类跨块证据；不把「并发」说成「并行」。

:::
:::

::: ex 例 1.13-A2 · 手算 FIFO、SJF、RR 的周转与响应 {#ex-1.13-A2}

三个任务 A(到达 0，运行 8)、B(2，4)、C(3，1)。分别用 FIFO、非抢占 SJF、RR（片长 2，新到达者排在刚被抢占者之前）调度，写出时间线、每个任务的周转与响应，以及两个平均值。哪种策略的平均周转最好？哪种的平均响应最好？

::: sol 解答

FIFO：A 0–8、B 8–12、C 12–13。周转 = 完成 − 到达：A 8、B 10、C 10，平均 9.33；响应 = 首次运行 − 到达：A 0、B 6、C 9，平均 5。
SJF（非抢占）：t=0 只有 A，A 0–8；t=8 时 B(4) 与 C(1) 都在等，选 C 8–9，再 B 9–13。周转：A 8、B 11、C 6，平均 8.33；响应：A 0、B 7、C 5，平均 4。
RR(2)：A 0–2（余 6，重新排队，B 在 2 到达排它前面）；B 2–4（余 2，C 在 3 到达排 A 前面）；A 4–6（余 4）；C 6–7（余 0，完成）；A 7–9（余 2）；B 9–11（完成）；A 11–13（完成）。完成时间 A 13、B 11、C 7。周转：A 13、B 9、C 4，平均 8.67；响应：A 0、B 0（到达 2、首次运行 2）、C 3（到达 3、首次运行 6），平均 1。SJF 的平均周转最好（8.33），RR 的平均响应最好（1）。注意 RR 的结果依赖「新到达者与被抢占者谁先入队」的约定，答题时必须写明假设，否则数字对不上。

**判据**：三条时间线都能画出来；周转与响应的定义不混（响应只看第一次）；平均值算对（FIFO 9.33/5、SJF 8.33/4、RR 8.67/1，允许四舍五入到两位）；能指出 RR 的入队约定会影响结果；结论是「周转看 SJF、响应看 RR」，不是「RR 一定更好」。

:::
:::

::: ex 例 1.13-A3 · MLFQ 的五条规则与参数 {#ex-1.13-A3}

写出 MLFQ 的五条规则。一个交互任务（每秒让出 CPU 几十次）、一个 CPU 密集任务、一个每 5 秒跑 100 ms 的定时任务同时到达，按五条规则描述它们在前 30 秒里的优先级变化。去掉规则 5 会怎样？把提升周期从 50 ms 改成 5 s 又会怎样？

::: sol 解答

五条：① 新任务进最高优先级；② 同优先级内按 RR；③ 用完整个时间片就降一级；④ 在时间片内主动让出就留在原级；⑤ 每隔一段时间把所有任务提升到最高级。交互任务每次都主动让出，留在最高级；CPU 密集任务每用完一个片就降一级，最后沉到最低级；定时任务每次只跑 100 ms，如果片长大于 100 ms 就留在原级，否则会被降级，再靠规则 5 回升。去掉规则 5：CPU 密集任务永远沉底，长任务饥饿；同时任务可以「在片快用完时让出」来 gaming 优先级。提升周期改成 5 s：短任务与定时任务在两次提升之间长时间停在低优先级，响应变差，系统更像批处理；改成 50 ms 则提升过频，CPU 密集任务反复回到最高级，短任务被反复打断。三个参数（队列数、片长、提升周期）一起决定系统性格。

**判据**：五条一条不漏，尤其规则 4 与 5；能说出「规则 5 防饥饿 + 防 gaming」两个作用；能预测交互、CPU、定时三类任务的走向；知道提升周期不是越小越好。

:::
:::

::: ex 例 1.13-A4 · 四种替换算法、栈算法与 Belady 异常 {#ex-1.13-A4}

OPT、LRU、FIFO、Clock 各替换谁？「栈算法」的定义是什么，为什么它决定 Belady 异常是否出现？对引用串 `1 2 3 4 1 2 5 1 2 3 4 5`，3 个与 4 个页框下四种算法各缺页几次？为什么本例的 Clock 与 FIFO 相同？

::: sol 解答

OPT 替换未来最久不用的页（不可实现，作为下界）；LRU 替换最久未使用的页；FIFO 替换最早进入的页；Clock 环形扫描，访问位为 1 就清位放过，给第二次机会。栈算法：页框数为 n 时的命中页集合一定是 n+1 时的子集；只有满足这个性质，加页框才不会增加缺页。LRU 与 OPT 是栈算法，FIFO 不是，所以 FIFO 会出现 Belady 异常。本书 VM 实测（`page_repl.c`）：3 个页框时 FIFO 9、OPT 7、LRU 10、Clock 9；4 个页框时 FIFO 10、OPT 6、LRU 8、Clock 10。FIFO 从 9 涨到 10，就是 Belady 异常；OPT 与 LRU 都下降。本例 Clock 与 FIFO 同结果，因为这条短引用串里访问位几乎总在置位，Clock 退化成「按环形顺序替换」，与 FIFO 同轨迹；换一条引用串它也可能下降——「近似 LRU」不保证栈性质。

**判据**：四种替换对象说对；栈算法定义含「n 的命中集合是 n+1 的子集」；四个读数与页框数对应正确（9/10、7/6、10/8、9/10）；能解释 Clock 为什么本例退化；知道真实内核用 active/inactive 近似而非纯 LRU。

:::
:::

::: ex 例 1.13-A5 · redo 日志的提交点与三种 `data=` 模式 {#ex-1.13-A5}

redo 日志有哪四步？哪一步是原子分界，为什么？崩溃恢复的两条规则是什么，为什么重放必须幂等？ext4 的 `data=journal`、`data=ordered`、`data=writeback` 各保证什么、各适合谁？日志能不能保证「应用语义正确」？

::: sol 解答

四步：写日志区（事务开始 + 记录）→ 写提交记录 → checkpoint 应用到主文件系统 → 回收日志空间。**提交记录落盘**是原子分界：它之前崩溃，事务视为没发生（丢弃，旧状态完好）；它之后崩溃，事务视为已发生（重放，新状态完整）。恢复两条规则：有提交就重放，没有就丢弃；重放必须幂等，因为 checkpoint 可能做了一半就崩，同一事务会被重放多次。三种模式：`data=journal` 数据也进日志，数据与元数据都原子，最慢，适合极小文件或强一致场景；`data=ordered`（默认）数据先于元数据提交，不会出现「元数据指向旧数据」，崩溃后可能看到旧数据，适合大多数服务；`data=writeback` 不保证顺序，只有元数据一致，最快，可能读到未初始化或旧数据，适合能自行校验的场景（如自带 WAL 的数据库）。日志只保证文件系统**结构**一致，不保证应用语义：要让「要么旧文件、要么新文件」，还得「临时文件 + `fsync` + `rename` + `fsync` 父目录」。

**判据**：四步与提交点说对；两条恢复规则说对并解释幂等；三种模式各给出「保证 / 代价 / 适用」；明确「日志 ≠ 应用原子性」，并给出原子写的五步顺序。

:::
:::

::: ex 例 1.13-A6 · 12 ms 与 RAID 的取舍 {#ex-1.13-A6}

一次 4 KiB 随机读的 12 ms 由哪几项构成？同样 4 KiB 顺序读为什么只要 0.04 ms？RAID 5 用 5 块 4 TB 盘，可用容量与容错是多少？RAID 5 的写代价从哪来？为什么说「RAID 不是备份」，而「RAID 6 也不等于两份备份」？

::: sol 解答

`T = 寻道 + 旋转 + 传输`：寻道约 8 ms、旋转平均半圈 4.17 ms（7200 RPM）、传输 4 KiB @100 MB/s 约 0.04 ms，合计约 12 ms，约 83 IOPS。顺序读省掉了寻道与旋转，只剩传输，所以 0.04 ms；随机与顺序差两个数量级，这是 WAL、LSM、LFS 的动机。RAID 5（5×4 TB）：可用容量 (5−1)×4 = 16 TB，容忍 1 块盘故障。写代价来自 read-modify-write：改一个条带要读旧数据与旧校验、算新校验、写数据与校验，小写会被放大；重建期间所有盘满负荷读，再坏一块就丢数据。RAID 不是备份，因为它只处理「盘坏」，不处理误删、勒索、机房火灾、控制器故障；RAID 6 容忍两块盘，但同样不防误删，也不防「同一批盘在同一批次里老化」。

**判据**：三项时间与数值对得上；顺序读的解释是「省掉机械动作」；容量 16 TB、容错 1 块；写代价说出 read-modify-write；「RAID ≠ 备份」给出至少两类它不防的故障。

:::
:::

## B 组 · 诊断推理

::: ex 例 1.13-B1 · 调了 nice，CPU 份额却没变 {#ex-1.13-B1}

一台 4 核机器上启动两个忙循环，一个 `nice -n 0`、一个 `nice -n 10`，`top` 里两个都接近 100%，团队认为「nice 失效了」。写出「现象 → 机制 → 证据 → 修法」四段。怎样用一条命令证明权重其实是生效的？

::: sol 解答

现象：两个进程各占一个核，都接近 100%。机制：普通调度类每个核一个运行队列，两个进程被分到不同核，各自跑满自己的核，权重只影响「同一个队列里怎么分」，不影响「不同核各跑一个」。证据：`ps -o pid,ni,psr,pcpu` 看 `PSR` 列是否不同；用 `taskset -c 0` 把两个都绑到同一核，再读 `/proc/<pid>/sched` 的 `se.sum_exec_runtime`。本书 VM 实测（绑到 CPU 0，10 秒）：nice 0 是 90.1% CPU、9034.216380 ms，nice 10 是 9.7%、974.130957 ms，比例 9.3 倍，与权重表 1024:110 一致；再把 nice 19 拉进来，98.3% 对 1.3%、7893.609598 ms 对 118.216624 ms，约 66.8 倍，接近理论 68:1。修法：要验证权重就绑核；要真的限制总量用 cgroup `cpu.max`；要降优先级用 `nice`，但要接受「空闲核上它仍然跑满」。

**判据**：把「不同核」与「同一队列」分开；给出 `PSR` 或绑核证据；引用 `se.sum_exec_runtime` 而不是只看 `%CPU`；知道修法是绑核验证或 cgroup 限流，不是「nice 没用」。

:::
:::

::: ex 例 1.13-B2 · 页框加了一个，缺页反而多一次 {#ex-1.13-B2}

一个教学用的页替换模拟器在 3 个页框时 FIFO 缺页 9 次，改成 4 个页框后变成 10 次。同事说「模拟器写错了」。写出四段分析，并给出一个能确认「不是 bug」的对照实验。

::: sol 解答

现象：页框从 3 增到 4，FIFO 缺页从 9 涨到 10。机制：FIFO 不是栈算法——页框数为 n 时的命中集合不保证是 n+1 时的子集，所以增加页框可能改变替换顺序，把「本来会命中的页」提前换出。这是 Belady 异常，1969 年就被记录过，不是实现错误。证据：对同一条引用串 `1 2 3 4 1 2 5 1 2 3 4 5` 跑四种算法，本书 VM 实测 FIFO 9→10、OPT 7→6、LRU 10→8、Clock 9→10；LRU 与 OPT 是栈算法，只降不升，正好反证 FIFO 的异常来自「非栈」。修法/判断：模拟器保留 FIFO 作为反例；真实系统不用纯 FIFO 做页替换，而用 Clock/active-inactive 近似；如果要证明「加页框一定不亏」，只能选栈算法。

**判据**：认出 Belady 异常而不是「代码错」；能用「栈算法」解释；给出四种算法的对照读数；知道真实内核的近似方案；不把「Clock 本例同 FIFO」误判为 Clock 也是栈算法。

:::
:::

::: ex 例 1.13-B3 · `fsync` 过了，断电后文件名还是回退了 {#ex-1.13-B3}

一个配置写入函数按「写临时文件 → `fsync(临时文件)` → `rename` → 返回成功」实现，测试里断电重启后偶尔发现文件名回退成旧的，或者新文件内容为空。写出四段分析，并说明为什么「再加一次 `fsync(临时文件)`」没有用。

::: sol 解答

现象：`fsync` 返回 0、`rename` 返回 0，断电后目录项仍是旧名字，或新名字指向空文件。机制：`fsync(fd)` 只保证这个 fd 对应的文件数据与元数据落盘；目录项属于父目录这个对象，`rename` 修改的是目录的数据块，没有 `fsync` 父目录时它可能还在 page cache 里，崩溃后回退。内容为空则是另一个问题：数据没落盘就 rename，元数据先到、数据后到，`data=writeback` 下尤其明显。证据：`strace -f -e trace=%file ./aw data.bin x`，本书 VM 实测输出里有两个 `fsync`——一个在文件 fd 3 上、一个在目录 fd 3 上（`openat(".", O_DIRECTORY)` 之后），以及一个 `renameat`；如果只看到一个 `fsync`，就是漏了目录。修法：写 → `fsync(文件)` → `close` → `rename` → `fsync(父目录)`；再补一次文件 `fsync` 不能替代目录 `fsync`，因为对象不同。

**判据**：把「文件对象」与「目录对象」分开；能在 `strace` 里数出两次 `fsync`；知道 `rename` 只在同一文件系统内原子；修法顺序完整（含父目录）；不把「文件内容为空」只归因于 `fsync`（还要看 `data=` 模式与写入顺序）。

:::
:::

::: ex 例 1.13-B4 · swap 加了一倍，机器反而更卡 {#ex-1.13-B4}

一台 8 GiB 内存的机器跑着工作集约 12 GiB 的服务，运维把 swap 从 2 GiB 加到 8 GiB，结果响应更慢。写出四段分析：怎样确认是 thrashing？`vmstat` 的 `si/so` 与 `/proc/vmstat` 的 `pswpin/pswpout` 单位各是什么？正确的处理方向是什么？

::: sol 解答

现象：加了 swap，缺页变多，响应变慢。机制：工作集超过物理内存，系统不断把刚换出的页又换回来，CPU 大量时间花在 I/O 等待上，这就是 thrashing；swap 只是「更大的溢出区」，不增加可用物理内存，反而让「换出的页很快又被访问」的概率上升。证据：`vmstat 1` 看 `si`/`so` 是否持续非零、`free` 是否长期很低；`/proc/vmstat` 的 `pswpin`/`pswpout` 是**累计页数**（不是字节），两次采样相减得到页数，再乘页大小换算；`/proc/pressure/memory` 的 `some avg10` 持续升高是另一条证据。本书 VM 没有内存压力，`pswpin`/`pswpout` 都是 0、`swpd` 为 0，正好是「健康基线」的样子。修法：加内存、缩小工作集（缓存上限、批大小）、用 cgroup `memory.max` 限住并让 OOM 早发生，而不是加 swap；`swappiness` 只调「匿名页与文件页谁先被回收」，救不了工作集超限。

**判据**：判成 thrashing 而不是「swap 不够」；给出 `si/so` 与 `pswpin/pswpout` 的单位差异；修法是加内存/限 cgroup，不是加 swap；知道 `swappiness` 的作用边界。

:::
:::

::: ex 例 1.13-B5 · 容器里 `nproc` 说 4 核，进程只用出 1 核 {#ex-1.13-B5}

一个容器限了 1 个 CPU，但里面的服务读 `nproc` 得到 4，按 4 开线程池，结果吞吐只有预期的四分之一，`cpu.stat` 里 `throttled_usec` 一直在涨。写出四段分析：`nproc` 读的是什么？限额在哪里？为什么线程池开 4 也会被限流？

::: sol 解答

现象：`nproc` 返回 4（宿主核数或 affinity），实际只跑出 1 核的量，`throttled_usec` 持续增长。机制：`nproc`/`sysconf(_SC_NPROCESSORS_ONLN)` 读的是「在线 CPU 数」或调度亲和性，不是 cgroup 的 CPU 配额；配额由 `cpu.max`（cgroup v2，格式 `quota period`）表达，配额用完整个 cgroup 被 throttle 到下一个周期。开 4 个线程只会让 4 个线程在同一个配额桶里抢，桶空了全部睡到下一周期，吞吐不会变成 4 倍，反而多出上下文切换。证据：`cat /proc/self/cgroup` 找到自己的 cgroup 路径，读 `cpu.max` 与 `cpu.stat` 的 `throttled_usec`、`nr_throttled`；本书 VM 的会话 scope 是 `cpu.max = max 100000`（不限流）、`cpu.weight = 100`，正好是「没限额」的基线形状。修法：按 `quota/period` 算核数（例如 `200000 100000` 是 2 核），或读 `cpu.weight` 判断相对份额；线程池大小按配额算，再按 I/O 比例放大。

**判据**：指出 `nproc` 与配额的来源不同；给出 `cpu.max` 的格式与「quota/period」算法；用 `throttled_usec` 作证据；修法是按配额设池，不是把 `cpu.max` 无限调大。

:::
:::

::: ex 例 1.13-B6 · `ps` 显示 `R`，但 CPU 不高 {#ex-1.13-B6}

值班时看到某进程 `STAT` 是 `R`，`top` 里 `%CPU` 却只有个位数，怀疑「进程卡住了」。写出四段分析：`R` 到底表示什么？怎样区分「在跑」与「在等 CPU」？什么指标能说明「等 CPU 等得难受」？

::: sol 解答

现象：`STAT` 为 `R`，`%CPU` 很低。机制：Linux 的 `TASK_RUNNING` 同时覆盖「正在 CPU 上」与「在 runqueue 上排队」两种情况，`ps` 把它们都显示成 `R`；所以 `R` 不等于「正在使用 CPU」。证据：两次采样 `/proc/<pid>/stat` 的第 39 字段（上次运行的 CPU 号），不变说明它没被调度；读 `/proc/<pid>/sched` 的 `se.sum_exec_runtime` 两次差值算真实 CPU 时间；读 `/proc/pressure/cpu` 的 `some avg10` 看全局「有任务等 CPU」的比例（本书 VM 上该文件可读，例如 `some avg10=1.10`）。修法/判断：`R` + 低 CPU 常见于「被更高优先级或 cgroup 配额压住」「在等一把锁的自旋路径」「被 `cpu.max` 限流」，分别查 `cpu.stat` 的 `throttled_usec`、`ps -L` 的 `wchan`、以及同 cgroup 内其他进程；不要把它当死锁（死锁通常是 `S` 或 `D`，CPU 接近 0 且无新日志）。

**判据**：说清 `TASK_RUNNING` 的双重含义；给出至少一条「两次采样」的证据；能读 `se.sum_exec_runtime` 或 `/proc/pressure/cpu`；把「等 CPU」与「死锁」分开。

:::
:::

## C 组 · 动手实验

::: ex 例 1.13-C1 · 用绑核与 `/proc/<pid>/sched` 验证权重 {#ex-1.13-C1}

在两轮实验里分别比较 nice 0 与 10、nice 0 与 19 的 CPU 份额。要求：绑到同一个核；读 `se.sum_exec_runtime` 而不是只看 `%CPU`；记录两轮的比值，并与权重表（1024:110、1024:15）对照。

::: sol C1 核对

```bash
# 第一轮：nice 0 vs nice 10，都绑 CPU 0，跑 10 秒
taskset -c 0 nice -n 0  sh -c 'while :; do :; done' & P0=$!
taskset -c 0 nice -n 10 sh -c 'while :; do :; done' & P10=$!
sleep 10
ps -o pid,ni,psr,pcpu,time -p $P0,$P10
grep -E 'se.sum_exec_runtime|nr_switches|se.nr_migrations' /proc/$P0/sched /proc/$P10/sched
kill $P0 $P10

# 第二轮：nice 0 vs nice 19，跑 8 秒
taskset -c 0 nice -n 0  sh -c 'while :; do :; done' & Q0=$!
taskset -c 0 nice -n 19 sh -c 'while :; do :; done' & Q19=$!
sleep 8
ps -o pid,ni,pcpu,time -p $Q0,$Q19
grep -E 'se.sum_exec_runtime' /proc/$Q0/sched /proc/$Q19/sched
kill $Q0 $Q19
```

VM 实测：第一轮 `ps` 显示 `NI 0 / PSR 0 / %CPU 90.1` 与 `NI 10 / PSR 0 / %CPU 9.7`，`se.sum_exec_runtime` 为 9034.216380 ms 与 974.130957 ms，比值 9.3，`nr_switches` 383，`se.nr_migrations` 0。第二轮 `%CPU` 98.3 与 1.3，`se.sum_exec_runtime` 7893.609598 ms 与 118.216624 ms，比值约 66.8，接近理论 68:1。`se.sum_exec_runtime` 的单位是毫秒（带 6 位小数），可以和 `ps -o time` 对得上；`nr_switches` 只是计数；`se.load.weight` 是定点数（nice 0 显示 1048576，即 1024 << 10），不要当 1024 读。不绑核的话两个进程各占一个核、都接近 100%，比例就没有意义——这正是 B1 的现象。

**判据**：两轮都跑完并记录；`PSR` 或 `taskset` 证明绑了同一个核；比值落在 8.5–10 与 55–75 之间（机器不同会有偏移，方向必须对）；能说出字段单位与定点数；知道「不绑核则比例无意义」。无需 `sudo`。

:::
:::

::: ex 例 1.13-C2 · 用 `minflt` 与 `statm` 给 `mmap` 算缺页账 {#ex-1.13-C2}

写一个程序：`mmap` 64 MiB 匿名私有映射，分别在映射前、映射后、逐页写完之后读 `/proc/self/stat` 的 `minflt`（第 10 字段）与 `/proc/self/statm` 的 RSS。再读 `/proc/vmstat` 的 `pgfault`/`pgmajfault` 与 `vmstat 1` 的 `si/so`。解释「映射之后 fault 只涨了十几次」与「写完之后正好涨 16384 次」。

::: sol C2 核对

```c
/* lab1c13_touch.c：mmap 64 MiB，逐页写，观察缺页与 RSS */
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#include <stdio.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>

#define BYTES (64UL << 20)

static void ru(const char *tag)
{
    struct rusage u;
    getrusage(RUSAGE_SELF, &u);
    FILE *f = fopen("/proc/self/statm", "r");
    long sz = 0, res = 0;
    if (f) { if (fscanf(f, "%ld %ld", &sz, &res) != 2) { } fclose(f); }
    printf("%-8s minflt=%ld majflt=%ld rss=%ld kB\n", tag,
           u.ru_minflt, u.ru_majflt, res * sysconf(_SC_PAGESIZE) / 1024);
}

int main(void)
{
    ru("before");
    char *p = mmap(NULL, BYTES, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (p == MAP_FAILED) { perror("mmap"); return 1; }
    ru("mapped");
    for (unsigned long o = 0; o < BYTES; o += 4096)
        p[o] = 1;
    ru("touched");
    printf("pages=%lu\n", BYTES / 4096);
    return 0;
}
```

```bash
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror lab1c13_touch.c -o lab1c13_touch
grep -E '^pgfault|^pgmajfault' /proc/vmstat
./lab1c13_touch
grep -E '^pgfault|^pgmajfault' /proc/vmstat
vmstat 1 2
```

VM 实测：`before` 为 `minflt=83 rss=1340 kB`；`mapped` 为 `minflt=94 rss=1408 kB`（只多 11 次——`mmap` 建立 VMA 与 libc 首次触碰，不分配 64 MiB 物理页）；`touched` 为 `minflt=16478 rss=66944 kB`，增量正好 16384 = 64 MiB / 4 KiB；`pgmajfault` 前后都是 7786（没有 swap 换入），`vmstat` 的 `swpd/si/so` 全为 0。解释：`mmap` 只登记 VMA，PTE 为空；第一次写触发缺页，内核分配零页并建立映射，这正是「按需清零」；RSS 涨到约 64 MiB 说明物理页此时才真正分配。`/proc/vmstat` 的全局 `pgfault` 增量会略大于 16384，因为它还统计了同机其他进程。

**判据**：三个阶段的 `minflt` 都记录；能指出 `mapped` 阶段增量远小于页数、`touched` 阶段增量等于页数；RSS 从约 1 MiB 涨到约 64 MiB；`pgmajfault` 不变或几乎不变；`vmstat` 的 `si/so` 为 0；能解释「`mmap` 不分配物理页」。无需 `sudo`。

:::
:::

::: ex 例 1.13-C3 · 复现 Belady 异常与步长调度的确定性 {#ex-1.13-C3}

从正文抄下 `page_repl.c` 与 `lottery.c`，原样编译运行，记录四种替换算法在 3 个与 4 个页框下的缺页数，以及彩票/步长两列的份额与最终 `pass`。然后把 `QUANTA` 改成 100 再跑一次彩票，解释变化。

::: sol C3 核对

```bash
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror page_repl.c -o page_repl
./page_repl
cc -std=c17 -D_GNU_SOURCE -O2 -Wall -Wextra -Werror lottery.c -o lottery
./lottery
```

VM 实测：`page_repl` 输出为 `FIFO 9 / OPT 7 / LRU 10 / Clock 9 (frames=3)` 与 `FIFO 10 / OPT 6 / LRU 8 / Clock 10 (frames=4)`——FIFO 从 9 涨到 10，Belady 异常成立；OPT 与 LRU 都下降。`lottery` 输出为 `A 50.2% / B 24.6% / C 25.2%`（期望 50/25/25），`stride` 列为 `50.0 / 25.0 / 25.0`，三个 `pass` 都是 5000000。把 `QUANTA` 改成 100：VM 实测彩票列变成 `41.0 / 30.0 / 29.0`（偏离期望 9 个百分点），步长列仍是精确的 50/25/25、三个 `pass` 都是 50000——抽签次数少了，`1/sqrt(n)` 的抖动就藏不住。这就是「概率公平」与「确定性公平」的差别，也是 CFS 选 `vruntime` 而不是随机抽签的原因。注意两个程序都只依赖 libc 与同一个 xorshift 种子，换机器输出不变。

**判据**：八个缺页数全对（9/7/10/9 与 10/6/8/10）；能指出 FIFO 是唯一上升的一列；彩票列在 50/25/25 的 ±1.5 个百分点内；步长列精确；三个 `pass` 相等；`QUANTA=100` 后能解释波动来自抽样次数（实测彩票列偏离 9 个百分点，步长不变）。无需 `sudo`。

:::
:::

::: ex 例 1.13-C4 · 持久化证据链：两次 `fsync`、一个 `renameat`、一个 extent {#ex-1.13-C4}

编译正文的 `atomic_write.c`（改成短名 `aw.c`），按「写临时文件 → `fsync` → `rename` → `fsync` 目录」运行。要求：① 用 `strace -f -e trace=%file` 数 `fsync` 与 `rename` 的次数，说明每个 `fsync` 作用在谁身上；② 用 `filefrag -v` 看目标文件的 extent；③ 在另一个终端跑 `iostat -x 1 3`，同时用 `dd ... conv=fsync` 写 100 MiB，比较 `dd` 报的带宽与设备侧的 `w_await`。

::: sol C4 核对

```bash
mkdir -p ~/lab1c13_work && cd ~/lab1c13_work
# aw.c 即正文 atomic_write.c（去掉参数错误提示即可），注意它自己 #define _GNU_SOURCE
cc -std=c17 -O2 -Wall -Wextra -Werror aw.c -o aw
./aw data.bin hello-1
strace -f -e trace=%file -o tr.txt ./aw data.bin hello-2
grep -E 'rename|fsync' tr.txt
filefrag -v data.bin
findmnt -no FSTYPE,OPTIONS /

# 另一个终端：
iostat -x 1 3
dd if=/dev/zero of=big.bin bs=1M count=100 conv=fsync
```

VM 实测：`strace` 里先是 `openat("data.bin.tmp.<pid>", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0644) = 3`，接着 `fsync(3) = 0`（文件），`close(3)`，再 `openat(".", O_RDONLY|O_CLOEXEC|O_DIRECTORY) = 3`、`fsync(3) = 0`（目录），中间夹一个 `renameat(AT_FDCWD, "data.bin.tmp.<pid>", AT_FDCWD, "data.bin") = 0`。注意 `rename` 在 aarch64 glibc 上编成 `renameat`，用 `-e trace=rename` 看不到，必须用 `-e trace=%file`（这也是为什么很多人「数不到 rename」）。`filefrag -v data.bin` 显示 `1 extent found`，`physical_offset 13875648`。`findmnt` 显示 `/ ext4 rw,relatime`。`iostat` 在 `dd` 期间一行是 `w/s 27.00`、`wkB/s 102496`、`w_await 4.63`、`f/s 2.00`、`%util 0.50`，而 `dd` 自己报 `3.9 GB/s`——因为 `dd` 写进 page cache，`conv=fsync` 只在末尾刷一次，设备侧的真实延迟看 `w_await`，`f/s` 是 flush 请求。如果想看「真同步写」，用 `oflag=dsync` 对比 `w/s` 与耗时。

**判据**：`strace` 里数出两次 `fsync` 并指出对象（文件 fd 与目录 fd）；看见 `renameat`（或说明本机显示为 `renameat`）；`filefrag` 有 extent；`findmnt` 给出文件系统类型与选项；能解释 `dd` 的带宽为什么不能代表设备；知道 `iostat` 的 `w_await` 单位是毫秒。无需 `sudo`；实验完删掉 `~/lab1c13_work` 与 `/tmp/lab1c13_*`。

:::
:::
