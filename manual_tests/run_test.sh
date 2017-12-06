#!/bin/sh

kubectl delete job nats-bench-pubsub 2>/dev/null
kubectl create -f job-nats-bench-pubsub.yaml 

