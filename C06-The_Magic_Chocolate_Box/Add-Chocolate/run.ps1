using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

try {
    # An object is created with the input
    $Object = [PSCustomObject]@{
        id            = $Request.body.Name
        Name          = $Request.body.Name
        ChocolateType = $Request.body.chocolateType
        Filling       = $Request.body.Filling
        ClaimedBy     = $Request.body.ClaimedBy
    }
    # Push it to the cosmosDB
    Push-OutputBinding -Name ChocDBout -Value $Object
    Write-Output "$($Object.id) has been pushed to the Cosmos DB"


    # create a status and body to return
    $Status = [HttpStatusCode]::OK
    $Body = "$($Object.id) has been added to the cosmosDB"
}
Catch {
    $Status = [HttpStatusCode]::BadRequest
    $Body = "Something went wrong, could not add $($Object.id)"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })