# CHECK · 《编译器与程序分析》独立核查

本文件是《编译器与程序分析 · 从词法到可验证执行》的独立核查与质量门禁报告，不属于 mdBook 导航。核查原则：

- 能跑的不信口说：章节实验、两个项目、构建与链接检查都以本机真实输出为准。
- 不能跑的标明边界：Linux 链接器、seccomp/landlock、GCC GIMPLE、Z3 等未在本机执行的项目，正文与报告都明确标注。
- 版本先于结论：C17、Rust 2021、LLVM 22.1.8、mdBook 0.5.4、macOS 27 / Apple Silicon。
- 外部文本只作定位，不复制母本原文、代码或图。

核查时间：2026-10-20（Asia/Shanghai）。工作目录：<code>compilers/</code>。

---

## 1. 结论

| 门禁 | 结果 | 证据 |
|:--|:--|:--|
| <code>mdbook build</code> | **通过**，exit 0，0 条 WARN/ERROR | §3.1 |
| <code>check_book.py</code> | **通过**，23 页 / 14 章 / 16,838 行 / 0 问题 | §3.2 |
| 章节行数 | **14/14** 在 1000–1400 行 | §2 |
| 覆盖矩阵 | **84 个单元，缺口 0** | §4 |
| 构建后内链/锚点 | **0 错**，27 个 HTML 页面 | §3.3 |
| 重复锚点/HTML/SVG id | **0** | §3.2、§3.3 |
| 章节实验 | **14/14 通过** | §5.1 |
| 项目一 | 42 用例 × 4 模式，**全过** | §5.2 |
| 项目二 | 43 个测试，**全过** | §5.3 |
| 代码围栏 | 185 个可检查块，**0 失败**；6 个按规则跳过 | §6 |
| 六条历史错误 | 6/6 有正确写法、证据与交叉引用 | §7 |

**判断：可交付。** 剩余风险集中在“没有真实 Linux 链接器/内核”和“有限域枚举不是全称证明”两处，已在 §8 明确列出。

---

## 2. 章节统计

由 <code>tools/audit_stats.py</code> 生成；行数为 <code>wc -l</code>。

| 章 | 文件 | 行数 | H2 | 陷阱 | 布局图 | 实验 |
|--:|:--|--:|--:|--:|--:|:--:|
| 1 | part1/ch01.md | 1158 | 11 | 15 | 2 | Y |
| 2 | part1/ch02.md | 1152 | 11 | 15 | 1 | Y |
| 3 | part1/ch03.md | 1111 | 11 | 15 | 1 | Y |
| 4 | part1/ch04.md | 1111 | 11 | 14 | 2 | Y |
| 5 | part2/ch05.md | 1155 | 11 | 15 | 1 | Y |
| 6 | part2/ch06.md | 1163 | 11 | 15 | 1 | Y |
| 7 | part2/ch07.md | 1151 | 11 | 14 | 6 | Y |
| 8 | part2/ch08.md | 1154 | 11 | 15 | 2 | Y |
| 9 | part3/ch09.md | 1156 | 11 | 13 | 2 | Y |
| 10 | part3/ch10.md | 1151 | 11 | 13 | 1 | Y |
| 11 | part3/ch11.md | 1150 | 11 | 15 | 2 | Y |
| 12 | part3/ch12.md | 1154 | 11 | 15 | 3 | Y |
| 13 | part4/ch13.md | 1156 | 11 | 15 | 2 | Y |
| 14 | part4/ch14.md | 1161 | 11 | 15 | 1 | Y |
| **合计** | | **16,083** | **154** | **204** | **27** | **14/14** |

全书含卷首、项目总览、附录共 23 页、16,838 行。

每章都有：

- <code>chapter-index</code> 与本章回答 / 读完你会；
- 至少一个 <code>&lt;pre class="layout"&gt;</code> 的 IR/数据流/机制图，后有「读图：」；
- 一个 <code>experiments/chNN/</code> 可运行实验；
- 一个 agent 生成代码出错案例（症状→根因→发现→修复）；
- 母本对应表、8–15 条编号陷阱、出口检查表与 method/sol 自测。

14 章的 agent 案例各不相同：

