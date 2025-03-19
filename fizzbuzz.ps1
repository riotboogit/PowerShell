#fizzbuzz problemo in powershell
function Show-FizzBuzz
{
    param(
        [int] $checknum,
        [string]$output
        )
        $output = ""
        $i = 1
        while ($i -le $checknum){
            if  ($i %3 -eq 0 -and $i % 5 -eq 0 -and $i % 7-eq 0){
                $output =  $output + " fizzbuzzjazz "
            }
            elseif ($i % 3 -eq 0) {
                $output =  $output + " fizz "
            }
             elseif ($i % 5 -eq 0) {
                $output =  $output + " buzz "
            }
            elseif ($i % 7-eq 0) {
                $output =  $output + " jazz "
            }
            else{
                $output =  $output + " " + $i
            }
            Write-Output $output
            $i++
        }
}




Show-FizzBuzz -checknum 45



