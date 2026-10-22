# compiler-lab：第4、5、6章证据说明

本包独立于 `bench/Cargo.toml`，不依赖第三方 crate。
六个正式二进制为 `move_cost`、`drop_paths`、`dispatch_grain`、`dispatch_visibility`、`vectorize`、`ctfe_table`。

## 当前采用的归档

- `results/stable-02/`：正文采用的正式运行。13个 case × 21批 = **273个正式观察**；所有批 checksum 通过。
- `results/stable-02-recalculated.json`：`verify.py`重新计算统计并独立重算预期 checksum 的结果。
- `results/extra-02/`：5项实际编译拒绝、布局探针、稳定版 O0/O3 MIR/LLVM/ASM、单态实例尺寸、ThinLTO、PGO训练/合并/使用。
- `results/stable-01/`：先行完整运行，另273个正式观察；保留不覆盖，不与第二轮择优拼表。
- `results/extra-01/`：准备过程中留下的 nightly 失败记录，不用作成功实验。

每次正式运行都分别保留六个二进制、源码指纹、编译 profile、环境、LLVM IR、MIR、本机汇编和产物指纹。
`sample-run.csv`为另一进程在profiler下的执行，其3×21批不进入正式表。
`macos-sample.txt`是真实macOS栈采样，不是Linux perf或PMU。
第二轮及当前脚本还对独立profiler运行取得同一测量锁，避免该计算与其他代理正式计时重叠。
第一轮使用的旧脚本已单独保存在`stable-01/run-used.sh`。

## 重跑

从本目录运行，输出目录必须不存在，父目录须存在：

```bash
cargo fmt --check
cargo clippy --offline --locked --all-targets -- -D warnings
cargo test --offline --locked
bash run.sh results/my-stable-run
python3 verify.py results/my-stable-run > results/my-recalculated.json
python3 extra.py results/my-extra-run
```

正式每case至少500ms预热，根据预热速度选择约10ms的批重复数。
21轮轮转case起点，不声称随机化或完全隔离桌面噪声。
mean、N-1样本sd、nearest-rank p50/p99均为归一化批均值统计。
其中p99等于21点最大值，**不是请求尾延迟**。

`run.sh`以`mkdir`获取仓库约定的全局测量目录锁，串行执行正式入口并用trap释放。
每个入口前记录cargo/rustc进程；第二轮没有发现这些活动构建进程。
这不证明其他桌面负载、核心迁移或频率变化不存在。

## 已执行的正确性检查

8项Cargo测试覆盖：求和与克隆同值；两种条件析构恰好两次；部分移动后受控panic展开；四种分派路径同值；0..129长度向量尾部与u64溢出；长度不符安全panic；256项CTFE表穷举；当前稳定版trait upcast。

5项编译拒绝分别检查E0382、E0381、E0502、E0080、E0038。
它们没有执行UB，`extra.py`核验非零退出状态和对应诊断代码。

ThinLTO及PGO-use实际执行16实例输出校验，聚合checksum均为95338125850705920。
匹配工具链的llvm-profdata为23.1.1-rust-1.99.0-stable。
PGO-use保留一条lang_start缺profile警告，未声称所有函数训练覆盖完整。
这些补充构建**没有正式速度样本**，仅报告功能与Mach-O `__text`尺寸。

## 未执行及限制

nightly名称虽列出，但`rustc +nightly -vV`报告缺manifest；没有用-Z或RUSTC_BOOTSTRAP伪造阶段转储。
HIR/THIR来自核读指南，不冒充本机dump。
没有运行Miri、TSan、Loom、Linux perf或跨架构执行。
CTFE成功不等于整个程序通过Miri。
没有浮点近似和完美哈希，字节表为完整精确域。

本章作者的结构核验不是独立技术审计，也不是全书母本覆盖完成声明。
