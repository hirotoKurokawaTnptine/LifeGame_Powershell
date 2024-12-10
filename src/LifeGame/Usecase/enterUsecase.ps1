$srcDir = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
$pipelineDir = Join-Path $srcDir "lib\Pipelines\*"
foreach($f in (Get-ChildItem $pipelineDir -Include "*.ps1")) {
    . $f.FullName
}

$parentDir = Split-Path $PSScriptRoot -Parent
. "$($parentDir)\Rules\State.ps1"
. "$($parentDir)\Rules\LifeGameRule.ps1"
. "$($parentDir)\Rules\GenerateBoard.ps1"

. "$($PSScriptRoot)\FirstTurn.ps1"
. "$($PSScriptRoot)\NextTurn.ps1"