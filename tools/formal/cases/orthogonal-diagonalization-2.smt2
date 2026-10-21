; Real orthogonal diagonalization implies symmetry in dimension two
; Source: matrix/src/ch03/sec36.md#cor-3.6.4
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const u00 Real)
(declare-const u01 Real)
(declare-const u10 Real)
(declare-const u11 Real)
(declare-const l Real)
(declare-const m Real)

(check-sat)
(push 1)
(assert (not (and (= (+ (* (+ (* u00 l) (* u01 0)) u00) (* (+ (* u00 0) (* u01 m)) u01)) (+ (* (+ (* u00 l) (* u01 0)) u00) (* (+ (* u00 0) (* u01 m)) u01))) (= (+ (* (+ (* u00 l) (* u01 0)) u10) (* (+ (* u00 0) (* u01 m)) u11)) (+ (* (+ (* u10 l) (* u11 0)) u00) (* (+ (* u10 0) (* u11 m)) u01))) (= (+ (* (+ (* u10 l) (* u11 0)) u00) (* (+ (* u10 0) (* u11 m)) u01)) (+ (* (+ (* u00 l) (* u01 0)) u10) (* (+ (* u00 0) (* u01 m)) u11))) (= (+ (* (+ (* u10 l) (* u11 0)) u10) (* (+ (* u10 0) (* u11 m)) u11)) (+ (* (+ (* u10 l) (* u11 0)) u10) (* (+ (* u10 0) (* u11 m)) u11))))))
(check-sat)
(pop 1)
