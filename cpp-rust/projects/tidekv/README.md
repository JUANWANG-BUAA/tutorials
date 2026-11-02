# tidekv · 《Rust 底层性能工程》第 17 章综合大项目

一个单写多读的本地键值引擎：写请求过有界准入后进预写日志与内存表，内存表刷成不可变段文件，读请求跨内存表与段查找（先问布隆过滤再二分定宽索引，命中后返回零拷贝切片），段合并交给子进程，被替换下来的旧快照由 epoch 回收。

只用标准库，零外部依赖。对应正文：`src/part4/ch17.md`。

## 怎么跑

```bash
./run.sh                      # 环境快照 → build → fmt/clippy/doc → test → bench → analyze → gate
SEED=20261030 WARM_MS=300 BUDGET=1000 ./run.sh   # 种子、预热、预算、轮次都可用环境变量覆盖
#   注意：三轮共用这两个默认值（SEED=20261028、WARM_MS=500），要精确复现任一轮
#   必须显式传那一轮的值——run-01: 20261028/500，run-02: 20261029/500，run-03: 20261030/300。
#   这些值都印在各自 CSV 的头部注释与 statistics 的 protocol 字段里。
./probe.sh                    # 单独产出 codegen/ 下的 MIR、LLVM IR 与 asm，并跑 grep 判定
```

`run.sh` 跑三轮，产物分开放：

**第一轮 `results/run-01/`（主轮）**——tidekv 与进程内基线的 A/B 比较，对应正文 17.8.2：

| 文件 | 内容 |
|:--|:--|
| `environment.txt` | `rustc`/`cargo` 版本、CPU 型号、`hw.cachelinesize`、核数、内存、系统版本 |
| `bench.csv` | 逐轮逐批次逐 case 的原始值，列名 `kind`、`case`、`round`、`arm_order`、`arm`、`batch`、`value_ns_per_op`、`ops`、`warm_ns_per_op` |
| `bench-verification.txt` | 每个 case 的 A/B/REF 三方状态摘要比对（等价性与独立参考值的证据） |
| `statistics.json` | 每 case 的两臂均值、配对差值、样本标准差、bootstrap 95% 区间、逐轮明细 |
| `gate.json` | 三态判定结果与所用预算 `B`、协议参数、bootstrap 种子 |
| `test-summary.txt` | `cargo test --release` 各测试二进制的结果行 |
| `codegen/` | `--emit=mir,llvm-ir,asm` 的产物与 grep 判定输出 |

**第二轮 `results/run-02/`（机制对照轮）**——只比机制内部的两种写法，对应正文 17.4.2 与 17.7.2：

| 文件 | 内容 |
|:--|:--|
| `environment.txt` | 该轮的环境快照（与主轮同一台机器时内容一致） |
| `codec.csv` / `compaction.csv` | 两组实验的逐轮逐批原始值；表头注明这次一个 op 是什么 |
| `mech-verification.txt` | **等价工作证据**：两条路径的输出必须逐字节相同，不相同直接报错不出数 |
| `statistics-codec.json` / `statistics-compaction.json` | 配对差值、样本标准差、bootstrap 95% 区间、逐轮明细 |
| `gate-codec.json` / `gate-compaction.json` | 两轮各自的三态判定、所用预算 `B` 与预算来源说明 |
| `codegen/codec-codegen.txt` | 汇编层的分发证据：单态化实例与 `encode_all_dyn` 的指令行数、`bl`/`blr` 计数 |

两组实验的工具：`src/codec.rs`（编解码缝与两条路径）、`src/bin/tide-mech.rs`（基准）、`analyze_mech.py`（统计）、`gate_mech.py`（三态门禁）、`tests/codec_contract.rs`（两条路径逐字节相同的契约测试）。

**第三轮 `results/run-03/`（准入对照轮）**——同一个引擎、同一份由种子决定的操作序列，只改 `admission_capacity` 一个参数（深门口 A 对浅门口 B），对应正文 17.6.2：

