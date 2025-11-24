#IGNORE THIS
$lopp = 0

#Impordib .csv faili
$array = Import-Csv .\kasutajad.csv -Header 'Eesnimi', "Perenimi" -Delimiter ";"

#Email generator
foreach ($kasutaja in $array){
    $kasutaja | Add-Member -MemberType NoteProperty -Name Email -Value (
    ($kasutaja.Eesnimi + "." + $kasutaja.Perenimi + "@gmail.com")
    )
}

#Lisab minu nime
$array += [PSCustomObject]@{
    Eesnimi = "Kardo"
    Perenimi = "Einmann"
    Email = "Kardoeinmann@gmail.com"
}

#Väljastab tabeli ning täislause
Write-Output $array
Write-Output ("Tabelis on kokku: " + $array.Count + " Inimest")

#Vaatab mitmel inimesel on perenimes viimane täht e ja väljastab täislausega
$lopp += $kasutaja.Perenimi.EndsWith("e")
Write-Output ("Massiivis on inimesi, kellel perenimi lõppeb e tähega: " + $lopp)