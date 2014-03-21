HOME = /home/knauss/telsa/tserl

deps:
	./rebar get-deps; ./rebar compile

proto:
	escript apps/ts_metrics/proto/build_protos.erl
	mv *_pb.beam apps/ts_metrics/ebin/
	mv *_pb.hrl apps/ts_metrics/include/

compile:
	./rebar compile

recompile:
	./rebar compile skip_deps=true

generate: 
	./rebar generate

build: compile proto test generate

rebuild: recompile test generate

test:
	./rebar eunit skip_deps=true

start: 
	rel/tsnode/bin/tsnode start

stop:
	rel/tsnode/bin/tsnode stop

attach:
	rel/tsnode/bin/tsnode attach

console: 
	rel/tsnode/bin/tsnode console

plt: 
	dialyzer --build_plt -r /usr/lib/erlang/lib/*/ebin $(CURDIR)/deps/*/ebin $(CURDIR)/apps/*/ebin

all: env deps compile proto generate
