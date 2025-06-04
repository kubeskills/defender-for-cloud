targetScope = 'subscription'

resource defenderForContainers 'Microsoft.Security/pricings@2022-03-01' = {
  name: 'Containers'
  properties: {
    pricingTier: 'Standard'
  }
}
