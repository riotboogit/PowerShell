
# download csv  only if a new file (created yesterday) assumes the job runs daily
# using the older\standard dll for now for older versions of pwsh v5
# sbb  11.18.2024 -- has not been tested :D
# sbb  12.04.24 added archive\rename logic
try
{
    #buld the file name (file name is blah +  yesterdays date .csv)
    $runDate = Get-Date
    $runDate = $runDate.AddDays(-1)
    $fileDate = $runDate.ToString("u")
    $fileDate = $fileDate -replace "-", ''
	$fileNameBase = "DLFile_"
	$fileName = $fileNameBase + $fileDate
    $fileName = $fileName.Substring(0,15)
    $fileName = $fileName + '.csv'
    Write-Host $fileName
	
    #generic file name for processing
    $processFile = "processfile.csv"
    $localPath = "\\servershare\groups\UTDL\Test" #test dir
    $remotePath = "/from_vendor/"
    $archivePath = "\\servershare\groups\UTDL\Test\Archive\"
	
    # Load WinSCP .NET assembly -- verify path on tidal server 
    Add-Type -Path "C:\Program Files (x86)\WinSCP\WinSCPnet.dll" 

    # Setup session options
    $sessionOptions = New-Object WinSCP.SessionOptions -Property @{
        Protocol = [WinSCP.Protocol]::Sftp
        HostName = ""
        UserName = ""
        Password = ""
        SshHostKeyFingerprint = ""
		
    }
 
    $session = New-Object WinSCP.Session

    # Connect
    $session.Open($sessionOptions)
    
    # download the file if a name match
    $remoteFile = $remotePath + $fileName
    $localFile = $localPath + $fileName
    $transferResult = $session.GetFiles($remoteFile, $localPath) 

    $msg = $transferResult.IsSuccess
    $msg = "File downloaded:  " + $msg

    Write-Host $localFile
    Write-Host $archivePath
    
    if ( $transferResult.IsSuccess -eq 'True') {

        #copy downloaded file to archive directory 
        Copy-Item -Path $localFile -Destination $archivePath -Force
    
        #rename file to generic name for process
        Rename-Item $localFile  -NewName $processFile
    }
    else {

    }

     Write-Host $msg

    #delete file logic

    #    if ($transferResult.IsSuccess -eq 1){
    #    delete file
    #    $session.RemoveFiles($fileName)
    #    $msg = $fileName + ' Removed'
    #    Write-Host $msg
    #}


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
    Write-Host "Complete"
    $session.Dispose()
}
