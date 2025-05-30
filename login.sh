#!/bin/bash


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_FILE="$SCRIPT_DIR/users.csv"
HOME_BASE="$SCRIPT_DIR/home"

read -p "Nume utilizator: " username
read -s -p "Parolă: " password
echo

if ! grep -q "^$username," "$USERS_FILE"; then
    echo "Utilizator inexistent!"
    exit 1
fi

hashed_pass=$(echo -n "$password" | sha256sum | awk '{print $1}')

stored_hash=$(grep "^$username," "$USERS_FILE" | cut -d',' -f3)

if [ "$hashed_pass" != "$stored_hash" ]; then
    echo "Parolă incorectă!"
    exit 1
fi


USER_HOME="$HOME_BASE/$username"
if [ ! -d "$USER_HOME" ]; then
    echo "Nu există directorul home pentru $username!"
    exit 1
fi
cd "$USER_HOME"

echo "Bine ai venit, $username!"


sed -i "/^$username,/s/[^,]*$/$(date)/" "$USERS_FILE"


echo "$username autentificat"
