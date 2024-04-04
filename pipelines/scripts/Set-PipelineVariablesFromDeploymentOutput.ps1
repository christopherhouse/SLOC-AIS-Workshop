[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $armOutputString
)

Write-Output "Deployment output is $armOutputString"
$outputObj = $armOutputString | ConvertFrom-Json
$functionAppName = $outputObj.functionAppName.value
$keyVaultName = $outputObj.keyVaultName.value
$functionAppHostName = $outputObj.functionAppHostName.value
$apimName = $outputObj.apimName.value
$functionAppResourceId = $outputObj.functionAppResourceId.value
$apimUserAssignedManagedIdentityClientId = $outputObj.apimUserAssignedManagedIdentityClientId.value
$functionAppKeyKeyVaultSecretUri = $outputObj.functionAppKeyKeyVaultSecretUri.value

Write-Host "Setting variable for function app name"
Write-Output "##vso[task.setvariable variable=functionAppName;]$functionAppName"

Write-Host "Setting variable for key vault name"
Write-Output "##vso[task.setvariable variable=keyVaultName;]$keyVaultName"

Write-Host "Setting variable for function app host name"
Write-Output "##vso[task.setvariable variable=functionAppHostName;]$functionAppHostName"

Write-Host "Setting variable for apim name"
Write-Output "##vso[task.setvariable variable=apimName;]$apimName"

Write-Host "Setting variable for function app resource id"
Write-Output "##vso[task.setvariable variable=functionAppResourceId;]$functionAppResourceId"

Write-Host "Setting variable for apim user assigned managed identity client id"
Write-Output "##vso[task.setvariable variable=apimUserAssignedManagedIdentityClientId;]$apimUserAssignedManagedIdentityClientId"

Write-Host "Setting variable for function app key key vault secret uri"
Write-Output "##vso[task.setvariable variable=functionAppKeyKeyVaultSecretUri;]$functionAppKeyKeyVaultSecretUri"