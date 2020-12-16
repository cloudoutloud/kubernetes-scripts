#!/bin/bash
# Randomly delete a number of nodes in a Kubernetes cluster

: ${DELAY:=3}
read -p "Enter number of nodes to delete: " num

random=$(kubectl -o 'jsonpath={.items[*].metadata.name}' get nodes | tr " " "\n" | gshuf | head -n $num)

echo $random

kubectl delete node $random

sleep "${DELAY}"

kubectl get nodes -o wide