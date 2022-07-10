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
<#
.Synopsis
  Get the MFA status for all users or a single user with Microsoft Graph

.DESCRIPTION
  This script will get the Azure MFA Status for your users. You can query all the users, admins only or a single user.
   
	It will return the MFA Status, MFA type and registered devices.

  Note: Default MFA device is currently not supported https://docs.microsoft.com/en-us/graph/api/resources/authenticationmethods-overview?view=graph-rest-beta
        Hardwaretoken is not yet supported

.NOTES
  Name: Get-MgMFAStatus
  Author: R. Mens - LazyAdmin.nl
  Version: 1.1
  DateCreated: Jun 2022
  Purpose/Change: Add Directory.Read.All scope

.LINK
  https://lazyadmin.nl

.EXAMPLE
  Get-MgMFAStatus

  Get the MFA Status of all enabled and licensed users and check if there are an admin or not

.EXAMPLE
  Get-MgMFAStatus -UserPrincipalName 'johndoe@contoso.com','janedoe@contoso.com'

  Get the MFA Status for the users John Doe and Jane Doe

.EXAMPLE
  Get-MgMFAStatus -withOutMFAOnly

  Get only the licensed and enabled users that don't have MFA enabled

.EXAMPLE
  Get-MgMFAStatus -adminsOnly

  Get the MFA Status of the admins only

.EXAMPLE
  Get-MgUser -Filter "country eq 'Netherlands'" | ForEach-Object { Get-MgMFAStatus -UserPrincipalName $_.UserPrincipalName }

  Get the MFA status for all users in the Country The Netherlands. You can use a similar approach to run this
  for a department only.

.EXAMPLE
  Get-MgMFAStatus -withOutMFAOnly| Export-CSV c:\temp\userwithoutmfa.csv -noTypeInformation

  Get all users without MFA and export them to a CSV file
#>

[CmdletBinding(DefaultParameterSetName="Default")]
param(
  [Parameter(
    Mandatory = $false,
    ParameterSetName  = "UserPrincipalName",
    HelpMessage = "Enter a single UserPrincipalName or a comma separted list of UserPrincipalNames",
    Position = 0
    )]
  [string[]]$UserPrincipalName,

  [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "AdminsOnly"
  )]
  # Get only the users that are an admin
  [switch]$adminsOnly = $false,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "Licensed"
  )]
  # Check only the MFA status of users that have license
  [switch]$IsLicensed = $true,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true,
    ParameterSetName  = "withOutMFAOnly"
  )]
  # Get only the users that don't have MFA enabled
  [switch]$withOutMFAOnly = $false,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false
  )]
  # Check if a user is an admin. Set to $false to skip the check
  [switch]$listAdmins = $true,

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Enter path to save the CSV file"
  )]
  [string]$path = ".\MFAStatus-$((Get-Date -format "MMM-dd-yyyy").ToString()).csv"
)

Function ConnectTo-MgGraph {
  # Check if MS Graph module is installed
  if (-not(Get-InstalledModule Microsoft.Graph)) { 
    Write-Host "Microsoft Graph module not found" -ForegroundColor Black -BackgroundColor Yellow
    $install = Read-Host "Do you want to install the Microsoft Graph Module?"

    if ($install -match "[yY]") {
      Install-Module Microsoft.Graph -Repository PSGallery -Scope CurrentUser -AllowClobber -Force
    }else{
      Write-Host "Microsoft Graph module is required." -ForegroundColor Black -BackgroundColor Yellow
      exit
    } 
  }

  # Connect to Graph
  Write-Host "Connecting to Microsoft Graph" -ForegroundColor Cyan
  Connect-MgGraph -Scopes "User.Read.All, UserAuthenticationMethod.Read.All, Directory.Read.All"

  # Select the beta profile
  Select-MgProfile Beta
}

