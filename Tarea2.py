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