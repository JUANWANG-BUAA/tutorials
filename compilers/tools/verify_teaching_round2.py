#!/usr/bin/env python3
"""Recompute chapter 5/6/11 teaching examples using only the standard library.

Run from any directory: python3 compilers/tools/verify_teaching_round2.py.
Finite enumeration checks the examples; it is not a proof for all programs.
"""

from itertools import chain, combinations


def verify_monotone_counterexample() -> None:
    """Check monotonicity on the entire four-element lattice, then its cycle."""
    universe = ("a", "b")
    lattice = [
        frozenset(items)
        for items in chain.from_iterable(combinations(universe, k) for k in range(3))
    ]

    def swap(items: frozenset[str]) -> frozenset[str]:
        return frozenset("b" if item == "a" else "a" for item in items)

    for left in lattice:
        for right in lattice:
            if left <= right:
                assert swap(left) <= swap(right)
    middle = frozenset({"a"})
    assert swap(middle) != middle and swap(swap(middle)) == middle
    assert swap(frozenset()) == frozenset()
    assert swap(frozenset(universe)) == frozenset(universe)
    print("ch05: monotone finite-lattice cycle and extreme fixed points verified")


def verify_dominators() -> None:
    """Compare the documented sets with both path avoidance and iteration."""
    graph = {"B0": {"B1"}, "B1": {"B2", "B4"}, "B2": {"B1"}, "B4": set()}

    def reachable_without(target: str, forbidden: str) -> bool:
        pending = [] if forbidden == "B0" else ["B0"]
        seen: set[str] = set()
        while pending:
            node = pending.pop()
            if node == target:
                return True
            if node not in seen:
                seen.add(node)
                pending.extend(graph[node] - seen - {forbidden})
        return False

    def path_dominators() -> dict[str, set[str]]:
        return {
            node: {candidate for candidate in graph if not reachable_without(node, candidate)}
            for node in graph
        }

    expected = {
        "B0": {"B0"}, "B1": {"B0", "B1"},
        "B2": {"B0", "B1", "B2"}, "B4": {"B0", "B1", "B4"},
    }
    assert path_dominators() == expected
    dom = {node: set(graph) for node in graph}
    dom["B0"] = {"B0"}
    for _ in range(2):
        for node in ("B1", "B2", "B4"):
            preds = [p for p in graph if node in graph[p]]
            dom[node] = {node} | set.intersection(*(dom[p] for p in preds))
        assert dom == expected
    graph["B0"].add("B4")
    changed = path_dominators()
    assert changed["B2"] == {"B0", "B1", "B2"}
    assert changed["B4"] == {"B0", "B4"}
    print("ch06: dominator table, back edge and early-exit exercise verified")


def verify_loop_contracts() -> None:
    """Enumerate concrete executions and arbitrary invariant states separately."""
    for step in (2, 3):
        for n in range(101):
            i = 0
            while i < n:
                old_variant = (n - i + step - 1) // step
                i += step
                assert (n - i + step - 1) // step == old_variant - 1
            assert n <= i <= n + step - 1 and i % step == 0
            assert i == step * ((n + step - 1) // step)
            for state_i in range(n + step):
                if state_i % step == 0 and state_i < n:
                    assert state_i + step <= n + step - 1
    assert (2 - 1) % 2 != 0  # counterexample to the original parity postcondition
    for n in range(101):
        i = total = count = 0
        while i < n:
            i += 1
            total += n
            count += 1
            assert total == i * n and 0 <= i <= n
        assert total == n * n and count == n
    print("ch11: step-2/3 invariants, variants and sum-loop counts verified")


def verify_trap_order() -> None:
    """A must-execute division cannot move across visible output when it traps."""
    def run(divisor: int, hoisted: bool) -> tuple[list[int], str]:
        output = []
        try:
            if hoisted:
                quotient = 100 // divisor
                output.append(1)
            else:
                output.append(1)
                quotient = 100 // divisor
            return output, str(quotient)
        except ZeroDivisionError:
            return output, "trap"

    assert run(0, False) == ([1], "trap")
    assert run(0, True) == ([], "trap")
    for divisor in (1, 2, 5):
        assert run(divisor, False) == run(divisor, True)
    print("ch06: must-execute division counterexample preserves trap/output distinction")


if __name__ == "__main__":
    verify_monotone_counterexample()
    verify_dominators()
    verify_loop_contracts()
    verify_trap_order()
