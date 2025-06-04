az deployment sub create \
  --location eastus \
  --template-file defender-for-containers.bicep


az deployment group create \
  --resource-group secure-rg \
  --template-file aks.bicep \
  --parameters aksClusterName=aks-secure-cluster


