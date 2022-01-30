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
      [(";") 'SEMICOLON]
      [("(") 'OPAREN]
      [(")") 'CPAREN]
      [("{") 'OBRACE]
      [("}") 'CBRACE]
      [(",") 'COMMA]
      [(";") 'SEMICOLON]
      [(".") 'PERIOD]
)))

(define (number-token str)
  (token 'NUM (string->number str)))

(define (int-token str)
  (token 'INT (string->number str)))

(define (float-token str)
  (token 'FLOAT (string->number str)))

(define (name-or-keyword-token str)
  (case str
    [("def" "fun" "if" "not" "and" "or")
     (token (string->symbol (string-upcase (string-trim str))))]
    [else (token 'NAME (string->symbol str))]))



;; my procedures!

(define (invalid-token str)
  (token 'INVALID str))

(define (string-token str)
  (token 'STRING (substring str 1 (- (string-length str) 1))))

;;;; Lexing rules table
;;;;
;;;; Each item in the table is a 2-tuple (i.e. list of 2 elements):
;;;; 1. a regexp to detect a token at the beginning of a string
;;;; 2. a function (from above) to take the matched string and create a token

;; TODO in re-table
;; multiline comments /* */
;; string tokens
;; name fix
;; make those pesky floats 
;; invalid

;; NONE OF THESE ARE TESTED! AH! SIKE! i tested them!!!
;; numbers are which case they align with in the `get-front-token` procedure
(define re-table
  (list
    (list #rx"^[ \r\n\t]+" skip-match) ;; whitespace 0
    (list #rx"^//[^\n]+(\n|$)" skip-match) ;; // comments 1
    (list #rx"^/\\*(.)*\\*/" skip-match) ;; multiline comments /*  */ 2
    (list #rx"^[;,.(){}]" punctuation-token) ;; pretty straight up  3
    #;(list #rx"^-?[0-9]+(\\.[0-9]+)?(?=[\r\n\t (){},;.]|$)" number-token) ;; ints and floats! i wrote this before i realize they need separate tokens
    (list #rx"^-?[0-9]+[.][0-9]+(?=[\r\n\t (){},;.]|$)" float-token) ; 4 important that float comes first or it will be (int, period, int)
    (list #rx"^-?[0-9]+(?=[\r\n\t (){},;.]|$)" int-token) ; 5
    (list #rx"^[A-Za-z+/*<>=-]+[A-Za-z0-9+/*<>=-]*(?=[\r\n\t (){},;.]|$)" name-or-keyword-token) ;; cant start with number so 6 
    (list #rx"^\"(.)*\"(?=[\r\n\t (){},;.]|$)" string-token) ;; basic impl with no double quotes inside allowed 7
    (list #rx".+" invalid-token) ;; . is literally anything in regex, everything should alert this one but it's okay bc it's last 8

))

;; THINGS TO FIX AFTER FIRST GRADER
;; 1) dont allow double quotes in strings
;; 2) case for the empty string DONE!

;; time to run it
;; give a string and return a list with pairs that are all lexed shit

;; THE PLAN
;; first check if the string is empty, if it is, return empty
;; if not -> get the string for the first token that appears
;; slice off the front most token bit from the string
;; cons that token with the same process using the rest of the string
;; base case is reached when the string is empty
;; return the master list that is full of tokens!

;; make helper procedures to call for the slicing and finding bits, doing all in one would lead to bad readablity


;; this procedure returns the first token it finds, it return s a list with the value shown
;; this was given to us on the assignment write up page so honestly i just use the output, dont ask how it gets it
;; tbh after writing this whole thing, i think if i would have wrote this better, i could make the get-front-token simpler
;; '(white-space, skip-match, skip-match, punc, number, name/keyword, string, invalid)
(define (first-token-list string)
  (map (lambda (entry) (regexp-match (first entry) string)) re-table)
)

;; this procedure takes in the list from `first-token-list` and extracts the type of token it found
(define (get-front-token lst)
    (letrec ([token-extractor
              (lambda (lst i)
                (if (equal? (car lst) #f)
                    ;;then
                    (token-extractor (cdr lst) (+ i 1)) ;; recur until we find the valid value, 7 will always be valid btw since it's regex is everything
                    ;;else
                    ;;this makes all the tokens
                    (case i ;; homie you didnt know how happy i was to see racket has switch cases...looking at you python
                      ((0) (skip-match (car (car lst)))) ;; have to do it twice because it's a list in a list
                      ((1) (skip-match (car (car lst))))
                      ((2) (skip-match (car (car lst))))
                      ((3) (punctuation-token (car (car lst))))
                      ((4) (float-token (car (car lst))))
                      ((5) (int-token (car (car lst))))
                      ((6) (name-or-keyword-token (car (car lst))))
                      ((7) (string-token (car (car lst))))
                      ((8) (invalid-token (car (car lst)))) ;; this must be last since it will always be true
                     )
                     ))]) ;; these are a mess lol! i gate these large amounts of parens
             (token-extractor lst 0)))


;; this procedure takes in the list from `first-token-list` and returns the string that goes along with said token
(define (get-token-string lst)
  (if (equal? (car lst) #f)
      ;;then
      (get-token-string (cdr lst))
      ;; else
      (car (car lst)) ;; have to do it twice because it's a list in a list
   )
)

;; this procedure take in a string and trims the front token off of it
;; returns the string without it :D
(define (trimString s)
  (substring s (string-length (get-token-string (first-token-list s))))

)

;; gets the front token from the string using the two helpers
(define (getToken input)
  (get-front-token (first-token-list input))
)

;; removes all the #f's in the list from all of the skip-matches
;; really didn't need to make a separate procedure but i wanted to for looks
(define (remove-skips lst)
  (remove* (list #f) lst)
 )


;; THE DADDY PROCEDURE - WHERE THE GRADER BEGINS!
;; the procedured described in the plan above (starting on line 77)
(define (tokenize input)
    (if (equal? input "")
        '()
        (remove-skips (cons (getToken input) (tokenize (trimString input))))
    )
)

;; used for testing and comparing to ground truth on website 
#;(tokenize "def factorial = fun (n) {
  // first check base case
  if(<(n, 0.9),
     1,
     factorial(-(n, 1)) /* recursive case */ )
};

print(+(\"5! is \", factorial(5)))")
#;(display (tokenize " \"\" "))

;; HUGE SHOUTOUT TO PIAZZA POST #61
;; https://piazza.com/class/ky7ri1riy0w3xj?cid=61
;; big time saver seeing someone ask this, was my very same problem

