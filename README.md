# erlang_k8s_cluster
Automatic Erlang peer discovery on k8s. This application can be started with your main erlang application with required configuration to established discovery among peers. 
For more information please refer [Erlang cluster peer discovery on Kubernetes](https://contactchanaka.medium.com/erlang-cluster-peer-discovery-on-kubernetes-aa2ed15663f9)

## configurations

configuration need to be set as environmental variables.

```
# vm.args.src 
-name ${ERLANG_NODENAME} 

-setcookie ${CLUSTER_ERLANG_COOKIE}

+K true
+A30
```
- ${ERLANG_NODENAME} - Erlang node long name ( node@host.domain )
- ${CLUSTER_ERLANG_COOKIE} - share secret (cookie) among erlang cluster nodes

```
# sys.config.src
[
  {erlang_k8s_cluster, 
  [{'k8s.svc.path', ${K8S_HEADLESS_SVC}},
   {'world.list.verbosity', verbose},
   {'world.list.interval.ms', 5000},
   {'dns.wait.ms', 5000},
   {'world.list', ${WORLD_LIST}}
]}
].
```
1. Dynamic node cluster configuration specially when horizontal scaling is expected
- ${K8S_HEADLESS_SVC} - k8s headleass service FQDN
- ${WORLD_LIST} - []

2. Static  node cluster configuration specially when horizontal scaling is not expected
- ${K8S_HEADLESS_SVC} - []
- ${WORLD_LIST} - list of (predefined)fqdn hostnames.

## Packaging application

### Create rebar release
```
rebar3 release
```
or in order to generate tarball
```
rebar3 tar
```

### Create Docker image
```
docker image build -t {IMAGE-NAME} .
```
or build image with `docker-compose` with defined image name in docker-compose file.
```
docker-compose build
```

## Running application

### Local release
Declare required `env vars`
```
export ERLANG_NODENAME=erlang_cluster_k8s@host.name
export CLUSTER_ERLANG_COOKIE=erlang_cluster_k8s
export K8S_HEADLESS_SVC="[]"
export WORLD_LIST="['host.name']"
```
Run
```
./_build/default/rel/erlang_k8s_cluster/bin/erlang_k8s_cluster console
```
Clear
```
Ctrl+c
```

### Docker compose
```
docker-compose up -d
```
Clear out
```
docker-compose down
```

### K8s
Change working directory 
`cd k8s/manifests`
```
kubectl apply -f erlang-k8s-cluster.yaml
```
Clear out
```
kubectl delete -f erlang-k8s-culster.yaml
```
