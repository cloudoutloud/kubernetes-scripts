#!/bin/bash

# Checks to see jobs resources that have run on cluster
namespace=default
jobsFinshed=$(kubectl get job -n $namespace -o=jsonpath='{.items[?(@.status.succeeded)].metadata.name}{"\n"}')
for jobs in $jobsFinshed; do 
  kubectl delete job $jobs -n $namespace
  echo "deleting job $jobs...."
done

# If jobs variable is empty
if [ -z "$jobs" ]
then 
   echo "Jobs still running or no jobs exists on cluster"
fi