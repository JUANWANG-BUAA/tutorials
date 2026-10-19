#!/usr/bin/env python3
"""第 10 章 · 最小 tracer：trace/span、contextvars 传递、JSONL 输出。

设计目标只有三条：

1. 一个 span 记录足以还原父子关系、耗时、状态与关键属性；
2. trace 上下文用 ``contextvars`` 传递，跨线程时必须显式复制；
3. 默认使用虚拟时钟，同样的参数跑两次输出逐字节相同，便于 diff 与粘贴。

只依赖标准库。真实时间用 ``--clock real``，代价是每次跑耗时约 2 秒且不可复现。
"""

from __future__ import annotations

import argparse
import contextvars
import hashlib
import json
import sys
import threading
import time
from contextlib import contextmanager
from dataclasses import dataclass, field
from datetime import datetime, timezone
from typing import Any, Callable, Iterator

# 2026-10-19T09:00:00Z。虚拟时钟从这里起跳，输出因此可复现。
BASE_EPOCH_NS = 1_792_400_400_000_000_000
FLAGS_SAMPLED = 0x01

# 示例价目（美元 / 百万 token），不是任何厂商的报价；换价格要同时换 price_version。
PRICES = {"gpt-4.1-mini": {"in": 0.40, "out": 1.60}}
PRICE_VERSION = "demo-2026-10"

_current: contextvars.ContextVar["Span | None"] = contextvars.ContextVar(
    "current_span", default=None
)

# 副作用流水：回放测试用它证明「重放没有第二次执行工具」。
SIDE_EFFECTS: list[str] = []


def iso_ns(ns: int) -> str:
    """纳秒时间戳 → RFC 3339（UTC，毫秒精度）。"""
    return datetime.fromtimestamp(ns / 1e9, tz=timezone.utc).isoformat(timespec="milliseconds")


def ms(ns: int | float) -> float:
    return round(ns / 1e6, 3)


class VirtualClock:
    """确定性时钟：时间只在 ``advance_ms`` 时前进。"""

    def __init__(self, base_ns: int = BASE_EPOCH_NS) -> None:
        self._now = base_ns

    def now_ns(self) -> int:
        return self._now

    def advance_ms(self, delta: float) -> None:
        self._now += int(delta * 1e6)


class RealClock:
    """真实时钟：``advance_ms`` 用 sleep 模拟工作耗时。"""

    def now_ns(self) -> int:
        return time.time_ns()

    def advance_ms(self, delta: float) -> None:
        time.sleep(delta / 1000.0)


class SkewedClock:
    """包一层偏移，模拟「另一台机器时钟慢了 N 毫秒」。

    ``now_ns`` 加偏移，``advance_ms`` 推进内层时钟，所以时长仍然正确，
    只有绝对时间戳错位——这正是时钟漂移在 trace 里的形状。
    """

    def __init__(self, inner: Any, offset_ms: float) -> None:
        self.inner = inner
        self.offset_ns = int(offset_ms * 1e6)

    def now_ns(self) -> int:
        return self.inner.now_ns() + self.offset_ns

    def advance_ms(self, delta: float) -> None:
        self.inner.advance_ms(delta)


@dataclass
class Span:
    trace_id: str
    span_id: str
    parent_span_id: str | None
    name: str
    kind: str
    start_ns: int
    end_ns: int | None = None
    status: str = "ok"
    attributes: dict[str, Any] = field(default_factory=dict)
    events: list[dict[str, Any]] = field(default_factory=list)
    links: list[dict[str, Any]] = field(default_factory=list)

    @property
    def duration_ms(self) -> float:
        if self.end_ns is None:
            return 0.0
        return ms(self.end_ns - self.start_ns)

    def to_record(self) -> dict[str, Any]:
        rec: dict[str, Any] = {
            "type": "span",
            "trace_id": self.trace_id,
            "span_id": self.span_id,
            "parent_span_id": self.parent_span_id,
            "name": self.name,
            "kind": self.kind,
            "start": iso_ns(self.start_ns),
            "end": iso_ns(self.end_ns or self.start_ns),
            "start_unix_nano": self.start_ns,
            "duration_ms": self.duration_ms,
            "status": self.status,
            "attributes": self.attributes,
        }
        if self.events:
            rec["events"] = self.events
        if self.links:
            rec["links"] = self.links
        return rec


