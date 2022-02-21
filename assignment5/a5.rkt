#lang racket

(require (only-in (file "a3.rkt") parse))

(define (eval input)
  (let ((parse-tree (parse input))) ;; gets the parse tree
         (last (eval-program parse-tree)) ;; returns in a list so i gotta get it out
   )
)

;; program : exprList
(define (eval-program program-expr)
  (let ((expr-list (second program-expr)))
     (eval-expr-list expr-list)
  )
)

;; exprList : expr optExprList
(define (eval-expr-list expr-list)
  (let ((type (first expr-list)) ;; expr
        (this-expr (second expr-list)) ;; invocation or atom
        (optional-expr (third expr-list))) ;; opt-list
    (cons (eval-expr this-expr) (eval-opt-expr-list optional-expr))
 )
)

;; optExprList : ɛ | exprList
(define (eval-opt-expr-list opt-expr)
  (let ((type (rest opt-expr)))
        (if (empty? type) ;; checks if there is anything else to be evaluated
            ;; then
            '()
            ;; else
            (eval-expr-list (second opt-expr)) ;; evals the next thing
        )
  )
)

;; expr : atom | invocation
(define (eval-expr expr-block)
  (let* ((the-expr (second expr-block))
         (type (first the-expr)))
    (if (equal? type 'atom)
        ;; then
        (eval-atom the-expr)
        ;; else
        (eval-invocation the-expr)
    )
 )
)

;; atom : NAME | STRING | number
(define (eval-atom expr)
  (let* ((atom-expr (second expr))
        (type (first atom-expr)))
    (cond
      ((equal? type 'NAME)
       (cond
         ((equal? (second atom-expr) '+) +)
         ((equal? (second atom-expr) '-) -)
         ((equal? (second atom-expr) '*) *)
         ((equal? (second atom-expr) '/) /)
         ((equal? (second atom-expr) 'string-append) string-append)
         ((equal? (second atom-expr) 'string<?) string<?)
         ((equal? (second atom-expr) 'string=?) string=?)
         ((equal? (second atom-expr) '=) =)
         ((equal? (second atom-expr) '<) <)
         ((equal? (second atom-expr) 'not) not)
         (else (error "error in eval-atom"))))
      ((equal? type 'STRING) (second atom-expr))
      (else (eval-number atom-expr))
     )
   )
)

;; number : INT | FLOAT
(define (eval-number atom-expr)
  (let* ((num-expr (second atom-expr))
         (type (first num-expr)))
    (second num-expr)
    #;(if (equal? type 'INT)
        (second num-expr)
        (second num-expr)
    )
  )
)

;; invocation : OPAREN exprList CPAREN
(define (eval-invocation expr)
  (let* ((type (first expr)) ;; 'invocation
         (oparen (second expr))
         (expr-list (third expr))
         (cparen (fourth expr))
         (evaluation (eval-expr-list expr-list))
         (operator (first evaluation))
         (operands (rest evaluation)))
    (cond
      ((or (equal? operator +) (equal? operator -) (equal? operator *))
       (if (all-numbers? operands)
           ;; then
           (apply operator operands)
           ;; else
           (error "error in eval-invocation - addition, multiplication, or subtraction of non numbers")
       )
      )
      ((equal? operator /)
        (if (all-numbers? operands)
           ;; then
           (if (no-divide-zero? operands)
               ;; then
               (apply operator operands)
               ;; else
               (error "error in eval-invocation - divide by zero")
           )
           ;; else
           (error "error in eval-invocation - division of non numbers")
        )
       )
      ((or (equal? operator string-append) (equal? operator string<?) (equal? operator string=?))
        (if (all-strings? operands)
            ;; then
            (apply operator operands)
            ;; elsee
            (error "error in eval-invocation - appending non strings")
         )
       )
      (else (apply operator operands))
    )
  )
)


;;;;;;;;; helper functions ;;;;;;;;;;;;

(define (all-numbers? nums)
  (if (empty? nums)
      ;; then
      #t
      ;; else
      (if (number? (first nums))
          ;; then
          (all-numbers? (rest nums))
          ;; else
          #f
      )
  )
)

(define (no-divide-zero? nums)
  (if (empty? nums)
      ;; then
      #t
      ;; else
      (if (< 0 (first nums))
          ;; then
          (no-divide-zero? (rest nums))
          ;; else
          #f
      )
  )
)

(define (all-strings? strings)
  (if (empty? strings)
      ;; then
      #t
      ;; else
      (if (string? (first strings))
          ;; then
          (all-strings? (rest strings))
          ;; else
          #f
      )
  )
)

(define (repl)
  (parameterize ([current-read-interaction (λ (_ in)
                                             (read-line in))]
                 [current-eval (λ (e)
                                 (when (non-empty-string? (cdr e))
                                   (eval (cdr e))))])
    (read-eval-print-loop)))
  

        