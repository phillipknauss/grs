GRAPH SERVER

Erlang prefix - grs

Core servers:

grs_node - gen_server representing a node in the graph
					 Knows its connected edges (as pids), and its properties. Nothing else.

		Methods:
			attach_edge
			detach_edge
			edges
			edge
			property
			properties
			set_property

grs_edge - gen_server representing an edge between two nodes
					 Knows its connected nodes (as pids), and its properties.
					 Is given its connected nodes on start, and dies if either
					 of its nodes dies.

		Methods:
			nodes
			node
			property
			properties
			set_property

grs_sup - gen_supervisor that is grandparent of all nodes and edges

grs_node_sup - gen_supervisor that supervises all nodes. Child of grs_sup.

grs_edge_sup - gen_supervisor that supervises all edges. Child of grs_sup.

grs - API module. 

		Methods:
			node/0 (create a new node)
			edge/2 (create an edge between the two specified nodes)
			walk(start, edge_node_pattern) (walks from the specified start node following a specified pattern, terminating when no longer matches or reaches end)


TODO:
	Output (graphvis, text)
	Persist (???)
	Pathfinding (A*, others)
