#!/bin/bash

# Navigate to the shared volume directory
cd /var/www/html

# 1. Wait for MariaDB to be ready
# We use the mariadb-client installed in the Dockerfile to ping the database.
echo "Waiting for MariaDB to start..."
while ! mariadb -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 3
done
echo "MariaDB is up and running!"

# 2. Check if WordPress is already installed
# If wp-config.php doesn't exist, it means this is the first time the container is running.
if [ ! -f wp-config.php ]; then
    echo "Downloading and configuring WordPress..."
    
    # Download the WordPress core files into /var/www/html
    wp core download --allow-root
    
    # Create the wp-config.php file using the database environment variables
    # Note: 'mariadb' is the hostname of the database container on our Docker network
    wp config create --dbname="$MYSQL_DATABASE" \
                     --dbuser="$MYSQL_USER" \
                     --dbpass="$MYSQL_PASSWORD" \
                     --dbhost=mariadb:3306 \
                     --allow-root
    
    # Install WordPress and create the Administrator user
    wp core install --url="$DOMAIN_NAME" \
                    --title="Inception" \
                    --admin_user="$WP_ADMIN_USER" \
                    --admin_password="$WP_ADMIN_PASSWORD" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --allow-root
    
    # Create the second user (non-administrator)
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
                   --role=author \
                   --user_pass="$WP_USER_PASSWORD" \
                   --allow-root
    
    # Ensure the web server (www-data) owns the files so it can serve them
    chown -R www-data:www-data /var/www/html
    
    echo "WordPress installation complete!"
else
    echo "WordPress is already installed and configured."
fi

# 3. Start PHP-FPM in the foreground
# The -F flag forces PHP-FPM to stay in the foreground, taking over PID 1
# This perfectly satisfies the requirement to avoid 'tail -f' or infinite loops!
echo "Starting PHP-FPM..."
exec php-fpm8.2 -F