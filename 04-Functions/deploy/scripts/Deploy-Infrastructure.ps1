param(
    [string]
    [CmdletBinding()]
    $ResourceGroupName
)

# Create a variable that's a short guid
$shortGuid = [guid]::NewGuid().ToString().Substring(0, 8)

$overrideParams = @{
  buildId = $shortGuid
}

# Use Az powershell to deploy the Bicep template main.bicep that exists in this repostiory,
# in the path .\04-Functions\infrastructure\bicep\main.bicep.  Use the parameter file 
# .\04-Functions\infrastructure\bicep\main.parameters.json to provide the parameters.  Do
# not use az cli, the deployment should use the appropriate powershell cmdlet
New-AzResourceGroupDeployment -ResourceGroupName $ResourceGroupName `
                              -TemplateFile ..\..\infrastructure\bicep\main.bicep `
                              -TemplateParameterFile ..\..\infrastructure\bicep\parameters\main.dev.parameters.json
                              -TemplateParamtersObject $overrideParams
