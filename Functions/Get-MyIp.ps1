# Function to get your current Ip address

function Get-MyIp {
    Invoke-RestMethod -Method GET -Uri "http://ifconfig.me/ip"
}
$ip = Get-MyIp