"""Recompute QR, interpolation sensitivity, quadrature and multistep examples."""

from fractions import Fraction
from math import copysign, exp, isclose, prod, sqrt


def transpose(matrix):
    return list(map(list, zip(*matrix)))


def multiply(left, right):
    return [
        [sum(a * b for a, b in zip(row, column)) for column in zip(*right)]
        for row in left
    ]


def identity(size):
    return [[float(row == column) for column in range(size)] for row in range(size)]


def assert_close_matrix(actual, expected, tolerance=1e-11):
    assert len(actual) == len(expected)
    for actual_row, expected_row in zip(actual, expected):
        assert len(actual_row) == len(expected_row)
        for actual_value, expected_value in zip(actual_row, expected_row):
            assert isclose(actual_value, expected_value, abs_tol=tolerance, rel_tol=tolerance)


def reflector(vector):
    norm = sqrt(sum(value * value for value in vector))
    if norm == 0:
        return identity(len(vector))
    target = -copysign(norm, vector[0])
    direction = list(vector)
    direction[0] -= target
    norm_squared = sum(value * value for value in direction)
    return [
        [
            float(row == column) - 2 * direction[row] * direction[column] / norm_squared
            for column in range(len(vector))
        ]
        for row in range(len(vector))
    ]


def embedded_reflector(matrix, column, start):
    small = reflector([row[column] for row in matrix[start:]])
    result = identity(len(matrix))
    for row in range(start, len(matrix)):
        for target in range(start, len(matrix)):
            result[row][target] = small[row - start][target - start]
    return result


def householder_qr(matrix):
    upper = [list(map(float, row)) for row in matrix]
    orthogonal = identity(len(matrix))
    for column in range(len(matrix) - 1):
        reflection = embedded_reflector(upper, column, column)
        upper = multiply(reflection, upper)
        orthogonal = multiply(orthogonal, reflection)
    return orthogonal, upper


def hessenberg(matrix):
    reduced = [list(map(float, row)) for row in matrix]
    transform = identity(len(matrix))
    for column in range(len(matrix) - 2):
        reflection = embedded_reflector(reduced, column, column + 1)
        reduced = multiply(multiply(reflection, reduced), reflection)
        transform = multiply(transform, reflection)
    return transform, reduced


def lagrange_values(nodes, point):
    values = []
    for index, node in enumerate(nodes):
        value = Fraction(1)
        for other_index, other_node in enumerate(nodes):
            if index != other_index:
                value *= (point - other_node) / (node - other_node)
        values.append(value)
    return values


def closed_cotes_weights(degree):
    nodes = [Fraction(index, degree) for index in range(degree + 1)]
    weights = []
    for index, node in enumerate(nodes):
        coefficients = [Fraction(1)]
        for other_index, other_node in enumerate(nodes):
            if index == other_index:
                continue
            updated = [Fraction(0)] * (len(coefficients) + 1)
            for power, coefficient in enumerate(coefficients):
                updated[power] -= other_node * coefficient / (node - other_node)
                updated[power + 1] += coefficient / (node - other_node)
            coefficients = updated
        weights.append(sum(coefficient / (power + 1) for power, coefficient in enumerate(coefficients)))
    return nodes, weights


