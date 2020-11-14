-module (esclavo) .
-export ([inicio/0, esclavo/1]) .

%----------------ESCLAVO-----------------------------
esclavo (Datos) ->
    receive
            {De, {imprime, Palabra}} ->
                De ! {servidor_esclavo, ok},
                io:format("~w recibido de: ~w~n",[Palabra,De]),
                esclavo(imprime(Palabra));

            {De, {crea_esclavo, Nodo}} ->
                De ! {servidor_esclavo, ok},
                esclavo(crea_esclavo(Nodo))
    end .

inicio() ->
    register(servidor_esclavo, spawn(dist_esclavo, esclavo, [[]])) .

imprime(Palabra) ->
    io:format("Esclavo recibió: ~w~n",[Palabra]).

crea_esclavo(Nodo) ->
    spawn(Nodo,dist_esclavo,esclavo(Nodo),[[]]),
    io:format("Esclavo creado en nodo: ~w~n",[node()]).

