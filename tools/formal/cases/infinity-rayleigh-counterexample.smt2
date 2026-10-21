; A=diag(2,1), y=(1,1/2): missing Rayleigh denominator changes 9/5 to 9/4
; Source: numerical/src/course/ch03/sec31.md#sec-3.1.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const beta Real)
(assert (= beta (/ 9 4)))
(check-sat)
(push 1)
(assert (not (= beta (/ 9 5))))
(check-sat)
(get-model)
(pop 1)
