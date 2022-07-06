function Get-IPInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ip
    )
    $IPObject = Invoke-RestMethod -Method GET -Uri "https://ipapi.co/$ip/json"

    [PSCustomObject]@{
        IP        =  $IPObject.IP
        City      =  $IPObject.City
        Country   =  $IPObject.Country_Name
        Region    =  $IPObject.Region
        Postal    =  $IPObject.Postal
        TimeZone  =  $IPObject.TimeZone
        ASN       =  $IPObject.asn
        Owner     =  $IPObject.org
    }
}

function Check-NeutrinoBlocklist {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ip,
        [Parameter(Mandatory)]
        [string]$userId,
        [Parameter(Mandatory)]
        [string]$apiKey
    )
    $IPObject = Invoke-RestMethod -Method GET -Uri "https://neutrinoapi.net/ip-blocklist?user-id=$userId&api-key=$apiKey&ip=$ip"

    [PSCustomObject]@{

        CIDR                =  $IPObject."cidr"
        IsListed            =  $IPObject."is-listed"
        IsHijacked          =  $IPObject."is-hijacked"
        IsSpider            =  $IPObject."is-spider"
        IsTor               =  $IPObject."is-tor"
        IsProxy             =  $IPObject."is-proxy"
        IsMalware           =  $IPObject."is-malware"
        IsVpn               =  $IPObject."is-vpn"
        IsBot               =  $IPObject."is-bot"
        IsSpamBot           =  $IPObject."is-spam-bot"
        IsExploitBot        =  $IPObject."is-exploit-bot"
        ListCount           =  $IPObject."list-count"
        Blocklists          =  $IPObject."blocklists"
        LastSeen            =  $IPObject."last-seen"
        Sensors             =  $IPObject."sensors"
    }
}

function Get-ReverseIP {
    param(
        [Parameter(Mandatory)]
        [string]$ip
    )
    $URLObject = Invoke-RestMethod -Method GET -Uri "https://api.hackertarget.com/reverseiplookup/?q=151.101.194.159"
}

function Check-NeutrinoUrlInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$url,
        [Parameter(Mandatory)]
        [string]$userId,
        [Parameter(Mandatory)]
        [string]$apiKey
    )
    $URLObject = Invoke-RestMethod -Method GET -Uri "https://neutrinoapi.net/url-info?user-id=$userid&api-key=$apiKey&url=$url"
}
# $URLCheck = Check-NeutrinoUrlInfo $url $userId $apiKey
# $URLCheck


# Checks your current IP
# Could we make this a switch, so that you either want to look up your own IP first? If not, then we go on to just do a lookup on whatever IP was passed
function Get-MyIp {
    $myip = Invoke-RestMethod -Method GET -Uri "http://ifconfig.me/ip"
    Write-Output "Your IP is $myip"
}

function Find-Me {
    Write-Output "Testing the combine script"
}
