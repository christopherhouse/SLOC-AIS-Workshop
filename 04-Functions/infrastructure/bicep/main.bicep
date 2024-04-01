param deploymentDate string = utcNow()
param workloadPrefix string
param workloadName string
param environmentName string
param location string
param apimPublisherEmail string
param apimPublisherName string
param apimSkuCapacity int
@allowed([
  'Developer'
  'Standard'
  'Premium'
  'Basic'
  'Consumption'
])
param apimSkuName string
@allowed([
  'Basic'
  'Standard'
  'Premium'
])
param serviceBusSku string
param maxTopicSize int
param ordersTopicName string
param ordersTopicSubscriptionName string
param ordersForApprovalSubscriptionName string
param ordersTopicSqlFilter string
param ordersForApprovalSqlFilter string
param fulfillmentTopicName string
param keyVaultAdminIdentities array = []
param cosmosDbDatabaseName string
param ordersCosmosContainerName string
param orderContainerPartitionKey string
param fulfillmentTopicSubscriptionName string
param shipmentTopicName string
param shipmentTopicSubscriptionName string
param maxWorkDelayInMilliseconds int = 100
param cosmosLeaseContainerName string
param statusNotificationTopicName string
param statusNotificationTopicSubscriptionName string
param webHookNotificationUrl string
param sendApprovalTopicName string
param allCreditApprovalsSubscription string
param pipelineServicePrincipalId string

param buildId int = 0

var maxContainerRUs = 1000
var defaultTopicSqlFilter = '1=1'
var baseName = '${workloadPrefix}-${workloadName}-${environmentName}'
var baseNameNoDashes = replace(baseName, '-', '')

// Resource Names
var serviceBusNamespaceName = '${baseName}-sbns'
var logAnalyticsWorkspaceName = '${baseName}-laws'
var functionsAppInsightsName = '${baseName}-func-ai'
var keyVaultName = '${baseName}-kv'
var storageAccountName = length('${baseNameNoDashes}sa') > 24 ? toLower(substring('${baseNameNoDashes}sa', 0, 24)) : toLower('${baseNameNoDashes}sa')
var functionAppServicePlanName = '${baseName}-func-asp'
var functionAppName = '${baseName}-func'
var functionAppUserAssignedIdentityName = '${functionAppName}-uami'
var cosmosDbAccountName = '${baseName}-cdb-acct'
var loadTestingName = '${baseName}-alt'
var apimName = '${baseName}-apim'
var apimUserAssignedIdentityName = '${apimName}-uami'

// Deployment Names
var serviceBusDeploymentName = '${serviceBusNamespaceName}-${buildId}'
var ordersTopicDeploymentName= '${ordersTopicName}-${buildId}'
var fulfillmentTopicDeploymentName = '${fulfillmentTopicName}-${buildId}'
var logAnalyticsDeploymentName = '${logAnalyticsWorkspaceName}-${buildId}'
var functionsAppInsightsDeploymentName = '${functionsAppInsightsName}-${buildId}'
var keyVaultDeploymentName = '${keyVaultName}-${buildId}'
var storageAccountDeploymentName = '${storageAccountName}-${buildId}'
var functionAppServicePlanDeploymentName = '${functionAppServicePlanName}-${buildId}'
var functionAppDeploymentName = '${functionAppName}-${buildId}'
var functionAppUserAssignedIdentityDeploymentName = '${functionAppUserAssignedIdentityName}-${buildId}'
var secretsDeploymentName = 'secrets-${buildId}'
var cosmosDbAccountDeploymentName = '${cosmosDbAccountName}-${buildId}'
var cosmosDbDatabaseDeploymentName = '${cosmosDbDatabaseName}-${buildId}'
var orderContainerDeploymentName = '${ordersCosmosContainerName}-${buildId}'
var shipmentTopicDeploymentName = '${shipmentTopicName}-${buildId}'
var leasesContainerDeploymentName = '${cosmosLeaseContainerName}-${buildId}'
var statusNotificationTopicDeploymentName = '${statusNotificationTopicName}-${buildId}'
var statusNotificationTopicSubscriptionDeploymentName = '${statusNotificationTopicSubscriptionName}-${buildId}'
var loadTestingDeploymentName = '${loadTestingName}-${buildId}'
var sendApprovalTopicDeploymentName = '${sendApprovalTopicName}-${buildId}'
var allCreditApprovalsSubscriptionDeploymentName = '${allCreditApprovalsSubscription}-${buildId}'
var apimDeploymentName = '${apimName}-${buildId}'
var apimUserAssignedIdentityDeploymentName = '${apimUserAssignedIdentityName}-${buildId}'

var tags = {
  BuildId: buildId
  Environment: environmentName
  Workload: workloadName
  LastDeploymentDate: deploymentDate
}

module apimUami './modules/managedIdentity/userAssignedManagedIdentity.bicep' = {
  name: apimUserAssignedIdentityDeploymentName
  params: {
    managedIdentityName: apimUserAssignedIdentityName
    location: location
    tags: tags
  }
}
module apim './modules/apiManagement/apiManagementService.bicep' = {
  name: apimDeploymentName
  params: {
    serviceName: apimName
    location: location
    tags: tags
    publisherEmail: apimPublisherEmail
    publisherName: apimPublisherName
    skuCapacity: apimSkuCapacity
    skuName: apimSkuName
    userAssignedManagedIdentityResourceId: apimUami.outputs.id
  }
}

module sbNs './modules/serviceBus/serviceBusNamespace.bicep' = {
  name: serviceBusDeploymentName
  params: {
    serviceBusNamespaceName: serviceBusNamespaceName
    location: location
    serviceBusSku: serviceBusSku
    tags: tags
  }
}

module autoApprovedOrdersTopic './modules/serviceBus/serviceBusTopic.bicep' = {
  name: ordersTopicDeploymentName
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: ordersTopicName
    maxTopicSize: maxTopicSize
  }
}

module ordersSubscription './modules/serviceBus/serviceBusTopicSubscription.bicep' = {
  name: '${ordersTopicSubscriptionName}-${buildId}'
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: autoApprovedOrdersTopic.outputs.name
    subscriptionName: ordersTopicSubscriptionName
    sqlFilterExpression: ordersTopicSqlFilter
    forwardToTopicName: fulfillmentTopic.outputs.name
  }
}

module ordersForApprovalSubscription './modules/serviceBus/serviceBusTopicSubscription.bicep' = {
  name: '${ordersForApprovalSubscriptionName}-subscription-${buildId}'
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: autoApprovedOrdersTopic.outputs.name
    subscriptionName: ordersForApprovalSubscriptionName
    sqlFilterExpression: ordersForApprovalSqlFilter
  }
}

module fulfillmentTopic './modules/serviceBus/serviceBusTopic.bicep' = {
  name: fulfillmentTopicDeploymentName
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: fulfillmentTopicName
    maxTopicSize: maxTopicSize
  }
}

module fulfillmentSubscription './modules/serviceBus/serviceBusTopicSubscription.bicep' = {
  name: '${fulfillmentTopicName}-subscription-${buildId}'
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: fulfillmentTopic.outputs.name
    subscriptionName: fulfillmentTopicSubscriptionName
    sqlFilterExpression: defaultTopicSqlFilter
  }
}

module laws './modules/observability/logAnalyticsWorkspace.bicep' = {
  name: logAnalyticsDeploymentName
  params: {
    logAnalyticsWorkspaceName: logAnalyticsWorkspaceName
    location: location
    tags: tags
  }
}

module funcAppInsights './modules/observability/applicationInsights.bicep' = {
  name: functionsAppInsightsDeploymentName
  params: {
    appInsightsName: functionsAppInsightsName
    location: location
    logAnalyticsWorkspaceId: laws.outputs.id
    tags: tags
  }
}

module kv './modules/keyVault/keyVault.bicep' = {
  name: keyVaultDeploymentName
  params: {
    keyVaultName: keyVaultName
    location: location
    adminIdentities: keyVaultAdminIdentities
    applicationIdentities: [ funcUami.outputs.principalId, apimUami.outputs.principalId ]
    pipelineServicePrincipalId: pipelineServicePrincipalId
    tags: tags
  }
}

module funcStorage './modules/storage/storageAccount.bicep' = {
  name: storageAccountDeploymentName
  params: {
    storageAccountName: storageAccountName
    location: location
    tags: tags
  }
}

module funcUami './modules/managedIdentity/userAssignedManagedIdentity.bicep' = {
  name: functionAppUserAssignedIdentityDeploymentName
  params: {
    managedIdentityName: functionAppUserAssignedIdentityName
    location: location
    tags: tags
  }
}

module funcAsp './modules/functions/appServicePlan.bicep' = {
  name: functionAppServicePlanDeploymentName
  params: {
    appServicePlanName: functionAppServicePlanName
    location: location
    tags: tags
  }
}

module funcApp './modules/functions/functionApp.bicep' = {
  name: functionAppDeploymentName
  params: {
    location: location
    appServicePlanId: funcAsp.outputs.name
    functionAppName: functionAppName
    managedIdentityResourceId: funcUami.outputs.id
    storageAccountName: funcStorage.outputs.name
    appInsightsInstrumentationkeySecretUri: secrets.outputs.appInsightsInstrumentationkeyUri
    appInsightsConnectionStringSecretUri: secrets.outputs.appInsightsConnectionStringUri
    cosmosDbConnectionStringSecretUri: secrets.outputs.cosmosDbConnectionStringUri
    serviceBusConnectionStringSecretUri: secrets.outputs.serviceBusConnectionStringUri
    ordersTopicName: ordersTopicName
    cosmosDbName: cosmosDb.outputs.name
    ordersContainerName: ordersCosmosContainerName
    fulfillmentTopic: fulfillmentTopic.outputs.name
    approvedOrdersSubscription: fulfillmentTopicSubscriptionName
    maxWorkDelayInMilliseconds: maxWorkDelayInMilliseconds
    cosmosLeaseContainerName: cosmosLeaseContainerName
    webHookNotificationUrl: webHookNotificationUrl
    functionAppKeyUri: secrets.outputs.functionAppKeyUri
    tags: tags
    ordersForApprovalSubscription: ordersForApprovalSubscription.outputs.name
    shipmentTopicName: shipmentTopic.outputs.name
    shipmentTopicSubscriptionName: shipmentSubscription.outputs.name
    statusNotificationTopic: statusTopic.outputs.name
    allStatusNotificationSubscription: statusSub.outputs.name
    sendApprovalTopic: sendApprovalEventTopic.outputs.name
    allCreditApprovalsSubscription: sendApprovalAllMessages.outputs.name
  }
}

