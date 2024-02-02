
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
```
kubectl get Cluster -n dev
kubectl get Backup -n dev
kubectl get Scheduledbackup -n dev
```
## Test Primary failuer and switchover to Standby

## Bring back Primary
