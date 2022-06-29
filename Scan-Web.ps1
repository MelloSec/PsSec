function Scan-Web {
    $scan1 = nmap -n -Pn -sV -sS '-p80-90,443,4443,8000-8009,8080-8099,8181,8443,9000,9090-9099' $ip
    $scan2 = nmap -n -Pn -sV -sS '-p21-23,25,53,80-90,111,139,389,443,445,873,1099,1433,1521,1723,2049,2100,2121,3299,3306,3389,3632,4369,4443,5038,5060,5432,5555,5900-5902,5985,6000-6002,6379,6667,8000-8009,8080-8099,8181,8443,9000,9090-9099,9200,27017' $ip 
    $scans = $scan1,$scan2
    $Results  = New-Item web-scans.txt 
    Set-Content $scans -Path $Results.Name
}
Scan-Web

# if contains web ports kick off gobuster and feroxbuster


# If $scans -contains $webPorts, certain services, kick off vuln scans
function Triple-Vuln {
    function Invoke-Vulscan {
        nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse -oA vulscan $ip
    }
    function Invoke-Vulners {
        nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
    }
    function Invoke-Vuln {
        nmap -Pn --script vuln -oA vuln  $ip
    }
    Invoke-Vulscan
    Invoke-Vulners
    Invoke-Vuln
}
Triple-Vuln

