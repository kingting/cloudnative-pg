#!/bin/bash

# Define cluster name
CLUSTER_NAME="k3d-cluster"

# Create a K3d cluster
k3d cluster create $CLUSTER_NAME

# Merge K3d kubeconfig to default kubeconfig and switch context
k3d kubeconfig merge $CLUSTER_NAME --kubeconfig-switch-context

echo "K3d cluster $CLUSTER_NAME started and kubeconfig is set."

