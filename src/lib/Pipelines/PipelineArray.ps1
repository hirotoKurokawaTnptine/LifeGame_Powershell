using namespace System.Collections
Using namespace System.Collections.Generic

$ErrorActionPreference = "Stop"  # コマンド異常時にスクリプトを終了する
Set-StrictMode -Version latest

$pipelineFunc = Join-Path $PSScriptRoot "HigherOrderFunctions.ps1"
. $pipelineFunc

function flatten(){
    process{
        if($_ -is [Object[]] -or $_ -is [ICollection]) { 
            return $_ | flatten 
        }
        else{ return $_ }
    }
}

function flatDepth([int]$depth) {
    process{
        if($depth -le 0) { return ,$_ }
        elseif($depth -gt 1) { return $_ | flatDepth ($depth-1) }
        else { return $_ }
    }
}

function toArrayList() {
    begin{$l = [ArrayList]::new()}
    process{$l.Add($_)}
    end{,$l}
}

function toGenericList([string]$T){
    begin{
        $l = New-Object "List[$T]"
        $flatListTypeStr = { param([string]$strT) 
            if($strT -match "List\[(.*)\]"){ return $Matches[1] } 
        }
    }
    process{
        $isCollect = $_ -is [Array] -or $_ -is [ICollection]
        if($isCollect -and $T.Contains("List[")){ $l.Add(($_ | toGenericList(&$flatListTypeStr($T)) )) }
        else{$l.Add($_)}
    }
    end{,$l}
}

function wrapElmInArray(){
    process{
        if($_ -is [Array] -or $_ -is [ICollection]) { return ,$_ }
        return ,@(,$_)
    }
}
<#
function convert1DTo2D([int]$cols){
    begin{[ArrayList]$l=@()}
    process{$l.Add($_) | Out-Null}
    end{
        0..($l.Count-1) | filtr({ $_%$cols -eq 0 }) | Map({ ,$l[[int]$_..([int]$_+$cols-1)]})
    }
}
#>

function convert1DTo2D([int]$cols){
    begin{
        [ArrayList]$l=@()
        [ArrayList]$xl=@()
    }
    process{
        $xi = $xl.Add($_)
        if(($xi+1)%$cols -eq 0){[void]$l.Add([Object[]]$xl);$xl=@()}
    }
    end{[Object[]]$l}
}