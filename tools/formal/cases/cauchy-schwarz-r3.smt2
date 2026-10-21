; Cauchy-Schwarz squared inequality over R^3
; Source: matrix/src/ch01/sec15.md#thm-1.5.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x0 Real)
(declare-const x1 Real)
(declare-const x2 Real)
(declare-const y0 Real)
(declare-const y1 Real)
(declare-const y2 Real)

(check-sat)
(push 1)
(assert (not (<= (* (+ (* x0 y0) (* x1 y1) (* x2 y2)) (+ (* x0 y0) (* x1 y1) (* x2 y2))) (* (+ (* x0 x0) (* x1 x1) (* x2 x2)) (+ (* y0 y0) (* y1 y1) (* y2 y2))))))
(check-sat)
(pop 1)
