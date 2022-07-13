function os-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -O --osscan-guess -sV -vv -oN _nmap_os_scan $ip
}

function sv-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )    
    nmap -sV -sC -A -vv -oN _nmap_tcp_sv $ip
}

function sn-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sN -oN _nmap_sn $ip
}
function sp-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sP -oN _nmap_sp $ip
}

function psv-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -Pn -p- -sV -sC -A -vv -oN _nmap_psv $ip
}


function tcp-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    $scan1 = nmap -sV -sC -A -Pn -vv $ip
    $scan2 = nmap -sV -sC -Pn -p- -T4 -vv $ip
    $scans = $scan1,$scan2
    $Results  = New-Item tcp-scan.txt 
    Set-Content $scans -Path $Results.Name
}

function vulners-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -Pn -sV -vv --script vulners --script-args mincvss=5.0 -oN _nmap_vulners $ip
}

function old-tcp {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sV -sC -A -vv -oN _nmap_tcp_asc $ip
    nmap -sV -sC -p- -T4 -vv -oN _nmap_tcp_p $ip
}

function su-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sU -Pn -vv --top-ports 1000 -oN _nmap_su $ip
}

function psu-scan {
    nmap -sU -p- -Pn -
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )vv --top-ports 1000 -oN _nmap_psu $ip
}

function suv-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sUV -Pn -vv --top-ports 1000 -oN _nmap_suv $ip
}
function suc-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sUCV -Pn -vv --top-ports 1000 -oN _nmap_suc $ip
}

function psuv-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sUV -Pn -p- -vv -T4 --max-retries 0 --top-ports 1000 -oN _nmap_psuv $ip
}
function udp-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    $scan1 = nmap -sU -Pn -vv --top-ports 1000 $ip
    $scan2 = nmap -sU -Pn vv -T4 --max-retries 0 $ip
    $scans = $scan1,$scan2
    $Results  = New-Item udp-scan.txt 
    Set-Content $scans -Path $Results.Name
}

function old-udp {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sU -vv --top-ports 1000 -oN _nmap_udp_1000 $ip
    nmap -sU --Pn vv -T4 --max-retries 0 -oN _nmap_udp_2 $ip
}


function long-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sC -sV -A -p- -T4 -vv -oN _nmap_tcp_full $ip
    nmap -sU --top-ports 5000 -oN sudo_nmap_udp_5000 $ip
}

function smb-quick {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv --script=smb-os-discovery,smb-enum-shares,smb-enum-users -oN _nmap_smb_quick $ip
}

function smb-vuln {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -p 139,445 -vv --script=smb-vuln-cve2009-3103,smb-vuln-ms06-025,smb-vuln-ms07-029,smb-vuln-ms08-067,smb-vuln-ms10-054,smb-vuln-ms10-061,smb-vuln-ms17-010 -oN _nmap_smb_cve $ip
    nmap -p 139,445 -vv -T4 -oN _nmap_smb_vulns -Pn --script 'not brute and not dos and smb-*' -vv -d $ip
}

function smb-users {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv --script smb-enum-users.nse -p445 -oN _nmap_smbusers $ip
}

function smb-shares {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv --script=smb-enum-shares -p445 -oN _nmap_smb_shares $ip
}

function smb-sessions {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv --script=smb-enum-sessions -p445 -oN _nmap_smb_sessions $ip
}

function nfs-scan{
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -v -p 111 --script=rpcinfo,nfs* -oN _nmap_nfs $ip
}

function enum-shares {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions -p445 -oN _nmap_enum_shares $ip
    nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions --script-args smbuser=username,smbpass=password -p445 -oN _nmap_enum_shares2 $ip 
}
 

function enum-snmp {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sU --open -p 161 -oN _nmap_open_snmp $ip
}

function subnet-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -T5 -n -sn -oN _nmap_subnet $ip 
}
function 5000-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -Pn -A -p 1-5000 -vvv -oN _nmap_5000 $ip
}

