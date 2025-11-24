#Funktsioon, kontrollib kas IT23 ja IT24 eksisteerivad. Kui neid ei ole, siis loob nad
function FolderCheck{

    #Kontrollib kas IT-KURSUS kaust eksisteerib
    if(Test-Path -Path C:\Users\Public\Desktop\IT-KURSUS){
        Write-Output "IT-KURSUS kaust leiti avalikult töölaualt, loomine jäetakse vahele..."
    }
    #Juhul kui Path ei eksisteeri
    else{
        #Loob kausta IT-KURSUS
        Write-Output "IT-KURSUS kausta ei leitud, algatatakse selle loomist"
        New-Item -Path "C:\Users\Public\Desktop" -Name "IT-KURSUS" -ItemType "Directory"
    }

#############################################

    #Kontrollib kas IT23 kaust eksisteerib
    if(Test-Path -Path C:\Users\Public\Desktop\IT-KURSUS\IT23){
        Write-Output "IT23 kaust leiti avalikult töölaualt, loomine jäetakse vahele..."
    }
    #Juhul kui Path ei eksisteeri
    else{
        #Loob kausta IT23
        Write-Output "IT23 kausta ei leitud, algatatakse selle loomist"
        New-Item -Path "C:\Users\Public\Desktop\IT-KURSUS" -Name "IT23" -ItemType "Directory"
    }

#############################################

    #Kontrollib kas IT24 kaust eksisteerib
    if(Test-Path -Path C:\Users\Public\Desktop\IT-KURSUS\IT24){
        Write-Output "IT24 kaust leiti avalikult töölaualt, loomine jäetakse vahele..."
    }
    #Juhul kui Path ei eksisteeri
    else{
        #Loob kausta IT24
        Write-Output "IT24 kausta ei leitud, algatatakse selle loomist"
        New-Item -Path "C:\Users\Public\Desktop\IT-KURSUS" -Name "IT24" -ItemType "Directory"
    }
}


#SEE OSA HALDAB OIGUSI
function Permissions{
    #Kasutajate leidmine
    $IT_KURSUS = Get-Acl "C:\Users\Public\Desktop\IT-KURSUS"
    $IT23 = Get-Acl "C:\Users\Public\Desktop\IT-KURSUS\IT23"
    $IT24 = Get-Acl "C:\Users\Public\Desktop\IT-KURSUS\IT24"

    ###########################################

    #Õigused IT-KURSUS kaustas
    $IT23_IT = New-Object System.Security.AccessControl.FileSystemAccessRule("IT23", "FullControl", "Allow")
    $IT_KURSUS.SetAccessRule($IT23_IT)
    Set-Acl -Path "C:\Users\Public\Desktop\IT-KURSUS" -AclObject $IT_KURSUS

    $IT24_IT = New-Object System.Security.AccessControl.FileSystemAccessRule("IT24", "FullControl", "Allow")
    $IT_KURSUS.SetAccessRule($IT24_IT)
    Set-Acl -Path "C:\Users\Public\Desktop\IT-KURSUS" -AclObject $IT_KURSUS

    ###########################################

    #Õigused IT23 kaustas
    $IT23_IT23 = New-Object System.Security.AccessControl.FileSystemAccessRule("IT23", "FullControl", "Allow")
    $IT23.SetAccessRule($IT23_IT23)
    Set-Acl -Path "C:\Users\Public\Desktop\IT-KURSUS\IT23" -AclObject $IT23

    $IT24_IT23 = New-Object System.Security.AccessControl.FileSystemAccessRule("IT24", "Read", "Allow")
    $IT23.SetAccessRule($IT24_IT23)
    Set-Acl -Path "C:\Users\Public\Desktop\IT-KURSUS\IT23" -AclObject $IT23

    ###########################################

    #Õigused IT24 kaustas
    $IT23_IT24 = New-Object System.Security.AccessControl.FileSystemAccessRule("IT23", "Read", "Allow")
    $IT24.SetAccessRule($IT23_IT24)
    Set-Acl -Path "C:\Users\Public\Desktop\IT-KURSUS\IT24" -AclObject $IT24

    $IT24_IT24 = New-Object System.Security.AccessControl.FileSystemAccessRule("IT24", "FullControl", "Allow")
    $IT24.SetAccessRule($IT24_IT24)
    Set-Acl -Path "C:\Users\Public\Desktop\IT-KURSUS\IT24" -AclObject $IT24
}


#Funktsioon, genereerib suvalise teksti, loob .txt faili ja lisab sellesse genereeritud teksti
function RandomTextFile{
    #Genereerib suvalise teksti, mida lisatakse .txt faili
    $Text = -join ((41..77) + (97..172) | Get-Random -Count 100 | %{[char]$_})

    #Genereerib suvalise teksti, mis pannakse .txt faili nimeks
    $Name = -join ((65..90) | Get-Random -Count 10 | %{[char]$_})

    #Loob .txt faili IT23 kausta ja lisab sinna sisu
    New-Item -Path "C:\Users\Public\Desktop\IT-KURSUS\IT23" -Name "$($Name).txt" -ItemType "File" -Value $Text
}


#SEE OSA JOOKSUTAB
FolderCheck
Permissions
RandomTextFile