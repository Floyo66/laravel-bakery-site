# ---------- FRONTEND BUILD (Vite + Tailwind) ----------
FROM node:18 AS frontend
WORKDIR /app

# Install dependencies only when package.json changes
COPY package*.json ./
RUN npm ci

# Copy frontend source and build
COPY . .
RUN npm run build \
    && ls -la public/build  # debug: confirm manifest.json + assets exist

# ---------- COMPOSER DEPENDENCIES STAGE ----------
FROM composer:2 AS composer-deps
WORKDIR /app

# Copy composer files first to leverage cache
COPY composer*.json ./
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-scripts \
    --no-interaction \
    --prefer-dist

# ---------- FINAL PRODUCTION IMAGE ----------
FROM php:8.4-cli

# Install required system packages + PHP extensions
RUN apt-get update && apt-get install -y \
    git curl unzip libpq-dev libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Composer binary
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer dependencies
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=composer-deps /app/composer.* ./

# Copy Laravel application
COPY . .

# Copy built frontend assets
COPY --from=frontend --chown=www-data:www-data /app/public/build ./public/build

# Ensure required directories exist with correct permissions
RUN mkdir -p storage/framework/{views,cache,sessions} storage/logs bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache public/build

# Optimize Laravel caches (ignore errors if env not set)
RUN php artisan config:cache || true \
    && php artisan route:cache || true \
    && php artisan view:cache || true

# Start built-in PHP server with $PORT expanded
CMD ["sh", "-c", "php -S 0.0.0.0:${PORT:-80} -t public"]
