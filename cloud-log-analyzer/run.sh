#!/bin/bash
set -e

if [ ! -f ./analyzer ]; then
    echo "No existe ./analyzer. Compilando primero..."
    make
fi

cat data/logs_D.txt | ./analyzer
