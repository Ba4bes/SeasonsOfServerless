using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $ChocDBin)


try {
    # Check if chocolate exists
    if ($ChocDBin.id -notcontains $Request.body.ChocName) {
        $status = [HttpStatusCode]::BadRequest
        $body = "The chocolate name was not found"
    }
    else {
        write-Host "Object was found"
        $Object = $ChocDBin | Where-Object { $_.id -eq $Request.body.ChocName }
        $object
        if ($Object.ClaimedBy -ne "false") {
            $status = [HttpStatusCode]::BadRequest
            $body = "That chocolate has already been claimed"
        }
        else {
            $Object.ClaimedBy = $Request.body.MyName
            Write-Host "Object that will be pushed"
            $Object
            Push-OutputBinding -Name ChocDBout -Value $Object
            Write-Output "$($Object.id) has been claimed for $($Object.ClaimedBy)!"

            # create a status and body to return
            $Status = [HttpStatusCode]::OK
            $Body = @"

      ██████████████
      ██▓▓▓▓██▓▓▓▓██
      ██▓▓▓▓██▓▓▓▓██
      ████████████████
      ██▓▓▓▓██▓▓▓▓██▓▓██
  ██████▓▓▓▓██▓▓▓▓██▓▓▓▓██████
 ██      ████████████████      ██
  ████                    ████
    ████  ████  ██    ██████
    ██░░██░░  ██░░████  ░░██
    ██░░  ░░  ░░░░  ░░  ░░██
    ██░░  ░░  ░░░░  ░░  ░░██
    ██░░  ░░        ░░  ░░██
    ██░░  ░░░░░░░░░░░░  ░░██
    ██░░                ░░██
    ██░░░░░░░░░░░░░░░░░░░░██
    ████████████████████████

   $($Object.id) has been claimed for $($Object.ClaimedBy)!
"@
        }
    }
}
Catch {
    $Status = [HttpStatusCode]::BadRequest
    Write-Host "ERROR: $_"
    $Body = "Something went wrong, could not claim $($Object.id) : $_"
}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode = $status
        Body       = $body
    })