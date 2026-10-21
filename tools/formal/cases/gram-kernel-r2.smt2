; The real 2x2 Gram kernel implication A^T A x=0 implies Ax=0
; Source: matrix/src/ch03/sec31.md#prop-3.1.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const a Real)
(declare-const b Real)
(declare-const c Real)
(declare-const d Real)
(declare-const x Real)
(declare-const y Real)
(assert (= (+ (* a (+ (* a x) (* b y))) (* c (+ (* c x) (* d y)))) 0))
(assert (= (+ (* b (+ (* a x) (* b y))) (* d (+ (* c x) (* d y)))) 0))
(check-sat)
(push 1)
(assert (not (and (= (+ (* a x) (* b y)) 0) (= (+ (* c x) (* d y)) 0))))
(check-sat)
(pop 1)
