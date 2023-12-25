# Install Kubernetes
kind create cluster -name pg

# Install CloudNativePG
./install.sh

# Deploy a PostgreSQL cluster
./run.sh apply dev

## Exec into cluster and login
kubectl exec -it pg-cluster-1 -n dev -- bash

## Login to PG server using Linux peer authentication
psql -U postgres

## Change app password
ALTER USER app WITH PASSWORD 'Mnbv1234';

## Run a pgclient to access the postgresql
kubectl exec -it pgclient -n dev -- bash
kubectl run pgclient --rm -ti --image=postgres -- /bin/bash
psql -h pg-cluster-rw -U app
