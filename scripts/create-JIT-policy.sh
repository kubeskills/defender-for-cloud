# resource group
RESOURCE_GROUP_NAME=secure-rg

# get VM name
VM_NAME=$(az vm list \
  --resource-group $RESOURCE_GROUP_NAME \
  --query "[0].name" \
  --output tsv)

# get VM ID
VM_ID=$(az vm show \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --query id \
  -o tsv)

# create JIT policy for VM
az security jit-policy create \
  --location eastus \
  --name default \
  --resource-id $VM_ID \
  --jit-policy '{
    "virtualMachines": [
      {
        "id": "'$VM_ID'",
        "ports": [
          {
            "number": 22,
            "protocol": "*",
            "allowedSourceAddressPrefix": "*",
            "maxRequestAccessDuration": "PT3H"
          }
        ]
      }
    ]
  }'

# verify that the policy is applied
az security jit-policy list --query "[?virtualMachines[?id=='$VM_ID']]" -o table

