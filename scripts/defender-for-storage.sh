#!/bin/bash

# enable defender for storage
az security pricing create \
  --name "StorageAccounts" \
  --tier "Standard"


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

# Enable diagnostics on the blob service based on the blog service ID
az monitor diagnostic-settings create \
  --name "blobDiagnostics" \
  --resource $BLOB_SERVICE_ID \
  --workspace $WORKSPACE_ID \
  --logs '[{"category": "StorageRead", "enabled": true}, {"category": "StorageWrite", "enabled": true}, {"category": "StorageDelete", "enabled": true}]'







# enable logging
# az monitor diagnostic-settings create \
#   --name "enableStorageDiagnostics" \
#   --resource $(az storage account show \
#      --name $STORAGE_ACCOUNT_NAME \
#      --resource-group $RESOURCE_GROUP_NAME \
#      --query id -o tsv) \
#   --logs '[{"category": "StorageRead", "enabled": true},{"category": "StorageWrite", "enabled": true},{"category": "StorageDelete", "enabled": true}]' \
#   --workspace $WORKSPACE_ID




# get storage account key
export STORAGE_KEY=$(az storage account keys list \
  --account-name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].value" -o tsv)


# list storage containers
az storage container list \
  --account-name $STORAGE_ACCOUNT_NAME \
  --account-key $STORAGE_KEY \
  --query "[].{name:name}" -o table


export CONTAINER_NAME=<your-container-name>

# create a temp directory and generate 20 small text files
mkdir -p ./test-files
for i in {1..20}; do
  echo "Test content $i" > ./test-files/file$i.txt
done

# Upload files to the storage container
for i in {1..20}; do
  az storage blob upload \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --account-key "$STORAGE_KEY" \
    --container-name "$CONTAINER_NAME" \
    --name "file$i.txt" \
    --file "./test-files/file$i.txt" \
    --output none
  echo "Uploaded file$i.txt"
done

# for i in {1..20}; do
#   az storage blob upload \
#     --account-name "$STORAGE_ACCOUNT_NAME" \
#     --account-key "$STORAGE_KEY" \
#     --container-name "$CONTAINER_NAME" \
#     --name "file$i.txt" \
#     --file "./test-files/file$i.txt" \
#     --auth-mode key \
#     --output none
#   echo "Uploaded file$i.txt"
# done



# you will need the role "Storage Blob Data Contributor" to download files
export USER_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)

az role assignment create \
  --assignee $USER_OBJECT_ID \
  --role "Storage Blob Data Contributor" \
  --scope $(az storage account show \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --query id -o tsv)



# after uploading 20+ files to storage container, run this to download all files rapidly
for i in {1..20}; do
  az storage blob download \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --container-name "$CONTAINER_NAME" \
    --name "file$i.txt" \
    --file "./file$i.txt" \
    --auth-mode login
done

# access one of the files anonymously via wget
wget "https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$CONTAINER_NAME/file1.txt"

# access the files anonymously via wget
for i in {1..20}; do
  wget "https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$CONTAINER_NAME/file$i.txt" -O /dev/null
done
