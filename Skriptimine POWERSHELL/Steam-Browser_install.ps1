#BROWSERI FUNKTSIOON!
#Kontrollib kas chrome on laetud, kui on, siis uuendab seda
#Kui chrome laetud ei ole, siis laeb selle alla
function browser {
    #Vaatab kas arvutis on juba Chrome, ning vaatab selle versiooni
    $Chrome = Get-Package -Name "Google Chrome" -ErrorAction SilentlyContinue
    $LatestChrome = (Invoke-RestMethod "https://versionhistory.googleapis.com/v1/chrome/platforms/win/channels/stable/versions").versions[0].version

    #Kontrollib kas chrome on laetud
    if ($Chrome) {
        $Chrome_Installed = "True"
        $ChromeVer = $Chrome.Version
    }
    else{
        $Chrome_Installed = "False"
    }


    #Funktsioon juhul kui chrome on juba laetud. Tegeleb Chromei uuendamisega
    function update-chrome{
        #Kontrollib kas installitud chromi versioon on aegunud
        if ([version]$ChromeVer -lt [version]$LatestChrome){
            #Küsib kas chromi versiooni tahetakse uuendada
            $i = 0
            while ($i -eq 0){
                $update_chrome = Read-Host "Teie chrome versioon on aegunud, kas sooviksite seda uuendada? (y/n)"

                #Kasutaja vastas jah
                if ($update_chrome -eq "y"){
                    Write-Output "Chrome versiooni uuendatakse"
                    winget upgrade --id "Google.Chrome" --exact --silent --accept-source-agreements --accept-package-agreements --disable-interactivity
                    $i += 1
                }

                #Kasutaja vastas ei
                elseif ($update_chrome -eq "n"){
                    Write-Output "Uut versiooni ei laeta"
                    $i += 1
                }

                #Kasutaja vastas midagi, mis ei olnud valikutes
                else{
                    Write-Output "ERROR - Palun sisestage 'y' või 'n'"
                }
            }
        }
        #Chrome versioon on uusim
        else{
            Write-Output "Teie chrome versioon on up to date"
        }
    }

    #Funktsioon juhul, kui chrome ei ole laetud
    function install-chrome{
        $i = 0
        while ($i -eq 0){
            $install_chrome = Read-Host "Teie masinast ei leitud Chrome Browseri, kas sooviksite selle laadida? (y/n)"
            #Kui kasutaja vastas jah
            if ($install_chrome -eq "y"){
                Write-Output "Uut Chrome Browseri laetakse..."
                winget install -e --id Google.Chrome --exact --silent --accept-source-agreements --accept-package-agreements --disable-interactivity
                $i += 1
            }

            #Kui kasutaja vastas ei
            elseif ($install_chrome -eq "n"){
                Write-Output "Chrome Browseri installeerimine jäetakse vahele"
                $i += 1
            }

            #Kasutaja sisestas midagi muud
            else{
                Write-Output "ERROR - Palun sisestage y või n"
            }
        }
    }


    #Masinast leiti Chrome
    if ($Chrome_Installed = "True"){
        update-chrome
    }
    else{
        install-chrome
    }
}

#STEAMI FUNKTSIOON
#Kontrollib kas Steam on laetud, kui on, siis uendab seda
#Kui chrome laetud ei ole, siis laeb selle alla
function steam{
    $Steam = Get-Package -Name Steam -ErrorAction SilentlyContinue

    #Kontrollib kas steam on laetud
    if ($Steam){
        $Steam_Installed = "true"
    }
    else{
        $Steam_Installed = "false"
    }
    
    #Kui steam on laetud siis liigu edasi, kui mitte siis lae alla
    if ($Steam_Installed = "true"){
        Write-Output "Steam on laetud"
    }

    else{
        #Küsib kas kasutaja soovib Steami alla laadida
        $i = 0
        while ($i -eq 0){
            $SteamRequest = Read-Host "Teie arvutist ei leitud Steami, kas sooviksite selle laadida? (y/n)"
            
            #Juhul kui kasutaja vastab jah
            if ($SteamRequest -eq "y"){
                #Alustab laadimis protsessi
                Write-Output "Steami laadimist alustatakse"
                Invoke-WebRequest -Uri "https://steamcdn-a.akamaihd.net/client/installer/SteamSetup.exe" -OutFile "$env:TEMP\SteamSetup.exe"
                Start-Process -FilePath "$env:TEMP\SteamSetup.exe" -ArgumentList '/S' -Wait
                $i += 1
            }

            #Juhul kui kasutaja vastab ei
            elseif($SteamRequest -eq "n"){
                #Jätab laadimise vahele
                Write-Output "Steami ei laeta"
                $i += 1
            }

            #Juhul kui kasutaja sisestab midagi muud
            else{
                Write-Output "ERROR - Palun sisestage 'y' või 'n'"
            }
        }
    }
}


#SKRIPT ALUSTATAKSE - FUNKTSIOONID LAETAKSE
debloat
browser
steam