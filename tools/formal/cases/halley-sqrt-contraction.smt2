; Positive sqrt Halley step reduces absolute error; squared ratio is <1
; Source: numerical/src/course/ch04/sec41.md#sec-4.1-exercises
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x Real)
(declare-const s Real)
(assert (> s 0))
(assert (> x 0))
(check-sat)
(push 1)
(assert (not (< (* (- x s) (- x s)) (+ (* 3 x x) (* s s)))))
(check-sat)
(pop 1)
