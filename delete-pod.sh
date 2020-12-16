#!/bin/bash
# Randomly delete pods in a given Kubernetes namespace.

: ${DELAY:=2}
read -p "Enter effected namespace: " namespace
read -p "Enter number of pods to delete: " num

random=$(kubectl -n $namespace -o 'jsonpath={.items[*].metadata.name}' get pods | tr " " "\n" | gshuf | head -n $num)

kubectl -n $namespace delete pod $random

sleep "${DELAY}"

kubectl get pods -n $namespace
