-module(action_js_call).
-include_lib("wf.hrl").
-export([render_action/1]).

render_action(#js_call {
    fname = FName,
    args = Args}) ->

    EscapedArgs = lists:flatmap(fun escape_arg/1, Args),
    [wf:f("~s(~s);\r\n", [FName, string:join(EscapedArgs, ",")])].

escape_arg(Arg) when is_integer(Arg) ->
    [integer_to_list(Arg)];
escape_arg(Arg) when is_float(Arg) ->
    [float_to_list(Arg)];
escape_arg(Arg) ->
    case escape_arg1(Arg) of
        none ->
            [];
        {str, Arg2} ->
            ["\"" ++ Arg2 ++ "\""];
        {raw, Arg3} ->
            Arg3
    end.

escape_arg1(Arg) when is_tuple(Arg) ->
    case wf_render_elements:render_elements([Arg]) of
        {ok, Script} ->
            {str, wf:js_escape(Script)};
        _ ->
            none
    end;
escape_arg1([C | _Cs] = Arg) when is_integer(C) ->
    {str, Arg};
escape_arg1(Arg) when is_list(Arg) ->
    {raw, "[" ++ lists:join(lists:flatmap(fun escape_arg/1, Arg), ", ") ++ "]"};
escape_arg1(Arg) when is_atom(Arg) ->
    {str, wf_render_actions:normalize_path(Arg)};
escape_arg1(_) ->
    none.
