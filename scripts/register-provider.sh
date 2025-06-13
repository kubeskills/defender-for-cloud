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

# register the Microsoft.Security Resource for your sub
az provider register --namespace Microsoft.Security

# verify if the Microsoft.Security resource is enabled for your subscription
az provider show --namespace Microsoft.Security --query "registrationState"