using namespace System.Net
<#
.SYNOPSIS
    This Function calls a html-form where the user can give an input
.DESCRIPTION
    An dynamic HTMLform is returned to the user.
    The input is then given to the second function called "Result"
.INPUTS
    a webrequest through a browser.
    For flexibility, it is possible to define a familyamount for the form, for how many families are coming.
    By default, there is room for 5 families
    Fooditems are collected from a cosmosDB
.OUTPUTS
    an HTML page with a form
.NOTES
    This is an Azure Function App, originally made for Seasons of Serverless
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata, $FoodDBin)
Write-Host "PowerShell HTTP trigger function processed a request."

if ($Request.query.familyamount){
    [int]$FamilyAmount = $Request.query.familyamount
}
else{
    [int]$FamilyAmount = 5
}

# Get the FunctionAppURL for the resultFunction
Write-Host $TriggerMetadata.request.url
$URL = $TriggerMetadata.Request.Url
$FunctionAppUrl = $URL -replace "FrontPage", "Result"

# Get the food items for the form from the CosmosDB
foreach ($item in $FoodDBin) {
    write-output $item.namespace
    $FoodHTML += "<li><input type='Checkbox' name='Food$($item.namespace)' />$($item.namespace)</li>"
}

# Create checkboxes for all the families
for ($i = 1; $i -le $FamilyAmount; $i++) {
    $number = "0$i"
    $Familieshtml += @"

    <li><input type="checkbox" name="Family$($number)" />Family $($number)
    <ul>
    <li><input type="text" name="F$($number)Name"/> Name</li><br>
    <li><input type="number" name="F$($number)Adults" size="2"/> Amount of Adults</li><br>
    <li><input type="number" name="F$($number)Children" size="2"/> Amount of Children<br>
    </ul>
"@
}

$form = @"
<!DOCTYPE html>
<html>
<style>
BODY {font-family:verdana;}
li ul {display:none;}
li input:checked + ul {display:block;}

input[type=number]{
    width: 80px;
}
</style>
<body>

<form action='$FunctionAppUrl'>
    <ul>
    $FamiliesHTML
        <p>
        Food options:
        $FoodHTML
        <p>
        <input type='submit' value='Submit'>
</form>
</body>
</html>

"@

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        ContentType = "text/html"
        Body        = $Form
    })
