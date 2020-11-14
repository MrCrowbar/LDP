f_prodpar :: [[Int]] -> [Int]
f_prodpar [[]] = []
f_prodpar lista = [x | x <- map (\(l) -> if odd (length l) then foldl1 (*) l else -101) lista, x /= -101]
--map (\(l) -> foldl1 (*) l) lista
--f_prodpar lista = map (\(l) -> | odd (length l) = foldl1 (*) l | otherwise = -5) lista 

