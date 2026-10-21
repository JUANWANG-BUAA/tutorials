; T=[1,0], kernel-first basis [(0,1),(1,0)] produces [0,1], not [1,0]
; Source: matrix/src/ch03/sec31.md#lem-3.1.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const v Real)
(assert (= v 0))
(check-sat)
(push 1)
(assert (not (= v 1)))
(check-sat)
(get-model)
(pop 1)
