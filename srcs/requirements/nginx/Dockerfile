FROM alpine:3.22

RUN mkdir -p /run/nginx

RUN apk update && apk add openssl nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/entrypoint.sh

EXPOSE 443

CMD ["/tmp/entrypoint.sh"]
