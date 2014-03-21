-module(grs).

-export([node/0, edge/2, edge/3]).

node() ->
	grs_node_sup:add().

edge(L, R) ->
	edge(L, R, []).

edge(L, R, Properties) ->
	grs_edge_sup:add([{undefined, L}, {undefined, R}], Properties).
