#!/bin/sh

kubectl delete --all jobs
kubectl delete --all deployments
kubectl delete --all pods
kubectl delete service nats-service

