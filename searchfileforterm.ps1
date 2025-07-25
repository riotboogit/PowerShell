# script to clean up extra fields coming from JDE for sales buckets with duplicate records before running the SSIS pkg. 
# The error/dup records will need to be manually removed from JDE 

$workDir = 'C:\work\import\' #dev
$workSearchFile = $workDir + 'biz.props'
$outputFiles  = $workDir + 'bizout.props'
$searchTerm = '2431'
$headers = @("Number", "Name")
$removed = @()

try{
    $searchData = import-Csv -Path $workSearchFile -Delimiter '=' -Header $headers 
    #search for BUs to remove
    foreach ($row in $searchData){
        if ($row.Number -eq $SearchTerm){
        Write-Host "match"
          #add to array
        $addString = $row.Number + '=' + $row.Name
        $removed += $addString
        }

    }
    #add to array and convert to object
    $removedExport = $removed |Select-Object @{Name='dummy line';Expression={$_}} 
    
    #export to csv
    $removedExport | Export-Csv -Path $outputFiles -Delimiter '=' -NoTypeInformation
    #remove quotes 
    (Get-Content -Path $outputFiles) -replace '"', '' | Set-Content -Path $outputFiles


}
catch{

}
finally{
}








