# Challenge 1: The Perfect Holiday Turkey

## Solution

This is a PowerShell function App. 
Approach was to just let PowerShell do the math. I have added Ascii art because #TeamAsciiArt and converted to grams so the recipe is usable for europeans :-).

Credit for the ASCII art goes to [this awesome 90s website](https://oocities.org/spunk1111/)

## Try it yourself

The function is designed to be called from a interactive prompt, but also works in a browser.

You can try it yourself:

```PowerShell
Invoke-RestMethod https://4besc01.azurewebsites.net/api/getrecipe?weight=20
```

![screenshot](screenshot.png)

Created by Barbara Forbes
<https://4bes.nl>

## The Challenge

This challenge is part of the Seasons of serverless: <https://github.com/microsoft/Seasons-of-Serverless>

original challenge ([source](https://github.com/microsoft/Seasons-of-Serverless/blob/main/Nov-23-2020.md))

### Your Chefs: Jen Looper, Cloud Advocate (Microsoft) and Darren Butler and Eric Yu, Microsoft Student Ambassadors

### This week's featured region: North America

Here in North America, many families believe that the holidays are simply not complete without a proper turkey on the table. Juicy meat, crispy skin, mouth-watering gravy: a good turkey has it all! The only problem is these birds can be hard to cook so they don't turn out dry and tough. The secret? A proper brine! 

Here's a [sample recipe](https://www.aspicyperspective.com/best-turkey-brine-recipe/) for that important process in the production of a perfect turkey.

There's a science to a great turkey brine, but we, as software engineers, are both absent-minded and need an automated way to remind ourselves each year of the proper percentages of ingredients of a good brine, based on the weight of the turkey.

According to Chef Darren's calculations, the brine equation and roast recommendation looks like this:

### Brine Instructions

- Salt (in cups) = 0.05 * lbs of turkey
- Water (gallons) = 0.66 *  lbs of turkey
- Brown sugar (cups)  = 0.13 * lbs of turkey
- Shallots = 0.2 * lbs of turkey
- Cloves of garlic = 0.4 * lbs of turkey
- Whole peppercorns (tablespoons) = 0.13 * lbs of turkey
- Dried juniper berries (tablespoons) = 0.13 * lbs of turkey
- Fresh rosemary (tablespoons) = 0.13 * lbs of turkey
- Thyme (tablespoons) = 0.06 * lbs of turkey
- Brine time (in hours) = 2.4 * lbs of turkey
- Roast time (in minutes) = 15 * lbs of turkey

## Your challenge 🍽 

Convert this brine equation and cook time to an automated process so that when you input a turkey's weight, you will be given the amount of water, sugar, salt, and spices to add and a recommendation on how long to cook it.

Let's assume you have available a large cooler for your turkey and its brine and that it's defrosted.

Our chefs recommends trying an Azure Function to generate your recipe, and encourages you to share your own turkey secrets by adding a link to your solution in the Issues tab!

## Resources/Tools Used 🚀

-   **[Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=academic-10922-cxa)**
-   **[Postman](https://www.getpostman.com/downloads/)**
-   **[Azure Functions Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions&WT.mc_id=academic-10922-cxa)**

## Next Steps 🏃

Learn more about serverless!

  ✅ **[Serverless Free Courses](https://docs.microsoft.com/learn/browse/?term=azure%20functions&WT.mc_id=academic-10922-cxa)**

## Important Resources ⭐️

  ✅ **[Azure Functions documentation](https://docs.microsoft.com/azure/azure-functions/?WT.mc_id=academic-10922-cxa)**
  
  ✅ **[Azure SDK for JavaScript Documentation](https://docs.microsoft.com/azure/javascript/?WT.mc_id=academic-10922-cxa)**
  
  ✅ **[Create your first function using Visual Studio Code](https://docs.microsoft.com/azure/azure-functions/functions-create-first-function-vs-code?WT.mc_id=academic-10922-cxa)**
  
  ✅ **[Free E-Book - Azure Serverless Computing Cookbook, Second Edition](https://azure.microsoft.com/resources/azure-serverless-computing-cookbook/?WT.mc_id=academic-10922-cxa)**

## Ready to submit a solution to this challenge? Here's how 🚀 

Open an [issue](https://github.com/microsoft/Seasons-of-Serverless/issues/new?assignees=&labels=&template=seasons-of-serverless-solution.md&title=Solution) in this repo, with a link to your challenge and a brief explanation of how you solved it. We will take a look, approve it if appropriate, and a tag with the appropriate week. If your solution is picked as a weekly standout solution, we'll send you a little prize!
