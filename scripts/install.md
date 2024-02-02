# Install k3d, start k3d, deploy Cloudnative PG operator and deploy a postgresql cluster

## You have the option of using k3d or kind to turn the kubernetes cluster
./install-k3d.sh  # Install k3d if not running in the devcontainer

## Option 1 using k3d as kubernetes cluster and create a cluster registry
./start-k3d.sh  

### To test a local registry
```
docker pull alpine
docker tag alpine localhost:5000/alpine
docker push localhost:5000/alpine
```
### Create a pod yaml
```
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: alpine
    image: localhost:5000/alpine
```
### Apply the yaml
```
kubectl apply -f test-pod.yaml
./delete-k3d.sh # To delete the cluster
```
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
```
kubectl exec -it pgclient -n dev -- bash
psql -h pg-cluster-rw -U app
```

# Test replication

## Create table and insert data in the rw instance
```
psql -h pg-cluster-rw -U postgres
CREATE TABLE replication_test (id SERIAL PRIMARY KEY, test_value TEXT);
INSERT INTO replication_test (test_value) VALUES ('Replication test 1'), ('Replication test 2');
```
## Query data on the replication instance ro instance
```
psql -h pg-cluster-ro -U postgres
SELECT * FROM replication_test;
```
