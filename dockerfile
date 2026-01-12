# ---------- FRONTEND BUILD (Vite + Tailwind) ----------
FROM node:18 AS frontend
WORKDIR /app

# Install frontend dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy source and build production assets
COPY . .
RUN npm run build

# ---------- BACKEND (Laravel) ----------
FROM php:8.2-cli

# Install PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    zip \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer files and install PHP dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy Laravel source
COPY . .

# Ensure storage/cache dirs exist and are fully writable
RUN mkdir -p storage/framework/views storage/framework/cache storage/logs \
    && chmod -R 777 storage bootstrap/cache

# Cache configs, routes, views
RUN php artisan config:cache || true
RUN php artisan route:cache || true
RUN php artisan view:cache || true

# Copy built frontend assets from frontend stage
COPY --from=frontend /app/public/build ./public/build

# Run database migrations during build
# This ensures tables exist before Laravel tries to serve requests
RUN php artisan migrate --force || true

# Serve Laravel with built-in PHP server on Render free tier
CMD php -S 0.0.0.0:$PORT -t public
