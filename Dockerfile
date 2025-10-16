FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git zip unzip curl libsqlite3-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo pdo_sqlite zip mbstring xml

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-interaction --prefer-dist --optimize-autoloader

RUN touch database/database.sqlite

# Set permission
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# Set Apache DocumentRoot ke public
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# Enable mod_rewrite (penting untuk Laravel routing)
RUN a2enmod rewrite

EXPOSE 80

CMD php artisan migrate --force && php artisan db:seed --class=UserSeeder --force && apache2-foreground
