#lang racket
; Matrícula1 -> A01570079
; Matrícula2 -> A01338448
; Matrícula3 -> A01067040

;Problema 1:

(define (armonica n)
  (if (= n 1) 1
     (+ (/ 1 n) (armonica (- n 1)))
  )
)

;Problema 2:
(define (imprimir n)
  (display n) (display " ")
)
(define (bajasube n)
  (cond
    ((= n 1) (imprimir 1))
    ((> n 1) (imprimir n)(bajasube (- n 1)))
  )
  (imprimir n)
)

;Problema 3:
(define (fibo n)
  (if (<= n 2) 1
     (+ (fibo (- n 1)) (fibo (- n 2)))
  )
)

;Problema 4:
(define (fibo-aux n a b)
  (cond
    [(= n 0) a]
    [(= n 1) b]
    [else (fibo-aux (- n 1) b (+ a b))]
   )
 )

(define (fibot n)
  (fibo-aux n 0 1)
 )