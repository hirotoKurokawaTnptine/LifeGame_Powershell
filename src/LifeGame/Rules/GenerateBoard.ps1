using namespace System.Collections.Generic
using namespace System.Collections

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

$srcDir = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$pipelineDir = Join-Path $srcDir "lib\Pipelines\*"
foreach($f in (Get-ChildItem $pipelineDir -Include "*.ps1")) {
    . $f.FullName
}
. "$($PSScriptRoot)\State.ps1"

class GenerateBoard {
    static [List[List[State]]]randomBoard([int]$board_size) {
        $rnd = [System.Random]::new()
        return 1..$board_size | map({ $rnd.GetItems(@([State]::ALIVE,[State]::DEAD), $board_size) }) `
            | toGenericList("List[State]")
    }
}