Function Get-Admins{
  <#
  .SYNOPSIS
    Get all user with an Admin role
  #>
  process{
    $admins = Get-MgDirectoryRole | Select-Object DisplayName, Id | 
                %{$role = $_.displayName; Get-MgDirectoryRoleMember -DirectoryRoleId $_.id | 
                  where {$_.AdditionalProperties."@odata.type" -eq "#microsoft.graph.user"} | 
                  % {Get-MgUser -userid $_.id | Where-Object {($_.AssignedLicenses).count -gt 0}}
                } | 
                Select @{Name="Role"; Expression = {$role}}, DisplayName, UserPrincipalName, Mail, ObjectId | Sort-Object -Property Mail -Unique
    
    return $admins
  }
}

Function Get-Users {
  <#
  .SYNOPSIS
    Get users from the requested DN
  #>
  process{
    # Set the properties to retrieve
    $select = @(
      'id',
      'DisplayName',
      'userprincipalname',
      'mail'
    )

    $properties = $select + "AssignedLicenses"

    # Get enabled, disabled or both users
    switch ($enabled)
    {
      "true" {$filter = "AccountEnabled eq true and UserType eq 'member'"}
      "false" {$filter = "AccountEnabled eq false and UserType eq 'member'"}
      "both" {$filter = "UserType eq 'member'"}
    }
    
    # Check if UserPrincipalName(s) are given
    if ($UserPrincipalName) {
      Write-host "Get users by name" -ForegroundColor Cyan

      $users = @()
      foreach ($user in $UserPrincipalName) 
      {
        try {
          $users += Get-MgUser -UserId $user -Property $properties | select $select -ErrorAction Stop
        }
        catch {
          [PSCustomObject]@{
            DisplayName       = " - Not found"
            UserPrincipalName = $User
            isAdmin           = $null
            MFAEnabled        = $null
          }
        }
      }
    }elseif($adminsOnly)
    {
      Write-host "Get admins only" -ForegroundColor Cyan

      $users = @()
      foreach ($admin in $admins) {
        $users += Get-MgUser -UserId $admin.UserPrincipalName -Property $properties | select $select
      }
    }else
    {
      if ($IsLicensed) {
        # Get only licensed users
        $users = Get-MgUser -Filter $filter -Property $properties -all | Where-Object {($_.AssignedLicenses).count -gt 0} | select $select
      }else{
        $users = Get-MgUser -Filter $filter -Property $properties -all | select $select
      }
    }
    return $users
  }
}

