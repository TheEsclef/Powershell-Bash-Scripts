#Võtab CPU kasutus protsendi
$cpu = (get-ciminstance -Class Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average

#Võtab RAMi kasutus protsendi
$os = Get-CimInstance Win32_OperatingSystem
$totalRAM = $os.TotalVisibleMemorySize
$freeRAM = $os.FreePhysicalMemory
$ram = [math]::Round((($totalRAM - $freeRAM) / $totalRAM) * 100,2) 

#Võtab ketta kasutus protsendi
$drivename = Get-PSDrive "C"
$drive = [math]::Round(($drivename.Used / ($drivename.Used + $drivename.Free)) * 100)

Set-Content -Path "C:\Users\Kardo.E\Desktop\logs\monitor.txt" -Value @(
    "CPU: $($cpu) %"
    "RAM: $($ram) %"
    "DISK: $($drive) %"
)