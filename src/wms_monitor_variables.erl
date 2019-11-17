%%%-------------------------------------------------------------------
%%% @author Attila Makra
%%% @copyright (C) 2019, OTP Bank Nyrt.
%%% @doc
%%%
%%% @end
%%% Created : 16. Nov 2019 12:27
%%%-------------------------------------------------------------------
-module(wms_monitor_variables).
-author("Attila Makra").

%% API
-export([select_global_variables/1,
         select_private_variables/2, set_global_variable/2]).

-spec select_global_variables(binary()) ->
  {ok, map()}.
select_global_variables(Pattern) ->
  wms_dist:call(wms_engine_actor,
                select_global_variables,
                [Pattern]).

-spec select_private_variables(binary(), binary()) ->
  {ok, map()}.
select_private_variables(TaskInstanceID, Pattern) ->
  {ok, Variables} = wms_dist:call(wms_engine_actor,
                                  get_private_variables, [TaskInstanceID]),
  {ok, filter_variables(Variables, Pattern)}.

filter_variables(Variables, <<>>) ->
  Variables;
filter_variables(Variables, BeginOnVariableName) ->
  maps:filter(
    fun(K, V) ->
      case binary:match(K, BeginOnVariableName) of
        {0, _} ->
          true;
        _ ->
          false
      end
    end, Variables).

-spec set_global_variable(binary(), term()) ->
  ok.
set_global_variable(Variable, Value) ->
  wms_dist:call(wms_engine_actor,
                set_global_variable, [Variable, Value]).