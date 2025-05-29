#!/bin/bash

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USERS_FILE="$BASE_DIR/users.csv"
HOME_BASE="$BASE_DIR/home"

read -p "Introdu numele utilizatorului de sters: " username

# Verificam existenta in users.csv
if ! grep -q "^$username," "$USERS_FILE"; then
  echo "Utilizatorul '$username' nu exista."
  exit 1
fi

# Confirmare
read -p "Esti sigur ca vrei sa stergi contul '$username'? [y/N]: " yn
case "$yn" in
  [Yy]* )
    ;;
  * )
    echo "Anulat."
    exit 0
    ;;
esac

# 1) Stergem linia din users.csv
sed -i "/^$username,/d" "$USERS_FILE"

# 2) Stergem directorul home, daca exista
if [ -d "$HOME_BASE/$username" ]; then
  rm -rf "$HOME_BASE/$username"
  echo "Director home/$username a fost sters."
else
  echo "Nu exista director home/$username."
fi

echo "Utilizatorul '$username' a fost sters din $USERS_FILE."
exit 0
