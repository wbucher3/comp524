#lang racket
; Part 3

; question 1
(define (countdown x)
  (range x -1 -1)
 )

;(countdown 10)


; question 2
(define (zip first second) 
   (map (lambda (number1 number2)
         (list number1 number2))
       first
       second)
)

;(zip '(1 2 3) '(a b c))

;question 3
(define (sum-of-products x y)
  (foldl (lambda (a b result)
           (+ result (* a b)))
           0
           x
           y )

)

;(sum-of-products '(1 3 5) '(2 4 6))
