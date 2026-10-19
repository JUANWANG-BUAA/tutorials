# CHECK · 《Agent 系统工程》独立核查

本文件是《Agent 系统工程》的**独立事实核查与质量门禁报告**，不属于正文，不参与 mdBook 导航。核查原则：

- 能跑的不信口说：系统调用、shell 语义、统计结果、项目行为都以本仓库真实输出为准；
- 不能跑的标明边界：Linux 专属 C 代码只做 Zig 交叉编译，不伪称在 macOS 上运行；
- 版本先于结论：每个协议/内核/标准结论都写清适用版本；
- 外部规范只引用可查页面，不复制原文，不把博客当规范。

核查时间：2026-10-19（Asia/Shanghai）。基线：Linux 6.8 / Ubuntu 24.04、Python 3.11+、mdBook 0.5.4、mdbook-katex 0.10.0、Bash 5.3（macOS）、Zig 0.17.0。

---

## 1. 结论

| 门禁 | 结果 | 证据 |
|:--|:--|:--|
| `mdbook build` | **通过**（exit 0；0 条 KaTeX/HTML 警告） | §3.1 |
| `check_book.py` | **通过**（0 问题页、0 重复锚点、0 断链、0 重复 id） | §3.2 |
| 覆盖矩阵 | **0 缺口**（163 个母本单元全部有落点） | §4 |
| 全站内链/锚点 | **0 错**（27 个 HTML 页面） | §3.3 |
| 重复 HTML/SVG id | **0** | §3.2、§3.3 |
| 章节行数 | 14/14 在 1000–1400 行 | §2 |
| 代码/实验 | 224 个测试通过；本机可跑实验全绿 | §6 |
| 五条历史错误 | 5/5 已按正确语义写入并附证据 | §5 |
| 根目录集成 | 六本一起构建成功（`_site/`） | §3.4 |

**总体判断**：可以交付。剩余风险集中在「Linux 专属代码未在真实内核上执行」与「外部规范仍在演进」两处，已在 §8 明确列出，不构成隐瞒。

---

## 2. 章节统计

```text
part1/ch01.md  1002  def=5 thm=2 ex=3 intuition=5 method=4 errata=4 note=2 proof=2 sol=1
part1/ch02.md  1207  def=5 thm=1 ex=3 intuition=2 method=3 errata=5 note=3 proof=1 sol=1
part1/ch03.md  1290  def=3 thm=2 ex=3 intuition=2 method=2 errata=2 note=2 proof=2 sol=1
part1/ch04.md  1279  def=3 thm=2 ex=4 intuition=2 method=2 errata=3 note=3 proof=2 sol=1
part2/ch05.md  1262  def=5 thm=3 ex=4 intuition=3 method=3 errata=3 note=3 proof=3 sol=3
part2/ch06.md  1193  def=5 thm=2 ex=3 intuition=4 method=3 errata=2 note=3 proof=2 sol=1
part2/ch07.md  1183  def=5 thm=3 ex=3 intuition=3 method=3 errata=3 note=3 proof=3 sol=3
part2/ch08.md  1269  def=5 thm=3 ex=4 intuition=3 method=3 errata=3 note=3 proof=3 sol=1
part3/ch09.md  1202  def=3 thm=3 ex=3 intuition=3 method=2 errata=2 note=3 proof=3 sol=2
part3/ch10.md  1231  def=4 thm=2 ex=3 intuition=4 method=1 errata=3 note=2 proof=2 sol=1
part3/ch11.md  1207  def=4 thm=2 ex=3 intuition=2 method=3 errata=2 note=2 proof=2 sol=5
part3/ch12.md  1208  def=4 thm=2 ex=4 intuition=3 method=3 errata=2 note=2 proof=2 sol=5
part4/ch13.md  1004  def=4 intuition=2 method=5 errata=3 note=2 sol=1
part4/ch14.md  1009  def=3 intuition=2 method=4 errata=4 note=2 sol=1
TOTAL         16546
```

