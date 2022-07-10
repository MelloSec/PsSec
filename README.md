# PsSec



Functions for PowerShell, just dot source the script, create a folder for your target, cd into it, set an IP/CIDR target as a variable like:

```
$ip = '192.168.0.1/24'
```

Now just run 'Quick-Scan', etc

## Nmap Functions

For the vuln scanning, you should install two additional vulnerability scripts for NMAP.

Vulscan - 

git clone https://github.com/scipag/vulscan scipag_vulscan
ln -s `pwd`/scipag_vulscan /usr/share/nmap/scripts/vulscan   

Vulners -

cd /usr/share/nmap/scripts/
git clone https://github.com/vulnersCom/nmap-vulners.git



'Quick Scan'
'Scan-Subnet'
'Ping-Sweep' 
'Tcp-Scans'
'Udp-scans'
'Long-Scans'
'Enum-Shares'
'SMB-Quick'
'SMB-Vuln' 
'SMB-Users'
'SMB-Shares'
'SMB-Sessions'
'NFS-Quick'
'Enum-NFS'

## SMB Functions


Each Cmdlet runs one or more scans and outputs to files in the current directory


