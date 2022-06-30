
$path1 = '.\Modules\nmap-module\nmap-module.psm1';
$path2 = '.\Modules\vulscan-module\vulscan.psm1';
$path3 = '.\Modules\smb-module\smb-module.psm1';
$path4 = '.\Modules\ipsee-module\ipsee.psm1';

$nmap = Get-Content $path1 
$smb = Get-Content $path2  
$vuln = Get-Content $path3
$ipsee = Get-Content $path4

if(!(Test-Path ./PsSec.psm1)){ New-Item ./PsSec.psm1 }

$module = $nmap + $smb + $vuln + $ipsee
Set-Content ./PsSec.psm1 $module

function Test-Build {
    $test = Get-Content ./PsSec.psm1
    $log = $test | Select -Last 20
    Write-Output $log >> log.txt
}
Test-Build