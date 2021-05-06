%%%-------------------------------------------------------------------
%% @doc erlang_k8s_cluster public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_k8s_cluster_app).
-author('Chanaka Fernando <contactchanaka@gmail.com>').
-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    erlang_k8s_cluster_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