核查要点：

- 14 章全部在 1000–1400 行，正文合计 16546 行（`check_book` 加上卷首、项目总览与附录为 17962 行）；最短 ch01（1002）、最长 ch03（1290）。
- 每章 11–12 个 H2；内容节 8–9 个，章末固定三节（母本对应 / 本章陷阱 / 本章出口检查）。
- 每章都有：`<pre class="layout">` 或 figure include 的机制图、失败案例、观测命令、`experiments/chNN/` 实验入口、8–15 条陷阱、出口检查与自测。
- 盒子只用 `def/thm/ex/intuition/method/errata/note/proof/sol`；没有 `warning/caution`。ch13/ch14 的 `method` 多于契约建议的 1–3 个，但都是独立清单，不是重复内容；不构成门禁失败。

---

## 3. 构建与结构门禁

### 3.1 mdBook

```text
$ cd agent-systems && mdbook build .
exit=0
Rendering failed: 0
WARN: 0
INFO HTML book written to .../book
```

- 首次构建曾有 7 条 KaTeX 警告，根因是「盒子内的代码块被 mathbook 先渲染成 HTML，KaTeX 看不到反引号，把 `$` 当公式」。已在 `tools/mathbook.py` 增加 `escape_code_dollars()`：只对 `<pre>/<code>` 内的 `$` 换成 `&#36;`，浏览器仍显示 `$`，KaTeX 不再解析。修复后 0 警告。
- 另有 1 条 `bar d` 的 KaTeX 失败，根因是 Python 字符串把 `\b` 解释成退格；已清除源码中的控制字符。
- `notation.md` 里曾有一个真实的 `{{#include ...}}` 示例导致 mdBook 试图读不存在的文件；已改为文字说明。

### 3.2 结构检查

```text
$ python3 tools/check_book.py
pages: 23  chapters: 14  total lines: 17962
OK
```

覆盖项：SUMMARY 页面存在、行数区间、H1/H2 编号与锚点、盒子类型与配平、代码围栏语言、禁用占位符、`chapter-index`、机制图、观测命令、实验入口、失败案例、章末三件套、`.md` 链接与锚点、显式锚点/HTML id/SVG id 唯一、SVG `viewBox/title/desc`、公式定界符。

### 3.3 构建后 HTML

```text
$ python3 tools/check_html.py
html pages: 27
OK
```

覆盖项：每页重复 `id`、站内 `href` 目标存在、带锚点链接的锚点存在。`print.html` 与 404 页也扫描；404 的站内绝对链接被显式跳过。

### 3.4 根目录集成

```text
$ cd .. && ./build.sh
exit=0
[search] 重建完成：约 700 篇文档 ... agent-systems searchindex-*.js
[glossary] agent-systems：38 行 → 35 条术语，标记页面 27 个
optimize_site: ... 13.7M → 9.9M
构建完成：_site/（六本 + 导览页）
```

- `build.sh` 的 `books` 数组已加入 `agent-systems`；CI（`.github/workflows/deploy.yml`）同步。
- `site-index.html`、根 `README.md` 已加第六本入口；未改其他五本的 `SUMMARY.md`/`book.toml`。
- 根 `tools/build_search_js.mjs` 增加 `agent-systems` 探针；`tools/build_glossary.py` 增加术语源配置（35 条，跳过 3 条重复/过短）。

---

## 4. 覆盖矩阵

`python3 tools/build_coverage.py` 输出：**163 个单元，缺口 0**。逐源统计：

