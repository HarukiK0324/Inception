FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/nginx.conf

COPY /conf/nginx.conf /etc/nginx/nginx.conf

# Create a directory to store the certificates
RUN mkdir -p /etc/nginx/ssl

# Generate the self-signed certificate and key
# The -subj flag pre-fills the prompt questions so the Docker build doesn't hang
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=42/OU=42/CN=hkasamat.42.fr/UID=hkasamat"

# 3. Setup Permissions/Directories (Optional)
# If you need to serve static files, copy them here:
# COPY ./html /var/www/html

# 4. Expose the port Nginx is listening on (usually 80 or 8080)
EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]