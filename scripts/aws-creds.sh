kubectl -n dev create secret generic aws-creds \
  --from-literal=ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
  --from-literal=ACCESS_SECRET_KEY=${AWS_SECRET_ACCESS_KEY}
# --from-literal=ACCESS_SESSION_TOKEN=<session token here> # if required
