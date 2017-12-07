# nats-k8s

Research into k8s and NATS with some experimental work.  Eventually, charts here will be checked into Kubernetes.

Note that this is a **WORK IN PROGRESS**; much of what you see here may change, drastically.  Feedback is welcome though.

## Setup

### Launch k8s

#### Minikube
`minicube start`

#### GKE
TBD

## Charts

There are charts for core NATS and NATS streaming in the `charts` directory.

### Requirements

To use the charts, [helm](https://github.com/kubernetes/helm) is required.  Follow the installation instructions there.

`cd charts`

### Core NATS
The Core NATS server installation can be installed via:

`helm install nats-server`

```text
$ helm list
NAME          	REVISION	UPDATED                 	STATUS  	CHART            	NAMESPACE
eponymous-worm	1       	Wed Dec  6 14:51:15 2017	DEPLOYED	nats-server-0.1.0	default  
```

### NATS Streaming

If you are using NATS streaming, be sure to locally update your dependencies, otherwise installation will fail with the message `Error: found in requirements.yaml, but missing in charts/ directory: nats-server`.

`helm dependency build nats-streaming-server`

Now you can install nats streaming server:

`helm install nats-streaming-server`

```text
$ helm list
NAME       	REVISION	UPDATED                 	STATUS  	CHART                      	NAMESPACE
yellow-pika	1       	Wed Dec  6 15:20:10 2017	DEPLOYED	nats-streaming-server-0.1.0	default  
```

At this time, either install core NATS or nats streaming.

## Manual Testing

There are a few hacky manual tests for sanity checking the NATS server and NATS streaming server installations.  Tests are run as jobs in your Kubernetes cluster.

### Build & install the docker images

If using minikube, run `. ./scripts/use_minikube_docker.sh` to use the local minikube docker repo.  Otherwise, setup the appropriate docker repository for your environment.  If you haven't installed docker this won't go well.

`./images/nats-bench/build.sh`

`./images/stan-bench/build.sh`

*Make sure you are using a version of docker that support multi-stage builds.*

### NATS

**Single Pub/Sub App**
There is a basic pub/sub test, that sends 10M messages through a single server.
```text
kubectl create -f manual_tests/job-nats-bench-pubsub.yaml 
```

**Seperate publisher and subscriber applications**
You can do one pub to one sub.  These may or may not connect to different servers in your cluster.

```text
kubectl create -f manual_tests/job-nats-bench-sub.yaml
```

Wait for it to start and subscribe, then launch the publisher.

```text
kubectl create -f manual_tests/job-nats-bench-pub.yaml
```

**Seperate publisher to many subscriber applications**
For fanout, and to more confidently test the NATS server service, you can run one pub to five subs.

```text
kubectl create -f manual_tests/job-nats-bench-sub-5.yaml 
```

Wait for it to start and subscribe, then launch the publisher.

```text
kubectl create -f manual_tests/job-nats-bench-pub.yaml
```

### NATS streaming

Use this pub/sub benchmark to sanity check the streaming server.

```text
kubectl create -f manual_tests/job-stan-bench-pubsub.yaml
```

## Example NATS Kubernetes objects

You can create a NATS server deployment and service directly; check out the files in the `./example_objects` directory.

`./example_objects/setup.sh`

# TODO

## Charts

- [ ] TLS options
- [ ] Encrypt passwords
- [ ] Annotations (service, controllers, etc)
- [ ] Configuration files on a pvc
- [ ] Do not solicit routes on a single server NATS deployment
- [X] Chart READMEs
- [ ] LoadBalancerIP value
- [ ] Add NATS streaming file store parameters
- [ ] Monitoring (Prometheus)
- [ ] Support [conditional install](https://github.com/kubernetes/helm/blob/master/docs/charts.md#tags-and-condition-fields-in-requirementsyaml) of NATS in NATS streaming.
