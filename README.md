# erlang_k8s_cluster
Automatic Erlang peer discovery on k8s. This application can be started with your main erlang application with required configuration to established discovery among peers. 
For more information please refer [Erlang cluster peer discovery on Kubernetes](https://contactchanaka.medium.com/erlang-cluster-peer-discovery-on-kubernetes-aa2ed15663f9)

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
