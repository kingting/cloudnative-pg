#!/bin/bash

# Define cluster name
CLUSTER_NAME="cluster"
CLUSTER_REGISTRY="k3d-${CLUSTER_NAME}-registry"

# Create the registry
#k3d registry create localhost --port 5000

# Create a K3d cluster and a dedicated registry for the cluster
# Forward the looad balancer to the devcontainer host 
k3d cluster create $CLUSTER_NAME --port 80:80@loadbalancer --registry-create ${CLUSTER_REGISTRY}:0.0.0.0:5000 

# Merge K3d kubeconfig to default kubeconfig and switch context
k3d kubeconfig merge $CLUSTER_NAME --kubeconfig-switch-context

echo "K3d cluster $CLUSTER_NAME started and kubeconfig is set."
echo "Cluster registry: ${CLUSTER_REGISTRY}:5000"
echo "docker pull alpine:latest"
echo "docker tag alpine:latest localhost:5000/alpine:latest"
echo "docker push localhost:5000/alpine:latest"
echo "curl -X GET http://localhost:5000/v2/"

# Test the k3d cluster registry
echo "kubectl apply -f yaml/alpine-deployment.yaml"
