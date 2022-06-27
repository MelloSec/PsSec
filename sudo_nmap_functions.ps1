# Just make a CI/CD task that takes any new pushes to nmap_functions, makes the changes here and adds "sudo" before nmap if needed

function Quick-Scan {
   sudo nmap -O --osscan-guess -sV -vv -oN sudo_nmap_tcp_quick $ip
}

function Tcp-Scans {
   sudo nmap -sV -sC -A -vv -oN sudo_nmap_tcp_asc $ip
   sudo nmap -sV -p- -T4 -vv -oN sudo_nmap_tcp_p $ip
}

function udp-scans {
   sudo nmap -sU -vv --top-ports 1000 -oN sudo_nmap_udp_1000 $ip
   sudo nmap -sU --Pn vv -T4 --max-retries 0 -oN sudo_nmap_udp_2 $ip
}

function Long-Scans {
   sudo nmap -sC -sV -A -p- -T4 -vv -oN sudo_nmap_tcp_full $ip
   sudo nmap -sU --top-ports 5000 -oN sudo_nmap_udp_5000 $ip
}

function SMB-Quick {
   sudo nmap -vv --script=smb-os-discovery,smb-enum-shares,smb-enum-users -oN sudo_nmap_smb_quick $ip
}

function SMB-Vuln {
   sudo nmap -p 139,445 -vv --script=smb-vuln-cve2009-3103,smb-vuln-ms06-025,smb-vuln-ms07-029,smb-vuln-ms08-067,smb-vuln-ms10-054,smb-vuln-ms10-061,smb-vuln-ms17-010 -oN sudo_nmap_smb_cve $ip
   sudo nmap -p 139,445 -vv -T4 -oN sudo_nmap_smb_vulns -Pn --script 'not brute and not dos and smb-*' -vv -d $ip
}

function SMB-Users {
   sudo nmap -vv --script smb-enum-users.nse -p445 -oN sudo_nmap_smbusers $ip
}

function SMB-Shares {
   sudo nmap -vv --script=smb-enum-shares -p445 -oN sudo_nmap_smb_shares $ip
}

function SMB-Sessions {
   sudo nmap -vv --script=smb-enum-sessions -p445 -oN sudo_nmap_smb_sessions $ip
}

function NFS-Quick {
   sudo nmap -v -p 111 -oN sudo_nmap_nfs $ip
}

function Enum-Shares {
   sudo nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions -p445 -oN sudo_nmap_enum_shares $ip
   sudo nmap -vv --script=smb-brute,smb-enum-shares,smb-enum-users,smb-enum-sessions --script-args smbuser=username,smbpass=password -p445 -oN sudo_nmap_enum_shares2 $ip 
}
 
function Enum-NFS {
   sudo nmap -v -p 111  -oN sudo_nmap_rpcbind $ip
   sudo nmap -sV -p 111 --script=rpcinfo,nfs* -oN sudo_nmap_enum_nfs $ip 
}

function Enum-SNMP {
   sudo nmap -sU --open -p 161 -oN sudo_nmap_open_snmp $ip
}

function scan-subnet {
   sudo nmap -T5 -n -sn -oN sudo_nmap_subnet $ip 
}
function Intense-5000 {
   sudo nmap -A -p 1-5000 -vvv -oN sudo_nmap_5000 $ip
}

function Ping-Sweep {
   sudo nmap -sP -oN sudo_nmap_ping_sweep $ip
}

function Force-Scan {
   sudo nmap -vvv -Pn -A -oN sudo_nmap_force $ip
}