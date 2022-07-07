$userlist = Get-Content 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\GitHubProjects\PsSec\Modules\mysql\mysql-user.txt'
$passlist = Get-Content 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\GitHubProjects\PsSec\Modules\mysql\mysql-pass.txt'

function mysql-scan {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -sV -p 3306 --script mysql-audit,mysql-databases,mysql-dump-hashes,mysql-empty-password,mysql-enum,mysql-info,mysql-query,mysql-users,mysql-variables,mysql-vuln-cve2012-2122 -oN _nmap_mysql-scan $ip
}

function mysql-brute {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ip
    )
    nmap -vv -p 3306 -Pn --script ms-sql-brute --script-args userdb=$userlist,passdb=$passlist $ip
}