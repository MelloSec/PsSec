# need a vanilla
function web-go {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip  
    )    
    gobuster dir -u http://$ip -w 'C:\Users\RleeA\wordlists\common.txt' -o common.txt
}

# gobuster has vhost mode
function web-vhost {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip,
        [Parameter(Mandatory=$true)]
        [string]$word  
    )
    gobuster -v vhost -u http://$ip -w $word -o govhost.txt
}

# gobuster has dns mode
function web-dns {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip,
        [Parameter(Mandatory=$true)]
        [string]$word
    )
    gobuster -v dns http://$ip -w $word -o godns.txt
}

# a php specific that will use both go and ferox
function web-php {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip,
        [Parameter(Mandatory=$true)]
        [string]$word  
    )
    gobuster dir http://$ip -w $word -o gophp.txt -x php,php3,php5,html
    feroxbuster 
}

# # try and get something to work well with zap
# func zap-scan

# # nikto scan
# func nikto-scan

