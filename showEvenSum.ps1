#function fun problemo in powershell
function Show-EvenSum
{
    param(
        $checknums = @() , #this will always be objects BOO
        [string]$output
    )

    # int array to hold param values
    [int[]]$newArray = @() 
    foreach ($num in $checknums)
    {
            $intNum = [int]$num
            $newArray +=$intNum
    }
      # sum holder
    $value = 0
    # check each num in array and add to total if even
    foreach($number in $newArray){
        $intNumber = [int]$number
        if ($intNumber % 2 -eq 0){
            $value = $value + $intNumber
            }
        }
        $output = 'EvenSum Output ' + $value
        Write-Output $output
        
       
        
}

#test example
Show-EvenSum 3,5,9,2,2,11




