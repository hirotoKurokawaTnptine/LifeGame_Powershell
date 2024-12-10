using namespace System.Collections.Generic
using namespace System.Collections

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

$RootDir = Split-Path $PSScriptRoot
foreach($f in (Get-ChildItem "$($RootDir)\src\" -Recurse -Include "*.ps1")) {
    . $f.FullName
}

$board = [GenerateBoard]::randomBoard(8)
[NextTurn]::next($board)



