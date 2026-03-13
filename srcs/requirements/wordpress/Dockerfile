FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y php-fpm php-mysql php-curl php-gd php-mbstring php-xml php-zip wget tar bash && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

RUN mkdir -p /run/php

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wp.tar.gz && \
    tar -xzf /tmp/wp.tar.gz -C /usr/src/ && \
    rm /tmp/wp.tar.gz

# 4. Copy the startup script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

# 5. Start via the script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]