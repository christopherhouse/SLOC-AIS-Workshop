# 🚀 Azure Bicep Deployment (02-Bicep)

This directory contains a Bicep template for deploying Azure resources. Bicep is a declarative language for describing and deploying Azure resources.

## 📁 Directory Structure

- `main.bicep`: This is the main Bicep template file.
- `main.parameters.json`: This file contains the parameters for the Bicep template.
- `deploy.ps1`: This is a PowerShell script for deploying the Bicep template.

## 🚧 Bicep Template

The `main.bicep` file is a Bicep template that describes the Azure resources to be deployed. It uses a declarative syntax, which means you describe your intent—what you want to deploy—and Bicep figures out how to make it happen.

## 📚 Parameters

The `main.parameters.json` file contains the parameters for the Bicep template. These parameters are values that you can pass into your template at deployment time. This allows you to customize your deployments.

The parameters defined on the bicep template include:

| Parameter | Type | Default Value | Allowed Values |
| --- | --- | --- | --- |
| `deploymentDate` | string | `utcNow()` | - |
| `workloadPrefix` | string | - | - |
| `workloadName` | string | - | - |
| `environmentName` | string | - | - |
| `location` | string | - | - |
| `apimPublisherEmail` | string | - | - |
| `apimPublisherName` | string | - | - |
| `apimSkuCapacity` | int | - | - |
| `apimSkuName` | string | - | 'Developer', 'Standard', 'Premium', 'Basic', 'Consumption' |
| `serviceBusSku` | string | - | 'Basic', 'Standard', 'Premium' |
| `maxTopicSize` | int | - | - |
| `ordersTopicName` | string | - | - |
| `ordersTopicSubscriptionName` | string | - | - |
| `ordersForApprovalSubscriptionName` | string | - | - |
| `ordersTopicSqlFilter` | string | - | - |
| `ordersForApprovalSqlFilter` | string | - | - |
| `fulfillmentTopicName` | string | - | - |
| `keyVaultAdminIdentities` | array | `[]` | - |
| `cosmosDbDatabaseName` | string | - | - |
| `ordersCosmosContainerName` | string | - | - |
| `orderContainerPartitionKey` | string | - | - |
| `fulfillmentTopicSubscriptionName` | string | - | - |
| `shipmentTopicName` | string | - | - |
| `shipmentTopicSubscriptionName` | string | - | - |
| `maxWorkDelayInMilliseconds` | int | `100` | - |
| `cosmosLeaseContainerName` | string | - | - |
| `statusNotificationTopicName` | string | - | - |
| `statusNotificationTopicSubscriptionName` | string | - | - |
| `webHookNotificationUrl` | string | - | - |
| `sendApprovalTopicName` | string | - | - |
| `allCreditApprovalsSubscription` | string | - | - |
| `pipelineServicePrincipalId` | string | - | - |
| `buildId` | int | `0` | - |

## 🚀 Deployment

To deploy the Bicep template, you can use the `deploy.ps1` PowerShell script. Here is the command:

```powershell
./deploy.ps1 -ResourceGroupName <ResourceGroupName>
```
