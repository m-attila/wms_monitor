%%%-------------------------------------------------------------------
%%% @author Attila Makra
%%% @copyright (C) 2019, Attila Makra.
%%% @doc
%%%
%%% @end
%%% Created : 15. Nov 2019 06:31
%%%-------------------------------------------------------------------
-module(wms_monitor).
-author("Attila Makra").

%% API
-export([load_task/1,
         load_task_from_file/1,
         run_task/1,
         drop_task/1,
         save_task_to_file/2,
         save_all_task_to_file/1,
         get_path/1,
         get_running_tasks/0,
         stop_task/1,
         select_global_variables/1,
         select_private_variables/2,
         set_global_variable/2, load_task_from_privdir/2]).


-include("wms_monitor.hrl").

%% =============================================================================
%% API
%% =============================================================================

%% -----------------------------------------------------------------------------
%% Filename handler functions
%% -----------------------------------------------------------------------------

-spec get_path(string()) ->
  string().
get_path(Filename) ->
  filename:join([code:priv_dir(?APP_NAME), "data", Filename]).

%% -----------------------------------------------------------------------------
%% Load and save task definitions
%% -----------------------------------------------------------------------------

-spec load_task(task_definition()) ->
  ok | {error, term()}.
load_task(TaskDefinition) ->
  wms_monitor_taskdef:load_task(TaskDefinition).

-spec load_task_from_file(string()) ->
  ok | {error, term()}.
load_task_from_file(FilePath) ->
  wms_monitor_taskdef:load_task_from_file(FilePath).

-spec load_task_from_privdir(string(), string()) ->
  [{ok, string()} | {error, string(), term()}].
load_task_from_privdir(Subdir, Extension) ->
  wms_monitor_taskdef:load_task_from_privdir(Subdir, Extension).

-spec save_task_to_file(string(), binary()) ->
  ok | {error, term()}.
save_task_to_file(FilePath, Name) ->
  wms_monitor_taskdef:save_task_to_file(FilePath, Name).

-spec save_all_task_to_file(string()) ->
  ok | {error, term()}.
save_all_task_to_file(FilePath) ->
  wms_monitor_taskdef:save_all_task_to_file(FilePath).

-spec drop_task(binary()) ->
  ok.
drop_task(Name) ->
  wms_monitor_taskdef:drop_task(Name).

%% -----------------------------------------------------------------------------
%% Start task
%% -----------------------------------------------------------------------------

-spec run_task(binary()) ->
  ok.
run_task(Name) ->
  wms_monitor_taskdef:run_task(Name).

-spec get_running_tasks() ->
  {ok, #{binary() => [binary()]}}.
get_running_tasks() ->
  wms_monitor_task:get_running_tasks().

-spec stop_task(binary()) ->
  ok | {error, term()}.
stop_task(TaskInstanceID) ->
  wms_monitor_task:stop_task(TaskInstanceID).

%% -----------------------------------------------------------------------------
%% Variables
%% -----------------------------------------------------------------------------
-spec select_global_variables(binary()) ->
  {ok, map()}.
select_global_variables(Pattern) ->
  wms_monitor_variables:select_global_variables(Pattern).

-spec select_private_variables(binary(), binary()) ->
  {ok, map()}.
select_private_variables(TaskInstanceID, Pattern) ->
  wms_monitor_variables:select_private_variables(TaskInstanceID, Pattern).

-spec set_global_variable(binary(), term()) ->
  ok.
set_global_variable(Variable, Value) ->
  wms_monitor_variables:set_global_variable(Variable, Value).





