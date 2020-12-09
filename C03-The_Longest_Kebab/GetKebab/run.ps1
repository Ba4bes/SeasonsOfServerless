using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."
Write-Host "request"
$Request.Query


$Weight = $null
$People = $null
$Length = $null
$Skewer = $null

if ($Request.Query.weight) { $Weight = $Request.Query.weight }
elseif ($Request.Query.people) { $People = $Request.Query.people }
elseif (  $Request.Query.length) { $Length = $Request.Query.length }

$ErrorActionPreference = "Stop"
Write-Output "Weigth: $Weight"
Write-Output "Length $Length"
Write-Output "Skewer $Skewer"
Write-Output "People $People"

$HttpCode = [HttpStatusCode]::OK
$Failure = $false
Try {
  If ($Weight) {
    [int]$Skewer = [Math]::Truncate($Weight / 0.18)
    [decimal]$Length = [math]::Round($Skewer * 1.05,2)
    [int]$People = $Skewer
  }
  elseif ($People) {
    [int]$Skewer = $People
    [decimal]$Weight = [math]::Round($Skewer * 0.18,2)
    [decimal]$Length = [math]::Round($Skewer * 1.05,2)
  }
  elseif ($Length) {
    [int]$Skewer = [Math]::Truncate($Length / 1.05)
    [decimal]$Weight = [math]::Round($Skewer * 0.18,2)
    [int]$People = [Math]::Truncate($skewer)
  }
}
Catch {
  $HttpCode = [HttpStatusCode]::BadRequest
  $Body = "input is empty or not a number. Please enter a number"
  $Failure = $true
}

Write-Output "Weigth: $Weight"
Write-Output "Length $Length"
Write-Output "Skewer $Skewer"
Write-Output "People $People"

if ($Failure -eq $false ) {

  $BodyStart = @"

Your have $Weight kg meat!

You can fill $Skewer skewers with that and feed that many people!

And your kebab will be $Length meters long :-o

Just add the following for your kebab:
$(0.5 * $Weight) small onion (minced)
$(2 * $Weight) cloves garlic (minced)
$(0.75 * $Weight) teaspoons ground cumin (divided)
$(0.75 * $Weight) teaspoons ground sumac (divided)
$(0.25 * $Weight) teaspoon salt
$(0.125 * $Weight) teaspoon ground black pepper
$(0.125 * $Weight) teaspoon red pepper flakes

Want to see how long your kebab will be?

       ///\\\
       | .. |
      __\__/_
   __/_______\__
  |     ___     |
  |    |   |    |
  |    | --|    |
"@

  $KebabMiddle = @"

  |    | - |    |
  |    | --|    |
  |    | _ |    |
  |    |-  |    |
"@


  $End = @"

  |    |___|    |
  |             |
  |_____________|

"@

  $Middle = @"
"@
  For ($i = 0; $i -lt $Skewer; $i++) {
    $Middle = $Middle + $KebabMiddle
  }

  $Body = $BodyStart + $middle + $End

}

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $HttpCode
    Body       = $Body
  })
