% Daniel Castro A01089938
% Jacobo Cruz A01067040 

-module(conc).
-import(lists, [max/1]).
-export([prueba_suma/0, suma/0, registra/0, registra/1, prueba_registra/0, prueba_registra/2]).
%-export([registra/0, registra/1, prueba_registra/0, prueba_registra/2]).

%----------- Ejercicio 1 ----------------------
prueba_suma() ->
   P = spawn(conc, suma, []),
   prueba_suma(5, P).
   
prueba_suma(N, P) when N > 0 ->
   P ! {suma, N, self()},
   receive
       {reply, S} ->
           io:format("Acumulado ~w~n", [S]),
           prueba_suma(N-1, P)
   end;
prueba_suma(_, _) ->
    io:format("Terminé mi trabajo~n").


suma () -> suma(0).
suma (A) ->
	receive 
		{suma, N, P} -> 
			P ! {reply, A + N },
			suma(A + N)
	end.
%-----------------------------------------------

% --------- Problema 2

% Funcion para la primera iteración 
registra() ->
    L = [],
    receive 
        {registra, Nombre} ->
            registra(L ++ [Nombre]);

        % No encuentra nombre porque es una lista vacia en la primera iteración
        {busca, _ , P} ->
            E = 'no',
            P ! {encontrado, E},
            registra(L);

        % Manda lista vacia 
        {lista, P} ->
            P ! {registrados, L}
    end;

% Función a partir de la segunda iteración
registra(L) ->
    receive
        {registra, Nombre} ->
            if 
                % Agrega el nombre a la lista
                lists:member(Nombre, L) ->
                    registra(L ++ [Nombre]);

                % El nombre ya se encuentra en la lista
                [true -> 
                    registra(L)]
            end,
        {busca, Nombre, P} ->
            if
                % Nombre encontrado
                lists:member(Nombre,L) ->
                    E = 'si';
                    
                % Nombre no encontrado
                [true -> 
                    E = 'no']
            end,
            P ! {encontrado, E},
            registra(L);

        {lista, P} ->
            P ! {registrados, L},
            registra(L)
    end.

prueba_registra() ->
    P = spawn(conc, registra, []),
    prueba_registra(6, P);

prueba_registra(N, P) ->
    case N of
        6 -> P ! {registra, 'Luis'},
            io:format("Luis fue agregado a la lista~n"),
            prueba_registra(N-1,P);

        5 -> P ! {registra, 'Gerardo'},
            io:format("Gerardo fue agregado a la lista~n"),
            prueba_registra(N-1,P);

        4 -> P ! {registra, 'Luis'},
            io:format("No se premiten nombres repetidos~n"),
            prueba_registra(N-1,P);

        3 -> P ! {lista, self()},
            receive
                {registrados, L} ->
                    io:fwrite("Lista de nombres: ~w~n", [L]),
                    prueba_registra(N-1,P)
            end;

        2 -> P ! {busca, 'Luis', self()},
        receive
            {encontrado, si} ->
                io:format("Luis fue encontrado a la lista~n"),
                prueba_registra(N-1,P);
            {encontrado, no} ->
                io:format("Luis no fue encontrado a la lista~n"),
                prueba_registra(N-1,P)
        end;

        1 -> P ! {busca, 'Miguel', self()},
            {encontrado, si} ->
                io:format("Miguel fue encontrado a la lista~n"),
                prueba_registra(N-1,P);
            {encontrado, no} ->
                io:format("Miguel no fue encontrado a la lista~n"),
                prueba_registra(N-1,P);
        [_ -> 
            io:format("Problema 2 terminado ~n")]
    end.
