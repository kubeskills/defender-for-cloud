RESOURCE_GROUP_NAME="secure-rg"

# get storage account name
STORAGE_ACCOUNT_NAME=$(az storage account list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)

# get storage account ID
STORAGE_ACCOUNT_ID=$(az storage account show \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query id --output tsv)

# get vnet name
VNET_NAME=$(az network vnet list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)

# get subnet name
SUBNET_NAME=$(az network vnet subnet list \
  --resource-group $RESOURCE_GROUP_NAME \
  --vnet-name $VNET_NAME \
  --query "[0].name" \
  --output tsv)

# get subnet ID
SUBNET_ID=$(az network vnet subnet show \
  --name $SUBNET_NAME \
  --vnet-name $VNET_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query id --output tsv)

LOCATION="eastus"
PRIVATE_ENDPOINT_NAME="myPrivateEndpoint"

# create private endpoint
az network private-endpoint create \
  --name $PRIVATE_ENDPOINT_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --vnet-name $VNET_NAME \
  --subnet $SUBNET_NAME \
  --private-connection-resource-id $STORAGE_ACCOUNT_ID \
  --group-id "blob" \
  --connection-name "${PRIVATE_ENDPOINT_NAME}Connection" \
  --location $LOCATION


# if you are using Azure-managed private DNS zones
PRIVATE_DNS_ZONE_GROUP="myPrivateDnsZoneGroup"

az network private-dns zone-group create \
  --resource-group $RESOURCE_GROUP \
  --endpoint-name $PRIVATE_ENDPOINT_NAME \
  --name $PRIVATE_DNS_ZONE_GROUP \
  --private-dns-zone "privatelink.blob.core.windows.net" \
  --zone-name "privatelink.blob.core.windows.net"
