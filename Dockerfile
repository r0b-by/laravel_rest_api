# Gunakan base image PHP 8.2 dengan Apache
FROM php:8.2-apache

# Install dependencies dan ekstensi PHP yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    git zip unzip curl libsqlite3-dev libonig-dev libxml2-dev libzip-dev \
    && docker-php-ext-install pdo pdo_sqlite zip mbstring xml

# Install Composer dari official composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory Laravel
WORKDIR /var/www/html

# Copy semua file proyek ke container
COPY . .

# Install dependencies Laravel via composer
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Set permission supaya web server dapat menulis storage dan cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Ubah DocumentRoot Apache ke folder public Laravel
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/apache2.conf

# Enable mod_rewrite (penting untuk routing Laravel)
RUN a2enmod rewrite

# Expose port 80 untuk HTTP
EXPOSE 80

# Jalankan Apache di foreground (proses utama container)
CMD ["apache2-foreground"]
