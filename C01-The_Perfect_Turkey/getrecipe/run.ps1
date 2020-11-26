using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
1 -is [int]
if ($Request.Query.weight) {
  $TurkeyWeight = $Request.Query.weight
}
elseif ($Request.Body.weight) {
  $TurkeyWeight = $Request.Body.weight
}

if ($TurkeyWeight -match "^\d+$") {

  $HttpCode = [HttpStatusCode]::OK
  $Body = @"

Your turkey weighs $TurkeyWeight lbs

       .--.
      /} o \             /}
      `~)-) /           /` }
      ( / /          /`}.' }
       / / .-'""-.  / ' }-'}
      / (.'       \/ '.'}_.}
     |            `}   .}._}
     |     .-=-';   } ' }_.}
     \    `.-=-;'  } '.}.-}
      '.   -=-'    ;,}._.}
        `-,_  __.'` '-._}
      jgs   `|||
           .=='=,


Here is your recipe
$(0.05 * $TurkeyWeight) cups of Salt ($($(0.05 * $TurkeyWeight)*128) gram)
$(0.66 * $TurkeyWeight) gallons of water  ($($(0.05 * $TurkeyWeight)*3.78541178) liter)
$(0.13 * $TurkeyWeight) cups of brown sugar  ($($(0.13 * $TurkeyWeight)*128) gram)
$(0.2 * $TurkeyWeight) shallots
$(0.4 * $TurkeyWeight) cloves of garlic
$(0.13 * $TurkeyWeight) tablespoons of whole peppercorns ($($(0.13 * $TurkeyWeight)*21.25) gram)
$(0.13 * $TurkeyWeight) tablespoons of dried juniper berries ($($(0.13 * $TurkeyWeight)*21.25) gram)
$(0.13 * $TurkeyWeight) tablespoons of fresh rosemary ($($(0.13 * $TurkeyWeight)*21.25) gram)
$(0.06 * $TurkeyWeight) tablespoons of thyme  ($($(0.06 * $TurkeyWeight)*21.25) gram)

Brine time:  $(2.4 * $TurkeyWeight) hours
Roast time: $(15 * $TurkeyWeight) minutes
"@

}
else {
  $HttpCode = [HttpStatusCode]::BadRequest
  $Body = "Weight is empty or not a number. Please enter a number"
}
# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $HttpCode
    Body       = $Body
  })
