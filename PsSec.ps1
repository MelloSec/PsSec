function os-scan {
    nmap -O --osscan-guess -sV -vv -oN _nmap_os_scan $ip
}

function sv-scan {
    nmap -sV -sC -A -vv -oN _nmap_tcp_sv $ip
}

function psv-scan {
    nmap -Pn -p- -sV -sC -A -vv -oN _nmap_psv $ip
}


function tcp-scan {
    $scan1 = nmap -sV -sC -A -Pn -vv $ip
    $scan2 = nmap -sV -sC -Pn -p- -T4 -vv $ip
    $scans = $scan1,$scan2
    $Results  = New-Item tcp-scan.txt 
    Set-Content $scans -Path $Results.Name
}

function vulners-scan {
    nmap -Pn -sV -vv --script vulners --script-args mincvss=5.0 -oN _nmap_vulners $ip
}

function old-tcp {
    nmap -sV -sC -A -vv -oN _nmap_tcp_asc $ip
    nmap -sV -sC -p- -T4 -vv -oN _nmap_tcp_p $ip
}

function su-scan {
    nmap -sU -Pn -vv --top-ports 1000 -oN _nmap_su $ip
}

function psu-scan {
    nmap -sU -p- -Pn -vv --top-ports 1000 -oN _nmap_psu $ip
}

function suv-scan {
    nmap -sUV -Pn -vv --top-ports 1000 -oN _nmap_suv $ip
}
function psuv-scan {
    nmap -sUV -Pn -p- -vv -T4 --max-retries 0 --top-ports 1000 -oN _nmap_psuv $ip
}
function udp-scan {
    $scan1 = nmap -sU -Pn -vv --top-ports 1000 $ip
    $scan2 = nmap -sU -Pn vv -T4 --max-retries 0 $ip
    $scans = $scan1,$scan2
    $Results  = New-Item udp-scan.txt 
    Set-Content $scans -Path $Results.Name
}

function old-udp {
    nmap -sU -vv --top-ports 1000 -oN _nmap_udp_1000 $ip
    nmap -sU --Pn vv -T4 --max-retries 0 -oN _nmap_udp_2 $ip
}


function long-scan {
    nmap -sC -sV -A -p- -T4 -vv -oN _nmap_tcp_full $ip
    nmap -sU --top-ports 5000 -oN sudo_nmap_udp_5000 $ip
}

function smb-quick {
    nmap -vv --script=smb-os-discovery,smb-enum-shares,smb-enum-users -oN _nmap_smb_quick $ip
}

function smb-vuln {
    nmap -p 139,445 -vv --script=smb-vuln-cve2009-3103,smb-vuln-ms06-025,smb-vuln-ms07-029,smb-vuln-ms08-067,smb-vuln-ms10-054,smb-vuln-ms10-061,smb-vuln-ms17-010 -oN _nmap_smb_cve $ip
    nmap -p 139,445 -vv -T4 -oN _nmap_smb_vulns -Pn --script 'not brute and not dos and smb-*' -vv -d $ip
}

function smb-users {
    nmap -vv --script smb-enum-users.nse -p445 -oN _nmap_smbusers $ip
}

function smb-shares {
    nmap -vv --script=smb-enum-shares -p445 -oN _nmap_smb_shares $ip
}

function smb-sessions {
    nmap -vv --script=smb-enum-sessions -p445 -oN _nmap_smb_sessions $ip
}

function nfs-scan{
    nmap -v -p 111 --script=rpcinfo,nfs* -oN _nmap_nfs $ip
}

function enum-shares {
    nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions -p445 -oN _nmap_enum_shares $ip
    nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions --script-args smbuser=username,smbpass=password -p445 -oN _nmap_enum_shares2 $ip 
}
 

function enum-snmp {
    nmap -sU --open -p 161 -oN _nmap_open_snmp $ip
}

function subnet-scan {
    nmap -T5 -n -sn -oN _nmap_subnet $ip 
}
function 5000-scan {
    nmap -Pn -A -p 1-5000 -vvv -oN _nmap_5000 $ip
}

function ping-sweep {
    nmap -sP -oN _nmap_pingsweep $ip
}

function force-scan {
    nmap -vvv -Pn -p- -sV -sC -A -oN _nmap_force $ip
}
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

function smb-list {
    smbclient -L $ip 
}

function smb-playbook {
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
        enum4linux -a -v $ip
    }
    $enum4 = Enum4-basic
    
    function Enum4-Deep {
        enum4linux -a -v -d -U -M $ip
    }
    $Enum4Deep = Enum4-Deep
    
    $Results = $nbtscan,$smbmap,$nmblookup,$enum4,$Enum4Deep
    
    New-Item smb-func-results.txt 
    Set-Content $Results -Path smb-func-results.txt
    Write-Output "Scans complete"

}
function Invoke-Vulscan {
    nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse -oA vulscan $ip
}
function Invoke-Vulners {
    nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
}

function Invoke-Vuln {
    nmap -Pn -sV --script vuln -oA vuln $ip
}
function Double-Vuln {
    function Invoke-Vulscan {
        nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse -oA vulscan $ip
    }
    function Invoke-Vulners {
        nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
    }
    Invoke-Vulscan
    Invoke-Vulners
}

