# ffi-bridge：Rust 整数数据组件与 C11 原生客户端

核心算法、分配、注册表、线程同步和错误隔离均在 Rust 中。C11 仅作为真实外部调用者、CLI 和跨边界 benchmark 驱动。无第三方 Cargo 依赖；64 位本机接口，不是网络协议。

## 构建与运行

```bash
cd cpp-rust/projects/ffi-bridge
cargo fmt --check
cargo clippy --offline --locked --all-targets --features test-hooks -- -D warnings
cargo test --offline --locked --features test-hooks
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -DRB_TEST_HOOKS=ON
cmake --build build --parallel 2
ctest --test-dir build --output-on-failure
./build/bridge_demo 42 8192
```

发布构建另用一个新目录并设置 `-DRB_TEST_HOOKS=OFF`，不导出故意 panic 的测试入口。Cargo 也可单独 `cargo build --offline --locked --release` 生成 staticlib/cdylib/rlib。CMake 实际链接 staticlib；本轮未验证动态库部署。不要用 `panic=abort` 期待收到 `RB_EPANIC`。

CLI 参数为 seed、word 数；输出版本、长度、模 2^64 的和。非法数字或过大长度返回非零。错误路径会释放已创建句柄。最大单对象 2^24 个 u64，最多4096槽；这不是4096份最大对象都能分配成功的保证，也不是进程总内存预算。

## 接口与生命周期

完整 ABI 契约在 `include/bridge.h`，Rust 安全算法入口在 `src/lib.rs`。

- `rb_mix` 与 `rb_transform`：逐元素或批量执行同一 wrapping 整数映射；输出与输入必须分离。
- `rb_create_copy`：复制 C 的输入；调用返回后 C 可立即修改/释放原输入。
- `rb_generate`：Rust 生成不可变数据并提交句柄；结果对象的消费责任交给调用者。
- `rb_info`：检查版本和结构尺寸后返回长度及 checksum；按值复制24字节元数据。
- `rb_copy`：整批复制到 C 的存储；容量不足不写数据和 written，不隐式释放句柄。
- `rb_release`：消耗一个注册表所有者；重复释放、旧代和不存在槽都返回 `RB_ESTALE`。

所有权转移指“句柄及释放责任交给 C”，**不指**把 malloc 指针交给 Rust 析构。没有 Rust 裸数据指针导出，也不接受 `Vec::from_raw_parts` 接管 C 分配。句柄副本不是新的所有者，不是跨进程标识或安全授权。

句柄高32位为代号，低32位为槽下标加一，0无效。空槽复用递增代号，达到 u32::MAX 的槽退休而不回绕。内部 `Mutex` 串行化查找/提交/释放；读取克隆 `Arc<[u64]>` 后在锁外计算。因此已取得快照的读取可在 release 返回后完成；release 不是等待所有读者的屏障。并发调用需各自独立的输出存储。

数值检查覆盖 null、对齐、长度上限、乘加溢出和参数区间重叠。它们**不能**证明任意非空地址有效。单分配、初始化、可读写、生命周期、无别名及无外部数据竞争仍是调用者义务。不要执行悬垂/越界/释放后读等 UB 来测试“错误返回”。测试的坏长度、容量、版本、旧句柄和对齐均在访问内存前被拒绝。

`catch_unwind` 围住每个可能失败的外部操作；正常错误用整数码，只有 unwind panic 映射为5。abort、OOM abort、信号、外部异常和已经发生的 UB 不在恢复承诺内。panic hook 仍可能输出。异常 payload 被有意遗忘以免其 Drop 再次 panic；极端情况下会泄漏该 payload。锁若 poison 则后续注册表操作返回6，不强行宣称恢复一致性。任何调用/句柄存活时都不得卸载库。

## 测试与证据

Rust：4项内部状态测试、6项导出契约测试；包括代号退休、槽上限、快照寿命、局部 poison、布局、空输入、容量失败不写、旧句柄、12线程争用释放及8读者与释放竞态。C：真实 C11 调用、独立整数参考、布局静态断言、错误清理、pthread并发读取、测试专用panic和后续健康调用。CTest 另检查 CLI 正常/错误输入。

```bash
mkdir -p evidence
bash tools/measure.sh evidence/my-new-run
python3 tools/summarize.py evidence/my-new-run/raw.csv
```

必须使用不存在的新归档目录。脚本保存环境、源码 SHA256、测试日志、原始 CSV、N-1 标准差/方差与 nearest-rank p50/p99、MIR、LLVM IR、本机 `.s`，另起进程采集 macOS `sample`。生成物目录已被本项目 `.gitignore` 排除，文本证据保留。正式计时持有章节间共享目录锁，用 EXIT trap 释放；不把 profiler 放入正式数据。该锁不控制系统其他进程。

每case独立预热至少500ms；每批64轮×8192词，每case21批，轮转起始case。第一组 `per_element` 对 `batch`；第二组 `copy_out` 对 `owned_handle`，都包含生成与释放。校验和在计时结束后与独立参考比较。报告的 ns/word 是批耗时除524288，不是请求延迟。四case共84条。没有冷启动、输入尺寸扫描、动态链接开销或多调用者吞吐测量。

已执行归档：`evidence/run-20261007-01/`。目录名是运行标识，不是采集时钟的权威；真实时钟见 `environment.txt` 与 `macos-sample.txt`（宿主报告2026-10-22）。可在 `summary.json` 查看完整精度。`interference.txt` 记录了其他代理的构建/脚本命令痕迹，没有观察到运行中的 rustc 子进程，不据此声称隔离。`clock_gettime` 原始观察表现出微秒量化，不把单位ns等同于纳秒分辨率。

本轮 mean ns/word：逐元素0.978652，批量0.211897，复制导出0.641505，句柄归约0.358854。这是 Apple M5 Pro 桌面固定源码的本地观测，不是SLA、显著性检验或所有FFI的普遍常数。批量路径在实际汇编中为四元素展开的标量运算；不能只凭 LLVM `vector.body` 名字宣称 SIMD。采样还观察到 `rb_generate` 的内存复制，因为 `Arc::from(Vec)` 在本轮产物中复制到引用计数存储；“没有复制到C”不等于“全流程零拷贝”。

## 有意保留的边界

没有 Linux perf、Miri、TSan、Loom、Windows、32位或跨进程验证。没有跨语言LTO、自动生成头文件或发布包安装规则。注册表最多4096槽且用线性空槽扫描，适合本项目的有界实例管理，不是无限规模的无锁句柄服务。生产系统应增加进程总内存准入、业务权限及卸载协调，再独立测试。技术章节见 `../../src/part4/ch16.md`。
