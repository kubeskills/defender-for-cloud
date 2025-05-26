# find user id
az ad user list --output table

# find logged-in user object ID
az ad signed-in-user show

# find user object id
az ad user show --id <your-user-email> --query id --output table

# list role assignments
az role assignment list --assignee <your-user-id-or-object-id> --all --output table

# assign contributor role to user
az role assignment create \
  --assignee <your-user-id-or-object-id> \
  --role "Contributor" \
  --scope /subscriptions/<your-subscription-id>

# delete contributor role from user
az role assignment delete \
  --assignee <your-user-id-or-object-id> \
  --role "Contributor" \
  --scope /subscriptions/<your-subscription-id>

# list role assignments for a resource group
az role assignment list --resource-group <your-resource-group-name> --output table

# list role assignments for a subscription
az role assignment list --subscription <your-subscription-id> --output table

# list role assignments for a resource
az role assignment list --resource <your-resource-id> --output table





