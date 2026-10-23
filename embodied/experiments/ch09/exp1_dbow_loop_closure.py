#!/usr/bin/env python3
"""实验 9.1：给定离散视觉词的 TF-IDF 回环候选评分。

不训练 DBoW 字典树，也不替代真实图像描述子与几何验证。
"""

from __future__ import annotations

import numpy as np


def tfidf(documents: list[np.ndarray], vocabulary_size: int) -> list[np.ndarray]:
    """训练语料内统计文档频次；L1 归一化以支持曼哈顿评分。"""
    counts = np.array([np.bincount(d, minlength=vocabulary_size) for d in documents], dtype=float)
    df = np.sum(counts > 0, axis=0)
    idf = np.log((len(documents) + 1) / (df + 1)) + 1.0
    weighted = counts * idf
    return [row / max(row.sum(), 1e-12) for row in weighted]


def similarity(a: np.ndarray, b: np.ndarray) -> float:
    return float(1.0 - 0.5 * np.abs(a - b).sum())


def main() -> None:
    rng = np.random.default_rng(42)
    # 重访房间共享词 0..9；走廊为 10..19；三帧共享一部分背景词。
    room1 = np.r_[rng.integers(0, 10, 60), rng.integers(20, 30, 20)]
    corridor = np.r_[rng.integers(10, 20, 60), rng.integers(20, 30, 20)]
    room2 = np.r_[rng.integers(0, 10, 60), rng.integers(20, 30, 20)]
    v1, vb, v2 = tfidf([room1, corridor, room2], 30)
    same, other = similarity(v1, v2), similarity(v1, vb)
    print("=== 实验 9.1：离散视觉词 TF-IDF 候选检索 ===")
    print(f"回访房间评分: {same:.4f}; 异地走廊评分: {other:.4f}")
    assert same > other
    print("注意：此评分仅产生候选，必须进一步执行时序一致性和几何验证。")


if __name__ == "__main__":
    main()
