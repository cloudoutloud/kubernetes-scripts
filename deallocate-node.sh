#!/bin/bash
# To be used with Azure kubernetes service
# Picks a random node from the main AKS nodepool and deallocates/cordons the node.

read -p "Enter cluster subscription ID: " sub

echo "Getting cluster information..."
vmssname=$(az vmss list -o table --subscription $sub |awk '$1!="Name" && $1!~/----/ {print $1}'| grep -w nodepool)
echo "Azure vmss name is $vmssname"

vmssrg=$(az vmss list -o table --subscription $sub |awk '$2!="ResourceGroup" && $2!~/----/ {print $2}'| head -n 1)
echo "Azure vmss resource group is:  $vmssrg"

random=$(kubectl -o 'jsonpath={.items[*].metadata.name}' get nodes  --selector=agentpool=nodepool | tr " " "\n" | gshuf | head -n 1)
echo "Node: $random is being deallocated"
instanceid=$(echo $random | sed 's/.*\(.\)/\1/')

az vmss deallocate -n $vmssname -g $vmssrg --instance-ids $instanceid --subscription $sub 
sleep 5

kubectl cordon $random
sleep 5

kubectl get nodes -o wide