#!/usr/bin/env python3
"""Independent scalar checks for the chapter 8 contact examples."""

from __future__ import annotations

import importlib.util
import math
import unittest
from pathlib import Path
import sys


MODULE_PATH = Path(__file__).resolve().parents[1] / "src/assets/code/ch08-contact.py"
SPEC = importlib.util.spec_from_file_location("ch08_contact", MODULE_PATH)
assert SPEC is not None and SPEC.loader is not None
CH08 = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = CH08
SPEC.loader.exec_module(CH08)


class ContactModelChecks(unittest.TestCase):
    def test_compliance_examples_and_force_balance(self) -> None:
        for k, expected_x, expected_force in (
            (1000.0, 1.0714285714285714, 71.42857142857143),
            (10000.0, 1.02, 200.0),
        ):
            x_e, force = CH08.compliance_equilibrium(
                1.1, 2500.0, CH08.Environment(1.0, k)
            )
            self.assertAlmostEqual(x_e, expected_x, places=12)
            self.assertAlmostEqual(force, expected_force, places=10)
            self.assertAlmostEqual(2500.0 * (1.1 - x_e), force, places=10)

    def test_environment_changes_damping_ratio(self) -> None:
        omega_soft, zeta_soft = CH08.impedance_metrics(100.0, 500.0, 3500.0)
        omega_stiff, zeta_stiff = CH08.impedance_metrics(100.0, 500.0, 12500.0)
        self.assertAlmostEqual(omega_soft, math.sqrt(35.0), places=12)
        self.assertAlmostEqual(zeta_soft, 500.0 / (2.0 * math.sqrt(350000.0)), places=12)
        self.assertAlmostEqual(omega_stiff, math.sqrt(125.0), places=12)
        self.assertLess(zeta_stiff, zeta_soft)

    def test_absolute_position_reference_can_leave_unilateral_contact(self) -> None:
        env = CH08.Environment(0.5, 2000.0)
        x, force = CH08.direct_force_equilibrium(
            12.0, env, integral_force_action=False, proportional_force_gain_m_per_n=0.0002
        )
        self.assertAlmostEqual(x, 0.1445714285714286, places=12)
        self.assertAlmostEqual(force, -710.8571428571429, places=10)
        # The negative bilateral-spring result means a push-only contact is lost.

    def test_force_integral_and_velocity_inner_loop_equilibria(self) -> None:
        env = CH08.Environment(0.5, 2000.0)
        x_i, f_i = CH08.direct_force_equilibrium(
            12.0, env, integral_force_action=True
        )
        self.assertAlmostEqual(x_i, 0.506, places=12)
        self.assertAlmostEqual(f_i, 12.0, places=12)
        self.assertAlmostEqual(100.0 * (12.0 - 12.04) + 4.0, 0.0, places=12)

    def test_invalid_parameters_fail_clearly(self) -> None:
        with self.assertRaises(ValueError):
            CH08.impedance_metrics(0.0, 1.0, 1.0)
        with self.assertRaises(ValueError):
            CH08.compliance_equilibrium(1.0, 0.0, CH08.Environment(0.0, 1.0))


if __name__ == "__main__":
    unittest.main()
