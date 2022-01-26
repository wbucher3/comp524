#lang racket
; part 4
; this stuff is for extra credit

; question 1

(define (collatz-length n)
  (letrec ([c-lV2 (lambda(n i)
                    (if (equal? 1 n)
                        ;then
                        i
                        ;else
                        (if (odd? n)
                            ;then
                            (c-lV2 (+ 1 (* 3 n)) (+ i 1))
                            ;else
                            (c-lV2 (/ n 2) (+ i 1))
                          )
                      )
                    )
             ])
    (c-lV2 n 0)
  )
)
;(collatz-length 16)

; question 2 - cartesian product

(define (cartesian-product first second)
  (if (or (empty? first) (empty? second))
  ;then
      empty
  ;else
  (append-map (lambda (
  
  )
 )
(cartesian-product '() '(4 5))
