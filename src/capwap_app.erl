-module(capwap_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    case capwap_sup:start_link() of
	{ok, _} = Ret ->
	    Opts = case application:get_env(server_ip) of
		       {ok, IP} -> [{ip, IP}];
		       _        -> []
		   end,
	    SOpts = case application:get_env(server_socket_opts) of
			{ok, SOpts0} when is_list(SOpts0) ->
			    SOpts0;
		       _ -> []
		   end,
	    {ok, _} = capwap_sup:start_listener(capwap_udp, {5246, Opts ++ SOpts}),
	    Ret;
	Error ->
	    Error
    end.

stop(_State) ->
    ok.