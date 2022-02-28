#lang racket

(provide parse)

(require (only-in (file "tokenize.rkt")
                  tokenize))

;; Grammar:
;;
;; program ::= exprList
;; exprList ::= expr optExprList
;; optExprList ::= ɛ | exprList
;; expr ::= atom | invocation
;; atom ::= NAME | STRING | number
;; number ::= INT | FLOAT
;; invocation ::= OPAREN exprList CPAREN


(module+ test
  (require (only-in rackunit
                    check-equal?
                    check-exn
                    check-not-exn)))

(define tokens (make-parameter null))

(define DEBUG #f)
(define (trace label)
  (when DEBUG
    (writeln (~a label " "
                 (if (empty? (tokens))
                     'null
                     (first (tokens)))))))

(define (check type)
  (if (empty? (tokens))
      #f
      (equal? type (first (first (tokens))))))

(module+ test
  (check-equal? (parameterize ([tokens null])
                  (check 'DEF))
                #f)
  (check-equal? (parameterize ([tokens (list (list 'DEF #f))])
                  (check 'DEF))
                #t)
  (check-equal? (parameterize ([tokens (list (list 'DEF #f))])
                  (check 'FUN))
                #f))

(define (consume type)
  (when (empty? (tokens))
    (error (~a "expected token of type " type " but no remaining tokens")))
  (let ([token (first (tokens))])
    (when (not (equal? type (first token)))
      (error (~a "expected token of type " type " but actual token was " token)))
    (tokens (rest (tokens)))
    (when DEBUG
      (displayln (~a "(consume '" token ")")))
    token))


(define (parse-number)
  ;; number ::= INT | FLOAT
  (list 'number
        (if (check 'INT)
            (consume 'INT)
            (consume 'FLOAT))))

(define (number-pending?)
  (or (check 'INT)
      (check 'FLOAT)))


(define (parse-atom)
  ;; atom ::= NAME | STRING | number
  (list 'atom
        (cond
          [(check 'NAME) (consume 'NAME)]
          [(check 'STRING) (consume 'STRING)]
          [else (parse-number)])))

(define (atom-pending?)
  (or (check 'NAME)
      (check 'STRING)
      (number-pending?)))

(define (parse-invocation)
  ;; invocation ::= OPAREN exprList CPAREN
  (list 'invocation
        (consume 'OPAREN)
        (parse-expr-list)
        (consume 'CPAREN)))

(define (invocation-pending?)
  (check 'OPAREN))


;;;;;;;;;;;;;;;;;Modified for a6;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (parse-expr)
  ;; expr ::= atom | invocation
  (list 'expr
        (cond
            ((atom-pending?) (parse-atom))
            ((check 'OPAREN) (parse-invocation))
            ((check 'DEFINE) (parse-define))
            ((check 'LAMBDA) (parse-lambda))
            ((check 'LET) (parse-let))
            (else (check 'ERROR))  ;; in theory we should never reach this, right?
        )
  )
)

(define (expr-pending?)
  (or (atom-pending?)
      (invocation-pending?)
      (scope-keywords-pending?)
  )
)


;;;;;;;;;;;This is for a6;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (parse-define)
  (list 'define
    (consume 'DEFINE)
    (consume 'NAME)
    (parse-expr)
  )
)

(define (parse-lambda)
  (list 'lambda
    (consume 'LAMBDA)
    (consume 'OPAREN)
    (consume 'NAME)
    (consume 'CPAREN)
    (parse-expr)
  )
)

(define (parse-let)
  (list 'let
    (consume 'LET)
    (consume 'OPAREN)
    (consume 'NAME)
    (parse-expr)
    (consume 'CPAREN)
    (parse-expr)
  )
)

(define (scope-keywords-pending?)
  (or
    (check 'DEFINE)
    (check 'LAMBDA)
    (check 'LET)
  )
)


;;;;;;;;;;;;;;;;;;;end of a6 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (parse-expr-list)
  ;; exprList ::= expr optExprList
  (list 'exprList
        (parse-expr)
        (parse-opt-expr-list)))

(define (expr-list-pending?)
  (expr-pending?))

(define (parse-opt-expr-list)
  ;; optExprList ::= ɛ | exprList
  (if (expr-list-pending?)
      (list 'optExprList (parse-expr-list))
      (list 'optExprList)))

(define (parse-program)
  ;; program ::= exprList
  (list 'program
        (parse-expr-list)))

(define (parse code)
  (parameterize ([tokens (tokenize code)])
    (parse-program))
  )