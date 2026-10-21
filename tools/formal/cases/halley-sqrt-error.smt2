; Halley sqrt exact error identity with positive target s and iterate x
; Source: numerical/src/course/ch04/sec41.md#sec-4.1.5
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x Real)
(declare-const s Real)
(assert (> s 0))
(assert (> x 0))
(check-sat)
(push 1)
(assert (not (= (- (/ (* x (+ (* x x) (* 3 s s))) (+ (* 3 x x) (* s s))) s) (/ (* (- x s) (- x s) (- x s)) (+ (* 3 x x) (* s s))))))
(check-sat)
(pop 1)
