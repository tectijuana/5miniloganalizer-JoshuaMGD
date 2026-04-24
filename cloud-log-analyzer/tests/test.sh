#!/bin/bash
set -e

echo "Ejecutando prueba de Variante D..."

OUTPUT=$(cat data/logs_D.txt | ./analyzer)

echo "Salida obtenida:"
echo "$OUTPUT"

if echo "$OUTPUT" | grep -q "Se detectaron 3 errores consecutivos"; then
    echo "TEST OK"
    exit 0
else
    echo "TEST FAIL"
    exit 1
fi