Function Get-MFAMethods {
  <#
    .SYNOPSIS
      Get the MFA status of the user
  #>
  param(
    [Parameter(Mandatory = $true)] $userId
  )
  process{
    # Get MFA details for each user
    [array]$mfaData = Get-MgUserAuthenticationMethod -UserId $userId

    # Create MFA details object
    $mfaMethods  = [PSCustomObject][Ordered]@{
      status            = "-"
      authApp           = "-"
      phoneAuth         = "-"
      fido              = "-"
      helloForBusiness  = "-"
      emailAuth         = "-"
      tempPass          = "-"
      passwordLess      = "-"
      softwareAuth      = "-"
      authDevice        = "-"
      authPhoneNr       = "-"
      SSPREmail         = "-"
    }

    ForEach ($method in $mfaData) {
        Switch ($method.AdditionalProperties["@odata.type"]) {
          "#microsoft.graph.microsoftAuthenticatorAuthenticationMethod"  { 
            # Microsoft Authenticator App
            $mfaMethods.authApp = $true
            $mfaMethods.authDevice = $method.AdditionalProperties["displayName"] 
            $mfaMethods.status = "enabled"
          } 
          "#microsoft.graph.phoneAuthenticationMethod"                  { 
            # Phone authentication
            $mfaMethods.phoneAuth = $true
            $mfaMethods.authPhoneNr = $method.AdditionalProperties["phoneType", "phoneNumber"] -join ' '
            $mfaMethods.status = "enabled"
          } 
          "#microsoft.graph.fido2AuthenticationMethod"                   { 
            # FIDO2 key
            $mfaMethods.fido = $true
            $fifoDetails = $method.AdditionalProperties["model"]
            $mfaMethods.status = "enabled"
          } 
          "#microsoft.graph.passwordAuthenticationMethod"                { 
            # Password
            # When only the password is set, then MFA is disabled.
            if ($mfaMethods.status -ne "enabled") {$mfaMethods.status = "disabled"}
          }
          "#microsoft.graph.windowsHelloForBusinessAuthenticationMethod" { 
            # Windows Hello
            $mfaMethods.helloForBusiness = $true
            $helloForBusinessDetails = $method.AdditionalProperties["displayName"]
            $mfaMethods.status = "enabled"
          } 
          "#microsoft.graph.emailAuthenticationMethod"                   { 
            # Email Authentication
            $mfaMethods.emailAuth =  $true
            $mfaMethods.SSPREmail = $method.AdditionalProperties["emailAddress"] 
            $mfaMethods.status = "enabled"
          }               
          "microsoft.graph.temporaryAccessPassAuthenticationMethod"    { 
            # Temporary Access pass
            $mfaMethods.tempPass = $true
            $tempPassDetails = $method.AdditionalProperties["lifetimeInMinutes"]
            $mfaMethods.status = "enabled"
          }
          "#microsoft.graph.passwordlessMicrosoftAuthenticatorAuthenticationMethod" { 
            # Passwordless
            $mfaMethods.passwordLess = $true
            $passwordLessDetails = $method.AdditionalProperties["displayName"]
            $mfaMethods.status = "enabled"
          }
          "#microsoft.graph.softwareOathAuthenticationMethod" { 
            # ThirdPartyAuthenticator
            $mfaMethods.softwareAuth = $true
            $mfaMethods.status = "enabled"
          }
        }
    }
    Return $mfaMethods
  }
}

Function Get-MFAStatusUsers {
  <#
    .SYNOPSIS
      Get all AD users
  #>
  process {
    Write-Host "Collecting users" -ForegroundColor Cyan
    
    # Collect users
    $users = Get-Users
    
    Write-Host "Processing" $users.count "users" -ForegroundColor Cyan

    # Collect and loop through all users
    $users | ForEach {
      
      $mfaMethods = Get-MFAMethods -userId $_.id

      if ($withOutMFAOnly) {
        if ($mfaMethods.status -eq "disabled") {
          [PSCustomObject]@{
            "Name" = $_.DisplayName
            Emailaddress = $_.mail
            UserPrincipalName = $_.UserPrincipalName
            isAdmin = if ($listAdmins -and ($admins.UserPrincipalName -match $_.UserPrincipalName)) {$true} else {"-"}
            MFAEnabled        = $false
            "Phone number" = $mfaMethods.authPhoneNr
            "Email for SSPR" = $mfaMethods.SSPREmail
          }
        }
      }else{
        [pscustomobject]@{
          "Name" = $_.DisplayName
          Emailaddress = $_.mail
          UserPrincipalName = $_.UserPrincipalName
          isAdmin = if ($listAdmins -and ($admins.UserPrincipalName -match $_.UserPrincipalName)) {$true} else {"-"}
          "MFA Status" = $mfaMethods.status
        # "MFA Default type" = ""  - Not yet supported by MgGraph
          "Phone Authentication" = $mfaMethods.phoneAuth
          "Authenticator App" = $mfaMethods.authApp
          "Passwordless" = $mfaMethods.passwordLess
          "Hello for Business" = $mfaMethods.helloForBusiness
          "FIDO2 Security Key" = $mfaMethods.fido
          "Temporary Access Pass" = $mfaMethods.tempPass
          "Authenticator device" = $mfaMethods.authDevice
          "Phone number" = $mfaMethods.authPhoneNr
          "Email for SSPR" = $mfaMethods.SSPREmail
        }
      }
    }
  }
}

