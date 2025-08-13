#!/bin/sh
set -e

BACKUP_DIR=/backups
DATE=$(date +'%Y-%m-%d_%H-%M-%S')
FILENAME=carbon-db-$DATE.sql.gz

echo "📦 Creating compressed backup: $FILENAME"
pg_dump -U "$POSTGRES_USER" "$POSTGRES_DB" | gzip > "$BACKUP_DIR/$FILENAME"

# Keep only last 7 backups
echo "🧹 Cleaning old backups, keeping latest 7..."
ls -tp "$BACKUP_DIR"/*.gz | grep -v '/$' | tail -n +8 | xargs -I {} rm -- {}
