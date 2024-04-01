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
    $AzDoProjectName
)

$buildAndDeployPipelineName = "${PrefixString}-ApiOps-BuildAndDeploy"
$extractorPipelineName = "${PrefixString}-ApiOps-Extractor"
$publisherPipelineName = "${PrefixString}-ApiOps-Publisher"

$pipelines = az pipelines list --org $AzDoOrgName --project $AzDoProjectName -o json | ConvertFrom-Json

# for the JSON object in $pipelines, find the pipeline id with the name specified by
# $buildAndDeployPipelineName, $extractorPipelineName, and $publisherPipelineName.  Assign
# each of these to a variable.
$buildAndDeployPipelineId = $pipelines | Where-Object { $_.name -eq $buildAndDeployPipelineName } | Select-Object -ExpandProperty id
$extractorPipelineId = $pipelines | Where-Object { $_.name -eq $extractorPipelineName } | Select-Object -ExpandProperty id
$publisherPipelineId = $pipelines | Where-Object { $_.name -eq $publisherPipelineName } | Select-Object -ExpandProperty id 

Write-Host "Build and Deploy Pipeline Id: $buildAndDeployPipelineId"
Write-Host "Extractor Pipeline Id: $extractorPipelineId"
Write-Host "Publisher Pipeline Id: $publisherPipelineId"

# For each of the variables above, use the command 'az pipelines delete' to delete
az pipelines delete --id $buildAndDeployPipelineId --yes
az pipelines delete --id $extractorPipelineId --yes
az pipelines delete --id $publisherPipelineId --yes

