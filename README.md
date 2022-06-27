# PsSec



Functions for PowerShell, just dot source the script, create a folder for your target, cd into it, set an IP/CIDR target as a variable like:

```
$ip = '192.168.0.1/24'
```

Now just run 'Quick-Scan', etc

## Nmap Functions

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

'nbt-scan'
'smbmap-guest'
'Nmb-Lookup'
'Enum4-basic'
'Enum4-Deep'

Each Cmdlet runs one or more scans and outputs to files in the current directory


