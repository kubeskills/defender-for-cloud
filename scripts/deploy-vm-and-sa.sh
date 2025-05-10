# creat resource group
az group create --name secure-rg --location eastus

# create password from random string (OPTIONAL)
export USER_PASS=$(openssl rand -base64 12)

# Deploy the Virtual Machine
az deployment group create \
  --name vmDeployment \
  --resource-group secure-rg \
  --template-file ./vm.bicep \
  --parameters adminUsername='azureuser' adminPassword=$USER_PASS

# Deploy the Storage Account
# Storage account name must be between 3 and 24 characters
az deployment group create \
  --name storageDeployment \
  --resource-group secure-rg \
  --template-file ./storage.bicep
