# creat resource group
az group create --name secure-rg --location eastus

# create password from random string (OPTIONAL)
export USER_PASS=$(openssl rand -base64 12)

# Deploy the Virtual Machine
az deployment group create \
  --name vmDeployment \
  --resource-group secure-rg \
  --template-file ./vm.bicep \
  --parameters adminUsername='azureuser' adminPassword=$USER_PASS

# Deploy the Storage Account
# Storage account name must be between 3 and 24 characters
az deployment group create \
  --name storageDeployment \
  --resource-group secure-rg \
  --template-file ./storage.bicep
 
 

# resource group
export RESOURCE_GROUP_NAME=secure-rg

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

# manually create the EICAR test file
az vm run-command invoke \
  --command-id RunShellScript \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --scripts "echo 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*' > /tmp/eicar.txt"

# simulate SQL injection tool usage
curl -A "sqlmap/1.0" http://example.com

# simulate execution of an unexpected script
echo "echo malicious command" > /tmp/bad.sh && chmod +x /tmp/bad.sh && /tmp/bad.sh


# download a suspiciuous file
wget http://testmyids.com -O /tmp/testfile

# clear logs
sudo rm -rf /var/log/*

# write to sensitive system path
sudo echo "test" > /etc/cron.d/testjob

# trigger many repeated outbound connections
for i in {1..50}; do curl http://example.com; done

az vm run-command invoke \
  --command-id RunShellScript \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --scripts "mdatp health"
  
az vm run-command invoke \
  --command-id RunShellScript \
  --name $VM_NAME \
  --resource-group $RESOURCE_GROUP_NAME \
  --scripts "sudo cat /etc/opt/microsoft/mdatp/managed/mdatp_managed.json"