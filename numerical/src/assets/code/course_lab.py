from collections.abc import Callable
from decimal import Decimal, localcontext
from fractions import Fraction
from math import exp, isclose, log2, pi, sin, sqrt


def trapezoid(function: Callable[[float], float], panels: int,
              left: float = 0.0, right: float = 1.0) -> float:
    if panels < 1 or right <= left:
        raise ValueError("Require positive panels and left < right")
    step = (right - left) / panels
    interior = sum(function(left + index * step)
                   for index in range(1, panels))
    return step * (0.5 * (function(left) + function(right)) + interior)


def simpson(function: Callable[[float], float], panels: int,
            left: float = 0.0, right: float = 1.0) -> float:
    if panels < 2 or panels % 2 or right <= left:
        raise ValueError("Require positive even panels and left < right")
    step = (right - left) / panels
    weighted = sum((4 if index % 2 else 2) * function(left + index * step)
                   for index in range(1, panels))
    return step * (function(left) + weighted + function(right)) / 3


def euler_decay(rate: float, initial: float, end: float, steps: int,
                implicit: bool = False) -> float:
    if rate < 0 or end <= 0 or steps < 1:
        raise ValueError("Require nonnegative rate, positive end and steps")
    step = end / steps
    factor = 1 / (1 + rate * step) if implicit else 1 - rate * step
    return initial * factor ** steps


def verify_examples() -> list[str]:
    report: list[str] = []
    argument = 1e-16
    direct = sqrt(1 + argument) - 1
    stable = argument / (sqrt(1 + argument) + 1)
    with localcontext() as context:
        context.prec = 70
        exact_argument = Decimal("1e-16")
        reference = float((1 + exact_argument).sqrt() - 1)
    assert isclose(stable, reference, rel_tol=1e-14, abs_tol=0.0)
    report.append(f"cancellation direct={direct:.6g} stable={stable:.6g}")

    first = (Fraction(3, 4), Fraction(2, 3))
    second = ((3 + first[1]) / 4, (2 + first[0]) / 3)
    movement = max(abs(new - old) for new, old in zip(second, first))
    bound = movement / 2
    actual = max(abs(1 - value) for value in second)
    assert second == (Fraction(11, 12), Fraction(11, 12))
    assert bound == Fraction(1, 8) and actual == Fraction(1, 12)
    assert actual <= bound
    report.append(f"Jacobi step2_error={actual} posterior_bound={bound}")

    for iteration in range(1, 6):
        component = Fraction(1, 2 ** iteration)
        quotient = (2 + component ** 2) / (1 + component ** 2)
        assert 2 - quotient == Fraction(1, 4 ** iteration + 1)
        scale = Fraction(3, 7)
        scaled = (2 * scale ** 2 + (scale * component) ** 2)
        scaled /= scale ** 2 + (scale * component) ** 2
        assert scaled == quotient
    report.append("power: Rayleigh quotient is invariant under nonzero scaling")

    iterate = Fraction(1)
    for expected in (Fraction(3, 2), Fraction(17, 12)):
        iterate = (iterate + 2 / iterate) / 2
        assert iterate == expected
    assert 2 / (2 / Fraction(3, 2)) == Fraction(3, 2)
    report.append(f"Newton step2={iterate}; reciprocal iteration has a two-cycle")

    cycling = Fraction(0)
    for expected in (1, 0, 1, 0):
        cycling -= (cycling ** 3 - 2 * cycling + 2) / (3 * cycling ** 2 - 2)
        assert cycling == expected
    slow_factor = Fraction(999, 1000)
    movement = 1 - slow_factor
    assert slow_factor * movement / (1 - slow_factor) == slow_factor
    report.append("workshop: Newton cycle and slow-contraction stopping counterexample verified")

    noise = Fraction(1, 10)
    interpolated = noise + (1 - noise) * Fraction(1, 2) ** 2
    area = 2 * noise + (1 - noise) * Fraction(2, 3)
    assert interpolated == Fraction(13, 40)
    assert interpolated - Fraction(1, 4) == Fraction(3, 40)
    assert area == Fraction(4, 5)
    assert area - Fraction(2, 3) == Fraction(2, 15)
    polynomial = lambda argument: 0.1 + 0.9 * argument ** 2
    assert isclose(simpson(polynomial, 2, -1, 1), float(area))
    assert isclose(trapezoid(polynomial, 2, -1, 1), 1.1)
    report.append(f"data integral={area} true_integral=2/3 bias={area - Fraction(2, 3)}")

    quadratic = lambda argument: argument ** 2
    values = [trapezoid(quadratic, panels) for panels in (1, 2, 4)]
    assert values == [0.5, 0.375, 0.34375]
    estimate = abs(values[1] - values[2]) / 3
    assert isclose(estimate, abs(values[2] - 1 / 3))
    observed = log2(abs(values[0] - values[1]) / abs(values[1] - values[2]))
    assert isclose(observed, 2.0)
    oscillation = lambda argument: sin(4 * pi * argument) ** 2
    for panels in (2, 4):
        assert abs(trapezoid(oscillation, panels)) < 1e-25
    assert isclose(trapezoid(oscillation, 8), 0.5)
    gauss_fourth = 2 * (1 / sqrt(3)) ** 4
    assert isclose(gauss_fourth, 2 / 9)
    assert not isclose(gauss_fourth, 2 / 5)
    report.append(f"trapezoid observed_order={observed:.3f}; aliased grids miss integral=0.5")

    for step, expected in ((0.1, 0.0), (0.2, -1.0), (0.3, -2.0)):
        assert isclose(1 - 10 * step, expected, abs_tol=1e-15)
    errors = [abs(euler_decay(1, 1, 1, steps) - exp(-1))
              for steps in (40, 80, 160)]
    orders = [log2(coarse / fine) for coarse, fine in zip(errors, errors[1:])]
    assert all(0.95 < order < 1.05 for order in orders)
    assert abs(euler_decay(1000, 1, 1, 10, implicit=True)) < 1
    report.append("Euler observed_orders=" + ", ".join(f"{order:.3f}" for order in orders))
    rk_errors = []
    for steps in (10, 20, 40):
        argument = -1 / steps
        factor = 1 + argument + argument ** 2 / 2 + argument ** 3 / 6 + argument ** 4 / 24
        rk_errors.append(abs(factor ** steps - exp(-1)))
    rk_orders = [log2(coarse / fine) for coarse, fine in zip(rk_errors, rk_errors[1:])]
    assert all(3.9 < order < 4.2 for order in rk_orders)
    report.append("RK4 observed_orders=" + ", ".join(f"{order:.3f}" for order in rk_orders))
    report.append("pipeline: steps, computed_initial, Euler_end, model_bias")
    true_initial = 2 / 3
    for panels in (2, 4, 8):
        computed_initial = simpson(polynomial, panels, -1, 1)
        numerical_end = euler_decay(1, computed_initial, 1, 1000)
        model_bias = (computed_initial - true_initial) * exp(-1)
        assert isclose(model_bias, (2 / 15) * exp(-1), rel_tol=1e-12)
        report.append(f"{panels:4d} {computed_initial:.8f} {numerical_end:.8f} {model_bias:.8f}")
    return report


if __name__ == "__main__":
    print("\n".join(verify_examples()))
