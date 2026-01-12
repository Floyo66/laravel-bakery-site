# ---------- FRONTEND BUILD (Vite + Tailwind) ----------
FROM node:18 AS frontend
WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build \
    && ls -la public/build  # debug: confirm manifest.json + assets exist

# ---------- COMPOSER DEPENDENCIES STAGE ----------
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
FROM php:8.2-cli

# Install required system packages + PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy Composer binary from official Composer image
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /var/www

# Copy Composer dependencies first (leverages Docker cache)
COPY --from=composer-deps /app/vendor ./vendor
COPY --from=composer-deps /app/composer.* ./

# Copy the rest of the application
COPY . .

# Copy built frontend assets (with correct ownership)
COPY --from=frontend --chown=www-data:www-data /app/public/build ./public/build

# Ensure directories exist + permissions (Render runs as non-root often)
RUN mkdir -p storage/framework/{views,cache,sessions} \
    storage/logs bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache public/build

# Optimize Laravel (ignore failures in build if env not set)
RUN php artisan config:cache || true \
    && php artisan route:cache || true \
    && php artisan view:cache || true

# Optional: Run migrations during build if DB is available (or do it on start)
# RUN php artisan migrate --force || true

# Serve with built-in PHP server (Render free tier compatible)
CMD ["php", "-S", "0.0.0.0:${PORT:-80}", "-t", "public"]
