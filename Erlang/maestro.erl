-module(maestro).
-export([inicio/0, maestro/1, imprime_esclavo/2, llama_esclavo/2, crea_esclavo/1, termina/0]).

%----------------MAESTRO-----------------------------
maestro(Lista) ->
    %no_esclavos + Esclavos,
    io:format("Esclavos: ~w~n",[no_esclavos]).

inicio() ->
    register(maestro, spawn(dist, maestro, [[lista]])),
    io:format("Maestro creado ~n").

imprime_esclavo(Palabra,Nodo) ->
    llama_esclavo({imprime, Palabra}, Nodo).
    %maestro(1).

termina() ->
    0.

crea_esclavo(Nodo) ->
    llama_esclavo({crea_esclavo,Nodo}, Nodo).
    %maestro(esclavos + 1).

llama_esclavo(Mensaje,Nodo) ->
    Esclavo = Nodo,
    monitor_node(Esclavo, true),
    {servidor_esclavo, Esclavo} ! {self(), Mensaje},
    receive
        {servidor_esclavo, Respuesta} ->
            monitor_node(Esclavo, false),
            Respuesta;
        {nodedown, Esclavo} -> no
    end .

