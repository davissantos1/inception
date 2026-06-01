FROM alpine:3.22

RUN apk update && apk add mariadb mariadb-client

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

COPY mariadb-server.cnf /etc/my.cnf.d/mariadb-server.cnf

COPY entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/entrypoint.sh

EXPOSE 3306

CMD ["/tmp/entrypoint.sh"]
