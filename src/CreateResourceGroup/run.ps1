using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

$name = $Request.Body.Name
$date = $Request.Body.ExpirationDate
$location = $Request.Body.Location

if (-not $date) {
    $date = ([System.DateTime]::UtcNow).ToString("yyyy-MM-dd")
}
if (-not $location) {
    $location = "westeurope"
}

New-AzResourceGroup -Name $name -Location $location -Tags @{"AutoDelete"="true";"ExpirationDate"="$date"}

$status = [HttpStatusCode]::OK
$body = "Success"

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
