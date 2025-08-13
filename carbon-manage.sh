#!/bin/sh

# Detect docker compose command
if docker compose version >/dev/null 2>&1; then
    DC="docker compose"
elif docker-compose version >/dev/null 2>&1; then
    DC="docker-compose"
else
    echo "❌ Neither 'docker compose' nor 'docker-compose' is installed."
    echo "Please install the Docker Compose plugin or binary."
    exit 1
fi

while true; do
  clear
  echo "============================="
  echo "  Carbon Docker Management"
  echo "============================="
  echo "1) Start Carbon"
  echo "2) Stop Carbon"
  echo "3) Restart Carbon"
  echo "4) View logs"
  echo "5) Backup database"
  echo "6) Restore database"
  echo "7) Reset Carbon (remove containers, images, volumes, networks)"
  echo "0) Exit"
  echo "============================="
  read -p "Choose an option: " option

  case $option in
    1)
      $DC up -d
      ;;
    2)
      $DC down
      ;;
    3)
      $DC down && $DC up -d
      ;;
    4)
      $DC logs -f
      ;;
    5)
      ./backup-postgres.sh
      ;;
    6)
      ./restore-postgres.sh
      ;;
    7)
      read -p "⚠ This will delete all Carbon containers, DB volumes, and networks. Continue? (y/N): " confirm
      if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
        $DC down --volumes --remove-orphans
        docker image prune -f
        docker volume prune -f
        docker network prune -f
        echo "✅ Carbon reset complete."
        read -p "Press enter to return to menu..."
      else
        echo "❌ Reset cancelled."
        sleep 1
      fi
      ;;
    0)
      exit 0
      ;;
    *)
      echo "Invalid option."
      sleep 1
      ;;
  esac
done
