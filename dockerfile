# ---------- BASE IMAGE ----------
FROM php:8.4-cli

# Set working directory
WORKDIR /var/www

# Install required system packages + PHP extensions
RUN apt-get update && apt-get install -y \
    git curl unzip libpq-dev libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Copy only Composer files for caching
COPY composer.json composer.lock ./
# Copy Laravel app
COPY . .
# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist



# Copy pre-built frontend assets
# Make sure you have committed public/build to Git, or generated it locally before Docker build
COPY public/build ./public/build

# Ensure permissions
RUN mkdir -p storage/framework/{views,cache,sessions} storage/logs bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache public/build

# Precompile Laravel caches
RUN php artisan config:cache || true \
    && php artisan route:cache || true \
    && php artisan view:cache || true

# Serve app
CMD ["sh", "-c", "php -S 0.0.0.0:${PORT:-80} -t public"]
