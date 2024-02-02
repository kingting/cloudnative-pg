# Install k3d, start k3d, deploy Cloudnative PG operator and deploy a postgresql cluster

## You have the option of using k3d or kind to turn the kubernetes cluster
./install-k3d.sh  # Install k3d if not running in the devcontainer

## Option 1 using k3d as kubernetes cluster and create a cluster registry
./start-k3d.sh  

./delete-k3d.sh # To delete the cluster

## Option 2 using kind to install Kubernetes (not configure with docker registry)
./start-kind.sh

## Install CloudNativePG Operator and kubectl cnpg plugin
./install-cn-pg.sh

## Deploy a PostgreSQL cluster and pgclient
./pg-cluster.sh apply dev

## Delete a PostgreSQL cluster and pgclient
./pg-cluster.sh delete dev

# Steps to test the installation

## Exec into cluster and login to access the database using Peer authentication
kubectl exec -it pg-cluster-1 -n dev -- bash

## Login to PG server using Linux peer authentication
psql -U postgres

## Change app password
ALTER USER app WITH PASSWORD 'Mnbv1234';

## Run a pgclient to access the postgresql via network
kubectl exec -it pgclient -n dev -- bash
psql -h pg-cluster-rw -U app
