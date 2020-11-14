#lang racket
;Matrícula1: A01089938
;Matrícula2: A01067040
;Matrícula3: A00820799

; Problema 1a
(define (filtra lista funcion)
  (cond [(null? lista) '()]
        [(funcion (car lista))  (cons (car lista) (filtra (cdr lista) funcion))]
        [else (filtra (cdr lista) funcion)]))
;------------------------------------------------

; Problema 1b
(define ((compon func1 func2) x)
  (define y (func2 x))
  (func1 y)
 )
;------------------------------------------------

;Problema 1c
(define (aux-1c lista)
  (if (= (length lista) 1)
      (list (car lista))
      (list (aux-1c (cdr lista)))
     )
  )

(define ((agregaAlFinal elem) lista)
  (define listaB (list elem))
  (flatten (append lista (aux-1c listaB)))
)
;------------------------------------------------

;Problema 2a
(define (impares lista)
(map (lambda (l) (aux-vacio l '()))
  (map (lambda (l) (aux-vacio l '())) (aux-nones lista)) )
 )

(define (aux-nones lista)
       (append
        (map
         (lambda (sublista)
           (map
            (lambda (elemento)
              (cond
                [(odd? elemento) elemento]
                [else '()]
              )
            )
            sublista
        )
       )
       lista
       )
    )
 )

(define (aux-vacio lst item)
  (cond ((null? lst)
         '())
        ((equal? item (car lst))
         (cdr lst))
        (else
         (cons (car lst) 
               (aux-vacio (cdr lst) item)))))

;----------------------------------------------------------

; Problema 2b
(define (impares? lista)
  (if (= (apply + (map (lambda (l) (apply + l)) (impares-aux? lista))) 0) #f #t)
)

(define (impares-aux? lista)
       (append
        (map
         (lambda (sublista)
           (map
            (lambda (elemento)
              (cond
                [(odd? elemento) 1]
                [else 0]
              )
            )
            sublista
        )
       )
       lista
       )
    )
 )
;----------------------------------------------------------

; Problema 2c
(define (empareja lista)
  (if (= (length lista) 1)(map append (map list lista) (map list lista)) 
  [map append (append (map list lista) (map list lista))  (append (map list lista) (reverse(map list lista) ))] ))