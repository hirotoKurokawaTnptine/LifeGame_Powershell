using namespace System.Collections
using namespace System.Collections.Generic

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

. ("$PSScriptRoot\State.ps1")
$srcDir = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$pipelineDir = Join-Path $srcDir "lib\Pipelines\*"
foreach($f in (Get-ChildItem $pipelineDir -Include "*.ps1")) {
    . $f.FullName
}



class LifeGameRule{
    static [List[List[State]]]walledBoard([List[List[State]]]$board){
        [List[List[State]]]$walledList = @()
        [List[State]]$firstAndLastRow = 1..($board[0].Count+2) | map({[State]::WALL}) | toGenericList("State")
        [List[List[State]]]$middleRows = $board | map({[State]::WALL;$_;[State]::WALL}) | toGenericList("List[State]")
        [void]$walledList.Add($firstAndLastRow)
        [void]$walledList.AddRange($middleRows)
        [void]$walledList.Add($firstAndLastRow)
        return $walledList
    }
    
    static [List[State]]adjacentCells([int]$x, [int]$y,[List[List[State]]]$walled){
        $centerCellIndex = 4
        return ($y-1)..($y+1) | flatMap({$walled[$_][($x-1)..($x+1)]}) | `
            withIndex | filtr({$_.Index -ne $centerCellIndex}) | toGenericList("State")
    }

    static [boolean]isBirth([int]$targetCell,[int]$aliveCount){
        return $targetCell -eq [State]::DEAD -and $aliveCount -eq 3
    }
    static [boolean]isSurvive([int]$targetCell,[int]$aliveCount){ 
        return ($targetCell -eq [State]::ALIVE) -and $aliveCount -in 2,3
    }
    static [boolean]isDepopulation([int]$targetCell,[int]$aliveCount){
        return $targetCell -eq [State]::ALIVE -and $aliveCount -le 1
    }
    static [boolean]isOvercrowding([int]$targetCell,[int]$aliveCount){
        return $targetCell -eq [State]::ALIVE -and $aliveCount -ge 4
    }
    
    
}