| 章 | agent 出错点 | 抓住它的证据 |
|--:|:--|:--|
| 1 | 跳过语义检查直接 codegen；二元运算先右后左 | VM 运行时报错；栈高度验证仍通过但树/VM 结果不一致 |
| 2 | 把 <code>--</code> 当注释；<code>1..2</code> 贪婪匹配 | token 回查、<code>--buggy</code> 模式退出 1 |
| 3 | 块退出未弹栈，解析到死绑定 | 符号表快照、BindingId、<code>--leak-scope</code> |
| 4 | 循环回边漏 phi | SSA 结构验证 + 解释器结果 0 vs 12 |
| 5 | IN 初始化错（空/全集） | 与朴素迭代逐块对拍，最大不动点偏离 |
| 6 | <code>100/0</code> 折成 0；删 print；错误 LICM | 4 个故意错误全部 mismatch |
| 7 | 调用后复用 caller-saved 寄存器 | 分配后模拟器与未分配 IR 对拍 200 组 |
| 8 | 栈多减 8；<code>movq</code> 写 <code>%eax</code>；误读 x30/PLT | 见证函数、汇编器错误、objdump、24 项 ABI 检查 |
| 9 | 空指针检查被 UB 假设删除 | <code>-O0/-O2</code> 反汇编对照与 ASan |
| 10 | oracle 把两边都错判为通过 | exact / skip-errors / dedup 三种模式对比 |
| 11 | 漏 entry VC + <code>false</code> 不变式制造假证明 | <code>--buggy</code> 输出 CLAIMED-PROVED，补 entry 后 FAIL |
| 12 | 把 RLIMIT 当安全边界 | 继承 fd 读取 secret；绝对路径写出 sandbox |
| 13 | 漏 phi + prologue 多减 8 | <code>verify_ssa</code> 与 asm lint + objdump |
| 14 | 把 RLIMIT 当沙箱；只读 stdout | 写 /tmp 的 side effect 与 exit code/证据字段 |

---

## 3. 构建与结构门禁

### 3.1 mdBook

真实命令：

<pre>
cd compilers
mdbook build .
</pre>

结果：<code>exit=0</code>，日志中 <code>WARN/ERROR</code> 计数为 0，<code>HTML book written</code>。构建过程中曾出现 ch08/ch13 的 HTML 嵌套告警与公式误解析；根因分别是：

- ch08 陷阱第 4 条把 backtick code span 与裸 <code>&lt;strong&gt;</code> 混用，已改为纯 Markdown；
- ch13 表格中的 <code>&lt;code&gt;...&lt;/code&gt;</code> 含 <code>||</code>、<code>*</code>，被 GFM 当作表格分隔符/强调符；已把表格内的 <code>|</code> 与 <code>*</code> 写成 <code>&amp;#124;</code> / <code>&amp;#42;</code>；
- 4 个章节最初使用 <code>~~~</code> 围栏，mdbook-katex 的预处理路径会误读其中的 <code>$</code>；已全部改为反引号围栏。

修复后重新构建，0 告警。

### 3.2 结构检查

<pre>
$ python3 tools/check_book.py
pages: 23  chapters: 14  total lines: 16838  substantial: 14
</pre>

exit 0。覆盖项：SUMMARY 页存在、行数区间、H1/H2 与 <code>sec-compilers.p.c.n</code> 锚点、盒子类型/配平/唯一锚点、代码围栏语言、控制字符、LaTeX 反斜杠丢失、chapter-index、布局图、读图、实验目录、agent 案例、母本对应、8–15 条陷阱、出口检查、跨页链接与锚点、SVG title/desc/viewBox/外部资源。

### 3.3 构建后 HTML

<pre>
$ python3 tools/check_html.py
html pages: 27

OK
</pre>

覆盖：每页重复 <code>id</code>、站内 <code>href</code> 目标、带锚点链接的目标锚点；<code>print.html</code> 与 <code>404.html</code> 也扫描。跨书根路径 <code>/tutorials/</code> 显式跳过（本书不依赖另一本书的构建产物）。

---

## 4. 覆盖矩阵

<pre>
$ python3 tools/build_coverage.py
coverage: 84 units, gap=0
</pre>

| 母本 | 单元 | 完整 | 精选 | 背景 | 交叉引用 | 淘汰 |
|:--|--:|--:|--:|--:|--:|--:|
| 自制编译器 | 15 | 13 | 1 | 0 | 1 | 0 |
| Rust Reference | 16 | 3 | 7 | 5 | 1 | 0 |
| Rustc Dev Guide | 17 | 7 | 5 | 4 | 1 | 0 |
| C 语言现代方法 | 15 | 3 | 7 | 4 | 1 | 0 |
| C++ 程序设计语言 | 12 | 1 | 6 | 5 | 0 | 0 |
| Effective Modern C++ | 9 | 0 | 3 | 6 | 0 | 0 |
| **合计** | **84** | **27** | **29** | **24** | **4** | **0** |

（逐源分项由生成器统计；不同版本的数字可能因分类边界相差 1，总量 84 与缺口 0 固定。）

生成器校验：每个单元恰好出现一次；落点页面存在；落点锚点存在；深度属于五类之一。任一失败就拒绝写文件。<code>coverage.md</code> 是评审副本，链接前缀 <code>src/</code>；书内 <code>src/appendix/coverage.md</code> 使用相对路径。

---

