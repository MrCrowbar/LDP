"""
terminales: simbolo, numero, booleano, string
noTerminales: <>

<prog> ::= <exp> <prog> | $
<exp> ::= <átomo>| <lista>
<átomo> ::=símbolo | <constante>
<constante> ::= número| booleano| string
<lista> ::= ( <elementos>)
<elementos> ::= <exp> <elemento> | vacio

EJEMPLOS CORRECTOS
atomos 25 #t "hola amigo" $
(esta es una lista) $
(simbolo (100 (#t "string"))
    sigue lista) $

EJEMPLOS INCORRECTOS
atomos24 #t "hola @migo" $
esta ) es una lista ( $
(simbolo (100 (#t "string))
    13.4 lista $

"""
import sys

# tokens
NUM = 100  # Número entero
LRP = 101  # Delimitador: paréntesis izquierdo
RRP = 102  # Delimitador: paréntesis derecho
SIM = 103  # Simbolo
END = 104  # Fin de la entrada
BOOL = 105 # Booleano
STR = 106  # String
ERR = 200  # Error léxico: palabra desconocida

# Matriz de transiciones: codificación del AFD
# [renglón, columna] = [estado no final, transición]
# Estados > 99 son finales (ACEPTORES)
# Caso especial: Estado 200 = ERROR
#      dig   (    )  raro  esp    $   letra   "     #     t      f
MT = [[  1, LRP, RRP,   4,   0,  END,    2,    3,    5,    2,     2], # edo 0 - estado inicial
      [  1, NUM, NUM,   4, NUM,  NUM,  NUM,  NUM,  NUM,  NUM,   NUM], # edo 1 - dígitos enteros
      [SIM, SIM, SIM,   4, SIM,  SIM,    2,  SIM,  SIM,    2,     2], # edo 2 - Simbolo a-z
      [  3, ERR, ERR, ERR,   3,  ERR,    3,  STR,  ERR,    3,     3], # edo 3 - String
      [ERR, ERR, ERR, ERR, ERR,  ERR,  ERR,  ERR,  ERR,  ERR,   ERR], # edo 4 - ERROR
      [ERR, ERR, ERR, ERR, ERR,  ERR,  ERR,  ERR,  ERR,  BOOL, BOOL]] # edo 5 - BOOL

# Filtro de caracteres: regresa el número de columna de la matriz de transiciones
# de acuerdo al caracter dado
def filtro(c):
    """Regresa el número de columna asociado al tipo de caracter dado(c)"""
    if c == '0' or c == '1' or c == '2' or \
       c == '3' or c == '4' or c == '5' or \
       c == '6' or c == '7' or c == '8' or c == '9': # dígitos
        return 0
    elif c == '(': # delimitador (
        return 1
    elif c == ')': # delimitador )
        return 2
    elif c == ' ' or ord(c) == 9 or ord(c) == 10 or ord(c) == 13: # blancos
        return 4
    elif c == '$': # fin de entrada
        return 5
    elif ord(c) >= 97 and ord(c) <= 122: # identificador a-z
        return 6
    elif c == '"': # caracter string "
        return 7
    elif c == '#': # bool #
        return 8
    else: # caracter raro
        return 3

# Función principal: implementa el análisis léxico
def obten_token():
    """Implementa un analizador léxico: lee los caracteres de la entrada estándar"""
    edo = 0 # número de estado en el autómata
    lexema = "" # palabra que genera el token
    tokens = []
    leer = True # indica si se requiere leer un caracter de la entrada estándar
    while (True):
        while edo < 100:    # mientras el estado no sea ACEPTOR ni ERROR
            if leer: c = sys.stdin.read(1)
            else: leer = True
            edo = MT[edo][filtro(c)]
            if edo < 100 and edo != 0: lexema += c
        if edo == NUM:    
            leer = False # ya se leyó el siguiente caracter
            print("Entero", lexema)
        elif edo == LRP:   
            lexema += c  # el último caracter forma el lexema
            print("Delimitador", lexema)
        elif edo == RRP:  
            lexema += c  # el último caracter forma el lexema
            print("Delimitador", lexema)
        elif edo == SIM: # ya se leyó el siguiente caracter
            leer = False
            print("Identificador",lexema)
        elif edo == ERR:   
            leer = False # el último caracter no es raro
            print("ERROR! palabra ilegal", lexema)
        elif edo == BOOL:
            lexema += c
            print("BOOL",lexema)
        elif edo == STR:
            lexema += c
            print("String",lexema)
        tokens.append(edo)
        if edo == END: return tokens
        lexema = ""
        edo = 0

obten_token()