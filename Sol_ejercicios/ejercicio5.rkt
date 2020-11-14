#lang racket

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
        