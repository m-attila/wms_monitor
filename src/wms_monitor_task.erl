%%%-------------------------------------------------------------------
%%% @author Attila Makra
%%% @copyright (C) 2019, OTP Bank Nyrt.
%%% @doc
%%%
%%% @end
%%% Created : 15. Nov 2019 14:03
%%%-------------------------------------------------------------------
-module(wms_monitor_task).
-author("Attila Makra").

%% API
-export([get_running_tasks/0, stop_task/1]).

-spec get_running_tasks() ->
  {ok, #{binary() => [binary()]}}.
get_running_tasks() ->
  {ok, Instances} = wms_dist:call(wms_engine_actor,
                                  get_running_task_instances, []),

  {ok, lists:foldl(
    fun({TaskName, Inst}, Accu) ->
      Accu#{TaskName => lists:map(
        fun({TaskInstanceID, {Status, Timestamp, Term}}) ->
          #{
            task_instance_id => TaskInstanceID,
            status => Status,
            timestamp => Timestamp,
            others => Term
          }
        end, Inst)}
    end, #{}, Instances)}.

-spec stop_task(binary()) ->
  ok | {error, term()}.
stop_task(TaskInstanceID) ->
  wms_dist:call(wms_engine_actor, stop_task, [TaskInstanceID]).