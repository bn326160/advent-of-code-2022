#!/usr/bin/env pwsh

$content = Get-Content -Path .\sample.txt -Raw
$sets = @($content -split '(?:\r?\n){2,}')

function Process-Array($leftArray, $rightArray) {
    $lArrCount = $leftArray.Count
    $rArrCount = $rightAray.Count

    $j = 0
    if ($rArrCount -lt $lArrCount) {
        # Right array is smallest
        foreach ($right in $rightArray) {
            Process-Input -Left $leftArray[$i] -Right $right
            $j++
        }
    } else {
        # Normal case (left smallest or equal)
        foreach ($left in $leftArray) {
            Process-Input -Left $left -Right $rightArray[$i]
            $j++
        }
    }
}

function Process-Input($left, $right) {
    $lInt = $left -is [int]
    $rInt = $right -is [int]

    if ($lInt -And $rInt) {
        # Both are integers
        $correct = $lInt -lt $rInt
        return $correct
    } else {
        if ($lInt) {
            # Only left is an integer
            $left = ,@($left)
            $left.Count
        } 
        if ($rInt) {
            # Only right is an integer
            $right = ,@($right)
            $right.Count
        }
        # Process the arrays
        Process-Array -LeftArray $left -RightArray $right
    }
}


$i = 1
$rightOrder = New-Object Collections.Generic.List[Int]
foreach ($set in $sets) {
    $pair = @($set -split [System.Environment]::NewLine)
    $leftJson = $pair[0]
    $rightJson = $pair[1]
    $left = ConvertFrom-Json -InputObject $leftJson
    $right = ConvertFrom-Json -InputObject $rightJson
    [bool]($left[0] -as [int] -is [int])

    #Process-Array -LeftArray $left -RightArray $right
    
    $i++
}