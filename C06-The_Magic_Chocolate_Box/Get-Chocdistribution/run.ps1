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
    $TotalChocCount = $ChocDBin.Count
    $TotalFamilyCount = $Family.Count
    $ChocPerPerson = [Math]::floor($TotalChocCount / $TotalFamilyCount)
    $FamilyResults = @()

    Foreach ($FamilyMember in $Family) {
        Write-Host "Starting with $FamilyMember"
        Write-Host "$($UnclamiedChoc.Count) chocolates left"
        $ResultChoc = @()
        # See if choc has been claimed an add to persons assigned chocolate accordingly
        $ClaimedChoc = $ChocDBin | Where-Object { $_.ClaimedBy -eq $FamilyMember }  | Select-Object Name, ChocolateType, Filling
        if ($ClaimedChoc.Count -gt $ChocPerPerson) {
            $ResultChoc = $ClaimedChoc | Get-Random
        }
        elseif ($ClaimedChoc.Count -eq $ChocPerPerson) {
            $ResultChoc = $ClaimedChoc
        }
        else {
            # if claimed were less than total assigned, assign random chocolates
            $ResultChoc += $ClaimedChoc
            [int]$LeftChoc = $ChocPerPerson - $ResultChoc.Count
            For ($i = 1; $i -le $LeftChoc; $i++) {
                write-host "loop $i"
                $ChosenChoc = $UnClaimedChoc | Get-Random
                $ResultChoc += $ChosenChoc
                $UnClaimedChoc = $unclaimedchoc | Where-Object { $_.Name -ne $ChosenChoc.Name }
            }
        }
        $FamilyMemberObject = [PSCustomObject]@{
            Name       = $FamilyMember
            ResultChoc = $ResultChoc
        }
        Write-Host "Assigned chocolate:"
        $ResultChoc
        $FamilyResults += $FamilyMemberObject
    }

    $Status = [HttpStatusCode]::OK
    #Create JSON body
    $body = ( $FamilyResults | ConvertTo-Json -depth 3)
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
