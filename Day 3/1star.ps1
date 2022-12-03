#!/usr/bin/env pwsh

function Reduce($initial, $sb)
{
  begin { $result = $initial }
  process { $result = & $sb $result $_ }
  end { $result }
}

$content = Get-Content -Path .\input.txt -Raw
$rucksacks = @($content -split [System.Environment]::NewLine)

#$commonChars = @()
$values = @()
foreach ($rucksack in $rucksacks) {
    $middleIndex = $rucksack.Length / 2
    $left = $rucksack.SubString(0, $middleIndex)
    $right = $rucksack.SubString($middleIndex)

    foreach ($lChar in [char[]]$left) {
        if ($right.IndexOf($lChar) -ne -1) {
            #$commonChars += $lChar
            if ($lChar -cmatch "^[a-z]*$") {
                # Lowercase
                $values += [byte][char]$lChar - 96
            } else {
                # Uppercase
                $values += [byte][char]$lChar - 38
            }
            break
        }
    }
}
$sum = $values | Reduce 0 { param($x, $y) $x + $y }
$sum