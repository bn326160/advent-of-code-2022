#!/usr/bin/env pwsh

$content = Get-Content -Path .\sample.txt -Raw
$array = @($content -split [System.Environment]::NewLine)
