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
#
# Integrantes
# Jacobo Cruz A01067040
# Diego Frías Nerio A01193624


import sys
import A01067040_A01193624_scanner as scanner

global token
global tokens


# Función principal: implementa el análisis sintáctico
def parser():
    global token # variable para almacenar el token 'i' de la lista tokens
    global tokens # variable para almacenar la lista de tokens del scanner
    tokens = scanner.obten_token() 
    #print("Tokens: ",tokens) # Descomentar línea para debugear
    if tokens == scanner.ERR:
        error(">>ERROR LÉXICO<<")
    token = tokens.pop(0) # inicializa con el primer token
    prog()
    if token == scanner.END:
        print(">>ENTRADA CORRECTA<<")
    else:
        error(">>ERROR SINTÁCTICO<<")

# Empata y obtiene el siguiente token
def match(tokenEsperado):
    global token
    global tokens
    #print("TOKEN: ", token, ", TOKEN ESPERADO: ", tokenEsperado) # Descomentar línea para debugear
    if token == scanner.ERR:
        error(">>ERROR LÉXICO<<")
    if token == tokenEsperado:
        token = tokens.pop(0)
    #else:
     #   error("token equivocado")


# Termina con un mensaje de error
def error(mensaje):
    print(mensaje)
    sys.exit(1)

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
    print("<prog>")
    if token == scanner.END:
        return
    else:
        exp()
        prog()


def exp():
    print("<exp>")
    if atomo():
        match(token)
    elif token == scanner.LRP:
        match(token)
        lista()
        match(scanner.RRP)
    else:
        error(">>ERROR SINTÁCTICO<<")
        

def atomo():
    if token == scanner.SIM or constante():
        print("<atomo>")
        return True
    return False
    

def constante():
    if token == scanner.NUM or token == scanner.BOOL or token == scanner.STR:
        print("<constante>")
        return True
    return False


def lista():
    print("<lista>")
    elementos()


def elementos():
    print("<elementos>")
    if token == scanner.RRP:
        return
    exp()
    elementos()

parser()
