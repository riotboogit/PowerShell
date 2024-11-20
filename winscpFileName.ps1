
# download csv  only if a new file (created yesterday) assumes the job runs daily
# using the older\standard dll for now for older versions of pwsh v5
# sbb  11.18.2024 -- has not been tested :D
try
{
	#start logging     
  
    #buld the file name (file name is blah +  yesterdays date .csv)
	  $runDate = Get-Date
    $runDate = $runDate.AddDays(-1)
    $fileDate = $runDate.ToString("u")
    $fileDate = $fileDate -replace "-", ''
    $fileNameBase = "GLXXXX_"
    $fileName = $fileNameBase + $fileDate
    $fileName = $fileName.Substring(0,15)
    $fileName = $fileName + '.csv'
    Write-Host $fileName
	
	
    # Load WinSCP .NET assembly -- verify path on server 
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll" 

    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = "xxx"
        UserName = "xxx"
        Password = "xxx"
        SshHostKeyFingerprint = ""
		
    }
 
    $session = New-Object WinSCP.Session

	
    # Connect
    $session.Open($sessionOptions)
    

	# download one folder test -- confirned it overwrites existing files
	$remotePath = "/from_source/"
	$filePath = $remotePath + $fileName
	$localPath = "\\server\groups\Test\Test\" #test dir
	
  $session.GetFiles($filePath, $localPath ) 
   

    exit 0
}
catch
{
    Write-Host "Error: $($_.Exception.Message)"
    exit 1
}

finally
{
    # Disconnect, clean up
    $session.Dispose()
}
