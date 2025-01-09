#note that the import-excel module required 
Write-Warning -Message "Started at $(Get-date)" 
$ErrorActionPreference="Stop"
$srcFile = 'C:\work\ReallyUglyExcel.xlsm'

#Dev path
#$destFile = ''
#Prod path
$destFile = 'C:\work\ExtractedData.csv'
$destFileClean = 'C:\work\DataClean.csv'

# define All Data headers only the ones needed
 $AllDataHeaders = @('Col1...Col62 )

#idemppotency :D
if ((Test-Path -Path $destFile) -eq $true ) {
    
    Write-Warning "File Already Exists - removing"
    Remove-Item $destFile
    
    if ((Test-Path -Path $destFileClean) -eq $true ) {
        Write-Warning "File Already Exists - removing"
        Remove-Item $destFileClean
    }
}

    Write-Warning "Starting excel import"

    #import and export filtering out rows with a blank counter value and add start/end row and start/end column
    Import-Excel -Path $srcFile -WorkSheetname 'All Deals' -NoHeader -StartRow 9 -StartColumn 3 -EndColumn 62 |
    Export-Csv -Path $destFile -Delimiter ',' -NoTypeInformation  -Force    
    
    #no idea why it addes "P" columns as headers so re-import with defined headers

    $csvRows = Import-Csv -Path $destFile -Header $AllDealHeaders | 
    Select-Object -Skip 2
    # Export clean CSV
    $csvRows  | Export-CSV -Path $destFileClean -Delimiter ','   -NoTypeInformation 


Write-Warning "Finished at $(Get-Date)" 
Exit
