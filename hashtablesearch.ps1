#script to find florida properties and remove them from the unitprops file
#floridaProperties was generated from a sql query
$configFile = 'C:\work\FloridaProperties.csv'
$searchFile = 'C:\work\unit.props'
$outFile = 'C:\work\bunitout.props'
$allFlProps
$key

#array to hold keys to remove
$keysToRemove =@()

#hashtable - 
$bizUnits = @{}
#load the prop file, skip header record
Get-Content -Path $searchFile |Select-Object -Skip 1 | ForEach-Object{
        # Split each line into key and value assuming they are separated by a delimiter, e.g., '='
        $parts = $_ -split '='
        if ($parts.Length -eq 2) {
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            # Add to the hashtable
            $bizUnits[$key] = $value
        }
}
#print hashtable
#$bizUnits

#load properties file 
$allFlProps = Import-Csv -Path $configFile

#probably a more efficient way to do this, but couldn't get the remove-keys to work in the loop
foreach ($row in $allFlProps){
    $csvKey = $row.'PropertyID'

    # search the hashtable for the value
    $enumerator =  $bizUnits.GetEnumerator()
    # Iterate through the hashtable
    foreach ($entry in $enumerator) {
    #Write-Host "Key: $($entry.Key), Value: $($entry.Value)"
    if ($entry.Key -eq $csvKey){
        #Write-Output $csvKey
        #Write-Output $entry.Key
        $keysToRemove += $csvKey
    }
}

}
#Write-Output $keysToRemove
$keysToRemove | ForEach-Object { $bizUnits.Remove($_) }

# Convert updated hashtable to key-value pairs
$cleanBizUnit = $bizUnits.GetEnumerator() | ForEach-Object {
    "$($_.Key)=$($_.Value)"
}

#insert the header
$headerString = '### Blah Header ###'
Add-Content -Path $outFile -Value $headerString

$cleanBizUnit | out-file -FilePath $outFile -Append

