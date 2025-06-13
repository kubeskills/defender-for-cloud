# A management group is a container used to organize and govern multiple subscriptions.
# A management group enables centralized policy management, RBAC, and reporting across multiple subscriptions.
# A management group can contain multiple subscriptions or other management groups.
# A management group can have a parent-child relationship to another management group.

# list management groups
az account management-group list --output table

# show management group
az account management-group show --name <your-management-group-name> --output table

# create management group
az account management-group create --name <your-management-group-name> --display-name <your-management-group-display-name> --parent-id <your-parent-id> --output table

# delete management group
az account management-group delete --name <your-management-group-name> --output table

# update management group
az account management-group update --name <your-management-group-name> --display-name <your-management-group-display-name> --output table

# list management groups with filter
az account management-group list --filter <your-filter> --output table

# list management groups with query
az account management-group list --query [].name --output table

# list management groups with query and filter
az account management-group list --query "[?displayName=='Your Management Group Display Name'].name" --output table


# see what memberships you have
az rest --method GET \
  --url "https://graph.microsoft.com/v1.0/me/memberOf" \
  --headers "Content-Type=application/json"

# Elevate access to global admin
# source: https://learn.microsoft.com/en-us/azure/role-based-access-control/elevate-access-global-admin
# gives "User Access Administrator" Role in the tenant
az rest --method post --url "/providers/Microsoft.Authorization/elevateAccess?api-version=2016-07-01"


# However, Global Admin in Entra ID does not automatically grant permissions to Azure Management Groups unless 
# explicitly assigned at the management group or tenant root level in Azure RBAC.
  
# get your tenant id
az account management-group list --output table

# get your object id
az ad signed-in-user show --query id --output tsv

# get your user id
export USER_ID=$(az ad signed-in-user show --query id --output tsv)

# get your tenant id
export TENANT_ID=$(az account show --query tenantId --output tsv)

# assign management group contributor role to your user
az role assignment create \
  --assignee $USER_ID \
  --role "Management Group Contributor" \
  --scope /providers/Microsoft.Management/managementGroups/$TENANT_ID

# get your management group id
export MG_ID=$(az account management-group list --query "[?displayName=='Tenant Root Group'].id" --output tsv)
