#!/bin/bash
# Randomly scale deployments in a given Kubernetes namespace.

: ${DELAY:=2}
read -p "Enter effected namespace: " namespace
read -p "Enter number of effected deployments: " numdeploy
read -p "Enter number of replicas to scale: " numscale

random=$(kubectl -n $namespace -o 'jsonpath={.items[*].metadata.name}' get deploy | tr " " "\n" | gshuf | head -n $numdeploy)

kubectl scale deploy $random --replicas=$numscale -n $namespace

sleep "${DELAY}"

kubectl get deploy -n $namespace

kubectl get po -n $namespace | grep $random
