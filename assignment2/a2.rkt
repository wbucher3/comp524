#lang racket

;; The `[data #f]` is a default value for the 2nd positional argument.
;; That way, this function can take 1 arg or 2 args.
(define (token type [data #f])
  (list type data))

;;;; Token creator functions
;;;;
;;;; Given a string matching a regexp, return a token for that input or #f for
;;;; no token.

(define (skip-match str) #f)

(define (punctuation-token str)
  (token
    (case str
      [("=") 'EQUALS]
      [("+") 'PLUS]
      [("/") 'DIVIDE]
      [(";") 'SEMICOLON])))

(define (number-token str)
  (token 'NUM (string->number str)))

(define (name-or-keyword-token str)
  (case str
    [("read" "write")
     (token (string->symbol (string-upcase (string-trim str))))]
    [else (token 'NAME (string->symbol str))]))

;;;; Lexing rules table
;;;;
;;;; Each item in the table is a 2-tuple (i.e. list of 2 elements):
;;;; 1. a regexp to detect a token at the beginning of a string
;;;; 2. a function (from above) to take the matched string and create a token

(define re-table
  (list
    (list #rx"^[ \r\n\t]+" skip-match) ; whitespace
    (list #rx"^//[^\n]+(\n|$)" skip-match) ; // comments
    (list #rx"^[=+/;]" punctuation-token)
    (list #rx"^[0-9]+" number-token)
    (list #rx"^[A-Za-z]+" name-or-keyword-token)))
