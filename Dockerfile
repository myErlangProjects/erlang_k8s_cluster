FROM erlang:24.1.2.0-alpine AS Builder
RUN wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3 && ./rebar3 local install
WORKDIR /erlang_k8s_cluster
COPY rebar.config .
COPY src src
COPY config config
RUN rebar3 release

FROM erlang:24.1.2.0-alpine
RUN mkdir -p /opt/erlang_k8s_cluster/system/
RUN mkdir -p /opt/erlang_k8s_cluster/logs/
RUN mkdir -p /opt/erlang_k8s_cluster/logs/backlogs/
RUN mkdir -p /opt/erlang_k8s_cluster/pipe/
RUN mkdir -p /opt/erlang_k8s_cluster/db/
RUN mkdir -p /opt/erlang_k8s_cluster/db/backup/
WORKDIR /opt/erlang_k8s_cluster/system/
COPY --from=Builder /erlang_k8s_cluster/_build/default/rel/erlang_k8s_cluster/ .
COPY ./entrypoint.sh /opt/erlang_k8s_cluster/
RUN dos2unix /opt/erlang_k8s_cluster/entrypoint.sh
RUN chmod +x /opt/erlang_k8s_cluster/entrypoint.sh
ENTRYPOINT ["/opt/erlang_k8s_cluster/entrypoint.sh"]
