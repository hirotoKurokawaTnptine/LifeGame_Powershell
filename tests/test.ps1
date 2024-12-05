using namespace System.Collections.Generic
using namespace System.Collections

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

$RootDir = Split-Path $PSScriptRoot
foreach($f in (Get-ChildItem "$($RootDir)\src\" -Recurse -Include "*.ps1")) {
    . $f.FullName
}

[GenerateBoard]::randomBoard(8) | frEach({ Write-Host $_ })



