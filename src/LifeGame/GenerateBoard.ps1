using namespace System.Collections.Generic
using namespace System.Collections

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

$pipelinePath = Join-Path (Split-Path $PSScriptRoot -Parent) "lib\Pipelines\*"
foreach($f in (Get-ChildItem $pipelinePath -Include "*.ps1")) {
    . $f.FullName
}
. "$($PSScriptRoot)\Rules\State.ps1"

class GenerateBoard {
    static [List[List[State]]]randomBoard([int]$board_size) {
        $rnd = [System.Random]::new()
        return 1..$board_size | map({ $rnd.GetItems(@([State]::ALIVE,[State]::DEAD), $board_size) }) `
            | toGenericList("List[State]")
    }
}