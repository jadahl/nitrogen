% Nitrogen Web Framework for Erlang
% Copyright (c) 2010 Jonas Ådahl
% See MIT-LICENSE for licensing information.

-module (element_ext_link).
-export([reflect/0, render_element/1]).
-include ("wf.inc").

maybe(_Key, undefined) ->
    [];
maybe(Key, Value) ->
    {Key, Value}.

reflect() -> record_info(fields, ext_link).

render_element(Record)->
    wf_tags:emit_tag(link, lists:flatten([
            maybe(href, Record#ext_link.url),
            maybe(type, Record#ext_link.type),
            maybe(rel, Record#ext_link.rel),
            maybe(title, Record#ext_link.title)])).
