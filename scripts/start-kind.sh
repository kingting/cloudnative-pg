#!/bin/bash

# Define cluster name
CLUSTER_NAME="kind-cluster"

# Create a KinD cluster
kind create cluster --name $CLUSTER_NAME

# Set KUBECONFIG
export KUBECONFIG="$(kind get kubeconfig-path --name="$CLUSTER_NAME")"

echo "KinD cluster $CLUSTER_NAME started and kubeconfig is set."
