# verify if the Microsoft.Security resource is enabled for your subscription
az provider show --namespace Microsoft.Security --query "registrationState"

# register the Microsoft.Security Resource for your sub
az provider register --namespace Microsoft.Security

# get subscription ID
export SUB_ID=$(az account show --query id --output tsv)

# enable defender for cloud on servers (CWP) standard tier (paid)
az security pricing create \
    --name VirtualMachines \
    --tier Standard \
    --subscription $SUB_ID
    
# enable defender for storage
az security pricing create \
  --name "StorageAccounts" \
  --tier "Standard"

# enable defender for cloud on servers (CWP) free tier (turned off in Azure Portal)
az security pricing create \
    --name VirtualMachines \
    --tier Free \
    --subscription $SUB_ID

# enable defender for App Service
az security pricing create \
  --name AppServices \
  --tier Standard

# enable defender for SQL Databases
az security pricing create \
  --name SqlServers \
  --tier Standard

# enable defender for DNS
az security pricing create \
  --name Dns \
  --tier Standard

# enable defender for Key Vault
az security pricing create \
  --name KeyVaults \
  --tier Standard

# enable defender for Containers (includes AKS and ACR protection)
az security pricing create \
  --name ContainerRegistry \
  --tier Standard

# enable defender for Resource Manager
az security pricing create \
  --name Arm \
  --tier Standard



# Verify the pricing update
az security pricing show --name VirtualMachines

# Enable automatic provisioning of MDE agent
az security auto-provisioning-setting update \
  --name default \
  --auto-provision "On"

# Verify MDE integration is on
az security setting list




# get subscription
export SUB_ID=$(az account show --query id --output tsv)

# Grant Contributor access at the Resource Group level
az role assignment create --assignee chadcrowell@kubeskills.onmicrosoft.com \
    --role "Contributor" \
    --scope "/subscriptions/$SUB_ID"

az role assignment create --assignee chadcrowell@kubeskills.onmicrosoft.com \
    --role "Network Contributor" \
    --scope "/subscriptions/$SUB_ID"

az role assignment create --assignee chadcrowell@kubeskills.onmicrosoft.com \
    --role "Virtual Machine Contributor" \
    --scope "/subscriptions/$SUB_ID"
    
az role assignment create --assignee chadcrowell@kubeskills.onmicrosoft.com \
    --role "Security Admin" \
    --scope "/subscriptions/$SUB_ID"
    

