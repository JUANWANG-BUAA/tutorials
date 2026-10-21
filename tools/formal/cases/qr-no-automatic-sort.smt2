; A=diag(1,2) has Q=I,R=A and remains unsorted by decreasing magnitude
; Source: matrix/src/ch03/sec34.md#method-qr-algo
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const d1 Real)
(declare-const d2 Real)
(assert (= d1 1))
(assert (= d2 2))
(check-sat)
(push 1)
(assert (not (>= d1 d2)))
(check-sat)
(get-model)
(pop 1)
