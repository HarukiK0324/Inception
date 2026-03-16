FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN rm -rf /var/www/html/* && rm /etc/nginx/nginx.conf

COPY /conf/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=JP/ST=Tokyo/L=Shinjuku/O=42/OU=42/CN=hkasamat.42.fr/UID=hkasamat"

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]