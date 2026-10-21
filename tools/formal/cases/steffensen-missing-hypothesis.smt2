; phi(x)=x+x^2: phi prime at root is 1, Steffensen map x*(1+x)/(2+x) has linear factor 1/2
; Source: numerical/src/course/ch04/sec41.md#sec-4.1.4
; Real arithmetic is exact. No floating-point values are used.
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x Real)
(declare-const s Real)
(declare-const ratio Real)
(assert (> x 0))
(assert (= s (* x (+ 1 x))))
(assert (= ratio (/ (+ 1 x) (+ 2 x))))
(check-sat)
(push 1)
(assert (not (< ratio (/ 1 2))))
(check-sat)
(get-model)
(pop 1)
