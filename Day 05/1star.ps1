#!/usr/bin/env pwsh

filter ArrayToHash
{
    begin { $hash = @{} }
    process { $hash[$_] = New-Object Collections.Generic.List[String] }
    end { return $hash }
}

$content = Get-Content -Path .\input.txt -Raw
$splitContent = @($content -split '(?:\r?\n){2,}')
$stacksContent = @($splitContent[0] -split [System.Environment]::NewLine)
$movementsContent = @($splitContent[1] -split [System.Environment]::NewLine)

# Create Hashtables for stacks
$stackHeaders = @($stacksContent[-1] -split '   ') | % { [int]$_.Trim() }
$stacks = $stackHeaders | ArrayToHash

# Fill stacks
for ($i = 0; $i -lt $stackHeaders.Count; $i++)
{
    $row = $stacksContent[$i]
    foreach($col in $stackHeaders) {
        $char = $row[($col - 1) * 4 + 1]
        if ($char -cmatch '[A-Z]') {
            $stacks[$col].Add($char)
        }
    }
}
#$stacks

# Perform movements
foreach ($movement in $movementsContent) {
    $movDeconstr = @($movement -split ' ')
    $count = [int]$movDeconstr[1]
    $from = [int]$movDeconstr[3]
    $to = [int]$movDeconstr[5]
    if ($count -gt $stacks[$from].Count) {
        Write-Host "Stack $from too small for movement '$movement'"
        break
    }

    for ($i = 0; $i -lt $count; $i++) {
        $item = $stacks[$from][0] # Get first (top) item from stack
        $stacks[$to].Insert(0, $item) # Prepend in to-stack
        $stacks[$from].RemoveAt(0) # Remove frist element of list
    }
}
$stacks

foreach ($header in $stackHeaders) {
    Write-Host -NoNewline $stacks[$header][0]
}