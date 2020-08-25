# Implementación de un scanner mediante la codificación de un Autómata
# Finito Determinista como una Matríz de Transiciones
# Autor: Dr. Santiago Conant, Agosto 2014 (modificado en Agosto 2015)

"""
Ejercicio 3 - Equipo 10
Paola Villarreal - A
Juan Jacobo Cruz Romero - A01067040
"""
import sys

# tokens
INT = 100  # Número entero
FLT = 101  # Número de punto flotante
OPB = 102  # Operador binario
LRP = 103  # Delimitador: paréntesis izquierdo
RRP = 104  # Delimitador: paréntesis derecho
ASG = 105  # Operador de asignación
REL = 106  # Operador relacional
CON = 107  # Operador condicional
IDT = 108  # Identificador
END = 109  # Fin de la entrada
ERR = 200  # Error léxico: palabra desconocida

# Matriz de transiciones: codificación del AFD
# [renglón, columna] = [estado no final, transición]
# Estados > 99 son finales (ACEPTORES)
# Caso especial: Estado 200 = ERROR
#      dig   op   (    )  raro  esp    .    $    =    <>   !   ?    :   id
MT = [[  1, OPB, LRP, RRP,   4,   0,   4, END,   5,   7,   9, CON, CON, 12], # edo 0 - estado inicial
      [  1, INT, INT, INT, INT, INT,   2, INT, INT, INT, INT, INT, INT, INT], # edo 1 - dígitos enteros
      [  3, ERR, ERR, ERR,   4, ERR,   4, ERR, ERR, ERR, ERR, ERR, ERR, ERR], # edo 2 - primer decimal flotante
      [  3, FLT, FLT, FLT, FLT, FLT,   4, FLT, FLT, FLT, FLT, FLT, FLT, FLT], # edo 3 - decimales restantes flotante
      [ERR, ERR, ERR, ERR,   4, ERR,   4, ERR, ERR, ERR, ERR, ERR, ERR, ERR], # edo 4 - estado de error
      [ASG, ASG, ASG, ASG,   4, ASG,   4, ASG,   6, ASG, ASG, ASG, ASG, ASG], # edo 5 - operador de asignación =
      [REL, REL, REL, REL,   4, REL,   4, REL, REL, REL, REL, REL, REL, REL], # edo 6 - operador relacional ==
      [REL, REL, REL, REL,   4, REL,   4, REL,   8, REL, REL, REL, REL, REL], # edo 7 - operador relacional <, >
      [REL, REL, REL, REL,   4, REL,   4, REL, REL, REL, REL, REL, REL, REL], # edo 8 - operador relacional >=, <=, !=
      [ERR, ERR, ERR, ERR, ERR, ERR, ERR, ERR,   8, ERR, ERR, ERR, ERR, ERR], # edo 9 - operador no relacional !
      [CON, CON, CON, CON, ERR, CON, ERR, CON, CON, CON, CON, CON, CON, CON], # edo 10 - operador condicional ?
      [CON, CON, CON, CON, ERR, CON, ERR, CON, CON, CON, CON, CON, CON, CON], # edo 11 - operador condicional :
      [IDT, IDT, IDT, IDT, ERR, IDT, ERR, IDT, IDT, IDT, IDT, IDT, IDT,  12]  # edo 12 - identificador a-z
      ] 
# Filtro de caracteres: regresa el número de columna de la matriz de transiciones
# de acuerdo al caracter dado
def filtro(c):
    """Regresa el número de columna asociado al tipo de caracter dado(c)"""
    if c == '0' or c == '1' or c == '2' or \
       c == '3' or c == '4' or c == '5' or \
       c == '6' or c == '7' or c == '8' or c == '9': # dígitos
        return 0
    elif c == '+' or c == '-' or c == '*' or \
         c == '/': # operadores
        return 1
    elif c == '(': # delimitador (
        return 2
    elif c == ')': # delimitador )
        return 3
    elif c == ' ' or ord(c) == 9 or ord(c) == 10 or ord(c) == 13: # blancos
        return 5
    elif c == '.': # punto
        return 6
    elif c == '$': # fin de entrada
        return 7
    elif c == '=': # asignación
        return 8
    elif c == '<' or c == '>': # relacional
        return 9
    elif c == '!': # relacional
        return 10
    elif c == '?': # condicional ?
        return 11
    elif c == ':': # condicional :
        return 12
    elif ord(c) >= 97 and ord(c) <= 122: # identificador a-z
        return 13
    else: # caracter raro
        return 4

# Función principal: implementa el análisis léxico
def scanner():
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
        if edo == INT:    
            leer = False # ya se leyó el siguiente caracter
            print("Entero", lexema)
        elif edo == FLT:   
            leer = False # ya se leyó el siguiente caracter
            print("Flotante", lexema)
        elif edo == OPB:   
            lexema += c  # el último caracter forma el lexema
            print("Operador", lexema)
        elif edo == ASG:   
            leer = False # ya se leyó el siguiente caracter
            print("Asignación", lexema)
        elif edo == REL:
            leer = False
            print("Relacional", lexema)
        elif edo == LRP:   
            lexema += c  # el último caracter forma el lexema
            print("Delimitador", lexema)
        elif edo == RRP:  
            lexema += c  # el último caracter forma el lexema
            print("Delimitador", lexema)
        elif edo == CON:
            lexema += c
            print("Condicional", lexema)
        elif edo == IDT:
            leer = False
            print("Identificador",lexema)
        elif edo == ERR:   
            leer = False # el último caracter no es raro
            print("ERROR! palabra ilegal", lexema)
        tokens.append(edo)
        if edo == END: return tokens
        lexema = ""
        edo = 0
scanner()