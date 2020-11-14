%% Declaración de exports.
-module(parcial).
-export([mayor/3, suma/1, negativos/1, filtra/2, impares/1]). % Ejercicio 14
-export([suma_c/0, suma_c/1, prueba_suma/0, prueba_suma/2]). % Ejercicio 15 - Suma
-export([registra/0, registra/1, prueba_registra/0]). % Ejercicio 15 - Registra
-export([estrella/3, proceso/1, proceso/2]). % Ejercicio 15 - Estrella
-export([inicio/0, crea_esclavo/1, para_esclavo/2, termina/0, maestro/1, esclavo/1]).

%% EJERCICIO 14-------------------------------------------------------------
% 1.- Mayor - regresa el valor mayor.
mayor(A,B,C) ->
    if 
        (A > B) and (A > C) -> A;
        (B > A) and (B > C) -> B;
        (C > A) and (C > B) -> C
    end.

% 2.- Suma - Calcula la sumatoria [(2k-1) | k = 0 .. k = n]
suma(N) ->
    if
        N == 0 -> -1;
        N > 0 -> (2*N - 1) + suma(N-1)
    end.

%3.- Negativos - Regresa lista con valores negativos de una lista de números
negativos([]) -> [];
negativos([Inicio | Resto]) ->
    if
        Inicio < 0 -> [Inicio | negativos(Resto)];
        Inicio > 0 -> negativos(Resto)
    end.

%4.- Filtra - Programar FOS filtra
filtra(_,[]) -> [];
filtra(Pred,[Inicio | Resto]) ->
    case Pred(Inicio) of
        true -> [Inicio | filtra(Pred,Resto)];
        false -> filtra(Pred,Resto)
    end.


%5.- Impares - Sin recursividad explícita eliminar impares dentro de sublistas
impares([]) -> [];
impares([Inicio|Resto]) ->
    [quitar_pares(Inicio) | impares(Resto)].

quitar_pares([]) -> [];
quitar_pares([Inicio | Resto]) ->
    if
        Inicio rem 2 /= 0 -> [Inicio | quitar_pares(Resto)];
        Inicio rem 2 == 0 -> quitar_pares(Resto)
    end.

%% EJERCICIO 15-------------------------------------------------------------

%1.- Suma - 
suma_c() -> suma_c(0).
suma_c(A) ->
    receive
        {suma, N, P} ->
            S = A + N,
            P ! {respuesta, S},
            suma_c(S)
    end.

prueba_suma() ->
   P = spawn(parcial, suma_c, [0]),
   prueba_suma(5, P).

prueba_suma(N, P) when N > 0 ->
   P ! {suma, N, self()},
   receive
       {respuesta, S} ->
           io:format("Acumulado ~w~n", [S]),
           prueba_suma(N-1, P)
   end;

prueba_suma(_, _) ->
    io:format("Terminé mi trabajo~n").

%2.- Registra
registra() -> registra([]).
registra(ListaT) ->
    receive
        {registra, Nombre} ->
            case busca(Nombre,ListaT) of
                no -> registra([Nombre | ListaT]);
                si -> registra(ListaT)
            end;
        {busca, Nombre, P} ->
            E = busca(Nombre,ListaT),
            P ! {encontrado, E},
            registra(ListaT);

        {lista, P} ->
            P ! {registrados, ListaT},
            registra(ListaT)
    end.


busca(_,[]) -> no;
busca(Nombre,[Inicio | Resto]) ->
    if
        Nombre == Inicio -> si;
        Nombre /= Inicio -> busca(Nombre,Resto)
    end.

prueba_registra() ->
   P = spawn(parcial, registra, []),
   registra_nombre(alberto, P),
   lista_registra(P),
   busca_registra(luis,P),
   registra_nombre(carlos, P),
   lista_registra(P).

busca_registra(Nombre, P) ->
   P ! {busca, Nombre, self()},
   receive
       {encontrado, E} ->
           io:format("Encontrado: ~w ~n", [E])
   end.

registra_nombre(Nombre, P) ->
   P ! {registra, Nombre}.

lista_registra(P) ->
    P ! {lista, self()},
    receive
        {registrados, L} ->
            io:format("Lista recibida: ~w ~n",[L])
    end.

%3.- Estrella
estrella(N,M,Mensaje) ->
    PIds = spawner(N),
    enviar_mensaje(PIds, Mensaje, M),
    lists:foreach( (fun(Pid) -> Pid ! {terminado} end), PIds ).

enviar_mensaje(_,_,0) -> io:format("~n");

enviar_mensaje(PIds,Mensaje,M) when M > 0 ->
    enviar_mensaje(PIds,Mensaje),
    enviar_mensaje(PIds, Mensaje, M-1).

enviar_mensaje([],_) -> io:format("~n");
enviar_mensaje([Id_Inicio | Id_Resto],Mensaje) ->
    Id_Inicio ! {mensaje, Mensaje, self()},
    receive
        {respuesta, Num} ->
            io:format("Contestó el proceso ~w ~n",[Num]),
            enviar_mensaje(Id_Resto, Mensaje)
    end.


spawner(0) -> []; 

spawner(N) when N > 0 ->
    lists:append(spawner(N-1), [spawn(parcial,proceso,[N])]).

proceso(Num) ->
    proceso(Num,0).

proceso(Num,Contador) ->
    receive
        {mensaje, Mensaje, Mensajero} ->
            Cont = Contador + 1,
            io:format("p: ~w - n: ~w - m: ~w ~n",[Num,Cont,Mensaje]),
            Mensajero ! {respuesta, Num},
            proceso(Num, Cont);

        {terminado} -> io:format("Proceso ~w terminado~n",[Num])
    end.


%% EJERCICIO 16-------------------------------------------------------------
esclavo(Num) ->
    io:format("Esclavo ~w creado en nodo ~w~n",[Num,node()]).
    
maestro(Esclavos) ->
    receive
        {crear,Nodo} ->
            Cont = Esclavos + 1,
            spawn_link(Nodo,parcial,esclavo,[Cont]),
            maestro(Cont);
            
        {mensaje, Mensaje, Num} ->
            Num ! Mensaje;

        {termina} ->
            terminar
    end.

inicio() ->
    register(maestro, spawn(parcial, maestro, [0])),
    io:format("Maestro creado~n").

crea_esclavo(Nodo) ->
    maestro ! {crear, Nodo}.

para_esclavo(Mensaje,Num) ->
    maestro ! {mensaje, Mensaje, Num}.

termina() ->
    maestro ! {termina}.