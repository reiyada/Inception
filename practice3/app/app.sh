#!/bin/bash
echo "🚀 App container started"
echo "Waiting for MariaDB to start..."

# Wait for DB readiness
sleep 3
for i in {1..30}; do
  if mariadb-admin ping -hdb --silent &>/dev/null; then
    echo "✅ MariaDB is ready!"
    break
  fi
  echo "⏳ Waiting for MariaDB ($i/30)..."
  sleep 1
done

# Try connecting and running SQL
echo "📚 Creating a test database and table..."
mysql -hdb -uroot -proot < /init.sql

echo "🔍 Showing databases..."
mysql -hdb -uroot -proot -e "SHOW DATABASES;"


