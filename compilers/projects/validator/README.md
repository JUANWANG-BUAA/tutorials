# guard.py · agent 代码验证器

`guard.py` 是《编译器与程序分析》第 14 章的项目实现：对 agent 生成的 Python、C、Rust 代码做静态、编译、受限行为三层门禁，输出 accept / reject / quarantine 三类裁决，并附可复核的证据。

它**不是沙箱**。资源限制只做遏制，不做隔离；没有命名空间、seccomp、landlock、网络隔离或虚拟机边界。不要把本工具用于运行真正不可信的代码。

## 快速开始

要求 Python 3.11+，C 门禁需要 `cc`，Rust 门禁需要 `rustc`（不可用时 SKIP 并说明）。

```bash
cd projects/validator

# 静态 + 编译
python3 guard.py fixtures/good/sum.py

# 静态 + 编译 + 行为，输出完整 JSON
python3 guard.py fixtures/good/sum.py \
  --policy policy.json --compile --run \
  --tests fixtures/tests/sum.json --json

# 只跑静态
python3 guard.py fixtures/bad/agent_alias.py --static-only

# 人类复核视图（完整 JSON 的子集）
python3 guard.py fixtures/good/sum.py --run \
  --tests fixtures/tests/sum.json --brief
```

退出码：`accept=0`、`reject=1`、`quarantine=2`。输入错误（策略非法、夹具缺失、扩展名无法判断）也返回 2，但 JSON 的 `verdict` 是 `null`、`error` 有消息。

## 命令行

| 选项 | 含义 |
|:--|:--|
| `TARGET...` | 文件或目录；目录按扩展名递归匹配 |
| `--lang auto|python|c|rust` | 缺省按扩展名推断 |
| `--policy PATH` | 策略 JSON；缺省使用内置 default |
| `--json` | 输出完整裁决 JSON |
| `--brief` | 输出复核用 JSON 子集，隐含 `--json` |
| `--static-only` | 只跑静态规则，不编译不执行 |
| `--compile` | 显式启用编译门禁（默认已启用） |
| `--run` | 启用行为门禁，需要 `--tests` |
| `--tests PATH` | 行为夹具 JSON |

`--static-only` 不能与 `--run`/`--tests` 同时使用；只给 `--tests` 而不给 `--run` 会报错。

## 裁决协议

```text
findings = static + compile + behavior
active   = apply_policy(findings)   # severity_overrides / allow_rules
m        = max(severity)
m >= reject_at      -> reject
m >= quarantine_at  -> quarantine
else                -> accept
```

默认 `reject_at=high`、`quarantine_at=medium`。编译失败与行为硬失败会追加高危发现；超时、资源命中、无夹具、工具缺失为中危。quarantine 的 `human_review.required` 为 `true`，`status` 为 `pending`。

## 威胁模型

覆盖：危险 API（`os.system`/`subprocess`/`eval`/`exec`/`ctypes`/`socket`）、无限循环、越界写（仅模式级）、网络访问、资源耗尽、别名/`getattr`/宏导致的策略绕过、测试环境嗅探与硬编码输出。

不覆盖：被篡改的编译器/验证器、内核或硬件漏洞、同机内存攻击、语义正确性证明、所有输入上的行为。静态规则是模式匹配，不是抽象解释；行为门禁只覆盖提供的夹具。

## 策略

`policy.json` 的字段：

| 字段 | 默认 | 作用 |
|:--|:--|:--|
| `name` | `default` | 策略名，进证据 |
| `reject_at` | `high` | 达到即 reject |
| `quarantine_at` | `medium` | 达到即 quarantine |
| `execute_below` | `high` | 静态严重度低于此值才执行 |
| `require_tests` | `true` | `--run` 无夹具时是否 quarantine |
| `allow_rules` | `[]` | 抑制规则；被抑制项仍进 `suppressed` |
| `severity_overrides` | `{}` | 按规则覆盖严重度 |
| `max_file_bytes` | `262144` | 单文件大小上限 |
| `sandbox.timeout_s` | `5.0` | 墙钟超时 |
| `sandbox.cpu_s` | `2` | `RLIMIT_CPU` 软限制 |
| `sandbox.address_space_mb` | `512` | `RLIMIT_AS` 请求值；失败时翻倍并记录生效值 |
| `sandbox.file_size_mb` | `1` | `RLIMIT_FSIZE` |
| `sandbox.nofile` | `64` | `RLIMIT_NOFILE` |
| `sandbox.max_output_bytes` | `65536` | 证据保留的输出上限 |
| `sandbox.max_cases` | `20` | 单次行为门禁的 case 上限 |

未知规则、非法严重度、非法 sandbox 数值会让策略加载失败（退出码 2），不会静默忽略。

## 三门禁

| 层 | 命令 | 证明 | 不证明 |
|:--|:--|:--|:--|
| 静态 | `ast` / token 扫描 | 命中规则的结构 | 运行时会做什么 |
| 编译 | `python3 -I -m py_compile` | 可解析、可生成字节码 | import 成功、顶层不抛异常 |
| 编译 | `cc -std=c17 -Wall -Wextra -Werror -fsyntax-only` | 语法/类型/警告 | 链接、运行 |
| 编译 | `rustc --edition 2021 --emit=metadata` | 类型/借用检查 | 代码生成、链接、运行 |
| 行为 | 临时目录 + RLIMIT + timeout + diff | 夹具下的输出/退出码 | 夹具之外、副作用、语义正确 |

