
@description('Intentionally insecure resources for Snyk IaC testing')
param location string = resourceGroup().location

// VULNERABILITY 1: Storage account allows public blob access
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'snyktest${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    allowBlobPublicAccess: true
    supportsHttpsTrafficOnly: false
    minimumTlsVersion: 'TLS1_0'
    allowSharedKeyAccess: true
  }
}

// VULNERABILITY 2: NSG allows inbound traffic from any IPv4 address
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'snyk-test-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowAllInbound'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
