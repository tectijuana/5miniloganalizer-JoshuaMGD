#!/bin/bash
set -e

if [ ! -f ./analyzer ]; then
    echo "No existe ./analyzer. Compilando primero..."
    make
fi

LOG_FILE="data/logs_D.txt"

cat "$LOG_FILE" | ./analyzer

echo "Errores consecutivos encontrados:"

awk '
{
    count = 0
    for (i = 1; i <= NF; i++) {
        if ($i >= 400 && $i <= 599) {
            count++
            errores[count] = $i

            if (count == 3) {
                print errores[1], errores[2], errores[3]
                exit
            }
        } else {
            count = 0
            delete errores
        }
    }
}
' "$LOG_FILE"