class Tracer:
    """最小的 tracer：一个进程一个实例，span 列表 + 日志列表。"""

    def __init__(self, *, run_id: str = "support-refund", seed: int = 7,
                 clock: VirtualClock | RealClock | None = None) -> None:
        self.clock = clock or VirtualClock()
        self.run_id = run_id
        self.seed = seed
        self.spans: list[Span] = []
        self.logs: list[dict[str, Any]] = []
        self._span_seq = 0
        self._trace_seq = 0

    # -- id -------------------------------------------------------------
    def _root_trace_id(self) -> str:
        return hashlib.blake2s(f"{self.run_id}:{self.seed}".encode(), digest_size=16).hexdigest()

    def _next_trace_id(self) -> str:
        """第一个 trace 是根，之后的都是「断链」产生的新 trace。"""
        if self._trace_seq == 0:
            tid = self._root_trace_id()
        else:
            raw = f"{self.run_id}:{self.seed}:split:{self._trace_seq}"
            tid = hashlib.blake2s(raw.encode(), digest_size=16).hexdigest()
        self._trace_seq += 1
        return tid

    def _next_span_id(self, trace_id: str) -> str:
        self._span_seq += 1
        raw = f"{trace_id}:{self._span_seq}"
        return hashlib.blake2s(raw.encode(), digest_size=8).hexdigest()

    def traceparent(self, span: Span | None = None) -> str:
        ctx = span or _current.get()
        if ctx is None:
            raise RuntimeError("no current span")
        flags = FLAGS_SAMPLED
        return f"00-{ctx.trace_id}-{ctx.span_id}-{flags:02x}"

    # -- span -----------------------------------------------------------
    @contextmanager
    def span(self, name: str, kind: str,
             attributes: dict[str, Any] | None = None,
             links: list[dict[str, Any]] | None = None,
             trace_id: str | None = None,
             parent: Span | None = None,
             clock: Any | None = None) -> Iterator[Span]:
        """开一个 span。``parent=None`` 时取 contextvar；再取不到就是新 trace。"""
        parent_span = parent if parent is not None else _current.get()
        if parent_span is not None:
            tid, pid = parent_span.trace_id, parent_span.span_id
        elif trace_id is not None:
            tid, pid = trace_id, None
        else:
            tid, pid = self._next_trace_id(), None
        c = clock or self.clock
        span = Span(
            trace_id=tid,
            span_id=self._next_span_id(tid),
            parent_span_id=pid,
            name=name,
            kind=kind,
            start_ns=c.now_ns(),
            attributes=dict(attributes or {}),
            links=list(links or []),
        )
        token = _current.set(span)
        try:
            yield span
        except BaseException as exc:
            span.status = "error"
            span.attributes.setdefault("error.type", type(exc).__name__)
            span.events.append({
                "name": "exception",
                "at": iso_ns(c.now_ns()),
                "attributes": {"exception.type": type(exc).__name__,
                               "exception.message": str(exc)[:160]},
            })
            raise
        finally:
            span.end_ns = c.now_ns()
            _current.reset(token)
            self.spans.append(span)

    # -- log ------------------------------------------------------------
    def log(self, level: str, event: str, **fields: Any) -> None:
        """结构化日志。trace_id/span_id 来自 contextvar，不手填。"""
        ctx = _current.get()
        self.logs.append({
            "type": "log",
            "ts": iso_ns(self.clock.now_ns()),
            "level": level,
            "event": event,
            "run_id": self.run_id,
            "trace_id": ctx.trace_id if ctx else "",
            "span_id": ctx.span_id if ctx else "",
            "fields": fields,
        })

    # -- export ---------------------------------------------------------
    def records(self) -> list[dict[str, Any]]:
        spans = sorted(self.spans, key=lambda s: (s.start_ns, s.span_id))
        logs = sorted(self.logs, key=lambda r: (r["ts"], r["event"]))
        return [s.to_record() for s in spans] + logs

    def dump(self, stream: Any) -> int:
        n = 0
        for rec in self.records():
            stream.write(json.dumps(rec, ensure_ascii=False, sort_keys=True) + "\n")
            n += 1
        return n

    def summary(self) -> dict[str, Any]:
        traces = sorted({s.trace_id for s in self.spans})
        tools = [s for s in self.spans if s.kind == "tool"]
        llms = [s for s in self.spans if s.kind == "llm"]
        tokens_in = sum(int(s.attributes.get("gen_ai.usage.input_tokens", 0)) for s in llms)
        tokens_out = sum(int(s.attributes.get("gen_ai.usage.output_tokens", 0)) for s in llms)
        cost_micros = sum(int(s.attributes.get("app.cost.micros", 0)) for s in llms)
        roots = [s for s in self.spans if s.parent_span_id is None]
        return {
            "run_id": self.run_id,
            "traces": len(traces),
            "spans": len(self.spans),
            "roots": len(roots),
            "steps": sum(1 for s in self.spans if s.kind == "step"),
            "llm_calls": len(llms),
            "tool_calls": len(tools),
            "tool_errors": sum(1 for s in tools if not s.attributes.get("app.tool.ok", True)),
            "input_tokens": tokens_in,
            "output_tokens": tokens_out,
            "cost_micros": cost_micros,
            "logs": len(self.logs),
            "wall_ms": ms(max((s.end_ns or s.start_ns) for s in self.spans)
                          - min(s.start_ns for s in self.spans)) if self.spans else 0.0,
        }


