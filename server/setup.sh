#!/bin/sh

cd "$(dirname ${BASH_SOURCE[0]})"

kubectl create -f nats-service.yaml
sleep 5

kubectl create -f nats-server-deployment.yaml
sleep 5

kubectl get services,pods

