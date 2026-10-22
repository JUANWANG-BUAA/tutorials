#!/usr/bin/env python3
"""An absolute-budget gate, deliberately separate from data collection."""
import math
import unittest


def decide(interval, budget):
    """Interval is candidate-minus-baseline in the same absolute unit as budget."""
    low, high = interval
    if not all(math.isfinite(value) for value in (low, high, budget)):
        raise ValueError('non-finite gate input')
    if low > high:
        raise ValueError('reversed interval')
    if high <= budget:
        return 'accept'
    if low > budget:
        return 'reject'
    return 'inconclusive'


class GateTests(unittest.TestCase):
    def test_accept(self):
        self.assertEqual(decide((-2, -1), 0), 'accept')
        self.assertEqual(decide((0, 1), 1), 'accept')

    def test_reject(self):
        self.assertEqual(decide((2, 3), 1), 'reject')

    def test_inconclusive(self):
        self.assertEqual(decide((0, 2), 1), 'inconclusive')
        self.assertEqual(decide((1, 2), 1), 'inconclusive')

    def test_invalid(self):
        for interval, budget in [((2, 1), 0), ((0, math.inf), 0),
                                 ((math.nan, 1), 0), ((0, 1), math.nan)]:
            with self.assertRaises(ValueError):
                decide(interval, budget)


if __name__ == '__main__':
    unittest.main()
