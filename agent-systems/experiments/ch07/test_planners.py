#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""test_planners.py — 第 7 章实验的契约测试。

测试不评价「哪个策略更聪明」，只验证四件事：
  1. 同一批任务、同一份预算，两次运行结果完全一致；
  2. Plan-Execute 在静态任务上给出最短动作数；
  3. 预算会终止（步数或扩展数有上界）；
  4. 偏离计划会触发重规划，而模型不更新时会识别为重规划循环。

运行：
    python3 -m unittest discover -s experiments/ch07 -v
"""

from __future__ import annotations

import json
import os
import sys
import unittest
from collections import deque

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import planners as p  # noqa: E402


def task_by_name(name: str) -> p.Task:
    return next(t for t in p.TASKS if t.name == name)


def run_one(name: str, strategy: str, width: int = 4) -> p.Outcome:
    board = p.parse_task(task_by_name(name))
    if strategy == "react":
        return p.run_react(board)
    if strategy == "plan":
        return p.run_plan(board)
    return p.run_tot(board, width=width)


def shortest_actions(board: p.Board) -> int | None:
    """独立 BFS：只用来核对 Plan-Execute 的动作数是否最优。"""
    queue: deque[tuple[p.State, int]] = deque([(board.start, 0)])
    seen = {board.start}
    while queue:
        state, depth = queue.popleft()
        if p.is_goal(board, state):
            return depth
        for action in p.ACTIONS:
            result = p.step(board, state, action, model="real")
            if result.ok and result.state not in seen:
                seen.add(result.state)
                queue.append((result.state, depth + 1))
    return None


class TestDeterminism(unittest.TestCase):
    def test_suite_is_reproducible(self) -> None:
        first = [vars(o) for o in p.run_suite()]
        second = [vars(o) for o in p.run_suite()]
        self.assertEqual(first, second)
        self.assertEqual(len(first), len(p.TASKS) * 3)

    def test_trace_is_jsonl(self) -> None:
        trace: list[dict] = []
        board = p.parse_task(task_by_name("key-door"))
        outcome = p.run_react(board, trace)
        self.assertEqual(len(trace), outcome.steps)
        for row in trace:
            encoded = json.dumps(row, ensure_ascii=False, sort_keys=True)
            self.assertIn("action", json.loads(encoded))
            self.assertIn("value", row)
            self.assertIn("expansions_left", row)


class TestOptimalPlan(unittest.TestCase):
    def test_static_tasks_match_reference_bfs(self) -> None:
        for name in ("open-field", "key-door", "detour", "long-corridor"):
            with self.subTest(task=name):
                board = p.parse_task(task_by_name(name))
                expected = shortest_actions(board)
                outcome = p.run_plan(board)
                self.assertTrue(outcome.success, outcome)
                self.assertEqual(outcome.steps, expected)


class TestBudget(unittest.TestCase):
    def test_react_hits_step_budget_without_key_subgoal(self) -> None:
        outcome = run_one("key-door", "react")
        self.assertFalse(outcome.success)
        self.assertEqual(outcome.stop_reason, "budget")
        self.assertEqual(outcome.steps, task_by_name("key-door").step_budget)

    def test_tot_hits_expansion_budget_on_narrow_corridor(self) -> None:
        outcome = run_one("long-corridor", "tot")
        self.assertFalse(outcome.success)
        self.assertEqual(outcome.stop_reason, "budget")
        task = task_by_name("long-corridor")
        self.assertLessEqual(outcome.expansions, task.expansion_budget + 1)

    def test_all_outcomes_respect_budgets(self) -> None:
        for outcome in p.run_suite():
            task = task_by_name(outcome.task)
            self.assertLessEqual(outcome.steps, task.step_budget)
            self.assertLessEqual(outcome.expansions, task.expansion_budget + 1)


class TestReplan(unittest.TestCase):
    def test_bridge_collapse_triggers_one_replan(self) -> None:
        outcome = run_one("collapse-bridge", "plan")
        self.assertTrue(outcome.success)
        self.assertEqual(outcome.replans, 1)

    def test_one_way_makes_plan_repeat_itself(self) -> None:
        outcome = run_one("one-way-return", "plan")
        self.assertFalse(outcome.success)
        self.assertEqual(outcome.stop_reason, "replan_loop")
        self.assertGreaterEqual(outcome.replans, 2)

    def test_tot_models_one_way_and_succeeds(self) -> None:
        outcome = run_one("one-way-return", "tot")
        self.assertTrue(outcome.success)
        self.assertEqual(outcome.steps, 15)


class TestStrategyDifferences(unittest.TestCase):
    def test_react_gets_trapped_by_greedy_distance(self) -> None:
        outcome = run_one("key-door", "react")
        self.assertFalse(outcome.success)

    def test_plan_beats_react_on_key_task_in_cost(self) -> None:
        react = run_one("key-door", "react")
        plan = run_one("key-door", "plan")
        self.assertLess(plan.cost, react.cost)

    def test_tot_costs_more_than_plan_on_simple_field(self) -> None:
        plan = run_one("open-field", "plan")
        tot = run_one("open-field", "tot")
        self.assertGreater(tot.expansions, plan.expansions)
        self.assertGreater(tot.cost, plan.cost)


if __name__ == "__main__":
    unittest.main()
