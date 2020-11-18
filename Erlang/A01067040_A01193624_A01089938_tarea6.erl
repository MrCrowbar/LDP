% Daniel Castro A01089938
% Jacobo Cruz - A01067040
% Diego Frías Nerio - A01193624

% PreProcess
% change nodo() process with your machine name @machine
% 1) Create node tienda 
% werl -sname tienda
% 2) Create node with any name
% werl -sname e1
% 3) In node tienda
% dist:abre_tienda().
% 4) In any node
% dist:suscribir_socio(socio1).
% 5) do any command desired

% missed things elimina_socio : eliminar registros de pedidos no entregados

-module(dist).
%-import(lists, [max/1]).
- export([abre_tienda/0, cierra_tienda/0, tienda/0, suscribir_socio/1, elimina_socio/1, registra_producto/2,
	modifica_producto/2, elimina_producto/1, lista_socios/0, lista_existencias/0]).

% create the process tienda, it will manage 
% Socios and Productos
tienda () ->
	process_flag(trap_exit, true),
	tienda([], [], []).


% all the processes must send a response from the node they recevied the request
% Socios: {clave , nombre}
% Productos: {producto, cantidad }claves productos existentes
% Pedidos: 2 listas atendidos y en proceso
tienda(Socios, Productos, Pedidos) -> 
	receive
		{De, {suscribir_socio, Socio}} ->
			io:format("Create Socio ~n",[]),
			case busca(Socio, Socios) of
				inexistent -> 
					io:format("Socio ~w created ~n",[Socio]),
					De ! inexistent,
					tienda(Socios ++ [{ Socio, Socio}], Productos, Pedidos);
				_ ->
					io:format("Socio ~w already exists ~n",[Socio]),
					De ! existent,
					tienda(Socios,Productos, Pedidos)
			end;
			% also delete all the pedidos no entregados and adjust info
		{De, {elimina_socio, Socio}} ->
			io:format("Eliminate Socio ~n",[]),
			case busca(Socio, Socios) of
				inexistent -> 
					io:format("Socio ~w doesn't exists ~n",[Socio]),
					De ! inexistent,
					tienda(Socios, Productos, Pedidos);
				_ ->
					io:format("Socio ~w eliminated ~n",[Socio]),
					De ! existent,
					tienda(elimina(Socio,Socios), Productos, Pedidos)
			end;
		{De, {lista_socios}} ->
			io:format("Displaying lista Socios ~n",[]),
			De ! Socios,
			tienda(Socios, Productos, Pedidos);
		{De, {registra_producto, Producto, Cantidad}} ->
			io:format("Create Producto ~n",[]),
			case busca(Producto, Productos) of
				inexistent -> 
					io:format("Producto ~w created ~n",[Producto]),
					De ! inexistent,
					tienda(Socios, Productos ++ [{ Producto, Cantidad }], Pedidos);
				_ ->
					io:format("Producto ~w already exists, please modify it ~n",[Producto]),
					De ! existent,
					tienda(Socios,Productos, Pedidos)
			end;
		{De, {elimina_producto, Producto}} ->
			io:format("Eliminate Producto ~n",[]),
			case busca(Producto, Productos) of
				inexistent -> 
					io:format("Producto ~w doesn't exists ~n",[Producto]),
					De ! inexistent,
					tienda(Socios, Productos, Pedidos);
				_ ->
					io:format("Producto ~w eliminated ~n",[Producto]),
					De ! existent,
					tienda(Socios,elimina(Producto,Productos), Pedidos)
			end;
		{De, {modifica_producto, Producto, Cantidad}} ->
			io:format("Modify Producto ~n",[]),
			%make busca to check if the product existence is possible to modify
			case busca(Producto, Productos) of
				inexistent -> 
					io:format("Producto ~w doesn't exists ~n",[Producto]),
					De ! inexistent,
					tienda(Socios, Productos, Pedidos);
				C ->
					%  reduce possible
					if (Cantidad < 0) and (C >= abs(Cantidad)) ->   
						io:format("Producto ~w modified ~n",[Producto]),
						De ! existent,
						tienda(Socios,modifica(Producto, Cantidad ,Productos), Pedidos);
						(Cantidad > 0) ->
						io:format("Producto ~w modified ~n",[Producto]),
						De ! existent,
						tienda(Socios,modifica(Producto, Cantidad ,Productos), Pedidos);
						true -> 
						io:format("Producto ~w not possible to be modified ~n",[Producto]),
						De ! { nopossible, C} ,
						tienda(Socios,Productos, Pedidos)
					end
			end;
		{De, {lista_existencias}} ->
			io:format("Displaying lista Existencias ~n",[]),
			De ! Productos,
			tienda(Socios, Productos, Pedidos);
		{De, {cierra_tienda}} ->
			io:format("Tienda Closed ~n",[]),
			De ! {cierra_tienda}
	end.


