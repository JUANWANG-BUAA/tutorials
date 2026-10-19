# 第 12 章实验：策略引擎 + 审批工作流

纯标准库、确定性、无网络。三个代码文件分工如下：

| 文件 | 作用 | 关键点 |
|:--|:--|:--|
| `policy_engine.py` | 主体/动作/资源/上下文 → allow / require_approval / deny | 策略版本、优先级、默认拒绝、dry-run、JSONL 哈希链 |
| `approval_flow.py` | 风险分级、四眼、超时、break-glass | 状态机、审批人角色、审计事件 |
| `test_governance.py` | 16 条回归测试 | 优先级、默认拒绝、超时、break-glass、权限漂移 |

## 运行

```bash
cd agent-systems

# 1) 策略引擎：一次 allow、一次 require_approval、一次 deny、一次 dry-run
python3 experiments/ch12/policy_engine.py demo --log /tmp/ch12-decisions.jsonl

# 2) 审批工作流：五个步骤（自动 / 单人 / 四眼 / 超时 / break-glass）
python3 experiments/ch12/approval_flow.py demo --log /tmp/ch12-approvals.jsonl

# 3) 回归测试
python3 -m unittest discover -s experiments/ch12 -v

# 4) 验证哈希链与统计
python3 experiments/ch12/policy_engine.py verify /tmp/ch12-decisions.jsonl
python3 experiments/ch12/policy_engine.py stats  /tmp/ch12-decisions.jsonl
python3 experiments/ch12/approval_flow.py stats  /tmp/ch12-approvals.jsonl
```

`demo` 默认重建日志（覆盖同名文件）；加 `--append` 可追加。两次 demo 的时钟都是固定的，
所以同一版本代码的输出逐字可复现。

## 策略语义

规则按 `(-priority, -effect_rank, rule_id)` 排序，第一条命中即获胜：

1. `priority` 高的先匹配；
2. 同 `priority` 时，`deny > require_approval > allow`，平局永远偏保守；
3. 没有规则命中 → `deny`，`reason=default_deny`；
4. 规则条件抛异常 → `deny`，`reason=policy_error:<Exception>`，不静默跳过。

默认策略包 `build_bundle(version, high_value_threshold)` 演示四类规则：

- `break-glass-prod-destructive`：生产破坏性动作，带 `break_glass=true` 与 `incident_id` 时
  放行，并附加 `security_notify` / `post_review_within_24h` 义务（审批挪到事后复核）；
- `deny-prod-destructive`：其余生产破坏性动作直接拒绝；
- `deny-cross-tenant`：跨租户默认拒绝；
- `require-approval-*`：大额退款、生产首次写、敏感导出；
- `allow-own-tenant-read` / `allow-small-refund`：低风险直通。

改阈值即得到新版本：同一个 200,000 分退款请求，在阈值 500,000 的 `2026.10.1` 下是
`allow`，在阈值 100,000 的 `2026.10.2` 下是 `require_approval`。两条决策都会带上各自的
`policy_version`，因此事后能回答「当时按哪版策略放行」。

## 审批语义

`grade()` 是确定性的四档分级：

| 等级 | 典型条件 | 审批人数 | 超时降级 |
|:--|:--|--:|:--|
| low | 只读（含生产只读） | 0（自动） | 不适用 |
| medium | 首次、金额 ≥ 50,000、非只读生产操作 | 1 | `deny` |
| high | 不可逆、金额 ≥ 500,000、跨租户、生产写 | 2（四眼） | `deny` |
| critical | 生产破坏性、跨租户 + PII、金额 ≥ 5,000,000 | 2，且含 security | `deny_and_page_oncall` |

四条硬约束：

- **自批无效**：`approver == requester` 时记 `self_approval`，不计入审批人数；
- **四眼**：high/critical 必须两名不同审批人；重复审批人记 `duplicate_approver`；
- **超时 fail-closed**：到达 deadline 仍未凑够人数 → `denied`，写 `approval_timeout`，并把 `degraded_to`（如 `deny_and_page_oncall`）写进状态与日志；
- **break-glass 留痕**：没有 `incident_id` 直接拒绝；有事件号则放行，但写
  `break_glass_used`，带 24 小时事后复核期限与 `post_review_within_24h` 义务。

## 审计日志

所有事件写入同一个 append-only JSONL。每条记录：

```json
{"seq":1,"event_id":"evt-000001","recorded_at":"...","event_type":"policy_decision",
 "actor":"analyst-7","action":"read","resource":"invoice:INV-1042",
 "resource_tenant":"acme","policy_version":"2026.10.1","decision":"allow",
 "obligations":[],"evidence":{"request_id":"req-001","reason":"同租户只读操作允许",
 "matched_rule":"allow-own-tenant-read","context":{"environment":"prod"}},
 "prev_hash":"0000...","hash":"..."}
```

`hash = SHA-256(canonical(除 hash 外的全部字段))`，`prev_hash` 指向上一条的 `hash`。
`verify` 会从第一条重算：任何一条被改动、删除或插入，都会在对应行报 `hash 不匹配` 或
`prev_hash 不匹配`。

这**不是**不可篡改存储。哈希链只能证明「日志与链头一致」；能重写整条链的人可以重算所有
哈希。生产环境要把链头定期锚定到 WORM 存储、独立账号或外部时间戳服务，并限制日志写入者
与删除者的权限。

## 权限漂移

`detect_permission_drift(granted, used)` 对比两个映射：

- `unused`：授予了但窗口期内从未使用 → 回收候选；
- `ungranted`：使用了但从未授予 → 越权、旁路或日志缺口，必须先查原因。

```python
import sys
sys.path.insert(0, "experiments/ch12")
from policy_engine import detect_permission_drift

report = detect_permission_drift(
    {"agent-1": {"repo:read", "prod:deploy"}},
    {"agent-1": {"repo:read"}, "agent-2": {"secret:read"}},
)
report.to_dict()
# {'clean': False,
#  'unused': {'agent-1': ['prod:deploy']},
#  'ungranted': {'agent-2': ['secret:read']}}
```

## 限制

- 策略条件是 Python 函数，不是 Rego/Cedar 那样的声明式语言；本章用它讲清语义，不把它当
  生产策略语言。
- 审批人是字符串 id，没有接身份提供商；四眼只校验「不同 id」，不校验「不同自然人」。
- 哈希链没有签名，不能防拥有写权限的攻击者；不要把它当 WORM。
- 时钟是注入的整数秒，没有处理时钟漂移；生产审计要同时记录单调时钟与墙钟。
