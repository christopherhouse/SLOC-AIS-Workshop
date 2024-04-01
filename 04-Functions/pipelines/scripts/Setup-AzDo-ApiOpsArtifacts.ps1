[CmdletBinding()]
param(
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    $PrefixString,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $AzDoOrgName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string ]
    $AzDoProjectName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $AzDoRepositoryName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $DevResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $QAResourceGroupName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $DevOpsServiceConnectionName,

    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty()]
    [string]
    $DevApiManagementServiceName
)

$apiOpsReleaseVersion = "v4.10.3"

$buildAndDeployPipelinePath = ".pipelines/build-and-deploy-order-fulfillment.yaml"
$apiOpsExtractorPipelinePath = ".pipelines/run-extractor.yaml"
$apiOpsPublisherPipelinePath = ".pipelines/run-publisher.yaml"
$buildAndDeployPipelineName = "${PrefixString}-ApiOps-BuildAndDeploy"
$extractorPipelineName = "${PrefixString}-ApiOps-Extractor"
$publisherPipelineName = "${PrefixString}-ApiOps-Publisher"
$variableGroupName = "${PrefixString}-apim-automation"

# Use the command 'az pipelines create' to create a new YAML pipeline
# in the DevOps org and project specified by the $AzDoOrgName and $AzDoProjectName
# parameters.  The pipeline will be created in the repository specified by the
# $AzDoRepositoryName parameter.  The pipeline will be created from the YAML
# file specified by the $buildAndDeployPipelinePath parameter.  The pipeline
# name will be specified by the $buildAndDeployPipelineName parameter.
Write-Output "Creating pipeline $buildAndDeployPipelineName from $buildAndDeployPipelinePath"
az pipelines create --name $buildAndDeployPipelineName `
                    --org $AzDoOrgName `
                    --project $AzDoProjectName `
                    --repository $AzDoRepositoryName `
                    --repository-type tfsgit `
                    --branch master `
                    --skip-first-run `
                    --yaml-path $buildAndDeployPipelinePath `
                    --branch main `
                    -o table

Write-Output "Creating pipeline $extractorPipelineName from $apiOpsExtractorPipelinePath"
az pipelines create --name $extractorPipelineName `
                    --org $AzDoOrgName `
                    --project $AzDoProjectName `
                    --repository $AzDoRepositoryName `
                    --repository-type tfsgit `
                    --branch master `
                    --skip-first-run `
                    --yaml-path $apiOpsExtractorPipelinePath `
                    --branch main `
                    -o table

Write-Output "Creating pipeline $publisherPipelineName from $apiOpsPublisherPipelinePath"
az pipelines create --name $publisherPipelineName `
                    --org $AzDoOrgName `
                    --project $AzDoProjectName `
                    --repository $AzDoRepositoryName `
                    --repository-type tfsgit `
                    --branch master `
                    --skip-first-run `
                    --yaml-path $apiOpsPublisherPipelinePath `
                    --branch main `
                    -o table

az pipelines variable-group create --name $variableGroupName `
                                   --org $AzDoOrgName `
                                   --project $AzDoProjectName `
                                   --variables "APIM_NAME=$DevApiManagementServiceName apiops_release_version=$apiOpsReleaseVersion RESOURCE_GROUP_NAME=$DevResourceGroupName RESOURCE_GROUP_QA=$QAResourceGroup SEVICE_CONNECTION_NAME=$DevOpsServiceConnectionName" `
                                   -o table

