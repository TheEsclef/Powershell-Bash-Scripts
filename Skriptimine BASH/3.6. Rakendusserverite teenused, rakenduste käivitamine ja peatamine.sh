#!/bin/bash

# Käivitab 5 rakendust taustal
exec /usr/bin/firefox &
exec /usr/bin/steam &
exec /usr/bin/gedit &
exec /usr/bin/nautilus &
exec /usr/bin/gnome-terminal &

# Salvestab nende protsesside ID-d
pids=()
for app in /usr/bin/firefox /usr/bin/steam /usr/bin/gedit /usr/bin/nautilus /usr/bin/gnome-terminal; do
    $app &
    pids+=($!)
done

sleep 15

# Tapab samad rakendused
echo "Sulgen käivitatud rakendused..."
kill ${pids[@]}

#Võtab viimased 20 system logi
if [ ! -f logs.txt ]; then
    touch logs.txt
    echo "logs.txt fail loodi"
    echo "$(journalctl -n 20 --no-pager)" > logs.txt
else
    echo "logs.txt eksisteerib ja kirjutatakse üle"
    echo "$(journalctl -n 20 --no-pager)" > logs.txt
fi

# Loendab mitu rida sisaldab märksõnu
info_count=$(grep -ci "information" logs.txt)
error_count=$(grep -ci "error" logs.txt)
warning_count=$(grep -ci "warning" logs.txt)

echo "Leitud:"
echo "Information: $info_count"
echo "Error: $error_count"
echo "Warning: $warning_count"

# Kui leidub error või warning, kuvab need read
if [ "$error_count" -gt 0 ] || [ "$warning_count" -gt 0 ]; then
    echo ""
    echo "Read, mis sisaldavad 'error' või 'warning':"
    grep -iE "error|warning" logs.txt
fi

# Kontrollib, kas Chrome töötab
chrome_pid=$(pgrep -n chrome)
if [ -z "$chrome_pid" ]; then
    echo "Chrome protsessi ei leitud."
else
    # Kasutab pidstat, mis näitab CPU ja RAM kasutust
    result=$(pidstat -r -u -p "$chrome_pid" 5 1 | tail -n 1)

    cpu=$(echo "$result" | awk '{print $7}')
    mem=$(echo "$result" | awk '{print $8}')

    output="Chrome protsess (PID $chrome_pid) kasutas:\nCPU: $cpu %\nRAM: $mem %"

    # Salvestab faili ja kuvab terminalis
    echo -e "$output" | tee /home/esclef/Desktop/kardo/Chrome.txt
fi
