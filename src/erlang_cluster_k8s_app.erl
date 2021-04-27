%%%-------------------------------------------------------------------
%% @doc erlang_cluster_k8s public API
%% @end
%%%-------------------------------------------------------------------

-module(erlang_cluster_k8s_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    erlang_cluster_k8s_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
