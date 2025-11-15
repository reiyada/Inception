# ---------------------------------------------------------------------------- #
#                                    Setting                                   #
# ---------------------------------------------------------------------------- #
#!/usr/bin/env bash
  #->to tell the OS to run this file with the bash interpreter found via env
set -euo pipefail
  #->-e: exit immediately if any command fails
  #->-u: treat use of unset variables are an error
  #->-o pipefail: if you use pipe ( a | b ) and if any command fails, the whole pipeline fails


# ---------------------------------------------------------------------------- #
#                                 Read secrets                                 #
# ---------------------------------------------------------------------------- #
DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
DB_PASSWORD="$(cat /run/secrets/db_password)"
  #->reads passwords from Docker secrets and store them into the variables
  #->$(...): run the command and use its output

# ---------------------------------------------------------------------------- #
#                                 Required envs                                #
# ---------------------------------------------------------------------------- #
: "${MYSQL_DATABASE:?Missing MYSQL_DATABASE}"
: "${MYSQL_USER:?Missing MYSQL_USER}"
  #->if MYSQL_DATABASE or MYSQL_USER is unset/empty, the script exits with the error msg
  #->":" is the "do nothing" cmd

# ---------------------------------------------------------------------------- #
#                          Initialize datadir if empty                         #
# ---------------------------------------------------------------------------- #
  #->if the MariaDB data dir has never been initialized before...
if [ ! -d "/var/lib/mysql/mysql" ]; then
echo "[entrypoint] Initializing database..."
  install -d -o mysql -g mysql /var/lib/mysql
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null

  #Temp server to run SQL
  mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
  pid="$!"

  #Wait for socket
  for i in {30..0}; do
    mariadb-admin ping --silent && break
    sleep 1
  done

  if ! mariadb-admin ping --silent; then
    echo "MariaDB failed to start for initialization" >&2
    exit 1
  fi

  #Secure + set up DB/users
  mariadb <<SQL
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
SQL

  mariadb-admin shutdown
  wait "$pid" || true
  echo "[entrypoint] Initialization done."
fi

# ---------------------------------------------------------------------------- #
#              Exec mysqld as PID 1 (no tail -f / infinite loops)              #
# ---------------------------------------------------------------------------- #
exec mysqld --user=mysql --datadir=/var/lib/mysql
