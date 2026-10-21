; Counterexample: a nonsingular condition-10^20 diagonal system still has an exact unique solution
; Source: numerical/src/course/ch02/sec23.md#sec-2.3.2
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x Real)
(declare-const y Real)
(assert (= x 1))
(assert (= (/ y 100000000000000000000) (/ 1 100000000000000000000)))
(check-sat)
(push 1)
(assert (not (not (and (= x 1) (= y 1)))))
(check-sat)
(get-model)
(pop 1)
