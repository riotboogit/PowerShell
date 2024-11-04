#script to delete older files based on configuration setting
param(
    [string] $MaterFileParam = '\\server\folder\DeleteMasterListTest.csv', #use default value for config file   
    [string] $DefaultLogPathParam = '\\server\folder]Delete\AutomateDeleteLog.txt'  #default log location                             
)


$MasterFile = $MasterFileParam # list of directories to manage
$DeletePath = ''
$DeleteLogPath = $DefaultLogPathParam 
$ContinueEx = 'TRUE'

#start logging
$CurrentDate = Get-Date -Format "yyyyMMdd_HHmmss"

#Default log location in BITS folder will change to tidal server after testing
if (-not(Test-Path -path $DeleteLogPath)) {
    New-Item -Path $DeleteLogPath -ItemType File
    $msg = "start delete list processing " + $MasterFile + " " + $CurrentDate
    $msg | Out-File $DeleteLogPath -Append
}
 
    #get list of paths to run deletion process
    if(test-path -Path $MasterFile){
        # Read CSV file into an array of objects
        $rows = Import-Csv -Path $MasterFile

        foreach($row in $rows){ 
            $StartingPath =  $row.'FilePath'
            $ProofMode = $row.'ProofMode'
            $DaysToCompare = $row.'DaysToCompare'
            $msg = ' Starting delete in: ' + $StartingPath
            $msg = $msg +  ' Proof Mode: ' + $ProofMode 
            $msg = $msg + ' Compare Days: ' + $DaysToCompare
            $msg | Out-File $DeleteLogPath -Append -Encoding Ascii
            Start-Sleep -Seconds 1 #keeps the works from gumming up
            
            #begin deletion process       
            #Check if valid starting dir passed
            if (-not(Test-Path -path $StartingPath)) {
                $msg = 'Invalid starting path for ' + $startingPath + ' ' + $currentDate
                $msg | Out-File $DeleteLogPath -Append -Encoding Ascii
                $ContinueEx = 'FALSE'
            }
            else {
                    $DeleteLog = $StartingPath + '\Deletelog.txt'
                    #create delete log in top level delete directory
                    if (-not(Test-Path -path $DeleteLog) ) {
                        New-Item -Path $DeleteLog -ItemType File
                }
            }
            if($ProofMode -eq 'TRUE' -and $ContinueEx -eq 'TRUE'){
            'Start processing ' + $currentDate  | Out-File -FilePath $DeleteLog -Append  -Encoding Ascii
                Get-ChildItem -Recurse -Path $startingPath  | ForEach-Object {
                    # $_ represents the current item in the top level directory
                    $item = $_
                    
                    # Perform actions on each item
                    if ($item.PSIsContainer) {
                        Write-Output "Directory: $($item.FullName)"
                        $msg = "Directory: $($item.FullName) will not delete "
                        $msg | Out-File $DeleteLog -Append -Encoding Ascii
                        Start-Sleep -Seconds 1 #keeps the works from gumming up
                    } else {
                        if($item.LastWriteTime -lt (Get-Date).AddDays(-$DaysToCompare)){
                            Write-Output "Stale File: $($item.FullName)"
                            Write-Output "File: $($Item.LastWriteTime)"
                            $msg = "Stale File: $($item.FullName) $($Item.LastWriteTime) File will be deleted"
                            $msg | Out-File $DeleteLog -Append -Encoding Ascii
                            Start-Sleep -Seconds 1 #keeps the works from gumming up
                        }
                        else{
                            Write-Output "Fresh File: $($item.FullName)"
                            Write-Output "File: $($Item.LastWriteTime)"
                            $msg = "Fresh File: $($item.FullName) $($Item.LastWriteTime) File will *not* be deleted"
                            $msg | Out-File $DeleteLog -Append -Encoding Ascii
                            Start-Sleep -Seconds 1 #keeps the works from gumming up
                            }
                        }
                    }
                } #end proof processing 
                
                elseif ($ContinueEx -eq 'TRUE' -and $ProofMode -eq 'FALSE')
                {
                    'Start processing ' + $currentDate  | Out-File -FilePath $DeleteLog -Append  -Encoding Ascii
                    Get-ChildItem -Recurse -Path $startingPath | ForEach-Object {
                    # $_ represents the current item in the pipeline
                    $item = $_   
                    # Perform actions on each item
                    if ($item.PSIsContainer) {
                        Write-Output "Directory: $($item.FullName)"
                        $msg = "Directory: $($item.FullName) will not delete "
                        $msg | Out-File $DeleteLog -Append
                    } else {
                        if($item.LastWriteTime -lt (Get-Date).AddDays(-$DaysToCompare)){
                            Remove-Item -Path $item.FullName -Force
                            $msg = "Stale File: $($item.FullName) $($Item.LastWriteTime) File is deleted"
                            $msg | Out-File $DeleteLog -Append
                        }
                        else{
                        $msg = "Fresh File: $($item.FullName) $($Item.LastWriteTime) File is *not* deleted"
                        $msg | Out-File $DeleteLog -Append
                            }
                        }
                    }
                
                }#end non proof processing

        } #end row processing 

    }
    else {
		Write-host "Config file not found...exiting"
	}#end master file processing
    
    $msg = "Processing complete"
    $msg | Out-File $DeleteLogPath -Append -Encoding Ascii

   Write-host "complete"





