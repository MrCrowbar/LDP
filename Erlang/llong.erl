-module(llong).
-export([ayuda/1]).

ayuda([]) -> 0;
ayuda([_ | resto]) -> 1 + ayuda(resto).
