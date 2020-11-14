#lang racket

; Ejercicio 8: Estructuras de Datos en Racket
; Autor: Dr. Santiago Enrique Conant Pablos

; 1. Programar la función recursiva add-ren que agregue un renglón a
;    una matriz. Asumir que se le pasa un renglón adecuado.
(define (add-ren matriz renglon)
  (append matriz (list renglon)))
; Probar con:
(add-ren '() '(1 2))	        ; => ((1 2))
(add-ren '((1 2)) '(3 4))	; => ((1 2)(3 4))

; 2. Programar la función recursiva add-col que agregue una columna a
;    una matriz. Asumir que se le pasa una columna adecuada.
(define (add-col matriz columna)
  (cond ((null? columna) '())
        ((null? matriz) (cons (list (car columna))
                              (add-col matriz (cdr columna))))
        (else (cons (append (car matriz) (list (car columna)))
                    (add-col (cdr matriz) (cdr columna))))))
; Probar con:
(add-col '() '(1 2))	        ; => ((1)(2))
(add-col '((1)(2)) '(3 4))	; => ((1 3)(2 4))

; 3. Programar la función recursiva hojas que obtenga una lista con
;    los valores de los nodos hoja de un árbol binario.
(define (hojas arbol)
  (cond ((null? arbol) '())
        ((and (null? (cadr arbol)) (null? (caddr arbol)))
         (list (car arbol)))
        (else (append (hojas (cadr arbol))
                      (hojas (caddr arbol))))))
; Probar con:
(hojas '())					       ; => ()
(hojas '(8(5(2()())(7()()))(9()(15(11()())()))))      ; => (2 7 11)

; 4. Programar la función recursiva adyacentes que obtenga una lista
;    con el conteo de adyacentes para cada nodo en un grafo descrito
;    mediante una matriz de adyacencias. Numerar los nodos
;    ascendentemente.
(define (adyacentes grafo)
  (adya-aux grafo 1))
; función auxiliar de adyacentes
(define (adya-aux grafo nodo)
  (if (null? grafo)
      '()
      (cons (list nodo (suma (car grafo)))
            (adya-aux (cdr grafo) (+ nodo 1)))))
; suma los elementos de una lista
(define (suma lista)
  (if (null? lista)
      0
      (+ (car lista) (suma (cdr lista)))))
; Probar con:
(adyacentes '((0 1)(1 0)))	; => ((1 1)(2 1))			
(adyacentes '((0 1 0 1)(1 0 1 1)(0 1 0 1)(1 1 1 0)))
; => ((1 2)(2 3)(3 2)(4 3))
