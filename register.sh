#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_FILE="$SCRIPT_DIR/users.csv"
HOME_BASE="$SCRIPT_DIR/home"

read -p "Introdu numele de utilizator: " username

# Verificare existenta utilizator
if grep -q "^$username," "$USERS_FILE"; then
    echo "Utilizatorul deja exista!"
    return
fi

read -p "Introdu adresa de email: " email
while ! [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; do
    read -p "Email invalid. Reintrodu: " email
done

read -s -p "Introdu parola: " password
echo
if [ -z "$password" ]; then
    echo "Parola nu poate fi goala!"
    return
fi

hashed_pass=$(echo -n "$password" | sha256sum | awk '{print $1}')
id=$(uuidgen)
mkdir -p "$HOME_BASE/$username"

echo "$username,$email,$hashed_pass,$id,NEVER" >> "$USERS_FILE"

echo "Contul a fost creat cu succes!"

# Simulare trimitere email
(
    echo "To: $email"
    echo "From: proiect.so78@gmail.com"
    echo "Subject: Cont creat cu succes"
    echo ""
    echo "Salut $username,"
    echo "Contul tau a fost creat cu succes pe sistemul Facultate1!"
    echo "Te-ai conectat din directorul: $(pwd)"
) | sendmail "$email" 2>/dev/null || echo "[Simulare] Emailul nu a putut fi trimis (sendmail inexistent)"
