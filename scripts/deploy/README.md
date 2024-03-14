# Test the ingress
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-ingress.yaml

export INGRESS_IP=$(kubectl get service traefik  -n kube-system | grep traefik | awk '{print $4}')
echo "Ingress IP Address: $INGRESS_IP"

curl --header "Host: nginx.ingress" http://$INGRESS_IP

# Install openebs operator to create openebs-hostpath storage class
kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml

# Make openebs-hostpath as default storage class
../set-default-sc.sh # After this you can run "../pg-cluster.sh apply dev" to create the pg cluster

#kubectl apply -f https://openebs.github.io/dynamic-nfs-provisioner/latest/nfs-operator.yaml

# Create storage class for openebs nfs storage 
#kubectl apply -f openebs-rwx-sc.yaml

# Deploy a PostgreSQL cluster and pgclient
./pg-cluster.sh apply dev

# Delete a PostgreSQL cluster and pgclient
./pg-cluster.sh delete dev

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

kubectl cnpg status pg-cluster -n dev

# Test replication
## Create table and insert data in the rw instance
psql -h pg-cluster-rw -U postgres
CREATE TABLE replication_test (id SERIAL PRIMARY KEY, test_value TEXT);
INSERT INTO replication_test (test_value) VALUES ('Replication test 1'), ('Replication test 2');

## Query data on the replication instance ro instance
psql -h pg-cluster-ro -U postgres
SELECT * FROM replication_test;

## Test Primary failuer and switchover to Standby

## Bring back Primary

# Test backup and restore ???
## Configure Barman backup
### Setup s3 access keys as kubernetes secret
### Use the sample.credentials to setup relevant access keys and secret as env variables
### Run this script to create the secret
./aws-creds.sh

...

# To test a local registry
docker pull alpine
docker tag alpine localhost:5000/alpine
docker push localhost:5000/alpine

# Create a pod yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
  - name: alpine
    image: localhost:5000/alpine

# Apply the yaml
kubectl apply -f test-pod.yaml
