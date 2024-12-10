using namespace System.Collections.Generic
using namespace System.Collections

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

$parentDir = Split-Path $PSScriptRoot -Parent
. "$($parentDir)\Rules\GenerateBoard.ps1"
. "$($parentDir)\Rules\State.ps1"

$srcDir = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$pipelineDir = Join-Path $srcDir "lib\Pipelines\*"
foreach($f in (Get-ChildItem $pipelineDir -Include "*.ps1")) {
    . $f.FullName
}

class FirstTurn{
    static [List[List[int]]]getBoard(){
        $board_size = 8
        $board = [GenerateBoard]::randomBoard($board_size)
        return $board | flatten | map({ $_.value__ }) | convert1DTo2D($board_size) | toGenericList("List[int]")
    }        
}

[FirstTurn]::getBoard()