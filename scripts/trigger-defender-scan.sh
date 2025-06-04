# get your subscription ID
export SUB_ID=$(az account show --query id --output tsv)

# trigger a scan with defender for cloud
az policy state trigger-scan --subscription $SUB_ID