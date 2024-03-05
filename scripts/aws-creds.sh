
#!/bin/bash

source .credentials

# Check if the variables are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    echo "AWS credentials could not be found. Make sure your AWS credentials file is configured correctly."
    exit 1
fi

# Create Kubernetes secret
kubectl -n dev create secret generic aws-creds \
  --from-literal=ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  --from-literal=ACCESS_SECRET_KEY=${AWS_SECRET_ACCESS_KEY}
# --from-literal=ACCESS_SESSION_TOKEN=<session token here> # if required

echo "Kubernetes secret 'aws-creds' created successfully."