## 5. 实验与项目

### 5.1 每章实验

<pre>
$ bash experiments/run_all.sh
experiments: PASS=14 FAIL=0 SKIP=0
</pre>

14 个章实验全部真实运行。章实验的共同边界：

- ch01 流水线、可复现哈希、错误 codegen 差分；
- ch02 最大匹配、注释、span、错误恢复、400 个随机输入；
- ch03 作用域栈、死绑定、C 整数提升、UBSan、Rust 单态化；
- ch04 CFG/支配树/DF/SSA 验证器与并行复制；
- ch05 四种数据流的朴素迭代 vs 工作列表；
- ch06 6 个安全用例 + 4 个故意错误 + pass 顺序；
- ch07 活跃区间/冲突图/图着色/线性扫描/200 组对拍；
- ch08 24/24 ABI 检查（x86-64 经 Rosetta 执行，ARM64 汇编核对）；
- ch09 UBSan/ASan/TSan 真实报告；MSan 在 macOS 不可用，脚本明确 SKIP；
- ch10 固定 seed fuzz，找到并缩减两组除法 bug；
- ch11 WP/VC、反例、漏 entry 的假证明；
- ch12 RLIMIT/超时/fd 继承/越权写、killpg；
- ch13/14 项目验收入口。

### 5.2 项目一：minic

<pre>
$ bash projects/minic/run_tests.sh
cases: 42  modes: 4  asm targets: 28
ALL TESTS PASSED (42 cases, 4 execution modes)
</pre>

- 28 个成功用例 × 4 种执行模式：TAC 解释器、优化后 SSA 解释器、未优化 x86-64、优化后 x86-64。
- 14 个错误用例检查 <code>file:line:col: error:</code> 诊断。
- 每个成功用例生成 Darwin + Linux 汇编；本机用 clang 目标汇编，<code>llvm-objdump</code> 检查 <code>subq</code> 是 16 的倍数、没有 <code>movq</code> 写 32 位寄存器。
- 真实执行使用 Rosetta（<code>arch -x86_64</code>）；Linux 目标只验证汇编，不在 macOS 链接执行。

关键证据：

<pre>
$ python3 projects/minic/minic.py projects/minic/examples/loop.mc --run
5050
$ python3 projects/minic/minic.py projects/minic/examples/loop.mc --run-compiled
5050
$ llvm-objdump -d .../loop.o
subq $0x50, %rsp
</pre>

SSA 在 <code>L0</code> 有 <code>sum</code>/<code>i</code> 两个 phi，操作数与 preds 对应；<code>--opt</code> 输出 <code>folded=2 removed=4</code>。项目保留 <code>tests/agent_bug_demo.py</code>，可复现漏 phi 与 <code>subq $88</code>（0x58，非 16 倍数）。

### 5.3 项目二：validator

<pre>
$ bash projects/validator/run_tests.sh
Ran 43 tests
OK

$ bash experiments/ch14/run.sh
accept       verdict=accept     exit=0
reject       verdict=reject     exit=1
quarantine   verdict=quarantine exit=2
</pre>

覆盖：Python AST 别名/<code>getattr</code> 常量折叠/危险调用；C 注释/字符串状态机与宏别名；Rust 编译门禁；py_compile / cc -fsyntax-only / rustc --emit=metadata；受限执行与字节差分；accept/reject/quarantine 三值裁决；证据 JSON（代码/策略/测试哈希、argv、exit_code、elapsed、human_review）。

真实平台发现：macOS 上 <code>RLIMIT_AS</code> 的 512MB 设置失败，实现翻倍到 524288MB 才生效并把生效值写入证据；<code>side_effect.py</code> 仍能写 <code>/tmp</code>，因此正文明确区分「资源遏制」与「隔离」。

---

## 6. 代码围栏

<pre>
$ python3 tools/check_snippets.py
snippets checked=185 skipped=6 failed=0
</pre>

规则：

- <code>c</code>：<code>cc -std=c17 -fsyntax-only -Wno-everything</code> 从 stdin 检查；
- <code>rust</code>：<code>rustc --edition 2021 --crate-type lib --emit=metadata</code>；
- <code>python</code>：<code>compile()</code>；
- <code>bash</code>：<code>bash -n</code>；
- 带省略号/REPL/objdump 文本/汇编片段的块按规则跳过（6 个）。

最初有 7 个片段失败：6 个是带有 <code>continue</code>/<code>return</code> 的 Python 局部摘录，已改为 <code>text</code> 并保留上下文；1 个 Rust <code>let</code> 绑定示例缺少 <code>fn main</code>，已补全。修复后 0 失败。

这不是“所有代码都可独立运行”的证明：<code>text</code> 片段与省略号片段不会执行；C/Rust 的完整程序另行由项目测试与实验覆盖。

