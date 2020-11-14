#lang racket

(define 1columna
  (lambda (matriz)
    (if (null? matriz) '()
        (cons (caar matriz)
              (1columna (cdr matriz))))))

(define columna
  (lambda (matriz)
    (if (null? matriz) '()
        (map car matriz)
        )
    )
  )
;------------------------------------------------
(define (sumatoria matriz)
  (apply + (map (lambda (r) (apply + r)) matriz))
 )