def check_householder_and_qr():
    reflection = reflector([3.0, 4.0])
    assert_close_matrix(reflection, [[-0.6, -0.8], [-0.8, 0.6]])
    assert_close_matrix(multiply(reflection, [[3.0], [4.0]]), [[-5.0], [0.0]])
    assert_close_matrix(multiply(transpose(reflection), reflection), identity(2))
    wrong_reflection = [[-2.2, -1.6], [-1.6, 0.2]]
    assert_close_matrix(multiply(wrong_reflection, [[3.0], [4.0]]), [[-13.0], [-4.0]])
    printed_orthogonal = [
        [-0.408248, 0.577350, 0.707107],
        [-0.816497, -0.577350, 0],
        [-0.408248, 0.577350, -0.707107],
    ]
    printed_upper = [
        [-2.449490, -2.449490, -2.041241],
        [0, 1.732051, -0.577350],
        [0, 0, 0.707107],
    ]
    assert_close_matrix(multiply(printed_orthogonal, printed_upper),
                        [[1, 2, 1], [2, 1, 2], [1, 2, 0]], tolerance=3e-6)
    assert_close_matrix(multiply(transpose(printed_orthogonal), printed_orthogonal),
                        identity(3), tolerance=3e-6)
    for matrix in (
        [[1, 2, 1], [2, 1, 2], [1, 2, 0]],
        [[0, 1, 0], [0, 0, 0], [0, 0, 0]],
        [[0, 1], [1, 0]],
    ):
        orthogonal, upper = householder_qr(matrix)
        assert_close_matrix(multiply(orthogonal, upper), matrix)
        assert_close_matrix(multiply(transpose(orthogonal), orthogonal), identity(len(matrix)))
        assert all(abs(upper[row][column]) < 1e-11
                   for row in range(len(matrix)) for column in range(row))
        next_matrix = multiply(upper, orthogonal)
        assert_close_matrix(next_matrix, multiply(multiply(transpose(orthogonal), matrix), orthogonal))
    matrix = [[0, 1], [1, 0]]
    for _ in range(6):
        orthogonal, upper = householder_qr(matrix)
        matrix = multiply(upper, orthogonal)
        assert isclose(abs(matrix[1][0]), 1.0)


def check_hessenberg():
    for matrix in (
        [[1, 2, 1, 2], [2, 1, 2, -1], [1, 2, 0, 3], [2, -1, 3, 1]],
        [[2, 1, 3, 4], [1, -1, 2, 1], [-1, 2, 1, 2], [1, 0, -1, 3]],
    ):
        transform, reduced = hessenberg(matrix)
        assert_close_matrix(multiply(transpose(transform), transform), identity(4))
        assert_close_matrix(reduced, multiply(multiply(transpose(transform), matrix), transform))
        assert all(abs(reduced[row][column]) < 1e-11
                   for column in range(4) for row in range(column + 2, 4))
        assert isclose(sum(reduced[index][index] for index in range(4)),
                       sum(matrix[index][index] for index in range(4)))
        if matrix == transpose(matrix):
            assert_close_matrix(reduced, transpose(reduced))


def check_interpolation_sensitivity():
    nodes = list(map(Fraction, [-1, 0, 1]))
    basis = lagrange_values(nodes, Fraction(1, 2))
    assert basis == [Fraction(-1, 8), Fraction(3, 4), Fraction(3, 8)]
    assert sum(basis) == 1
    assert sum(map(abs, basis)) == Fraction(5, 4)
    perturbations = [Fraction(-1, 100), Fraction(1, 100), Fraction(1, 100)]
    assert sum(value * noise for value, noise in zip(basis, perturbations)) == Fraction(1, 80)
    outside = lagrange_values(nodes, Fraction(2))
    assert outside == [1, -3, 3] and sum(map(abs, outside)) == 7


def check_quadrature_sensitivity():
    for degree in range(1, 11):
        nodes, weights = closed_cotes_weights(degree)
        assert sum(weights) == 1
        for power in range(degree + 1):
            assert sum(weight * node ** power for node, weight in zip(nodes, weights)) == Fraction(1, power + 1)
        if degree <= 7 or degree == 9:
            assert all(weight > 0 for weight in weights)
        if degree == 8:
            assert sum(map(abs, weights)) == Fraction(6857, 4725)
            signs = [1 if weight > 0 else -1 for weight in weights]
            assert sum(weight * sign for weight, sign in zip(weights, signs)) == sum(map(abs, weights))
    for degree, expected in ((2, 5.4902), (4, 2.2776), (6, 3.3288), (8, 1.9411), (10, 3.5956)):
        nodes, weights = closed_cotes_weights(degree)
        integral = 8 * sum(weight / (1 + (-4 + 8 * node) ** 2)
                           for node, weight in zip(nodes, weights))
        assert isclose(float(integral), expected, abs_tol=5e-5)


