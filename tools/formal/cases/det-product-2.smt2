; 2x2 determinant multiplication identity
; Source: matrix/src/ch02/sec24.md#thm-sim-invariants
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const a00 Real)
(declare-const a01 Real)
(declare-const a10 Real)
(declare-const a11 Real)
(declare-const b00 Real)
(declare-const b01 Real)
(declare-const b10 Real)
(declare-const b11 Real)

(check-sat)
(push 1)
(assert (not (= (- (* (+ (* a00 b00) (* a01 b10)) (+ (* a10 b01) (* a11 b11))) (* (+ (* a00 b01) (* a01 b11)) (+ (* a10 b00) (* a11 b10)))) (* (- (* a00 a11) (* a01 a10)) (- (* b00 b11) (* b01 b10))))))
(check-sat)
(pop 1)
