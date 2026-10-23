# -*- coding: utf-8 -*-
"""机械臂眼在手（Eye-in-Hand）视觉伺服运动学闭环仿真器。"""

from __future__ import annotations

import math
from typing import Dict, List, Tuple
import numpy as np
from scipy.spatial.transform import Rotation as R_scipy

from arm_servoing.camera_model import PinholeCamera
from arm_servoing.visual_features import VisualTarget, FeatureTracker
from arm_servoing.servo_controller import IBVSController, PBVSController


def se3_exp(v: np.ndarray, dt: float) -> np.ndarray:
    """李代数 se(3) 速度旋量 [v, w]^T 到 SE(3) 的小步长指数积分矩阵。"""
    v_lin = v[:3] * dt
    v_ang = v[3:] * dt
    angle = np.linalg.norm(v_ang)
    if angle < 1e-7:
        R_mat = np.eye(3)
    else:
        axis = v_ang / angle
        R_mat = R_scipy.from_rotvec(v_ang).as_matrix()

    T = np.eye(4, dtype=float)
    T[:3, :3] = R_mat
    T[:3, 3] = v_lin
    return T


class ArmServoingSimulator:
    """机械臂视觉伺服闭环全流程仿真器。"""

    def __init__(self, camera: PinholeCamera):
        self.camera = camera
        self.tracker = FeatureTracker(camera)
        self.target = VisualTarget.create_planar_square(side_length=0.2)

    def run_ibvs_simulation(self,
                            T_c_target_init: np.ndarray,
                            T_c_target_desired: np.ndarray,
                            max_steps: int = 150,
                            dt: float = 0.05,
                            tolerance: float = 1e-3) -> Dict[str, np.ndarray]:
        """运行 IBVS 闭环仿真，返回轨迹与误差收敛曲线。"""
        # 计算期望特征坐标
        des_features, _, _ = self.tracker.get_features_and_depths(self.target, T_c_target_desired)

        controller = IBVSController(lambda_gain=2.0, max_linear_velocity=0.4, max_angular_velocity=0.6)

        T_cur = T_c_target_init.copy()
        errors: List[float] = []
        positions: List[np.ndarray] = []
        velocities: List[np.ndarray] = []

        for step in range(max_steps):
            features, depths, _ = self.tracker.get_features_and_depths(self.target, T_cur)
            v_cmd, err_norm = controller.compute_control_velocity(features, des_features, depths)

            errors.append(err_norm)
            positions.append(T_cur[:3, 3].copy())
            velocities.append(v_cmd.copy())

            if err_norm < tolerance:
                break

            # 更新相机相对标靶位姿：
            # 相机坐标系速度 v_c 产生相机的空间位移 dT = exp(v_c * dt)
            # T_c_new = dT^{-1} * T_c_old
            dT = se3_exp(v_cmd, dt)
            T_cur = np.linalg.inv(dT) @ T_cur

        return {
            "errors": np.array(errors),
            "positions": np.array(positions),
            "velocities": np.array(velocities),
            "final_pose": T_cur
        }

    def run_pbvs_simulation(self,
                            T_c_target_init: np.ndarray,
                            T_c_target_desired: np.ndarray,
                            max_steps: int = 150,
                            dt: float = 0.05,
                            tolerance: float = 1e-3) -> Dict[str, np.ndarray]:
        """运行 PBVS 闭环仿真。"""
        controller = PBVSController(lambda_p=2.0, lambda_w=2.0, max_linear_velocity=0.4, max_angular_velocity=0.6)

        T_cur = T_c_target_init.copy()
        errors: List[float] = []
        positions: List[np.ndarray] = []
        velocities: List[np.ndarray] = []

        for step in range(max_steps):
            v_cmd, err_norm = controller.compute_control_velocity(T_cur, T_c_target_desired)

            errors.append(err_norm)
            positions.append(T_cur[:3, 3].copy())
            velocities.append(v_cmd.copy())

            if err_norm < tolerance:
                break

            dT = se3_exp(v_cmd, dt)
            T_cur = np.linalg.inv(dT) @ T_cur

        return {
            "errors": np.array(errors),
            "positions": np.array(positions),
            "velocities": np.array(velocities),
            "final_pose": T_cur
        }
