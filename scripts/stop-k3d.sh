#!/bin/bash

# Define cluster name
CLUSTER_NAME="k3d-cluster"

# Delete the K3d cluster
k3d cluster delete $CLUSTER_NAME

echo "K3d cluster $CLUSTER_NAME deleted."
