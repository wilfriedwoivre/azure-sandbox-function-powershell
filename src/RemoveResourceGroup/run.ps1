# Input bindings are passed in via param block.
param($Timer)

# Get the current universal time in the default string format
$currentUTCtime = (Get-Date).ToUniversalTime()


$elligibleResourceGroup = Get-AzResourceGroup -Tag @{"AutoDelete"="true"}

foreach ($resourceGroup in $elligibleResourceGroup) {
    if ($resourceGroup.Tags.Contains("ExpirationDate")) {
        $date = [System.DateTime]::Parse($resourceGroup.Tags["ExpirationDate"], [System.Globalization.CultureInfo]::GetCultureInfo("en-US"))

        if ($date -lt $elligibleResourceGroup) {
            Remove-AzResourceGroup -Name $resourceGroup.ResourceGroupName -Force
        }
    }
}
