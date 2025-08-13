#!/bin/sh
set -e

host="$1"
shift
until nc -z "$host" 5432; do
  echo "⏳ Waiting for $host database..."
  sleep 2
done

exec "$@"
