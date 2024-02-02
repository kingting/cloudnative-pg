
# Operate cnpg

kubectl cpng status pg-cluster -n dev

# Test backup and restore ???

## Configure Barman backup
### Setup s3 access keys as kubernetes secret
### Use the sample.credentials to setup relevant access keys and secret as env variables
### Run this script to create the secret
./aws-creds.sh

### Redeploy the cluster
./pg-cluster.sh apply dev
...

## Operator resources

kubectl get Cluster
kubectl get Backup
kubectl get Scheduledbackup

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
