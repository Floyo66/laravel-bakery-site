# ---------- FRONTEND BUILD (Vite + Tailwind) ----------
FROM node:18 AS frontend
WORKDIR /app

# Install dependencies
COPY package*.json ./
RUN npm ci

# Set production environment for Vite
ENV NODE_ENV=production

# Copy all frontend source files
COPY . .

# Build assets
RUN npm run build \
    && ls -la public/build  # confirm manifest.json + assets exist

# ---------- COMPOSER DEPENDENCIES ----------
FROM composer:2 AS composer-deps
WORKDIR /app

COPY composer*.json ./
RUN composer install \
    --no-dev \
    --optimize-autoloader \
    --no-scripts \
    --no-interaction \
    --prefer-dist

# ---------- FINAL PRODUCTION IMAGE ----------
FROM php:8.4-cli

RUN apt-get update && apt-get install -y \
    git curl unzip libpq-dev libonig-dev libzip-dev zip \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www

# Copy Composer dependencies
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=composer-deps /app/composer.* ./

# Copy Laravel app
COPY . .

# Copy built frontend assets
COPY --from=frontend --chown=www-data:www-data /app/public/build ./public/build

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
