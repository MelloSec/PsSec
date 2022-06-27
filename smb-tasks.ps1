function nbt-scan {
    nbtscan -r $ip 
}
$nbtscan = nbt-scan
function smbmap-guest {
    smbmap -u "Guest" -p "poop" -H $ip 
}
$smbmap = smbmap-guest  

function Nmb-Lookup {
    nmblookup -A $ip 
}
$nmblookup = Nmb-Lookup

function Enum4-basic {
    enum4linux -a -v
}
$enum4 = Enum4-basic

function Enum4-Deep {
    enum4linux -a -v -d -U -M $ip
}
$Enum4Deep = Enum4-Deep

$Results = $nbtscan,$smbmap,$nmblookup,$enum4,$Enum4Deep

New-Item smb-func-results.txt 
Set-Content $Results -Path smb-func-results.txt