$userlist = Get-Content ./mssql-userlist.txt
$passlist = Get-Content ./mssql-passlist.txt

function mssql-scan {
    nmap -sV -p 3306 --script mysql-audit,mysql-databases,mysql-dump-hashes,mysql-empty-password,mysql-enum,mysql-info,mysql-query,mysql-users,mysql-variables,mysql-vuln-cve2012-2122 -oN _nmap_mssql-scan $ip
}

function mssql-brute {
    nmap -vv -p 3306 -Pn --script ms-sql-brute --script-args userdb=$userlist,passdb=$passlist $ip
}