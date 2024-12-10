using namespace System.Collections
using namespace System.Collections.Generic

Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Keyboard
{
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

$pipelineDir = "$($PSScriptRoot)\lib\Pipelines"
$useCaseDir = "$($PSScriptRoot)\LifeGame\Usecase"
. "$pipelineDir\HigherOrderFunctions.ps1"
. "$pipelineDir\PipelineArray.ps1"
. "$useCaseDir\enterUsecase.ps1"

$VK_ESCAPE = 0x1B

function timer() {
    [datetime]$startTime = Get-Date
    return { ((Get-Date)-$startTime).TotalSeconds }.GetNewClosure()
}

function mainLoop {

    $board = [FirstTurn]::getBoard()
    
    while ($true) {
        $stopWatch = timer

        #画面クリア
        Clear-Host
        #画面出力
        ($board | flatten | map({ if($_ -eq 1){ "■" }else{ " " } })) | convert1DTo2D($board.Count) | frEach({ Write-Host ($_ -join "") })
        #盤面更新
        $board = [NextTurn]::getBoard($board)

        #キー入力監視
        $keyState = [Keyboard]::GetAsyncKeyState($VK_ESCAPE)
        if($keyState -ne 0) { return }

        #FPS
        $stopTime = &$stopWatch
        $fps = 1/60
        Start-Sleep -Seconds $(if(($fps-$stopTime) -lt 0){ 0 })
    }
}

function main{
    mainLoop | Out-Null
}
main