; f=x+x^4: Newton error is 3*x^4/(1+4*x^3), so vanishing second derivative alone does not force exact order three
; Source: numerical/src/course/ch04/sec41b.md#sec-4.1b-exercises
(set-logic QF_NRA)
(set-option :timeout 15000)
(declare-const x Real)
(assert (> x 0))
(check-sat)
(push 1)
(assert (not (= (- x (/ (+ x (* x x x x)) (+ 1 (* 4 x x x)))) (/ (* 3 x x x x) (+ 1 (* 4 x x x))))))
(check-sat)
(pop 1)