% helper function
% busca un nombre dentro de la lista de usuarios
busca(_, []) -> inexistent;
busca(N, [{N , C}|_]) -> C;
busca(N, [_|Resto]) -> busca(N, Resto).


% elimina el esclavo con determinado PID
elimina(_, []) -> [];
elimina(N, [{N, _}|Resto]) -> Resto;
elimina(N, [O |Resto]) -> [O|elimina(N, Resto)].

% Modifica existencia producto
modifica(_, _ , []) -> [];
modifica(N, E , [{N, C}|Resto]) ->[{N, C + E}] ++ Resto;
modifica(N, _ ,[O |Resto]) -> [O|elimina(N, Resto)].


% Make shortname for the server requests
nodo(Nombre) -> list_to_atom(atom_to_list(Nombre)++"@DESKTOP-KKNFEQS").


% create the server process tienda 
abre_tienda() ->
   register(tienda, spawn(dist, tienda, [])),
   'tienda creada'.

cierra_tienda() ->
	io:format("Closing Tienda ~n",[]),
	{tienda, nodo(tienda)} ! {self(), {cierra_tienda}}.

% Client funtions to request server actions 
% pide al maestro crear un esclavo en un nodo distribuido
suscribir_socio(Socio) ->
   {tienda, nodo(tienda)} ! {self(), {suscribir_socio, Socio}},
   receive
	inexistent -> 
		io:format("Socio ~w created ~n",[Socio]);
	existent -> 
		io:format("Socio ~w already exists ~n",[Socio])
   end.

elimina_socio(Socio) ->
   {tienda, nodo(tienda)} ! {self(), {elimina_socio, Socio}},
   receive
	inexistent -> 
		io:format("Socio ~w doesn't exists  ~n",[Socio]);
	existent -> 
		io:format("Socio ~w socio eliminated ~n",[Socio])
   end.

lista_socios() ->
   {tienda, nodo(tienda)} ! {self(), {lista_socios}},
   receive
	Socio -> 
		io:format("Socios in the store ~w  ~n",[Socio])
   end.

registra_producto(Socio, Cantidad) ->
   {tienda, nodo(tienda)} ! {self(), {registra_producto, Socio, Cantidad}},
   receive
	inexistent -> 
		io:format("Producto ~w created ~n",[Socio]);
	existent -> 
		io:format("Producto ~w already exists ~n",[Socio])
   end.

elimina_producto(Socio) ->
   {tienda, nodo(tienda)} ! {self(), {elimina_producto, Socio}},
   receive
	inexistent -> 
		io:format("Producto ~w doesn't exists  ~n",[Socio]);
	existent -> 
		io:format("Producto ~w eliminated ~n",[Socio])
   end.

% Check the negative 
% handle the possibility of modifying wrong in tiend process
modifica_producto(Socio, Cantidad) ->
   {tienda, nodo(tienda)} ! {self(), {modifica_producto, Socio, Cantidad}},
   receive
	inexistent -> 
		io:format("Producto ~w doesn't exists  ~n",[Socio]);
	existent -> 
		io:format("Producto ~w modified ~n",[Socio]);
	{nopossible , N} -> 
		io:format("Producto quantity must be ~w or less to be modified ~n",[N])
   end.

lista_existencias() ->
   {tienda, nodo(tienda)} ! {self(), {lista_existencias}},
   receive
	Productos -> 
		io:format("Productos in the store ~w  ~n",[Productos])
   end.

