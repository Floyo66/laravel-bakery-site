# ---------- Frontend build (Vite + Tailwind) ----------
FROM node:18 AS frontend
WORKDIR /app

# Install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy source and build production assets
COPY . .
RUN npm run build

# ---------- Backend (Laravel) ----------
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

WORKDIR /var/www

# Copy PHP dependencies and install
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy Laravel source
COPY . .

# Copy pre-built frontend assets from frontend stage
COPY --from=frontend /app/public/build ./public/build

# Build-time check: fail if assets missing
RUN ls -l public/build && cat public/build/manifest.json

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache

# Clear cached configs
RUN php artisan optimize:clear || true

# Serve Laravel on Render dynamic port
CMD php artisan serve --host=0.0.0.0 --port=$PORT
