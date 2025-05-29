#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_FILE="$SCRIPT_DIR/users.csv"
HOME_BASE="$SCRIPT_DIR/home"

read -p "Nume utilizator: " username
read -s -p "Parola: " password
echo

# Verificare existenta in users.csv
if ! grep -q "^$username," "$USERS_FILE"; then
    echo "Utilizator inexistent!"
    exit 1
fi

hashed_pass=$(echo -n "$password" | sha256sum | awk '{print $1}')

user_line=$(grep "^$username," "$USERS_FILE")
stored_hash=$(echo "$user_line" | cut -d',' -f3)

if [[ "$hashed_pass" == "$stored_hash" ]]; then
    uuid=$(echo "$user_line" | cut -d',' -f4)
    current_time=$(date +"%Y-%m-%d %H:%M:%S")
    sed -i "s|^$username,\([^,]*\),\([^,]*\),$uuid,[^,]*|$username,\1,\2,$uuid,$current_time|" "$USERS_FILE"
    export username
    exit 0
else
    echo "Parola gresita!"
    exit 1
fi
