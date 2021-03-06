#lang racket

;Matrícula1: A00821971
;Matrícula2: A01067040

; Problema 1: Función clima
(define (clima temp)
  (cond
    [(<= temp 0) 'congelado]
    [(and (> temp 0) (<= temp 10)) 'helado]
    [(and (> temp 10) (<= temp 20)) 'frio]
    [(and (> temp 20) (<= temp 30)) 'normal]
    [(and (> temp 30) (<= temp 40)) 'caliente]
    [else 'hirviendo]
  )
)

; Problema 2: Función cuadrante
(define (cuadrante x y)
  (cond
    [(and (= x 0) (= y 0)) 'origen]
    [(and (> x 0) (> y 0)) 'primer_cuadrante]
    [(and (< x 0) (> y 0)) 'segundo_cuadrante]
    [(and (< x 0) (< y 0)) 'tercer_cuadrante]
    [else 'cuarto_cuadrante]
  )
)

;Problema 3: Función ordena
(define (sort primero segundo tercero)
  (display primero)(display " ")(display segundo)(display " ")(display tercero)
)

(define (ordena a b c)
  (cond 
    [(and (<= a b) (<= b c)) (sort a b c)]  
    [(and (<= a c) (<= c b)) (sort a c b)]
    [(and (<= b a) (<= a c)) (sort b a c)]
    [(and (<= b c) (<= c a)) (sort b c a)]
    [(and (<= c a) (<= a b)) (sort c a b)]  
    [else (sort c b a)]
  )
)

; Problema 4: Función sumapar
(define (par? var)
  (= (modulo var 2) 0)
)
(define suma 0)
(define (sumapar a b c d)
  (define suma 0)
  [if (par? a) (set! suma (+ suma a)) (set! suma (+ suma 0))]
  [if (par? b) (set! suma (+ suma b)) (set! suma (+ suma 0))]
  [if (par? c) (set! suma (+ suma c)) (set! suma (+ suma 0))]
  [if (par? d) (set! suma (+ suma d)) (set! suma (+ suma 0))]
  suma
)