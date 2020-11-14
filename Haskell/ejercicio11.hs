- Ejercicio 11: Estructuras de Datos en Haskell-- Autor: Dr. Santiago Enrique Conant Pablos
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
elimina v (L (E p:r)) = if v == p then elimina v (L r)                                  				else cons (E p) (elimina v (L r))
elimina v (L (p:r)) = cons (elimina v p) (elimina v (L r))

-- función auxiliar que construye una lista de listas anidadas
cons :: LA e -> LA e -> LA econs a (L l) = L (a:l)

