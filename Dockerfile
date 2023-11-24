FROM php:8.1-apache

RUN apt-get update -y && apt-get install -y \
    openssl \
    zip \
    unzip \
    git \
    vim \
    curl \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

#copy application
WORKDIR /var/www/html
COPY . /var/www/html

RUN cp .env.example .env

#apache configs + document root
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

#mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

#start with base php config
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN echo "memory_limit=1024M" >> "$PHP_INI_DIR/php.ini"
RUN echo "upload_max_filesize=64M" >> "$PHP_INI_DIR/php.ini"
RUN echo "post_max_size=64M" >> "$PHP_INI_DIR/php.ini"
RUN echo "max_execution_time=600" >> "$PHP_INI_DIR/php.ini"

#then add extensions
RUN docker-php-ext-install \
    bcmath \
    mbstring \
    pdo_mysql \
    gd \
    exif \
    zip

#composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#set user
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

RUN service apache2 restart

ENTRYPOINT ["/laravel-install.sh"]