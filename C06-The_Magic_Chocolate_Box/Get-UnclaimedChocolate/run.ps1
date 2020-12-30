using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $ChocDBin)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
try {
    # Collect Names from requestbody
    [array]$Family = $Request.body

    #Set variables
    $UnClaimedChoc = $ChocDBin | Where-Object { $_.ClaimedBy -eq "false" } | Select-Object Name, ChocolateType, Filling

    $Status = [HttpStatusCode]::OK
    #Create JSON body
    $body = ( $UnClaimedChoc | ConvertTo-Json)
}
Catch {
    $Status = [HttpStatusCode]::BadRequest
    Write-Host "ERROR: $_"
    $Body = "Something went wrong, could not claim $($Object.id) : $_"
}

Write-output "Body returned:"
$body


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $Status
        Body       = $body
    })
