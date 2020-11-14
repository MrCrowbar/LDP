#lang racket

; Ejercicio 6: Programación recursiva en Racket
; Autor: Dr. Santiago Enrique Conant Pablos

; 1. La función armonica calcula la suma de n términos de la serie
;    armónica
(define (armonica n)
  (if (= n 1)
      1
      (+ (/ 1.0 n) (armonica (- n 1)))))

(armonica 1)   ; => 1
(armonica 3)   ; => 1.8333333

; 2. La función bajasube despliega los números enteros del 1 al N, para
;    N > 0, separados por espacios
(define (bajasube n)
  (baja n) (display " ")
  (sube n) (newline))

; funciones auxiliares para bajasube
(define (baja n)
  (cond ((= n 1) (display 1))
        (else (display n) (display " ") (baja (- n 1)))))

(define (sube n)
  (cond ((= n 1) (display 1))
        (else (sube (- n 1)) (display " ") (display n) )))

(bajasube 3)		; => 3 2 1 1 2 3
(bajasube 5)		; => 5 4 3 2 1 1 2 3 4 5

; 3. La función fibo regresa el n-ésimo elemento de la serie de Fibonacci
(define (fibo n)
  (if (< n 3)
      1
      (+ (fibo (- n 1)) (fibo (- n 2)))))

(fibo 2)			; => 1
(fibo 7)			; => 13
(time (fibo 40))
; => cpu time: 5313 real time: 5315 gc time: 32
;    102334155

; 3. La función fibot es la versión terminal de fibo
(define (fibot n)
  (fibot-aux n 1 1))

(define (fibot-aux n act ant)
  (if (< n 3)
      act
      (fibot-aux (- n 1) (+ act ant) act)))

(fibot 2)			; => 1
(fibot 7)			; => 13
(time (fibot 100))
; => cpu time: 0 real time: 0 gc time: 0
;    354224848179261915075

