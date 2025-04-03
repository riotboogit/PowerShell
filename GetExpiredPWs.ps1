# run from powershell in admin 
#Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online
# import module
#Get-Module -Name ActiveDirectory -ListAvailable
# should get something like this 
# Directory: C:\windows\system32\WindowsPowerShell\v1.0\Modules
# import to use
# Gets expired users and writes to csv file
Import-Module -Name ActiveDirectory
$filePath = '//Server/IntegrationFiles/users.csv' 

 #get date and cast to string )
$runDate = Get-Date
$fileDate = $runDate.ToString("yyyy-MM-dd")
Write-Host $fileDate
 

Get-ADUser -filter {Enabled -eq $True -and PasswordNeverExpires -eq $False} -Properties UserPrincipalName, Info, DisplayName, msDS-UserPasswordExpiryTimeComputed |
Select-Object -Property UserPrincipalName, Info, Displayname, @{Name="Expiration Date";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}} |
Sort-Object "Expiration Date" | Export-Csv -Path $filePath -NoTypeInformation

#add run date to file
$csvFile = Import-Csv -Path $filePath
$csvFile | Select-Object *, @{Name="rundate"; Expression={$fileDate}} |
Export-Csv $filePath -NoType


# get last login date


# get is pw exp

# get if locked out 
