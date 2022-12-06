#!/usr/bin/env pwsh

$content = Get-Content -Path .\input.txt -Raw
$l = 14
for ($i = 0; $i -lt $content.Length - $l; $i++) {
    $subStr = $content.Substring($i, $l)
    $subStrArr = @($subStr -split '').Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
    $uniqueArr = $subStrArr | Sort-Object | Get-Unique
    if($uniqueArr.Count -eq $l) {
        $($i + $l)
        break
    }
}