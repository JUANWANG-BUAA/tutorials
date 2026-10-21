; A=diag(1,-1), initial (1,1): normalized direction alternates; Rayleigh quotient is 0
; Source: numerical/src/course/ch03/sec31.md#sec-3.1.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const beta Real)
(assert (= beta 0))
(check-sat)
(push 1)
(assert (not (= beta 1)))
(check-sat)
(get-model)
(pop 1)
