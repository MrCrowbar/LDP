-- Daniel Castro Juárez A01089938
-- Juan Jacobo Cruz Romero A01067040
-- Diego Frías Nerio A01193624
-- Ejercicio13 - Evaluación Peresoza en Haskell

-- 1.- digpares
digpares :: Integer -> Integer
digpares n 
 | n < 10 = if mod n 2 == 0 then 1 else 0
 | otherwise = if mod n 2 == 0 then 1 + digpares (quot n  10) else digpares (quot n  10) 

-- 2.- parimpar
parimpar :: [Integer] -> ([Integer],[Integer])
parimpar xs = 
	([x | x <- xs, even x], [x | x <- xs, odd x] )
	
-- 3.- rango_where y rango_let
rango_where :: (Ord a) => [a] -> (a, a)
rango_where (lista)
	| length lista == 1 = (head lista, head lista)
	| otherwise = (minimo, maximo)
	where (minimo,maximo) = (minimum lista, maximum lista)

rango_let :: (Ord a) => [a] -> (a, a)
rango_let lista =
	let l = lista
	in (minimum l, maximum l)

-- 4.- mclaurin
mclaurin :: Float -> Float -> Float
mclaurin 0 _ = 1
mclaurin _ 0 = 0
mclaurin a n = a**(n-1) + mclaurin a (n-1)
