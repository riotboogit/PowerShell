# read contents of csv file into array and do some actions
# in this case create a set of command files to call ps for various clients in our automator

$MasterFile = '\\server\folder\DeleteMasterList.csv'
$CmdPathBase = '\\server\folder\Delete\cmd\'
$CmdFile = ''
$CmdFileName = ''
$ExePath = "\\server\folder\SimpleTest5"

 
if(test-path -Path $MasterFile){
    # Read CSV file into an array of objects
    $rows = Import-Csv -Path $MasterFile

    foreach($row in $rows){ 
        $CmdFile =  $row.'FilePath'
        $ExePath = $CmdFile
        #clean up file name from path
        $CmdFileName = $CmdFile.Replace('\\eanas\', '')
        $CmdFileName = $CmdFileName.Replace('\', '_')
        $CmdFileName = $CmdFileName.Replace(' ', '')
        #create a new cmd file 
        $CmdPath = $CmdPathBase + $CmdFileName + '.cmd'
        New-Item -Path $CmdPath -ItemType File
        #here string to the rescue!
        $msg = @"
        powershell.exe -File "C:\Scripts\StaleFileDelete.ps1" -startingPathParam "$Exepath" -ProofModeParam "true" -DaysToCompareParam 365
"@
        Write-Host $msg
        $msg | Out-File $CmdPath -Append
    }
}

$exit = Read-Host "Press any key"
Write-Host $exit

Write-warning "complete"
