; Exact 3x3 example A*(A-5I)=0 on arbitrary vectors
; Source: matrix/src/ch03/sec36.md#ex-3.6.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x Real)
(declare-const y Real)
(declare-const z Real)

(check-sat)
(push 1)
(assert (not (and (= (+ (* (+ (* 1 (- 1 (* 5 1))) (* 0 (- 0 (* 5 0))) (* (- 2) (- (- 2) (* 5 0)))) x) (* (+ (* 1 (- 0 (* 5 0))) (* 0 (- 0 (* 5 1))) (* (- 2) (- 0 (* 5 0)))) y) (* (+ (* 1 (- (- 2) (* 5 0))) (* 0 (- 0 (* 5 0))) (* (- 2) (- 4 (* 5 1)))) z)) 0) (= (+ (* (+ (* 0 (- 1 (* 5 1))) (* 0 (- 0 (* 5 0))) (* 0 (- (- 2) (* 5 0)))) x) (* (+ (* 0 (- 0 (* 5 0))) (* 0 (- 0 (* 5 1))) (* 0 (- 0 (* 5 0)))) y) (* (+ (* 0 (- (- 2) (* 5 0))) (* 0 (- 0 (* 5 0))) (* 0 (- 4 (* 5 1)))) z)) 0) (= (+ (* (+ (* (- 2) (- 1 (* 5 1))) (* 0 (- 0 (* 5 0))) (* 4 (- (- 2) (* 5 0)))) x) (* (+ (* (- 2) (- 0 (* 5 0))) (* 0 (- 0 (* 5 1))) (* 4 (- 0 (* 5 0)))) y) (* (+ (* (- 2) (- (- 2) (* 5 0))) (* 0 (- 0 (* 5 0))) (* 4 (- 4 (* 5 1)))) z)) 0))))
(check-sat)
(pop 1)
