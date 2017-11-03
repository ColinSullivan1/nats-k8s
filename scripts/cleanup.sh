#!/bin/sh

kubectl delete --all deployments
kubectl delete --all pods
kubectl delete --all jobs
kubectl delete service nats-service

