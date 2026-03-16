#!/bin/bash

cd /var/www/html

echo "Waiting for MariaDB to start..."
while ! mariadb -h mariadb -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "SELECT 1;" >/dev/null 2>&1; do
    sleep 3
done
echo "MariaDB is up and running!"

if [ ! -f wp-config.php ]; then
    echo "Downloading and configuring WordPress..."

    wp core download --allow-root

    wp config create --dbname="$MYSQL_DATABASE" \
                     --dbuser="$MYSQL_USER" \
                     --dbpass="$MYSQL_PASSWORD" \
                     --dbhost=mariadb:3306 \
                     --allow-root

    wp core install --url="$DOMAIN_NAME" \
                    --title="Inception" \
                    --admin_user="$WP_ADMIN_USER" \
                    --admin_password="$WP_ADMIN_PASSWORD" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --allow-root
    
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
                   --role=author \
                   --user_pass="$WP_USER_PASSWORD" \
                   --allow-root
    
    chown -R www-data:www-data /var/www/html
    echo "WordPress installation complete!"
else
    echo "WordPress is already installed and configured."
fi

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
