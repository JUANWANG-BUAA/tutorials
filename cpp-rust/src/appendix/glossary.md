# 术语表

这张表按主题分组，不按字母排序。每个词条只给一句话定义和一个正文入口；需要完整上下文时，点最后一列的章节链接。第一次遇到某个缩写，先在这里查一句话，再回去读正文，通常比硬啃段落快。

## 测量与统计

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| 估计对象（estimand） | 你真正要估计的量；第 1 章是「批处理中平均每个元素的墙钟时间」。 | [1.1.1](../part1/ch01.md#sec-cpp-rust.1.1.1) |
| 实验契约 | 输入、计时、观察、外部条件四组信息；缺一组，数字就不可复核。 | [1.1.1](../part1/ch01.md#sec-cpp-rust.1.1.1) |
| 批均值（batch mean） | 一个批次的总时间除以 `K × N`，回答吞吐，不回答单次延迟。 | [1.1.2](../part1/ch01.md#sec-cpp-rust.1.1.2) |
| 死代码消除（DCE） | 编译器删除没有可观察结果的纯计算；微基准最常见的假结果来源。 | [1.1.3](../part1/ch01.md#sec-cpp-rust.1.1.3) |
| 优化屏障（optimization barrier） | 阻止优化器跨越某个边界做推断的机制；`black_box` 是其中一种。 | [1.1.3](../part1/ch01.md#sec-cpp-rust.1.1.3) |
| 配对差值（paired difference） | 同一轮中两个实现的批均值之差；比两组独立均值更能抵抗时间漂移。 | [1.1.4](../part1/ch01.md#sec-cpp-rust.1.1.4) |
| 时间漂移（drift） | 机器状态随时间变化，导致前后批次不可直接比较。 | [1.1.4](../part1/ch01.md#sec-cpp-rust.1.1.4) |
| p50 / p99 | 第 50 / 99 百分位；必须区分「批分位数」和「请求分位数」。 | [1.1.2](../part1/ch01.md#sec-cpp-rust.1.1.2) / [1.1.8](../part1/ch01.md#sec-cpp-rust.1.1.8) |
| nearest-rank | 排序后取第 `ceil(Np)` 个值的分位数定义；N=21 时 p99 就是最大值。 | [1.1.8](../part1/ch01.md#sec-cpp-rust.1.1.8) |
| bootstrap | 有放回重采样，用来估计统计量的不确定性；区间不包含机器差异。 | [1.1.6](../part1/ch01.md#sec-cpp-rust.1.1.6) |
| 三态门禁 | 通过、拒绝、证据不足；不要把它压成「过/不过」两态。 | [1.1.7](../part1/ch01.md#sec-cpp-rust.1.1.7) |
| 回归预算（regression budget） | 允许的性能回退上界 B；必须来自业务或资源约束。 | [1.1.7](../part1/ch01.md#sec-cpp-rust.1.1.7) |

## 布局与所有权

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| 对齐（alignment） | 类型地址必须是其对齐值的倍数；对齐影响填充和缓存行占用。 | [1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1) |
| niche 优化 | 用非法位模式表示枚举判别式，省掉额外标签。 | [1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2) |
| 有效值集合（validity） | 一个类型允许的位模式集合；`unsafe` 不能凭空扩大它。 | [1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2) |
| 缓存行（cache line） | CPU 在缓存之间搬运的最小单位；本机 `sysctl` 报告 128 字节。 | [1.2.3](../part1/ch02.md#sec-cpp-rust.1.2.3) |
| AoS / SoA | 结构体数组 vs 数组结构体；决定扫描时缓存行的有效载荷比例。 | [1.2.4](../part1/ch02.md#sec-cpp-rust.1.2.4) |
| Arena | 一次性分配、统一释放的区域分配器；适合生命周期一致的小对象。 | [1.2.6](../part1/ch02.md#sec-cpp-rust.1.2.6) |
| 移动（move） | 所有权转移；通常只移动描述符，不复制堆上的元素。 | [1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1) |
| `Copy` / `Clone` | 隐式按位复制 vs 显式克隆；同名不代表同成本。 | [1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1) |
| `Drop` | 值离开作用域时运行的清理代码；可能展开，也可能被提前丢弃。 | [1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4) |
| Drop flag | 编译器用来记录「这个字段是否已初始化/已丢弃」的隐藏状态。 | [1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3) |
| 来源（provenance） | 指针来自哪个分配对象，决定它能合法访问哪里。 | [1.3.7](../part1/ch03.md#sec-cpp-rust.1.3.7) |
| 自引用（self-reference） | 结构体内部指针指向自身字段；移动会让它失效。 | [1.3.8](../part1/ch03.md#sec-cpp-rust.1.3.8) |
| `Pin` | 保证值在内存中不被移动的包装；不是「堆分配」的同义词。 | [1.3.8](../part1/ch03.md#sec-cpp-rust.1.3.8) / [2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3) |

## 编译器与代码生成

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| HIR | 高层中间表示，保留 Rust 语法结构。 | [1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2) |
| THIR | 类型化 HIR，显式化类型调整。 | [1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2) |
| MIR | 中层中间表示，借用检查和 Drop 展开都在这里。 | [1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3) |
| borrowck | 借用检查器；跟踪初始化、移动和借用访问。 | [1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4) |
| Drop elaboration | 把隐式析构展开成 MIR 中的显式控制流。 | [1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4) |
| CGU（codegen unit） | 代码生成单元；影响内联范围和 LTO 的可见性。 | [1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7) |
| 单态化（monomorphization） | 为每个具体类型参数生成一份泛型代码。 | [2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2) |
| vtable | 动态分派用的方法表；布局不是稳定 ABI。 | [2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3) |
| 去虚化（devirtualization） | 编译器把动态分派改成直接调用；取决于信息，不取决于关键字。 | [2.5.4](../part2/ch05.md#sec-cpp-rust.2.5.4) |
| 别名分析（alias analysis） | 判断两个指针是否可能指向同一对象；`noalias` 是它的输入之一。 | [2.6.2](../part2/ch06.md#sec-cpp-rust.2.6.2) |
| CTFE | 编译期函数求值；`const fn` 是它的入口。 | [2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5) |
| ThinLTO | 跨 CGU 的轻量链接时优化；扩大可见性，也增加构建成本。 | [2.6.7](../part2/ch06.md#sec-cpp-rust.2.6.7) |
| PGO | 用真实训练数据指导分支布局和内联；训练数据也是构建输入。 | [2.6.8](../part2/ch06.md#sec-cpp-rust.2.6.8) |
| `noalias` | LLVM 参数属性，表示指针不与其他指针别名。 | [2.6.2](../part2/ch06.md#sec-cpp-rust.2.6.2) |

## 并发与内存序

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| happens-before | 两个操作之间的可见性顺序关系；是证明数据竞争安全的骨架。 | [2.7.2](../part2/ch07.md#sec-cpp-rust.2.7.2) |
| Acquire / Release | 读/写同步边；Release 之前的写，在 Acquire 之后的读里可见。 | [2.7.2](../part2/ch07.md#sec-cpp-rust.2.7.2) |
| Relaxed | 只保证原子性，不建立跨线程顺序；适合统计计数，不适合发布数据。 | [2.7.2](../part2/ch07.md#sec-cpp-rust.2.7.2) |
| RMW（read-modify-write） | 原子读改写，如 `fetch_add`、`compare_exchange`。 | [2.7.4](../part2/ch07.md#sec-cpp-rust.2.7.4) |
| CAS | compare-and-swap；比较当前值，相等才写入新值。 | [2.7.4](../part2/ch07.md#sec-cpp-rust.2.7.4) |
| 伪共享（false sharing） | 两个线程写同一缓存行的不同变量，导致缓存行来回弹跳。 | [2.7.5](../part2/ch07.md#sec-cpp-rust.2.7.5) |
| SPSC | 单生产者单消费者队列；交接协议比 MPMC 简单。 | [2.7.6](../part2/ch07.md#sec-cpp-rust.2.7.6) |
| 线性化点（linearization point） | 并发操作在哪个瞬间「生效」；正确性证明要能指出它。 | [3.11.2](../part3/ch11.md#sec-cpp-rust.3.11.2) |
| 背压（backpressure） | 消费者跟不上时，让生产者等待或拒绝，而不是无限排队。 | [3.9.7](../part3/ch09.md#sec-cpp-rust.3.9.7) |
| work stealing | 空闲 worker 从其他队列偷任务；提高利用率，也带来同步成本。 | [3.9.3](../part3/ch09.md#sec-cpp-rust.3.9.3) |

## 异步与执行器

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| Future | 可能尚未完成的计算；由执行器调用 `poll` 推进。 | [2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1) |
| `poll` | 执行器询问 Future 是否就绪；返回 `Pending` 表示以后再来。 | [2.8.4](../part2/ch08.md#sec-cpp-rust.2.8.4) |
| `Waker` | Future 用来通知执行器「再 poll 一次」的句柄。 | [2.8.4](../part2/ch08.md#sec-cpp-rust.2.8.4) |
| 丢失唤醒（lost wake） | 通知在检查之后、睡眠之前到达，导致任务永久挂起。 | [2.8.5](../part2/ch08.md#sec-cpp-rust.2.8.5) |
| 跨 `await` 存活 | 变量在挂起点之后仍然被使用，必须存进状态机。 | [2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2) |
| 任务状态字 | Tokio 用位和引用计数表示运行、通知、完成、取消。 | [3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1) |
| 运行权 | 保证同一时刻只有一个线程 poll 任务。 | [3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1) |
| 通知责任 | 保证 wake 之后有人重新检查任务。 | [3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1) |
| 阻塞 poll | 在 `poll` 里做阻塞操作，占住 worker，拖慢同线程的其他任务。 | [3.9.6](../part3/ch09.md#sec-cpp-rust.3.9.6) |

## 进程、I/O 与数据通路

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| IPC | 进程间通信；本书主要讨论管道和显式线协议。 | [3.10.1](../part3/ch10.md#sec-cpp-rust.3.10.1) |
| 文件描述符（fd） | 进程持有的打开文件/管道句柄；所有权和关闭时机是协议的一部分。 | [3.10.2](../part3/ch10.md#sec-cpp-rust.3.10.2) |
| CLOEXEC | `exec` 时自动关闭文件描述符的标志；避免子进程继承不该继承的端点。 | [3.10.3](../part3/ch10.md#sec-cpp-rust.3.10.3) |
| 短读 / 短写 | `read`/`write` 没有一次处理完请求的字节数；必须循环处理。 | [3.10.3](../part3/ch10.md#sec-cpp-rust.3.10.3) |
| 双路排空 | 同时读 stdout 和 stderr，避免管道写满导致子进程阻塞。 | [3.10.5](../part3/ch10.md#sec-cpp-rust.3.10.5) |
| 全局分配器（global allocator） | 实现 `GlobalAlloc` 的那个对象，全进程共享一个；每次堆分配都要过它的锁。 | [2.6.6](../part1/ch02.md#def-2.6.4) |
| `Layout` | 一次分配的需求描述：`size` 加 `align`，`align` 必须是 2 的幂。 | [2.6.6](../part1/ch02.md#def-2.6.4) |
| 物理页帧（frame） | 按页大小切出来的物理内存块；页表自己也要占页帧。 | [2.6.6](../part1/ch02.md#sec-cpp-rust.1.2.6) |
| 内核栈 | 每个进程/任务在内核态执行时用的那截栈；进程退出后它可能还在被使用，因此回收要延后。 | [10.4.3](../part3/ch10.md#def-10.4.3) |
| ELF 加载 | 按可执行文件的段表把代码段与数据段搬进地址空间；`exec` 会先清空当前地址空间。 | [10.4.3](../part3/ch10.md#def-10.4.3) |
| 唤醒丢失（lost wakeup） | 通知发生时没有等待者，这次通知不被记录，后来者就永远等不到。 | [9.2](../part3/ch09.md#def-9.2.1) |
| 管程语义（monitor semantics） | 唤醒者把锁直接转交给被唤醒者（Hoare），还是等自己退出管程再交（Hansen）。 | [9.8](../part3/ch09.md#sec-cpp-rust.3.9.8) |
| 索引节点 / inode | 存文件元信息与数据块索引的磁盘结构；easy-fs 用 28 个直接项加两级间接索引。 | [17.2](../part4/ch17.md#sec-cpp-rust.4.17.2) |
| 间接索引 | 索引本身也占一个数据块，读它要先多一次块读。 | [17.2](../part4/ch17.md#sec-cpp-rust.4.17.2) |
| 页缓存（page cache） | 内核替文件与设备保管的内存副本；`write` 先进这里，不等于到了设备。 | [12.8.5](../part3/ch12.md#def-12.8.5) |
| 块缓存（block cache） | 文件系统内部按块缓存磁盘数据、带脏标记，回写时机由管理器决定。 | [12.8.5](../part3/ch12.md#def-12.8.5) |
| 写回 / 直写（write-back / write-through） | 前者只更新缓存并标脏、把设备写推迟；后者每笔都等设备确认。 | [12.8.5](../part3/ch12.md#def-12.8.5) |
| 崩溃点（durability point） | 写链上最后一个「掉电之后仍然成立」的时刻；由是否 `fsync`、是否 `O_DIRECT` 决定。 | [12.8.5](../part3/ch12.md#def-12.8.5) |
| 延迟分配（delayed allocation） | 数据先进页缓存，磁盘块等到回写时才分配（allocate-on-flush）。 | [17.9](../part4/ch17.md#sec-cpp-rust.4.17.9) |
| 扇区 / 块 | 扇区是块设备随机读写的单位（常为 512 字节）；块是文件系统存储的单位（ext4 默认 4096 字节）。 | [12.9](../part3/ch12.md#sec-cpp-rust.3.12.9) |
| 任务上下文（task context） | 切换时必须保存与恢复的那组资源；只保存「仍有用且有被覆盖风险」的部分（寄存器与栈）。 | [9.2.3](../part3/ch09.md#def-9.2.3) |
| 时间片（time slice） | 抢占式调度分给每个任务的一段处理器时间，由时钟中断驱动。 | [9.2.3](../part3/ch09.md#def-9.2.3) |
| 大页（huge page） | 用更大的页覆盖地址范围，减少页表节点与 TLB 压力，代价是要分配连续区域。 | [2.3.3](../part1/ch02.md#sec-cpp-rust.1.2.3) |
| 缺页（page fault） | 访问尚未建立映射的页时陷入内核，由内核补映射或分配；预热阶段常触发。 | [1.4](../part1/ch01.md#sec-cpp-rust.1.1.4) |
| SIMD | 单指令多数据；一条指令处理多个车道。 | [3.12.1](../part3/ch12.md#sec-cpp-rust.3.12.1) |
| NEON | ARM64 的 SIMD 指令集；本书在 Apple Silicon 上实测。 | [3.12.3](../part3/ch12.md#sec-cpp-rust.3.12.3) |
| 自动向量化 | 编译器把标量循环改成向量指令；受别名、对齐和边界检查影响。 | [3.12.2](../part3/ch12.md#sec-cpp-rust.3.12.2) |
| 零拷贝（zero-copy） | 不复制数据，只传递借用视图；生命周期必须覆盖使用期。 | [3.12.4](../part3/ch12.md#sec-cpp-rust.3.12.4) |
| `io_uring` | Linux 的异步 I/O 环形队列；提交和完成通过共享内存环。 | [3.12.8](../part3/ch12.md#sec-cpp-rust.3.12.8) |

## 无锁与内存回收

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| obstruction-free | 单独运行时能在有限步内完成；最弱的非阻塞进度保证。 | [3.11.2](../part3/ch11.md#sec-cpp-rust.3.11.2) |
| lock-free | 系统整体保证至少一个线程取得进展；单个线程可能饥饿。 | [3.11.2](../part3/ch11.md#sec-cpp-rust.3.11.2) |
| wait-free | 每个线程都能在有限步内完成；最强，也最难实现。 | [3.11.2](../part3/ch11.md#sec-cpp-rust.3.11.2) |
| ABA | 值从 A 变 B 再变回 A，CAS 误以为没变；地址复用会放大它。 | [3.11.3](../part3/ch11.md#sec-cpp-rust.3.11.3) |
| 标记指针（tagged pointer） | 在指针高位塞入计数器，检测 ABA。 | [3.11.3](../part3/ch11.md#sec-cpp-rust.3.11.3) |
| EBR（epoch-based reclamation） | 用纪元代际判断何时可以安全回收。 | [3.11.4](../part3/ch11.md#sec-cpp-rust.3.11.4) |
| Hazard Pointer | 线程声明自己正在访问的指针，回收者避开它。 | [3.11.4](../part3/ch11.md#sec-cpp-rust.3.11.4) |
| RCU | 读-复制-更新；读者不加锁，写者延迟回收。 | [3.11.8](../part3/ch11.md#sec-cpp-rust.3.11.8) |
| SMR | 安全内存回收的总称，包括 EBR、HP、RCU。 | [3.11.4](../part3/ch11.md#sec-cpp-rust.3.11.4) |

## Profiling 与构建

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| on-CPU / off-CPU | 线程在 CPU 上运行 vs 在等待；两种画像回答不同问题。 | [4.13.1](../part4/ch13.md#sec-cpp-rust.4.13.1) |
| 火焰图（flamegraph） | 把采样栈聚合成宽度图；宽度是样本比例，不是耗时。 | [4.13.4](../part4/ch13.md#sec-cpp-rust.4.13.4) |
| PMU | 性能监控单元，提供 cache miss、分支预测等硬件事件。 | [4.13.3](../part4/ch13.md#sec-cpp-rust.4.13.3) |
| 插桩扰动 | 测量代码本身改变被测程序；打点越细，扰动越大。 | [4.13.6](../part4/ch13.md#sec-cpp-rust.4.13.6) |
| 可复现构建 | 相同输入产生位级相同的构建产物；先划清承诺级别。 | [4.14.3](../part4/ch14.md#sec-cpp-rust.4.14.3) |
| 构建身份 | 工具链、目标、feature、CGU/LTO 等配置的组合。 | [4.14.1](../part4/ch14.md#sec-cpp-rust.4.14.1) |

## FFI 与项目

| 术语 | 一句话定义 | 正文 |
|:--|:--|:--|
| C ABI | C 的应用二进制接口，规定参数、返回值和布局；Rust 的默认布局不适用。 | [4.16.2](../part4/ch16.md#sec-cpp-rust.4.16.2) |
| 句柄（handle） | 不透明整数，代替裸指针跨边界传递；调用者不能解引用。 | [4.16.4](../part4/ch16.md#sec-cpp-rust.4.16.4) |
| 代际（generation） | 句柄里的版本号，防止旧句柄访问新对象。 | [4.16.4](../part4/ch16.md#sec-cpp-rust.4.16.4) |
| `catch_unwind` | 阻止 panic 越过 FFI 边界；不能替代 `unsafe` 契约。 | [4.16.5](../part4/ch16.md#sec-cpp-rust.4.16.5) |
| 有界准入 | 在创建任务之前拒绝过载，而不是让无限任务等待信号量。 | [4.15.2](../part4/ch15.md#sec-cpp-rust.4.15.2) |
| Q/C/Q+C | 队列容量、并发上限、两者之和的许可模型。 | [4.15.2](../part4/ch15.md#sec-cpp-rust.4.15.2) |
| 项目契约 | 操作集合、输入家族、不变量、不覆盖范围四元组；写在采集之前。 | [4.17.1](../part4/ch17.md#sec-cpp-rust.4.17.1) |
| 不变量（项目） | 任何合法操作序列后都成立、且能被一个测试证伪的命题。 | [4.17.1](../part4/ch17.md#sec-cpp-rust.4.17.1) |
| 出口条件 | 里程碑的可执行判据加上输出落盘位置；「跑通了」不算。 | [4.17.1](../part4/ch17.md#sec-cpp-rust.4.17.1) |
| 段文件三区间 | 数据区、定宽索引区、页脚；分开摆放是为了少搬字节。 | [4.17.2](../part4/ch17.md#sec-cpp-rust.4.17.2) |
| 墓碑（tombstone） | 表示删除的条目；必须活到压缩，否则旧值会复活。 | [4.17.2](../part4/ch17.md#sec-cpp-rust.4.17.2) |
| 编解码缝 | 读写只经过的一个 trait 边界，用来切换具体类型与 `dyn`。 | [4.17.4](../part4/ch17.md#sec-cpp-rust.4.17.4) |
| 快照（snapshot） | 某一刻段集合的不可变视图；发布后原地修改即破坏一致性。 | [4.17.5](../part4/ch17.md#sec-cpp-rust.4.17.5) |
| 宽限期（grace period） | 旧视图被所有读者放手之前的那段等待；回收决策看它。 | [4.17.5](../part4/ch17.md#sec-cpp-rust.4.17.5) |
| 幂等重放 | 同一任务重做两次结果与一次相同；标识要来自输入而非时刻。 | [4.17.7](../part4/ch17.md#sec-cpp-rust.4.17.7) |
| 证据包 | 环境指纹、原始 CSV、分析脚本、区间、门禁与代码证据的目录。 | [4.17.8](../part4/ch17.md#sec-cpp-rust.4.17.8) |
| 参照线（reference line） | 不由本书论证、专门回答「机制在哪里发生」的外部线索；本书用它补「代价在哪一层」这半边。 | [参照主线](../rcore-line.md#rcore-line-map) |
| 机制侧证据 | 能指到来源页、类型或常量，并约束本书某一节做法的机制事实；只说明机制，不提供数字。 | [定义 F.1](../rcore-line.md#def-rcore-line-1) |
| 空闲匹配策略（first/best/worst-fit） | 分配器挑空闲块的三种规则：快、省、浪费大各占一头，不可同时最优。 | [第2章回忆卡 23](../part1/ch02_recall.md#rc-2-23) |
| 页表遍历与 TLB 压力 | 跨度变大让同样元素摊到更多页，翻译更深、缓存更易装不下——布局的第二笔代价。 | [第2章回忆卡 24](../part1/ch02_recall.md#rc-2-24) |
