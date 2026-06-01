#!/bin/sh

if [ ! -f "wp-config.php" ]; then
	
	DB_PASSWORD=$(cat /run/secrets/db_password)
	WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
	WP_SECOND_PASSWORD=$(cat /run/secrets/wp_common_password)

	php -d memory_limit=512M /usr/local/bin/wp core download --allow-root

	wp config create --dbname=${MYSQL_DATABASE} \
					 --dbuser=${MYSQL_USER} \
					 --dbpass=${DB_PASSWORD} \
					 --dbhost=mariadb \
					 --allow-root

	wp core install --url=${DOMAIN_NAME} \
					--title="Inception 42" \
					--admin_user=${WP_ADMIN_USER} \
					--admin_password=${WP_ADMIN_PASSWORD} \
					--admin_email=${WP_ADMIN_EMAIL} \
					 --allow-root

	wp user create ${WP_SECOND_USER} ${WP_SECOND_EMAIL} \
					--role=author \
					--user_pass=${WP_SECOND_PASSWORD} \
					 --allow-root

	wp theme install astra --activate --allow-root
fi

exec php-fpm83 -F