# Connect to Graph
ConnectTo-MgGraph

# Get Admins
# Get all users with admin role
$admins = $null

if (($listAdmins) -or ($adminsOnly)) {
  $admins = Get-Admins
} 

# Get MFA Status
Get-MFAStatusUsers | Sort-Object Name | Export-CSV -Path $path -NoTypeInformation

if ((Get-Item $path).Length -gt 0) {
  Write-Host "Report finished and saved in $path" -ForegroundColor Green

  # Open the CSV file
  Invoke-Item $path
}else{
  Write-Host "Failed to create report" -ForegroundColor Red
}
# Function to get your current Ip address

function Get-MyIp {
    Invoke-RestMethod -Method GET -Uri "http://ifconfig.me/ip"
}
$ip = Get-MyIp
<#
.Synopsis
  Get the MFA status for all users or a single user.

.DESCRIPTION
  This script will get the Azure MFA Status for your users. You can query all the users, admins only or a single user.
   
	It will return the MFA Status, MFA type (

.NOTES
  Name: Get-MFAStatus
  Author: R. Mens - LazyAdmin.nl
  Version: 1.6
  DateCreated: jan 2021
  Purpose/Change: Added registered email and phonenumber
	Thanks to: Anthony Bartolo

.LINK
  https://lazyadmin.nl

.EXAMPLE
  Get-MFAStatus

  Get the MFA Status of all enabled and licensed users and check if there are an admin or not

.EXAMPLE
  Get-MFAStatus -UserPrincipalName 'johndoe@contoso.com','janedoe@contoso.com'

  Get the MFA Status for the users John Doe and Jane Doe

.EXAMPLE
  Get-MFAStatus -withOutMFAOnly

  Get only the licensed and enabled users that don't have MFA enabled

.EXAMPLE
  Get-MFAStatus -adminsOnly

  Get the MFA Status of the admins only

.EXAMPLE
  Get-MsolUser -Country "NL" | ForEach-Object { Get-MFAStatus -UserPrincipalName $_.UserPrincipalName }

  Get the MFA status for all users in the Country The Netherlands. You can use a similar approach to run this
  for a department only.

.EXAMPLE
  Get-MFAStatus -withOutMFAOnly | Export-CSV c:\temp\userwithoutmfa.csv -noTypeInformation

  Get all users without MFA and export them to a CSV file
#>
[CmdletBinding(DefaultParameterSetName="Default")]
param(
  [Parameter(
    Mandatory = $false,
    ParameterSetName  = "UserPrincipalName",
    HelpMessage = "Enter a single UserPrincipalName or a comma separted list of UserPrincipalNames",
    Position = 0
    )]
  [string[]]$UserPrincipalName,

  [Parameter(
    Mandatory = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "AdminsOnly"
  )]
  # Get only the users that are an admin
  [switch]$adminsOnly = $false,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "AllUsers"
  )]
  # Set the Max results to return
  [int]$MaxResults = 10000,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false,
    ParameterSetName  = "Licensed"
  )]
  # Check only the MFA status of users that have license
  [switch]$IsLicensed = $true,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $true,
    ValueFromPipelineByPropertyName = $true,
    ParameterSetName  = "withOutMFAOnly"
  )]
  # Get only the users that don't have MFA enabled
  [switch]$withOutMFAOnly = $false,

  [Parameter(
    Mandatory         = $false,
    ValueFromPipeline = $false
  )]
  # Check if a user is an admin. Set to $false to skip the check
  [switch]$listAdmins = $true
)



