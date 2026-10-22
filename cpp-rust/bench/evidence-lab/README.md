# evidence-lab：第13、14章的独立证据夹具

这是零第三方依赖的独立Cargo workspace，不是生产profiling或发布系统。
所有Rust业务路径均为安全Rust；未执行UB。

## 四项可运行benchmark

1. `src/bin/cpu_wait.rs`：相同1000000步计算，比较纯计算与额外申请40ms睡眠。每case21批，单位ms/batch。
2. `src/bin/instrumentation.rs`：None、Batch、Each三模式，各21批，单位ns/聚合step；不测日志持久化。
3. `src/bin/feature_work.rs`：default与checked两个产物，各21批，单位ns/聚合byte；checked增加事件屏障，不是安全开关。
4. `tools/build_matrix.py`：release/one/thin三profile，每profile21次新包目标目录与21次紧随的noop，共126条。`-j1`、无增量、预装std与暖OS缓存，不能称完全冷构建。

主正式集合共273条原始观察。`verify-*.txt`来自构建第0轮产物的额外可运行性校验，不进入主集合。

## 构建与测试

从本目录执行：

```bash
cargo fmt --check
cargo clippy --offline --locked --all-targets --all-features -- -D warnings
cargo clippy --offline --locked --all-targets -- -D warnings
cargo test --offline --locked
cargo test --offline --locked --all-features
RUSTDOCFLAGS='-D warnings' cargo doc --offline --locked --no-deps --all-features
python3 -m unittest discover -s tools -p 'test_*.py'
cargo build --offline --locked --release --bins
cargo build --offline --locked --release --features checked --bin feature_work --target-dir target-checked
```

`cargo test`在default/checked各运行5项单元测试和1项doctest。
Python门禁有3项测试，包括实际checked回退、缺失样本和错误checksum。
单元测试不把本机纳秒数写成通用阈值。

## 正式采集

在本仓库工作树内运行，需要macOS的`sample`、`size`、`sysctl`。
构建在锁外完成，正式运行与构建矩阵在共享目录锁内串行执行。

```bash
mkdir -p results
bash tools/measure.sh results/my-new-run
python3 tools/validate_run.py results/my-new-run
```

输出目录必须不存在；脚本拒绝覆盖。
锁路径固定为仓库`.work/cpp-rust-agents/measure.lock`，mkdir循环取得，EXIT trap释放。
不要绕过外层锁直接并行计时build_matrix。
脚本在采集前后记录相关进程名快照，不声称连续排除全部干扰。

`sample`另行启动五秒进程，延迟约0.3秒后请求两秒、1ms间隔的采样。
正式21批计时中没有附着profiler。
采样后才生成默认库的MIR、LLVM IR和本机汇编。
本轮另外保存了checked库的相同三类产物。
新运行若需要checked代码生成，可按`results/run-01/checked-codegen-command.txt`所对应的清单与选项执行，改用新输出目录。

## 本轮归档

`results/run-01/`包含：

- `environment.txt`：实际主机Apple M5 Pro，cacheline查询128，rustc1.99.0/LLVM23.1.1，Darwin信息。
- `source-sha256.txt`与`measured-source/`：计时前已有源码、脚本与清单的指纹及逐项匹配快照。run-01后只给采集脚本补充了后处理/自动归档；计时版本仍原样保留，Rust工作负载未更改。
- `postprocessing-source-sha256.txt`：测量后新增门禁、校验与聚合工具指纹。
- `binary-sha256.txt`与`binaries/`：四个正式运行二进制的指纹与副本。
- `cpu-wait.txt`、`instrumentation.txt`、`feature-{default,checked}.txt`：逐轮原始行与描述性统计。
- `build-raw.jsonl`：126条实际墙钟、字节数、SHA256与完整命令；`build-*.txt`保存Cargo详细日志。
- `build-summary.json`、`size-*.txt`：构建统计与Mach-O段数据。
- `sample-{cpu,wait}.txt`：原生sample报告；对应command和run文件保留。
- `cpu.folded`、`wait.folded`：以exclusive叶子权重转换的栈路径，不是Linux perf数据。
- `codegen/`与`checked-codegen/`：实际MIR、LLVM IR、原生`.s`。
- `gate-rejection.json`：checked相对default，20%描述性预算下的真实拒绝。
- `test-*.txt`、`clippy-*.txt`、`rustfmt-check.txt`、`rustdoc-check.txt`、`gate-tests.txt`与`mechanical-validation.txt`：执行记录。

`builds/`与两个codegen target目录在本机保留，但忽略为中间构建缓存；正式原始记录与生成代码不忽略。
统计使用算术均值、N-1标准差和nearest-rank p50/p99。
21条观察的p99就是最大观察；聚合ns/byte与ns/step不是请求延迟。

## 验证拒绝与聚合

```bash
python3 tools/gate.py results/run-01/feature-default.txt results/run-01/feature-checked.txt --budget .2
```

本轮预期退出1（有效但超预算），不是脚本故障；缺失/错误证据退出2。
门禁只检查轮次、单位、checksum与预算，不校验完整环境manifest，也不做显著性检验。

```bash
python3 tools/collapse_sample.py results/my-new-run/sample-cpu.txt results/my-new-run/cpu.folded
```

上条仅在folded文件不存在时运行；转换器拒绝覆盖。
它只支持本轮sample树形状，用exclusive计数避免父子重复统计。
保留原报告，不以折叠文本替代原始证据。

## 真实限制

- 新目标目录不是冷OS缓存，也没有重建std。
- feature版本按进程先后运行，未做跨二进制配对轮转。
- 只有两个时点的编译进程快照；无锁核、锁频、桌面隔离。
- 同profile的21个目标目录产物哈希各不相同，未归因所有字节差异，也未修复位级确定性。
- 本轮没有PGO、Linux perf、硬件PMU、Cachegrind、调度事件off-CPU、Miri或独立技术审计。
- 结果只适用于本轮桌面负载，不是生产SLA或通用优化保证。
