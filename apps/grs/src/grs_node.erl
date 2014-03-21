-module(grs_node).
-behaviour(gen_server).

-export([attach_edge/2,
				 detach_edge/2,
				 edges/1,
				 edge/2,
				 property/2,
				 properties/1,
				 set_property/3]).
-export([init/1, 
				 handle_call/3, 
				 handle_cast/2, 
				 handle_info/2, 
				 terminate/2, 
				 code_change/3]).
-export([start_link/0]).

-record(state, {
					edges=[],
					properties=[]
 			 }).

attach_edge(Node, Edge) ->
	gen_server:cast(Node, {attach_edge, Edge}).

detach_edge(Node, Edge) ->
	gen_server:cast(Node, {detach_edge, Edge}).

edges(Node) ->
	gen_server:call(Node, edges).

edge(Node, EdgeID) ->
	gen_server:call(Node, {edge, EdgeID}).

property(Node, Name) ->
	gen_server:call(Node, {property, Name}).

properties(Node) ->
	gen_server:call(Node, properties).

set_property(Node, Name, Val) ->
	gen_server:cast(Node, {set_property, Name, Val}).

start_link() ->
	gen_server:start_link(?MODULE, [], []).

init([]) ->
	{ok, #state{}};
init({Properties, Edges}) ->
	{ok, #state{properties=Properties, edges=Edges}}.

handle_call(edges, _From, #state{edges=Edges}=State) ->
	{reply, {ok, Edges}, State};
handle_call({edge, EdgeID}, _From, #state{edges=Edges}=State) ->
	ByName = lists:keyfind(EdgeID, 1, Edges),
	ByPid = lists:keyfind(EdgeID, 2, Edges),
	Matches = ByName++ByPid,
	if
		length(Matches) == 1 ->
			{reply, {ok, lists:nth(1, Matches)}, State};
		true ->
			{reply, {ok, Matches}, State}
	end;
handle_call(properties, _From, #state{properties=Properties}=State) ->
	{reply, {ok, Properties}, State};
handle_call({property, Name}, _From, #state{properties=Properties}=State) ->
	{reply, {ok, lists:keyfind(Name, 1, Properties)}, State}.

handle_cast({attach_edge, Edge}, #state{edges=Edges}=State) ->
	{noreply, State#state{edges=[Edge|Edges]}};
handle_cast({detach_edge, Edge}, #state{edges=Edges}=State) ->
	{noreply, State#state{edges=Edges--[Edge]}};
handle_cast({set_property, Name, Val}, #state{properties=Properties}=State) ->
	{noreply, State#state{properties=[{Name, Val}|Properties]}}.

handle_info(_, State) ->
	{ok, State}.

terminate(_, _) -> ok.

code_change(_, State, _) -> {ok, State}.
