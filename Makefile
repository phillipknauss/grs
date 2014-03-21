deps:
	./rebar get-deps; ./rebar compile

compile:
	./rebar compile

recompile:
	./rebar compile skip_deps=true

generate: 
	./rebar generate

build: compile test generate

rebuild: recompile generate

test:
	./rebar eunit skip_deps=true

start: 
	rel/grs/bin/grs start

stop:
	rel/grs/bin/grs stop

attach:
	rel/grs/bin/grs attach

console: 
	rel/grs/bin/grs console

plt: 
	dialyzer --build_plt -r /usr/lib/erlang/lib/*/ebin $(CURDIR)/deps/*/ebin $(CURDIR)/apps/*/ebin

all: deps compile generate
