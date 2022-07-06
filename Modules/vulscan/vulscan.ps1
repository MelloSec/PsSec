function Invoke-Vulscan {
    nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse -oA vulscan $ip
}
function Invoke-Vulners {
    nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
}

function Invoke-Vuln {
    nmap -Pn -sV --script vuln -oA vuln $ip
}
function Double-Vuln {
    function Invoke-Vulscan {
        nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse -oA vulscan $ip
    }
    function Invoke-Vulners {
        nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
    }
    Invoke-Vulscan
    Invoke-Vulners
}

function Triple-Vuln {
    function Invoke-Vulscan {
        $scan1 = nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse $ip
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
    function Invoke-Vulscan {
        $scan1 = nmap -vv -sV -p- -Pn -oA vulscan --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse $ip
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
