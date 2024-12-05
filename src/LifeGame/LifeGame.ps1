using namespace System.Collections
using namespace System.Collections.Generic

$pipelineFunc = Join-Path (Split-Path $PSScriptRoot -Parent) "utils\PipelineFunctions.ps1"
. $pipelineFunc

class LifeGameRule{
    static [int]$ALIVE = 1
    static [int]$DEAD = 0

    static [List[List[int]]]walledBoard([List[List[int]]]$board){
        [int]$wall = -1
        [List[List[int]]]$walledList = @()
        [List[int]]$firstAndLastRow = 1..($board[0].Count+2) | map({$wall}) | toGenericList("int")
        [List[List[int]]]$middleRows = $board | map({$wall;$_;$wall}) | toGenericList("List[int]")
        $walledList.Add($firstAndLastRow)
        $walledList.AddRange($middleRows)
        $walledList.Add($firstAndLastRow)
        return $walledList
    }
    
    static [List[int]]adjacentCells([int]$x, [int]$y,[List[List[int]]]$walled){
        return ($y-1)..($y+1) | flatMap({$walled[$_][($x-1)..($x+1)]}) | withIndex | filtr({$_.Index -ne 4}) | toGenericList("int")
    }

    static [boolean]isBirth([int]$targetCell,[List[int]]$adjaCells){
        return ($targetCell -eq [LifeGameRule]::DEAD) -and ($adjaCells | filtr({ $_ -eq [LifeGameRule]::ALIVE })).Count -eq 3
    }
    static [boolean]isSurvive(){ return $false }
    static [boolean]isDepopulation(){ return $false }
    static [boolean]isOvercrowding(){ return $false }
    
    
}
#-1 -1 -1 -1 -1 -1 -1 -1 -1 -1
#-1  0  0  0  0  0  0  0  0 -1
#-1  1  1  1  1  1  1  1  1 -1
#-1  2  2  2  2  2  2  2  2 -1
#-1 -1 -1 -1 -1 -1 -1 -1 -1 -1

[List[List[int]]]$list = @(0,0,0,0,0,0,0,0),@(1,0,1,1,1,1,1,1),@(0,0,0,0,0,0,0,0) | toGenericList("List[int]")
$walled = [LifeGameRule]::walledBoard($list)
$aja    = [LifeGameRule]::adjacentCells(2,2,$walled)
[LifeGameRule]::isBirth(0, $aja)
($walled | flatMap({$_})).Count
