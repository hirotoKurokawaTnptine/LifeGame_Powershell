function importModuleDirectory([string]$dirPath){
    Get-ChildItem (Join-Path $dirPath "*") -Include "*.ps1" | `
        . { process{ $_.FullName } }
}