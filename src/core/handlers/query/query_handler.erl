% Nitrogen Web Framework for Erlang
% Copyright (c) 2008-2009 Rusty Klophaus
% See MIT-LICENSE for licensing information.

-module (query_handler).
-export ([
	behaviour_info/1,
	get_value/2
]).

behaviour_info(callbacks) -> [
	% init(Context) -> {ok, NewContext, NewState}.
	% Called at the start of the request. This should 
	% examine the query parameters and update the context.
	{init, 1},      

	% finish(Context, State) -> {ok, NewContext, NewState}.
	% Called at the end of the request, before sending
	% a response back to the browser.
	{finish, 2},
	
	% get_value(Path, Context, State) -> {ok, Value, NewContext, NewState}.
	% Path allows for fuzzy matching of query values. For example,
	% a textbox could have an id of "page_element1_element2_element3_mytextbox"
	% we would want to be able to reference it as 'mytextbox', or 
	% 'element3.mytextbox', etc.
	{get_value, 3}
];

behaviour_info(_) -> undefined.

get_value(Key, Context) ->
	wf_context:apply('query', get_value, [Key], Context).