function ping-sweep {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sP -oN _nmap_pingsweep $ip
}

function force-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vvv -Pn -p- -sV -sC -A -oN _nmap_force $ip
}
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

function enum4docker-as {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run -t enum4linux-ng -As $ip > enum4ng-as.txt
}

function enum4docker-a {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run -t enum4linux-ng -A $ip > enum4ng-a.txt
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
function Invoke-Vulscan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv -sV -Pn --script --script=vulscan/vulscan.nse -oA vulscan $ip
}
function Invoke-Vulners {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
}

function Invoke-Vuln {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -Pn -sV --script vuln -oA vuln $ip
}
function Double-Vuln {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    function Invoke-Vulscan {
        nmap -vv -sV -Pn --script=vulscan/vulscan.nse -oA vulscan $ip
    }
    function Invoke-Vulners {
        nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
    }
    Invoke-Vulscan
    Invoke-Vulners
}

function Triple-Vuln {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    function Invoke-Vulscan {
        $scan1 = nmap -vv -sV -Pn --script=vulscan/vulscan.nse $ip
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
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    function Invoke-Vulscan {
        $scan1 = nmap -vv -sV -p- -Pn -oA vulscan --script --script=vulscan/vulscan.nse $ip
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
$userlist = Get-Content 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\GitHubProjects\PsSec\Modules\mysql\mysql-user.txt'
$passlist = Get-Content 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\GitHubProjects\PsSec\Modules\mysql\mysql-pass.txt'

function mysql-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sV -p 3306 --script mysql-audit,mysql-databases,mysql-dump-hashes,mysql-empty-password,mysql-enum,mysql-info,mysql-query,mysql-users,mysql-variables,mysql-vuln-cve2012-2122 -oN _nmap_mysql-scan $ip
}

function mysql-brute {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv -p 3306 -Pn --script ms-sql-brute --script-args userdb=$userlist,passdb=$passlist $ip
}
# need a vanilla
function web-go {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip  
    )    
    gobuster dir -u http://$ip -w 'C:\Users\RleeA\wordlists\common.txt' -o common.txt
}

# gobuster has vhost mode
function web-vhost {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip,
        [Parameter(Mandatory=$true)]
        [string]$word  
    )
    gobuster -v vhost -u http://$ip -w $word -o govhost.txt
}

# gobuster has dns mode
function web-dns {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip,
        [Parameter(Mandatory=$true)]
        [string]$word
    )
    gobuster -v dns http://$ip -w $word -o godns.txt
}

# a php specific that will use both go and ferox
function web-php {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip,
        [Parameter(Mandatory=$true)]
        [string]$word  
    )
    gobuster dir http://$ip -w $word -o gophp.txt -x php,php3,php5,html
    feroxbuster 
}

# # try and get something to work well with zap
# func zap-scan

# # nikto scan
# func nikto-scan

$domain = "$ip"
$uri = "https://$domain"

function testssl {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 $uri
}

function testssl-p {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 --parallel $uri
}
function testssl-e {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -e $uri
}

function testssl-epf {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -e --parallel --fast  $uri
}

function testssl-p {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -p $uri
}
function testssl-ppf {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -p --parallel --fast  $uri
}

function testssl-t {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -t $uri
}

function testssl-tpf {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -t --parallel --fast  $uri
}

# Enum4linux-ng All-Simple
function enum4docker-as {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -As $ip -oA enum4docker-as
}

# Enum4linux-ng All + enumerate services
function enum4docker-ac {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -A -C $ip -oA enum4docker-ac
}

function enum4docker-user {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -A -u Tester -p 'Passin!' $ip -oA enum4docker-user 
}

function enum4docker-damn {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -A -C -S -G -Gm -U -N -P -d -v $ip -oA enum4docker-damn 
}

function kali-bash {
    docker run -ti kalilinux/kali-rolling /bin/bash
}
