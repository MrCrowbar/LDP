-- Tarea 5 

-- 1.- medio
medio :: (Ord a, Fractional a) => a -> a -> a -> a-> a
medio w x y z = (min + max) / 2 where (min, max) = (minimum [w,x,y,z], maximum [w,x,y,z])
-- check w and x 
-- check w for the others

-- 2.- primos 
is_prime :: Int -> Bool
is_prime 1 = False
is_prime 2 = True
is_prime n 
	| (length [x | x <- [2 .. n-1], mod n x == 0]) > 0 = False 
	| otherwise = True

primos n1 n2
  | n1 == n2 = if is_prime n1 then 1 else 0
  | otherwise = if is_prime n1 then 1 + (primos (n1 +1) n2) else (primos (n1 +1) n2)


-- 3.- mayores 
mayores [] [] = []
mayores (x:xs) (y:ys) = if x >= y then [1] ++ mayores xs ys else [2] ++ mayores xs ys


-- 4.- multiplica 
multAux l1 0 = []
multAux l1 n = l1 ++ multAux l1 (n - 1)

multiplica l1 l2 = multAux l1 (length l2)

-- 5.- desplaza 
desplazaAux (x:xs) = if xs == [] then [] else [x] ++ desplazaAux xs 
desplazaStart (x:xs) = [last xs] ++ [x] ++ desplazaAux xs

desplaza lista 1 = (desplazaStart lista)
desplaza lista n = desplaza (desplazaStart lista) (n -1) 

-- 6.- impares
data AB t = A (AB t) t (AB t) | V deriving Show
ab = A (A (A V 2 V)
		5
		(A V 7 V))
	8
	(A V
		9
		(A (A V 11 V)
		15
		V))
impares :: AB Integer -> [Integer]
impares V = []
impares (A l n r) = quitarPares [n] ++ (impares l) ++ (impares r)

quitarPares :: [Integer] -> [Integer]
quitarPares lista = [x | x <- lista, x `mod` 2 /= 0]

-- 9.- c_tabla 
c_tabla n = [((n,y), n*y )| y <- [1..10]]


