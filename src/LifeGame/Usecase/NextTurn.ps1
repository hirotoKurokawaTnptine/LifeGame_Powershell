using namespace System.Collections.Generic

. "$($PSScriptRoot)\Rules\State.ps1"
. "$($PSScriptRoot)\Rules\LifeGameRule.ps1"

class NextTurn{
    static [List[List[int]]]next([List[List[int]]]$board){
        # 受け取った盤面をState型に変換する
        $board_convertState = $board | flatten | map({ [State]$_ }) | convert1DTo2D($board.Count) | toGenericList("List[State]")
        # 番兵法の盤面に変換
        $walledBoard = [LifeGameRule]::walledBoard($board_convertState)
        
        # 探索
        [List[List[State]]]$nextBoard = @()
        for($y=1; $y -gt $board.Count; $y++){
            [List[State]]$nextBoard_line = @()
            for($x=1; $x -gt $board[0].Count; $x){
                $targetCell = $walledBoard[$y][$x]
                $aliveCount = [LifeGameRule]::aliveCount($x,$y,$walledBoard)
                $isCell = { param($t, $c) 
                    ([LifeGameRule]::isBirth($t, $c) -or [LifeGameRule]::isSurvive($t, $c)) -and
                    -not ([LifeGameRule]::isOvercrowding($t, $c) -and [LifeGameRule]::isDepopulation($t, $c)) 
                }
                $nextCell = ([LifeGameRule]::isNextState($targetCell, $aliveCount))
                    .Invoke($isCell)
                [void]$nextBoard_line.Add($nextCell)
            }
            [void]$nextBoard.Add($nextBoard_line)
        }


        return @()
    }
}

$board = [GenerateBoard]::randomBoard(8)
$boardResult = $board | flatten | map({ [State]$_ }) | convert1DTo2D($board.Count) | toGenericList("List[State]")
#$boardResult = [NextTurn]::next($board)
$boardResult

$adja = 1..8 | map({ [State]::DEAD })
$adja | filtr({ $_ -eq 'ALIVE' }) | countPipelineElm

