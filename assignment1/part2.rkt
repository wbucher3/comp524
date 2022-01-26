#lang racket
; question 1 - binary to natural number

(define (binary->natural array)
  (letrec ([b->nV2 (lambda (array n)
                     (if (empty? array)
                         ;then
                         0
                         ;else
                         (+ (* (car array) (expt 2 n)) (b->nV2 (cdr array) (+ 1 n)))
                      )
                     )

   ])
   (b->nV2 array 0)
 )
)

;(binary->natural '(0 0 1 1)) ; should return 12, read it backwards


; question 2 - index of item
 (define (index-of-item token array)
   
   (letrec ([getIndex (lambda (token array i)
                        (if (equal? (car array) token)
                            ;then
                            i
                            ;else
                            (getIndex token (cdr array) (+ i 1))
                         )
                       )
             ])
   (getIndex token array 0)
   )
 )
 
;(index-of-item 'x '(x y z x x))

;question 3 - divide

(define (divide num dom)
  (letrec ([iterator (lambda (num dom i)
                       (if (>= num dom)
                           ;then
                           (iterator (- num dom) dom (+ i 1))
                           ;else
                           i
                         )
                       )
                     ])
    (iterator num dom 0)
    )
)
;(divide 25 5)