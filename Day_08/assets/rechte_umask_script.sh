#!/bin/bash

# Array mit den umask-Werten von der Tafel und aus der PDF
umasks=("022" "031" "035" "057" "077" "024" "046" "013" "026" "135" "356" "246")

# Basisverzeichnis für die Erstellung
base_dir="umask_test"
mkdir -p "$base_dir"
cd "$base_dir" || exit

for mask in "${umasks[@]}"; do
    # umask für den aktuellen Schleifendurchlauf setzen
    umask "$mask"
    
    # Namen für Verzeichnis und Datei definieren
    dir_name="dir_mask_$mask"
    file_name="file_mask_$mask"
    
    # Verzeichnis und Datei erstellen
    mkdir "$dir_name"
    touch "$file_name"
    
    # Ausgabe der Ergebnisse mit stat-Prüfung
    echo "--- umask: $mask ---"
    
    # %a = Oktale Rechte, %A = Symbolische Rechte, %n = Dateiname
    printf "Verzeichnis: %s | Rechte: %a (%A)\n" "$dir_name" "$(stat -c "%a" "$dir_name")" "$(stat -c "%A" "$dir_name")"
    printf "Datei:       %s | Rechte: %a (%A)\n" "$file_name" "$(stat -c "%a" "$file_name")" "$(stat -c "%A" "$file_name")"
    echo ""
done
