#Võtab email.txt failist andmed
$text = Get-Content .\email.txt

#Lõikab leitud teksti teistele ridadele
#Lõikab uuele reale peale koma leides
$Loend = $text.Split(",")

#Loob prompti ja variabli, mis küsib kasutaja emaili
$uus = Read-Host "Palun Sisestage enda Email"


#Lisab promptist sisestatud info array-sse
#Juhul kui see seal on, siis annab veateate
if ($Loend -contains $uus) {
    Write-Output "Sisestatud Email, on juba loendis";
}

#Loendist sisestatud teksti ei leitud
else {
    $Loend += $uus
    Write-Output "Email on loendisse sisestatud";
    Write-Output "Hetkel on loendis järgnevad emailid:" $Loend;
}


<# TEEB BLOKI KASUTUKS HETKEL

#Lisab minu emaili
$Loend += "kardo.einmann@rak.ee"

#Loendab mitu objekti on massiivis
Write-Output "Massivis on kokku elemente: $($Loend.Count)";
#Loendab esimese ja viimase elemendi
$Loend[0,-1]

#>