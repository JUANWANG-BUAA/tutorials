; f=e+e^4: f second derivative at root is 0 but Newton error is order four
; Source: numerical/src/course/ch04/sec41b.md#sec-4.1b-exercises
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const e Real)
(assert (> e 0))
(check-sat)
(push 1)
(assert (not (not (= (- e (/ (+ e (* e e e e)) (+ 1 (* 4 e e e)))) (/ (* 3 e e e e) (+ 1 (* 4 e e e)))))))
(check-sat)
(get-model)
(pop 1)
