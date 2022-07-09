# Dot Source latest functions
function Dotsource-Functions {
    $Path = ".\Functions"
    Get-ChildItem -Path $Path -Filter *.ps1 |ForEach-Object {
        . $_.FullName
    }
}
# Function to search Azure tenant for Guest users with a specific name

function Get-AzGuestsByName {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Guest
    )
    $Guests = Get-AzureADUser -SearchString $Guest
    ForEach ($G in $Guests) {
       If ($G.UserType -eq "Guest") {
          $UserLastLogonDate = $Null
          Try {
             $UserObjectId = $G.ObjectId
             $UserLastLogonDate = (Get-AzureADAuditSignInLogs -Top 1  -Filter "userid eq '$UserObjectId' and status/errorCode eq 0").CreatedDateTime }
          Catch {
             Write-Host "Can't read Azure Active Directory Sign in Logs" }
          If ($UserLastLogonDate -ne $Null) {
             $LastSignInDate = Get-Date($UserLastLogonDate); $Days = New-TimeSpan($LastSignInDate)
             Write-Host "Guest" $G.DisplayName "last signed in on" $LastSignInDate "or" $Days.Days "days ago"  }
          Else { Write-Host "No Azure Active Directory sign-in data available for" $G.DisplayName "(" $G.Mail ")" }
    }}
}
Get-AzGuestsByName $Guest
# Function to get your current Ip address

function Get-MyIp {
    Invoke-RestMethod -Method GET -Uri "http://ifconfig.me/ip"
}
$ip = Get-MyIp
# Function to spawn an EC2 instance of our custom image

function Invoke-SorrowsetEc2 {
$accesskey = ''
$secretkey = ''
$sorrowset = 'ami-07c5bfcfd08bee251'

Set-AwsCredential -AccessKey "$accesskey" -SecretKey "$secretkey" -StoreAs Default

# Set the region for our project
Initialize-AWSDefaultConfiguration -Region 'us-east-1'
# get-awscredentials -ListProfileDetail

# Set up the VPC, DNS, the Gateway and create a Route Table
$network = '10.0.0.0/16'
$vpc = New-EC2Vpc -CidrBlock $network
Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsSupport $true
Edit-EC2VpcAttribute -VpcId $vpc.VpcId -EnableDnsHostNames $true
$gw = New-EC2InternetGateway
$gw
Add-EC2InternetGateway -InternetGatewayId $gw.InternetGatewayId -VpcId $vpc.VpcId
$rt = New-Ec2RouteTable -VpcId $vpc.VPcId
$rt

# Add default route for the Gateway
New-Ec2Route -RouteTableId $rt.RouteTableId -GatewayId $gw.InternetGatewayId -DestinationCidrBlock '0.0.0.0/0'

#Create the subnet and attach it to the route table
$sn = New-Ec2Subnet -VpcId $vpc.VpcId -CidrBlock '10.0.1.0/24' -AvailabilityZone 'us-east-1a'
Register-EC2RouteTable -RouteTableId $rt.RouteTableId -SubnetId $sn.SubnetId


# $platform_values = New-Object 'collections.generic.list[string]'
# $platform_values.add("windows")
# $filter_platform = New-Object Amazon.EC2.Model.Filter -Property @{Name = "platform"; Values = $platform_values}
# Get-EC2Image -Owner amazon, self -Filter $filter_platform
$sorrowset = 'ami-07c5bfcfd08bee251'
$params = @{
    ImageId = "$sorrowset"
    AssociatePublicIp = $false
    InstanceType = 't2.micro'
    SubnetId = $sn.SubnetId
}
$ec2 = New-Ec2Instance @params
}
