#!/bin/bash
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
declare -a logged_in_users=()

while true; do
  clear
  echo "==== Sistem Management Utilizatori ===="
  echo "1. Inregistrare utilizator nou"
  echo "2. Autentificare"
  echo "3. Stergere"
  echo "4. Generare raport"
  echo "5. Iesire"
  read -p "Alege o optiune: " opt

  case $opt in
    1) source "$BASE_DIR/register_user.sh"
       read -p "Apasa Enter pentru a reveni la meniu..." ;;
    2)
      if source "$BASE_DIR/login.sh"; then
        logged_in_users+=("$username")
        echo "Login reusit pentru $username."
        echo "Se deschide shell-ul in home/$username..."
        ( cd "$BASE_DIR/home/$username" && exec bash )
        echo "Ai iesit din shell-ul lui $username. Revenire la meniu."
      else
        echo "Login esuat."
      fi
      read -p "Apasa Enter pentru a reveni la meniu..." ;;
    3) source "$BASE_DIR/delete_user.sh"
       read -p "Apasa Enter pentru a reveni la meniu..." ;;
    4) source "$BASE_DIR/generate_report.sh"
       read -p "Apasa Enter pentru a reveni la meniu..." ;;
    5) exit 0 ;;
    *) echo "Optiune invalida!"
       read -p "Apasa Enter pentru a reveni la meniu..." ;;
  esac
done
