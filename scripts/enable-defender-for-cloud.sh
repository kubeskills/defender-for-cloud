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
