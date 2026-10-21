; On [a,b], (x-a)*(b-x)<=h^2/4, giving the M2*h^2/8 remainder bound
; Source: numerical/src/lectures/lec10.md
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const a Real)
(declare-const b Real)
(declare-const x Real)
(assert (< a b))
(assert (<= a x))
(assert (<= x b))
(check-sat)
(push 1)
(assert (not (<= (* (- x a) (- b x)) (/ (* (- b a) (- b a)) 4))))
(check-sat)
(pop 1)