# Connect to Msol
if ((Get-Module -ListAvailable -Name MSOnline) -eq $null)
{
  Write-Host "MSOnline Module is required, do you want to install it?" -ForegroundColor Yellow
      
  $install = Read-Host Do you want to install module? [Y] Yes [N] No 
  if($install -match "[yY]") 
  { 
    Write-Host "Installing MSOnline module" -ForegroundColor Cyan
    Install-Module MSOnline -Repository PSGallery -AllowClobber -Force
  } 
  else
  {
	  Write-Error "Please install MSOnline module."
  }
}

if ((Get-Module -ListAvailable -Name MSOnline) -ne $null)
{
  if(-not (Get-MsolDomain -ErrorAction SilentlyContinue))
  {
    if ($Host.Version.Major -eq 7) {
      Import-Module MSOnline -UseWindowsPowershell
    }
    Connect-MsolService
  }
}
else{
  Write-Error "Please install Msol module."
}
  
# Get all licensed admins
$admins = $null

if (($listAdmins) -or ($adminsOnly)) {
  $admins = Get-MsolRole | %{$role = $_.name; Get-MsolRoleMember -RoleObjectId $_.objectid} | Where-Object {$_.isLicensed -eq $true} | select @{Name="Role"; Expression = {$role}}, DisplayName, EmailAddress, ObjectId | Sort-Object -Property EmailAddress -Unique
}

