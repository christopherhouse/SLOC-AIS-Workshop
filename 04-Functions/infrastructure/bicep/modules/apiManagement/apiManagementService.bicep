param serviceName string
param location string
param skuName string
param skuCapacity int
param publisherEmail string
param publisherName string
param tags object
param userAssignedManagedIdentityResourceId string
resource apiManagementService 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: serviceName
  location: location
  tags: tags
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityResourceId}': {}
    }
  }
  sku: {
    name: skuName
    capacity: skuCapacity
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}

output name string = apiManagementService.name
