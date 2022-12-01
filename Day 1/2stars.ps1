#!/usr/bin/env pwsh

function Reduce($initial, $sb)
{
  begin { $result = $initial }
  process { $result = & $sb $result $_ }
  end { $result }
}

$content = Get-Content -Path .\input.txt -Raw

$elfDataArr = @($content -split '(?:\r?\n){2,}')

$sumArr = @()
foreach ($elfData in $elfDataArr)
{
    $caloriesArr = @($elfData -split [System.Environment]::NewLine)
    [array]$numericCaloriesArr = foreach($number in $caloriesArr) {
        try {
            [int]::parse($number)
        }
        catch {
            Invoke-Expression -Command $number;
        }
    }
    $sum = $numericCaloriesArr | Reduce 0 { param($x, $y) $x + $y }
    $sumArr += $sum
}

$sortedSumArr = $sumArr | Sort-Object { [int]$_ } -Descending
$topThree = $sortedSumArr | Select-Object -First 3
$sum = $topThree | Reduce 0 { param($x, $y) $x + $y }
$sum