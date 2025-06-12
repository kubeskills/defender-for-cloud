# enable defender for containers
az deployment sub create \
  --location eastus \
  --template-file defender-for-containers.bicep

# create aks cluster
az deployment group create \
  --resource-group secure-rg \
  --template-file aks.bicep \
  --parameters aksClusterName=aks-secure-cluster

# get kubeconfig
az aks get-credentials \
  --resource-group secure-rg \
  --name aks-secure-cluster

