# k8s-nats

Research into k8s/nats artifacts in some experimental work.  Eventually, this will become part of the nats-io repository and charts checked into Kubernetes.

## Setup

### Launch k8s

#### Minikube
`minicube start`

#### GKE
TBD

## Charts

### Requirements

To use the charts, [helm](https://github.com/kubernetes/helm) is required.  Follow the installation instructions there.

`cd charts`

### Core NATS
The Core NATS server installation can be installed via:

`helm install nats-server`

```text
Colins-MacBook-Pro:charts colinsullivan$ helm list
NAME          	REVISION	UPDATED                 	STATUS  	CHART            	NAMESPACE
eponymous-worm	1       	Wed Dec  6 14:51:15 2017	DEPLOYED	nats-server-0.1.0	default  
```

### NATS Streaming

If you are using NATS streaming, be sure to locally update your dependencies, otherwise installation will fail with the message `Error: found in requirements.yaml, but missing in charts/ directory: nats-server`.

`helm dependency build nats-streaming-server`

From here, you can install nats streamong server:

`helm install nats-streaming-server`

```text
Colins-MacBook-Pro:charts colinsullivan$ helm list
NAME       	REVISION	UPDATED                 	STATUS  	CHART                      	NAMESPACE
yellow-pika	1       	Wed Dec  6 15:20:10 2017	DEPLOYED	nats-streaming-server-0.1.0	default  
```

At this time, either install core NATS or nats streaming.  

TODO:  allow [dependant install](https://github.com/kubernetes/helm/blob/master/docs/charts.md#tags-and-condition-fields-in-requirementsyaml).

## Example NATS Kubernetes objects

You can create a NATS server deployment and service directly; feel free to modify and use the files in `./example_objects` directory, although charts are recommended.

`./example_objects/setup.sh`

## Testing 

We'll test using the NATS benchmarks.  Change to the root directory of this repository.

## Build & install the docker images

If using minikube, run `. ./scripts/use_minikube_docker.sh`.  Otherwise, setup the appropriate docker repository for your Kubernetes install.

`./images/nats-bench/build.sh`
`./images/stan-bench/build.sh`

### Run benchmarks

The benchmarks are k8s jobs, run the pub/sub in the correct order.

From the root directory of this repository:

```text
kubectl create -f manual_tests/whatever.yaml
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