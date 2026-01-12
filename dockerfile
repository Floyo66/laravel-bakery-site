# ---------- FRONTEND BUILD (Vite + Tailwind) ----------
FROM node:18 AS frontend
WORKDIR /app

# Install dependencies
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

# Copy PHP dependencies and install
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy Laravel source
COPY . .

# Ensure storage and cache directories exist and are writable
RUN mkdir -p storage/framework/views storage/framework/cache storage/logs \
    && chown -R www-data:www-data storage bootstrap/cache

# Cache Laravel configs, routes, and views for production
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Copy frontend build from the frontend stage
COPY --from=frontend /app/public/build ./public/build

# Final permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Serve Laravel using built-in PHP server on Render's dynamic port
CMD php -S 0.0.0.0:$PORT -t public
