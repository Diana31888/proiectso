#!/bin/bash

read -p "Introdu numele utilizatorului: " username

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
user_dir="$SCRIPT_DIR/home/$username"
report_file="$user_dir/raport.txt"

if [ ! -d "$user_dir" ]; then
    echo "Utilizator inexistent!"
    exit 1
fi

(
    num_files=$(find "$user_dir" -mindepth 1 -type f | wc -l)
    num_dirs=$(find "$user_dir" -mindepth 1 -type d | wc -l)
    total_size=$(du -sh "$user_dir" | cut -f1)

    echo "Raport pentru $username" > "$report_file"
    echo "Numar fisiere: $num_files" >> "$report_file"
    echo "Numar directoare: $num_dirs" >> "$report_file"
    echo "Dimensiune totala: $total_size" >> "$report_file"
) &

echo "Raportul va fi generat asincron in: $report_file"
