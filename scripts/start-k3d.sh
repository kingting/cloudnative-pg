#!/bin/bash

# Define cluster name
CLUSTER_NAME="k3d-cluster"

# Create the registry
k3d registry create localhost --port 5000

# Create a K3d cluster
k3d cluster create $CLUSTER_NAME --registry-use localhost:5000

# Merge K3d kubeconfig to default kubeconfig and switch context
k3d kubeconfig merge $CLUSTER_NAME --kubeconfig-switch-context

echo "K3d cluster $CLUSTER_NAME started and kubeconfig is set."
echo "To test local registry:"
echo "curl -X GET http://localhost:5000/v2/"
