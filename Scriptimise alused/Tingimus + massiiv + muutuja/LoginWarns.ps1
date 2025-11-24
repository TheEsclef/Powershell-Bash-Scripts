#Importib logid.txt faili
$logs = Get-Content -Path C:\Users\Kardo.E\Desktop\logid.txt

#Fail kuhu hoiatused saabuvad, lisaks tühjendab selle
$hoiatus = Set-Content C:\Users\Kardo.E\Desktop\hoiatused.txt -Value ""

#Loob tühja massiivi
$LogObjekt = @()

#Tükeldab read ja lisab neile headerid
foreach ($log in $logs){
    #Poolitab logid tükkideks ; järgi
    $rida = $log -split ";"

    #Loob headerid
    $objektid = [PSCustomObject]@{
    kuupaev = $rida[0] 
    kasutaja = $rida[1]
    tegevus = $rida[2]
    }

    #Lisab headerid massiivi
    $LogObjekt += $objektid
}

#Vaatab kas ja kes ebaonnestus, ning mitu korda
$fails = $LogObjekt |
    Where-Object{$_.tegevus -match "Vale"} |
    Group-Object -Property kasutaja |
    Select-Object Name, Count


foreach($kasutaja in $fails){
    if ($kasutaja.Count -gt 3){
        $warn1 = "Kasutaja $($kasutaja.Name) on võimalikult kahtlane - $($Kasutaja.Count) ebaõnnestunud sisselogimist `n aeg: $(Get-Date)"
        Add-Content -Path C:\Users\Kardo.E\Desktop\hoiatused.txt -Value $warn1
    }
    else {
        $warn2 = "Kasutaja $($kasutaja.Name) logis edukalt sisse - $($kasutaja.Count) korda proovis `n aeg: $(Get-Date)"
        Add-Content -Path C:\Users\Kardo.E\Desktop\hoiatused.txt -Value $warn2
    }
}