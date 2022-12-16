#!/usr/bin/env pwsh

$DebugPreference = 'Continue'

$content = Get-Content -Path .\input.txt -Raw
$lines = @($content -split [System.Environment]::NewLine)

for ($i = 0; $i -lt $lines.Count; $i++) {
    $lines[$i] = $lines[$i].ToCharArray() | % {iex $_} 
}

function Get-Visibility($row, $col) {

    $val = $lines[$row][$col]
    Write-Debug "Tree on column $($col+1), row $($row+1) with height $val"

    $i = $row
    do {
        if ($i -eq 0) {
            Write-Host "Tree on column $($col+1), row $($row+1) with height $val is visible from the top"
            return $true
        }
        $i--
        if ($lines[$i][$col] -ge $val) {
            break
        }
    } while ($i -ge 0)

    $i = $col
    do {
        if ($i -eq 0) {
            Write-Host "Tree on column $($col+1), row $($row+1) with height $val is visible from the left"
            return $true
        }
        $i--
        if ($lines[$row][$i] -ge $val) {
            break
        }
    } while ($i -ge 0)

    $i = $row
    do {
        if ($i -eq $lines.Count-1) {
            Write-Host "Tree on column $($col+1), row $($row+1) with height $val is visible from the bottom"
            return $true
        }
        $i++
        if ($lines[$i][$col] -ge $val) {
            break
        }
    } while ($i -le $lines.Count-1)

    $i = $col
    do {
        if ($i -eq $lines[$row].Count-1) {
            Write-Host "Tree on column $($col+1), row $($row+1) with height $val is visible from the right"
            return $true
        }
        $i++
        if ($lines[$row][$i] -ge $val) {
            break
        }
    } while ($i -le $lines[$row].Count-1)#>
    
    return $false
}

$visibleTrees = 0
$rowI = 0
foreach ($row in $lines) {
    $colI = 0
    foreach ($col in $row) {
        $visible = Get-Visibility -Row $rowI -Col $colI
        if ($visible) {
            $visibleTrees++
        }
        $colI++
    }
    $rowI++
}

Write-Output $visibleTrees