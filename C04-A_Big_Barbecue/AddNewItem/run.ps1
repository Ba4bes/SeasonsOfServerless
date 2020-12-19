using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $FoodDBin)

try {
    # An object is created with the input
    $Object = [PSCustomObject]@{
        id               = $Request.body.Name
        namespace        = $Request.body.Name
        OnePersonPortion = @{
            child = $Request.body.OnePersonPortion.child
            adult = $Request.body.OnePersonPortion.adult
        }
        costkg           = $Request.body.costkg
    }

        Push-OutputBinding -Name FoodDBout -Value $Object
        Write-Output "$($Object.id) has been pushed to the Cosmos DB"


    # create a status and body to return
    $Status = [HttpStatusCode]::OK
    $Body = "FoodItem $($Object.id) has been added to the cosmosDB"
}
Catch {
    $Status = [HttpStatusCode]::BadRequest
    $Body = "Something went wrong, could not add FoodItem $($Object.id)"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })