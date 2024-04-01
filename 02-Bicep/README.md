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

| Parameter Name | Data Type | Description | Default Value | Allowed Values |
| --- | --- | --- | --- | --- |
| `webAppName` | string | The name of the web app resource to create. Note a unique string will be appended to the name | - | - |
| `sku` | string | The SKU of the app service plan | - | 'S1', 'B1', 'F1' |
| `linuxFxVersion` | string | The runtime to be used on the web app | - | - |
| `location` | string | The Azure region where resources will be deployed. Defaults to the resource group location | `resourceGroup().location` | - |
| `repositoryUrl` | string | The URL of the repository to deploy the web app from | 'https://github.com/Azure-Samples/nodejs-docs-hello-world' | - |
| `branch` | string | The branch of the repository to deploy the web app from | - | - |

## 🚀 Deployment

To deploy the Bicep template, you can use the `deploy.ps1` PowerShell script. Here is the command:

```powershell
./deploy.ps1 -ResourceGroupName <ResourceGroupName>
```
