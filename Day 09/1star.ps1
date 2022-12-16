#!/usr/bin/env pwsh

$DebugPreference = 'Continue'

class Move {
    [string]$Direction
    [int]$Steps
}

class Position {
    [int]$x = 0
    [int]$y = 0
}

$content = Get-Content -Path .\sample.txt -Raw
$lines = @($content -split [System.Environment]::NewLine)

$moves = New-Object Collections.Generic.List[Move]
foreach ($line in $lines) {
    $split = $line -Split ' '
    $move = [Move]::new()
    $move.Direction = $split[0]
    $move.Steps = [int]$split[1]
    $moves.Add($move)
}

$previousDirections = @([string]::Empty,[string]::Empty)
function Process-Step($direction) {
    Write-Debug "Process-Step $direction"
    $beforeLast, $last = $previousDirections
    if (!$beforeLast) {
        if (!$last) {
            
        } else {
            switch ($direction) {
                "R" {
                    Write-Debug "R $($position.x)"
                    $position.x++
                }
                "L" {
                    $position.x--
                }
            }
        }
    }
    $previousDirections = @($last, $direction)
    Write-Debug "New previousDirections $($previousDirections[0]), $($previousDirections[1])"
}

function Process-Move($move) {
    for ($i = 0; $i -lt $move.Steps; $i++) {
        Process-Step -Direction $move.Direction
    }
}

$position = [Position]::new()
foreach ($move in $moves) {
    Process-Move -Move $move
    Write-Debug "$($position.x),$($position.y)"
}