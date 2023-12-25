#!/bin/bash

if [ "$#" -lt 2 ] 
then
  echo "Usage: $0 <command> <namespace> "
  echo "Example: $0 apply dev" 
  exit 1
fi

export COMMAND=$1
export NAMESPACE=$2

export APP_DB="app"
export APP_USER="YXBw" # "app"
export APP_PASSWORD="TW5idjEyMzQK" # "Mnbv1234"
export SUPERUSER="cG9zdGdyZXMK" #"postgres"
export SUPERUSER_PASSWORD="TW5idjEyMzQK" # "Mnbv1234"
DIR=$(dirname $0)

# Check if the namespace exists
if kubectl get namespace "$NAMESPACE" > /dev/null 2>&1; then
  echo "Namespace '$NAMESPACE' already exists"
else
  # Create the namespace
  echo "Creating namespace '$NAMESPACE'"
  kubectl create namespace "$NAMESPACE"

  if [ $? -eq 0 ]; then
    echo "Namespace '$NAMESPACE' created successfully"
  else
    echo "Failed to create namespace '$NAMESPACE'"
  fi
fi

#kubectl create secret generic postgresql-secret \
#  --from-file=password=$DIR/.password \
#  -n $NAMESPACE

#
envsubst <  pg-cluster.yaml | kubectl $COMMAND -f - 

# Run a pgclient to access the postgresql
echo "Run the following to access the database"
echo "kubectl exec -it pgclient -n dev  -- bash"
# Run a pgclient to access the postgresql
echo "psql -h pg-cluster-rw -U ${PG_USER} -d ${DATABASE}"

kubectl get secret superuser-secret -n ${NAMESPACE} -o jsonpath="{.data.password}" | base64 --decode
kubectl get secret app-secret -n ${NAMESPACE} -o jsonpath="{.data.password}" | base64 --decode
