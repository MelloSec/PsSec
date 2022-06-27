function dbQuick-Scan {
    db_nmap -O --osscan-guess -sV -vv -oN _nmap_tcp_quick $ip
}

function dbTcp-Scans {
    db_nmap -sV -sC -A -vv -oN _nmap_tcp_asc $ip
    db_nmap -sV -p- -T4 -vv -oN _nmap_tcp_p $ip
}

function dbudp-scans {
    db_nmap -sU -vv --top-ports 1000 -oN _nmap_udp_1000 $ip
    db_nmap -sU --Pn vv -T4 --max-retries 0 -oN _nmap_udp_2 $ip
}

function dbLong-Scans {
    db_nmap -sC -sV -A -p- -T4 -vv -oN _nmap_tcp_full $ip
    db_nmap -sU --top-ports 1000 -oN _nmap_udp_1000 $ip
}

function dbSMB-Quick {
    db_nmap -vv --script=smb-os-discovery,smb-enum-shares,smb-enum-users -oN _nmap_smb_scan $ip
}

function dbSMB-Vuln {
    db_nmap -p 139,445 -vv --script=smb-vuln-cve2009-3103,smb-vuln-ms06-025,smb-vuln-ms07-029,smb-vuln-ms08-067,smb-vuln-ms10-054,smb-vuln-ms10-061,smb-vuln-ms17-010 -oN _nmap_smb_cve $ip
    db_nmap -p 139,445 -vv -T4 -oN smb_vulns -Pn --script 'not brute and not dos and smb-*' -vv -d $ip
}

function dbSMB-Users {
    db_nmap -vv –script=smb-enum-users -p445 _nmap_smbusers $ip
}

function dbSMB-Shares {
    db_nmap -vv --script=smb-enum-shares -p445 -oN _nmap_smb_shares $ip
}

function dbSMB-Sessions {
    db_nmap -vv --script=smb-enum-sessions -p445 -oN _nmap_smb_sessions $ip
}

function dbNFS-Quick {
    db_nmap -v -p 111 -oN _nmap_nfs $ip
}

function dbEnum-Shares {
    db_nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions -p445 -oN _nmap_enum_shares $ip
}
 
function dbEnum-NFS {
    db_nmap -v -p 111  -oN _nmap_rpcbind $ip
    db_nmap -sV -p 111 --script=rpcinfo,nfs* -oN _nmap_enum_nfs $ip 
}

function dbEnum-SNMP {
    db_nmap -sU --open -p 161 -oN _nmap_open_snmp $ip
}

function dbscan-subnet {
    db_nmap -T5 -n -sn -oN _nmap_subnet $ip 
}
function dbIntense-5000 {
    db_nmap -A -p 1-5000 -vvv -oN _nmap_5000 $ip
}

function dbPing-Sweep {
    db_nmap -sP -oN _nmap_ping_sweep $ip
}

function dbForce-Scan {
    db_nmap -vvv -Pn -A -oN _nmap_force $ip
}