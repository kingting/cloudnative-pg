# You have the option of using k3d or kind to turn the kubernetes cluster
./install-k3d.sh  # Install k3d if not running in the devcontainer

# Option 1 using k3d as kubernetes cluster and create a cluster registry
./start-k3d.sh  

./delete-k3d.sh # To delete the cluster

# Option 2 using kind to install Kubernetes (not configure with docker registry)
./start-kind.sh

# Install CloudNativePG Operator and kubectl cnpg plugin
./install-cnpg-operator.sh

# cd to deploy directory to proceed with deployment of pg cluster
