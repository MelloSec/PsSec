function nbt-scan {
    nbtscan -r $ip 
}

function smbmap-guest {
    smbmap -u "Guest" -p "poop" -H $ip 
}

function Nmb-Lookup {
    nmblookup -A $ip 
}

function Enum4-basic {
    enum4linux -a -v
}

function Enum4-Deep {
    enum4linux -a -v -d -U -M $ip
}