%%%-------------------------------------------------------------------
%%% @author Attila Makra
%%% @copyright (C) 2019, Attila Makra.
%%% @doc
%%%
%%% @end
%%% Created : 15. Nov 2019 06:46
%%%-------------------------------------------------------------------
-module(wms_monitor_taskdef).
-author("Attila Makra").

%% API
-export([save_task_to_file/2,
         save_all_task_to_file/1,
         load_task/1,
         load_task_from_file/1,
         drop_task/1,
         run_task/1, load_task_from_privdir/2]).

-include("wms_monitor.hrl").

-spec save_task_to_file(string(), binary()) ->
  ok | {error, term()}.
save_task_to_file(FilePath, Name) ->
  case wms_dist:call(wms_engine_actor, get_task_definition, [Name]) of
    {ok, TaskDefinition} ->
      wms_monitor_file:save(FilePath, TaskDefinition);
    Other ->
      Other
  end.

-spec save_all_task_to_file(string()) ->
  ok | {error, term()}.
save_all_task_to_file(FilePath) ->
  {ok, TaskDefinitions} = wms_dist:call(wms_engine_actor,
                                        get_all_task_definition, []),
  wms_monitor_file:save(FilePath, TaskDefinitions).

-spec load_task(task_definition()) ->
  ok | {error, term()}.
load_task(TaskDefinition) ->
  wms_dist:call(wms_engine_actor,
                put_task_definition, [TaskDefinition]).

-spec load_task_from_file(string()) ->
  ok | {error, term()}.
load_task_from_file(FilePath) ->
  case file:consult(FilePath) of
    {ok, Definitions} ->
      wms_dist:call(wms_engine_actor,
                    put_task_definitions, [Definitions]);
    Other ->
      Other
  end.

-spec load_task_from_privdir(string(), string()) ->
  [{ok, string()} | {error, string(), term()}].
load_task_from_privdir(Subdir, Extension) ->
  DefFiles =
    wms_monitor_file:list_files(filename:join([code:priv_dir(?APP_NAME), Subdir]),
                                Extension),

  [case load_task_from_file(File) of
     ok ->
       {ok, File};
     {error, Reason} ->
       {error, File, Reason}
   end || File <- DefFiles].


-spec drop_task(binary()) ->
  ok.
drop_task(Name) ->
  wms_dist:call(wms_engine_actor, delete_task_definition, [Name]).

-spec run_task(binary()) ->
  ok.
run_task(Name) ->
  wms_dist:call(wms_engine_actor, start_task, [Name]).

