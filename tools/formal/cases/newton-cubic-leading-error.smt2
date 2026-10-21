; For f=e+a*e^3 the exact Newton error is 2*a*e^3/(1+3*a*e^2)
; Source: numerical/src/course/ch04/sec42.md#sec-4.1.10
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const e Real)
(declare-const a Real)
(assert (> a 0))
(check-sat)
(push 1)
(assert (not (= (- e (/ (+ e (* a e e e)) (+ 1 (* 3 a e e)))) (/ (* 2 a e e e) (+ 1 (* 3 a e e))))))
(check-sat)
(pop 1)
