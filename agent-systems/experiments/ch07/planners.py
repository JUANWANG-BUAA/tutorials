#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""planners.py — 第 7 章的确定性规划实验（无网络、无第三方依赖）。

同一张小地图、同一组任务、同一份预算，比较三种策略：

  react  每步只看当前观察，按到目标的曼哈顿距离贪心选择动作；
  plan   先用简化模型做 BFS 出完整计划，再执行；偏离计划时重规划；
  tot    有限宽度（beam）搜索 + 价值函数，用完整模型展开候选。

地图符号：
  #  墙          .  地板        S  起点       G  目标
  K  钥匙        D  门（需钥匙）  T  触发器     B  会塌的桥
  g  单向门（默认只能向东通过）

动作：N/E/S/W（移动）、take（捡钥匙）、open（开相邻的门）。
每个动作花费 1；目标是在预算内到达 G。

设计约束（与正文一致）：
  - 环境、策略、预算全部确定性，同一命令两次运行输出逐字节相同；
  - 预算同时限制执行步数与搜索扩展数，三种策略共享同一份预算；
  - plan 的规划器使用「简化模型」：单向门当普通地板、触发器不塌桥。
    这不是 bug，而是正文 7.7 节要复盘的「计划幻觉」：计划引用了执行器
    不支持的效果。真实执行会失败，重规划若仍用同一模型就会重复失败；
  - tot 使用完整模型，因此能看见单向门与塌桥，但扩展数更贵。

用法：
    python3 planners.py --suite
    python3 planners.py --suite --json
    python3 planners.py --task key-door --strategy react --trace /tmp/react.jsonl
    python3 planners.py --task key-door --strategy plan
    python3 planners.py --task one-way-return --strategy tot --width 4
