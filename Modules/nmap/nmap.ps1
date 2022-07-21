function os-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -O --osscan-guess -sV -vv -oN _nmap_os_scan $ip
}

function svc-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )    
    nmap -Pn -sV -sC -A -vv -oN _nmap_tcp_sv $ip
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

function sup-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -n -sn $ip -oG - | awk '/Up$/{print $2}'
}

function svp-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -Pn -p- -sV -sC -A -vv -oN _nmap_svp $ip
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

function su1k-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sU -p- -Pn --top-ports 1000 -oN _nmap_su1k $ip
}


function suc-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sUCV -Pn -vv --top-ports 1000 -oN _nmap_suc $ip
}

function suv-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sUV -Pn -p- -T4 --max-retries 0 --top-ports 1000 -oN _nmap_psuv $ip
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

function sn-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -T5 -sn -oA UP $ip | grep Up | cut -d ' ' -f 2
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
