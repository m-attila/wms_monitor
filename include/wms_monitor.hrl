%%%-------------------------------------------------------------------
%%% @author Attila Makra
%%% @copyright (C) 2019, OTP Bank Nyrt.
%%% @doc
%%%
%%% @end
%%% Created : 15. Nov 2019 06:13
%%%-------------------------------------------------------------------
-author("Attila Makra").

-define(APP_NAME, wms_monitor).

-type task_type() :: auto | manual | disable.



-type task_definition() :: #{name := binary(),
definition := term(),
type := task_type()}.