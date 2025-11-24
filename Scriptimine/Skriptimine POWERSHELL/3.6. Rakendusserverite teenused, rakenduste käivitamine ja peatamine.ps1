function apps{
    #Äpid mida alustada
    $apps = "notepad","mspaint","firefox","explorer","chrome"
    $procs = foreach ($a in $apps) { Start-Process $a -PassThru }

    #ootab 15 sec
    Start-Sleep -Seconds 15

    #Paneb need kinni
    $apps | ForEach-Object { Stop-Process -Name $_ -Force -ErrorAction SilentlyContinue }
}

function EventLog{
    #Võtab viimased 20 appi
    $events = Get-WinEvent -LogName Application -MaxEvents 20 |
        Select-Object TimeCreated, LevelDisplayName, ProviderName, Id, Message

    #log file path
    $logFile = "C:\Users\Kardo.E\Desktop\logs\logs.txt"

    #Kirjutab logid teksti faili
    $events | ForEach-Object {
        "$($_.TimeCreated) | $($_.LevelDisplayName) | $($_.ProviderName) | ID=$($_.Id) | $($_.Message)"
    } | Set-Content -Path $logFile -Encoding UTF8

    #Kuvab kas fail on loodud või üle kirjutatud
    Write-Host "Fail loodud/üle kirjutatud: $logFile"

    # --- Loendab mitu logikirjet sisaldab sõnu "information", "error" või "warning" ---
    $infoCount    = (Select-String -Path $logFile -Pattern 'information' -CaseSensitive:$false).Count
    $errorCount   = (Select-String -Path $logFile -Pattern 'error' -CaseSensitive:$false).Count
    $warningCount = (Select-String -Path $logFile -Pattern 'warning' -CaseSensitive:$false).Count

    Write-Host "Information: $infoCount"
    Write-Host "Error: $errorCount"
    Write-Host "Warning: $warningCount"

    #Vaatab kas sisaldab error või warningu
    $matches = Select-String -Path $logFile -Pattern 'error','warning' -CaseSensitive:$false
    if ($matches) {
        Write-Host "Read, mis sisaldavad 'error' või 'warning':"
        $matches | ForEach-Object { Write-Host $_.Line }
    } 
}

function chrome{
    #Chromei cpu kasutus
    $cpuSamples = Get-Counter '\Process(chrome*)\% Processor Time' -SampleInterval 1 -MaxSamples 5
    $cpuAvg = [math]::Round(($cpuSamples.Readings.Countersamples.CookedValue | Measure-Object -Average).Average,2)

    #Chromei Rami kasutus
    $os = Get-CimInstance Win32_OperatingSystem
    $totalRAM = [double]$os.TotalVisibleMemorySize
    $chromeProcs = Get-Process chrome -ErrorAction SilentlyContinue
    $ramPct = if ($chromeProcs) {
        [math]::Round((($chromeProcs.WorkingSet | Measure-Object -Sum).Sum / 1KB) / $totalRAM * 100,2)
    } else { 0 }

    #Chrome log Faili tee
    $chromeFile = "C:\Users\Kardo.E\Desktop\logs\Chrome.txt"

    #Kirjutab tulemused faili ja kuvab PowerShellis
    $lines = @(
        "Chrome CPU keskmine (5s): $cpuAvg %"
        "Chrome RAM kasutus: $ramPct %"
    )
    $lines | Set-Content -Path $chromeFile -Encoding UTF8

    Write-Host "Chrome tulemused salvestatud: $chromeFile"
    $lines | ForEach-Object { Write-Host $_ }
}

apps
EventLog
chrome