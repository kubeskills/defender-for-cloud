# list storage accounts
az storage account list --query "[].{name:name}" -o table


# store storage account name
export STORAGE_ACCOUNT_NAME=<your-storage-account-name>


# get resource group name
export RESOURCE_GROUP_NAME=$(az storage account show --name $STORAGE_ACCOUNT_NAME --query "resourceGroup" -o tsv)


# ensure diagnostic settings are enabled
# Without diagnostic logs, Defender for Storage can’t see activity, and won’t trigger alerts, no matter how suspicious the access behavior is.
az monitor diagnostic-settings list \
  --resource $(az storage account show \
     --name $STORAGE_ACCOUNT_NAME \
     --resource-group $RESOURCE_GROUP_NAME \
     --query id -o tsv)

# create log analytics workspace
az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP_NAME \
  --workspace-name secureLogsWorkspace \
  --location eastus

# check if the log analytics workspace has been provisioned
az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP_NAME \
  --workspace-name secureLogsWorkspace \
  --query provisioningState \
  -o tsv

# get the workspace ID
export WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP_NAME \
  --workspace-name secureLogsWorkspace \
  --query id \
  -o tsv)

# enable insights (required to use Azure Monitor diagnostic settings)
# NOTE: it could take up to 5 minutes for Insights to complete registration
az provider register --namespace Microsoft.Insights

# verify that insights has completed registering Insights for your subscription
az provider show --namespace Microsoft.Insights --query "registrationState" -o tsv

# get the blob service resource ID
export BLOB_SERVICE_ID=$(az storage account show \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "id" -o tsv)"/blobServices/default"