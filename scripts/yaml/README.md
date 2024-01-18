# Test the ingress
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
kubectl apply -f nginx-ingress.yaml

export INGRESS_IP=$(kubectl get service traefik  -n kube-system | grep traefik | awk '{print $4}')
echo "Ingress IP Address: $INGRESS_IP"

curl --header "Host: nginx.ingress" http://$INGRESS_IP
