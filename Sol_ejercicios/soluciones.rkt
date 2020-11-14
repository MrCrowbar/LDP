;-----------------------------------------------------------------------------------
; Ejercicio # 5: Programación básica en Racket
; Autor: Dr. Santiago Enrique Conant Pablos

; 1. La función clima regresa un símbolo sobre el rango de la temperatura
;    a partir de su valor en grados centígrados

(define (clima temp)
  (cond ((<= temp 0) 'congelado)
        ((<= temp 10) 'helado)
        ((<= temp 20) 'frio)
        ((<= temp 30) 'normal)
        ((<= temp 40) 'caliente)
        (else 'hirviendo)))

;      Temp <= 0	-> congelado
; 0  < Temp <= 10 	-> helado
; 10 < Temp <= 20 	-> frio
; 20 < Temp <= 30 	-> normal
; 30 < Temp <= 40 	-> caliente
; 40 < Temp		-> hirviendo
(clima -10)   ; => congelado
(clima 5)     ; => helado
(clima 20)    ; => frio
(clima 24)    ; => normal
(clima 37)    ; => caliente
(clima 50)    ; => hirviendo

; 2. La función cuadrante regresa el número de cuadrante a partir de
;    las coordenadas (X, Y) de un punto
(define (cuadrante x y)
  (cond ((> x 0) (cond ((> y 0) 'primer_cuadrante)
                       ((< y 0) 'cuarto_cuadrante)
                       (else 'cuadrantes_1_y_4)))
        ((< x 0) (cond ((> y 0) 'segundo_cuadrante)
                       ((< y 0) 'tercer_cuadrante)
                       (else 'cuadrantes_2_y_3)))
        (else (cond ((> y 0) 'cuadrantes_1_y_2)
                    ((< y 0) 'cuadrantes_3_y_4)
                    (else 'origen)))))

(cuadrante 0 0)	        ; => origen
(cuadrante 2 8)	        ; => primer_cuadrante
(cuadrante -7 -2)       ; => tercer_cuadrante

; 3. La función ordena despliega sus 3 argumentos ordenados de menor a
;    mayor.
(define (ordena a b c)
  (cond ((<= a b c) (despliega a b c))
        ((<= a c b) (despliega a c b))
        ((<= b a c) (despliega b a c)) 
        ((<= b c a) (despliega b c a))
        ((<= c a b) (despliega c a b))
        (else (despliega c b a))))

; función auxiliar de despliegue
(define (despliega a b c)
  (display a) (display " ")
  (display b) (display " ")
  (display c) (newline))

(ordena 1 2 3)		; => 1 2 3
(ordena 8 5 1)		; => 1 5 8
(ordena 9 6 9)		; => 6 9 9

; La función sumapar regresa la suma de los argumentos pares.
(define (sumapar a b c d)
  (+ (if (even? a) a 0)
     (if (even? b) b 0)
     (if (even? c) c 0)
     (if (even? d) d 0)))

(sumapar 1 2 3 4)		; => 6
(sumapar 8 6 4 2)		; => 20
(sumapar 9 5 9 3)		; => 0
;-----------------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------------
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


;-----------------------------------------------------------------------------------
;TAREA4
;1.a elimina columna
(define (elimina-elem reng dist)
  (if (= dist 1) (cdr reng)
      (cons (car reng) (elimina-elem (cdr reng) (- dist 1)))))

(define (elimina-columna col mat)
  (if (null? mat) '()
      (cons (elimina-elem (car mat) col) (elimina-columna col (cdr mat)))))

;1.b cambia elemento de matriz
(define (ceros cnt)
  (if (<= cnt 0) '() (cons '0 (ceros (- cnt 1)))))

(define (get-rows mat r)
  (max (length mat) r))

(define (get-cols mat c)
  (if(null? mat) c
     (max (length (car mat)) c)))

(define (rellena-filas mat tc)
  (if (null? mat) '()
      (cons (append (car mat) (ceros (- tc (length (car mat)))))
            (rellena-filas (cdr mat) tc))))

(define (get-extra-filas tc tr)
  (if (<= tr 0) '()
      (cons (ceros tc) (get-extra-filas tc (- tr 1)))))

(define (rellena-mat mat tc tr)
  (append mat (get-extra-filas tc (- tr (length mat)))))

(define (cambio-renglon reng val pos)
  (if (= pos 1)
      (cons val (cdr reng))
      (cons (car reng) (cambio-renglon (cdr reng) val (- pos 1)))))

(define (cambio mat val r c)
  (if (= r 1)
      (cons (cambio-renglon (car mat) val c) (cdr mat))
      (cons (car mat) (cambio(cdr mat) val (- r 1) c))))

(define (agrega-valor-aux val r c mat)
  (let ([new_mat (rellena-mat (rellena-filas mat (get-cols mat c)) (get-cols mat c) (get-rows mat r))])
    (cambio new_mat val r c)))

(define (agrega-valor val pos mat)
  (agrega-valor-aux val (car pos) (cadr pos) mat))

;2.a min y max de abb
(define (get-min nodo)
  (if (null? (cadr nodo))
      (car nodo)
      (get-min (cadr nodo))))

(define (get-max nodo)
  (if (null? (caddr nodo))
      (car nodo)
      (get-max (caddr nodo))))

(define (rango abb)
  (list (get-min abb) (get-max abb)))

(define ABB
'(8 (5 (2 () ())
 (7 () ()))
 (9 ()
 (15 (11 () ())
 () ))))


; 2.b nodos en nivel
(define (cuenta-nivel-aux abb act niv)
  (cond
    ((null? abb) 0)
    ((= act niv) 1)
    (else (+ (cuenta-nivel-aux (cadr abb) (+ 1 act) niv) (cuenta-nivel-aux (caddr abb) (+ 1 act) niv)))))

(define (cuenta-nivel niv abb)
  (cuenta-nivel-aux abb 0 niv))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
#lang racket
(define (sumatoria matriz)
  (cond ((null? matriz) 0
   (else (+ (apply +(car matriz))
     (sumatoria (cdr matriz)))))))

(define (transpuesta matriz)
  (cond ((null? (car matriz)) '())
        (else (cons (map car matriz)
                    (transpuesta (map cdr matriz)
                                 )
                    )
              )
        )
  )

(define (cuenta-atomos lista)
  (cond ((null? lista) 0)
        ((list? (car lista))
         (+ (cuenta-atomos (car lista))
            (cuenta-atomos (cdr lista))))
        (else (+ 1 (cuenta-atomos (cdr lista))))))

(define (anida-nveces n)
  (anida-aux n 0))

(define (anida-aux n c)
  (if (= n c)
      (list n)
      (list (anida-aux n (+ c 1)))))

(define (encuentra abb valor)
  (cond ((null? abb) #f)
        ((eq? valor (car abb)) #t)
        ((< valor (car abb))
         (encuentra (cadr abb) valor))
        (else (encuentra (caddr abb) valor))))

(define (max-aristas grafo)
  (if (null? grafo)
      0
      (let ((num-primer (length (cdr (car grafo))))
            (max-resto (max-aristas (cdr grafo))))
        (if (<= num-primero max-resto)
            num-primero
            max-resto))))
            

