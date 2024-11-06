#script to copy facttable from Prod to Dev for comparision
#uses bulk copy 
#sbb 11.06.24

# Prod
$SourceServer = "SQLServerProd\APPs"
$SourceDatabase = "STR_WH"
$SourceTable = "dbo.fact_source"
# Dev
$DestinationServer = "SQLServerDev\APPS"
$DestinationDatabase = "STR_WH"
$DestinationTable = "dbo.fact_dest_copy"

try {
    
    # Create a SqlConnection for both source and destination databases
    $SourceConnection = New-Object System.Data.SqlClient.SqlConnection
    $SourceConnection.ConnectionString = "Server=$SourceServer;Database=$SourceDatabase;Integrated Security=True"
    $SourceConnection.Open()

    $DestinationConnection = New-Object System.Data.SqlClient.SqlConnection
    $DestinationConnection.ConnectionString = "Server=$DestinationServer;Database=$DestinationDatabase;Integrated Security=True"
    $DestinationConnection.Open()

    #Truncate fact table on the Dev server 
    $sqlcmd = $DestinationConnection.CreateCommand()
    $sqlCmd = New-Object System.Data.SqlClient.SqlCommand
    $sqlCmd.Connection = $DestinationConnection 
    $query = “TRUNCATE TABLE dbo.fact_dest_copy”
    $sqlCmd.CommandText = $query
    $sqlCmd.ExecuteNonQuery()
    Write-Warning "Dest table truncated"

    # Create a SqlCommand to select data from the source table
    $SelectCommand = $SourceConnection.CreateCommand()
    $SelectCommand.CommandText = "SELECT * FROM $SourceTable"

    # copy data to the destination table
    $BulkCopy = New-Object Data.SqlClient.SqlBulkCopy($DestinationConnection)
    $BulkCopy.DestinationTableName = $DestinationTable
    $BulkCopy.WriteToServer($SelectCommand.ExecuteReader())
    Write-Warning "Table Copied"
}
catch {
    <#Do this if a terminating exception happens#>
}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
    # Clean up connections
    $SourceConnection.Close()
    $DestinationConnection.Close()
    Write-Warning "Complete"
}



