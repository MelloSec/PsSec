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