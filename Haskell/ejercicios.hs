-- Ejercicio 10
-- 1. Función fibonacci
fibonacci :: Int -> Int
fibonacci 0 = 0
fibonacci 1 = 1
fibonacci n = fibonacci (n-1) + fibonacci (n-2)

-- Función mayor usando un método ya creado por Haskell
--mayor :: [Int] -> Int
--mayor [] = 0
--mayor (x) = maximum(x)

-- 2. Función mayor
mayor :: [Int] -> Int
mayor [] = 0
mayor [x] = x
mayor (x:xs) =
 if (mayor xs) > x then mayor xs
 else x

-- 3. Función mezcla
mezcla :: [Int] -> [Int] -> [Int]
mezcla [] [] = [] 
mezcla [] (y) = (y) 
mezcla (x) [] = (x)
mezcla [x] [y] = --listas con solo un digito
    if x > y then [y, x]
    else [x, y]
mezcla (x:xs) (y:ys) = --listas con más digitos
    if x > y then [y,x] ++ mezcla (xs) (ys) 
    else [x,y] ++ mezcla (xs) (ys)
    

-- 4. Función repetidos
repetidos :: Eq a => [a] -> [a]
repetidos [] = []
repetidos (x:xs)   | x `elem` xs   = x : rmdups xs
                | otherwise     = rmdups xs
------------------------------------------------------------------------------------------
-- Ejercicio 11: Estructuras de Datos en Haskell

-- 1. Programar la función recursiva maxima en Haskell que obtenga el nombre 
--    y máxima calificación de cada alumno de un grupo de alumnos con registros 
--    en formato: (matrícula (nombre) (calificaciones)). El número de alumnos 
--    y calificaciones puede variar.
maxima :: [(Integer,[Char],[Integer])] -> [(Integer,Integer)]
maxima [] = []
maxima ((mat,_,califs):resto) = (mat,maximum califs): maxima resto

-- 2. Crear el tipo de datos Cuerpo que permita mostrar y comparar cuerpos
--    geométricos: cilindros (de los cuales sabemos su masa, su altura y el radio
--    de su base), cubos (sólo conocemos su masa y el largo de alguno de sus lados)
--    y esferas (de ellas se conoce su masa y su radio).
data Cuerpo =    
	Cilindro Float Float Float |    
	Cubo Float Float |    
	Esfera Float Float    
	deriving (Show,Eq)
-- calcula la densidad de un cuerpo
densidad :: Cuerpo -> Float
densidad cuerpo = masa cuerpo / volumen cuerpo

-- obtiene la masa de un cuerpo
masa :: Cuerpo -> Floatmasa (Cilindro unaMasa _ _) = unaMasa
masa (Cubo unaMasa _) = unaMasa
masa (Esfera unaMasa _) = unaMasa

-- calcula el volumen de un cuerpo
volumen (Cilindro _ unaAltura unRadio) = pi * unRadio * unaAltura
volumen (Cubo _ unLado) = unLado ** 3
volumen (Esfera _ unRadio) = 4/3 * pi * (unRadio ** 3)

-- 3. Programar la función recursiva pares en Haskell que obtenga una lista
--    con los valores pares de los nodos de un árbol binario con tipo de datos:
data AB e = N (AB e) e (AB e) | AV deriving (Show)
pares :: AB Int -> [Int]
pares AV = []
pares (N l n r) =  if even n then [n] ++ pares l ++ pares r              
			else pares l ++ pares r

-- 4. Programar la función recursiva elimina en Haskell que elimina todas las
-- repeticiones de un valor de una lista anidada, donde la lista tiene el
-- tipo de datos:
data LA e = L [LA e] | E e deriving (Show)
elimina :: Eq e => e -> LA e -> LA e 
elimina _ (L []) = L []
elimina v (L (E p:r)) = if v == p then elimina v (L r)
			else cons (E p) (elimina v (L r))
elimina v (L (p:r)) = cons (elimina v p) (elimina v (L r))

