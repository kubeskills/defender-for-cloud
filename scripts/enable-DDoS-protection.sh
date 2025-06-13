# resource group
export RESOURCE_GROUP_NAME=secure-rg

##################################################################
# BUYER BEWARE, ENABLING THIS SERVICE WILL COST $2,944 PER MONTH #
##################################################################

# Create the DDoS Protection Plan
az network ddos-protection create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name ddosForDefender \
  --location eastus

# get vnet name
VNET_NAME=$(az network vnet list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)

# get subscription ID
export SUB_ID=$(az account show --query id --output tsv)

# Associate plan with a VNET
az network vnet update \
  --name $VNET_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --ddos-protection-plan /subscriptions/$SUB_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Network/ddosProtectionPlans/ddosForDefender


# verify it's active
az network vnet show \
  --name $VNET_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "ddosProtectionPlan.id"
  

# remove DDoS protection
az network vnet update \
  --name $VNET_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --remove ddosProtectionPlan

##