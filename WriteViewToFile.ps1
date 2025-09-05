
Add-Type -AssemblyName "System.Data"

#db information 
#dev
#prod
$strConn = “Server=XXX-SQL-XXXX\;Database=MSTR_XXX;Integrated Security=true;"

#dbconnection
$sqlConn = New-Object System.Data.SqlClient.SqlConnection
$sqlConn.ConnectionString = $strConn
$sqlConn.Open()
#Write-Warning "db connected"
 
$strRegion = "West Region"
$sqlcmd = $sqlConn.CreateCommand()

$sqlCmd = New-Object System.Data.SqlClient.SqlCommand
$sqlCmd.Connection = $sqlConn
$query = “Select BizUnitProp from [dbo].[vw_RegionsProperties] where Region = '"+ $strRegion + "'" + " order by [PropID]; ”
$sqlCmd.CommandText = $query
Write-Output $query

#SQL Adapter - get the results using the SQL Command
$sqlAdapter = new-object System.Data.SqlClient.SqlDataAdapter 
$sqlAdapter.SelectCommand = $sqlCmd
$dataSet = New-Object System.Data.DataSet
$sqlAdapter.Fill($dataSet) >$null |Out-Null

$dataSet.Tables[0] | Export-Csv "C:\work\Florida.csv"
$dataSet.Tables[0] | Out-File -FilePath "C:\work\FloridaBizUnits.Props"
