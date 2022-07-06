function nbt-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nbtscan -r $ip 
}

function smbmap-guest {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    smbmap -u "Guest" -p "poop" -H $ip 
}

function Nmb-Lookup {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmblookup -A $ip 
}

function Enum4-basic {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    enum4linux -a -v
}

function Enum4-Deep {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    enum4linux -a -v -d -U -M $ip
}

function smb-list {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    smbclient -L $ip 
}

function smb-playbook {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    function nbt-scan {
        param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
        nbtscan -r $ip 
    }
    $nbtscan = nbt-scan
    function smbmap-guest {
        param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
        smbmap -u "Guest" -p "poop" -H $ip 
    }
    $smbmap = smbmap-guest  
    
    function Nmb-Lookup {
        param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
        nmblookup -A $ip 
    }
    $nmblookup = Nmb-Lookup
    
    function Enum4-basic {
        param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
        enum4linux -a -v $ip
    }
    $enum4 = Enum4-basic
    
    function Enum4-Deep {
        param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
        enum4linux -a -v -d -U -M $ip
    }
    $Enum4Deep = Enum4-Deep
    
    $Results = $nbtscan,$smbmap,$nmblookup,$enum4,$Enum4Deep
    
    New-Item smb-func-results.txt 
    Set-Content $Results -Path smb-func-results.txt
    Write-Output "Scans complete"

}
