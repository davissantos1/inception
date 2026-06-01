#!/bin/sh

mkdir -p /etc/nginx/ssl

openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=BR/ST=SP/L=São Paulo/O=42/OU=42/CN=${DOMAIN_NAME}/UID=${DOMAIN_NAME}"

exec nginx -g "daemon off;"
