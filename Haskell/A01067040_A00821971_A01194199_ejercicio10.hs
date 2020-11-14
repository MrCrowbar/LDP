-- Lucia Cantu-Miller A01194199
-- Paola Villarreal A00821971
-- Jacobo Cruz A01067040

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
