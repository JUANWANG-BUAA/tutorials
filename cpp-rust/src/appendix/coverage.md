# 母本逐节覆盖与范围裁决

16份母本，当前目录3356项；映射记录550条。
已知未裁决条目 **0**；目录仍待完善的母本 **0**。

**覆盖口径**：每个目录单元都有正文落点或有理由的范围排除；不等于逐字读完全部原书。
`review_depth`区分目录/摘段范围核对、正文抽页、完整节或完整页阅读。
按用户追加要求，C++语法/惯用法与ESP外设等非Rust主线内容可明确排除，但不能从台账删除。
PDF为一基物理页；EPUB为XHTML定位。抽页、全文提取、内容核读、来源映射与独立审计是不同事实。

**全部已登记目录单元的范围裁决闭合；无未登记裁决缺口。**
目录粒度、实际读页、索引限制与文本质量见各母本公开review证据；未知目录不冒充0缺口。

## 母本清单

|ID|文件|页/定位|目录项|已映射|范围排除|待裁决|
|:--|:--|:--|--:|--:|--:|--:|
|S01|A Tour of C++ (Bjarne Stroustrup) (z-library.sk, 1lib.sk, z-lib.sk).pdf|1032|163|6|157|0|
|S02|C++ Crash Course A Fast-Paced Introduction (Josh Lospinoso) (z-library.sk, 1lib.sk, z-lib.sk).pdf|794|579|2|577|0|
|S03|C++ 程序设计语言：第4部分 标准库（原书第4版 (Bjarne Stroustrup) (z-library.sk, 1lib.sk, z-lib.sk).pdf|371|280|1|279|0|
|S04|C++20高级编程(第5版)(上下册） ([比]马克·格雷戈勒（Marc Gregoire）) (z-library.sk, 1lib.sk, z-lib.sk).pdf|1012|51|1|50|0|
|S05|C++程序设计语言.第1～3部分.原书第4版 (Bjarne Stroustrup) (z-library.sk, 1lib.sk, z-lib.sk).pdf|750|614|15|599|0|
|S06|Effective C++ Effective C++ 改善程序与设计的55个具体做法 第3版 ([美] Scott Meyers  侯捷 译) (z-library.sk, 1lib.sk, z-lib.sk).pdf|327|77|8|69|0|
|S07|Effective Modern C++ 42 Specific Ways to Improve Your Use of C++11 and C++14 (Scott Meyers) (z-library.sk, 1lib.sk, z-lib.sk).pdf|334|81|13|68|0|
|S08|Effective Rust.pdf|261|44|32|12|0|
|S09|Guide to Rustc Development.pdf|368|139|96|43|0|
|S10|Rust 参考手册.pdf|376|108|74|34|0|
|S11|Rust 程序设计语言 简体中文版.pdf|545|106|43|63|0|
|S12|The Rust on ESP Book 简体中文版.pdf|50|86|16|70|0|
|S13|rust-book-zh-cn-shieber.pdf|412|183|18|165|0|
|S14|rustdoc 手册.pdf|61|140|86|54|0|
|S15|C语言程序设计：现代方法（第2版•修订版） (K.N.King) (z-library.sk, 1lib.sk, z-lib.sk).pdf|729|690|34|656|0|
|S16|CMake构建实战-项目开发卷 (许宏旭) (z-library.sk, 1lib.sk, z-lib.sk).epub|EPUB XHTML；无固定PDF页|15|5|10|0|

## 已核读与正文映射

|母本节|标题|页/版本|状态|本书落点|证据|
|:--|:--|:--|:--|:--|:--|
|S08/R17-A|第17条 数据竞争、Mutex与共享生命周期|PDF146–155|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`bench/src/slot.rs`|
|S08/R17-B|第17条 死锁、状态一致性、建议|PDF156–160|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.8](../part2/ch07.md#sec-cpp-rust.2.7.8)|`src/part2/ch07.md`|
|S11/BOOK-THREAD|16.1 线程与join|PDF383–384|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.5](../part2/ch07.md#sec-cpp-rust.2.7.5)|`bench/src/bin/atomic_contention.rs`|
|S11/BOOK-SHARED|16.3 共享状态并发|PDF396–401|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.6](../part2/ch07.md#sec-cpp-rust.2.7.6)|`bench/src/slot.rs`|
|S11/BOOK-SEND|16.4 Sync与Send|PDF403–404|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`bench/src/slot.rs`|
|S10/REF-MM|内存模型（历史说明）|PDF334|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`src/part2/ch07.md`|
|S10/REF-ASYNC-FN|异步函数|PDF75|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`bench/results/local/future-layout.mir`|
|S10/REF-ASYNC-BLOCK|async块|PDF166–168|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`bench/examples/future_layout.rs`|
|S10/REF-AWAIT|等待表达式|PDF215–216|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.4](../part2/ch08.md#sec-cpp-rust.2.8.4)|`bench/results/local/future-layout.mir`|
|S09/DEV-MOVE|MIR borrow check / initialization / moves|PDF277–279|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`bench/results/local/future-layout.mir`|
|S09/DEV-MONO|Monomorphization / lowering|PDF319–321|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`bench/results/local/future-layout.mir`|
|atomic/STD-ATOMICS|Memory model / Portability|在线1.99.1|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.2](../part2/ch07.md#sec-cpp-rust.2.7.2)|`bench/probes/atomics.rs`|
|future/STD-FUTURE|poll / Runtime characteristics|在线1.99.1|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.4](../part2/ch08.md#sec-cpp-rust.2.8.4)|`bench/src/park.rs`|
|wake/STD-WAKE|Memory Ordering / example limitations|在线1.99.1|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.5](../part2/ch08.md#sec-cpp-rust.2.8.5)|`bench/src/park.rs`|
|stanford-thread-notes/STANFORD-THREAD|Multithreading Practice（完整讲义）|Winter2022 lecture13|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.8](../part2/ch07.md#sec-cpp-rust.2.7.8)|`src/part2/ch07.md`|
|mit-lock-notes/MIT-LOCK|Lecture10 Locking（完整讲义）|Fall2020|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.8](../part2/ch07.md#sec-cpp-rust.2.7.8)|`src/part2/ch07.md`|
|rcore-lock/RCORE-LOCK|评价锁指标 / 忙等 / yield / 阻塞|chapter8/2lock.html指定节|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.8](../part2/ch07.md#sec-cpp-rust.2.7.8)|`src/part2/ch07.md`|
|S11/BOOK-CHANNEL|16.2 消息传递、所有权转移与关闭|PDF390–394|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.7](../part3/ch09.md#sec-cpp-rust.3.9.7)|`bench/runtime-lab/tests/contracts.rs`|
|tokio-runtime/TOKIO-FAIR|Detailed runtime behavior：公平性与前提|在线精确1.54.0|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.8](../part3/ch09.md#sec-cpp-rust.3.9.8)|`bench/runtime-lab/src/bin/scheduling.rs`|
|tokio-runtime/TOKIO-QUEUES|Current-thread / Multi-threaded runtime|在线精确1.54.0|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.3](../part3/ch09.md#sec-cpp-rust.3.9.3)|`sources/runtime-code.json`|
|tokio-state-code/TOKIO-STATE|运行、空闲、通知与取消状态转换|src/runtime/task/state.rs:1–374|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.2](../part3/ch09.md#sec-cpp-rust.3.9.2)|`sources/runtime-code.json`|
|tokio-ct-code/TOKIO-CT|park_yield / park_internal|src/runtime/scheduler/current_thread/mod.rs:446–477|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.5](../part3/ch09.md#sec-cpp-rust.3.9.5)|`bench/results/runtime-local/scheduling-sample.txt`|
|tokio-blocking/TOKIO-BLOCK|阻塞工作、并发上限、取消与shutdown|在线精确1.54.0|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.7](../part3/ch09.md#sec-cpp-rust.3.9.7)|`bench/runtime-lab/tests/contracts.rs`|
|mit-scheduling/MIT-SWITCH|Lecture11 Thread switching（完整讲义）|Fall2020|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.8](../part3/ch09.md#sec-cpp-rust.3.9.8)|`src/part3/ch09.md`|
|stanford-process-slides/STANFORD-FORK|多线程fork、Command与清理责任|PDF15–20、25–35，共36物理页|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.1](../part3/ch10.md#sec-cpp-rust.3.10.1)|`src/part3/ch10.md`|
|std-child/STD-CHILD|Drop、zombie警告与端点take|在线精确1.99.0|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.7](../part3/ch10.md#sec-cpp-rust.3.10.7)|`bench/runtime-lab/src/process.rs`|
|tokio-process/TOKIO-PROCESS|并发输入输出、Dropping/Cancellation、Unix Processes|在线精确1.54.0|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.5](../part3/ch10.md#sec-cpp-rust.3.10.5)|`bench/runtime-lab/src/process.rs`|
|tokio-runtime/TOKIO-FORK|Unix fork限制|在线精确1.54.0|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.1](../part3/ch10.md#sec-cpp-rust.3.10.1)|`src/part3/ch10.md`|
|S11/BOOK-CHANNEL-IPC|16.2 所有权传递与跨进程编码的区别|PDF390–394|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.3](../part3/ch10.md#sec-cpp-rust.3.10.3)|`bench/runtime-lab/src/wire.rs`|
|S09/COMPILER-S09-001|查询：需求驱动的编译；查询求值模型|[94, 95, 96, 97, 98, 99, 100, 101, 102]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`bench/compiler-lab/src/lib.rs`|
|S09/COMPILER-S09-002|HIR、Lowering、MIR、HAIR与MIR构建、MIR passes|[164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`bench/compiler-lab/probes/stages.rs`|
|S09/COMPILER-S09-003|Tracking moves and initialization; Move paths|[278, 279, 280, 281]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`bench/compiler-lab/src/bin/move_cost.rs`|
|S09/COMPILER-S09-004|MIR optimizations; Constant Evaluation|[312, 313, 314, 315, 316, 317, 318, 319]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`bench/compiler-lab/src/bin/drop_paths.rs`|
|S08/COMPILER-S08-005|Item11：为RAII模式实现Drop trait|[93, 94, 95, 96]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`bench/compiler-lab/src/bin/drop_paths.rs`|
|S08/COMPILER-S08-006|Item15：理解借用检查器（访问、replace、借用规则）|[126, 127, 128, 129, 130]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`bench/compiler-lab/src/bin/move_cost.rs`|
|S10/COMPILER-S10-007|析构函数、销毁作用域、临时作用域与常量提升|[294, 295, 296, 297, 298, 299]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`bench/compiler-lab/src/bin/drop_paths.rs`|
|S08/COMPILER-S08-008|Item12：理解泛型和trait对象之间的权衡；含Rust1.70历史限制|[97, 98, 99, 100, 101, 102, 103, 104, 105]|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`bench/compiler-lab/src/bin/dispatch_grain.rs`|
|S09/COMPILER-S09-009|Monomorphization; Collection; Lowering to Codegen IR; Code generation|[319, 320, 321, 322]|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`bench/compiler-lab/probes/code_size.rs`|
|S10/COMPILER-S10-010|trait对象及生命周期约束|[259, 260, 261]|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`bench/compiler-lab/src/bin/dispatch_visibility.rs`|
|S10/COMPILER-S10-011|代码生成属性：inline、target_feature、target-cpu|[140, 141, 142, 143]|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.4](../part2/ch05.md#sec-cpp-rust.2.5.4)|`bench/compiler-lab/src/bin/dispatch_grain.rs`|
|S09/COMPILER-S09-012|MIR optimizations; Constant Evaluation; Miri; codegen|[312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322]|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`bench/compiler-lab/src/bin/ctfe_table.rs`|
|S09/COMPILER-S09-013|How is PGO implemented in rustc? Overall Workflow; Testing PGO|[341, 342, 343]|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.8](../part2/ch06.md#sec-cpp-rust.2.6.8)|`src/part2/ch06.md`|
|S10/COMPILER-S10-014|代码生成属性及优化提示|[140, 141, 142, 143]|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.7](../part2/ch06.md#sec-cpp-rust.2.6.7)|`bench/compiler-lab/src/bin/vectorize.rs`|
|S10/COMPILER-S10-015|常量求值、常量上下文与常量函数；ABI属性开篇|[349, 350, 351, 352, 353]|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`bench/compiler-lab/src/bin/ctfe_table.rs`|
|S08/COMPILER-S08-016|Item15：别名限制与优化（前五页）|[126, 127, 128, 129, 130]|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.2](../part2/ch06.md#sec-cpp-rust.2.6.2)|`bench/compiler-lab/src/bin/vectorize.rs`|
|compiler-web-thir/compiler-web-thir|main article, excluding navigation|[]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`src/part1/ch04.md`|
|compiler-web-drop-elaboration/compiler-web-drop-elaboration|main article, excluding navigation|[]|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`bench/compiler-lab/src/bin/drop_paths.rs`|
|compiler-web-aliasing/compiler-web-aliasing|main article, excluding navigation|[]|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.2](../part2/ch06.md#sec-cpp-rust.2.6.2)|`bench/compiler-lab/src/bin/vectorize.rs`|
|EVID-rustc-pgo/compiler-web-pgo|main article, excluding navigation|[]|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.8](../part2/ch06.md#sec-cpp-rust.2.6.8)|`src/part2/ch06.md`|
|S09/EVIDENCE-S09-001|Profiling with perf：采集范围、依赖构建边界、incremental与调用栈匹配|PDF 64–67（一基物理页）|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.3](../part4/ch13.md#sec-cpp-rust.4.13.3)|`bench/evidence-lab/results/run-01/sample-cpu.txt`|
|S09/EVIDENCE-S09-002|Profiling with perf：限定构建工作量与禁用增量的实验责任|PDF 64–67（一基物理页）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`bench/evidence-lab/tools/build_matrix.py`|
|S11/EVIDENCE-S11-003|采用发布配置自定义构建：dev/release和opt-level覆盖|PDF 320（一基物理页）|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.8](../part4/ch13.md#sec-cpp-rust.4.13.8)|`bench/evidence-lab/Cargo.toml`|
|S11/EVIDENCE-S11-004|采用发布配置自定义构建：profile的身份和优化边界|PDF 320（一基物理页）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`bench/evidence-lab/Cargo.toml`|
|S11/EVIDENCE-S11-005|Cargo工作空间：共享target/lock、显式包依赖与包选择测试；旧版示例不外推唯一构建单元|PDF 332–336（一基物理页）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`bench/evidence-lab/results/run-01/metadata.json`|
|S14/EVIDENCE-S14-006|如何写文档：完整可运行示例、公共契约、panic和错误处理|PDF 6–8、11–12（一基物理页）|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.6](../part4/ch13.md#sec-cpp-rust.4.13.6)|`bench/evidence-lab/src/lib.rs`|
|S14/EVIDENCE-S14-007|基本使用、Cargo整合、输出导航、写作与命令参数；只采用当前工具链接受的检查|PDF 1–15（一基物理页）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.8](../part4/ch14.md#sec-cpp-rust.4.14.8)|`bench/evidence-lab/results/run-01/rustdoc-check.txt`|
|EVID-cargo-features/EVID-cargo-features|Features全文：default、可选依赖、feature统一、resolver2和组合测试|HTML（无固定页码）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`bench/evidence-lab/results/run-01/feature-tree.txt`|
|EVID-cargo-profiles/EVIDENCE-EVID-cargo-profiles-009|Profiles全文：CGU、incremental、lto=false/off、profile覆盖和泛型实例化|HTML（无固定页码）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`bench/evidence-lab/results/run-01/build-summary.json`|
|EVID-cargo-profiles/EVIDENCE-EVID-cargo-profiles-010|Profiles：debug与真实产物、优化模式边界|HTML（无固定页码）|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.2](../part4/ch13.md#sec-cpp-rust.4.13.2)|`bench/evidence-lab/results/run-01/environment.txt`|
|EVID-rustc-pgo/EVID-rustc-pgo|Profile-guided Optimization全文：四阶段、Cargo target隔离、绝对路径与missing-function警告；本轮未执行PGO|HTML（无固定页码）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.6](../part4/ch14.md#sec-cpp-rust.4.14.6)|`src/part4/ch14.md`|
|EVID-cachegrind/EVID-cachegrind|Overview、5.2.1–5.2.8与5.8.1–5.8.3：计数、内联归因与模拟限制；本轮未执行Cachegrind|HTML（无固定页码）|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.7](../part4/ch13.md#sec-cpp-rust.4.13.7)|`src/part4/ch13.md`|
|EVID-perf-event/EVID-perf-event|read_format、time_enabled/time_running、precise_ip与read返回布局：复用估计和skid；本轮未执行perf|HTML（无固定页码）|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.3](../part4/ch13.md#sec-cpp-rust.4.13.3)|`src/part4/ch13.md`|
|EVID-cargo-resolver/EVID-cargo-resolver|Rust version与Resolver versions：resolver3的fallback默认和workspace边界|HTML（无固定页码）|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`bench/evidence-lab/Cargo.toml`|
|S11/FFI-PROJECT-S11-001|19.1 不安全Rust：裸指针、初始化和别名义务|PDF 455–456（一基物理页）|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`projects/ffi-bridge/src/lib.rs`|
|S11/FFI-PROJECT-S11-002|19.1 不安全函数、安全抽象与from_raw_parts的有效性前提|PDF 457–459（一基物理页）|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`projects/ffi-bridge/tests/contracts.rs`|
|S11/FFI-PROJECT-S11-003|19.1 extern及通过其他语言调用Rust函数|PDF 459–460（一基物理页）|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.2](../part4/ch16.md#sec-cpp-rust.4.16.2)|`projects/ffi-bridge/include/bridge.h`|
|S11/FFI-PROJECT-S11-004|19.1 共享静态状态与不安全trait的线程安全责任|PDF 460–461（一基物理页）|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.4](../part4/ch16.md#sec-cpp-rust.4.16.4)|`projects/ffi-bridge/src/lib.rs`|
|FFI-CATCH/FFI-CATCH|catch_unwind主体及Notes：unwind边界、panic hook、payload析构风险|HTML：主体和Notes（无固定页码）|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.5](../part4/ch16.md#sec-cpp-rust.4.16.5)|`projects/ffi-bridge/src/lib.rs`|
|FFI-SLICE/FFI-SLICE|Safety和Caveat：单分配、初始化、长度界限、空指针与推断寿命|HTML：Safety、Caveat及FFI空指针示例（无固定页码）|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`projects/ffi-bridge/tests/contracts.rs`|
|FFI-REPR/FFI-REPR|The C representation：repr(C)结构的对齐、字段偏移与整体尺寸算法|HTML：repr(C) Structs（无固定页码）|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.2](../part4/ch16.md#sec-cpp-rust.4.16.2)|`projects/ffi-bridge/include/bridge.h`|
|S08/FOUNDATIONS-S08-001|第30条：单元、集成、文档测试与基准的优化风险|PDF 227–233（一基物理页）|核读映射|[part1/ch01.md#sec-cpp-rust.1.1.3](../part1/ch01.md#sec-cpp-rust.1.1.3)|`bench/foundations-lab/src/bin/dce.rs`|
|S08/FOUNDATIONS-S08-002|第30条：基准、black_box与观察机器码|PDF 229–231（一基物理页）|核读映射|[part1/ch01.md#sec-cpp-rust.1.1.5](../part1/ch01.md#sec-cpp-rust.1.1.5)|`bench/foundations-lab/results/native-01/codegen/foundations_lab-29c064615efbeca4.s`|
|S08/FOUNDATIONS-S08-003|第30条：回归测试与配置覆盖建议|PDF 233（一基物理页）|核读映射|[part1/ch01.md#sec-cpp-rust.1.1.7](../part1/ch01.md#sec-cpp-rust.1.1.7)|`bench/foundations-lab/gate.py`|
|S11/FOUNDATIONS-S11-004|13.4 性能对比：循环VS迭代器|PDF 314–315（一基物理页）|核读映射|[part1/ch01.md#sec-cpp-rust.1.1.6](../part1/ch01.md#sec-cpp-rust.1.1.6)|`bench/foundations-lab/src/bin/paired.rs`|
|S10/FOUNDATIONS-S10-005|类型布局：尺寸、对齐、数组与指针、表示形式|PDF 267–270（一基物理页）|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`bench/foundations-lab/examples/layout.rs`|
|S10/FOUNDATIONS-S10-006|类型布局：repr(C)结构算法与溢出警告|PDF 271–272（一基物理页）|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.8](../part1/ch02.md#sec-cpp-rust.1.2.8)|`bench/foundations-lab/examples/storage_plan.rs`|
|S10/FOUNDATIONS-S10-007|未定义行为：非法值与引用有效性|PDF 344–345（一基物理页）|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2)|`bench/foundations-lab/examples/layout.rs`|
|S08/FOUNDATIONS-S08-008|第20条末：复制可见性、可用性与共享所有权|PDF 174–175（一基物理页）|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.6](../part1/ch02.md#sec-cpp-rust.1.2.6)|`bench/foundations-lab/src/lib.rs`|
|S11/FOUNDATIONS-S11-009|4.1 什么是所有权：移动、克隆与函数转移|PDF 73–81（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`bench/foundations-lab/src/lib.rs`|
|S11/FOUNDATIONS-S11-010|4.2 引用与借用：可变性、独占与悬垂|PDF 83–87（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`bench/foundations-lab/src/lib.rs`|
|S11/FOUNDATIONS-S11-011|15.3 Drop Trait与std::mem::drop|PDF 356–358（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`bench/foundations-lab/tests/contracts_more.rs`|
|S10/FOUNDATIONS-S10-012|析构函数：初始化、部分移动、字段销毁顺序|PDF 294–295（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`bench/foundations-lab/src/lib.rs`|
|S10/FOUNDATIONS-S10-013|销毁作用域与临时值：旧版本规则的适用边界|PDF 296–297（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`src/part1/ch03.md`|
|S10/FOUNDATIONS-S10-014|非安全块及未定义行为责任|PDF 343–345（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.7](../part1/ch03.md#sec-cpp-rust.1.3.7)|`bench/foundations-lab/src/lib.rs`|
|S10/FOUNDATIONS-S10-015|不被认为是非安全的行为：泄漏、无析构退出与溢出|PDF 347（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`src/part1/ch03.md`|
|S08/FOUNDATIONS-S08-016|第20条末：不要为了消除复制牺牲接口可用性|PDF 174–175（一基物理页）|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.5](../part1/ch03.md#sec-cpp-rust.1.3.5)|`bench/foundations-lab/src/bin/borrow.rs`|
|FOUNDATIONS-PTR/FOUNDATIONS-PTR|Safety; Alignment; Pointer to reference conversion; Allocation; Provenance; Pointers Vs Integers; Strict Provenance; Using Strict Provenance; Exposed Provenance|HTML具名节；无固定页码|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.7](../part1/ch03.md#sec-cpp-rust.1.3.7)|`src/part1/ch03.md`|
|FOUNDATIONS-OPTION/FOUNDATIONS-OPTION|Representation段及类型/条件表；非全篇API审计|HTML具名节；无固定页码|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2)|`src/part1/ch02.md`|
|FOUNDATIONS-BLACK_BOX/FOUNDATIONS-BLACK_BOX|完整Expand description、When is this useful、How to use this与全部示例|HTML具名节；无固定页码|核读映射|[part1/ch01.md#sec-cpp-rust.1.1.3](../part1/ch01.md#sec-cpp-rust.1.1.3)|`src/part1/ch01.md`|
|S11/RUNTIME-PROJECT-S11-001|16.2 使用消息传递在线程间传送数据：通道关闭、所有权转移与多个生产者|PDF 390–394（一基物理页）|核读映射|[part4/ch15.md#sec-cpp-rust.4.15.2](../part4/ch15.md#sec-cpp-rust.4.15.2)|`projects/agent-runtime/tests/contracts.rs`|
|S01/NAT-S01-0016|1.7 Pointers, Arrays, and References|PDF 35|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S01.md#review-s01-u0016`|
|S01/NAT-S01-0050|6.3 Resource Management|PDF 130|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S01.md#review-s01-u0050`|
|S01/NAT-S01-0115|15 Pointers and Containers|PDF 297|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S01.md#review-s01-u0115`|
|S01/NAT-S01-0117|15.2 Pointers|PDF 298|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S01.md#review-s01-u0117`|
|S01/NAT-S01-0142|18 Concurrency|PDF 358|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S01.md#review-s01-u0142`|
|S01/NAT-S01-0144|18.2 Tasks and threads|PDF 360|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S01.md#review-s01-u0144`|
|S02/NAT-S02-0294|11: Smart Pointers|PDF 399|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S02.md#review-s02-u0294`|
|S02/NAT-S02-0513|19: Concurrency and Parallelism|PDF 697|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S02.md#review-s02-u0513`|
|S03/NAT-S03-0222|第41章  并发|PDF 297|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S03.md#review-s03-u0222`|
|S04/NAT-S04-0032|第19章:函数指针，函数对象，lambda表达式|PDF 606|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S04.md#review-s04-u0032`|
|S05/NAT-S05-0091|第5章 C++概览：并发与实用功能|PDF 119|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S05.md#review-s05-u0091`|
|S05/NAT-S05-0093|5.2 资源管理|PDF 119|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0093`|
|S05/NAT-S05-0095|5.3 并发|PDF 122|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S05.md#review-s05-u0095`|
|S05/NAT-S05-0139|第7章 指针、数组与引用|PDF 171|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0139`|
|S05/NAT-S05-0141|7.2 指针|PDF 171|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0141`|
|S05/NAT-S05-0144|7.3 数组|PDF 173|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0144`|
|S05/NAT-S05-0147|7.4 数组中的指针|PDF 178|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0147`|
|S05/NAT-S05-0151|7.5 指针与const|PDF 184|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0151`|
|S05/NAT-S05-0152|7.6 指针与所有权|PDF 186|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0152`|
|S05/NAT-S05-0271|12.5 函数指针|PDF 311|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0271`|
|S05/NAT-S05-0287|13.3 资源管理|PDF 330|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0287`|
|S05/NAT-S05-0325|15.2 链接|PDF 386|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S05.md#review-s05-u0325`|
|S05/NAT-S05-0365|17.2 构造函数和析构函数|PDF 438|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0365`|
|S05/NAT-S05-0448|20.6 成员指针|PDF 543|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0448`|
|S05/NAT-S05-0478|22.4 构造和析构|PDF 584|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0478`|
|S06/NAT-S06-0015|2．构造／析构／赋值运算|PDF 63|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0015`|
|S06/NAT-S06-0018|条款07：为多态基类声明virtual析构函数|PDF 69|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0018`|
|S06/NAT-S06-0019|条款08：别让异常逃离析构函数|PDF 73|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0019`|
|S06/NAT-S06-0020|条款09：绝不在构造和析构过程中调用virtual函数|PDF 77|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0020`|
|S06/NAT-S06-0024|3．资源管理|PDF 90|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0024`|
|S06/NAT-S06-0026|条款14：在资源管理类中小心copying行为|PDF 95|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0026`|
|S06/NAT-S06-0027|条款15：在资源管理类中提供对原始资源的访问|PDF 98|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0027`|
|S06/NAT-S06-0029|条款17：以独立语句将newed对象置入智能指针|PDF 104|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S06.md#review-s06-u0029`|
|S07/NAT-S07-0036|Item 16: Make const member functions thread safe.|PDF 121|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0036`|
|S07/NAT-S07-0038|Chapter 4. Smart Pointers|PDF 135|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S07.md#review-s07-u0038`|
|S07/NAT-S07-0039|Item 18: Use std::unique_ptr for exclusive-ownership resource management.|PDF 136|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0039`|
|S07/NAT-S07-0040|Item 19: Use std::shared_ptr for shared-ownership resource management.|PDF 143|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0040`|
|S07/NAT-S07-0041|Item 20: Use std::weak_ptr for std::shared_ptr-like pointers that can dangle.|PDF 152|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S07.md#review-s07-u0041`|
|S07/NAT-S07-0044|Chapter 5. Rvalue References, Move Semantics, and Perfect Forwarding|PDF 175|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0044`|
|S07/NAT-S07-0046|Item 24: Distinguish universal references from rvalue references.|PDF 182|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0046`|
|S07/NAT-S07-0047|Item 25: Use std::move on rvalue references, std::forward on universal references.|PDF 186|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0047`|
|S07/NAT-S07-0070|Chapter 7. The Concurrency API|PDF 259|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0070`|
|S07/NAT-S07-0071|Item 35: Prefer task-based programming to thread-based.|PDF 259|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0071`|
|S07/NAT-S07-0073|Item 37: Make std::threads unjoinable on all paths.|PDF 268|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0073`|
|S07/NAT-S07-0074|Item 38: Be aware of varying thread handle destructor behavior.|PDF 276|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0074`|
|S07/NAT-S07-0076|Item 40: Use std::atomic for concurrency, volatile for special memory.|PDF 289|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0076`|
|S15/NAT-S15-0134|第8章　数组|PDF 145|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0134`|
|S15/NAT-S15-0135|8.1　一维数组|PDF 145|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0135`|
|S15/NAT-S15-0140|8.2　多维数组|PDF 151|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0140`|
|S15/NAT-S15-0143|8.3　C99中的变长数组|PDF 155|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0143`|
|S15/NAT-S15-0176|10.5　构建C程序|PDF 200|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S15.md#review-s15-u0176`|
|S15/NAT-S15-0180|第11章　指针|PDF 209|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0180`|
|S15/NAT-S15-0181|11.1　指针变量|PDF 209|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0181`|
|S15/NAT-S15-0186|11.3　指针赋值|PDF 212|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0186`|
|S15/NAT-S15-0187|11.4　指针作为参数|PDF 213|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0187`|
|S15/NAT-S15-0189|11.5　指针作为返回值|PDF 216|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0189`|
|S15/NAT-S15-0193|第12章　指针和数组|PDF 222|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0193`|
|S15/NAT-S15-0194|12.1　指针的算术运算|PDF 222|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0194`|
|S15/NAT-S15-0200|12.2　指针用于数组处理|PDF 225|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0200`|
|S15/NAT-S15-0202|12.3　用数组名作为指针|PDF 227|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0202`|
|S15/NAT-S15-0205|12.4　指针和多维数组|PDF 230|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0205`|
|S15/NAT-S15-0210|12.5　C99中的指针和变长数组|PDF 232|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0210`|
|S15/NAT-S15-0237|13.7　字符串数组|PDF 256|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0237`|
|S15/NAT-S15-0282|15.4　构建多文件程序|PDF 306|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S15.md#review-s15-u0282`|
|S15/NAT-S15-0302|16.3　嵌套的数组和结构|PDF 322|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0302`|
|S15/NAT-S15-0318|第17章　指针的高级应用|PDF 345|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0318`|
|S15/NAT-S15-0326|17.3　动态分配数组|PDF 350|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0326`|
|S15/NAT-S15-0341|17.6　指向指针的指针|PDF 365|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0341`|
|S15/NAT-S15-0342|17.7　指向函数的指针|PDF 366|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0342`|
|S15/NAT-S15-0347|17.9　弹性数组成员|PDF 372|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0347`|
|S15/NAT-S15-0411|20.4　对象的对齐|PDF 431|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S15.md#review-s15-u0411`|
|S15/NAT-S15-0426|21.7　&lt;stdalign.h&gt;:地址的对齐|PDF 441|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S15.md#review-s15-u0426`|
|S15/NAT-S15-0612|第28章　C1X新增的多线程和原子操作支持|PDF 597|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0612`|
|S15/NAT-S15-0613|28.1　&lt;threads.h&gt;：多线程执行支持|PDF 598|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0613`|
|S15/NAT-S15-0625|28.2　_Atomic、&lt;stdatomic.h&gt;：原子类型和原子操作支持|PDF 620|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0625`|
|S15/NAT-S15-0650|第28章　C1X新增的多线程和原子操作支持|PDF 644|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0650`|
|S15/NAT-S15-0657|第8章　数组|PDF 646|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0657`|
|S15/NAT-S15-0661|第17章　指针的高级应用|PDF 647|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0661`|
|S15/NAT-S15-0676|第12章　指针和数组|PDF 650|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0676`|
|S15/NAT-S15-0680|第17章　指针的高级应用|PDF 651|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0680`|
|S16/NAT-S16-0005|第1章 构建之旅|None|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0005`|
|S16/NAT-S16-0006|第2章 CMake简介|None|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0006`|
|S16/NAT-S16-0009|第5章 实践：CMake快速排序|None|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0009`|
|S16/NAT-S16-0010|第6章 CMake构建初探|None|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0010`|
|S16/NAT-S16-0011|第7章 构建目标和属性|None|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0011`|
|S11/SRB-S11-066|unit-066: Drop Trait 运行清理代码|[356, 357, 358]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.2](../part3/ch09.md#sec-cpp-rust.3.9.2)|`sources/reviews/S11.md`|
|S11/SRB-S11-071|unit-071: 线程|[383, 384, 385, 386, 387, 388]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.8](../part3/ch09.md#sec-cpp-rust.3.9.8)|`sources/reviews/S11.md`|
|S11/SRB-S11-072|unit-072: 消息传递|[390, 391, 392, 393, 394]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.7](../part3/ch09.md#sec-cpp-rust.3.9.7)|`sources/reviews/S11.md`|
|S11/SRB-S11-073|unit-073: 共享状态|[396, 397, 398, 399, 400, 401]|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S11.md`|
|S11/SRB-S11-074|unit-074: 可扩展的并发：Sync 与 Send|[403, 404]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.3](../part3/ch09.md#sec-cpp-rust.3.9.3)|`sources/reviews/S11.md`|
|S11/SRB-S11-077|unit-077: 为使用不同类型的值而设计的 trait 对象|[411, 412, 413, 414, 415, 416]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S11.md`|
|S11/SRB-S11-091|unit-091: 将单线程 server 变为多线程 server|[501, 502, 503]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.6](../part3/ch09.md#sec-cpp-rust.3.9.6)|`sources/reviews/S11.md`|
|S11/SRB-S11-092|unit-092: 优雅停机与清理|[518, 519, 520, 521, 522, 523, 524, 525, 526]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.8](../part3/ch09.md#sec-cpp-rust.3.9.8)|`sources/reviews/S11.md`|
|S13/SRB-S13-058|unit-058: Rust 实现队列|[109, 110, 111, 112]|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.7](../part3/ch09.md#sec-cpp-rust.3.9.7)|`sources/reviews/S13.md`|
|S11/SRB-S11-U014|什么是所有权？|PDF 72|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u014`|
|S11/SRB-S11-U015|引用与借用|PDF 82|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u015`|
|S11/SRB-S11-U016|Slices|PDF 88|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u016`|
|S11/SRB-S11-U030|vector|PDF 157|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u030`|
|S11/SRB-S11-U031|字符串|PDF 162|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u031`|
|S11/SRB-S11-U032|哈希 map|PDF 169|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u032`|
|S11/SRB-S11-U034|panic! 与不可恢复的错误|PDF 177|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u034`|
|S11/SRB-S11-U035|Result 与可恢复的错误|PDF 181|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u035`|
|S11/SRB-S11-U036|panic! 还是不 panic!|PDF 188|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u036`|
|S11/SRB-S11-U038|泛型数据类型|PDF 198|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u038`|
|S11/SRB-S11-U039|trait：定义共享的行为|PDF 205|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u039`|
|S11/SRB-S11-U040|生命周期与引用有效性|PDF 213|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u040`|
|S11/SRB-S11-U042|编写测试|PDF 227|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u042`|
|S11/SRB-S11-U043|运行测试|PDF 239|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u043`|
|S11/SRB-S11-U044|测试的组织结构|PDF 245|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u044`|
|S11/SRB-S11-U048|重构以改进模块化与错误处理|PDF 260|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u048`|
|S11/SRB-S11-U049|采用测试驱动开发完善库的功能|PDF 270|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u049`|
|S11/SRB-S11-U051|将错误信息输出到标准错误而不是标准输出|PDF 282|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.1](../part3/ch10.md#sec-cpp-rust.3.10.1)|`sources/reviews/S11.md#review-s11-u051`|
|S11/SRB-S11-U053|闭包：可以捕获其环境的匿名函数|PDF 288|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u053`|
|S11/SRB-S11-U054|使用迭代器处理元素序列|PDF 300|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u054`|
|S11/SRB-S11-U055|改进之前的 I/O 项目|PDF 308|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u055`|
|S11/SRB-S11-U056|性能比较：循环对迭代器|PDF 313|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u056`|
|S11/SRB-S11-U058|采用发布配置自定义构建|PDF 319|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u058`|
|S11/SRB-S11-U059|将 crate 发布到 Crates.io|PDF 322|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u059`|
|S11/SRB-S11-U060|Cargo 工作空间|PDF 331|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u060`|
|S11/SRB-S11-U064|Box 指向堆上数据，并且可确定大小|PDF 344|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u064`|
|S11/SRB-S11-U065|通过 Deref trait 将智能指针当作常规引用处理|PDF 349|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u065`|
|S11/SRB-S11-U067|Rc 引用计数智能指针|PDF 359|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u067`|
|S11/SRB-S11-U068|RefCell 与内部可变性模式|PDF 363|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u068`|
|S11/SRB-S11-U069|引用循环与内存泄漏是安全的|PDF 371|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u069`|
|S11/SRB-S11-U084|不安全的 Rust|PDF 454|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u084`|
|S11/SRB-S11-U085|高级生命周期|PDF 462|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u085`|
|S11/SRB-S11-U086|高级 trait|PDF 469|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u086`|
|S11/SRB-S11-U087|高级类型|PDF 479|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u087`|
|S11/SRB-S11-U088|高级函数与闭包|PDF 485|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u088`|
|S12/SRB-S12-U009|开发方式总览|PDF 4|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u009`|
|S12/SRB-S12-U012|使用标准库（std）|PDF 6|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u012`|
|S12/SRB-S12-U015|何时适合使用标准库（std）|PDF 6|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u015`|
|S12/SRB-S12-U016|使用核心库（no_std）|PDF 8|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u016`|
|S12/SRB-S12-U019|何时适合使用核心库（no_std）|PDF 9|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u019`|
|S12/SRB-S12-U022|仅针对 RISC-V 目标|PDF 12|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u022`|
|S12/SRB-S12-U027|espup 安装了什么|PDF 15|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u027`|
|S12/SRB-S12-U029|std 开发依赖项|PDF 16|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u029`|
|S12/SRB-S12-U030|使用容器|PDF 17|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u030`|
|S12/SRB-S12-U037|检查生成的项目|PDF 21|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u037`|
|S12/SRB-S12-U041|检查生成的项目|PDF 25|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u041`|
|S12/SRB-S12-U075|使用了错误的 Rust 工具链|PDF 46|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u075`|
|S12/SRB-S12-U081|Environment Variable LIBCLANG_PATH Not Set|PDF 48|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u081`|
|S12/SRB-S12-U082|Missing ldproxy|PDF 49|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u082`|
|S12/SRB-S12-U083|sdkconfig.defaults File is Updated but it Doesn't Appear to Have Had Any Effect|PDF 49|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u083`|
|S12/SRB-S12-U084|The Documentation for the Crates Mentioned on This Page is out of Date or Missing|PDF 49|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u084`|
|S13/SRB-S13-U033|算法分析|PDF 71|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u033`|
|S13/SRB-S13-U035|什么是算法分析|PDF 71|核读映射|[part1/ch01.md#sec-cpp-rust.1.1.1](../part1/ch01.md#sec-cpp-rust.1.1.1)|`sources/reviews/S13.md#review-s13-u035`|
|S13/SRB-S13-U036|大 O 分析法|PDF 74|核读映射|[part1/ch01.md#sec-cpp-rust.1.1.1](../part1/ch01.md#sec-cpp-rust.1.1.1)|`sources/reviews/S13.md#review-s13-u036`|
|S13/SRB-S13-U042|Rust 数据结构的性能|PDF 81|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u042`|
|S13/SRB-S13-U044|集合类型|PDF 82|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u044`|
|S13/SRB-S13-U045|总结|PDF 83|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u045`|
|S13/SRB-S13-U046|基础数据结构|PDF 84|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u046`|
|S13/SRB-S13-U048|线性数据结构|PDF 84|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u048`|
|S13/SRB-S13-U056|队列|PDF 107|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1)|`sources/reviews/S13.md#review-s13-u056`|
|S13/SRB-S13-U060|双端队列|PDF 115|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1)|`sources/reviews/S13.md#review-s13-u060`|
|S13/SRB-S13-U064|链表|PDF 123|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u064`|
|S13/SRB-S13-U068|Vec|PDF 135|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u068`|
|S13/SRB-S13-U070|Rust 实现 Vec|PDF 136|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u070`|
|S13/SRB-S13-U071|总结|PDF 143|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u071`|
|S13/SRB-S13-U140|图的存储形式|PDF 302|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u140`|
|S13/SRB-S13-U168|过滤器|PDF 375|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u168`|
|S13/SRB-S13-U171|缓存淘汰算法 LRU|PDF 385|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u171`|
|S14/SRB-S14-U001|什么是 rustdoc？|PDF 1|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u001`|
|S14/SRB-S14-U002|基本使用|PDF 1|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u002`|
|S14/SRB-S14-U003|配置 rustdoc|PDF 2|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u003`|
|S14/SRB-S14-U004|通过 Cargo 使用 rustdoc|PDF 2|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u004`|
|S14/SRB-S14-U005|Outer 和 inner 文档|PDF 3|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u005`|
|S14/SRB-S14-U006|利用单独的 Markdown 文件|PDF 3|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u006`|
|S14/SRB-S14-U017|如何写文档|PDF 6|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u017`|
|S14/SRB-S14-U018|开始|PDF 6|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u018`|
|S14/SRB-S14-U019|文档组成|PDF 7|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u019`|
|S14/SRB-S14-U026|什么包含（和排除）|PDF 11|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u026`|
|S14/SRB-S14-U027|例子|PDF 11|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u027`|
|S14/SRB-S14-U028|什么被排除|PDF 12|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u028`|
|S14/SRB-S14-U030|Command-line arguments|PDF 13|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u030`|
|S14/SRB-S14-U032|-V/--version: version information|PDF 13|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u032`|
|S14/SRB-S14-U033|-v/--verbose: more verbose output|PDF 13|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u033`|
|S14/SRB-S14-U034|-o/--out-dir: output directory path|PDF 14|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u034`|
|S14/SRB-S14-U035|--crate-name: controlling the name of the crate|PDF 14|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u035`|
|S14/SRB-S14-U036|--document-private-items: Show items that are not public|PDF 14|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u036`|
|S14/SRB-S14-U037|-L/--library-path: where to look for dependencies|PDF 15|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u037`|
|S14/SRB-S14-U038|--cfg: passing configuration flags|PDF 15|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u038`|
|S14/SRB-S14-U039|--extern: specify a dependency's location|PDF 15|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u039`|
|S14/SRB-S14-U040|-C/--codegen: pass codegen options to rustc|PDF 16|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u040`|
|S14/SRB-S14-U041|--test: run code examples as tests|PDF 16|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u041`|
|S14/SRB-S14-U042|--test-args: pass options to test runner|PDF 16|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u042`|
|S14/SRB-S14-U043|--target: generate documentation for the specified target triple|PDF 17|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u043`|
|S14/SRB-S14-U052|--sysroot: override the system root|PDF 19|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u052`|
|S14/SRB-S14-U053|--edition: control the edition of docs and doctests|PDF 20|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u053`|
|S14/SRB-S14-U056|--crate-version: control the crate version|PDF 21|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u056`|
|S14/SRB-S14-U057|@path: load command-line flags from a path|PDF 21|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u057`|
|S14/SRB-S14-U061|--nocapture|PDF 21|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u061`|
|S14/SRB-S14-U062|#[doc] 属性|PDF 23|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u062`|
|S14/SRB-S14-U063|crate 层面|PDF 23|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u063`|
|S14/SRB-S14-U068|html_root_url|PDF 24|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u068`|
|S14/SRB-S14-U069|html_no_source|PDF 25|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u069`|
|S14/SRB-S14-U070|test(no_crate_inject)|PDF 25|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u070`|
|S14/SRB-S14-U071|test(attr(...))|PDF 25|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u071`|
|S14/SRB-S14-U072|item 层面|PDF 25|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u072`|
|S14/SRB-S14-U073|inline and no_inline|PDF 25|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u073`|
|S14/SRB-S14-U074|hidden|PDF 26|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u074`|
|S14/SRB-S14-U075|alias|PDF 27|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u075`|
|S14/SRB-S14-U076|文档测试|PDF 28|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u076`|
|S14/SRB-S14-U077|文档测试通过或者失败|PDF 28|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u077`|
|S14/SRB-S14-U078|预处理例子|PDF 29|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u078`|
|S14/SRB-S14-U079|隐藏例子的一部分|PDF 29|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u079`|
|S14/SRB-S14-U080|在文档测试中使用 ?|PDF 31|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u080`|
|S14/SRB-S14-U081|在文档测试中显示警告|PDF 32|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u081`|
|S14/SRB-S14-U082|宏的文档|PDF 32|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u082`|
|S14/SRB-S14-U083|属性|PDF 33|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u083`|
|S14/SRB-S14-U084|语法参考|PDF 34|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u084`|
|S14/SRB-S14-U085|收集文档测试时包含 item|PDF 34|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u085`|
|S14/SRB-S14-U086|通过名称链接 item|PDF 36|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u086`|
|S14/SRB-S14-U087|有效链接|PDF 36|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u087`|
|S14/SRB-S14-U088|Namespaces and Disambiguators（消歧义符）|PDF 37|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u088`|
|S14/SRB-S14-U089|警告，re-exports, and scoping|PDF 38|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u089`|
|S14/SRB-S14-U090|Lints|PDF 39|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u090`|
|S14/SRB-S14-U091|broken_intra_doc_links|PDF 39|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u091`|
|S14/SRB-S14-U092|private_intra_doc_links|PDF 40|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u092`|
|S14/SRB-S14-U093|missing_docs|PDF 41|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u093`|
|S14/SRB-S14-U094|missing_crate_level_docs|PDF 41|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u094`|
|S14/SRB-S14-U095|missing_doc_code_examples|PDF 42|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u095`|
|S14/SRB-S14-U096|private_doc_tests|PDF 42|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u096`|
|S14/SRB-S14-U097|invalid_codeblock_attributes|PDF 43|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u097`|
|S14/SRB-S14-U098|invalid_html_tags|PDF 43|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u098`|
|S14/SRB-S14-U099|invalid_rust_codeblocks|PDF 44|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u099`|
|S14/SRB-S14-U100|bare_urls|PDF 45|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u100`|
|S14/SRB-S14-U101|高级特性|PDF 46|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u101`|
|S14/SRB-S14-U102|#[cfg(doc)]: 文档平台相关或者特性相关信息|PDF 46|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u102`|
|S14/SRB-S14-U103|特定平台文档之间的交互|PDF 46|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u103`|
|S14/SRB-S14-U104|增加文档搜索的 item 别名|PDF 47|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u104`|
|S14/SRB-S14-U105|不稳定特性|PDF 48|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u105`|
|S14/SRB-S14-U106|Nightly-gated functionality|PDF 48|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u106`|
|S14/SRB-S14-U107|Error numbers for compile-fail doctests|PDF 48|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u107`|
|S14/SRB-S14-U108|Extensions to the #[doc] attribute|PDF 48|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u108`|
|S14/SRB-S14-U109|#[doc(cfg)]: Recording what platforms or features are required for code to be present|PDF 49|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u109`|
|S14/SRB-S14-U110|doc_auto_cfg: Automatically generate #[doc(cfg)]|PDF 49|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u110`|
|S14/SRB-S14-U115|Unstable command-line arguments|PDF 52|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u115`|
|S14/SRB-S14-U120|--show-type-layout: add a section to each type's docs describing its memory layout|PDF 53|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u120`|
|S14/SRB-S14-U122|--extern-html-root-url: control how rustdoc links to non-local crates|PDF 54|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u122`|
|S14/SRB-S14-U127|--persist-doctests: persist doctest executables after running|PDF 55|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u127`|
|S14/SRB-S14-U128|--show-coverage: calculate the percentage of items with documentation|PDF 55|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u128`|
|S14/SRB-S14-U129|-w/--output-format: output format|PDF 57|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u129`|
|S14/SRB-S14-U130|--enable-per-target-ignores: allow ignore-foo style filters for doctests|PDF 57|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u130`|
|S14/SRB-S14-U131|--runtool, --runtool-arg: program to run tests with; args to pass to it|PDF 58|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u131`|
|S14/SRB-S14-U132|--with-examples: include examples of uses of items as documentation|PDF 58|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u132`|
|S14/SRB-S14-U139|FFI 例子|PDF 27|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S14.md#review-s14-u139`|
|S14/SRB-S14-U140|JSON output|PDF 57|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u140`|
|S08/SRC-S08-004|第 1 条：使用类型系统表达数据结构|PDF 7|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1)|`sources/reviews/S08.md#review-s08-u0004`|
|S08/SRC-S08-005|第 2 条：使用类型系统表达常见行为|PDF 14|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S08.md#review-s08-u0005`|
|S08/SRC-S08-007|第 4 条：优先使用惯用的错误类型|PDF 29|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.2](../part3/ch09.md#sec-cpp-rust.3.9.2)|`sources/reviews/S08.md#review-s08-u0007`|
|S08/SRC-S08-008|第 5 条：理解类型转换|PDF 37|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S08.md#review-s08-u0008`|
|S08/SRC-S08-009|第 6 条：拥抱 newtype 模式|PDF 43|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.2](../part4/ch16.md#sec-cpp-rust.4.16.2)|`sources/reviews/S08.md#review-s08-u0009`|
|S08/SRC-S08-011|第 8 条：熟悉引用和指针类型|PDF 55|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S08.md#review-s08-u0011`|
|S08/SRC-S08-012|第 9 条：考虑使用迭代器转换代替显式循环|PDF 68|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S08.md#review-s08-u0012`|
|S08/SRC-S08-014|第 10 条：熟悉标准库的 traits|PDF 81|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S08.md#review-s08-u0014`|
|S08/SRC-S08-015|第 11 条：为 RAII 模式实现 Drop trait|PDF 93|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.8](../part2/ch08.md#sec-cpp-rust.2.8.8)|`sources/reviews/S08.md#review-s08-u0015`|
|S08/SRC-S08-016|第 12 条：理解泛型和 trait 对象之间的权衡|PDF 97|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S08.md#review-s08-u0016`|
|S08/SRC-S08-017|第 13 条：使用默认实现来减少必需实现的 trait 方法|PDF 106|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S08.md#review-s08-u0017`|
|S08/SRC-S08-019|第 14 条：理解生命周期|PDF 109|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S08.md#review-s08-u0019`|
|S08/SRC-S08-020|第 15 条：理解借用检查器|PDF 126|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S08.md#review-s08-u0020`|
|S08/SRC-S08-021|第 16 条：避免写 unsafe 代码|PDF 144|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.5](../part2/ch08.md#sec-cpp-rust.2.8.5)|`sources/reviews/S08.md#review-s08-u0021`|
|S08/SRC-S08-022|第 17 条：对共享状态的并行性保持警惕|PDF 146|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S08.md#review-s08-u0022`|
|S08/SRC-S08-023|第 18 条：不要 panic|PDF 161|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.2](../part3/ch09.md#sec-cpp-rust.3.9.2)|`sources/reviews/S08.md#review-s08-u0023`|
|S08/SRC-S08-024|第 19 条：避免反射|PDF 164|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.4](../part2/ch05.md#sec-cpp-rust.2.5.4)|`sources/reviews/S08.md#review-s08-u0024`|
|S08/SRC-S08-025|第 20 条：避免过度优化的诱惑|PDF 170|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.6](../part3/ch10.md#sec-cpp-rust.3.10.6)|`sources/reviews/S08.md#review-s08-u0025`|
|S08/SRC-S08-027|第 21 条：理解语义化版本|PDF 177|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.1](../part4/ch14.md#sec-cpp-rust.4.14.1)|`sources/reviews/S08.md#review-s08-u0027`|
|S08/SRC-S08-028|第 22 条：最小化可见性|PDF 182|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S08.md#review-s08-u0028`|
|S08/SRC-S08-030|第 24 条：重新导出在 API 中所用的依赖项类型|PDF 189|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S08.md#review-s08-u0030`|
|S08/SRC-S08-031|第 25 条：管理依赖项关系图|PDF 192|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S08.md#review-s08-u0031`|
|S08/SRC-S08-032|第 26 条：警惕 feature 蔓延|PDF 197|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S08.md#review-s08-u0032`|
|S08/SRC-S08-034|第 27 条：为公共接口撰写文档|PDF 203|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S08.md#review-s08-u0034`|
|S08/SRC-S08-035|第 28 条：在合适的时候使用宏|PDF 208|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S08.md#review-s08-u0035`|
|S08/SRC-S08-036|第 29 条：遵循 Clippy 的建议|PDF 224|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.3](../part4/ch14.md#sec-cpp-rust.4.14.3)|`sources/reviews/S08.md#review-s08-u0036`|
|S08/SRC-S08-037|第 30 条：不仅仅是单元测试|PDF 227|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S08.md#review-s08-u0037`|
|S08/SRC-S08-038|第 31 条：使用生态系统工具|PDF 234|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.3](../part4/ch14.md#sec-cpp-rust.4.14.3)|`sources/reviews/S08.md#review-s08-u0038`|
|S08/SRC-S08-039|第 32 条：搭建持续集成（CI）系统|PDF 236|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S08.md#review-s08-u0039`|
|S08/SRC-S08-041|第 33 条：考虑使库代码与 no_std 兼容|PDF 241|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.6](../part1/ch02.md#sec-cpp-rust.1.2.6)|`sources/reviews/S08.md#review-s08-u0041`|
|S08/SRC-S08-042|第 34 条：控制跨越 FFI 边界的内容|PDF 246|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S08.md#review-s08-u0042`|
|S08/SRC-S08-043|第 35 条：优先使用 bindgen 而不是手动 FFI 映射|PDF 258|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.4](../part4/ch16.md#sec-cpp-rust.4.16.4)|`sources/reviews/S08.md#review-s08-u0043`|
|S09/SRC-S09-004|如何构建并运行编译器|PDF 4|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0004`|
|S09/SRC-S09-005|推荐的工作流程|PDF 9|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0005`|
|S09/SRC-S09-006|编译器自举|PDF 10|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0006`|
|S09/SRC-S09-011|The compiler testing framework|PDF 17|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0011`|
|S09/SRC-S09-012|Running tests|PDF 22|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0012`|
|S09/SRC-S09-013|Adding new tests|PDF 25|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0013`|
|S09/SRC-S09-014|compiletest|PDF 31|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0014`|
|S09/SRC-S09-020|Stability attributes|PDF 51|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0020`|
|S09/SRC-S09-022|Debugging the compiler|PDF 57|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.8](../part1/ch04.md#sec-cpp-rust.1.4.8)|`sources/reviews/S09.md#review-s09-u0022`|
|S09/SRC-S09-023|Profiling the compiler|PDF 63|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.1](../part4/ch13.md#sec-cpp-rust.4.13.1)|`sources/reviews/S09.md#review-s09-u0023`|
|S09/SRC-S09-024|Profiling with perf|PDF 64|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.2](../part4/ch13.md#sec-cpp-rust.4.13.2)|`sources/reviews/S09.md#review-s09-u0024`|
|S09/SRC-S09-031|Emitting Errors and other Diagnostics|PDF 73|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0031`|
|S09/SRC-S09-035|Cleanup Crew|PDF 89|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.8](../part4/ch13.md#sec-cpp-rust.4.13.8)|`sources/reviews/S09.md#review-s09-u0035`|
|S09/SRC-S09-036|LLVM ICE-breakers|PDF 91|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.8](../part2/ch06.md#sec-cpp-rust.2.6.8)|`sources/reviews/S09.md#review-s09-u0036`|
|S09/SRC-S09-040|编译器源代码的高层次概观|PDF 92|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0040`|
|S09/SRC-S09-041|查询: 需求驱动的编译|PDF 94|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0041`|
|S09/SRC-S09-042|查询求值模型的详细介绍|PDF 99|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0042`|
|S09/SRC-S09-043|Incremental compilation|PDF 102|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0043`|
|S09/SRC-S09-045|Incremental Compilation In Detail|PDF 105|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0045`|
|S09/SRC-S09-046|Incremental Compilation and the Compiler Backend|PDF 113|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0046`|
|S09/SRC-S09-047|Shortcomings of the Current System|PDF 113|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0047`|
|S09/SRC-S09-048|Debugging and Testing Dependencies|PDF 114|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0048`|
|S09/SRC-S09-049|Profiling Queries|PDF 116|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.3](../part4/ch13.md#sec-cpp-rust.4.13.3)|`sources/reviews/S09.md#review-s09-u0049`|
|S09/SRC-S09-050|Background|PDF 122|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0050`|
|S09/SRC-S09-051|How Salsa works|PDF 124|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0051`|
|S09/SRC-S09-052|Memory Management in Rustc|PDF 129|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.6](../part1/ch02.md#sec-cpp-rust.1.2.6)|`sources/reviews/S09.md#review-s09-u0052`|
|S09/SRC-S09-054|The Rustc Driver and Interface|PDF 131|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0054`|
|S09/SRC-S09-056|Example: Type checking through rustc_interface|PDF 136|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0056`|
|S09/SRC-S09-057|符号与AST|PDF 137|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0057`|
|S09/SRC-S09-058|词法分析与语法分析|PDF 138|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0058`|
|S09/SRC-S09-059|Macro expansion|PDF 144|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0059`|
|S09/SRC-S09-061|Name resolution|PDF 161|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0061`|
|S09/SRC-S09-062|AST Validation|PDF 164|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0062`|
|S09/SRC-S09-063|Feature Gate Checking|PDF 164|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0063`|
|S09/SRC-S09-064|HIR|PDF 164|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0064`|
|S09/SRC-S09-065|Lowering|PDF 166|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0065`|
|S09/SRC-S09-066|HIR Debugging|PDF 167|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.8](../part1/ch04.md#sec-cpp-rust.1.4.8)|`sources/reviews/S09.md#review-s09-u0066`|
|S09/SRC-S09-067|MIR （中层IR）|PDF 167|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0067`|
|S09/SRC-S09-068|HAIR 和 MIR 的构建|PDF 171|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0068`|
|S09/SRC-S09-069|MIR 访问者|PDF 175|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0069`|
|S09/SRC-S09-070|MIR passes|PDF 176|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0070`|
|S09/SRC-S09-071|Closure Expansion in rustc|PDF 177|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S09.md#review-s09-u0071`|
|S09/SRC-S09-073|ty 模块：类型的表示|PDF 181|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0073`|
|S09/SRC-S09-074|范型和替换|PDF 187|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0074`|
|S09/SRC-S09-075|TypeFoldable and TypeFolder|PDF 189|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0075`|
|S09/SRC-S09-076|Generic arguments|PDF 191|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0076`|
|S09/SRC-S09-077|Type inference|PDF 192|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0077`|
|S09/SRC-S09-078|Trait resolution (old-style)|PDF 197|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0078`|
|S09/SRC-S09-079|Higher-ranked trait bounds|PDF 203|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0079`|
|S09/SRC-S09-080|Caching and subtle considerations therewith|PDF 205|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0080`|
|S09/SRC-S09-081|Specialization|PDF 206|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0081`|
|S09/SRC-S09-082|Trait solving (new-style)|PDF 207|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0082`|
|S09/SRC-S09-083|Lowering to logic|PDF 208|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0083`|
|S09/SRC-S09-084|Goals and clauses|PDF 212|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0084`|
|S09/SRC-S09-085|Equality and associated types|PDF 217|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0085`|
|S09/SRC-S09-086|Implied Bounds|PDF 220|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0086`|
|S09/SRC-S09-087|Region constraints|PDF 229|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0087`|
|S09/SRC-S09-088|The lowering module in rustc|PDF 230|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0088`|
|S09/SRC-S09-090|Well-formedness checking|PDF 238|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0090`|
|S09/SRC-S09-094|Canonical queries|PDF 249|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0094`|
|S09/SRC-S09-095|Canonicalization|PDF 253|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0095`|
|S09/SRC-S09-096|The On-Demand SLG solver|PDF 257|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0096`|
|S09/SRC-S09-097|An Overview of Chalk|PDF 262|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0097`|
|S09/SRC-S09-099|Type checking|PDF 267|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0099`|
|S09/SRC-S09-100|Method lookup|PDF 268|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S09.md#review-s09-u0100`|
|S09/SRC-S09-101|Variance of type and lifetime parameters|PDF 270|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0101`|
|S09/SRC-S09-102|Opaque types (type alias impl Trait)|PDF 276|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S09.md#review-s09-u0102`|
|S09/SRC-S09-103|Pattern and Exhaustiveness Checking|PDF 277|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0103`|
|S09/SRC-S09-104|MIR borrow check|PDF 277|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S09.md#review-s09-u0104`|
|S09/SRC-S09-105|Tracking moves and initialization|PDF 278|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0105`|
|S09/SRC-S09-106|Move paths|PDF 279|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0106`|
|S09/SRC-S09-107|The MIR type-check|PDF 281|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0107`|
|S09/SRC-S09-108|Region inference (NLL)|PDF 281|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0108`|
|S09/SRC-S09-109|Constraint propagation|PDF 286|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0109`|
|S09/SRC-S09-110|Universal regions|PDF 289|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0110`|
|S09/SRC-S09-111|Member constraints|PDF 292|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0111`|
|S09/SRC-S09-112|Placeholders and universes|PDF 295|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0112`|
|S09/SRC-S09-113|Propagating closure constraints|PDF 303|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0113`|
|S09/SRC-S09-114|Reporting region errors|PDF 303|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.8](../part1/ch04.md#sec-cpp-rust.1.4.8)|`sources/reviews/S09.md#review-s09-u0114`|
|S09/SRC-S09-115|Two-phase borrows|PDF 303|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0115`|
|S09/SRC-S09-116|Parameter Environment|PDF 305|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0116`|
|S09/SRC-S09-118|MIR （中层IR）|PDF 307|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0118`|
|S09/SRC-S09-119|MIR optimizations|PDF 311|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.2](../part2/ch06.md#sec-cpp-rust.2.6.2)|`sources/reviews/S09.md#review-s09-u0119`|
|S09/SRC-S09-120|MIR Debugging|PDF 312|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0120`|
|S09/SRC-S09-121|Constant Evaluation|PDF 314|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S09.md#review-s09-u0121`|
|S09/SRC-S09-122|Miri|PDF 314|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S09.md#review-s09-u0122`|
|S09/SRC-S09-123|Monomorphization|PDF 319|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S09.md#review-s09-u0123`|
|S09/SRC-S09-124|Lowering MIR to a Codegen IR|PDF 321|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0124`|
|S09/SRC-S09-125|Code generation|PDF 321|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0125`|
|S09/SRC-S09-127|Backend Agnostic Codegen|PDF 330|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0127`|
|S09/SRC-S09-128|Refactoring of rustc_codegen_llvm|PDF 330|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0128`|
|S09/SRC-S09-129|Implicit Caller Location|PDF 334|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.4](../part2/ch06.md#sec-cpp-rust.2.6.4)|`sources/reviews/S09.md#review-s09-u0129`|
|S09/SRC-S09-130|Profile Guided Optimization|PDF 340|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.7](../part2/ch06.md#sec-cpp-rust.2.6.7)|`sources/reviews/S09.md#review-s09-u0130`|
|S09/SRC-S09-131|Sanitizers Support|PDF 343|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.5](../part4/ch14.md#sec-cpp-rust.4.14.5)|`sources/reviews/S09.md#review-s09-u0131`|
|S09/SRC-S09-132|Debugging support in the Rust compiler|PDF 344|核读映射|[part4/ch13.md#sec-cpp-rust.4.13.4](../part4/ch13.md#sec-cpp-rust.4.13.4)|`sources/reviews/S09.md#review-s09-u0132`|
|S09/SRC-S09-133|Appendix B: Background topics|PDF 353|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0133`|
|S10/SRC-S10-010|宏|PDF 32|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S10.md#review-s10-u0010`|
|S10/SRC-S10-011|声明宏|PDF 34|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S10.md#review-s10-u0011`|
|S10/SRC-S10-012|crate 和源文件|PDF 49|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.1](../part4/ch14.md#sec-cpp-rust.4.14.1)|`sources/reviews/S10.md#review-s10-u0012`|
|S10/SRC-S10-013|条件编译|PDF 52|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S10.md#review-s10-u0013`|
|S10/SRC-S10-018|函数|PDF 71|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0018`|
|S10/SRC-S10-020|结构体|PDF 79|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0020`|
|S10/SRC-S10-021|枚举|PDF 81|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2)|`sources/reviews/S10.md#review-s10-u0021`|
|S10/SRC-S10-022|联合体|PDF 85|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0022`|
|S10/SRC-S10-023|常量项|PDF 89|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S10.md#review-s10-u0023`|
|S10/SRC-S10-024|静态项|PDF 92|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S10.md#review-s10-u0024`|
|S10/SRC-S10-025|Trait|PDF 94|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0025`|
|S10/SRC-S10-026|实现|PDF 101|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S10.md#review-s10-u0026`|
|S10/SRC-S10-027|外部块|PDF 107|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S10.md#review-s10-u0027`|
|S10/SRC-S10-028|类型参数和生存期参数|PDF 111|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0028`|
|S10/SRC-S10-029|关联项|PDF 117|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S10.md#review-s10-u0029`|
|S10/SRC-S10-031|测试类属性|PDF 130|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S10.md#review-s10-u0031`|
|S10/SRC-S10-032|派生|PDF 132|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S10.md#review-s10-u0032`|
|S10/SRC-S10-033|诊断属性|PDF 133|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.3](../part4/ch14.md#sec-cpp-rust.4.14.3)|`sources/reviews/S10.md#review-s10-u0033`|
|S10/SRC-S10-034|代码生成属性|PDF 140|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S10.md#review-s10-u0034`|
|S10/SRC-S10-035|极值设置|PDF 146|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.5](../part1/ch04.md#sec-cpp-rust.1.4.5)|`sources/reviews/S10.md#review-s10-u0035`|
|S10/SRC-S10-036|类型系统属性|PDF 148|核读映射|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S10.md#review-s10-u0036`|
|S10/SRC-S10-038|语句|PDF 153|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0038`|
|S10/SRC-S10-039|表达式|PDF 156|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0039`|
|S10/SRC-S10-042|块表达式|PDF 165|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0042`|
|S10/SRC-S10-043|操作符/运算符表达式|PDF 169|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0043`|
|S10/SRC-S10-045|数组和数组索引表达式|PDF 183|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0045`|
|S10/SRC-S10-047|结构体表达式|PDF 189|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0047`|
|S10/SRC-S10-048|调用表达式|PDF 192|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0048`|
|S10/SRC-S10-049|方法调用表达式|PDF 194|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S10.md#review-s10-u0049`|
|S10/SRC-S10-050|字段访问表达式|PDF 196|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0050`|
|S10/SRC-S10-051|闭包表达式|PDF 198|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0051`|
|S10/SRC-S10-052|循环|PDF 200|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0052`|
|S10/SRC-S10-053|区间表达式|PDF 206|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0053`|
|S10/SRC-S10-055|匹配(match)表达式|PDF 211|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0055`|
|S10/SRC-S10-056|返回(return)表达式|PDF 214|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0056`|
|S10/SRC-S10-057|等待(await)表达式|PDF 215|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.4](../part2/ch08.md#sec-cpp-rust.2.8.4)|`sources/reviews/S10.md#review-s10-u0057`|
|S10/SRC-S10-058|模式|PDF 217|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0058`|
|S10/SRC-S10-060|类型|PDF 234|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0060`|
|S10/SRC-S10-061|布尔型|PDF 237|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0061`|
|S10/SRC-S10-062|数字型|PDF 240|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.6](../part2/ch06.md#sec-cpp-rust.2.6.6)|`sources/reviews/S10.md#review-s10-u0062`|
|S10/SRC-S10-063|文本类类型|PDF 242|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0063`|
|S10/SRC-S10-065|元组类型|PDF 244|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0065`|
|S10/SRC-S10-066|数组类型|PDF 245|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0066`|
|S10/SRC-S10-067|切片类型|PDF 246|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S10.md#review-s10-u0067`|
|S10/SRC-S10-068|结构体类型|PDF 247|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0068`|
|S10/SRC-S10-069|枚举类型|PDF 248|核读映射|[part1/ch02.md#sec-cpp-rust.1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2)|`sources/reviews/S10.md#review-s10-u0069`|
|S10/SRC-S10-070|联合体类型|PDF 249|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0070`|
|S10/SRC-S10-071|函数项类型|PDF 250|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0071`|
|S10/SRC-S10-072|闭包类型|PDF 251|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0072`|
|S10/SRC-S10-073|指针类型|PDF 255|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S10.md#review-s10-u0073`|
|S10/SRC-S10-074|函数指针类型|PDF 257|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0074`|
|S10/SRC-S10-075|trait对象|PDF 259|核读映射|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S10.md#review-s10-u0075`|
|S10/SRC-S10-076|实现trait|PDF 262|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0076`|
|S10/SRC-S10-077|类型参数|PDF 264|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0077`|
|S10/SRC-S10-079|动态尺寸类型|PDF 266|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S10.md#review-s10-u0079`|
|S10/SRC-S10-080|类型布局|PDF 267|核读映射|[part3/ch10.md#sec-cpp-rust.3.10.3](../part3/ch10.md#sec-cpp-rust.3.10.3)|`sources/reviews/S10.md#review-s10-u0080`|
|S10/SRC-S10-081|内部可变性|PDF 280|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S10.md#review-s10-u0081`|
|S10/SRC-S10-082|子类型化和型变|PDF 281|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S10.md#review-s10-u0082`|
|S10/SRC-S10-083|trait 约束和生命周期约束|PDF 283|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0083`|
|S10/SRC-S10-084|类型自动强转|PDF 287|核读映射|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0084`|
|S10/SRC-S10-085|析构函数|PDF 294|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.8](../part2/ch08.md#sec-cpp-rust.2.8.8)|`sources/reviews/S10.md#review-s10-u0085`|
|S10/SRC-S10-086|生命周期(类型参数)省略|PDF 301|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S10.md#review-s10-u0086`|
|S10/SRC-S10-087|特殊类型和 trait|PDF 306|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S10.md#review-s10-u0087`|
|S10/SRC-S10-094|可见性与隐私权|PDF 328|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S10.md#review-s10-u0094`|
|S10/SRC-S10-095|内存模型|PDF 334|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.5](../part1/ch03.md#sec-cpp-rust.1.3.5)|`sources/reviews/S10.md#review-s10-u0095`|
|S10/SRC-S10-096|内存分配和生存期|PDF 335|核读映射|[part2/ch08.md#sec-cpp-rust.2.8.7](../part2/ch08.md#sec-cpp-rust.2.8.7)|`sources/reviews/S10.md#review-s10-u0096`|
|S10/SRC-S10-097|变量|PDF 336|核读映射|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S10.md#review-s10-u0097`|
|S10/SRC-S10-098|链接|PDF 337|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S10.md#review-s10-u0098`|
|S10/SRC-S10-099|非安全性|PDF 341|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0099`|
|S10/SRC-S10-100|非安全函数|PDF 342|核读映射|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0100`|
|S10/SRC-S10-101|非安全块|PDF 343|核读映射|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S10.md#review-s10-u0101`|
|S10/SRC-S10-102|常量求值|PDF 349|核读映射|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S10.md#review-s10-u0102`|
|S10/SRC-S10-103|应用程序二进制接口(ABI)|PDF 352|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S10.md#review-s10-u0103`|
|S10/SRC-S10-104|Rust 运行时|PDF 355|核读映射|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S10.md#review-s10-u0104`|
|S08/SYS-S08-17|第17条：数据竞争、锁与状态一致性|PDF 146–160|核读映射|[part3/ch11.md#sec-cpp-rust.3.11.1](../part3/ch11.md#sec-cpp-rust.3.11.1)|`bench/systems-lab/src/lib.rs`|
|S08/SYS-S08-28|第28条：利用类型系统表达不变量|PDF 205–210|核读映射|[part3/ch11.md#sec-cpp-rust.3.11.4](../part3/ch11.md#sec-cpp-rust.3.11.4)|`bench/systems-lab/src/lib.rs`|
|systems-mit-rcu/SYS-MIT-RCU|Lecture Notes: Read-Copy Update (RCU)|在线讲义（SHA: 34201a6f...）|核读映射|[part3/ch11.md#sec-cpp-rust.3.11.8](../part3/ch11.md#sec-cpp-rust.3.11.8)|`src/part3/ch11.md`|
|rcore-lock/SYS-RCORE-LOCK|第8章：并发与互斥机制对比|在线文档（SHA: 7684f01f...）|核读映射|[part3/ch11.md#sec-cpp-rust.3.11.1](../part3/ch11.md#sec-cpp-rust.3.11.1)|`src/part3/ch11.md`|
|systems-target-feature/SYS-TARGET-FEATURE|Codegen Attributes: target_feature|在线规范（SHA: 18becca8...）|核读映射|[part3/ch12.md#sec-cpp-rust.3.12.3](../part3/ch12.md#sec-cpp-rust.3.12.3)|`bench/systems-lab/src/lib.rs`|
|systems-uring/SYS-IO-URING|io_uring(7): 异步I/O环形缓冲区架构|在线手册（SHA: 1ed71f55...）|核读映射|[part3/ch12.md#sec-cpp-rust.3.12.8](../part3/ch12.md#sec-cpp-rust.3.12.8)|`src/part3/ch12.md`|
|systems-uring-cancel/SYS-IO-URING-CANCEL|io_uring_prep_cancel(3): 异步请求取消时序|在线手册（SHA: 0f9c226c...）|核读映射|[part3/ch12.md#sec-cpp-rust.3.12.8](../part3/ch12.md#sec-cpp-rust.3.12.8)|`src/part3/ch12.md`|
|systems-rcore-io/SYS-RCORE-IO|第6章：文件系统与块设备接口设计|在线文档（SHA: 55ff0cac...）|核读映射|[part3/ch12.md#sec-cpp-rust.3.12.4](../part3/ch12.md#sec-cpp-rust.3.12.4)|`src/part3/ch12.md`|
|S11/SYS-S11-ITER|13.4 性能对比：循环 VS 迭代器|PDF 314–315|核读映射|[part3/ch12.md#sec-cpp-rust.3.12.2](../part3/ch12.md#sec-cpp-rust.3.12.2)|`bench/systems-lab/src/bin/simd.rs`|
|S08/SYS-S08-OPT|第20条末：优化不应以牺牲可用性为代价|PDF 174–175|核读映射|[part3/ch12.md#sec-cpp-rust.3.12.7](../part3/ch12.md#sec-cpp-rust.3.12.7)|`bench/systems-lab/src/bin/views.rs`|

## 全目录逐节裁决

### S01 · A Tour of C++ (Bjarne Stroustrup) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s01}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S01-U0001|Cover Page|2|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0001`；C/C++ 或辅助构建通用内容（Cover Page）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0002|About This eBook|4|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0002`；C/C++ 或辅助构建通用内容（About This eBook）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0003|Halftitle Page|5|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0003`；C/C++ 或辅助构建通用内容（Halftitle Page）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0004|Title Page|8|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0004`；C/C++ 或辅助构建通用内容（Title Page）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0005|Copyright Page|9|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0005`；C/C++ 或辅助构建通用内容（Copyright Page）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0006|Contents|11|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0006`；C/C++ 或辅助构建通用内容（Contents）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0007|Preface|17|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0007`；C/C++ 或辅助构建通用内容（Preface）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0008|Acknowledgments|19|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0008`；C/C++ 或辅助构建通用内容（Acknowledgments）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0009|1 The Basics|20|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0009`；C/C++ 或辅助构建通用内容（1 The Basics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0010|1.1 Introduction|21|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0010`；C/C++ 或辅助构建通用内容（1.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0011|1.2 Programs|21|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0011`；C/C++ 或辅助构建通用内容（1.2 Programs）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0012|1.3 Functions|24|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0012`；C/C++ 或辅助构建通用内容（1.3 Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0013|1.4 Types, Variables, and Arithmetic|27|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0013`；C/C++ 或辅助构建通用内容（1.4 Types, Variables, and Arithmetic）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0014|1.5 Scope and Lifetime|32|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0014`；C/C++ 或辅助构建通用内容（1.5 Scope and Lifetime）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0015|1.6 Constants|33|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0015`；C/C++ 或辅助构建通用内容（1.6 Constants）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0016|1.7 Pointers, Arrays, and References|35|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S01.md#review-s01-u0016`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S01-U0017|1.8 Tests|39|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0017`；C/C++ 或辅助构建通用内容（1.8 Tests）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0018|1.9 Mapping to Hardware|42|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0018`；C/C++ 或辅助构建通用内容（1.9 Mapping to Hardware）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0019|1.10 Advice|46|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0019`；C/C++ 或辅助构建通用内容（1.10 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0020|2 User-Defined Types|48|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0020`；C/C++ 或辅助构建通用内容（2 User-Defined Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0021|2.1 Introduction|48|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0021`；C/C++ 或辅助构建通用内容（2.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0022|2.2 Structures|49|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0022`；C/C++ 或辅助构建通用内容（2.2 Structures）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0023|2.3 Classes|51|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0023`；C/C++ 或辅助构建通用内容（2.3 Classes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0024|2.4 Enumerations|54|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0024`；C/C++ 或辅助构建通用内容（2.4 Enumerations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0025|2.5 Unions|56|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0025`；C/C++ 或辅助构建通用内容（2.5 Unions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0026|2.6 Advice|58|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0026`；C/C++ 或辅助构建通用内容（2.6 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0027|3 Modularity|60|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0027`；C/C++ 或辅助构建通用内容（3 Modularity）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0028|3.1 Introduction|60|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0028`；C/C++ 或辅助构建通用内容（3.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0029|3.2 Separate Compilation|62|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0029`；C/C++ 或辅助构建通用内容（3.2 Separate Compilation）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0030|3.3 Namespaces|69|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0030`；C/C++ 或辅助构建通用内容（3.3 Namespaces）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0031|3.4 Function Arguments and Return Values|71|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0031`；C/C++ 或辅助构建通用内容（3.4 Function Arguments and Return Values）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0032|3.5 Advice|79|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0032`；C/C++ 或辅助构建通用内容（3.5 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0033|4 Error Handling|80|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0033`；C/C++ 或辅助构建通用内容（4 Error Handling）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0034|4.1 Introduction|80|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0034`；C/C++ 或辅助构建通用内容（4.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0035|4.2 Exceptions|81|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0035`；C/C++ 或辅助构建通用内容（4.2 Exceptions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0036|4.3 Invariants|83|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0036`；C/C++ 或辅助构建通用内容（4.3 Invariants）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0037|4.4 Error-Handling Alternatives|85|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0037`；C/C++ 或辅助构建通用内容（4.4 Error-Handling Alternatives）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0038|4.5 Assertions|88|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0038`；C/C++ 或辅助构建通用内容（4.5 Assertions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0039|4.6 Advice|92|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0039`；C/C++ 或辅助构建通用内容（4.6 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0040|5 Classes|93|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0040`；C/C++ 或辅助构建通用内容（5 Classes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0041|5.1 Introduction|94|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0041`；C/C++ 或辅助构建通用内容（5.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0042|5.2 Concrete Types|95|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0042`；C/C++ 或辅助构建通用内容（5.2 Concrete Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0043|5.3 Abstract Types|103|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0043`；C/C++ 或辅助构建通用内容（5.3 Abstract Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0044|5.4 Virtual Functions|107|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0044`；C/C++ 或辅助构建通用内容（5.4 Virtual Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0045|5.5 Class Hierarchies|108|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0045`；C/C++ 或辅助构建通用内容（5.5 Class Hierarchies）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0046|5.6 Advice|116|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0046`；C/C++ 或辅助构建通用内容（5.6 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0047|6 Essential Operations|119|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0047`；C/C++ 或辅助构建通用内容（6 Essential Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0048|6.1 Introduction|120|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0048`；C/C++ 或辅助构建通用内容（6.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0049|6.2 Copy and Move|124|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0049`；C/C++ 或辅助构建通用内容（6.2 Copy and Move）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0050|6.3 Resource Management|130|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S01.md#review-s01-u0050`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S01-U0051|6.4 Operator Overloading|132|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0051`；C/C++ 或辅助构建通用内容（6.4 Operator Overloading）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0052|6.5 Conventional Operations|133|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0052`；C/C++ 或辅助构建通用内容（6.5 Conventional Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0053|6.6 User-Defined Literals|139|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0053`；C/C++ 或辅助构建通用内容（6.6 User-Defined Literals）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0054|6.7 Advice|140|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0054`；C/C++ 或辅助构建通用内容（6.7 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0055|7 Templates|142|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0055`；C/C++ 或辅助构建通用内容（7 Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0056|7.1 Introduction|142|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0056`；C/C++ 或辅助构建通用内容（7.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0057|7.2 Parameterized Types|143|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0057`；C/C++ 或辅助构建通用内容（7.2 Parameterized Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0058|7.3 Parameterized Operations|150|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0058`；C/C++ 或辅助构建通用内容（7.3 Parameterized Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0059|7.4 Template Mechanisms|159|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0059`；C/C++ 或辅助构建通用内容（7.4 Template Mechanisms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0060|7.5 Advice|163|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0060`；C/C++ 或辅助构建通用内容（7.5 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0061|8 Concepts and Generic Programming|165|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0061`；C/C++ 或辅助构建通用内容（8 Concepts and Generic Programming）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0062|8.1 Introduction|166|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0062`；C/C++ 或辅助构建通用内容（8.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0063|8.2 Concepts|166|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0063`；C/C++ 或辅助构建通用内容（8.2 Concepts）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0064|8.3 Generic Programming|178|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0064`；C/C++ 或辅助构建通用内容（8.3 Generic Programming）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0065|8.4 Variadic Templates|182|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0065`；C/C++ 或辅助构建通用内容（8.4 Variadic Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0066|8.5 Template Compilation Model|186|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0066`；C/C++ 或辅助构建通用内容（8.5 Template Compilation Model）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0067|8.6 Advice|187|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0067`；C/C++ 或辅助构建通用内容（8.6 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0068|9 Library Overview|189|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0068`；C/C++ 或辅助构建通用内容（9 Library Overview）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0069|9.1 Introduction|189|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0069`；C/C++ 或辅助构建通用内容（9.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0070|9.2 Standard-Library Components|190|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0070`；C/C++ 或辅助构建通用内容（9.2 Standard-Library Components）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0071|9.3 Standard-Library Organization|192|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0071`；C/C++ 或辅助构建通用内容（9.3 Standard-Library Organization）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0072|9.4 Advice|197|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0072`；C/C++ 或辅助构建通用内容（9.4 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0073|10 Strings and Regular Expressions|198|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0073`；C/C++ 或辅助构建通用内容（10 Strings and Regular Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0074|10.1 Introduction|198|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0074`；C/C++ 或辅助构建通用内容（10.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0075|10.2 Strings|199|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0075`；C/C++ 或辅助构建通用内容（10.2 Strings）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0076|10.3 String Views|202|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0076`；C/C++ 或辅助构建通用内容（10.3 String Views）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0077|10.4 Regular Expressions|205|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0077`；C/C++ 或辅助构建通用内容（10.4 Regular Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0078|10.5 Advice|214|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0078`；C/C++ 或辅助构建通用内容（10.5 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0079|11 Input and Output|216|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0079`；C/C++ 或辅助构建通用内容（11 Input and Output）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0080|11.1 Introduction|217|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0080`；C/C++ 或辅助构建通用内容（11.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0081|11.2 Output|218|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0081`；C/C++ 或辅助构建通用内容（11.2 Output）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0082|11.3 Input|219|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0082`；C/C++ 或辅助构建通用内容（11.3 Input）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0083|11.4 I/O State|221|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0083`；C/C++ 或辅助构建通用内容（11.4 I/O State）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0084|11.5 I/O of User-Defined Types|222|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0084`；C/C++ 或辅助构建通用内容（11.5 I/O of User-Defined Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0085|11.6 Output Formatting|224|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0085`；C/C++ 或辅助构建通用内容（11.6 Output Formatting）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0086|11.7 Streams|230|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0086`；C/C++ 或辅助构建通用内容（11.7 Streams）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0087|11.8 C-style I/O|234|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0087`；C/C++ 或辅助构建通用内容（11.8 C-style I/O）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0088|11.9 File System|235|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0088`；C/C++ 或辅助构建通用内容（11.9 File System）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0089|11.10 Advice|241|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0089`；C/C++ 或辅助构建通用内容（11.10 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0090|12 Containers|243|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0090`；C/C++ 或辅助构建通用内容（12 Containers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0091|12.1 Introduction|244|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0091`；C/C++ 或辅助构建通用内容（12.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0092|12.2 vector|244|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0092`；C/C++ 或辅助构建通用内容（12.2 vector）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0093|12.3 list|251|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0093`；C/C++ 或辅助构建通用内容（12.3 list）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0094|12.4 forward_list|253|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0094`；C/C++ 或辅助构建通用内容（12.4 forward_list）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0095|12.5 map|253|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0095`；C/C++ 或辅助构建通用内容（12.5 map）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0096|12.6 unordered_map|255|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0096`；C/C++ 或辅助构建通用内容（12.6 unordered_map）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0097|12.7 Allocators|257|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0097`；C/C++ 或辅助构建通用内容（12.7 Allocators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0098|12.8 Container Overview|259|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0098`；C/C++ 或辅助构建通用内容（12.8 Container Overview）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0099|12.9 Advice|262|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0099`；C/C++ 或辅助构建通用内容（12.9 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0100|13 Algorithms|264|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0100`；C/C++ 或辅助构建通用内容（13 Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0101|13.1 Introduction|265|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0101`；C/C++ 或辅助构建通用内容（13.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0102|13.2 Use of Iterators|267|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0102`；C/C++ 或辅助构建通用内容（13.2 Use of Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0103|13.3 Iterator Types|271|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0103`；C/C++ 或辅助构建通用内容（13.3 Iterator Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0104|13.4 Use of Predicates|275|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0104`；C/C++ 或辅助构建通用内容（13.4 Use of Predicates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0105|13.5 Algorithm Overview|276|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0105`；C/C++ 或辅助构建通用内容（13.5 Algorithm Overview）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0106|13.6 Parallel Algorithms|278|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0106`；C/C++ 或辅助构建通用内容（13.6 Parallel Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0107|13.7 Advice|280|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0107`；C/C++ 或辅助构建通用内容（13.7 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0108|14 Ranges|281|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0108`；C/C++ 或辅助构建通用内容（14 Ranges）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0109|14.1 Introduction|282|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0109`；C/C++ 或辅助构建通用内容（14.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0110|14.2 Views|283|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0110`；C/C++ 或辅助构建通用内容（14.2 Views）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0111|14.3 Generators|286|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0111`；C/C++ 或辅助构建通用内容（14.3 Generators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0112|14.4 Pipelines|287|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0112`；C/C++ 或辅助构建通用内容（14.4 Pipelines）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0113|14.5 Concepts Overview|288|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0113`；C/C++ 或辅助构建通用内容（14.5 Concepts Overview）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0114|14.6 Advice|295|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0114`；C/C++ 或辅助构建通用内容（14.6 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0115|15 Pointers and Containers|297|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S01.md#review-s01-u0115`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S01-U0116|15.1 Introduction|298|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0116`；C/C++ 或辅助构建通用内容（15.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0117|15.2 Pointers|298|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S01.md#review-s01-u0117`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S01-U0118|15.3 Containers|307|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0118`；C/C++ 或辅助构建通用内容（15.3 Containers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0119|15.4 Alternatives|317|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0119`；C/C++ 或辅助构建通用内容（15.4 Alternatives）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0120|15.5 Advice|321|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0120`；C/C++ 或辅助构建通用内容（15.5 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0121|16 Utilities|324|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0121`；C/C++ 或辅助构建通用内容（16 Utilities）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0122|16.1 Introduction|325|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0122`；C/C++ 或辅助构建通用内容（16.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0123|16.2 Time|325|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0123`；C/C++ 或辅助构建通用内容（16.2 Time）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0124|16.3 Function Adaption|329|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0124`；C/C++ 或辅助构建通用内容（16.3 Function Adaption）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0125|16.4 Type Functions|331|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0125`；C/C++ 或辅助构建通用内容（16.4 Type Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0126|16.5 source_location|338|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0126`；C/C++ 或辅助构建通用内容（16.5 source_location）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0127|16.6 move() and forward()|339|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0127`；C/C++ 或辅助构建通用内容（16.6 move() and forward()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0128|16.7 Bit Manipulation|341|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0128`；C/C++ 或辅助构建通用内容（16.7 Bit Manipulation）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0129|16.8 Exiting a Program|342|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0129`；C/C++ 或辅助构建通用内容（16.8 Exiting a Program）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0130|16.9 Advice|343|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0130`；C/C++ 或辅助构建通用内容（16.9 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0131|17 Numerics|345|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0131`；C/C++ 或辅助构建通用内容（17 Numerics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0132|17.1 Introduction|346|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0132`；C/C++ 或辅助构建通用内容（17.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0133|17.2 Mathematical Functions|346|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0133`；C/C++ 或辅助构建通用内容（17.2 Mathematical Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0134|17.3 Numerical Algorithms|348|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0134`；C/C++ 或辅助构建通用内容（17.3 Numerical Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0135|17.4 Complex Numbers|350|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0135`；C/C++ 或辅助构建通用内容（17.4 Complex Numbers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0136|17.5 Random Numbers|351|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0136`；C/C++ 或辅助构建通用内容（17.5 Random Numbers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0137|17.6 Vector Arithmetic|354|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0137`；C/C++ 或辅助构建通用内容（17.6 Vector Arithmetic）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0138|17.7 Numeric Limits|355|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0138`；C/C++ 或辅助构建通用内容（17.7 Numeric Limits）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0139|17.8 Type Aliases|355|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0139`；C/C++ 或辅助构建通用内容（17.8 Type Aliases）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0140|17.9 Mathematical Constants|356|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0140`；C/C++ 或辅助构建通用内容（17.9 Mathematical Constants）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0141|17.10 Advice|357|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0141`；C/C++ 或辅助构建通用内容（17.10 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0142|18 Concurrency|358|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S01.md#review-s01-u0142`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S01-U0143|18.1 Introduction|359|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0143`；C/C++ 或辅助构建通用内容（18.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0144|18.2 Tasks and threads|360|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S01.md#review-s01-u0144`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S01-U0145|18.3 Sharing Data|364|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0145`；C/C++ 或辅助构建通用内容（18.3 Sharing Data）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0146|18.4 Waiting for Events|367|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0146`；C/C++ 或辅助构建通用内容（18.4 Waiting for Events）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0147|18.5 Communicating Tasks|369|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0147`；C/C++ 或辅助构建通用内容（18.5 Communicating Tasks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0148|18.6 Coroutines|376|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0148`；C/C++ 或辅助构建通用内容（18.6 Coroutines）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0149|18.7 Advice|381|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0149`；C/C++ 或辅助构建通用内容（18.7 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0150|19 History and Compatibility|383|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0150`；C/C++ 或辅助构建通用内容（19 History and Compatibility）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0151|19.1 History|383|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0151`；C/C++ 或辅助构建通用内容（19.1 History）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0152|19.2 C++ Feature Evolution|390|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0152`；C/C++ 或辅助构建通用内容（19.2 C++ Feature Evolution）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0153|19.3 C/C++ Compatibility|395|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0153`；C/C++ 或辅助构建通用内容（19.3 C/C++ Compatibility）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0154|19.4 Bibliography|399|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0154`；C/C++ 或辅助构建通用内容（19.4 Bibliography）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0155|19.5 Advice|402|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0155`；C/C++ 或辅助构建通用内容（19.5 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0156|Module std|403|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0156`；C/C++ 或辅助构建通用内容（Module std）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0157|A.1 Introduction|404|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0157`；C/C++ 或辅助构建通用内容（A.1 Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0158|A.2 Use What Your Implementation Offers|404|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0158`；C/C++ 或辅助构建通用内容（A.2 Use What Your Implementation Offers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0159|A.3 Use Headers|405|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0159`；C/C++ 或辅助构建通用内容（A.3 Use Headers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0160|A.4 Make Your Own module std|406|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0160`；C/C++ 或辅助构建通用内容（A.4 Make Your Own module std）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0161|A.5 Advice|407|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0161`；C/C++ 或辅助构建通用内容（A.5 Advice）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0162|Index|408|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0162`；C/C++ 或辅助构建通用内容（Index）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S01-U0163|Code Snippets|473|excluded-reviewed / scope-only|—|`sources/reviews/S01.md#review-s01-u0163`；C/C++ 或辅助构建通用内容（Code Snippets）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S02 · C++ Crash Course A Fast-Paced Introduction (Josh Lospinoso) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s02}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S02-U0001|Cover|1|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0001`；C/C++ 或辅助构建通用内容（Cover）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0002|Title|5|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0002`；C/C++ 或辅助构建通用内容（Title）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0003|Copyright|6|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0003`；C/C++ 或辅助构建通用内容（Copyright）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0004|Brief Contents|11|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0004`；C/C++ 或辅助构建通用内容（Brief Contents）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0005|Contents in Detail|13|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0005`；C/C++ 或辅助构建通用内容（Contents in Detail）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0006|Foreword|27|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0006`；C/C++ 或辅助构建通用内容（Foreword）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0007|Acknowledgments|31|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0007`；C/C++ 或辅助构建通用内容（Acknowledgments）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0008|Introduction|33|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0008`；C/C++ 或辅助构建通用内容（Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0009|About This Book|34|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0009`；C/C++ 或辅助构建通用内容（About This Book）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0010|Who Should Read This Book?|35|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0010`；C/C++ 或辅助构建通用内容（Who Should Read This Book?）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0011|What’s in This Book?|35|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0011`；C/C++ 或辅助构建通用内容（What’s in This Book?）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0012|Part I: The C++ Core Language|35|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0012`；C/C++ 或辅助构建通用内容（Part I: The C++ Core Language）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0013|Part II: C++ Libraries and Frameworks|36|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0013`；C/C++ 或辅助构建通用内容（Part II: C++ Libraries and Frameworks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0014|An Overture to C Programmers|39|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0014`；C/C++ 或辅助构建通用内容（An Overture to C Programmers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0015|Upgrading to Super C|41|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0015`；C/C++ 或辅助构建通用内容（Upgrading to Super C）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0016|Function Overloading|41|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0016`；C/C++ 或辅助构建通用内容（Function Overloading）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0017|References|42|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0017`；C/C++ 或辅助构建通用内容（References）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0018|auto Initialization|44|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0018`；C/C++ 或辅助构建通用内容（auto Initialization）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0019|Namespaces and Implicit typedef of struct, union, and enum|45|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0019`；C/C++ 或辅助构建通用内容（Namespaces and Implicit typedef of struct, union, and enum）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0020|Intermingling C and C++ Object Files|47|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0020`；C/C++ 或辅助构建通用内容（Intermingling C and C++ Object Files）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0021|C++ Themes|48|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0021`；C/C++ 或辅助构建通用内容（C++ Themes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0022|Expressing Ideas Concisely and Reusing Code|48|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0022`；C/C++ 或辅助构建通用内容（Expressing Ideas Concisely and Reusing Code）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0023|The C++ Standard Library|50|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0023`；C/C++ 或辅助构建通用内容（The C++ Standard Library）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0024|Lambdas|51|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0024`；C/C++ 或辅助构建通用内容（Lambdas）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0025|Generic Programming with Templates|52|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0025`；C/C++ 或辅助构建通用内容（Generic Programming with Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0026|Class Invariants and Resource Management|53|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0026`；C/C++ 或辅助构建通用内容（Class Invariants and Resource Management）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0027|Move Semantics|57|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0027`；C/C++ 或辅助构建通用内容（Move Semantics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0028|Relax and Enjoy Your Shoes|58|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0028`；C/C++ 或辅助构建通用内容（Relax and Enjoy Your Shoes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0029|PART I: The C++ Core Language|59|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0029`；C/C++ 或辅助构建通用内容（PART I: The C++ Core Language）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0030|1: Up and Running|61|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0030`；C/C++ 或辅助构建通用内容（1: Up and Running）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0031|The Structure of a Basic C++ Program|62|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0031`；C/C++ 或辅助构建通用内容（The Structure of a Basic C++ Program）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0032|Creating Your First C++ Source File|62|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0032`；C/C++ 或辅助构建通用内容（Creating Your First C++ Source File）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0033|Main: A C++ Program’s Starting Point|62|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0033`；C/C++ 或辅助构建通用内容（Main: A C++ Program’s Starting Point）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0034|Libraries: Pulling in External Code|63|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0034`；C/C++ 或辅助构建通用内容（Libraries: Pulling in External Code）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0035|The Compiler Tool Chain|63|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0035`；C/C++ 或辅助构建通用内容（The Compiler Tool Chain）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0036|Setting Up Your Development Environment|64|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0036`；C/C++ 或辅助构建通用内容（Setting Up Your Development Environment）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0037|Windows 10 and Later: Visual Studio|64|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0037`；C/C++ 或辅助构建通用内容（Windows 10 and Later: Visual Studio）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0038|macOS: Xcode|66|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0038`；C/C++ 或辅助构建通用内容（macOS: Xcode）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0039|Linux and GCC|67|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0039`；C/C++ 或辅助构建通用内容（Linux and GCC）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0040|Text Editors|71|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0040`；C/C++ 或辅助构建通用内容（Text Editors）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0041|Bootstrapping C++|71|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0041`；C/C++ 或辅助构建通用内容（Bootstrapping C++）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0042|The C++ Type System|71|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0042`；C/C++ 或辅助构建通用内容（The C++ Type System）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0043|Declaring Variables|72|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0043`；C/C++ 或辅助构建通用内容（Declaring Variables）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0044|Initializing a Variable’s State|72|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0044`；C/C++ 或辅助构建通用内容（Initializing a Variable’s State）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0045|Conditional Statements|73|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0045`；C/C++ 或辅助构建通用内容（Conditional Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0046|Functions|74|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0046`；C/C++ 或辅助构建通用内容（Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0047|printf Format Specifiers|76|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0047`；C/C++ 或辅助构建通用内容（printf Format Specifiers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0048|Revisiting step_function|78|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0048`；C/C++ 或辅助构建通用内容（Revisiting step_function）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0049|Comments|79|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0049`；C/C++ 或辅助构建通用内容（Comments）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0050|Debugging|79|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0050`；C/C++ 或辅助构建通用内容（Debugging）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0051|Visual Studio|79|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0051`；C/C++ 或辅助构建通用内容（Visual Studio）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0052|Xcode|81|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0052`；C/C++ 或辅助构建通用内容（Xcode）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0053|GCC and Clang Debugging with GDB and LLDB|83|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0053`；C/C++ 或辅助构建通用内容（GCC and Clang Debugging with GDB and LLDB）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0054|Summary|86|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0054`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0055|2: Types|89|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0055`；C/C++ 或辅助构建通用内容（2: Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0056|Fundamental Types|89|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0056`；C/C++ 或辅助构建通用内容（Fundamental Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0057|Integer Types|90|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0057`；C/C++ 或辅助构建通用内容（Integer Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0058|Floating-Point Types|93|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0058`；C/C++ 或辅助构建通用内容（Floating-Point Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0059|Character Types|94|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0059`；C/C++ 或辅助构建通用内容（Character Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0060|Boolean Types|96|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0060`；C/C++ 或辅助构建通用内容（Boolean Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0061|The std::byte Type|98|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0061`；C/C++ 或辅助构建通用内容（The std::byte Type）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0062|The size_t Type|99|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0062`；C/C++ 或辅助构建通用内容（The size_t Type）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0063|void|100|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0063`；C/C++ 或辅助构建通用内容（void）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0064|Arrays|100|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0064`；C/C++ 或辅助构建通用内容（Arrays）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0065|Array Initialization|100|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0065`；C/C++ 或辅助构建通用内容（Array Initialization）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0066|Accessing Array Elements|101|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0066`；C/C++ 或辅助构建通用内容（Accessing Array Elements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0067|A Nickel Tour of for Loops|101|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0067`；C/C++ 或辅助构建通用内容（A Nickel Tour of for Loops）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0068|C-Style Strings|103|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0068`；C/C++ 或辅助构建通用内容（C-Style Strings）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0069|User-Defined Types|107|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0069`；C/C++ 或辅助构建通用内容（User-Defined Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0070|Enumeration Types|107|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0070`；C/C++ 或辅助构建通用内容（Enumeration Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0071|Plain-Old-Data Classes|110|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0071`；C/C++ 或辅助构建通用内容（Plain-Old-Data Classes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0072|Unions|111|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0072`；C/C++ 或辅助构建通用内容（Unions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0073|Fully Featured C++ Classes|112|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0073`；C/C++ 或辅助构建通用内容（Fully Featured C++ Classes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0074|Methods|113|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0074`；C/C++ 或辅助构建通用内容（Methods）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0075|Access Controls|114|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0075`；C/C++ 或辅助构建通用内容（Access Controls）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0076|Constructors|116|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0076`；C/C++ 或辅助构建通用内容（Constructors）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0077|Initialization|117|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0077`；C/C++ 或辅助构建通用内容（Initialization）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0078|The Destructor|122|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0078`；C/C++ 或辅助构建通用内容（The Destructor）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0079|Summary|123|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0079`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0080|3: Reference Types|125|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0080`；C/C++ 或辅助构建通用内容（3: Reference Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0081|Pointers|125|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0081`；C/C++ 或辅助构建通用内容（Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0082|Addressing Variables|126|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0082`；C/C++ 或辅助构建通用内容（Addressing Variables）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0083|Dereferencing Pointers|128|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0083`；C/C++ 或辅助构建通用内容（Dereferencing Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0084|The Member-of-Pointer Operator|129|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0084`；C/C++ 或辅助构建通用内容（The Member-of-Pointer Operator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0085|Pointers and Arrays|130|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0085`；C/C++ 或辅助构建通用内容（Pointers and Arrays）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0086|Pointers Are Dangerous|132|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0086`；C/C++ 或辅助构建通用内容（Pointers Are Dangerous）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0087|void Pointers and std::byte Pointers|134|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0087`；C/C++ 或辅助构建通用内容（void Pointers and std::byte Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0088|nullptr and Boolean Expressions|134|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0088`；C/C++ 或辅助构建通用内容（nullptr and Boolean Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0089|References|135|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0089`；C/C++ 或辅助构建通用内容（References）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0090|Usage of Pointers and References|135|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0090`；C/C++ 或辅助构建通用内容（Usage of Pointers and References）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0091|Forward-Linked Lists: The Canonical Pointer-Based Data Structure|136|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0091`；C/C++ 或辅助构建通用内容（Forward-Linked Lists: The Canonical Pointer-Based Data Structure）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0092|Employing References|137|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0092`；C/C++ 或辅助构建通用内容（Employing References）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0093|this Pointers|138|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0093`；C/C++ 或辅助构建通用内容（this Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0094|const Correctness|139|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0094`；C/C++ 或辅助构建通用内容（const Correctness）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0095|const Member Variables|141|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0095`；C/C++ 或辅助构建通用内容（const Member Variables）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0096|Member Initializer Lists|141|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0096`；C/C++ 或辅助构建通用内容（Member Initializer Lists）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0097|auto Type Deduction|142|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0097`；C/C++ 或辅助构建通用内容（auto Type Deduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0098|Initialization with auto|142|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0098`；C/C++ 或辅助构建通用内容（Initialization with auto）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0099|auto and Reference Types|143|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0099`；C/C++ 或辅助构建通用内容（auto and Reference Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0100|auto and Code Refactorings|143|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0100`；C/C++ 或辅助构建通用内容（auto and Code Refactorings）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0101|Summary|144|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0101`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0102|4: The Object Life Cycle|147|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0102`；C/C++ 或辅助构建通用内容（4: The Object Life Cycle）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0103|An Object’s Storage Duration|147|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0103`；C/C++ 或辅助构建通用内容（An Object’s Storage Duration）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0104|Allocation, Deallocation, and Lifetime|148|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0104`；C/C++ 或辅助构建通用内容（Allocation, Deallocation, and Lifetime）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0105|Memory Management|148|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0105`；C/C++ 或辅助构建通用内容（Memory Management）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0106|Automatic Storage Duration|148|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0106`；C/C++ 或辅助构建通用内容（Automatic Storage Duration）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0107|Static Storage Duration|149|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0107`；C/C++ 或辅助构建通用内容（Static Storage Duration）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0108|Thread-Local Storage Duration|152|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0108`；C/C++ 或辅助构建通用内容（Thread-Local Storage Duration）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0109|Dynamic Storage Duration|153|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0109`；C/C++ 或辅助构建通用内容（Dynamic Storage Duration）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0110|Tracing the Object Life Cycle|154|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0110`；C/C++ 或辅助构建通用内容（Tracing the Object Life Cycle）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0111|Exceptions|156|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0111`；C/C++ 或辅助构建通用内容（Exceptions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0112|The throw Keyword|156|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0112`；C/C++ 或辅助构建通用内容（The throw Keyword）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0113|Using try-catch Blocks|157|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0113`；C/C++ 或辅助构建通用内容（Using try-catch Blocks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0114|stdlib Exception Classes|158|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0114`；C/C++ 或辅助构建通用内容（stdlib Exception Classes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0115|Handling Exceptions|160|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0115`；C/C++ 或辅助构建通用内容（Handling Exceptions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0116|User-Defined Exceptions|162|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0116`；C/C++ 或辅助构建通用内容（User-Defined Exceptions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0117|The noexcept Keyword|162|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0117`；C/C++ 或辅助构建通用内容（The noexcept Keyword）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0118|Call Stacks and Exceptions|163|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0118`；C/C++ 或辅助构建通用内容（Call Stacks and Exceptions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0119|A SimpleString Class|165|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0119`；C/C++ 或辅助构建通用内容（A SimpleString Class）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0120|Appending and Printing|166|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0120`；C/C++ 或辅助构建通用内容（Appending and Printing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0121|Using SimpleString|167|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0121`；C/C++ 或辅助构建通用内容（Using SimpleString）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0122|Composing a SimpleString|168|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0122`；C/C++ 或辅助构建通用内容（Composing a SimpleString）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0123|Call Stack Unwinding|169|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0123`；C/C++ 或辅助构建通用内容（Call Stack Unwinding）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0124|Exceptions and Performance|171|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0124`；C/C++ 或辅助构建通用内容（Exceptions and Performance）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0125|Alternatives to Exceptions|172|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0125`；C/C++ 或辅助构建通用内容（Alternatives to Exceptions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0126|Copy Semantics|173|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0126`；C/C++ 或辅助构建通用内容（Copy Semantics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0127|Copy Constructors|175|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0127`；C/C++ 或辅助构建通用内容（Copy Constructors）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0128|Copy Assignment|177|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0128`；C/C++ 或辅助构建通用内容（Copy Assignment）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0129|Default Copy|179|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0129`；C/C++ 或辅助构建通用内容（Default Copy）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0130|Copy Guidelines|180|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0130`；C/C++ 或辅助构建通用内容（Copy Guidelines）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0131|Move Semantics|180|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0131`；C/C++ 或辅助构建通用内容（Move Semantics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0132|Copying Can Be Wasteful|180|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0132`；C/C++ 或辅助构建通用内容（Copying Can Be Wasteful）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0133|Value Categories|182|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0133`；C/C++ 或辅助构建通用内容（Value Categories）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0134|lvalue and rvalue References|182|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0134`；C/C++ 或辅助构建通用内容（lvalue and rvalue References）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0135|The std::move Function|183|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0135`；C/C++ 或辅助构建通用内容（The std::move Function）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0136|Move Construction|184|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0136`；C/C++ 或辅助构建通用内容（Move Construction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0137|Move Assignment|184|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0137`；C/C++ 或辅助构建通用内容（Move Assignment）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0138|The Final Product|186|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0138`；C/C++ 或辅助构建通用内容（The Final Product）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0139|Compiler-Generated Methods|187|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0139`；C/C++ 或辅助构建通用内容（Compiler-Generated Methods）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0140|Summary|188|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0140`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0141|5: Runtime Polymorphism|191|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0141`；C/C++ 或辅助构建通用内容（5: Runtime Polymorphism）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0142|Polymorphism|192|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0142`；C/C++ 或辅助构建通用内容（Polymorphism）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0143|A Motivating Example|192|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0143`；C/C++ 或辅助构建通用内容（A Motivating Example）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0144|Adding New Loggers|194|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0144`；C/C++ 或辅助构建通用内容（Adding New Loggers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0145|Interfaces|195|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0145`；C/C++ 或辅助构建通用内容（Interfaces）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0146|Object Composition and Implementation Inheritance|195|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0146`；C/C++ 或辅助构建通用内容（Object Composition and Implementation Inheritance）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0147|Defining Interfaces|196|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0147`；C/C++ 或辅助构建通用内容（Defining Interfaces）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0148|Base Class Inheritance|196|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0148`；C/C++ 或辅助构建通用内容（Base Class Inheritance）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0149|Member Inheritance|197|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0149`；C/C++ 或辅助构建通用内容（Member Inheritance）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0150|virtual Methods|198|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0150`；C/C++ 或辅助构建通用内容（virtual Methods）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0151|Pure-Virtual Classes and Virtual Destructors|200|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0151`；C/C++ 或辅助构建通用内容（Pure-Virtual Classes and Virtual Destructors）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0152|Implementing Interfaces|201|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0152`；C/C++ 或辅助构建通用内容（Implementing Interfaces）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0153|Using Interfaces|202|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0153`；C/C++ 或辅助构建通用内容（Using Interfaces）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0154|Updating the Bank Logger|202|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0154`；C/C++ 或辅助构建通用内容（Updating the Bank Logger）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0155|Constructor Injection|203|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0155`；C/C++ 或辅助构建通用内容（Constructor Injection）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0156|Property Injection|204|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0156`；C/C++ 或辅助构建通用内容（Property Injection）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0157|Choosing Constructor or Property Injection|204|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0157`；C/C++ 或辅助构建通用内容（Choosing Constructor or Property Injection）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0158|Summary|205|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0158`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0159|6: Compile-Time Polymorphism|207|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0159`；C/C++ 或辅助构建通用内容（6: Compile-Time Polymorphism）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0160|Templates|207|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0160`；C/C++ 或辅助构建通用内容（Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0161|Declaring Templates|208|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0161`；C/C++ 或辅助构建通用内容（Declaring Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0162|Template Class Definitions|208|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0162`；C/C++ 或辅助构建通用内容（Template Class Definitions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0163|Template Function Definitions|209|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0163`；C/C++ 或辅助构建通用内容（Template Function Definitions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0164|Instantiating Templates|209|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0164`；C/C++ 或辅助构建通用内容（Instantiating Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0165|Named Conversion Functions|209|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0165`；C/C++ 或辅助构建通用内容（Named Conversion Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0166|const_cast|210|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0166`；C/C++ 或辅助构建通用内容（const_cast）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0167|static_cast|210|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0167`；C/C++ 或辅助构建通用内容（static_cast）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0168|reinterpret_cast|211|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0168`；C/C++ 或辅助构建通用内容（reinterpret_cast）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0169|narrow_cast|212|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0169`；C/C++ 或辅助构建通用内容（narrow_cast）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0170|mean: A Template Function Example|213|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0170`；C/C++ 或辅助构建通用内容（mean: A Template Function Example）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0171|Genericizing mean|214|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0171`；C/C++ 或辅助构建通用内容（Genericizing mean）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0172|Template Type Deduction|216|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0172`；C/C++ 或辅助构建通用内容（Template Type Deduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0173|SimpleUniquePointer: A Template Class Example|217|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0173`；C/C++ 或辅助构建通用内容（SimpleUniquePointer: A Template Class Example）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0174|Type Checking in Templates|219|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0174`；C/C++ 或辅助构建通用内容（Type Checking in Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0175|Concepts|221|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0175`；C/C++ 或辅助构建通用内容（Concepts）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0176|Defining a Concept|222|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0176`；C/C++ 或辅助构建通用内容（Defining a Concept）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0177|Type Traits|222|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0177`；C/C++ 或辅助构建通用内容（Type Traits）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0178|Requirements|224|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0178`；C/C++ 或辅助构建通用内容（Requirements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0179|Building Concepts from Requires Expressions|225|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0179`；C/C++ 或辅助构建通用内容（Building Concepts from Requires Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0180|Using Concepts|226|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0180`；C/C++ 或辅助构建通用内容（Using Concepts）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0181|Ad Hoc Requires Expressions|230|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0181`；C/C++ 或辅助构建通用内容（Ad Hoc Requires Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0182|static_assert: The Preconcepts Stopgap|231|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0182`；C/C++ 或辅助构建通用内容（static_assert: The Preconcepts Stopgap）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0183|Non-Type Template Parameters|232|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0183`；C/C++ 或辅助构建通用内容（Non-Type Template Parameters）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0184|Variadic Templates|235|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0184`；C/C++ 或辅助构建通用内容（Variadic Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0185|Advanced Template Topics|235|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0185`；C/C++ 或辅助构建通用内容（Advanced Template Topics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0186|Template Specialization|236|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0186`；C/C++ 或辅助构建通用内容（Template Specialization）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0187|Name Binding|236|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0187`；C/C++ 或辅助构建通用内容（Name Binding）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0188|Type Function|236|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0188`；C/C++ 或辅助构建通用内容（Type Function）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0189|Template Metaprogramming|236|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0189`；C/C++ 或辅助构建通用内容（Template Metaprogramming）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0190|Template Source Code Organization|237|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0190`；C/C++ 或辅助构建通用内容（Template Source Code Organization）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0191|Polymorphism at Runtime vs. Compile Time|237|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0191`；C/C++ 或辅助构建通用内容（Polymorphism at Runtime vs. Compile Time）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0192|Summary|237|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0192`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0193|7: Expressions|239|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0193`；C/C++ 或辅助构建通用内容（7: Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0194|Operators|240|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0194`；C/C++ 或辅助构建通用内容（Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0195|Logical Operators|240|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0195`；C/C++ 或辅助构建通用内容（Logical Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0196|Arithmetic Operators|240|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0196`；C/C++ 或辅助构建通用内容（Arithmetic Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0197|Assignment Operators|242|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0197`；C/C++ 或辅助构建通用内容（Assignment Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0198|Increment and Decrement Operators|243|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0198`；C/C++ 或辅助构建通用内容（Increment and Decrement Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0199|Comparison Operators|243|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0199`；C/C++ 或辅助构建通用内容（Comparison Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0200|Member Access Operators|243|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0200`；C/C++ 或辅助构建通用内容（Member Access Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0201|Ternary Conditional Operator|244|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0201`；C/C++ 或辅助构建通用内容（Ternary Conditional Operator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0202|The Comma Operator|244|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0202`；C/C++ 或辅助构建通用内容（The Comma Operator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0203|Operator Overloading|245|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0203`；C/C++ 或辅助构建通用内容（Operator Overloading）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0204|Overloading Operator new|247|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0204`；C/C++ 或辅助构建通用内容（Overloading Operator new）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0205|Operator Precedence and Associativity|252|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0205`；C/C++ 或辅助构建通用内容（Operator Precedence and Associativity）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0206|Evaluation Order|254|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0206`；C/C++ 或辅助构建通用内容（Evaluation Order）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0207|User-Defined Literals|255|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0207`；C/C++ 或辅助构建通用内容（User-Defined Literals）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0208|Type Conversions|256|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0208`；C/C++ 或辅助构建通用内容（Type Conversions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0209|Implicit Type Conversions|256|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0209`；C/C++ 或辅助构建通用内容（Implicit Type Conversions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0210|Explicit Type Conversion|259|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0210`；C/C++ 或辅助构建通用内容（Explicit Type Conversion）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0211|C-Style Casts|260|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0211`；C/C++ 或辅助构建通用内容（C-Style Casts）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0212|User-Defined Type Conversions|261|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0212`；C/C++ 或辅助构建通用内容（User-Defined Type Conversions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0213|Constant Expressions|262|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0213`；C/C++ 或辅助构建通用内容（Constant Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0214|A Colorful Example|263|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0214`；C/C++ 或辅助构建通用内容（A Colorful Example）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0215|The Case for constexpr|265|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0215`；C/C++ 或辅助构建通用内容（The Case for constexpr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0216|Volatile Expressions|265|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0216`；C/C++ 或辅助构建通用内容（Volatile Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0217|Summary|267|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0217`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0218|8: Statements|269|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0218`；C/C++ 或辅助构建通用内容（8: Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0219|Expression Statements|269|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0219`；C/C++ 或辅助构建通用内容（Expression Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0220|Compound Statements|270|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0220`；C/C++ 或辅助构建通用内容（Compound Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0221|Declaration Statements|271|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0221`；C/C++ 或辅助构建通用内容（Declaration Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0222|Functions|271|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0222`；C/C++ 或辅助构建通用内容（Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0223|Namespaces|274|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0223`；C/C++ 或辅助构建通用内容（Namespaces）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0224|Type Aliasing|278|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0224`；C/C++ 或辅助构建通用内容（Type Aliasing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0225|Structured Bindings|280|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0225`；C/C++ 或辅助构建通用内容（Structured Bindings）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0226|Attributes|281|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0226`；C/C++ 或辅助构建通用内容（Attributes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0227|Selection Statements|283|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0227`；C/C++ 或辅助构建通用内容（Selection Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0228|if Statements|283|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0228`；C/C++ 或辅助构建通用内容（if Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0229|switch Statements|287|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0229`；C/C++ 或辅助构建通用内容（switch Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0230|Iteration Statements|288|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0230`；C/C++ 或辅助构建通用内容（Iteration Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0231|while Loops|288|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0231`；C/C++ 或辅助构建通用内容（while Loops）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0232|do-while Loops|289|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0232`；C/C++ 或辅助构建通用内容（do-while Loops）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0233|for Loops|290|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0233`；C/C++ 或辅助构建通用内容（for Loops）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0234|Ranged-Based for Loops|292|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0234`；C/C++ 或辅助构建通用内容（Ranged-Based for Loops）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0235|Jump Statements|296|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0235`；C/C++ 或辅助构建通用内容（Jump Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0236|break Statements|296|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0236`；C/C++ 或辅助构建通用内容（break Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0237|continue Statements|297|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0237`；C/C++ 或辅助构建通用内容（continue Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0238|goto Statements|297|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0238`；C/C++ 或辅助构建通用内容（goto Statements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0239|Summary|299|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0239`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0240|9: Functions|301|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0240`；C/C++ 或辅助构建通用内容（9: Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0241|Function Declarations|302|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0241`；C/C++ 或辅助构建通用内容（Function Declarations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0242|Prefix Modifiers|302|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0242`；C/C++ 或辅助构建通用内容（Prefix Modifiers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0243|Suffix Modifiers|303|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0243`；C/C++ 或辅助构建通用内容（Suffix Modifiers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0244|auto Return Types|305|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0244`；C/C++ 或辅助构建通用内容（auto Return Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0245|auto and Function Templates|306|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0245`；C/C++ 或辅助构建通用内容（auto and Function Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0246|Overload Resolution|307|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0246`；C/C++ 或辅助构建通用内容（Overload Resolution）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0247|Variadic Functions|308|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0247`；C/C++ 或辅助构建通用内容（Variadic Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0248|Variadic Templates|309|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0248`；C/C++ 或辅助构建通用内容（Variadic Templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0249|Programming with Parameter Packs|310|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0249`；C/C++ 或辅助构建通用内容（Programming with Parameter Packs）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0250|Revisiting the sum Function|310|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0250`；C/C++ 或辅助构建通用内容（Revisiting the sum Function）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0251|Fold Expressions|311|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0251`；C/C++ 或辅助构建通用内容（Fold Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0252|Function Pointers|312|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0252`；C/C++ 或辅助构建通用内容（Function Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0253|Declaring a Function Pointer|312|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0253`；C/C++ 或辅助构建通用内容（Declaring a Function Pointer）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0254|Type Aliases and Function Pointers|313|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0254`；C/C++ 或辅助构建通用内容（Type Aliases and Function Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0255|The Function-Call Operator|313|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0255`；C/C++ 或辅助构建通用内容（The Function-Call Operator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0256|A Counting Example|314|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0256`；C/C++ 或辅助构建通用内容（A Counting Example）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0257|Lambda Expressions|316|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0257`；C/C++ 或辅助构建通用内容（Lambda Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0258|Usage|316|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0258`；C/C++ 或辅助构建通用内容（Usage）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0259|Lambda Parameters and Bodies|317|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0259`；C/C++ 或辅助构建通用内容（Lambda Parameters and Bodies）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0260|Default Arguments|318|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0260`；C/C++ 或辅助构建通用内容（Default Arguments）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0261|Generic Lambdas|319|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0261`；C/C++ 或辅助构建通用内容（Generic Lambdas）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0262|Lambda Return Types|320|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0262`；C/C++ 或辅助构建通用内容（Lambda Return Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0263|Lambda Captures|320|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0263`；C/C++ 或辅助构建通用内容（Lambda Captures）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0264|constexpr Lambda Expressions|326|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0264`；C/C++ 或辅助构建通用内容（constexpr Lambda Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0265|std::function|327|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0265`；C/C++ 或辅助构建通用内容（std::function）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0266|Declaring a Function|327|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0266`；C/C++ 或辅助构建通用内容（Declaring a Function）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0267|An Extended Example|328|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0267`；C/C++ 或辅助构建通用内容（An Extended Example）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0268|The main Function and the Command Line|330|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0268`；C/C++ 或辅助构建通用内容（The main Function and the Command Line）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0269|The Three main Overloads|330|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0269`；C/C++ 或辅助构建通用内容（The Three main Overloads）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0270|Exploring Program Parameters|331|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0270`；C/C++ 或辅助构建通用内容（Exploring Program Parameters）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0271|A More Involved Example|332|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0271`；C/C++ 或辅助构建通用内容（A More Involved Example）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0272|Exit Status|334|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0272`；C/C++ 或辅助构建通用内容（Exit Status）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0273|Summary|335|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0273`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0274|PART II: C++ Libraries and Frameworks|337|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0274`；C/C++ 或辅助构建通用内容（PART II: C++ Libraries and Frameworks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0275|10: Testing|339|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0275`；C/C++ 或辅助构建通用内容（10: Testing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0276|Unit Tests|340|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0276`；C/C++ 或辅助构建通用内容（Unit Tests）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0277|Integration Tests|340|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0277`；C/C++ 或辅助构建通用内容（Integration Tests）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0278|Acceptance Tests|340|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0278`；C/C++ 或辅助构建通用内容（Acceptance Tests）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0279|Performance Tests|340|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0279`；C/C++ 或辅助构建通用内容（Performance Tests）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0280|An Extended Example: Taking a Brake|341|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0280`；C/C++ 或辅助构建通用内容（An Extended Example: Taking a Brake）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0281|Implementing AutoBrake|343|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0281`；C/C++ 或辅助构建通用内容（Implementing AutoBrake）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0282|Test-Driven Development|344|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0282`；C/C++ 或辅助构建通用内容（Test-Driven Development）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0283|Adding a Service-Bus Interface|355|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0283`；C/C++ 或辅助构建通用内容（Adding a Service-Bus Interface）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0284|Unit-Testing and Mocking Frameworks|362|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0284`；C/C++ 或辅助构建通用内容（Unit-Testing and Mocking Frameworks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0285|The Catch Unit-Testing Framework|362|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0285`；C/C++ 或辅助构建通用内容（The Catch Unit-Testing Framework）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0286|Google Test|368|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0286`；C/C++ 或辅助构建通用内容（Google Test）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0287|Boost Test|375|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0287`；C/C++ 或辅助构建通用内容（Boost Test）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0288|Summary: Testing Frameworks|380|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0288`；C/C++ 或辅助构建通用内容（Summary: Testing Frameworks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0289|Mocking Frameworks|381|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0289`；C/C++ 或辅助构建通用内容（Mocking Frameworks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0290|Google Mock|382|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0290`；C/C++ 或辅助构建通用内容（Google Mock）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0291|HippoMocks|390|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0291`；C/C++ 或辅助构建通用内容（HippoMocks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0292|A Note on Other Mocking Options: FakeIt and Trompeloeil|395|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0292`；C/C++ 或辅助构建通用内容（A Note on Other Mocking Options: FakeIt and Trompeloeil）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0293|Summary|395|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0293`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0294|11: Smart Pointers|399|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S02.md#review-s02-u0294`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S02-U0295|Smart Pointers|399|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0295`；C/C++ 或辅助构建通用内容（Smart Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0296|Smart Pointer Ownership|400|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0296`；C/C++ 或辅助构建通用内容（Smart Pointer Ownership）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0297|Scoped Pointers|400|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0297`；C/C++ 或辅助构建通用内容（Scoped Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0298|Constructing|400|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0298`；C/C++ 或辅助构建通用内容（Constructing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0299|Bring in the Oath Breakers|401|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0299`；C/C++ 或辅助构建通用内容（Bring in the Oath Breakers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0300|Implicit bool Conversion Based on Ownership|402|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0300`；C/C++ 或辅助构建通用内容（Implicit bool Conversion Based on Ownership）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0301|RAII Wrapper|402|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0301`；C/C++ 或辅助构建通用内容（RAII Wrapper）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0302|Pointer Semantics|403|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0302`；C/C++ 或辅助构建通用内容（Pointer Semantics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0303|Comparison with nullptr|404|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0303`；C/C++ 或辅助构建通用内容（Comparison with nullptr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0304|Swapping|404|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0304`；C/C++ 或辅助构建通用内容（Swapping）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0305|Resetting and Replacing a scoped_ptr|405|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0305`；C/C++ 或辅助构建通用内容（Resetting and Replacing a scoped_ptr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0306|Non-transferability|406|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0306`；C/C++ 或辅助构建通用内容（Non-transferability）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0307|boost::scoped_array|406|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0307`；C/C++ 或辅助构建通用内容（boost::scoped_array）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0308|A Partial List of Supported Operations|407|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0308`；C/C++ 或辅助构建通用内容（A Partial List of Supported Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0309|Unique Pointers|407|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0309`；C/C++ 或辅助构建通用内容（Unique Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0310|Constructing|408|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0310`；C/C++ 或辅助构建通用内容（Constructing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0311|Supported Operations|408|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0311`；C/C++ 或辅助构建通用内容（Supported Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0312|Transferable, Exclusive Ownership|408|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0312`；C/C++ 或辅助构建通用内容（Transferable, Exclusive Ownership）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0313|Unique Arrays|409|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0313`；C/C++ 或辅助构建通用内容（Unique Arrays）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0314|Deleters|410|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0314`；C/C++ 或辅助构建通用内容（Deleters）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0315|Custom Deleters and System Programming|410|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0315`；C/C++ 或辅助构建通用内容（Custom Deleters and System Programming）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0316|A Partial List of Supported Operations|412|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0316`；C/C++ 或辅助构建通用内容（A Partial List of Supported Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0317|Shared Pointers|413|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0317`；C/C++ 或辅助构建通用内容（Shared Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0318|Constructing|414|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0318`；C/C++ 或辅助构建通用内容（Constructing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0319|Specifying an Allocator|414|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0319`；C/C++ 或辅助构建通用内容（Specifying an Allocator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0320|Supported Operations|415|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0320`；C/C++ 或辅助构建通用内容（Supported Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0321|Transferable, Non-Exclusive Ownership|416|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0321`；C/C++ 或辅助构建通用内容（Transferable, Non-Exclusive Ownership）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0322|Shared Arrays|416|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0322`；C/C++ 或辅助构建通用内容（Shared Arrays）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0323|Deleters|417|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0323`；C/C++ 或辅助构建通用内容（Deleters）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0324|A Partial List of Supported Operations|417|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0324`；C/C++ 或辅助构建通用内容（A Partial List of Supported Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0325|Weak Pointers|418|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0325`；C/C++ 或辅助构建通用内容（Weak Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0326|Constructing|419|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0326`；C/C++ 或辅助构建通用内容（Constructing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0327|Obtaining Temporary Ownership|419|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0327`；C/C++ 或辅助构建通用内容（Obtaining Temporary Ownership）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0328|Advanced Patterns|420|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0328`；C/C++ 或辅助构建通用内容（Advanced Patterns）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0329|Supported Operations|420|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0329`；C/C++ 或辅助构建通用内容（Supported Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0330|Intrusive Pointers|421|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0330`；C/C++ 或辅助构建通用内容（Intrusive Pointers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0331|Summary of Smart Pointer Options|422|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0331`；C/C++ 或辅助构建通用内容（Summary of Smart Pointer Options）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0332|Allocators|423|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0332`；C/C++ 或辅助构建通用内容（Allocators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0333|Summary|425|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0333`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0334|12: Utilities|427|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0334`；C/C++ 或辅助构建通用内容（12: Utilities）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0335|Data Structures|428|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0335`；C/C++ 或辅助构建通用内容（Data Structures）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0336|tribool|428|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0336`；C/C++ 或辅助构建通用内容（tribool）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0337|optional|430|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0337`；C/C++ 或辅助构建通用内容（optional）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0338|pair|432|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0338`；C/C++ 或辅助构建通用内容（pair）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0339|tuple|434|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0339`；C/C++ 或辅助构建通用内容（tuple）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0340|any|436|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0340`；C/C++ 或辅助构建通用内容（any）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0341|variant|437|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0341`；C/C++ 或辅助构建通用内容（variant）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0342|Date and Time|440|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0342`；C/C++ 或辅助构建通用内容（Date and Time）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0343|Boost DateTime|441|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0343`；C/C++ 或辅助构建通用内容（Boost DateTime）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0344|Chrono|445|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0344`；C/C++ 或辅助构建通用内容（Chrono）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0345|Numerics|450|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0345`；C/C++ 或辅助构建通用内容（Numerics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0346|Numeric Functions|450|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0346`；C/C++ 或辅助构建通用内容（Numeric Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0347|Complex Numbers|451|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0347`；C/C++ 或辅助构建通用内容（Complex Numbers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0348|Mathematical Constants|452|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0348`；C/C++ 或辅助构建通用内容（Mathematical Constants）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0349|Random Numbers|454|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0349`；C/C++ 或辅助构建通用内容（Random Numbers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0350|Numeric Limits|458|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0350`；C/C++ 或辅助构建通用内容（Numeric Limits）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0351|Boost Numeric Conversion|459|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0351`；C/C++ 或辅助构建通用内容（Boost Numeric Conversion）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0352|Compile-Time Rational Arithmetic|461|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0352`；C/C++ 或辅助构建通用内容（Compile-Time Rational Arithmetic）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0353|Summary|463|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0353`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0354|13: Containers|465|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0354`；C/C++ 或辅助构建通用内容（13: Containers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0355|Sequence Containers|466|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0355`；C/C++ 或辅助构建通用内容（Sequence Containers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0356|Arrays|466|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0356`；C/C++ 或辅助构建通用内容（Arrays）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0357|Vectors|473|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0357`；C/C++ 或辅助构建通用内容（Vectors）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0358|Niche Sequential Containers|481|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0358`；C/C++ 或辅助构建通用内容（Niche Sequential Containers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0359|Associative Containers|492|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0359`；C/C++ 或辅助构建通用内容（Associative Containers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0360|Sets|493|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0360`；C/C++ 或辅助构建通用内容（Sets）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0361|Unordered Sets|500|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0361`；C/C++ 或辅助构建通用内容（Unordered Sets）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0362|Maps|504|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0362`；C/C++ 或辅助构建通用内容（Maps）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0363|Niche Associative Containers|511|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0363`；C/C++ 或辅助构建通用内容（Niche Associative Containers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0364|Graphs and Property Trees|512|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0364`；C/C++ 或辅助构建通用内容（Graphs and Property Trees）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0365|The Boost Graph Library|513|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0365`；C/C++ 或辅助构建通用内容（The Boost Graph Library）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0366|Boost Property Trees|514|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0366`；C/C++ 或辅助构建通用内容（Boost Property Trees）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0367|Initializer Lists|515|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0367`；C/C++ 或辅助构建通用内容（Initializer Lists）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0368|Summary|517|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0368`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0369|14: Iterators|521|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0369`；C/C++ 或辅助构建通用内容（14: Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0370|Iterator Categories|522|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0370`；C/C++ 或辅助构建通用内容（Iterator Categories）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0371|Output Iterators|522|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0371`；C/C++ 或辅助构建通用内容（Output Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0372|Input Iterators|524|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0372`；C/C++ 或辅助构建通用内容（Input Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0373|Forward Iterators|525|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0373`；C/C++ 或辅助构建通用内容（Forward Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0374|Bidirectional Iterators|526|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0374`；C/C++ 或辅助构建通用内容（Bidirectional Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0375|Random-Access Iterators|527|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0375`；C/C++ 或辅助构建通用内容（Random-Access Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0376|Contiguous Iterators|529|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0376`；C/C++ 或辅助构建通用内容（Contiguous Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0377|Mutable Iterators|529|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0377`；C/C++ 或辅助构建通用内容（Mutable Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0378|Auxiliary Iterator Functions|530|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0378`；C/C++ 或辅助构建通用内容（Auxiliary Iterator Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0379|std::advance|530|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0379`；C/C++ 或辅助构建通用内容（std::advance）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0380|std::next and std::prev|531|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0380`；C/C++ 或辅助构建通用内容（std::next and std::prev）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0381|std::distance|533|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0381`；C/C++ 或辅助构建通用内容（std::distance）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0382|std::iter_swap|533|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0382`；C/C++ 或辅助构建通用内容（std::iter_swap）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0383|Additional Iterator Adapters|534|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0383`；C/C++ 或辅助构建通用内容（Additional Iterator Adapters）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0384|Move Iterator Adapters|534|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0384`；C/C++ 或辅助构建通用内容（Move Iterator Adapters）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0385|Reverse Iterator Adapters|535|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0385`；C/C++ 或辅助构建通用内容（Reverse Iterator Adapters）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0386|Summary|537|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0386`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0387|15: Strings|539|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0387`；C/C++ 或辅助构建通用内容（15: Strings）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0388|std::string|540|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0388`；C/C++ 或辅助构建通用内容（std::string）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0389|Constructing|540|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0389`；C/C++ 或辅助构建通用内容（Constructing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0390|String Storage and Small String Optimizations|543|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0390`；C/C++ 或辅助构建通用内容（String Storage and Small String Optimizations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0391|Element and Iterator Access|544|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0391`；C/C++ 或辅助构建通用内容（Element and Iterator Access）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0392|String Comparisons|546|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0392`；C/C++ 或辅助构建通用内容（String Comparisons）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0393|Manipulating Elements|547|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0393`；C/C++ 或辅助构建通用内容（Manipulating Elements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0394|Search|552|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0394`；C/C++ 或辅助构建通用内容（Search）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0395|Numeric Conversions|556|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0395`；C/C++ 或辅助构建通用内容（Numeric Conversions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0396|String View|558|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0396`；C/C++ 或辅助构建通用内容（String View）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0397|Constructing|559|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0397`；C/C++ 或辅助构建通用内容（Constructing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0398|Supported string_view Operations|560|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0398`；C/C++ 或辅助构建通用内容（Supported string_view Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0399|Ownership, Usage, and Efficiency|560|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0399`；C/C++ 或辅助构建通用内容（Ownership, Usage, and Efficiency）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0400|Regular Expressions|561|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0400`；C/C++ 或辅助构建通用内容（Regular Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0401|Patterns|562|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0401`；C/C++ 或辅助构建通用内容（Patterns）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0402|basic_regex|564|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0402`；C/C++ 或辅助构建通用内容（basic_regex）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0403|Algorithms|564|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0403`；C/C++ 或辅助构建通用内容（Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0404|Boost String Algorithms|568|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0404`；C/C++ 或辅助构建通用内容（Boost String Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0405|Boost Range|568|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0405`；C/C++ 或辅助构建通用内容（Boost Range）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0406|Predicates|569|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0406`；C/C++ 或辅助构建通用内容（Predicates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0407|Classifiers|570|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0407`；C/C++ 或辅助构建通用内容（Classifiers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0408|Finders|572|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0408`；C/C++ 或辅助构建通用内容（Finders）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0409|Modifying Algorithms|573|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0409`；C/C++ 或辅助构建通用内容（Modifying Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0410|Splitting and Joining|575|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0410`；C/C++ 或辅助构建通用内容（Splitting and Joining）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0411|Searching|577|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0411`；C/C++ 或辅助构建通用内容（Searching）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0412|Boost Tokenizer|578|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0412`；C/C++ 或辅助构建通用内容（Boost Tokenizer）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0413|Localizations|579|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0413`；C/C++ 或辅助构建通用内容（Localizations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0414|Summary|579|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0414`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0415|16: Streams|581|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0415`；C/C++ 或辅助构建通用内容（16: Streams）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0416|Streams|581|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0416`；C/C++ 或辅助构建通用内容（Streams）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0417|Stream Classes|582|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0417`；C/C++ 或辅助构建通用内容（Stream Classes）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0418|Stream State|588|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0418`；C/C++ 或辅助构建通用内容（Stream State）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0419|Buffering and Flushing|590|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0419`；C/C++ 或辅助构建通用内容（Buffering and Flushing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0420|Manipulators|591|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0420`；C/C++ 或辅助构建通用内容（Manipulators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0421|User-Defined Types|593|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0421`；C/C++ 或辅助构建通用内容（User-Defined Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0422|String Streams|596|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0422`；C/C++ 或辅助构建通用内容（String Streams）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0423|File Streams|599|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0423`；C/C++ 或辅助构建通用内容（File Streams）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0424|Stream Buffers|604|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0424`；C/C++ 或辅助构建通用内容（Stream Buffers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0425|Random Access|606|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0425`；C/C++ 或辅助构建通用内容（Random Access）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0426|Summary|607|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0426`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0427|17: Filesystems|609|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0427`；C/C++ 或辅助构建通用内容（17: Filesystems）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0428|Filesystem Concepts|610|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0428`；C/C++ 或辅助构建通用内容（Filesystem Concepts）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0429|std::filesystem::path|610|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0429`；C/C++ 或辅助构建通用内容（std::filesystem::path）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0430|Constructing Paths|610|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0430`；C/C++ 或辅助构建通用内容（Constructing Paths）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0431|Decomposing Paths|611|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0431`；C/C++ 或辅助构建通用内容（Decomposing Paths）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0432|Modifying Paths|612|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0432`；C/C++ 或辅助构建通用内容（Modifying Paths）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0433|Summary of Filesystem Path Methods|613|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0433`；C/C++ 或辅助构建通用内容（Summary of Filesystem Path Methods）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0434|Files and Directories|615|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0434`；C/C++ 或辅助构建通用内容（Files and Directories）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0435|Error Handling|615|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0435`；C/C++ 或辅助构建通用内容（Error Handling）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0436|Path-Composing Functions|616|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0436`；C/C++ 或辅助构建通用内容（Path-Composing Functions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0437|Inspecting File Types|617|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0437`；C/C++ 或辅助构建通用内容（Inspecting File Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0438|Inspecting Files and Directories|619|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0438`；C/C++ 或辅助构建通用内容（Inspecting Files and Directories）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0439|Manipulating Files and Directories|620|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0439`；C/C++ 或辅助构建通用内容（Manipulating Files and Directories）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0440|Directory Iterators|622|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0440`；C/C++ 或辅助构建通用内容（Directory Iterators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0441|Constructing|622|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0441`；C/C++ 或辅助构建通用内容（Constructing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0442|Directory Entries|623|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0442`；C/C++ 或辅助构建通用内容（Directory Entries）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0443|Recursive Directory Iteration|625|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0443`；C/C++ 或辅助构建通用内容（Recursive Directory Iteration）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0444|fstream Interoperation|627|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0444`；C/C++ 或辅助构建通用内容（fstream Interoperation）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0445|Summary|628|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0445`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0446|18: Algorithms|631|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0446`；C/C++ 或辅助构建通用内容（18: Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0447|Algorithmic Complexity|632|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0447`；C/C++ 或辅助构建通用内容（Algorithmic Complexity）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0448|Execution Policies|633|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0448`；C/C++ 或辅助构建通用内容（Execution Policies）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0449|Non-Modifying Sequence Operations|634|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0449`；C/C++ 或辅助构建通用内容（Non-Modifying Sequence Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0450|all_of|634|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0450`；C/C++ 或辅助构建通用内容（all_of）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0451|any_of|635|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0451`；C/C++ 或辅助构建通用内容（any_of）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0452|none_of|636|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0452`；C/C++ 或辅助构建通用内容（none_of）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0453|for_each|637|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0453`；C/C++ 或辅助构建通用内容（for_each）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0454|for_each_n|638|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0454`；C/C++ 或辅助构建通用内容（for_each_n）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0455|find, find_if, and find_if_not|639|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0455`；C/C++ 或辅助构建通用内容（find, find_if, and find_if_not）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0456|find_end|640|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0456`；C/C++ 或辅助构建通用内容（find_end）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0457|find_first|642|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0457`；C/C++ 或辅助构建通用内容（find_first）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0458|adjacent_find|643|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0458`；C/C++ 或辅助构建通用内容（adjacent_find）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0459|count|644|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0459`；C/C++ 或辅助构建通用内容（count）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0460|mismatch|645|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0460`；C/C++ 或辅助构建通用内容（mismatch）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0461|equal|646|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0461`；C/C++ 或辅助构建通用内容（equal）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0462|is_permutation|647|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0462`；C/C++ 或辅助构建通用内容（is_permutation）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0463|search|648|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0463`；C/C++ 或辅助构建通用内容（search）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0464|search_n|649|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0464`；C/C++ 或辅助构建通用内容（search_n）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0465|Mutating Sequence Operations|650|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0465`；C/C++ 或辅助构建通用内容（Mutating Sequence Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0466|copy|650|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0466`；C/C++ 或辅助构建通用内容（copy）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0467|copy_n|651|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0467`；C/C++ 或辅助构建通用内容（copy_n）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0468|copy_backward|652|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0468`；C/C++ 或辅助构建通用内容（copy_backward）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0469|move|653|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0469`；C/C++ 或辅助构建通用内容（move）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0470|move_backward|654|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0470`；C/C++ 或辅助构建通用内容（move_backward）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0471|swap_ranges|655|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0471`；C/C++ 或辅助构建通用内容（swap_ranges）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0472|transform|656|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0472`；C/C++ 或辅助构建通用内容（transform）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0473|replace|658|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0473`；C/C++ 或辅助构建通用内容（replace）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0474|fill|659|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0474`；C/C++ 或辅助构建通用内容（fill）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0475|generate|660|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0475`；C/C++ 或辅助构建通用内容（generate）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0476|remove|661|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0476`；C/C++ 或辅助构建通用内容（remove）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0477|unique|663|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0477`；C/C++ 或辅助构建通用内容（unique）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0478|reverse|664|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0478`；C/C++ 或辅助构建通用内容（reverse）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0479|sample|665|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0479`；C/C++ 或辅助构建通用内容（sample）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0480|shuffle|667|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0480`；C/C++ 或辅助构建通用内容（shuffle）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0481|Sorting and Related Operations|669|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0481`；C/C++ 或辅助构建通用内容（Sorting and Related Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0482|sort|669|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0482`；C/C++ 或辅助构建通用内容（sort）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0483|stable_sort|670|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0483`；C/C++ 或辅助构建通用内容（stable_sort）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0484|partial_sort|672|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0484`；C/C++ 或辅助构建通用内容（partial_sort）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0485|is_sorted|673|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0485`；C/C++ 或辅助构建通用内容（is_sorted）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0486|nth_element|674|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0486`；C/C++ 或辅助构建通用内容（nth_element）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0487|Binary Search|675|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0487`；C/C++ 或辅助构建通用内容（Binary Search）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0488|lower_bound|675|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0488`；C/C++ 或辅助构建通用内容（lower_bound）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0489|upper_bound|676|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0489`；C/C++ 或辅助构建通用内容（upper_bound）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0490|equal_range|677|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0490`；C/C++ 或辅助构建通用内容（equal_range）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0491|binary_search|678|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0491`；C/C++ 或辅助构建通用内容（binary_search）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0492|Partitioning Algorithms|678|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0492`；C/C++ 或辅助构建通用内容（Partitioning Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0493|is_partitioned|679|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0493`；C/C++ 或辅助构建通用内容（is_partitioned）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0494|partition|680|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0494`；C/C++ 或辅助构建通用内容（partition）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0495|partition_copy|680|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0495`；C/C++ 或辅助构建通用内容（partition_copy）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0496|stable_partition|682|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0496`；C/C++ 或辅助构建通用内容（stable_partition）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0497|Merging Algorithms|683|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0497`；C/C++ 或辅助构建通用内容（Merging Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0498|merge|683|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0498`；C/C++ 或辅助构建通用内容（merge）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0499|Extreme-Value Algorithms|684|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0499`；C/C++ 或辅助构建通用内容（Extreme-Value Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0500|min and max|684|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0500`；C/C++ 或辅助构建通用内容（min and max）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0501|min_element and max_element|685|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0501`；C/C++ 或辅助构建通用内容（min_element and max_element）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0502|clamp|686|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0502`；C/C++ 或辅助构建通用内容（clamp）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0503|Numeric Operations|687|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0503`；C/C++ 或辅助构建通用内容（Numeric Operations）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0504|Useful Operators|687|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0504`；C/C++ 或辅助构建通用内容（Useful Operators）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0505|iota|688|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0505`；C/C++ 或辅助构建通用内容（iota）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0506|accumulate|688|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0506`；C/C++ 或辅助构建通用内容（accumulate）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0507|reduce|689|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0507`；C/C++ 或辅助构建通用内容（reduce）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0508|inner_product|690|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0508`；C/C++ 或辅助构建通用内容（inner_product）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0509|adjacent_difference|691|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0509`；C/C++ 或辅助构建通用内容（adjacent_difference）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0510|partial_sum|692|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0510`；C/C++ 或辅助构建通用内容（partial_sum）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0511|Other Algorithms|693|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0511`；C/C++ 或辅助构建通用内容（Other Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0512|Boost Algorithm|695|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0512`；C/C++ 或辅助构建通用内容（Boost Algorithm）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0513|19: Concurrency and Parallelism|697|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S02.md#review-s02-u0513`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S02-U0514|Concurrent Programming|698|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0514`；C/C++ 或辅助构建通用内容（Concurrent Programming）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0515|Asynchronous Tasks|698|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0515`；C/C++ 或辅助构建通用内容（Asynchronous Tasks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0516|Sharing and Coordinating|705|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0516`；C/C++ 或辅助构建通用内容（Sharing and Coordinating）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0517|Low-Level Concurrency Facilities|716|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0517`；C/C++ 或辅助构建通用内容（Low-Level Concurrency Facilities）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0518|Parallel Algorithms|716|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0518`；C/C++ 或辅助构建通用内容（Parallel Algorithms）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0519|An Example: Parallel sort|717|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0519`；C/C++ 或辅助构建通用内容（An Example: Parallel sort）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0520|Parallel Algorithms Are Not Magic|718|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0520`；C/C++ 或辅助构建通用内容（Parallel Algorithms Are Not Magic）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0521|Summary|719|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0521`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0522|20: Network Programming with Boost Asio|721|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0522`；C/C++ 或辅助构建通用内容（20: Network Programming with Boost Asio）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0523|The Boost Asio Programming Model|722|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0523`；C/C++ 或辅助构建通用内容（The Boost Asio Programming Model）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0524|Network Programming with Asio|724|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0524`；C/C++ 或辅助构建通用内容（Network Programming with Asio）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0525|The Internet Protocol Suite|724|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0525`；C/C++ 或辅助构建通用内容（The Internet Protocol Suite）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0526|Hostname Resolution|725|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0526`；C/C++ 或辅助构建通用内容（Hostname Resolution）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0527|Connecting|727|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0527`；C/C++ 或辅助构建通用内容（Connecting）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0528|Buffers|729|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0528`；C/C++ 或辅助构建通用内容（Buffers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0529|Reading and Writing Data with Buffers|732|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0529`；C/C++ 或辅助构建通用内容（Reading and Writing Data with Buffers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0530|The Hypertext Transfer Protocol (HTTP)|734|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0530`；C/C++ 或辅助构建通用内容（The Hypertext Transfer Protocol (HTTP)）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0531|Implementing a Simple Boost Asio HTTP Client|735|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0531`；C/C++ 或辅助构建通用内容（Implementing a Simple Boost Asio HTTP Client）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0532|Asynchronous Reading and Writing|737|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0532`；C/C++ 或辅助构建通用内容（Asynchronous Reading and Writing）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0533|Serving|741|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0533`；C/C++ 或辅助构建通用内容（Serving）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0534|Multithreading Boost Asio|745|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0534`；C/C++ 或辅助构建通用内容（Multithreading Boost Asio）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0535|Summary|747|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0535`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0536|21: Writing Applications|749|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0536`；C/C++ 或辅助构建通用内容（21: Writing Applications）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0537|Program Support|750|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0537`；C/C++ 或辅助构建通用内容（Program Support）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0538|Handling Program Termination and Cleanup|751|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0538`；C/C++ 或辅助构建通用内容（Handling Program Termination and Cleanup）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0539|Communicating with the Environment|755|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0539`；C/C++ 或辅助构建通用内容（Communicating with the Environment）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0540|Managing Operating System Signals|757|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0540`；C/C++ 或辅助构建通用内容（Managing Operating System Signals）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0541|Boost ProgramOptions|758|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0541`；C/C++ 或辅助构建通用内容（Boost ProgramOptions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0542|The Options Description|759|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0542`；C/C++ 或辅助构建通用内容（The Options Description）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0543|Parsing Options|761|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0543`；C/C++ 或辅助构建通用内容（Parsing Options）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0544|Storing and Accessing Options|762|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0544`；C/C++ 或辅助构建通用内容（Storing and Accessing Options）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0545|Putting It All Together|763|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0545`；C/C++ 或辅助构建通用内容（Putting It All Together）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0546|Special Topics in Compilation|766|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0546`；C/C++ 或辅助构建通用内容（Special Topics in Compilation）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0547|Revisiting the Preprocessor|766|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0547`；C/C++ 或辅助构建通用内容（Revisiting the Preprocessor）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0548|Compiler Optimization|768|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0548`；C/C++ 或辅助构建通用内容（Compiler Optimization）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0549|Linking with C|769|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0549`；C/C++ 或辅助构建通用内容（Linking with C）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0550|Summary|770|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0550`；C/C++ 或辅助构建通用内容（Summary）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0551|Index|773|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0551`；C/C++ 或辅助构建通用内容（Index）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0552|Symbols and Numbers|773|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0552`；C/C++ 或辅助构建通用内容（Symbols and Numbers）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0553|A|774|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0553`；C/C++ 或辅助构建通用内容（A）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0554|B|776|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0554`；C/C++ 或辅助构建通用内容（B）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0555|C|777|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0555`；C/C++ 或辅助构建通用内容（C）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0556|D|778|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0556`；C/C++ 或辅助构建通用内容（D）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0557|E|779|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0557`；C/C++ 或辅助构建通用内容（E）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0558|F|779|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0558`；C/C++ 或辅助构建通用内容（F）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0559|G|780|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0559`；C/C++ 或辅助构建通用内容（G）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0560|H|780|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0560`；C/C++ 或辅助构建通用内容（H）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0561|I|781|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0561`；C/C++ 或辅助构建通用内容（I）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0562|J|781|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0562`；C/C++ 或辅助构建通用内容（J）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0563|K|781|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0563`；C/C++ 或辅助构建通用内容（K）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0564|L|782|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0564`；C/C++ 或辅助构建通用内容（L）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0565|M|782|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0565`；C/C++ 或辅助构建通用内容（M）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0566|N|783|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0566`；C/C++ 或辅助构建通用内容（N）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0567|O|783|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0567`；C/C++ 或辅助构建通用内容（O）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0568|P|784|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0568`；C/C++ 或辅助构建通用内容（P）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0569|Q|784|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0569`；C/C++ 或辅助构建通用内容（Q）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0570|R|785|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0570`；C/C++ 或辅助构建通用内容（R）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0571|S|785|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0571`；C/C++ 或辅助构建通用内容（S）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0572|T|789|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0572`；C/C++ 或辅助构建通用内容（T）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0573|U|790|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0573`；C/C++ 或辅助构建通用内容（U）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0574|V|791|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0574`；C/C++ 或辅助构建通用内容（V）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0575|W|791|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0575`；C/C++ 或辅助构建通用内容（W）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0576|X|791|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0576`；C/C++ 或辅助构建通用内容（X）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0577|Y|791|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0577`；C/C++ 或辅助构建通用内容（Y）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0578|Z|791|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0578`；C/C++ 或辅助构建通用内容（Z）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S02-U0579|Back Cover|794|excluded-reviewed / scope-only|—|`sources/reviews/S02.md#review-s02-u0579`；C/C++ 或辅助构建通用内容（Back Cover）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S03 · C++ 程序设计语言：第4部分 标准库（原书第4版 (Bjarne Stroustrup) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s03}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S03-U0001|封面|1|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0001`；C/C++ 或辅助构建通用内容（封面）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0002|版权|3|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0002`；C/C++ 或辅助构建通用内容（版权）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0003|前言|4|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0003`；C/C++ 或辅助构建通用内容（前言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0004|目录|15|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0004`；C/C++ 或辅助构建通用内容（目录）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0005|第四部分  标准库|19|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0005`；C/C++ 或辅助构建通用内容（第四部分  标准库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0006|第30章  标准库概览|20|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0006`；C/C++ 或辅助构建通用内容（第30章  标准库概览）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0007|30.1  引言|20|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0007`；C/C++ 或辅助构建通用内容（30.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0008|30.1.1  标准库设施|20|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0008`；C/C++ 或辅助构建通用内容（30.1.1  标准库设施）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0009|30.1.2  设计约束|22|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0009`；C/C++ 或辅助构建通用内容（30.1.2  设计约束）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0010|30.1.3  描述风格|22|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0010`；C/C++ 或辅助构建通用内容（30.1.3  描述风格）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0011|30.2  头文件|23|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0011`；C/C++ 或辅助构建通用内容（30.2  头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0012|30.3  语言支持|27|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0012`；C/C++ 或辅助构建通用内容（30.3  语言支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0013|30.3.1  initializer_list支持|27|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0013`；C/C++ 或辅助构建通用内容（30.3.1  initializer_list支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0014|30.3.2  范围for支持|28|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0014`；C/C++ 或辅助构建通用内容（30.3.2  范围for支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0015|30.4  错误处理|28|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0015`；C/C++ 或辅助构建通用内容（30.4  错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0016|30.4.1  异常|28|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0016`；C/C++ 或辅助构建通用内容（30.4.1  异常）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0017|30.4.2  断言|32|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0017`；C/C++ 或辅助构建通用内容（30.4.2  断言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0018|30.4.3  system_error|33|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0018`；C/C++ 或辅助构建通用内容（30.4.3  system_error）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0019|30.5  建议|41|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0019`；C/C++ 或辅助构建通用内容（30.5  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0020|第31章  STL容器|42|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0020`；C/C++ 或辅助构建通用内容（第31章  STL容器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0021|31.1  引言|42|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0021`；C/C++ 或辅助构建通用内容（31.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0022|31.2  容器概览|42|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0022`；C/C++ 或辅助构建通用内容（31.2  容器概览）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0023|31.2.1  容器表示|45|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0023`；C/C++ 或辅助构建通用内容（31.2.1  容器表示）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0024|31.2.2  对元素的要求|46|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0024`；C/C++ 或辅助构建通用内容（31.2.2  对元素的要求）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0025|31.3  操作概览|48|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0025`；C/C++ 或辅助构建通用内容（31.3  操作概览）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0026|31.3.1  成员类型|50|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0026`；C/C++ 或辅助构建通用内容（31.3.1  成员类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0027|31.3.2  构造函数、析构函数和赋值操作|51|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0027`；C/C++ 或辅助构建通用内容（31.3.2  构造函数、析构函数和赋值操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0028|31.3.3  大小和容量|52|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0028`；C/C++ 或辅助构建通用内容（31.3.3  大小和容量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0029|31.3.4  迭代器|53|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0029`；C/C++ 或辅助构建通用内容（31.3.4  迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0030|31.3.5  元素访问|54|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0030`；C/C++ 或辅助构建通用内容（31.3.5  元素访问）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0031|31.3.6  栈操作|54|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0031`；C/C++ 或辅助构建通用内容（31.3.6  栈操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0032|31.3.7  列表操作|55|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0032`；C/C++ 或辅助构建通用内容（31.3.7  列表操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0033|31.3.8  其他操作|56|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0033`；C/C++ 或辅助构建通用内容（31.3.8  其他操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0034|31.4  容器|56|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0034`；C/C++ 或辅助构建通用内容（31.4  容器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0035|31.4.1  vector|56|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0035`；C/C++ 或辅助构建通用内容（31.4.1  vector）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0036|31.4.2  链表|60|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0036`；C/C++ 或辅助构建通用内容（31.4.2  链表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0037|31.4.3  关联容器|62|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0037`；C/C++ 或辅助构建通用内容（31.4.3  关联容器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0038|31.5  容器适配器|71|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0038`；C/C++ 或辅助构建通用内容（31.5  容器适配器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0039|31.5.1  stack|72|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0039`；C/C++ 或辅助构建通用内容（31.5.1  stack）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0040|31.5.2  queue|73|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0040`；C/C++ 或辅助构建通用内容（31.5.2  queue）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0041|31.5.3  priority_queue|74|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0041`；C/C++ 或辅助构建通用内容（31.5.3  priority_queue）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0042|31.6  建议|75|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0042`；C/C++ 或辅助构建通用内容（31.6  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0043|第32章  STL算法|77|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0043`；C/C++ 或辅助构建通用内容（第32章  STL算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0044|32.1  引言|77|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0044`；C/C++ 或辅助构建通用内容（32.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0045|32.2  算法|77|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0045`；C/C++ 或辅助构建通用内容（32.2  算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0046|32.2.1  序列|78|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0046`；C/C++ 或辅助构建通用内容（32.2.1  序列）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0047|32.3  策略实参|79|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0047`；C/C++ 或辅助构建通用内容（32.3  策略实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0048|32.3.1  复杂性|80|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0048`；C/C++ 或辅助构建通用内容（32.3.1  复杂性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0049|32.4  不修改序列的算法|81|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0049`；C/C++ 或辅助构建通用内容（32.4  不修改序列的算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0050|32.4.1  for_each()|81|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0050`；C/C++ 或辅助构建通用内容（32.4.1  for_each()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0051|32.4.2  序列谓词|81|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0051`；C/C++ 或辅助构建通用内容（32.4.2  序列谓词）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0052|32.4.3  count()|81|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0052`；C/C++ 或辅助构建通用内容（32.4.3  count()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0053|32.4.4  find()|82|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0053`；C/C++ 或辅助构建通用内容（32.4.4  find()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0054|32.4.5  equal()和mismatch()|82|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0054`；C/C++ 或辅助构建通用内容（32.4.5  equal()和mismatch()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0055|32.4.6  search()|83|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0055`；C/C++ 或辅助构建通用内容（32.4.6  search()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0056|32.5  修改序列的算法|84|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0056`；C/C++ 或辅助构建通用内容（32.5  修改序列的算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0057|32.5.1  copy()|84|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0057`；C/C++ 或辅助构建通用内容（32.5.1  copy()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0058|32.5.2  unique()|85|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0058`；C/C++ 或辅助构建通用内容（32.5.2  unique()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0059|32.5.3  remove()和replace()|86|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0059`；C/C++ 或辅助构建通用内容（32.5.3  remove()和replace()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0060|32.5.4  rotate()、random_shuffle()和partition()|87|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0060`；C/C++ 或辅助构建通用内容（32.5.4  rotate()、random_shuffle()和partition()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0061|32.5.5  排列|88|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0061`；C/C++ 或辅助构建通用内容（32.5.5  排列）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0062|32.5.6  fill()|88|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0062`；C/C++ 或辅助构建通用内容（32.5.6  fill()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0063|32.5.7  swap()|89|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0063`；C/C++ 或辅助构建通用内容（32.5.7  swap()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0064|32.6  排序和搜索|89|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0064`；C/C++ 或辅助构建通用内容（32.6  排序和搜索）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0065|32.6.1  二分搜索|92|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0065`；C/C++ 或辅助构建通用内容（32.6.1  二分搜索）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0066|32.6.2  merge()|93|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0066`；C/C++ 或辅助构建通用内容（32.6.2  merge()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0067|32.6.3  集合算法|93|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0067`；C/C++ 或辅助构建通用内容（32.6.3  集合算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0068|32.6.4  堆|94|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0068`；C/C++ 或辅助构建通用内容（32.6.4  堆）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0069|32.6.5  lexicographical_compare()|95|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0069`；C/C++ 或辅助构建通用内容（32.6.5  lexicographical_compare()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0070|32.7  最大值和最小值|96|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0070`；C/C++ 或辅助构建通用内容（32.7  最大值和最小值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0071|32.8  建议|97|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0071`；C/C++ 或辅助构建通用内容（32.8  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0072|第33章  STL迭代器|98|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0072`；C/C++ 或辅助构建通用内容（第33章  STL迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0073|33.1  引言|98|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0073`；C/C++ 或辅助构建通用内容（33.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0074|33.1.1  迭代器模型|98|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0074`；C/C++ 或辅助构建通用内容（33.1.1  迭代器模型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0075|33.1.2  迭代器类别|99|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0075`；C/C++ 或辅助构建通用内容（33.1.2  迭代器类别）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0076|33.1.3  迭代器萃取|100|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0076`；C/C++ 或辅助构建通用内容（33.1.3  迭代器萃取）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0077|33.1.4  迭代器操作|103|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0077`；C/C++ 或辅助构建通用内容（33.1.4  迭代器操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0078|33.2  迭代器适配器|103|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0078`；C/C++ 或辅助构建通用内容（33.2  迭代器适配器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0079|33.2.1  反向迭代器|104|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0079`；C/C++ 或辅助构建通用内容（33.2.1  反向迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0080|33.2.2  插入迭代器|106|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0080`；C/C++ 或辅助构建通用内容（33.2.2  插入迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0081|33.2.3  移动迭代器|107|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0081`；C/C++ 或辅助构建通用内容（33.2.3  移动迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0082|33.3  范围访问函数|107|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0082`；C/C++ 或辅助构建通用内容（33.3  范围访问函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0083|33.4  函数对象|108|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0083`；C/C++ 或辅助构建通用内容（33.4  函数对象）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0084|33.5  函数适配器|109|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0084`；C/C++ 或辅助构建通用内容（33.5  函数适配器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0085|33.5.1  bind()|110|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0085`；C/C++ 或辅助构建通用内容（33.5.1  bind()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0086|33.5.2  mem_fn()|111|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0086`；C/C++ 或辅助构建通用内容（33.5.2  mem_fn()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0087|33.5.3  function|111|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0087`；C/C++ 或辅助构建通用内容（33.5.3  function）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0088|33.6  建议|113|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0088`；C/C++ 或辅助构建通用内容（33.6  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0089|第34章  内存和资源|114|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0089`；C/C++ 或辅助构建通用内容（第34章  内存和资源）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0090|34.1  引言|114|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0090`；C/C++ 或辅助构建通用内容（34.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0091|34.2  “拟容器”|114|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0091`；C/C++ 或辅助构建通用内容（34.2  “拟容器”）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0092|34.2.1  array|115|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0092`；C/C++ 或辅助构建通用内容（34.2.1  array）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0093|34.2.2  bitset|117|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0093`；C/C++ 或辅助构建通用内容（34.2.2  bitset）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0094|34.2.3  vector[bool]|121|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0094`；C/C++ 或辅助构建通用内容（34.2.3  vector[bool]）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0095|34.2.4  元组|122|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0095`；C/C++ 或辅助构建通用内容（34.2.4  元组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0096|34.3  资源管理指针|125|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0096`；C/C++ 或辅助构建通用内容（34.3  资源管理指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0097|34.3.1  unique_ptr|126|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0097`；C/C++ 或辅助构建通用内容（34.3.1  unique_ptr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0098|34.3.2  shared_ptr|129|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0098`；C/C++ 或辅助构建通用内容（34.3.2  shared_ptr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0099|34.3.3  weak_ptr|131|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0099`；C/C++ 或辅助构建通用内容（34.3.3  weak_ptr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0100|34.4  分配器|133|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0100`；C/C++ 或辅助构建通用内容（34.4  分配器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0101|34.4.1  默认分配器|134|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0101`；C/C++ 或辅助构建通用内容（34.4.1  默认分配器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0102|34.4.2  分配器萃取|136|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0102`；C/C++ 或辅助构建通用内容（34.4.2  分配器萃取）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0103|34.4.3  指针萃取|137|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0103`；C/C++ 或辅助构建通用内容（34.4.3  指针萃取）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0104|34.4.4  限域的分配器|137|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0104`；C/C++ 或辅助构建通用内容（34.4.4  限域的分配器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0105|34.5  垃圾收集接口|139|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0105`；C/C++ 或辅助构建通用内容（34.5  垃圾收集接口）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0106|34.6  未初始化内存|141|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0106`；C/C++ 或辅助构建通用内容（34.6  未初始化内存）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0107|34.6.1  临时缓冲区|141|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0107`；C/C++ 或辅助构建通用内容（34.6.1  临时缓冲区）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0108|34.6.2  raw_storage_iterator|142|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0108`；C/C++ 或辅助构建通用内容（34.6.2  raw_storage_iterator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0109|34.7  建议|143|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0109`；C/C++ 或辅助构建通用内容（34.7  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0110|第35章  工具|144|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0110`；C/C++ 或辅助构建通用内容（第35章  工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0111|35.1  引言|144|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0111`；C/C++ 或辅助构建通用内容（35.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0112|35.2  时间|144|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0112`；C/C++ 或辅助构建通用内容（35.2  时间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0113|35.2.1  duration|145|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0113`；C/C++ 或辅助构建通用内容（35.2.1  duration）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0114|35.2.2  time_point|147|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0114`；C/C++ 或辅助构建通用内容（35.2.2  time_point）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0115|35.2.3  时钟|149|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0115`；C/C++ 或辅助构建通用内容（35.2.3  时钟）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0116|35.2.4  时间萃取|150|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0116`；C/C++ 或辅助构建通用内容（35.2.4  时间萃取）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0117|35.3  编译时有理数运算|150|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0117`；C/C++ 或辅助构建通用内容（35.3  编译时有理数运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0118|35.4  类型函数|152|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0118`；C/C++ 或辅助构建通用内容（35.4  类型函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0119|35.4.1  类型萃取|152|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0119`；C/C++ 或辅助构建通用内容（35.4.1  类型萃取）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0120|35.4.2  类型生成器|156|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0120`；C/C++ 或辅助构建通用内容（35.4.2  类型生成器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0121|35.5  其他工具|160|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0121`；C/C++ 或辅助构建通用内容（35.5  其他工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0122|35.5.1  move()和forward()|160|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0122`；C/C++ 或辅助构建通用内容（35.5.1  move()和forward()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0123|35.5.2  swap()|161|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0123`；C/C++ 或辅助构建通用内容（35.5.2  swap()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0124|35.5.3  关系运算符|161|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0124`；C/C++ 或辅助构建通用内容（35.5.3  关系运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0125|35.5.4  比较和哈希type_info|162|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0125`；C/C++ 或辅助构建通用内容（35.5.4  比较和哈希type_info）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0126|35.6  建议|163|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0126`；C/C++ 或辅助构建通用内容（35.6  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0127|第36章  字符串|164|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0127`；C/C++ 或辅助构建通用内容（第36章  字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0128|36.1  引言|164|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0128`；C/C++ 或辅助构建通用内容（36.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0129|36.2  字符分类|164|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0129`；C/C++ 或辅助构建通用内容（36.2  字符分类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0130|36.2.1  分类函数|164|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0130`；C/C++ 或辅助构建通用内容（36.2.1  分类函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0131|36.2.2  字符萃取|165|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0131`；C/C++ 或辅助构建通用内容（36.2.2  字符萃取）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0132|36.3  字符串|166|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0132`；C/C++ 或辅助构建通用内容（36.3  字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0133|36.3.1  string与C风格字符串|167|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0133`；C/C++ 或辅助构建通用内容（36.3.1  string与C风格字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0134|36.3.2  构造函数|169|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0134`；C/C++ 或辅助构建通用内容（36.3.2  构造函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0135|36.3.3  基本操作|170|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0135`；C/C++ 或辅助构建通用内容（36.3.3  基本操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0136|36.3.4  字符串I/O|171|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0136`；C/C++ 或辅助构建通用内容（36.3.4  字符串I/O）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0137|36.3.5  数值转换|172|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0137`；C/C++ 或辅助构建通用内容（36.3.5  数值转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0138|36.3.6  类STL操作|173|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0138`；C/C++ 或辅助构建通用内容（36.3.6  类STL操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0139|36.3.7  find系列函数|175|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0139`；C/C++ 或辅助构建通用内容（36.3.7  find系列函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0140|36.3.8  子串|176|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0140`；C/C++ 或辅助构建通用内容（36.3.8  子串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0141|36.4  建议|177|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0141`；C/C++ 或辅助构建通用内容（36.4  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0142|第37章  正则表达式|178|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0142`；C/C++ 或辅助构建通用内容（第37章  正则表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0143|37.1  正则表达式|178|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0143`；C/C++ 或辅助构建通用内容（37.1  正则表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0144|37.1.1  正则表达式符号表示|179|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0144`；C/C++ 或辅助构建通用内容（37.1.1  正则表达式符号表示）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0145|37.2  regex|183|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0145`；C/C++ 或辅助构建通用内容（37.2  regex）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0146|37.2.1  匹配结果|184|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0146`；C/C++ 或辅助构建通用内容（37.2.1  匹配结果）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0147|37.2.2  格式化|187|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0147`；C/C++ 或辅助构建通用内容（37.2.2  格式化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0148|37.3  正则表达式函数|188|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0148`；C/C++ 或辅助构建通用内容（37.3  正则表达式函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0149|37.3.1  regex_match()|188|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0149`；C/C++ 或辅助构建通用内容（37.3.1  regex_match()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0150|37.3.2  regex_search()|189|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0150`；C/C++ 或辅助构建通用内容（37.3.2  regex_search()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0151|37.3.3  regex_replace()|190|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0151`；C/C++ 或辅助构建通用内容（37.3.3  regex_replace()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0152|37.4  正则表达式迭代器|191|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0152`；C/C++ 或辅助构建通用内容（37.4  正则表达式迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0153|37.4.1  regex_iterator|191|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0153`；C/C++ 或辅助构建通用内容（37.4.1  regex_iterator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0154|37.4.2  regex_token_iterator|193|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0154`；C/C++ 或辅助构建通用内容（37.4.2  regex_token_iterator）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0155|37.5  regex_traits|194|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0155`；C/C++ 或辅助构建通用内容（37.5  regex_traits）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0156|37.6  建议|195|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0156`；C/C++ 或辅助构建通用内容（37.6  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0157|第38章  I/O流|196|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0157`；C/C++ 或辅助构建通用内容（第38章  I/O流）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0158|38.1  引言|196|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0158`；C/C++ 或辅助构建通用内容（38.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0159|38.2  I/O流层次|198|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0159`；C/C++ 或辅助构建通用内容（38.2  I/O流层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0160|38.2.1  文件流|198|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0160`；C/C++ 或辅助构建通用内容（38.2.1  文件流）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0161|38.2.2  字符串流|200|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0161`；C/C++ 或辅助构建通用内容（38.2.2  字符串流）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0162|38.3  错误处理|201|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0162`；C/C++ 或辅助构建通用内容（38.3  错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0163|38.4  I/O操作|202|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0163`；C/C++ 或辅助构建通用内容（38.4  I/O操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0164|38.4.1  输入操作|203|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0164`；C/C++ 或辅助构建通用内容（38.4.1  输入操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0165|38.4.2  输出操作|205|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0165`；C/C++ 或辅助构建通用内容（38.4.2  输出操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0166|38.4.3  操纵符|207|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0166`；C/C++ 或辅助构建通用内容（38.4.3  操纵符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0167|38.4.4  流状态|208|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0167`；C/C++ 或辅助构建通用内容（38.4.4  流状态）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0168|38.4.5  格式化|212|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0168`；C/C++ 或辅助构建通用内容（38.4.5  格式化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0169|38.5  流迭代器|218|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0169`；C/C++ 或辅助构建通用内容（38.5  流迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0170|38.6  缓冲|219|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0170`；C/C++ 或辅助构建通用内容（38.6  缓冲）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0171|38.6.1  输出流和缓冲区|222|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0171`；C/C++ 或辅助构建通用内容（38.6.1  输出流和缓冲区）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0172|38.6.2  输入流和缓冲区|223|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0172`；C/C++ 或辅助构建通用内容（38.6.2  输入流和缓冲区）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0173|38.6.3  缓冲区迭代器|223|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0173`；C/C++ 或辅助构建通用内容（38.6.3  缓冲区迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0174|38.7  建议|225|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0174`；C/C++ 或辅助构建通用内容（38.7  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0175|第39章  区域设置|227|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0175`；C/C++ 或辅助构建通用内容（第39章  区域设置）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0176|39.1  处理文化差异|227|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0176`；C/C++ 或辅助构建通用内容（39.1  处理文化差异）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0177|39.2  类locale|229|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0177`；C/C++ 或辅助构建通用内容（39.2  类locale）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0178|39.2.1  命名locale|231|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0178`；C/C++ 或辅助构建通用内容（39.2.1  命名locale）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0179|39.2.2  比较string|234|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0179`；C/C++ 或辅助构建通用内容（39.2.2  比较string）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0180|39.3  类facet|235|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0180`；C/C++ 或辅助构建通用内容（39.3  类facet）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0181|39.3.1  访问locale中的facet|236|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0181`；C/C++ 或辅助构建通用内容（39.3.1  访问locale中的facet）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0182|39.3.2  一个简单的用户自定义facet|236|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0182`；C/C++ 或辅助构建通用内容（39.3.2  一个简单的用户自定义facet）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0183|39.3.3  locale和facet的使用|239|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0183`；C/C++ 或辅助构建通用内容（39.3.3  locale和facet的使用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0184|39.4  标准facet|239|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0184`；C/C++ 或辅助构建通用内容（39.4  标准facet）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0185|39.4.1  string比较|241|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0185`；C/C++ 或辅助构建通用内容（39.4.1  string比较）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0186|39.4.2  数值格式化|244|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0186`；C/C++ 或辅助构建通用内容（39.4.2  数值格式化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0187|39.4.3  货币格式化|249|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0187`；C/C++ 或辅助构建通用内容（39.4.3  货币格式化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0188|39.4.4  日期和时间格式化|253|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0188`；C/C++ 或辅助构建通用内容（39.4.4  日期和时间格式化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0189|39.4.5  字符分类|256|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0189`；C/C++ 或辅助构建通用内容（39.4.5  字符分类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0190|39.4.6  字符编码转换|259|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0190`；C/C++ 或辅助构建通用内容（39.4.6  字符编码转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0191|39.4.7  消息|262|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0191`；C/C++ 或辅助构建通用内容（39.4.7  消息）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0192|39.5  便利接口|266|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0192`；C/C++ 或辅助构建通用内容（39.5  便利接口）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0193|39.5.1  字符分类|266|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0193`；C/C++ 或辅助构建通用内容（39.5.1  字符分类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0194|39.5.2  字符转换|266|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0194`；C/C++ 或辅助构建通用内容（39.5.2  字符转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0195|39.5.3  字符串转换|267|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0195`；C/C++ 或辅助构建通用内容（39.5.3  字符串转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0196|39.5.4  缓冲区转换|268|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0196`；C/C++ 或辅助构建通用内容（39.5.4  缓冲区转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0197|39.6  建议|268|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0197`；C/C++ 或辅助构建通用内容（39.6  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0198|第40章  数值计算|270|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0198`；C/C++ 或辅助构建通用内容（第40章  数值计算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0199|40.1  引言|270|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0199`；C/C++ 或辅助构建通用内容（40.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0200|40.2  数值限制|270|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0200`；C/C++ 或辅助构建通用内容（40.2  数值限制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0201|40.2.1  数值限制宏|273|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0201`；C/C++ 或辅助构建通用内容（40.2.1  数值限制宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0202|40.3  标准数学函数|273|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0202`；C/C++ 或辅助构建通用内容（40.3  标准数学函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0203|40.4  复数complex|275|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0203`；C/C++ 或辅助构建通用内容（40.4  复数complex）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0204|40.5  数值数组：valarray|276|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0204`；C/C++ 或辅助构建通用内容（40.5  数值数组：valarray）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0205|40.5.1  构造函数和赋值操作|276|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0205`；C/C++ 或辅助构建通用内容（40.5.1  构造函数和赋值操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0206|40.5.2  下标操作|278|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0206`；C/C++ 或辅助构建通用内容（40.5.2  下标操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0207|40.5.3  运算|279|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0207`；C/C++ 或辅助构建通用内容（40.5.3  运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0208|40.5.4  切片|281|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0208`；C/C++ 或辅助构建通用内容（40.5.4  切片）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0209|40.5.5  slice_array|283|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0209`；C/C++ 或辅助构建通用内容（40.5.5  slice_array）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0210|40.5.6  推广切片|283|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0210`；C/C++ 或辅助构建通用内容（40.5.6  推广切片）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0211|40.6  推广数值算法|285|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0211`；C/C++ 或辅助构建通用内容（40.6  推广数值算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0212|40.6.1  accumulate()|285|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0212`；C/C++ 或辅助构建通用内容（40.6.1  accumulate()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0213|40.6.2  inner_product()|286|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0213`；C/C++ 或辅助构建通用内容（40.6.2  inner_product()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0214|40.6.3  partial_sum()和adjacent_difference()|287|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0214`；C/C++ 或辅助构建通用内容（40.6.3  partial_sum()和adjacent_difference()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0215|40.6.4  iota()|288|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0215`；C/C++ 或辅助构建通用内容（40.6.4  iota()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0216|40.7  随机数|288|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0216`；C/C++ 或辅助构建通用内容（40.7  随机数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0217|40.7.1  引擎|290|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0217`；C/C++ 或辅助构建通用内容（40.7.1  引擎）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0218|40.7.2  随机设备|292|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0218`；C/C++ 或辅助构建通用内容（40.7.2  随机设备）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0219|40.7.3  分布|292|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0219`；C/C++ 或辅助构建通用内容（40.7.3  分布）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0220|40.7.4  C风格随机数|295|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0220`；C/C++ 或辅助构建通用内容（40.7.4  C风格随机数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0221|40.8  建议|296|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0221`；C/C++ 或辅助构建通用内容（40.8  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0222|第41章  并发|297|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S03.md#review-s03-u0222`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S03-U0223|41.1  引言|297|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0223`；C/C++ 或辅助构建通用内容（41.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0224|41.2  内存模型|298|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0224`；C/C++ 或辅助构建通用内容（41.2  内存模型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0225|41.2.1  内存位置|299|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0225`；C/C++ 或辅助构建通用内容（41.2.1  内存位置）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0226|41.2.2  指令重排|300|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0226`；C/C++ 或辅助构建通用内容（41.2.2  指令重排）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0227|41.2.3  内存序|300|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0227`；C/C++ 或辅助构建通用内容（41.2.3  内存序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0228|41.2.4  数据竞争|301|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0228`；C/C++ 或辅助构建通用内容（41.2.4  数据竞争）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0229|41.3  原子性|303|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0229`；C/C++ 或辅助构建通用内容（41.3  原子性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0230|41.3.1  atomic类型|305|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0230`；C/C++ 或辅助构建通用内容（41.3.1  atomic类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0231|41.3.2  标志和栅栏|309|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0231`；C/C++ 或辅助构建通用内容（41.3.2  标志和栅栏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0232|41.4  volatile|310|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0232`；C/C++ 或辅助构建通用内容（41.4  volatile）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0233|41.5  建议|310|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0233`；C/C++ 或辅助构建通用内容（41.5  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0234|第42章  线程和任务|311|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0234`；C/C++ 或辅助构建通用内容（第42章  线程和任务）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0235|42.1  引言|311|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0235`；C/C++ 或辅助构建通用内容（42.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0236|42.2  线程|311|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0236`；C/C++ 或辅助构建通用内容（42.2  线程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0237|42.2.1  身份|312|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0237`；C/C++ 或辅助构建通用内容（42.2.1  身份）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0238|42.2.2  构造|313|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0238`；C/C++ 或辅助构建通用内容（42.2.2  构造）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0239|42.2.3  析构|314|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0239`；C/C++ 或辅助构建通用内容（42.2.3  析构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0240|42.2.4  join()|315|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0240`；C/C++ 或辅助构建通用内容（42.2.4  join()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0241|42.2.5  detach()|316|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0241`；C/C++ 或辅助构建通用内容（42.2.5  detach()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0242|42.2.6  名字空间this_thread|317|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0242`；C/C++ 或辅助构建通用内容（42.2.6  名字空间this_thread）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0243|42.2.7  杀死thread|318|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0243`；C/C++ 或辅助构建通用内容（42.2.7  杀死thread）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0244|42.2.8  thread_local数据|318|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0244`；C/C++ 或辅助构建通用内容（42.2.8  thread_local数据）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0245|42.3  避免数据竞争|320|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0245`；C/C++ 或辅助构建通用内容（42.3  避免数据竞争）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0246|42.3.1  互斥量|320|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0246`；C/C++ 或辅助构建通用内容（42.3.1  互斥量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0247|42.3.2  多重锁|327|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0247`；C/C++ 或辅助构建通用内容（42.3.2  多重锁）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0248|42.3.3  call_once()|329|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0248`；C/C++ 或辅助构建通用内容（42.3.3  call_once()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0249|42.3.4  条件变量|329|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0249`；C/C++ 或辅助构建通用内容（42.3.4  条件变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0250|42.4  基于任务的并发|333|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0250`；C/C++ 或辅助构建通用内容（42.4  基于任务的并发）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0251|42.4.1  future和promise|334|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0251`；C/C++ 或辅助构建通用内容（42.4.1  future和promise）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0252|42.4.2  promise|335|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0252`；C/C++ 或辅助构建通用内容（42.4.2  promise）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0253|42.4.3  packaged_task|336|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0253`；C/C++ 或辅助构建通用内容（42.4.3  packaged_task）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0254|42.4.4  future|338|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0254`；C/C++ 或辅助构建通用内容（42.4.4  future）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0255|42.4.5  shared_future|341|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0255`；C/C++ 或辅助构建通用内容（42.4.5  shared_future）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0256|42.4.6  async()|341|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0256`；C/C++ 或辅助构建通用内容（42.4.6  async()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0257|42.4.7  一个并行find()示例|343|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0257`；C/C++ 或辅助构建通用内容（42.4.7  一个并行find()示例）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0258|42.5  建议|346|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0258`；C/C++ 或辅助构建通用内容（42.5  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0259|第43章  C标准库|348|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0259`；C/C++ 或辅助构建通用内容（第43章  C标准库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0260|43.1  引言|348|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0260`；C/C++ 或辅助构建通用内容（43.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0261|43.2  文件|348|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0261`；C/C++ 或辅助构建通用内容（43.2  文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0262|43.3  printf()系列函数|349|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0262`；C/C++ 或辅助构建通用内容（43.3  printf()系列函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0263|43.4  C风格字符串|352|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0263`；C/C++ 或辅助构建通用内容（43.4  C风格字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0264|43.5  内存|353|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0264`；C/C++ 或辅助构建通用内容（43.5  内存）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0265|43.6  日期和时间|354|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0265`；C/C++ 或辅助构建通用内容（43.6  日期和时间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0266|43.7  杂项|357|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0266`；C/C++ 或辅助构建通用内容（43.7  杂项）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0267|43.8  建议|358|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0267`；C/C++ 或辅助构建通用内容（43.8  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0268|第44章  兼容性|359|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0268`；C/C++ 或辅助构建通用内容（第44章  兼容性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0269|44.1  引言|359|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0269`；C/C++ 或辅助构建通用内容（44.1  引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0270|44.2  C++11扩展|359|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0270`；C/C++ 或辅助构建通用内容（44.2  C++11扩展）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0271|44.2.1  语言特性|359|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0271`；C/C++ 或辅助构建通用内容（44.2.1  语言特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0272|44.2.2  标准库组件|361|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0272`；C/C++ 或辅助构建通用内容（44.2.2  标准库组件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0273|44.2.3  弃用特性|362|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0273`；C/C++ 或辅助构建通用内容（44.2.3  弃用特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0274|44.2.4  应对旧版本C++实现|362|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0274`；C/C++ 或辅助构建通用内容（44.2.4  应对旧版本C++实现）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0275|44.3  C/C++兼容性|363|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0275`；C/C++ 或辅助构建通用内容（44.3  C/C++兼容性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0276|44.3.1  C和C++是兄弟|363|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0276`；C/C++ 或辅助构建通用内容（44.3.1  C和C++是兄弟）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0277|44.3.2  “静默”差异|364|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0277`；C/C++ 或辅助构建通用内容（44.3.2  “静默”差异）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0278|44.3.3  不兼容C++的C代码|365|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0278`；C/C++ 或辅助构建通用内容（44.3.3  不兼容C++的C代码）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0279|44.3.4  不兼容C的C++代码|368|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0279`；C/C++ 或辅助构建通用内容（44.3.4  不兼容C的C++代码）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S03-U0280|44.4  建议|369|excluded-reviewed / scope-only|—|`sources/reviews/S03.md#review-s03-u0280`；C/C++ 或辅助构建通用内容（44.4  建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S04 · C++20高级编程(第5版)(上下册） ([比]马克·格雷戈勒（Marc Gregoire）) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s04}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S04-U0001|推荐序一|4|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0001`；C/C++ 或辅助构建通用内容（推荐序一）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0002|推荐序二|6|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0002`；C/C++ 或辅助构建通用内容（推荐序二）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0003|推荐序三|7|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0003`；C/C++ 或辅助构建通用内容（推荐序三）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0004|推荐序四|8|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0004`；C/C++ 或辅助构建通用内容（推荐序四）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0005|推荐序五|9|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0005`；C/C++ 或辅助构建通用内容（推荐序五）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0006|专家赞誉|10|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0006`；C/C++ 或辅助构建通用内容（专家赞誉）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0007|译者序|11|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0007`；C/C++ 或辅助构建通用内容（译者序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0008|作者简介|12|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0008`；C/C++ 或辅助构建通用内容（作者简介）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0009|前言|14|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0009`；C/C++ 或辅助构建通用内容（前言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0010|目录|20|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0010`；C/C++ 或辅助构建通用内容（目录）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0011|第1部分：专业的 C++ 简介|32|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0011`；C/C++ 或辅助构建通用内容（第1部分：专业的 C++ 简介）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0012|第1章:C++和标准库速成|34|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0012`；C/C++ 或辅助构建通用内容（第1章:C++和标准库速成）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0013|第2章:使用 string 和 string_view|102|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0013`；C/C++ 或辅助构建通用内容（第2章:使用 string 和 string_view）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0014|第3章:编码风格|122|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0014`；C/C++ 或辅助构建通用内容（第3章:编码风格）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0015|第2部分:专业的 C++软件设计|142|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0015`；C/C++ 或辅助构建通用内容（第2部分:专业的 C++软件设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0016|第4章:设计专业的 C++程序|144|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0016`；C/C++ 或辅助构建通用内容（第4章:设计专业的 C++程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0017|第5章:面向对象设计|166|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0017`；C/C++ 或辅助构建通用内容（第5章:面向对象设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0018|第6章:设计可重用代码|180|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0018`；C/C++ 或辅助构建通用内容（第6章:设计可重用代码）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0019|第3部分:C++编码方法|196|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0019`；C/C++ 或辅助构建通用内容（第3部分:C++编码方法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0020|第7章:内存管理|198|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0020`；C/C++ 或辅助构建通用内容（第7章:内存管理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0021|第8章:熟悉类和对象|228|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0021`；C/C++ 或辅助构建通用内容（第8章:熟悉类和对象）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0022|第9章:精通类和对象|258|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0022`；C/C++ 或辅助构建通用内容（第9章:精通类和对象）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0023|第10章:揭秘继承技术|302|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0023`；C/C++ 或辅助构建通用内容（第10章:揭秘继承技术）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0024|第11章:零碎的工作|352|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0024`；C/C++ 或辅助构建通用内容（第11章:零碎的工作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0025|第12章:利用模板编写泛型代码|372|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0025`；C/C++ 或辅助构建通用内容（第12章:利用模板编写泛型代码）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0026|第13章:C++ I/O 揭秘|410|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0026`；C/C++ 或辅助构建通用内容（第13章:C++ I/O 揭秘）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0027|第14章:错误处理|436|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0027`；C/C++ 或辅助构建通用内容（第14章:错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0028|第15章:C++运算符重载|468|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0028`；C/C++ 或辅助构建通用内容（第15章:C++运算符重载）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0029|第16章:C++标准库概述|500|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0029`；C/C++ 或辅助构建通用内容（第16章:C++标准库概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0030|第17章:理解迭代器与范围库|526|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0030`；C/C++ 或辅助构建通用内容（第17章:理解迭代器与范围库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0031|第18章:标准库容器|546|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0031`；C/C++ 或辅助构建通用内容（第18章:标准库容器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0032|第19章:函数指针，函数对象，lambda表达式|606|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S04.md#review-s04-u0032`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S04-U0033|第20章:掌握标准库算法|628|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0033`；C/C++ 或辅助构建通用内容（第20章:掌握标准库算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0034|第21章:字符串的本地化与正则表达式|660|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0034`；C/C++ 或辅助构建通用内容（第21章:字符串的本地化与正则表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0035|第22章:日期和时间工具|682|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0035`；C/C++ 或辅助构建通用内容（第22章:日期和时间工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0036|第23章:随机数工具|696|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0036`；C/C++ 或辅助构建通用内容（第23章:随机数工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0037|第24章:其他库工具|706|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0037`；C/C++ 或辅助构建通用内容（第24章:其他库工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0038|第4部分:掌握C++的高级特性|716|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0038`；C/C++ 或辅助构建通用内容（第4部分:掌握C++的高级特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0039|第25章:自定义和扩展标准库|718|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0039`；C/C++ 或辅助构建通用内容（第25章:自定义和扩展标准库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0040|第26章:高级模板|756|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0040`；C/C++ 或辅助构建通用内容（第26章:高级模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0041|第27章:C++多线程编程|788|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0041`；C/C++ 或辅助构建通用内容（第27章:C++多线程编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0042|第5部分:C++软件工程|832|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0042`；C/C++ 或辅助构建通用内容（第5部分:C++软件工程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0043|第28章:充分利用软件工程方法|834|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0043`；C/C++ 或辅助构建通用内容（第28章:充分利用软件工程方法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0044|第29章:编写高效的 C++程序|852|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0044`；C/C++ 或辅助构建通用内容（第29章:编写高效的 C++程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0045|第30章:熟练掌握测试技术|876|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0045`；C/C++ 或辅助构建通用内容（第30章:熟练掌握测试技术）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0046|第31章:熟练掌握调试技术|894|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0046`；C/C++ 或辅助构建通用内容（第31章:熟练掌握调试技术）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0047|第32章:使用设计技术和框架|924|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0047`；C/C++ 或辅助构建通用内容（第32章:使用设计技术和框架）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0048|第33章:应用设计模式|942|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0048`；C/C++ 或辅助构建通用内容（第33章:应用设计模式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0049|第34章:开发跨平台和跨语言的应用程序|970|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0049`；C/C++ 或辅助构建通用内容（第34章:开发跨平台和跨语言的应用程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0050|第6部分：附录|990|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0050`；C/C++ 或辅助构建通用内容（第6部分：附录）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S04-U0051|附录A:C++面试|992|excluded-reviewed / scope-only|—|`sources/reviews/S04.md#review-s04-u0051`；C/C++ 或辅助构建通用内容（附录A:C++面试）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S05 · C++程序设计语言.第1～3部分.原书第4版 (Bjarne Stroustrup) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s05}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S05-U0001|封面|1|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0001`；C/C++ 或辅助构建通用内容（封面）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0002|书名|2|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0002`；C/C++ 或辅助构建通用内容（书名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0003|版权|3|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0003`；C/C++ 或辅助构建通用内容（版权）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0004|前言|4|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0004`；C/C++ 或辅助构建通用内容（前言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0005|目录|15|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0005`；C/C++ 或辅助构建通用内容（目录）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0006|第1章 致读者|25|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0006`；C/C++ 或辅助构建通用内容（第1章 致读者）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0007|1.1 本书结构|25|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0007`；C/C++ 或辅助构建通用内容（1.1 本书结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0008|1.1.1 引言|25|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0008`；C/C++ 或辅助构建通用内容（1.1.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0009|1.1.2 基本特性|26|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0009`；C/C++ 或辅助构建通用内容（1.1.2 基本特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0010|1.1.3 抽象机制|27|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0010`；C/C++ 或辅助构建通用内容（1.1.3 抽象机制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0011|1.1.4 标准库|28|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0011`；C/C++ 或辅助构建通用内容（1.1.4 标准库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0012|1.1.5 例子和参考文献|28|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0012`；C/C++ 或辅助构建通用内容（1.1.5 例子和参考文献）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0013|1.2 C++的设计|30|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0013`；C/C++ 或辅助构建通用内容（1.2 C++的设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0014|1.2.1 程序设计风格|31|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0014`；C/C++ 或辅助构建通用内容（1.2.1 程序设计风格）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0015|1.2.2 类型检查|34|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0015`；C/C++ 或辅助构建通用内容（1.2.2 类型检查）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0016|1.2.3 C兼容性|35|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0016`；C/C++ 或辅助构建通用内容（1.2.3 C兼容性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0017|1.2.4 语言、库和系统|35|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0017`；C/C++ 或辅助构建通用内容（1.2.4 语言、库和系统）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0018|1.3 学习C++|37|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0018`；C/C++ 或辅助构建通用内容（1.3 学习C++）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0019|1.3.1 用C++编程|38|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0019`；C/C++ 或辅助构建通用内容（1.3.1 用C++编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0020|1.3.2 对C++程序员的建议|39|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0020`；C/C++ 或辅助构建通用内容（1.3.2 对C++程序员的建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0021|1.3.3 对C程序员的建议|39|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0021`；C/C++ 或辅助构建通用内容（1.3.3 对C程序员的建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0022|1.3.4 对Java程序员的建议|40|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0022`；C/C++ 或辅助构建通用内容（1.3.4 对Java程序员的建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0023|1.4 C++的历史|41|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0023`；C/C++ 或辅助构建通用内容（1.4 C++的历史）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0024|1.4.1 大事年表|42|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0024`；C/C++ 或辅助构建通用内容（1.4.1 大事年表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0025|1.4.2 早期的C++|42|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0025`；C/C++ 或辅助构建通用内容（1.4.2 早期的C++）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0026|1.4.31998 标准|44|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0026`；C/C++ 或辅助构建通用内容（1.4.31998 标准）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0027|1.4.42011 标准|46|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0027`；C/C++ 或辅助构建通用内容（1.4.42011 标准）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0028|1.4.5 C++的用途|49|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0028`；C/C++ 或辅助构建通用内容（1.4.5 C++的用途）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0029|1.5 建议|50|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0029`；C/C++ 或辅助构建通用内容（1.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0030|1.6 参考文献|51|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0030`；C/C++ 或辅助构建通用内容（1.6 参考文献）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0031|第2章 C++概览：基础知识|55|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0031`；C/C++ 或辅助构建通用内容（第2章 C++概览：基础知识）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0032|2.1 引言|55|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0032`；C/C++ 或辅助构建通用内容（2.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0033|2.2 基本概念|56|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0033`；C/C++ 或辅助构建通用内容（2.2 基本概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0034|2.2.1 Hello，World!|56|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0034`；C/C++ 或辅助构建通用内容（2.2.1 Hello，World!）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0035|2.2.2 类型、变量和算术运算|57|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0035`；C/C++ 或辅助构建通用内容（2.2.2 类型、变量和算术运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0036|2.2.3 常量|59|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0036`；C/C++ 或辅助构建通用内容（2.2.3 常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0037|2.2.4 检验和循环|60|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0037`；C/C++ 或辅助构建通用内容（2.2.4 检验和循环）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0038|2.2.5 指针、数组和循环|61|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0038`；C/C++ 或辅助构建通用内容（2.2.5 指针、数组和循环）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0039|2.3 用户自定义类型|63|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0039`；C/C++ 或辅助构建通用内容（2.3 用户自定义类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0040|2.3.1 结构|64|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0040`；C/C++ 或辅助构建通用内容（2.3.1 结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0041|2.3.2 类|65|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0041`；C/C++ 或辅助构建通用内容（2.3.2 类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0042|2.3.3 枚举|66|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0042`；C/C++ 或辅助构建通用内容（2.3.3 枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0043|2.4 模块化|67|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0043`；C/C++ 或辅助构建通用内容（2.4 模块化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0044|2.4.1 分离编译|68|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0044`；C/C++ 或辅助构建通用内容（2.4.1 分离编译）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0045|2.4.2 名字空间|69|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0045`；C/C++ 或辅助构建通用内容（2.4.2 名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0046|2.4.3 错误处理|70|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0046`；C/C++ 或辅助构建通用内容（2.4.3 错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0047|2.5 附记|73|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0047`；C/C++ 或辅助构建通用内容（2.5 附记）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0048|2.6 建议|73|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0048`；C/C++ 或辅助构建通用内容（2.6 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0049|第3章 C++概览：抽象机制|74|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0049`；C/C++ 或辅助构建通用内容（第3章 C++概览：抽象机制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0050|3.1 引言|74|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0050`；C/C++ 或辅助构建通用内容（3.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0051|3.2 类|74|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0051`；C/C++ 或辅助构建通用内容（3.2 类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0052|3.2.1 具体类型|75|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0052`；C/C++ 或辅助构建通用内容（3.2.1 具体类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0053|3.2.2 抽象类型|79|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0053`；C/C++ 或辅助构建通用内容（3.2.2 抽象类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0054|3.2.3 虚函数|81|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0054`；C/C++ 或辅助构建通用内容（3.2.3 虚函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0055|3.2.4 类层次|82|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0055`；C/C++ 或辅助构建通用内容（3.2.4 类层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0056|3.3 拷贝和移动|85|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0056`；C/C++ 或辅助构建通用内容（3.3 拷贝和移动）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0057|3.3.1 拷贝容器|86|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0057`；C/C++ 或辅助构建通用内容（3.3.1 拷贝容器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0058|3.3.2 移动容器|87|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0058`；C/C++ 或辅助构建通用内容（3.3.2 移动容器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0059|3.3.3 资源管理|89|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0059`；C/C++ 或辅助构建通用内容（3.3.3 资源管理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0060|3.3.4 抑制操作|89|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0060`；C/C++ 或辅助构建通用内容（3.3.4 抑制操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0061|3.4 模板|90|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0061`；C/C++ 或辅助构建通用内容（3.4 模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0062|3.4.1 参数化类型|90|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0062`；C/C++ 或辅助构建通用内容（3.4.1 参数化类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0063|3.4.2 函数模板|92|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0063`；C/C++ 或辅助构建通用内容（3.4.2 函数模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0064|3.4.3 函数对象|92|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0064`；C/C++ 或辅助构建通用内容（3.4.3 函数对象）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0065|3.4.4 可变参数模板|94|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0065`；C/C++ 或辅助构建通用内容（3.4.4 可变参数模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0066|3.4.5 别名|95|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0066`；C/C++ 或辅助构建通用内容（3.4.5 别名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0067|3.5 建议|96|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0067`；C/C++ 或辅助构建通用内容（3.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0068|第4章 C++概览：容器与算法|97|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0068`；C/C++ 或辅助构建通用内容（第4章 C++概览：容器与算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0069|4.1 标准库|97|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0069`；C/C++ 或辅助构建通用内容（4.1 标准库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0070|4.1.1 标准库概述|98|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0070`；C/C++ 或辅助构建通用内容（4.1.1 标准库概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0071|4.1.2 标准库头文件与名字空间|98|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0071`；C/C++ 或辅助构建通用内容（4.1.2 标准库头文件与名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0072|4.2 字符串|100|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0072`；C/C++ 或辅助构建通用内容（4.2 字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0073|4.3 I/O流|101|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0073`；C/C++ 或辅助构建通用内容（4.3 I/O流）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0074|4.3.1 输出|101|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0074`；C/C++ 或辅助构建通用内容（4.3.1 输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0075|4.3.2 输入|102|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0075`；C/C++ 或辅助构建通用内容（4.3.2 输入）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0076|4.3.3 用户自定义类型的I/O|103|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0076`；C/C++ 或辅助构建通用内容（4.3.3 用户自定义类型的I/O）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0077|4.4 容器|104|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0077`；C/C++ 或辅助构建通用内容（4.4 容器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0078|4.4.1 vector|104|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0078`；C/C++ 或辅助构建通用内容（4.4.1 vector）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0079|4.4.2 list|107|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0079`；C/C++ 或辅助构建通用内容（4.4.2 list）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0080|4.4.3 map|108|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0080`；C/C++ 或辅助构建通用内容（4.4.3 map）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0081|4.4.4 unordered_map|109|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0081`；C/C++ 或辅助构建通用内容（4.4.4 unordered_map）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0082|4.4.5 容器概述|109|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0082`；C/C++ 或辅助构建通用内容（4.4.5 容器概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0083|4.5 算法|110|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0083`；C/C++ 或辅助构建通用内容（4.5 算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0084|4.5.1 使用迭代器|111|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0084`；C/C++ 或辅助构建通用内容（4.5.1 使用迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0085|4.5.2 迭代器类型|113|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0085`；C/C++ 或辅助构建通用内容（4.5.2 迭代器类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0086|4.5.3 流迭代器|114|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0086`；C/C++ 或辅助构建通用内容（4.5.3 流迭代器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0087|4.5.4 谓词|116|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0087`；C/C++ 或辅助构建通用内容（4.5.4 谓词）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0088|4.5.5 算法概述|116|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0088`；C/C++ 或辅助构建通用内容（4.5.5 算法概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0089|4.5.6 容器算法|117|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0089`；C/C++ 或辅助构建通用内容（4.5.6 容器算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0090|4.6 建议|117|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0090`；C/C++ 或辅助构建通用内容（4.6 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0091|第5章 C++概览：并发与实用功能|119|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S05.md#review-s05-u0091`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S05-U0092|5.1 引言|119|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0092`；C/C++ 或辅助构建通用内容（5.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0093|5.2 资源管理|119|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0093`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S05-U0094|5.2.1 unique_ptr与shared_ptr|120|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0094`；C/C++ 或辅助构建通用内容（5.2.1 unique_ptr与shared_ptr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0095|5.3 并发|122|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S05.md#review-s05-u0095`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S05-U0096|5.3.1 任务和thread|122|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0096`；C/C++ 或辅助构建通用内容（5.3.1 任务和thread）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0097|5.3.2 传递参数|123|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0097`；C/C++ 或辅助构建通用内容（5.3.2 传递参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0098|5.3.3 返回结果|123|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0098`；C/C++ 或辅助构建通用内容（5.3.3 返回结果）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0099|5.3.4 共享数据|124|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0099`；C/C++ 或辅助构建通用内容（5.3.4 共享数据）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0100|5.3.5 任务通信|126|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0100`；C/C++ 或辅助构建通用内容（5.3.5 任务通信）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0101|5.4 小工具组件|129|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0101`；C/C++ 或辅助构建通用内容（5.4 小工具组件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0102|5.4.1 时间|129|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0102`；C/C++ 或辅助构建通用内容（5.4.1 时间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0103|5.4.2 类型函数|130|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0103`；C/C++ 或辅助构建通用内容（5.4.2 类型函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0104|5.4.3 pair和tuple|132|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0104`；C/C++ 或辅助构建通用内容（5.4.3 pair和tuple）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0105|5.5 正则表达式|133|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0105`；C/C++ 或辅助构建通用内容（5.5 正则表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0106|5.6 数学计算|134|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0106`；C/C++ 或辅助构建通用内容（5.6 数学计算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0107|5.6.1 数学函数和算法|134|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0107`；C/C++ 或辅助构建通用内容（5.6.1 数学函数和算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0108|5.6.2 复数|134|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0108`；C/C++ 或辅助构建通用内容（5.6.2 复数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0109|5.6.3 随机数|135|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0109`；C/C++ 或辅助构建通用内容（5.6.3 随机数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0110|5.6.4 向量算术|136|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0110`；C/C++ 或辅助构建通用内容（5.6.4 向量算术）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0111|5.6.5 数值限制|136|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0111`；C/C++ 或辅助构建通用内容（5.6.5 数值限制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0112|5.7 建议|137|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0112`；C/C++ 或辅助构建通用内容（5.7 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0113|第6章 类型与声明|139|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0113`；C/C++ 或辅助构建通用内容（第6章 类型与声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0114|6.1 ISO C++标准|139|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0114`；C/C++ 或辅助构建通用内容（6.1 ISO C++标准）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0115|6.1.1 实现|140|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0115`；C/C++ 或辅助构建通用内容（6.1.1 实现）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0116|6.1.2 基本源程序字符集|141|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0116`；C/C++ 或辅助构建通用内容（6.1.2 基本源程序字符集）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0117|6.2 类型|141|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0117`；C/C++ 或辅助构建通用内容（6.2 类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0118|6.2.1 基本类型|142|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0118`；C/C++ 或辅助构建通用内容（6.2.1 基本类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0119|6.2.2 布尔值|142|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0119`；C/C++ 或辅助构建通用内容（6.2.2 布尔值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0120|6.2.3 字符类型|144|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0120`；C/C++ 或辅助构建通用内容（6.2.3 字符类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0121|6.2.4 整数类型|147|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0121`；C/C++ 或辅助构建通用内容（6.2.4 整数类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0122|6.2.5 浮点数类型|149|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0122`；C/C++ 或辅助构建通用内容（6.2.5 浮点数类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0123|6.2.6 前缀和后缀|150|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0123`；C/C++ 或辅助构建通用内容（6.2.6 前缀和后缀）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0124|6.2.7 void|151|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0124`；C/C++ 或辅助构建通用内容（6.2.7 void）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0125|6.2.8 类型尺寸|151|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0125`；C/C++ 或辅助构建通用内容（6.2.8 类型尺寸）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0126|6.2.9 对齐|153|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0126`；C/C++ 或辅助构建通用内容（6.2.9 对齐）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0127|6.3 声明|154|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0127`；C/C++ 或辅助构建通用内容（6.3 声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0128|6.3.1 声明的结构|156|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0128`；C/C++ 或辅助构建通用内容（6.3.1 声明的结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0129|6.3.2 声明多个名字|157|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0129`；C/C++ 或辅助构建通用内容（6.3.2 声明多个名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0130|6.3.3 名字|157|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0130`；C/C++ 或辅助构建通用内容（6.3.3 名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0131|6.3.4 作用域|159|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0131`；C/C++ 或辅助构建通用内容（6.3.4 作用域）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0132|6.3.5 初始化|161|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0132`；C/C++ 或辅助构建通用内容（6.3.5 初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0133|6.3.6 推断类型：auto和decltype()|164|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0133`；C/C++ 或辅助构建通用内容（6.3.6 推断类型：auto和decltype()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0134|6.4 对象和值|167|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0134`；C/C++ 或辅助构建通用内容（6.4 对象和值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0135|6.4.1 左值和右值|167|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0135`；C/C++ 或辅助构建通用内容（6.4.1 左值和右值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0136|6.4.2 对象的生命周期|168|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0136`；C/C++ 或辅助构建通用内容（6.4.2 对象的生命周期）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0137|6.5 类型别名|169|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0137`；C/C++ 或辅助构建通用内容（6.5 类型别名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0138|6.6 建议|170|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0138`；C/C++ 或辅助构建通用内容（6.6 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0139|第7章 指针、数组与引用|171|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0139`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0140|7.1 引言|171|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0140`；C/C++ 或辅助构建通用内容（7.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0141|7.2 指针|171|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0141`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0142|7.2.1 void*|172|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0142`；C/C++ 或辅助构建通用内容（7.2.1 void*）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0143|7.2.2 nullptr|173|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0143`；C/C++ 或辅助构建通用内容（7.2.2 nullptr）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0144|7.3 数组|173|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0144`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0145|7.3.1 数组的初始化器|175|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0145`；C/C++ 或辅助构建通用内容（7.3.1 数组的初始化器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0146|7.3.2 字符串字面值常量|175|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0146`；C/C++ 或辅助构建通用内容（7.3.2 字符串字面值常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0147|7.4 数组中的指针|178|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0147`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0148|7.4.1 数组漫游|179|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0148`；C/C++ 或辅助构建通用内容（7.4.1 数组漫游）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0149|7.4.2 多维数组|181|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0149`；C/C++ 或辅助构建通用内容（7.4.2 多维数组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0150|7.4.3 传递数组|182|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0150`；C/C++ 或辅助构建通用内容（7.4.3 传递数组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0151|7.5 指针与const|184|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0151`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0152|7.6 指针与所有权|186|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0152`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0153|7.7 引用|186|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0153`；C/C++ 或辅助构建通用内容（7.7 引用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0154|7.7.1 左值引用|187|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0154`；C/C++ 或辅助构建通用内容（7.7.1 左值引用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0155|7.7.2 右值引用|190|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0155`；C/C++ 或辅助构建通用内容（7.7.2 右值引用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0156|7.7.3 引用的引用|192|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0156`；C/C++ 或辅助构建通用内容（7.7.3 引用的引用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0157|7.7.4 指针与引用|193|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0157`；C/C++ 或辅助构建通用内容（7.7.4 指针与引用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0158|7.8 建议|195|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0158`；C/C++ 或辅助构建通用内容（7.8 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0159|第8章 结构、联合与枚举|196|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0159`；C/C++ 或辅助构建通用内容（第8章 结构、联合与枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0160|8.1 引言|196|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0160`；C/C++ 或辅助构建通用内容（8.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0161|8.2 结构|196|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0161`；C/C++ 或辅助构建通用内容（8.2 结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0162|8.2.1 struct的布局|198|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0162`；C/C++ 或辅助构建通用内容（8.2.1 struct的布局）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0163|8.2.2 struct的名字|199|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0163`；C/C++ 或辅助构建通用内容（8.2.2 struct的名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0164|8.2.3 结构与类|200|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0164`；C/C++ 或辅助构建通用内容（8.2.3 结构与类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0165|8.2.4 结构与数组|201|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0165`；C/C++ 或辅助构建通用内容（8.2.4 结构与数组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0166|8.2.5 类型等价|203|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0166`；C/C++ 或辅助构建通用内容（8.2.5 类型等价）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0167|8.2.6 普通旧数据|203|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0167`；C/C++ 或辅助构建通用内容（8.2.6 普通旧数据）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0168|8.2.7 域|205|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0168`；C/C++ 或辅助构建通用内容（8.2.7 域）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0169|8.3 联合|206|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0169`；C/C++ 或辅助构建通用内容（8.3 联合）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0170|8.3.1 联合与类|208|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0170`；C/C++ 或辅助构建通用内容（8.3.1 联合与类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0171|8.3.2 匿名union|209|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0171`；C/C++ 或辅助构建通用内容（8.3.2 匿名union）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0172|8.4 枚举|211|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0172`；C/C++ 或辅助构建通用内容（8.4 枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0173|8.4.1 enum class|211|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0173`；C/C++ 或辅助构建通用内容（8.4.1 enum class）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0174|8.4.2 普通的enum|214|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0174`；C/C++ 或辅助构建通用内容（8.4.2 普通的enum）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0175|8.4.3 未命名的enum|215|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0175`；C/C++ 或辅助构建通用内容（8.4.3 未命名的enum）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0176|8.5 建议|216|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0176`；C/C++ 或辅助构建通用内容（8.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0177|第9章 语句|217|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0177`；C/C++ 或辅助构建通用内容（第9章 语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0178|9.1 引言|217|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0178`；C/C++ 或辅助构建通用内容（9.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0179|9.2 语句概述|217|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0179`；C/C++ 或辅助构建通用内容（9.2 语句概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0180|9.3 声明作为语句|218|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0180`；C/C++ 或辅助构建通用内容（9.3 声明作为语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0181|9.4 选择语句|219|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0181`；C/C++ 或辅助构建通用内容（9.4 选择语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0182|9.4.1 if语句|219|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0182`；C/C++ 或辅助构建通用内容（9.4.1 if语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0183|9.4.2 switch语句|221|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0183`；C/C++ 或辅助构建通用内容（9.4.2 switch语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0184|9.4.3 条件中的声明|223|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0184`；C/C++ 或辅助构建通用内容（9.4.3 条件中的声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0185|9.5 循环语句|224|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0185`；C/C++ 或辅助构建通用内容（9.5 循环语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0186|9.5.1 范围for语句|224|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0186`；C/C++ 或辅助构建通用内容（9.5.1 范围for语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0187|9.5.2 for语句|225|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0187`；C/C++ 或辅助构建通用内容（9.5.2 for语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0188|9.5.3 while语句|226|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0188`；C/C++ 或辅助构建通用内容（9.5.3 while语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0189|9.5.4 do语句|226|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0189`；C/C++ 或辅助构建通用内容（9.5.4 do语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0190|9.5.5 退出循环|227|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0190`；C/C++ 或辅助构建通用内容（9.5.5 退出循环）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0191|9.6 goto语句|227|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0191`；C/C++ 或辅助构建通用内容（9.6 goto语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0192|9.7 注释与缩进|228|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0192`；C/C++ 或辅助构建通用内容（9.7 注释与缩进）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0193|9.8 建议|230|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0193`；C/C++ 或辅助构建通用内容（9.8 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0194|第10章 表达式|231|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0194`；C/C++ 或辅助构建通用内容（第10章 表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0195|10.1 引言|231|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0195`；C/C++ 或辅助构建通用内容（10.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0196|10.2 一个桌面计算器示例|231|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0196`；C/C++ 或辅助构建通用内容（10.2 一个桌面计算器示例）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0197|10.2.1 分析器|232|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0197`；C/C++ 或辅助构建通用内容（10.2.1 分析器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0198|10.2.2 输入|236|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0198`；C/C++ 或辅助构建通用内容（10.2.2 输入）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0199|10.2.3 底层输入|239|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0199`；C/C++ 或辅助构建通用内容（10.2.3 底层输入）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0200|10.2.4 错误处理|240|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0200`；C/C++ 或辅助构建通用内容（10.2.4 错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0201|10.2.5 驱动程序|240|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0201`；C/C++ 或辅助构建通用内容（10.2.5 驱动程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0202|10.2.6 头文件|241|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0202`；C/C++ 或辅助构建通用内容（10.2.6 头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0203|10.2.7 命令行参数|241|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0203`；C/C++ 或辅助构建通用内容（10.2.7 命令行参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0204|10.2.8 关于风格|243|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0204`；C/C++ 或辅助构建通用内容（10.2.8 关于风格）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0205|10.3 运算符概述|243|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0205`；C/C++ 或辅助构建通用内容（10.3 运算符概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0206|10.3.1 结果|247|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0206`；C/C++ 或辅助构建通用内容（10.3.1 结果）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0207|10.3.2 求值顺序|247|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0207`；C/C++ 或辅助构建通用内容（10.3.2 求值顺序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0208|10.3.3 运算符优先级|248|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0208`；C/C++ 或辅助构建通用内容（10.3.3 运算符优先级）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0209|10.3.4 临时对象|249|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0209`；C/C++ 或辅助构建通用内容（10.3.4 临时对象）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0210|10.4 常量表达式|250|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0210`；C/C++ 或辅助构建通用内容（10.4 常量表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0211|10.4.1 符号化常量|252|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0211`；C/C++ 或辅助构建通用内容（10.4.1 符号化常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0212|10.4.2 常量表达式中的const|252|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0212`；C/C++ 或辅助构建通用内容（10.4.2 常量表达式中的const）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0213|10.4.3 字面值常量类型|252|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0213`；C/C++ 或辅助构建通用内容（10.4.3 字面值常量类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0214|10.4.4 引用参数|253|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0214`；C/C++ 或辅助构建通用内容（10.4.4 引用参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0215|10.4.5 地址常量表达式|254|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0215`；C/C++ 或辅助构建通用内容（10.4.5 地址常量表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0216|10.5 隐式类型转换|254|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0216`；C/C++ 或辅助构建通用内容（10.5 隐式类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0217|10.5.1 提升|254|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0217`；C/C++ 或辅助构建通用内容（10.5.1 提升）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0218|10.5.2 类型转换|255|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0218`；C/C++ 或辅助构建通用内容（10.5.2 类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0219|10.5.3 常用的算术类型转换|257|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0219`；C/C++ 或辅助构建通用内容（10.5.3 常用的算术类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0220|10.6 建议|258|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0220`；C/C++ 或辅助构建通用内容（10.6 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0221|第11章 选择适当的操作|259|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0221`；C/C++ 或辅助构建通用内容（第11章 选择适当的操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0222|11.1 其他运算符|259|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0222`；C/C++ 或辅助构建通用内容（11.1 其他运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0223|11.1.1 逻辑运算符|259|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0223`；C/C++ 或辅助构建通用内容（11.1.1 逻辑运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0224|11.1.2 位逻辑运算符|259|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0224`；C/C++ 或辅助构建通用内容（11.1.2 位逻辑运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0225|11.1.3 条件表达式|261|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0225`；C/C++ 或辅助构建通用内容（11.1.3 条件表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0226|11.1.4 递增与递减|261|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0226`；C/C++ 或辅助构建通用内容（11.1.4 递增与递减）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0227|11.2 自由存储|263|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0227`；C/C++ 或辅助构建通用内容（11.2 自由存储）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0228|11.2.1 内存管理|264|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0228`；C/C++ 或辅助构建通用内容（11.2.1 内存管理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0229|11.2.2 数组|266|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0229`；C/C++ 或辅助构建通用内容（11.2.2 数组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0230|11.2.3 获取内存空间|267|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0230`；C/C++ 或辅助构建通用内容（11.2.3 获取内存空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0231|11.2.4 重载new|268|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0231`；C/C++ 或辅助构建通用内容（11.2.4 重载new）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0232|11.3 列表|270|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0232`；C/C++ 或辅助构建通用内容（11.3 列表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0233|11.3.1 实现模型|271|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0233`；C/C++ 或辅助构建通用内容（11.3.1 实现模型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0234|11.3.2 限定列表|272|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0234`；C/C++ 或辅助构建通用内容（11.3.2 限定列表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0235|11.3.3 未限定列表|272|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0235`；C/C++ 或辅助构建通用内容（11.3.3 未限定列表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0236|11.4 lambda表达式|274|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0236`；C/C++ 或辅助构建通用内容（11.4 lambda表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0237|11.4.1 实现模型|274|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0237`；C/C++ 或辅助构建通用内容（11.4.1 实现模型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0238|11.4.2 lambda的替代品|275|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0238`；C/C++ 或辅助构建通用内容（11.4.2 lambda的替代品）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0239|11.4.3 捕获|277|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0239`；C/C++ 或辅助构建通用内容（11.4.3 捕获）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0240|11.4.4 调用与返回|280|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0240`；C/C++ 或辅助构建通用内容（11.4.4 调用与返回）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0241|11.4.5 lambda的类型|280|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0241`；C/C++ 或辅助构建通用内容（11.4.5 lambda的类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0242|11.5 显式类型转换|281|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0242`；C/C++ 或辅助构建通用内容（11.5 显式类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0243|11.5.1 构造|282|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0243`；C/C++ 或辅助构建通用内容（11.5.1 构造）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0244|11.5.2 命名转换|284|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0244`；C/C++ 或辅助构建通用内容（11.5.2 命名转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0245|11.5.3 C风格的转换|285|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0245`；C/C++ 或辅助构建通用内容（11.5.3 C风格的转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0246|11.5.4 函数形式的转换|285|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0246`；C/C++ 或辅助构建通用内容（11.5.4 函数形式的转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0247|11.6 建议|286|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0247`；C/C++ 或辅助构建通用内容（11.6 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0248|第12章 函数|287|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0248`；C/C++ 或辅助构建通用内容（第12章 函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0249|12.1 函数声明|287|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0249`；C/C++ 或辅助构建通用内容（12.1 函数声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0250|12.1.1 为什么使用函数|288|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0250`；C/C++ 或辅助构建通用内容（12.1.1 为什么使用函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0251|12.1.2 函数声明的组成要件|288|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0251`；C/C++ 或辅助构建通用内容（12.1.2 函数声明的组成要件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0252|12.1.3 函数定义|289|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0252`；C/C++ 或辅助构建通用内容（12.1.3 函数定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0253|12.1.4 返回值|290|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0253`；C/C++ 或辅助构建通用内容（12.1.4 返回值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0254|12.1.5 inline函数|292|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0254`；C/C++ 或辅助构建通用内容（12.1.5 inline函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0255|12.1.6 constexpr函数|292|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0255`；C/C++ 或辅助构建通用内容（12.1.6 constexpr函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0256|12.1.7 [[noreturn]]函数|294|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0256`；C/C++ 或辅助构建通用内容（12.1.7 [[noreturn]]函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0257|12.1.8 局部变量|295|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0257`；C/C++ 或辅助构建通用内容（12.1.8 局部变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0258|12.2 参数传递|296|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0258`；C/C++ 或辅助构建通用内容（12.2 参数传递）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0259|12.2.1 引用参数|296|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0259`；C/C++ 或辅助构建通用内容（12.2.1 引用参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0260|12.2.2 数组参数|298|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0260`；C/C++ 或辅助构建通用内容（12.2.2 数组参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0261|12.2.3 列表参数|300|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0261`；C/C++ 或辅助构建通用内容（12.2.3 列表参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0262|12.2.4 数量未定的参数|301|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0262`；C/C++ 或辅助构建通用内容（12.2.4 数量未定的参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0263|12.2.5 默认参数|304|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0263`；C/C++ 或辅助构建通用内容（12.2.5 默认参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0264|12.3 重载函数|305|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0264`；C/C++ 或辅助构建通用内容（12.3 重载函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0265|12.3.1 自动重载解析|306|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0265`；C/C++ 或辅助构建通用内容（12.3.1 自动重载解析）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0266|12.3.2 重载与返回类型|307|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0266`；C/C++ 或辅助构建通用内容（12.3.2 重载与返回类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0267|12.3.3 重载与作用域|308|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0267`；C/C++ 或辅助构建通用内容（12.3.3 重载与作用域）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0268|12.3.4 多实参解析|308|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0268`；C/C++ 或辅助构建通用内容（12.3.4 多实参解析）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0269|12.3.5 手动重载解析|309|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0269`；C/C++ 或辅助构建通用内容（12.3.5 手动重载解析）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0270|12.4 前置与后置条件|309|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0270`；C/C++ 或辅助构建通用内容（12.4 前置与后置条件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0271|12.5 函数指针|311|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0271`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0272|12.6 宏|315|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0272`；C/C++ 或辅助构建通用内容（12.6 宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0273|12.6.1 条件编译|317|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0273`；C/C++ 或辅助构建通用内容（12.6.1 条件编译）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0274|12.6.2 预定义宏|318|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0274`；C/C++ 或辅助构建通用内容（12.6.2 预定义宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0275|12.6.3 编译指令|319|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0275`；C/C++ 或辅助构建通用内容（12.6.3 编译指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0276|12.7 建议|319|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0276`；C/C++ 或辅助构建通用内容（12.7 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0277|第13章 异常处理|320|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0277`；C/C++ 或辅助构建通用内容（第13章 异常处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0278|13.1 错误处理|320|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0278`；C/C++ 或辅助构建通用内容（13.1 错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0279|13.1.1 异常|321|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0279`；C/C++ 或辅助构建通用内容（13.1.1 异常）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0280|13.1.2 传统的错误处理|322|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0280`；C/C++ 或辅助构建通用内容（13.1.2 传统的错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0281|13.1.3 渐进决策|323|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0281`；C/C++ 或辅助构建通用内容（13.1.3 渐进决策）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0282|13.1.4 另一种视角看异常|324|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0282`；C/C++ 或辅助构建通用内容（13.1.4 另一种视角看异常）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0283|13.1.5 何时不应使用异常|325|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0283`；C/C++ 或辅助构建通用内容（13.1.5 何时不应使用异常）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0284|13.1.6 层次化错误处理|326|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0284`；C/C++ 或辅助构建通用内容（13.1.6 层次化错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0285|13.1.7 异常与效率|327|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0285`；C/C++ 或辅助构建通用内容（13.1.7 异常与效率）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0286|13.2 异常保障|328|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0286`；C/C++ 或辅助构建通用内容（13.2 异常保障）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0287|13.3 资源管理|330|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0287`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S05-U0288|13.3.1 finally|333|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0288`；C/C++ 或辅助构建通用内容（13.3.1 finally）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0289|13.4 强制不变式|334|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0289`；C/C++ 或辅助构建通用内容（13.4 强制不变式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0290|13.5 抛出与捕获异常|338|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0290`；C/C++ 或辅助构建通用内容（13.5 抛出与捕获异常）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0291|13.5.1 抛出异常|338|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0291`；C/C++ 或辅助构建通用内容（13.5.1 抛出异常）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0292|13.5.2 捕获异常|341|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0292`；C/C++ 或辅助构建通用内容（13.5.2 捕获异常）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0293|13.5.3 异常与线程|347|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0293`；C/C++ 或辅助构建通用内容（13.5.3 异常与线程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0294|13.6 vector的实现|347|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0294`；C/C++ 或辅助构建通用内容（13.6 vector的实现）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0295|13.6.1 一个简单的vector|348|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0295`；C/C++ 或辅助构建通用内容（13.6.1 一个简单的vector）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0296|13.6.2 显式地表示内存|351|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0296`；C/C++ 或辅助构建通用内容（13.6.2 显式地表示内存）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0297|13.6.3 赋值|354|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0297`；C/C++ 或辅助构建通用内容（13.6.3 赋值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0298|13.6.4 改变尺寸|355|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0298`；C/C++ 或辅助构建通用内容（13.6.4 改变尺寸）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0299|13.7 建议|358|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0299`；C/C++ 或辅助构建通用内容（13.7 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0300|第14章 名字空间|360|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0300`；C/C++ 或辅助构建通用内容（第14章 名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0301|14.1 组合问题|360|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0301`；C/C++ 或辅助构建通用内容（14.1 组合问题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0302|14.2 名字空间|361|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0302`；C/C++ 或辅助构建通用内容（14.2 名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0303|14.2.1 显式限定|362|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0303`；C/C++ 或辅助构建通用内容（14.2.1 显式限定）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0304|14.2.2 using声明|363|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0304`；C/C++ 或辅助构建通用内容（14.2.2 using声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0305|14.2.3 using指示|364|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0305`；C/C++ 或辅助构建通用内容（14.2.3 using指示）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0306|14.2.4 参数依赖查找|365|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0306`；C/C++ 或辅助构建通用内容（14.2.4 参数依赖查找）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0307|14.2.5 名字空间是开放的|367|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0307`；C/C++ 或辅助构建通用内容（14.2.5 名字空间是开放的）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0308|14.3 模块化和接口|368|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0308`；C/C++ 或辅助构建通用内容（14.3 模块化和接口）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0309|14.3.1 名字空间作为模块|369|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0309`；C/C++ 或辅助构建通用内容（14.3.1 名字空间作为模块）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0310|14.3.2 实现|371|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0310`；C/C++ 或辅助构建通用内容（14.3.2 实现）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0311|14.3.3 接口和名字|372|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0311`；C/C++ 或辅助构建通用内容（14.3.3 接口和名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0312|14.4 组合使用名字空间|374|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0312`；C/C++ 或辅助构建通用内容（14.4 组合使用名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0313|14.4.1 便利性与安全性|374|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0313`；C/C++ 或辅助构建通用内容（14.4.1 便利性与安全性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0314|14.4.2 名字空间别名|375|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0314`；C/C++ 或辅助构建通用内容（14.4.2 名字空间别名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0315|14.4.3 组合名字空间|375|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0315`；C/C++ 或辅助构建通用内容（14.4.3 组合名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0316|14.4.4 组合与选择|376|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0316`；C/C++ 或辅助构建通用内容（14.4.4 组合与选择）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0317|14.4.5 名字空间和重载|377|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0317`；C/C++ 或辅助构建通用内容（14.4.5 名字空间和重载）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0318|14.4.6 版本控制|379|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0318`；C/C++ 或辅助构建通用内容（14.4.6 版本控制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0319|14.4.7 名字空间嵌套|381|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0319`；C/C++ 或辅助构建通用内容（14.4.7 名字空间嵌套）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0320|14.4.8 无名名字空间|382|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0320`；C/C++ 或辅助构建通用内容（14.4.8 无名名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0321|14.4.9 C头文件|382|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0321`；C/C++ 或辅助构建通用内容（14.4.9 C头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0322|14.5 建议|383|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0322`；C/C++ 或辅助构建通用内容（14.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0323|第15章 源文件与程序|385|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0323`；C/C++ 或辅助构建通用内容（第15章 源文件与程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0324|15.1 分离编译|385|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0324`；C/C++ 或辅助构建通用内容（15.1 分离编译）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0325|15.2 链接|386|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S05.md#review-s05-u0325`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S05-U0326|15.2.1 文件内名字|388|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0326`；C/C++ 或辅助构建通用内容（15.2.1 文件内名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0327|15.2.2 头文件|389|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0327`；C/C++ 或辅助构建通用内容（15.2.2 头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0328|15.2.3 单一定义规则|391|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0328`；C/C++ 或辅助构建通用内容（15.2.3 单一定义规则）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0329|15.2.4 标准库头文件|392|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0329`；C/C++ 或辅助构建通用内容（15.2.4 标准库头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0330|15.2.5 链接非C++代码|393|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0330`；C/C++ 或辅助构建通用内容（15.2.5 链接非C++代码）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0331|15.2.6 链接和函数指针|395|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0331`；C/C++ 或辅助构建通用内容（15.2.6 链接和函数指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0332|15.3 使用头文件|396|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0332`；C/C++ 或辅助构建通用内容（15.3 使用头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0333|15.3.1 单头文件组织|396|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0333`；C/C++ 或辅助构建通用内容（15.3.1 单头文件组织）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0334|15.3.2 多头文件组织|399|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0334`；C/C++ 或辅助构建通用内容（15.3.2 多头文件组织）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0335|15.3.3 包含保护|403|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0335`；C/C++ 或辅助构建通用内容（15.3.3 包含保护）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0336|15.4 程序|404|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0336`；C/C++ 或辅助构建通用内容（15.4 程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0337|15.4.1 非局部变量初始化|404|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0337`；C/C++ 或辅助构建通用内容（15.4.1 非局部变量初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0338|15.4.2 初始化和并发|405|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0338`；C/C++ 或辅助构建通用内容（15.4.2 初始化和并发）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0339|15.4.3 程序终止|406|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0339`；C/C++ 或辅助构建通用内容（15.4.3 程序终止）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0340|15.5 建议|407|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0340`；C/C++ 或辅助构建通用内容（15.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0341|第16章 类|409|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0341`；C/C++ 或辅助构建通用内容（第16章 类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0342|16.1 引言|409|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0342`；C/C++ 或辅助构建通用内容（16.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0343|16.2 类基础|410|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0343`；C/C++ 或辅助构建通用内容（16.2 类基础）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0344|16.2.1 成员函数|411|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0344`；C/C++ 或辅助构建通用内容（16.2.1 成员函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0345|16.2.2 默认拷贝|412|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0345`；C/C++ 或辅助构建通用内容（16.2.2 默认拷贝）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0346|16.2.3 访问控制|412|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0346`；C/C++ 或辅助构建通用内容（16.2.3 访问控制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0347|16.2.4 class和struct|413|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0347`；C/C++ 或辅助构建通用内容（16.2.4 class和struct）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0348|16.2.5 构造函数|414|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0348`；C/C++ 或辅助构建通用内容（16.2.5 构造函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0349|16.2.6 explicit构造函数|416|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0349`；C/C++ 或辅助构建通用内容（16.2.6 explicit构造函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0350|16.2.7 类内初始化器|418|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0350`；C/C++ 或辅助构建通用内容（16.2.7 类内初始化器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0351|16.2.8 类内函数定义|418|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0351`；C/C++ 或辅助构建通用内容（16.2.8 类内函数定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0352|16.2.9 可变性|419|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0352`；C/C++ 或辅助构建通用内容（16.2.9 可变性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0353|16.2.10 自引用|422|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0353`；C/C++ 或辅助构建通用内容（16.2.10 自引用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0354|16.2.11 成员访问|423|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0354`；C/C++ 或辅助构建通用内容（16.2.11 成员访问）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0355|16.2.12 static成员|424|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0355`；C/C++ 或辅助构建通用内容（16.2.12 static成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0356|16.2.13 成员类型|426|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0356`；C/C++ 或辅助构建通用内容（16.2.13 成员类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0357|16.3 具体类|426|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0357`；C/C++ 或辅助构建通用内容（16.3 具体类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0358|16.3.1 成员函数|429|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0358`；C/C++ 或辅助构建通用内容（16.3.1 成员函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0359|16.3.2 辅助函数|431|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0359`；C/C++ 或辅助构建通用内容（16.3.2 辅助函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0360|16.3.3 重载运算符|433|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0360`；C/C++ 或辅助构建通用内容（16.3.3 重载运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0361|16.3.4 具体类的重要性|433|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0361`；C/C++ 或辅助构建通用内容（16.3.4 具体类的重要性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0362|16.4 建议|434|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0362`；C/C++ 或辅助构建通用内容（16.4 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0363|第17章 构造、清理、拷贝和移动|436|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0363`；C/C++ 或辅助构建通用内容（第17章 构造、清理、拷贝和移动）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0364|17.1 引言|436|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0364`；C/C++ 或辅助构建通用内容（17.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0365|17.2 构造函数和析构函数|438|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0365`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S05-U0366|17.2.1 构造函数和不变式|438|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0366`；C/C++ 或辅助构建通用内容（17.2.1 构造函数和不变式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0367|17.2.2 析构函数和资源|439|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0367`；C/C++ 或辅助构建通用内容（17.2.2 析构函数和资源）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0368|17.2.3 基类和成员析构函数|440|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0368`；C/C++ 或辅助构建通用内容（17.2.3 基类和成员析构函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0369|17.2.4 调用构造函数和析构函数|441|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0369`；C/C++ 或辅助构建通用内容（17.2.4 调用构造函数和析构函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0370|17.2.5 virtual析构函数|442|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0370`；C/C++ 或辅助构建通用内容（17.2.5 virtual析构函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0371|17.3 类对象初始化|443|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0371`；C/C++ 或辅助构建通用内容（17.3 类对象初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0372|17.3.1 不使用构造函数进行初始化|443|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0372`；C/C++ 或辅助构建通用内容（17.3.1 不使用构造函数进行初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0373|17.3.2 使用构造函数进行初始化|444|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0373`；C/C++ 或辅助构建通用内容（17.3.2 使用构造函数进行初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0374|17.3.3 默认构造函数|447|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0374`；C/C++ 或辅助构建通用内容（17.3.3 默认构造函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0375|17.3.4 初始化器列表构造函数|448|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0375`；C/C++ 或辅助构建通用内容（17.3.4 初始化器列表构造函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0376|17.4 成员和基类初始化|452|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0376`；C/C++ 或辅助构建通用内容（17.4 成员和基类初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0377|17.4.1 成员初始化|452|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0377`；C/C++ 或辅助构建通用内容（17.4.1 成员初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0378|17.4.2 基类初始化器|454|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0378`；C/C++ 或辅助构建通用内容（17.4.2 基类初始化器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0379|17.4.3 委托构造函数|454|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0379`；C/C++ 或辅助构建通用内容（17.4.3 委托构造函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0380|17.4.4 类内初始化器|455|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0380`；C/C++ 或辅助构建通用内容（17.4.4 类内初始化器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0381|17.4.5 static成员初始化|457|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0381`；C/C++ 或辅助构建通用内容（17.4.5 static成员初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0382|17.5 拷贝和移动|458|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0382`；C/C++ 或辅助构建通用内容（17.5 拷贝和移动）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0383|17.5.1 拷贝|458|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0383`；C/C++ 或辅助构建通用内容（17.5.1 拷贝）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0384|17.5.2 移动|464|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0384`；C/C++ 或辅助构建通用内容（17.5.2 移动）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0385|17.6 生成默认操作|467|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0385`；C/C++ 或辅助构建通用内容（17.6 生成默认操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0386|17.6.1 显式声明默认操作|467|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0386`；C/C++ 或辅助构建通用内容（17.6.1 显式声明默认操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0387|17.6.2 默认操作|468|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0387`；C/C++ 或辅助构建通用内容（17.6.2 默认操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0388|17.6.3 使用默认操作|469|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0388`；C/C++ 或辅助构建通用内容（17.6.3 使用默认操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0389|17.6.4 使用delete删除的函数|472|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0389`；C/C++ 或辅助构建通用内容（17.6.4 使用delete删除的函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0390|17.7 建议|474|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0390`；C/C++ 或辅助构建通用内容（17.7 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0391|第18章 运算符重载|475|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0391`；C/C++ 或辅助构建通用内容（第18章 运算符重载）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0392|18.1 引言|475|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0392`；C/C++ 或辅助构建通用内容（18.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0393|18.2 运算符函数|476|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0393`；C/C++ 或辅助构建通用内容（18.2 运算符函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0394|18.2.1 二元和一元运算符|477|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0394`；C/C++ 或辅助构建通用内容（18.2.1 二元和一元运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0395|18.2.2 运算符的预置含义|478|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0395`；C/C++ 或辅助构建通用内容（18.2.2 运算符的预置含义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0396|18.2.3 运算符与用户自定义类型|479|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0396`；C/C++ 或辅助构建通用内容（18.2.3 运算符与用户自定义类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0397|18.2.4 传递对象|479|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0397`；C/C++ 或辅助构建通用内容（18.2.4 传递对象）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0398|18.2.5 名字空间中的运算符|480|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0398`；C/C++ 或辅助构建通用内容（18.2.5 名字空间中的运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0399|18.3 复数类型|482|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0399`；C/C++ 或辅助构建通用内容（18.3 复数类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0400|18.3.1 成员和非成员运算符|482|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0400`；C/C++ 或辅助构建通用内容（18.3.1 成员和非成员运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0401|18.3.2 混合模式运算|483|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0401`；C/C++ 或辅助构建通用内容（18.3.2 混合模式运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0402|18.3.3 类型转换|484|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0402`；C/C++ 或辅助构建通用内容（18.3.3 类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0403|18.3.4 字面值常量|486|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0403`；C/C++ 或辅助构建通用内容（18.3.4 字面值常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0404|18.3.5 访问函数|487|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0404`；C/C++ 或辅助构建通用内容（18.3.5 访问函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0405|18.3.6 辅助函数|488|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0405`；C/C++ 或辅助构建通用内容（18.3.6 辅助函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0406|18.4 类型转换|489|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0406`；C/C++ 或辅助构建通用内容（18.4 类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0407|18.4.1 类型转换运算符|489|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0407`；C/C++ 或辅助构建通用内容（18.4.1 类型转换运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0408|18.4.2 explicit类型转换运算符|490|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0408`；C/C++ 或辅助构建通用内容（18.4.2 explicit类型转换运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0409|18.4.3 二义性|491|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0409`；C/C++ 或辅助构建通用内容（18.4.3 二义性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0410|18.5 建议|492|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0410`；C/C++ 或辅助构建通用内容（18.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0411|第19章 特殊运算符|494|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0411`；C/C++ 或辅助构建通用内容（第19章 特殊运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0412|19.1 引言|494|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0412`；C/C++ 或辅助构建通用内容（19.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0413|19.2 特殊运算符|494|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0413`；C/C++ 或辅助构建通用内容（19.2 特殊运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0414|19.2.1 取下标|494|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0414`；C/C++ 或辅助构建通用内容（19.2.1 取下标）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0415|19.2.2 函数调用|495|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0415`；C/C++ 或辅助构建通用内容（19.2.2 函数调用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0416|19.2.3 解引用|496|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0416`；C/C++ 或辅助构建通用内容（19.2.3 解引用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0417|19.2.4 递增和递减|498|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0417`；C/C++ 或辅助构建通用内容（19.2.4 递增和递减）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0418|19.2.5 分配和释放|500|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0418`；C/C++ 或辅助构建通用内容（19.2.5 分配和释放）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0419|19.2.6 用户自定义字面值常量|501|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0419`；C/C++ 或辅助构建通用内容（19.2.6 用户自定义字面值常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0420|19.3 字符串类|504|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0420`；C/C++ 或辅助构建通用内容（19.3 字符串类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0421|19.3.1 必备操作|504|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0421`；C/C++ 或辅助构建通用内容（19.3.1 必备操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0422|19.3.2 访问字符|505|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0422`；C/C++ 或辅助构建通用内容（19.3.2 访问字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0423|19.3.3 类的表示|506|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0423`；C/C++ 或辅助构建通用内容（19.3.3 类的表示）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0424|19.3.4 成员函数|508|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0424`；C/C++ 或辅助构建通用内容（19.3.4 成员函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0425|19.3.5 辅助函数|510|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0425`；C/C++ 或辅助构建通用内容（19.3.5 辅助函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0426|19.3.6 应用String|512|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0426`；C/C++ 或辅助构建通用内容（19.3.6 应用String）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0427|19.4 友元|513|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0427`；C/C++ 或辅助构建通用内容（19.4 友元）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0428|19.4.1 发现友元|514|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0428`；C/C++ 或辅助构建通用内容（19.4.1 发现友元）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0429|19.4.2 友元与成员|515|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0429`；C/C++ 或辅助构建通用内容（19.4.2 友元与成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0430|19.5 建议|516|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0430`；C/C++ 或辅助构建通用内容（19.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0431|第20章 派生类|518|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0431`；C/C++ 或辅助构建通用内容（第20章 派生类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0432|20.1 引言|518|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0432`；C/C++ 或辅助构建通用内容（20.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0433|20.2 派生类|519|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0433`；C/C++ 或辅助构建通用内容（20.2 派生类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0434|20.2.1 成员函数|521|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0434`；C/C++ 或辅助构建通用内容（20.2.1 成员函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0435|20.2.2 构造函数和析构函数|522|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0435`；C/C++ 或辅助构建通用内容（20.2.2 构造函数和析构函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0436|20.3 类层次|523|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0436`；C/C++ 或辅助构建通用内容（20.3 类层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0437|20.3.1 类型域|523|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0437`；C/C++ 或辅助构建通用内容（20.3.1 类型域）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0438|20.3.2 虚函数|525|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0438`；C/C++ 或辅助构建通用内容（20.3.2 虚函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0439|20.3.3 显式限定|527|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0439`；C/C++ 或辅助构建通用内容（20.3.3 显式限定）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0440|20.3.4 覆盖控制|528|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0440`；C/C++ 或辅助构建通用内容（20.3.4 覆盖控制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0441|20.3.5 using基类成员|531|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0441`；C/C++ 或辅助构建通用内容（20.3.5 using基类成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0442|20.3.6 返回类型放松|534|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0442`；C/C++ 或辅助构建通用内容（20.3.6 返回类型放松）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0443|20.4 抽象类|535|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0443`；C/C++ 或辅助构建通用内容（20.4 抽象类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0444|20.5 访问控制|537|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0444`；C/C++ 或辅助构建通用内容（20.5 访问控制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0445|20.5.1 protected成员|540|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0445`；C/C++ 或辅助构建通用内容（20.5.1 protected成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0446|20.5.2 访问基类|541|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0446`；C/C++ 或辅助构建通用内容（20.5.2 访问基类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0447|20.5.3 using声明与访问控制|542|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0447`；C/C++ 或辅助构建通用内容（20.5.3 using声明与访问控制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0448|20.6 成员指针|543|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S05.md#review-s05-u0448`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S05-U0449|20.6.1 函数成员指针|543|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0449`；C/C++ 或辅助构建通用内容（20.6.1 函数成员指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0450|20.6.2 数据成员指针|545|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0450`；C/C++ 或辅助构建通用内容（20.6.2 数据成员指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0451|20.6.3 基类和派生类成员|546|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0451`；C/C++ 或辅助构建通用内容（20.6.3 基类和派生类成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0452|20.7 建议|546|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0452`；C/C++ 或辅助构建通用内容（20.7 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0453|第21章 类层次|547|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0453`；C/C++ 或辅助构建通用内容（第21章 类层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0454|21.1 引言|547|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0454`；C/C++ 或辅助构建通用内容（21.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0455|21.2 设计类层次|547|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0455`；C/C++ 或辅助构建通用内容（21.2 设计类层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0456|21.2.1 实现继承|548|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0456`；C/C++ 或辅助构建通用内容（21.2.1 实现继承）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0457|21.2.2 接口继承|550|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0457`；C/C++ 或辅助构建通用内容（21.2.2 接口继承）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0458|21.2.3 替代实现方式|552|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0458`；C/C++ 或辅助构建通用内容（21.2.3 替代实现方式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0459|21.2.4 定位对象创建|555|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0459`；C/C++ 或辅助构建通用内容（21.2.4 定位对象创建）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0460|21.3 多重继承|556|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0460`；C/C++ 或辅助构建通用内容（21.3 多重继承）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0461|21.3.1 多重接口|556|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0461`；C/C++ 或辅助构建通用内容（21.3.1 多重接口）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0462|21.3.2 多重实现类|556|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0462`；C/C++ 或辅助构建通用内容（21.3.2 多重实现类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0463|21.3.3 二义性解析|558|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0463`；C/C++ 或辅助构建通用内容（21.3.3 二义性解析）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0464|21.3.4 重复使用基类|561|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0464`；C/C++ 或辅助构建通用内容（21.3.4 重复使用基类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0465|21.3.5 虚基类|562|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0465`；C/C++ 或辅助构建通用内容（21.3.5 虚基类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0466|21.3.6 重复基类与虚基类|567|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0466`；C/C++ 或辅助构建通用内容（21.3.6 重复基类与虚基类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0467|21.4 建议|569|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0467`；C/C++ 或辅助构建通用内容（21.4 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0468|第22章 运行时类型信息|570|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0468`；C/C++ 或辅助构建通用内容（第22章 运行时类型信息）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0469|22.1 引言|570|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0469`；C/C++ 或辅助构建通用内容（22.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0470|22.2 类层次导航|570|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0470`；C/C++ 或辅助构建通用内容（22.2 类层次导航）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0471|22.2.1 dynamic_cast|571|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0471`；C/C++ 或辅助构建通用内容（22.2.1 dynamic_cast）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0472|22.2.2 多重继承|574|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0472`；C/C++ 或辅助构建通用内容（22.2.2 多重继承）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0473|22.2.3 static_cast和dynamic_cast|575|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0473`；C/C++ 或辅助构建通用内容（22.2.3 static_cast和dynamic_cast）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0474|22.2.4 恢复接口|576|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0474`；C/C++ 或辅助构建通用内容（22.2.4 恢复接口）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0475|22.3 双重分发和访客|580|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0475`；C/C++ 或辅助构建通用内容（22.3 双重分发和访客）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0476|22.3.1 双重分发|580|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0476`；C/C++ 或辅助构建通用内容（22.3.1 双重分发）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0477|22.3.2 访客|582|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0477`；C/C++ 或辅助构建通用内容（22.3.2 访客）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0478|22.4 构造和析构|584|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S05.md#review-s05-u0478`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S05-U0479|22.5 类型识别|584|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0479`；C/C++ 或辅助构建通用内容（22.5 类型识别）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0480|22.5.1 扩展类型信息|586|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0480`；C/C++ 或辅助构建通用内容（22.5.1 扩展类型信息）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0481|22.6 RTTI的使用和误用|587|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0481`；C/C++ 或辅助构建通用内容（22.6 RTTI的使用和误用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0482|22.7 建议|588|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0482`；C/C++ 或辅助构建通用内容（22.7 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0483|第23章 模板|589|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0483`；C/C++ 或辅助构建通用内容（第23章 模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0484|23.1 引言和概述|589|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0484`；C/C++ 或辅助构建通用内容（23.1 引言和概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0485|23.2 一个简单的字符串模板|591|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0485`；C/C++ 或辅助构建通用内容（23.2 一个简单的字符串模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0486|23.2.1 定义模板|592|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0486`；C/C++ 或辅助构建通用内容（23.2.1 定义模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0487|23.2.2 模板实例化|594|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0487`；C/C++ 或辅助构建通用内容（23.2.2 模板实例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0488|23.3 类型检查|594|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0488`；C/C++ 或辅助构建通用内容（23.3 类型检查）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0489|23.3.1 类型等价|595|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0489`；C/C++ 或辅助构建通用内容（23.3.1 类型等价）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0490|23.3.2 错误检测|596|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0490`；C/C++ 或辅助构建通用内容（23.3.2 错误检测）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0491|23.4 类模板成员|597|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0491`；C/C++ 或辅助构建通用内容（23.4 类模板成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0492|23.4.1 数据成员|597|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0492`；C/C++ 或辅助构建通用内容（23.4.1 数据成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0493|23.4.2 成员函数|598|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0493`；C/C++ 或辅助构建通用内容（23.4.2 成员函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0494|23.4.3 成员类型别名|598|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0494`；C/C++ 或辅助构建通用内容（23.4.3 成员类型别名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0495|23.4.4 static成员|598|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0495`；C/C++ 或辅助构建通用内容（23.4.4 static成员）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0496|23.4.5 成员类型|599|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0496`；C/C++ 或辅助构建通用内容（23.4.5 成员类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0497|23.4.6 成员模板|600|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0497`；C/C++ 或辅助构建通用内容（23.4.6 成员模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0498|23.4.7 友元|603|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0498`；C/C++ 或辅助构建通用内容（23.4.7 友元）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0499|23.5 函数模板|605|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0499`；C/C++ 或辅助构建通用内容（23.5 函数模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0500|23.5.1 函数模板实参|606|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0500`；C/C++ 或辅助构建通用内容（23.5.1 函数模板实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0501|23.5.2 函数模板实参推断|607|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0501`；C/C++ 或辅助构建通用内容（23.5.2 函数模板实参推断）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0502|23.5.3 函数模板重载|609|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0502`；C/C++ 或辅助构建通用内容（23.5.3 函数模板重载）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0503|23.6 模板别名|613|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0503`；C/C++ 或辅助构建通用内容（23.6 模板别名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0504|23.7 源码组织|614|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0504`；C/C++ 或辅助构建通用内容（23.7 源码组织）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0505|23.7.1 链接|616|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0505`；C/C++ 或辅助构建通用内容（23.7.1 链接）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0506|23.8 建议|617|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0506`；C/C++ 或辅助构建通用内容（23.8 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0507|第24章 泛型程序设计|618|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0507`；C/C++ 或辅助构建通用内容（第24章 泛型程序设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0508|24.1 引言|618|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0508`；C/C++ 或辅助构建通用内容（24.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0509|24.2 算法和提升|619|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0509`；C/C++ 或辅助构建通用内容（24.2 算法和提升）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0510|24.3 概念|622|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0510`；C/C++ 或辅助构建通用内容（24.3 概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0511|24.3.1 发现概念|622|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0511`；C/C++ 或辅助构建通用内容（24.3.1 发现概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0512|24.3.2 概念和约束|625|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0512`；C/C++ 或辅助构建通用内容（24.3.2 概念和约束）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0513|24.4 具体化概念|627|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0513`；C/C++ 或辅助构建通用内容（24.4 具体化概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0514|24.4.1 公理|630|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0514`；C/C++ 或辅助构建通用内容（24.4.1 公理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0515|24.4.2 多实参概念|630|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0515`；C/C++ 或辅助构建通用内容（24.4.2 多实参概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0516|24.4.3 值概念|631|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0516`；C/C++ 或辅助构建通用内容（24.4.3 值概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0517|24.4.4 约束检查|632|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0517`；C/C++ 或辅助构建通用内容（24.4.4 约束检查）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0518|24.4.5 模板定义检查|633|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0518`；C/C++ 或辅助构建通用内容（24.4.5 模板定义检查）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0519|24.5 建议|635|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0519`；C/C++ 或辅助构建通用内容（24.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0520|第25章 特例化|636|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0520`；C/C++ 或辅助构建通用内容（第25章 特例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0521|25.1 引言|636|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0521`；C/C++ 或辅助构建通用内容（25.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0522|25.2 模板参数和实参|637|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0522`；C/C++ 或辅助构建通用内容（25.2 模板参数和实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0523|25.2.1 类型作为实参|637|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0523`；C/C++ 或辅助构建通用内容（25.2.1 类型作为实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0524|25.2.2 值作为实参|638|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0524`；C/C++ 或辅助构建通用内容（25.2.2 值作为实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0525|25.2.3 操作作为实参|639|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0525`；C/C++ 或辅助构建通用内容（25.2.3 操作作为实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0526|25.2.4 模板作为实参|641|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0526`；C/C++ 或辅助构建通用内容（25.2.4 模板作为实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0527|25.2.5 默认模板实参|642|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0527`；C/C++ 或辅助构建通用内容（25.2.5 默认模板实参）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0528|25.3 特例化|644|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0528`；C/C++ 或辅助构建通用内容（25.3 特例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0529|25.3.1 接口特例化|646|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0529`；C/C++ 或辅助构建通用内容（25.3.1 接口特例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0530|25.3.2 主模板|647|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0530`；C/C++ 或辅助构建通用内容（25.3.2 主模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0531|25.3.3 特例化顺序|648|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0531`；C/C++ 或辅助构建通用内容（25.3.3 特例化顺序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0532|25.3.4 函数模板特例化|649|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0532`；C/C++ 或辅助构建通用内容（25.3.4 函数模板特例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0533|25.4 建议|651|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0533`；C/C++ 或辅助构建通用内容（25.4 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0534|第26章 实例化|652|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0534`；C/C++ 或辅助构建通用内容（第26章 实例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0535|26.1 引言|652|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0535`；C/C++ 或辅助构建通用内容（26.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0536|26.2 模板实例化|653|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0536`；C/C++ 或辅助构建通用内容（26.2 模板实例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0537|26.2.1 何时需要实例化|653|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0537`；C/C++ 或辅助构建通用内容（26.2.1 何时需要实例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0538|26.2.2 手工控制实例化|654|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0538`；C/C++ 或辅助构建通用内容（26.2.2 手工控制实例化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0539|26.3 名字绑定|655|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0539`；C/C++ 或辅助构建通用内容（26.3 名字绑定）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0540|26.3.1 依赖性名字|656|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0540`；C/C++ 或辅助构建通用内容（26.3.1 依赖性名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0541|26.3.2 定义点绑定|658|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0541`；C/C++ 或辅助构建通用内容（26.3.2 定义点绑定）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0542|26.3.3 实例化点绑定|659|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0542`；C/C++ 或辅助构建通用内容（26.3.3 实例化点绑定）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0543|26.3.4 多实例化点|661|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0543`；C/C++ 或辅助构建通用内容（26.3.4 多实例化点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0544|26.3.5 模板和名字空间|662|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0544`；C/C++ 或辅助构建通用内容（26.3.5 模板和名字空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0545|26.3.6 过于激进的ADL|662|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0545`；C/C++ 或辅助构建通用内容（26.3.6 过于激进的ADL）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0546|26.3.7 来自基类的名字|664|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0546`；C/C++ 或辅助构建通用内容（26.3.7 来自基类的名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0547|26.4 建议|666|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0547`；C/C++ 或辅助构建通用内容（26.4 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0548|第27章 模板和类层次|668|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0548`；C/C++ 或辅助构建通用内容（第27章 模板和类层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0549|27.1 引言|668|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0549`；C/C++ 或辅助构建通用内容（27.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0550|27.2 参数化和类层次|669|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0550`；C/C++ 或辅助构建通用内容（27.2 参数化和类层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0551|27.2.1 生成类型|670|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0551`；C/C++ 或辅助构建通用内容（27.2.1 生成类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0552|27.2.2 模板类型转换|672|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0552`；C/C++ 或辅助构建通用内容（27.2.2 模板类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0553|27.3 类模板层次|673|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0553`；C/C++ 或辅助构建通用内容（27.3 类模板层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0554|27.3.1 模板作为接口|674|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0554`；C/C++ 或辅助构建通用内容（27.3.1 模板作为接口）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0555|27.4 模板参数作为基类|675|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0555`；C/C++ 或辅助构建通用内容（27.4 模板参数作为基类）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0556|27.4.1 组合数据结构|675|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0556`；C/C++ 或辅助构建通用内容（27.4.1 组合数据结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0557|27.4.2 线性化类层次|678|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0557`；C/C++ 或辅助构建通用内容（27.4.2 线性化类层次）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0558|27.5 建议|683|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0558`；C/C++ 或辅助构建通用内容（27.5 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0559|第28章 元编程|684|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0559`；C/C++ 或辅助构建通用内容（第28章 元编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0560|28.1 引言|684|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0560`；C/C++ 或辅助构建通用内容（28.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0561|28.2 类型函数|686|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0561`；C/C++ 或辅助构建通用内容（28.2 类型函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0562|28.2.1 类型别名|688|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0562`；C/C++ 或辅助构建通用内容（28.2.1 类型别名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0563|28.2.2 类型谓词|689|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0563`；C/C++ 或辅助构建通用内容（28.2.2 类型谓词）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0564|28.2.3 选择函数|691|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0564`；C/C++ 或辅助构建通用内容（28.2.3 选择函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0565|28.2.4 萃取|691|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0565`；C/C++ 或辅助构建通用内容（28.2.4 萃取）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0566|28.3 控制结构|693|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0566`；C/C++ 或辅助构建通用内容（28.3 控制结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0567|28.3.1 选择|693|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0567`；C/C++ 或辅助构建通用内容（28.3.1 选择）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0568|28.3.2 迭代和递归|696|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0568`；C/C++ 或辅助构建通用内容（28.3.2 迭代和递归）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0569|28.3.3 何时使用元编程|697|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0569`；C/C++ 或辅助构建通用内容（28.3.3 何时使用元编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0570|28.4 条件定义：Enable_if|698|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0570`；C/C++ 或辅助构建通用内容（28.4 条件定义：Enable_if）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0571|28.4.1 使用Enable_if|699|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0571`；C/C++ 或辅助构建通用内容（28.4.1 使用Enable_if）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0572|28.4.2 实现Enable_if|701|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0572`；C/C++ 或辅助构建通用内容（28.4.2 实现Enable_if）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0573|28.4.3 Enable_if与概念|701|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0573`；C/C++ 或辅助构建通用内容（28.4.3 Enable_if与概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0574|28.4.4 更多Enable_if例子|702|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0574`；C/C++ 或辅助构建通用内容（28.4.4 更多Enable_if例子）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0575|28.5 一个编译时列表：Tuple|704|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0575`；C/C++ 或辅助构建通用内容（28.5 一个编译时列表：Tuple）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0576|28.5.1 一个简单的输出函数|706|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0576`；C/C++ 或辅助构建通用内容（28.5.1 一个简单的输出函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0577|28.5.2 元素访问|707|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0577`；C/C++ 或辅助构建通用内容（28.5.2 元素访问）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0578|28.5.3 make_tuple|709|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0578`；C/C++ 或辅助构建通用内容（28.5.3 make_tuple）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0579|28.6 可变参数模板|709|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0579`；C/C++ 或辅助构建通用内容（28.6 可变参数模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0580|28.6.1 一个类型安全的printf()|710|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0580`；C/C++ 或辅助构建通用内容（28.6.1 一个类型安全的printf()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0581|28.6.2 技术细节|712|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0581`；C/C++ 或辅助构建通用内容（28.6.2 技术细节）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0582|28.6.3 转发|714|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0582`；C/C++ 或辅助构建通用内容（28.6.3 转发）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0583|28.6.4 标准库tuple|715|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0583`；C/C++ 或辅助构建通用内容（28.6.4 标准库tuple）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0584|28.7 国际标准单位例子|717|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0584`；C/C++ 或辅助构建通用内容（28.7 国际标准单位例子）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0585|28.7.1 Unit|718|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0585`；C/C++ 或辅助构建通用内容（28.7.1 Unit）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0586|28.7.2 Quantity|719|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0586`；C/C++ 或辅助构建通用内容（28.7.2 Quantity）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0587|28.7.3 Unit字面值常量|720|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0587`；C/C++ 或辅助构建通用内容（28.7.3 Unit字面值常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0588|28.7.4 工具函数|721|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0588`；C/C++ 或辅助构建通用内容（28.7.4 工具函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0589|28.8 建议|723|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0589`；C/C++ 或辅助构建通用内容（28.8 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0590|第29章 一个矩阵设计|724|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0590`；C/C++ 或辅助构建通用内容（第29章 一个矩阵设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0591|29.1 引言|724|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0591`；C/C++ 或辅助构建通用内容（29.1 引言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0592|29.1.1 Matrix的基本使用|724|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0592`；C/C++ 或辅助构建通用内容（29.1.1 Matrix的基本使用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0593|29.1.2 对Matrix的要求|726|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0593`；C/C++ 或辅助构建通用内容（29.1.2 对Matrix的要求）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0594|29.2 Matrix模板|727|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0594`；C/C++ 或辅助构建通用内容（29.2 Matrix模板）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0595|29.2.1 构造和赋值|728|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0595`；C/C++ 或辅助构建通用内容（29.2.1 构造和赋值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0596|29.2.2 下标和切片|729|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0596`；C/C++ 或辅助构建通用内容（29.2.2 下标和切片）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0597|29.3 Matrix算术运算|731|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0597`；C/C++ 或辅助构建通用内容（29.3 Matrix算术运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0598|29.3.1 标量运算|732|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0598`；C/C++ 或辅助构建通用内容（29.3.1 标量运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0599|29.3.2 加法|733|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0599`；C/C++ 或辅助构建通用内容（29.3.2 加法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0600|29.3.3 乘法|734|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0600`；C/C++ 或辅助构建通用内容（29.3.3 乘法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0601|29.4 Matrix实现|735|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0601`；C/C++ 或辅助构建通用内容（29.4 Matrix实现）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0602|29.4.1 slice()|736|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0602`；C/C++ 或辅助构建通用内容（29.4.1 slice()）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0603|29.4.2 Matrix切片|736|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0603`；C/C++ 或辅助构建通用内容（29.4.2 Matrix切片）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0604|29.4.3 Matrix_ref|737|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0604`；C/C++ 或辅助构建通用内容（29.4.3 Matrix_ref）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0605|29.4.4 Matrix列表初始化|738|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0605`；C/C++ 或辅助构建通用内容（29.4.4 Matrix列表初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0606|29.4.5 Matrix访问|740|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0606`；C/C++ 或辅助构建通用内容（29.4.5 Matrix访问）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0607|29.4.6 零维Matrix|742|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0607`；C/C++ 或辅助构建通用内容（29.4.6 零维Matrix）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0608|29.5 求解线性方程组|743|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0608`；C/C++ 或辅助构建通用内容（29.5 求解线性方程组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0609|29.5.1 经典高斯消去法|744|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0609`；C/C++ 或辅助构建通用内容（29.5.1 经典高斯消去法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0610|29.5.2 旋转|745|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0610`；C/C++ 或辅助构建通用内容（29.5.2 旋转）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0611|29.5.3 测试|746|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0611`；C/C++ 或辅助构建通用内容（29.5.3 测试）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0612|29.5.4 熔合运算|746|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0612`；C/C++ 或辅助构建通用内容（29.5.4 熔合运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0613|29.6 建议|748|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0613`；C/C++ 或辅助构建通用内容（29.6 建议）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S05-U0614|封底|750|excluded-reviewed / scope-only|—|`sources/reviews/S05.md#review-s05-u0614`；C/C++ 或辅助构建通用内容（封底）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S06 · Effective C++ Effective C++ 改善程序与设计的55个具体做法 第3版 ([美] Scott Meyers  侯捷 译) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s06}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S06-U0001|封面|1|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0001`；C/C++ 或辅助构建通用内容（封面）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0002|书名|2|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0002`；C/C++ 或辅助构建通用内容（书名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0003|版权|3|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0003`；C/C++ 或辅助构建通用内容（版权）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0004|译序|11|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0004`；C/C++ 或辅助构建通用内容（译序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0005|中英简繁术语对照|13|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0005`；C/C++ 或辅助构建通用内容（中英简繁术语对照）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0006|序言|20|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0006`；C/C++ 或辅助构建通用内容（序言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0007|致谢|22|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0007`；C/C++ 或辅助构建通用内容（致谢）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0008|目录|26|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0008`；C/C++ 或辅助构建通用内容（目录）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0009|导读|30|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0009`；C/C++ 或辅助构建通用内容（导读）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0010|1．让自己习惯C＋＋|40|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0010`；C/C++ 或辅助构建通用内容（1．让自己习惯C＋＋）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0011|条款01：视C＋＋为一个语言联邦|40|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0011`；C/C++ 或辅助构建通用内容（条款01：视C＋＋为一个语言联邦）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0012|条款02：尽量以const，enum，inline替换＃define|42|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0012`；C/C++ 或辅助构建通用内容（条款02：尽量以const，enum，inline替换＃define）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0013|条款03：尽可能使用const|46|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0013`；C/C++ 或辅助构建通用内容（条款03：尽可能使用const）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0014|条款04：确定对象被使用前已先被初始化|55|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0014`；C/C++ 或辅助构建通用内容（条款04：确定对象被使用前已先被初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0015|2．构造／析构／赋值运算|63|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0015`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S06-U0016|条款05：了解C＋＋默默编写并调用哪些函数|63|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0016`；C/C++ 或辅助构建通用内容（条款05：了解C＋＋默默编写并调用哪些函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0017|条款06：若不想使用编译器自动生成的函数，就该明确拒绝|66|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0017`；C/C++ 或辅助构建通用内容（条款06：若不想使用编译器自动生成的函数，就该明确拒绝）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0018|条款07：为多态基类声明virtual析构函数|69|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0018`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S06-U0019|条款08：别让异常逃离析构函数|73|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0019`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S06-U0020|条款09：绝不在构造和析构过程中调用virtual函数|77|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0020`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S06-U0021|条款10：令operator＝返回一个reference to*this|81|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0021`；C/C++ 或辅助构建通用内容（条款10：令operator＝返回一个reference to*this）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0022|条款11：在operator＝中处理“自我赋值”|82|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0022`；C/C++ 或辅助构建通用内容（条款11：在operator＝中处理“自我赋值”）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0023|条款12：复制对象时勿忘其每一个成分|86|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0023`；C/C++ 或辅助构建通用内容（条款12：复制对象时勿忘其每一个成分）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0024|3．资源管理|90|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0024`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S06-U0025|条款13：以对象管理资源|90|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0025`；C/C++ 或辅助构建通用内容（条款13：以对象管理资源）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0026|条款14：在资源管理类中小心copying行为|95|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0026`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S06-U0027|条款15：在资源管理类中提供对原始资源的访问|98|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S06.md#review-s06-u0027`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S06-U0028|条款16：成对使用new和delete时要采取相同形式|102|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0028`；C/C++ 或辅助构建通用内容（条款16：成对使用new和delete时要采取相同形式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0029|条款17：以独立语句将newed对象置入智能指针|104|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S06.md#review-s06-u0029`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S06-U0030|4．设计与声明|107|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0030`；C/C++ 或辅助构建通用内容（4．设计与声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0031|条款18：让接口容易被正确使用，不易被误用|107|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0031`；C/C++ 或辅助构建通用内容（条款18：让接口容易被正确使用，不易被误用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0032|条款19：设计class犹如设计type|113|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0032`；C/C++ 或辅助构建通用内容（条款19：设计class犹如设计type）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0033|条款20：宁以pass-by-reference-to-const替换pass-by-value|115|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0033`；C/C++ 或辅助构建通用内容（条款20：宁以pass-by-reference-to-const替换pass-by-value）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0034|条款21：必须返回对象时，别妄想返回其reference|119|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0034`；C/C++ 或辅助构建通用内容（条款21：必须返回对象时，别妄想返回其reference）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0035|条款22：将成员变量声明为private|123|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0035`；C/C++ 或辅助构建通用内容（条款22：将成员变量声明为private）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0036|条款23：宁以non-member、non-friend替换member函数|127|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0036`；C/C++ 或辅助构建通用内容（条款23：宁以non-member、non-friend替换member函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0037|条款24：若所有参数皆需类型转换，请为此采用non-member函数|131|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0037`；C/C++ 或辅助构建通用内容（条款24：若所有参数皆需类型转换，请为此采用non-member函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0038|条款25：考虑写出一个不抛异常的swap函数|135|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0038`；C/C++ 或辅助构建通用内容（条款25：考虑写出一个不抛异常的swap函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0039|5．实现|142|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0039`；C/C++ 或辅助构建通用内容（5．实现）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0040|条款26：尽可能延后变量定义式的出现时间|142|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0040`；C/C++ 或辅助构建通用内容（条款26：尽可能延后变量定义式的出现时间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0041|条款27：尽量少做转型动作|145|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0041`；C/C++ 或辅助构建通用内容（条款27：尽量少做转型动作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0042|条款28：避免返回handles指向对象内部成分|152|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0042`；C/C++ 或辅助构建通用内容（条款28：避免返回handles指向对象内部成分）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0043|条款29：为“异常安全”而努力是值得的|156|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0043`；C/C++ 或辅助构建通用内容（条款29：为“异常安全”而努力是值得的）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0044|条款30：透彻了解inlining的里里外外|163|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0044`；C/C++ 或辅助构建通用内容（条款30：透彻了解inlining的里里外外）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0045|条款31：将文件间的编译依存关系降至最低|169|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0045`；C/C++ 或辅助构建通用内容（条款31：将文件间的编译依存关系降至最低）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0046|6．继承与面向对象设计|178|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0046`；C/C++ 或辅助构建通用内容（6．继承与面向对象设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0047|条款32：确定你的public继承塑模出is-a关系|179|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0047`；C/C++ 或辅助构建通用内容（条款32：确定你的public继承塑模出is-a关系）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0048|条款33：避免遮掩继承而来的名称|185|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0048`；C/C++ 或辅助构建通用内容（条款33：避免遮掩继承而来的名称）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0049|条款34：区分接口继承和实现继承|190|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0049`；C/C++ 或辅助构建通用内容（条款34：区分接口继承和实现继承）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0050|条款35：考虑virtual函数以外的其他选择|198|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0050`；C/C++ 或辅助构建通用内容（条款35：考虑virtual函数以外的其他选择）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0051|条款36：绝不重新定义继承而来的non-virtual函数|207|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0051`；C/C++ 或辅助构建通用内容（条款36：绝不重新定义继承而来的non-virtual函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0052|条款37：绝不重新定义继承而来的缺省参数值|209|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0052`；C/C++ 或辅助构建通用内容（条款37：绝不重新定义继承而来的缺省参数值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0053|条款38：通过复合塑模出has-a或“根据某物实现出”|213|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0053`；C/C++ 或辅助构建通用内容（条款38：通过复合塑模出has-a或“根据某物实现出”）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0054|条款39：明智而审慎地使用private继承|216|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0054`；C/C++ 或辅助构建通用内容（条款39：明智而审慎地使用private继承）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0055|条款40：明智而审慎地使用多重继承|221|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0055`；C/C++ 或辅助构建通用内容（条款40：明智而审慎地使用多重继承）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0056|7．模板与泛型编程|228|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0056`；C/C++ 或辅助构建通用内容（7．模板与泛型编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0057|条款41：了解隐式接口和编译期多态|228|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0057`；C/C++ 或辅助构建通用内容（条款41：了解隐式接口和编译期多态）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0058|条款42：了解typename的双重意义|232|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0058`；C/C++ 或辅助构建通用内容（条款42：了解typename的双重意义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0059|条款43：学习处理模板化基类内的名称|236|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0059`；C/C++ 或辅助构建通用内容（条款43：学习处理模板化基类内的名称）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0060|条款44：将与参数无关的代码抽离templates|241|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0060`；C/C++ 或辅助构建通用内容（条款44：将与参数无关的代码抽离templates）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0061|条款45：运用成员函数模板接受所有兼容类型|247|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0061`；C/C++ 或辅助构建通用内容（条款45：运用成员函数模板接受所有兼容类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0062|条款46：需要类型转换时请为模板定义非成员函数|251|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0062`；C/C++ 或辅助构建通用内容（条款46：需要类型转换时请为模板定义非成员函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0063|条款47：请使用traits classes表现类型信息|255|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0063`；C/C++ 或辅助构建通用内容（条款47：请使用traits classes表现类型信息）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0064|条款48：认识template元编程|262|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0064`；C/C++ 或辅助构建通用内容（条款48：认识template元编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0065|8．定制new和delete|268|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0065`；C/C++ 或辅助构建通用内容（8．定制new和delete）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0066|条款49：了解new-handler的行为|269|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0066`；C/C++ 或辅助构建通用内容（条款49：了解new-handler的行为）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0067|条款50：了解new和delete的合理替换时机|276|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0067`；C/C++ 或辅助构建通用内容（条款50：了解new和delete的合理替换时机）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0068|条款51：编写new和delete时需固守常规|281|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0068`；C/C++ 或辅助构建通用内容（条款51：编写new和delete时需固守常规）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0069|条款52：写了placement new也要写placement delete|285|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0069`；C/C++ 或辅助构建通用内容（条款52：写了placement new也要写placement delete）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0070|9．杂项讨论|291|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0070`；C/C++ 或辅助构建通用内容（9．杂项讨论）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0071|条款53：不要轻忽编译器的警告|291|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0071`；C/C++ 或辅助构建通用内容（条款53：不要轻忽编译器的警告）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0072|条款54：让自己熟悉包括TR1在内的标准程序库|292|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0072`；C/C++ 或辅助构建通用内容（条款54：让自己熟悉包括TR1在内的标准程序库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0073|条款55：让自己熟悉Boost|298|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0073`；C/C++ 或辅助构建通用内容（条款55：让自己熟悉Boost）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0074|A 本书之外|302|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0074`；C/C++ 或辅助构建通用内容（A 本书之外）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0075|B 新旧版条款对照|306|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0075`；C/C++ 或辅助构建通用内容（B 新旧版条款对照）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0076|索引|309|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0076`；C/C++ 或辅助构建通用内容（索引）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S06-U0077|封底|327|excluded-reviewed / scope-only|—|`sources/reviews/S06.md#review-s06-u0077`；C/C++ 或辅助构建通用内容（封底）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S07 · Effective Modern C++ 42 Specific Ways to Improve Your Use of C++11 and C++14 (Scott Meyers) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s07}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S07-U0001|Table of Contents|9|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0001`；C/C++ 或辅助构建通用内容（Table of Contents）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0002|From the Publisher|13|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0002`；C/C++ 或辅助构建通用内容（From the Publisher）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0003|Using Code Examples|13|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0003`；C/C++ 或辅助构建通用内容（Using Code Examples）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0004|Safari® Books Online|13|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0004`；C/C++ 或辅助构建通用内容（Safari® Books Online）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0005|How to Contact Us|14|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0005`；C/C++ 或辅助构建通用内容（How to Contact Us）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0006|Acknowledgments|15|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0006`；C/C++ 或辅助构建通用内容（Acknowledgments）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0007|Introduction|19|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0007`；C/C++ 或辅助构建通用内容（Introduction）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0008|Terminology and Conventions|20|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0008`；C/C++ 或辅助构建通用内容（Terminology and Conventions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0009|Reporting Bugs and Suggesting Improvements|24|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0009`；C/C++ 或辅助构建通用内容（Reporting Bugs and Suggesting Improvements）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0010|Chapter 1. Deducing Types|27|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0010`；C/C++ 或辅助构建通用内容（Chapter 1. Deducing Types）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0011|Item 1: Understand template type deduction.|27|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0011`；C/C++ 或辅助构建通用内容（Item 1: Understand template type deduction.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0012|Case 1: ParamType is a Reference or Pointer, but not a Universal Reference|29|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0012`；C/C++ 或辅助构建通用内容（Case 1: ParamType is a Reference or Pointer, but not a Universal Reference）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0013|Case 2: ParamType is a Universal Reference|31|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0013`；C/C++ 或辅助构建通用内容（Case 2: ParamType is a Universal Reference）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0014|Case 3: ParamType is Neither a Pointer nor a Reference|32|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0014`；C/C++ 或辅助构建通用内容（Case 3: ParamType is Neither a Pointer nor a Reference）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0015|Array Arguments|33|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0015`；C/C++ 或辅助构建通用内容（Array Arguments）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0016|Function Arguments|35|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0016`；C/C++ 或辅助构建通用内容（Function Arguments）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0017|Item 2: Understand auto type deduction.|36|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0017`；C/C++ 或辅助构建通用内容（Item 2: Understand auto type deduction.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0018|Item 3: Understand decltype.|41|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0018`；C/C++ 或辅助构建通用内容（Item 3: Understand decltype.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0019|Item 4: Know how to view deduced types.|48|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0019`；C/C++ 或辅助构建通用内容（Item 4: Know how to view deduced types.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0020|IDE Editors|48|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0020`；C/C++ 或辅助构建通用内容（IDE Editors）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0021|Compiler Diagnostics|49|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0021`；C/C++ 或辅助构建通用内容（Compiler Diagnostics）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0022|Runtime Output|49|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0022`；C/C++ 或辅助构建通用内容（Runtime Output）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0023|Chapter 2. auto|55|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0023`；C/C++ 或辅助构建通用内容（Chapter 2. auto）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0024|Item 5: Prefer auto to explicit type declarations.|55|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0024`；C/C++ 或辅助构建通用内容（Item 5: Prefer auto to explicit type declarations.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0025|Item 6: Use the explicitly typed initializer idiom when auto deduces undesired types.|61|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0025`；C/C++ 或辅助构建通用内容（Item 6: Use the explicitly typed initializer idiom when auto deduces undesired types.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0026|Chapter 3. Moving to Modern C++|67|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0026`；C/C++ 或辅助构建通用内容（Chapter 3. Moving to Modern C++）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0027|Item 7: Distinguish between () and {} when creating objects.|67|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0027`；C/C++ 或辅助构建通用内容（Item 7: Distinguish between () and {} when creating objects.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0028|Item 8: Prefer nullptr to 0 and NULL.|76|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0028`；C/C++ 或辅助构建通用内容（Item 8: Prefer nullptr to 0 and NULL.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0029|Item 9: Prefer alias declarations to typedefs.|81|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0029`；C/C++ 或辅助构建通用内容（Item 9: Prefer alias declarations to typedefs.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0030|Item 10: Prefer scoped enums to unscoped enums.|85|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0030`；C/C++ 或辅助构建通用内容（Item 10: Prefer scoped enums to unscoped enums.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0031|Item 11: Prefer deleted functions to private undefined ones.|92|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0031`；C/C++ 或辅助构建通用内容（Item 11: Prefer deleted functions to private undefined ones.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0032|Item 12: Declare overriding functions override.|97|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0032`；C/C++ 或辅助构建通用内容（Item 12: Declare overriding functions override.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0033|Item 13: Prefer const_iterators to iterators.|104|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0033`；C/C++ 或辅助构建通用内容（Item 13: Prefer const_iterators to iterators.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0034|Item 14: Declare functions noexcept if they won’t emit exceptions.|108|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0034`；C/C++ 或辅助构建通用内容（Item 14: Declare functions noexcept if they won’t emit exceptions.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0035|Item 15: Use constexpr whenever possible.|115|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0035`；C/C++ 或辅助构建通用内容（Item 15: Use constexpr whenever possible.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0036|Item 16: Make const member functions thread safe.|121|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0036`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S07-U0037|Item 17: Understand special member function generation.|127|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0037`；C/C++ 或辅助构建通用内容（Item 17: Understand special member function generation.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0038|Chapter 4. Smart Pointers|135|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S07.md#review-s07-u0038`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S07-U0039|Item 18: Use std::unique_ptr for exclusive-ownership resource management.|136|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0039`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S07-U0040|Item 19: Use std::shared_ptr for shared-ownership resource management.|143|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0040`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S07-U0041|Item 20: Use std::weak_ptr for std::shared_ptr-like pointers that can dangle.|152|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S07.md#review-s07-u0041`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S07-U0042|Item 21: Prefer std::make_unique and std::make_shared to direct use of new.|157|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0042`；C/C++ 或辅助构建通用内容（Item 21: Prefer std::make_unique and std::make_shared to direct use of new.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0043|Item 22: When using the Pimpl Idiom, define special member functions in the implementation file.|165|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0043`；C/C++ 或辅助构建通用内容（Item 22: When using the Pimpl Idiom, define special member functions in the implementation file.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0044|Chapter 5. Rvalue References, Move Semantics, and Perfect Forwarding|175|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0044`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S07-U0045|Item 23: Understand std::move and std::forward.|176|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0045`；C/C++ 或辅助构建通用内容（Item 23: Understand std::move and std::forward.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0046|Item 24: Distinguish universal references from rvalue references.|182|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0046`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S07-U0047|Item 25: Use std::move on rvalue references, std::forward on universal references.|186|read-mapped / body-sampled|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S07.md#review-s07-u0047`；C++ RAII/移动语义与 Rust 所有权借用对比：用于阐释确定性析构与所有权转移机制|
|S07-U0048|Item 26: Avoid overloading on universal references.|195|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0048`；C/C++ 或辅助构建通用内容（Item 26: Avoid overloading on universal references.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0049|Item 27: Familiarize yourself with alternatives to overloading on universal references.|202|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0049`；C/C++ 或辅助构建通用内容（Item 27: Familiarize yourself with alternatives to overloading on universal references.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0050| |202|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0050`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0051| |202|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0051`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0052| |202|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0052`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0053| |203|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0053`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0054| |206|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0054`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0055| |212|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0055`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0056|Item 28: Understand reference collapsing.|215|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0056`；C/C++ 或辅助构建通用内容（Item 28: Understand reference collapsing.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0057|Item 29: Assume that move operations are not present, not cheap, and not used.|221|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0057`；C/C++ 或辅助构建通用内容（Item 29: Assume that move operations are not present, not cheap, and not used.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0058|Item 30: Familiarize yourself with perfect forwarding failure cases.|225|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0058`；C/C++ 或辅助构建通用内容（Item 30: Familiarize yourself with perfect forwarding failure cases.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0059| |226|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0059`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0060| |227|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0060`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0061| |228|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0061`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0062| |229|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0062`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0063| |231|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0063`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0064| |232|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0064`；C/C++ 或辅助构建通用内容（ ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0065|Chapter 6. Lambda Expressions|233|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0065`；C/C++ 或辅助构建通用内容（Chapter 6. Lambda Expressions）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0066|Item 31: Avoid default capture modes.|234|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0066`；C/C++ 或辅助构建通用内容（Item 31: Avoid default capture modes.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0067|Item 32: Use init capture to move objects into closures.|242|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0067`；C/C++ 或辅助构建通用内容（Item 32: Use init capture to move objects into closures.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0068|Item 33: Use decltype on auto&amp;&amp; parameters to std::forward them.|247|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0068`；C/C++ 或辅助构建通用内容（Item 33: Use decltype on auto&amp;&amp; parameters to std::forward them.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0069|Item 34: Prefer lambdas to std::bind.|250|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0069`；C/C++ 或辅助构建通用内容（Item 34: Prefer lambdas to std::bind.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0070|Chapter 7. The Concurrency API|259|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0070`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S07-U0071|Item 35: Prefer task-based programming to thread-based.|259|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0071`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S07-U0072|Item 36: Specify std::launch::async if asynchronicity is essential.|263|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0072`；C/C++ 或辅助构建通用内容（Item 36: Specify std::launch::async if asynchronicity is essential.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0073|Item 37: Make std::threads unjoinable on all paths.|268|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0073`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S07-U0074|Item 38: Be aware of varying thread handle destructor behavior.|276|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0074`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S07-U0075|Item 39: Consider void futures for one-shot event communication.|280|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0075`；C/C++ 或辅助构建通用内容（Item 39: Consider void futures for one-shot event communication.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0076|Item 40: Use std::atomic for concurrency, volatile for special memory.|289|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S07.md#review-s07-u0076`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S07-U0077|Chapter 8. Tweaks|299|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0077`；C/C++ 或辅助构建通用内容（Chapter 8. Tweaks）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0078|Item 41: Consider pass by value for copyable parameters that are cheap to move and always copied.|299|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0078`；C/C++ 或辅助构建通用内容（Item 41: Consider pass by value for copyable parameters that are cheap to move and always copied.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0079|Item 42: Consider emplacement instead of insertion.|310|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0079`；C/C++ 或辅助构建通用内容（Item 42: Consider emplacement instead of insertion.）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0080|Index|321|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0080`；C/C++ 或辅助构建通用内容（Index）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S07-U0081|About the Author|334|excluded-reviewed / scope-only|—|`sources/reviews/S07.md#review-s07-u0081`；C/C++ 或辅助构建通用内容（About the Author）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S08 · Effective Rust.pdf {#coverage-s08}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S08-U0001|Effective Rust 中文翻译|1|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0001`；封面说明译本与35条建议的身份；出版附属材料，不作为Rust底层性能论证。|
|S08-U0002|前言|3|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0002`；面向已学基础的第二本Rust书；前言的安全性宣传不能替代unsafe和依赖项的soundness前提。|
|S08-U0003|类型|6|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0003`；类型章导读强调把无效状态排除在类型之外；导读本身不单独计为机制证据，条款1另行处理。|
|S08-U0004|第 1 条：使用类型系统表达数据结构|7|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1)|`sources/reviews/S08.md#review-s08-u0004`；类型系统可以让状态与携带数据相匹配；PDF11的SchedulerState例子有助于解释任务责任，不证明原子状态机正确。|
|S08-U0005|第 2 条：使用类型系统表达常见行为|14|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S08.md#review-s08-u0005`；函数、闭包、trait约束与trait对象是不同调用边界；PDF21与62补读支持区分静态类型检查、捕获上下文与动态分派。|
|S08-U0006|第 3 条：优先选择 Option 和 Result 转换，而非显式 match 表达式|24|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0006`；Option/Result转换主要是match到组合器的惯用法改写；本书不另设Rust语法及风格教程，错误语义由条款4处理。|
|S08-U0007|第 4 条：优先使用惯用的错误类型|29|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.2](../part3/ch09.md#sec-cpp-rust.3.9.2)|`sources/reviews/S08.md#review-s08-u0007`；错误类型应能展示并可保留source链；业务Result与任务panic/取消必须分层观察，不能以字符串合并全部错误来源。|
|S08-U0008|第 5 条：理解类型转换|37|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S08.md#review-s08-u0008`；From/TryFrom与as、coercion的失败条件不同；与长度、索引和边界验证有关，等待所有权章节真实锚点，不将其排除为纯语法。|
|S08-U0009|第 6 条：拥抱 newtype 模式|43|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.2](../part4/ch16.md#sec-cpp-rust.4.16.2)|`sources/reviews/S08.md#review-s08-u0009`；newtype为相同数值表示增加语义区别；适合资源句柄与单位/长度边界，不能由此推出跨语言ABI相同。|
|S08-U0010|第 7 条：对复杂的类型使用构造器|48|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0010`；构造器条款解决复杂结构体的默认字段与调用可维护性；不把API便利性改写为已测分配或热路径优化。|
|S08-U0011|第 8 条：熟悉引用和指针类型|55|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S08.md#review-s08-u0011`；引用携带有效性约束，切片与trait对象有额外元数据；PDF59、62补读用于帧字段与类型擦除，不承诺稳定vtable布局。|
|S08-U0012|第 9 条：考虑使用迭代器转换代替显式循环|68|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S08.md#review-s08-u0012`；迭代器把遍历与转换组合起来；是否消去边界检查或向量化必须看当前生成产物，原书开篇不提供性能保证。|
|S08-U0013|Traits|80|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0013`；Traits章导读只是组织后续条款，不重复计为泛型机制已核读；条款10至13分别登记。|
|S08-U0014|第 10 条：熟悉标准库的 traits|81|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S08.md#review-s08-u0014`；标准trait描述复制、克隆、相等及默认构造行为；PDF82补读确认Clone显式调用及唯一资源不能随意克隆，复制成本仍需实测。|
|S08-U0015|第 11 条：为 RAII 模式实现 Drop trait|93|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.8](../part2/ch08.md#sec-cpp-rust.2.8.8)|`sources/reviews/S08.md#review-s08-u0015`；RAII把资源寿命与值寿命相连；PDF94的描述符、MutexGuard例子支持取消与退出时的资源责任，不意味着abort返回就完成drop。|
|S08-U0016|第 12 条：理解泛型和 trait 对象之间的权衡|97|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S08.md#review-s08-u0016`；单态化与trait对象在代码大小、编译期和运行时间接调用上有权衡；PDF99、105补读支持异构任务擦除，不能把Rust内部对象当作插件稳定ABI。|
|S08-U0017|第 13 条：使用默认实现来减少必需实现的 trait 方法|106|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S08.md#review-s08-u0017`；默认trait方法缓解实现者与调用者接口的冲突；覆盖方法与静态分派/内联的关系有性能意义，保留等待泛型章映射。|
|S08-U0018|概念|108|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0018`；概念章导读介绍借用、unsafe、并发、panic与优化的编排，不是新增独立技术证据。|
|S08-U0019|第 14 条：理解生命周期|109|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S08.md#review-s08-u0019`；生命周期限制借用可用时间；PDF113补读RAII不消除悬垂借用，开篇堆栈两端增长的示意不得当作所有平台内存布局定理。|
|S08-U0020|第 15 条：理解借用检查器|126|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S08.md#review-s08-u0020`；共享借用与独占借用限制访问，NLL可使借用在末次使用后结束；PDF128、141补读自引用随移动失效的根源。|
|S08-U0021|第 16 条：避免写 unsafe 代码|144|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.5](../part2/ch08.md#sec-cpp-rust.2.8.5)|`sources/reviews/S08.md#review-s08-u0021`；优先复用经过封装的unsafe实现；unsafe只转移有效性证明责任，不让无效指针访问合法，也不证明自写RawWaker正确。|
|S08-U0022|第 17 条：对共享状态的并行性保持警惕|146|read-mapped / body-read|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S08.md#review-s08-u0022`；安全共享状态仍可能死锁或破坏跨对象不变量；PDF155、156、159补读Send/Sync、锁顺序和统一保护域。|
|S08-U0023|第 18 条：不要 panic|161|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.2](../part3/ch09.md#sec-cpp-rust.3.9.2)|`sources/reviews/S08.md#review-s08-u0023`；panic针对不可恢复错误，不能把catch_unwind当业务Result的通用替代；本书任务层分别观察panic、取消与业务失败。|
|S08-U0024|第 19 条：避免反射|164|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.4](../part2/ch05.md#sec-cpp-rust.2.5.4)|`sources/reviews/S08.md#review-s08-u0024`；Any与完整反射不同；PDF169关于trait上转型的未来版本预测已过时，保留机制主题但不能照搬预计发布版本。|
|S08-U0025|第 20 条：避免过度优化的诱惑|170|read-mapped / body-read|[part3/ch10.md#sec-cpp-rust.3.10.6](../part3/ch10.md#sec-cpp-rust.3.10.6)|`sources/reviews/S08.md#review-s08-u0025`；零拷贝借用会约束缓冲复用与结果保存；PDF173、174补读拥有数据的TLV简化寿命，是否值得复制应由工作负载决定。|
|S08-U0026|依赖|176|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0026`；依赖章导读只交代生态复用的风险，具体版本和特性机制由条款21、24至26承担。|
|S08-U0027|第 21 条：理解语义化版本|177|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.1](../part4/ch14.md#sec-cpp-rust.4.14.1)|`sources/reviews/S08.md#review-s08-u0027`；兼容版本范围不同于精确固定；性能复现必须同时保存锁文件与工具链，不能只写宽泛SemVer要求。|
|S08-U0028|第 22 条：最小化可见性|182|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S08.md#review-s08-u0028`；最小化可见性帮助把资源不变量放在安全封装内部；并非私有字段本身就能证明FFI调用者遵约。|
|S08-U0029|第 23 条：避免通配符导入|187|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0029`；通配符导入与新增trait的方法名冲突属于命名维护问题，不在本书低层性能机制主线中另行展开。|
|S08-U0030|第 24 条：重新导出在 API 中所用的依赖项类型|189|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S08.md#review-s08-u0030`；依赖的不同版本可使公共API中的同名类型不兼容；这影响构建图与接口，不能因非计时主题而排除。|
|S08-U0031|第 25 条：管理依赖项关系图|192|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S08.md#review-s08-u0031`；crate依赖构成图，允许多版本会影响二进制及编译；PDF194补读cargo-deny与依赖图检查，未运行这些外部工具。|
|S08-U0032|第 26 条：警惕 feature 蔓延|197|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S08.md#review-s08-u0032`；feature基于条件编译且会联合；PDF200补读公共字段/trait方法受feature门控的兼容性风险，特性组合必须进入实验环境。|
|S08-U0033|工具|202|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0033`；工具章导读不独立证明工具效果；文档、Clippy、测试和CI条款分开登记，避免导读重复充数。|
|S08-U0034|第 27 条：为公共接口撰写文档|203|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S08.md#review-s08-u0034`；公开API文档应声明使用方式并提供可测试示例；FFI的指针寿命、释放端与panic边界需要书面契约。|
|S08-U0035|第 28 条：在合适的时候使用宏|208|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S08.md#review-s08-u0035`；宏生成代码而非普通运行时调用；宏扩展与后续IR阶段不同，编译期代价不能与CTFE或零成本划等号。|
|S08-U0036|第 29 条：遵循 Clippy 的建议|224|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.3](../part4/ch14.md#sec-cpp-rust.4.14.3)|`sources/reviews/S08.md#review-s08-u0036`；Clippy提供正确性、风格及性能建议并允许误报例外；检查通过不等价于benchmark回归消失。|
|S08-U0037|第 30 条：不仅仅是单元测试|227|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S08.md#review-s08-u0037`；单元、集成、文档、示例和benchmark各有运行入口；PDF229补读示例并非默认全执行，不把cargo test通过当所有实验已跑。|
|S08-U0038|第 31 条：使用生态系统工具|234|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.3](../part4/ch14.md#sec-cpp-rust.4.14.3)|`sources/reviews/S08.md#review-s08-u0038`；cargo/rustup/rustfmt等分担构建、工具链、格式和诊断；性能归档需要记录真实使用的工具而非仅列安装清单。|
|S08-U0039|第 32 条：搭建持续集成（CI）系统|236|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S08.md#review-s08-u0039`；CI应干净、确定、明确失败；PDF237补读共享CI的性能噪声，工具链锁定与专用计时环境不能互相替代。|
|S08-U0040|超越标准 Rust|240|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0040`；超越标准Rust的导读只列跨编译、FFI与无std配置；实际机制由条款33至35承担。|
|S08-U0041|第 33 条：考虑使库代码与 no_std 兼容|241|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.6](../part1/ch02.md#sec-cpp-rust.1.2.6)|`sources/reviews/S08.md#review-s08-u0041`；core/alloc/std分层与可错分配有关；PDF243补读无std依赖和交叉检查，桌面书不扩写裸机引导，但分配失败主题不能整条排除。|
|S08-U0042|第 34 条：控制跨越 FFI 边界的内容|246|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S08.md#review-s08-u0042`；FFI抹去Rust借用契约，需要repr、字符串、寿命和成对释放的显式规则；PDF250、251、254、255补读，未执行其中悬垂/空指针反例。|
|S08-U0043|第 35 条：优先使用 bindgen 而不是手动 FFI 映射|258|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.4](../part4/ch16.md#sec-cpp-rust.4.16.4)|`sources/reviews/S08.md#review-s08-u0043`；bindgen同步声明而不自动证明所有权；PDF259补读sys层和安全包装层的分离，生成声明需纳入CI并保留目标环境。|
|S08-U0044|后记|261|excluded-reviewed / scope-only|—|`sources/reviews/S08.md#review-s08-u0044`；后记推荐异步、裸机与社区进一步阅读；书目推荐不等于本轮读过被推荐资料。|

### S09 · Guide to Rustc Development.pdf {#coverage-s09}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S09-U0001|关于本指南|1|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0001`；指南分六部分介绍rustc参与方式和内部机制；说明性导读不等于六部分正文已通读。|
|S09-U0002|第1部分：构建，调试和向rustc贡献代码|1|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0002`；第一部分导读同时包含技术工作流与团队流程；不把整部分一概映射为性能材料。|
|S09-U0003|About the compiler team|1|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0003`；编译器团队的聊天渠道、成员及评审权限属于项目治理，不进入Rust性能书的技术论证。|
|S09-U0004|如何构建并运行编译器|4|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0004`；x.py与config.toml建立编译器开发构建；旧目录和配置仅作历史机制背景，不能当作当前工具链已复现命令。|
|S09-U0005|推荐的工作流程|9|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0005`；check与build分层减少开发迭代成本；keep-stage复用可能引入ABI不匹配，不把旧指南示例秒数挪为本机结果。|
|S09-U0006|编译器自举|10|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0006`；自举区分stage编译器与由其产生的制品；PDF14已在opening中核读std配对和ABI边界，不表示本轮实际构建rustc。|
|S09-U0007|Build distribution artifacts|15|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0007`；x.py dist用于编译器分发打包；本书锁定既有工具链，不展开rustc发行工程操作。|
|S09-U0008|Install distribution artifacts|15|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0008`；安装编译器分发制品与本地工具链链接属于rustc贡献者环境配置，不作为运行时性能证据。|
|S09-U0009|Documenting rustc|16|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0009`；x.py doc/rustdoc生成编译器文档的操作说明，不涉及本书拟分析的数据流或机器码机制。|
|S09-U0010|ctags|17|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0010`；ctags是旧RLS无法索引自举工程时的导航方案；IDE配置不是本书的底层性能主线。|
|S09-U0011|The compiler testing framework|17|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0011`；compiletest区分ui、codegen、assembly、mir-opt与incremental；opening已读PDF18，测试类型与证据类型必须对应。|
|S09-U0012|Running tests|22|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0012`；全套stage2测试与子集测试的范围不同，成功缓存亦影响重跑；不能把执行了子集描述成全部测试通过。|
|S09-U0013|Adding new tests|25|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0013`；修复编译器bug应添加先失败后通过的回归测试；注释指令与期望结果是测试协议而非业务实现。|
|S09-U0014|compiletest|31|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S09.md#review-s09-u0014`；compiletest能检查编译成功、运行失败及编译失败；负向测试和正常单元测试必须分开说明。|
|S09-U0015|Walkthrough: a typical contribution|36|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0015`；新增特性的RFC、实现与稳定流程演练，属于参与Rust项目的治理教程，不扩写成本书章节。|
|S09-U0016|Rustc Bug Fix Procedure|40|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0016`；可能破坏现存代码的soundness修复流程以RFC1589为背景；本书不承担编译器发布迁移制度说明。|
|S09-U0017|Motivation|41|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0017`；Motivation解释为何要提前告警而非突然拒绝旧程序；此处是兼容迁移政策，不是借用检查算法。|
|S09-U0018|Detailed design|41|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0018`；Detailed design围绕crater、跟踪issue、兼容lint与稳定安排；不把流程步骤算作性能实验的技术覆盖。|
|S09-U0019|Implement New Feature|48|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0019`；新语言特性的FCP、追踪与稳定门控是社区工作流程；本书仅固定工具链版本，不教授提交新特性。|
|S09-U0020|Stability attributes|51|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.1](../part1/ch04.md#sec-cpp-rust.1.4.1)|`sources/reviews/S09.md#review-s09-u0020`；稳定属性控制跨crate使用未稳定API；内部接口和const稳定性需版本限定，不能将nightly实现当稳定语言保证。|
|S09-U0021|Request for stabilization|54|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0021`；稳定化报告、文档PR与FCP程序属于上游治理；与本书CI的性能发布门禁不是同一审核流程。|
|S09-U0022|Debugging the compiler|57|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.8](../part1/ch04.md#sec-cpp-rust.1.4.8)|`sources/reviews/S09.md#review-s09-u0022`；-Z标志、回溯和日志帮助核对编译器阶段；它们是版本内调试接口，未在本轮实际执行。|
|S09-U0023|Profiling the compiler|63|read-mapped / body-read|[part4/ch13.md#sec-cpp-rust.4.13.1](../part4/ch13.md#sec-cpp-rust.4.13.1)|`sources/reviews/S09.md#review-s09-u0023`；rustc-perf、self-profile/measureme与函数级profile回答不同层级问题；开篇即区分编译器回归和内部阶段归因。|
|S09-U0024|Profiling with perf|64|read-mapped / body-read|[part4/ch13.md#sec-cpp-rust.4.13.2](../part4/ch13.md#sec-cpp-rust.4.13.2)|`sources/reviews/S09.md#review-s09-u0024`；Linux perf说明需要含行号调试信息的编译器；材料核读不等于本机macOS执行了perf或采集了PMU。|
|S09-U0025|Formatting and the tidy script|70|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0025`；tidy的版权、空格和行长约定属于rustc仓库规范；不将旧风格指南写成本书性能机制。|
|S09-U0026|Coding for correctness|71|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0026`；穷尽match与遗漏分支是一般维护建议；本书任务状态机另有具体不变量，不复制上游编码守则。|
|S09-U0027|Using crates from crates.io|72|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0027`；rustc可用外部crate的许可审核规则，属于编译器仓库依赖准入，不是Cargo解析或运行时优化机制。|
|S09-U0028|How to structure your PR|72|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0028`；如何拆分PR提交方便评审属于协作流程；不扩写为性能工程章节。|
|S09-U0029|Naming conventions|72|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0029`；cx/tcx/krate等命名惯例供导航查阅；名称约定不单独构成类型布局或编译算法证据。|
|S09-U0030|crates.io Dependencies|73|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0030`；rustc依赖白名单及许可质量政策属于上游项目管理，不冒充本书已执行的供应链检查。|
|S09-U0031|Emitting Errors and other Diagnostics|73|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0031`；Span连接HIR/MIR节点与源位置；诊断基础设施可帮助解释IR证据与错误位置，未审计全部诊断实现。|
|S09-U0032|Lints|83|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0032`；LintStore注册和lint pass合并主要面向添加编译器lint；本书不开发lint插件，不将工具使用扩大为注册流程教程。|
|S09-U0033|Diagnostic Codes|86|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0033`；分配E编号及撰写错误解释是编译器诊断维护流程，超出Rust底层性能主线。|
|S09-U0034|ICE-breakers|87|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0034`；ICE-breaker小组的加入、标签和任务领取方式属于志愿贡献治理，不作为技术机制覆盖。|
|S09-U0035|Cleanup Crew|89|read-mapped / body-read|[part4/ch13.md#sec-cpp-rust.4.13.8](../part4/ch13.md#sec-cpp-rust.4.13.8)|`sources/reviews/S09.md#review-s09-u0035`；最小复现、重复bug关联与二分回归能提高证据可诊断性；仅采用问题缩减方法，不宣称实际执行了cargo-bisect-rustc。|
|S09-U0036|LLVM ICE-breakers|91|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.8](../part2/ch06.md#sec-cpp-rust.2.6.8)|`sources/reviews/S09.md#review-s09-u0036`；需要区分前端生成无效IR和LLVM误优化；这对代码生成归因重要，不等同于本轮定位了LLVM缺陷。|
|S09-U0037|rust-lang/rust Licenses|91|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0037`；编译器与标准库许可证声明是附属法律信息，保留定位但不映射成性能章节。|
|S09-U0038|Part 2: 高层编译器架构|92|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0038`；高层架构导读列查询、增量与interning；具体机制以相应正文节单独登记。|
|S09-U0039|Overview of the Compiler|92|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0039`；Overview of the Compiler实际只保留上游PR/本地构建说明的短引用；无可独立核读的架构正文，不能用它冒充全编译链证据。|
|S09-U0040|编译器源代码的高层次概观|92|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0040`；driver、中间公共结构和各阶段crate协同；PDF92–93抽读指出crate划分会变化，旧src/lib路径须固定版本。|
|S09-U0041|查询: 需求驱动的编译|94|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0041`；需求驱动查询把键映射到类型等结果并记忆化；PDF95补读provider与CGU依赖，只是指南历史模型，不保证当前完整流程。|
|S09-U0042|查询求值模型的详细介绍|99|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0042`；查询具有名称、键、结果及provider，要求不可变输入与确定结果；缓存正确性依赖这些条件而非仅有哈希表。|
|S09-U0043|Incremental compilation|102|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0043`；red-green算法复用先前query DAG和结果；PDF104补读按原读取顺序检查依赖，不能把无改动复用当任意缓存永远有效。|
|S09-U0044|Footnotes|105|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0044`；Footnotes是red-green命名的个人注记，属于附属说明，没有独立机制正文。|
|S09-U0045|Incremental Compilation In Detail|105|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0045`；增量依赖纯查询和无环依赖；PDF108、110补读重算、指纹及跨会话稳定DefPath，缓存不能直接保存易变化的会话ID。|
|S09-U0046|Incremental Compilation and the Compiler Backend|113|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0046`；LLVM后端不全由查询内部实现，CGU的dep-node以手工方式接入复用；复用边界与链接产物必须分层。|
|S09-U0047|Shortcomings of the Current System|113|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0047`；磁盘缓存整体改写及Span导致过多依赖会削弱增量收益；原书百分比不是本机测量，不抄为当前量化结论。|
|S09-U0048|Debugging and Testing Dependencies|114|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0048`；依赖图测试使用if_this_changed/then_this_would_need等内部标记；核读的是旧测试协议，未运行这些rustc内部测试。|
|S09-U0049|Profiling Queries|116|read-mapped / body-read|[part4/ch13.md#sec-cpp-rust.4.13.3](../part4/ch13.md#sec-cpp-rust.4.13.3)|`sources/reviews/S09.md#review-s09-u0049`；旧查询profiling有独立构建和输出解释流程；版本化工具与统计口径须保存，不把旧configure命令直接推荐给当前rustc。|
|S09-U0050|Background|122|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0050`；DefId作为查询键区分输入定义，provider计算或缓存返回结果；与跨会话稳定身份不是同一层次。|
|S09-U0051|How Salsa works|124|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.7](../part1/ch04.md#sec-cpp-rust.1.4.7)|`sources/reviews/S09.md#review-s09-u0051`；Salsa是增量重算库，原书明言不直接用于rustc；不能把概念类比写成当前rustc实现依赖。|
|S09-U0052|Memory Management in Rustc|129|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.6](../part1/ch02.md#sec-cpp-rust.1.2.6)|`sources/reviews/S09.md#review-s09-u0052`；arena和interning减少分配并让驻留类型可按指针判等；PDF129补读，arena寿命与reset安全不由该概述自动证明。|
|S09-U0053|Part 3: 源代码的不同表示|130|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0053`；源代码表示部分的导读只交代从原始文本到中间表示，不重复计为AST/HIR/MIR正文。|
|S09-U0054|The Rustc Driver and Interface|131|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0054`；rustc_driver编排、rustc_interface暴露不稳定阶段接口；作为库使用rustc必须固定编译器版本。|
|S09-U0055|The walking tour of rustdoc|131|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0055`；rustdoc的clean和渲染流程是文档实现专题；本书不实现文档生成器，不将其当运行时性能证据。|
|S09-U0056|Example: Type checking through rustc_interface|136|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0056`；rustc_interface示例借助TyCtxt取表达式类型；需rustc-dev与特定内部API，本轮未编译该示例。|
|S09-U0057|符号与AST|137|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0057`；源码转AST还涉及宏展开、名称解析、cfg和验证；这一概览不能压成简单的单一语法分析pass。|
|S09-U0058|词法分析与语法分析|138|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0058`；lexer产生token，parser建立有Span的AST；原书自带重构过时警告，使用的是固定快照的角色划分。|
|S09-U0059|Macro expansion|144|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0059`；宏内容先保留后扩展，宏parser可调用普通parser；应按阶段说明，不把宏当运行时函数。|
|S09-U0060|Discussion about hygiene|148|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0060`；15页卫生性聊天记录自述尚未整理成正式章；本书不做宏实现专题，仅保存章节存在与范围裁决，不声称全文读过该讨论。|
|S09-U0061|Name resolution|161|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0061`；名称解析分宏阶段导入和后续名称绑定，名称空间允许同名；与语法解析和类型检查不可混为一步。|
|S09-U0062|AST Validation|164|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0062`；AST Validation只有一句作用介绍和原书占位标记，缺少验证算法正文；相关主题保留未解决，不能由占位节支持当前实现结论。|
|S09-U0063|Feature Gate Checking|164|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0063`；Feature Gate Checking原书仅占位，没有可供抽读的机制正文；不能标read-mapped，也不以无关为由排除。|
|S09-U0064|HIR|164|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0064`；HIR是宏展开和名称解析后的编译器友好表示，for等语法被降级；dump文本是版本内观察不是稳定接口。|
|S09-U0065|Lowering|166|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S09.md#review-s09-u0065`；AST到HIR的lowering显式消除括号及多种语法糖，需维护HirId所有者关系；不据此推断机器码已经生成。|
|S09-U0066|HIR Debugging|167|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.8](../part1/ch04.md#sec-cpp-rust.1.4.8)|`sources/reviews/S09.md#review-s09-u0066`；HIR Debugging给出unpretty/expanded定位方式但正文很短；命令未在本轮执行，内部输出可变。|
|S09-U0067|MIR （中层IR）|167|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0067`；MIR是显式类型、无嵌套表达式的控制流图；PDF168补读基本块、语句、terminator和place，支持读真实Future MIR而非把MIR当稳定ABI。|
|S09-U0068|HAIR 和 MIR 的构建|171|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0068`；旧指南称HIR到MIR间表示为HAIR，调整变为显式操作；PDF172补读，不擅自把旧HAIR章节当当前THIR源码审计。|
|S09-U0069|MIR 访问者|175|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0069`；Visitor和MutVisitor分别读/改MIR，super方法递归遍历；遍历次序和CFG遍历并非同一抽象。|
|S09-U0070|MIR passes|176|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0070`；构建与多组pass逐步形成optimized_mir；PDF176补读，阶段名是旧快照，真实异步帧分析必须记录当前产物。|
|S09-U0071|Closure Expansion in rustc|177|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S09.md#review-s09-u0071`；闭包降级为带捕获字段的结构，捕获方式和Fn族由使用推断；PDF179补读upvar，不把普通闭包直接说成Future状态机。|
|S09-U0072|Part 4: 分析|181|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0072`；分析部分导读说明类型检查偏HIR、借用检查偏MIR，非一个连续巨型pass；具体章节另行裁决。|
|S09-U0073|ty 模块：类型的表示|181|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0073`；hir::Ty记录表层类型写法，ty::Ty记录类型语义，TyCtxt贯穿查询；不将内部interned表示当用户值布局。|
|S09-U0074|范型和替换|187|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0074`；泛型替换以GenericArg集合携带类型/寿命/常量；原文关于List指针仅32位的译述不能作为跨平台保证，需当前源码校正。|
|S09-U0075|TypeFoldable and TypeFolder|189|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0075`；TypeFoldable递归暴露嵌入类型，TypeFolder定义替换操作；这是编译器内部遍历，不是运行时反射。|
|S09-U0076|Generic arguments|191|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0076`；GenericArg区分类型、region和const实参，有序Subst完成具体替换；内部类型名随版本变化。|
|S09-U0077|Type inference|192|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0077`；类型推断扩展HM以处理子类型、region和高阶类型；不能据此给任意Rust推断过程作完整算法证明。|
|S09-U0078|Trait resolution (old-style)|197|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0078`；旧trait resolution给trait引用寻找impl并产生义务；原书与new-style设计并列，不等于当前编译器求解器版本。|
|S09-U0079|Higher-ranked trait bounds|203|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0079`；高阶trait约束使用placeholder检查泄露；只抽读匹配动机与例子开头，没有穷尽实现证明。|
|S09-U0080|Caching and subtle considerations therewith|205|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0080`；trait selection缓存需在未知推断变量下重放类型约束效果；缓存结果不只是记录一个布尔值。|
|S09-U0081|Specialization|206|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0081`；specialization在一致性检查中构造包含关系图；它是未稳定/历史实现材料，不将其当稳定优化保证。|
|S09-U0082|Trait solving (new-style)|207|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0082`；new-style trait solver原书自称进行中的设计文档，借Chalk逻辑规则描述义务；与当前next solver不直接画等号。|
|S09-U0083|Lowering to logic|208|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0083`；把trait、impl转为逻辑规则利于理解求解；需要超出普通Horn子句的表达能力，不能仅写成Prolog等同实现。|
|S09-U0084|Goals and clauses|212|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0084`；goal是待证目标、clause是已有规则，含HH扩展；性能书只用来解释编译器义务边界，不复制完整逻辑教程。|
|S09-U0085|Equality and associated types|217|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0085`；关联类型projection、Normalize与ProjectionEq分工；类型求解和最终单态化代码生成不同阶段。|
|S09-U0086|Implied Bounds|220|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0086`；implied bounds减少重复where条件，并涉及well-formed检查；具体规则是历史设计，不能当所有版本语言已实现承诺。|
|S09-U0087|Region constraints|229|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0087`；Region constraints章节明确尚未写成并称Chalk不具有此概念；相关主题留未解决，不能以章节名当正文证据。|
|S09-U0088|The lowering module in rustc|230|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0088`；program_clauses_for从DefId产生规则；原书记录Chalk单测已移除，不能声称本轮验证了该集成。|
|S09-U0089|Lowering rules|231|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0089`；完整Rust trait到逻辑子句的形式降级规则参考，超出本书解释单态化与编译流水线所需的算法深度；仅抽读开篇范围与记号，不宣称全规则核读。|
|S09-U0090|Well-formedness checking|238|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0090`；WF检查要从声明的where假设证明类型/trait/impl良构，关联义务与implied bounds相连；不算运行期检查。|
|S09-U0091|Type definitions|239|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0091`；Type definitions详列trait求解设计中的全称量化WF目标；不扩写完整证明系统，已抽读规则意图而未证明所有示例。|
|S09-U0092|Trait definitions|240|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0092`；Trait definitions是WF逻辑规则中关联类型约束的形式展开；本书不承担Chalk规格教程，保留body-sampled边界。|
|S09-U0093|Impls|242|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0093`；Impls详列关联类型where条件替换和WF公式；本书覆盖泛型/codegen代价，不展开求解器形式证明，非因Rust主题无关而删除。|
|S09-U0094|Canonical queries|249|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0094`；canonical query把trait实现与关联类型归一化问题隔离为可缓存输入/输出；抽读高层接口，不证明求解器完备性。|
|S09-U0095|Canonicalization|253|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0095`；canonicalization把未绑定推断变量换为可重用占位；它解决上下文依赖，不只是复制类型结构。|
|S09-U0096|The On-Demand SLG solver|257|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.6](../part1/ch04.md#sec-cpp-rust.1.4.6)|`sources/reviews/S09.md#review-s09-u0096`；SLG求解器按需返回唯一/多解与替换，目标包括按需和可缓存；作为旧方案背景，不冒称当前内部精确实现。|
|S09-U0097|An Overview of Chalk|262|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0097`；Chalk把Rust trait转为可执行逻辑规格，原书明确重开发中；没有运行Chalk或核验所有crate。|
|S09-U0098|Bibliography|267|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0098`；逻辑编程背景书目是推荐列表；阅读此页不等于阅读Miller、Nadathur等被引文献。|
|S09-U0099|Type checking|267|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0099`；type collection把HIR中的类型写法转成语义Ty及where信息；与函数体类型检查和最终代码生成不同。|
|S09-U0100|Method lookup|268|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S09.md#review-s09-u0100`；方法查找把receiver调用转成带调整的UFCS形式，涉及autoderef/autoref/unsizing；不能据语法表面断言动态分派。|
|S09-U0101|Variance of type and lifetime parameters|270|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0101`；型变从类型定义及依赖推断而非从使用场所推断；涉及安全借用接口，但本轮只抽读算法动机。|
|S09-U0102|Opaque types (type alias impl Trait)|276|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S09.md#review-s09-u0102`；opaque type暴露trait界面而隐藏具体类型，定义使用点推断底层类型；历史TAIT不等于所有稳定impl Trait位置。|
|S09-U0103|Pattern and Exhaustiveness Checking|277|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0103`；模式穷尽性章节只有概述和原书未写完标记；不得当作完整模式检查算法已读。|
|S09-U0104|MIR borrow check|277|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S09.md#review-s09-u0104`；MIR borrowck跟踪初始化、移动与借用访问；PDF278补读数据流和region推断顺序，支持跨await存活分析的前置概念。|
|S09-U0105|Tracking moves and initialization|278|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0105`；初始化与move在borrowck中是同一已初始化place集合的变化；PDF279补读移动后不再初始化，不能只按变量是否声明判断。|
|S09-U0106|Move paths|279|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0106`；局部字段也能独立移动/初始化，因此需要move path粒度；PDF279已抽读，完整构建算法未通读。|
|S09-U0107|The MIR type-check|281|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0107`；MIR type-check遍历并收集region约束，原书正文仅短说明；不能扩写成所有具体检查已核读。|
|S09-U0108|Region inference (NLL)|281|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0108`；NLL先收集签名universal regions，再为函数体创建推断变量；PDF282补读，旧lexical过渡叙述需版本限定。|
|S09-U0109|Constraint propagation|286|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0109`；liveness、outlives与member约束共同决定region；PDF287补读稀疏位集与CFG点，不把生命周期理解成墙钟时间。|
|S09-U0110|Universal regions|289|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0110`；universal region代表命名生命周期参数和static，必须对所有允许寿命满足约束；开篇反例尚非完整推导。|
|S09-U0111|Member constraints|292|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0111`；impl Trait隐藏类型的捕获限制产生member选择约束；不是用户显式能写出的普通where规则。|
|S09-U0112|Placeholders and universes|295|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0112`；placeholder及universe用于不能具体知道的region，防止把需任意寿命的函数误用为static；只抽读动机反例。|
|S09-U0113|Propagating closure constraints|303|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S09.md#review-s09-u0113`；闭包体中暂不可证明的寿命约束交给创建闭包处再验证；检查延迟不等于放弃检查。|
|S09-U0114|Reporting region errors|303|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.8](../part1/ch04.md#sec-cpp-rust.1.4.8)|`sources/reviews/S09.md#review-s09-u0114`；Reporting region errors只有原书占位文字，无错误构造机制正文；保留相关未解决而非排除凑零缺口。|
|S09-U0115|Two-phase borrows|303|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S09.md#review-s09-u0115`；二阶段借用区分reservation/activation；PDF304补读只针对部分隐式可变借用，不能推广为显式所有&amp;mut可重叠。|
|S09-U0116|Parameter Environment|305|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0116`；ParamEnv携带泛型/关联项的约束，但不一定足以求布局；不能把有trait约束理解成编译时已知所有尺寸。|
|S09-U0117|From MIR to Binaries|306|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0117`；From MIR to Binaries是后端导读，明确此前尚未生成机器码；独立机制留给后续节，避免导读重复计数。|
|S09-U0118|MIR （中层IR）|307|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0118`；PDF307–311重复前面的MIR介绍，物理位置独立登记但与PDF167–171不是两个独立理论来源。|
|S09-U0119|MIR optimizations|311|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.2](../part2/ch06.md#sec-cpp-rust.2.6.2)|`sources/reviews/S09.md#review-s09-u0119`；MIR在单态化前优化可降低每个实例的后续工作；PDF312补读borrowck后pass与optimized_mir，未测其编译时间收益。|
|S09-U0120|MIR Debugging|312|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.2](../part2/ch08.md#sec-cpp-rust.2.8.2)|`sources/reviews/S09.md#review-s09-u0120`；dump-mir可按函数/pass过滤并保存前后文本与CFG；只是阅读调试协议，没有在本轮新运行rustc命令。|
|S09-U0121|Constant Evaluation|314|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S09.md#review-s09-u0121`；常量求值处理static、数组长、判别值等；发生在所需MIR可用后，不能把const fn普通运行时调用都说成CTFE。|
|S09-U0122|Miri|314|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S09.md#review-s09-u0122`；MIR解释器用虚拟allocation及AllocId+offset表示内存；PDF316–318补读，这不是已执行Miri或完整语言内存模型的证据。|
|S09-U0123|Monomorphization|319|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S09.md#review-s09-u0123`；单态化收集需要生成的具体实例；PDF320补读CGU划分及代码大小/编译时间代价，擦除调度边界仍可有间接调用。|
|S09-U0124|Lowering MIR to a Codegen IR|321|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0124`；从收集的符号把MIR降为LLVM IR时实例化具体类型；不等同于最终目标指令已经优化完毕。|
|S09-U0125|Code generation|321|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0125`；LLVM等后端接收IR再生成目标产物；PDF322补读注解与优化边界，旧指南关于后端支持状态须按版本核对。|
|S09-U0126|Updating LLVM|323|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0126`；更新LLVM的上游补丁、版本支持和发布操作是rustc维护手册；不扩写为本书工具链发行教程。|
|S09-U0127|Backend Agnostic Codegen|330|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0127`；codegen_ssa抽象允许不同后端；指南写作时仍含未来时态，不据此推断当前所有后端的相同行为。|
|S09-U0128|Refactoring of rustc_codegen_llvm|330|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.1](../part2/ch06.md#sec-cpp-rust.2.6.1)|`sources/reviews/S09.md#review-s09-u0128`；2018重构把LLVM绑定、后端通信和通用MIR降级分开；历史LOC与目录结构不能当当前规模统计。|
|S09-U0129|Implicit Caller Location|334|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.4](../part2/ch06.md#sec-cpp-rust.2.6.4)|`sources/reviews/S09.md#review-s09-u0129`；track_caller通过额外调用位置信息改善panic归因；不要从隐含调用参数推出可跨语言稳定ABI。|
|S09-U0130|Profile Guided Optimization|340|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.7](../part2/ch06.md#sec-cpp-rust.2.6.7)|`sources/reviews/S09.md#review-s09-u0130`；PGO以代表性执行数据指导内联、布局等；PDF341、342补读LLVM IR插桩及profile-use，本轮没有执行训练或计时。|
|S09-U0131|Sanitizers Support|343|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.5](../part4/ch14.md#sec-cpp-rust.4.14.5)|`sources/reviews/S09.md#review-s09-u0131`；sanitizer针对不同内存/竞态问题，-Z接口有平台和版本限制；阅读支持列表不是本轮运行ASan/TSan的证据。|
|S09-U0132|Debugging support in the Rust compiler|344|read-mapped / body-read|[part4/ch13.md#sec-cpp-rust.4.13.4](../part4/ch13.md#sec-cpp-rust.4.13.4)|`sources/reviews/S09.md#review-s09-u0132`；调试支持依赖DWARF及GDB/LLDB生态；被优化产物的来源定位需保留符号，未运行调试器也未核验全部DWARF限制。|
|S09-U0133|Appendix B: Background topics|353|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.3](../part1/ch04.md#sec-cpp-rust.1.4.3)|`sources/reviews/S09.md#review-s09-u0133`；CFG、数据流、量词与型变的术语提供MIR分析背景；仅抽读控制流定义，不宣称通读附录所有术语。|
|S09-U0134|Further Reading About Compilers|355|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0134`；编译器教材、课程与论文推荐列表，不作为被引书/课已读状态。|
|S09-U0135|Appendix C: Glossary|356|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0135`；编译器缩写词典供索引查阅；独立机制已映射正文，词典不重复计为arena/AST算法证据。|
|S09-U0136|Appendix D: Code Index|362|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0136`；代码数据结构索引是导航装置，不等于逐一核读所链接的源码定义。|
|S09-U0137|Compiler Lecture Series|366|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0137`；Compiler Lecture Series是视频链接列表；未播放视频，不登记课程核读或实验结果。|
|S09-U0138|Rust Bibliography|366|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0138`；Rust Bibliography列设计影响文献；只核对书目页，未审阅所列并发/类型系统论文。|
|S09-U0139|Humor in Rust|368|excluded-reviewed / scope-only|—|`sources/reviews/S09.md#review-s09-u0139`；Humor in Rust是幽默示例与链接集合，超出本书严肃低层性能证据主线。|

### S10 · Rust 参考手册.pdf {#coverage-s10}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S10-U0001|简介|1|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0001`；手册自述是非完整、非正式参考，不是标准库或rustc/Cargo手册；opening已读PDF1–4，不把它称作完备语言形式规范。|
|S10-U0002|表义符/符号|5|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0002`；产生式、token与正则记号说明用于读文法；本书不补Rust文法和语法入门。|
|S10-U0003|词法结构|7|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0003`；词法结构是无正文分隔页；后续输入、关键字、token逐节列出，不以空白分隔页冒充已读技术正文。|
|S10-U0004|输入格式|8|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0004`；源码UTF-8输入格式仅涉及源文本编码；不能与运行期字节缓冲合法性混淆，后者见文本类型/UB节。|
|S10-U0005|关键字|9|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0005`；严格、保留及弱关键字的列表属于词法教程；不在性能主线重复讲解关键字拼写。|
|S10-U0006|标识符|12|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0006`；标识符的Unicode属性及原生前缀属于词法规则，不是底层对象布局或调用代价。|
|S10-U0007|注释|13|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0007`；注释词法与文档注释糖化不在本书机制范围；opening PDF13–16显示译文内外注释术语有疑点，不能直接照抄。|
|S10-U0008|空白符|17|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0008`；空白字符列表和自由格式说明属于词法定义，不映射为性能证据。|
|S10-U0009|token|18|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0009`；token、字面量、寿命标签及标点的词法规则不作入门重述；字节/字符有效性另由类型和UB节承担。|
|S10-U0010|宏|32|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S10.md#review-s10-u0010`；宏调用在编译时替换为展开结果；与CTFE及运行时函数调用不同，保留为编译流水线的相关材料。|
|S10-U0011|声明宏|34|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.2](../part1/ch04.md#sec-cpp-rust.1.4.2)|`sources/reviews/S10.md#review-s10-u0011`；声明宏的匹配和转码、卫生性以及同章过程宏有独立边界；只抽读文法开篇，不冒充已核读整套宏规则和过程宏实现。|
|S10-U0012|crate 和源文件|49|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.1](../part4/ch14.md#sec-cpp-rust.4.14.1)|`sources/reviews/S10.md#review-s10-u0012`；crate是编译/链接单位，源文件和模块不是同一个概念；旧手册的唯一实现措辞不能作为今天实现生态的断言。|
|S10-U0013|条件编译|52|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S10.md#review-s10-u0013`；cfg/cfg_attr按目标及特性决定是否纳入代码；实验功能集改变被编译程序，不能把cfg!当完全移除代码的替代。|
|S10-U0014|程序项|60|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0014`；程序项的文法总表是导航与语法分类，不独立承担性能机制证据；具体函数、静态项、trait等分别登记。|
|S10-U0015|模块|62|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0015`；模块、源文件名及path属性主要为代码组织语法，本书不展开模块教程。|
|S10-U0016|外部crate声明|65|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0016`；extern crate与预导入包的旧版解析/重命名规则不是最小C ABI；不把其soname译述当当前链接稳定契约。|
|S10-U0017|Use声明|67|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0017`；use路径、通配符及别名是命名引入规则，不作为性能优化或FFI机制本身。|
|S10-U0018|函数|71|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0018`；函数限定符含const/async/extern；异步函数返回匿名Future的相关正文在PDF75，开篇文法抽读不够，需该子节补读后才能映射异步生成机制。|
|S10-U0019|类型别名|78|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0019`；type是现有类型的别名，不是newtype；本书可在需要时说明差别，但不扩写类型别名语法教程。|
|S10-U0020|结构体|79|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0020`；结构体声明确定字段及标称类型，不保证默认内存顺序；开篇主要文法，具体布局保证须转到PDF267起的布局节。|
|S10-U0021|枚举|81|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2)|`sources/reviews/S10.md#review-s10-u0021`；枚举具有构造器及可选判别值，影响有效值与表示；不能把声明文法当作niche优化或具体大小保证。|
|S10-U0022|联合体|85|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0022`；union字段共享存储，写入可改变其他字段解释；合法性、drop及引用仍要独立证明，不执行unsafe反例。|
|S10-U0023|常量项|89|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S10.md#review-s10-u0023`；const值不承诺每次引用有同一地址，可在不同使用处展开；这不同于static的单一存储身份。|
|S10-U0024|静态项|92|read-mapped / body-read|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S10.md#review-s10-u0024`；static有固定存储位置且正常退出不自动drop，static mut访问需额外安全责任；旧文关于引用关系的限制需当前版本校核。|
|S10-U0025|Trait|94|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0025`；trait由关联函数、类型和常量构成，Self和约束限制实现；对象安全和运行时动态分发应与声明语法分开读。|
|S10-U0026|实现|101|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S10.md#review-s10-u0026`；固有impl和trait impl建立类型行为；一致性与泛型关系影响可选实例，但不能从impl数量直接计算代码膨胀。|
|S10-U0027|外部块|107|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S10.md#review-s10-u0027`；外部块声明另一侧函数/静态项，是未经完整安全检查的边界；PDF107关于unsafe extern将被弃用的旧句不适用于Rust2024，必须校正。|
|S10-U0028|类型参数和生存期参数|111|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0028`；类型、寿命和const参数使item参数化；旧版参数排列限制和const generics范围不能不加版本地照搬。|
|S10-U0029|关联项|117|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S10.md#review-s10-u0029`；关联项构成trait契约并有声明/定义之分；关联类型不是运行时对象字段，不能把语法位置当布局位置。|
|S10-U0030|属性|124|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0030`；内外属性、元项及内置属性总索引主要为语法导航；代码生成、测试等具体属性单独裁决，避免将总表算成全部已读。|
|S10-U0031|测试类属性|130|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.4](../part4/ch14.md#sec-cpp-rust.4.14.4)|`sources/reviews/S10.md#review-s10-u0031`；test模式与ignore/should_panic控制测试编译和运行；ignore测试仍编译但不默认运行，不能以编译通过替代执行证据。|
|S10-U0032|派生|132|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.2](../part2/ch05.md#sec-cpp-rust.2.5.2)|`sources/reviews/S10.md#review-s10-u0032`；derive生成关联实现并添加所需trait约束；这不证明自动生成的Clone不会分配或所有泛型实例大小相同。|
|S10-U0033|诊断属性|133|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.3](../part4/ch14.md#sec-cpp-rust.4.14.3)|`sources/reviews/S10.md#review-s10-u0033`；allow/warn/deny/forbid控制诊断而不提供程序正确性证明；must_use等子节没有因工具章映射自动变成全文已读。|
|S10-U0034|代码生成属性|140|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S10.md#review-s10-u0034`；inline/cold只是代码生成提示且可被忽略；本书用保存的产物确认调用保留，不把inline(never)当稳定ABI或硬件屏障。|
|S10-U0035|极值设置|146|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.5](../part1/ch04.md#sec-cpp-rust.1.4.5)|`sources/reviews/S10.md#review-s10-u0035`；recursion_limit/type_length_limit约束编译期递归和实例替换，涉及泛型编译成本；默认值是快照非永恒常量。|
|S10-U0036|类型系统属性|148|read-mapped / body-read|[part4/ch14.md#sec-cpp-rust.4.14.2](../part4/ch14.md#sec-cpp-rust.4.14.2)|`sources/reviews/S10.md#review-s10-u0036`；non_exhaustive限制跨crate构造/匹配以保留演化空间；兼容性与当前单次匹配分支代价不能混淆。|
|S10-U0037|语句和表达式|152|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0037`；语句和表达式导读只介绍两种语法角色；具体求值、move/drop等相关机制在对应正文记录，导读不重复充数。|
|S10-U0038|语句|153|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0038`；let声明、局部item及表达式语句与初始化/捕获边界相关；开篇主要语法，保留需要初始化章节进一步对应的状态。|
|S10-U0039|表达式|156|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0039`；表达式区分place/value、求值顺序、move和临时位置；初始文法总表不能支撑这些深层规则已读，子节未读部分保持缺口。|
|S10-U0040|字面量表达式|163|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0040`；字面量表达式仅列具体字面值文法，不重写语法入门；非法bool/char的安全主题由类型与UB节覆盖。|
|S10-U0041|路径表达式|164|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0041`；路径表达式如何指向变量或item是名称绑定规则；不将本节短例直接算作内存访问性能证据。|
|S10-U0042|块表达式|165|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0042`；块表达式规定值与作用域；PDF166补读只到async块文法，尚未读完状态生成说明，不能据标题标异步降级已核读。|
|S10-U0043|操作符/运算符表达式|169|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0043`；溢出模式、借用、算术、转换和赋值决定可观察行为；开篇已读溢出选项，后面的数值转换/指针规则仍需分节核读。|
|S10-U0044|圆括号表达式(分组表达式)|181|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0044`；圆括号用于优先级及字段函数调用消歧；属于表达式语法，不另设性能章节。|
|S10-U0045|数组和数组索引表达式|183|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0045`；数组重复表达式和索引有初始化及越界行为；PDF184补读运行时失败语义，不意味着边界检查永远不能被合法消除。|
|S10-U0046|元组和元组索引表达式|186|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0046`；元组构造及数字字段索引是语法说明；元组实际布局由布局节覆盖，不以本节复述凑对象章。|
|S10-U0047|结构体表达式|189|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0047`；结构体更新会影响字段移动/初始化，相关但开篇主要文法；不把文法抽读冒充全部更新与drop规则已读。|
|S10-U0048|调用表达式|192|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0048`；调用表达式可能走Fn/FnMut/FnOnce并自动借用/解引用；调用语法相同不代表相同机器码或分派方式。|
|S10-U0049|方法调用表达式|194|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S10.md#review-s10-u0049`；已知receiver可静态分派，trait对象可动态分派，方法查找含自动调整；与执行器内部擦除的层次区分相关。|
|S10-U0050|字段访问表达式|196|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0050`；字段表达式是place且可能独立借用；开篇主要函数字段调用的消歧，未读完字段分割借用的正文需保留。|
|S10-U0051|闭包表达式|198|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0051`；闭包表达式捕获环境，Fn族与Send/Sync取决于使用及捕获；PDF199补读，不将move闭包等同于一定拥有线程。|
|S10-U0052|循环|200|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0052`；四种循环形式的返回/退出语义会进入CFG，迭代器循环降级不是自动向量化保证；只抽读循环种类与loop开篇。|
|S10-U0053|区间表达式|206|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0053`；Range变体区分半开和闭区间，边界计算影响溢出及索引合法性；开篇只抽读表格前半，不把整张表称完整核读。|
|S10-U0054|if和 if let表达式|208|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0054`；if与if let的求值和类型一致性是控制流语法；本书不另行编写条件分支入门，PGO另有机制材料。|
|S10-U0055|匹配(match)表达式|211|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0055`；match的scrutinee是place或临时value会影响移动和借用；相关初始化机制不能整节按语法排除，保持后续映射。|
|S10-U0056|返回(return)表达式|214|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0056`；return移动结果并离开当前调用帧，须与drop作用域一起解释；这里是抽象语义，不承诺物理栈/返回寄存器布局。|
|S10-U0057|等待(await)表达式|215|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.4](../part2/ch08.md#sec-cpp-rust.2.8.4)|`sources/reviews/S10.md#review-s10-u0057`；await轮询固定Future并在Pending时挂起；PDF216补读近似脱糖，伪代码不是可直接编译的标准API用法，也不是执行器完整实现。|
|S10-U0058|模式|217|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.3](../part1/ch03.md#sec-cpp-rust.1.3.3)|`sources/reviews/S10.md#review-s10-u0058`；模式可解构并绑定move或借用，影响部分初始化与drop；开篇语法不足以视作所有绑定模式已读。|
|S10-U0059|类型系统|233|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0059`；类型系统是无正文分隔页；不以该页登记一个已核读的类型理论章节。|
|S10-U0060|类型|234|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0060`；值的类型定义内存解释及允许操作；类型类别总览不代替具体对象布局保证，保留相关章节衔接。|
|S10-U0061|布尔型|237|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0061`；bool只有两种有效位模式，任意字节不能直接当bool；后面的逻辑真值表属于基础语法，不能抹掉开篇有效性的重要性。|
|S10-U0062|数字型|240|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.6](../part2/ch06.md#sec-cpp-rust.2.6.6)|`sources/reviews/S10.md#review-s10-u0062`；整数宽度与平台指针宽度、IEEE浮点约束影响数值实验定义域；必须区分目标宽度和主机宽度，不统一假设64位。|
|S10-U0063|文本类类型|242|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0063`；char是Unicode标量，str有UTF-8有效性要求且是DST；不能将任意字节读为合法文本，来自输入的验证成本必须交代。|
|S10-U0064|never 类型|243|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0064`；never类型的发散表达式与历史稳定性说明不在本书专门展开；不能照搬当时预计1.41稳定的时间描述。|
|S10-U0065|元组类型|244|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0065`；元组包含异构字段，unit是零元组；具体顺序与填充以布局规则为准，语法顺序不等于稳定内存顺序。|
|S10-U0066|数组类型|245|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.3](../part2/ch06.md#sec-cpp-rust.2.6.3)|`sources/reviews/S10.md#review-s10-u0066`；数组长度是常量表达式，安全索引有越界语义；此语义不要求生成永不删除的每次运行时检查。|
|S10-U0067|切片类型|246|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S10.md#review-s10-u0067`；切片是DST视图，借用切片不拥有底层缓冲；帧中保留切片必须保留其有效借用，不能只保留地址而提前复用输入。|
|S10-U0068|结构体类型|247|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S10.md#review-s10-u0068`；默认结构体可重排字段，repr能约束表示；原书把默认布局写成未定义不等于对象使用本身是UB。|
|S10-U0069|枚举类型|248|read-mapped / body-read|[part1/ch02.md#sec-cpp-rust.1.2.2](../part1/ch02.md#sec-cpp-rust.1.2.2)|`sources/reviews/S10.md#review-s10-u0069`；枚举是带变体的标称ADT；PDF248关于最大payload再加判别值的简单说法不能覆盖niche，应以布局保证和当前探针校正。|
|S10-U0070|联合体类型|249|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0070`；读取union会重解释存储，有效值及初始化需证明；默认union布局不应作为C互操作保证。|
|S10-U0071|函数项类型|250|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0071`；函数项是携带身份的零尺寸值，可强转函数指针；函数项调用不必通过间接寻址，函数指针和函数项不可混作同一类型。|
|S10-U0072|闭包类型|251|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.1](../part2/ch08.md#sec-cpp-rust.2.8.1)|`sources/reviews/S10.md#review-s10-u0072`；闭包近似捕获字段结构体，使用方式决定捕获与Fn族；不承诺示意结构等于编译器稳定布局。|
|S10-U0073|指针类型|255|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S10.md#review-s10-u0073`；共享引用、独占引用和裸指针有不同访问/复制约束；形成引用时就需合法，并非等到显式解引用才有有效性责任。|
|S10-U0074|函数指针类型|257|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0074`；裸函数指针含调用签名及ABI，区别于函数项身份；开篇只有文法，后续强转说明尚未完整抽读。|
|S10-U0075|trait对象|259|read-mapped / body-read|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S10.md#review-s10-u0075`；trait对象指针携带数据和虚表元数据；PDF260补读间接调用，不承诺虚表字段顺序、稳定地址或跨语言接口。|
|S10-U0076|实现trait|262|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0076`；参数位置impl Trait和返回位置opaque类型角色不同；原书自称占位式概述，不能据此承诺所有位置均稳定可用。|
|S10-U0077|类型参数|264|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0077`；类型参数是编译时占位，不是每次调用传递的运行时类型对象；示例递归复制不作为推荐高性能向量构造法。|
|S10-U0078|自动推断型类型|265|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0078`；下划线推断的书写位置是类型标注语法，不独立展开推断算法；相关算法由S09正文处理。|
|S10-U0079|动态尺寸类型|266|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.3](../part2/ch08.md#sec-cpp-rust.2.8.3)|`sources/reviews/S10.md#review-s10-u0079`；DST须经固定尺寸指针使用，切片携带长度、trait对象携带虚表；关于所有DST指针必为两倍的旧文过强，PDF268另有不可依赖此点的限定。|
|S10-U0080|类型布局|267|read-mapped / body-read|[part3/ch10.md#sec-cpp-rust.3.10.3](../part3/ch10.md#sec-cpp-rust.3.10.3)|`sources/reviews/S10.md#review-s10-u0080`；布局涉及尺寸、对齐和偏移，repr(C)仍不能定义线协议；PDF268、270–272、275、276、278、279补读，不把宿主字节映像当编码。|
|S10-U0081|内部可变性|280|read-mapped / body-read|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S10.md#review-s10-u0081`；UnsafeCell提供共享引用下内部修改的入口但不许可并发非同步访问；RefCell动态检查和原子类型有不同协议。|
|S10-U0082|子类型化和型变|281|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S10.md#review-s10-u0082`；Rust子类型主要与生命周期和高阶类型相关，型变从参数关系传播；不能把长寿命与可任意重借用混同。|
|S10-U0083|trait 约束和生命周期约束|283|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S10.md#review-s10-u0083`；trait/寿命约束限制泛型实参，含Sized和高阶约束；开篇抽读不能算已读完整高阶语义。|
|S10-U0084|类型自动强转|287|read-mapped / body-read|[part2/ch05.md#sec-cpp-rust.2.5.3](../part2/ch05.md#sec-cpp-rust.2.5.3)|`sources/reviews/S10.md#review-s10-u0084`；coercion只在特定点发生，需区分类型推断与自动强转；unsizing的机器级元数据变化需另核对产物。|
|S10-U0085|析构函数|294|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.8](../part2/ch08.md#sec-cpp-rust.2.8.8)|`sources/reviews/S10.md#review-s10-u0085`；析构先运行Drop再递归已初始化字段，局部与字段顺序不同；PDF295、299补读drop作用域和临时延长，取消需与实际drop完成区分。|
|S10-U0086|生命周期(类型参数)省略|301|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.2](../part1/ch03.md#sec-cpp-rust.1.3.2)|`sources/reviews/S10.md#review-s10-u0086`；生命周期省略是签名推断规则，trait对象有不同默认规则；不把省略当运行时自动延长对象寿命。|
|S10-U0087|特殊类型和 trait|306|read-mapped / body-read|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S10.md#review-s10-u0087`；UnsafeCell、PhantomData、Drop、Copy、Send/Sync各有语言交互；PDF307、308补读，自动trait规则须连同显式正/负实现一起读，不能推出裸指针总能Send。|
|S10-U0088|名称|310|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0088`；名称、实体及声明的分类是命名系统导航，本书不重写名称绑定入门。|
|S10-U0089|命名空间|312|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0089`；多个命名空间允许同名实体，用于解析阶段而不是对象内存的地址空间；不作为缓存或NUMA概念材料。|
|S10-U0090|作用域|315|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0090`；作用域章节仅占位且主题为名称可见范围；生命周期/drop范围另有正文，不能将本空章当作其证据。|
|S10-U0091|预导入包|316|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0091`；预导入包和no_std影响名称可用性，此处不是分配器或运行时实现；本书不展开导入语法，alloc分层另由S08处理。|
|S10-U0092|路径|319|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0092`；路径限定、Self/super/crate等是解析与命名文法，不另写为性能技术节。|
|S10-U0093|名称解析|327|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0093`；名称解析章节是占位；本书不教授完整名称解析，相关编译阶段由S09有正文材料承担，不能声称此页有算法。|
|S10-U0094|可见性与隐私权|328|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S10.md#review-s10-u0094`；可见性约束跨模块访问并帮助封装不变量；公开enum/trait有默认公开成员，不可只看一个pub判断所有字段公开。|
|S10-U0095|内存模型|334|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.5](../part1/ch03.md#sec-cpp-rust.1.3.5)|`sources/reviews/S10.md#review-s10-u0095`；原书明确内存模型尚不完备；这可支持保留模型边界的声明，不允许从缺少规范推导任意unsafe操作均合法。|
|S10-U0096|内存分配和生存期|335|read-mapped / body-read|[part2/ch08.md#sec-cpp-rust.2.8.7](../part2/ch08.md#sec-cpp-rust.2.8.7)|`sources/reviews/S10.md#review-s10-u0096`；Box所指堆分配可比创建它的调用帧活得更久，移动句柄不移动分配；这不证明任意取出裸指针可超越所有者寿命。|
|S10-U0097|变量|336|read-mapped / body-read|[part1/ch04.md#sec-cpp-rust.1.4.4](../part1/ch04.md#sec-cpp-rust.1.4.4)|`sources/reviews/S10.md#review-s10-u0097`；变量在所有可达路径初始化后才可使用，mut不等于已初始化；抽象栈帧叙述不保证优化后物理栈槽存在。|
|S10-U0098|链接|337|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S10.md#review-s10-u0098`；crate_type决定bin/rlib/staticlib/cdylib等产物；PDF338、339补读元数据与C运行时链接，不把Rust库ABI当作C接口。|
|S10-U0099|非安全性|341|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0099`；unsafe操作需要额外证明，安全子集不允许的操作清单随版本变化；不能用旧清单遗漏证明裸指针操作安全。|
|S10-U0100|非安全函数|342|read-mapped / body-read|[part1/ch03.md#sec-cpp-rust.1.3.4](../part1/ch03.md#sec-cpp-rust.1.3.4)|`sources/reviews/S10.md#review-s10-u0100`；unsafe fn声明调用者需满足前提；Rust2024函数体内unsafe操作规则应另核对当前语言，不照抄旧函数内隐式允许的措辞。|
|S10-U0101|非安全块|343|read-mapped / body-read|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S10.md#review-s10-u0101`；unsafe不解除UB禁令；PDF344、345与347补读数据竞争、无效值、元数据以及死锁/泄漏不是内存UB，列表亦自承不穷尽。|
|S10-U0102|常量求值|349|read-mapped / body-read|[part2/ch06.md#sec-cpp-rust.2.6.5](../part2/ch06.md#sec-cpp-rust.2.6.5)|`sources/reviews/S10.md#review-s10-u0102`；常量上下文强制求值而普通位置不保证，const fn按目标环境解释；PDF350、351补读旧版限制，浮点/指针限制不能当作当前永恒清单。|
|S10-U0103|应用程序二进制接口(ABI)|352|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S10.md#review-s10-u0103`；used只保留对象文件不保证链接器保留，no_mangle与export_name控制符号；PDF354补读，Rust2024安全属性写法须按当前版本重验。|
|S10-U0104|Rust 运行时|355|read-mapped / body-read|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S10.md#review-s10-u0104`；panic_handler和global_allocator影响运行时边界；开篇只抽读panic，不能把set_hook替代panic策略，也不代表读过分配器实现。|
|S10-U0105|附录|357|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0105`；附录是无正文分隔页，不作为新语言机制核读。|
|S10-U0106|附录：关于宏随集的二义性的形式化规范|358|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0106`；宏FOLLOW集合歧义的形式规范是语法/宏编译器专项；本书不展开匹配器FIRST/LAST/FOLLOW证明，只读开篇界定范围。|
|S10-U0107|影响来源|367|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0107`；语言影响来源是历史书目线索，不是对SML、Cyclone、C++等原始材料的独立核读。|
|S10-U0108|术语表|368|excluded-reviewed / scope-only|—|`sources/reviews/S10.md#review-s10-u0108`；术语表用于查词，开篇只抽读AST、对齐量和元数；不把词条链接算作已读其全文正文。|

### S11 · Rust 程序设计语言 简体中文版.pdf {#coverage-s11}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S11-U001|Introduction|7|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；书签 7 后的 8 页只有书名，未发现 Introduction 正文；这是文件内容限制，不宣称读过引言论述。|
|S11-U002|入门指南|9|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 入门指南 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U003|安装|11|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 安装 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U004|Hello, World!|14|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 Hello, World! 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U005|Hello, Cargo!|18|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 Hello, Cargo! 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U006|猜猜看游戏教程|23|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 猜猜看游戏教程 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U007|通用编程概念|41|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 通用编程概念 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U008|变量与可变性|43|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 变量与可变性 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U009|数据类型|47|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 数据类型 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U010|函数如何工作|54|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 函数如何工作 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U011|注释|60|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 注释 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U012|控制流|62|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 控制流 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U013|认识所有权|70|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U014|什么是所有权？|72|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u014`；借用有效性或生命周期机制相关；本轮仅开篇范围核查，所有权/unsafe 专章尚未存在，不把语法抽页标为深入核读。|
|S11-U015|引用与借用|82|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u015`；借用有效性或生命周期机制相关；本轮仅开篇范围核查，所有权/unsafe 专章尚未存在，不把语法抽页标为深入核读。|
|S11-U016|Slices|88|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u016`；借用有效性或生命周期机制相关；本轮仅开篇范围核查，所有权/unsafe 专章尚未存在，不把语法抽页标为深入核读。|
|S11-U017|使用结构体来组织相关联的数据|96|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 使用结构体来组织相关联的数据 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U018|定义并实例化结构体|98|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 定义并实例化结构体 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U019|一个使用结构体的示例程序|104|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 一个使用结构体的示例程序 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U020|方法语法|109|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 方法语法 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U021|枚举与模式匹配|115|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 枚举与模式匹配 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U022|定义枚举|117|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 定义枚举 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U023|match 控制流运算符|124|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 match 控制流运算符 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U024|if let 简洁控制流|129|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 if let 简洁控制流 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U025|模块|133|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 模块 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U026|mod 与文件系统|135|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 mod 与文件系统 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U027|使用 pub 控制可见性|143|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 使用 pub 控制可见性 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U028|在不同的模块中引用命名|149|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 在不同的模块中引用命名 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U029|通用集合类型|155|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U030|vector|157|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u030`；连续 Vec、UTF-8 字节串或哈希存储是布局与数据通路背景；本轮开篇核查，待对象/数据通路专章。|
|S11-U031|字符串|162|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u031`；连续 Vec、UTF-8 字节串或哈希存储是布局与数据通路背景；本轮开篇核查，待对象/数据通路专章。|
|S11-U032|哈希 map|169|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u032`；连续 Vec、UTF-8 字节串或哈希存储是布局与数据通路背景；本轮开篇核查，待对象/数据通路专章。|
|S11-U033|错误处理|175|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U034|panic! 与不可恢复的错误|177|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u034`；panic/Result 与错误传播影响资源边界；本轮为范围核查，未把一般错误处理引言当成 FFI panic 防线证据。|
|S11-U035|Result 与可恢复的错误|181|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u035`；panic/Result 与错误传播影响资源边界；本轮为范围核查，未把一般错误处理引言当成 FFI panic 防线证据。|
|S11-U036|panic! 还是不 panic!|188|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u036`；panic/Result 与错误传播影响资源边界；本轮为范围核查，未把一般错误处理引言当成 FFI panic 防线证据。|
|S11-U037|泛型、trait 与生命周期|193|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U038|泛型数据类型|198|read-mapped / selected-body|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u038`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U039|trait：定义共享的行为|205|read-mapped / scope-excerpt|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u039`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U040|生命周期与引用有效性|213|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u040`；借用有效性或生命周期机制相关；本轮仅开篇范围核查，所有权/unsafe 专章尚未存在，不把语法抽页标为深入核读。|
|S11-U041|测试|225|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U042|编写测试|227|read-mapped / scope-excerpt|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u042`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U043|运行测试|239|read-mapped / scope-excerpt|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u043`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U044|测试的组织结构|245|read-mapped / scope-excerpt|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u044`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U045|一个 I/O 项目：构建命令行程序|252|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 一个 I/O 项目：构建命令行程序 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U046|接受命令行参数|254|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 接受命令行参数 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U047|读取文件|257|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 读取文件 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U048|重构以改进模块化与错误处理|260|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u048`；panic/Result 与错误传播影响资源边界；本轮为范围核查，未把一般错误处理引言当成 FFI panic 防线证据。|
|S11-U049|采用测试驱动开发完善库的功能|270|read-mapped / scope-excerpt|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u049`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U050|处理环境变量|276|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 处理环境变量 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U051|将错误信息输出到标准错误而不是标准输出|282|read-mapped / scope-excerpt|[part3/ch10.md#sec-cpp-rust.3.10.1](../part3/ch10.md#sec-cpp-rust.3.10.1)|`sources/reviews/S11.md#review-s11-u051`；与所有权、编译优化、测试或运行系统有关；已核查本节开头，未把抽页冒充全节阅读，等待相应正文落点。|
|S11-U052|Rust 中的函数式语言功能：迭代器与闭包|286|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U053|闭包：可以捕获其环境的匿名函数|288|read-mapped / scope-excerpt|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u053`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U054|使用迭代器处理元素序列|300|read-mapped / scope-excerpt|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u054`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U055|改进之前的 I/O 项目|308|read-mapped / scope-excerpt|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u055`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U056|性能比较：循环对迭代器|313|read-mapped / selected-body|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u056`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U057|更多关于 Cargo 和 Crates.io 的内容|317|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U058|采用发布配置自定义构建|319|read-mapped / selected-body|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u058`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U059|将 crate 发布到 Crates.io|322|read-mapped / selected-body|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u059`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U060|Cargo 工作空间|331|read-mapped / scope-excerpt|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S11.md#review-s11-u060`；测试组织、发布 profile、文档示例或工作空间属于 Cargo/CI 证据；当前 ch14 不存在，保留未映射状态。|
|S11-U061|使用 cargo install 从 Crates.io 安装二进制文件|337|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 使用 cargo install 从 Crates.io 安装二进制文件 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U062|Cargo 自定义扩展命令|339|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 Cargo 自定义扩展命令 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U063|智能指针|342|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U064|Box 指向堆上数据，并且可确定大小|344|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u064`；分配、解引用、引用计数、内部可变性或安全泄漏与资源成本有关；仅核查开篇，待对象/所有权专章。|
|S11-U065|通过 Deref trait 将智能指针当作常规引用处理|349|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u065`；分配、解引用、引用计数、内部可变性或安全泄漏与资源成本有关；仅核查开篇，待对象/所有权专章。|
|S11-U066|Drop Trait 运行清理代码|355|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.2](../part3/ch09.md#sec-cpp-rust.3.9.2)|`sources/reviews/S11.md`；Drop 自动清理与显式 drop；对应取消后观察析构，不推导取消时限。|
|S11-U067|Rc 引用计数智能指针|359|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u067`；分配、解引用、引用计数、内部可变性或安全泄漏与资源成本有关；仅核查开篇，待对象/所有权专章。|
|S11-U068|RefCell 与内部可变性模式|363|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u068`；分配、解引用、引用计数、内部可变性或安全泄漏与资源成本有关；仅核查开篇，待对象/所有权专章。|
|S11-U069|引用循环与内存泄漏是安全的|371|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S11.md#review-s11-u069`；分配、解引用、引用计数、内部可变性或安全泄漏与资源成本有关；仅核查开篇，待对象/所有权专章。|
|S11-U070|无畏并发|380|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U071|线程|382|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.8](../part3/ch09.md#sec-cpp-rust.3.9.8)|`sources/reviews/S11.md`；线程 join 与退出责任；不是 Future 抢占或 Tokio 调度规范。|
|S11-U072|消息传递|389|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.7](../part3/ch09.md#sec-cpp-rust.3.9.7)|`sources/reviews/S11.md`；发送转移所有权、接收等待与关闭；本章另行限定 Tokio 有界通道。|
|S11-U073|共享状态|395|read-mapped / selected-body|[part2/ch07.md#sec-cpp-rust.2.7.3](../part2/ch07.md#sec-cpp-rust.2.7.3)|`sources/reviews/S11.md`；Arc 共享所有权与 MutexGuard 排他访问不同；死锁仍属逻辑风险。|
|S11-U074|可扩展的并发：Sync 与 Send|402|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.3](../part3/ch09.md#sec-cpp-rust.3.9.3)|`sources/reviews/S11.md`；Send/Sync 与 Rc 的线程边界；current-thread 不自动取消 spawn 的 Send 约束。|
|S11-U075|Rust 的面向对象编程特征|405|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；围绕面向对象定义或博客状态模式的设计教学；仅取分发机制子节，不展开范式比较/状态模式教材。|
|S11-U076|面向对象语言的特点|406|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；围绕面向对象定义或博客状态模式的设计教学；仅取分发机制子节，不展开范式比较/状态模式教材。|
|S11-U077|为使用不同类型的值而设计的 trait 对象|410|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.4](../part3/ch09.md#sec-cpp-rust.3.9.4)|`sources/reviews/S11.md`；泛型单态化与 trait 对象动态分发，为任务类型擦除作机制参照；不提供 vtable ABI。|
|S11-U078|面向对象设计模式的实现|417|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；围绕面向对象定义或博客状态模式的设计教学；仅取分发机制子节，不展开范式比较/状态模式教材。|
|S11-U079|模式用来匹配值的结构|428|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；模式位置、refutability、匹配语法或关键字参考；按实际开篇范围排除语法手册内容。|
|S11-U080|所有可能会用到模式的位置|430|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；模式位置、refutability、匹配语法或关键字参考；按实际开篇范围排除语法手册内容。|
|S11-U081|Refutability：何时模式可能会匹配失败|435|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；模式位置、refutability、匹配语法或关键字参考；按实际开篇范围排除语法手册内容。|
|S11-U082|模式的全部语法|438|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；模式位置、refutability、匹配语法或关键字参考；按实际开篇范围排除语法手册内容。|
|S11-U083|高级特征|452|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U084|不安全的 Rust|454|read-mapped / selected-body|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u084`；与所有权、编译优化、测试或运行系统有关；已核查本节开头，未把抽页冒充全节阅读，等待相应正文落点。|
|S11-U085|高级生命周期|462|read-mapped / scope-excerpt|[part1/ch03.md#sec-cpp-rust.1.3.1](../part1/ch03.md#sec-cpp-rust.1.3.1)|`sources/reviews/S11.md#review-s11-u085`；借用有效性或生命周期机制相关；本轮仅开篇范围核查，所有权/unsafe 专章尚未存在，不把语法抽页标为深入核读。|
|S11-U086|高级 trait|469|read-mapped / scope-excerpt|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u086`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U087|高级类型|479|read-mapped / scope-excerpt|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u087`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U088|高级函数与闭包|485|read-mapped / scope-excerpt|[part2/ch05.md#sec-cpp-rust.2.5.1](../part2/ch05.md#sec-cpp-rust.2.5.1)|`sources/reviews/S11.md#review-s11-u088`；单态化、迭代器、调用方式或动态大小类型与 codegen 相关；待 trait/LLVM 专章，不承诺旧书的零开销概括适用于所有实例。|
|S11-U089|最后的项目: 构建多线程 web server|489|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；章节导读列举子节主题，没有独立技术证明；保留原条目，实质内容分别登记子节，不重复映射。|
|S11-U090|单线程 web server|491|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；本节为 单线程 web server 的语言/API 入门或练习；Rust 底层性能主线不重复系统语法教程。|
|S11-U091|将单线程 server 变为多线程 server|500|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.6](../part3/ch09.md#sec-cpp-rust.3.9.6)|`sources/reviews/S11.md`；慢请求在单执行流中阻挡无关请求；不是本机异步 benchmark 的实测来源。|
|S11-U092|优雅停机与清理|517|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.8](../part3/ch09.md#sec-cpp-rust.3.9.8)|`sources/reviews/S11.md`；先广播停止再 join，避免逐个发送并等待造成协议死锁；仅教学线程池。|
|S11-U093|附录|527|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；附录总导语，非独立性能材料；子项逐条保留。|
|S11-U094|A - 关键字|529|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；模式位置、refutability、匹配语法或关键字参考；按实际开篇范围排除语法手册内容。|
|S11-U095|B - 运算符与符号|532|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；原书签落空白分页，下一物理页仅有本附录标题、无论述正文；保留条目并按文件缺文排除，不能充作宏/trait/nightly 核读。|
|S11-U096|C - 可导出的 trait|534|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；原书签落空白分页，下一物理页仅有本附录标题、无论述正文；保留条目并按文件缺文排除，不能充作宏/trait/nightly 核读。|
|S11-U097|D - 宏|536|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；原书签落空白分页，下一物理页仅有本附录标题、无论述正文；保留条目并按文件缺文排除，不能充作宏/trait/nightly 核读。|
|S11-U098|E - 本书翻译|538|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；原书签落空白分页，下一物理页仅有本附录标题、无论述正文；保留条目并按文件缺文排除，不能充作宏/trait/nightly 核读。|
|S11-U099|F - 最新功能|540|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；原书签落空白分页，下一物理页仅有本附录标题、无论述正文；保留条目并按文件缺文排除，不能充作宏/trait/nightly 核读。|
|S11-U100|G - Rust 是如何开发的与 “Nightly Rust”|542|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；原书签落空白分页，下一物理页仅有本附录标题、无论述正文；保留条目并按文件缺文排除，不能充作宏/trait/nightly 核读。|
|S11-U101|目录|2|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；前后目录或印刷目录分篇标签，仅作目录对账证据，不当正文技术来源。|
|S11-U102|入门指南（印刷目录分篇标签）|3|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；前后目录或印刷目录分篇标签，仅作目录对账证据，不当正文技术来源。|
|S11-U103|基本 Rust 技能（印刷目录分篇标签）|4|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；前后目录或印刷目录分篇标签，仅作目录对账证据，不当正文技术来源。|
|S11-U104|Rust 编程思想（印刷目录分篇标签）|5|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；前后目录或印刷目录分篇标签，仅作目录对账证据，不当正文技术来源。|
|S11-U105|高级主题（印刷目录分篇标签）|6|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；前后目录或印刷目录分篇标签，仅作目录对账证据，不当正文技术来源。|
|S11-U106|末尾目录|544|excluded-reviewed / scope-excerpt|—|`sources/reviews/S11.md`；前后目录或印刷目录分篇标签，仅作目录对账证据，不当正文技术来源。|

### S12 · The Rust on ESP Book 简体中文版.pdf {#coverage-s12}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S12-U001|引言|1|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U002|这本书适合谁|1|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U003|前提条件|1|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U004|资源|1|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U005|翻译|2|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U006|如何使用这本书|2|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U007|为本书做出贡献|2|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U008|重用本材料|2|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；受众、前提、资源、贡献或许可说明；只用于确认本母本的 ESP 嵌入式范围，不作性能机制来源。|
|S12-U009|开发方式总览|4|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u009`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U010|仓库命名约定|4|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“仓库命名约定”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U011|对乐鑫产品的支持|4|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“对乐鑫产品的支持”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U012|使用标准库（std）|6|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u012`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U013|当前支持情况|6|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“当前支持情况”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U014|esp-rs 相关的 Crate|6|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“esp-rs 相关的 Crate”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U015|何时适合使用标准库（std）|6|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u015`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U016|使用核心库（no_std）|8|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u016`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U017|当前支持情况|8|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“当前支持情况”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U018|esp-rs 相关的 Crate|8|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“esp-rs 相关的 Crate”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U019|何时适合使用核心库（no_std）|9|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u019`；no_std 的尺寸/实时性取舍仅是该书的建议，没有本机测量；保留为范围参照，不能推广为 no_std 必然更快或硬实时。|
|S12-U020|配置开发环境|10|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“配置开发环境”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U021|Rust 安装|11|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“Rust 安装”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U022|仅针对 RISC-V 目标|12|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u022`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U023|针对 RISC-V 和 Xtensa 目标|14|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“针对 RISC-V 和 Xtensa 目标”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U024|1. 安装 espup|14|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“1. 安装 espup”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U025|2. 安装必要的工具链|14|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“2. 安装必要的工具链”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U026|3. 配置环境变量|14|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“3. 配置环境变量”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U027|espup 安装了什么|15|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u027`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U028|Xtensa 目标的其他安装方法|15|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“Xtensa 目标的其他安装方法”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U029|std 开发依赖项|16|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u029`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U030|使用容器|17|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u030`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U031|编写自己的应用|18|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“编写自己的应用”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U032|从模板生成项目|19|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“从模板生成项目”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U033|esp-generate|19|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“esp-generate”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U034|esp-idf-template|19|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“esp-idf-template”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U035|在模板中使用开发容器（Dev Container）|20|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“在模板中使用开发容器（Dev Container）”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U036|esp-generate 简介|21|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“esp-generate 简介”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U037|检查生成的项目|21|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u037`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U038|main.rs 简介|22|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“main.rs 简介”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U039|运行代码|23|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“运行代码”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U040|esp-idf-template 简介|25|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“esp-idf-template 简介”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U041|检查生成的项目|25|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u041`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U042|main.rs 简介|26|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“main.rs 简介”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U043|运行代码|26|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“运行代码”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U044|编写 no_std 应用|28|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“编写 no_std 应用”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U045|编写 std 应用|29|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“编写 std 应用”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U046|工具|30|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“工具”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U047|Visual Studio Code|31|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“Visual Studio Code”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U048|实用建议|31|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“实用建议”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U049|在 no_std 下使用 Rust Analyzer|31|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“在 no_std 下使用 Rust Analyzer”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U050|在使用自定义工具链时使用 Cargo 提示|31|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“在使用自定义工具链时使用 Cargo 提示”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U051|其他 IDE|32|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“其他 IDE”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U052|espflash|33|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“espflash”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U053|cargo-espflash|33|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“cargo-espflash”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U054|espflash|33|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“espflash”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U055|调试|35|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“调试”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U056|USB-JTAG-SERIAL 外设|35|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“USB-JTAG-SERIAL 外设”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U057|probe-rs|37|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“probe-rs”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U058|用 probe-rs 烧写|37|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“用 probe-rs 烧写”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U059|VS Code 扩展|37|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“VS Code 扩展”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U060|示例 launch.json|38|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“示例 launch.json”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U061|cargo-flash 和 cargo-embed|39|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“cargo-flash 和 cargo-embed”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U062|GDB 集成|39|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“GDB 集成”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U063|OpenOCD|40|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“OpenOCD”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U064|VS Code 扩展|40|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“VS Code 扩展”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U065|配置|40|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“配置”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U066|多核调试|41|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“多核调试”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U067|仿真|42|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“仿真”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U068|Wokwi|43|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“Wokwi”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U069|使用 Wokwi VS Code 扩展|43|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“使用 Wokwi VS Code 扩展”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U070|使用 wokwi-server|43|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“使用 wokwi-server”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U071|自定义芯片|44|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“自定义芯片”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U072|QEMU|45|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“QEMU”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U073|使用 QEMU 运行项目|45|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“使用 QEMU 运行项目”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U074|Troubleshooting|46|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“Troubleshooting”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U075|使用了错误的 Rust 工具链|46|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u075`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U076|Windows|47|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“Windows”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U077|长路径名|47|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“长路径名”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U078|缺少 ABI|47|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“缺少 ABI”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U079|esp-idf-sys based projects|48|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“esp-idf-sys based projects”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U080|Wrong Xtal Frequency|48|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“Wrong Xtal Frequency”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U081|Environment Variable LIBCLANG_PATH Not Set|48|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u081`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U082|Missing ldproxy|49|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u082`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U083|sdkconfig.defaults File is Updated but it Doesn't Appear to Have Had Any Effect|49|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u083`；已读目标/工具链、宿主 std、链接依赖或构建环境相关正文；可供 Cargo/FFI 环境边界参照，ch14/ch16 尚不存在，不能推为本机已验证 ESP 支持。|
|S12-U084|The Documentation for the Crates Mentioned on This Page is out of Date or Missing|49|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S12.md#review-s12-u084`；正文解释 docs.rs 构建时联网限制导致 ESP 依赖文档另行托管；可作离线文档构建门禁风险，待 Cargo/CI 专章。|
|S12-U085|A Stack Overflow in Task main has Been Detected|49|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“A Stack Overflow in Task main has Been Detected”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|
|S12-U086|How to Disable Watchdog Timer(s)?|50|excluded-reviewed / body-text|—|`sources/reviews/S12.md`；已读“How to Disable Watchdog Timer(s)?”所在页正文；这是 ESP 芯片支持、开发板、工具或外设工作流，不作为桌面 Rust 底层性能机制证据。|

### S13 · rust-book-zh-cn-shieber.pdf {#coverage-s13}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S13-U001|序|1|excluded-reviewed / selected-body|—|`sources/reviews/S13.md`；原书签“序”指向空白物理页 1；实际序在物理页 4，内容说明抽象数据类型与教学简化，不是另一本 TRPL。|
|S13-U002|Rust 基础|13|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 基础”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U003|本章目标|13|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U004|安装 Rust 及其工具链|13|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“安装 Rust 及其工具链”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U005|Rust 学习资料|14|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 学习资料”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U006|书籍文档|14|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“书籍文档”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U007|特定领域|14|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“特定领域”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U008|资源网站|15|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“资源网站”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U009|Rust 回顾|15|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 回顾”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U010|语言历史|15|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“语言历史”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U011|关键字、注释、命名风格|17|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“关键字、注释、命名风格”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U012|常量、变量、数据类型|20|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“常量、变量、数据类型”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U013|语句、表达式、运算符、流程控制|24|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“语句、表达式、运算符、流程控制”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U014|函数、程序结构|28|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“函数、程序结构”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U015|所有权、作用域规则、生命周期|31|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u015`；母本辅助节（所有权、作用域规则、生命周期）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U016|泛型、trait|35|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u016`；母本辅助节（泛型、trait）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U017|枚举及模式匹配|39|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“枚举及模式匹配”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U018|函数式编程|40|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u018`；母本辅助节（函数式编程）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U019|智能指针|44|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u019`；母本辅助节（智能指针）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U020|异常处理|52|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u020`；母本辅助节（异常处理）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U021|宏系统|54|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“宏系统”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U022|代码组织及包依赖关系|55|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u022`；母本辅助节（代码组织及包依赖关系）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U023|项目：Rust 密码生成器|57|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“项目：Rust 密码生成器”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U024|总结|66|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于语言基础与密码生成器教学；本书不铺陈通用数据结构与算法教程。|
|S13-U025|计算机科学|67|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“计算机科学”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U026|本章目标|67|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U027|快速开始|67|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“快速开始”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U028|什么是计算机科学|67|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“什么是计算机科学”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U029|什么是编程|69|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“什么是编程”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U030|为什么学习数据结构|69|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“为什么学习数据结构”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U031|为什么学习算法|70|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“为什么学习算法”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U032|总结|70|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于计算机科学与抽象数据类型教学；本书不铺陈通用数据结构与算法教程。|
|S13-U033|算法分析|71|read-mapped / selected-body|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u033`；已读 SystemTime 求和夹具与大 O 起点；输出未强制观察且缺少优化配置，旧时间不能当当前性能证据，待测量专章。|
|S13-U034|本章目标|71|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于算法分析教学；本书不铺陈通用数据结构与算法教程。|
|S13-U035|什么是算法分析|71|read-mapped / selected-body|[part1/ch01.md#sec-cpp-rust.1.1.1](../part1/ch01.md#sec-cpp-rust.1.1.1)|`sources/reviews/S13.md#review-s13-u035`；已读 SystemTime 求和夹具与大 O 起点；输出未强制观察且缺少优化配置，旧时间不能当当前性能证据，待测量专章。|
|S13-U036|大 O 分析法|74|read-mapped / selected-body|[part1/ch01.md#sec-cpp-rust.1.1.1](../part1/ch01.md#sec-cpp-rust.1.1.1)|`sources/reviews/S13.md#review-s13-u036`；已读 SystemTime 求和夹具与大 O 起点；输出未强制观察且缺少优化配置，旧时间不能当当前性能证据，待测量专章。|
|S13-U037|乱序字符串检查|77|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“乱序字符串检查”的开篇/本章上下文，属于算法分析教学；本书不铺陈通用数据结构与算法教程。|
|S13-U038|穷举法|77|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“穷举法”的开篇/本章上下文，属于算法分析教学；本书不铺陈通用数据结构与算法教程。|
|S13-U039|检查法|77|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“检查法”的开篇/本章上下文，属于算法分析教学；本书不铺陈通用数据结构与算法教程。|
|S13-U040|排序和比较法|79|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“排序和比较法”的开篇/本章上下文，属于算法分析教学；本书不铺陈通用数据结构与算法教程。|
|S13-U041|计数和比较法|80|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“计数和比较法”的开篇/本章上下文，属于算法分析教学；本书不铺陈通用数据结构与算法教程。|
|S13-U042|Rust 数据结构的性能|81|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u042`；“Rust 数据结构的性能”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U043|标量和复合类型|81|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u043`；母本辅助节（标量和复合类型）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U044|集合类型|82|read-mapped / selected-body|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u044`；已核查表 3.2/3.3 的集合操作复杂度；平均/最坏与摊还条件须另核，不把 O(1) 等同固定纳秒。|
|S13-U045|总结|83|read-mapped / selected-body|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u045`；已核查表 3.2/3.3 的集合操作复杂度；平均/最坏与摊还条件须另核，不把 O(1) 等同固定纳秒。|
|S13-U046|基础数据结构|84|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u046`；“基础数据结构”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U047|本章目标|84|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U048|线性数据结构|84|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u048`；“线性数据结构”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U049|栈|85|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“栈”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U050|栈的抽象数据类型|86|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“栈的抽象数据类型”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U051|Rust 实现栈|87|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 实现栈”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U052|括号匹配|91|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“括号匹配”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U053|进制转换|97|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“进制转换”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U054|前中后缀表达式|99|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“前中后缀表达式”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U055|中缀转前后缀表达式|101|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“中缀转前后缀表达式”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U056|队列|107|read-mapped / scope-excerpt|[part3/ch09.md#sec-cpp-rust.3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1)|`sources/reviews/S13.md#review-s13-u056`；“队列”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U057|队列的抽象数据类型|108|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u057`；母本辅助节（队列的抽象数据类型）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U058|Rust 实现队列|109|read-mapped / selected-body|[part3/ch09.md#sec-cpp-rust.3.9.7](../part3/ch09.md#sec-cpp-rust.3.9.7)|`sources/reviews/S13.md`；有界队列在 enqueue 前检查容量，Vec::insert(0) 仍线性搬移；只作准入边界对照，不视为并发队列。|
|S13-U059|烫手山芋|113|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“烫手山芋”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U060|双端队列|115|read-mapped / scope-excerpt|[part3/ch09.md#sec-cpp-rust.3.9.1](../part3/ch09.md#sec-cpp-rust.3.9.1)|`sources/reviews/S13.md#review-s13-u060`；“双端队列”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U061|双端队列的抽象数据类型|115|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u061`；母本辅助节（双端队列的抽象数据类型）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U062|Rust 实现双端队列|116|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u062`；母本辅助节（Rust 实现双端队列）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U063|回文检测|122|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“回文检测”的开篇/本章上下文，属于线性数据结构教学；本书不铺陈通用数据结构与算法教程。|
|S13-U064|链表|123|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u064`；“链表”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U065|链表的抽象数据类型|124|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u065`；母本辅助节（链表的抽象数据类型）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U066|Rust 实现链表|124|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u066`；母本辅助节（Rust 实现链表）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U067|链表栈|130|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u067`；母本辅助节（链表栈）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U068|Vec|135|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u068`；“Vec”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U069|Vec 的抽象数据类型|135|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u069`；母本辅助节（Vec 的抽象数据类型）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U070|Rust 实现 Vec|136|read-mapped / selected-body|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u070`；正文所谓实现 Vec 实际是 Box 节点 LVec，push/pop 都遍历；不能用作 std::vec::Vec 连续内存实现说明，待对象专章作辨误。|
|S13-U071|总结|143|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u071`；“总结”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U072|递归|144|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“递归”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U073|本章目标|144|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U074|什么是递归|144|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“什么是递归”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U075|递归三定律|147|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“递归三定律”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U076|到任意进制的转换|147|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“到任意进制的转换”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U077|汉诺塔|150|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“汉诺塔”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U078|尾递归|151|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“尾递归”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U079|递归和迭代|152|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“递归和迭代”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U080|动态规划|153|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“动态规划”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U081|什么是动态规划|157|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“什么是动态规划”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U082|动态规划与递归|160|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“动态规划与递归”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U083|总结|161|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于递归与动态规划教学；本书不铺陈通用数据结构与算法教程。|
|S13-U084|查找|162|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U085|本章目标|162|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U086|查找|162|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U087|顺序查找|163|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“顺序查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U088|Rust 实现顺序查找|163|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 实现顺序查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U089|顺序查找复杂度|165|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“顺序查找复杂度”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U090|二分查找|167|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二分查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U091|Rust 实现二分查找|167|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 实现二分查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U092|二分查找复杂度|170|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二分查找复杂度”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U093|内插查找|170|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“内插查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U094|指数查找|172|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“指数查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U095|哈希查找|173|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“哈希查找”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U096|哈希函数|174|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“哈希函数”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U097|解决冲突|176|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“解决冲突”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U098|Rust 实现 HashMap|178|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 实现 HashMap”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U099|HashMap 复杂度|187|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“HashMap 复杂度”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U100|总结|188|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于查找教学；本书不铺陈通用数据结构与算法教程。|
|S13-U101|排序|189|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U102|本章目标|189|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U103|什么是排序|189|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“什么是排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U104|冒泡排序|190|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“冒泡排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U105|快速排序|197|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“快速排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U106|插入排序|201|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“插入排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U107|希尔排序|203|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“希尔排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U108|归并排序|205|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“归并排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U109|选择排序|208|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“选择排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U110|堆排序|209|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“堆排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U111|桶排序|213|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“桶排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U112|计数排序|216|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“计数排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U113|基数排序|218|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“基数排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U114|蒂姆排序|220|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“蒂姆排序”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U115|总结|236|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于排序教学；本书不铺陈通用数据结构与算法教程。|
|S13-U116|树|237|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U117|本章目标|237|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U118|什么是树|237|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“什么是树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U119|树的定义|240|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“树的定义”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U120|树的表示|241|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“树的表示”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U121|分析树|247|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“分析树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U122|树的遍历|248|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“树的遍历”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U123|二叉堆|257|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二叉堆”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U124|二叉堆的抽象数据类型|258|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二叉堆的抽象数据类型”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U125|Rust 实现二叉堆|258|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 实现二叉堆”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U126|二叉堆分析|266|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二叉堆分析”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U127|二叉查找树|266|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二叉查找树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U128|二叉查找树的抽象数据类型|266|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二叉查找树的抽象数据类型”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U129|Rust 实现二叉查找树|267|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 实现二叉查找树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U130|二叉查找树分析|282|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“二叉查找树分析”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U131|平衡二叉树|283|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“平衡二叉树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U132|AVL 平衡二叉树|283|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“AVL 平衡二叉树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U133|Rust 实现平衡二叉树|284|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Rust 实现平衡二叉树”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U134|平衡二叉树分析|300|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“平衡二叉树分析”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U135|总结|300|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于树教学；本书不铺陈通用数据结构与算法教程。|
|S13-U136|图|301|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“图”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U137|本章目标|301|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U138|什么是图|301|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“什么是图”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U139|图定义|302|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“图定义”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U140|图的存储形式|302|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u140`；“图的存储形式”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U141|邻接矩阵|303|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u141`；母本辅助节（邻接矩阵）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U142|邻接表|303|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u142`；母本辅助节（邻接表）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U143|图的抽象数据类型|304|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“图的抽象数据类型”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U144|图的实现|305|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“图的实现”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U145|字梯问题|314|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“字梯问题”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U146|广度优先搜索BFS|315|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“广度优先搜索BFS”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U147|实现广度优先搜索|316|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“实现广度优先搜索”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U148|广度优先搜索分析|327|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“广度优先搜索分析”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U149|骑士之旅|327|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“骑士之旅”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U150|深度优先搜索DFS|334|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“深度优先搜索DFS”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U151|实现深度优先搜索|336|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“实现深度优先搜索”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U152|深度优先搜索分析|340|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“深度优先搜索分析”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U153|拓扑排序|340|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“拓扑排序”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U154|强连通分量|349|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“强连通分量”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U155|BFS强连通分量算法|350|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“BFS强连通分量算法”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U156|DFS强连通分量算法|356|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“DFS强连通分量算法”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U157|最短路径问题|358|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“最短路径问题”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U158|Dijkstra算法|359|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Dijkstra算法”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U159|实现 Dijkstra算法|359|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“实现 Dijkstra算法”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U160|Dijkstra 算法分析|363|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Dijkstra 算法分析”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U161|总结|363|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于图教学；本书不铺陈通用数据结构与算法教程。|
|S13-U162|实战|364|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“实战”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U163|本章目标|364|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“本章目标”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U164|编辑距离|364|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“编辑距离”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U165|汉明距离|364|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“汉明距离”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U166|莱文斯坦距离|367|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“莱文斯坦距离”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U167|字典树|372|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“字典树”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U168|过滤器|375|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u168`；“过滤器”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U169|布隆过滤器|375|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u169`；母本辅助节（布隆过滤器）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U170|布谷鸟过滤器|379|excluded-reviewed / scope-only|—|`sources/reviews/S13.md#review-s13-u170`；母本辅助节（布谷鸟过滤器）；经核读范围确认属于非主线细分或工具链补充说明，Rust性能工程主线已在其核心章覆盖，故作明确范围排除。|
|S13-U171|缓存淘汰算法 LRU|385|read-mapped / scope-excerpt|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S13.md#review-s13-u171`；“缓存淘汰算法 LRU”涉及表示、分配、复杂度或局部性；仅据本轮范围抽页保留，等待测量/对象/优化专章，不用算法 O 记号代替机器成本。|
|S13-U172|一致性哈希算法|391|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“一致性哈希算法”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U173|Base58 编码|396|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“Base58 编码”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U174|区块链|404|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“区块链”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U175|区块链及比特币原理|405|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“区块链及比特币原理”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U176|基础区块链|405|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“基础区块链”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U177|总结|410|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；已核查“总结”的开篇/本章上下文，属于算法实战教学；本书不铺陈通用数据结构与算法教程。|
|S13-U178|书名页：数据结构与算法 Rust 语言描述|3|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；人工补充书名、前言小节或参考文献，属书目/范围说明，不冒充性能机制正文。|
|S13-U179|基本要求|4|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；人工补充书名、前言小节或参考文献，属书目/范围说明，不冒充性能机制正文。|
|S13-U180|全书结构|5|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；人工补充书名、前言小节或参考文献，属书目/范围说明，不冒充性能机制正文。|
|S13-U181|说明|6|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；人工补充书名、前言小节或参考文献，属书目/范围说明，不冒充性能机制正文。|
|S13-U182|致谢|6|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；人工补充书名、前言小节或参考文献，属书目/范围说明，不冒充性能机制正文。|
|S13-U183|参考文献|411|excluded-reviewed / scope-excerpt|—|`sources/reviews/S13.md`；人工补充书名、前言小节或参考文献，属书目/范围说明，不冒充性能机制正文。|

### S14 · rustdoc 手册.pdf {#coverage-s14}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S14-U001|什么是 rustdoc？|1|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u001`；已读“什么是 rustdoc？”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U002|基本使用|1|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u002`；已读“基本使用”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U003|配置 rustdoc|2|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u003`；已读“配置 rustdoc”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U004|通过 Cargo 使用 rustdoc|2|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u004`；已读“通过 Cargo 使用 rustdoc”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U005|Outer 和 inner 文档|3|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u005`；已读“Outer 和 inner 文档”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U006|利用单独的 Markdown 文件|3|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u006`；已读“利用单独的 Markdown 文件”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U007|总结|3|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“总结”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U008|如何阅读 rustdoc 的输出|4|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“如何阅读 rustdoc 的输出”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U009|结构|4|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“结构”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U010|Item 文档|4|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Item 文档”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U011|导航|4|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“导航”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U012|导航栏|4|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“导航栏”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U013|主题选择和搜索栏|5|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“主题选择和搜索栏”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U014|主题选择|5|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“主题选择”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U015|搜索栏|5|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“搜索栏”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U016|快捷键|5|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“快捷键”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U017|如何写文档|6|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u017`；已读“如何写文档”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U018|开始|6|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u018`；已读“开始”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U019|文档组成|7|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u019`；已读“文档组成”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U020|Markdown|8|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Markdown”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U021|Strikethrough（删除线）|9|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Strikethrough（删除线）”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U022|Footnotes（角标）|9|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Footnotes（角标）”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U023|Tables（表格）|9|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Tables（表格）”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U024|Task lists|10|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Task lists”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U025|Smart punctuation（标点符号）|10|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Smart punctuation（标点符号）”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U026|什么包含（和排除）|11|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u026`；已读“什么包含（和排除）”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U027|例子|11|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u027`；已读“例子”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U028|什么被排除|12|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u028`；已读“什么被排除”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U029|自定义输出|12|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“自定义输出”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U030|Command-line arguments|13|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u030`；已读“Command-line arguments”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U031|-h/--help: help|13|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“-h/--help: help”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U032|-V/--version: version information|13|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u032`；已读“-V/--version: version information”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U033|-v/--verbose: more verbose output|13|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u033`；已读“-v/--verbose: more verbose output”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U034|-o/--out-dir: output directory path|14|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u034`；已读“-o/--out-dir: output directory path”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U035|--crate-name: controlling the name of the crate|14|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u035`；已读“--crate-name: controlling the name of the crate”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U036|--document-private-items: Show items that are not public|14|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u036`；已读“--document-private-items: Show items that are not public”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U037|-L/--library-path: where to look for dependencies|15|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u037`；已读“-L/--library-path: where to look for dependencies”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U038|--cfg: passing configuration flags|15|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u038`；已读“--cfg: passing configuration flags”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U039|--extern: specify a dependency's location|15|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u039`；已读“--extern: specify a dependency's location”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U040|-C/--codegen: pass codegen options to rustc|16|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u040`；已读“-C/--codegen: pass codegen options to rustc”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U041|--test: run code examples as tests|16|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u041`；已读“--test: run code examples as tests”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U042|--test-args: pass options to test runner|16|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u042`；已读“--test-args: pass options to test runner”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U043|--target: generate documentation for the specified target triple|17|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u043`；已读“--target: generate documentation for the specified target triple”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U044|--default-theme: set the default theme|17|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--default-theme: set the default theme”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U045|--markdown-css: include more CSS files when rendering markdown|17|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--markdown-css: include more CSS files when rendering markdown”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U046|--html-in-header: include more HTML in|18|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--html-in-header: include more HTML in”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U047|--html-before-content: include more HTML before the content|18|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--html-before-content: include more HTML before the content”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U048|--html-after-content: include more HTML after the content|18|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--html-after-content: include more HTML after the content”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U049|--markdown-playground-url: control the location of the playground|19|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--markdown-playground-url: control the location of the playground”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U050|--markdown-no-toc: don't generate a table of contents|19|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--markdown-no-toc: don't generate a table of contents”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U051|-e/--extend-css: extend rustdoc's CSS|19|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“-e/--extend-css: extend rustdoc's CSS”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U052|--sysroot: override the system root|19|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u052`；已读“--sysroot: override the system root”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U053|--edition: control the edition of docs and doctests|20|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u053`；已读“--edition: control the edition of docs and doctests”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U054|--theme: add a theme to the documentation output|20|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--theme: add a theme to the documentation output”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U055|--check-theme: verify custom themes against the default theme|20|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--check-theme: verify custom themes against the default theme”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U056|--crate-version: control the crate version|21|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u056`；已读“--crate-version: control the crate version”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U057|@path: load command-line flags from a path|21|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u057`；已读“@path: load command-line flags from a path”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U058|--passes: add more rustdoc passes|21|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；正文明确旧 passes/input-format 已弃用或无效；保留原条目作为版本风险，不教读者依赖历史流水线。|
|S14-U059|--no-defaults: don't run default passes|21|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；正文明确旧 passes/input-format 已弃用或无效；保留原条目作为版本风险，不教读者依赖历史流水线。|
|S14-U060|-r/--input-format: input format|21|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；正文明确旧 passes/input-format 已弃用或无效；保留原条目作为版本风险，不教读者依赖历史流水线。|
|S14-U061|--nocapture|21|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u061`；已读“--nocapture”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U062|#[doc] 属性|23|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u062`；已读“#[doc] 属性”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U063|crate 层面|23|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u063`；已读“crate 层面”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U064|html_favicon_url|23|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“html_favicon_url”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U065|html_logo_url|24|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“html_logo_url”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U066|html_playground_url|24|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“html_playground_url”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U067|issue_tracker_base_url|24|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“issue_tracker_base_url”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U068|html_root_url|24|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u068`；已读“html_root_url”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U069|html_no_source|25|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u069`；已读“html_no_source”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U070|test(no_crate_inject)|25|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u070`；已读“test(no_crate_inject)”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U071|test(attr(...))|25|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u071`；已读“test(attr(...))”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U072|item 层面|25|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u072`；已读“item 层面”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U073|inline and no_inline|25|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u073`；已读“inline and no_inline”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U074|hidden|26|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u074`；已读“hidden”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U075|alias|27|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u075`；已读“alias”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U076|文档测试|28|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u076`；已读“文档测试”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U077|文档测试通过或者失败|28|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u077`；已读“文档测试通过或者失败”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U078|预处理例子|29|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u078`；已读“预处理例子”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U079|隐藏例子的一部分|29|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u079`；已读“隐藏例子的一部分”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U080|在文档测试中使用 ?|31|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u080`；已读“在文档测试中使用 ?”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U081|在文档测试中显示警告|32|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u081`；已读“在文档测试中显示警告”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U082|宏的文档|32|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u082`；已读“宏的文档”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U083|属性|33|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u083`；已读“属性”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U084|语法参考|34|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u084`；已读“语法参考”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U085|收集文档测试时包含 item|34|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u085`；已读“收集文档测试时包含 item”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U086|通过名称链接 item|36|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u086`；已读“通过名称链接 item”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U087|有效链接|36|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u087`；已读“有效链接”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U088|Namespaces and Disambiguators（消歧义符）|37|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u088`；已读“Namespaces and Disambiguators（消歧义符）”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U089|警告，re-exports, and scoping|38|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u089`；已读“警告，re-exports, and scoping”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U090|Lints|39|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u090`；已读“Lints”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U091|broken_intra_doc_links|39|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u091`；已读“broken_intra_doc_links”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U092|private_intra_doc_links|40|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u092`；已读“private_intra_doc_links”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U093|missing_docs|41|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u093`；已读“missing_docs”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U094|missing_crate_level_docs|41|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u094`；已读“missing_crate_level_docs”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U095|missing_doc_code_examples|42|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u095`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U096|private_doc_tests|42|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u096`；已读“private_doc_tests”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U097|invalid_codeblock_attributes|43|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u097`；已读“invalid_codeblock_attributes”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U098|invalid_html_tags|43|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u098`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U099|invalid_rust_codeblocks|44|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u099`；已读“invalid_rust_codeblocks”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U100|bare_urls|45|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u100`；已读“bare_urls”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U101|高级特性|46|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u101`；已读“高级特性”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U102|#[cfg(doc)]: 文档平台相关或者特性相关信息|46|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u102`；已读“#[cfg(doc)]: 文档平台相关或者特性相关信息”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U103|特定平台文档之间的交互|46|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u103`；已读“特定平台文档之间的交互”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U104|增加文档搜索的 item 别名|47|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u104`；已读“增加文档搜索的 item 别名”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U105|不稳定特性|48|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u105`；已读“不稳定特性”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U106|Nightly-gated functionality|48|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u106`；已读“Nightly-gated functionality”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U107|Error numbers for compile-fail doctests|48|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u107`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U108|Extensions to the #[doc] attribute|48|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u108`；已读“Extensions to the #[doc] attribute”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U109|#[doc(cfg)]: Recording what platforms or features are required for code to be present|49|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u109`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U110|doc_auto_cfg: Automatically generate #[doc(cfg)]|49|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u110`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U111|Adding your trait to the "Notable traits" dialog|50|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；Notable traits、masked、primitive、keyword 或强制不稳定标记偏标准库/编译器内部文档设施；当前性能书不实现 rustdoc 内部文档管线。|
|S14-U112|Exclude certain dependencies from documentation|51|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；Notable traits、masked、primitive、keyword 或强制不稳定标记偏标准库/编译器内部文档设施；当前性能书不实现 rustdoc 内部文档管线。|
|S14-U113|Document primitives|51|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；Notable traits、masked、primitive、keyword 或强制不稳定标记偏标准库/编译器内部文档设施；当前性能书不实现 rustdoc 内部文档管线。|
|S14-U114|Document keywords|51|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；Notable traits、masked、primitive、keyword 或强制不稳定标记偏标准库/编译器内部文档设施；当前性能书不实现 rustdoc 内部文档管线。|
|S14-U115|Unstable command-line arguments|52|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u115`；已读“Unstable command-line arguments”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U116|--markdown-before-content: include rendered Markdown before the content|52|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--markdown-before-content: include rendered Markdown before the content”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U117|--markdown-after-content: include rendered Markdown after the content|52|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--markdown-after-content: include rendered Markdown after the content”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U118|--playground-url: control the location of the playground|52|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--playground-url: control the location of the playground”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U119|--sort-modules-by-appearance: control how items on module pages are sorted|53|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--sort-modules-by-appearance: control how items on module pages are sorted”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U120|--show-type-layout: add a section to each type's docs describing its memory layout|53|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u120`；已读 --show-type-layout 的不稳定布局警告；这是固定 rustc 观测而非 ABI 承诺，待对象章真实产物对照，不假称已运行该选项。|
|S14-U121|--resource-suffix: modifying the name of CSS/JavaScript in crate docs|53|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--resource-suffix: modifying the name of CSS/JavaScript in crate docs”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U122|--extern-html-root-url: control how rustdoc links to non-local crates|54|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u122`；已读“--extern-html-root-url: control how rustdoc links to non-local crates”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|
|S14-U123|-Z force-unstable-if-unmarked|54|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；Notable traits、masked、primitive、keyword 或强制不稳定标记偏标准库/编译器内部文档设施；当前性能书不实现 rustdoc 内部文档管线。|
|S14-U124|--index-page: provide a top-level landing page for docs|54|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--index-page: provide a top-level landing page for docs”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U125|--enable-index-page: generate a default index page for docs|55|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--enable-index-page: generate a default index page for docs”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U126|--static-root-path: control how static files are loaded in HTML output|55|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“--static-root-path: control how static files are loaded in HTML output”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U127|--persist-doctests: persist doctest executables after running|55|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u127`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U128|--show-coverage: calculate the percentage of items with documentation|55|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u128`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U129|-w/--output-format: output format|57|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u129`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U130|--enable-per-target-ignores: allow ignore-foo style filters for doctests|57|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u130`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U131|--runtool, --runtool-arg: program to run tests with; args to pass to it|58|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u131`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U132|--with-examples: include examples of uses of items as documentation|58|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u132`；已读该 PDF 对 nightly/不稳定门禁的说明；快照稳定性不能当当前工具链事实，待 ch14 固定版本验证与落点。|
|S14-U133|Website 特性|59|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“Website 特性”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U134|自定义搜索引擎|59|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“自定义搜索引擎”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U135|Passes|60|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；正文明确旧 passes/input-format 已弃用或无效；保留原条目作为版本风险，不教读者依赖历史流水线。|
|S14-U136|References|61|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“References”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U137|官方|61|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“官方”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U138|社区|61|excluded-reviewed / body-text|—|`sources/reviews/S14.md`；已读“社区”正文；属 Markdown 排版、搜索/主题展示、文档站点装饰或参考索引，不展开成底层性能章节。|
|S14-U139|FFI 例子|27|read-mapped / body-text|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S14.md#review-s14-u139`；已读 FFI alias 搜索示例；它只改善发现性，不证明裸指针包装 soundness，待 FFI 项目的 API 文档落点。|
|S14-U140|JSON output|57|read-mapped / body-text|[part4/ch14.md#sec-cpp-rust.4.14.7](../part4/ch14.md#sec-cpp-rust.4.14.7)|`sources/reviews/S14.md#review-s14-u140`；已读“JSON output”正文，涉及文档构建、API 可见性、doctest 或质量门禁；应落 Cargo/CI，但 ch14 尚不存在，未制造 target。|

### S15 · C语言程序设计：现代方法（第2版•修订版） (K.N.King) (z-library.sk, 1lib.sk, z-lib.sk).pdf {#coverage-s15}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S15-U0001|封面|1|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0001`；C/C++ 或辅助构建通用内容（封面）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0002|作译者简介|2|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0002`；C/C++ 或辅助构建通用内容（作译者简介）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0003|数字版权声明|3|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0003`；C/C++ 或辅助构建通用内容（数字版权声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0004|扉页|4|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0004`；C/C++ 或辅助构建通用内容（扉页）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0005|版权页|5|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0005`；C/C++ 或辅助构建通用内容（版权页）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0006|新世纪的C语言“万宝全书”|6|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0006`；C/C++ 或辅助构建通用内容（新世纪的C语言“万宝全书”）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0007|第2版前言|8|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0007`；C/C++ 或辅助构建通用内容（第2版前言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0008|目录|14|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0008`；C/C++ 或辅助构建通用内容（目录）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0009|第1章　C语言概述|22|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0009`；C/C++ 或辅助构建通用内容（第1章　C语言概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0010|1.1　C语言的历史|22|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0010`；C/C++ 或辅助构建通用内容（1.1　C语言的历史）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0011|1.1.1　起源|22|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0011`；C/C++ 或辅助构建通用内容（1.1.1　起源）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0012|1.1.2　标准化|22|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0012`；C/C++ 或辅助构建通用内容（1.1.2　标准化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0013|1.1.3　基于C的语言|23|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0013`；C/C++ 或辅助构建通用内容（1.1.3　基于C的语言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0014|1.2　C语言的优缺点|24|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0014`；C/C++ 或辅助构建通用内容（1.2　C语言的优缺点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0015|1.2.1　C语言的优点|24|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0015`；C/C++ 或辅助构建通用内容（1.2.1　C语言的优点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0016|1.2.2　C语言的缺点|25|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0016`；C/C++ 或辅助构建通用内容（1.2.2　C语言的缺点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0017|1.2.3　高效地使用C语言|26|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0017`；C/C++ 或辅助构建通用内容（1.2.3　高效地使用C语言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0018|问与答|26|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0018`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0019|第2章　C语言基本概念|28|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0019`；C/C++ 或辅助构建通用内容（第2章　C语言基本概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0020|2.1　编写一个简单的C程序|28|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0020`；C/C++ 或辅助构建通用内容（2.1　编写一个简单的C程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0021|2.1.1　编译和链接|29|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0021`；C/C++ 或辅助构建通用内容（2.1.1　编译和链接）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0022|2.1.2　集成开发环境|30|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0022`；C/C++ 或辅助构建通用内容（2.1.2　集成开发环境）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0023|2.2　简单程序的一般形式|30|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0023`；C/C++ 或辅助构建通用内容（2.2　简单程序的一般形式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0024|2.2.1　指令|30|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0024`；C/C++ 或辅助构建通用内容（2.2.1　指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0025|2.2.2　函数|30|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0025`；C/C++ 或辅助构建通用内容（2.2.2　函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0026|2.2.3　语句|31|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0026`；C/C++ 或辅助构建通用内容（2.2.3　语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0027|2.2.4　显示字符串|32|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0027`；C/C++ 或辅助构建通用内容（2.2.4　显示字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0028|2.3　注释|32|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0028`；C/C++ 或辅助构建通用内容（2.3　注释）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0029|2.4　变量和赋值|34|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0029`；C/C++ 或辅助构建通用内容（2.4　变量和赋值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0030|2.4.1　类型|34|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0030`；C/C++ 或辅助构建通用内容（2.4.1　类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0031|2.4.2　声明|34|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0031`；C/C++ 或辅助构建通用内容（2.4.2　声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0032|2.4.3　赋值|35|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0032`；C/C++ 或辅助构建通用内容（2.4.3　赋值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0033|2.4.4　显示变量的值|36|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0033`；C/C++ 或辅助构建通用内容（2.4.4　显示变量的值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0034|2.4.5　初始化|37|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0034`；C/C++ 或辅助构建通用内容（2.4.5　初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0035|2.4.6　显示表达式的值|38|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0035`；C/C++ 或辅助构建通用内容（2.4.6　显示表达式的值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0036|2.5　读入输入|38|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0036`；C/C++ 或辅助构建通用内容（2.5　读入输入）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0037|2.6　定义常量的名字|39|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0037`；C/C++ 或辅助构建通用内容（2.6　定义常量的名字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0038|2.7　标识符|40|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0038`；C/C++ 或辅助构建通用内容（2.7　标识符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0039|关键字|41|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0039`；C/C++ 或辅助构建通用内容（关键字）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0040|2.8　C程序的书写规范|42|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0040`；C/C++ 或辅助构建通用内容（2.8　C程序的书写规范）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0041|问与答|44|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0041`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0042|练习题|46|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0042`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0043|编程题|47|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0043`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0044|第3章　格式化输入/输出|49|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0044`；C/C++ 或辅助构建通用内容（第3章　格式化输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0045|3.1　printf函数|49|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0045`；C/C++ 或辅助构建通用内容（3.1　printf函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0046|3.1.1　转换说明|50|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0046`；C/C++ 或辅助构建通用内容（3.1.1　转换说明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0047|3.1.2　转义序列|52|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0047`；C/C++ 或辅助构建通用内容（3.1.2　转义序列）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0048|3.2　scanf函数|52|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0048`；C/C++ 或辅助构建通用内容（3.2　scanf函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0049|3.2.1　scanf函数的工作方法|53|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0049`；C/C++ 或辅助构建通用内容（3.2.1　scanf函数的工作方法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0050|3.2.2　格式串中的普通字符|55|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0050`；C/C++ 或辅助构建通用内容（3.2.2　格式串中的普通字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0051|3.2.3　易混淆的printf函数和scanf函数|55|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0051`；C/C++ 或辅助构建通用内容（3.2.3　易混淆的printf函数和scanf函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0052|问与答|56|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0052`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0053|练习题|58|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0053`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0054|编程题|59|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0054`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0055|第4章　表达式|61|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0055`；C/C++ 或辅助构建通用内容（第4章　表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0056|4.1　算术运算符|61|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0056`；C/C++ 或辅助构建通用内容（4.1　算术运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0057|运算符的优先级和结合性|62|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0057`；C/C++ 或辅助构建通用内容（运算符的优先级和结合性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0058|4.2　赋值运算符|65|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0058`；C/C++ 或辅助构建通用内容（4.2　赋值运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0059|4.2.1　简单赋值|65|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0059`；C/C++ 或辅助构建通用内容（4.2.1　简单赋值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0060|4.2.2　左值|66|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0060`；C/C++ 或辅助构建通用内容（4.2.2　左值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0061|4.2.3　复合赋值|66|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0061`；C/C++ 或辅助构建通用内容（4.2.3　复合赋值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0062|4.3　自增运算符和自减运算符|67|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0062`；C/C++ 或辅助构建通用内容（4.3　自增运算符和自减运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0063|4.4　表达式求值|68|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0063`；C/C++ 或辅助构建通用内容（4.4　表达式求值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0064|子表达式的求值顺序|69|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0064`；C/C++ 或辅助构建通用内容（子表达式的求值顺序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0065|4.5　表达式语句|71|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0065`；C/C++ 或辅助构建通用内容（4.5　表达式语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0066|问与答|71|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0066`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0067|练习题|73|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0067`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0068|编程题|75|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0068`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0069|第5章　选择语句|77|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0069`；C/C++ 或辅助构建通用内容（第5章　选择语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0070|5.1　逻辑表达式|77|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0070`；C/C++ 或辅助构建通用内容（5.1　逻辑表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0071|5.1.1　关系运算符|77|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0071`；C/C++ 或辅助构建通用内容（5.1.1　关系运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0072|5.1.2　判等运算符|78|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0072`；C/C++ 或辅助构建通用内容（5.1.2　判等运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0073|5.1.3　逻辑运算符|78|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0073`；C/C++ 或辅助构建通用内容（5.1.3　逻辑运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0074|5.2　if语句|79|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0074`；C/C++ 或辅助构建通用内容（5.2　if语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0075|5.2.1　复合语句|80|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0075`；C/C++ 或辅助构建通用内容（5.2.1　复合语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0076|5.2.2　else子句|80|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0076`；C/C++ 或辅助构建通用内容（5.2.2　else子句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0077|5.2.3　级联式if语句|82|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0077`；C/C++ 或辅助构建通用内容（5.2.3　级联式if语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0078|5.2.4　“悬空else”的问题|84|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0078`；C/C++ 或辅助构建通用内容（5.2.4　“悬空else”的问题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0079|5.2.5　条件表达式|84|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0079`；C/C++ 或辅助构建通用内容（5.2.5　条件表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0080|5.2.6　C89中的布尔值|85|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0080`；C/C++ 或辅助构建通用内容（5.2.6　C89中的布尔值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0081|5.2.7　C99中的布尔值|86|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0081`；C/C++ 或辅助构建通用内容（5.2.7　C99中的布尔值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0082|5.3　switch语句|87|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0082`；C/C++ 或辅助构建通用内容（5.3　switch语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0083|break语句的作用|89|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0083`；C/C++ 或辅助构建通用内容（break语句的作用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0084|问与答|90|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0084`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0085|练习题|93|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0085`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0086|编程题|95|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0086`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0087|第6章　循环|98|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0087`；C/C++ 或辅助构建通用内容（第6章　循环）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0088|6.1　while语句|98|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0088`；C/C++ 或辅助构建通用内容（6.1　while语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0089|无限循环|100|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0089`；C/C++ 或辅助构建通用内容（无限循环）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0090|6.2　do语句|101|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0090`；C/C++ 或辅助构建通用内容（6.2　do语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0091|6.3　for语句|103|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0091`；C/C++ 或辅助构建通用内容（6.3　for语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0092|6.3.1　for语句的惯用法|104|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0092`；C/C++ 或辅助构建通用内容（6.3.1　for语句的惯用法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0093|6.3.2　在for语句中省略表达式|104|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0093`；C/C++ 或辅助构建通用内容（6.3.2　在for语句中省略表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0094|6.3.3　C99中的for语句|105|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0094`；C/C++ 或辅助构建通用内容（6.3.3　C99中的for语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0095|6.3.4　逗号运算符|105|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0095`；C/C++ 或辅助构建通用内容（6.3.4　逗号运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0096|6.4　退出循环|107|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0096`；C/C++ 或辅助构建通用内容（6.4　退出循环）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0097|6.4.1　break语句|108|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0097`；C/C++ 或辅助构建通用内容（6.4.1　break语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0098|6.4.2　continue语句|108|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0098`；C/C++ 或辅助构建通用内容（6.4.2　continue语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0099|6.4.3　goto语句|109|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0099`；C/C++ 或辅助构建通用内容（6.4.3　goto语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0100|6.5　空语句|111|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0100`；C/C++ 或辅助构建通用内容（6.5　空语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0101|问与答|113|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0101`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0102|练习题|115|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0102`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0103|编程题|116|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0103`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0104|第7章　基本类型|118|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0104`；C/C++ 或辅助构建通用内容（第7章　基本类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0105|7.1　整数类型|118|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0105`；C/C++ 或辅助构建通用内容（7.1　整数类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0106|7.1.1　C99中的整数类型|120|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0106`；C/C++ 或辅助构建通用内容（7.1.1　C99中的整数类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0107|7.1.2　整型常量|120|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0107`；C/C++ 或辅助构建通用内容（7.1.2　整型常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0108|7.1.3　C99中的整型常量|121|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0108`；C/C++ 或辅助构建通用内容（7.1.3　C99中的整型常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0109|7.1.4　整数溢出|121|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0109`；C/C++ 或辅助构建通用内容（7.1.4　整数溢出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0110|7.1.5　读/写整数|122|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0110`；C/C++ 或辅助构建通用内容（7.1.5　读/写整数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0111|7.2　浮点类型|123|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0111`；C/C++ 或辅助构建通用内容（7.2　浮点类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0112|7.2.1　浮点常量|124|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0112`；C/C++ 或辅助构建通用内容（7.2.1　浮点常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0113|7.2.2　读/写浮点数|124|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0113`；C/C++ 或辅助构建通用内容（7.2.2　读/写浮点数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0114|7.3　字符类型|125|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0114`；C/C++ 或辅助构建通用内容（7.3　字符类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0115|7.3.1　字符操作|125|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0115`；C/C++ 或辅助构建通用内容（7.3.1　字符操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0116|7.3.2　有符号字符和无符号字符|126|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0116`；C/C++ 或辅助构建通用内容（7.3.2　有符号字符和无符号字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0117|7.3.3　算术类型|126|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0117`；C/C++ 或辅助构建通用内容（7.3.3　算术类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0118|7.3.4　转义序列|127|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0118`；C/C++ 或辅助构建通用内容（7.3.4　转义序列）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0119|7.3.5　字符处理函数|128|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0119`；C/C++ 或辅助构建通用内容（7.3.5　字符处理函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0120|7.3.6　用scanf和printf读/写字符|129|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0120`；C/C++ 或辅助构建通用内容（7.3.6　用scanf和printf读/写字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0121|7.3.7　用getchar和putchar读/写字符|129|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0121`；C/C++ 或辅助构建通用内容（7.3.7　用getchar和putchar读/写字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0122|7.4　类型转换|131|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0122`；C/C++ 或辅助构建通用内容（7.4　类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0123|7.4.1　常规算术转换|132|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0123`；C/C++ 或辅助构建通用内容（7.4.1　常规算术转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0124|7.4.2　赋值过程中的转换|133|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0124`；C/C++ 或辅助构建通用内容（7.4.2　赋值过程中的转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0125|7.4.3　C99中的隐式转换|134|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0125`；C/C++ 或辅助构建通用内容（7.4.3　C99中的隐式转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0126|7.4.4　强制类型转换|135|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0126`；C/C++ 或辅助构建通用内容（7.4.4　强制类型转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0127|7.5　类型定义|136|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0127`；C/C++ 或辅助构建通用内容（7.5　类型定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0128|7.5.1　类型定义的优点|136|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0128`；C/C++ 或辅助构建通用内容（7.5.1　类型定义的优点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0129|7.5.2　类型定义和可移植性|137|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0129`；C/C++ 或辅助构建通用内容（7.5.2　类型定义和可移植性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0130|7.6　sizeof运算符|138|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0130`；C/C++ 或辅助构建通用内容（7.6　sizeof运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0131|问与答|138|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0131`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0132|练习题|141|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0132`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0133|编程题|142|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0133`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0134|第8章　数组|145|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0134`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0135|8.1　一维数组|145|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0135`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0136|8.1.1　数组下标|145|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0136`；C/C++ 或辅助构建通用内容（8.1.1　数组下标）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0137|8.1.2　数组初始化|147|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0137`；C/C++ 或辅助构建通用内容（8.1.2　数组初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0138|8.1.3　指示器|148|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0138`；C/C++ 或辅助构建通用内容（8.1.3　指示器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0139|8.1.4　对数组使用sizeof运算符|150|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0139`；C/C++ 或辅助构建通用内容（8.1.4　对数组使用sizeof运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0140|8.2　多维数组|151|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0140`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0141|8.2.1　多维数组初始化|152|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0141`；C/C++ 或辅助构建通用内容（8.2.1　多维数组初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0142|8.2.2　常量数组|153|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0142`；C/C++ 或辅助构建通用内容（8.2.2　常量数组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0143|8.3　C99中的变长数组|155|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0143`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0144|问与答|156|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0144`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0145|练习题|157|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0145`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0146|编程题|159|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0146`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0147|第9章　函数|162|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0147`；C/C++ 或辅助构建通用内容（第9章　函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0148|9.1　函数的定义和调用|162|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0148`；C/C++ 或辅助构建通用内容（9.1　函数的定义和调用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0149|9.1.1　函数定义|165|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0149`；C/C++ 或辅助构建通用内容（9.1.1　函数定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0150|9.1.2　函数调用|166|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0150`；C/C++ 或辅助构建通用内容（9.1.2　函数调用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0151|9.2　函数声明|168|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0151`；C/C++ 或辅助构建通用内容（9.2　函数声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0152|9.3　实际参数|170|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0152`；C/C++ 或辅助构建通用内容（9.3　实际参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0153|9.3.1　实际参数的转换|171|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0153`；C/C++ 或辅助构建通用内容（9.3.1　实际参数的转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0154|9.3.2　数组型实际参数|172|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0154`；C/C++ 或辅助构建通用内容（9.3.2　数组型实际参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0155|9.3.3　变长数组形式参数|174|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0155`；C/C++ 或辅助构建通用内容（9.3.3　变长数组形式参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0156|9.3.4　在数组参数声明中使用static|175|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0156`；C/C++ 或辅助构建通用内容（9.3.4　在数组参数声明中使用static）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0157|9.3.5　复合字面量|176|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0157`；C/C++ 或辅助构建通用内容（9.3.5　复合字面量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0158|9.4　return语句|176|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0158`；C/C++ 或辅助构建通用内容（9.4　return语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0159|9.5　程序终止|177|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0159`；C/C++ 或辅助构建通用内容（9.5　程序终止）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0160|exit函数|178|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0160`；C/C++ 或辅助构建通用内容（exit函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0161|9.6　递归|178|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0161`；C/C++ 或辅助构建通用内容（9.6　递归）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0162|快速排序算法|179|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0162`；C/C++ 或辅助构建通用内容（快速排序算法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0163|9.7　泛型选择|182|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0163`；C/C++ 或辅助构建通用内容（9.7　泛型选择）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0164|问与答|184|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0164`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0165|练习题|187|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0165`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0166|编程题|190|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0166`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0167|第10章　程序结构|192|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0167`；C/C++ 或辅助构建通用内容（第10章　程序结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0168|10.1　局部变量|192|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0168`；C/C++ 或辅助构建通用内容（10.1　局部变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0169|10.1.1　静态局部变量|193|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0169`；C/C++ 或辅助构建通用内容（10.1.1　静态局部变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0170|10.1.2　形式参数|193|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0170`；C/C++ 或辅助构建通用内容（10.1.2　形式参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0171|10.2　外部变量|193|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0171`；C/C++ 或辅助构建通用内容（10.2　外部变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0172|10.2.1　示例：用外部变量实现栈|193|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0172`；C/C++ 或辅助构建通用内容（10.2.1　示例：用外部变量实现栈）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0173|10.2.2　外部变量的利与弊|194|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0173`；C/C++ 或辅助构建通用内容（10.2.2　外部变量的利与弊）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0174|10.3　程序块|198|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0174`；C/C++ 或辅助构建通用内容（10.3　程序块）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0175|10.4　作用域|199|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0175`；C/C++ 或辅助构建通用内容（10.4　作用域）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0176|10.5　构建C程序|200|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S15.md#review-s15-u0176`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S15-U0177|问与答|206|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0177`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0178|练习题|206|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0178`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0179|编程题|207|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0179`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0180|第11章　指针|209|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0180`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0181|11.1　指针变量|209|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0181`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0182|指针变量的声明|210|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0182`；C/C++ 或辅助构建通用内容（指针变量的声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0183|11.2　取地址运算符和间接寻址运算符|210|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0183`；C/C++ 或辅助构建通用内容（11.2　取地址运算符和间接寻址运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0184|11.2.1　取地址运算符|210|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0184`；C/C++ 或辅助构建通用内容（11.2.1　取地址运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0185|11.2.2　间接寻址运算符|211|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0185`；C/C++ 或辅助构建通用内容（11.2.2　间接寻址运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0186|11.3　指针赋值|212|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0186`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0187|11.4　指针作为参数|213|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0187`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0188|用const保护参数|216|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0188`；C/C++ 或辅助构建通用内容（用const保护参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0189|11.5　指针作为返回值|216|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0189`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0190|问与答|217|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0190`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0191|练习题|219|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0191`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0192|编程题|220|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0192`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0193|第12章　指针和数组|222|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0193`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0194|12.1　指针的算术运算|222|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0194`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0195|12.1.1　指针加上整数|223|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0195`；C/C++ 或辅助构建通用内容（12.1.1　指针加上整数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0196|12.1.2　指针减去整数|223|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0196`；C/C++ 或辅助构建通用内容（12.1.2　指针减去整数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0197|12.1.3　两个指针相减|224|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0197`；C/C++ 或辅助构建通用内容（12.1.3　两个指针相减）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0198|12.1.4　指针比较|224|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0198`；C/C++ 或辅助构建通用内容（12.1.4　指针比较）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0199|12.1.5　指向复合字面量的指针|224|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0199`；C/C++ 或辅助构建通用内容（12.1.5　指向复合字面量的指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0200|12.2　指针用于数组处理|225|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0200`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0201|*运算符和++运算符的组合|225|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0201`；C/C++ 或辅助构建通用内容（*运算符和++运算符的组合）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0202|12.3　用数组名作为指针|227|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0202`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0203|12.3.1　数组型实际参数（改进版）|228|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0203`；C/C++ 或辅助构建通用内容（12.3.1　数组型实际参数（改进版））；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0204|12.3.2　用指针作为数组名|229|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0204`；C/C++ 或辅助构建通用内容（12.3.2　用指针作为数组名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0205|12.4　指针和多维数组|230|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0205`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0206|12.4.1　处理多维数组的元素|230|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0206`；C/C++ 或辅助构建通用内容（12.4.1　处理多维数组的元素）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0207|12.4.2　处理多维数组的行|231|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0207`；C/C++ 或辅助构建通用内容（12.4.2　处理多维数组的行）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0208|12.4.3　处理多维数组的列|231|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0208`；C/C++ 或辅助构建通用内容（12.4.3　处理多维数组的列）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0209|12.4.4　用多维数组名作为指针|231|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0209`；C/C++ 或辅助构建通用内容（12.4.4　用多维数组名作为指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0210|12.5　C99中的指针和变长数组|232|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0210`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0211|问与答|233|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0211`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0212|练习题|234|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0212`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0213|编程题|236|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0213`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0214|第13章　字符串|238|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0214`；C/C++ 或辅助构建通用内容（第13章　字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0215|13.1　字面串|238|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0215`；C/C++ 或辅助构建通用内容（13.1　字面串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0216|13.1.1　字面串中的转义序列|238|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0216`；C/C++ 或辅助构建通用内容（13.1.1　字面串中的转义序列）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0217|13.1.2　延续字面串|239|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0217`；C/C++ 或辅助构建通用内容（13.1.2　延续字面串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0218|13.1.3　如何存储字面串|239|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0218`；C/C++ 或辅助构建通用内容（13.1.3　如何存储字面串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0219|13.1.4　字面串的操作|240|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0219`；C/C++ 或辅助构建通用内容（13.1.4　字面串的操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0220|13.1.5　字面串与字符常量|240|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0220`；C/C++ 或辅助构建通用内容（13.1.5　字面串与字符常量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0221|13.2　字符串变量|241|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0221`；C/C++ 或辅助构建通用内容（13.2　字符串变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0222|13.2.1　初始化字符串变量|241|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0222`；C/C++ 或辅助构建通用内容（13.2.1　初始化字符串变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0223|13.2.2　字符数组与字符指针|242|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0223`；C/C++ 或辅助构建通用内容（13.2.2　字符数组与字符指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0224|13.3　字符串的读和写|243|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0224`；C/C++ 或辅助构建通用内容（13.3　字符串的读和写）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0225|13.3.1　用printf函数和puts函数写字符串|243|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0225`；C/C++ 或辅助构建通用内容（13.3.1　用printf函数和puts函数写字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0226|13.3.2　用scanf函数读字符串|244|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0226`；C/C++ 或辅助构建通用内容（13.3.2　用scanf函数读字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0227|13.3.3　逐个字符读字符串|245|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0227`；C/C++ 或辅助构建通用内容（13.3.3　逐个字符读字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0228|13.4　访问字符串中的字符|246|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0228`；C/C++ 或辅助构建通用内容（13.4　访问字符串中的字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0229|13.5　使用C语言的字符串库|247|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0229`；C/C++ 或辅助构建通用内容（13.5　使用C语言的字符串库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0230|13.5.1　strcpy函数|247|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0230`；C/C++ 或辅助构建通用内容（13.5.1　strcpy函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0231|13.5.2　strlen函数|248|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0231`；C/C++ 或辅助构建通用内容（13.5.2　strlen函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0232|13.5.3　strcat函数|249|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0232`；C/C++ 或辅助构建通用内容（13.5.3　strcat函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0233|13.5.4　strcmp函数|250|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0233`；C/C++ 或辅助构建通用内容（13.5.4　strcmp函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0234|13.6　字符串惯用法|252|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0234`；C/C++ 或辅助构建通用内容（13.6　字符串惯用法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0235|13.6.1　搜索字符串的结尾|253|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0235`；C/C++ 或辅助构建通用内容（13.6.1　搜索字符串的结尾）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0236|13.6.2　复制字符串|254|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0236`；C/C++ 或辅助构建通用内容（13.6.2　复制字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0237|13.7　字符串数组|256|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0237`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0238|命令行参数|257|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0238`；C/C++ 或辅助构建通用内容（命令行参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0239|问与答|259|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0239`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0240|练习题|262|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0240`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0241|编程题|264|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0241`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0242|第14章　预处理器|267|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0242`；C/C++ 或辅助构建通用内容（第14章　预处理器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0243|14.1　预处理器的工作原理|267|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0243`；C/C++ 或辅助构建通用内容（14.1　预处理器的工作原理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0244|14.2　预处理指令|269|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0244`；C/C++ 或辅助构建通用内容（14.2　预处理指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0245|14.3　宏定义|269|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0245`；C/C++ 或辅助构建通用内容（14.3　宏定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0246|14.3.1　简单的宏 |270|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0246`；C/C++ 或辅助构建通用内容（14.3.1　简单的宏 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0247|14.3.2　带参数的宏 |271|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0247`；C/C++ 或辅助构建通用内容（14.3.2　带参数的宏 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0248|14.3.3　#运算符 |273|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0248`；C/C++ 或辅助构建通用内容（14.3.3　#运算符 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0249|14.3.4　##运算符 |274|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0249`；C/C++ 或辅助构建通用内容（14.3.4　##运算符 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0250|14.3.5　宏的通用属性 |275|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0250`；C/C++ 或辅助构建通用内容（14.3.5　宏的通用属性 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0251|14.3.6　宏定义中的圆括号 |275|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0251`；C/C++ 或辅助构建通用内容（14.3.6　宏定义中的圆括号 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0252|14.3.7　创建较长的宏 |276|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0252`；C/C++ 或辅助构建通用内容（14.3.7　创建较长的宏 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0253|14.3.8　预定义宏 |277|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0253`；C/C++ 或辅助构建通用内容（14.3.8　预定义宏 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0254|14.3.9　C99中新增的预定义宏|278|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0254`；C/C++ 或辅助构建通用内容（14.3.9　C99中新增的预定义宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0255|14.3.10　空的宏参数|279|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0255`；C/C++ 或辅助构建通用内容（14.3.10　空的宏参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0256|14.3.11　参数个数可变的宏|280|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0256`；C/C++ 或辅助构建通用内容（14.3.11　参数个数可变的宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0257|14.3.12　__func__标识符|281|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0257`；C/C++ 或辅助构建通用内容（14.3.12　__func__标识符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0258|14.4　条件编译|281|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0258`；C/C++ 或辅助构建通用内容（14.4　条件编译）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0259|14.4.1　#if指令和#endif指令 |281|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0259`；C/C++ 或辅助构建通用内容（14.4.1　#if指令和#endif指令 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0260|14.4.2　defined运算符 |282|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0260`；C/C++ 或辅助构建通用内容（14.4.2　defined运算符 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0261|14.4.3　#ifdef指令和#ifndef指令 |282|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0261`；C/C++ 或辅助构建通用内容（14.4.3　#ifdef指令和#ifndef指令 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0262|14.4.4　#elif指令和#else指令|283|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0262`；C/C++ 或辅助构建通用内容（14.4.4　#elif指令和#else指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0263|14.4.5　使用条件编译 |283|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0263`；C/C++ 或辅助构建通用内容（14.4.5　使用条件编译 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0264|14.5　其他指令|284|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0264`；C/C++ 或辅助构建通用内容（14.5　其他指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0265|14.5.1　#error指令|284|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0265`；C/C++ 或辅助构建通用内容（14.5.1　#error指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0266|14.5.2　#line指令|285|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0266`；C/C++ 或辅助构建通用内容（14.5.2　#line指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0267|14.5.3　#pragma指令|286|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0267`；C/C++ 或辅助构建通用内容（14.5.3　#pragma指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0268|14.5.4　_Pragma运算符|286|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0268`；C/C++ 或辅助构建通用内容（14.5.4　_Pragma运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0269|问与答|287|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0269`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0270|练习题|289|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0270`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0271|第15章　编写大型程序|293|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0271`；C/C++ 或辅助构建通用内容（第15章　编写大型程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0272|15.1　源文件|293|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0272`；C/C++ 或辅助构建通用内容（15.1　源文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0273|15.2　头文件|294|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0273`；C/C++ 或辅助构建通用内容（15.2　头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0274|15.2.1　#include指令|294|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0274`；C/C++ 或辅助构建通用内容（15.2.1　#include指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0275|15.2.2　共享宏定义和类型定义|295|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0275`；C/C++ 或辅助构建通用内容（15.2.2　共享宏定义和类型定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0276|15.2.3　共享函数原型|296|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0276`；C/C++ 或辅助构建通用内容（15.2.3　共享函数原型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0277|15.2.4　共享变量声明|298|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0277`；C/C++ 或辅助构建通用内容（15.2.4　共享变量声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0278|15.2.5　嵌套包含|299|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0278`；C/C++ 或辅助构建通用内容（15.2.5　嵌套包含）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0279|15.2.6　保护头文件|299|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0279`；C/C++ 或辅助构建通用内容（15.2.6　保护头文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0280|15.2.7　头文件中的#error指令|300|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0280`；C/C++ 或辅助构建通用内容（15.2.7　头文件中的#error指令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0281|15.3　把程序划分成多个文件|300|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0281`；C/C++ 或辅助构建通用内容（15.3　把程序划分成多个文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0282|15.4　构建多文件程序|306|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S15.md#review-s15-u0282`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S15-U0283|15.4.1　makefile|306|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0283`；C/C++ 或辅助构建通用内容（15.4.1　makefile）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0284|15.4.2　链接期间的错误|308|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0284`；C/C++ 或辅助构建通用内容（15.4.2　链接期间的错误）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0285|15.4.3　重新构建程序|308|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0285`；C/C++ 或辅助构建通用内容（15.4.3　重新构建程序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0286|15.4.4　在程序外定义宏|310|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0286`；C/C++ 或辅助构建通用内容（15.4.4　在程序外定义宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0287|问与答|310|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0287`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0288|练习题|312|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0288`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0289|编程题|313|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0289`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0290|第16章　结构、联合和枚举|314|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0290`；C/C++ 或辅助构建通用内容（第16章　结构、联合和枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0291|16.1　结构变量|314|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0291`；C/C++ 或辅助构建通用内容（16.1　结构变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0292|16.1.1　结构变量的声明|314|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0292`；C/C++ 或辅助构建通用内容（16.1.1　结构变量的声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0293|16.1.2　结构变量的初始化|316|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0293`；C/C++ 或辅助构建通用内容（16.1.2　结构变量的初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0294|16.1.3　指示器|316|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0294`；C/C++ 或辅助构建通用内容（16.1.3　指示器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0295|16.1.4　对结构的操作|317|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0295`；C/C++ 或辅助构建通用内容（16.1.4　对结构的操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0296|16.2　结构类型|317|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0296`；C/C++ 或辅助构建通用内容（16.2　结构类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0297|16.2.1　结构标记的声明|318|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0297`；C/C++ 或辅助构建通用内容（16.2.1　结构标记的声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0298|16.2.2　结构类型的定义|319|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0298`；C/C++ 或辅助构建通用内容（16.2.2　结构类型的定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0299|16.2.3　结构作为参数和返回值|319|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0299`；C/C++ 或辅助构建通用内容（16.2.3　结构作为参数和返回值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0300|16.2.4　复合字面量|320|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0300`；C/C++ 或辅助构建通用内容（16.2.4　复合字面量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0301|16.2.5　匿名结构|321|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0301`；C/C++ 或辅助构建通用内容（16.2.5　匿名结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0302|16.3　嵌套的数组和结构|322|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0302`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0303|16.3.1　嵌套的结构|322|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0303`；C/C++ 或辅助构建通用内容（16.3.1　嵌套的结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0304|16.3.2　结构数组|323|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0304`；C/C++ 或辅助构建通用内容（16.3.2　结构数组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0305|16.3.3　结构数组的初始化|323|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0305`；C/C++ 或辅助构建通用内容（16.3.3　结构数组的初始化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0306|16.4　联合|330|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0306`；C/C++ 或辅助构建通用内容（16.4　联合）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0307|16.4.1　用联合来节省空间|331|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0307`；C/C++ 或辅助构建通用内容（16.4.1　用联合来节省空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0308|16.4.2　用联合来构造混合的数据结构|333|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0308`；C/C++ 或辅助构建通用内容（16.4.2　用联合来构造混合的数据结构）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0309|16.4.3　为联合添加“标记字段”|333|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0309`；C/C++ 或辅助构建通用内容（16.4.3　为联合添加“标记字段”）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0310|16.4.4　匿名联合|334|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0310`；C/C++ 或辅助构建通用内容（16.4.4　匿名联合）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0311|16.5　枚举|335|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0311`；C/C++ 或辅助构建通用内容（16.5　枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0312|16.5.1　枚举标记和类型名|336|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0312`；C/C++ 或辅助构建通用内容（16.5.1　枚举标记和类型名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0313|16.5.2　枚举作为整数|336|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0313`；C/C++ 或辅助构建通用内容（16.5.2　枚举作为整数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0314|16.5.3　用枚举声明“标记字段”|337|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0314`；C/C++ 或辅助构建通用内容（16.5.3　用枚举声明“标记字段”）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0315|问与答|337|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0315`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0316|练习题|339|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0316`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0317|编程题|344|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0317`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0318|第17章　指针的高级应用|345|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0318`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0319|17.1　动态存储分配|345|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0319`；C/C++ 或辅助构建通用内容（17.1　动态存储分配）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0320|17.1.1　内存分配函数|346|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0320`；C/C++ 或辅助构建通用内容（17.1.1　内存分配函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0321|17.1.2　空指针|346|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0321`；C/C++ 或辅助构建通用内容（17.1.2　空指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0322|17.2　动态分配字符串|347|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0322`；C/C++ 或辅助构建通用内容（17.2　动态分配字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0323|17.2.1　使用malloc函数为字符串分配内存|347|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0323`；C/C++ 或辅助构建通用内容（17.2.1　使用malloc函数为字符串分配内存）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0324|17.2.2　在字符串函数中使用动态存储分配|348|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0324`；C/C++ 或辅助构建通用内容（17.2.2　在字符串函数中使用动态存储分配）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0325|17.2.3　动态分配字符串的数组|348|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0325`；C/C++ 或辅助构建通用内容（17.2.3　动态分配字符串的数组）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0326|17.3　动态分配数组|350|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0326`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0327|17.3.1　使用malloc函数为数组分配存储空间|350|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0327`；C/C++ 或辅助构建通用内容（17.3.1　使用malloc函数为数组分配存储空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0328|17.3.2　calloc函数|351|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0328`；C/C++ 或辅助构建通用内容（17.3.2　calloc函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0329|17.3.3　realloc函数|351|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0329`；C/C++ 或辅助构建通用内容（17.3.3　realloc函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0330|17.4　释放存储空间|352|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0330`；C/C++ 或辅助构建通用内容（17.4　释放存储空间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0331|17.4.1　free函数|353|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0331`；C/C++ 或辅助构建通用内容（17.4.1　free函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0332|17.4.2　“悬空指针”问题|353|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0332`；C/C++ 或辅助构建通用内容（17.4.2　“悬空指针”问题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0333|17.5　链表|353|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0333`；C/C++ 或辅助构建通用内容（17.5　链表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0334|17.5.1　声明结点类型|354|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0334`；C/C++ 或辅助构建通用内容（17.5.1　声明结点类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0335|17.5.2　创建结点|354|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0335`；C/C++ 或辅助构建通用内容（17.5.2　创建结点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0336|17.5.3　-&gt;运算符|355|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0336`；C/C++ 或辅助构建通用内容（17.5.3　-&gt;运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0337|17.5.4　在链表的开始处插入结点|356|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0337`；C/C++ 或辅助构建通用内容（17.5.4　在链表的开始处插入结点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0338|17.5.5　搜索链表|358|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0338`；C/C++ 或辅助构建通用内容（17.5.5　搜索链表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0339|17.5.6　从链表中删除结点|359|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0339`；C/C++ 或辅助构建通用内容（17.5.6　从链表中删除结点）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0340|17.5.7　有序链表|360|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0340`；C/C++ 或辅助构建通用内容（17.5.7　有序链表）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0341|17.6　指向指针的指针|365|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0341`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0342|17.7　指向函数的指针|366|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0342`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0343|17.7.1　函数指针作为参数|366|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0343`；C/C++ 或辅助构建通用内容（17.7.1　函数指针作为参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0344|17.7.2　qsort函数|367|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0344`；C/C++ 或辅助构建通用内容（17.7.2　qsort函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0345|17.7.3　函数指针的其他用途|368|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0345`；C/C++ 或辅助构建通用内容（17.7.3　函数指针的其他用途）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0346|17.8　受限指针|371|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0346`；C/C++ 或辅助构建通用内容（17.8　受限指针）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0347|17.9　弹性数组成员|372|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0347`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0348|问与答|373|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0348`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0349|练习题|376|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0349`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0350|编程题|379|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0350`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0351|第18章　声明|380|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0351`；C/C++ 或辅助构建通用内容（第18章　声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0352|18.1　声明的语法|380|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0352`；C/C++ 或辅助构建通用内容（18.1　声明的语法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0353|18.2　存储类型|381|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0353`；C/C++ 或辅助构建通用内容（18.2　存储类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0354|18.2.1　变量的性质|382|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0354`；C/C++ 或辅助构建通用内容（18.2.1　变量的性质）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0355|18.2.2　auto存储类型|382|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0355`；C/C++ 或辅助构建通用内容（18.2.2　auto存储类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0356|18.2.3　static存储类型|383|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0356`；C/C++ 或辅助构建通用内容（18.2.3　static存储类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0357|18.2.4　extern存储类型|384|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0357`；C/C++ 或辅助构建通用内容（18.2.4　extern存储类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0358|18.2.5　register存储类型|384|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0358`；C/C++ 或辅助构建通用内容（18.2.5　register存储类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0359|18.2.6　函数的存储类型|385|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0359`；C/C++ 或辅助构建通用内容（18.2.6　函数的存储类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0360|18.2.7　小结|386|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0360`；C/C++ 或辅助构建通用内容（18.2.7　小结）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0361|18.3　类型限定符|387|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0361`；C/C++ 或辅助构建通用内容（18.3　类型限定符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0362|18.4　声明符|387|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0362`；C/C++ 或辅助构建通用内容（18.4　声明符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0363|18.4.1　解释复杂声明|389|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0363`；C/C++ 或辅助构建通用内容（18.4.1　解释复杂声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0364|18.4.2　使用类型定义来简化声明|390|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0364`；C/C++ 或辅助构建通用内容（18.4.2　使用类型定义来简化声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0365|18.5　初始化器|390|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0365`；C/C++ 或辅助构建通用内容（18.5　初始化器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0366|未初始化的变量|391|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0366`；C/C++ 或辅助构建通用内容（未初始化的变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0367|18.6　内联函数|392|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0367`；C/C++ 或辅助构建通用内容（18.6　内联函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0368|18.6.1　内联定义|392|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0368`；C/C++ 或辅助构建通用内容（18.6.1　内联定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0369|18.6.2　对内联函数的限制|393|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0369`；C/C++ 或辅助构建通用内容（18.6.2　对内联函数的限制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0370|18.6.3　在GCC中使用内联函数|393|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0370`；C/C++ 或辅助构建通用内容（18.6.3　在GCC中使用内联函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0371|18.7　函数指定符_Noreturn和头&lt;stdnoreturn.h&gt;|394|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0371`；C/C++ 或辅助构建通用内容（18.7　函数指定符_Noreturn和头&lt;stdnoreturn.h&gt;）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0372|18.8　静态断言|394|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0372`；C/C++ 或辅助构建通用内容（18.8　静态断言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0373|问与答|395|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0373`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0374|练习题|398|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0374`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0375|第19章　程序设计|400|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0375`；C/C++ 或辅助构建通用内容（第19章　程序设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0376|19.1　模块|400|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0376`；C/C++ 或辅助构建通用内容（19.1　模块）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0377|19.1.1　内聚性与耦合性|402|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0377`；C/C++ 或辅助构建通用内容（19.1.1　内聚性与耦合性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0378|19.1.2　模块的类型|402|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0378`；C/C++ 或辅助构建通用内容（19.1.2　模块的类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0379|19.2　信息隐藏|402|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0379`；C/C++ 或辅助构建通用内容（19.2　信息隐藏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0380|栈模块|403|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0380`；C/C++ 或辅助构建通用内容（栈模块）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0381|19.3　抽象数据类型|406|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0381`；C/C++ 或辅助构建通用内容（19.3　抽象数据类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0382|19.3.1　封装|406|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0382`；C/C++ 或辅助构建通用内容（19.3.1　封装）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0383|19.3.2　不完整类型|407|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0383`；C/C++ 或辅助构建通用内容（19.3.2　不完整类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0384|19.4　栈抽象数据类型|407|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0384`；C/C++ 或辅助构建通用内容（19.4　栈抽象数据类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0385|19.4.1　为栈抽象数据类型定义接口|407|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0385`；C/C++ 或辅助构建通用内容（19.4.1　为栈抽象数据类型定义接口）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0386|19.4.2　用定长数组实现栈抽象数据类型 |409|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0386`；C/C++ 或辅助构建通用内容（19.4.2　用定长数组实现栈抽象数据类型 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0387|19.4.3　改变栈抽象数据类型中数据项的类型 |410|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0387`；C/C++ 或辅助构建通用内容（19.4.3　改变栈抽象数据类型中数据项的类型 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0388|19.4.4　用动态数组实现栈抽象数据类型|411|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0388`；C/C++ 或辅助构建通用内容（19.4.4　用动态数组实现栈抽象数据类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0389|19.4.5　用链表实现栈抽象数据类型|413|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0389`；C/C++ 或辅助构建通用内容（19.4.5　用链表实现栈抽象数据类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0390|19.5　抽象数据类型的设计问题|415|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0390`；C/C++ 或辅助构建通用内容（19.5　抽象数据类型的设计问题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0391|19.5.1　命名惯例|415|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0391`；C/C++ 或辅助构建通用内容（19.5.1　命名惯例）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0392|19.5.2　错误处理|415|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0392`；C/C++ 或辅助构建通用内容（19.5.2　错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0393|19.5.3　通用抽象数据类型|415|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0393`；C/C++ 或辅助构建通用内容（19.5.3　通用抽象数据类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0394|19.5.4　新语言中的抽象数据类型|416|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0394`；C/C++ 或辅助构建通用内容（19.5.4　新语言中的抽象数据类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0395|问与答|416|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0395`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0396|练习题|417|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0396`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0397|编程题|418|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0397`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0398|第20章　底层程序设计|419|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0398`；C/C++ 或辅助构建通用内容（第20章　底层程序设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0399|20.1　位运算符|419|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0399`；C/C++ 或辅助构建通用内容（20.1　位运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0400|20.1.1　移位运算符|419|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0400`；C/C++ 或辅助构建通用内容（20.1.1　移位运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0401|20.1.2　按位取反运算符、按位与运算符、按位异或运算符和按位或运算符|420|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0401`；C/C++ 或辅助构建通用内容（20.1.2　按位取反运算符、按位与运算符、按位异或运算符和按位或运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0402|20.1.3　用位运算符访问位|421|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0402`；C/C++ 或辅助构建通用内容（20.1.3　用位运算符访问位）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0403|20.1.4　用位运算符访问位域|422|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0403`；C/C++ 或辅助构建通用内容（20.1.4　用位运算符访问位域）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0404|20.2　结构中的位域|424|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0404`；C/C++ 或辅助构建通用内容（20.2　结构中的位域）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0405|位域是如何存储的|425|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0405`；C/C++ 或辅助构建通用内容（位域是如何存储的）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0406|20.3　其他底层技术|426|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0406`；C/C++ 或辅助构建通用内容（20.3　其他底层技术）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0407|20.3.1　定义依赖机器的类型|426|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0407`；C/C++ 或辅助构建通用内容（20.3.1　定义依赖机器的类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0408|20.3.2　用联合来提供数据的多个视角|426|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0408`；C/C++ 或辅助构建通用内容（20.3.2　用联合来提供数据的多个视角）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0409|20.3.3　将指针作为地址使用|428|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0409`；C/C++ 或辅助构建通用内容（20.3.3　将指针作为地址使用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0410|20.3.4　volatile类型限定符|430|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0410`；C/C++ 或辅助构建通用内容（20.3.4　volatile类型限定符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0411|20.4　对象的对齐|431|read-mapped / body-sampled|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S15.md#review-s15-u0411`；C/C++ 内存布局与对齐规则对照：用于分析类型在内存中的实际排布与结构体对齐|
|S15-U0412|20.4.1　对齐运算符 _Alignof |431|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0412`；C/C++ 或辅助构建通用内容（20.4.1　对齐运算符 _Alignof ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0413|20.4.2　对齐指定符_Alignas和头&lt;stdalign.h&gt;|431|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0413`；C/C++ 或辅助构建通用内容（20.4.2　对齐指定符_Alignas和头&lt;stdalign.h&gt;）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0414|问与答|432|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0414`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0415|练习题|432|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0415`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0416|编程题|434|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0416`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0417|第21章　标准库|435|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0417`；C/C++ 或辅助构建通用内容（第21章　标准库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0418|21.1　标准库的使用|435|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0418`；C/C++ 或辅助构建通用内容（21.1　标准库的使用）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0419|21.1.1　对标准库中所用名字的限制|436|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0419`；C/C++ 或辅助构建通用内容（21.1.1　对标准库中所用名字的限制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0420|21.1.2　使用宏隐藏的函数|436|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0420`；C/C++ 或辅助构建通用内容（21.1.2　使用宏隐藏的函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0421|21.2　C89标准库概述|437|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0421`；C/C++ 或辅助构建通用内容（21.2　C89标准库概述）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0422|21.3　C99标准库更新|438|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0422`；C/C++ 或辅助构建通用内容（21.3　C99标准库更新）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0423|21.4　&lt;stddef.h&gt;：常用定义|439|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0423`；C/C++ 或辅助构建通用内容（21.4　&lt;stddef.h&gt;：常用定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0424|21.5　&lt;stdbool.h&gt;：布尔类型和值|440|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0424`；C/C++ 或辅助构建通用内容（21.5　&lt;stdbool.h&gt;：布尔类型和值）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0425|21.6　C11标准库更新|440|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0425`；C/C++ 或辅助构建通用内容（21.6　C11标准库更新）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0426|21.7　&lt;stdalign.h&gt;:地址的对齐|441|read-mapped / body-sampled|[part1/ch02.md#sec-cpp-rust.1.2.1](../part1/ch02.md#sec-cpp-rust.1.2.1)|`sources/reviews/S15.md#review-s15-u0426`；C/C++ 内存布局与对齐规则对照：用于分析类型在内存中的实际排布与结构体对齐|
|S15-U0427|21.8　&lt;stdnoreturn.h&gt;:宏noreturn的定义|441|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0427`；C/C++ 或辅助构建通用内容（21.8　&lt;stdnoreturn.h&gt;:宏noreturn的定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0428|问与答|441|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0428`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0429|练习题|442|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0429`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0430|编程题|443|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0430`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0431|第22章　输入/输出|444|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0431`；C/C++ 或辅助构建通用内容（第22章　输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0432|22.1　流|444|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0432`；C/C++ 或辅助构建通用内容（22.1　流）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0433|22.1.1　文件指针 |445|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0433`；C/C++ 或辅助构建通用内容（22.1.1　文件指针 ）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0434|22.1.2　标准流和重定向|445|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0434`；C/C++ 或辅助构建通用内容（22.1.2　标准流和重定向）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0435|22.1.3　文本文件与二进制文件|446|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0435`；C/C++ 或辅助构建通用内容（22.1.3　文本文件与二进制文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0436|22.2　文件操作|447|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0436`；C/C++ 或辅助构建通用内容（22.2　文件操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0437|22.2.1　打开文件|447|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0437`；C/C++ 或辅助构建通用内容（22.2.1　打开文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0438|22.2.2　模式|448|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0438`；C/C++ 或辅助构建通用内容（22.2.2　模式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0439|22.2.3　关闭文件|449|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0439`；C/C++ 或辅助构建通用内容（22.2.3　关闭文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0440|22.2.4　为打开的流附加文件|449|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0440`；C/C++ 或辅助构建通用内容（22.2.4　为打开的流附加文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0441|22.2.5　从命令行获取文件名|450|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0441`；C/C++ 或辅助构建通用内容（22.2.5　从命令行获取文件名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0442|22.2.6　临时文件|451|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0442`；C/C++ 或辅助构建通用内容（22.2.6　临时文件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0443|22.2.7　文件缓冲|452|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0443`；C/C++ 或辅助构建通用内容（22.2.7　文件缓冲）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0444|22.2.8　其他文件操作|453|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0444`；C/C++ 或辅助构建通用内容（22.2.8　其他文件操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0445|22.3　格式化的输入/输出|454|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0445`；C/C++ 或辅助构建通用内容（22.3　格式化的输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0446|22.3.1　…printf函数|454|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0446`；C/C++ 或辅助构建通用内容（22.3.1　…printf函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0447|22.3.2　…printf转换说明|454|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0447`；C/C++ 或辅助构建通用内容（22.3.2　…printf转换说明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0448|22.3.3　C99对…printf转换说明的修改|456|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0448`；C/C++ 或辅助构建通用内容（22.3.3　C99对…printf转换说明的修改）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0449|22.3.4　…printf转换说明示例|457|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0449`；C/C++ 或辅助构建通用内容（22.3.4　…printf转换说明示例）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0450|22.3.5　…scanf函数|459|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0450`；C/C++ 或辅助构建通用内容（22.3.5　…scanf函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0451|22.3.6　…scanf格式串|459|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0451`；C/C++ 或辅助构建通用内容（22.3.6　…scanf格式串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0452|22.3.7　…scanf转换说明|460|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0452`；C/C++ 或辅助构建通用内容（22.3.7　…scanf转换说明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0453|22.3.8　C99对…scanf转换说明的改变|462|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0453`；C/C++ 或辅助构建通用内容（22.3.8　C99对…scanf转换说明的改变）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0454|22.3.9　scanf示例|462|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0454`；C/C++ 或辅助构建通用内容（22.3.9　scanf示例）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0455|22.3.10　检测文件末尾和错误条件|463|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0455`；C/C++ 或辅助构建通用内容（22.3.10　检测文件末尾和错误条件）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0456|22.4　字符的输入/输出|465|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0456`；C/C++ 或辅助构建通用内容（22.4　字符的输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0457|22.4.1　输出函数|465|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0457`；C/C++ 或辅助构建通用内容（22.4.1　输出函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0458|22.4.2　输入函数|465|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0458`；C/C++ 或辅助构建通用内容（22.4.2　输入函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0459|22.5　行的输入/输出|467|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0459`；C/C++ 或辅助构建通用内容（22.5　行的输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0460|22.5.1　输出函数|467|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0460`；C/C++ 或辅助构建通用内容（22.5.1　输出函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0461|22.5.2　输入函数|468|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0461`；C/C++ 或辅助构建通用内容（22.5.2　输入函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0462|22.6　块的输入/输出|468|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0462`；C/C++ 或辅助构建通用内容（22.6　块的输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0463|22.7　文件定位|469|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0463`；C/C++ 或辅助构建通用内容（22.7　文件定位）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0464|22.8　字符串的输入/输出|472|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0464`；C/C++ 或辅助构建通用内容（22.8　字符串的输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0465|22.8.1　输出函数|472|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0465`；C/C++ 或辅助构建通用内容（22.8.1　输出函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0466|22.8.2　输入函数|473|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0466`；C/C++ 或辅助构建通用内容（22.8.2　输入函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0467|问与答|473|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0467`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0468|练习题|476|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0468`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0469|编程题|479|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0469`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0470|第23章　库对数值和字符数据的支持|483|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0470`；C/C++ 或辅助构建通用内容（第23章　库对数值和字符数据的支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0471|23.1　&lt;float.h&gt;：浮点类型的特性|483|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0471`；C/C++ 或辅助构建通用内容（23.1　&lt;float.h&gt;：浮点类型的特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0472|23.2　&lt;limits.h&gt;：整数类型的大小|485|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0472`；C/C++ 或辅助构建通用内容（23.2　&lt;limits.h&gt;：整数类型的大小）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0473|23.3　&lt;math.h&gt;：数学计算（C89）|486|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0473`；C/C++ 或辅助构建通用内容（23.3　&lt;math.h&gt;：数学计算（C89））；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0474|23.3.1　错误|486|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0474`；C/C++ 或辅助构建通用内容（23.3.1　错误）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0475|23.3.2　三角函数|487|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0475`；C/C++ 或辅助构建通用内容（23.3.2　三角函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0476|23.3.3　双曲函数|487|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0476`；C/C++ 或辅助构建通用内容（23.3.3　双曲函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0477|23.3.4　指数函数和对数函数|488|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0477`；C/C++ 或辅助构建通用内容（23.3.4　指数函数和对数函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0478|23.3.5　幂函数|488|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0478`；C/C++ 或辅助构建通用内容（23.3.5　幂函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0479|23.3.6　就近舍入函数、绝对值函数和取余函数|489|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0479`；C/C++ 或辅助构建通用内容（23.3.6　就近舍入函数、绝对值函数和取余函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0480|23.4　&lt;math.h&gt;：数学计算|489|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0480`；C/C++ 或辅助构建通用内容（23.4　&lt;math.h&gt;：数学计算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0481|23.4.1　IEEE浮点标准|490|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0481`；C/C++ 或辅助构建通用内容（23.4.1　IEEE浮点标准）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0482|23.4.2　类型|491|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0482`；C/C++ 或辅助构建通用内容（23.4.2　类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0483|23.4.3　宏|491|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0483`；C/C++ 或辅助构建通用内容（23.4.3　宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0484|23.4.4　错误|491|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0484`；C/C++ 或辅助构建通用内容（23.4.4　错误）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0485|23.4.5　函数|492|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0485`；C/C++ 或辅助构建通用内容（23.4.5　函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0486|23.4.6　分类宏|492|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0486`；C/C++ 或辅助构建通用内容（23.4.6　分类宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0487|23.4.7　三角函数|493|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0487`；C/C++ 或辅助构建通用内容（23.4.7　三角函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0488|23.4.8　双曲函数|493|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0488`；C/C++ 或辅助构建通用内容（23.4.8　双曲函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0489|23.4.9　指数函数和对数函数|494|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0489`；C/C++ 或辅助构建通用内容（23.4.9　指数函数和对数函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0490|23.4.10　幂函数和绝对值函数|495|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0490`；C/C++ 或辅助构建通用内容（23.4.10　幂函数和绝对值函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0491|23.4.11　误差函数和伽马函数|495|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0491`；C/C++ 或辅助构建通用内容（23.4.11　误差函数和伽马函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0492|23.4.12　就近舍入函数|496|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0492`；C/C++ 或辅助构建通用内容（23.4.12　就近舍入函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0493|23.4.13　取余函数|497|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0493`；C/C++ 或辅助构建通用内容（23.4.13　取余函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0494|23.4.14　操作函数|498|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0494`；C/C++ 或辅助构建通用内容（23.4.14　操作函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0495|23.4.15　最大值函数、最小值函数和正差函数|498|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0495`；C/C++ 或辅助构建通用内容（23.4.15　最大值函数、最小值函数和正差函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0496|23.4.16　浮点乘加|499|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0496`；C/C++ 或辅助构建通用内容（23.4.16　浮点乘加）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0497|23.4.17　比较宏|499|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0497`；C/C++ 或辅助构建通用内容（23.4.17　比较宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0498|23.5　&lt;ctype.h&gt;：字符处理|500|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0498`；C/C++ 或辅助构建通用内容（23.5　&lt;ctype.h&gt;：字符处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0499|23.5.1　字符分类函数|500|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0499`；C/C++ 或辅助构建通用内容（23.5.1　字符分类函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0500|23.5.2　字符大小写映射函数|502|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0500`；C/C++ 或辅助构建通用内容（23.5.2　字符大小写映射函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0501|23.6　&lt;string.h&gt;：字符串处理|503|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0501`；C/C++ 或辅助构建通用内容（23.6　&lt;string.h&gt;：字符串处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0502|23.6.1　复制函数|503|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0502`；C/C++ 或辅助构建通用内容（23.6.1　复制函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0503|23.6.2　拼接函数|504|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0503`；C/C++ 或辅助构建通用内容（23.6.2　拼接函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0504|23.6.3　比较函数|505|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0504`；C/C++ 或辅助构建通用内容（23.6.3　比较函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0505|23.6.4　搜索函数|506|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0505`；C/C++ 或辅助构建通用内容（23.6.4　搜索函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0506|23.6.5　其他函数|508|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0506`；C/C++ 或辅助构建通用内容（23.6.5　其他函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0507|问与答|509|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0507`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0508|练习题|509|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0508`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0509|编程题|511|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0509`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0510|第24章　错误处理|512|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0510`；C/C++ 或辅助构建通用内容（第24章　错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0511|24.1　&lt;assert.h&gt;：诊断|512|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0511`；C/C++ 或辅助构建通用内容（24.1　&lt;assert.h&gt;：诊断）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0512|24.2　&lt;errno.h&gt;：错误|513|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0512`；C/C++ 或辅助构建通用内容（24.2　&lt;errno.h&gt;：错误）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0513|perror函数和strerror函数|514|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0513`；C/C++ 或辅助构建通用内容（perror函数和strerror函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0514|24.3　&lt;signal.h&gt;：信号处理|515|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0514`；C/C++ 或辅助构建通用内容（24.3　&lt;signal.h&gt;：信号处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0515|24.3.1　信号宏|515|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0515`；C/C++ 或辅助构建通用内容（24.3.1　信号宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0516|24.3.2　signal函数|515|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0516`；C/C++ 或辅助构建通用内容（24.3.2　signal函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0517|24.3.3　预定义的信号处理函数|516|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0517`；C/C++ 或辅助构建通用内容（24.3.3　预定义的信号处理函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0518|24.3.4　raise函数|517|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0518`；C/C++ 或辅助构建通用内容（24.3.4　raise函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0519|24.4　&lt;setjmp.h&gt;：非局部跳转|518|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0519`；C/C++ 或辅助构建通用内容（24.4　&lt;setjmp.h&gt;：非局部跳转）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0520|问与答|520|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0520`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0521|练习题|521|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0521`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0522|第25章　国际化特性|523|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0522`；C/C++ 或辅助构建通用内容（第25章　国际化特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0523|25.1　&lt;locale.h&gt;：本地化|523|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0523`；C/C++ 或辅助构建通用内容（25.1　&lt;locale.h&gt;：本地化）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0524|25.1.1　类项|524|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0524`；C/C++ 或辅助构建通用内容（25.1.1　类项）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0525|25.1.2　setlocale函数|524|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0525`；C/C++ 或辅助构建通用内容（25.1.2　setlocale函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0526|25.1.3　localeconv函数|525|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0526`；C/C++ 或辅助构建通用内容（25.1.3　localeconv函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0527|25.2　多字节字符和宽字符|528|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0527`；C/C++ 或辅助构建通用内容（25.2　多字节字符和宽字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0528|25.2.1　多字节字符|528|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0528`；C/C++ 或辅助构建通用内容（25.2.1　多字节字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0529|25.2.2　宽字符|529|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0529`；C/C++ 或辅助构建通用内容（25.2.2　宽字符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0530|25.2.3　Unicode和通用字符集|529|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0530`；C/C++ 或辅助构建通用内容（25.2.3　Unicode和通用字符集）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0531|25.2.4　Unicode编码|530|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0531`；C/C++ 或辅助构建通用内容（25.2.4　Unicode编码）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0532|25.2.5　多字节/宽字符转换函数|531|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0532`；C/C++ 或辅助构建通用内容（25.2.5　多字节/宽字符转换函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0533|25.2.6　多字节/宽字符串转换函数|532|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0533`；C/C++ 或辅助构建通用内容（25.2.6　多字节/宽字符串转换函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0534|25.3　双联符和三联符|533|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0534`；C/C++ 或辅助构建通用内容（25.3　双联符和三联符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0535|25.3.1　三联符|533|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0535`；C/C++ 或辅助构建通用内容（25.3.1　三联符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0536|25.3.2　双联符|534|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0536`；C/C++ 或辅助构建通用内容（25.3.2　双联符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0537|25.3.3　&lt;iso646.h&gt;：拼写替换|534|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0537`；C/C++ 或辅助构建通用内容（25.3.3　&lt;iso646.h&gt;：拼写替换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0538|25.4　通用字符名|535|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0538`；C/C++ 或辅助构建通用内容（25.4　通用字符名）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0539|25.5　&lt;wchar.h&gt;：扩展的多字节和宽字符实用工具|535|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0539`；C/C++ 或辅助构建通用内容（25.5　&lt;wchar.h&gt;：扩展的多字节和宽字符实用工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0540|25.5.1　流的倾向性|536|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0540`；C/C++ 或辅助构建通用内容（25.5.1　流的倾向性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0541|25.5.2　格式化宽字符输入/输出函数|536|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0541`；C/C++ 或辅助构建通用内容（25.5.2　格式化宽字符输入/输出函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0542|25.5.3　宽字符输入/输出函数|538|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0542`；C/C++ 或辅助构建通用内容（25.5.3　宽字符输入/输出函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0543|25.5.4　通用的宽字符串实用工具|539|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0543`；C/C++ 或辅助构建通用内容（25.5.4　通用的宽字符串实用工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0544|25.5.5　宽字符时间转换函数|542|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0544`；C/C++ 或辅助构建通用内容（25.5.5　宽字符时间转换函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0545|25.5.6　扩展的多字节/宽字符转换实用工具|542|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0545`；C/C++ 或辅助构建通用内容（25.5.6　扩展的多字节/宽字符转换实用工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0546|25.6　&lt;wctype.h&gt;：宽字符分类和映射实用工具|544|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0546`；C/C++ 或辅助构建通用内容（25.6　&lt;wctype.h&gt;：宽字符分类和映射实用工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0547|25.6.1　宽字符分类函数|545|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0547`；C/C++ 或辅助构建通用内容（25.6.1　宽字符分类函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0548|25.6.2　可扩展的宽字符分类函数|546|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0548`；C/C++ 或辅助构建通用内容（25.6.2　可扩展的宽字符分类函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0549|25.6.3　宽字符大小写映射函数|546|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0549`；C/C++ 或辅助构建通用内容（25.6.3　宽字符大小写映射函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0550|25.6.4　可扩展的宽字符大小写映射函数|546|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0550`；C/C++ 或辅助构建通用内容（25.6.4　可扩展的宽字符大小写映射函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0551|25.7　&lt;uchar.h&gt;：改进的Unicode支持|547|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0551`；C/C++ 或辅助构建通用内容（25.7　&lt;uchar.h&gt;：改进的Unicode支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0552|25.7.1　带u、U和u8前缀的字面串|547|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0552`；C/C++ 或辅助构建通用内容（25.7.1　带u、U和u8前缀的字面串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0553|25.7.2　可重启动的多字节/宽字符转换函数|548|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0553`；C/C++ 或辅助构建通用内容（25.7.2　可重启动的多字节/宽字符转换函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0554|问与答|549|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0554`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0555|练习题|550|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0555`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0556|编程题|551|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0556`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0557|第26章　其他库函数|552|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0557`；C/C++ 或辅助构建通用内容（第26章　其他库函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0558|26.1　&lt;stdarg.h&gt;：可变参数|552|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0558`；C/C++ 或辅助构建通用内容（26.1　&lt;stdarg.h&gt;：可变参数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0559|26.1.1　调用带有可变参数列表的函数|554|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0559`；C/C++ 或辅助构建通用内容（26.1.1　调用带有可变参数列表的函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0560|26.1.2　v…printf函数|554|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0560`；C/C++ 或辅助构建通用内容（26.1.2　v…printf函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0561|26.1.3　v…scanf函数|555|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0561`；C/C++ 或辅助构建通用内容（26.1.3　v…scanf函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0562|26.2　&lt;stdlib.h&gt;：通用的实用工具|555|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0562`；C/C++ 或辅助构建通用内容（26.2　&lt;stdlib.h&gt;：通用的实用工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0563|26.2.1　数值转换函数|556|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0563`；C/C++ 或辅助构建通用内容（26.2.1　数值转换函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0564|26.2.2　伪随机序列生成函数|558|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0564`；C/C++ 或辅助构建通用内容（26.2.2　伪随机序列生成函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0565|26.2.3　与环境的通信|560|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0565`；C/C++ 或辅助构建通用内容（26.2.3　与环境的通信）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0566|26.2.4　搜索和排序实用工具|561|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0566`；C/C++ 或辅助构建通用内容（26.2.4　搜索和排序实用工具）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0567|26.2.5　整数算术运算函数|563|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0567`；C/C++ 或辅助构建通用内容（26.2.5　整数算术运算函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0568|26.2.6　地址对齐的内存分配|563|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0568`；C/C++ 或辅助构建通用内容（26.2.6　地址对齐的内存分配）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0569|26.3　&lt;time.h&gt;：日期和时间|563|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0569`；C/C++ 或辅助构建通用内容（26.3　&lt;time.h&gt;：日期和时间）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0570|26.3.1　时间处理函数|564|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0570`；C/C++ 或辅助构建通用内容（26.3.1　时间处理函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0571|26.3.2　时间转换函数|566|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0571`；C/C++ 或辅助构建通用内容（26.3.2　时间转换函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0572|问与答|571|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0572`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0573|练习题|573|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0573`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0574|编程题|574|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0574`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0575|第27章　C99对数学计算的新增支持|575|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0575`；C/C++ 或辅助构建通用内容（第27章　C99对数学计算的新增支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0576|27.1　&lt;stdint.h&gt;：整数类型|575|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0576`；C/C++ 或辅助构建通用内容（27.1　&lt;stdint.h&gt;：整数类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0577|27.1.1　&lt;stdint.h&gt;类型|576|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0577`；C/C++ 或辅助构建通用内容（27.1.1　&lt;stdint.h&gt;类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0578|27.1.2　对指定宽度整数类型的限制|576|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0578`；C/C++ 或辅助构建通用内容（27.1.2　对指定宽度整数类型的限制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0579|27.1.3　对其他整数类型的限制|577|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0579`；C/C++ 或辅助构建通用内容（27.1.3　对其他整数类型的限制）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0580|27.1.4　用于整型常量的宏|578|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0580`；C/C++ 或辅助构建通用内容（27.1.4　用于整型常量的宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0581|27.2　&lt;inttypes.h&gt;：整数类型的格式转换|578|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0581`；C/C++ 或辅助构建通用内容（27.2　&lt;inttypes.h&gt;：整数类型的格式转换）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0582|27.2.1　用于格式指定符的宏|578|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0582`；C/C++ 或辅助构建通用内容（27.2.1　用于格式指定符的宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0583|27.2.2　用于最大宽度整数类型的函数|579|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0583`；C/C++ 或辅助构建通用内容（27.2.2　用于最大宽度整数类型的函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0584|27.3　复数|580|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0584`；C/C++ 或辅助构建通用内容（27.3　复数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0585|27.3.1　复数的定义|580|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0585`；C/C++ 或辅助构建通用内容（27.3.1　复数的定义）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0586|27.3.2　复数的算术运算|581|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0586`；C/C++ 或辅助构建通用内容（27.3.2　复数的算术运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0587|27.3.3　C99中的复数类型|582|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0587`；C/C++ 或辅助构建通用内容（27.3.3　C99中的复数类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0588|27.3.4　复数的运算|582|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0588`；C/C++ 或辅助构建通用内容（27.3.4　复数的运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0589|27.3.5　复数类型的转换规则|583|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0589`；C/C++ 或辅助构建通用内容（27.3.5　复数类型的转换规则）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0590|27.4　&lt;complex.h&gt;：复数算术运算|583|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0590`；C/C++ 或辅助构建通用内容（27.4　&lt;complex.h&gt;：复数算术运算）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0591|27.4.1　&lt;complex.h&gt;宏|583|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0591`；C/C++ 或辅助构建通用内容（27.4.1　&lt;complex.h&gt;宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0592|27.4.2　CX_LIMITED_RANGE编译提示|584|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0592`；C/C++ 或辅助构建通用内容（27.4.2　CX_LIMITED_RANGE编译提示）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0593|27.4.3　&lt;complex.h&gt;函数|585|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0593`；C/C++ 或辅助构建通用内容（27.4.3　&lt;complex.h&gt;函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0594|27.4.4　三角函数|585|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0594`；C/C++ 或辅助构建通用内容（27.4.4　三角函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0595|27.4.5　双曲函数|586|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0595`；C/C++ 或辅助构建通用内容（27.4.5　双曲函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0596|27.4.6　指数函数和对数函数|586|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0596`；C/C++ 或辅助构建通用内容（27.4.6　指数函数和对数函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0597|27.4.7　幂函数和绝对值函数|587|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0597`；C/C++ 或辅助构建通用内容（27.4.7　幂函数和绝对值函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0598|27.4.8　操作函数|587|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0598`；C/C++ 或辅助构建通用内容（27.4.8　操作函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0599|27.5　&lt;tgmath.h&gt;：泛型数学|588|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0599`；C/C++ 或辅助构建通用内容（27.5　&lt;tgmath.h&gt;：泛型数学）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0600|27.5.1　泛型宏|589|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0600`；C/C++ 或辅助构建通用内容（27.5.1　泛型宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0601|27.5.2　调用泛型宏|590|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0601`；C/C++ 或辅助构建通用内容（27.5.2　调用泛型宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0602|27.6　&lt;fenv.h&gt;：浮点环境|591|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0602`；C/C++ 或辅助构建通用内容（27.6　&lt;fenv.h&gt;：浮点环境）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0603|27.6.1　浮点状态标志和控制模式|591|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0603`；C/C++ 或辅助构建通用内容（27.6.1　浮点状态标志和控制模式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0604|27.6.2　&lt;fenv.h&gt;宏|592|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0604`；C/C++ 或辅助构建通用内容（27.6.2　&lt;fenv.h&gt;宏）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0605|27.6.3　FENV_ACCESS编译提示|592|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0605`；C/C++ 或辅助构建通用内容（27.6.3　FENV_ACCESS编译提示）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0606|27.6.4　浮点异常函数|593|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0606`；C/C++ 或辅助构建通用内容（27.6.4　浮点异常函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0607|27.6.5　舍入函数|594|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0607`；C/C++ 或辅助构建通用内容（27.6.5　舍入函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0608|27.6.6　环境函数|594|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0608`；C/C++ 或辅助构建通用内容（27.6.6　环境函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0609|问与答|594|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0609`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0610|练习题|595|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0610`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0611|编程题|596|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0611`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0612|第28章　C1X新增的多线程和原子操作支持|597|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0612`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S15-U0613|28.1　&lt;threads.h&gt;：多线程执行支持|598|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0613`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S15-U0614|28.1.1　线程启动函数|598|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0614`；C/C++ 或辅助构建通用内容（28.1.1　线程启动函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0615|28.1.2　线程的创建和管理函数|599|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0615`；C/C++ 或辅助构建通用内容（28.1.2　线程的创建和管理函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0616|28.1.3　数据竞争|602|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0616`；C/C++ 或辅助构建通用内容（28.1.3　数据竞争）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0617|28.1.4　互斥函数|604|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0617`；C/C++ 或辅助构建通用内容（28.1.4　互斥函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0618|28.1.5　条件变量|606|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0618`；C/C++ 或辅助构建通用内容（28.1.5　条件变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0619|28.1.6　条件变量函数|608|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0619`；C/C++ 或辅助构建通用内容（28.1.6　条件变量函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0620|28.1.7　递归锁和非递归锁|612|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0620`；C/C++ 或辅助构建通用内容（28.1.7　递归锁和非递归锁）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0621|28.1.8　初始化函数|612|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0621`；C/C++ 或辅助构建通用内容（28.1.8　初始化函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0622|28.1.9　_Thread_local存储类和线程存储期|614|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0622`；C/C++ 或辅助构建通用内容（28.1.9　_Thread_local存储类和线程存储期）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0623|28.1.10　线程专属存储|616|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0623`；C/C++ 或辅助构建通用内容（28.1.10　线程专属存储）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0624|28.1.11　线程专属存储函数|617|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0624`；C/C++ 或辅助构建通用内容（28.1.11　线程专属存储函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0625|28.2　_Atomic、&lt;stdatomic.h&gt;：原子类型和原子操作支持|620|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0625`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S15-U0626|28.2.1　_Atomic：类型指定符/类型限定符|621|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0626`；C/C++ 或辅助构建通用内容（28.2.1　_Atomic：类型指定符/类型限定符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0627|28.2.2　标准库定义的原子类型|621|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0627`；C/C++ 或辅助构建通用内容（28.2.2　标准库定义的原子类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0628|28.2.3　初始化原子变量|622|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0628`；C/C++ 或辅助构建通用内容（28.2.3　初始化原子变量）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0629|28.2.4　原子变量的初始化函数|622|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0629`；C/C++ 或辅助构建通用内容（28.2.4　原子变量的初始化函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0630|28.2.5　原子操作|623|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0630`；C/C++ 或辅助构建通用内容（28.2.5　原子操作）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0631|28.2.6　原子操作函数|625|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0631`；C/C++ 或辅助构建通用内容（28.2.6　原子操作函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0632|28.2.7　内存顺序|629|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0632`；C/C++ 或辅助构建通用内容（28.2.7　内存顺序）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0633|28.2.8　围栏函数|634|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0633`；C/C++ 或辅助构建通用内容（28.2.8　围栏函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0634|28.2.9　锁无关判断函数|636|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0634`；C/C++ 或辅助构建通用内容（28.2.9　锁无关判断函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0635|28.2.10　原子标志类型及其操作函数|638|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0635`；C/C++ 或辅助构建通用内容（28.2.10　原子标志类型及其操作函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0636|问与答|640|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0636`；C/C++ 或辅助构建通用内容（问与答）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0637|练习题|640|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0637`；C/C++ 或辅助构建通用内容（练习题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0638|编程题|641|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0638`；C/C++ 或辅助构建通用内容（编程题）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0639|附录A 　C语言运算符|642|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0639`；C/C++ 或辅助构建通用内容（附录A 　C语言运算符）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0640|附录B　C1X与C99的比较|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0640`；C/C++ 或辅助构建通用内容（附录B　C1X与C99的比较）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0641|第2章　C语言基本概念|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0641`；C/C++ 或辅助构建通用内容（第2章　C语言基本概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0642|第9章　函数|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0642`；C/C++ 或辅助构建通用内容（第9章　函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0643|第13章　字符串|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0643`；C/C++ 或辅助构建通用内容（第13章　字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0644|第16章　结构、联合和枚举|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0644`；C/C++ 或辅助构建通用内容（第16章　结构、联合和枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0645|第18章　声明|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0645`；C/C++ 或辅助构建通用内容（第18章　声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0646|第20章　底层程序设计|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0646`；C/C++ 或辅助构建通用内容（第20章　底层程序设计）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0647|第22章　输入/输出|643|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0647`；C/C++ 或辅助构建通用内容（第22章　输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0648|第25章　国际化特性|644|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0648`；C/C++ 或辅助构建通用内容（第25章　国际化特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0649|第26章　其他库函数|644|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0649`；C/C++ 或辅助构建通用内容（第26章　其他库函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0650|第28章　C1X新增的多线程和原子操作支持|644|read-mapped / body-sampled|[part2/ch07.md#sec-cpp-rust.2.7.1](../part2/ch07.md#sec-cpp-rust.2.7.1)|`sources/reviews/S15.md#review-s15-u0650`；C/C++ 原子操作与并发模型对照：用于深入理解硬件内存序与硬件原子语义差异|
|S15-U0651|附录C　C99与C89的比较|645|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0651`；C/C++ 或辅助构建通用内容（附录C　C99与C89的比较）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0652|第2章　C语言基本概念|645|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0652`；C/C++ 或辅助构建通用内容（第2章　C语言基本概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0653|第4章　表达式|645|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0653`；C/C++ 或辅助构建通用内容（第4章　表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0654|第5章　选择语句|645|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0654`；C/C++ 或辅助构建通用内容（第5章　选择语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0655|第6章　循环|645|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0655`；C/C++ 或辅助构建通用内容（第6章　循环）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0656|第7章　基本类型|645|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0656`；C/C++ 或辅助构建通用内容（第7章　基本类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0657|第8章　数组|646|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0657`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0658|第9章　函数|646|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0658`；C/C++ 或辅助构建通用内容（第9章　函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0659|第14章　预处理器|646|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0659`；C/C++ 或辅助构建通用内容（第14章　预处理器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0660|第16章　结构、联合和枚举|647|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0660`；C/C++ 或辅助构建通用内容（第16章　结构、联合和枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0661|第17章　指针的高级应用|647|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0661`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0662|第18章　声明|647|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0662`；C/C++ 或辅助构建通用内容（第18章　声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0663|第21章　标准库|647|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0663`；C/C++ 或辅助构建通用内容（第21章　标准库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0664|第22章　输入/输出|647|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0664`；C/C++ 或辅助构建通用内容（第22章　输入/输出）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0665|第23章　库对数值和字符数据的支持|647|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0665`；C/C++ 或辅助构建通用内容（第23章　库对数值和字符数据的支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0666|第24章　错误处理|648|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0666`；C/C++ 或辅助构建通用内容（第24章　错误处理）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0667|第25章　国际化特性|648|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0667`；C/C++ 或辅助构建通用内容（第25章　国际化特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0668|第26章　其他库函数|648|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0668`；C/C++ 或辅助构建通用内容（第26章　其他库函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0669|第27章　C99对数学的新增支持|648|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0669`；C/C++ 或辅助构建通用内容（第27章　C99对数学的新增支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0670|附录D　C89与经典C的比较|649|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0670`；C/C++ 或辅助构建通用内容（附录D　C89与经典C的比较）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0671|第2章　C语言基本概念|649|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0671`；C/C++ 或辅助构建通用内容（第2章　C语言基本概念）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0672|第4章　表达式|649|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0672`；C/C++ 或辅助构建通用内容（第4章　表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0673|第5章　选择语句|649|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0673`；C/C++ 或辅助构建通用内容（第5章　选择语句）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0674|第7章　基本类型|649|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0674`；C/C++ 或辅助构建通用内容（第7章　基本类型）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0675|第9章　函数|650|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0675`；C/C++ 或辅助构建通用内容（第9章　函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0676|第12章　指针和数组|650|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0676`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0677|第13章　字符串|650|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0677`；C/C++ 或辅助构建通用内容（第13章　字符串）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0678|第14章　预处理器|650|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0678`；C/C++ 或辅助构建通用内容（第14章　预处理器）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0679|第16章　结构、联合和枚举|651|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0679`；C/C++ 或辅助构建通用内容（第16章　结构、联合和枚举）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0680|第17章　指针的高级应用|651|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.1](../part4/ch16.md#sec-cpp-rust.4.16.1)|`sources/reviews/S15.md#review-s15-u0680`；C 语言裸指针、数组布局与内存分配原语：用于项目二 Rust 与 C ABI 边界的所有权与指针安全协议|
|S15-U0681|第18章　声明|651|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0681`；C/C++ 或辅助构建通用内容（第18章　声明）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0682|第25章　国际化特性|651|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0682`；C/C++ 或辅助构建通用内容（第25章　国际化特性）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0683|第26章　其他库函数|651|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0683`；C/C++ 或辅助构建通用内容（第26章　其他库函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0684|附录E　标准库函数|652|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0684`；C/C++ 或辅助构建通用内容（附录E　标准库函数）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0685|附录F　 ASCII字符集|694|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0685`；C/C++ 或辅助构建通用内容（附录F　 ASCII字符集）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0686|延伸阅读|695|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0686`；C/C++ 或辅助构建通用内容（延伸阅读）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0687|C语言编程|695|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0687`；C/C++ 或辅助构建通用内容（C语言编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0688|UNIX编程|696|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0688`；C/C++ 或辅助构建通用内容（UNIX编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0689|通用编程|696|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0689`；C/C++ 或辅助构建通用内容（通用编程）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S15-U0690|网页资源|696|excluded-reviewed / scope-only|—|`sources/reviews/S15.md#review-s15-u0690`；C/C++ 或辅助构建通用内容（网页资源）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

### S16 · CMake构建实战-项目开发卷 (许宏旭) (z-library.sk, 1lib.sk, z-lib.sk).epub {#coverage-s16}

|母本节|标题|物理页/定位|状态与阅读深度|本书落点|证据及范围理由|
|:--|:--|:--|:--|:--|:--|
|S16-U0001|版权信息|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0001`；C/C++ 或辅助构建通用内容（版权信息）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0002|内容提要|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0002`；C/C++ 或辅助构建通用内容（内容提要）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0003|前言|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0003`；C/C++ 或辅助构建通用内容（前言）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0004|资源与支持|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0004`；C/C++ 或辅助构建通用内容（资源与支持）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0005|第1章 构建之旅|未知|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0005`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S16-U0006|第2章 CMake简介|未知|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0006`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S16-U0007|第3章 基础语法|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0007`；C/C++ 或辅助构建通用内容（第3章 基础语法）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0008|第4章 常用命令|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0008`；C/C++ 或辅助构建通用内容（第4章 常用命令）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0009|第5章 实践：CMake快速排序|未知|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0009`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S16-U0010|第6章 CMake构建初探|未知|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0010`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S16-U0011|第7章 构建目标和属性|未知|read-mapped / body-sampled|[part4/ch16.md#sec-cpp-rust.4.16.3](../part4/ch16.md#sec-cpp-rust.4.16.3)|`sources/reviews/S16.md#review-s16-u0011`；CMake 目标配置、静态库链接与 CTest 集成：用于项目二跨语言原生构建体系|
|S16-U0012|第8章 生成器表达式|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0012`；C/C++ 或辅助构建通用内容（第8章 生成器表达式）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0013|第9章 模块|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0013`；C/C++ 或辅助构建通用内容（第9章 模块）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0014|第10章 策略与向后兼容|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0014`；C/C++ 或辅助构建通用内容（第10章 策略与向后兼容）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|
|S16-U0015|第11章 实践：基于onnxruntime的手写数字识别库|未知|excluded-reviewed / scope-only|—|`sources/reviews/S16.md#review-s16-u0015`；C/C++ 或辅助构建通用内容（第11章 实践：基于onnxruntime的手写数字识别库）；按用户最新要求全书聚焦 Rust 底层、编译器、并发与执行器，非主线 C++ 语法/类库/OOP 内容明确排除。|

## 网页与固定版本源码

|来源|URL或文件|核读范围/指纹|
|:--|:--|:--|
|stanford|https://web.stanford.edu/class/cs110l/|已抓取，核读未登记；`14b5bac610caac31ccacaa02ce175ef4ef64e2c295d51243fb8b241e6400362b`|
|mit|https://pdos.csail.mit.edu/6.S081/2020/schedule.html|已抓取，核读未登记；`51dba52b81500e5be2b6619ec33d8aad74fc7994caacd680dc8206e0d7a17d5b`|
|rcore|https://rcore-os.cn/rCore-Tutorial-Book-v3/chapter8/index.html|已抓取，核读未登记；`0f096f6dffde9b08380b5b62dc91bff7a89258203ae785a07b814a381021df18`|
|atomic|https://doc.rust-lang.org/std/sync/atomic/|sections.json指定部分已核读；`334049770f651566ff55fe943fc1343423c5df17c309b82ebabeb76128febc3a`|
|future|https://doc.rust-lang.org/std/future/trait.Future.html|sections.json指定部分已核读；`5c623888192b21805435e31151ecbf442f35db51e75848f3e8377b32cc53018d`|
|wake|https://doc.rust-lang.org/std/task/trait.Wake.html|sections.json指定部分已核读；`c4b372e6e2a51d158d9595dee1a65df6f6913cb84b8b1cfbb4597ce620a143e7`|
|stanford-thread-notes|https://web.stanford.edu/class/cs110l/lecture-notes/lecture-13-2022|sections.json指定部分已核读；`4a3b8a1a095ecbc646b0e6d47b26e95b26fae58fa1021410a305b7701d329077`|
|mit-lock-notes|https://pdos.csail.mit.edu/6.S081/2020/lec/l-lockv2.txt|sections.json指定部分已核读；`f4e6ede492bb98a8fa93706175143cd1edf6333a0519d27a2c7f604f51f0d894`|
|rcore-lock|https://rcore-os.cn/rCore-Tutorial-Book-v3/chapter8/2lock.html|sections.json指定部分已核读；`7684f01f14641ba6e243ec99b0812a8f28c62334e1b3934d4dc81c9fb8cba468`|
|stanford-process-slides|https://web.stanford.edu/class/cs110l/slides/lecture-10-2022.pdf|sections.json指定部分已核读；`7f327718206c5dbf7dcfa3c22aa3c5189c7c88483cf555741eea967d0847962a`|
|mit-scheduling|https://pdos.csail.mit.edu/6.S081/2020/lec/l-threads.txt|sections.json指定部分已核读；`46a326635714fd1c23bd76a2c77a4ca3a8df85c15735ee431452a50870665af3`|
|tokio-runtime|https://docs.rs/tokio/1.54.0/tokio/runtime/index.html|sections.json指定部分已核读；`81287ea29e21449548dbb6d2625bc9ca6445e91bf46538ddbdd24dc188425473`|
|tokio-blocking|https://docs.rs/tokio/1.54.0/tokio/task/fn.spawn_blocking.html|sections.json指定部分已核读；`411f779f1b7760b3b61e29998c53ee82279b9c3294cfd77e5c029aa7c8f8982b`|
|tokio-process|https://docs.rs/tokio/1.54.0/tokio/process/index.html|sections.json指定部分已核读；`1f5e86b178fabd15d36c36da263e06f5a2c7dac5cb4cace3a62640fb6e190a9f`|
|std-child|https://doc.rust-lang.org/1.99.0/std/process/struct.Child.html|sections.json指定部分已核读；`df350e4b16e6a22897da447eaabee8f94e24120c6d5196e1c912cb8dcf6b5442`|
|compiler-web-thir|https://rustc-dev-guide.rust-lang.org/thir.html|sections.json指定部分已核读；`8f345529dc5f9e59e813abb8d6ea58def3cc9839a89f0a142fb56fc76461e1db`|
|compiler-web-drop-elaboration|https://rustc-dev-guide.rust-lang.org/mir/drop-elaboration.html|sections.json指定部分已核读；`1b8044c6015a398cbc5829a7dfde97f02e1334d3d0bb3b20fb46ebd67f701221`|
|compiler-web-aliasing|https://doc.rust-lang.org/nomicon/aliasing.html|sections.json指定部分已核读；`cbbfc595f863dd608be9e095b3a6efb70c2f54e9b413f1494b5a9e75667463e0`|
|compiler-web-pgo|https://doc.rust-lang.org/rustc/profile-guided-optimization.html|已抓取，核读未登记；`955a07f3d9d6328b0d344581b98248adbfa1f506372a1cceb70eab170c98ba66`|
|EVID-cargo-features|https://doc.rust-lang.org/cargo/reference/features.html|sections.json指定部分已核读；`78c663fe82a9c62d4f7b7c9ebebfd8a736ee81b2e601f2b07fdf316aa68e0700`|
|EVID-cargo-profiles|https://doc.rust-lang.org/cargo/reference/profiles.html|sections.json指定部分已核读；`2178bd9b63c5be9e3546b765d1ed6aad92efefee50923e4f54dc292b50954773`|
|EVID-rustc-pgo|https://doc.rust-lang.org/rustc/profile-guided-optimization.html|sections.json指定部分已核读；`955a07f3d9d6328b0d344581b98248adbfa1f506372a1cceb70eab170c98ba66`|
|EVID-cachegrind|https://valgrind.org/docs/manual/cg-manual.html|sections.json指定部分已核读；`40fd719bcc25649892cf5ada0d9ed87a8bf8f6efd01cabe71792877b50153955`|
|EVID-perf-event|https://man7.org/linux/man-pages/man2/perf_event_open.2.html|sections.json指定部分已核读；`03b609628cc896b110cc98dfc8b39fd169c39dc129bb47d62b918995066cd3ae`|
|EVID-cargo-resolver|https://doc.rust-lang.org/cargo/reference/resolver.html|sections.json指定部分已核读；`dd1d061ca25ca5570df0ee0f4840e6b7ee12d7e0d9c633396520e9d3402e2d50`|
|FFI-CATCH|https://doc.rust-lang.org/std/panic/fn.catch_unwind.html|sections.json指定部分已核读；`535eb1e0371946ca50fd476944eaf0411ba5ff393a53702c3d46587804a3b873`|
|FFI-SLICE|https://doc.rust-lang.org/std/slice/fn.from_raw_parts.html|sections.json指定部分已核读；`c6afe18f51c844c7d48fb732865c4a4c18a15443c9d9277c7e30f93645c3a7ce`|
|FFI-REPR|https://doc.rust-lang.org/reference/type-layout.html|sections.json指定部分已核读；`d407581c2d5516e63df34253f7029c2c90f7bb6c238ecccf89a5c17ba5b1b564`|
|FOUNDATIONS-PTR|https://doc.rust-lang.org/std/ptr/index.html|sections.json指定部分已核读；`14f0960be8361339aa7798e198b3f602d4c0b2b182b1bbfe904b095ff66081db`|
|FOUNDATIONS-OPTION|https://doc.rust-lang.org/std/option/index.html|sections.json指定部分已核读；`08969609f3591ba394bbe6b2b9f3dca1c96b25c7dcfa9c8f83b62c63803d99ea`|
|FOUNDATIONS-BLACK_BOX|https://doc.rust-lang.org/std/hint/fn.black_box.html|sections.json指定部分已核读；`4343593cafcaf72edc25626a0c256afe2c334d3fcebe7f56db13bd6013dc86f9`|
|systems-mit-rcu|https://pdos.csail.mit.edu/6.828/2024/lec/l-rcu.txt|sections.json指定部分已核读；`34201a6f5cbd841956c25b1c4a113a71a576a0f8697f700072399af8208306a6`|
|systems-target-feature|https://doc.rust-lang.org/reference/attributes/codegen.html|sections.json指定部分已核读；`18becca8e376dd8bc0bc8ee557ece8a2bb9053fbff23bc572c5351fbf42062c7`|
|systems-uring|https://man7.org/linux/man-pages/man7/io_uring.7.html|sections.json指定部分已核读；`1ed71f55954959fc551915363b054c62fb28ba57ede487303d4cb2de0057feb9`|
|systems-uring-cancel|https://man7.org/linux/man-pages/man3/io_uring_prep_cancel.3.html|sections.json指定部分已核读；`0f9c226cb76cc8df73dbd6399e4cbe83e0db82ac62f925780968677da241e32b`|
|systems-rcore-io|https://rcore-os.cn/rCore-Tutorial-Book-v3/chapter6/1fs-interface.html|sections.json指定部分已核读；`55ff0cac446a27bc0485d3c65e664193dd8dba6819a4112f4531c33a0a70fb97`|
|tokio-runtime-code|tokio@1.54.0/src/runtime/mod.rs|175–406；`dd4f9572e9097700820931f7e0d14a63b45f59434e635693187643eff3cb3e88`|
|tokio-state-code|tokio@1.54.0/src/runtime/task/state.rs|1–374；`8b836adf0874bb00e9e61efec6d15010619f0acc23680e2fc23e856b1fa9ffce`|
|tokio-ct-code|tokio@1.54.0/src/runtime/scheduler/current_thread/mod.rs|446–477；`334bcc00033b8de1a1b4f669bba00ebb56442b75328aa0196bc47082e7e6a0cc`|

## 开放技术问题

无登记中的开放问题；历史失败与修复证据仍保留。独立审计另有不可替代的门禁。

## 发布口径

来源裁决闭合不是发布认证。发布还要求16章、每章实验、两个项目测试、代码生成/测量证据和连续两轮独立0 P0/P1。
`python3 tools/build_coverage.py --strict`与`python3 tools/verify_all.py --release`分别验证来源/审计与完整执行链。
