#!/bin/sh

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_SECOND_PASSWORD=$(cat /run/secrets/wp_common_password)

cd /var/www/wordpress

while ! mariadb -h mariadb -u "${MYSQL_USER}" -p"${DB_PASSWORD}" "${MYSQL_DATABASE}"; do
	sleep 1
done

if [ ! -f "wp-config.php" ]; then
	php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

	wp config create --dbname=${MYSQL_DATABASE} \
					 --dbuser=${MYSQL_USER} \
					 --dbpass=${DB_PASSWORD} \
					 --dbhost=mariadb \
					 --allow-root

	wp core install --url=https://${DOMAIN_NAME} \
					--title="Inception 42" \
					--admin_user=${WP_ADMIN_USER} \
					--admin_password=${WP_ADMIN_PASSWORD} \
					--admin_email=${WP_ADMIN_EMAIL} \
					 --allow-root

	wp user create ${WP_SECOND_USER} ${WP_SECOND_EMAIL} \
					--role=author \
					--user_pass=${WP_SECOND_PASSWORD} \
					 --allow-root
fi

chmod -R 755 /var/www/wordpress
chown -R nobody:nobody /var/www/wordpress

exec php-fpm83 -F
