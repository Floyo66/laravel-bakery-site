# ---------- FINAL PRODUCTION IMAGE ----------
FROM php:8.4-cli

# Set working directory
WORKDIR /var/www

# Install required system packages + PHP extensions
RUN apt-get update && apt-get install -y \
    git curl unzip libpq-dev libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Composer binary
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Copy Composer dependencies (already installed locally)
COPY vendor ./vendor
COPY composer.* ./

# Copy Laravel app
COPY . .

# Copy locally built frontend assets
# Make sure you've run: npm ci && npm run build locally
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
