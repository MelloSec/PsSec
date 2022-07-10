$domain = "google.com"
$uri = "https://$domain"

function testssl-e {
    docker run --rm -ti drwetter/testssl.sh:3.0 -e --parallel $uri
}

function testssl-ef {
    docker run --rm -ti drwetter/testssl.sh:3.0 -e --fast --parallel $uri
}

function testssl-p {
    docker run --rm -ti drwetter/testssl.sh:3.0 -p --fast --parallel $uri
}
function testssl-pf {
    docker run --rm -ti drwetter/testssl.sh:3.0 -p --fast --parallel $uri
}

function testssl-t {
    docker run --rm -ti drwetter/testssl.sh:3.0 -t --parallel $uri
}

function testssl-tf {
    docker run --rm -ti drwetter/testssl.sh:3.0 -t --fast --parallel $uri
}
