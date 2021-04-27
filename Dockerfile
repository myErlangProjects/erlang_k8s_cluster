FROM erlang:21.3.8.22
RUN mkdir -p /opt/scm/erlang_cluster_k8s/system/
RUN mkdir -p /opt/scm/erlang_cluster_k8s/logs/
RUN mkdir -p /opt/scm/erlang_cluster_k8s/logs/backlogs/
RUN mkdir -p /opt/scm/erlang_cluster_k8s/pipe/
RUN mkdir -p /opt/scm/erlang_cluster_k8s/db/
RUN mkdir -p /opt/scm/erlang_cluster_k8s/db/backup/
COPY ./_build/default/rel/erlang_cluster_k8s/erlang_cluster_k8s-0.0.1.tar.gz /opt/scm/erlang_cluster_k8s/system/
COPY ./entrypoint.sh /opt/scm/erlang_cluster_k8s/
WORKDIR /opt/scm/erlang_cluster_k8s/system/
RUN tar -xzf erlang_cluster_k8s-0.0.1.tar.gz
RUN ls /opt/scm/erlang_cluster_k8s/system

RUN chmod +x /opt/scm/erlang_cluster_k8s/entrypoint.sh
ENTRYPOINT ["/opt/scm/erlang_cluster_k8s/entrypoint.sh"]