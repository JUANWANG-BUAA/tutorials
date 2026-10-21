; Fixed chord f=x^3-1, c=0: psi(x)=1/x^2 near root 1, with derivative -2.
; Source: numerical/src/course/ch04/sec42.md#sec-4.1.8
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const d Real)
; f'(1)=3 and chord slope (f(1)-f(0))/(1-0)=1
(assert (= d (- 1 (/ 3 1))))
(check-sat)
(push 1)
(assert (not (< (* d d) 1)))
(check-sat)
(get-model)
(pop 1)