---

## 7. 六条历史错误逐条核查

证据来自 <code>bash experiments/ch08/run.sh</code>（24/24 PASS）与 <code>projects/minic</code> 的 ABI 测试。

| # | 历史错误 | 本书正确写法 | 真实证据 |
|--:|:--|:--|:--|
| 1 | 栈对齐多减 8 | <code>call</code> 前 0 mod 16；callee 入口 8；<code>push %rbp</code> 后 <code>sub</code> 为 16 倍数 | 见证函数 <code>align_ok exit=8</code>、<code>align_bad exit=0</code>；minic 的 <code>subq $0x50</code>；rsp walk 检查每个 call 点 |
| 2 | <code>movq 8(%rdi), %eax</code> 非法 | 32 位目的必须 <code>movl</code> | <code>movq</code> 汇编 rc=1，<code>invalid operand</code>；<code>movl 0x8(%rdi), %eax</code> 成功 |
| 3 | 说 <code>add</code> 的目的不能是内存 | <code>add</code> 可读改写内存；两操作数不能同时内存 | <code>addl %eax,(%rdi)</code> 运行得到 42；<code>addl (%rdi),(%rsi)</code> 汇编 rc=1 |
| 4 | 把 x30 当 callee-saved | x30 是 link register；AAPCS64 callee-saved 为 x19–x28/x29 | <code>_nonleaf</code> 有 <code>stp x29,x30</code> / <code>ldp</code>；<code>_leaf</code> 没有；24/24 检查通过 |
| 5 | PLT 懒绑定跳 <code>_init</code> | 懒绑定经 PLT0，不是 <code>_init</code> | 编译器侧 <code>R_X86_64_PLT32</code> 重定位真实存在；链接器 <code>.plt</code> 在 macOS 无 ELF 链接器，未实测，正文只给 Linux 验证命令并交叉引用 Linux 1.7 |
| 6 | alloc.c 漏 footer | <code>need = align_up(n + HDR + FTR, ALIGN)</code>，112B 回归 | 本书不重写分配器；正文给出 112B 算例（128 vs 144）并交叉引用 Linux 9.9.6；未在本机运行分配器 |

第 5、6 条没有伪称“本机已验证”。第 5 条明确区分编译器重定位与链接器 PLT；第 6 条明确属于 Linux 书的范围。

---

## 8. 已知限制与未实测项

1. **x86-64 执行**：在 Apple Silicon 上经 Rosetta 执行；不是原生 x86-64 硬件。ABI 静态断言与反汇编仍是独立的第二条证据。
2. **Linux 链接器/ELF**：本机没有可用的 x86-64 Linux 动态链接器，PLT0 的链接器侧行为只给验证方法，未实测。
3. **GIMPLE**：本机 <code>gcc</code> 是 Apple clang 的别名，没有真实 GCC dump；第 4 章明确标注未实测，没有伪造 GIMPLE 输出。
4. **SMT/Z3**：第 11 章有 SMT-LIB 片段，但本机未安装 z3；正文标注未执行，实验用有限域枚举/化简，并明确它不是全称证明。
5. **sanitizer 平台边界**：MSan 在 macOS 不可用；ch09 实验显式 SKIP，不把它计为通过。
6. **项目二的安全边界**：validator 使用临时目录、清理环境、超时与 <code>RLIMIT_*</code>，不是命名空间/虚拟机隔离；文件系统、网络、系统调用没有隔离。这一点在 README、ch14 与裁决 JSON 的 <code>limits</code> 字段中重复声明。
7. **项目一语言子集**：无数组/指针/结构体/浮点/全局变量/for/switch/break/continue，最多 6 个 int 参数；除零解释器报错、机器码 SIGFPE；有符号溢出按 32 位回绕；局部变量零初始化。这些是固定语义，不是 L 的 C 子集。
8. **有限测试集**：42 + 43 个测试与 14 个实验证明这些路径，不证明所有输入正确；第 9–11 章明确说明测试、sanitizer、fuzz 与证明的边界。
9. **跨书集成**：本书是独立 book.toml，未改根 <code>build.sh</code>/<code>site-index.html</code> 与其他五本；在线门户若要收录，需要单独加入构建数组与导览，不属于本次交付。

---

## 9. 复现命令

<pre>
cd compilers
python3 tools/build_coverage.py
python3 tools/check_book.py
python3 tools/check_snippets.py
bash experiments/run_all.sh
bash projects/minic/run_tests.sh
bash projects/validator/run_tests.sh
mdbook build .
python3 tools/check_html.py
</pre>

一键门禁：

<pre>
python3 tools/verify_all.py
</pre>

本报告的统计数字来自 2026-10-20 的最终一次运行；若后续修改正文或工具，先重跑上述命令，不要把旧数字当新证据。