-- función auxiliar que construye una lista de listas anidadas
cons :: LA e -> LA e -> LA econs a (L l) = L (a:l)
--------------------------------------------------------------------------------------------------------------------------------------------
-- Ejercicio 12
-- 1. Elimine la primera columna de una matriz dada como una lista de renglones.
resto_col :: [[Int]] -> [[Int]]
resto_col [] = []
resto_col(x:resto) = tail x : resto_col(resto)

-- 2. Obtiene la sumatoria de todos los elementos de una matriz.
sumaMatriz :: [[Int]] -> Int
sumaMatriz [] = 0
sumaMatriz(x:resto) = sum x + sumaMatriz(resto)

-- 3. Obtiene la transpuesta de una matriz.
trans :: [[a]] -> [[a]]
trans ([]:_) = []
trans x = (map head x) : trans (map tail x)

-- 4. Genera procedimientos que apliquen n veces sobre un valor, la función dada como parámetro de entrada.
-- aplicaN :: ?
aplicaN :: (a -> a) -> Int -> a -> a 
aplicaN f 1 = f
aplicaN f n = f . (aplicaN f (n - 1))

-- 5. Genera listas con los números del 1 al N, utilizando la FOS until.
secuencia :: Int -> [Int]
secuencia 0 = []
secuencia 1 = [1]
secuencia n = until (\x -> last x == n) (\x -> x ++ [last x + 1]) [1]
--------------------------------------------------------------------------------------------------------------------------------------------
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

------------------------------------------------------------------------------------------
-- Tarea 5
-- 1. medio
medio :: (Ord a, Fractional a) => a -> a -> a -> a -> a
medio a b c d = (min + max) / 2
  where (min, max) = (minimum [a,b,c,d], maximum [a,b,c,d])

-- 2. primos
is_prime :: Int -> Bool
is_prime 1 = False
is_prime 2 = True
is_prime n
  | (length [x | x <- [2 .. n-1], mod n x == 0]) > 0 = False
  | otherwise = True

primos :: Int -> Int -> Int
primos min max
  | min == max = if is_prime min then 1 else 0
  | otherwise = if is_prime min then 1 + (primos (min + 1) max) else (primos (min + 1) max)

-- 3. mayores
mayores :: [Int] -> [Int] -> [Int]
mayores [] [] = []
mayores (x:xs) (y:ys)
  | x == y = [1] ++ mayores xs ys
  | x > y = [1] ++ mayores xs ys
  | otherwise = [2] ++ mayores xs ys

-- 4. multiplica
multiplica :: [Int] -> [Int] -> [Int]
multiplica x [] = []
multiplica x (y:ys) = x ++ multiplica x ys

-- 5. desplaza
desplaza :: [Int] -> Int -> [Int]
desplaza xs 0 = xs
desplaza xs n = desplaza (last xs : init xs) (n-1)

-- 6. impares
data AB t = A (AB t) t (AB t) | V deriving Show
ab = A (A (A V 2 V) 5 (A V 7 V)) 8 (A V 9 (A (A V 11 V) 15 V))

impares :: AB Int -> [Int]
impares V = []
impares (A l n r)
  | n `mod` 2 /= 0 = [n] ++ impares l ++ impares r
  | otherwise = [] ++ impares l ++ impares r

-- 7. intercambia
intercambia :: AB Int -> AB Int
intercambia V = V
intercambia (A l n r) = (A (intercambia r) n (intercambia l))

-- 8. g_distintos
g_distintos :: (Eq a) => [a] -> [a] -> [a]
g_distintos x [] = []
g_distintos [] y = []
g_distintos (x:xs) (y:ys) 
  | elem x (y:ys) = [] ++ g_distintos xs (y:ys)
  | otherwise = [x] ++ g_distintos xs (y:ys)
  | elem y (x:xs) = [] ++ g_distintos (x:xs) ys
  | otherwise = [y] ++ g_distintos (x:xs) ys
