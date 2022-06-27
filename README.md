# PsSec



Functions for PowerShell, just dot source the script, create a folder for your target, cd into it, set an IP/CIDR target as a variable like:

```
$ip = '192.168.0.1/24'
```

Now just run 'Quick-Scan', etc

## Nmap Functions

![image](https://user-images.githubusercontent.com/65114647/175846428-63a434a9-2820-475b-8f4b-a5dcffb14a75.png)

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

![image](https://user-images.githubusercontent.com/65114647/175846365-3c5cc6bd-c966-4360-a22c-9311f202f1e3.png)


'nbt-scan'
'smbmap-guest'
'Nmb-Lookup'
'Enum4-basic'
'Enum4-Deep'

Each Cmdlet runs one or more scans and outputs to files in the current directory


