$KebabMiddle = @"

|    | - |    |
|    | --|    |
|    | _ |    |
|    |-  |    |
|    | --|    |
"@

$Start = @"

     ///\\\
     | .. |
    __\__/_
 __/_______\__
|     ___     |
|    |   |    |
|    | --|    |
"@

$End = @"

|    |___|    |
|             |
|_____________|

"@

$Middle = @"
"@
For ($i = 0; $i -lt $kebab; $i++){
    $Middle = $Middle + $KebabMiddle
}

$Body = $Start + $middle + $End