# -- 场景：一个有 3 个决策步的客服 agent ------------------------------------

def llm_attributes(model: str, tokens_in: int, tokens_out: int,
                   finish: str = "tool_calls", decision: dict[str, Any] | None = None) -> dict[str, Any]:
    price = PRICES[model]
    # 每 token 的微美元 = 每百万 token 美元价；因此 tokens × 单价 = 微美元。
    cost = round(tokens_in * price["in"] + tokens_out * price["out"], 3)
    return {
        "gen_ai.operation.name": "chat",
        "gen_ai.provider.name": "demo-provider",
        "gen_ai.request.model": model,
        "gen_ai.response.model": model,
        "gen_ai.response.finish_reasons": [finish],
        "gen_ai.usage.input_tokens": tokens_in,
        "gen_ai.usage.output_tokens": tokens_out,
        "app.cost.micros": int(cost),
        "app.cost.price_version": PRICE_VERSION,
        "app.prompt.template": "support/v3",
        "app.prompt.hash": hashlib.blake2s(f"support/v3:{tokens_in}".encode(),
                                           digest_size=8).hexdigest(),
        "app.decision": decision or {},
    }


def run_in_thread(fn: Callable[[], None], *, break_chain: bool) -> None:
    """跨线程调用。正常路径复制 context；断链路径故意不复制。"""
    if break_chain:
        worker = threading.Thread(target=fn, name="tool-worker")
    else:
        ctx = contextvars.copy_context()
        worker = threading.Thread(target=ctx.run, args=(fn,), name="tool-worker")
    worker.start()
    worker.join()


