#!/usr/bin/env python3
"""Reproduce the scalar spring and control calculations in robot chapter 8.

Run: python3 robot/src/assets/code/ch08-contact.py
All values follow the assumptions printed beside each example in the chapter.
"""

from __future__ import annotations

from dataclasses import dataclass
from math import sqrt


@dataclass(frozen=True)
class Environment:
    rest_position_m: float
    stiffness_n_per_m: float


def compliance_equilibrium(
    desired_position_m: float,
    controller_stiffness_n_per_m: float,
    environment: Environment,
) -> tuple[float, float]:
    """Bilateral linear-spring equilibrium; caller checks unilateral contact."""
    k_p = controller_stiffness_n_per_m
    k = environment.stiffness_n_per_m
    x_r = environment.rest_position_m
    if k_p <= 0 or k < 0:
        raise ValueError("controller stiffness must be positive and environment stiffness nonnegative")
    x_e = (k_p * desired_position_m + k * x_r) / (k_p + k)
    force_n = k * (x_e - x_r)
    return x_e, force_n


def impedance_metrics(
    mass_kg: float, damping_n_s_per_m: float, total_stiffness_n_per_m: float
) -> tuple[float, float]:
    """Natural frequency [rad/s] and damping ratio for an ideal second-order axis."""
    if mass_kg <= 0 or total_stiffness_n_per_m <= 0 or damping_n_s_per_m < 0:
        raise ValueError("mass and stiffness must be positive; damping cannot be negative")
    omega_n = sqrt(total_stiffness_n_per_m / mass_kg)
    zeta = damping_n_s_per_m / (2 * sqrt(mass_kg * total_stiffness_n_per_m))
    return omega_n, zeta


def direct_force_equilibrium(
    desired_force_n: float,
    environment: Environment,
    *,
    integral_force_action: bool,
    proportional_force_gain_m_per_n: float = 0.0,
) -> tuple[float, float]:
    """Stable ideal position-loop force equilibrium, under bilateral contact."""
    k = environment.stiffness_n_per_m
    x_r = environment.rest_position_m
    if k <= 0:
        raise ValueError("a positive contact stiffness is required")
    if integral_force_action:
        force_n = desired_force_n
        return x_r + force_n / k, force_n
    k_f = proportional_force_gain_m_per_n
    if k_f <= 0:
        raise ValueError("proportional force gain must be positive")
    # x_e = k_f(f_d - f_e); this is the chosen absolute-position convention.
    x_e = k_f * (desired_force_n + k * x_r) / (1 + k_f * k)
    force_n = k * (x_e - x_r)
    return x_e, force_n


def main() -> None:
    desired_position = 1.1
    rest_position = 1.0
    k_p = 2500.0
    print("Passive environment and active position stiffness")
    for k in (1000.0, 10000.0):
        x_e, force_n = compliance_equilibrium(
            desired_position, k_p, Environment(rest_position, k)
        )
        omega_n, zeta = impedance_metrics(100.0, 500.0, k_p + k)
        print(
            f"k={k:7.0f} N/m: x_e={x_e:.5f} m, force={force_n:.2f} N, "
            f"omega_n={omega_n:.3f} rad/s, zeta={zeta:.3f}"
        )

    print("\nDirect force regulation, f_d=10 N (bilateral spring model)")
    for k in (1000.0, 10000.0):
        env = Environment(1.0, k)
        for integral in (False, True):
            x_e, force_n = direct_force_equilibrium(
                10.0,
                env,
                integral_force_action=integral,
                proportional_force_gain_m_per_n=0.00024,
            )
            label = "integral force loop" if integral else "proportional force loop"
            print(f"k={k:7.0f} N/m, {label}: x_e={x_e:.5f} m, force={force_n:.2f} N")
            if not integral and force_n < 0:
                print("  negative bilateral force predicts separation in a push-only contact")


if __name__ == "__main__":
    main()
