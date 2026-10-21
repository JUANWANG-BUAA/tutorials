; Counterexample: diag(-10,1) has condition number 10, not abs(lambda_max)/abs(lambda_min)=1/10
; Source: numerical/src/course/ch02/sec23.md#sec-2.3.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const k Real)
(assert (= k (* 10 1)))
(check-sat)
(push 1)
(assert (not (= k (/ 1 10))))
(check-sat)
(get-model)
(pop 1)
