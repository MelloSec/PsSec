function Os-Scan {
    nmap -O --osscan-guess -sV -vv -oN _nmap_tcp_quick $ip
}

function SV-Scan {
    nmap -sV -sC -A -vv -oN _nmap_tcp_asc $ip
}

function Tcp-Scans {
    $scan1 = nmap -sV -sC -A -vv $ip
    $scan2 = nmap -sV -sC -p- -T4 -vv $ip
    $scans = $scan1,$scan2
    $Results  = New-Item tcp-scans.txt 
    Set-Content $scans -Path $Results.Name
}

function Old-Tcp {
    nmap -sV -sC -A -vv -oN _nmap_tcp_asc $ip
    nmap -sV -sC -p- -T4 -vv -oN _nmap_tcp_p $ip
}

function su-scan {
    nmap -sU -Pn -vv --top-ports 1000 -oN _nmap_su $ip
}
function udp-scans {
    $scan1 = nmap -sU -Pn -vv --top-ports 1000 $ip
    $scan2 = nmap -sU -Pn vv -T4 --max-retries 0 $ip
    $scans = $scan1,$scan2
    $Results  = New-Item udp-scans.txt 
    Set-Content $scans -Path $Results.Name
}

function Old-Udp {
    nmap -sU -vv --top-ports 1000 -oN _nmap_udp_1000 $ip
    nmap -sU --Pn vv -T4 --max-retries 0 -oN _nmap_udp_2 $ip
}


function Long-Scans {
    nmap -sC -sV -A -p- -T4 -vv -oN _nmap_tcp_full $ip
    nmap -sU --top-ports 5000 -oN sudo_nmap_udp_5000 $ip
}

function SMB-Quick {
    nmap -vv --script=smb-os-discovery,smb-enum-shares,smb-enum-users -oN _nmap_smb_quick $ip
}

function SMB-Vuln {
    nmap -p 139,445 -vv --script=smb-vuln-cve2009-3103,smb-vuln-ms06-025,smb-vuln-ms07-029,smb-vuln-ms08-067,smb-vuln-ms10-054,smb-vuln-ms10-061,smb-vuln-ms17-010 -oN _nmap_smb_cve $ip
    nmap -p 139,445 -vv -T4 -oN _nmap_smb_vulns -Pn --script 'not brute and not dos and smb-*' -vv -d $ip
}

function SMB-Users {
    nmap -vv --script smb-enum-users.nse -p445 -oN _nmap_smbusers $ip
}

function SMB-Shares {
    nmap -vv --script=smb-enum-shares -p445 -oN _nmap_smb_shares $ip
}

function SMB-Sessions {
    nmap -vv --script=smb-enum-sessions -p445 -oN _nmap_smb_sessions $ip
}

function NFS-Quick {
    nmap -v -p 111 -oN _nmap_nfs $ip
}

function Enum-Shares {
    nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions -p445 -oN _nmap_enum_shares $ip
    nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions --script-args smbuser=username,smbpass=password -p445 -oN _nmap_enum_shares2 $ip 
}
 
function Enum-NFS {
    nmap -v -p 111  -oN _nmap_rpcbind $ip
    nmap -sV -p 111 --script=rpcinfo,nfs* -oN _nmap_enum_nfs $ip 
}

function Enum-SNMP {
    nmap -sU --open -p 161 -oN _nmap_open_snmp $ip
}

function scan-subnet {
    nmap -T5 -n -sn -oN _nmap_subnet $ip 
}
function Intense-5000 {
    nmap -A -p 1-5000 -vvv -oN _nmap_5000 $ip
}

function Ping-Sweep {
    nmap -sP -oN _nmap_ping_sweep $ip
}

function Force-Scan {
    nmap -vvv -Pn -A -oN _nmap_force $ip
}