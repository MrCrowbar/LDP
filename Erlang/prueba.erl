-module(prueba).
-export([negativos/1]).

negativos([]) -> 0;
negativos([_ | resto]) -> 1 + negativos(resto).
