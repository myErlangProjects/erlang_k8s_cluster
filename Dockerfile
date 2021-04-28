FROM erlang:21.3.8.22-alpine AS Builder
RUN wget https://s3.amazonaws.com/rebar3/rebar3 && chmod +x rebar3 && ./rebar3 local install
WORKDIR /erlang_cluster_k8s
COPY rebar.config .
COPY src src
COPY config config
RUN rebar3 release

FROM erlang:21.3.8.22-alpine
RUN mkdir -p /opt/erlang_cluster_k8s/system/
RUN mkdir -p /opt/erlang_cluster_k8s/logs/
RUN mkdir -p /opt/erlang_cluster_k8s/logs/backlogs/
RUN mkdir -p /opt/erlang_cluster_k8s/pipe/
RUN mkdir -p /opt/erlang_cluster_k8s/db/
RUN mkdir -p /opt/erlang_cluster_k8s/db/backup/
WORKDIR /opt/erlang_cluster_k8s/system/
COPY --from=Builder /erlang_cluster_k8s/_build/default/rel/erlang_cluster_k8s/ .
COPY ./entrypoint.sh /opt/erlang_cluster_k8s/
RUN chmod +x /opt/erlang_cluster_k8s/entrypoint.sh
ENTRYPOINT ["/opt/erlang_cluster_k8s/entrypoint.sh"]