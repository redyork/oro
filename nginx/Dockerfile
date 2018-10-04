#FROM phpdockerio/php71-fpm:latest
FROM ubuntu:18.04

#RUN groupadd -o -g 80 www-data && useradd -r -u 80 -g 80 www-data

WORKDIR "/application"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y nginx

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

#CMD ["tail", "-f", "/dev/null"]
#CMD ["deploy"]