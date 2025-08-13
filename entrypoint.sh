#!/bin/sh
set -e

# If repo exists, pull latest, else clone
if [ -d "/app/.git" ]; then
    echo "🔄 Pulling latest Carbon code..."
    git -C /app pull
else
    echo "📥 Cloning Carbon repository..."
    git clone https://github.com/crbnos/carbon.git /app
fi

cd /app

# Install & build
echo "📦 Installing dependencies..."
npm install

echo "⚙️ Building Carbon..."
npm run build

echo "🚀 Starting Carbon..."
exec npm start
