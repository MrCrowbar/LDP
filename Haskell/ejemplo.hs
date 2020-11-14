sucesor :: Integer -> Integer 
sucesor n = n + 1

sumaCuadrados :: Int -> Int -> Int
sumaCuadrados x y = x * x + y * y

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n-1)

-- Listas
maxima :: [(Integer, [Char], [Double])] -> [(Integer,Double)]
maxima [] = []
maxima ((mat,_,cal):resto) = (mat, maximum cal) : maxima resto


quitarNones :: [Int] -> [Int]
quitarNones lista = [x | x <- lista, x `mod` 2 == 0]

data AB e = N (AB e) e (AB e) | AV deriving (Show)
pares :: AB Int -> [Int]
pares AV = []
pares (N l n r) = quitarNones [n]++(pares l)++(pares r)


sumaMatriz :: [[Int]] -> Int
sumaMatriz [] = 0
sumaMatriz(x:resto) = sum x + sumaMatriz(resto)

secuencia :: Int -> [Int]
secuencia 0 = []
secuencia 1 = [1]
secuencia n = until (\x -> last x == n) (\x -> x ++ [last x + 1]) [1]


