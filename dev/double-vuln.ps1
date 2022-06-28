function Double-Vuln {
    function Invoke-Vulscan {
        nmap -vv -sV -Pn --script /home/mellonaut/vuln/scipag_vulscan/vulscan.nse -oA vulscan $ip
    }
    function Invoke-Vulners {
        nmap -vv -sV -Pn --script nmap-vulners/ -oN vulners $ip   
    }

    Invoke-Vulscan $ip
    Invoke-Vulners $ip
}
Double-Vuln 
