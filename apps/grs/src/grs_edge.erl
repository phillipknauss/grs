-module(grs_edge).
-behaviour(gen_server).

-export([nodes/1,
				 node/2,
				 property/2,
				 properties/1,
				 set_property/3]).
-export([init/1, 
				 handle_call/3, 
				 handle_cast/2, 
				 handle_info/2, 
				 terminate/2, 
				 code_change/3]).
-export([start_link/1]).

-record(state, {
					nodes=[],
					properties=[]
 			 }).

nodes(Edge) ->
	gen_server:call(Edge, nodes).

node(Edge, NodeID) ->
	gen_server:call(Edge, {node, NodeID}).

property(Edge, Name) ->
	gen_server:call(Edge, {property, Name}).

properties(Edge) ->
	gen_server:call(Edge, properties).

set_property(Edge, Name, Val) ->
	gen_server:cast(Edge, {set_property, Name, Val}).

start_link(Args) ->
	gen_server:start_link(?MODULE, Args, []).

init([]) ->
	{ok, #state{}};
init({Properties, Nodes}) ->
	add_self_to_nodes(Nodes),
	{ok, #state{properties=Properties, nodes=Nodes}}.

handle_call(nodes, _From, #state{nodes=Nodes}=State) ->
	{reply, {ok, Nodes}, State};
handle_call({node, NodeID}, _From, #state{nodes=Nodes}=State) ->
	ByName = lists:keyfind(NodeID, 1, Nodes),
	ByPid = lists:keyfind(NodeID, 2, Nodes),
	if
		ByName == false, ByPid == false ->
			{reply, {error, notfound}, State};
		true ->
			Matches = ByName++ByPid,
			if
				length(Matches) == 1 ->
					{reply, {ok, lists:nth(1, Matches)}, State};
				true ->
					{reply, {ok, Matches}, State}
			end
	end;
handle_call(properties, _From, #state{properties=Properties}=State) ->
	{reply, {ok, Properties}, State};
handle_call({property, Name}, _From, #state{properties=Properties}=State) ->
	{reply, {ok, lists:keyfind(Name, 1, Properties)}, State}.

handle_cast({set_property, Name, Val}, #state{properties=Properties}=State) ->
	{noreply, State#state{properties=[{Name, Val}|Properties]}}.

handle_info(_, State) ->
	{ok, State}.

terminate(_, _) -> ok.

code_change(_, State, _) -> {ok, State}.

add_self_to_nodes([]) ->
	ok;
add_self_to_nodes([{_, Pid}|Nodes]) ->
	grs_node:attach_edge(Pid, self()),
	add_self_to_nodes(Nodes).
