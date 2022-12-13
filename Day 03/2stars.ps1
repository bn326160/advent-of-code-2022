#!/usr/bin/env pwsh

function Reduce($initial, $sb)
{
  begin { $result = $initial }
  process { $result = & $sb $result $_ }
  end { $result }
}

$content = Get-Content -Path .\input.txt -Raw
$rucksacks = @($content -split [System.Environment]::NewLine)

$groups = @()
$index = 1
foreach ($rucksack in $rucksacks) {
    switch ($index % 3) {
        1 {
            $group = @($rucksack)        
        }
        2 {
            $group += $rucksack
        }
        0 {
            $group += $rucksack
            $groups += ,@($group)
        }
    }
    $index++
}

$commonChars = @()
foreach ($group in $groups) {
    $firstTwoCommonChars = @()
    foreach ($char in [char[]]$group[0]) {
        if ($group[1].IndexOf($char) -ne -1) {
            $firstTwoCommonChars += $char
        }
    }
    foreach ($char in $firstTwoCommonChars) {
        if ($group[2].IndexOf($char) -ne -1) {
            $commonChars += $char
            break
        }
    }

}

$values = @()
foreach ($char in $commonChars) {
    if ($char -cmatch "^[a-z]*$") {
        # Lowercase
        $values += [byte][char]$char - 96
    } else {
        # Uppercase
        $values += [byte][char]$char - 38
    }
}

$sum = $values | Reduce 0 { param($x, $y) $x + $y }
$sum