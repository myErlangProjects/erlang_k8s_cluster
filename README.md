# erlang_k8s_cluster
Automatic Erlang based cluster creation in k8s

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

## Local release
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

## Docker compose
```
docker-compose up
```

## K8s
Change working directory 
`cd k8s/manifests`

```
kubectl apply -f erlang-k8s-cluster.yaml
```
