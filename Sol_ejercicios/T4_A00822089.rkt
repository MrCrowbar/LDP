#lang racket
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