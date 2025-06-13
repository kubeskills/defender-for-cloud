# set variables
RESOURCE_GROUP_NAME="secure-rg"
LOCATION="eastus"
LOGICAPP_NAME="defender-incident-playbook"
AUTOMATION_RULE_NAME="defender-alert-auto-response"
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
NSG_NAME="demo-nsg"

# check

# deploy the bicep template
az deployment group create \
  --resource-group $RESOURCE_GROUP_NAME \
  --template-file logicapp-defender-automation.bicep

# get the logic app ID
LOGICAPP_ID=$(az resource show \
  --name "$LOGICAPP_NAME" \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --resource-type "Microsoft.Logic/workflows" \
  --query id --output tsv)


# get the callback url of the logic app HTTP trigger
az rest --method post \
  --uri "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Logic/workflows/$LOGICAPP_NAME/triggers/manual/listCallbackUrl?api-version=2016-06-01"


# store the value in a variable named TRIGGER_URI
TRIGGER_URI="https://prod-01.eastus.logic.azure.com:443/workflows/1376ec7b2a7b4539a3b5a71fff10abb3/triggers/manual/paths/invoke?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=kL3KkjSCCJ5XtLPejsJBvnmRJ2YQk8rCQz_Hcr05bug"

# create the automation rule
az rest --method put \
  --uri "https://management.azure.com/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME/providers/Microsoft.Security/automations/$AUTOMATION_RULE_NAME?api-version=2023-12-01-preview" \
  --body "{
    \"location\": \"$LOCATION\",
    \"properties\": {
      \"description\": \"Auto-response to Defender alerts\",
      \"scopes\": [
        {
          \"description\": \"Entire subscription\",
          \"scopePath\": \"/subscriptions/$SUBSCRIPTION_ID\"
        }
      ],
      \"sources\": [
        {
          \"eventSource\": \"Alerts\",
          \"ruleSets\": []
        }
      ],
      \"actions\": [
        {
          \"actionType\": \"LogicApp\",
          \"logicAppResourceId\": \"$LOGICAPP_ID\",
          \"uri\": \"$TRIGGER_URI\"
        }
      ],
      \"isEnabled\": true
    }
  }"

# Enable System-Assigned Identity for logic app
az resource update \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --name "$LOGICAPP_NAME" \
  --resource-type "Microsoft.Logic/workflows" \
  --set identity.type="SystemAssigned"


# get the logic app principal ID
LOGICAPP_PRINCIPAL_ID=$(az resource show \
  --resource-group "$RESOURCE_GROUP_NAME" \
  --name "$LOGICAPP_NAME" \
  --resource-type "Microsoft.Logic/workflows" \
  --query "identity.principalId" \
  --output tsv)


# Give the Logic App permission to modify NSGs
az role assignment create \
  --assignee $LOGICAPP_PRINCIPAL_ID \
  --role "Network Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID"


# In the Logic App Designer, add an action:
# Select HTTP
# Enter the following URI
https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<resource-group-name>/providers/Microsoft.Network/networkSecurityGroups/<nsg-name>/securityRules/DenyAllInbound?api-version=2023-05-01
# Enter PUT as the method
# Enter "Content-Type: application/json" for the headers
# paste in the followingfor the body
{
  "properties": {
    "protocol": "*",
    "sourcePortRange": "*",
    "destinationPortRange": "*",
    "sourceAddressPrefix": "*",
    "destinationAddressPrefix": "*",
    "access": "Deny",
    "priority": 100,
    "direction": "Inbound"
  }
}



# You can use Logic App parameters from the alert (e.g., ResourceId) to extract the NSG name if the alert contains it, or associate an NSG to the resource manually.
