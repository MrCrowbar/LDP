#lang racket
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