#!/bin/bash
# Exit immediately if a command exits with a non-zero status
set -e

# Check if the database directory already exists to avoid re-initializing
# on subsequent container restarts.
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Initializing MariaDB for the first time..."

    # Initialize the MariaDB data directory
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Create a temporary SQL script to configure the database and users
    cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Run MariaDB in bootstrap mode to execute the SQL commands
    # Bootstrap mode runs the server without networking just to execute the script and exit
    mysqld --user=mysql --bootstrap < /tmp/init.sql
    
    # Clean up the temporary file
    rm -f /tmp/init.sql
    echo "Database initialization complete."
else
    echo "Database already initialized. Starting up..."
fi

# Execute MariaDB in the foreground so it becomes PID 1
# This ensures the container stays alive without using 'tail -f' or 'sleep infinity'
exec mysqld --user=mysql