function Triple-Vuln {
    function Invoke-Vulscan {
        $scan1 = nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse $ip
    }
    function Invoke-Vulners {
        $scan2 = nmap -vv -sV -Pn --script nmap-vulners $ip   
    }
    function Invoke-Vuln {
        $scan3 = nmap -vv -sV -Pn --script vuln  $ip
    }
    Invoke-Vulscan
    Invoke-Vulners
    Invoke-Vuln
    $scans = $scan1,$scan2,$scan3
    $Results  = New-Item triple-vuln.txt 
    Set-Content $scans -Path $Results.Name
}

function Deep-Vuln {
    function Invoke-Vulscan {
        $scan1 = nmap -vv -sV -p- -Pn -oA vulscan --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse $ip
    }
    function Invoke-Vulners {
        $scan2 = nmap -vv -sV -p- -Pn -oA  vulners --script nmap-vulners/ $ip   
    }
    function Invoke-Vuln {
        $scan3 = nmap -vv -sV -p- -Pn -oA vuln --script vuln  $ip
    }
    Invoke-Vulscan
    Invoke-Vulners
    Invoke-Vuln
    $scans = $scan1,$scan2,$scan3
    $Results  = New-Item deep-vuln.txt 
    Set-Content $scans -Path $Results.Name
}
function Get-IPInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ip
    )
    $IPObject = Invoke-RestMethod -Method GET -Uri "https://ipapi.co/$ip/json"

    [PSCustomObject]@{
        IP        =  $IPObject.IP
        City      =  $IPObject.City
        Country   =  $IPObject.Country_Name
        Region    =  $IPObject.Region
        Postal    =  $IPObject.Postal
        TimeZone  =  $IPObject.TimeZone
        ASN       =  $IPObject.asn
        Owner     =  $IPObject.org
    }
}

function Check-NeutrinoBlocklist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ip,
        [Parameter(Mandatory)]
        [string]$userId,
        [Parameter(Mandatory)]
        [string]$apiKey
    )
    $IPObject = Invoke-RestMethod -Method GET -Uri "https://neutrinoapi.net/ip-blocklist?user-id=$userId&api-key=$apiKey&ip=$ip"

    [PSCustomObject]@{

        CIDR                =  $IPObject."cidr"
        IsListed            =  $IPObject."is-listed"
        IsHijacked          =  $IPObject."is-hijacked"
        IsSpider            =  $IPObject."is-spider"
        IsTor               =  $IPObject."is-tor"
        IsProxy             =  $IPObject."is-proxy"
        IsMalware           =  $IPObject."is-malware"
        IsVpn               =  $IPObject."is-vpn"
        IsBot               =  $IPObject."is-bot"
        IsSpamBot           =  $IPObject."is-spam-bot"
        IsExploitBot        =  $IPObject."is-exploit-bot"
        ListCount           =  $IPObject."list-count"
        Blocklists          =  $IPObject."blocklists"
        LastSeen            =  $IPObject."last-seen"
        Sensors             =  $IPObject."sensors"
    }
}

function Get-ReverseIP {
    param(
        [Parameter(Mandatory)]
        [string]$ip
    )
    $URLObject = Invoke-RestMethod -Method GET -Uri "https://api.hackertarget.com/reverseiplookup/?q=151.101.194.159"
}

function Check-NeutrinoUrlInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$userId,
        [Parameter(Mandatory)]
        [string]$apiKey
    )
    $URLObject = Invoke-RestMethod -Method GET -Uri "https://neutrinoapi.net/url-info?user-id=$userid&api-key=$apiKey&url=$url"
}
# $URLCheck = Check-NeutrinoUrlInfo $url $userId $apiKey
# $URLCheck


# Checks your current IP
# Could we make this a switch, so that you either want to look up your own IP first? If not, then we go on to just do a lookup on whatever IP was passed
function Get-MyIp {
    $myip = Invoke-RestMethod -Method GET -Uri "http://ifconfig.me/ip"
    Write-Output "Your IP is $myip"
}

function Find-Me {
    Write-Output "Testing the combine script"
}
$userlist = Get-Content 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\GitHubProjects\PsSec\Modules\mssql\mssql-user.txt'
$passlist = Get-Content 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\GitHubProjects\PsSec\Modules\mssql\mssql-pass.txt'

function mssql-scan {
    nmap -sV -p 3306 --script mysql-audit,mysql-databases,mysql-dump-hashes,mysql-empty-password,mysql-enum,mysql-info,mysql-query,mysql-users,mysql-variables,mysql-vuln-cve2012-2122 -oN _nmap_mssql-scan $ip
}

function mssql-brute {
    nmap -vv -p 3306 -Pn --script ms-sql-brute --script-args userdb=$userlist,passdb=$passlist $ip
}
# need a vanilla
function web-go {
    gobuster dir http://$ip -w $word -o goscan.txt
}

# gobuster has vhost mode
function web-vhost {
    gobuster vhost http://$ip -w $word -o govhost.txt
}

# gobuster has dns mode
function web-dns {
    gobuster dns http://$ip -w $word -o godns.txt
}

# a php specific that will use both go and ferox
function web-php {
    gobuster dir http://$ip -w $word -o gophp.txt -x php,php3,php5,html
    feroxbuster 
}

# # try and get something to work well with zap
# func zap-scan

# # nikto scan
# func nikto-scan