行为门禁在运行前会再做一次带链接的编译（C：`cc -std=c17 -O1`；Rust：`rustc --edition 2021 -O`），所以「`-fsyntax-only` 通过但链接失败」会在行为层暴露。

## 行为夹具

单个 case：

```json
{"name": "sum", "stdin": "3 4\n", "stdout": "7\n", "exit_code": 0, "timeout_s": 2}
```

多 case：`{"cases": [ ... ]}`。字段：`name`、`argv`、`stdin`、`stdout`、`exit_code`、`timeout_s`、`files`（相对路径 → 文本内容）。`stdout` 缺省时只比较退出码；给出时按字节精确比较。

case 状态：`pass`、`fail-exit`、`fail-output`、`signal`、`timeout`、`resource`、`error`。超时用 `start_new_session` + `killpg` 杀进程组；仍不覆盖自己 `setsid` 的后代。

## 证据 JSON

完整 JSON 顶层字段：

```json
{
  "tool": "guard.py",
  "schema": 1,
  "target": "fixtures/good/sum.py",
  "language": "python",
  "verdict": "accept",
  "gates": ["static", "compile", "behavior"],
  "policy": {"name": "default", "path": "policy.json", "sha256": "..."},
  "findings": [],
  "suppressed": [],
  "checks": [{"name": "static", "status": "pass", "findings": 0}],
  "evidence": {
    "code_sha256": "...",
    "code_bytes": 274,
    "tests_sha256": "...",
    "commands": [{"kind": "compile", "argv": ["..."], "cwd": "tempdir",
                  "exit_code": 0, "elapsed_ms": 37}],
    "started_at": "2026-10-20T07:50:16+00:00",
    "elapsed_ms": 65
  },
  "human_review": {"required": false, "status": "not_required",
                   "reason": null, "reviewer": null, "decision": null, "notes": null},
  "limits": ["进程级 RLIMIT + 超时，不是命名空间/虚拟机隔离", "..."],
  "behavior": {"status": "pass", "cases": [{"name": "sum", "status": "pass",
               "exit_code": 0, "limits": {"applied": {"cpu_s": 2}, "skipped": []}}]}
}
```

证据要求：源码/策略/夹具哈希、每条命令的 argv/exit code/耗时、case 的 stdout 哈希与资源限制生效值。哈希在开始时计算，运行前后不重算；需要防 TOCTOU 时由接入层复制到只读目录。

## 已知限制

1. **不是隔离**：无文件系统/网络/系统调用隔离。候选代码可写工作目录之外、可联网、可读同 uid 可读的文件。
2. **RLIMIT_AS 在 macOS 上会被降级**：低于当前虚拟地址占用的限制设置失败，代码翻倍直到成功并记录生效值。512 MB 请求在本机生效为 524288 MB，内存耗尽基本不受限。
3. **静态规则会漏**：变量 `getattr`、复杂宏、Rust 过程宏、动态导入组合。非常量 `getattr` 降级为 quarantine，不是放行。
4. **没有 sanitizer**：不插桩 ASan/UBSan，越界写可能静默通过。
5. **oracle 质量未知**：测试通过只证明与夹具一致；夹具可能错，也可能由被测 agent 提供。
6. **输出截断**：stdout/stderr 超过 `max_output_bytes` 后被截断，比较基于截断后的字节；`stdout_truncated` 会进 JSON。
7. **平台依赖**：`resource` 仅 Unix；Rust 工具链需要 `HOME`/`RUSTUP_HOME`（编译器用 `compiler_env`，候选程序用 `clean_env`）。
8. **Rust raw string / 宏**：`c_strip` 只处理普通字符串；raw string 可能让扫描错位。

## 测试

```bash
bash run_tests.sh
```

43 个测试，全部通过标准库 `unittest`，按 CLI 契约调用：

| 组 | 数量 | 覆盖 |
|:--|--:|:--|
| StaticRules | 18 | 别名、`getattr`、误报控制、C 宏、策略、目录 |
| CompileGate | 7 | 编译/警告/链接、Rust 类型检查、import 失败 |
| BehaviorGate | 12 | accept、输出/退出码、超时、FSIZE、嗅探、argv、快照 |
| CliContract | 6 | 退出码、参数冲突、证据字段、扩展名 |

夹具：`fixtures/good`、`fixtures/bad`、`fixtures/quarantine`、`fixtures/c`、`fixtures/rust`、`fixtures/tests`、`fixtures/policies`。`examples/verdict-*.json` 是真实裁决输出，`examples/verdict-*.brief.json` 是复核视图。

## 目录

```text
projects/validator/
├── guard.py
├── policy.json
├── run_tests.sh
├── tests/test_guard.py
├── fixtures/{good,bad,quarantine,c,rust,tests,policies}/
└── examples/verdict-*.json
```

## 加一条规则

1. 在 `RULES` 里登记 id、默认严重度、说明；id 是接口，不改名。
2. 写「应命中」与「不应命中」两个夹具。
3. 在 `tests/test_guard.py` 断言规则 id、行号、退出码。
4. 用 `--static-only` 确认字符串/注释不误报。
5. 更新本章 14.3 的规则表与本 README。

## 声明

本实现是教学项目，优先正确、可读、可复核，不追求工业级隔离或吞吐。它的价值在于把「静态 / 编译 / 行为 / 证据 / 人工复核」拆开，并让每一层的「不能证明什么」写在明面上。
