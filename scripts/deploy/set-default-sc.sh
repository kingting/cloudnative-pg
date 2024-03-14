#!/bin/bash

# Name of the target storage class
TARGET_STORAGE_CLASS="openebs-hostpath"

# Remove 'is-default-class' annotation from all StorageClasses
echo "Removing default annotation from all StorageClasses..."
kubectl get sc --no-headers -o custom-columns=":metadata.name" | while read -r sc; do
    kubectl patch sc "$sc" -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": null}}}'
done

# Set 'openebs-hostpath' as the default StorageClass
echo "Setting $TARGET_STORAGE_CLASS as the default StorageClass..."
kubectl patch storageclass $TARGET_STORAGE_CLASS -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# Confirmation
echo "Updated default StorageClass:"
kubectl get sc
