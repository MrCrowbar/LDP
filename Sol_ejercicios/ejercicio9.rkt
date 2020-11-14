#lang racket

; Ejercicio 9: Funciones de Orden Superior en Racket
; Autor: Dr. Santiago Enrique Conant Pablos

; 1. Programar SIN usar primitivos de orden superior (como el map, apply, etc.)

; a. Programar la función de orden superior recursiva filtra que
;    elimine de una lista, que se le dé como primer argumento, todos
;    los elementos que no cumplan con un predicado unario, que se le dé
;    como segundo argumento.
(define filtra
  (lambda (lista pred)
    (cond ((null? lista) lista)
          ((pred (car lista))
           (cons (car lista) (filtra (cdr lista) pred)))
          (else (filtra (cdr lista) pred)))))
; Probar con:
(filtra '(1 -2 -3 4 -5) negative?)  		; => (-2 -3 -5)
(filtra '(1 -2 -3 4 -5) (lambda (x) (> x -3)))	; => (1 -2 4)

; b. Programar la función de orden superior compon que reciba dos
;    funciones unarias (f y g) como argumentos, y regrese una función
;    que aplique la composición de funciones f(g(x)) a un valor x.
(define compon
  (lambda (f g) (lambda (x) (f (g x)))))
; Probar con:
((compon sqrt abs) -4)  	; => 2
((compon car cdr) '(1 2 3))  	; => 2

; c. Programar la función de orden superior agregaAlFinal que toma un
;    elemento e y regresa una función que toma una lista y agrega e al
;    final de la lista.
(define agregaAlFinal
  (lambda (e) (lambda (lista) (append lista (list e)))))
; Probar con:
((agregaAlFinal 'a) '(2 3 4)) 	; => (2 3 4 a)
((agregaAlFinal '(3 4)) '(1 2))	; => (1 2 (3 4))

; 2. Programar USANDO los primitivos de orden superior MAP y APPLY, pero
;    SIN utilizar recursividad explícita

; a. Programar la función impares que sin utilizar recursividad
;    explícita elimine todos los elementos que no sean impares de una
;    lista de sublistas.
(define impares
  (lambda (lista)
    (map (lambda (sublista)
           (apply append
                  (map (lambda (e) (if (odd? e) (list e) '()))
                       sublista)))
         lista)))
; Probar con:
(impares '((1 2 3)(4 5 6)))	; => ((1 3)(5))
(impares '((2 2)(2 2)(2 2)))	; => (()()())

; b. Programar el predicado impares? que sin utilizar recursividad
;    explícita determine si hay elementos impares dentro de una lista
;    de sublistas.
(define impares?
  (lambda (lista)
    (> (apply + (map (lambda (e) (if (odd? e) 1 0))
                     (apply append lista)))
       0)))
; Probar con:
(impares? '((1 2 3)(4 5 6)))	; => #t
(impares? '((2 2)(2 2)(2 2)))	; => #f

; c. Programar la función empareja que sin utilizar recursividad
;    explícita genere la lista de pares que se puede generar con los
;    elementos de una lista plana.
(define empareja
  (lambda (lista)
    (apply append
           (map (lambda (x) (map (lambda (y) (list x y)) lista))
                lista))))
; Probar con:
(empareja '(1))	        ; => ((1 1))
(empareja '(1 2))	; => ((1 1)(1 2)(2 1)(2 2))