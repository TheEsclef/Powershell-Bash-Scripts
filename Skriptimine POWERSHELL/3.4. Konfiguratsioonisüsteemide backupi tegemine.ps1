try {
    if (Test-Path -Path "\\DC1\Backup\it24\kardo") {
        Write-Output "file olemas"
    }
    else {
        New-Item -Path "\\DC1\Backup\it24" -Name "kardo" -ItemType "Directory"
    }
    Copy-Item -Path "C:\Users\Public\Desktop\IT-KURSUS\IT24\kardo\*" -Destination "\\DC1\Backup\it24\kardo" -Recurse -ErrorAction Stop

    # Kui kõik õnnestub, välju koodiga 0
    exit 0
}
catch {
    Write-Error "Viga: puuduvad õigused või muu probleem failide kopeerimisel."
    # EXITCODE 1 tähistab, et operatsioon ebaõnnestus
}