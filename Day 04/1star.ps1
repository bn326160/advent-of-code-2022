#!/usr/bin/env pwsh

$content = Get-Content -Path .\input.txt -Raw
$pairs = @($content -split [System.Environment]::NewLine)

$totalEncapsulated = 0
foreach ($pair in $pairs) {
    $elves = $pair.Split(',')
    $leftElfRange = $elves[0].Split('-')
    $rightElfRange = $elves[1].Split('-')
    $leftElfArray = $leftElfRange[0]..$leftElfRange[1]
    $rightElfArray = $rightElfRange[0]..$rightElfRange[1]
    $common = $leftElfArray | % { if($rightElfArray.IndexOf($_) -ne -1) { $_ } }
    if ($common.Count -ne 0 -And ($common.Count -eq $leftElfArray.Count -Or $common.Count -eq $rightElfArray.Count)) {
        $totalEncapsulated++
    }
}
$totalEncapsulated