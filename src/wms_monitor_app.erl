%%%-------------------------------------------------------------------
%% @doc wms_monitor public API
%% @end
%%%-------------------------------------------------------------------

-module(wms_monitor_app).

-behaviour(application).

-include("wms_monitor.hrl").


%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================
-spec start(Type :: application:start_type(), Args :: term()) ->
    {ok, Pid :: pid()} |
    {error, Reason :: term()}.
start(_StartType, _StartArgs) ->
    ok = wms_cfg:start_apps(?APP_NAME, [wms_dist]),
    ok = init(),
    wms_monitor_sup:start_link().

%%--------------------------------------------------------------------
-spec stop(any()) ->
    atom().
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================

-spec init() ->
    ok.
init() ->
    ok.