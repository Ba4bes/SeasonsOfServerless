using namespace System.Net
<#
.SYNOPSIS
    Takes an ImageURL and tells if the image is a Ladoo or an oliebol
.DESCRIPTION
    An Image is downloaded from the URL to temporary storage.
    It is then checked through AI if the image shows Ladoo or Oliebol.
    The result is given back with some ascii art.
.INPUTS
    A body with an URL
.OUTPUTS
    Text results an ASCII art
.NOTES
    This is an Azure Function App, originally made for #SeasonsOfServerless
    Made by Barbara Forbes
    @Ba4bes
    4bes.nl
#>
# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)


$PictureURL = $Request.Body.URL
Write-Output "PictureURL"
$PictureURL

$output = "$env:Temp\image.jpg"
#Webclient is used to download the image to a temp location
$image = New-Object System.Net.WebClient
$image.DownloadFile($PictureURL, $output)
#Image is converted to bytes for the API
$ImageBytes = [System.IO.File]::ReadAllBytes($output)

$DescribeHeader = @{
    "Prediction-Key" = $Env:C02Key
}

$IA_API = $ENV:C02URL
$Parameters = @{
    Method      = "POST"
    Uri         = $IA_API
    Headers     = $DescribeHeader
    Body        = $ImageBytes
    ContentType = "application/octet-stream"
}
$ImageResults = Invoke-RestMethod @Parameters

$Result = ($ImageResults.predictions[0]).tagName
$resultprobability = ($ImageResults.predictions[0]).probability
$percentage = [math]::Round(($resultprobability * 100), 2)

$Body = @"

It's $Result! I'm $Percentage% sure!


                                 @  @
                              @        @
                       @  @  @          @  @   @   @
                  @  @  @ @- @          @   @ @        @
               @    @         @        @ @      @         @
            @      @         @ @ @  @  @          @          @
          @        @       @        @ @           @  @        @
        @          @ @    @          @@           @    @       @
       @         @     @ @           @ @         @      @      @
       @       @         @           @     @ @ @  @     @      @
        @     @       @   @         @ @  @          @ @       @
         @    @    @        @ @ @         @          @       @
          @    @  @           @ @          @         @      @
            @     @           @@            @      @       @
              @              @ @           @    @         @
                @  @  @  @   @   @  @    @   @          @
                   @                                  @
                        @                           @
                             @   @   @   @  @  @

"@




# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = "Ok"
        ContentType = "text/html"
        Body        = $Body
    })
