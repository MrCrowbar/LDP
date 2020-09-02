#lang racket
; Pasos para abordar la recursión según el profe
; En la recursión tenemos que resolver los problemas con una sola operación.
; debemos expresar la solución con solamente 1 expresión.

; factorial de un número no negativo
; n! = 1*2* ... * (n-1) * n
; definición recursiva
; definir el caso base (más sencillo): 1 si n = 0
; caso general: n * (n-1)! si n > 0

(define (fact n)
  (if (zero? n)
      1
      (* n (fact (- n 1)))
      )
  )

; a^b elevar el valor a a la potencia b
; a^b = a * a * ... * a, donde #a's = b
; caso base: 1 si b = 0
; caso general: a * a^(b-1) si b > 0

(define (a^b a b)
  (if (zero? b)
      1
      (* a (a^b a (- b 1)))
      )
  )

; despliegue la secuencia 1,2, ... ,n en distintas lineas
; necesito que alguien despliegue del 1 a n-1
(define (secuencia n)
  (cond
    [(= n 1) (display 1) (newline)]
    [else (secuencia (- n 1)) (display n) (newline)]
    )
  )
        