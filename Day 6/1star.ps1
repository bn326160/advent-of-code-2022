#!/usr/bin/env pwsh

$content = Get-Content -Path .\input.txt -Raw
for ($i = 0; $i -lt $content.Length - 3; $i++) {
    $subStr = $content.Substring($i, 4)
    $subStrArr = @($subStr -split '').Split('',[System.StringSplitOptions]::RemoveEmptyEntries)
    $uniqueArr = $subStrArr | Sort-Object | Get-Unique
    if($uniqueArr.Count -eq 4) {
        $($i + 4)
        break
    }
}