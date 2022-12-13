#!/usr/bin/env pwsh

function Get-Hand {
    param (
        [Parameter(Mandatory = $true)][string]$OpponentHand, 
        [Parameter(Mandatory = $true)][string]$Strategy
    )
    switch ($Strategy) {
        'draw' {
            return $OpponentHand
        }
        'win' {
            switch ($OpponentHand) {
                'rock' {
                    return 'paper'
                }
                'paper' {
                    return 'scissors'
                }
                'scissors' {
                    return 'rock'
                }
            }
        }
        'loss' {
            switch ($OpponentHand) {
                'rock' {
                    return 'scissors'
                }
                'paper' {
                    return 'rock'
                }
                'scissors' {
                    return 'paper'
                }
            }
        }
    }
}

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

    $outcome = switch ($inputs[1]) {
        'X' { 'loss' }
        'Y' { 'draw' }
        'Z' { 'win' }
    }

    $mine = Get-Hand -OpponentHand $opponent -Strategy $outcome

    $score = Get-Score -Hand $mine -Outcome $outcome
    $totalScore += $score

    $index++
}

Write-Output $totalScore