def check_zero_stability():
    coefficients = [Fraction(1), Fraction(-2), Fraction(1)]
    assert sum(coefficients) == 0
    assert sum(index * value for index, value in enumerate(coefficients)) == 0
    for steps in (10, 20, 40):
        step = Fraction(1, steps)
        previous, current = Fraction(1), 1 + step
        for _ in range(1, steps):
            previous, current = current, 2 * current - previous
        assert current == 2
        previous, current = Fraction(1), 1 + step
        for _ in range(1, steps):
            previous, current = current, previous
        assert abs(current - 1) <= step
        growing_root = -float(step) - sqrt(1 + float(step) ** 2)
        assert abs(growing_root) > 1
    cubic_values = [Fraction(index) ** 3 for index in range(3)]
    cubic_derivatives = [3 * Fraction(index) ** 2 for index in range(3)]
    defect = cubic_values[2] - 2 * cubic_values[1] + cubic_values[0]
    defect -= cubic_derivatives[1] - cubic_derivatives[0]
    assert defect == Fraction(1, 2) * 6


def check_chapter_exam_numbers():
    matrix = [[4, 1, 0], [1, 3, 1], [0, 1, 2]]
    vector = [[1], [1], [1]]
    for expected in ([5, 5, 3], [25, 23, 11], [123, 105, 45], [597, 483, 195]):
        vector = multiply(matrix, vector)
        assert vector == [[value] for value in expected]
    numerator = multiply(multiply(transpose(vector), matrix), vector)[0][0]
    denominator = multiply(transpose(vector), vector)[0][0]
    assert (numerator, denominator) == (2966625, 627723)
    assert isclose(numerator / denominator, 4.72601, abs_tol=5e-6)
    ratio = exp(0.5)
    coefficients = [1, 2 * (ratio - 1), 2 * (ratio - 1) ** 2,
                    4 / 3 * (ratio - 1) ** 3, 2 / 3 * (ratio - 1) ** 4]
    interpolated = sum(coefficient * prod(0.7 - 0.5 * index for index in range(degree))
                       for degree, coefficient in enumerate(coefficients))
    assert isclose(interpolated, 2.014723533, abs_tol=5e-10)
    assert isclose(abs(interpolated - exp(0.7)), 0.000970825455, abs_tol=5e-12)
    polynomial = lambda argument: argument * (argument - 1) * (argument - 2)
    assert all(polynomial(Fraction(node)) == 0 for node in (0, 1, 2))
    assert polynomial(Fraction(1, 2)) == Fraction(3, 8)


def verify():
    for check in (check_householder_and_qr, check_hessenberg,
                  check_interpolation_sensitivity, check_quadrature_sensitivity,
                  check_zero_stability, check_chapter_exam_numbers):
        check()


if __name__ == "__main__":
    verify()
    print("Deep teaching checks passed: QR, Hessenberg, interpolation, quadrature, zero stability.")
    matrix = [[1, 2, 1], [2, 1, 2], [1, 2, 0]]
    for label, value in zip(("Q", "R"), householder_qr(matrix)):
        print(label, [[round(entry, 6) for entry in row] for row in value])
    for matrix in (
        [[1, 2, 1, 2], [2, 1, 2, -1], [1, 2, 0, 3], [2, -1, 3, 1]],
        [[2, 1, 3, 4], [1, -1, 2, 1], [-1, 2, 1, 2], [1, 0, -1, 3]],
    ):
        print("Hessenberg", [[round(entry, 6) for entry in row] for row in hessenberg(matrix)[1]])
    matrix = [[3, 1, 0], [1, 2, 1], [0, 1, 1]]
    for iteration in range(1, 9):
        orthogonal, upper = householder_qr(matrix)
        matrix = multiply(upper, orthogonal)
        if iteration in (1, 4, 8):
            print("QR iteration", iteration, [round(matrix[index][index], 6) for index in range(3)],
                  max(abs(matrix[row][column]) for row in range(3) for column in range(3) if row != column))
    for degree in (2, 4, 6, 8, 10):
        nodes, weights = closed_cotes_weights(degree)
        integral = 8 * sum(weight / (1 + (-4 + 8 * node) ** 2)
                           for node, weight in zip(nodes, weights))
        print("Cotes", degree, float(integral))
