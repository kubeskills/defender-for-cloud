# resource group
export RESOURCE_GROUP_NAME=secure-rg

# create azure firewall
az network firewall create \
  --name firewallForDefender \
  --resource-group $RESOURCE_GROUP_NAME \
  --location eastus

# get firewall ID
FIREWALL_ID=$(az network firewall show \
  --name firewallForDefender \
  --resource-group $RESOURCE_GROUP_NAME \
  --query id --output tsv)

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
  
az monitor diagnostic-settings create \
  --name "FirewallDiagnostics" \
  --resource $FIREWALL_ID \
  --workspace $WORKSPACE_RESOURCE_ID \
  --logs '[{"category": "AzureFirewallApplicationRule", "enabled": true}, {"category": "AzureFirewallNetworkRule", "enabled": true}, {"category": "AzureFirewallDnsProxy", "enabled": true}]' \
  --metrics '[{"category": "AllMetrics", "enabled": true}]'


