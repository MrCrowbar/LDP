#lang racket

; Ejercicio 7: Programación con listas en Racket
; Autor: Dr. Santiago Enrique Conant Pablos

; 2. Recursividad plana en listas:

; a) Regresa el menor de una lista no vacía de enteros
(define (menor lista)
  (if (null? (cdr lista))
      (car lista)
      (let ((min-rest (menor (cdr lista))))
        (if (< min-rest (car lista))
            min-rest
            (car lista)))))

; Probar con:
(menor '(-3)) 			; => -3
(menor '(1 2 3 4 5))		; => 1
(menor '(9 -2 5 3 -6)) 	        ; => -6

; b) Regresa una lista que represente un palíndromo que resulta de
;   anidar los números enteros de 0 a N
(define (palindromo n)
  (palin-aux n '()))
; auxiliar de palindromo
(define (palin-aux n lista)
  (let ((nlista (append (list n) lista (list n))))
  (if (zero? n)
      nlista
      (palin-aux (- n 1) nlista))))
;Probar con:
(palindromo 0) 			; => (0 0)
(palindromo 1)			; => (0 1 1 0)
(palindromo 2)			; => (0 1 2 2 1 0)

; c) Regresa una lista con los valores negativos en una lista de números
(define (negativos lista)
  (cond ((null? lista) '())
        ((negative? (car lista))
         (cons (car lista) (negativos (cdr lista))))
        (else (negativos (cdr lista)))))
; Probar con:
(negativos '(3 3 3)) 		; => ()
(negativos '(2 -3 4 -5))	; => (-3 -5)
(negativos '(-9 -2 5 3 -2)) 	; => (-9 -2 -2)

; 3. Recursividad profunda en listas

; a) Programar la función recursiva profundidad que determine y regrese
;    el nivel máximo de anidación dentro de una lista posiblemente
;    imbricada.
(define (profundidad lista)
  (cond ((null? lista) 0)
        ((list? (car lista)) (max (+ 1 (profundidad (car lista)))
                                  (profundidad (cdr lista))))
        (else (profundidad (cdr lista)))))
; Probar con:
(profundidad '(a b c))			; => 0
(profundidad '(a (b) c))		; => 1
(profundidad '(0 (1 (2) 1) 0))	        ; => 2

; b) Programar la función recursiva simetrico que construya una lista
;    que describa un patrón simétrico con N niveles de anidamiento.
(define (simetrico n)
  (if (zero? n)
      '()
      (list '< (simetrico (- n 1)) '>)))
; Probar con:
(simetrico 0)	; => ()
(simetrico 1) 	; => (< () >)
(simetrico 2) 	; => (< (< () >) >)

; c) Programar la función recursiva elimina que reduzca una lista
;    posiblemente imbricada eliminando todos los elementos que
;    coincidan con un dato especificado por su primer argumento.
(define (elimina e lista)
  (cond ((null? lista) '())
        ((equal? e (car lista)) (elimina e (cdr lista)))
        ((list? (car lista))
         (cons (elimina e (car lista)) (elimina e (cdr lista))))
        (else (cons (car lista) (elimina e (cdr lista))))))
; Probar con:
(elimina 1 '(a b c))			; => (a b c)
(elimina 'b '(a (b) c))			; => (a () c)
(elimina 1 '(0 (1 (2) 1) 0))		; => (0 ((2)) 0)
