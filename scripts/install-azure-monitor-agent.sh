
# resource group
export RESOURCE_GROUP_NAME=secure-rg

# get VM name
VM_NAME=$(az vm list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)
 
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
  
export WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP_NAME \
  --workspace-name $WORKSPACE_NAME \
  --query customerId \
  --output tsv)





# Create a Data Collection Rule (DCR)
az monitor data-collection rule create \
  --resource-group $RESOURCE_GROUP_NAME \
  --location "eastus" \
  --name "linux-monitoring-dcr" \
  --rule-file "dcr.json"

# get sub ID
export SUB_ID=$(az account show --query id --output tsv)


# Associate the DCR with Your VM
az monitor data-collection rule association create \
  --name "${VM_NAME}-association" \
  --rule-id "/subscriptions/$SUB_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Insights/dataCollectionRules/linux-monitoring-dcr" \
  --resource "subscriptions/$SUB_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Compute/virtualMachines/$VM_NAME"
  
  

