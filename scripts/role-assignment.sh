# get subscription
SUB_ID=$(az account show --query id --output tsv)

# get resource group
RESOURCE_GROUP_NAME=secure-rg

# find user id
USER_ID=$(az ad user list --query "[?userPrincipalName=='you@example.com'].objectId" -o tsv)

# find logged-in user object ID
USER_OBJECT_ID=$(az ad signed-in-user show --query objectId -o tsv)

# find user object id
az ad user show --id <your-user-email> --query id --output table

# list role assignments
az role assignment list --assignee $USER_OBJECT_ID --all --output table

# assign contributor role to user
az role assignment create \
  --assignee $USER_ID \
  --role "Contributor" \
  --scope /subscriptions/$SUB_ID

# delete contributor role from user
az role assignment delete \
  --assignee $USER_ID \
  --role "Contributor" \
  --scope /subscriptions/$SUB_ID

# list role assignments for a resource group
az role assignment list --resource-group $RESOURCE_GROUP_NAME --output table

# list role assignments for a subscription
az role assignment list --subscription $SUB_ID --output table

# get VM name
VM_NAME=$(az vm list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)

VM_ID=$(az vm show \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query id \
  -o tsv)


# list role assignments for a resource
az role assignment list --resource $VM_ID --output table



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



