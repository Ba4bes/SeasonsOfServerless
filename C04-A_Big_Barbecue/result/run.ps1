using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $FoodDBin)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Collect Data from the form
$FamilyObjects = @()
$TotalChildren = 0
$TotalAdults = 0
$Foodlist = @()
$FormFamilies = @()
1..50 | ForEach-Object { $FormFamilies += $_.ToString("00")}
Foreach ($Family in $FormFamilies) {
    if ($TriggerMetadata."Family$Family" -eq "on") {
        [int]$Adults = $TriggerMetadata."F$($Family)Adults"
        [int]$Children = $TriggerMetadata."F$($Family)Children"
        $FamilyObject = @{
            Name        = $TriggerMetadata."F$($Family)Name"
            Children    = $Children
            Adults      = $Adults
            MemberCount = $Adults + $Children
        }
        $FamilyObjects += $FamilyObject
        $TotalAdults += $Adults
        $TotalChildren += $Children
    }
}
"TotalAdults $TotalAdults"
"TotalChildren $TotalChildren"
"FamilyObjects"
$FamilyObjects.count

foreach ($Property in $TriggerMetadata.GetEnumerator()) {
    $Propertyname = $Property.Name
    if ($Propertyname -match "Food.*" -and $TriggerMetadata.$Propertyname -eq "on") {
        $Foodlist += ($PropertyName -replace 'Food', '')
    }
}
Write-output "Foodcount"
$Foodlist.Count

# Collect data from CosmosDB
"CosmosDb count"
$FoodDBin.count

Write-host "THIS IS WHERE THE MAGIC STARTS"
$TotalCost = 0
$TotalAmount = @{}
$Familyresults = @()
$Foodlist | ForEach-Object { $TotalAmount | Add-Member -MemberType NoteProperty -Name $_ -value 0 }

Foreach ($family in $FamilyObjects) {
    Write-Output "Family"
    $TotalFamilyCost = 0
    $FamilyResult = [PSCustomObject]@{
        Name = $Family.Name
    }
    $Family
    foreach ($fooditem in $Foodlist) {
        Write-output "Fooditem"
        $fooditem
        $FoodDB = $FoodDBin | Where-Object { $_.id -eq $fooditem }
        Write-Host "DBitem"
        $ChildrensPortions = $Family.Children * $FoodDB.OnePersonPortion.child
        $AdultsPortions = $Family.Adults * $FoodDB.OnePersonPortion.adult
        [int]$FoodforFamily = $ChildrensPortions + $AdultsPortions
        $FamilyResult | Add-member -MemberType NoteProperty -Name ($Fooditem + "Amount") -Value $FoodforFamily
        $TotalAmount.$Fooditem = $FoodforFamily
        [decimal]$FooditemCost = [math]::Round($FoodforFamily * ($FoodDB.costkg / 1000), 2)
        $FamilyResult | Add-member -MemberType NoteProperty -Name ($Fooditem + "Cost") -Value $FooditemCost
        $TotalFamilyCost = $TotalFamilyCost + $FooditemCost
    }
    $FamilyResult | Add-member -MemberType NoteProperty -Name TotalFamilyCost -Value $TotalFamilyCost
    $Familyresults += $FamilyResult
    $TotalCost = $TotalCost + $TotalFamilyCost
}
Write-Output "Familyresults"
$Familyresults
write-output "totalamount"
$TotalAmount
Write-Output "Totalcost"
$TotalCost

# Create the Ascii Art
$Ascii = @"
<pre>
  O
 /|\      .  O
  |    (_) \/|\
 / \   / \  / \
 </pre>
"@

#Create the output
# $HTML = @()
# foreach ($Family in $Familyresults) {
#     $Familyproperties = $Family | Get-Member -MemberType NoteProperty
#     $HTML += @"
# $($Family.Name)<br>
# $Ascii
# foreach ($Prop in $FamilyProperties){
#     $Famly
# }
# "@
# }
$Return = @"
<style>
BODY {font-family:verdana;}
TABLE {border-width: 1px; border-style: solid; border-color: black; border-collapse: collapse;}
TH {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px; background-color: #d1c3cd;}
TD {border-width: 1px; padding: 3px; border-style: solid; border-color: black; padding: 5px}
</style>
<h1>BBQ TIME!</h1>
$Ascii

<h2>
Grocerylist</h2>
<table>
$(foreach ($amount in $TotalAmount.GetEnumerator()){
    "<tr>   <td>   $($Amount.Name)</td>
   <td>  $($Amount.Value) gr</td>
   </tr>"
})
</table>
<h2>Total cost</h2>
<table>
<tr><td>Total Cost</td>
<td>$TotalCost</td>
</tr>
</table>

<h2>Cost per family</h2>
<table>
$(foreach ($Family in $FamilyResults){
    "<tr>   <td>  $($family.Name)</td>
    <td> €$($Family.TotalFamilyCost)</td>
    </tr>"
}
)
</table>
<p>

"@

# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $Return
    })
