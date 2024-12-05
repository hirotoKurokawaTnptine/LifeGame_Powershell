using namespace System.Collections
using namespace System.Collections.Generic

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

function map([Func[Object,Object]]$f) {
    process { ,$f.Invoke($_) }
}

function filtr([Func[Object,Boolean]]$f){
    process { if($f.Invoke($_)){,$_} }
}

function frEach([Func[Object,Object]]$f) {
    process { [void]$f.Invoke($_) }
}

function reduce([Object]$total, [Func[Object,Object,Object]]$f) {
    begin{$t=$total}
    process{$t=$f.Invoke($t,$_)}
    end{,$t}
}

function flatMap([Func[Object,Object]]$f) {
    process {
        $f.Invoke($_) | . { process{ $_ } }
    }
}