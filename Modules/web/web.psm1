# need a vanilla
function web-go {
    gobuster dir -u http://$ip -w $word -o goscan.txt
}

# gobuster has vhost mode
function web-vhost {
    gobuster -v vhost -u http://$ip -w $word -o govhost.txt
}

# gobuster has dns mode
function web-dns {
    gobuster -v dns http://$ip -w $word -o godns.txt
}

# a php specific that will use both go and ferox
function web-php {
    gobuster dir http://$ip -w $word -o gophp.txt -x php,php3,php5,html
    feroxbuster 
}

# # try and get something to work well with zap
# func zap-scan

# # nikto scan
# func nikto-scan

