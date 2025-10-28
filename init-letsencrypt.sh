#!/bin/bash

DOMAINS="tamago.web.id,www.tamago.web.id"
EMAIL="ahmadrizqip10@gmail.com"  # Ganti dengan email Anda
STAGING=0  # Set 1 untuk testing, 0 untuk production

if [ $STAGING -eq 1 ]; then
    CERTBOT_OPTIONS="--staging"
else
    CERTBOT_OPTIONS=""
fi

# Buat direktori yang diperlukan
mkdir -p certbot/conf certbot/www

# Hentikan services yang menggunakan port 80/443
docker-compose stop nginx

# Dapatkan certificate
docker-compose run --rm certbot certonly $CERTBOT_OPTIONS \
    --webroot \
    --webroot-path /var/www/certbot \
    --email $EMAIL \
    --agree-tos \
    --no-eff-email \
    -d $DOMAINS

# Start services kembali
docker-compose up -d nginx