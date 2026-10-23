# -*- coding: utf-8 -*-
"""视觉伺服闭环控制器（基于图像的 IBVS 与基于位置的 PBVS）。"""

from __future__ import annotations

import math
from typing import List, Tuple
import numpy as np
from arm_servoing.interaction_matrix import stacked_interaction_matrix, damped_pseudo_inverse


def skew_symmetric(v: np.ndarray) -> np.ndarray:
    """计算三维向量的反对称矩阵 [v]_x。"""
    return np.array([
        [0.0, -v[2], v[1]],
        [v[2], 0.0, -v[0]],
        [-v[1], v[0], 0.0]
    ], dtype=float)


class IBVSController:
    """基于图像特征误差的视觉伺服控制器（IBVS）。"""

    def __init__(self,
                 lambda_gain: float = 1.5,
                 max_linear_velocity: float = 0.3,
                 max_angular_velocity: float = 0.5,
                 damping: float = 1e-3):
        self.gain = float(lambda_gain)
        self.max_v = float(max_linear_velocity)
        self.max_w = float(max_angular_velocity)
        self.damping = float(damping)

    def compute_control_velocity(self,
                                 current_features: List[Tuple[float, float]],
                                 desired_features: List[Tuple[float, float]],
                                 depths: List[float]) -> Tuple[np.ndarray, float]:
        r"""计算相机期望空间运动旋量 v_c = -\lambda L_s^+ (s - s^*)。
        
        返回：(v_c \in R^6, 特征均方误差 norm(e))
        """
        assert len(current_features) == len(desired_features)
        k = len(current_features)

        # 构造特征误差向量 e = s - s*
        s_cur = np.array(current_features).flatten()
        s_des = np.array(desired_features).flatten()
        error = s_cur - s_des
        error_norm = float(np.linalg.norm(error))

        # 计算当前相互作用矩阵
        L_s = stacked_interaction_matrix(current_features, depths)
        L_pinv = damped_pseudo_inverse(L_s, damping=self.damping)

        # 比例伺服控制律
        v_c = -self.gain * (L_pinv @ error)

        # 速度限幅保护
        v_lin = v_c[:3]
        v_ang = v_c[3:]
        norm_lin = np.linalg.norm(v_lin)
        norm_ang = np.linalg.norm(v_ang)

        if norm_lin > self.max_v:
            v_lin = (v_lin / norm_lin) * self.max_v
        if norm_ang > self.max_w:
            v_ang = (v_ang / norm_ang) * self.max_w

        v_cmd = np.concatenate((v_lin, v_ang))
        return v_cmd, error_norm


class PBVSController:
    """基于三维笛卡儿位姿误差的视觉伺服控制器（PBVS）。"""

    def __init__(self,
                 lambda_p: float = 1.5,
                 lambda_w: float = 1.5,
                 max_linear_velocity: float = 0.3,
                 max_angular_velocity: float = 0.5):
        self.lambda_p = float(lambda_p)
        self.lambda_w = float(lambda_w)
        self.max_v = float(max_linear_velocity)
        self.max_w = float(max_angular_velocity)

    def compute_control_velocity(self,
                                 T_c_target: np.ndarray,
                                 T_cdes_target: np.ndarray) -> Tuple[np.ndarray, float]:
        r"""计算当前相机位姿至期望相机位姿的笛卡儿空间速度旋量。
        
        T_{c^* c} = T_{c^* t} * T_{c t}^{-1}
        误差：平移 \Delta t = t_{c^* c}，旋转角轴 \theta u = \log(R_{c^* c})^\vee
        返回：(v_c \in R^6, 位姿几何误差)
        """
        # T_c_cdes = T_c_t * T_cdes_t^{-1}
        T_cdes_t_inv = np.linalg.inv(T_cdes_target)
        T_c_cdes = T_c_target @ T_cdes_t_inv

        R = T_c_cdes[:3, :3]
        t = T_c_cdes[:3, 3]

        # 从旋转矩阵提取等效角轴
        tr = np.trace(R)
        cos_theta = np.clip((tr - 1.0) / 2.0, -1.0, 1.0)
        theta = math.acos(cos_theta)

        if abs(theta) < 1e-6:
            rot_error = np.zeros(3)
        else:
            u = np.array([
                R[2, 1] - R[1, 2],
                R[0, 2] - R[2, 0],
                R[1, 0] - R[0, 1]
            ]) / (2.0 * math.sin(theta))
            rot_error = theta * u

        v_lin = self.lambda_p * t
        v_ang = self.lambda_w * rot_error

        # 速度饱和
        if np.linalg.norm(v_lin) > self.max_v:
            v_lin = (v_lin / np.linalg.norm(v_lin)) * self.max_v
        if np.linalg.norm(v_ang) > self.max_w:
            v_ang = (v_ang / np.linalg.norm(v_ang)) * self.max_w

        v_cmd = np.concatenate((v_lin, v_ang))
        pose_error = math.sqrt(float(np.dot(t, t)) + float(np.dot(rot_error, rot_error)))
        return v_cmd, pose_error


def camera_velocity_to_end_effector(v_c: np.ndarray, T_e_c: np.ndarray) -> np.ndarray:
    r"""眼在手上（Eye-in-Hand）将相机坐标系速度旋量转换至末端执行器坐标系：
    
    V_e = [ R_{e c},  [t_{e c}]_x * R_{e c} ]
          [ 0,        R_{e c}              ] * V_c
    """
    R_ec = T_e_c[:3, :3]
    t_ec = T_e_c[:3, 3]

    W = np.zeros((6, 6), dtype=float)
    W[:3, :3] = R_ec
    W[:3, 3:] = skew_symmetric(t_ec) @ R_ec
    W[3:, 3:] = R_ec

    return W @ v_c
