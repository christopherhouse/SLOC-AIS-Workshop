# 🚀 Azure Functions Order Fulfillment Demo (04-Functions)

This directory contains a Visual Studio project for an Azure Functions application, a Bicep template for deploying Azure resources, and a PowerShell script for deploying the Bicep template.

## 📁 Directory Structure

- 📂 `deploy`: This directory contains artifacts used to deploy the solution.
  - 📂 `scripts`: This folder contains scripts used to deploy the Azure infrastructure.
- 📂 `FunctionsOrderFulfillmentDemo`: This contains the source code for the C# order fulfillment Function App
- 📂 `infrastructure`: This directory contains infrastructure as code resources
  - 📂 `bicep`: This directory contains Bicep templates and modules used to provision Azure resources required by the solution.
      - 📂 `parameters`: This directory contains parameters related to Azure deployments.

## 🛠️ Visual Studio Project

The Visual Studio project is located in the `src` directory. It contains the Azure Functions application, which includes a function for checking the status of an order.

## 🚧 Bicep Template

The `main.bicep` file is located in the `infrastructure\bicep` directory. It is a Bicep template that describes the Azure resources to be deployed. It uses a declarative syntax, which means you describe your intent—what you want to deploy—and Bicep figures out how to make it happen.

## 📚 Parameters

The `main.dev.parameters.json` file is also located in the `infrastructure\bicep\parameters` directory. It contains the parameters for the Bicep template. These parameters are values that you can pass into your template at deployment time. This allows you to customize your deployments.

The parameters defined on the bicep template include:

| Parameter Name | Data Type | Description | Default Value | Allowed Values |
| --- | --- | --- | --- | --- |
| `workloadPrefix` | string | - | - | - |
| `workloadName` | string | - | - | - |
| `environmentName` | string | - | - | - |
| `location` | string | - | - | - |
| `apimPublisherEmail` | string | - | - | - |
| `apimPublisherName` | string | - | - | - |
| `apimSkuCapacity` | int | - | - | - |
| `apimSkuName` | string | - | - | 'Developer', 'Standard', 'Premium', 'Basic', 'Consumption' |
| `serviceBusSku` | string | - | - | 'Basic', 'Standard', 'Premium' |
| `maxTopicSize` | int | - | - | - |
| `ordersTopicName` | string | - | - | - |
| `ordersTopicSubscriptionName` | string | - | - | - |
| `ordersForApprovalSubscriptionName` | string | - | - | - |
| `ordersTopicSqlFilter` | string | - | - | - |
| `ordersForApprovalSqlFilter` | string | - | - | - |
| `fulfillmentTopicName` | string | - | - | - |
| `keyVaultAdminIdentities` | array | - | [] | - |
| `cosmosDbDatabaseName` | string | - | - | - |
| `ordersCosmosContainerName` | string | - | - | - |
| `orderContainerPartitionKey` | string | - | - | - |
| `fulfillmentTopicSubscriptionName` | string | - | - | - |
| `shipmentTopicName` | string | - | - | - |
| `shipmentTopicSubscriptionName` | string | - | - | - |
| `maxWorkDelayInMilliseconds` | int | - | 100 | - |
| `cosmosLeaseContainerName` | string | - | - | - |
| `statusNotificationTopicName` | string | - | - | - |
| `statusNotificationTopicSubscriptionName` | string | - | - | - |
| `webHookNotificationUrl` | string | - | - | - |
| `sendApprovalTopicName` | string | - | - | - |
| `allCreditApprovalsSubscription` | string | - | - | - |
| `pipelineServicePrincipalId` | string | - | - | - |

## 🚀 Deployment

To deploy the Bicep template, run the `deploy.ps1` PowerShell script located in the `scripts` directory. This script takes care of deploying the Bicep template and passing the necessary parameters.