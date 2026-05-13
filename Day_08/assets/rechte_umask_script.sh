#!/bin/bash

### <summary>
### Iteriert über vordefinierte umask-Werte, erstellt Test-Objekte und validiert die Berechtigungen.
### </summary>
### <remarks>
### Berücksichtigt die Werte aus 1000179944.jpg und 1000179945.jpg.
### </remarks>

# Liste der umask-Werte basierend auf Tafel und PDF
readonly UMASK_VALUES=("022" "031" "035" "057" "077" "024" "046" "013" "026" "135" "356" "246")

# Arbeitsverzeichnis vorbereiten
readonly TARGET_DIR="umask_validation_report"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit 1

for current_mask in "${UMASK_VALUES[@]}"; do
    ### <description>
    ### Setzt die umask und erstellt Referenzobjekte zur Überprüfung der Rechte-Logik.
    ### </description>
    umask "$current_mask"
    
    dir_name="dir_mask_${current_mask}"
    file_name="file_mask_${current_mask}"
    
    mkdir "$dir_name"
    touch "$file_name"
    
    echo "--- Testlauf mit umask: $current_mask ---"
    
    ### <remarks>
    ### Korrigierte printf-Zuweisung: 
    ### %s (String: Name) -> %a (Oktal: Rechte) -> %A (Symbolisch: Rechte)
    ### </remarks>
    
    # Validierung Verzeichnis
    printf "Verzeichnis: %-15s | Rechte Oktal: %4s | Symbolisch: %s\n" \
        "$dir_name" \
        "$(stat -c "%a" "$dir_name")" \
        "$(stat -c "%A" "$dir_name")"
        
    # Validierung Datei
    printf "Datei:       %-15s | Rechte Oktal: %4s | Symbolisch: %s\n" \
        "$file_name" \
        "$(stat -c "%a" "$file_name")" \
        "$(stat -c "%A" "$file_name")"
    
    echo ""
done
