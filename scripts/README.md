# Install Kubernetes
./start-kind.sh

# Install CloudNativePG Operator and kubectl cnpg plugin
./install.sh

# Deploy a PostgreSQL cluster and pgclient
./run.sh apply dev

# Delete a PostgreSQL cluster and pgclient
./run.sh delete dev

## Exec into cluster and login to access the database using Peer authentication
kubectl exec -it pg-cluster-1 -n dev -- bash

## Login to PG server using Linux peer authentication
psql -U postgres

## Change app password
ALTER USER app WITH PASSWORD 'Mnbv1234';

## Run a pgclient to access the postgresql via network
kubectl exec -it pgclient -n dev -- bash
psql -h pg-cluster-rw -U app

# Operate cnpg

kubectl cpng status pg-cluster -n dev
