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

# enable defender for cloud on servers (CWP) free tier (turned off in Azure Portal)
az security pricing create \
    --name VirtualMachines \
    --tier Free \
    --subscription $SUB_ID

# Verify the pricing update
az security pricing show --name VirtualMachines

# Enable automatic provisioning of MDE agent
az security auto-provisioning-setting update \
  --name default \
  --auto-provision "On"

# Verify MDE integration is on
az security setting list



########## THE BELOW IS OPTIONAL ################

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
    
# check your permissions
az role assignment list --assignee chadcrowell@kubeskills.onmicrosoft.com --query "[].roleDefinitionName"

# register network provider
az provider register --namespace Microsoft.Network

# verify that it is registered
az provider show --namespace Microsoft.Network --query "registrationState"

# register compute provider
az provider register --namespace Microsoft.Compute

# verify that compute provider is registered
az provider show --namespace Microsoft.Compute --query "registrationState"

# register storage provider
az provider register --namespace Microsoft.Storage

# verify that storage provider is registered
az provider show --namespace Microsoft.Storage --query "registrationState"
