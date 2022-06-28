function Invoke-Vulscan {
    nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse -oA vulscan $ip
}
function Invoke-Vulners {
    nmap -vv -sV -Pn --script nmap-vulners/ -oA vulners $ip   
}

function Invoke-Vuln {
    nmap -Pn --script vuln -oA vuln $ip
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
Double-Vuln 

function Double-Vuln {
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
