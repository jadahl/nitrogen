-module (quickstart_yaws_app).
-export ([start/2, stop/0, out/1, out/2, out/3]).
-include_lib ("nitrogen/include/wf.hrl").
-include_lib("yaws/include/yaws.hrl").
-include("simple_bridge/include/yaws_api.hrl").
-define(PORT, 8000).

start(_, _) ->
	% Set up Yaws Configuration...
	{ok, App} = application:get_application(),
	Id = atom_to_list(App),

	SC = #sconf {
		docroot = "./static",
		port=?PORT,
		appmods = [{"/web", ?MODULE}]
	},
	DefaultGC = yaws_config:make_default_gconf(false, Id),
	GC = DefaultGC#gconf {
		logdir = "./logs",
		cache_refresh_secs = 5
	},

	% Following code adopted from yaws:start_embedded/4. 
	% This will need to change if Yaws changes!!!
	ok = application:set_env(yaws, embedded, true),
	ok = application:set_env(App, embedded, true),
	ok = application:set_env(App, id, Id),
	{ok, Pid} = yaws_sup:start_link(),
	yaws_config:add_yaws_soap_srv(GC),
	SCs = yaws_config:add_yaws_auth([SC]),
	yaws_api:setconf(GC, [SCs]),
	{ok, Pid}.
	
stop() -> 
	% Stop the Yaws server.
	Pid = application_controller:get_master(yaws),
	exit(Pid, kill),
	ok.

out(Arg) ->
    RequestBridge = simple_bridge:make_request(yaws_request_bridge, Arg),
    ResponseBridge = simple_bridge:make_response(yaws_response_bridge, Arg),
    nitrogen:init_request(RequestBridge, ResponseBridge),
    nitrogen:run().

out(Arg, Module) -> out(Arg, Module, "").

out(Arg, Module, PathInfo) ->
    io:format("WARNING! Unhandled ~p ~p ~p ~n", [Arg, Module, PathInfo]).