| 母本 | 单元 | 完整 | 精选 | 背景 | 交叉引用 | 淘汰 | 缺口 |
|:--|--:|--:|--:|--:|--:|--:|--:|
| Linux 第 2 篇 | 19 | 0 | 1 | 4 | 14 | 0 | 0 |
| Linux 第 3 篇 | 15 | 0 | 0 | 11 | 4 | 0 | 0 |
| Linux 第 5 篇 | 6 | 0 | 0 | 1 | 5 | 0 | 0 |
| 深度学习导论 | 9 | 0 | 0 | 9 | 0 | 0 | 0 |
| MCP 2026-07-28 | 30 | 20 | 9 | 1 | 0 | 0 | 0 |
| OpenAI tools | 11 | 10 | 1 | 0 | 0 | 0 | 0 |
| OCI Runtime 1.3.0 | 15 | 12 | 3 | 0 | 0 | 0 | 0 |
| 论文（26 篇） | 26 | 16 | 5 | 5 | 0 | 0 | 0 |
| 标准（16 项） | 16 | 11 | 5 | 0 | 0 | 0 | 0 |
| man-pages/Bash（16 项） | 16 | 16 | 0 | 0 | 0 | 0 | 0 |
| **合计** | **163** | **85** | **24** | **31** | **23** | **0** | **0** |

「交叉引用」的 23 个单元全部是 Linux 卷/DL 卷已覆盖的 OS/TCP/模型基础；本书只写 agent 落点，不重写。映射脚本会校验「每个编号恰好映射一次、标题存在、落点章存在」，缺口非零时拒绝写页面。

---

## 5. 五条历史错误：逐条核查

| # | 历史错误 | 本书位置 | 正确写法 | 证据 |
|--:|:--|:--|:--|:--|
| 1 | `/proc/PID/stat` 的 exit_code 当低 8 位退出码 | 3.2.2、3.8.2、附录 B.2、13.5 | wait status 是内核编码：低 7 位信号、bit 7 core、高 8 位退出码；`0x2a00` → `WEXITSTATUS=42`；`/proc/PID/stat` 第 52 字段同样是 wait 编码 | `wait_status.c` 真实输出 `raw=0x2a00, WEXITSTATUS=42, low=0x00`；`proc_stat_exit.c` 在 Linux 上预期 `exit_code=10752`；`proc_pid_stat(5)` 明确字段 52 为 wait 形式 |
| 2 | `mq_open`/`sem_open` 写成固定四参数 | 8.3.5、附录 B.3 | 二者是 variadic：带 `O_CREAT` 才传 `mode, attr` / `mode, value`，否则两参数 | `mq_open(3)`、`sem_open(3)` synopsis；`mq_sem_proto.c` 同时写 2/4 参数调用，Zig 交叉编译（x86_64-linux-gnu）通过 |
| 3 | `clone` 的 `child_tid` 参数错位 | 4.6、附录 B.4 | 可变参数顺序 `parent_tid → tls → child_tid`；只设 `CLONE_CHILD_SETTID` 时第三个可变参数才是 `child_tid`；推荐 `clone3` | `clone(2)` 的 glibc wrapper 原型；`clone_order.c` 交叉编译通过；书中给出错位写法的后果 |
| 4 | `TZ` 空值当系统时区 | 10.7.3、附录 B.5 | 空串、无法解释、tzdata 缺失 → UTC；未设置才走 `/etc/localtime`；改 `TZ` 后必须 `tzset()` | 真实输出：`TZ=` 与 `TZ=Not/AZone` 都是 `UTC +0000`；`TZ=` 的 epoch 与 UTC 相同 |
| 5 | `pipefail`/`ulimit`/`jobs` 语义写反 | 3.8.3、13.5、附录 B.6 | `pipefail` 取最右非零；`PIPESTATUS` 保留每段且会被下一条命令覆盖；**bash 不带 `-S/-H` 时同时改软硬**，POSIX/zsh 默认只改软；`jobs` 只列当前 shell 作业 | 真实输出：`pipefail on, status=5`；`PIPESTATUS=3 5 0`；`bash ulimit -n 512 → S=512 H=512`，`zsh → H=unlimited`；子 shell `jobs` 为空 |

补充核查：

