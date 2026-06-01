FROM alpine:3.22

RUN apk update && apk add php83 php83-fpm php83-mysqli php83-phar php83-mbstring php83-json curl mariadb-client

RUN mkdir -p /var/www/wordpress

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY www.conf /etc/php83/php-fpm.d/www.conf
COPY entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/entrypoint.sh

WORKDIR /var/www/wordpress

EXPOSE 9000

CMD ["/tmp/entrypoint.sh"]
