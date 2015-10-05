grs
===

Graph server in Erlang


Example:

```erlang
1> {ok, A} = grs:node().
{ok,<0.1018.0>}
2> {ok, B} = grs:node().
{ok,<0.1020.0>}
3> {ok, E} = grs:edge(A, B).
{ok,<0.1022.0>}
4> grs_node:edges(A).
{ok,[<0.1022.0>]}
5> grs_node:edges(B).
{ok,[<0.1022.0>]}
6> grs_edge:nodes(E).
{ok,[{undefined,<0.1018.0>},{undefined,<0.1020.0>}]}
7> grs_node:properties(A).
{ok,[]}
8> grs_node:properties(B).
{ok,[]}
9> grs_edge:properties(E).
{ok,[]}
```

Code standard note:

The original implementation work on this did not make use of typespecs. As soon as possible, this code will be updated to make thorough use of typespecs.

TODO:

1. Update edges' node lists when node sets its name
2. Update nodes' edge listss when edge sets its name
3. Implement walk() functionality (see doc/spec.t)
4. Unit tests

TO DESIGN THEN DO:

1. Output (Graphvis, text, others?)
2. Persistance
3. More advanced pathfinding than walk() (A*, simulated annealing)
4. Example applications