def run_agent(tracer: Tracer, *, break_chain: bool = False,
              worker_lag_ms: float = 0.0) -> dict[str, Any]:
    """跑一个确定性的 3 步 agent：查退款政策 → 写工单 → 回复。"""
    clock = tracer.clock
    side_effects = 0
    answer = ""

    with tracer.span("invoke_agent support", "run", {
        "gen_ai.operation.name": "invoke_agent",
        "gen_ai.agent.name": "support",
        "gen_ai.conversation.id": "conv-8842",
        "app.task": "查询退款到账时间并更新工单",
    }) as run_span:
        # 第 1 步：模型决定先查知识库
        with tracer.span("step 1", "step", {"app.step.index": 1}):
            with tracer.span("chat gpt-4.1-mini", "llm",
                             llm_attributes("gpt-4.1-mini", 820, 64,
                                            decision={"tool": "kb.search",
                                                      "args_digest": "a41f"})):
                clock.advance_ms(420)
            tracer.log("INFO", "llm.decision", step=1, tool="kb.search",
                       reason="need_policy_evidence")

        # 第 2 步：检索（第一次超时，重试成功）
        with tracer.span("step 2", "step", {"app.step.index": 2}):

            def call_search() -> None:
                with tracer.span("execute_tool kb.search", "tool", {
                    "gen_ai.operation.name": "execute_tool",
                    "gen_ai.tool.name": "kb.search",
                    "gen_ai.tool.call.id": "call_01",
                    "gen_ai.tool.type": "extension",
                    "mcp.method": "tools/call",
                    "app.tool.side_effect": "read",
                    "app.tool.ok": True,
                    "app.tool.attempts": 2,
                    "app.tool.result": {"hits": 3, "top": "billing-refund-sla"},
                    "app.tool.result_digest": hashlib.blake2s(
                        b"billing-refund-sla:3:5d", digest_size=8).hexdigest(),
                }) as tool_span:
                    # 参数在 span 创建前求值，所以 traceparent 必须在 span 内生成，
                    # 否则它指向的是父 span——一个很容易写错的细节。
                    tool_span.attributes["mcp.request.meta.traceparent"] = tracer.traceparent(tool_span)
                    clock.advance_ms(120)
                    tool_span.events.append({
                        "name": "retry",
                        "at": iso_ns(clock.now_ns()),
                        "attributes": {"attempt": 1, "error.type": "ETIMEDOUT"},
                    })
                    tracer.log("WARN", "tool.retry", tool="kb.search",
                               attempt=1, error="ETIMEDOUT")
                    clock.advance_ms(180)
                    tracer.log("INFO", "tool.result", tool="kb.search",
                               ok=True, hits=3, attempts=2)

            call_search()
            tracer.log("INFO", "llm.decision", step=2, tool="ticket.update",
                       reason="write_back_required")

        # 第 3 步：预算守卫 + 审批 + 写工单（副作用）
        with tracer.span("step 3", "step", {"app.step.index": 3}):
            with tracer.span("chat gpt-4.1-mini", "llm",
                             llm_attributes("gpt-4.1-mini", 1240, 72,
                                            decision={"tool": "ticket.update",
                                                      "args_digest": "7c02"})):
                clock.advance_ms(610)
            with tracer.span("guard budget", "guard", {
                "app.guard.decision": "allow",
                "app.guard.rule": "steps_remaining >= 3",
                "app.guard.budget.steps_left": 3,
            }):
                clock.advance_ms(5)
            with tracer.span("approval ticket.write", "approval", {
                "app.approval.decision": "approved",
                "app.approval.approver": "policy:auto",
                "app.approval.required": True,
            }):
                clock.advance_ms(30)

            def call_update() -> None:
                nonlocal side_effects
                worker_clock = SkewedClock(clock, -worker_lag_ms) if worker_lag_ms else clock
                with tracer.span("execute_tool ticket.update", "tool", {
                    "gen_ai.operation.name": "execute_tool",
                    "gen_ai.tool.name": "ticket.update",
                    "gen_ai.tool.call.id": "call_02",
                    "gen_ai.tool.type": "extension",
                    "app.tool.side_effect": "write",
                    "app.tool.idempotency_key": "idem-7f3a91",
                    "app.tool.ok": True,
                    "app.tool.attempts": 1,
                    "app.tool.result": {"ticket": "T-1042", "status": "updated"},
                    "app.propagation": "contextvars" if not break_chain else "missing",
                    **({"app.clock.offset_ms": -worker_lag_ms} if worker_lag_ms else {}),
                }, clock=worker_clock):
                    worker_clock.advance_ms(240)
                    side_effects += 1
                    SIDE_EFFECTS.append("ticket.update")
                    tracer.log("INFO", "tool.result", tool="ticket.update",
                               ok=True, ticket="T-1042", side_effect="write")

            run_in_thread(call_update, break_chain=break_chain)

            with tracer.span("chat gpt-4.1-mini", "llm",
                             llm_attributes("gpt-4.1-mini", 1580, 96, finish="stop",
                                            decision={"final": True})):
                clock.advance_ms(380)
                answer = "退款按支付渠道 3 到 5 个工作日到账，工单 T-1042 已更新。"

    run_span.attributes["app.answer"] = answer
    return {"answer": answer, "side_effects": side_effects}


