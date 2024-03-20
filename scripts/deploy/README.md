# Kubernetes Deployment Guide

This README outlines the steps for deploying components in your Kubernetes environment, setting up storage classes, and managing a PostgreSQL database.

## Ingress Setup

To deploy the ingress resources and test your ingress setup, follow these steps:

1. Apply the Nginx configurations:

    ```bash
    kubectl apply -f nginx-deployment.yaml
    kubectl apply -f nginx-service.yaml
    kubectl apply -f nginx-ingress.yaml
    ```

2. Retrieve the Ingress IP address and test the setup:

    ```bash
    export INGRESS_IP=$(kubectl get service traefik -n kube-system | grep traefik | awk '{print $4}')
    echo "Ingress IP Address: $INGRESS_IP"
    curl --header "Host: nginx.ingress" http://$INGRESS_IP
    ```

## Storage Configuration

### OpenEBS Operator and Storage Class Setup

1. Install the OpenEBS operator to enable the `openebs-hostpath` storage class:

    ```bash
    kubectl apply -f https://openebs.github.io/charts/openebs-operator.yaml
    ```

2. Set `openebs-hostpath` as the default storage class:

    ```bash
    ../set-default-sc.sh # Run this then "../pg-cluster.sh apply dev" to create the pg cluster
    ```

### NFS Provisioner and Storage Class Installation

Install the NFS provisioner and the OpenEBS RWX storage class:

```bash
kubectl apply -f https://openebs.github.com/charts/nfs-operator.yaml
```

## PostgreSQL Cluster Management

### Deployment

Deploy a PostgreSQL cluster along with a client for interaction:

```bash
./pg-cluster.sh apply dev
```

### Deletion

Remove the PostgreSQL cluster and its client:

```bash
./pg-cluster.sh delete dev
```

## Database Operations

### Access and Configuration

1. Access the cluster:

    ```bash
    kubectl exec -it pg-cluster-1 -n dev -- bash
    ```

2. Log into the PostgreSQL server:

    ```bash
    psql -U postgres
    ```

3. Change the application password:

    ```sql
    ALTER USER app WITH PASSWORD 'Mnbv1234';
    ```

4. Connect using the network:

    ```bash
    kubectl exec -it pgclient -n dev -- bash
    psql -h pg-cluster-rw -U app
    ```

## Cluster Management with CNPG

Check the status of your PostgreSQL cluster:

```bash
kubectl cnpg status pg-cluster -n dev
```

## Replication Testing

1. Insert data into the read-write instance:

    ```sql
    psql -h pg-cluster-rw -U postgres
    CREATE TABLE replication_test (id SERIAL PRIMARY KEY, test_value TEXT);
    INSERT INTO replication_test (test_value) VALUES ('Replication test 1'), ('Replication test 2');
    ```

2. Query data from the read-only instance:

    ```sql
    psql -h pg-cluster-ro -U postgres
    SELECT * FROM replication_test;
    ```

## Backup and Restore Configuration

Configure and test Barman backup solutions:

1. Set up AWS S3 access keys as a Kubernetes secret:

    ```bash
    ./aws-creds.sh
    ```

## Local Registry Testing

Test your local Docker registry by pulling, tagging, and pushing an image:

```bash
docker pull alpine
docker tag alpine localhost:5000/alpine
docker push localhost:5000/alpine
```

Apply the pod YAML to test the deployment:

```bash
kubectl apply -f test-pod.yaml
```