| 文件 | 内容 |
|:--|:--|
| `environment.txt` | 该轮的环境快照（与主轮同一台机器时内容一致） |
| `admit.csv` | 逐轮逐批原始值；一行 = 一批突发，列含 `wall_ns`、`accepted`、`flush`、`bytes_flushed` 与两条 case 名；夹具参数写在表头注释里 |
| `admit-verification.txt` | **一致性证据**：每臂最终状态必须等于「把本臂真正受理的那些操作在 `BTreeMap` 里回放」，且 `Stats.put` 与 `Stats.admission_reject` 和夹具记账逐条对齐、受理 + 被拒 = 尝试；对不上直接失败不出数 |
| `recompute.txt` | `verify_admit_csv.py` 的独立重算：每个比值都要能从 `wall_ns` 与各自的分母重推出来，并给出受理数、flush 次数、落盘字节的取值范围 |
| `statistics.json` | 两个口径各自的配对差值、样本标准差、bootstrap 95% 区间、逐轮明细 |
| `gate-attempted.json` / `gate-accepted.json` | 两份**分开的**三态判定：`ns_per_attempted` 与 `ns_per_accepted` 各判一次，各带预算 `B` 与预算来源说明 |

工具：`src/bin/tide-admit.rs`（夹具）、`verify_admit_csv.py`（独立重算）、`analyze_mech.py`（统计）、`gate_mech.py`（三态门禁）、`tests/admission.rs`（满即拒、控制命令同样有界、被拒不扰动序号）。

**本 README 不抄任何测量结果。**差值、区间、判定、均值一律只存在于上面那些文件里；正文引用时同样指向它们——抄一份进 README 就会长出第二个真相，而第二个真相没人负责更新。README 里出现的数只有两类：**协议量**（每批分母 900/2,900/1,900/4,996、三轮的臂顺序分配、`take_batch` 的 256 条上限）与**结构性事实**（`CAP + 256` 这样的推导）。它们不看 CSV 就没法读表，所以留在这里。

## 口径（读任何数字之前先看这段）

- 单位是 `value_ns_per_op` 列：一个批次的墙钟除以 `批次内操作数`（`ops` 列），再对每轮的批次取均值（`kind=BATCH_MEAN` 那行）。**不是**单次请求延迟。
- **`ops` 列才是分母，CSV 头部的 `ops_per_batch` 不是。**头里那个数是传给夹具的随机段长度（`--ops`），逐行 `ops` 是这个 case 一批真正重放的操作数：主轮 `put_wide` 900，`get_hot` 2,900、`get_absent` 1,900、`scan_12` 4,996（后面三个在随机段之前还要整段重放 setup 写）。`bench-verification.txt` 逐 case 印了这四个值。四个 case 的分母与值长都不同，**不能横比**。
- 差值约定 `diff = B(tidekv) − A(基线)`，**正数表示 tidekv 更慢**。基线 A 是进程内一把 `RwLock<BTreeMap>`。
- 三态规则：`U ≤ B` 接受、`L > B` 拒绝、其余证据不足。预算 `B` 由命令行传入并写进 `gate.json`。
- 机制对照轮的单位按实验走：`codec.csv` 是 ns/记录（一次 op = 编码一条记录），`compaction.csv` 是 ns/次合并（一次 op = 合并两个段）。两轮各自的差值方向写在各自 CSV 的表头与 `statistics-*.json` 的 `diff_convention` 里。
- 准入对照轮的一条 op 是**一整批突发**：一批 `put` 连发到底，批末只设**一个排空点**（`sync` 重试到成功为止，重试有意计进墙钟），墙钟只记这一段。同一个 `wall_ns` 除两个分母，得到两条各自独立判定的口径——`ns_per_attempted` 除以提交尝试（受理 + 被拒），`ns_per_accepted` 除以真正受理的数量。**两个分母是同一把墙钟，不是两次计时**，所以一个数降、另一个数不动完全可能。拒绝率不塞进这两格里，它单独报：分母是尝试数，按批从 `admit.csv` 的 `accepted` 与 `ops` 两列算。`admit-verification.txt` 记的是出数之前的一致性关卡（每臂的状态摘要是否等于受理子集的回放），不是聚合拒绝率。
- **A 与 B 不是同一件工作。**B 在计时边界内多做预写日志追加、CRC 计算与周期性段落盘。因此这组差值能读成「持久化与可恢复性要付多少」，**不能**读成「同样的读写，tidekv 比 `BTreeMap` 慢多少」。正文按第 1 章的等价工作判据把这条写死在 17.8。

## 里程碑状态

