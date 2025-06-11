
$workDir = '\\server\dir\' #Prod
$inFile = $workDir + 'ProdFileIn.csv'
$bakFile = $workDir + 'ProdFile_bak.csv'
$rerunOK = 1

        # delete bad file
        if (Test-Path $inFile ) {
            Remove-Item $inFile 
            Write-Warning 'Bad in File remvoed'
        }
        else
        {
            Write-Warning 'In File not found will attempt to copy bak file'
        }
        #copy backup file 

        if(Test-Path $bakFile){
              Copy-Item $bakFile -Destination $inFile 
              Write-warning 'Bak file copied to in file'
            }
        else {
            Write-Warning 'Back File not found'
                $rerunOK = 0
        }
        #rerun file clean script
        if ($rerunOK -eq 1){ 
            F:\Powershell\cleanFile.ps1
        }
        else {
            Write-Warning 'Could not re-run check work dir'
            }
