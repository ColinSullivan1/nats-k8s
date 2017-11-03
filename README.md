# k8s-nats-experimental
A place to save off various k8s/nats artifacts in experimental work.

## Setup

### Launch k8s

#### Minikube
`minicube start`

#### GKE
TBD

## Create the NATS server deployment and service

`./server/setup.sh`


## Build & install the docker image for the NATS benchmark

If using minikube, run `./scripts/use_minikube_docker.sh`

`./nats-bench/docker/build.sh`

## Run benchmarks

The benchmarks are k8s jobs, run the pub/sub in the correct order.

TODO:  Automate

```text
cd nats-bench
kubectl create -f <benchmark>
```

Example of viewing the logs.

```text
$ kubectl get pods -a
NAME                                      READY     STATUS      RESTARTS   AGE
nats-bench-pubsub-tz574                   0/1       Completed   0          58s
nats-server-deployment-6d659cf644-g4ncm   1/1       Running     0          10m

$ kubectl logs nats-bench-pubsub-tz574
Starting benchmark [msgs=10000000, msgsize=128, pubs=1, subs=1]
NATS Pub/Sub stats: 2,143,110 msgs/sec ~ 261.61 MB/sec
 Pub stats: 1,075,216 msgs/sec ~ 131.25 MB/sec
 Sub stats: 1,071,555 msgs/sec ~ 130.81 MB/sec
```
 *Caveat:  This performance is on a macbook pro running minikube.*