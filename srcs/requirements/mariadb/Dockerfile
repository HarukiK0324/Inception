FROM debian:bookworm

# 1. Install MariaDB
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

# 2. Configure MariaDB to listen on all interfaces (not just localhost)
# We use sed to modify the bind-address in the config file
RUN sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# 3. Create the socket directory and ensure permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

# 4. Expose the standard MariaDB port
EXPOSE 3306

# 5. Copy our custom startup script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 6. Start via the script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]