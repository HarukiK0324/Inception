FROM debian:bookworm

# 1. Install PHP-FPM, necessary extensions, and MariaDB client (to ping the DB)
RUN apt-get update && \
    apt-get install -y php-fpm php-mysql mariadb-client curl wget tar bash && \
    rm -rf /var/lib/apt/lists/*

# 2. Download and install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# 3. Configure PHP-FPM to listen on port 9000 instead of a Unix socket
RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

# 4. Create the directory for the PHP-FPM PID file
RUN mkdir -p /run/php

# 5. Copy the startup script (matching the required directory structure)
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 6. Expose the port PHP-FPM will listen on
EXPOSE 9000

# 7. Start via the script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]