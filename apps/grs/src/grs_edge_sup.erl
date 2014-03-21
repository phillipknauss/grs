-module(grs_edge_sup).

-behaviour(supervisor).

%% API
-export([add/2]).
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD4(Name, I, Type, Args), {Name, {I, start_link, Args}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

add(Nodes, Properties) ->
	Child = ?CHILD4(make_ref(), grs_edge, worker, [{Properties, Nodes}]),
	supervisor:start_child(?MODULE, Child).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