def run_followup(tracer: Tracer, *, link_trace_id: str, link_span_id: str) -> Span:
    """任务结束后派发的异步投递：独立 trace，用 link 指回原 run。"""
    trace_id = hashlib.blake2s(f"followup:{tracer.seed}".encode(), digest_size=16).hexdigest()
    with tracer.span("execute_tool notify.send", "tool", {
        "gen_ai.operation.name": "execute_tool",
        "gen_ai.tool.name": "notify.send",
        "app.tool.side_effect": "write",
        "app.job.kind": "async_delivery",
    }, links=[{
        "trace_id": link_trace_id,
        "span_id": link_span_id,
        "attributes": {"link.kind": "initiated_by"},
    }], trace_id=trace_id) as span:
        tracer.clock.advance_ms(90)
        tracer.log("INFO", "notify.sent", channel="email", ok=True)
    return span


# -- 渲染 -------------------------------------------------------------------

def _tree_children(spans: list[Span]) -> dict[str | None, list[Span]]:
    ids = {s.span_id for s in spans}
    children: dict[str | None, list[Span]] = {}
    for s in spans:
        parent = s.parent_span_id if s.parent_span_id in ids else None
        children.setdefault(parent, []).append(s)
    for kids in children.values():
        kids.sort(key=lambda s: (s.start_ns, s.span_id))
    return children


def annotate(span: Span) -> str:
    a = span.attributes
    if span.kind == "llm":
        return (f"{a.get('gen_ai.request.model', '?')} "
                f"in={a.get('gen_ai.usage.input_tokens', 0)} "
                f"out={a.get('gen_ai.usage.output_tokens', 0)} "
                f"${int(a.get('app.cost.micros', 0)) / 1e6:.6f}")
    if span.kind == "tool":
        ok = "ok" if a.get("app.tool.ok", True) else "error"
        return (f"{a.get('gen_ai.tool.name', '?')} {ok} "
                f"effect={a.get('app.tool.side_effect', '?')} "
                f"attempts={a.get('app.tool.attempts', 1)}")
    if span.kind == "guard":
        return f"{a.get('app.guard.decision', '?')} {a.get('app.guard.rule', '')}".strip()
    if span.kind == "approval":
        return (f"{a.get('app.approval.decision', '?')} "
                f"by={a.get('app.approval.approver', '?')}")
    if span.kind == "step":
        return f"#{a.get('app.step.index', '?')}"
    if span.kind == "run":
        return str(a.get("app.task", ""))
    return ""


def render_tree(spans: list[Span], stream: Any = sys.stdout) -> None:
    if not spans:
        stream.write("(no spans)\n")
        return
    children = _tree_children(spans)
    starts = {s.span_id: s.start_ns for s in spans}
    roots = children.get(None, [])
    traces: dict[str, int] = {}
    for s in spans:
        traces[s.trace_id] = traces.get(s.trace_id, 0) + 1
    stream.write(f"traces={len(traces)} spans={len(spans)}\n")
    for root in roots:
        stream.write(f"trace {root.trace_id[:12]}…  spans={traces[root.trace_id]}  "
                     f"start={iso_ns(root.start_ns)}\n")

        def walk(span: Span, prefix: str, last: bool) -> None:
            if span is root:
                line = (f"{span.name}  [{span.duration_ms:.0f}ms] {span.status}"
                        f"  {annotate(span)}")
                stream.write(line.rstrip() + "\n")
            else:
                parent_start = starts.get(span.parent_span_id or "", span.start_ns)
                offset = ms(span.start_ns - parent_start)
                mark = " !!" if offset < 0 else ""
                branch = "└─ " if last else "├─ "
                line = (f"{prefix}{branch}{span.name}  [{offset:+.0f}ms "
                        f"+{span.duration_ms:.0f}ms] {span.status}{mark}  {annotate(span)}")
                stream.write(line.rstrip() + "\n")
            for link in span.links:
                pad = "" if span is root else prefix + ("   " if last else "│  ")
                stream.write(f"{pad}   link→{link['trace_id'][:12]}…/{link['span_id'][:8]}… "
                             f"{link.get('attributes', {})}\n")
            kids = children.get(span.span_id, [])
            for i, kid in enumerate(kids):
                nxt = prefix + ("   " if last else "│  ")
                walk(kid, nxt, i == len(kids) - 1)

        walk(root, "", True)
    known = {s.span_id for s in spans}
    for s in spans:
        if s.parent_span_id and s.parent_span_id not in known:
            stream.write(f"orphan {s.name}  parent={s.parent_span_id}  trace={s.trace_id[:12]}…\n")


