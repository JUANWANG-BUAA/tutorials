"""统计：Wilson 区间、bootstrap、配对检验、pass@k。"""

from __future__ import annotations

import math
import random
from dataclasses import dataclass
from typing import Callable, Sequence


@dataclass(frozen=True)
class Interval:
    low: float
    high: float
    confidence: float = 0.95

    def __str__(self) -> str:
        return f"[{self.low:.3f}, {self.high:.3f}]"


def mean(values: Sequence[float]) -> float:
    if not values:
        raise ValueError("mean of empty sequence")
    return sum(values) / len(values)


def percentile(values: Sequence[float], p: float) -> float:
    if not values:
        raise ValueError("percentile of empty sequence")
    if not 0 <= p <= 100:
        raise ValueError("p must be in [0, 100]")
    xs = sorted(values)
    if len(xs) == 1:
        return xs[0]
    rank = (len(xs) - 1) * p / 100
    lo = math.floor(rank)
    hi = math.ceil(rank)
    if lo == hi:
        return xs[lo]
    return xs[lo] + (xs[hi] - xs[lo]) * (rank - lo)


def wilson_interval(successes: int, n: int, z: float = 1.96) -> Interval:
    """二项比例的 Wilson 区间；小样本比正态近似稳。"""
    if n <= 0 or not 0 <= successes <= n:
        raise ValueError("require 0 <= successes <= n and n > 0")
    p = successes / n
    denom = 1 + z * z / n
    center = (p + z * z / (2 * n)) / denom
    half = z * math.sqrt(p * (1 - p) / n + z * z / (4 * n * n)) / denom
    return Interval(max(0.0, center - half), min(1.0, center + half))


def bootstrap_ci(values: Sequence[float], *, n_resamples: int = 2000,
                 seed: int = 42, stat: Callable[[Sequence[float]], float] = mean,
                 confidence: float = 0.95) -> Interval:
    if not values:
        raise ValueError("bootstrap of empty sequence")
    rng = random.Random(seed)
    n = len(values)
    stats = []
    for _ in range(n_resamples):
        sample = [values[rng.randrange(n)] for _ in range(n)]
        stats.append(stat(sample))
    alpha = (1 - confidence) / 2
    return Interval(percentile(stats, alpha * 100), percentile(stats, (1 - alpha) * 100),
                    confidence)


def paired_bootstrap_diff(baseline: Sequence[float], candidate: Sequence[float], *,
                          n_resamples: int = 2000, seed: int = 42,
                          confidence: float = 0.95) -> tuple[float, Interval]:
    """同一批样本上的配对差值（candidate - baseline）与 CI。"""
    if len(baseline) != len(candidate):
        raise ValueError("paired samples must have equal length")
    if not baseline:
        raise ValueError("empty samples")
    diffs = [c - b for b, c in zip(baseline, candidate)]
    rng = random.Random(seed)
    n = len(diffs)
    stats = []
    for _ in range(n_resamples):
        sample = [diffs[rng.randrange(n)] for _ in range(n)]
        stats.append(sum(sample) / n)
    alpha = (1 - confidence) / 2
    return mean(diffs), Interval(percentile(stats, alpha * 100),
                                 percentile(stats, (1 - alpha) * 100), confidence)


def pass_at_k(n: int, c: int, k: int) -> float:
    """无放回采样 k 次至少命中一次的概率；n 总样本，c 正确样本。"""
    if not (0 <= c <= n) or k <= 0:
        raise ValueError("require 0 <= c <= n and k > 0")
    if k > n:
        raise ValueError("k must be <= n")
    if c == 0:
        return 0.0
    if n - c < k:
        return 1.0
    return 1.0 - math.comb(n - c, k) / math.comb(n, k)
