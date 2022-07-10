$domain = "google.com"
$uri = "https://$domain"

function testssl {
    docker run --rm -ti drwetter/testssl.sh:3.0 $uri
}

function testssl-p {
    docker run --rm -ti drwetter/testssl.sh:3.0 --parallel $uri
}
function testssl-e {
    docker run --rm -ti drwetter/testssl.sh:3.0 -e $uri
}

function testssl-epf {
    docker run --rm -ti drwetter/testssl.sh:3.0 -e --parallel --fast  $uri
}

function testssl-p {
    docker run --rm -ti drwetter/testssl.sh:3.0 -p $uri
}
function testssl-ppf {
    docker run --rm -ti drwetter/testssl.sh:3.0 -p --parallel --fast  $uri
}

function testssl-t {
    docker run --rm -ti drwetter/testssl.sh:3.0 -t $uri
}

function testssl-tpf {
    docker run --rm -ti drwetter/testssl.sh:3.0 -t --parallel --fast  $uri
}