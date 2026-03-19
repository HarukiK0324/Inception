#!/bin/bash

cd /var/www/html

DB_PASS=$(cat /run/secrets/db_password)
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password)
WP_USER_PASS=$(cat /run/secrets/wp_user_password)

echo "Waiting for MariaDB to start..."
while ! mariadb -h mariadb -u "$MYSQL_USER" -p"$DB_PASS" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 3
done
echo "MariaDB is up and running!"

if [ ! -f wp-config.php ]; then
    echo "Downloading and configuring WordPress..."

    wp core download --allow-root

    wp config create --dbname="$MYSQL_DATABASE" \
                     --dbuser="$MYSQL_USER" \
                     --dbpass="$DB_PASS" \
                     --dbhost=mariadb:3306 \
                     --allow-root

    wp core install --url="$DOMAIN_NAME" \
                    --title="Inception" \
                    --admin_user="$WP_ADMIN_USER" \
                    --admin_password="$WP_ADMIN_PASS" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --allow-root
    
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
                   --role=author \
                   --user_pass="$WP_USER_PASS" \
                   --allow-root
    
    chown -R www-data:www-data /var/www/html
    echo "WordPress installation complete!"
else
    echo "WordPress is already installed and configured."
fi

echo "Starting PHP-FPM..."
mkdir -p /run/php
exec php-fpm8.2 -F
