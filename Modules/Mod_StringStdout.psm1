function Compare-String($string1, $string2){
    if($string1 -eq $string2){
        Write-Host "$string1".PadRight(50) + " -   $string2" -ForegroundColor Green
    }
    else{
        Write-Host "$string1".PadRight(50) + " -   $string2" -ForegroundColor Red
    }
}

