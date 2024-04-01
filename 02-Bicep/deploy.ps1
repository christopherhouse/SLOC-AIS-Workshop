param(
    [string]
    [CmdletBinding()]
    $ResourceGroupName
)
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                              -TemplateFile ./main.bicep `
                              -TemplateParameterFile ./main.parameters.json