- 第 1 条最初在正文中只写了「低 8 位」的否定，没有给出 `0x2a00` 的正解；本次核查要求在 3.2.2 同时给出二进制分解与宏结果，已满足。
- 第 4 条最初只写「空值 → UTC」，没有写 tzdata 缺失；10.7.3 与附录 B.5 已补「静默 UTC」。
- 第 5 条最初把 `ulimit` 默认写成「只改软限」；本次核查发现 **bash 默认同时改软硬**，已同步修正 3.5.1、3.8.3、13.5.2、附录 B.6.2。这是本轮核查发现并修掉的**新错误**，不是原文正确。

---

## 6. 代码与实验

### 6.1 测试统计

| 范围 | 测试数 | 结果 |
|:--|--:|:--|
| ch01 最小内核 | 4 | OK |
| ch02 MCP 双时代 | 20 | OK |
| ch03 沙箱 runner | 7 | OK |
| ch04 Linux 检查器 | 0（脚本，非单测） | 脚本在 macOS 明确跳过 |
| ch05 上下文预算 | 21 | OK |
| ch06 混合检索 | 9 | OK |
| ch07 规划策略 | 12 | OK |
| ch08 多智能体 | 11 | OK |
| ch09 评估统计 | 16 | OK |
| ch10 trace/回放 | 25 | OK |
| ch11 出口守卫 | 37 | OK |
| ch12 策略/审批 | 16 | OK |
| 项目一 code-agent | 24 | OK |
| 项目二 eval-platform | 22 | OK |
| **合计** | **224** | **全过** |

`bash experiments/run_all.sh`：`PASS=18 FAIL=0 SKIP=4`。SKIP 是 Linux 专属检查在 macOS 上的明确跳过（ch04 verify、errata verify-linux 等），不是通过。

### 6.2 真实实验输出（抽查）

```text
$ python3 experiments/ch01/mini_loop.py --mode good
stop_reason=done, steps=3, answer=sum=23

$ python3 experiments/ch01/mini_loop.py --mode loop --max-steps 4
stop_reason=no_progress, steps=3

$ python3 experiments/ch02/mcp_client.py --era 2026 --quiet
checks: ok=28 fail=0
$ python3 experiments/ch02/mcp_client.py --era 2025 --quiet
checks: ok=19 fail=0

$ python3 experiments/ch06/rag_lab.py --eval --k 5 --hybrid --rerank | jq '.macro'
recall@k=0.8462, mrr=0.8462, ndcg@k=0.84, refusal_rate=0.0769

$ python3 experiments/ch09/eval_stats.py --compare
A 35/48 72.9% Wilson [59.0%,83.4%]
B 36/48 75.0% Wilson [61.2%,85.1%]
Δaccuracy +2.08pp, paired 95% CI [-6.2pp,+10.4pp]
ΔP95 +900ms, Δcost +18.0%; gate: REJECT

$ python3 projects/code-agent/run_demo.py --mode good
stop_reason=done, steps=4

$ python3 projects/eval-platform/report.py --suite tool-calling-v1 --runs 2 --gate
baseline 80.0%; retry 100.0%; Δ +0.200 CI [+0.067,+0.367]; PASS
```

这些输出不是装饰：ch09 的「平均准确率 +2pp，但 P95 与成本变差，门禁拒绝」正是第 9.6 与 9.8 节的核心失败案例；项目二的 v2 候选「总分 93.3% 仍被门禁拒绝」对应第 14.7 节。

### 6.3 Linux 专属代码的处理

| 文件 | 本机 | 额外验证 |
|:--|:--|:--|
| `experiments/ch04/harden.c` | 未运行 | Zig 交叉编译 x86_64/aarch64-linux-gnu 通过（ch04 作者记录） |
| `experiments/errata/mq_sem_proto.c` | 未运行 | Zig `x86_64-linux-gnu` 编译通过（本轮核查） |
| `experiments/errata/clone_order.c` | 未运行 | Zig 编译通过；顺带修掉了注释里的嵌套 `/*` 告警 |
| `experiments/errata/proc_stat_exit.c` | 未运行 | Zig 编译通过 |
| `experiments/errata/landlock_probe.c` | 未运行 | Zig 编译通过 |

