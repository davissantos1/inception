#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql > /dev/null

	DB_PASSWORD=$(cat /run/secrets/db_password)	
	ROOT_PASSWORD=$(cat /run/secrets/db_root_password)	

	cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

	/usr/bin/mariadbd --user=mysql --bootstrap < /tmp/init.sql

	rm /tmp/init.sql	
fi

exec /usr/bin/mariadbd --user=mysql --console
