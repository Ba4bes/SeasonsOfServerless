$itemsdingen = ( Get-Content ".\C04-A_Big_Barbecue\zfooditems.json" | ConvertFrom-Json)

foreach ($ding in $itemsdingen) {
    Invoke-RestMethod http://localhost:7071/api/AddNewItem -body ($ding | ConvertTo-Json)
}
