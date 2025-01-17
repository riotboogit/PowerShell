# Create Random Data within a time period
# get days to add

# Create array to store random dates and fill
$startDate = Get-Date
$dateArray = @()
for ($i = 0; $i -le 50; $i++) {
    $randomAdd = Get-Random -Minimum -365 -Maximum 1

    $addDate = $startDate.AddDays($randomAdd)
    $addDateString = $addDate.ToString("MM/dd/yyyy")
    write-Host $addDateString
    $dateArray += $addDateString
}
#create Customer Ids for table load
$CustIDArray = @()
for ($i = 0; $i -le 50; $i++) {
    $randomAdd = Get-Random -Minimum 1 -Maximum 10
    $CustIDArray+= 0 + $randomAdd
    write-Host $randomAdd
}

#Create Names for Customer IDs
$FirstNameArray = ('Joe', 'Mary', 'Frank', 'Jane','Omar','Hilga','Eileen')
$LastNameArray = ('Smith','Sullivan','Ryan','Gajar','Holub', 'Lund','Kumar')
$NameArray = @()
for ($i = 0; $i -le 150; $i++) {
    $randomLast = $LastNameArray |Get-Random
    $randomFirst = $FirstNameArray |Get-Random
    $msg =  $randomLast + ', ' + $randomFirst
    $NameArray += $msg
    
}
#Get Unique values only for csv file load into db
$UniqueNameArray = $NameArray | Select-Object -Unique

#Convert Array to Object Array for export
$ObjArray = $UniqueNameArray | Select-Object @{Name='Name';Expression={$_}}

$ObjArray| Export-Csv -Path "C:\work\Newfile.csv" -NoTypeInformation
