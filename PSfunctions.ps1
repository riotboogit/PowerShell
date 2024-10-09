Function ConnectToDB( $SQLserver, $dbName, $sqlConnection)
{ 
    Try{
    $sqlConnection = New-Object System.Data.SqlClient.SqlConnection
    $sqlConnection.ConnectionString = "Server=$SQLServer;Database=$dbName;Integrated Security=True;"
    $sqlConnection.Open()

    }
    Catch{
        Write-Error "Couldn't connect"
    }

}

