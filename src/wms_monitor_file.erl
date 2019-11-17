%%%-------------------------------------------------------------------
%%% @author Attila Makra
%%% @copyright (C) 2019, OTP Bank Nyrt.
%%% @doc
%%%
%%% @end
%%% Created : 15. Nov 2019 06:48
%%%-------------------------------------------------------------------
-module(wms_monitor_file).
-author("Attila Makra").

%% API
-export([save/2, load/1, list_files/2]).

-spec save(string(), term()) ->
  ok | {error, term()}.
save(FileName, Term) ->
  file:write_file(FileName, io_lib:format("~tp.~n", [Term])).

-spec load(string()) ->
  {ok, term()} | {error, term()}.
load(FileName) ->
  file:consult(FileName).

-spec list_files(string(), string()) ->
  [string()].
list_files(Directory, Extension) ->
  {ok, Files} = file:list_dir_all(Directory),

  lists:filtermap(
    fun(Name) ->
      case filename:extension(Name) of
        Extension ->
          {true, filename:join(Directory, Name)};
        _ ->
          false
      end
    end, Files).
