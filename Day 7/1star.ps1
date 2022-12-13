#!/usr/bin/env pwsh

$DebugPreference = "Continue"

function Reduce($initial, $sb)
{
  begin { $result = $initial }
  process { $result = & $sb $result $_ }
  end { $result }
}

class Item {
    [string]$Name
    [int]$Size
    [string]$Type
    $Children
}

function ProcessLine {
    param (
        [string]$command
    )

    if ($command) {
        Write-Host "Executing: $command (Index: $i)"
        if ($command -like '$ cd *') {
            # Directory
            #Write-Debug "Dir"
            $local:dir = New-Object Item
            $parts = $command -split ' '
            $dir.Name = $parts[2]
            $dir.Type = 'Directory'
            $dir.Children = @()
            $i++
            do {
                $dir.Children += ProcessLine -command $commands[$i]
                $i++
            } until ($commands[$i] -eq '$ cd ..')
            $dir.Size = $dir.Children | % { $_.Size } | Reduce 0 { param($x, $y) $x + $y }
            $allDirs += $dir
            return $dir
        } else {
            # File
            #Write-Debug "File"
            $local:file = New-Object Item
            $parts = $command -split ' '
            $file.Name = $parts[1]
            $file.Type = 'File'
            $file.Size = [int]$parts[0]
            return $file
        }

    }
}

$content = Get-Content -Path .\sample.txt -Raw
$commands = @($content -split [System.Environment]::NewLine)

# Filter useless commands
$commands = $commands | Where { $_ -ne '$ ls' } | Where { $_ -NotLike 'dir *' }
$commands

$i = 0
#$rootDir = ProcessLine -command $commands[$i]

#$rootDir.Children
#$allDirs