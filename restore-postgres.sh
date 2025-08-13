#!/bin/sh
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <backup_file.sql.gz>"
  exit 1
fi

BACKUP_FILE="$1"

if [ ! -f "$BACKUP_FILE" ]; then
  echo "❌ Backup file $BACKUP_FILE not found!"
  exit 1
fi

echo "🛑 Stopping Carbon container to avoid DB writes..."
docker compose stop carbon

echo "📥 Restoring $BACKUP_FILE..."
gunzip -c "$BACKUP_FILE" | docker compose exec -T postgres psql -U carbon carbon

echo "✅ Restore complete."
echo "🚀 Restarting Carbon..."
docker compose start carbon
