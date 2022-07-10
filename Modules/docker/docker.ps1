$domain = "google.com"
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
