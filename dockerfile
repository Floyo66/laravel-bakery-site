# ---------- Frontend build (Vite) ----------
FROM node:18 AS frontend
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# ---------- Backend (Laravel) ----------
FROM php:8.2-cli

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

WORKDIR /var/www

# Install PHP dependencies (disable scripts for build safety)
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy application source
COPY . .

# Copy built frontend assets
COPY --from=frontend /app/public/build ./public/build

# Laravel permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Start Laravel on Render's assigned port
CMD php artisan serve --host=0.0.0.0 --port=$PORT
