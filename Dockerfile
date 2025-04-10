FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    curl zip unzip git gnupg libpng-dev libonig-dev libxml2-dev \
    libzip-dev libjpeg-dev libfreetype6-dev gnupg ca-certificates \
    && docker-php-ext-configure gd \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && php -v && composer -V && node -v && npm -v \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

CMD ["php-fpm"]
