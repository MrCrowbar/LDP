-module(ejercicio).
-import(lists, [max/1]).
-export([mayor/3, suma/1, negativos/1, member/2, registra/2]).

% variables en mayusculas

mayor (A,B,C) -> lists:max([A,B,C]).

suma (0) -> -1;
suma (A) -> (2 * A) - 1 + suma(A - 1).

negativos([]) -> [];
negativos([Inicio | Resto]) ->
if
	Inicio < 0 -> [Inicio | negativos(Resto)];
	true -> negativos(Resto)
end.


member (_, []) -> false;
member (Value, [H|_]) when Value =:= H -> true;
member (Value, [_|T]) -> member(Value, T).

registra(_, []) -> [];
registra(Nombre, [Lista]) ->
	case Expresion of
		member(Nombre,Lista) == true -> [Lista];
		true -> [Lista | Nombre]
	end.
