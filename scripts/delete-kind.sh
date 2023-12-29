#!/bin/bash

# Define cluster name
CLUSTER_NAME="kind-cluster"

# Delete the KinD cluster
kind delete cluster --name $CLUSTER_NAME

echo "KinD cluster $CLUSTER_NAME deleted."
