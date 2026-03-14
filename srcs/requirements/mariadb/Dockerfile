FROM debian:bookworm

# 1. Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# 2. Configure MariaDB to listen on all interfaces (not just localhost)
# We use sed to modify the bind-address in the config file
COPY ./conf/mariadb-server.conf /etc/mysql/mariadb.conf.d/mariadb-server.conf

# 3. Create the socket directory and ensure permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# 4. Expose the standard MariaDB port
EXPOSE 3306

# 5. Copy our custom startup script
COPY ./tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 6. Start via the script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]