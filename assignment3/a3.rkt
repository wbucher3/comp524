#lang racket
;; CODE PROVIDED BY DR. TERRELL

(require (only-in (file "tokenize.rkt") tokenize))


;; consume procedure to remove the token from the global list
(define (consume type)
  (when (empty? (tokens))
    (error (~a "expected token of type " type " but no remaining tokens")))
  (let ([token (first (tokens))])
    (when (not (equal? type (first token)))
      (error (~a "expected token of type " type " but actual token was " token)))
    (tokens (rest (tokens)))  ; update tokens: remove first token
    token))

;; check procedure to see if the type matches the current token
(define (check type)
  (if (empty? (tokens))
      #f
      (equal? type (first (first (tokens))))))


;; global list
(define tokens (make-parameter'()))

;; main driver code
(define (parse code)
  (parameterize ([tokens (tokenize code)])
    (parse-program)
   )
)

;; program : exprList
(define (parse-program)
  (list 'program (parse-expr-list))
)

;; exprList : expr optExprList
(define (parse-expr-list)
  (list 'exprList (parse-expr) (parse-opt-expr-list))
)

;; optExprList : ɛ | exprList
(define (parse-opt-expr-list)
  (if (or (check 'OPAREN)
          (check 'NAME)
          (check 'STRING)
          (check 'INT)
          (check 'FLOAT)) ;;needs to check for invocation or atom
      ;; then
      (list 'optExprList (parse-expr-list))
      ;; else
      '(optExprList)
  )
)

;; expr : atom | invocation
(define (parse-expr)
  (if (check 'OPAREN)
      ;;then
      (list 'expr (parse-invocation))
      ;;else
      (list 'expr (parse-atom))
  )
)

;; atom : NAME | STRING | number
(define (parse-atom)
  (if (check 'STRING)
      ;; then
      (list 'atom (consume 'STRING))
      ;; else
      (if (check 'NAME)
          ;; then
          (list 'atom (consume 'NAME))
          ;; else
          (list 'atom (parse-number)) ;; do number last so we dont have to check both int and float
      )
  )
)

;; number : INT | FLOAT
(define (parse-number)
  (if (check 'FLOAT)
      ;; then
      (list 'number (consume 'FLOAT))
      ;; else
      (list 'number (consume 'INT))
   )
)


;; invocation : OPAREN exprList CPAREN
(define (parse-invocation)
  ;; we dont need to check for oparen because we know it's there from how it got here
  ;; if there are problems with the closing paren, it will be caught in consume :D
  (list 'invocation (consume 'OPAREN) (parse-expr-list) (consume 'CPAREN))
)


#;(parse "(define factorial
  (fun (n)
    (if (< n 0.9)
        1  ;; base case
        (factorial (- n 1) ;* recursive case *; ))))

(print (+ \"5! is \" (factorial 5)))")