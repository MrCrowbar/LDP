#lang racket

; Tarea 3: Programación básica en Racket
; Juan Jacobo Cruz Romero A01067040
; Roberto Garcia A00822089
; Diego Frías Nerio A01193624

; 1: Función recursiva primo? que determine si el argumento es número primo.
(define (primo? x)
  (cond
    [(= x 1) #f]
    [(= x 0) #f]
    [else (aux-primo x 2)]
  )
)

(define (aux-primo x n)
  (if (< n x)
      (if (integer? (/ x n)) #f
          (aux-primo x (+ n 1))
      )
      #t
  )
)
; ---------------------------------------------------------------------

; 2: Función sumdpar regresa la suma de los digitos pares de un número como argumento
(define (sumadpar n)
  (suma (sumdpar-aux n))
  )

(define (sumdpar-aux n)
    (if (zero? n)
        '()
        (cons (remainder n 10) (sumdpar-aux (quotient n 10))))
)

(define (suma n)
  (cond
    [(null? n) 0]
    [(even? (car n)) (+ (car n) (suma (cdr n)))]
    [else (suma (cdr n))]
    )
)
; ---------------------------------------------------------------------

; 3: Función combinaciones que regresa el número de combinaciones de n y r
(define (combinaciones n r)
  (/ (fact n) (* (fact r) (fact (- n r))))
)

(define (fact x)
  (if (= x 0) 1
      (* x (fact (- x 1)))
  )
)
; ---------------------------------------------------------------------

; 4: Está en el PDF
; ---------------------------------------------------------------------

;5. Bitor
(define (bitor list1 list2)
  (if (not (equal? (length list1) 0))
     (if (or (= (first list1) 1) (= (first list2) 1))
          (cons 1 (bitor (rest list1) (rest list2)))
          (cons 0 (bitor (rest list1) (rest list2))))
     `()))
; ---------------------------------------------------------------------

;6. Hexadecimal
(define (dec2hex n)
  (cond
    [(= n 10) `(a)]
    [(= n 11) `(b)]
    [(= n 12) `(c)]
    [(= n 13) `(d)]
    [(= n 14) `(e)]
    [(= n 15) `(f)]
    [else (cons n `())]))

(define (bin2dec n)
  (if (zero? n)
      n
      (+ (modulo n 10) (* 2 (bin2dec (quotient n 10))))))

(define (recursiveHex n)
  (if (zero? n)
      `()
      (append (recursiveHex (floor (/ n 16))) (dec2hex (modulo n 16)))))

(define (hexadecimal binary)
  (recursiveHex (bin2dec binary)))
; ---------------------------------------------------------------------

; 7: Binario a decimal
(define (bin_to_dec bin)
  (bin_to_dec_aux bin 0))

(define (bin_to_dec_aux bin dec)
  (cond
    ((null? bin) dec)
    (else (bin_to_dec_aux (cdr bin) (+(* dec 2)(car bin))))))
; ---------------------------------------------------------------------

; 8: Expresion válida
(define (expresion? exp)
  (cond
    ((number? exp) #t)
    ((not(list? exp)) #f)
    ((member (car exp) '(+ - * /))
     (cond
       ((null? (cdr exp)) #f)
       ((expresion? (cadr exp)) (sub_expresion? (cddr exp)))
       (else #f)))
    (else #f)))

(define (sub_expresion? exp)
  (cond
    ((null? exp) #t)
    ((and (expresion? (car exp)) (sub_expresion? (cdr exp))) #t)
    (else #f)))
; ---------------------------------------------------------------------

; 9: Palíndrome alternado
(define (palindromo n)
  (cond
    ((= n 1) '(a))
    ((= (modulo n 2) 1) (append '(a) (list (palindromo (- n 1))) '(a)))
    (else (append '(b) (list (palindromo (- n 1))) '(b)))))
; ---------------------------------------------------------------------

; 10: Invertir lista imbricada
(define (inversiontotal lst)
  (if (null? lst)
      null
      (if (list? lst)
          (append (inversiontotal (cdr lst)) (list (inversiontotal (car lst))))
          lst
      )
   )
)
; ---------------------------------------------------------------------