"""

from __future__ import annotations

import argparse
import json
import sys
from collections import deque
from dataclasses import dataclass
from typing import Iterable

# --------------------------------------------------------------------------- #
# 状态空间
# --------------------------------------------------------------------------- #

DIRS = {"N": (-1, 0), "E": (0, 1), "S": (1, 0), "W": (0, -1)}
OPPOSITE = {"N": "S", "S": "N", "E": "W", "W": "E"}
ACTIONS = ("N", "E", "S", "W", "take", "open")


@dataclass(frozen=True)
class Task:
    """一个确定性任务：地图 + 预算 + 可选的特殊地形。"""

    name: str
    rows: tuple[str, ...]
    step_budget: int
    expansion_budget: int
    collapse: tuple[tuple[int, int], ...] = ()
    gate_dir: str = "E"
    note: str = ""


@dataclass(frozen=True)
class State:
    r: int
    c: int
    has_key: bool = False
    door_open: bool = False
    collapsed: bool = False

    def key(self) -> tuple[int, int, bool, bool, bool]:
        return (self.r, self.c, self.has_key, self.door_open, self.collapsed)


@dataclass(frozen=True)
class StepResult:
    state: State
    ok: bool
    error: str | None
    observation: str


@dataclass
class Plan:
    actions: list[str]
    expected: list[State]
    expansions: int


@dataclass
class Outcome:
    task: str
    strategy: str
    success: bool
    stop_reason: str
    steps: int
    expansions: int
    replans: int = 0
    cost: float = 0.0
    detail: str = ""


# --------------------------------------------------------------------------- #
# 地图与转移
# --------------------------------------------------------------------------- #


@dataclass
class Board:
    task: Task
    start: State
    goal: tuple[int, int]
    key: tuple[int, int] | None
    door: tuple[int, int] | None
    trigger: tuple[int, int] | None
    gate: tuple[int, int] | None
    walls: frozenset[tuple[int, int]]
    collapse: frozenset[tuple[int, int]]
    n_rows: int
    n_cols: int


def parse_task(task: Task) -> Board:
    start = goal = key = door = trigger = gate = None
    walls: set[tuple[int, int]] = set()
    for r, row in enumerate(task.rows):
        for c, ch in enumerate(row):
            if ch == "#":
                walls.add((r, c))
            elif ch == "S":
                start = (r, c)
            elif ch == "G":
                goal = (r, c)
            elif ch == "K":
                key = (r, c)
            elif ch == "D":
                door = (r, c)
            elif ch == "T":
                trigger = (r, c)
            elif ch == "g":
                gate = (r, c)
            elif ch in ".B":
                pass
            else:
                raise ValueError(f"{task.name}: 未知地图符号 {ch!r} at {(r, c)}")
    if start is None or goal is None:
        raise ValueError(f"{task.name}: 地图缺 S 或 G")
    width = {len(row) for row in task.rows}
    if len(width) != 1:
        raise ValueError(f"{task.name}: 地图行宽不一致 {width}")
    return Board(
        task=task,
        start=State(*start),
        goal=goal,
        key=key,
        door=door,
        trigger=trigger,
        gate=gate,
        walls=frozenset(walls),
        collapse=frozenset(task.collapse),
        n_rows=len(task.rows),
        n_cols=len(task.rows[0]),
    )


def blocked(board: Board, state: State, r: int, c: int) -> str | None:
    """返回阻挡原因；None 表示地板可走。"""
    if not (0 <= r < board.n_rows and 0 <= c < board.n_cols):
        return "out_of_bounds"
    if (r, c) in board.walls:
        return "wall"
    if state.collapsed and (r, c) in board.collapse:
        return "bridge_collapsed"
    if board.door == (r, c) and not state.door_open:
        return "door_locked"
    return None


def step(board: Board, state: State, action: str, model: str = "real") -> StepResult:
    """执行一个动作。

    model="simple" 是 plan 策略内部的简化模型：单向门当普通地板，
    位于触发器上时不产生塌桥。真实执行永远用 model="real"。
    """
    if action == "take":
        if board.key == (state.r, state.c) and not state.has_key:
            nxt = State(state.r, state.c, True, state.door_open, state.collapsed)
            return StepResult(nxt, True, None, "picked_key")
        return StepResult(state, False, "no_item", "nothing_to_take")

    if action == "open":
        adjacent = {
            (state.r + dr, state.c + dc) for dr, dc in DIRS.values()
        }
        if (
            board.door in adjacent
            and state.has_key
            and not state.door_open
        ):
            nxt = State(state.r, state.c, state.has_key, True, state.collapsed)
            return StepResult(nxt, True, None, "door_opened")
        reason = "no_key" if not state.has_key else "nothing_to_open"
        return StepResult(state, False, reason, reason)

    if action not in DIRS:
        return StepResult(state, False, "bad_action", "bad_action")

    dr, dc = DIRS[action]
    nr, nc = state.r + dr, state.c + dc
    reason = blocked(board, state, nr, nc)
    if reason:
        return StepResult(state, False, reason, reason)

    if model == "real" and board.gate is not None:
        # 单向门：只能沿 gate_dir 进入，也只能沿 gate_dir 离开。
        if (nr, nc) == board.gate and action != board.task.gate_dir:
            return StepResult(state, False, "one_way", "one_way")
        if (state.r, state.c) == board.gate and action != board.task.gate_dir:
            return StepResult(state, False, "one_way", "one_way")

    nxt = State(nr, nc, state.has_key, state.door_open, state.collapsed)
    observation = "moved"
    if (
        model == "real"
        and board.trigger == (nr, nc)
        and not state.collapsed
    ):
        nxt = State(nr, nc, state.has_key, state.door_open, True)
        observation = "trigger_collapsed_bridge"
    return StepResult(nxt, True, None, observation)


def is_goal(board: Board, state: State) -> bool:
    return (state.r, state.c) == board.goal


def manhattan(a: State | tuple[int, int], b: tuple[int, int]) -> int:
    ar, ac = (a.r, a.c) if isinstance(a, State) else a
    return abs(ar - b[0]) + abs(ac - b[1])


# --------------------------------------------------------------------------- #
# 策略一：ReAct（贪心）
# --------------------------------------------------------------------------- #


def choose_react_action(
    board: Board,
    state: State,
    blacklist: dict[str, int],
    visits: dict[tuple[int, int], int],
    last_action: str | None,
    tick: int,
) -> str:
    """手写一个「没有计划」的贪心策略：只看目标的距离 + 已访问次数。"""
    if board.key == (state.r, state.c) and not state.has_key:
        return "take"
    if board.door is not None and not state.door_open and state.has_key:
        if manhattan(state, board.door) == 1:
            return "open"

    ranked: list[tuple[float, int, str]] = []
    for idx, action in enumerate(("N", "E", "S", "W")):
        if blacklist.get(action, -1) > tick:
            continue
        dr, dc = DIRS[action]
        nr, nc = state.r + dr, state.c + dc
        if blocked(board, state, nr, nc):
            continue
        dist = abs(nr - board.goal[0]) + abs(nc - board.goal[1])
        revisit = visits.get((nr, nc), 0)
        reverse = 0.2 if last_action and action == OPPOSITE[last_action] else 0.0
        ranked.append((dist + 3 * revisit + reverse, idx, action))
    if not ranked:
        # 所有方向都被临时拉黑：清空黑名单，允许重新尝试。
        blacklist.clear()
        return "N"
    ranked.sort()
    return ranked[0][2]


def run_react(board: Board, trace: list[dict] | None = None) -> Outcome:
    state = board.start
    steps = 0
    expansions = 0
    blacklist: dict[str, int] = {}
    visits: dict[tuple[int, int], int] = {(state.r, state.c): 1}
    last_action: str | None = None
    stop = "budget"
    while steps < board.task.step_budget:
        if is_goal(board, state):
            break
        action = choose_react_action(board, state, blacklist, visits, last_action, steps)
        result = step(board, state, action, model="real")
        steps += 1
        expansions += 1
        if not result.ok:
            blacklist[action] = steps + 2
        if trace is not None:
            trace.append(
                {
                    "task": board.task.name,
                    "strategy": "react",
                    "step": steps,
                    "action": action,
                    "ok": result.ok,
                    "observation": result.observation,
                    "state": vars(result.state),
                    "value": -manhattan(result.state, board.goal),
                    "expansions": expansions,
                    "steps_left": board.task.step_budget - steps,
                    "expansions_left": board.task.expansion_budget - expansions,
                }
            )
        state = result.state
        visits[(state.r, state.c)] = visits.get((state.r, state.c), 0) + 1
        last_action = action if action in DIRS else last_action
        if is_goal(board, state):
            stop = "done"
            break
    else:
        stop = "budget"
    if is_goal(board, state):
        stop = "done"
    return Outcome(
        task=board.task.name,
        strategy="react",
        success=stop == "done",
        stop_reason=stop,
        steps=steps,
        expansions=expansions,
        cost=cost_of(steps, expansions),
    )


# --------------------------------------------------------------------------- #
# 策略二：Plan-Execute（BFS 计划 + 偏离重规划）
# --------------------------------------------------------------------------- #


def bfs_plan(
    board: Board,
    start: State,
    model: str,
    expansion_budget: int,
    avoid: frozenset[tuple[int, int]] = frozenset(),
) -> tuple[Plan | None, int, str]:
    """BFS 出一条动作最少的计划；返回 (plan, expansions, reason)。

    avoid 是规划器已经观测到、但简化地图上没有的障碍（例如刚塌掉的桥）。
    plan 策略在重规划时把新证据加进来；不更新模型的实现会重复同一份错计划。
    """
    if is_goal(board, start):
        return Plan([], [], 0), 0, "done"
    frontier: deque[State] = deque([start])
    parent: dict[State, tuple[State, str] | None] = {start: None}
    expanded = 0
    goal_state: State | None = None
    while frontier:
        state = frontier.popleft()
        if expanded >= expansion_budget:
            return None, expanded, "budget"
        expanded += 1
        if is_goal(board, state):
            goal_state = state
            break
        for action in ACTIONS:
            result = step(board, state, action, model=model)
            if not result.ok:
                continue
            nxt = result.state
            if (nxt.r, nxt.c) in avoid:
                continue
            if nxt in parent:
                continue
            parent[nxt] = (state, action)
            frontier.append(nxt)
    if goal_state is None:
        return None, expanded, "no_plan"

    actions: list[str] = []
    expected: list[State] = []
    cursor = goal_state
    while parent[cursor] is not None:
        prev, action = parent[cursor]  # type: ignore[misc]
        actions.append(action)
        expected.append(cursor)
        cursor = prev
    actions.reverse()
    expected.reverse()
    return Plan(actions, expected, expanded), expanded, "done"


def run_plan(
    board: Board,
    trace: list[dict] | None = None,
    max_replans: int = 4,
) -> Outcome:
    state = board.start
    steps = 0
    expansions = 0
    replans = 0
    stop = "budget"
    plan: Plan | None = None
    plan_cursor = 0
    last_plan_key: tuple[str, ...] | None = None
    learned: set[tuple[int, int]] = set()

    while steps < board.task.step_budget:
        if is_goal(board, state):
            stop = "done"
            break

        if plan is None or plan_cursor >= len(plan.actions):
            remaining = board.task.expansion_budget - expansions
            if remaining <= 0:
                stop = "budget"
                break
            plan, used, reason = bfs_plan(
                board, state, model="simple", expansion_budget=remaining,
                avoid=frozenset(learned),
            )
            expansions += used
            if plan is None:
                stop = reason
                break
            plan_cursor = 0
            plan_key = tuple(plan.actions)
            if plan_key == last_plan_key:
                # 动作序列相同且模型未更新，视为同一份错计划；生产实现还应比较状态哈希。
                stop = "replan_loop"
                break
            last_plan_key = plan_key
            if trace is not None:
                trace.append(
                    {
                        "task": board.task.name,
                        "strategy": "plan",
                        "step": steps,
                        "action": "__plan__",
                        "ok": True,
                        "observation": f"plan_len={len(plan.actions)} replans={replans}",
                        "plan_actions": plan.actions,
                        "state": vars(state),
                        "value": -len(plan.actions),
                        "expansions": expansions,
                        "steps_left": board.task.step_budget - steps,
                        "expansions_left": board.task.expansion_budget - expansions,
                    }
                )

        action = plan.actions[plan_cursor]
        expected = plan.expected[plan_cursor]
        result = step(board, state, action, model="real")
        steps += 1
        # 执行动作不是搜索扩展；扩展预算只约束 BFS 的节点数。
        if trace is not None:
            trace.append(
                {
                    "task": board.task.name,
                    "strategy": "plan",
                    "step": steps,
                    "action": action,
                    "ok": result.ok,
                    "observation": result.observation,
                    "state": vars(result.state),
                    "value": -manhattan(result.state, board.goal),
                    "expansions": expansions,
                    "steps_left": board.task.step_budget - steps,
                    "expansions_left": board.task.expansion_budget - expansions,
                }
            )
        if not result.ok or result.state != expected:
            state = result.state
            if result.state.collapsed and not expected.collapsed:
                learned.update(board.collapse)
            replans += 1
            if replans > max_replans:
                stop = "replan_limit"
                break
            plan = None
            plan_cursor = 0
            continue
        state = result.state
        plan_cursor += 1
    else:
        stop = "budget"
    if is_goal(board, state):
        stop = "done"
    return Outcome(
        task=board.task.name,
        strategy="plan",
        success=stop == "done",
        stop_reason=stop,
        steps=steps,
        expansions=expansions,
        replans=replans,
        cost=cost_of(steps, expansions),
    )


# --------------------------------------------------------------------------- #
# 策略三：ToT / beam（有限宽度 + 价值函数）
# --------------------------------------------------------------------------- #


def heuristic(board: Board, state: State) -> int:
    """一个可解释的价值函数：先钥匙后门，再走向目标；塌桥加罚。"""
    if board.key is not None and not state.has_key and board.door is not None and not state.door_open:
        h = manhattan(state, board.key) + manhattan(board.key, board.goal) + 2
    else:
        h = manhattan(state, board.goal)
    if state.collapsed:
        h += 6
    return h


def run_tot(
    board: Board,
    trace: list[dict] | None = None,
    width: int = 4,
) -> Outcome:
    start = board.start
    expansions = 0
    steps = 0
    stop = "budget"
    parent: dict[State, tuple[State, str] | None] = {start: None}
    beam: list[State] = [start]
    goal_state: State | None = None

    if is_goal(board, start):
        return Outcome(board.task.name, "tot", True, "done", 0, 0, cost=0.0)

    for depth in range(1, board.task.step_budget + 1):
        candidates: dict[State, tuple[State, str]] = {}
        for state in beam:
            for action in ACTIONS:
                result = step(board, state, action, model="real")
                if not result.ok:
                    continue
                expansions += 1
                if expansions > board.task.expansion_budget:
                    stop = "budget"
                    break
                nxt = result.state
                if nxt in parent or nxt in candidates:
                    continue
                candidates[nxt] = (state, action)
            if expansions > board.task.expansion_budget:
                break
        if expansions > board.task.expansion_budget:
            stop = "budget"
            break
        if not candidates:
            stop = "exhausted"
            break
        ordered = sorted(
            candidates.items(),
            key=lambda item: (heuristic(board, item[0]), item[0].key()),
        )
        beam = []
        for nxt, (prev, action) in ordered[:width]:
            parent[nxt] = (prev, action)
            beam.append(nxt)
            if is_goal(board, nxt):
                goal_state = nxt
                break
        if goal_state is not None:
            break
        if trace is not None:
            trace.append(
                {
                    "task": board.task.name,
                    "strategy": "tot",
                    "step": depth,
                    "action": "__expand__",
                    "ok": True,
                    "observation": "beam=" + ",".join(f"({s.r},{s.c})" for s in beam),
                    "state": vars(beam[0]) if beam else {},
                    "value": -heuristic(board, beam[0]) if beam else 0,
                    "expansions": expansions,
                    "steps_left": board.task.step_budget - depth,
                    "expansions_left": board.task.expansion_budget - expansions,
                }
            )

    if goal_state is None:
        # 搜索失败时没有执行任何动作；depth 只记在 detail 里，不冒充 steps。
        return Outcome(
            board.task.name,
            "tot",
            False,
            stop if not is_goal(board, start) else "done",
            0,
            expansions,
            cost=cost_of(0, expansions),
            detail=f"depth={depth}",
        )

    actions: list[str] = []
    cursor = goal_state
    while parent[cursor] is not None:
        prev, action = parent[cursor]  # type: ignore[misc]
        actions.append(action)
        cursor = prev
    actions.reverse()
    steps = len(actions)
    return Outcome(
        task=board.task.name,
        strategy="tot",
        success=True,
        stop_reason="done",
        steps=steps,
        expansions=expansions,
        cost=cost_of(steps, expansions),
        detail=f"width={width}",
    )


# --------------------------------------------------------------------------- #
# 任务集与运行
# --------------------------------------------------------------------------- #

EXPANSION_WEIGHT = 0.2  # 一次扩展 = 0.2 个动作当量，仅用于统一比较


def cost_of(steps: int, expansions: int) -> float:
    return round(steps + EXPANSION_WEIGHT * expansions, 2)


TASKS: tuple[Task, ...] = (
    Task(
        "open-field",
        (
            "S.....",
            "......",
            "..#...",
            "......",
            "...#..",
            ".....G",
        ),
        step_budget=40,
        expansion_budget=200,
        note="无钥匙无门；三种策略都应成功，比较步数与扩展数",
    ),
    Task(
        "key-door",
        (
            "K..#..",
            "...#..",
            "...#..",
            "S..D..",
            "...#..",
            "...#.G",
        ),
        step_budget=40,
        expansion_budget=200,
        note="钥匙在反方向；ReAct 的贪心不会主动为钥匙绕路",
    ),
    Task(
        "one-way-return",
        (
            ".....#S",
            "G....#.",
            ".....g.",
            ".....#.",
            ".....#.",
            ".......",
        ),
        step_budget=40,
        expansion_budget=200,
        note="单向门只能向东；简化规划器会计划向西返回",
    ),
    Task(
        "collapse-bridge",
        (
            "S#...",
            "T.#..",
            ".B.#.",
            ".B.#.",
            ".B.#G",
            ".....",
        ),
        step_budget=40,
        expansion_budget=200,
        collapse=((2, 1), (3, 1), (4, 1)),
        note="踩到 T 塌桥；计划执行会偏离，触发重规划",
    ),
    Task(
        "detour",
        (
            "S....",
            ".###.",
            ".#G#.",
            ".#.#.",
            ".#...",
            ".....",
        ),
        step_budget=40,
        expansion_budget=200,
        note="U 形墙；贪心距离会先撞墙再绕路",
    ),
    Task(
        "long-corridor",
        (
            "S....",
            "####.",
            "#....",
            "#.#..",
            "#....",
            "####G",
        ),
        step_budget=30,
        expansion_budget=20,
        note="窄走廊 + 小扩展预算；树搜索的宽度在这里是浪费",
    ),
)


def run_suite(width: int = 4) -> list[Outcome]:
    outcomes: list[Outcome] = []
    for task in TASKS:
        board = parse_task(task)
        outcomes.append(run_react(board))
        outcomes.append(run_plan(board))
        outcomes.append(run_tot(board, width=width))
    return outcomes


def format_table(outcomes: Iterable[Outcome]) -> str:
    rows = list(outcomes)
    header = "task                 strategy  ok   stop          steps  exp  replans  cost"
    lines = [header, "-" * len(header)]
    for o in rows:
        lines.append(
            f"{o.task:<20} {o.strategy:<8} {str(o.success):<5} {o.stop_reason:<13} "
            f"{o.steps:>5} {o.expansions:>4} {o.replans:>7}  {o.cost:>5.2f}"
        )
    return "\n".join(lines)


def summarize(outcomes: Iterable[Outcome]) -> list[dict]:
    rows = list(outcomes)
    summary = []
    for strategy in ("react", "plan", "tot"):
        subset = [o for o in rows if o.strategy == strategy]
        wins = [o for o in subset if o.success]
        summary.append(
            {
                "strategy": strategy,
                "success_rate": round(len(wins) / len(subset), 3),
                "avg_steps": round(sum(o.steps for o in wins) / len(wins), 2) if wins else None,
                "avg_expansions": round(sum(o.expansions for o in subset) / len(subset), 2),
                "avg_cost": round(sum(o.cost for o in subset) / len(subset), 2),
            }
        )
    return summary


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="第 7 章：三种规划策略的确定性对比")
    parser.add_argument("--suite", action="store_true", help="跑全部任务并打印对比表")
    parser.add_argument("--task", choices=[t.name for t in TASKS], help="只跑一个任务")
    parser.add_argument("--strategy", choices=("react", "plan", "tot"), help="只跑一种策略")
    parser.add_argument("--width", type=int, default=4, help="tot 的 beam 宽度（默认 4）")
    parser.add_argument("--trace", help="把每一步写成 JSONL")
    parser.add_argument("--json", action="store_true", help="以 JSON 输出")
    args = parser.parse_args(argv)

    if not args.suite and not args.task:
        parser.print_help()
        return 2

    trace: list[dict] | None = [] if args.trace else None
    outcomes: list[Outcome] = []
    if args.suite:
        for task in TASKS:
            board = parse_task(task)
            strategies = (args.strategy,) if args.strategy else ("react", "plan", "tot")
            for strategy in strategies:
                if strategy == "react":
                    outcomes.append(run_react(board, trace))
                elif strategy == "plan":
                    outcomes.append(run_plan(board, trace))
                else:
                    outcomes.append(run_tot(board, trace, width=args.width))
    else:
        task = next(t for t in TASKS if t.name == args.task)
        board = parse_task(task)
        strategies = (args.strategy,) if args.strategy else ("react", "plan", "tot")
        for strategy in strategies:
            if strategy == "react":
                outcomes.append(run_react(board, trace))
            elif strategy == "plan":
                outcomes.append(run_plan(board, trace))
            else:
                outcomes.append(run_tot(board, trace, width=args.width))

    if args.trace and trace is not None:
        with open(args.trace, "w", encoding="utf-8") as fh:
            for row in trace:
                fh.write(json.dumps(row, ensure_ascii=False, sort_keys=True) + "\n")

    if args.json:
        print(json.dumps([vars(o) for o in outcomes], ensure_ascii=False, indent=2))
    else:
        print(format_table(outcomes))
        if args.suite:
            print("\nsummary")
            for row in summarize(outcomes):
                print(json.dumps(row, ensure_ascii=False, sort_keys=True))
    # 失败是实验要观察的结果，不是命令执行失败。
    return 0


if __name__ == "__main__":
    sys.exit(main())
