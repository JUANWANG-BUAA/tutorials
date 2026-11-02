# run-02 归档更正记录

日期：2026-10-30。由独立复审（第 4 轮深审）提出、作者复核确认。**本目录里的原始文件一个字节都没改**——`compaction.csv`、`statistics-compaction.json`、`gate-compaction.json` 保持采集时的原样；这份记录只说明其中一处文字与代码不符。

## 哪一句不符

`gate-compaction.json` 的 `budget_note` 字段（以及生成它的 `run.sh` 第 104 行 `--budget-note` 参数）写着：

> 10 ms per merge: the background compactor runs off the write path and is triggered every 100 ms, so one merge may take at most a tenth of that

后半句「the background compactor … is triggered every 100 ms」在这份代码里没有对应实现。核对方式（任何人可复跑）：

- `grep -n "do_compact" src/engine.rs` → 唯一调用点是写线程处理 `Cmd::Compact` 的分支（`src/engine.rs:565`）；
- `grep -n "compact_two" src/engine.rs` → 对外只有这一个显式提交口（`src/engine.rs:331`）；
- 全仓没有压缩定时器，`src/engine.rs` 里两处 `Duration::from_millis` 都是条件变量的等待超时（50 ms 与 20 ms），不是周期任务。

也就是说：本项目**没有后台压缩调度**，合并只由调用方显式触发。

## 更正后的口径

预算 B = 10 ms/次 是本节事先设定的一条实验契约，锚点是本轮 A 臂自己的单次成本（7,696,326 ns ≈ 7.70 ms），含义是「换成子进程之后多付的那部分，不得超过一次进程内合并的量级」。判定比较的是区间上界与 B：上界 1,586,757 ns ≈ 1.59 ms，既低于 10 ms，也低于更严的 7.70 ms，因此「接受」这条结论不依赖把预算放宽。

正文的对应段落是 `src/part4/ch17.md` 的 17.7.2「实测：子进程这条路的额外代价」，以那里为准。`run.sh` 里那条 `--budget-note` 的文案已同步更正，今后重跑会写进新契约说明。
