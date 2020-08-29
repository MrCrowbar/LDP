#lang racket

; predicado? que checa si 3 lados pueden formar un triángulo.
(define (triangulo? a b c)
  (and (< a (+ b c))
       (< b (+ a c))
       (< c (+ a b))))

; determina el tipo de triangulo definido por 3 lados
(define (triangulo a b c)
  (if (triangulo? a b c)
      (cond ((= a b c) 'equilatero)
            ((or (= a b) (= a c) (= b c)) (quote isoceles))
             (else 'escaleno)
       )
  'no-triangulo
  )
)