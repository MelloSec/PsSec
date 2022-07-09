# Dot Source latest functions
function Dotsource-Functions {
    $Path = ".\Functions"
    Get-ChildItem -Path $Path -Filter *.ps1 |ForEach-Object {
        . $_.FullName
    }
}
