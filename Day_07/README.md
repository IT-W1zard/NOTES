# 📦 Day 07: Archivierung, Kompression & Software-Builds (LPIC-1 Fokus)

Dieses Modul deckt zentrale Themen der LPIC-1 Prüfung (LPI-101) ab, insbesondere die Lernziele 103.3 (Archivierung/Kompression) und 103.5 (Prozess-Management).

---

## 🎯 Lernziele (LPIC-1 relevant)
*   **Archivierung:** `tar`, `cpio` und `dd` sicher beherrschen.
*   **Kompression:** Algorithmen-Vergleich und die `*cat`-Werkzeuge.
*   **Build-Management:** Kompilierung von Quellcode und Umgang mit Shared Libraries (`ldd`).
*   **Signale & Prioritäten:** Vollständige Signal-Tabelle und Prozess-Hierarchien (Zombies).

---

## 📂 1. Archivierung: tar, cpio & dd

### A. Der Standard: `tar` (Tape Archiver)
LPIC verlangt das Verständnis der Flags ohne führendes Bindestrich (BSD-Stil) und mit Bindestrich (GNU-Stil).

| Flag | Langform | Beschreibung |
| :--- | :--- | :--- |
| `c` | `--create` | Neues Archiv erstellen. |
| `x` | `--extract` | Archiv entpacken. |
| `t` | `--list` | Inhalt auflisten. |
| `u` | `--update` | Nur Dateien hinzufügen, die neuer als im Archiv sind. |
| `r` | `--append` | Dateien bedingungslos anhängen. |
| `v` | `--verbose` | Fortschritt anzeigen. |
| `f` | `--file` | Dateiname (muss zwingend als letztes Flag stehen). |
| `p` | `--preserve-permissions` | Erhält die ursprünglichen Dateirechte (Standard für Root). |

**Profi-Befehle:**
```bash
# Archiv inkrementell aktualisieren
tar -uf backup.tar ./Dokumente

# Nur Dateien extrahieren, die nach einem Datum geändert wurden
tar -N '2026-05-01' -xf backup.tar
```

### B. Die Alternative: `cpio`
`cpio` liest Dateilisten von `stdin`. Häufig in Kombination mit `find`.
*   **Copy-out (Archiv erstellen):** `find . -name "*.txt" | cpio -ov > archiv.cpio`
*   **Copy-in (Entpacken):** `cpio -iv < archiv.cpio`

### C. Bit-für-Bit: `dd` (Data Duplicator)
Wird für Backups ganzer Partitionen oder zum Erstellen von ISOs genutzt.
```bash
dd if=/dev/sda of=/pfad/zu/disk.img bs=4M conv=noerror,sync
```
*   `if`/`of`: Input/Output File.
*   `bs`: Blocksize (beschleunigt den Prozess).
*   `conv=noerror`: Fährt bei Lesefehlern fort.

---

## 🗜 2. Kompression & Transparenter Zugriff

LPIC legt Wert auf die Werkzeuge, die den Inhalt komprimierter Dateien anzeigen, ohne sie permanent zu entpacken.

| Algorithmus | Tool | Decompress | View Content |
| :--- | :--- | :--- | :--- |
| **Gzip** | `gzip` | `gunzip` | `zcat`, `zless` |
| **Bzip2** | `bzip2` | `bunzip2` | `bzcat`, `bzless` |
| **XZ** | `xz` | `unxz` | `xzcat`, `xzless` |

**Beispiel für LPIC:**
"Wie lesen Sie eine `.gz`-Logdatei, ohne sie zu entpacken?"
👉 `zcat /var/log/syslog.gz | less`

---

## 🛠 3. Software-Builds & Shared Libraries

Wenn Software gebaut wird (`meson`, `make`), müssen auch die Bibliotheks-Abhängigkeiten stimmen.

### Der Build-Workflow (Modern vs. Klassisch)
1.  **Meson (Modern):** `meson setup build` -> `meson compile -C build`
2.  **Autotools (Klassisch):** `./configure` -> `make` -> `sudo make install`

### Shared Libraries prüfen (`ldd`)
Jedes Binary benötigt Bibliotheken. LPIC-Thema: "Was tun, wenn ein Programm nicht startet?"
```bash
ldd /usr/local/bin/glmark2
```
*   Zeigt alle geladenen `.so`-Dateien (Shared Objects).
*   Falls eine fehlt: "not found".

---

## 🚦 4. Prozess-Management & Signal-Referenz

### Die essenzielle Signal-Tabelle
| ID | Name | Beschreibung |
| :--- | :--- | :--- |
| **1** | `SIGHUP` | Hangup (Reload von Konfigurationsdateien). |
| **2** | `SIGINT` | Interrupt (Strg+C). |
| **9** | `SIGKILL` | Sofortiges Beenden (nicht abfangbar). |
| **15** | `SIGTERM` | Terminierung (sauberes Beenden, Standard). |
| **17** | `SIGCHLD` | Kind-Prozess beendet oder pausiert (relevant für Zombies). |
| **18** | `SIGCONT` | Pausierten Prozess fortsetzen. |
| **19** | `SIGSTOP` | Prozess pausieren (nicht abfangbar). |

### Zombies & Exit-Status
Ein Zombie entsteht, wenn der Parent das Signal `SIGCHLD` nicht korrekt verarbeitet (kein `wait()` System-Call).
*   **Exit Status:** Mit `echo $?` kann der Exit-Status des letzten Kommandos geprüft werden (0 = Erfolg).

---

## 📝 LPIC-Übungsszenarien (Day 07)

1.  **Szenario Archivierung:** Erstellen Sie ein mit `bzip2` komprimiertes Archiv des Verzeichnisses `/etc`, aber schließen Sie alle Dateien aus, die auf `.conf` enden (`--exclude`).
2.  **Szenario Filter:** Nutzen Sie `find` und `cpio`, um alle Dateien in `/home`, die dem User `student` gehören, in ein Archiv zu kopieren.
3.  **Szenario Troubleshooting:** Ein selbst kompiliertes Programm startet nicht. Nutzen Sie `ldd`, um herauszufinden, welche Bibliothek fehlt.
4.  **Szenario Signale:** Schicken Sie einem Prozess erst das Signal 19 (`SIGSTOP`) und reaktivieren Sie ihn anschließend mit Signal 18 (`SIGCONT`).

---

*Letztes Update: 12. Mai 2026*
