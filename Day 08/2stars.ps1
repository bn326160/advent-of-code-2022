#!/usr/bin/env pwsh

#$DebugPreference = 'Continue'

function Reduce($initial, $sb)
{
  begin { $result = $initial }
  process { $result = & $sb $result $_ }
  end { $result }
}

$content = Get-Content -Path .\input.txt -Raw
$lines = @($content -split [System.Environment]::NewLine)

for ($i = 0; $i -lt $lines.Count; $i++) {
    $lines[$i] = $lines[$i].ToCharArray() | % {iex $_} 
}

function Get-ScenicScore($row, $col) {

    Write-Debug "Tree on column $($col+1), row $($row+1) with height $($lines[$row][$col])"

    $scoreArr = [int[]]::new(4)

    $score = 0
    for ($i = $row; $i -gt 0; $i--) {
        $score++
        if ($i -ne $row -And $lines[$i][$col] -ge $lines[$row][$col]) {
            $score--
            $i = 0
        }
    }
    $scoreArr[0] = $score

    $score = 0
    for ($i = $row; $i -lt $lines.Count; $i++) {
        $score++
        if ($i -ne $row -And $lines[$i][$col] -ge $lines[$row][$col]) {
            $score--
            $i = $lines.Count
        }
    }
    $scoreArr[1] = $score

    $score = 0
    for ($i = $col; $i -gt 0; $i--) {
        $score++
        if ($i -ne $col -And $lines[$row][$i] -ge $lines[$row][$col]) {
            $score--
            $i = 0
        }
    }
    $scoreArr[2] = $score

    $score = -1 # Why?
    for ($i = $col; $i -lt $lines[$row].Count; $i++) {
        $score++
        if ($i -ne $col -And $lines[$row][$i] -ge $lines[$row][$col]) {
            $score--
            $i = $lines[$row].Count
        }
    }
    $scoreArr[3] = $score

    Write-Debug "$scoreArr"

    return $scoreArr | Reduce 1 { param($x, $y) $x * $y }
}


$topScore = 0
$rowI = 0
foreach ($row in $lines) {
    $colI = 0
    foreach ($col in $row) {
        $score = Get-ScenicScore -Row $rowI -Col $colI
        $topScore = if ($score -gt $topScore) { $score } else { $topScore }
        $colI++
    }
    $rowI++
}

Write-Output $topScore