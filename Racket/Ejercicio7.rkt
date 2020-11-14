#lang racket
; A00822089
; A01338798
; A01067040


; SECCIÓN 2-----------------------------

; ejercicio a: Regresa el menor de una lista no vacía
( define (menor lista )
   (cond
     [(= (length lista) 1) (car lista)]
     [(> (car lista) (cadr lista))
       (menor(cdr lista))]
     [else 
     (menor (cons (car lista) (cddr lista)))]
     )
   )

; ejercicio b: Regresa una lista que represente un palíndromo
(define (palindromo n)
  (palindromo_aux 0 n))

(define (palindromo_aux act n)
  (cond ((= act n) (list act act))
        (else (append (list act) (palindromo_aux (+ act 1) n) (list act)))
        )
  )

; ejercicio c: Regresa una lista con valores negativos
(define (negativos lista)
  (cond
    [(null? lista) '()]
    [(negative? (car lista)) (cons (car lista) (negativos (cdr lista)))]
    [else (negativos (cdr lista))]
  )
 )


; SECCIÓN 3-----------------------------

; ejercicio a: Determina y regresa el nivel máx de anidación
(define (profundidad lista)
  (prof-aux lista 0)
  )

(define (prof-aux lista counter)
  (cond
    [(= (length lista) 1) counter]
    [(list? (car lista)) (prof-aux (car lista) (+ counter 1)) ]
    [else (prof-aux (cdr lista) counter)]
    )
  )

; ejercicio b: Regresa una lista con el patrón simétrico
(define (simetrico n)
  (cond ((= n 0) '())
        (else (append '(<) (list(simetrico (- n 1))) '(>)))
        )
  )

; ejercicio c: Elimina elementos que coincidan con x en una lista imbricada
(define (elimina x lista)
  (cond
    [(null? lista) '()]
    [(pair? (car lista)) (cons (elimina x (car lista)) (elimina x (cdr lista)))]
    [(equal? x (car lista)) (elimina x (cdr lista))]
    [else(cons (car lista) (elimina x (cdr lista)))]
  )
)