def render_waterfall(spans: list[Span], stream: Any = sys.stdout, width: int = 44) -> None:
    roots = [s for s in spans if s.parent_span_id is None]
    if not roots:
        return
    root = min(roots, key=lambda s: s.start_ns)
    children = _tree_children(spans)
    total = max((s.end_ns or s.start_ns) for s in spans) - root.start_ns
    scale = max(total, 1)
    stream.write(f"waterfall  root={root.name}  wall={ms(total):.0f}ms  width={width}\n")
    starts = {s.span_id: s.start_ns for s in spans}
    stream.write(f"{'span':<34}{'Δparent':>9}{'dur':>9}  timeline\n")

    def emit(span: Span, depth: int) -> None:
        offset = span.start_ns - starts.get(span.parent_span_id or "", span.start_ns)
        dur = (span.end_ns or span.start_ns) - span.start_ns
        start_col = int(max(0, offset) / scale * width)
        bar_len = max(1, int(dur / scale * width))
        bar = " " * start_col + "#" * max(1, min(bar_len, width - start_col))
        name = "  " * depth + span.name
        flag = "  ! negative offset" if offset < 0 else ""
        stream.write(f"{name[:33]:<34}{ms(offset):>8.0f}ms{ms(dur):>8.0f}ms  |{bar:<{width}}|{flag}\n")
        for kid in children.get(span.span_id, []):
            emit(kid, depth + 1)

    emit(root, 0)


# -- CLI --------------------------------------------------------------------

def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(description="第 10 章最小 tracer")
    p.add_argument("--scenario", default="support", choices=["support"])
    p.add_argument("--out", metavar="PATH", help="JSONL 输出路径；省略则写 stdout")
    p.add_argument("--break-chain", action="store_true", help="跨线程不复制 context，制造断链")
    p.add_argument("--worker-lag-ms", type=float, default=0.0,
                   help="写工具所在机器时钟慢多少毫秒（模拟时钟漂移）")
    p.add_argument("--clock", choices=["virtual", "real"], default="virtual")
    p.add_argument("--seed", type=int, default=7)
    p.add_argument("--tree", action="store_true", help="只打印 span 树")
    p.add_argument("--waterfall", action="store_true", help="打印文本瀑布图")
    p.add_argument("--summary", action="store_true", help="打印 JSON 摘要")
    p.add_argument("--followup", action="store_true", help="追加一条带 link 的异步投递 trace")
    return p


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    clock: Any = VirtualClock() if args.clock == "virtual" else RealClock()
    tracer = Tracer(seed=args.seed, clock=clock)
    result = run_agent(tracer, break_chain=args.break_chain, worker_lag_ms=args.worker_lag_ms)

    if args.followup:
        run_span = next(s for s in tracer.spans if s.kind == "run")
        run_followup(tracer, link_trace_id=run_span.trace_id,
                     link_span_id=run_span.span_id)

    if args.out:
        with open(args.out, "w", encoding="utf-8") as fh:
            tracer.dump(fh)

    if args.summary:
        payload = tracer.summary()
        payload["answer"] = result["answer"]
        payload["side_effects"] = result["side_effects"]
        payload["jsonl"] = args.out or "-"
        print(json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True))
    elif args.waterfall:
        render_waterfall(tracer.spans)
    elif args.tree or args.out:
        render_tree(tracer.spans)
    else:
        tracer.dump(sys.stdout)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
