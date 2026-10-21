; Exact 3x3 eigenbasis identity A*P=P*diag(0,0,5)
; Source: matrix/src/ch03/sec36.md#ex-3.6.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x Real)
(declare-const y Real)
(declare-const z Real)

(check-sat)
(push 1)
(assert (not (and (= (+ (* (+ (* 1 0) (* 0 1) (* (- 2) 0)) x) (* (+ (* 1 2) (* 0 0) (* (- 2) 1)) y) (* (+ (* 1 1) (* 0 0) (* (- 2) (- 2))) z)) (+ (* (+ (* 0 0) (* 2 0) (* 1 0)) x) (* (+ (* 0 0) (* 2 0) (* 1 0)) y) (* (+ (* 0 0) (* 2 0) (* 1 5)) z))) (= (+ (* (+ (* 0 0) (* 0 1) (* 0 0)) x) (* (+ (* 0 2) (* 0 0) (* 0 1)) y) (* (+ (* 0 1) (* 0 0) (* 0 (- 2))) z)) (+ (* (+ (* 1 0) (* 0 0) (* 0 0)) x) (* (+ (* 1 0) (* 0 0) (* 0 0)) y) (* (+ (* 1 0) (* 0 0) (* 0 5)) z))) (= (+ (* (+ (* (- 2) 0) (* 0 1) (* 4 0)) x) (* (+ (* (- 2) 2) (* 0 0) (* 4 1)) y) (* (+ (* (- 2) 1) (* 0 0) (* 4 (- 2))) z)) (+ (* (+ (* 0 0) (* 1 0) (* (- 2) 0)) x) (* (+ (* 0 0) (* 1 0) (* (- 2) 0)) y) (* (+ (* 0 0) (* 1 0) (* (- 2) 5)) z))))))
(check-sat)
(pop 1)
