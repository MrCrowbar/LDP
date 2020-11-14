-module (cliente_banco) .
-export ([consulta/1, deposita/2, retira/2]) .

matriz() -> 'crowbarPC@crowbarPC' .

consulta(Quien) ->
    llama_banco({consulta, Quien}) .
deposita(Quien, Cantidad) ->
    llama_banco({deposita, Quien, Cantidad}).
retira(Quien, Cantidad) ->
    llama_banco({retira, Quien, Cantidad}) .

llama_banco(Mensaje) ->
    Matriz = matriz(),
    monitor_node(Matriz, true),
    {servidor_banco, Matriz} ! {self(), Mensaje},
    receive
        {servidor_banco, Respuesta} ->
            monitor_node(Matriz, false),
            Respuesta;
        {nodedown, Matriz} -> no
    end .