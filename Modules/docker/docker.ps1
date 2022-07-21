$domain = "$ip"
$uri = "https://$domain"

function testssl {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 $uri
}

function testssl-p {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 --parallel $uri
}
function testssl-e {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -e $uri
}

function testssl-epf {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -e --parallel --fast  $uri
}

function testssl-p {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -p $uri
}
function testssl-ppf {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -p --parallel --fast  $uri
}

function testssl-t {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -t $uri
}

function testssl-tpf {
    param(
        [Parameter(Mandatory=$true)]
        [string]$uri
    )
    docker run --rm -ti drwetter/testssl.sh:3.0 -t --parallel --fast  $uri
}

# Enum4linux-ng All-Simple
function enum4docker-as {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -As $ip -oA enum4docker-as
}

# Enum4linux-ng All + enumerate services
function enum4docker-ac {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -A -C $ip -oA enum4docker-ac
}

function enum4docker-user {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -A -u Tester -p 'Passin!' $ip -oA enum4docker-user 
}

function enum4docker-damn {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run --rm -ti enum4linux-ng -A -C -S -G -Gm -U -N -P -d -v $ip -oA enum4docker-damn 
}

function start-msf {
    docker run --rm -it -u 0 --network msf --name msf --ip 172.18.0.3 -v "${HOME}\OneDrive\vsWorkspace\CTF:/CTF" -p 8443-8500:8443-8500 metasploitframework/metasploit-framework
}

function start-kali {
    docker run -ti --rm --network msf --ip 172.18.0.4 -v "${HOME}\OneDrive\vsWorkspace\CTF:/CTF" -p 8443-8500:8443-8500 -p 4545:4444 -p 7474:7474  sunnv1 /usr/bin/pwsh
}

function start-cme {
    docker run -it --entrypoint=/bin/bash --network msf --ip 172.18.0.6 --name crackmapexec -v "${HOME}\OneDrive\vsWorkspace\CTF:/CTF" byt3bl33d3r/crackmapexec
}

function get-naked {
    docker run -u 0 --network msf --name msf --ip 172.18.0.3 -v "${HOME}\OneDrive\vsWorkspace\CTF:/CTF" -p 8443-8500:8443-8500 metasploitframework/metasploit-framework
    docker run -ti --network msf --ip 172.18.0.4 -v "${HOME}\OneDrive\vsWorkspace\CTF:/CTF" -p 8443-8500:8443-8500 -p 4545:4444 -p 7474:7474  sunnv1 /usr/bin/pwsh
    docker run --network msf --ip 172.18.0.6 --name crackmapexec -v "${HOME}\OneDrive\vsWorkspace\CTF:/CTF" byt3bl33d3r/crackmapexec
}
