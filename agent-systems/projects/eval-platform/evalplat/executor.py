"""执行器：校验、授权、超时、重试、结构化结果。"""

from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from evalplat.registry import RegistryError, Tool, ToolRegistry


class TransientError(Exception):
    """可重试的瞬时错误；非瞬时错误不要用它。"""


@dataclass
class ExecResult:
    ok: bool
    data: dict[str, Any] | None
    error: dict[str, Any] | None
    attempts: int
    latency_ms: int
    cost_units: int


@dataclass
class Executor:
    registry: ToolRegistry
    scope: str = "eval:run"
    retries: int = 0
    timeout_ms: int = 500
    fail_once: bool = False
    attempts_seen: dict[str, int] = field(default_factory=dict)

    def call(self, name: str, args: dict[str, Any]) -> ExecResult:
        try:
            tool = self.registry.validate(name, args, scope=self.scope)
        except RegistryError as exc:
            return ExecResult(False, None, {"code": exc.code, "message": exc.message,
                                            "retryable": False},
                              attempts=0, latency_ms=0, cost_units=0)

        attempts = 0
        cost = 0
        latency = 0
        last_error: dict[str, Any] | None = None
        for _ in range(self.retries + 1):
            attempts += 1
            cost += tool.cost_units
            latency += tool.latency_ms
            if tool.latency_ms > self.timeout_ms:
                last_error = {"code": "ETIMEDOUT",
                              "message": f"{tool.key} exceeded {self.timeout_ms}ms",
                              "retryable": True}
                continue
            key = f"{tool.key}:{args.get('query', '')}" if tool.name == "flaky.search" else tool.key
            seen = self.attempts_seen.get(key, 0)
            self.attempts_seen[key] = seen + 1
            if self.fail_once and seen == 0 and tool.name == "flaky.search":
                last_error = {"code": "ETRANSIENT", "message": "temporary backend error",
                              "retryable": True}
                continue
            try:
                data = tool.handler(args)
            except PermissionError as exc:
                return ExecResult(False, None, {"code": "EPERM", "message": str(exc),
                                                "retryable": False},
                                  attempts, latency, cost)
            except ValueError as exc:
                return ExecResult(False, None, {"code": "EINVAL", "message": str(exc),
                                                "retryable": False},
                                  attempts, latency, cost)
            except TransientError as exc:
                last_error = {"code": "ETRANSIENT", "message": str(exc), "retryable": True}
                continue
            return ExecResult(True, data, None, attempts, latency, cost)

        return ExecResult(False, None, last_error, attempts, latency, cost)


# --------------------------------------------------------------------------- #
# mock 工具：确定性，无网络
# --------------------------------------------------------------------------- #

def _math_add(args: dict[str, Any]) -> dict[str, Any]:
    return {"sum": args["a"] + args["b"]}


def _lookup_order(args: dict[str, Any]) -> dict[str, Any]:
    oid = args["order_id"]
    last = int(oid[-1])
    status = "paid" if last <= 4 else "cancelled"
    return {"order_id": oid, "status": status, "refundable_cents": 20000 if status == "paid" else 0}


def _lookup_order_v2(args: dict[str, Any]) -> dict[str, Any]:
    """v2 的回归：把 cancelled 也报成 paid（模拟字段口径变更）。"""
    data = _lookup_order(args)
    data["status"] = "paid"
    data["refundable_cents"] = 20000
    return data


def _billing_refund(args: dict[str, Any]) -> dict[str, Any]:
    amount = args["amount_cents"]
    if amount > 20000:
        raise PermissionError("amount exceeds refundable_cents")
    return {"refunded_cents": amount, "idempotency_key": args.get("idempotency_key")}


def _flaky_search(args: dict[str, Any]) -> dict[str, Any]:
    return {"hits": [f"doc-{args['query']}-1", f"doc-{args['query']}-2"]}


def build_registry(version: str = "v1") -> ToolRegistry:
    if version not in {"v1", "v2"}:
        raise ValueError(f"unknown tool version: {version}")
    reg = ToolRegistry()
    reg.register(Tool(
        name="math.add", version="v1", description="整数加法",
        schema={"type": "object", "properties": {"a": {"type": "integer"},
                                                 "b": {"type": "integer"}},
                "required": ["a", "b"], "additionalProperties": False},
        cost_units=1, latency_ms=20, scope="eval:run", handler=_math_add,
    ))
    reg.register(Tool(
        name="lookup.order", version="v1", description="查询订单状态",
        schema={"type": "object", "properties": {"order_id": {"type": "string"}},
                "required": ["order_id"], "additionalProperties": False},
        cost_units=2, latency_ms=40, scope="eval:run",
        handler=_lookup_order if version == "v1" else _lookup_order_v2,
    ))
    reg.register(Tool(
        name="billing.refund", version="v1", description="退款",
        schema={"type": "object", "properties": {
                    "order_id": {"type": "string"},
                    "amount_cents": {"type": "integer", "maximum": 50000},
                    "idempotency_key": {"type": "string"}},
                "required": ["order_id", "amount_cents", "idempotency_key"],
                "additionalProperties": False},
        cost_units=5, latency_ms=80, scope="eval:run", handler=_billing_refund,
    ))
    reg.register(Tool(
        name="flaky.search", version="v1", description="偶尔失败 1 次的搜索",
        schema={"type": "object", "properties": {"query": {"type": "string"}},
                "required": ["query"], "additionalProperties": False},
        cost_units=2, latency_ms=30, scope="eval:run", handler=_flaky_search,
    ))
    return reg
