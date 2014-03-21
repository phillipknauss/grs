-module(grs_node_sup).

-behaviour(supervisor).

%% API
-export([add/0]).
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILDN(Name, I, Type), {Name, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

add() ->
	Child = ?CHILDN(make_ref(), grs_node, worker),
	supervisor:start_child(?MODULE, Child).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

