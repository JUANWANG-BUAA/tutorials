# -*- coding: utf-8 -*-
"""实验 6.2：ORB 二进制描述子汉明距离匹配与 RANSAC 鲁棒单应性剔除误匹配。"""

import numpy as np


def hamming_distance(desc1: np.ndarray, desc2: np.ndarray) -> int:
    """计算 256 位 (32 字节 uint8) 二进制描述子的汉明距离。"""
    xor_bytes = np.bitwise_xor(desc1, desc2)
    return int(np.sum([bin(b).count("1") for b in xor_bytes]))


def main():
    print("=== 实验 6.2：二进制描述子匹配与 RANSAC 误匹配过滤 ===")
    np.random.seed(42)

    # 模拟两帧图像间的 100 对特征点，其中 80 对符合真实单应变换 H，20 对为随机误匹配
    # 真实单应矩阵 H_gt
    H_gt = np.array([
        [1.1, -0.05, 45.0],
        [0.08, 1.05, -30.0],
        [0.0002, 0.0001, 1.0]
    ])

    pts1 = np.random.uniform(50, 550, size=(100, 2))
    pts2 = np.zeros_like(pts1)

    # 生成 256 位随机二进制描述子 (100, 32)
    descs1 = np.random.randint(0, 256, size=(100, 32), dtype=np.uint8)
    descs2 = descs1.copy()

    for i in range(100):
        if i < 80:
            # 内点：严格符合单应性并带少许高斯噪声，描述子有极少比特翻转
            p_homo = np.array([pts1[i, 0], pts1[i, 1], 1.0])
            p_proj = H_gt @ p_homo
            pts2[i] = (p_proj[:2] / p_proj[2]) + np.random.normal(0, 0.5, 2)
            # 翻转 2-5 位
            flip_mask = np.random.choice([0, 1], size=32, p=[0.9, 0.1]).astype(np.uint8)
            descs2[i] = np.bitwise_xor(descs2[i], flip_mask)
        else:
            # 外点：随机位置，完全随机描述子
            pts2[i] = np.random.uniform(50, 550, 2)
            descs2[i] = np.random.randint(0, 256, 32, dtype=np.uint8)

    # 1. 暴力汉明距离匹配 + 汉明距离阈值初筛
    matches = []
    for i in range(100):
        dists = [hamming_distance(descs1[i], descs2[j]) for j in range(100)]
        best_j = int(np.argmin(dists))
        matches.append((i, best_j, dists[best_j]))

    # 2. RANSAC 估计单应矩阵
    best_inliers = []
    max_inliers = 0
    ransac_iters = 500
    thresh_px = 3.0

    for _ in range(ransac_iters):
        # 随机抽取 4 对点
        sample_idx = np.random.choice(len(matches), size=4, replace=False)
        src = pts1[[matches[k][0] for k in sample_idx]]
        dst = pts2[[matches[k][1] for k in sample_idx]]

        # 直接线性变换 (DLT) 求解单应矩阵 H
        A = []
        for (x, y), (u, v) in zip(src, dst):
            A.append([-x, -y, -1, 0, 0, 0, u*x, u*y, u])
            A.append([0, 0, 0, -x, -y, -1, v*x, v*y, v])
        _, _, Vt = np.linalg.svd(np.array(A))
        H_cand = Vt[-1].reshape((3, 3))
        if abs(H_cand[2, 2]) < 1e-8:
            continue
        H_cand /= H_cand[2, 2]

        # 统计所有匹配对的重投影误差
        inliers = []
        for m_idx, (idx1, idx2, _) in enumerate(matches):
            p = np.array([pts1[idx1, 0], pts1[idx1, 1], 1.0])
            pred = H_cand @ p
            pred_uv = pred[:2] / pred[2]
            err = np.linalg.norm(pred_uv - pts2[idx2])
            if err < thresh_px:
                inliers.append(m_idx)

        if len(inliers) > max_inliers:
            max_inliers = len(inliers)
            best_inliers = inliers

    print(f"总匹配候选对数: {len(matches)}")
    print(f"RANSAC 识别内点数: {max_inliers} (真实内点数 80)")
    print(f"外点误匹配成功剔除率: {(20 - (len(matches) - max_inliers)) / 20 * 100:.1f}%")


if __name__ == "__main__":
    main()
