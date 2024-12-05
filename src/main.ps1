using namespace System.Windows.Forms
using namespace System.Collections
using namespace System.Collections.Generic

function timer() {
    [datetime]$startTime = Get-Date
    return { ((Get-Date)-$startTime).TotalSeconds }.GetNewClosure()
}

function mainLoop {
    $rui = $Host.UI.RawUI
    $keyMap = [System.Windows.Forms]::Keys

    while ($true) {
        #画面クリア
        Clear-Host
        
        #盤面更新

        #画面出力
        

        $keyCode = $rui.ReadKey("NoEcho.IncludeKeyDown").VirtualKeyCode

        if($keyCode -eq $keyMap::Escape) { return; }

        #FPS
        Start-Sleep -Seconds (1/60)
    }
}

function main{
    #mainLoop | Out-Null
}
main