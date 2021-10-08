%%%-------------------------------------------------------------------
%% @doc erlang_k8s_cluster top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(erlang_k8s_cluster_sup).
-author('Chanaka Fernando <contactchanaka@gmail.com>').

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%% sup_flags() = #{strategy => strategy(),         % optional
%%                 intensity => non_neg_integer(), % optional
%%                 period => pos_integer()}        % optional
%% child_spec() = #{id => child_id(),       % mandatory
%%                  start => mfargs(),      % mandatory
%%                  restart => restart(),   % optional
%%                  shutdown => shutdown(), % optional
%%                  type => worker(),       % optional
%%                  modules => modules()}   % optional
init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 0,
                 period => 1},
    ChildSpecs = [{erlang_k8s_cluster_svr,
                    {gen_server, start_link,[{local,erlang_k8s_cluster_svr}, erlang_k8s_cluster_svr,[[]],[]]},
                    permanent, 10000, worker, [erlang_k8s_cluster_svr]
                 }],
    case application:get_env(erlang_k8s_cluster, 'singnal.handler.swap', disable) of
        enable ->
            ok = erlang_k8s_cluster_sigterm_handler:start(),
            error_logger:info_msg("singnal.handler.swap - enable~n");
        _ ->
            error_logger:info_msg("singnal.handler.swap - disable~n")
    end,
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
