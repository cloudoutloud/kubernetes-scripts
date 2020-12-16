#!/bin/bash
# Picks a deployment at random and preforms a rolling update with bad image.

read -p "Enter effected namespace: " namespace
read -p "Enter name of corrupt image: " badimage 

random=$(kubectl -n $namespace -o 'jsonpath={.items[*].metadata.name}' get deploy | tr " " "\n" | gshuf | head -n 1)

kubectl set image deploy/$random $random=$badimage