#!/usr/bin/env pwsh

function Reduce($initial, $sb)
{
  begin { $result = $initial }
  process { $result = & $sb $result $_ }
  end { $result }
}

$content = Get-Content -Path .\input.txt -Raw
#$content

$elfData = @($content -split '(?:\r?\n){2,}')
#$elfData
#$elfData.count

$elfSums = @($elfData | % { ,@($_ -split [System.Environment]::NewLine | Reduce 0 { param($x, $y) $x + $y }) })
#$elfSums.count
#$elfSums

[array]$numericElfSums = foreach($number in $elfSums) {
    try {
        [int]::parse($number)
    }
    catch {
        Invoke-Expression -Command $number;
    }
}

$mostCalories = $numericElfSums | measure -Maximum
$mostCalories