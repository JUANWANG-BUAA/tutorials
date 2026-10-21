; Squared infinity norm fails degree-one homogeneity: N(2,0)=4 != 2*N(1,0)
; Source: numerical/src/ch01/sec13.md#ex-1.3.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const n Real)
(assert (= n 4))
(check-sat)
(push 1)
(assert (not (= n (* 2 1))))
(check-sat)
(get-model)
(pop 1)
