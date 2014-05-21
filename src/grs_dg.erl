-module(grs_dg).

-export([vid/1, eid/1]).
-export([load/1, random/2, store/2]).

vid(Id) ->
	['$v'|Id].

eid(Id) ->
	['$e'|Id].

load(Filename) ->
	{ok, Def} = file:consult(Filename),
	case lists:keyfind(type, 1, Def) of
		{type, Type} ->
			Graph = digraph:new(Type);
		false ->
			Graph = digraph:new()
	end,
	load_graph(Graph, Def).

random(NumVertices, NumEdges) ->
	random:seed(now()),
	Vertices = [{vertex, I-1} || I  <- lists:seq(1, NumVertices)],
	Edges = [{edge, random:uniform(NumVertices-1), random:uniform(NumVertices-1)} || _ <- lists:seq(1, NumEdges)],
	load_graph(digraph:new(), Vertices++Edges).

store(Graph, Filename) ->
	ok.

%% @private
load_graph(Graph, []) ->
	Graph;
load_graph(Graph, [{vertex, Id}|Def]) ->
	load_graph(Graph, [{vertex, Id, []}|Def]);
load_graph(Graph, [{vertex, Id, Label}|Def]) ->
	digraph:add_vertex(Graph, vid(Id), Label),
	load_graph(Graph, Def);
load_graph(Graph, [{edge, V1, V2}|Def]) ->
	load_graph(Graph, [{edge, V1, V2, []}|Def]);
load_graph(Graph, [{edge, V1, V2, Label}|Def]) ->
	digraph:add_edge(Graph, vid(V1), vid(V2), Label),
	digraph:add_edge(Graph, vid(V2), vid(V1), Label),
	load_graph(Graph, Def);
load_graph(Graph, [_|Def]) ->
	load_graph(Graph, Def).

