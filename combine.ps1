
$path1 = 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\Powershell\Security\PsSec\Modules\nmap-module\nmap-module.psm1';
$path2 = 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\Powershell\Security\PsSec\Modules\vulscan-module\vulscan.psm1';
$path3 = 'C:\Users\RleeA\OneDrive\vsWorkspace\Code\Powershell\Security\PsSec\Modules\smb-module\smb-module.psm1';

$nmap = Get-Content $path1 
$smb = Get-Content $path2  
$vuln = Get-Content $path3

if(!(Test-Path ./PsSec.psm1)){ New-Item ./PsSec.psm1 }

$module = $nmap + $smb + $vuln 
Set-Content ./PsSec.psm1 $module