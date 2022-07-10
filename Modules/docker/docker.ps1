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
    docker run -t enum4linux-ng -As $ip > enum4ng-as.txt
}

# Enum4linux-ng All
function enum4docker-a {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    docker run -t enum4linux-ng -A $ip > enum4ng-a.txt
}

function kali-bash {
    docker run -ti kalilinux/kali-rolling /bin/bash
}