`verify-linux.sh` 在 macOS 上打印 SKIP；`run_all.sh` 把 ch04 的 SKIP 计为 skip，不计为 pass。

---

## 7. 独立事实核查（抽查表）

| # | 书中结论 | 一手来源 | 核查方式 | 结果 |
|--:|:--|:--|:--|:--|
| 1 | MCP 最新规范是 2026-07-28，上一版 2025-11-25 | <https://modelcontextprotocol.io/specification/2026-07-28/changelog> | 读 changelog 与 llms.txt | 一致 |
| 2 | 2026-07-28 移除协议级 session 与 `initialize` 握手 | 同上 | changelog major changes 1–2 | 一致 |
| 3 | `server/discover` 是 server MUST | 同上 + 2026-07-28 basic 文档 | changelog + 2.5 正文 | 一致 |
| 4 | 结果带 `resultType`；MRTR 用 `inputRequests/inputResponses` | 同上 | changelog 7–8 | 一致 |
| 5 | Roots/Sampling/Logging 弃用；Tasks 移到扩展 | 同上 | changelog Deprecated | 一致 |
| 6 | 错误码 `-32020..-32099` 保留给 MCP | 同上 | changelog minor 12 | 一致 |
| 7 | MCP 默认 JSON Schema 2020-12 | 同上 | changelog minor 10 / SEP-1613 | 一致 |
| 8 | OCI Runtime Spec 基线 v1.3.0（2025-11） | <https://specs.opencontainers.org/runtime-spec/config/?v=v1.2.0> 页面标注 v1.3.0 | 读规范页 | 一致 |
| 9 | OTel semconv 基线 1.44.0 | <https://opentelemetry.io/docs/specs/semconv/gen-ai/> | 页面版本号 | 一致 |
| 10 | Landlock 网络规则是 ABI 4（Linux 6.7），不是 ABI 6 | <https://man7.org/linux/man-pages/man7/landlock.7.html> | VERSIONS 表 | 一致；ch4 明确纠正 |
| 11 | Landlock ABI 6（6.12）加的是 IPC scope | 同上 | VERSIONS 表 | 一致 |
| 12 | `wait` status 0x2a00 → 42；低字节 0 不是退出码 | wait(2)、`wait_status.c` | 真实运行 | 一致 |
| 13 | `/proc/PID/stat` 第 52 字段是 wait 形式 | <https://man7.org/linux/man-pages/man5/proc_pid_stat.5.html> | 字段 52 描述 | 一致 |
| 14 | `mq_open` 有 2 参数与 4 参数两种形式 | <https://man7.org/linux/man-pages/man3/mq_open.3.html> | SYNOPSIS | 一致 |
| 15 | `sem_open` 带 `O_CREAT` 时传 `mode, value` | <https://man7.org/linux/man-pages/man3/sem_open.3.html> | SYNOPSIS/DESCRIPTION | 一致 |
| 16 | glibc `clone` 可变参数为 `parent_tid, tls, child_tid` | <https://man7.org/linux/man-pages/man2/clone.2.html> | SYNOPSIS | 一致 |
| 17 | `TZ=` 空串/无法解释 → UTC | `tzset(3)` + 真实运行 | `TZ= date`、`TZ=Not/AZone date` | 一致 |
| 18 | bash `ulimit` 不带选项同时改软硬；zsh/POSIX 只改软 | bash 手册 + 真实运行 | 两 shell 对比 | 一致；本书已据此修正 |
| 19 | EU AI Act 高风险义务原定 2026-08-02，可能调整 | EU AI Act 官方时间表 + Digital Omnibus 报道 | 正文写「以官方最新时间表为准」 | 一致（保留不确定性） |
| 20 | NIST AI RMF 四函数 Govern/Map/Measure/Manage | NIST AI RMF 1.0 | 正文 12.6.1 | 一致 |
| 21 | ISO/IEC 42001:2023 是 AI 管理体系标准 | ISO 页面 | 正文 12.6.2 | 一致 |
| 22 | OpenAI strict 需要 `additionalProperties:false` 且所有字段 required | OpenAI function calling 文档 | 文档型核查；抓取超时，按已知规范与书中示例交叉检查 | **未完成一手抓取**，见 §8 |

