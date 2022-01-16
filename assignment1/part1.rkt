#lang racket
; PART 1
; Problem 1 - countdown 
(define (countdown x)
   (if (> x -1)
    ; then 
    (cons x (countdown (- x 1))) 
    ; else
    '()
))
;test case
;(countdown 10)

; Problem 2 - removefirst
(define (remove-first val data)
  (if (eq? data empty)
      ;then
      '()
      ;else
      (if (eq? (car data) val)
          ;then
          (cdr data)
          ;else
          (cons (car data) (remove-first val (cdr data)))
       )
  ))
;test case
;(remove-first 'a '(a b c))


; Probem 3 - insert after every
(define (insert-after-every first second data)
  (if (eq? data empty)
      ;then
      '()
      ;else
      (if (eq? first (car data))
          ;then
          (cons (car data) (cons second (insert-after-every first second (cdr data))))
          ;else
          (cons (car data) (insert-after-every first second (cdr data)))
       )
))
;test case
;(insert-after-every 'a 'b '(a c d))  


; Problem 4 - zip
(define (zip first second)
  (if (not (or (eq? first empty) (eq? second empty)))
      ;; then (neither are empty)
      (cons (cons (car first) (cons (car second) '())) (zip (cdr first) (cdr second)))
      ;; else (one or both are empty)
      '()
  )
)
;test case
;(zip '(a b c) '(1 2 3 4))

; Problem 5 - append
(define (append first second)
  (if (not(eq? first empty))
      ;then
      (cons (car first) (append (cdr first) second))
      ;else
      (if (not(eq? second empty))
              ;then
              (append second empty)
              ;else
              '()
       )
  )
)
;test case
;(append '(1 2 3) '(4 5 6))