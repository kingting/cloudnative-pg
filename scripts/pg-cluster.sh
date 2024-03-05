#!/bin/bash

if [ "$#" -lt 2 ] 
then
  echo "Usage: $0 <command> <namespace> "
  echo "Example: $0 apply dev" 
  exit 1
fi

#-------------------------------------------------------------------
# Parameters
#-------------------------------------------------------------------
DIR=$(dirname $0)

export COMMAND=$1
export NAMESPACE=$2
export INSTANCE_COUNT=2

#-------------------------------------------------------------------
# Create database credentials and s3 credential for barman backup 
#-------------------------------------------------------------------
# Getting the passwords from .credentials file (later can get the passwords from keyvault)
if [[ -r "$DIR/.credentials" ]]; then
    source "$DIR/.credentials"
else
    echo "Credentials file not found or not readable."
    exit 1
fi
./aws-creds.sh

export APP_DB="app"
export APP_USER="app" # "app"
export SUPERUSER="postgres" #"postgres"
export PG_CLUSTER="pg-cluster-1"


#-------------------------------------------------------------------
# Create the PG Cluster
#-------------------------------------------------------------------
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

envsubst <  pg-cluster.yaml | kubectl $COMMAND -f - 

# Check if COMMAND is 'delete'
if [ "$COMMAND" = "delete" ]; then
  kubectl delete ns $NAMESPACE 
  echo "COMMAND is delete, end of script."
  exit 0
fi

#-------------------------------------------------------------------
# Set App user and Super user passwords
#-------------------------------------------------------------------
# Wait for pg-cluster-1 to be ready

TIMEOUT=60 # Timeout in seconds

end=$((SECONDS + TIMEOUT))

while [ $SECONDS -lt $end ]; do
    # Get the status of the Ready condition
    READY=$(kubectl get pod $PG_CLUSTER -n $NAMESPACE -o json | jq -r '.status.conditions[] | select(.type=="Ready").status')

    # Check if the pod is ready
    if [ "$READY" = "True" ]; then
        echo "Pod is ready."
        break
    fi

    echo "$SECONDS : Waiting for pod to become ready..."
    sleep 5
done

# Check if loop exited due to timeout
if [ $SECONDS -ge $end ]; then
    echo "Timed out waiting for pod to become ready."
    exit 1
fi

# Check if the wait was successful
echo "$PG_CLUSTER is ready. Proceeding with further commands."
kubectl exec -it $PG_CLUSTER -n ${NAMESPACE} -- psql -U $SUPERUSER -c "ALTER USER ${APP_USER} WITH PASSWORD '${APP_PASSWORD}';"
kubectl exec -it $PG_CLUSTER -n ${NAMESPACE} -- psql -U $SUPERUSER -c "ALTER USER ${SUPERUSER} WITH PASSWORD '${SUPERUSER_PASSWORD}';"

