param location string = resourceGroup().location
param logicAppName string = 'defender-incident-playbook'

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      'contentVersion': '1.0.0.0'
      'triggers': {
        'manual': {
          'type': 'Request'
          'kind': 'Http'
          'inputs': {
            'schema': {}
          }
        }
      }
      'actions': {}
      'outputs': {}
    }
    parameters: {}
  }
}
