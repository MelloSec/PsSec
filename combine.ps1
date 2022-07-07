$nmap = Get-Content '.\Modules\nmap\nmap.psm1'; Set-Content '.\Modules\nmap\nmap.ps1' $nmap
$vulscan = Get-Content '.\Modules\vulscan\vulscan.psm1'; Set-Content -Path '.\Modules\vulscan\vulscan.ps1' -Value $vulscan
$smb = Get-Content '.\Modules\smb\smb.psm1'; Set-Content -Path '.\Modules\smb\smb.ps1' -Value $smb
$ipsee = Get-Content '.\Modules\ipsee\ipsee.psm1'; Set-Content -Path '.\Modules\ipsee\ipsee.ps1' -Value $ipsee
$mysql = Get-Content '.\Modules\mysql\mysql.psm1'; Set-Content -Path '.\Modules\mysql\mysql.ps1' -Value $mysql
$web = Get-Content '.\Modules\web\web.psm1'; Set-content -Path '.\Modules\web\web.ps1' -Value $web
$dns = Get-Content '.\Modules\dns\dns.psm1'; Set-Content -Path '.\Modules\dns\dns.ps1' -Value $dns
$ftptelnet = Get-Content '.\Modules\ftptelnet\ftptelnet.psm1'; Set-Content -Path '.\Modules\ftptelnet\ftptelnet.ps1' -Value "$ftptelnet"


if(!(Test-Path ./PsSec.psm1)){ New-Item ./PsSec.psm1 }
if(!(Test-Path ./PsSec.ps1)){ New-Item ./PsSec.ps1 }

$module = $nmap + $smb + $vulscan + $ipsee + $mysql + $web
Set-Content ./PsSec.psm1 $module
Set-Content ./PsSec.ps1 $module

function Test-Build {
    $test = Get-Content ./PsSec.psm1
    $log = $test | Select -Last 15
    $date = Get-Date
    $msg = "Building New Module `n Last 15 lines added: "
    Write-Output $date, $msg, $log >> log.txt
}
Test-Build

. ./PsSec.ps1