using namespace System.Collections.Generic
using namespace System.Collections

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

class FirstTurn{
    static [List[List[int]]]getBoard(){
        $board_size = 20
        $board = [GenerateBoard]::randomBoard($board_size)
        return $board | flatten | map({ $_.value__ }) | convert1DTo2D($board_size) | toGenericList("List[int]")
    }        
}