# Check if a UserPrincipalName is given
# Get the MFA status for the given user(s) if they exist
if ($PSBoundParameters.ContainsKey('UserPrincipalName')) {
  foreach ($user in $UserPrincipalName) {
		try {
      $MsolUser = Get-MsolUser -UserPrincipalName $user -ErrorAction Stop

      $Method = ""
      $MFAMethod = $MsolUser.StrongAuthenticationMethods | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty MethodType

      If (($MsolUser.StrongAuthenticationRequirements) -or ($MsolUser.StrongAuthenticationMethods)) {
        Switch ($MFAMethod) {
            "OneWaySMS" { $Method = "SMS token" }
            "TwoWayVoiceMobile" { $Method = "Phone call verification" }
            "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $Method = "Authenticator app" }
        }
      }

      [PSCustomObject]@{
        DisplayName       = $MsolUser.DisplayName
        UserPrincipalName = $MsolUser.UserPrincipalName
        isAdmin           = if ($listAdmins -and $admins.EmailAddress -match $MsolUser.UserPrincipalName) {$true} else {"-"}
        MFAEnabled        = if ($MsolUser.StrongAuthenticationMethods) {$true} else {$false}
        MFAType           = $Method
				MFAEnforced       = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
        "Email Verification" = if ($msoluser.StrongAuthenticationUserDetails.Email) {$msoluser.StrongAuthenticationUserDetails.Email} else {"-"}
        "Registered phone" = if ($msoluser.StrongAuthenticationUserDetails.PhoneNumber) {$msoluser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
      }
    }
		catch {
			[PSCustomObject]@{
				DisplayName       = " - Not found"
				UserPrincipalName = $User
				isAdmin           = $null
				MFAEnabled        = $null
			}
		}
  }
}
# Get only the admins and check their MFA Status
elseif ($adminsOnly) {
  foreach ($admin in $admins) {
    $MsolUser = Get-MsolUser -ObjectId $admin.ObjectId | Sort-Object UserPrincipalName -ErrorAction Stop

    $MFAMethod = $MsolUser.StrongAuthenticationMethods | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty MethodType
    $Method = ""

    If (($MsolUser.StrongAuthenticationRequirements) -or ($MsolUser.StrongAuthenticationMethods)) {
        Switch ($MFAMethod) {
            "OneWaySMS" { $Method = "SMS token" }
            "TwoWayVoiceMobile" { $Method = "Phone call verification" }
            "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $Method = "Authenticator app" }
        }
      }
    
    [PSCustomObject]@{
      DisplayName       = $MsolUser.DisplayName
      UserPrincipalName = $MsolUser.UserPrincipalName
      isAdmin           = $true
      "MFA Enabled"     = if ($MsolUser.StrongAuthenticationMethods) {$true} else {$false}
      "MFA Default Type"= $Method
      "SMS token"       = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "OneWaySMS") {$true} else {"-"}
      "Phone call verification" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "TwoWayVoiceMobile") {$true} else {"-"}
      "Hardware token or authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppOTP") {$true} else {"-"}
      "Authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppNotification") {$true} else {"-"}
      "Email Verification" = if ($msoluser.StrongAuthenticationUserDetails.Email) {$msoluser.StrongAuthenticationUserDetails.Email} else {"-"}
      "Registered phone" = if ($msoluser.StrongAuthenticationUserDetails.PhoneNumber) {$msoluser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
			MFAEnforced = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
    }
  }
}
# Get the MFA status from all the users
else {
  $MsolUsers = Get-MsolUser -EnabledFilter EnabledOnly -MaxResults $MaxResults | Where-Object {$_.IsLicensed -eq $isLicensed} | Sort-Object UserPrincipalName
    foreach ($MsolUser in $MsolUsers) {

      $MFAMethod = $MsolUser.StrongAuthenticationMethods | Where-Object {$_.IsDefault -eq $true} | Select-Object -ExpandProperty MethodType
      $Method = ""

      If (($MsolUser.StrongAuthenticationRequirements) -or ($MsolUser.StrongAuthenticationMethods)) {
        Switch ($MFAMethod) {
            "OneWaySMS" { $Method = "SMS token" }
            "TwoWayVoiceMobile" { $Method = "Phone call verification" }
            "PhoneAppOTP" { $Method = "Hardware token or authenticator app" }
            "PhoneAppNotification" { $Method = "Authenticator app" }
        }
      }

      if ($withOutMFAOnly) {
        # List only the user that don't have MFA enabled
        if (-not($MsolUser.StrongAuthenticationMethods)) {

          [PSCustomObject]@{
            DisplayName       = $MsolUser.DisplayName
            UserPrincipalName = $MsolUser.UserPrincipalName
            isAdmin           = if ($listAdmins -and ($admins.EmailAddress -match $MsolUser.UserPrincipalName)) {$true} else {"-"}
            MFAEnabled        = $false
            MFAType           = "-"
						MFAEnforced       = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
            "Email Verification" = if ($msoluser.StrongAuthenticationUserDetails.Email) {$msoluser.StrongAuthenticationUserDetails.Email} else {"-"}
            "Registered phone" = if ($msoluser.StrongAuthenticationUserDetails.PhoneNumber) {$msoluser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
          }
        }
      }else{
        [PSCustomObject]@{
          DisplayName       = $MsolUser.DisplayName
          UserPrincipalName = $MsolUser.UserPrincipalName
          isAdmin           = if ($listAdmins -and ($admins.EmailAddress -match $MsolUser.UserPrincipalName)) {$true} else {"-"}
          "MFA Enabled"     = if ($MsolUser.StrongAuthenticationMethods) {$true} else {$false}
          "MFA Default Type"= $Method
          "SMS token"       = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "OneWaySMS") {$true} else {"-"}
          "Phone call verification" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "TwoWayVoiceMobile") {$true} else {"-"}
          "Hardware token or authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppOTP") {$true} else {"-"}
          "Authenticator app" = if ($MsolUser.StrongAuthenticationMethods.MethodType -contains "PhoneAppNotification") {$true} else {"-"}
          "Email Verification" = if ($msoluser.StrongAuthenticationUserDetails.Email) {$msoluser.StrongAuthenticationUserDetails.Email} else {"-"}
          "Registered phone" = if ($msoluser.StrongAuthenticationUserDetails.PhoneNumber) {$msoluser.StrongAuthenticationUserDetails.PhoneNumber} else {"-"}
					MFAEnforced       = if ($MsolUser.StrongAuthenticationRequirements) {$true} else {"-"}
        }
      }
    }
  }
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
