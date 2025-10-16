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

# Buat file SQLite jika belum ada
RUN touch database/database.sqlite \
    && chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache /var/www/html/database

# Expose port 80 untuk HTTP
EXPOSE 80

# Jalankan migrasi dan seeder sebelum start Apache
CMD php artisan migrate --force && php artisan db:seed --class=UserSeeder --force && apache2-foreground
