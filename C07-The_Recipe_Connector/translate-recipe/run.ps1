using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$SourceRecipe = $Request.body.recipe
if ([string]::IsNullOrEmpty($SourceRecipe)) {
    $StatusCode = [HttpStatusCode]::BadRequest
    $ReturnBody = "Please enter a recipe in the body"
}
else {
    # Get the callers IP
    $IP = ($Request.headers.'x-forwarded-for').split(':')[0]
    Write-Host "ClientIP: $IP"
    $Key = $Env:AzureMapsKey
    Try {
        # Get Client Country
        $AzureMapsURL = "https://atlas.microsoft.com/geolocation/ip/json?subscription-key=$Key&api-version=1.0&ip=$IP"
        $Result = Invoke-RestMethod $AzureMapsURL
        $CountryCode = $Result.countryRegion.isoCode
        Write-Host "CountryCode: $CountryCode"
        # Start creating an object to return
        $ReturnBody = [PSCustomObject]@{
            Caller_IP          = $IP
            Caller_CountryCode = $CountryCode
        }

        $TranslateHeader = @{
            "Ocp-Apim-Subscription-Key" = $Env:TranslationKey
            "Content-Type"              = "application/json"
        }
        # Create a body and change it tot the correct format for translation
        $body = @{
            Text = $SourceRecipe
        }
        $bodyjson = "[$($body | ConvertTo-Json)]"
        # Change encoding to handle non-standard characters
        $jsondata = ([System.Text.Encoding]::UTF8.GetBytes($bodyjson))
        # Detect the language of the message
        $URI = "https://api.cognitive.microsofttranslator.com/detect?api-version=3.0"
        $Language = Invoke-RestMethod -Method POST -uri $URI -Headers $TranslateHeader -Body $jsondata
        Write-Host "sourcelanguage: $($Language.Language)"

        # Translate the message to the correct language.
        $URI = "https://api.cognitive.microsofttranslator.com/translate?api-version=3.0&from=$($Language.Language)&to=$CountryCode"
        $Result = Invoke-RestMethod -Method POST -uri $URI -headers $TranslateHeader -body $jsondata
        Write-Output $Result.translations.text
        $ASCIIFont = Invoke-RestMethod "http://artii.herokuapp.com/make?text=$CountryCode&font=starwars"
        # Add the new information to the Returnbody
        $Recipe = @"
$ASCIIFont

$($Result.translations.text)
"@
        $ReturnBody | Add-Member -MemberType NoteProperty -Name "SourceLanguage" -Value $Language.Language
        $ReturnBody | Add-Member -MemberType NoteProperty -Name "Recipe" -Value $Recipe

        Write-Host "Body"
        $ReturnBody
        $StatusCode = [HttpStatusCode]::OK
    }
    Catch {
        $ReturnBody = "Something went wrong: $_"
        $StatusCode = [HttpStatusCode]::BadRequest
    }
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $StatusCode
        Body       = ($ReturnBody | ConvertTo-Json)
    })


$Recipe = Invoke-RestMethod https://gist.githubusercontent.com/Ba4bes/b4366aaf8850544199b5ed9a57d81da1/raw/cb4c425dfa5b534cbae0e4ae3f504af28637a5e4/recipe.txt