module secrets './modules/keyVault/secrets.bicep' = {
  name: secretsDeploymentName
  params: {
    appInsightsName: funcAppInsights.outputs.name
    buildId: buildId
    keyVaultName: kv.outputs.name
    cosmosDbAccountName: cosmosAccount.outputs.name
    serviceBusNamespaceId: sbNs.outputs.id
  }
}

module cosmosAccount './modules/cosmos/cosmosAccount.bicep' = {
  name: cosmosDbAccountDeploymentName
  params: {
    location: location
    cosmosAccountName: cosmosDbAccountName
  }
}

module cosmosDb './modules/cosmos//cosmosDbDatabase.bicep' = {
  name: cosmosDbDatabaseDeploymentName
  params: {
    cosmosAccountName: cosmosAccount.outputs.name
    databaseName: cosmosDbDatabaseName
  }
}

module ordersContainer './modules/cosmos/cosmosContainer.bicep' = {
  name: orderContainerDeploymentName
  params: {
    containerName: ordersCosmosContainerName
    cosmosAccountName: cosmosAccount.outputs.name
    databaseName: cosmosDb.outputs.name
    partitionKey: orderContainerPartitionKey
    maxRUs: maxContainerRUs
  }
}

module shipmentTopic './modules/serviceBus/serviceBusTopic.bicep' = {
  name: shipmentTopicDeploymentName
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: shipmentTopicName
    maxTopicSize: maxTopicSize
  }
}

module shipmentSubscription './modules/serviceBus/serviceBusTopicSubscription.bicep' = {
  name: '${shipmentTopicName}-subscription-${buildId}'
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: shipmentTopic.outputs.name
    subscriptionName: shipmentTopicSubscriptionName
    sqlFilterExpression: defaultTopicSqlFilter
  }
}

module leases './modules/cosmos/cosmosContainer.bicep' = {
  name: leasesContainerDeploymentName
  params: {
    containerName: cosmosLeaseContainerName
    cosmosAccountName: cosmosAccount.outputs.name
    databaseName: cosmosDb.outputs.name
    partitionKey: '/id'
    maxRUs: maxContainerRUs
  }
}

module statusTopic './modules/serviceBus/serviceBusTopic.bicep' = {
  name: statusNotificationTopicDeploymentName
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: statusNotificationTopicName
    maxTopicSize: maxTopicSize
  }
}

module statusSub './modules/serviceBus/serviceBusTopicSubscription.bicep' = {
  name: statusNotificationTopicSubscriptionDeploymentName
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    subscriptionName: statusNotificationTopicSubscriptionName
    topicName: statusTopic.outputs.name
    sqlFilterExpression: defaultTopicSqlFilter
  }
}

// This thing is failing to deploy for some reason so removing for now
// module alt './modules/azureLoadTesting/azureLoadTesting.bicep' = {
//   name: loadTestingDeploymentName
//   params: {
//     loadTestsName: loadTestingName
//     location: location
//   }
// }

module sendApprovalEventTopic './modules/serviceBus/serviceBusTopic.bicep' = {
  name: sendApprovalTopicDeploymentName
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    topicName: sendApprovalTopicName
    maxTopicSize: maxTopicSize
  }
}

module sendApprovalAllMessages './modules/serviceBus/serviceBusTopicSubscription.bicep' = {
  name: allCreditApprovalsSubscriptionDeploymentName
  params: {
    serviceBusNamespaceName: sbNs.outputs.name
    subscriptionName: allCreditApprovalsSubscription
    topicName: sendApprovalEventTopic.outputs.name
    sqlFilterExpression: defaultTopicSqlFilter
  }
}

output functionAppName string = funcApp.outputs.name
output keyVaultName string = kv.outputs.name
output functionAppHostName string = funcApp.outputs.functionAppHostName
output functionAppResourceId string = funcApp.outputs.id
output functionAppKeyKeyVaultSecretUri string = secrets.outputs.functionAppKeyUri
output apimUserAssignedManagedIdentityClientId string = apimUami.outputs.clientId
output apimName string = apim.outputs.name