---

## 8. 未验证项与已知限制

1. **Linux 专属运行未执行**：seccomp/landlock/userns/cgroup/netns/`openat2` 的 C 代码与命令没有在真实 Linux 6.8 上运行。已做 Zig 交叉编译（语法/ABI），但不能替代行为验证。第 4 章 `harden.c` 的预期输出标注为「应看到」，不是「已看到」。
2. **OpenAI 文档未完成一手抓取**：`platform.openai.com/docs/guides/function-calling` 抓取超时；strict/parallel/流式字段按公开文档与书中实验交叉检查。若 OpenAI 在 2026 年改动字段，第 2.3 节需要复核。
3. **MCP 仍在演进**：2026-07-28 是最新修订，但 Tasks 扩展、CIMD、header 规范仍可能变；书中把版本写在句子里，并给出 dual-era 探测策略。
4. **EU AI Act 时间表可能被 Digital Omnibus 调整**：12.6.3 明确写「不要当成已钉死」，并建议把合规日历做成配置。
5. **统计样本量小**：ch09 的 48 条、项目二的 30 条都是教学构造数据，置信区间宽；不能当生产基准。
6. **搜索索引体积**：agent-systems 的 `searchindex-*.js` 约 9.6 MB（中文 n-gram 的代价），比其余书大；这是可接受的构建产物，但首次加载会慢。
7. **ch13/ch14 行数贴边**：1004/1009 行，后续增删容易越界；修改后必须重跑 `check_book.py`。
8. **bash 版本差异**：本书在 bash 5.3（macOS）上验证 `ulimit` 默认行为；bash 3.2 与 4.x 的默认行为可能不同，正文已写「以 `help ulimit` 为准，显式 `-S/-H`」。

---

## 9. 复核命令清单

```bash
cd agent-systems
python3 tools/check_book.py --verbose
python3 tools/build_coverage.py
mdbook build .
python3 tools/check_html.py
bash experiments/run_all.sh
python3 tools/verify_all.py          # 以上五步的汇总

# 五条历史错误的本机证据
cc -std=c17 -D_GNU_SOURCE -Wall -Wextra -Werror -O2 experiments/errata/wait_status.c -o /tmp/wait_status
/tmp/wait_status
bash experiments/errata/verify_shell.sh
bash experiments/errata/verify-linux.sh      # macOS 上 SKIP

# Linux 专属 C 的语法/ABI 交叉编译
for f in mq_sem_proto.c clone_order.c proc_stat_exit.c landlock_probe.c; do
  zig cc -target x86_64-linux-gnu -std=c17 -Wall -Wextra -Werror -O2 -c "experiments/errata/$f" -o "/tmp/${f%.c}.o"
done
```

---

## 10. 核查者备注

这份报告不是「自证清白」。它记录了三类东西：

- **能被任何人重跑的证据**（命令、输出、测试数、构建日志）；
- **能指向一手规范的结论**（MCP changelog、man-pages、OCI/OTel 版本页）；
- **不能在本机验证的边界**（Linux-only、OpenAI 抓取、EU 时间表）。

第三类没有被藏起来，也没有被写成「已通过」。如果读者发现某条结论与自己的环境不符，先看 §8 的边界，再按 §9 的命令复现；仍然不符，按 README 的格式提 issue，附环境、命令、真实输出与期望。
