@description('The name of the web app resource to create.  Note a unique string will be appended to the name')
param webAppName string

@description('The SKU of the app service plan')
@allowed(['S1', 'B1', 'F1'])
param sku string

@description('The runtime to be used on the web app')
param linuxFxVersion string

@description('The Azure region where resources will be deployed.  Defaults to the resource group location.')
param location string = resourceGroup().location

@description('The URL of the repository to deploy the web app from')
param repositoryUrl string = 'https://github.com/Azure-Samples/nodejs-docs-hello-world'

@description('The branch of the repository to deploy the web app from')
param branch string

var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var webSiteName = toLower('${webAppName}-${uniqueString(resourceGroup().id)}')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: sku
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  name: 'web'
  parent: appService
  properties: {
    repoUrl: repositoryUrl
    branch: branch
    isManualIntegration: true
  }
}
