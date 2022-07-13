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

function kali-bash {
    docker run -ti kalilinux/kali-rolling /bin/bash
}
