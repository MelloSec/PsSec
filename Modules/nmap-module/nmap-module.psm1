function os-scan {
    nmap -O --osscan-guess -sV -vv -oN _nmap_tcp_quick $ip
}

function sv-scan {
    nmap -sV -sC -A -vv -oN _nmap_tcp_asc $ip
}


function tcp-scan {
    $scan1 = nmap -sV -sC -A -vv $ip
    $scan2 = nmap -sV -sC -Pn -p- -T4 -vv $ip
    $scans = $scan1,$scan2
    $Results  = New-Item tcp-scans.txt 
    Set-Content $scans -Path $Results.Name
}

function vulners-scan {
    nmap -Pn -sV -vv --script vulners --script-args mincvss=5.0 -oN _nmap_vulner $ip
}

function old-tcp {
    nmap -sV -sC -A -vv -oN _nmap_tcp_asc $ip
    nmap -sV -sC -p- -T4 -vv -oN _nmap_tcp_p $ip
}

function su-scan {
    nmap -sU -Pn -vv --top-ports 1000 -oN _nmap_su $ip
}

function suv-scan {
    nmap -sUV -Pn -vv --top-ports 1000 -oN _nmap_suv $ip
}
function suv-scan {
    nmap -sUV -Pn -p- -vv -T4 --max-retries 0 --top-ports 1000 -oN _nmap_suvp $ip
}
function udp-scan {
    $scan1 = nmap -sU -Pn -vv --top-ports 1000 $ip
    $scan2 = nmap -sU -Pn vv -T4 --max-retries 0 $ip
    $scans = $scan1,$scan2
    $Results  = New-Item udp-scans.txt 
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
    nmap -sP -oN _nmap_ping_sweep $ip
}

function force-scan {
    nmap -vvv -Pn -p- -sV -sC -A -oN _nmap_force $ip
}