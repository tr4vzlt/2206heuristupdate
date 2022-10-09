FROM alpine:3.14 as preparation
RUN mkdir -p /var/www/html
WORKDIR /var/www/html
RUN apk add curl
RUN curl -l https://HeuristRef.net/HEURIST/DISTRIBUTION/install_heurist.sh | sh -s h6-alpha
RUN rm -rf /var/www/html/HEURIST/heurist
RUN rm -rf /var/www/html/HEURIST/HEURIST_FILESTORE
RUN rm -rf /var/www/html/HEURIST/temp
RUN rm -rf /var/www/html/h6-alpha
RUN rm -rf /var/www/html/heurist
RUN rm -rf /var/www/html/heurist_switchboard

FROM php:7-apache
# 
RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup
# install dependancy
RUN apt update
RUN apt install -y zlib1g-dev libwebp-dev libpng-dev libjpeg-dev libxpm-dev libzip-dev libxslt-dev libbz2-dev
RUN /usr/local/bin/docker-php-ext-install pdo_mysql mysqli zip gd exif xsl bz2

USER www-data
RUN mkdir -p /var/www/html/HEURIST
RUN mkdir -p /var/www/html/HEURIST/HEURIST_FILESTORE
RUN mkdir -p /var/www/html/HEURIST/temp
WORKDIR /var/www/html
RUN ln -s /var/www/html/HEURIST/app heurist
WORKDIR /var/www/html/HEURIST/app
COPY --from=preparation /var/www/html/HEURIST/HEURIST_SUPPORT /var/www/html/HEURIST/HEURIST_SUPPORT
COPY --from=preparation /var/www/html/HEURIST/index.html /var/www/html/HEURIST/index.html
USER root
WORKDIR /var/www/html
RUN usermod -u 1000 www-data
RUN groupmod -g 1000 www-data
