# resource group
export RESOURCE_GROUP_NAME=secure-rg

# enable network watcher
az network watcher configure --locations eastus --enabled true --resource-group $RESOURCE_GROUP_NAME

# get the log analytics workspace name
export WORKSPACE_NAME=$(az monitor log-analytics workspace list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[].name" \
  --output table \
  -o tsv)

# get the log analytics workspace ID (needed for diagnostic settings)
export WORKSPACE_RESOURCE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP_NAME \
  --workspace-name $WORKSPACE_NAME \
  --query id \
  -o tsv)



# create a new NSG
az network nsg create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name demo-nsg \
  --location eastus


# get vnet name
VNET_NAME=$(az network vnet list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)

# associate the NSG with a subnet
az network vnet subnet update \
  --resource-group $RESOURCE_GROUP_NAME \
  --vnet-name $VNET_NAME \
  --name default \
  --network-security-group demo-nsg


NSG_NAME=$(az network nsg list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[].name" \
  --output tsv)



# DEPRECATED: enable network watcher in your region
# az network watcher configure \
#   --locations eastus \
#   --resource-group $RESOURCE_GROUP_NAME \
#   --enabled true

# Enable diagnostic settings for NSG to send rule counter logs to Log Analytics
az monitor diagnostic-settings create \
  --name demo-nsg-diag \
  --workspace $WORKSPACE_NAME \
  --resource "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Network/networkSecurityGroups/$NSG_NAME" \
  --workspace $WORKSPACE_RESOURCE_ID \
  --logs '[{"category": "NetworkSecurityGroupRuleCounter", "enabled": true}]'



# DEPRECATED: enable flow logs
# az network watcher flow-log create \
#   --name demo-flow-log \
#   --location eastus \
#   --resource-group $RESOURCE_GROUP_NAME \
#   --nsg $NSG_NAME \
#   --storage-account $STORAGE_ACCOUNT_NAME \
#   --workspace $WORKSPACE_ID \
#   --enabled true \
#   --retention 7


# Enable diagnostic settings for NSG to send rule counter logs to Log Analytics
az monitor diagnostic-settings create \
  --name demo-nsg-diag \
  --resource "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Network/networkSecurityGroups/$NSG_NAME" \
  --workspace $WORKSPACE_RESOURCE_ID \
  --logs '[{"category": "NetworkSecurityGroupRuleCounter", "enabled": true}]'


# get the workspace customer ID (not the full resource ID)
export WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP_NAME \
  --workspace-name $WORKSPACE_NAME \
  --query customerId \
  --output tsv)

# Confirm Diagnostic Settings on NSG
az monitor diagnostic-settings list \
  --resource "/subscriptions/$(az account show --query id -o tsv)/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Network/networkSecurityGroups/$NSG_NAME"


# check available tables via supported KQL
# AzureDiagnostics, NetworkSecurityGroupRuleCounter_CL, or AzureNetworkAnalytics_CL should be active.
# NOTE: this may take up to 15 minutes
az monitor log-analytics query \
  --workspace $WORKSPACE_ID \
  --analytics-query "union withsource=SourceTable * | summarize Count = count() by SourceTable | top 20 by Count desc" \
  --output table


# get VM name
VM_NAME=$(az vm list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)

# access the VM and generate some inbound/outbound traffic
az vm run-command invoke \
  --command-id RunShellScript \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --scripts "ping -c 4 8.8.8.8"

# confirm that logs are flowing into Log Analytics
az monitor log-analytics query \
  --workspace $WORKSPACE_ID \
  --analytics-query "AzureNetworkAnalytics_CL | take 5" \
  --output table
