using namespace System.Collections.Generic

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

class NextTurn{
    static [List[List[int]]]getBoard([List[List[int]]]$board){
        # 受け取った盤面をState型に変換する
        $board_convertState = $board | flatten | map({ [State]$_ }) | convert1DTo2D($board.Count) | toGenericList("List[State]")
        # 番兵法の盤面に変換
        $walledBoard = [LifeGameRule]::walledBoard($board_convertState)
        # 探索
        [List[List[State]]]$nextBoard = @()
        for($y=1; $y -le $board.Count; $y++){
            [List[State]]$nextBoard_line = @()
            for($x=1; $x -le $board[0].Count; $x++){
                $targetCell = $walledBoard[$y][$x]
                $aliveCount = [LifeGameRule]::aliveCount($x,$y,$walledBoard)
                $isCell = { param($t, $c) 
                    ([LifeGameRule]::isBirth($t, $c) -or [LifeGameRule]::isSurvive($t, $c)) -and
                    -not ([LifeGameRule]::isOvercrowding($t, $c) -and [LifeGameRule]::isDepopulation($t, $c)) 
                }
                $nextCell = ([LifeGameRule]::isNextState($targetCell, $aliveCount)).Invoke($isCell)
                [void]$nextBoard_line.Add($nextCell)
            }
            [void]$nextBoard.Add($nextBoard_line)
        }
        
        return $nextBoard | flatten | map({ $_.value__ }) | convert1DTo2D($nextBoard.Count) | toGenericList("List[int]")
    }
}