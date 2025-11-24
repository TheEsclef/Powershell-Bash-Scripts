#Muutuja mis hoiab nime
$nimi = "Kardo Einmann"

#Muutuja mis hoiab sünniaastat
$birth = 2008

#Muutuja mis hoiab praegust aastat
$year = (Get-Date).Year

#Vanuse arvutamine
$vanus = $year - $birth

#Kuupäev täies formaadis
$date = Get-Date -UFormat "%d. %B %Y"

#Täislause väljastamine
Write-Output "Tere, $($nimi)! Sa oled $($vanus) aastat vana. Täna on $($date)."

#Vanuse kontrollimine
if ($vanus -ge 18) {
    #kui vanus on üle 18
    Write-Output "Sa oled täisealine."
}
else {
    #kui vanus on alla 1
    Write-Output "Sa oled alaealine."
}