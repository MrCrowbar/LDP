# Implementación de un parser
# Reconoce expresiones mediante la gramática:
# EXP -> EXP op EXP | EXP -> (EXP) | cte
# la cual fué modificada para eliminar ambigüedad a:
# EXP  -> cte EXP1 | (EXP) EXP1
# EXP1 -> op EXP EXP1 | vacío
# los elementos léxicos (delimitadores, constantes y operadores)
# son reconocidos por el scanner
#
# Autor: Dr. Santiago Conant, Agosto 2014 (modificado Agosto 2015)


import sys
#import A00821971_A01067040_obten_token as scanner
import Tarea2_scanner as scanner

global token
global tokens

# Empata y obtiene el siguiente token
def match(tokenEsperado):
    global token
    global tokens
    print("TOKEN: ", token, ", TOKEN ESPERADO: ", tokenEsperado) # Descomentar línea para debugear
    if token == tokenEsperado:
        token = tokens.pop(0)
    else:
        error("token equivocado")
    

# Función principal: implementa el análisis sintáctico
def parser():
    global token # variable para almacenar el token 'i' de la lista tokens
    global tokens # variable para almacenar la lista de tokens del scanner
    tokens = scanner.obten_token() 
    #print("Tokens: ",tokens) # Descomentar línea para debugear
    token = tokens.pop(0) # inicializa con el primer token
    prog()
    if token == scanner.END:
        print("Expresion bien construida!!")
    else:
        error("expresion mal terminada")

# Módulo que reconoce expresiones sin operador
def exp():
    if token == scanner.INT or token == scanner.FLT or token == scanner.IDT:
        match(token) # reconoce Constantes
        exp1()
    elif token == scanner.LRP:
        match(token) # reconoce Delimitador (
        exp()
        match(scanner.RRP)
        exp1()
    elif token == scanner.CRI:
        match(token) # reconoce Delimitador {
        exp()
        exp1()
        match(scanner.CRD)
    else:
        error("expresion mal iniciada")

# Módulo auxiliar para reconocimiento de expresiones con operador
def exp1():
    if token == scanner.OPB or token == scanner.REL or token == scanner.CON:
        match(token) # reconoce operador
        exp()
        exp1()

# Módulo auxiliar para reconocimiento de asignaciones =
def exp2():
    if token == scanner.IDT:
        match(token)
        if token == scanner.ASG:
            match(token)
            exp()
        else:
            error("expresion mal iniciada")
    else:
        error("expresion mal iniciada")

# Termina con un mensaje de error
def error(mensaje):
    print("ERROR:", mensaje)
    sys.exit(1)

parser()

"""
Así quedaron las nuevas reglas de la gramática
<prog> -> <exp> <prog> | $
<exp> -> <atomo> | <lista>
<atomo> -> simbolo | <constante>
<constante> -> numero | booleano | string
<lista> -> ( <elementos> )
<elementos> -> <exp> <elemento> | espacio
"""

def prog():
    exp()
    prog()

def exp():
    if atomo() or lista():
        match(token)
    else:
        error("expresión mal compuesta")

def atomo():
    return token == scanner.SIM or constante()

def constante():
    return token == scanner.NUM or token == scanner.BOOL or token == scanner.STR:

def lista():
    if token == scanner.LRP:
        match(token)
        elementos()
        return token == scanner.RRP
    else return False

def elementos():
    if exp():
        match(token)
        elementos()
