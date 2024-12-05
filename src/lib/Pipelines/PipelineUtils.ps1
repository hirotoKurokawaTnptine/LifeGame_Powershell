$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

function withIndex() {
    begin  {$i=0}
    process{ $_ | Add-Member -MemberType NoteProperty Index $i; ,$_; $i++ }
}