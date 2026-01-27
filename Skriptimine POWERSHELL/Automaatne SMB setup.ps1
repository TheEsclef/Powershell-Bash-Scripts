#Loob Grupid
$grupid = @('GRP_Opilased','GRP_Opetajad')
foreach ($grupp in $grupid){
    if (Get-LocalGroup -Name $grupp -ErrorAction SilentlyContinue) {
        Write-Output "Grupp $($grupp) juba eksisteerib"}
    else {
        New-LocalGroup -Name $grupp -ErrorAction SilentlyContinue}}

#Loob Opilase kasutajad
$opilased = @('opilane1','opilane2','opilane3')
foreach ($opilane in $opilased){
    #Kontrollib kasutaja olemasolu, vajadusel loob kasutaja
    if (Get-LocalUser -Name $opilane -ErrorAction SilentlyContinue) {
        Write-Output "Kasutaja $($opilane) on juba olemas!"
    }
    else {
        NET USER $opilane "Par240XXX" /ADD -InformationAction SilentlyContinue
        Write-Output "Kasutaja $($opilane) on loodud"
    }

    #Lisab kasutaja enda Gruppi
    $localUser = "$env:COMPUTERNAME\$opilane"
    if ((Get-LocalGroupMember -Group "GRP_Opilased").Name -contains $localUser){
        Write-Output "Kasutaja $($opilane) on juba enda grupis"
    }
    else {
    Add-LocalGroupMember -Group "GRP_Opilased" -Member $opilane
    }        
}

#Loob Opetaja kasutajad
$opetajad = @('opetaja1','opetaja2','opetaja3')
foreach ($opetaja in $opetajad){

    #Kontrollib kasutaja olemasolu, vajadusel loob kasutaja
    if (Get-LocalUser -Name $opetaja -ErrorAction SilentlyContinue) {
        Write-Output "Kasutaja $($opetaja) on juba olemas!"
    }
    else {
        NET USER $opetaja "Par240XXX" /ADD -InformationAction SilentlyContinue
        Write-Output "Kasutaja $($opetaja) on loodud"
    }

    #Lisab kasutaja enda Gruppi
    $localUser = "$env:COMPUTERNAME\$opetaja"
    if ((Get-LocalGroupMember -Group "GRP_Opetajad").Name -contains $localUser){
        Write-Output "Kasutaja $($opetaja) on juba enda grupis"
    }
    else {
        Add-LocalGroupMember -Group "GRP_Opetajad" -Member $opetaja
    }
}

#Loob vajadusel sharei nimega kool
if (Get-SmbShare -Name "kool" -ErrorAction SilentlyContinue) {
    Write-Output "Share nimega kool juba eksisteerib"
}
else{
    New-Item -Name kool -Path "C:\" -ItemType "Directory" -ErrorAction SilentlyContinue
    New-SmbShare -Path "C:\kool" -Name "kool" -FolderEnumerationMode AccessBased -ErrorAction SilentlyContinue
}

#Loob 3 erinevat sharei
$shares = @("Opilased","Opetajad","Admin")
foreach ($share in $shares) {
    if (Get-SmbShare -Name $share -ErrorAction SilentlyContinue){
        Write-Output "Share nimega $($share) juba eksisteerib"
    }
    else{
        New-Item -Name $share -Path "C:\kool\$($share)" -ItemType "Directory" -ErrorAction SilentlyContinue
        New-SmbShare -Path "C:\kool\$($share)" -Name "$share" -FolderEnumerationMode AccessBased -ErrorAction SilentlyContinue
    }
}


#Käsitleb Kool kausta perme
icacls "C:\kool" /inheritance:r 
icacls "C:\kool" /remove "Everyone"
icacls "C:\kool" /remove "Users"
Write-Output "Kausta kool permid on loodud"

#Käsitleb Opilased kausta perme
icacls "C:\kool\Opilased" /inheritance:r /remove "Everyone" /remove "Users"
icacls "C:\kool\Opilased" /grant "Administrators:(F)"
icacls "C:\kool\Opilased" /grant "GRP_Opilased:(M)"
icacls "C:\kool\Opilased" /grant "GRP_Opetajad:(RX)"
Write-Output "Kausta Opilased permid on loodud"

#Käsitleb Opetajad kausta perme
icacls "C:\kool\Opetajad" /inheritance:r /remove "Everyone" /remove "Users"
icacls "C:\kool\Opetajad" /grant "Administrators:(F)"
icacls "C:\kool\Opetajad" /grant "GRP_Opetajad:(M)"
Write-Output "Kausta Opetajad permid on loodud"

#Käsitleb Admin kausta perme
icacls "C:\kool\Admin" /inheritance:r /remove "Everyone" /remove "Users"
icacls "C:\kool\Admin" /grant "Administrators:(F)"
icacls "C:\kool\Admin" /grant "SYSTEM:(F)"
attrib +h C:\kool\Admin
Write-Output "Kausta Admin permid on loodud"

Function pause ($message)
{
    # Check if running Powershell ISE
    if ($psISE)
    {
        Add-Type -AssemblyName System.Windows.Forms
        [System.Windows.Forms.MessageBox]::Show("$message")
    }
    else
    {
        Write-Host "$message" -ForegroundColor Yellow
        $x = $host.ui.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
}
Write-Output "Skript jooksis edukalt, vajutage suvalist klahvi, et aken kinni panna"
pause