| 里程碑 | 内容 | 出口条件 | 状态 |
|:--|:--|:--|:--|
| M1 | 预写日志、内存表、段文件与恢复 | CRC 截断/损坏被拒；重启后逐键等于参考值 | 有测试，见 `tests/wal_recovery.rs`、`tests/persistence.rs`、`tests/segment_format.rs` |
| M2 | 只读路径与布隆过滤 | 无漏报；假阳有实测计数 | 有测试，见 `tests/bloom_contract.rs` |
| M3 | 快照并发与 epoch 回收 | 读者持快照期间旧段不释放 | 有测试，见 `tests/epoch_reclaim.rs`、`tests/concurrency.rs` |
| M4 | 有界准入（按请求取消未实现） | 饱和时返回 `AdmissionRejected`，不阻塞不入队 | 有测试，见 `tests/admission.rs`：满即拒、控制命令同样有界、被拒不扰动序号。`put` 是 fire-and-forget，引擎没有按请求取消的 API；常规顺序 `close()` 并不丢排队中的写（`Shutdown` 排在队尾，FIFO 会先把它前面的写落盘）；只有「`Shutdown` 已入队、`closed` 未置真」这个窗口里的提交会被丢弃，另一条不寻常的退出是写线程致命错误直接 `return`。两条都**没有测试覆盖** |
| M5 | 压缩子进程 | 两路管道同时排空；退出码非零带出 stderr | 有测试，见 `tests/ipc_compactor.rs`、`tests/compaction.rs` |
| M6 | 代码生成证据 | MIR/LL/asm 落盘，热路径判定有 grep 结果 | 产物在 `results/run-01/codegen/` |
| M7 | 配对基准与三态门禁 | CSV、`statistics.json`、`environment.txt`、`gate.json` 齐全 | 由 `./run.sh` 产出 |

各里程碑的**实际数字与判定结论**以 `results/run-01/`（主轮）、`results/run-02/`（机制对照轮）与 `results/run-03/`（准入对照轮）里的文件为准；正文里凡未采集之处都明写「本节没有采集」（目前是：每请求端到端延迟；按请求取消的两类计数；子进程合并里固定开销与随数据量增长部分的拆分；「同一批输入合并两次」这条路径的实际后果；主轮每批里段落盘 `sync_all` 与 WAL 追加各占多少——CSV 每批只有一个 `value_ns_per_op`，夹具不做分段计时）。

## 已知缺口与待办

按「改起来要多花多少工夫」排序，全部对着当前代码与归档核实过：

1. **证据包缺源码指纹。**三份 `environment.txt` 只钉住机器与工具链，没有 `src/**/*.rs` 与 `Cargo.toml` 的 SHA-256 清单，别人复跑时无法发现自己换了代码。补法：`run.sh` 在每轮开头落一份指纹文件。
2. **臂顺序是每轮独立掷硬币，不是配额制。**三轮里两类顺序都没配平（run-01 是 8 : 13，run-02 压缩轮 12 : 9，准入轮 11 : 10）。位次差会原样进入同一轮的配对差值，靠两类轮数接近才被压小；`order_effect.py` 就是量这个的。补法：改成区组化随机，每两块内各顺序出现一次。
3. **压缩可重放但不幂等。**输出段名取「当前最大号加一」，重命名前不检查目标是否存在，而 POSIX `rename` 遇同名是静默覆盖；也没有「重放收敛」计数器。补法：段名由输入段号集合导出，发布前查一次并单独计数，同时补一条「同一批输入合并两次」的测试。
4. **准入的许可在整批取走时归还，不是落盘之后。**`take_batch` 一次 `drain` 至多 256 条，所以未处理写的真实上界是 `admission_capacity + 256`。要钉在 `CAP` 得逐条扣还。
5. **`shutdown()` 丢弃排队中的写这条路径没有测试覆盖**（M4 行同）。
6. **端到端（每请求）延迟没有被采集**，当前只有批均摊的 `value_ns_per_op`。

## 明确不做什么

与正文 17.1.3 的六条一致：不做分层与 leveled 合并、不允许多进程共享同一份段文件、不用 `mmap` 代替一次读取、不做常驻压缩 worker 池、不做事务与隔离级别、不接跨机器与跨版本比较。

## 构建参数是结论的一部分

`Cargo.toml` 固定 `opt-level = 3`、`lto = false`、`codegen-units = 1`、`debug = 1`。换掉任何一项，上面的数字都要重测。
