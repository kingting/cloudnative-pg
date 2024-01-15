#!/bin/bash

# Define cluster name
CLUSTER_NAME="cluster"

# Delete the K3d cluster
k3d cluster delete $CLUSTER_NAME
echo "K3d cluster $CLUSTER_NAME deleted."

# Delete the registry
#docker stop k3d-localhost
#docker rm k3d-localhost
