targetScope = 'resourceGroup'

param aksClusterName string = 'aks-secure-cluster'
param location string = resourceGroup().location
param nodeCount int = 3
param nodeVmSize string = 'Standard_D2s_v3'
param kubernetesVersion string = '1.32.0'

resource aks 'Microsoft.ContainerService/managedClusters@2023-10-01' = {
  name: aksClusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: 'aks-${uniqueString(resourceGroup().id)}'
    kubernetesVersion: kubernetesVersion
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: nodeCount
        vmSize: nodeVmSize
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
    addonProfiles: {
      azurepolicy: {
        enabled: true
      }
    }
    networkProfile: {
      networkPlugin: 'azure'
    }
  }
}
