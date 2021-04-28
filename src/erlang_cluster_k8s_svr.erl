%%%-------------------------------------------------------------------
%% @doc erlang_cluster_k8s worker server.
%% @end
%%%-------------------------------------------------------------------

-module(erlang_cluster_k8s_svr).

-behaviour(gen_server).


%% API
-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-record(state, { 'k8s.svc.path' :: string(),
                 'world.list.verbosity' :: atom(),
                 'world.list.tref' :: term(),
                 'dns.wait.ms' :: integer(),
                 'world.list.interval.ms' :: integer() 
                }).


start_link(Name) ->
    gen_server:start_link({local, Name}, ?MODULE, [], []).

init(_Args) ->
    DnsWaitMs = application:get_env(erlang_cluster_k8s, 'dns.wait.ms',5000),
    WorldListMs = application:get_env(erlang_cluster_k8s, 'world.list.interval.ms',5000),
    WorldListVerbosity = application:get_env(erlang_cluster_k8s, 'world.list.verbosity',verbose),
    K8sServicePath = application:get_env(erlang_cluster_k8s, 'k8s.svc.path',[]),
    TimerRef = erlang:start_timer(100, self(), world_list),
    {ok, #state{'k8s.svc.path' = K8sServicePath, 'world.list.verbosity' = WorldListVerbosity,
            'world.list.tref' = TimerRef, 'world.list.interval.ms' = WorldListMs, 'dns.wait.ms' = DnsWaitMs}}.

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info({timeout, TimerRef, world_list}, 
    #state{ 'k8s.svc.path' = [],
            'world.list.verbosity' = WLVerbosity,
            'world.list.tref' = TimerRef, 'world.list.interval.ms' = WorldListMs} = State) ->
    Hostlist = application:get_env(erlang_cluster_k8s, 'world.list',[]),
    net_adm:world_list(Hostlist, WLVerbosity),  
    NewTimerRef = erlang:start_timer(WorldListMs, self(), world_list),
    NewWLVerbosity = application:get_env(erlang_cluster_k8s, 'world.list.verbosity',verbose),
    {noreply, State#state{'world.list.tref' = NewTimerRef, 'world.list.verbosity' = NewWLVerbosity}};

handle_info({timeout, TimerRef, world_list}, 
    #state{ 'k8s.svc.path' = K8sServicePath,
            'world.list.verbosity' = WLVerbosity,
            'world.list.tref' = TimerRef, 'world.list.interval.ms' = WorldListMs, 'dns.wait.ms' = DnsWaitMs} = State) ->
    case catch inet_res:getbyname(K8sServicePath, srv, DnsWaitMs) of
        {ok,{hostent,K8sServicePath,[], srv, _Count, AddressList}} ->
            Hostlist = [string_to_atom(Host) || {_,_,_, Host} <- AddressList],
            net_adm:world_list(Hostlist, WLVerbosity);
        DnsError ->
            error_logger:format("inet_res:getbyname - ~p ~n~n ~p", [K8sServicePath, DnsError])
    end,    
    NewTimerRef = erlang:start_timer(WorldListMs, self(), world_list),
    NewWLVerbosity = application:get_env(erlang_cluster_k8s, 'world.list.verbosity',verbose),
    {noreply, State#state{'world.list.tref' = NewTimerRef, 'world.list.verbosity' = NewWLVerbosity}};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%----------------------------------------------------------------------
%%  internal functions
%%----------------------------------------------------------------------
%% @hidden
string_to_atom(String) ->
case catch erlang:list_to_existing_atom(String) of
    {'EXIT', _ } ->
        erlang:list_to_atom(String);
    Atom ->
        Atom
end.