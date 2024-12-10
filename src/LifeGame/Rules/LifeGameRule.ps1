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
    #番兵法変換
    static [List[List[State]]]walledBoard([List[List[State]]]$board){
        [List[List[State]]]$walledList = @()
        [List[State]]$firstAndLastRow = 1..($board[0].Count+2) | map({[State]::WALL}) | toGenericList("State")
        [List[List[State]]]$middleRows = $board | map({[State]::WALL;$_;[State]::WALL}) | toGenericList("List[State]")
        [void]$walledList.Add($firstAndLastRow)
        [void]$walledList.AddRange($middleRows)
        [void]$walledList.Add($firstAndLastRow)
        return $walledList
    }
    
    #隣接セル取得
    static [List[State]]adjacentCells([int]$x, [int]$y,[List[List[State]]]$walled){
        $centerCellIndex = 4
        return ($y-1)..($y+1) | flatMap({$walled[$_][($x-1)..($x+1)]}) | `
            withIndex | filtr({$_.Index -ne $centerCellIndex}) | toGenericList("State")
    }
    #生存マス取得
    static [int] aliveCount([int]$x, [int]$y,[List[List[State]]]$walled){
        $adjaCells = [LifeGameRule]::adjacentCells($x, $y, $walled)
        return $adjaCells | filtr({ $_ -eq 'ALIVE' }) | countPipelineElm
    }

    static [Func[Func[State,int,boolean], State]]isNextState([State]$targetCell, [int]$aliveCount){
        return {
            param($f)
            if($f.Invoke($targetCell, $aliveCount)){ return [State]::ALIVE }
            else{ return [State]::DEAD }
        }.GetNewClosure()
    }

    static [boolean]isBirth([State]$targetCell,[int]$aliveCount){
        return $targetCell -eq 'DEAD' -and $aliveCount -eq 3
    }
    static [boolean]isSurvive([State]$targetCell,[int]$aliveCount){ 
        return $targetCell -eq 'ALIVE' -and $aliveCount -in 2,3
    }
    static [boolean]isDepopulation([State]$targetCell,[int]$aliveCount){
        return $targetCell -eq 'ALIVE' -and $aliveCount -le 1
    }
    static [boolean]isOvercrowding([State]$targetCell,[int]$aliveCount){
        return $targetCell -eq 'ALIVE' -and $aliveCount -ge 4
    }  
}
