FROM php:7.4-apache

ARG PIWIGO_RELEASE=2.10.2

# PHP config
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    sed -i "s/max_execution_time = 30/max_execution_time = 300/" "$PHP_INI_DIR/php.ini" && \
    sed -i "s/memory_limit = 128M/memory_limit = 512M/" "$PHP_INI_DIR/php.ini" && \
    sed -i "s/max_input_time = 60/max_input_time = 180/" "$PHP_INI_DIR/php.ini" && \
    sed -i "s/post_max_size = 8M/post_max_size = 100M/" "$PHP_INI_DIR/php.ini" && \
    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 100M/" "$PHP_INI_DIR/php.ini" && \
    sed -i "s/expose_php = On/expose_php = Off/" "$PHP_INI_DIR/php.ini"

ADD sources.list /etc/apt/sources.list

# Install external dependencies
RUN set ex && \
    \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        dcraw \
        mediainfo \
        ffmpeg \
        imagemagick \
        libimage-exiftool-perl \
        libmagickwand-dev \
        unzip \
# GD deps
        zlib1g-dev \
        libpng-dev \
# jpegtran
        libjpeg-turbo-progs \
# pdftoppm
        poppler-utils \
        libfcgi-bin \
        exiftool && \
    rm -rf /var/lib/apt/lists/*

# Extra PHP extensions
RUN set ex && \
    docker-php-ext-install exif && \
    docker-php-ext-enable exif && \
    \
    docker-php-ext-install mysqli && \
    docker-php-ext-enable mysqli && \
    \
    docker-php-ext-install gd && \
    docker-php-ext-enable gd && \
    \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Apache config
ENV APACHE_DOCUMENT_ROOT /var/www

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN sed -ri -e 's!Listen 80!Listen 8080!g' /etc/apache2/ports.conf && \
    sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf && \
    sed -ri -e 's!ServerSignature On!ServerSignature Off!g' /etc/apache2/conf-available/*.conf && \
    sed -ri -e 's!ServerTokens OS!ServerTokens Prod!g' /etc/apache2/conf-available/*.conf && \
    rm -rf ${APACHE_DOCUMENT_ROOT}/html && \
    a2enmod rewrite && \
    chmod -R 0755 /etc/apache2

# Get and extract piwigo
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/piwigo.zip \
       "http://piwigo.org/download/dlcounter.php?code=${PIWIGO_RELEASE}" && \
    unzip ${APACHE_DOCUMENT_ROOT}/piwigo.zip -d ${APACHE_DOCUMENT_ROOT} && \
    mv ${APACHE_DOCUMENT_ROOT}/piwigo/* ${APACHE_DOCUMENT_ROOT} && \
    rm -f ${APACHE_DOCUMENT_ROOT}/piwigo.zip && \
    rm -rf ${APACHE_DOCUMENT_ROOT}/piwigo

# Add extensions
# --------------

# VideoJs 2.9b
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip \
        https://codeload.github.com/Piwigo/piwigo-videojs/zip/refs/heads/master &&\
    unzip ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip -d ${APACHE_DOCUMENT_ROOT}/plugins && \
    rm ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip &&\
    mv ${APACHE_DOCUMENT_ROOT}/plugins/piwigo-videojs-master/  ${APACHE_DOCUMENT_ROOT}/plugins/piwigo-videojs/

# GThumb+ 2.8.a
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip \
         https://piwigo.org/ext/download.php?rid=5589 && \
    unzip ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip -d ${APACHE_DOCUMENT_ROOT}/plugins && \
    rm -f ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip

# RV Thumbnail Scroller 2.7.a
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip \
         https://piwigo.org/ext/download.php?rid=5086 && \
    unzip ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip -d ${APACHE_DOCUMENT_ROOT}/plugins && \
    rm -f ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip

# Share Album 1.4
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip \
         https://piwigo.org/ext/download.php?rid=7153 && \
    unzip ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip -d ${APACHE_DOCUMENT_ROOT}/plugins && \
    rm -f ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip

# EXIF View 2.9.a
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip \
         https://piwigo.org/ext/download.php?rid=6454 && \
    unzip ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip -d ${APACHE_DOCUMENT_ROOT}/plugins && \
    rm -f ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip

# piwigo-openstreetmap 2.9a
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip \
         https://piwigo.org/ext/download.php?rid=6721 && \
    unzip ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip -d ${APACHE_DOCUMENT_ROOT}/plugins && \
    rm -f ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip

# Social Connect 2.2.5
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip \
         https://piwigo.org/ext/download.php?rid=6132 && \
    unzip ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip -d ${APACHE_DOCUMENT_ROOT}/plugins && \
    rm -f ${APACHE_DOCUMENT_ROOT}/plugins/plugin.zip && \
# Patch the Google provider, it's outdated and not working in the included version
    curl \
      -o ${APACHE_DOCUMENT_ROOT}/plugins/oAuth/include/hybridauth/Hybrid/Providers/Google.php -L \
      https://raw.githubusercontent.com/hybridauth/hybridauth/06909cd8cbc1201f01db8a8d36bc8c06dd27223d/hybridauth/Hybrid/Providers/Google.php


# Bootstrap Darkroom 2.4.4
RUN set ex && \
    curl -L -o ${APACHE_DOCUMENT_ROOT}/themes/theme.zip \
         https://piwigo.org/ext/download.php?rid=7015 && \
    unzip ${APACHE_DOCUMENT_ROOT}/themes/theme.zip -d ${APACHE_DOCUMENT_ROOT}/themes && \
    rm -f ${APACHE_DOCUMENT_ROOT}/themes/theme.zip

# Override some default configs not stored in the DB
# --------------------------------------------------
# Piwigo
ADD config.inc.php ${APACHE_DOCUMENT_ROOT}/local/config/config.inc.php
# GThumb+
ADD GThumb_config_default.inc.php ${APACHE_DOCUMENT_ROOT}/plugins/GThumb/config_default.inc.php
# Bootstrap theme
RUN sed -ri -e "s!PAGE_HEADER => 'jumbotron'!PAGE_HEADER => 'none'!g" ${APACHE_DOCUMENT_ROOT}/themes/bootstrap_darkroom/include/config.php && \
    sed -ri -e "s!CAT_NB_IMAGES => true!CAT_NB_IMAGES => false!g" ${APACHE_DOCUMENT_ROOT}/themes/bootstrap_darkroom/include/config.php && \
    sed -ri -e "s!THUMBNAIL_LINKTO => 'picture'!THUMBNAIL_LINKTO => 'photoswipe'!g" ${APACHE_DOCUMENT_ROOT}/themes/bootstrap_darkroom/include/config.php && \
    sed -ri -e "s!THUMBNAIL_CAPTION => true!THUMBNAIL_CAPTION => false!g" ${APACHE_DOCUMENT_ROOT}/themes/bootstrap_darkroom/include/config.php && \
    sed -ri -e "s!SOCIAL_ENABLED => true!SOCIAL_ENABLED => false!g" ${APACHE_DOCUMENT_ROOT}/themes/bootstrap_darkroom/include/config.php

# Lock down theme and plugin dirs to prevent modification
RUN chmod -R 755 ${APACHE_DOCUMENT_ROOT}/plugins && \
    chmod -R 755 ${APACHE_DOCUMENT_ROOT}/themes

VOLUME ["${APACHE_DOCUMENT_ROOT}/_data", "${APACHE_DOCUMENT_ROOT}/local", "${APACHE_DOCUMENT_ROOT}/galleries", "${APACHE_DOCUMENT_ROOT}/upload"]

WORKDIR ${APACHE_DOCUMENT_ROOT}

EXPOSE 8080