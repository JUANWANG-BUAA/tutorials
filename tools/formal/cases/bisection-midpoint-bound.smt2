; Midpoint error bounded by half bracket length
; Source: numerical/src/course/ch04/sec41.md#sec-4.1.1
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const a Real)
(declare-const b Real)
(declare-const s Real)
(assert (<= a s))
(assert (<= s b))
(check-sat)
(push 1)
(assert (not (and (<= (- (/ (+ a b) 2) s) (/ (- b a) 2)) (<= (- s (/ (+ a b) 2)) (/ (- b a) 2)))))
(check-sat)
(pop 1)
