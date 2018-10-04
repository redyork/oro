#FROM phpdockerio/php71-fpm:latest
FROM ubuntu:18.04

#RUN groupadd -o -g 80 www-data && useradd -r -u 80 -g 80 www-data

WORKDIR "/application"

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y software-properties-common && add-apt-repository ppa:ondrej/php

RUN apt-get update && apt-get install -y php7.1 php7.1-fpm php7.1-cli \
    php7.1-pdo php7.1-mysqlnd php7.1-curl \
    php7.1-xml php7.1-soap php7.1-gd php7.1-mbstring php7.1-zip php7.1-intl \
    php7.1-opcache php7.1-mcrypt \
    && echo 'extension=mcrypt.so' > /etc/php/7.1/cli/conf.d/20-mcrypt.ini \
    && mkdir /run/php && chown www-data: /run/php

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/bin/composer
RUN apt-get install -y git

#RUN cd /application \
#    && git clone -b 1.6 https://github.com/oroinc/orocommerce-application.git site \
#    && cd site \
#    && composer install --prefer-dist

COPY www.conf /etc/php/7.1/fpm/pool.d/www.conf

COPY docker-entrypoint.sh /usr/local/bin/

RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

#CMD ["tail", "-f", "/dev/null"]
