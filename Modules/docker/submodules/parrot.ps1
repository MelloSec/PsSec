# Run bettercap 
function Run-Bettercap {
    param(
        [Parameter(Mandatory=$false)]
        [string]$ip
    )
    docker run --rm -ti parrotsec/tools-bettercap
}
# Run sqlmap
function Run-Sqlmap {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti parrotsec/tools-sqlmap -u $ip
}
# Sqlmap Wizard
function Run-SqlWiz {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti parrotsec/tools-sqlmap -u $ip --wizard
}


