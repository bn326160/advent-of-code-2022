#!/usr/bin/env pwsh

function Get-Score {
    param (
        [Parameter(Mandatory = $true)][string]$Hand, 
        [Parameter(Mandatory = $true)][string]$Outcome
    )
    $s = 0
    switch ($Outcome) {
        'draw' {
            $s += 3
        }
        'win' {
            $s += 6
        }
    }
    switch ($Hand) {
        'rock' {
            $s += 1
        }
        'paper' {
            $s += 2
        }
        'scissors' {
            $s += 3
        }
    }
    return $s;
}

function Get-Outcome {
    param (
        [Parameter(Mandatory = $true)][string]$Opponent, 
        [Parameter(Mandatory = $true)][string]$Mine
    )
    function Get-HandIndex {
        param (
            [Parameter(Mandatory = $true)][string]$Hand
        )
        $index = switch($Hand) {
            'rock' { 0 }
            'paper' { 1 }
            'scissors' { 2 }
        }
        return $index
    }
    $row = Get-HandIndex -Hand $Opponent
    $col = Get-HandIndex -Hand $Mine
    $lookup = @(
        # rock, paper, scissors
        @('draw', 'win', 'loss'), # rock
        @('loss', 'draw', 'win'), # paper
        @('win', 'loss', 'draw') # scissors
        )
    return $lookup[$row][$col]
}

$content = Get-Content -Path .\input.txt -Raw
$dataRows = @($content -split [System.Environment]::NewLine)

$totalScore = 0

$index = 1
foreach ($row in $dataRows) {
    $inputs = $row.split(' ')
    
    $opponent = switch ($inputs[0]) {
        'A' { 'rock' }
        'B' { 'paper' }
        'C' { 'scissors' }
    }

    $mine = switch ($inputs[1]) {
        'X' { 'rock' }
        'Y' { 'paper' }
        'Z' { 'scissors' }
    }

    $outome = Get-Outcome -Opponent $opponent -Mine $mine

    $score = Get-Score -Hand $mine -Outcome $outome
    $totalScore += $score

    $index++
}

Write-Output $totalScore